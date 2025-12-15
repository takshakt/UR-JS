# Date Parser DY Format Fix - Comprehensive Review

## Summary of Changes

This document reviews all changes made to fix DY format detection and parsing, and provides a comprehensive test plan to ensure backward compatibility.

---

## Changes Made

### 1. Added `preprocess_dy_sample` Function (Lines 4117-4213)

**Location**: `UR_UTILS.sql:4117-4213`

**Purpose**: Preprocessing function that preserves day names (unlike standard `preprocess_date_sample`)

**What it does differently from `preprocess_date_sample`**:
- ✓ Normalizes day name abbreviations (Thurs→Thu, Tues→Tue, Weds→Wed)
- ✓ Uppercases day names (Mon→MON) for Oracle compatibility
- ✓ Uppercases month names (Dec→DEC) for Oracle compatibility
- ✓ Selective text number conversion (safe patterns only, skips "second"/"third" to avoid corrupting day names)
- ✓ Removes filler words except "day" (part of day names)
- ✓ Strips ordinal suffixes
- ✗ **Does NOT strip day names** (this is the key difference)

**Impact**: NONE on non-DY formats (this function is only called for DY format testing/parsing)

---

### 2. Modified Format Testing Loop (Lines 4776-4815)

**Location**: `UR_UTILS.sql:4776-4815`

**Purpose**: Use regex pattern matching for DY formats instead of Oracle TO_DATE (which doesn't work reliably without year)

**Logic Flow**:
```
IF format has_day_name = 'Y' THEN
    IF format is 'DY DD-MON' THEN
        Use regex: ^(Mon|Tue|...|Sun)\s+\d{1,2}\s*-\s*(Jan|...|Dec)\s*$
        (Note: \s*$ ensures NO year at end)
    ELSIF format is 'DY DD-MON-YYYY' THEN
        Use regex: ^(Mon|Tue|...|Sun)\s+\d{1,2}\s*-\s*(Jan|...|Dec)\s*-\s*\d{4}\s*$
        (Note: requires 4-digit year at end)
    ... (similar for DY DD MON, DY, DD MON, etc.)
    ELSE
        For other DY formats with year, use fn_try_date
    END IF
ELSIF ... (standard TO_DATE parsing for non-DY formats)
```

**Impact on Non-DY Formats**: NONE
- Non-DY formats skip the entire `IF v_formats(i).has_day_name = 'Y'` block
- They use the `ELSIF fn_try_date(v_preprocessed, v_formats(i).format_mask)` branch (line 4816)
- This is **identical** to the original code path

**Impact on DY Formats**:
- DY formats WITHOUT year (e.g., `DY DD-MON`): Now use regex matching → **FIXED**
- DY formats WITH year (e.g., `DY DD-MON-YYYY`): Still use regex matching → **CHANGED** but should work
- Full day name formats (DAY DD MON): Pattern matching → **CHANGED** but should work

---

### 3. Added DY Format Scoring Bonus (Line 4843)

**Location**: `UR_UTILS.sql:4843`

**Code**:
```sql
IF v_formats(i).has_day_name = 'Y' AND v_structure.has_day_name = 'Y' THEN
    v_score := v_score * 1.20;  -- 20% bonus
END IF;
```

**Purpose**: Ensure DY formats win over DD-MON when input contains day names

**Impact on Non-DY Formats**: NONE
- Only applies when `has_day_name = 'Y'`
- Non-DY formats have `has_day_name = 'N'`

---

### 4. Modified `parse_date_internal` (Lines 5036-5051)

**Location**: `UR_UTILS.sql:5036-5051`

**Purpose**: Route DY formats without year directly to `fn_infer_year` (skip TO_DATE)

**Logic Flow**:
```
IF format has DY/DAY AND no YYYY/RR THEN
    Call fn_infer_year directly (which validates day names)
    RETURN
END IF

-- Standard parsing for non-DY formats
(use preprocess_date_sample, fn_try_date, etc.)
```

**Impact on Non-DY Formats**: NONE
- Non-DY formats don't have DY/DAY in format mask
- They skip the early return and use standard parsing path
- Standard parsing path is **unchanged**

**Impact on DY Formats**:
- DY formats without year: Use `fn_infer_year` directly → **FIXED**
- DY formats with year: Continue to standard parsing (but won't match the early return condition)

---

## Potential Issues and Risks

### Risk 1: Regex Patterns Too Strict

**Issue**: Regex patterns use `\s*$` to ensure no trailing content. This might reject valid dates with trailing whitespace or comments.

**Example**: `"Mon 01-Dec  "` (trailing spaces) → Should still match

**Mitigation**: The `\s*` before `$` handles trailing whitespace

**Test**: Include dates with trailing spaces in test suite

---

### Risk 2: Case Sensitivity in Month/Day Names

**Issue**: Regex patterns use `'i'` flag (case-insensitive), but preprocessing uppercases day/month names. Any mismatch could cause issues.

**Example**: `"MONDAY 01-DECEMBER"` (full uppercase) → Should work

**Mitigation**: Preprocessing normalizes case; regex is case-insensitive

**Test**: Include various case combinations in test suite

---

### Risk 3: Full Day Names (Monday, Tuesday, etc.)

**Issue**: Regex patterns only check 3-letter abbreviations. Full day names might not match.

**Example**: `"Monday 01-Dec"` → Won't match `DY DD-MON` pattern

**Expected**: Should be handled by DAY formats (not DY)

**Test**: Verify DAY formats work separately

---

### Risk 4: DY Formats With Year Using Regex Instead of TO_DATE

**Issue**: Changed `DY DD-MON-YYYY` to use regex pattern matching instead of Oracle TO_DATE

**Example**: `"Mon 01-Dec-2025"` → Now validated by regex, not Oracle

**Risk**: Regex might accept invalid dates (e.g., "Mon 31-Feb-2025")

**Mitigation**: `fn_infer_year` still validates day name against actual date

**Test**: Include invalid day/month combinations

---

### Risk 5: Performance Impact

**Issue**: Added regex matching for all DY formats, which executes for every sample

**Impact**: Minimal - regex is fast, and only runs for formats with `has_day_name='Y'`

**Test**: Not critical for correctness, but monitor if dataset is very large

---

## Comprehensive Test Plan

### Test Category 1: DY Formats (Primary Fix)

**Purpose**: Verify DY format detection and parsing works correctly

```sql
-- Test 1.1: DY DD-MON format (hyphen separator, no year)
SELECT date_parser(
    '["Mon 01-Dec","Tue 02-Dec","Wed 03-Dec","Thu 01-Jan","Fri 02-Jan"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DY DD-MON', Confidence = 100%, parse "Thu 01-Jan" as 2026-01-01

-- Test 1.2: DY DD MON format (space separator, no year)
SELECT date_parser(
    '["Mon 01 Dec","Tue 02 Dec","Wed 03 Dec","Thu 01 Jan","Fri 02 Jan"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DY DD MON', Confidence = 100%, parse "Thu 01 Jan" as 2026-01-01

-- Test 1.3: DY, DD MON format (comma separator, no year)
SELECT date_parser(
    '["Mon, 01 Dec","Tue, 02 Dec","Wed, 03 Dec","Thu, 01 Jan","Fri, 02 Jan"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DY, DD MON', Confidence = 100%, parse "Thu, 01 Jan" as 2026-01-01

-- Test 1.4: DY DD-MON-YYYY format (with year)
SELECT date_parser(
    '["Mon 01-Dec-2025","Tue 02-Dec-2025","Wed 03-Dec-2025","Thu 01-Jan-2026"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DY DD-MON-YYYY', Confidence = 100%, parse "Thu 01-Jan-2026" as 2026-01-01

-- Test 1.5: Mixed case day/month names
SELECT date_parser(
    '["MON 01-DEC","tue 02-dec","Wed 03-Dec","THU 01-JAN"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DY DD-MON', Confidence = 100%, all parse correctly

-- Test 1.6: Trailing/leading whitespace
SELECT date_parser(
    '["  Mon 01-Dec  ","Tue 02-Dec","Wed 03-Dec  ","Thu 01-Jan"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DY DD-MON', Confidence = 100%, all parse correctly

-- Test 1.7: Year boundary validation (critical test case)
SELECT date_parser(
    '["Mon 29-Dec","Tue 30-Dec","Wed 31-Dec","Thu 01-Jan","Fri 02-Jan"]',
    TO_DATE('2025-12-15', 'YYYY-MM-DD'),
    'DETECT'
);
-- Expected: "Thu 01-Jan" → 2026-01-01 (NOT 2025-01-01)
-- Validation: 2026-01-01 is Thursday ✓, 2025-01-01 is Wednesday ✗
```

---

### Test Category 2: Non-DY Formats (Backward Compatibility)

**Purpose**: Verify existing formats still work correctly

```sql
-- Test 2.1: DD-MON format (no day name, no year)
SELECT date_parser(
    '["01-Dec","02-Dec","03-Dec","01-Jan","02-Jan"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DD-MON', Confidence = 100%, parse "01-Jan" as 2026-01-01 (year inference)

-- Test 2.2: DD/MM/YYYY format (numeric with slashes)
SELECT date_parser(
    '["01/12/2025","02/12/2025","03/12/2025","01/01/2026"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DD/MM/YYYY', Confidence = 100%, all parse correctly

-- Test 2.3: YYYY-MM-DD format (ISO format)
SELECT date_parser(
    '["2025-12-01","2025-12-02","2025-12-03","2026-01-01"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'YYYY-MM-DD', Confidence = 100%, all parse correctly

-- Test 2.4: DD MONTH YYYY format (full month name)
SELECT date_parser(
    '["01 December 2025","02 December 2025","03 December 2025","01 January 2026"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DD MONTH YYYY', Confidence = 100%, all parse correctly

-- Test 2.5: MM/DD/YYYY format (US format)
SELECT date_parser(
    '["12/01/2025","12/02/2025","12/03/2025","01/01/2026"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'MM/DD/YYYY', Confidence = 100%, all parse correctly

-- Test 2.6: DD.MM.YYYY format (European format with dots)
SELECT date_parser(
    '["01.12.2025","02.12.2025","03.12.2025","01.01.2026"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DD.MM.YYYY', Confidence = 100%, all parse correctly

-- Test 2.7: MON DD, YYYY format (US long format)
SELECT date_parser(
    '["Dec 01, 2025","Dec 02, 2025","Dec 03, 2025","Jan 01, 2026"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'MON DD, YYYY', Confidence = 100%, all parse correctly
```

---

### Test Category 3: Edge Cases

**Purpose**: Test unusual inputs and boundary conditions

```sql
-- Test 3.1: Input with day names but non-DY format should strip day name
SELECT date_parser(
    '["Mon 01-Dec-2025","Tue 02-Dec-2025","Wed 03-Dec-2025"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Should detect as DD-MON-YYYY or DY DD-MON-YYYY (both have year)
-- If DD-MON-YYYY: day names should be stripped and ignored
-- If DY DD-MON-YYYY: day names should be validated

-- Test 3.2: Special values (Today, Yesterday, etc.)
SELECT date_parser(
    '["Mon 01-Dec","Today","Wed 03-Dec","Thu 01-Jan"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DY DD-MON', special value "Today" handled correctly

-- Test 3.3: Invalid day name (wrong day for date)
-- Note: Regex pattern accepts any valid day name, validation happens during year inference
SELECT date_parser(
    '["Wed 01-Dec","Thu 02-Dec","Fri 03-Dec"]',  -- Wed 01-Dec is WRONG (should be Mon)
    TO_DATE('2025-12-15', 'YYYY-MM-DD'),
    'DETECT'
);
-- Expected: Format detected as 'DY DD-MON'
-- During parsing: fn_infer_year should find correct year where day name matches
-- If no year matches (day name never matches), should fail or use fallback

-- Test 3.4: Ambiguous DD/MM format
SELECT date_parser(
    '["01/12/2025","02/11/2025","03/10/2025"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Should detect as DD/MM/YYYY or MM/DD/YYYY (might be ambiguous)

-- Test 3.5: Single-digit day and month
SELECT date_parser(
    '["Mon 1-Dec","Tue 2-Dec","Wed 3-Dec"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DY DD-MON', regex allows \d{1,2}

-- Test 3.6: Full day names (should use DAY format, not DY)
SELECT date_parser(
    '["Monday 01-Dec","Tuesday 02-Dec","Wednesday 03-Dec"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Format = 'DAY DD-MON' (if registered) or fail to match DY formats

-- Test 3.7: Abbreviated month names (4 letters)
SELECT date_parser(
    '["Mon 01-Sept","Tue 02-Sept","Wed 03-Sept"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Should handle "Sept" (preprocessing should normalize)
```

---

### Test Category 4: Performance and Scale

**Purpose**: Verify performance with large datasets

```sql
-- Test 4.1: Large sample size (1000+ values)
-- Generate 1000 dates with day names
-- Expected: Detection completes within reasonable time (<5 seconds)

-- Test 4.2: Mixed formats in sample (should pick most common)
SELECT date_parser(
    '["Mon 01-Dec","02-Dec","Mon 03-Dec","04-Dec","Mon 05-Dec"]',
    SYSDATE,
    'DETECT'
);
-- Expected: Might detect DD-MON (60% match) or DY DD-MON (40% match)
-- Actual result depends on scoring
```

---

## Test Execution Script

Here's a complete SQL script to run all tests:

```sql
SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
    v_status VARCHAR2(10);
    v_message VARCHAR2(4000);
    v_format VARCHAR2(100);
    v_confidence NUMBER;
    v_result_date DATE;
    v_test_num NUMBER := 0;
    v_pass_count NUMBER := 0;
    v_fail_count NUMBER := 0;

    PROCEDURE run_test(
        p_test_name VARCHAR2,
        p_samples CLOB,
        p_start_date DATE,
        p_expected_format VARCHAR2,
        p_min_confidence NUMBER DEFAULT 90
    ) IS
    BEGIN
        v_test_num := v_test_num + 1;
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Test ' || v_test_num || ': ' || p_test_name);
        DBMS_OUTPUT.PUT_LINE('Samples: ' || SUBSTR(p_samples, 1, 100) || '...');

        -- Detect format
        date_parser(
            p_sample_values => p_samples,
            p_start => p_start_date,
            p_mode => 'DETECT',
            p_status => v_status,
            p_message => v_message,
            p_format_mask => v_format,
            p_confidence => v_confidence
        );

        DBMS_OUTPUT.PUT_LINE('  Status: ' || v_status);
        DBMS_OUTPUT.PUT_LINE('  Detected: ' || v_format || ' (Confidence: ' || v_confidence || '%)');
        DBMS_OUTPUT.PUT_LINE('  Expected: ' || p_expected_format || ' (Min confidence: ' || p_min_confidence || '%)');

        -- Check results
        IF v_status = 'S' AND v_format = p_expected_format AND v_confidence >= p_min_confidence THEN
            DBMS_OUTPUT.PUT_LINE('  Result: PASS ✓');
            v_pass_count := v_pass_count + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('  Result: FAIL ✗');
            DBMS_OUTPUT.PUT_LINE('  Message: ' || v_message);
            v_fail_count := v_fail_count + 1;
        END IF;
    END run_test;

BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('DATE PARSER COMPREHENSIVE TEST SUITE');
    DBMS_OUTPUT.PUT_LINE('========================================');

    -- Category 1: DY Formats
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== CATEGORY 1: DY FORMATS (PRIMARY FIX) ===');

    run_test(
        'DY DD-MON format (hyphen separator)',
        '["Mon 01-Dec","Tue 02-Dec","Wed 03-Dec","Thu 01-Jan","Fri 02-Jan"]',
        SYSDATE,
        'DY DD-MON',
        95
    );

    run_test(
        'DY DD MON format (space separator)',
        '["Mon 01 Dec","Tue 02 Dec","Wed 03 Dec","Thu 01 Jan","Fri 02 Jan"]',
        SYSDATE,
        'DY DD MON',
        95
    );

    run_test(
        'DY, DD MON format (comma separator)',
        '["Mon, 01 Dec","Tue, 02 Dec","Wed, 03 Dec","Thu, 01 Jan","Fri, 02 Jan"]',
        SYSDATE,
        'DY, DD MON',
        95
    );

    run_test(
        'DY DD-MON-YYYY format (with year)',
        '["Mon 01-Dec-2025","Tue 02-Dec-2025","Wed 03-Dec-2025","Thu 01-Jan-2026"]',
        SYSDATE,
        'DY DD-MON-YYYY',
        95
    );

    run_test(
        'Mixed case day/month names',
        '["MON 01-DEC","tue 02-dec","Wed 03-Dec","THU 01-JAN"]',
        SYSDATE,
        'DY DD-MON',
        95
    );

    -- Category 2: Non-DY Formats (Backward Compatibility)
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== CATEGORY 2: NON-DY FORMATS (BACKWARD COMPATIBILITY) ===');

    run_test(
        'DD-MON format (no day name)',
        '["01-Dec","02-Dec","03-Dec","01-Jan","02-Jan"]',
        SYSDATE,
        'DD-MON',
        95
    );

    run_test(
        'DD/MM/YYYY format (numeric)',
        '["01/12/2025","02/12/2025","03/12/2025","01/01/2026"]',
        SYSDATE,
        'DD/MM/YYYY',
        95
    );

    run_test(
        'YYYY-MM-DD format (ISO)',
        '["2025-12-01","2025-12-02","2025-12-03","2026-01-01"]',
        SYSDATE,
        'YYYY-MM-DD',
        95
    );

    run_test(
        'DD MONTH YYYY format (full month name)',
        '["01 December 2025","02 December 2025","03 December 2025","01 January 2026"]',
        SYSDATE,
        'DD MONTH YYYY',
        95
    );

    run_test(
        'MM/DD/YYYY format (US format)',
        '["12/01/2025","12/02/2025","12/15/2025","12/25/2025"]',
        SYSDATE,
        'MM/DD/YYYY',
        95
    );

    run_test(
        'DD.MM.YYYY format (European dots)',
        '["01.12.2025","02.12.2025","03.12.2025","01.01.2026"]',
        SYSDATE,
        'DD.MM.YYYY',
        95
    );

    -- Category 3: Edge Cases
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== CATEGORY 3: EDGE CASES ===');

    run_test(
        'Single-digit day',
        '["Mon 1-Dec","Tue 2-Dec","Wed 3-Dec"]',
        SYSDATE,
        'DY DD-MON',
        95
    );

    run_test(
        'Special values mixed in',
        '["Mon 01-Dec","Today","Wed 03-Dec","Thu 01-Jan"]',
        SYSDATE,
        'DY DD-MON',
        90
    );

    -- Summary
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('TEST SUMMARY');
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Total Tests: ' || v_test_num);
    DBMS_OUTPUT.PUT_LINE('Passed: ' || v_pass_count || ' ✓');
    DBMS_OUTPUT.PUT_LINE('Failed: ' || v_fail_count || ' ✗');
    DBMS_OUTPUT.PUT_LINE('Success Rate: ' || ROUND((v_pass_count / v_test_num) * 100, 1) || '%');

    IF v_fail_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('ALL TESTS PASSED! ✓✓✓');
    ELSE
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('SOME TESTS FAILED - Review above for details');
    END IF;
END;
/
```

---

## Expected Results

After running the complete test suite:

1. **All DY format tests should PASS** (Category 1)
2. **All non-DY format tests should PASS** (Category 2)
3. **Most edge case tests should PASS** (Category 3)

If any tests fail, it indicates:
- DY format test failure: Primary fix has issues
- Non-DY format test failure: **Backward compatibility broken** (critical issue)
- Edge case test failure: Need to handle special cases better

---

## Rollback Plan

If backward compatibility is broken, changes can be reverted in this order:

1. Remove parse routing change (lines 5036-5051)
2. Remove regex pattern matching (lines 4776-4815)
3. Remove scoring bonus (line 4843)
4. Remove `preprocess_dy_sample` function (lines 4117-4213)

Each change is isolated and can be reverted independently.

---

## Conclusion

The changes are **highly targeted** and should have **zero impact** on non-DY formats. However, comprehensive testing is recommended before production deployment.

Key safeguards:
- All changes are gated by `has_day_name = 'Y'` checks
- Non-DY formats use unchanged code paths
- Regex patterns are format-specific (no fallthrough)
- Year inference logic (`fn_infer_year`) was not modified

**Recommendation**: Run the test suite and verify all non-DY tests pass before declaring success.
