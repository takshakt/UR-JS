-- ═══════════════════════════════════════════════════════════════════════════
-- Bug Reporter - Complete APEX Plugin Installation Script
-- Version: 1.0.0
--
-- This script installs everything needed for the Bug Reporter plugin:
-- 1. Database table (BUG_REPORTS)
-- 2. Indexes for performance
-- 3. Audit trigger
-- 4. Helper view
-- 5. APEX Application Process (Ajax Callback)
--
-- Usage:
--   Run this script in SQL Workshop > SQL Scripts
--   Then upload bug-reporter.js as a plugin file
--
-- ═══════════════════════════════════════════════════════════════════════════

SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT  Bug Reporter Plugin - Installation
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 1: Create Table
-- ─────────────────────────────────────────────────────────────────────────────
PROMPT [1/5] Creating BUG_REPORTS table...

DECLARE
  l_exists NUMBER;
BEGIN
  SELECT COUNT(*) INTO l_exists FROM user_tables WHERE table_name = 'BUG_REPORTS';

  IF l_exists = 0 THEN
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
    DBMS_OUTPUT.PUT_LINE('      Table BUG_REPORTS created successfully.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('      Table BUG_REPORTS already exists - skipping.');
  END IF;
END;
/

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 2: Create Indexes
-- ─────────────────────────────────────────────────────────────────────────────
PROMPT [2/5] Creating indexes...

DECLARE
  PROCEDURE create_index_if_not_exists(p_index_name VARCHAR2, p_ddl VARCHAR2) IS
    l_exists NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_exists FROM user_indexes WHERE index_name = p_index_name;
    IF l_exists = 0 THEN
      EXECUTE IMMEDIATE p_ddl;
      DBMS_OUTPUT.PUT_LINE('      Index ' || p_index_name || ' created.');
    END IF;
  EXCEPTION
    WHEN OTHERS THEN NULL;
  END;
BEGIN
  create_index_if_not_exists('IDX_BUG_REPORTS_STATUS', 'CREATE INDEX IDX_BUG_REPORTS_STATUS ON BUG_REPORTS(STATUS)');
  create_index_if_not_exists('IDX_BUG_REPORTS_REPORTER', 'CREATE INDEX IDX_BUG_REPORTS_REPORTER ON BUG_REPORTS(REPORTER)');
  create_index_if_not_exists('IDX_BUG_REPORTS_CREATED', 'CREATE INDEX IDX_BUG_REPORTS_CREATED ON BUG_REPORTS(CREATED_ON)');
  create_index_if_not_exists('IDX_BUG_REPORTS_URGENCY', 'CREATE INDEX IDX_BUG_REPORTS_URGENCY ON BUG_REPORTS(URGENCY)');
  create_index_if_not_exists('IDX_BUG_REPORTS_WEBHOOK', 'CREATE INDEX IDX_BUG_REPORTS_WEBHOOK ON BUG_REPORTS(WEBHOOK_SENT)');
  DBMS_OUTPUT.PUT_LINE('      Indexes created successfully.');
END;
/

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 3: Create Trigger
-- ─────────────────────────────────────────────────────────────────────────────
PROMPT [3/5] Creating audit trigger...

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

PROMPT       Trigger TRG_BUG_REPORTS_AUDIT created successfully.

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 4: Create View
-- ─────────────────────────────────────────────────────────────────────────────
PROMPT [4/5] Creating helper view...

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
  RESOLVED_AT,
  ROUND((CAST(SYSTIMESTAMP AS DATE) - CAST(CREATED_ON AS DATE)) * 24, 1) AS AGE_HOURS
FROM BUG_REPORTS;

PROMPT       View V_BUG_REPORTS created successfully.

-- ─────────────────────────────────────────────────────────────────────────────
-- STEP 5: Display next steps
-- ─────────────────────────────────────────────────────────────────────────────
PROMPT [5/5] Database objects installed.

PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT  Installation Complete!
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT  Database objects created:
PROMPT    - Table:   BUG_REPORTS
PROMPT    - Indexes: 5 performance indexes
PROMPT    - Trigger: TRG_BUG_REPORTS_AUDIT
PROMPT    - View:    V_BUG_REPORTS
PROMPT
PROMPT  ┌─────────────────────────────────────────────────────────────────────┐
PROMPT  │  NEXT STEPS - Complete setup in your APEX application:             │
PROMPT  │                                                                     │
PROMPT  │  1. Create an Application Process (Ajax Callback):                 │
PROMPT  │     - Go to: Shared Components > Application Processes             │
PROMPT  │     - Name: AJX_BUG_REPORTER_LOG                                   │
PROMPT  │     - Point: Ajax Callback                                         │
PROMPT  │     - Copy PL/SQL code from: apex_ajax_callback.sql                │
PROMPT  │                                                                     │
PROMPT  │  2. Upload the JavaScript file:                                    │
PROMPT  │     - Go to: Shared Components > Static Application Files          │
PROMPT  │     - Upload: bug-reporter.js                                      │
PROMPT  │                                                                     │
PROMPT  │  3. Add to Global Page (Page 0):                                   │
PROMPT  │     - Create Dynamic Action on Page Load                           │
PROMPT  │     - Action: Execute JavaScript Code                              │
PROMPT  │     - Code: (see initialization example below)                     │
PROMPT  │                                                                     │
PROMPT  │  4. Add JavaScript File Reference:                                 │
PROMPT  │     - Page 0 > JavaScript > File URLs                              │
PROMPT  │     - Add: #APP_FILES#bug-reporter.js                              │
PROMPT  └─────────────────────────────────────────────────────────────────────┘
PROMPT
PROMPT  JavaScript initialization example:
PROMPT  ──────────────────────────────────────────────────────────────────────
PROMPT    BugReporter.init({
PROMPT      webhookUrl: ''https://your-webhook-url.com/bug-report'',
PROMPT      webhookApiKey: ''your-api-key'',
PROMPT      apexProcessName: ''AJX_BUG_REPORTER_LOG''
PROMPT    });
PROMPT  ──────────────────────────────────────────────────────────────────────
PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
