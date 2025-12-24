-- ═══════════════════════════════════════════════════════════════════════════
-- Bug Reporter Plugin - Uninstall Script
--
-- This script removes all database objects created by the Bug Reporter Plugin.
-- WARNING: This will permanently delete all bug report data!
--
-- Note: The APEX Ajax Callback (AJX_LOG_BUG_REPORT) must be deleted manually
--       through the APEX Builder interface.
-- ═══════════════════════════════════════════════════════════════════════════

PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT Bug Reporter Plugin - Uninstall
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT WARNING: This will permanently delete all bug report data!
PROMPT

-- ─────────────────────────────────────────────────────────────────────────
-- Step 1: Drop View
-- ─────────────────────────────────────────────────────────────────────────
PROMPT Step 1: Dropping view...
BEGIN
  EXECUTE IMMEDIATE 'DROP VIEW V_BUG_REPORTS';
  DBMS_OUTPUT.PUT_LINE('   View V_BUG_REPORTS dropped.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('   View V_BUG_REPORTS does not exist or already dropped.');
END;
/

-- ─────────────────────────────────────────────────────────────────────────
-- Step 2: Drop Trigger
-- ─────────────────────────────────────────────────────────────────────────
PROMPT Step 2: Dropping trigger...
BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER TRG_BUG_REPORTS_AUDIT';
  DBMS_OUTPUT.PUT_LINE('   Trigger TRG_BUG_REPORTS_AUDIT dropped.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('   Trigger TRG_BUG_REPORTS_AUDIT does not exist or already dropped.');
END;
/

-- ─────────────────────────────────────────────────────────────────────────
-- Step 3: Drop Indexes (will be dropped with table, but explicit for clarity)
-- ─────────────────────────────────────────────────────────────────────────
PROMPT Step 3: Dropping indexes...
BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX IDX_BUG_REPORTS_STATUS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX IDX_BUG_REPORTS_REPORTER';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX IDX_BUG_REPORTS_CREATED';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX IDX_BUG_REPORTS_URGENCY';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX IDX_BUG_REPORTS_STATUS_DATE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP INDEX IDX_BUG_REPORTS_WEBHOOK';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
PROMPT    Indexes dropped.

-- ─────────────────────────────────────────────────────────────────────────
-- Step 4: Drop Table
-- ─────────────────────────────────────────────────────────────────────────
PROMPT Step 4: Dropping table...
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE BUG_REPORTS CASCADE CONSTRAINTS';
  DBMS_OUTPUT.PUT_LINE('   Table BUG_REPORTS dropped.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('   Table BUG_REPORTS does not exist or already dropped.');
END;
/

-- ─────────────────────────────────────────────────────────────────────────
-- Uninstall Complete
-- ─────────────────────────────────────────────────────────────────────────
PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT Uninstall Complete!
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT Objects removed:
PROMPT   - View:    V_BUG_REPORTS
PROMPT   - Trigger: TRG_BUG_REPORTS_AUDIT
PROMPT   - Indexes: All BUG_REPORTS indexes
PROMPT   - Table:   BUG_REPORTS
PROMPT
PROMPT Don't forget to also:
PROMPT   1. Delete the APEX Ajax Callback (AJX_LOG_BUG_REPORT) in APEX Builder
PROMPT   2. Remove bug-reporter.js from your APEX application files
PROMPT   3. Remove the BugReporter.init() call from your application JavaScript
PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
