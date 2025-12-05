# Occupancy Hardcode - Deployment Guide

## Overview
This guide covers deploying the occupancy hardcode changes that replace the LOV dropdown with a standardized CALCULATED_OCCUPANCY attribute.

## Files Modified

### ✅ Frontend (Complete)
- **File**: `/home/coder/ur-js/algojs.js`
- **Changes**:
  - Removed dropdown selector
  - Added hidden input for attribute ID
  - Added disabled state handling
  - Added CSS styles
  - Updated save/load/validation logic
- **Lines Modified**: ~200 lines

### ✅ Backend (Complete)
- **File**: `/home/coder/ur-js/GET_LOV_DATA`
- **Changes**:
  - Changed from array to single object
  - Added availability flag
  - Filters for CALCULATED_OCCUPANCY only
  - Added error handling
- **Lines Modified**: 40 lines

## Pre-Deployment Checklist

### 1. Data Migration (Critical)
Ensure all active hotels have CALCULATED_OCCUPANCY attribute:

```sql
-- Step 1: Check for hotels without the attribute
SELECT
    h.id,
    h.name,
    h.active,
    h.created_on
FROM ur_hotels h
WHERE h.active = 'Y'
  AND NOT EXISTS (
    SELECT 1
    FROM ur_algo_attributes a
    WHERE a.hotel_id = h.id
      AND a.attribute_qualifier = 'CALCULATED_OCCUPANCY'
      AND a.type = 'C'
)
ORDER BY h.name;

-- Step 2: Create missing attributes (if any found above)
DECLARE
    v_status BOOLEAN;
    v_message VARCHAR2(4000);
    v_success_count NUMBER := 0;
    v_fail_count NUMBER := 0;
BEGIN
    FOR rec IN (
        SELECT id, name FROM ur_hotels
        WHERE active = 'Y'
          AND NOT EXISTS (
            SELECT 1 FROM ur_algo_attributes a
            WHERE a.hotel_id = ur_hotels.id
              AND a.attribute_qualifier = 'CALCULATED_OCCUPANCY'
              AND a.type = 'C'
        )
    ) LOOP
        BEGIN
            ur_utils.create_hotel_calculated_attributes(
                p_hotel_id => rec.id,
                p_status => v_status,
                p_message => v_message
            );

            IF v_status THEN
                v_success_count := v_success_count + 1;
                DBMS_OUTPUT.PUT_LINE('✓ Created for: ' || rec.name);
            ELSE
                v_fail_count := v_fail_count + 1;
                DBMS_OUTPUT.PUT_LINE('✗ Failed for: ' || rec.name || ' - ' || v_message);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                v_fail_count := v_fail_count + 1;
                DBMS_OUTPUT.PUT_LINE('✗ Error for: ' || rec.name || ' - ' || SQLERRM);
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Summary:');
    DBMS_OUTPUT.PUT_LINE('  Success: ' || v_success_count);
    DBMS_OUTPUT.PUT_LINE('  Failed: ' || v_fail_count);

    IF v_fail_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Some hotels failed - check output above');
    END IF;
END;
/

-- Step 3: Verify all active hotels now have the attribute
SELECT
    CASE
        WHEN COUNT(*) = 0 THEN '✓ All active hotels have CALCULATED_OCCUPANCY'
        ELSE '✗ ' || COUNT(*) || ' hotels still missing attribute'
    END AS status
FROM ur_hotels h
WHERE h.active = 'Y'
  AND NOT EXISTS (
    SELECT 1 FROM ur_algo_attributes a
    WHERE a.hotel_id = h.id
      AND a.attribute_qualifier = 'CALCULATED_OCCUPANCY'
      AND a.type = 'C'
);
```

### 2. Backup Current Files
```bash
# Backup algojs.js
cp /path/to/algojs.js /path/to/algojs.js.backup.$(date +%Y%m%d)

# Backup GET_LOV_DATA process
# In APEX: Export the page with the process before making changes
```

### 3. Test in Development Environment
- [ ] Deploy to dev environment first
- [ ] Test with hotel that HAS CALCULATED_OCCUPANCY
- [ ] Test with hotel that DOESN'T HAVE CALCULATED_OCCUPANCY (if any)
- [ ] Create new algorithm with occupancy condition
- [ ] Load existing algorithm with occupancy condition
- [ ] Verify validation works
- [ ] Check browser console for errors
- [ ] Check APEX debug logs

## Deployment Steps

### Option A: Deploy via APEX (Recommended)

#### 1. Update GET_LOV_DATA Process
```
1. Navigate to APEX Application Builder
2. Go to Page 1050 (or your algorithm page)
3. Find process "GET_LOV_DATA"
4. Replace lines 57-81 with new code from GET_LOV_DATA file
5. Click "Apply Changes"
```

#### 2. Update algojs.js File
```
1. Navigate to APEX Application Builder
2. Go to Shared Components → Static Application Files
3. Find and edit algojs.js
4. Replace entire file content with updated version
5. Click "Apply Changes"
6. Clear APEX cache (Ctrl+F5 or clear workspace cache)
```

### Option B: Deploy via SQL*Plus/SQLcl

#### 1. Update GET_LOV_DATA Process
```sql
-- Run this in SQL*Plus/SQLcl
-- (Note: Adjust for your APEX installation path)
@GET_LOV_DATA

-- Or manually copy/paste the DECLARE block into your APEX process
```

#### 2. Upload algojs.js
```bash
# Use APEX file upload or REST API
curl -X POST https://your-apex-url/upload \
  -F "file=@algojs.js" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Post-Deployment Verification

### 1. Smoke Test (5 minutes)
```
Test Case 1: Hotel with CALCULATED_OCCUPANCY
1. Open algorithm page
2. Select hotel (one with attribute)
3. Click "New Algorithm"
4. Add new condition
5. Check "Occupancy Threshold %" checkbox
6. Verify:
   ✓ Checkbox is enabled
   ✓ No dropdown shown
   ✓ Operator and value inputs shown
   ✓ Info text shows "Using: Occupancy %"
7. Set operator to ">" and value to "80"
8. Add expression or other conditions
9. Save algorithm
10. Reload page and open algorithm
11. Verify occupancy condition loads correctly

Test Case 2: Hotel without CALCULATED_OCCUPANCY (if any)
1. Select hotel (one without attribute)
2. Click "New Algorithm"
3. Add new condition
4. Verify:
   ✓ "Occupancy Threshold %" checkbox is disabled
   ✓ "Unavailable" badge is shown
   ✓ Warning message explains why
   ✓ Cannot interact with the condition
5. Try to save algorithm
6. Verify no errors occur
```

### 2. Console Check
```javascript
// Open browser console (F12)
// Look for:

// ✓ No JavaScript errors
// ✓ Warnings about attribute migration (if loading old algorithms)
// ✓ Debug log shows: "Detected date format..." etc.

// Expected warnings (OK):
console.warn('Saved occupancy attribute (OLD_ID) differs from current CALCULATED_OCCUPANCY (NEW_ID)...');

// Unexpected errors (NOT OK):
// TypeError, ReferenceError, etc.
```

### 3. Database Check
```sql
-- Verify GET_LOV_DATA is being called and returning correct structure
SELECT * FROM debug_log
WHERE message LIKE '%GET_LOV_DATA%'
ORDER BY created_on DESC
FETCH FIRST 10 ROWS ONLY;

-- Check algorithm versions saved after deployment
SELECT
    av.id,
    av.version_number,
    av.created_on,
    JSON_QUERY(av.expression, '$.conditions[*].occupancyThreshold' WITH ARRAY WRAPPER) AS occupancy_conditions
FROM ur_algo_versions av
WHERE av.created_on > SYSDATE - 1  -- Last 24 hours
  AND av.expression IS NOT NULL
ORDER BY av.created_on DESC;

-- Verify attribute structure
SELECT
    JSON_QUERY(av.expression, '$.conditions[*].occupancyThreshold.attribute' WITH ARRAY WRAPPER) AS attribute_refs
FROM ur_algo_versions av
WHERE av.created_on > SYSDATE - 1
  AND av.expression IS NOT NULL
FETCH FIRST 5 ROWS ONLY;

-- Should see: ["#ATTR_ID#"]
```

## Monitoring (First 24 Hours)

### What to Monitor

#### 1. Error Logs
```sql
-- Check for errors in APEX error log
SELECT *
FROM apex_debug_messages
WHERE message_text LIKE '%occupancy%'
  AND message_timestamp > SYSDATE - 1
ORDER BY message_timestamp DESC;

-- Check application errors
SELECT *
FROM apex_workspace_activity_log
WHERE application_id = YOUR_APP_ID
  AND log_timestamp > SYSDATE - 1
  AND apex_session_id IN (
    SELECT apex_session_id
    FROM apex_workspace_activity_log
    WHERE page_id = 1050  -- Algorithm page
  )
ORDER BY log_timestamp DESC;
```

#### 2. User Feedback
- Watch for reports of "occupancy not working"
- Check if users can't create/edit algorithms
- Monitor support tickets/emails

#### 3. Performance
```sql
-- Check if GET_LOV_DATA is slower
SELECT
    AVG(elapsed_time) AS avg_ms,
    MAX(elapsed_time) AS max_ms,
    COUNT(*) AS call_count
FROM apex_workspace_activity_log
WHERE page_id = 1050
  AND elapsed_time > 0
  AND log_timestamp > SYSDATE - 1
GROUP BY TRUNC(log_timestamp, 'HH');
```

## Rollback Procedure

### If Critical Issues Occur

#### 1. Immediate Rollback (< 5 minutes)

**Step 1: Revert algojs.js**
```
1. Go to APEX Shared Components → Static Files
2. Edit algojs.js
3. Replace with backup version
4. Save and clear cache
```

**Step 2: Revert GET_LOV_DATA**
```
1. Go to Page 1050 → GET_LOV_DATA process
2. Replace with backup code (restore lines 57-81)
3. Save changes
```

**Step 3: Clear APEX Cache**
```sql
-- Run in SQL*Plus/SQLcl
BEGIN
    apex_util.clear_app_cache(p_app_id => YOUR_APP_ID);
END;
/
```

**Step 4: Verify Rollback**
```
1. Refresh browser (Ctrl+F5)
2. Open algorithm page
3. Verify dropdown is back
4. Test creating/editing algorithm
```

#### 2. Partial Rollback (Keep Data Migration)

If the data migration succeeded but code has issues:
- Revert frontend/backend code
- Keep CALCULATED_OCCUPANCY attributes (no harm)
- Can re-attempt deployment later

## Known Issues & Workarounds

### Issue 1: TypeScript Warnings in IDE
**Symptom**: IDE shows hints about `occupancyAttribute` not existing
**Impact**: None (cosmetic only)
**Workaround**: Ignore or update type definitions

### Issue 2: Old Algorithms Load Slowly
**Symptom**: First load of old algorithm logs migration warning
**Impact**: Minimal (1-2 second delay)
**Workaround**: None needed (auto-migrates on save)

### Issue 3: Hotel Without Attribute
**Symptom**: Checkbox disabled, "Unavailable" badge
**Impact**: User can't use occupancy condition
**Fix**: Run migration script for that hotel

## Success Criteria

Deployment is successful if:
- ✅ No JavaScript errors in console
- ✅ No APEX errors in logs
- ✅ Users can create algorithms with occupancy
- ✅ Users can edit existing algorithms
- ✅ Disabled state works for hotels without attribute
- ✅ Validation works correctly
- ✅ Save/load cycle preserves data
- ✅ Performance is acceptable

## Support Contacts

**For Issues:**
- Frontend problems: Check browser console, review algojs.js changes
- Backend problems: Check APEX debug, review GET_LOV_DATA changes
- Data problems: Run verification queries, check CALCULATED_OCCUPANCY attributes

**Documentation:**
- Implementation Plan: `OCCUPANCY_HARDCODE_PLAN.md`
- Changes Summary: `OCCUPANCY_CHANGES_SUMMARY.md`
- Backend Changes: `GET_LOV_DATA_CHANGES.md`

## Appendix: Quick Reference

### Frontend Changes
- File: `algojs.js`
- Lines: 790-809 (UI), 215-238 (update), 1436-1450 (save), 1810-1835 (load), 1338-1366 (validate), 1992-2060 (CSS)

### Backend Changes
- File: `GET_LOV_DATA`
- Lines: 57-96

### Key Data Structure
```json
{
    "occupancyAttribute": {
        "available": true,
        "id": "RAW_ID",
        "name": "Occupancy %"
    }
}
```

### Migration Query
```sql
SELECT COUNT(*) FROM ur_hotels WHERE active='Y' AND NOT EXISTS (
    SELECT 1 FROM ur_algo_attributes WHERE hotel_id=ur_hotels.id
    AND attribute_qualifier='CALCULATED_OCCUPANCY' AND type='C'
);
```

---

**Deployment Date**: _______________
**Deployed By**: _______________
**Verification Completed**: ⬜ Yes ⬜ No
**Issues Encountered**: _______________
**Rollback Required**: ⬜ Yes ⬜ No
