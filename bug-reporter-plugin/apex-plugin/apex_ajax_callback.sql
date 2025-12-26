-- ═══════════════════════════════════════════════════════════════════════════
-- Bug Reporter - APEX Ajax Callback Process
--
-- Create this as an Application Process in APEX:
--
-- 1. Go to: Shared Components > Application Processes
-- 2. Click: Create
-- 3. Set:
--    - Name: AJX_BUG_REPORTER_LOG
--    - Sequence: 10
--    - Point: Ajax Callback
--    - Condition Type: No Condition
-- 4. Paste the PL/SQL code below (everything between BEGIN and END)
-- 5. Click: Create Process
--
-- ═══════════════════════════════════════════════════════════════════════════

/*
==============================================================================
APEX Application Process Settings:
==============================================================================
Name:             AJX_BUG_REPORTER_LOG
Sequence:         10
Point:            Ajax Callback
Condition Type:   No Condition
==============================================================================
*/

-- Copy everything below this line into the PL/SQL Code field:

DECLARE
  l_report_json    CLOB := apex_application.g_x01;
  l_screenshot_b64 CLOB;
  l_id             RAW(16);
  l_json           JSON_OBJECT_T;
  l_reporter_obj   JSON_OBJECT_T;
  l_title          VARCHAR2(500);
  l_description    CLOB;
  l_urgency        VARCHAR2(20);
  l_impact         VARCHAR2(50);
  l_reporter       VARCHAR2(255);
  l_screenshot     BLOB;
  l_base64_start   NUMBER;
BEGIN
  -- Validate input
  IF l_report_json IS NULL OR DBMS_LOB.GETLENGTH(l_report_json) = 0 THEN
    apex_json.open_object;
    apex_json.write('success', false);
    apex_json.write('error', 'No report data received');
    apex_json.close_object;
    RETURN;
  END IF;

  -- Parse JSON
  BEGIN
    l_json := JSON_OBJECT_T.parse(l_report_json);
  EXCEPTION
    WHEN OTHERS THEN
      apex_json.open_object;
      apex_json.write('success', false);
      apex_json.write('error', 'Invalid JSON: ' || SQLERRM);
      apex_json.close_object;
      RETURN;
  END;

  -- Extract fields
  l_title   := SUBSTR(l_json.get_string('title'), 1, 500);
  l_urgency := l_json.get_string('urgency');
  l_impact  := l_json.get_string('impact');

  BEGIN
    l_description := l_json.get_clob('description');
  EXCEPTION
    WHEN OTHERS THEN
      l_description := l_json.get_string('description');
  END;

  -- Get reporter
  BEGIN
    l_reporter_obj := l_json.get_object('reporter');
    IF l_reporter_obj IS NOT NULL THEN
      l_reporter := l_reporter_obj.get_string('userName');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_reporter := NULL;
  END;

  IF l_reporter IS NULL THEN
    l_reporter := COALESCE(:APP_USER, USER);
  END IF;

  -- Handle screenshot
  IF apex_application.g_f01.COUNT > 0 AND apex_application.g_f01(1) IS NOT NULL THEN
    l_screenshot_b64 := apex_application.g_f01(1);
    IF DBMS_LOB.GETLENGTH(l_screenshot_b64) > 0 THEN
      l_base64_start := INSTR(l_screenshot_b64, 'base64,');
      IF l_base64_start > 0 THEN
        l_screenshot_b64 := SUBSTR(l_screenshot_b64, l_base64_start + 7);
      END IF;
      BEGIN
        l_screenshot := apex_web_service.clobbase642blob(l_screenshot_b64);
      EXCEPTION
        WHEN OTHERS THEN
          l_screenshot := NULL;
      END;
    END IF;
  END IF;

  -- Insert record
  INSERT INTO BUG_REPORTS (
    TITLE, DESCRIPTION, URGENCY, IMPACT, REPORTER,
    REPORT_DATA, SCREENSHOT_BLOB, CREATED_BY
  ) VALUES (
    l_title, l_description, l_urgency, l_impact, l_reporter,
    l_report_json, l_screenshot, COALESCE(:APP_USER, USER)
  )
  RETURNING ID INTO l_id;

  -- Return success
  apex_json.open_object;
  apex_json.write('success', true);
  apex_json.write('reportId', RAWTOHEX(l_id));
  apex_json.close_object;

EXCEPTION
  WHEN OTHERS THEN
    apex_json.open_object;
    apex_json.write('success', false);
    apex_json.write('error', SQLERRM);
    apex_json.close_object;
END;
