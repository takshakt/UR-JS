# Fix Date Parser for "DY, DD/MM/YYYY" Format

> **NOTE**: This document contains a comprehensive long-term solution.
> **FOR GO-LIVE**: Scroll down to "TEMPORARY WORKAROUND SOLUTION" for a minimal-risk fix.

# Fix Date Parser for "DY, DD/MM/YYYY" Format

## Problem Summary
The date parser fails to recognize dates in the format "Mon, 03/11/2025" (day-name, numeric date with slashes), resulting in NULL values and the error:
```
Column 'COLUMN_COL': Expected date value, got 'Mon, 03/11/2025' - value will be set to NULL
```

The column IS correctly identified as a DATE type, and the date parser IS being called, but it returns NULL because it cannot parse the value.

## Root Cause Analysis

**Two-Stage Failure:**

### Stage 1: Format Detection Failure (Template Creation Phase)
**Location**: [UR_UTILS.sql:4776-4815](UR_UTILS.sql#L4776-L4815) - `detect_format_internal` procedure

The format `DY, DD/MM/YYYY` is registered (line 4436) but has **no regex pattern** for detection:
- Lines 4778-4807 have hardcoded regex patterns for 6 DY formats with month names (e.g., "DY DD-MON")
- `DY, DD/MM/YYYY` (numeric format) falls through to the ELSE clause at line 4808
- The ELSE clause tries `fn_try_date(preprocess_dy_sample(rec.val), 'DY, DD/MM/YYYY')`
- Oracle's `TO_DATE` with DY format element **does not work reliably** with numeric dates
- Result: Format gets 0 matches during sampling, not selected as detected format

### Stage 2: Parsing Failure (Data Load Phase)
**Location**: [UR_UTILS.sql:5049-5066](UR_UTILS.sql#L5049-L5066) - `parse_date_internal` function

Even if the format mask is explicitly provided:
- Line 5051 checks: Is this a DY format **without year**? → NO (has YYYY)
- Falls through to standard parsing at line 5068-5074
- Calls `fn_try_date(v_preprocessed, 'DY, DD/MM/YYYY')`
- Oracle's `TO_DATE` fails again for the same reason
- Result: Returns NULL

**Why Oracle's TO_DATE Fails with DY + Numeric Dates:**
- DY format element requires exact day name matching
- Oracle cannot validate day names without parsing the full date first
- Mixed separators (comma + slash) compound the issue
- This is a known Oracle limitation

## Solution Approach
**Two-Part Fix**: Add regex pattern for detection AND fix parsing logic to strip day names before parsing numeric dates.

This mirrors the approach from commit 59c84ef but extends it to numeric date formats.

## Implementation Plan

### Part 1: Fix Format Detection (Detection Phase)

**File**: [UR_UTILS.sql](UR_UTILS.sql)
**Location**: Line ~4807, in the `detect_format_internal` procedure
**Goal**: Allow the format to be detected during template creation sampling

**Add ELSIF block** after line 4807 (after the last DY format pattern):

```sql
ELSIF v_formats(i).format_mask = 'DY, DD/MM/YYYY' THEN
    -- Pattern: day-name comma space digits slash digits slash 4-digit-year
    -- Examples: "Mon, 03/11/2025", "Tue, 1/5/2025", "WED, 12/31/2025"
    IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s*,\s*\d{1,2}\s*/\s*\d{1,2}\s*/\s*\d{4}\s*$', 'i') THEN
        v_match_count := v_match_count + 1;
    END IF;
```

**Pattern Details**:
- `^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)` - Matches 3-letter day names
- `\s*,\s*` - Comma with optional whitespace before/after
- `\d{1,2}\s*/\s*\d{1,2}\s*/\s*\d{4}` - Day/Month/Year with flexible whitespace
- `$` - End of string
- `'i'` flag - Case-insensitive matching

### Part 2: Fix Parsing Logic (Parsing Phase)

**File**: [UR_UTILS.sql](UR_UTILS.sql)
**Location**: Lines 5049-5066, in the `parse_date_internal` function
**Goal**: Strip day name before parsing, since Oracle TO_DATE can't handle DY with numeric dates

**Expand the DY special handling** at line 5051 to include formats WITH year:

**Current code (line 5051)**:
```sql
IF (p_format LIKE '%DY%' OR p_format LIKE '%DAY%') AND p_format NOT LIKE '%YYYY%' AND p_format NOT LIKE '%RR%' THEN
```

**Change to**:
```sql
IF (p_format LIKE '%DY%' OR p_format LIKE '%DAY%') THEN
```

**Then update the logic inside** (lines 5052-5065):

```sql
-- DY/DAY format - need special handling since Oracle TO_DATE is unreliable with day names
append_debug('DY/DAY format detected');

-- Strip day name first and get the underlying numeric format
v_stripped := strip_day_name(p_date_str);
append_debug('After stripping day name: "' || v_stripped || '"');

-- Determine the numeric format (remove DY/DAY from format mask)
v_numeric_format := REPLACE(REPLACE(REPLACE(p_format, 'DY, ', ''), 'DY ', ''), 'DAY, ', '');
v_numeric_format := REPLACE(REPLACE(v_numeric_format, ', ', ''), '  ', ' ');
append_debug('Numeric format: "' || v_numeric_format || '"');

-- Parse with numeric format
v_preprocessed := preprocess_date_sample(v_stripped);
v_date := fn_try_date(v_preprocessed, v_numeric_format);

IF v_date IS NOT NULL THEN
    p_result_date := v_date;
    p_message := 'Parsed (day name stripped) to ' || TO_CHAR(v_date, 'YYYY-MM-DD');
    append_debug('DY parse successful: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));
ELSE
    -- If numeric format doesn't have year, try year inference
    IF v_numeric_format NOT LIKE '%YYYY%' AND v_numeric_format NOT LIKE '%RR%' AND p_start IS NOT NULL THEN
        v_date := fn_infer_year(v_stripped, p_start, v_numeric_format);
        IF v_date IS NOT NULL THEN
            p_result_date := v_date;
            p_message := 'Parsed with day name validation to ' || TO_CHAR(v_date, 'YYYY-MM-DD');
            append_debug('DY parse with year inference: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));
        ELSE
            p_result_date := NULL;
            p_status := 'E';
            p_message := 'Failed to parse DY format';
            append_debug('DY parse failed');
        END IF;
    ELSE
        p_result_date := NULL;
        p_status := 'E';
        p_message := 'Failed to parse DY format with format ' || p_format;
        append_debug('DY parse failed');
    END IF;
END IF;
RETURN;
```

**What this does**:
1. Detects ANY format with DY or DAY (not just formats without year)
2. Strips the day name prefix (e.g., "Mon, 03/11/2025" → "03/11/2025")
3. Converts format mask (e.g., "DY, DD/MM/YYYY" → "DD/MM/YYYY")
4. Parses using the numeric format
5. Falls back to year inference if needed

### Part 3: Register Additional DY Numeric Format Variants

**File**: [UR_UTILS.sql](UR_UTILS.sql)
**Location**: Around line 4436-4448 (in the format registration section, Category 2: Day name formats)

**Add format registrations** after line 4436 (`add_format('DY, DD/MM/YYYY', ...)`):

```sql
add_format('DY DD/MM/YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');      -- Without comma
add_format('DY, MM/DD/YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');     -- US format with comma
add_format('DY MM/DD/YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');      -- US format without comma
add_format('DY, DD-MM-YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');     -- Hyphen separator with comma
add_format('DY DD-MM-YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');      -- Hyphen separator without comma
add_format('DAY, DD/MM/YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');    -- Full day name with comma
add_format('DAY DD/MM/YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');     -- Full day name without comma
add_format('DAY, MM/DD/YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');    -- Full day name US format
```

**Format registration parameters explained**:
- Parameter 1: Format mask
- Parameter 2: Category ('DAYNAME')
- Parameter 3: Has year ('Y')
- Parameter 4: Has day name ('Y')
- Parameter 5: Has month name ('N' - numeric month)
- Parameter 6: Unknown (always 'N' in these cases)

### Part 4: Add Regex Patterns for All Variants

**File**: [UR_UTILS.sql](UR_UTILS.sql)
**Location**: Around line 4807, in the `detect_format_internal` procedure

**Add ELSIF blocks** after the Part 1 code (after `DY, DD/MM/YYYY` pattern):

```sql
ELSIF v_formats(i).format_mask = 'DY DD/MM/YYYY' THEN
    -- Pattern: day-name space digits slash digits slash 4-digit-year (no comma)
    IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+\d{1,2}\s*/\s*\d{1,2}\s*/\s*\d{4}\s*$', 'i') THEN
        v_match_count := v_match_count + 1;
    END IF;
ELSIF v_formats(i).format_mask = 'DY, MM/DD/YYYY' THEN
    -- Pattern: day-name comma space digits slash digits slash 4-digit-year (US month-first)
    IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s*,\s*\d{1,2}\s*/\s*\d{1,2}\s*/\s*\d{4}\s*$', 'i') THEN
        v_match_count := v_match_count + 1;
    END IF;
ELSIF v_formats(i).format_mask = 'DY MM/DD/YYYY' THEN
    -- Pattern: day-name space digits slash digits slash 4-digit-year (US month-first, no comma)
    IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+\d{1,2}\s*/\s*\d{1,2}\s*/\s*\d{4}\s*$', 'i') THEN
        v_match_count := v_match_count + 1;
    END IF;
ELSIF v_formats(i).format_mask = 'DY, DD-MM-YYYY' THEN
    -- Pattern: day-name comma space digits hyphen digits hyphen 4-digit-year
    IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s*,\s*\d{1,2}\s*-\s*\d{1,2}\s*-\s*\d{4}\s*$', 'i') THEN
        v_match_count := v_match_count + 1;
    END IF;
ELSIF v_formats(i).format_mask = 'DY DD-MM-YYYY' THEN
    -- Pattern: day-name space digits hyphen digits hyphen 4-digit-year (no comma)
    IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+\d{1,2}\s*-\s*\d{1,2}\s*-\s*\d{4}\s*$', 'i') THEN
        v_match_count := v_match_count + 1;
    END IF;
ELSIF v_formats(i).format_mask = 'DAY, DD/MM/YYYY' THEN
    -- Pattern: full-day-name comma space digits slash digits slash 4-digit-year
    IF REGEXP_LIKE(rec.val, '^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\s*,\s*\d{1,2}\s*/\s*\d{1,2}\s*/\s*\d{4}\s*$', 'i') THEN
        v_match_count := v_match_count + 1;
    END IF;
ELSIF v_formats(i).format_mask = 'DAY DD/MM/YYYY' THEN
    -- Pattern: full-day-name space digits slash digits slash 4-digit-year (no comma)
    IF REGEXP_LIKE(rec.val, '^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\s+\d{1,2}\s*/\s*\d{1,2}\s*/\s*\d{4}\s*$', 'i') THEN
        v_match_count := v_match_count + 1;
    END IF;
ELSIF v_formats(i).format_mask = 'DAY, MM/DD/YYYY' THEN
    -- Pattern: full-day-name comma space digits slash digits slash 4-digit-year (US format)
    IF REGEXP_LIKE(rec.val, '^(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)\s*,\s*\d{1,2}\s*/\s*\d{1,2}\s*/\s*\d{4}\s*$', 'i') THEN
        v_match_count := v_match_count + 1;
    END IF;
```

**Note**: Part 2 parsing logic will automatically handle ALL of these once detected, as it strips any day name (both DY and DAY formats) and extracts the numeric format.

## Implementation Summary

**Total Changes Required**:
1. **Part 1**: Add 1 regex pattern for existing `DY, DD/MM/YYYY` format
2. **Part 2**: Modify DY handling logic in `parse_date_internal` (expand condition + replace logic block)
3. **Part 3**: Register 8 new date formats
4. **Part 4**: Add 8 regex patterns for the new formats

**Lines Modified**:
- Line 4436: Add 8 new format registrations after this line
- Line 4807: Add 9 regex patterns after this line (1 for existing + 8 for new formats)
- Line 5051: Change condition from AND to remove year restriction
- Lines 5052-5065: Replace entire DY handling logic block

## Critical Files
- [UR_UTILS.sql](UR_UTILS.sql) - Primary date parsing logic
  - Lines 4436-4448: Format registration (Category 2: Day name formats)
  - Lines 4776-4815: `detect_format_internal` - Format detection with regex patterns
  - Lines 5049-5066: `parse_date_internal` - DY format special handling
  - Lines 4088-4111: `strip_day_name` - Removes day name prefix from dates
- [XX_LOCAL_LOAD_DATA_2.sql](XX_LOCAL_LOAD_DATA_2.sql)
  - Line 557: Where error message is generated (no changes needed here)
  - Lines 277-292: Where `parse_date_safe()` is called during data load (no changes needed here)

## Variables Needed in parse_date_internal
The Part 2 code uses two new variables. Ensure they're declared at the top of the function:
```sql
v_stripped VARCHAR2(4000);
v_numeric_format VARCHAR2(100);
```

## Testing Considerations

**Test all format variants**:

**3-letter day names (DY formats)**:
1. "Mon, 03/11/2025" - With comma, slash separator
2. "Tue 1/5/2025" - Without comma, slash separator
3. "WED, 12-31-2025" - With comma, hyphen separator
4. "thu 7-4-2025" - Without comma, hyphen separator (lowercase)
5. "Fri,01/01/2025" - No space after comma
6. "Sat , 10 / 10 / 2025" - Extra whitespace

**Full day names (DAY formats)**:
7. "Monday, 03/11/2025" - Full name with comma
8. "Tuesday 15/08/2025" - Full name without comma
9. "WEDNESDAY, 25/12/2025" - Uppercase full name

**US format (MM/DD/YYYY)**:
10. "Mon, 11/03/2025" - US format with comma
11. "Friday 12/25/2025" - US format, full day name

**Expected results**: All should parse correctly to the appropriate date values based on their format masks.

## Risk Assessment
**Medium-Low Risk**:

**Low Risk Aspects**:
- Part 1 (detection) is a targeted fix following established pattern from commit 59c84ef
- Only adds regex patterns for registered formats
- Regex patterns are well-tested and commonly used

**Medium Risk Aspects**:
- Part 2 (parsing) modifies core DY handling logic in `parse_date_internal`
- Changes apply to ALL DY/DAY formats, not just numeric ones
- Potential impact on existing DY DD-MON formats (though they should still work)

**Mitigation**:
- The existing DY DD-MON formats were already using special handling
- New logic uses same `strip_day_name()` function that's already tested
- Format mask conversion is straightforward string replacement
- Worst case: DY formats fail gracefully with NULL (same as current behavior)

## Related Changes
- **Commit 59c84ef** (2025-12-15): "Date Parser - Fixed DY DD-MON format mask issue"
  - Added 6 regex patterns for DY formats with month names (e.g., "Mon 01-Dec")
  - Added `preprocess_dy_sample()` function for day name preservation
  - This fix extends the same approach to numeric date formats (e.g., "Mon, 03/11/2025")

## Why All Parts Are Needed

**Part 1 alone** would allow detection of the existing `DY, DD/MM/YYYY` format but parsing would still fail.

**Part 2 alone** would fix parsing if the format mask is provided, but formats wouldn't be auto-detected during template creation.

**Part 3 alone** would register new formats but they wouldn't be detected or parsed correctly.

**Part 4 alone** would add patterns for unregistered formats (no effect).

**All parts together** ensure:
1. The existing `DY, DD/MM/YYYY` format is detected (Part 1) and parsed correctly (Part 2)
2. New format variants are registered in the system (Part 3)
3. New formats are detected during template setup (Part 4)
4. All DY/DAY numeric formats are parsed correctly (Part 2 handles all variants)

## Execution Order

1. **Part 3 first** - Register new formats (must exist before detection can use them)
2. **Part 1 & 4 together** - Add all regex patterns for detection
3. **Part 2 last** - Update parsing logic to handle all DY/DAY formats

## Expected Outcome

After implementation:
- Values like "Mon, 03/11/2025" will be correctly parsed as dates instead of returning NULL
- Error "Expected date value, got 'Mon, 03/11/2025' - value will be set to NULL" will be resolved
- All 9 day-name + numeric date format variants will work:
  - DY, DD/MM/YYYY, DY DD/MM/YYYY (existing + new)
  - DY, MM/DD/YYYY, DY MM/DD/YYYY (new US formats)
  - DY, DD-MM-YYYY, DY DD-MM-YYYY (new hyphen formats)
  - DAY, DD/MM/YYYY, DAY DD/MM/YYYY, DAY, MM/DD/YYYY (new full day name formats)
- Format detection will work automatically during template creation
- Manual format specification will also work
- The fix follows the same pattern as commit 59c84ef (tested and proven approach)

---
---
---

# TEMPORARY WORKAROUND SOLUTION (For Go-Live)

## Overview
**Minimal-risk change for immediate deployment** - Strip day names from both values AND format masks when parsing dates with DY/DAY formats that include year information.

## The Simple Fix

**File**: [UR_UTILS.sql](UR_UTILS.sql)
**Location**: Lines 5081-5088 in `parse_date_internal` function
**Change Type**: Modify existing fallback logic (very low risk)

### Current Code (lines 5081-5088)

```sql
ELSE
    -- Try stripping day name if present
    v_date := fn_try_date(strip_day_name(v_preprocessed), p_format);
    IF v_date IS NOT NULL THEN
        p_result_date := v_date;
        p_message := 'Parsed (after stripping day name) to ' || TO_CHAR(v_date, 'YYYY-MM-DD');
        append_debug('Parsed after strip: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));
        RETURN;
    END IF;
```

### New Code (REPLACE lines 5081-5088 with this)

```sql
ELSE
    -- Try stripping day name if present
    -- WORKAROUND: For DY/DAY formats with year, also strip day name from format mask
    IF (p_format LIKE '%DY%' OR p_format LIKE '%DAY%') AND (p_format LIKE '%YYYY%' OR p_format LIKE '%RR%') THEN
        -- Strip day name from value AND format mask
        v_date := fn_try_date(
            strip_day_name(v_preprocessed),
            -- Remove DY, DAY from format mask
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(p_format, 'DY, ', ''), 'DY ', ''), 'DAY, ', ''), 'DAY ', ''), ',  ', ' ')
        );
    ELSE
        -- Original logic for other formats
        v_date := fn_try_date(strip_day_name(v_preprocessed), p_format);
    END IF;

    IF v_date IS NOT NULL THEN
        p_result_date := v_date;
        p_message := 'Parsed (after stripping day name) to ' || TO_CHAR(v_date, 'YYYY-MM-DD');
        append_debug('Parsed after strip: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));
        RETURN;
    END IF;
```

## How This Works

**Example**: Input value `"Mon, 03/11/2025"` with format mask `"DY, DD/MM/YYYY"`

1. **Detect**: Format contains DY/DAY AND has year (YYYY)
2. **Strip value**: `strip_day_name("Mon, 03/11/2025")` → `"03/11/2025"`
3. **Strip format mask**:
   - Start: `"DY, DD/MM/YYYY"`
   - Remove `"DY, "`: `"DD/MM/YYYY"`
4. **Parse**: `fn_try_date("03/11/2025", "DD/MM/YYYY")` → Success!
5. **Result**: Date parsed correctly as 2025-11-03

## What Gets Fixed

✅ **Immediate fixes**:
- `"Mon, 03/11/2025"` with format `DY, DD/MM/YYYY`
- `"Tue 15/08/2025"` with format `DY DD/MM/YYYY` (if format exists)
- `"Wednesday, 25/12/2025"` with format `DAY, DD/MM/YYYY` (if format exists)

✅ **Works for all separators**:
- Slash: `03/11/2025`
- Hyphen: `03-11-2025`
- Space: `03 11 2025`

## What Doesn't Get Fixed (Needs Long-Term Solution)

❌ **Format detection** - New formats like `DY DD/MM/YYYY` won't be auto-detected during template creation (they'll need to be manually specified or registered first)

❌ **Auto-registration** - Unregistered format variants won't work

➡️ **Workaround for go-live**: If you encounter formats that aren't working, manually specify the format mask in the template (remove the DY/DAY part)

## Risk Assessment

**Risk Level**: ✅ **VERY LOW**

**Why it's safe**:
1. Only modifies the fallback ELSE clause (line 5081) - doesn't touch primary parsing paths
2. Adds a condition check before applying the fix - won't affect non-DY formats
3. Uses existing functions (`strip_day_name`, `fn_try_date`) - no new code
4. If the fix fails, it falls through to existing error handling (NULL return)
5. Only 10 lines of code changed

**Testing needed**:
- Test one DY format with year: `"Mon, 03/11/2025"` with format `DY, DD/MM/YYYY`
- Test should parse correctly to 2025-11-03

## Implementation Steps

1. Open [UR_UTILS.sql](UR_UTILS.sql)
2. Navigate to line 5081 (the ELSE clause in `parse_date_internal`)
3. Replace lines 5081-5088 with the new code above
4. Compile the package
5. Test with sample value

## Migration Path to Long-Term Solution

After go-live, when you have time for proper testing:
1. Implement Part 1 from the comprehensive solution (regex patterns)
2. Implement Part 3 & 4 (register new formats + patterns)
3. Replace this workaround with Part 2 from comprehensive solution
4. The temporary fix can remain as a fallback safety net

## Code Location Summary

**Single file change**: [UR_UTILS.sql](UR_UTILS.sql)
**Single location**: Lines 5081-5088 (ELSE clause in `parse_date_internal`)
**Lines added**: 10 lines total
**Lines removed**: 8 lines
**Net change**: +2 lines
