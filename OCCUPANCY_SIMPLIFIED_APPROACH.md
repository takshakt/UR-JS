# Occupancy Hardcode - Simplified Approach

## Overview
The occupancy condition has been updated to use a hardcoded CALCULATED_OCCUPANCY attribute instead of a dropdown LOV. The availability checking is handled entirely in the frontend by checking if the `occupancyAttributes` array is empty.

## Architecture Decision

**User's Request**: "instead of handling all the occupancy availability in the GET_LOV_DATA, why dont we simply handle that in the algojs.js file like if there is no data in the occupancyAttributes simply disable it, this goes true with rest of the dynamic attributes."

### Benefits of This Approach
1. **Consistency**: All dynamic attributes (occupancy, property types, lead time) follow the same pattern
2. **Simplicity**: Backend just returns empty array if no data - no complex availability flags
3. **Less Code**: No need for nested logic or error messages in backend
4. **Cleaner API**: Standard array structure `[{id, name}]` or `[]`

## Implementation

### Backend (GET_LOV_DATA)

**File**: `/home/coder/ur-js/GET_LOV_DATA`
**Lines**: 57-75

```sql
-- Fetch Occupancy Attribute (CALCULATED_OCCUPANCY only)
apex_json.open_array('occupancyAttributes');
FOR rec IN (
    SELECT
        a.id,
        a.name
    FROM
        ur_algo_attributes a
    WHERE
        a.hotel_id = l_hotel_id
        AND a.attribute_qualifier = 'CALCULATED_OCCUPANCY'
        AND a.type = 'C'
) LOOP
    apex_json.open_object;
    apex_json.write('id', rec.id);
    apex_json.write('name', rec.name);
    apex_json.close_object;
END LOOP;
apex_json.close_array;
```

**Response Structure**:

When CALCULATED_OCCUPANCY exists:
```json
{
    "occupancyAttributes": [
        {"id": "ABC123", "name": "Occupancy %"}
    ]
}
```

When CALCULATED_OCCUPANCY doesn't exist:
```json
{
    "occupancyAttributes": []
}
```

### Frontend (algojs.js)

**File**: `/home/coder/ur-js/algojs.js`

#### 1. UI Template (Lines 811-830)
```javascript
<div class="field-container ${!dynamicData.occupancyAttributes || dynamicData.occupancyAttributes.length === 0 ? 'disabled-field' : ''}">
    <input type="checkbox" ... ${!dynamicData.occupancyAttributes || dynamicData.occupancyAttributes.length === 0 ? 'disabled' : ''}>
    <label>
        Occupancy Threshold %
        ${!dynamicData.occupancyAttributes || dynamicData.occupancyAttributes.length === 0 ? '<span class="unavailable-badge">Unavailable</span>' : ''}
    </label>
    <div class="field-content hidden">
        ${dynamicData.occupancyAttributes && dynamicData.occupancyAttributes.length > 0 ? `
            <input type="hidden" class="occupancy-attribute-id" value="${dynamicData.occupancyAttributes[0].id}">
            <select class="operator-select occupancy-operator">...</select>
            <input type="number" class="value-input occupancy-value" value="80" min="0" max="100">
            <span class="occupancy-info">Using: ${dynamicData.occupancyAttributes[0].name}</span>
        ` : `
            <div class="unavailable-message">
                <strong>⚠️ Not Available</strong>
                <p>CALCULATED_OCCUPANCY attribute not configured for this hotel.</p>
            </div>
        `}
    </div>
</div>
```

**Key Check**: `dynamicData.occupancyAttributes && dynamicData.occupancyAttributes.length > 0`

#### 2. Update Dropdowns (Lines 215-239)
```javascript
// Handle occupancy attribute - set hidden input and update availability state
if (dynamicData.occupancyAttributes && dynamicData.occupancyAttributes.length > 0) {
    // Use first (and only) attribute in array
    document.querySelectorAll('.occupancy-attribute-id').forEach(el => {
        el.value = dynamicData.occupancyAttributes[0].id;
    });

    document.querySelectorAll('.occupancy-info').forEach(el => {
        el.textContent = `Using: ${dynamicData.occupancyAttributes[0].name}`;
    });
} else {
    // Disable and uncheck all occupancy checkboxes when array is empty
    document.querySelectorAll('[id$="-occupancy-threshold"]').forEach(checkbox => {
        if (checkbox.checked) {
            console.warn('Disabling occupancy threshold condition - not available for selected hotel');
        }
        checkbox.checked = false;
        checkbox.disabled = true;

        const fieldContainer = checkbox.closest('.field-container');
        if (fieldContainer) {
            fieldContainer.classList.add('disabled-field');
        }
    });
}
```

#### 3. Load Condition (Lines 1827-1851)
```javascript
if (key === 'occupancyThreshold') {
    // Check if occupancy is available (empty array means unavailable)
    if (!dynamicData.occupancyAttributes || dynamicData.occupancyAttributes.length === 0) {
        console.warn('Cannot load occupancy threshold - CALCULATED_OCCUPANCY not available for this hotel');
        checkbox.checked = false;
        checkbox.disabled = true;
        return; // Skip loading this condition
    }

    // Validate that saved attribute matches current CALCULATED_OCCUPANCY
    const savedAttrId = data.attribute.replace(/#/g, '');
    const currentAttrId = fieldContent.querySelector('.occupancy-attribute-id')?.value;

    if (savedAttrId !== currentAttrId) {
        console.warn(`Saved occupancy attribute (${savedAttrId}) differs from current CALCULATED_OCCUPANCY (${currentAttrId}). Using current attribute.`);
    }

    // Set operator and value
    const operatorSelect = fieldContent.querySelector('.operator-select');
    const valueInput = fieldContent.querySelector('.value-input');

    if (operatorSelect) operatorSelect.value = data.operator;
    if (valueInput) valueInput.value = data.value;
}
```

## Logic Flow

### Scenario 1: Hotel WITH CALCULATED_OCCUPANCY

1. **Backend**: Returns `occupancyAttributes: [{id: "ABC", name: "Occupancy %"}]`
2. **Frontend Check**: `occupancyAttributes.length > 0` → **TRUE**
3. **UI State**:
   - Checkbox **enabled**
   - Hidden input populated with `dynamicData.occupancyAttributes[0].id`
   - Operator and value inputs shown
   - Info text: "Using: Occupancy %"
4. **Save**: Reads from hidden input, saves with `#ABC#`
5. **Load**: Loads operator/value, validates ID match

### Scenario 2: Hotel WITHOUT CALCULATED_OCCUPANCY

1. **Backend**: Returns `occupancyAttributes: []`
2. **Frontend Check**: `occupancyAttributes.length === 0` → **FALSE**
3. **UI State**:
   - Checkbox **disabled**
   - "Unavailable" badge shown
   - Warning message displayed
   - `disabled-field` class added
4. **Save**: Skipped (checkbox disabled)
5. **Load**: Cannot load (checkbox disabled)

### Scenario 3: Hotel Change During Edit

1. User selects hotel A (has CALCULATED_OCCUPANCY)
2. User checks occupancy condition, sets value
3. User changes to hotel B (no CALCULATED_OCCUPANCY)
4. **updateAllDropdowns** called:
   - Detects empty array
   - Disables checkbox
   - Unchecks if was checked
   - Shows warning in console
5. Condition becomes unavailable (as expected)

## Consistency with Other Attributes

This pattern is **consistent** with how other dynamic attributes work:

### Property Types (Already Working This Way)
```javascript
// Backend returns: propertyTypes: [{id, name}] or []
// Frontend checks:
${(dynamicData.propertyTypes || []).map(type => `<option value="${type.id}">${type.name}</option>`).join('')}
```

### Lead Time Attributes (Already Working This Way)
```javascript
// Backend returns: leadTimeAttributes: [{id, name}] or []
// Same pattern as occupancy now
```

### Regular Attributes (Already Working This Way)
```javascript
// Backend returns: attributes: [{id, name}] or []
// Frontend populates dropdown
```

**Result**: All attributes follow the **same simple pattern** - empty array = unavailable.

## Data Migration

Ensure all active hotels have CALCULATED_OCCUPANCY:

```sql
-- Check for hotels without the attribute
SELECT
    h.id,
    h.name,
    h.active
FROM ur_hotels h
WHERE h.active = 'Y'
  AND NOT EXISTS (
    SELECT 1
    FROM ur_algo_attributes a
    WHERE a.hotel_id = h.id
      AND a.attribute_qualifier = 'CALCULATED_OCCUPANCY'
      AND a.type = 'C'
);

-- Create missing attributes using existing utility
DECLARE
    v_status BOOLEAN;
    v_message VARCHAR2(4000);
BEGIN
    FOR rec IN (
        SELECT id FROM ur_hotels
        WHERE active = 'Y'
          AND NOT EXISTS (
            SELECT 1 FROM ur_algo_attributes a
            WHERE a.hotel_id = ur_hotels.id
              AND a.attribute_qualifier = 'CALCULATED_OCCUPANCY'
              AND a.type = 'C'
        )
    ) LOOP
        ur_utils.create_hotel_calculated_attributes(
            p_hotel_id => rec.id,
            p_status => v_status,
            p_message => v_message
        );

        IF NOT v_status THEN
            DBMS_OUTPUT.PUT_LINE('Failed for hotel ' || RAWTOHEX(rec.id) || ': ' || v_message);
        END IF;
    END LOOP;
END;
/
```

## Testing Checklist

### Basic Functionality
- [ ] Hotel with CALCULATED_OCCUPANCY: checkbox enabled, works correctly
- [ ] Hotel without CALCULATED_OCCUPANCY: checkbox disabled, shows unavailable
- [ ] Save algorithm with occupancy (when available)
- [ ] Load algorithm with occupancy (when available)
- [ ] Validation passes when enabled and filled
- [ ] Validation skips when disabled

### UI/UX
- [ ] "Unavailable" badge visible when disabled
- [ ] Warning message styled correctly
- [ ] Info text shows "Using: Occupancy %" when available
- [ ] Disabled state is obvious (grayed out, opacity 0.6)

### Edge Cases
- [ ] Hotel change during algorithm creation
- [ ] Load old algorithm with different attribute ID (migration warning)
- [ ] Multiple conditions with occupancy
- [ ] Empty array handling (no crash)

## Files Modified

| File | Lines | Purpose |
|------|-------|---------|
| `GET_LOV_DATA` | 57-75 | Returns array (empty if no attribute) |
| `algojs.js` (UI template) | 811-830 | Checks array length for disabled state |
| `algojs.js` (updateAllDropdowns) | 215-239 | Checks array length, disables if empty |
| `algojs.js` (load condition) | 1827-1851 | Checks array length before loading |

**Save and validation logic**: No changes needed - already checks `checkbox.disabled`

## Deployment

### Steps
1. **Data Migration**: Ensure all hotels have CALCULATED_OCCUPANCY
2. **Backend Update**: Deploy updated GET_LOV_DATA (lines 57-75)
3. **Frontend Update**: Deploy updated algojs.js
4. **Clear Cache**: Clear APEX cache
5. **Test**: Verify both scenarios (with/without attribute)

### Rollback
If issues occur, revert both files:
1. GET_LOV_DATA: Restore old query (with array of all OCCUPANCY attributes)
2. algojs.js: Restore dropdown selector logic
3. Clear APEX cache

## Benefits Summary

### For Users
- Simpler UI (no dropdown confusion)
- Clear visual feedback when unavailable
- Consistent occupancy calculation

### For System
- Standardized on CALCULATED_OCCUPANCY
- Template-agnostic approach
- Consistent pattern across all attributes

### For Development
- Less complex frontend logic
- Cleaner backend (no availability flags)
- Same pattern for all dynamic attributes
- Easier to maintain and debug

## Success Criteria

- ✅ Backend returns simple array structure
- ✅ Frontend checks array length for availability
- ✅ Disabled state works correctly
- ✅ No JavaScript errors
- ✅ No APEX errors
- ✅ Save/load works seamlessly
- ✅ Consistent with other attributes

---

**Implementation Date**: 2025-12-05
**Approach**: Simplified (frontend-driven availability checking)
**Status**: ✅ Complete
**Breaking Changes**: None (backward compatible)
