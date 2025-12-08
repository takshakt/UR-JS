# Plan: Add Calculated Attributes to AJX_GET_HOTEL_TEMPLATES

## Current Understanding

The file [AJX_GET_HOTEL_TEMPLATES](AJX_GET_HOTEL_TEMPLATES) currently outputs a JSON response containing:
- Hotel name and key
- Templates (arrays of column names from template definitions)
- **Strategies** array (line 45-58) - algorithm names formatted as "name(Strategy_Column)"
- Price_Override array (line 75-82)
- Hotel_Occupancy array (line 85-87)

The user wants to add a new array section containing calculated attributes (type='C') from `ur_algo_attributes` table.

## Query to Execute
```sql
SELECT id, name
FROM ur_algo_attributes
WHERE hotel_id = '4523E60B56C22037E063B85A000A9A17'
  AND type = 'C'
ORDER BY id DESC
```

Expected output:
- Hotel Events
- Group Price Override
- Corporate Price Override
- Public Price Override
- Occupancy %

## User Requirements (Confirmed)

1. **Array name**: `Global_Attributes`
2. **Output format**: Array of objects with `{id, name}` pairs (IDs needed for data fetching in DynamicReportJS.js)
3. **Position**: Right after Strategies array (after line 58, before Price_Override)

## Critical Context from DynamicReportJS.js Analysis

The attributes are used in [DynamicReportJS.js](DynamicReportJS.js) to:
1. **Populate shuttle component** with available columns (lines 901-990)
2. **Generate dynamic SQL** using attribute IDs to fetch actual values (lines 1403-1554)
3. **Parse column metadata** to extract template name, column name, and importantly the **attribute ID** (lines 1637-1698)

**Key Finding**: Unlike Strategies/Price_Override which only use names, Global_Attributes will need both ID and name because:
- The **name** is displayed in the shuttle UI as `"Occupancy % ( Global_Attributes )"`
- The **ID** is used in SQL generation to query `ur_algo_attributes` table for actual attribute values

Similar pattern exists for:
- **Strategies**: Uses strategy name in `WHERE a.name LIKE '${sc.col_name}'`
- **Price_Override**: Uses type name in `WHERE upper(type) = upper('${sc.col_name}')`
- **Global_Attributes**: Will need to use attribute ID in `WHERE attribute_id = '${gc.attribute_id}'`

## Implementation Plan

### File to Modify
- [AJX_GET_HOTEL_TEMPLATES](AJX_GET_HOTEL_TEMPLATES)

### Changes Required

**Location**: Insert new code block after line 58 (after `APEX_JSON.CLOSE_ARRAY; -- Strategies`)

**Code to Add**:
```plsql
APEX_JSON.OPEN_ARRAY('Global_Attributes');
FOR rec_attr IN (
    SELECT id, name
      FROM ur_algo_attributes
     WHERE hotel_id = rec_hotel.id
       AND type = 'C'
     ORDER BY id DESC
) LOOP
    APEX_JSON.OPEN_OBJECT;
    APEX_JSON.WRITE('id', rec_attr.id);
    APEX_JSON.WRITE('name', rec_attr.name);
    APEX_JSON.CLOSE_OBJECT;
END LOOP;
APEX_JSON.CLOSE_ARRAY; -- Global_Attributes
```

### Implementation Details

1. **Open the array** named `Global_Attributes`
2. **Query `ur_algo_attributes`** table with:
   - Filter: `hotel_id = rec_hotel.id` (uses the hotel ID from the outer loop context)
   - Filter: `type = 'C'` (calculated attributes only)
   - Sort: `ORDER BY id DESC` (as per user's sample query)
   - **Return both ID and name** (not formatted, raw values)
3. **Loop through results** and write each as a JSON object with `{id, name}` structure
4. **Close the array**

### Expected Output Structure

The JSON will now include (between Strategies and Price_Override):
```json
"Global_Attributes": [
    {"id": "4523F861499128C2E063B85A000ABC45", "name": "Hotel Events"},
    {"id": "4523F861499028C2E063B85A000ABC45", "name": "Group Price Override"},
    {"id": "4523F861498F28C2E063B85A000ABC45", "name": "Corporate Price Override"},
    {"id": "4523F861498E28C2E063B85A000ABC45", "name": "Public Price Override"},
    {"id": "4523F861498D28C2E063B85A000ABC45", "name": "Occupancy %"}
]
```

## JavaScript Integration Changes

### File to Modify
- [DynamicReportJS.js](DynamicReportJS.js)

### Change 1: Add Global_Attributes to Shuttle Display

**Location**: After line 918 in `handleTemplateSelection()` function

**Current code** (line 919):
```javascript
//  formattedArray.push(...algoArray);
```

**Replace with**:
```javascript
// Add Global_Attributes to the shuttle
const hotelKey = selectedHotel.toLowerCase().replace(/\s+/g, '');
const globalAttrs = hotelData[hotelKey].Global_Attributes || [];
formattedArray.push(...globalAttrs.map(a => `${a.name} ( Global_Attributes )`));
```

**Purpose**: This will add all calculated attributes to the shuttle UI, formatted as "Occupancy % ( Global_Attributes )"

---

### Change 2: Handle Global_Attributes in Column Parsing

**Location**: In `generateJson()` function, after line 1660 (after Hotel_Occupancy handling)

**Add new conditional block**:
```javascript
// Handle Global_Attributes - calculated attributes from ur_algo_attributes
if (tempName === 'Global_Attributes') {
    // Extract the attribute name from the formatted string
    const attrName = item.dataset.value.split('(')[0].trim();

    // Find the attribute ID from hotelData
    const hotelKey = selectedHotel.toLowerCase().replace(/\s+/g, '');
    const globalAttrs = hotelData[hotelKey].Global_Attributes || [];
    const attrMatch = globalAttrs.find(a => a.name === attrName);

    return {
        col_name: attrName,
        temp_name: 'Global_Attributes',
        db_object_name: 'UR_ALGO_ATTRIBUTES',
        alias_name: attrName,
        attribute_id: attrMatch ? attrMatch.id : null,
        hotel_id: hotelLov.options[hotelLov.selectedIndex].value,
    };
}
```

**Purpose**: This extracts the attribute ID from the loaded data and stores it in the column metadata for SQL generation.

---

### Change 3: Filter Global_Attributes in SQL Generation

**Location**: In `buildSQLFromJSON()` function, line 1403

**Current code**:
```javascript
if (col.temp_name !== "Strategy_Column" && col.temp_name !== "Price_Override" && col.temp_name !== "Hotel_Occupancy") {
```

**Replace with**:
```javascript
if (col.temp_name !== "Strategy_Column" &&
    col.temp_name !== "Price_Override" &&
    col.temp_name !== "Hotel_Occupancy" &&
    col.temp_name !== "Global_Attributes") {
```

**Purpose**: Exclude Global_Attributes from normal table processing since they need special handling.

---

### Change 4: Collect Global_Attributes Columns

**Location**: After line 1420 (after hotelOccupancyCols declaration)

**Add new line**:
```javascript
const globalAttrCols = data.selectedColumns.filter(c => c.temp_name === "Global_Attributes");
```

**Purpose**: Collect all selected Global_Attributes columns for CTE generation.

---

### Change 5: Generate CTE for Global_Attributes

**Location**: After line 1492 (after Hotel_Occupancy CTE generation)

**Add new code block**:
```javascript
// Build CTE for each Global_Attribute (uses attribute_id to fetch calculated values)
globalAttrCols.forEach((gc, i) => {
    const alias = `ga${i + 1}_rn`;
    ctes.push(`${alias} AS (
  SELECT
      hotel_id,
      attribute_value,
      1 as rn
  FROM (
      SELECT
          hotel_id,
          ur_utils.GET_ATTRIBUTE_VALUE(
              p_attribute_id => '${gc.attribute_id}',
              p_hotel_id => '${hotelId}',
              p_stay_date => SYSDATE,
              p_booking_date => SYSDATE
          ) AS attribute_value
      FROM DUAL
  )
)`);
});
```

**Purpose**: Generate a CTE that calls the `ur_utils.GET_ATTRIBUTE_VALUE` function to retrieve the calculated attribute value using the attribute ID.

**Note**: This assumes the attribute values are single calculated values. If they vary by date, we may need a different query structure.

---

### Change 6: Add Global_Attributes to SELECT Clause

**Location**: After line 1528 (after Hotel_Occupancy SELECT columns)

**Add new code block**:
```javascript
// Add Global_Attributes columns
globalAttrCols.forEach((gc, i) => {
    const alias = `ga${i + 1}_rn`;
    selectCols.push(`${alias}.attribute_value AS "${gc.col_name} - Global_Attributes"`);
});
```

**Purpose**: Add the attribute values to the SELECT clause with proper column aliases.

---

### Change 7: Add Global_Attributes Aliases to JOIN Logic

**Location**: Line 1533

**Current code**:
```javascript
const allAliases = [...aliases, ...strategyCols.map((_, i) => `s${i + 1}_rn`), ...price_or_cols.map((_, i) => `por${i + 1}_rn`), ...hotelOccupancyCols.map((_, i) => `occ${i + 1}_rn`)];
```

**Replace with**:
```javascript
const allAliases = [
    ...aliases,
    ...strategyCols.map((_, i) => `s${i + 1}_rn`),
    ...price_or_cols.map((_, i) => `por${i + 1}_rn`),
    ...hotelOccupancyCols.map((_, i) => `occ${i + 1}_rn`),
    ...globalAttrCols.map((_, i) => `ga${i + 1}_rn`)
];
```

**Purpose**: Include Global_Attributes CTEs in the join logic.

---

### Change 8: Handle Global_Attributes in JOIN Clauses

**Location**: Line 1543-1544

**Current code**:
```javascript
const joinType = (alias.startsWith('s') || alias.startsWith('occ')) ? ' LEFT ' : 'FULL OUTER';
```

**Replace with**:
```javascript
const joinType = (alias.startsWith('s') || alias.startsWith('occ') || alias.startsWith('ga')) ? ' LEFT ' : 'FULL OUTER';
```

**And update line 1546**:

**Current code**:
```javascript
if (alias.startsWith('occ')) {
```

**Replace with**:
```javascript
if (alias.startsWith('occ') || alias.startsWith('ga')) {
```

**Purpose**: Use LEFT JOIN for Global_Attributes (like Hotel_Occupancy) and join only on hotel_id since they're single values per hotel.

## Summary of Changes

### Files Modified: 2
1. **[AJX_GET_HOTEL_TEMPLATES](AJX_GET_HOTEL_TEMPLATES)** - 1 change (add Global_Attributes array)
2. **[DynamicReportJS.js](DynamicReportJS.js)** - 8 changes (integrate Global_Attributes throughout)

### Key Implementation Points

1. **Data Structure**: Global_Attributes will be returned as an array of objects with `{id, name}` pairs
2. **Display Format**: Attributes will appear in shuttle as `"Occupancy % ( Global_Attributes )"`
3. **SQL Generation**: Uses `ur_utils.GET_ATTRIBUTE_VALUE()` function with attribute_id to fetch calculated values
4. **Join Strategy**: LEFT JOIN on hotel_id only (single value per hotel, like Hotel_Occupancy)

### Testing Considerations

**Backend (AJX_GET_HOTEL_TEMPLATES)**:
- Verify the query returns expected attributes with both ID and name for the test hotel_id
- Confirm the array appears in correct position in JSON output (after Strategies, before Price_Override)
- Ensure no syntax errors in PL/SQL block
- Test with hotels that have 0 calculated attributes (should return empty array)
- Validate IDs are valid UUIDs/GUIDs matching the sample format

**Frontend (DynamicReportJS.js)**:
- Verify Global_Attributes appear in the left shuttle (available columns)
- Test moving attributes between left/right shuttles
- Confirm attribute IDs are correctly extracted and stored in column metadata
- Verify generated SQL includes correct CTE for each selected Global_Attribute
- Test SQL execution with `ur_utils.GET_ATTRIBUTE_VALUE()` function
- Ensure report displays attribute values correctly

### Expected SQL Output Example

When a user selects "Occupancy %" from Global_Attributes, the generated SQL will include:

```sql
WITH ...,
ga1_rn AS (
  SELECT
      hotel_id,
      attribute_value,
      1 as rn
  FROM (
      SELECT
          hotel_id,
          ur_utils.GET_ATTRIBUTE_VALUE(
              p_attribute_id => '4523F861498D28C2E063B85A000ABC45',
              p_hotel_id => 'hotel_id_here',
              p_stay_date => SYSDATE,
              p_booking_date => SYSDATE
          ) AS attribute_value
      FROM DUAL
  )
)
SELECT ...,
       ga1_rn.attribute_value AS "Occupancy % - Global_Attributes"
FROM ...
LEFT JOIN ga1_rn ON t1_rn.hotel_id = ga1_rn.hotel_id
...
```
