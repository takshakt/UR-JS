# Plan: Add CALCULATED_OCCUPANCY to Algorithm Evaluation Results

## Overview
Add CALCULATED_OCCUPANCY percentage as a separate field in the result object returned by `ALGO_EVALUATOR_PKG.EVALUATE` function. The occupancy will be calculated for all stay dates, regardless of whether occupancy is used as a condition in the algorithm.

## User Requirements

1. **Runtime Discovery**: Query CALCULATED_OCCUPANCY attribute at runtime (not dependent on conditions)
2. **Type Extension**: Add new field to `t_result_rec_obj` type
3. **Separate Field**: Occupancy appears as its own field in result object (not in JSON)
4. **All Dates**: Calculate for all stay dates in the algorithm/strategy
5. **NULL Handling**: Pass NULL for dates where occupancy data is not available

## Current Structure

### Existing Types (Need to be Updated)

**Current `t_result_rec_obj`** (5 fields):
```sql
CREATE OR REPLACE TYPE t_result_rec_obj AS OBJECT (
    algo_name VARCHAR2(255),
    stay_date DATE,
    day_of_week VARCHAR2(3),
    evaluated_price VARCHAR2(4000),
    applied_rule CLOB
);
```

**Current `t_result_tab_obj`**:
```sql
CREATE OR REPLACE TYPE t_result_tab_obj AS TABLE OF t_result_rec_obj;
```

### Current PIPE ROW Usage

**Line 505** (Free text result):
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), l_text_result, l_applied_rule_json));
```

**Line 536** (Numeric result):
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), TO_CHAR(l_eval_result), l_applied_rule_json));
```

**Line 590** (Failure details):
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), NULL, l_failure_details_json));
```

**Line 592** (No applicable rules):
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), NULL, '[{"note":"No Applicable Rules..."}]'));
```

**Line 197** (Error):
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, NULL, NULL, NULL, 'ERROR: Algorithm or Version not found.'));
```

**Line 606** (Fatal error):
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, NULL, NULL, NULL, 'FATAL ERROR: ' || SQLERRM || '...'));
```

## New Type Definitions

### Updated `t_result_rec_obj` (6 fields)

```sql
CREATE OR REPLACE TYPE t_result_rec_obj AS OBJECT (
    algo_name VARCHAR2(255),
    stay_date DATE,
    day_of_week VARCHAR2(3),
    calculated_occupancy NUMBER,        -- NEW FIELD (position 4)
    evaluated_price VARCHAR2(4000),     -- Moved to position 5
    applied_rule CLOB                   -- Moved to position 6
);
/
```

### Updated `t_result_tab_obj` (No Change)

```sql
CREATE OR REPLACE TYPE t_result_tab_obj AS TABLE OF t_result_rec_obj;
/
```

### Type Compilation Order

**IMPORTANT**: Types must be created in this order:

1. Drop existing types (reverse order):
   ```sql
   DROP TYPE t_result_tab_obj;
   DROP TYPE t_result_rec_obj;
   ```

2. Create new types:
   ```sql
   CREATE OR REPLACE TYPE t_result_rec_obj AS OBJECT (...);
   CREATE OR REPLACE TYPE t_result_tab_obj AS TABLE OF t_result_rec_obj;
   ```

3. Recompile package body:
   ```sql
   ALTER PACKAGE ALGO_EVALUATOR_PKG COMPILE BODY;
   ```

## Implementation Changes in Algo_Evaluation_PKG_Body

### File Location
`/home/coder/ur-js/Algo_Evaluation_PKG_Body`

### Change 1: Add Variable Declarations (After line 161)

**Location**: Inside `EVALUATE` function, after `l_effective_algo_id` declaration

```sql
-- ++ CALCULATED_OCCUPANCY VARIABLES
l_calculated_occupancy   NUMBER := NULL;
l_calc_occ_attr_id       VARCHAR2(255) := NULL;
-- / CALCULATED_OCCUPANCY VARIABLES
```

### Change 2: Query CALCULATED_OCCUPANCY Attribute ID (After line 167)

**Location**: After `l_hotel_id` is retrieved from `ur_algos`

```sql
-- ++ QUERY CALCULATED_OCCUPANCY ATTRIBUTE ID
BEGIN
    SELECT RAWTOHEX(id)
    INTO l_calc_occ_attr_id
    FROM ur_algo_attributes
    WHERE hotel_id = l_hotel_id
      AND attribute_qualifier = 'CALCULATED_OCCUPANCY'
      AND type = 'C'
      AND ROWNUM = 1;

    log_debug('Found CALCULATED_OCCUPANCY attribute for hotel: ' || l_calc_occ_attr_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        l_calc_occ_attr_id := NULL;
        log_debug('CALCULATED_OCCUPANCY attribute not found for hotel: ' || RAWTOHEX(l_hotel_id));
END;
-- / QUERY CALCULATED_OCCUPANCY ATTRIBUTE ID
```

### Change 3: Load CALCULATED_OCCUPANCY into Staged Data (After line 220)

**Location**: After the loop that loads attributes into `l_staged_data`

```sql
-- ++ LOAD CALCULATED_OCCUPANCY DATA
IF l_calc_occ_attr_id IS NOT NULL THEN
    -- Initialize collection for this attribute
    l_staged_data(l_calc_occ_attr_id) := t_result_tab();

    -- Load attribute values for all dates
    FOR attr_rec IN (
        SELECT * FROM TABLE(ur_utils.GET_ATTRIBUTE_VALUE(p_attribute_id => l_calc_occ_attr_id))
    ) LOOP
        l_staged_data(l_calc_occ_attr_id).EXTEND;
        l_staged_data(l_calc_occ_attr_id)(l_staged_data(l_calc_occ_attr_id).COUNT) := attr_rec;
    END LOOP;

    log_debug('Loaded CALCULATED_OCCUPANCY data: ' || l_staged_data(l_calc_occ_attr_id).COUNT || ' date records');
END IF;
-- / LOAD CALCULATED_OCCUPANCY DATA
```

### Change 4: Calculate Occupancy for Current Date (Before each PIPE ROW)

**Location**: Before each PIPE ROW statement (lines 505, 536, 590, 592)

**Add this block before PIPE ROW calls that have a valid stay_date**:

```sql
-- ++ CALCULATE OCCUPANCY FOR THIS DATE
l_calculated_occupancy := NULL;
IF l_calc_occ_attr_id IS NOT NULL
   AND l_staged_data.EXISTS(l_calc_occ_attr_id)
   AND v_stay_date IS NOT NULL THEN
    l_calculated_occupancy := get_value_for_date(l_staged_data(l_calc_occ_attr_id), v_stay_date);
    log_debug('... Calculated occupancy for ' || TO_CHAR(v_stay_date, 'YYYY-MM-DD') || ': ' || NVL(TO_CHAR(l_calculated_occupancy), 'NULL'));
END IF;
-- / CALCULATE OCCUPANCY FOR THIS DATE
```

### Change 5: Update All PIPE ROW Statements

**Original Format** (5 parameters):
```sql
PIPE ROW(t_result_rec_obj(algo_name, stay_date, day_of_week, evaluated_price, applied_rule));
```

**New Format** (6 parameters):
```sql
PIPE ROW(t_result_rec_obj(algo_name, stay_date, day_of_week, calculated_occupancy, evaluated_price, applied_rule));
```

#### Update Line 505 (Free text result):

**Before**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), l_text_result, l_applied_rule_json));
```

**After**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), l_calculated_occupancy, l_text_result, l_applied_rule_json));
```

#### Update Line 536 (Numeric result):

**Before**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), TO_CHAR(l_eval_result), l_applied_rule_json));
```

**After**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), l_calculated_occupancy, TO_CHAR(l_eval_result), l_applied_rule_json));
```

#### Update Line 590 (Failure details):

**Before**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), NULL, l_failure_details_json));
```

**After**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), l_calculated_occupancy, NULL, l_failure_details_json));
```

#### Update Line 592 (No applicable rules):

**Before**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), NULL, '[{"note":"No Applicable Rules..."}]'));
```

**After**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), l_calculated_occupancy, NULL, '[{"note":"No Applicable Rules..."}]'));
```

#### Update Line 197 (Error - no stay_date):

**Before**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, NULL, NULL, NULL, 'ERROR: Algorithm or Version not found.'));
```

**After**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, NULL, NULL, NULL, NULL, 'ERROR: Algorithm or Version not found.'));
```

#### Update Line 606 (Fatal error - no stay_date):

**Before**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, NULL, NULL, NULL, 'FATAL ERROR: ' || SQLERRM || '...'));
```

**After**:
```sql
PIPE ROW(t_result_rec_obj(l_algo_name, NULL, NULL, NULL, NULL, 'FATAL ERROR: ' || SQLERRM || '...'));
```

## Summary of Changes

### Type Definitions (User to execute separately)

1. **Drop types** (reverse order):
   - `DROP TYPE t_result_tab_obj;`
   - `DROP TYPE t_result_rec_obj;`

2. **Create new types**:
   - `t_result_rec_obj` with 6 fields (add `calculated_occupancy NUMBER` at position 4)
   - `t_result_tab_obj` (unchanged, just recreate)

### Package Body Changes

| Line(s) | Change | Description |
|---------|--------|-------------|
| ~161 | Add | Declare `l_calculated_occupancy` and `l_calc_occ_attr_id` variables |
| ~167 | Add | Query CALCULATED_OCCUPANCY attribute ID using hotel_id |
| ~220 | Add | Load CALCULATED_OCCUPANCY data into `l_staged_data` |
| ~504 | Add | Calculate occupancy for current date (before PIPE ROW) |
| 505 | Modify | Add `l_calculated_occupancy` parameter to PIPE ROW |
| ~535 | Add | Calculate occupancy for current date (before PIPE ROW) |
| 536 | Modify | Add `l_calculated_occupancy` parameter to PIPE ROW |
| ~589 | Add | Calculate occupancy for current date (before PIPE ROW) |
| 590 | Modify | Add `l_calculated_occupancy` parameter to PIPE ROW |
| 592 | Modify | Add `l_calculated_occupancy` parameter to PIPE ROW |
| 197 | Modify | Add NULL for occupancy (error case, no stay_date) |
| 606 | Modify | Add NULL for occupancy (fatal error, no stay_date) |

## Expected Result Structure

### Before (5 fields)
```
ALGO_NAME       | STAY_DATE   | DAY_OF_WEEK | EVALUATED_PRICE | APPLIED_RULE
----------------|-------------|-------------|-----------------|-------------
"Weekend Rule"  | 2025-12-15  | "Sun"       | "150"           | {...}
```

### After (6 fields)
```
ALGO_NAME       | STAY_DATE   | DAY_OF_WEEK | CALCULATED_OCCUPANCY | EVALUATED_PRICE | APPLIED_RULE
----------------|-------------|-------------|----------------------|-----------------|-------------
"Weekend Rule"  | 2025-12-15  | "Sun"       | 85.5                 | "150"           | {...}
"Weekend Rule"  | 2025-12-16  | "Mon"       | NULL                 | "140"           | {...}
```

## NULL Handling Scenarios

| Scenario | `calculated_occupancy` Value |
|----------|------------------------------|
| CALCULATED_OCCUPANCY attribute exists for hotel + data available for date | Actual percentage (e.g., 85.5) |
| CALCULATED_OCCUPANCY attribute exists for hotel + NO data for date | NULL |
| CALCULATED_OCCUPANCY attribute does NOT exist for hotel | NULL (all dates) |
| Error case (no stay_date) | NULL |

## Data Flow

```
1. EVALUATE function called with algo_id
   ↓
2. Retrieve hotel_id from ur_algos
   ↓
3. Query CALCULATED_OCCUPANCY attribute ID
   (WHERE hotel_id = X AND qualifier = 'CALCULATED_OCCUPANCY' AND type = 'C')
   ↓
4. Load CALCULATED_OCCUPANCY data into l_staged_data
   (Using ur_utils.GET_ATTRIBUTE_VALUE)
   ↓
5. For each stay_date in evaluation:
   a. Calculate occupancy: get_value_for_date(l_staged_data[attr_id], stay_date)
   b. Returns NUMBER or NULL
   ↓
6. PIPE ROW with 6 parameters including occupancy
```

## Testing Checklist

### Scenario 1: Hotel WITH CALCULATED_OCCUPANCY
- [ ] Query finds CALCULATED_OCCUPANCY attribute ID
- [ ] Attribute data loads into `l_staged_data`
- [ ] Debug log shows: "Found CALCULATED_OCCUPANCY attribute..."
- [ ] Debug log shows: "Loaded CALCULATED_OCCUPANCY data: N date records"
- [ ] For each stay_date:
  - [ ] If data exists: `calculated_occupancy` has numeric value
  - [ ] If data missing: `calculated_occupancy` is NULL
  - [ ] Debug log shows: "Calculated occupancy for YYYY-MM-DD: VALUE or NULL"

### Scenario 2: Hotel WITHOUT CALCULATED_OCCUPANCY
- [ ] Query returns NO_DATA_FOUND
- [ ] Debug log shows: "CALCULATED_OCCUPANCY attribute not found for hotel..."
- [ ] `l_calc_occ_attr_id` remains NULL
- [ ] No data loaded into `l_staged_data`
- [ ] For all stay_dates:
  - [ ] `calculated_occupancy` is NULL

### Scenario 3: Error Cases
- [ ] Algorithm not found: Returns NULL for occupancy
- [ ] Fatal error: Returns NULL for occupancy

### Scenario 4: Occupancy as Condition
- [ ] Algorithm has occupancy condition enabled
- [ ] CALCULATED_OCCUPANCY still loaded (independent of condition)
- [ ] Occupancy appears in result for all dates
- [ ] Occupancy condition evaluation still works (unchanged)

### Scenario 5: No Occupancy Condition
- [ ] Algorithm has NO occupancy condition
- [ ] CALCULATED_OCCUPANCY still loaded and calculated
- [ ] Occupancy appears in result for all dates

## CALCULATED_OCCUPANCY Formula

From `UR_UTILS.sql` (lines 5236):
```sql
'ROUND((#ROOM_NIGHTS# / (#UR_HOTELS.CAPACITY# - #OUT_OF_ORDER_ROOMS#)) * 100)'
```

**Components**:
- `ROOM_NIGHTS`: Attribute for rooms sold per date
- `UR_HOTELS.CAPACITY`: Total room capacity for the hotel
- `OUT_OF_ORDER_ROOMS`: Rooms unavailable per date
- **Result**: Percentage occupancy (0-100), rounded to integer

## Deployment Steps

### Step 1: Update Type Definitions (User)
Execute in SQL*Plus/SQLcl:
```sql
-- Drop existing types
DROP TYPE t_result_tab_obj;
DROP TYPE t_result_rec_obj;

-- Create new types
CREATE OR REPLACE TYPE t_result_rec_obj AS OBJECT (
    algo_name VARCHAR2(255),
    stay_date DATE,
    day_of_week VARCHAR2(3),
    calculated_occupancy NUMBER,
    evaluated_price VARCHAR2(4000),
    applied_rule CLOB
);
/

CREATE OR REPLACE TYPE t_result_tab_obj AS TABLE OF t_result_rec_obj;
/
```

### Step 2: Update Package Body
Apply all changes to `Algo_Evaluation_PKG_Body` as outlined above.

### Step 3: Compile Package
```sql
ALTER PACKAGE ALGO_EVALUATOR_PKG COMPILE BODY;
```

### Step 4: Verify
```sql
-- Check package is valid
SELECT status FROM user_objects WHERE object_name = 'ALGO_EVALUATOR_PKG';

-- Test evaluation
SELECT * FROM TABLE(ALGO_EVALUATOR_PKG.EVALUATE(p_algo_id => 'YOUR_ALGO_ID'));
```

### Step 5: Update Frontend (if needed)
If the frontend consumes this result set, update to handle the new 6-field structure.

## Rollback Plan

If issues occur:

1. **Revert package body** to previous version
2. **Revert type definitions**:
   ```sql
   DROP TYPE t_result_tab_obj;
   DROP TYPE t_result_rec_obj;

   CREATE OR REPLACE TYPE t_result_rec_obj AS OBJECT (
       algo_name VARCHAR2(255),
       stay_date DATE,
       day_of_week VARCHAR2(3),
       evaluated_price VARCHAR2(4000),
       applied_rule CLOB
   );
   /

   CREATE OR REPLACE TYPE t_result_tab_obj AS TABLE OF t_result_rec_obj;
   /
   ```
3. **Recompile package**

## Notes

- **Non-Breaking for Other Code**: This change only affects consumers of `ALGO_EVALUATOR_PKG.EVALUATE` function
- **Performance Impact**: One additional attribute query and load per evaluation (minimal)
- **Backward Compatibility**: Breaking change - requires frontend updates if UI consumes this data
- **Graceful Degradation**: Returns NULL if CALCULATED_OCCUPANCY not available

---

**Status**: Ready for Implementation
**Priority**: Medium
**Estimated Time**: 30 minutes (code changes) + Testing
