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
-- This process handles TWO operations:
--   1. CREATE - Initial bug report submission (x02 = 'CREATE')
--   2. UPDATE_WEBHOOK - Update webhook status after client sends (x02 = 'UPDATE_WEBHOOK')
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
  l_operation      VARCHAR2(20)  := COALESCE(apex_application.g_x02, 'CREATE');
  l_report_json    CLOB          := apex_application.g_x01;
  l_screenshot_b64 CLOB;
  l_json           JSON_OBJECT_T;
  l_reporter_obj   JSON_OBJECT_T;
  l_title          VARCHAR2(500);
  l_description    CLOB;
  l_urgency        VARCHAR2(20);
  l_impact         VARCHAR2(50);
  l_reporter       VARCHAR2(255);
  l_screenshot     BLOB;
  l_base64_start   NUMBER;
  l_current_user   VARCHAR2(255);

  -- Bug ID (JS-generated UUID used as primary identifier)
  l_bug_id         VARCHAR2(100);
  l_bug_id_raw     RAW(16);
  l_webhook_sent   VARCHAR2(1);
  l_webhook_resp   VARCHAR2(4000);
BEGIN
  -- Get current user
  l_current_user := COALESCE(:APP_USER, USER);

  -- =========================================================================
  -- OPERATION: UPDATE_WEBHOOK - Update webhook status for existing record
  -- =========================================================================
  IF l_operation = 'UPDATE_WEBHOOK' THEN
    BEGIN
      l_json := JSON_OBJECT_T.parse(l_report_json);
      l_bug_id       := l_json.get_string('bugId');
      l_webhook_sent := CASE WHEN l_json.get_boolean('webhookSent') THEN 'Y' ELSE 'N' END;
      l_webhook_resp := SUBSTR(l_json.get_string('webhookResponse'), 1, 4000);

      -- Convert UUID string (32 uppercase hex chars) to RAW(16)
      l_bug_id_raw := HEXTORAW(l_bug_id);

      UPDATE BUG_REPORTS
      SET WEBHOOK_SENT     = l_webhook_sent,
          WEBHOOK_RESPONSE = l_webhook_resp,
          WEBHOOK_SENT_AT  = CASE WHEN l_webhook_sent = 'Y' THEN SYSTIMESTAMP ELSE NULL END,
          UPDATED_BY       = l_current_user,
          UPDATED_ON       = SYSTIMESTAMP
      WHERE ID = l_bug_id_raw;

      apex_json.open_object;
      apex_json.write('success', true);
      apex_json.write('updated', SQL%ROWCOUNT > 0);
      apex_json.close_object;

    EXCEPTION
      WHEN OTHERS THEN
        apex_json.open_object;
        apex_json.write('success', false);
        apex_json.write('error', SQLERRM);
        apex_json.close_object;
    END;
    RETURN;
  END IF;

  -- =========================================================================
  -- OPERATION: CREATE - Create new bug report record
  -- =========================================================================

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
  l_bug_id    := l_json.get_string('bugId');
  l_title     := SUBSTR(l_json.get_string('title'), 1, 500);
  l_urgency   := l_json.get_string('urgency');
  l_impact    := l_json.get_string('impact');

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
    l_reporter := l_current_user;
  END IF;

  -- Handle screenshot (if passed via f01 array)
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

  -- Convert UUID string (already uppercase hex, no hyphens) to RAW(16)
  l_bug_id_raw := HEXTORAW(l_bug_id);

  -- Insert record using the JS-generated bugId (converted to RAW) as the primary ID
  -- WEBHOOK_SENT = 'N' (will be updated after client sends webhook)
  INSERT INTO BUG_REPORTS (
    ID, TITLE, DESCRIPTION, URGENCY, IMPACT, REPORTER,
    REPORT_DATA, SCREENSHOT_BLOB, CREATED_BY, CREATED_ON,
    WEBHOOK_SENT
  ) VALUES (
    l_bug_id_raw, l_title, l_description, l_urgency, l_impact, l_reporter,
    l_report_json, l_screenshot, l_current_user, SYSTIMESTAMP,
    'N'
  );

  -- Return success
  apex_json.open_object;
  apex_json.write('success', true);
  apex_json.write('bugId', l_bug_id);
  apex_json.close_object;

EXCEPTION
  WHEN OTHERS THEN
    apex_json.open_object;
    apex_json.write('success', false);
    apex_json.write('error', SQLERRM);
    apex_json.close_object;
END;
