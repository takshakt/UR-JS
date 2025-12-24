-- ═══════════════════════════════════════════════════════════════════════════
-- BUG_REPORTS Indexes
-- Indexes for optimizing common queries on the BUG_REPORTS table
-- ═══════════════════════════════════════════════════════════════════════════

-- Index on STATUS for filtering by current state
CREATE INDEX IDX_BUG_REPORTS_STATUS ON BUG_REPORTS(STATUS);

-- Index on REPORTER for filtering by who reported
CREATE INDEX IDX_BUG_REPORTS_REPORTER ON BUG_REPORTS(REPORTER);

-- Index on CREATED_ON for date-based queries and sorting
CREATE INDEX IDX_BUG_REPORTS_CREATED ON BUG_REPORTS(CREATED_ON);

-- Index on URGENCY for priority-based filtering
CREATE INDEX IDX_BUG_REPORTS_URGENCY ON BUG_REPORTS(URGENCY);

-- Composite index for common dashboard queries (status + created date)
CREATE INDEX IDX_BUG_REPORTS_STATUS_DATE ON BUG_REPORTS(STATUS, CREATED_ON DESC);

-- Index on WEBHOOK_SENT for finding unsent webhooks
CREATE INDEX IDX_BUG_REPORTS_WEBHOOK ON BUG_REPORTS(WEBHOOK_SENT);

-- ═══════════════════════════════════════════════════════════════════════════
-- JSON Search Index (Optional - for searching within REPORT_DATA)
-- Note: This requires Oracle 12.2+ with JSON support
-- Uncomment if you need to search within the JSON payload
-- ═══════════════════════════════════════════════════════════════════════════

-- CREATE SEARCH INDEX IDX_BUG_REPORTS_JSON ON BUG_REPORTS(REPORT_DATA) FOR JSON;
