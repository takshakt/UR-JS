-- ═══════════════════════════════════════════════════════════════════════════
-- Bug Reporter - APEX Dynamic Action Plugin
-- Version: 1.0.0
--
-- Installation:
-- 1. Run this script in SQL Workshop to create database objects
-- 2. Import the plugin via Shared Components > Plug-ins > Import
-- 3. Add the Dynamic Action to Global Page (Page 0) on Page Load
--
-- Or use the combined installer: bug_reporter_install.sql
-- ═══════════════════════════════════════════════════════════════════════════

PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT Bug Reporter Plugin - Database Objects Installation
PROMPT ═══════════════════════════════════════════════════════════════════════════

-- ─────────────────────────────────────────────────────────────────────────────
-- Create Table
-- ─────────────────────────────────────────────────────────────────────────────
PROMPT Creating BUG_REPORTS table...

BEGIN
  EXECUTE IMMEDIATE '
    CREATE TABLE BUG_REPORTS (
      ID                 RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,
      TITLE              VARCHAR2(500) NOT NULL,
      DESCRIPTION        CLOB,
      URGENCY            VARCHAR2(20) CHECK (URGENCY IN (''low'', ''medium'', ''high'', ''critical'')),
      IMPACT             VARCHAR2(50) CHECK (IMPACT IN (''single_user'', ''team'', ''multiple_teams'', ''organization'')),
      STATUS             VARCHAR2(30) DEFAULT ''NEW'' CHECK (STATUS IN (''NEW'', ''TRIAGED'', ''IN_PROGRESS'', ''RESOLVED'', ''CLOSED'', ''WONT_FIX'')),
      REPORTER           VARCHAR2(255),
      REPORT_DATA        CLOB CONSTRAINT CHK_REPORT_DATA_JSON CHECK (REPORT_DATA IS JSON),
      SCREENSHOT_BLOB    BLOB,
      ATTACHMENTS_BLOB   BLOB,
      ATTACHMENTS_META   CLOB,
      WEBHOOK_SENT       VARCHAR2(1) DEFAULT ''N'' CHECK (WEBHOOK_SENT IN (''Y'', ''N'')),
      WEBHOOK_RESPONSE   CLOB,
      WEBHOOK_SENT_AT    TIMESTAMP,
      AI_ANALYSIS        CLOB,
      CREATED_BY         VARCHAR2(255),
      CREATED_ON         TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
      UPDATED_BY         VARCHAR2(255),
      UPDATED_ON         TIMESTAMP,
      RESOLVED_AT        TIMESTAMP
    )';
  DBMS_OUTPUT.PUT_LINE('Table BUG_REPORTS created.');
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -955 THEN
      DBMS_OUTPUT.PUT_LINE('Table BUG_REPORTS already exists.');
    ELSE
      RAISE;
    END IF;
END;
/

-- ─────────────────────────────────────────────────────────────────────────────
-- Create Indexes
-- ─────────────────────────────────────────────────────────────────────────────
PROMPT Creating indexes...

BEGIN EXECUTE IMMEDIATE 'CREATE INDEX IDX_BUG_REPORTS_STATUS ON BUG_REPORTS(STATUS)'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'CREATE INDEX IDX_BUG_REPORTS_REPORTER ON BUG_REPORTS(REPORTER)'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'CREATE INDEX IDX_BUG_REPORTS_CREATED ON BUG_REPORTS(CREATED_ON)'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'CREATE INDEX IDX_BUG_REPORTS_URGENCY ON BUG_REPORTS(URGENCY)'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ─────────────────────────────────────────────────────────────────────────────
-- Create Trigger
-- ─────────────────────────────────────────────────────────────────────────────
PROMPT Creating audit trigger...

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

-- ─────────────────────────────────────────────────────────────────────────────
-- Create View
-- ─────────────────────────────────────────────────────────────────────────────
PROMPT Creating view...

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
  JSON_VALUE(REPORT_DATA, '$.environment.browser') AS BROWSER,
  JSON_VALUE(REPORT_DATA, '$.environment.os') AS OS,
  JSON_VALUE(REPORT_DATA, '$.environment.url') AS PAGE_URL,
  JSON_VALUE(REPORT_DATA, '$.reporter.userEmail') AS REPORTER_EMAIL,
  REPORT_DATA,
  CASE WHEN SCREENSHOT_BLOB IS NOT NULL THEN 'Y' ELSE 'N' END AS HAS_SCREENSHOT,
  CASE WHEN ATTACHMENTS_BLOB IS NOT NULL THEN 'Y' ELSE 'N' END AS HAS_ATTACHMENTS,
  WEBHOOK_SENT,
  CREATED_BY,
  CREATED_ON,
  UPDATED_BY,
  UPDATED_ON,
  RESOLVED_AT
FROM BUG_REPORTS;

PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT Database objects created successfully!
PROMPT ═══════════════════════════════════════════════════════════════════════════
