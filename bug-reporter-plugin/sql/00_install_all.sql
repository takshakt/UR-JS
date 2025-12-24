-- ═══════════════════════════════════════════════════════════════════════════
-- Bug Reporter Plugin - Complete Installation Script
--
-- This script installs all database objects for the Bug Reporter Plugin.
-- Run this script as a user with CREATE TABLE, CREATE INDEX, CREATE TRIGGER,
-- and CREATE VIEW privileges.
--
-- Individual scripts can also be run separately in order:
--   01_create_table.sql   - Creates the BUG_REPORTS table
--   02_create_indexes.sql - Creates performance indexes
--   03_create_trigger.sql - Creates audit trigger
--   04_create_view.sql    - Creates helper view
--
-- Note: The APEX Ajax Callback (05_apex_ajax_callback.sql) must be created
--       manually through the APEX Builder interface.
-- ═══════════════════════════════════════════════════════════════════════════

PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT Bug Reporter Plugin - Database Installation
PROMPT ═══════════════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────────────────
-- Drop existing objects (optional - uncomment if reinstalling)
-- ─────────────────────────────────────────────────────────────────────────
-- PROMPT Dropping existing objects...
-- DROP VIEW V_BUG_REPORTS;
-- DROP TRIGGER TRG_BUG_REPORTS_AUDIT;
-- DROP INDEX IDX_BUG_REPORTS_STATUS;
-- DROP INDEX IDX_BUG_REPORTS_REPORTER;
-- DROP INDEX IDX_BUG_REPORTS_CREATED;
-- DROP INDEX IDX_BUG_REPORTS_URGENCY;
-- DROP INDEX IDX_BUG_REPORTS_STATUS_DATE;
-- DROP INDEX IDX_BUG_REPORTS_WEBHOOK;
-- DROP TABLE BUG_REPORTS;

-- ─────────────────────────────────────────────────────────────────────────
-- Step 1: Create Table
-- ─────────────────────────────────────────────────────────────────────────
PROMPT
PROMPT Step 1: Creating BUG_REPORTS table...

CREATE TABLE BUG_REPORTS (
  ID                 RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
  TITLE              VARCHAR2(500) NOT NULL,
  DESCRIPTION        CLOB,
  URGENCY            VARCHAR2(20) CHECK (URGENCY IN ('low', 'medium', 'high', 'critical')),
  IMPACT             VARCHAR2(50) CHECK (IMPACT IN ('single_user', 'team', 'multiple_teams', 'organization')),
  STATUS             VARCHAR2(30) DEFAULT 'NEW' CHECK (STATUS IN ('NEW', 'TRIAGED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED', 'WONT_FIX')),
  REPORTER           VARCHAR2(255),
  REPORT_DATA        CLOB CONSTRAINT CHK_REPORT_DATA_JSON CHECK (REPORT_DATA IS JSON),
  SCREENSHOT_BLOB    BLOB,
  ATTACHMENTS_BLOB   BLOB,
  ATTACHMENTS_META   CLOB CONSTRAINT CHK_ATTACH_META_JSON CHECK (ATTACHMENTS_META IS JSON OR ATTACHMENTS_META IS NULL),
  WEBHOOK_SENT       VARCHAR2(1) DEFAULT 'N' CHECK (WEBHOOK_SENT IN ('Y', 'N')),
  WEBHOOK_RESPONSE   CLOB,
  WEBHOOK_SENT_AT    TIMESTAMP,
  AI_ANALYSIS        CLOB CONSTRAINT CHK_AI_ANALYSIS_JSON CHECK (AI_ANALYSIS IS JSON OR AI_ANALYSIS IS NULL),
  CREATED_BY         VARCHAR2(255),
  CREATED_ON         TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  UPDATED_BY         VARCHAR2(255),
  UPDATED_ON         TIMESTAMP,
  RESOLVED_AT        TIMESTAMP
);

COMMENT ON TABLE BUG_REPORTS IS 'Stores bug reports submitted via the Bug Reporter Plugin';

PROMPT    Table BUG_REPORTS created successfully.

-- ─────────────────────────────────────────────────────────────────────────
-- Step 2: Create Indexes
-- ─────────────────────────────────────────────────────────────────────────
PROMPT
PROMPT Step 2: Creating indexes...

CREATE INDEX IDX_BUG_REPORTS_STATUS ON BUG_REPORTS(STATUS);
CREATE INDEX IDX_BUG_REPORTS_REPORTER ON BUG_REPORTS(REPORTER);
CREATE INDEX IDX_BUG_REPORTS_CREATED ON BUG_REPORTS(CREATED_ON);
CREATE INDEX IDX_BUG_REPORTS_URGENCY ON BUG_REPORTS(URGENCY);
CREATE INDEX IDX_BUG_REPORTS_STATUS_DATE ON BUG_REPORTS(STATUS, CREATED_ON DESC);
CREATE INDEX IDX_BUG_REPORTS_WEBHOOK ON BUG_REPORTS(WEBHOOK_SENT);

PROMPT    6 indexes created successfully.

-- ─────────────────────────────────────────────────────────────────────────
-- Step 3: Create Trigger
-- ─────────────────────────────────────────────────────────────────────────
PROMPT
PROMPT Step 3: Creating audit trigger...

CREATE OR REPLACE TRIGGER TRG_BUG_REPORTS_AUDIT
BEFORE INSERT OR UPDATE ON BUG_REPORTS
FOR EACH ROW
DECLARE
  l_user VARCHAR2(255);
BEGIN
  l_user := COALESCE(
    SYS_CONTEXT('APEX$SESSION', 'APP_USER'),
    SYS_CONTEXT('USERENV', 'SESSION_USER'),
    USER
  );

  IF INSERTING THEN
    :NEW.CREATED_ON := SYSTIMESTAMP;
    :NEW.CREATED_BY := COALESCE(:NEW.CREATED_BY, l_user);
    IF :NEW.ID IS NULL THEN
      :NEW.ID := SYS_GUID();
    END IF;
  END IF;

  IF UPDATING THEN
    :NEW.UPDATED_ON := SYSTIMESTAMP;
    :NEW.UPDATED_BY := l_user;
    :NEW.CREATED_ON := :OLD.CREATED_ON;
    :NEW.CREATED_BY := :OLD.CREATED_BY;
    IF :OLD.STATUS NOT IN ('RESOLVED', 'CLOSED')
       AND :NEW.STATUS IN ('RESOLVED', 'CLOSED')
       AND :NEW.RESOLVED_AT IS NULL THEN
      :NEW.RESOLVED_AT := SYSTIMESTAMP;
    END IF;
  END IF;
END TRG_BUG_REPORTS_AUDIT;
/

PROMPT    Trigger TRG_BUG_REPORTS_AUDIT created successfully.

-- ─────────────────────────────────────────────────────────────────────────
-- Step 4: Create View
-- ─────────────────────────────────────────────────────────────────────────
PROMPT
PROMPT Step 4: Creating helper view...

CREATE OR REPLACE VIEW V_BUG_REPORTS AS
SELECT
  ID,
  RAWTOHEX(ID) AS ID_HEX,
  TITLE,
  DESCRIPTION,
  URGENCY,
  IMPACT,
  STATUS,
  REPORTER,
  JSON_VALUE(REPORT_DATA, '$.apex.appId') AS APP_ID,
  JSON_VALUE(REPORT_DATA, '$.apex.pageId') AS PAGE_ID,
  JSON_VALUE(REPORT_DATA, '$.apex.sessionId') AS SESSION_ID,
  JSON_VALUE(REPORT_DATA, '$.apex.appUser') AS APP_USER,
  JSON_VALUE(REPORT_DATA, '$.environment.browser') AS BROWSER,
  JSON_VALUE(REPORT_DATA, '$.environment.os') AS OS,
  JSON_VALUE(REPORT_DATA, '$.environment.url') AS PAGE_URL,
  JSON_VALUE(REPORT_DATA, '$.environment.screenResolution') AS SCREEN_RESOLUTION,
  JSON_VALUE(REPORT_DATA, '$.environment.viewportSize') AS VIEWPORT_SIZE,
  JSON_VALUE(REPORT_DATA, '$.reporter.userEmail') AS REPORTER_EMAIL,
  JSON_VALUE(REPORT_DATA, '$.reporter.userRole') AS REPORTER_ROLE,
  REPORT_DATA,
  CASE WHEN SCREENSHOT_BLOB IS NOT NULL THEN 'Y' ELSE 'N' END AS HAS_SCREENSHOT,
  CASE WHEN ATTACHMENTS_BLOB IS NOT NULL THEN 'Y' ELSE 'N' END AS HAS_ATTACHMENTS,
  DBMS_LOB.GETLENGTH(SCREENSHOT_BLOB) AS SCREENSHOT_SIZE,
  ATTACHMENTS_META,
  WEBHOOK_SENT,
  WEBHOOK_SENT_AT,
  AI_ANALYSIS,
  CREATED_BY,
  CREATED_ON,
  UPDATED_BY,
  UPDATED_ON,
  RESOLVED_AT,
  ROUND((CAST(SYSTIMESTAMP AS DATE) - CAST(CREATED_ON AS DATE)) * 24, 1) AS AGE_HOURS,
  CASE
    WHEN STATUS IN ('RESOLVED', 'CLOSED') AND RESOLVED_AT IS NOT NULL THEN
      ROUND((CAST(RESOLVED_AT AS DATE) - CAST(CREATED_ON AS DATE)) * 24, 1)
    ELSE NULL
  END AS RESOLUTION_HOURS
FROM BUG_REPORTS;

PROMPT    View V_BUG_REPORTS created successfully.

-- ─────────────────────────────────────────────────────────────────────────
-- Installation Complete
-- ─────────────────────────────────────────────────────────────────────────
PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT Installation Complete!
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT Objects created:
PROMPT   - Table:   BUG_REPORTS
PROMPT   - Indexes: 6 indexes for performance
PROMPT   - Trigger: TRG_BUG_REPORTS_AUDIT
PROMPT   - View:    V_BUG_REPORTS
PROMPT
PROMPT Next steps:
PROMPT   1. Create the APEX Ajax Callback manually in APEX Builder
PROMPT      (See 05_apex_ajax_callback.sql for the PL/SQL code)
PROMPT   2. Upload bug-reporter.js to your APEX application
PROMPT   3. Initialize BugReporter in your application JavaScript
PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
