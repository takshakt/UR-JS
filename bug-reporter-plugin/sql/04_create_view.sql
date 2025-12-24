-- ═══════════════════════════════════════════════════════════════════════════
-- BUG_REPORTS View
-- Helper view for easy querying with extracted JSON fields
-- ═══════════════════════════════════════════════════════════════════════════

CREATE OR REPLACE VIEW V_BUG_REPORTS AS
SELECT
  -- Primary Key (both RAW and HEX format)
  ID,
  RAWTOHEX(ID) AS ID_HEX,

  -- Core Issue Data
  TITLE,
  DESCRIPTION,
  URGENCY,
  IMPACT,
  STATUS,
  REPORTER,

  -- Extracted APEX Info from JSON
  JSON_VALUE(REPORT_DATA, '$.apex.appId') AS APP_ID,
  JSON_VALUE(REPORT_DATA, '$.apex.pageId') AS PAGE_ID,
  JSON_VALUE(REPORT_DATA, '$.apex.sessionId') AS SESSION_ID,
  JSON_VALUE(REPORT_DATA, '$.apex.appUser') AS APP_USER,

  -- Extracted Environment Info from JSON
  JSON_VALUE(REPORT_DATA, '$.environment.browser') AS BROWSER,
  JSON_VALUE(REPORT_DATA, '$.environment.os') AS OS,
  JSON_VALUE(REPORT_DATA, '$.environment.url') AS PAGE_URL,
  JSON_VALUE(REPORT_DATA, '$.environment.screenResolution') AS SCREEN_RESOLUTION,
  JSON_VALUE(REPORT_DATA, '$.environment.viewportSize') AS VIEWPORT_SIZE,

  -- Extracted Reporter Info from JSON
  JSON_VALUE(REPORT_DATA, '$.reporter.userEmail') AS REPORTER_EMAIL,
  JSON_VALUE(REPORT_DATA, '$.reporter.userRole') AS REPORTER_ROLE,

  -- Console Error Count
  (
    SELECT COUNT(*)
    FROM JSON_TABLE(
      REPORT_DATA,
      '$.console.errors[*]'
      COLUMNS (dummy VARCHAR2(1) PATH '$')
    )
  ) AS CONSOLE_ERROR_COUNT,

  -- Console Warning Count
  (
    SELECT COUNT(*)
    FROM JSON_TABLE(
      REPORT_DATA,
      '$.console.warnings[*]'
      COLUMNS (dummy VARCHAR2(1) PATH '$')
    )
  ) AS CONSOLE_WARNING_COUNT,

  -- Full JSON for detailed access
  REPORT_DATA,

  -- Attachment Info
  CASE WHEN SCREENSHOT_BLOB IS NOT NULL THEN 'Y' ELSE 'N' END AS HAS_SCREENSHOT,
  CASE WHEN ATTACHMENTS_BLOB IS NOT NULL THEN 'Y' ELSE 'N' END AS HAS_ATTACHMENTS,
  DBMS_LOB.GETLENGTH(SCREENSHOT_BLOB) AS SCREENSHOT_SIZE,
  ATTACHMENTS_META,

  -- Webhook Status
  WEBHOOK_SENT,
  WEBHOOK_SENT_AT,

  -- AI Analysis
  AI_ANALYSIS,

  -- Audit Fields
  CREATED_BY,
  CREATED_ON,
  UPDATED_BY,
  UPDATED_ON,
  RESOLVED_AT,

  -- Calculated Fields
  ROUND((CAST(SYSTIMESTAMP AS DATE) - CAST(CREATED_ON AS DATE)) * 24, 1) AS AGE_HOURS,
  CASE
    WHEN STATUS IN ('RESOLVED', 'CLOSED') AND RESOLVED_AT IS NOT NULL THEN
      ROUND((CAST(RESOLVED_AT AS DATE) - CAST(CREATED_ON AS DATE)) * 24, 1)
    ELSE NULL
  END AS RESOLUTION_HOURS

FROM BUG_REPORTS;

-- Add view comment
COMMENT ON TABLE V_BUG_REPORTS IS 'View providing easy access to BUG_REPORTS with extracted JSON fields';
