# Plan: Enhanced File Preview with Parsing Controls for Page 1002

## Overview
Enhance Step 1 (File Load) on page 1002 to display actual file contents in a preview collection, with controls for skip rows and Excel sheet selection that dynamically refresh the preview.

---

## Current State Analysis

### Existing Flow
1. User uploads file → stored in `APEX_APPLICATION_TEMP_FILES`
2. `apex_data_parser.discover()` analyzes file structure
3. Column metadata populates `UR_FILE_DATA_PROFILES` collection
4. Only metadata shown (ID, Filename, Record count) - **no actual data preview**

### Key Findings
- `apex_data_parser.parse()` supports `p_skip_rows` parameter (currently hardcoded to 1)
- `apex_data_parser` supports `p_xlsx_sheet_name` parameter - **not currently used**
- No existing sheet enumeration in the codebase
- Sheet names available in discover profile JSON at `$.\"worksheets\"` path (Oracle APEX 19.2+)

---

## Proposed Implementation

### New Page Items to Add

| Item Name | Type | Purpose | Default |
|-----------|------|---------|---------|
| `P1002_SKIP_ROWS` | Number Field | Rows to skip before header | 0 |
| `P1002_SHEET_NAME` | Select List | Excel sheet selector | First sheet |
| `P1002_FILE_TYPE` | Hidden | Stores detected file type (CSV/XLSX) | - |

### New Regions to Add

| Region | Type | Purpose |
|--------|------|---------|
| `File_Preview` | Interactive Grid (read-only) | Shows first N rows of parsed data |
| `Parsing_Controls` | Static Content | Contains skip rows and sheet selector |

---

## Detailed Implementation Steps

### Step 1: Add New Page Items

#### P1002_SKIP_ROWS
- **Type**: Number Field
- **Label**: "Skip Rows (0 = first row is header)"
- **Default**: 0
- **Min Value**: 0
- **Max Value**: 100
- **Region**: Place in `File_Load` region or new `Parsing_Controls` sub-region

#### P1002_SHEET_NAME
- **Type**: Select List
- **Label**: "Excel Sheet"
- **LOV Type**: SQL Query (dynamic based on uploaded file)
- **LOV Query** (using `APEX_DATA_PARSER.GET_XLSX_WORKSHEETS`):
```sql
SELECT sheet_display_name AS d,    -- Display value (what user sees: "Sheet1")
       sheet_file_name AS r        -- Return value (what parse() needs: "sheet1.xml")
FROM TABLE(
    apex_data_parser.get_xlsx_worksheets(
        p_content => (SELECT blob_content
                      FROM apex_application_temp_files
                      WHERE name = :P1002_FILE_LOAD)
    )
)
ORDER BY sheet_sequence
```
**IMPORTANT**: `p_xlsx_sheet_name` in `apex_data_parser.parse()` expects `sheet_file_name` (e.g., "sheet1.xml"), NOT `sheet_display_name` (e.g., "Sheet1").
- **Cascading LOV Parent**: `P1002_FILE_LOAD`
- **Display Null**: Yes (for CSV files or when no sheets found)
- **Condition**: Only enabled when file type is XLSX

**API Reference**: `APEX_DATA_PARSER.GET_XLSX_WORKSHEETS(p_content IN BLOB)` returns `apex_t_parser_worksheets` with columns:
- `SHEET_SEQUENCE` - worksheet order
- `SHEET_DISPLAY_NAME` - visible worksheet name
- `SHEET_FILE_NAME` - internal file reference
- `SHEET_PATH` - location within workbook structure

#### P1002_FILE_TYPE
- **Type**: Hidden
- **Source**: Derived from filename extension or MIME type
- **Purpose**: Controls sheet selector enable/disable state

---

### Step 2: Add File Preview Collection

#### Create New Collection: `UR_FILE_PREVIEW`
Store parsed row data for preview display.

#### Preview Query (for Interactive Grid source):

**IMPORTANT - Handle NULL sheet name on initial load:**
```sql
SELECT line_number,
       col001, col002, col003, col004, col005,
       col006, col007, col008, col009, col010,
       col011, col012, col013, col014, col015,
       col016, col017, col018, col019, col020
FROM TABLE(
    apex_data_parser.parse(
        p_content         => (SELECT blob_content
                              FROM apex_application_temp_files
                              WHERE name = :P1002_FILE_LOAD),
        p_file_name       => (SELECT filename
                              FROM apex_application_temp_files
                              WHERE name = :P1002_FILE_LOAD),
        p_skip_rows       => NVL(:P1002_SKIP_ROWS, 0),
        p_xlsx_sheet_name => COALESCE(
            NULLIF(:P1002_SHEET_NAME, ''),
            (SELECT MIN(sheet_file_name) KEEP (DENSE_RANK FIRST ORDER BY sheet_sequence)
             FROM TABLE(apex_data_parser.get_xlsx_worksheets(
                 p_content => (SELECT blob_content
                               FROM apex_application_temp_files
                               WHERE name = :P1002_FILE_LOAD)
             ))
            )
        ),
        p_max_rows        => 50
    )
)
WHERE :P1002_FILE_LOAD IS NOT NULL
```

**Key Points:**
1. `NULLIF(:P1002_SHEET_NAME, '')` - Converts empty string to NULL
2. `COALESCE(..., subquery)` - Falls back to first sheet when NULL
3. `WHERE :P1002_FILE_LOAD IS NOT NULL` - Prevents query from running without file

**Alternative Approach** (using collection for more control):
```sql
SELECT seq_id,
       c001, c002, c003, c004, c005,
       c006, c007, c008, c009, c010,
       c011, c012, c013, c014, c015,
       c016, c017, c018, c019, c020
FROM apex_collections
WHERE collection_name = 'UR_FILE_PREVIEW'
ORDER BY seq_id
```

---

### Step 3: Modify Process Logic

#### Update `Create File Profile and Collection Loading` Process

Add logic to:
1. Detect file type (CSV vs XLSX)
2. Extract sheet names for Excel files
3. Populate preview collection with actual data

```sql
DECLARE
    v_profile_clob   CLOB;
    v_file_type      VARCHAR2(10);
    v_sheet_list     CLOB;
    v_first_sheet    VARCHAR2(100);
BEGIN
    -- Detect file type from extension
    IF LOWER(:P1002_FILE_LOAD) LIKE '%.csv' THEN
        v_file_type := 'CSV';
    ELSIF LOWER(:P1002_FILE_LOAD) LIKE '%.xls%' THEN
        v_file_type := 'XLSX';
    END IF;

    :P1002_FILE_TYPE := v_file_type;

    -- Get profile
    SELECT apex_data_parser.discover(
               p_content   => blob_content,
               p_file_name => filename
           )
    INTO v_profile_clob
    FROM apex_application_temp_files
    WHERE name = :P1002_FILE_LOAD;

    -- For Excel: Extract sheet names and set default
    IF v_file_type = 'XLSX' THEN
        -- Get first sheet name as default
        SELECT JSON_VALUE(v_profile_clob, '$.worksheets[0]')
        INTO v_first_sheet
        FROM dual;

        :P1002_SHEET_NAME := v_first_sheet;
    ELSE
        :P1002_SHEET_NAME := NULL;
    END IF;

    -- Populate preview collection (separate procedure recommended)
    populate_file_preview(
        p_file_name  => :P1002_FILE_LOAD,
        p_skip_rows  => NVL(:P1002_SKIP_ROWS, 0),
        p_sheet_name => :P1002_SHEET_NAME
    );
END;
```

---

### Step 4: Add Dynamic Actions

#### DA: `Skip_Rows_Changed` (Auto-refresh)
- **Event**: Change on `P1002_SKIP_ROWS`
- **Actions** (sequential):
  1. **Execute Server-side Code**: Re-parse file and update both collections
     ```sql
     BEGIN
         -- Re-populate preview with new skip rows
         populate_file_preview(
             p_file_name  => :P1002_FILE_LOAD,
             p_skip_rows  => NVL(:P1002_SKIP_ROWS, 0),
             p_sheet_name => :P1002_SHEET_NAME
         );

         -- Re-populate column metadata (UR_FILE_DATA_PROFILES)
         refresh_file_data_profiles(
             p_file_name  => :P1002_FILE_LOAD,
             p_skip_rows  => NVL(:P1002_SKIP_ROWS, 0),
             p_sheet_name => :P1002_SHEET_NAME
         );
     END;
     ```
     - Items to Submit: `P1002_FILE_LOAD, P1002_SKIP_ROWS, P1002_SHEET_NAME`
  2. **Refresh Region**: `File_Preview`
  3. **Refresh Region**: `Collection` (Step 2 Interactive Grid)

#### DA: `Sheet_Name_Changed` (Auto-refresh)
- **Event**: Change on `P1002_SHEET_NAME`
- **Condition**: `P1002_FILE_TYPE = 'XLSX'`
- **Actions** (sequential):
  1. **Execute Server-side Code**: Same as Skip_Rows_Changed (re-parse both collections)
  2. **Refresh Region**: `File_Preview`
  3. **Refresh Region**: `Collection` (columns may differ per sheet)

#### DA: `File_Type_Control`
- **Event**: Change on `P1002_FILE_TYPE`
- **True Actions** (when XLSX):
  - Enable `P1002_SHEET_NAME`
  - Refresh LOV for `P1002_SHEET_NAME`
- **False Actions** (when CSV):
  - Set Value: `P1002_SHEET_NAME` = NULL
  - Disable `P1002_SHEET_NAME`

---

### Step 5: Create Supporting Procedures

#### Procedure 1: `populate_file_preview` (Data Preview)

```sql
CREATE OR REPLACE PROCEDURE populate_file_preview(
    p_file_name  IN VARCHAR2,
    p_skip_rows  IN NUMBER DEFAULT 0,
    p_sheet_name IN VARCHAR2 DEFAULT NULL,
    p_max_rows   IN NUMBER DEFAULT 50
) AS
    v_blob     BLOB;
    v_filename VARCHAR2(400);
BEGIN
    -- Get file content
    SELECT blob_content, filename
    INTO v_blob, v_filename
    FROM apex_application_temp_files
    WHERE name = p_file_name;

    -- Truncate/create collection
    IF apex_collection.collection_exists('UR_FILE_PREVIEW') THEN
        apex_collection.truncate_collection('UR_FILE_PREVIEW');
    ELSE
        apex_collection.create_collection('UR_FILE_PREVIEW');
    END IF;

    -- Populate with parsed data (20 columns)
    FOR rec IN (
        SELECT line_number,
               col001, col002, col003, col004, col005,
               col006, col007, col008, col009, col010,
               col011, col012, col013, col014, col015,
               col016, col017, col018, col019, col020
        FROM TABLE(
            apex_data_parser.parse(
                p_content         => v_blob,
                p_file_name       => v_filename,
                p_skip_rows       => p_skip_rows,
                p_xlsx_sheet_name => p_sheet_name,
                p_max_rows        => p_max_rows
            )
        )
    ) LOOP
        apex_collection.add_member(
            p_collection_name => 'UR_FILE_PREVIEW',
            p_c001 => rec.col001,
            p_c002 => rec.col002,
            p_c003 => rec.col003,
            p_c004 => rec.col004,
            p_c005 => rec.col005,
            p_c006 => rec.col006,
            p_c007 => rec.col007,
            p_c008 => rec.col008,
            p_c009 => rec.col009,
            p_c010 => rec.col010,
            p_c011 => rec.col011,
            p_c012 => rec.col012,
            p_c013 => rec.col013,
            p_c014 => rec.col014,
            p_c015 => rec.col015,
            p_c016 => rec.col016,
            p_c017 => rec.col017,
            p_c018 => rec.col018,
            p_c019 => rec.col019,
            p_c020 => rec.col020,
            p_n001 => rec.line_number
        );
    END LOOP;
END;
```

#### Procedure 2: `refresh_file_data_profiles` (Column Metadata for Step 2)

```sql
CREATE OR REPLACE PROCEDURE refresh_file_data_profiles(
    p_file_name  IN VARCHAR2,
    p_skip_rows  IN NUMBER DEFAULT 0,
    p_sheet_name IN VARCHAR2 DEFAULT NULL
) AS
    v_blob         BLOB;
    v_filename     VARCHAR2(400);
    v_profile_clob CLOB;

    -- Sanitize column names (same as existing logic)
    FUNCTION sanitize_column_name(p_name IN VARCHAR2) RETURN VARCHAR2 IS
        v_name VARCHAR2(4000);
    BEGIN
        v_name := REGEXP_REPLACE(p_name, '[^A-Za-z0-9]', '_');
        v_name := REGEXP_REPLACE(v_name, '_+', '_');
        v_name := REGEXP_REPLACE(v_name, '^_+|_+$', '');
        RETURN UPPER(v_name);
    END;
BEGIN
    -- Get file content
    SELECT blob_content, filename
    INTO v_blob, v_filename
    FROM apex_application_temp_files
    WHERE name = p_file_name;

    -- Get profile with sheet/skip configuration
    SELECT apex_data_parser.discover(
               p_content         => v_blob,
               p_file_name       => v_filename,
               p_skip_rows       => p_skip_rows,
               p_xlsx_sheet_name => p_sheet_name
           )
    INTO v_profile_clob
    FROM dual;

    -- Truncate/create collection
    IF apex_collection.collection_exists('UR_FILE_DATA_PROFILES') THEN
        apex_collection.truncate_collection('UR_FILE_DATA_PROFILES');
    ELSE
        apex_collection.create_collection('UR_FILE_DATA_PROFILES');
    END IF;

    -- Populate from profile columns
    FOR col IN (
        SELECT column_name,
               CASE data_type
                   WHEN 1 THEN 'VARCHAR2'
                   WHEN 2 THEN 'NUMBER'
                   WHEN 3 THEN 'DATE'
                   ELSE 'VARCHAR2'
               END AS data_type_name
        FROM TABLE(apex_data_parser.get_columns(v_profile_clob))
        ORDER BY column_position
    ) LOOP
        apex_collection.add_member(
            p_collection_name => 'UR_FILE_DATA_PROFILES',
            p_c001            => sanitize_column_name(col.column_name),
            p_c002            => col.data_type_name,
            p_c005            => 'Maps To'  -- Default mapping type
        );
    END LOOP;
END;
```

---

## UI Layout Recommendation

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Load Template                                            │
├─────────────────────────────────────────────────────────────┤
│ [File Upload Dropzone - P1002_FILE_LOAD]                    │
│                                                             │
│ ┌─── Parsing Controls ───────────────────────────────────┐  │
│ │ Skip Rows: [0    ▼]    Excel Sheet: [Sheet1        ▼]  │  │
│ └────────────────────────────────────────────────────────┘  │
│                                                             │
│ ┌─── File Info (existing Report region) ─────────────────┐  │
│ │ ID: 12345  |  Filename: data.xlsx  |  Records: 150     │  │
│ └────────────────────────────────────────────────────────┘  │
│                                                             │
│ ┌─── Data Preview (20 cols with horizontal scroll) ──────┐  │
│ │ Col1  │ Col2  │ Col3  │ ... │ Col20 │ ← scroll →       │  │
│ ├───────┼───────┼───────┼─────┼───────┼──────────────────┤  │
│ │ Val1  │ Val2  │ Val3  │ ... │ Val20 │                  │  │
│ │ ...50 rows max...                                      │  │
│ └────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Important Considerations

### 1. Oracle APEX Version Compatibility
- `$.worksheets` JSON path requires APEX 19.2+
- Alternative for older versions: Use `DBMS_LOB` to parse Excel XML structure

### 2. Performance
- Limit preview rows (50-100 max)
- Use `p_max_rows` parameter in `apex_data_parser.parse()`
- Consider lazy loading for large files

### 3. Column Count Variability
- Files may have varying column counts
- Use generic col001-col050 approach or dynamic SQL
- Consider showing only first 10-15 columns in preview with horizontal scroll

### 4. Error Handling
- Invalid skip row values (exceeding file rows)
- Non-existent sheet names
- Corrupted files

---

## Files to Modify

1. **Page 1002 YAML** - Add new items, regions, and dynamic actions
2. **Database** - Create `populate_file_preview` procedure
3. **Existing Process** - Update `Create File Profile and Collection Loading`

---

## Confirmed Requirements

1. **Preview Rows**: 50 rows max
2. **Column Display**: 20 columns with horizontal scroll bar
3. **Refresh Behavior**: Auto-refresh on Skip Rows or Sheet Name change
4. **Header Logic**: Skip Rows = 0 → Row 1 is header; Skip Rows = 2 → Row 3 is header
5. **Step 2 Integration**: Column metadata (`UR_FILE_DATA_PROFILES`) auto-updates when preview refreshes

---

## Troubleshooting: Initial Load Issue

### Problem
"Specified worksheet does not exist in XLSX file" error on initial page load, even though:
- LOV correctly returns `sheet_file_name` (e.g., "sheet1.xml")
- Alert confirms correct values when changing sheets
- Skip rows works fine with same pattern

### Root Cause
`P1002_SHEET_NAME` is NULL/empty on initial load before the LOV populates.

### Solution
Use COALESCE to default to first sheet when the page item is NULL:

```sql
p_xlsx_sheet_name => COALESCE(
    NULLIF(:P1002_SHEET_NAME, ''),
    (SELECT MIN(sheet_file_name) KEEP (DENSE_RANK FIRST ORDER BY sheet_sequence)
     FROM TABLE(apex_data_parser.get_xlsx_worksheets(
         p_content => (SELECT blob_content
                       FROM apex_application_temp_files
                       WHERE name = :P1002_FILE_LOAD)
     ))
    )
)
```

This ensures:
1. If `P1002_SHEET_NAME` has a value, use it
2. If it's empty string, convert to NULL via NULLIF
3. If NULL, fetch the first sheet from the workbook automatically
