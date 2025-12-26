-- ═══════════════════════════════════════════════════════════════════════════
-- Bug Reporter - Uninstall Script
--
-- WARNING: This will permanently delete all bug report data!
--
-- Run this script in SQL Workshop to remove all Bug Reporter database objects.
-- You must also manually:
--   1. Delete the Application Process (AJX_BUG_REPORTER_LOG)
--   2. Remove bug-reporter.js from Static Application Files
--   3. Remove the Dynamic Action from Global Page (Page 0)
-- ═══════════════════════════════════════════════════════════════════════════

SET SERVEROUTPUT ON

PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT  Bug Reporter Plugin - Uninstall
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT  WARNING: This will permanently delete all bug report data!
PROMPT

-- Drop View
PROMPT Dropping view V_BUG_REPORTS...
BEGIN
  EXECUTE IMMEDIATE 'DROP VIEW V_BUG_REPORTS';
  DBMS_OUTPUT.PUT_LINE('   View dropped.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('   View does not exist or already dropped.');
END;
/

-- Drop Trigger
PROMPT Dropping trigger TRG_BUG_REPORTS_AUDIT...
BEGIN
  EXECUTE IMMEDIATE 'DROP TRIGGER TRG_BUG_REPORTS_AUDIT';
  DBMS_OUTPUT.PUT_LINE('   Trigger dropped.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('   Trigger does not exist or already dropped.');
END;
/

-- Drop Table (cascades indexes and constraints)
PROMPT Dropping table BUG_REPORTS...
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE BUG_REPORTS CASCADE CONSTRAINTS';
  DBMS_OUTPUT.PUT_LINE('   Table and indexes dropped.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('   Table does not exist or already dropped.');
END;
/

PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT  Database objects removed.
PROMPT ═══════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT  Don't forget to also remove from APEX:
PROMPT    1. Application Process: AJX_BUG_REPORTER_LOG
PROMPT    2. Static File: bug-reporter.js
PROMPT    3. Dynamic Action on Page 0
PROMPT    4. JavaScript File URL reference
PROMPT
PROMPT ═══════════════════════════════════════════════════════════════════════════
