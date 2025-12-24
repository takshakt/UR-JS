-- ═══════════════════════════════════════════════════════════════════════════
-- BUG_REPORTS Table
-- Main table for storing bug reports submitted via Bug Reporter Plugin
-- ═══════════════════════════════════════════════════════════════════════════

CREATE TABLE BUG_REPORTS (
  -- ─────────────────────────────────────────────────────────────────────────
  -- Primary Key (SYS_GUID for distributed/unique IDs)
  -- ─────────────────────────────────────────────────────────────────────────
  ID                 RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,

  -- ─────────────────────────────────────────────────────────────────────────
  -- Core Issue Data (queryable fields)
  -- ─────────────────────────────────────────────────────────────────────────
  TITLE              VARCHAR2(500) NOT NULL,
  DESCRIPTION        CLOB,
  URGENCY            VARCHAR2(20) CHECK (URGENCY IN ('low', 'medium', 'high', 'critical')),
  IMPACT             VARCHAR2(50) CHECK (IMPACT IN ('single_user', 'team', 'multiple_teams', 'organization')),
  STATUS             VARCHAR2(30) DEFAULT 'NEW' CHECK (STATUS IN ('NEW', 'TRIAGED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED', 'WONT_FIX')),

  -- ─────────────────────────────────────────────────────────────────────────
  -- Reporter (queryable)
  -- ─────────────────────────────────────────────────────────────────────────
  REPORTER           VARCHAR2(255),

  -- ─────────────────────────────────────────────────────────────────────────
  -- All Diagnostic Data as JSON (for n8n flexibility)
  -- Contains: reporter details, apex info, console logs, environment info
  -- ─────────────────────────────────────────────────────────────────────────
  REPORT_DATA        CLOB CONSTRAINT CHK_REPORT_DATA_JSON CHECK (REPORT_DATA IS JSON),

  -- ─────────────────────────────────────────────────────────────────────────
  -- Binary Data (Screenshot & Attachments - stored separately for performance)
  -- ─────────────────────────────────────────────────────────────────────────
  SCREENSHOT_BLOB    BLOB,
  ATTACHMENTS_BLOB   BLOB,
  ATTACHMENTS_META   CLOB CONSTRAINT CHK_ATTACH_META_JSON CHECK (ATTACHMENTS_META IS JSON OR ATTACHMENTS_META IS NULL),

  -- ─────────────────────────────────────────────────────────────────────────
  -- Webhook Tracking
  -- ─────────────────────────────────────────────────────────────────────────
  WEBHOOK_SENT       VARCHAR2(1) DEFAULT 'N' CHECK (WEBHOOK_SENT IN ('Y', 'N')),
  WEBHOOK_RESPONSE   CLOB,
  WEBHOOK_SENT_AT    TIMESTAMP,

  -- ─────────────────────────────────────────────────────────────────────────
  -- AI Analysis (Future Extension)
  -- ─────────────────────────────────────────────────────────────────────────
  AI_ANALYSIS        CLOB CONSTRAINT CHK_AI_ANALYSIS_JSON CHECK (AI_ANALYSIS IS JSON OR AI_ANALYSIS IS NULL),

  -- ─────────────────────────────────────────────────────────────────────────
  -- Standard Audit Fields
  -- ─────────────────────────────────────────────────────────────────────────
  CREATED_BY         VARCHAR2(255),
  CREATED_ON         TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  UPDATED_BY         VARCHAR2(255),
  UPDATED_ON         TIMESTAMP,
  RESOLVED_AT        TIMESTAMP
);

-- Add table comment
COMMENT ON TABLE BUG_REPORTS IS 'Stores bug reports submitted via the Bug Reporter Plugin';

-- Add column comments
COMMENT ON COLUMN BUG_REPORTS.ID IS 'Primary key using SYS_GUID for unique identification';
COMMENT ON COLUMN BUG_REPORTS.TITLE IS 'Brief description of the issue';
COMMENT ON COLUMN BUG_REPORTS.DESCRIPTION IS 'Detailed description of what happened';
COMMENT ON COLUMN BUG_REPORTS.URGENCY IS 'Issue urgency: low, medium, high, critical';
COMMENT ON COLUMN BUG_REPORTS.IMPACT IS 'Scope of impact: single_user, team, multiple_teams, organization';
COMMENT ON COLUMN BUG_REPORTS.STATUS IS 'Current status: NEW, TRIAGED, IN_PROGRESS, RESOLVED, CLOSED, WONT_FIX';
COMMENT ON COLUMN BUG_REPORTS.REPORTER IS 'Username of the person who reported the issue';
COMMENT ON COLUMN BUG_REPORTS.REPORT_DATA IS 'JSON containing all diagnostic data (APEX info, console logs, environment)';
COMMENT ON COLUMN BUG_REPORTS.SCREENSHOT_BLOB IS 'Screenshot image captured at time of report';
COMMENT ON COLUMN BUG_REPORTS.ATTACHMENTS_BLOB IS 'Additional file attachments (stored as ZIP if multiple)';
COMMENT ON COLUMN BUG_REPORTS.ATTACHMENTS_META IS 'JSON metadata about attachments (name, type, size)';
COMMENT ON COLUMN BUG_REPORTS.WEBHOOK_SENT IS 'Y/N flag indicating if webhook was called successfully';
COMMENT ON COLUMN BUG_REPORTS.WEBHOOK_RESPONSE IS 'Response received from webhook call';
COMMENT ON COLUMN BUG_REPORTS.WEBHOOK_SENT_AT IS 'Timestamp when webhook was called';
COMMENT ON COLUMN BUG_REPORTS.AI_ANALYSIS IS 'JSON containing AI analysis results (future feature)';
COMMENT ON COLUMN BUG_REPORTS.CREATED_BY IS 'User who created the record';
COMMENT ON COLUMN BUG_REPORTS.CREATED_ON IS 'Timestamp when record was created';
COMMENT ON COLUMN BUG_REPORTS.UPDATED_BY IS 'User who last updated the record';
COMMENT ON COLUMN BUG_REPORTS.UPDATED_ON IS 'Timestamp when record was last updated';
COMMENT ON COLUMN BUG_REPORTS.RESOLVED_AT IS 'Timestamp when issue was resolved';
