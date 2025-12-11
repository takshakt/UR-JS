# Advanced Date Parser Integration Plan

## Overview
Integrate the existing advanced date parser (`UR_UTILS.date_parser`) into the template creation and data load workflows to automatically detect date formats and use them during data loading.

## User Requirements (Confirmed)

1. **Detection Triggers**: Both automatic (file upload) AND manual (user changes type to DATE)
2. **Storage**: Add c007 (format_mask) to UR_FILE_DATA_PROFILES collection
3. **UI**: Visible and editable in Interactive Grid (user can override)
4. **Detection Failures**: Show warning with all low-confidence/ambiguous options, user decides
5. **Sample Size**: First 366 rows after skip_rows
6. **JSON Field**: Add "format-mask" field to template definition
7. **Backward Compatibility**: No migration needed - existing templates work as-is
8. **Special Values**: Ignore TODAY/TOMORROW/YESTERDAY when detecting format

## Implementation Strategy

**Core Approach**: Minimal code changes, leverage existing infrastructure, maintain backward compatibility

### Changes Summary
- **3 files modified**: UR_UTILS.sql, p01002.yaml, XX_LOCAL_LOAD_DATA_2.sql
- **1 new procedure**: extract_column_sample_values (~60 lines)
- **Code reduction**: -31 net lines (36-line CASE → 5-line function call)
- **Performance impact**: <1 second per DATE column

---

## Detailed Implementation Steps

### PHASE 1: UR_UTILS Package Modifications

#### 1.1 Modify get_collection_json to Include c007
**File**: `/home/coder/ur-js/UR_UTILS.sql` (lines 1305-1371)

Add c007 to SELECT and apex_json.write:
```sql
SELECT c001, c002, c003, c004, c005, c006, c007  -- ADD c007
...
apex_json.write('format_mask', rec.c007);  -- ADD THIS LINE
```

#### 1.2 Create extract_column_sample_values Procedure
**File**: `/home/coder/ur-js/UR_UTILS.sql` (add before line 3712)

New procedure to extract 366 sample values from uploaded file column for format detection. Uses apex_data_parser with p_max_rows => 366.

Key features:
- Extracts from temp_BLOB by file_id
- Handles skip_rows and xlsx_sheet_name
- Returns **JSON array format** CLOB: `["value1", "value2", ...]`
- Filters out NULL values
- Returns status/message for error handling

#### 1.3 Update LOAD_DATA_MAPPING_COLLECTION for c007
**File**: `/home/coder/ur-js/UR_UTILS.sql` (lines 2050-2150)

Add format_mask to JSON_TABLE extraction and update collection c007 attribute.

---

### PHASE 2: Template Creation Page (P1002)

#### 2.1 Update Interactive Grid SQL Query
**File**: `/home/coder/ur-js/f103 4/readable/application/pages/p01002.yaml` (lines 1043-1049)

Add c007 to SELECT:
```sql
SELECT seq_id, c001 AS name, c002 AS data_type, c003 as qualifier,
       c005 mapping_type, c004 as default_value,
       c007 as format_mask  -- ADD THIS
```

#### 2.2 Add FORMAT_MASK Column to Interactive Grid
**File**: Same file (after line 1501)

New column definition:
- Type: Textarea
- Heading: "Date Format"
- Editable: Yes
- Help text: "Oracle date format mask (e.g., DD-MON-YYYY). Auto-detected for DATE columns."

#### 2.3 Add Format Detection to Collection Population
**File**: Same file (lines 3911-3927)

When creating collection members:
- For DATE columns, call extract_column_sample_values
- Call date_parser in DETECT mode
- Store format_mask in c007
- Log warnings for ambiguous/failed detections

#### 2.4 Add Dynamic Action for Type Change (Optional MVP)
**File**: Same file

When user changes DATA_TYPE to DATE:
- Extract samples
- Detect format
- Update c007 in collection
- Show success/warning message

---

### PHASE 3: Data Load Procedure

#### 3.1 Extract format_mask from Template JSON
**File**: `/home/coder/ur-js/XX_LOCAL_LOAD_DATA_2.sql` (lines 150-201)

Add to TYPE definition:
```sql
TYPE t_mapping_rec IS RECORD (
    ...
    format_mask VARCHAR2(100)  -- ADD THIS
);
```

Add to JSON_TABLE:
```sql
format_mask VARCHAR2(100) PATH '$.format_mask'  -- ADD THIS
```

Store in associative array:
```sql
l_mapping(UPPER(TRIM(rec.src_col))).format_mask := TRIM(rec.format_mask);
```

#### 3.2 Replace Hardcoded CASE Statement
**File**: Same file (lines 273-308)

**BEFORE** (36 lines): Complex CASE with multiple REGEXP_LIKE patterns

**AFTER** (5-15 lines):
```sql
IF l_mapping(k).format_mask IS NOT NULL THEN
    v_expr := 'ur_utils.parse_date_safe(TRIM(p.' || l_mapping(k).parser_col ||
              '), ''' || l_mapping(k).format_mask || ''') as ' || upper(l_mapping(k).parser_col);
ELSE
    -- Backward compatibility fallback
    v_expr := [simplified CASE with 2-3 common formats]
END IF;
```

---

## Critical Files Reference

### Files to Modify
1. **UR_UTILS.sql** (76KB)
   - Lines 1305-1371: get_collection_json
   - Before line 3712: NEW extract_column_sample_values
   - Lines 2050-2150: LOAD_DATA_MAPPING_COLLECTION

2. **p01002.yaml** (template creation)
   - Lines 1043-1049: Grid SQL query
   - After line 1501: NEW FORMAT_MASK column
   - Lines 3911-3927: Collection population with detection

3. **XX_LOCAL_LOAD_DATA_2.sql** (data load)
   - Lines 20-30: TYPE definition
   - Lines 172-182: JSON_TABLE extraction
   - Lines 186-192: Associative array storage
   - Lines 273-308: CASE statement replacement

### Files Reference Only (No Changes)
- **UR_UTILS.sql** lines 3636-3709: date_parser wrappers (already complete)
- **UR_UTILS.sql** lines 196-321: sanitize_template_definition (already preserves format_mask)
- **p01011.yaml**: Data load page (no changes needed)

---

## Implementation Sequence

**Order matters for dependencies:**

1. UR_UTILS.sql - get_collection_json modification
2. UR_UTILS.sql - extract_column_sample_values procedure
3. UR_UTILS.sql - LOAD_DATA_MAPPING_COLLECTION update
4. **Compile UR_UTILS package** (verify no errors)
5. p01002.yaml - SQL query update
6. p01002.yaml - FORMAT_MASK column addition
7. p01002.yaml - Collection population with detection
8. p01002.yaml - Dynamic action (optional)
9. XX_LOCAL_LOAD_DATA_2.sql - TYPE and JSON_TABLE changes
10. XX_LOCAL_LOAD_DATA_2.sql - CASE statement replacement

---

## Testing Strategy

### Test Case 1: New Template with Auto-Detection
- Upload CSV with DATE column ("31-DEC-2024")
- Verify c007 = "DD-MON-YYYY"
- Save template, check JSON has "format_mask"

### Test Case 2: Ambiguous Format Warning
- Upload file with "01/02/2024"
- Verify warning about DD/MM vs MM/DD
- User can override in grid

### Test Case 3: Detection Failure
- Upload with unparseable dates
- Verify c007 = NULL
- User manually enters format

### Test Case 4: Data Load with Format Mask
- Use template from Test 1
- Load data
- Verify dates parsed correctly

### Test Case 5: Backward Compatibility
- Use old template (no format_mask)
- Load data
- Verify fallback CASE works

### Test Case 6: User Override
- Edit c007 in grid
- Save template
- Verify override persisted

---

## Edge Cases & Error Handling

- **No DATE columns**: No detection runs, no impact
- **Empty DATE column**: Returns NULL, user must specify
- **Mixed formats**: Returns ambiguous=Y, warns user
- **Special values**: Ignored (TODAY, TOMORROW, etc.)
- **Excel date serials**: APEX parser converts first
- **parse_date_safe returns NULL**: NULL inserted, no error
- **Invalid format_mask**: Returns NULL, data load continues

---

## Rollback Plan

If issues arise:
1. Revert UR_UTILS.sql backup
2. Revert p01002.yaml backup
3. Revert XX_LOCAL_LOAD_DATA_2.sql backup
4. Existing templates continue working (no format_mask field)

Test rollback in UAT before production.

---

## Performance Impact

- **Template creation**: +0.5-1 second per DATE column (366 rows parsed)
- **Data load**: Neutral (function call vs inline CASE, but shorter SQL)
- **Collection storage**: +1 column, negligible memory increase

---

## Benefits

✓ Automatic date format detection (saves user time)
✓ User override capability (flexibility)
✓ Backward compatible (no migration needed)
✓ Cleaner code (-31 lines in data load)
✓ Leverages existing advanced parser (tested, robust)
✓ Handles 80+ date formats automatically
✓ Special value handling (TODAY, TOMORROW, etc.)
✓ Confidence scoring and ambiguity detection

---

*Plan Status: **COMPLETE** - Ready for implementation*
