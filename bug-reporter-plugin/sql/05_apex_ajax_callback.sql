-- ═══════════════════════════════════════════════════════════════════════════
-- APEX Ajax Callback: AJX_LOG_BUG_REPORT
--
-- This code should be added as an Application Process in APEX:
-- 1. Go to Shared Components > Application Processes
-- 2. Click Create
-- 3. Name: AJX_LOG_BUG_REPORT
-- 4. Point: Ajax Callback
-- 5. Paste this PL/SQL code (without the CREATE PROCEDURE wrapper)
-- ═══════════════════════════════════════════════════════════════════════════

/*
--------------------------------------------------------------------------------
APEX Application Process Configuration:
--------------------------------------------------------------------------------
Name:           AJX_LOG_BUG_REPORT
Sequence:       10 (or any available)
Point:          Ajax Callback
Condition:      None (No Condition)

PL/SQL Code:    (Copy everything between BEGIN and END below)
--------------------------------------------------------------------------------
*/

DECLARE
  -- Input parameters
  l_report_json    CLOB := apex_application.g_x01;
  l_screenshot_b64 CLOB;

  -- Parsed values
  l_id             RAW(16);
  l_json           JSON_OBJECT_T;
  l_reporter_obj   JSON_OBJECT_T;
  l_title          VARCHAR2(500);
  l_description    CLOB;
  l_urgency        VARCHAR2(20);
  l_impact         VARCHAR2(50);
  l_reporter       VARCHAR2(255);

  -- Screenshot handling
  l_screenshot     BLOB;
  l_base64_start   NUMBER;
BEGIN
  -- ─────────────────────────────────────────────────────────────────────────
  -- Validate input
  -- ─────────────────────────────────────────────────────────────────────────
  IF l_report_json IS NULL OR DBMS_LOB.GETLENGTH(l_report_json) = 0 THEN
    apex_json.open_object;
    apex_json.write('success', false);
    apex_json.write('error', 'No report data received');
    apex_json.close_object;
    RETURN;
  END IF;

  -- ─────────────────────────────────────────────────────────────────────────
  -- Parse the JSON payload
  -- ─────────────────────────────────────────────────────────────────────────
  BEGIN
    l_json := JSON_OBJECT_T.parse(l_report_json);
  EXCEPTION
    WHEN OTHERS THEN
      apex_json.open_object;
      apex_json.write('success', false);
      apex_json.write('error', 'Invalid JSON format: ' || SQLERRM);
      apex_json.close_object;
      RETURN;
  END;

  -- ─────────────────────────────────────────────────────────────────────────
  -- Extract top-level fields
  -- ─────────────────────────────────────────────────────────────────────────
  l_title       := SUBSTR(l_json.get_string('title'), 1, 500);
  l_urgency     := l_json.get_string('urgency');
  l_impact      := l_json.get_string('impact');

  -- Get description (handle both string and clob)
  BEGIN
    l_description := l_json.get_clob('description');
  EXCEPTION
    WHEN OTHERS THEN
      l_description := l_json.get_string('description');
  END;

  -- ─────────────────────────────────────────────────────────────────────────
  -- Extract reporter name from nested object
  -- ─────────────────────────────────────────────────────────────────────────
  BEGIN
    l_reporter_obj := l_json.get_object('reporter');
    IF l_reporter_obj IS NOT NULL THEN
      l_reporter := l_reporter_obj.get_string('userName');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_reporter := NULL;
  END;

  -- Fallback to APEX user if reporter not found
  IF l_reporter IS NULL OR l_reporter = '' THEN
    l_reporter := COALESCE(:APP_USER, USER);
  END IF;

  -- ─────────────────────────────────────────────────────────────────────────
  -- Handle screenshot (sent via f01 array as base64)
  -- ─────────────────────────────────────────────────────────────────────────
  IF apex_application.g_f01.COUNT > 0 THEN
    l_screenshot_b64 := apex_application.g_f01(1);

    IF l_screenshot_b64 IS NOT NULL AND DBMS_LOB.GETLENGTH(l_screenshot_b64) > 0 THEN
      -- Remove data URL prefix if present (data:image/png;base64,)
      l_base64_start := INSTR(l_screenshot_b64, 'base64,');
      IF l_base64_start > 0 THEN
        l_screenshot_b64 := SUBSTR(l_screenshot_b64, l_base64_start + 7);
      END IF;

      -- Convert base64 to BLOB
      BEGIN
        l_screenshot := apex_web_service.clobbase642blob(l_screenshot_b64);
      EXCEPTION
        WHEN OTHERS THEN
          -- Log warning but continue without screenshot
          apex_debug.warn('Failed to convert screenshot: ' || SQLERRM);
          l_screenshot := NULL;
      END;
    END IF;
  END IF;

  -- ─────────────────────────────────────────────────────────────────────────
  -- Insert the bug report
  -- ─────────────────────────────────────────────────────────────────────────
  INSERT INTO BUG_REPORTS (
    TITLE,
    DESCRIPTION,
    URGENCY,
    IMPACT,
    REPORTER,
    REPORT_DATA,
    SCREENSHOT_BLOB,
    CREATED_BY
  ) VALUES (
    l_title,
    l_description,
    l_urgency,
    l_impact,
    l_reporter,
    l_report_json,
    l_screenshot,
    COALESCE(:APP_USER, USER)
  )
  RETURNING ID INTO l_id;

  -- ─────────────────────────────────────────────────────────────────────────
  -- Return success response
  -- ─────────────────────────────────────────────────────────────────────────
  apex_json.open_object;
  apex_json.write('success', true);
  apex_json.write('reportId', RAWTOHEX(l_id));
  apex_json.write('message', 'Bug report saved successfully');
  apex_json.close_object;

EXCEPTION
  WHEN OTHERS THEN
    -- ─────────────────────────────────────────────────────────────────────────
    -- Handle any unexpected errors
    -- ─────────────────────────────────────────────────────────────────────────
    apex_json.open_object;
    apex_json.write('success', false);
    apex_json.write('error', 'Database error: ' || SQLERRM);
    apex_json.write('errorCode', SQLCODE);
    apex_json.close_object;

    -- Log the error for debugging
    apex_debug.error('AJX_LOG_BUG_REPORT failed: ' || SQLERRM);
    apex_debug.error('Error backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
