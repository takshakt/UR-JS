# Bug Reporter Widget - Implementation Plan

## Overview

A **generic, portable** floating bug reporting button for Oracle APEX applications. Designed as a drop-in plugin that works with minimal configuration. Captures comprehensive diagnostic information, screenshots, and submits via webhook (n8n). Future-ready for AI-first analysis.

## Confirmed Requirements
- **Storage**: Both APEX table AND webhook (log locally first, then call n8n)
- **Authentication**: API Key header for n8n webhook
- **Position**: Bottom-right (configurable)
- **Attachments**: 5MB per file, max 3 files
- **Data Format**: JSON for all data except screenshot/attachments (BLOBs)
- **Generic**: No hardcoded project-specific references

---

## Architecture

### Component Structure
```
bug-reporter-plugin/
├── bug-reporter.js         # Main widget (single file, self-contained)
├── IMPLEMENTATION_PLAN.md  # This file
└── README.md               # Integration guide (to be created)
```

### Class Design
```javascript
(function(global) {
  'use strict';

  class BugReporter {
    constructor(options) { ... }

    // Core Methods
    async init()
    async gatherDiagnostics()
    async captureScreenshot()
    render()
    setupEventListeners()

    // UI Methods
    openReportModal()
    closeReportModal()
    showLoadingState()
    showSuccessState()

    // Data Collection
    getConsoleErrors()
    getApexErrors()
    getSessionInfo()
    getFormItemValues()
    getBrowserInfo()
    getSystemInfo()

    // Submission
    async submitReport()
    async callWebhook()
  }

  global.BugReporter = BugReporter;
})(window);
```

---

## Data Collection Strategy

### 1. Console Errors & Warnings
- Override `console.error` and `console.warn` to capture logs
- Store last N errors/warnings in circular buffer
- Capture timestamp and stack trace

### 2. APEX Errors
- Hook into `apex.message` API
- Capture validation errors via `apex.message.getErrors()`
- Monitor AJAX failures from `apex.server.process`

### 3. Session Variables
- Current page items: `apex.item().getValue()` for all items
- App user: `apex.env.APP_USER`
- App ID: `apex.env.APP_ID`
- Page ID: `apex.env.APP_PAGE_ID`
- Session ID: `apex.env.APP_SESSION`
- Debug mode: `apex.env.APP_DEBUG`

### 4. Browser/System Info
- User Agent parsing for browser/OS
- Screen resolution
- Viewport size
- Timezone
- Language
- Online status

### 5. Screenshot Capture
- Use `html2canvas` library (CDN loaded on demand)
- Capture visible viewport
- Convert to base64 PNG
- Option to redact sensitive fields

---

## UI Design

### Floating Button
- Fixed position (bottom-right, configurable)
- Subtle but visible (accent color with icon)
- Hover state with tooltip
- Minimalistic circular design
- Optional pulse animation for emphasis

### Report Modal
```
┌─────────────────────────────────────────────┐
│  [X]  Report an Issue                       │
├─────────────────────────────────────────────┤
│  📸 Screenshot captured                     │
│  [Preview] [Retake]                         │
│                                             │
│  Issue Title *                              │
│  ┌─────────────────────────────────────┐   │
│  │                                     │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  Description *                              │
│  ┌─────────────────────────────────────┐   │
│  │                                     │   │
│  │                                     │   │
│  │                                     │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  Urgency           Impact                   │
│  ○ Low             ○ Just me                │
│  ○ Medium          ○ My team                │
│  ○ High            ○ Multiple teams         │
│  ○ Critical        ○ Entire organization    │
│                                             │
│  📎 Attach files (optional)                 │
│  ┌─────────────────────────────────────┐   │
│  │  Drag files here or click to browse │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  ┌─ Diagnostics captured ──────────────┐   │
│  │ ✓ Console (3 errors, 2 warnings)    │   │
│  │ ✓ Session info                      │   │
│  │ ✓ Form values (24 items)            │   │
│  │ ✓ Browser: Chrome 120 / Windows 11  │   │
│  └─────────────────────────────────────┘   │
│                                             │
│         [Cancel]  [Submit Report]           │
└─────────────────────────────────────────────┘
```

---

## Configuration Options

```javascript
BugReporter.init({
  // ═══════════════════════════════════════════════════════════
  // REQUIRED - Minimum configuration to get started
  // ═══════════════════════════════════════════════════════════
  webhookUrl: 'https://your-n8n.com/webhook/bug-report',
  webhookApiKey: 'your-api-key',           // Sent as X-API-Key header

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - Appearance
  // ═══════════════════════════════════════════════════════════
  position: 'bottom-right',                // bottom-right, bottom-left, top-right, top-left
  theme: 'auto',                           // auto, light, dark
  buttonIcon: 'bug',                       // bug, help, support
  buttonText: '',                          // Optional text next to icon
  accentColor: '#4f46e5',                  // Primary accent color
  zIndex: 99999,                           // Z-index for floating button

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - Data Collection
  // ═══════════════════════════════════════════════════════════
  enableScreenshot: true,
  enableConsoleLogs: true,
  maxConsoleLogs: 50,
  enableFormCapture: true,
  sensitiveFields: ['password', 'credit_card', 'ssn', 'pin', 'cvv'],

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - Attachments
  // ═══════════════════════════════════════════════════════════
  maxFileSize: 5 * 1024 * 1024,            // 5MB per file
  maxFiles: 3,
  allowedFileTypes: ['image/*', 'application/pdf', 'text/*', '.log', '.json'],

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - APEX Integration (auto-detected if apex.env exists)
  // ═══════════════════════════════════════════════════════════
  apexProcessName: 'AJX_LOG_BUG_REPORT',   // Set to null to disable APEX logging

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - User Info (auto-detected from APEX if available)
  // ═══════════════════════════════════════════════════════════
  userName: '',                             // Falls back to apex.env.APP_USER
  userEmail: '',                            // Falls back to apex session if available
  userRole: '',

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - Future AI Extension
  // ═══════════════════════════════════════════════════════════
  enableAIAnalysis: false,
  aiEndpoint: '',
  aiApiKey: '',

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - Callbacks
  // ═══════════════════════════════════════════════════════════
  onOpen: () => {},
  onSubmit: (data) => {},
  onSuccess: (response) => {},
  onError: (error) => {}
});
```

### Minimal Setup Example
```javascript
// Just 2 lines to get started!
BugReporter.init({
  webhookUrl: 'https://n8n.example.com/webhook/bugs',
  webhookApiKey: 'abc123'
});
```

---

## Webhook Payload Structure

```json
{
  "reportId": "uuid-v4",
  "timestamp": "2024-01-15T10:30:00Z",

  "issue": {
    "title": "User entered title",
    "description": "User entered description",
    "urgency": "high",
    "impact": "multiple_teams"
  },

  "reporter": {
    "userName": "john.doe",
    "userEmail": "john@example.com",
    "userRole": "Manager",
    "ipAddress": "192.168.1.100"
  },

  "apex": {
    "appId": "103",
    "pageId": "10",
    "sessionId": "123456789",
    "appUser": "JOHN.DOE",
    "debugMode": false,
    "pageItems": {
      "P10_HOTEL_ID": "42",
      "P10_DATE_FROM": "2024-01-01"
    },
    "errors": []
  },

  "console": {
    "errors": [
      {
        "message": "Uncaught TypeError...",
        "stack": "...",
        "timestamp": "2024-01-15T10:29:55Z"
      }
    ],
    "warnings": []
  },

  "environment": {
    "browser": "Chrome 120.0.0",
    "os": "Windows 11",
    "screenResolution": "1920x1080",
    "viewportSize": "1200x800",
    "timezone": "America/New_York",
    "language": "en-US",
    "online": true,
    "userAgent": "Mozilla/5.0..."
  },

  "screenshot": "base64-encoded-png",
  "attachments": [
    {
      "name": "error-log.txt",
      "type": "text/plain",
      "size": 1234,
      "data": "base64-encoded"
    }
  ]
}
```

---

## Database Table Design (for APEX logging)

```sql
-- ═══════════════════════════════════════════════════════════════════════════
-- BUG_REPORTS - Main table for storing bug reports
-- All diagnostic data stored as structured JSON for easy n8n processing
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE BUG_REPORTS (
  -- Primary Key (SYS_GUID for distributed/unique IDs)
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
  -- ─────────────────────────────────────────────────────────────────────────
  REPORT_DATA        CLOB CONSTRAINT CHK_REPORT_DATA_JSON CHECK (REPORT_DATA IS JSON),
  /*
    REPORT_DATA JSON structure:
    {
      "reporter": {
        "userName": "john.doe",
        "userEmail": "john@example.com",
        "userRole": "Manager",
        "ipAddress": "192.168.1.100"
      },
      "apex": {
        "appId": 103,
        "pageId": 10,
        "sessionId": "123456789",
        "appUser": "JOHN.DOE",
        "debugMode": false,
        "pageItems": { "P10_HOTEL_ID": "42", ... },
        "errors": []
      },
      "console": {
        "errors": [{ "message": "...", "stack": "...", "timestamp": "..." }],
        "warnings": [...]
      },
      "environment": {
        "browser": "Chrome 120.0.0",
        "os": "Windows 11",
        "screenResolution": "1920x1080",
        "viewportSize": "1200x800",
        "timezone": "America/New_York",
        "language": "en-US",
        "online": true,
        "userAgent": "Mozilla/5.0...",
        "url": "https://example.com/app/f?p=103:10"
      }
    }
  */

  -- ─────────────────────────────────────────────────────────────────────────
  -- Binary Data (Screenshot & Attachments - stored separately for performance)
  -- ─────────────────────────────────────────────────────────────────────────
  SCREENSHOT_BLOB    BLOB,
  ATTACHMENTS_BLOB   BLOB,                -- Stored as ZIP if multiple files
  ATTACHMENTS_META   CLOB CONSTRAINT CHK_ATTACH_META_JSON CHECK (ATTACHMENTS_META IS JSON),
  /*
    ATTACHMENTS_META JSON structure:
    [
      { "name": "error.log", "type": "text/plain", "size": 1234, "index": 0 },
      { "name": "screen2.png", "type": "image/png", "size": 56789, "index": 1 }
    ]
  */

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

-- ═══════════════════════════════════════════════════════════════════════════
-- Indexes for common queries
-- ═══════════════════════════════════════════════════════════════════════════
CREATE INDEX IDX_BUG_REPORTS_STATUS ON BUG_REPORTS(STATUS);
CREATE INDEX IDX_BUG_REPORTS_REPORTER ON BUG_REPORTS(REPORTER);
CREATE INDEX IDX_BUG_REPORTS_CREATED ON BUG_REPORTS(CREATED_ON);
CREATE INDEX IDX_BUG_REPORTS_URGENCY ON BUG_REPORTS(URGENCY);

-- JSON search index (optional, for searching within REPORT_DATA)
CREATE SEARCH INDEX IDX_BUG_REPORTS_JSON ON BUG_REPORTS(REPORT_DATA) FOR JSON;

-- ═══════════════════════════════════════════════════════════════════════════
-- Trigger for auto-updating UPDATED_ON
-- ═══════════════════════════════════════════════════════════════════════════
CREATE OR REPLACE TRIGGER TRG_BUG_REPORTS_UPDATED
BEFORE UPDATE ON BUG_REPORTS
FOR EACH ROW
BEGIN
  :NEW.UPDATED_ON := SYSTIMESTAMP;
END;
/

-- ═══════════════════════════════════════════════════════════════════════════
-- Helper view for easy querying with extracted JSON fields
-- ═══════════════════════════════════════════════════════════════════════════
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
  -- Extract commonly queried fields from JSON
  JSON_VALUE(REPORT_DATA, '$.apex.appId') AS APP_ID,
  JSON_VALUE(REPORT_DATA, '$.apex.pageId') AS PAGE_ID,
  JSON_VALUE(REPORT_DATA, '$.environment.browser') AS BROWSER,
  JSON_VALUE(REPORT_DATA, '$.environment.os') AS OS,
  JSON_VALUE(REPORT_DATA, '$.reporter.userEmail') AS REPORTER_EMAIL,
  -- Full JSON for detailed access
  REPORT_DATA,
  -- Flags
  CASE WHEN SCREENSHOT_BLOB IS NOT NULL THEN 'Y' ELSE 'N' END AS HAS_SCREENSHOT,
  CASE WHEN ATTACHMENTS_BLOB IS NOT NULL THEN 'Y' ELSE 'N' END AS HAS_ATTACHMENTS,
  WEBHOOK_SENT,
  -- Audit
  CREATED_BY,
  CREATED_ON,
  UPDATED_BY,
  UPDATED_ON,
  RESOLVED_AT
FROM BUG_REPORTS;
```

---

## Implementation Steps

### Phase 1: Core Widget
1. Create `bug-reporter.js` with IIFE + Class structure
2. Implement floating button with CSS
3. Implement modal dialog UI
4. Add form validation

### Phase 2: Data Collection
5. Implement console log interception
6. Implement APEX data gathering
7. Implement browser/system info collection
8. Integrate html2canvas for screenshots

### Phase 3: Submission
9. Implement file attachment handling
10. Implement webhook submission
11. Add APEX process integration (optional)
12. Add success/error states

### Phase 4: Polish
13. Add theme support (light/dark)
14. Add responsive design
15. Add keyboard navigation
16. Add loading states and animations

### Phase 5: Future - AI Analysis (Extension Point)
17. Add AI endpoint configuration
18. Implement pre-submission analysis
19. Add suggested categories/solutions
20. Add similar issues detection

---

## APEX Integration

### Global Page JavaScript (Page 0 or Application JS)
```javascript
// Initialize bug reporter on page load
BugReporter.init({
  webhookUrl: '&G_BUG_WEBHOOK_URL.',
  webhookApiKey: '&G_BUG_WEBHOOK_KEY.'
  // Everything else is auto-detected from APEX environment
});
```

### APEX Ajax Callback (AJX_LOG_BUG_REPORT)
```sql
DECLARE
  l_report_json   CLOB := apex_application.g_x01;  -- JSON payload
  l_screenshot    BLOB := apex_application.g_clob01; -- Screenshot as base64
  l_id            RAW(16);
  l_json          JSON_OBJECT_T;
  l_title         VARCHAR2(500);
  l_description   CLOB;
  l_urgency       VARCHAR2(20);
  l_impact        VARCHAR2(50);
  l_reporter      VARCHAR2(255);
BEGIN
  -- Parse the JSON
  l_json := JSON_OBJECT_T.parse(l_report_json);

  -- Extract top-level fields for queryable columns
  l_title       := l_json.get_string('title');
  l_description := l_json.get_clob('description');
  l_urgency     := l_json.get_string('urgency');
  l_impact      := l_json.get_string('impact');
  l_reporter    := l_json.get_object('reporter').get_string('userName');

  -- Insert the bug report
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
    apex_web_service.clobbase642blob(l_screenshot),
    :APP_USER
  )
  RETURNING ID INTO l_id;

  -- Return success with report ID
  apex_json.open_object;
  apex_json.write('success', true);
  apex_json.write('reportId', RAWTOHEX(l_id));
  apex_json.close_object;

EXCEPTION
  WHEN OTHERS THEN
    apex_json.open_object;
    apex_json.write('success', false);
    apex_json.write('error', SQLERRM);
    apex_json.close_object;
END;
```

---

## CDN Dependencies

```javascript
const CDN_DEPS = {
  html2canvas: {
    url: 'https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js',
    check: () => typeof html2canvas !== 'undefined'
  }
};
```

---

## Key Design Decisions

1. **Single JS File**: All CSS embedded for easy deployment (just include one script)
2. **Zero Dependencies**: Uses vanilla JS (works with or without jQuery)
3. **APEX Auto-Detection**: Automatically uses APEX APIs when available, works standalone otherwise
4. **Minimal Config**: Only webhook URL + API key required to start
5. **Privacy-First**: Configurable sensitive field redaction
6. **JSON-Centric**: All diagnostic data as structured JSON for easy n8n processing
7. **Extensible**: Clean hooks for future AI integration
8. **Accessible**: Keyboard navigation, ARIA labels, focus management

---

## File to Create

| File | Description |
|------|-------------|
| `bug-reporter-plugin/bug-reporter.js` | Main widget (~900-1100 lines, self-contained) |

---

## Implementation Checklist

### Phase 1: Core Widget Structure
- [ ] Create `bug-reporter.js` with IIFE + Class pattern
- [ ] Embed CSS styles with CSS variables for theming
- [ ] Implement floating button (configurable position)
- [ ] Implement modal dialog UI with form

### Phase 2: Data Collection
- [ ] Console log interception (override console.error/warn with circular buffer)
- [ ] APEX data gathering (auto-detect if apex.* APIs exist)
- [ ] Browser/system info collection (UA parsing, screen size, etc.)
- [ ] Screenshot capture via html2canvas (CDN loaded on demand)

### Phase 3: Form & Validation
- [ ] Title field (required)
- [ ] Description field (required)
- [ ] Urgency selector (Low, Medium, High, Critical)
- [ ] Impact selector (Just me, My team, Multiple teams, Organization)
- [ ] File attachment dropzone (5MB max, 3 files max)
- [ ] Form validation with error messages

### Phase 4: Submission Flow
- [ ] Gather all diagnostics into structured JSON payload
- [ ] Submit to APEX process if available (AJX_LOG_BUG_REPORT)
- [ ] Call webhook with X-API-Key header
- [ ] Handle success/error states with user feedback
- [ ] Show confirmation with report ID

### Phase 5: Polish
- [ ] Loading states and animations
- [ ] Keyboard navigation (Escape to close, Tab order)
- [ ] Responsive design for mobile
- [ ] Theme support (light/dark/auto)
- [ ] Screenshot preview in modal

---

## APEX Objects to Create (Manually by User)

| Object | Type | Required |
|--------|------|----------|
| `BUG_REPORTS` | Database Table | Yes (for APEX logging) |
| `V_BUG_REPORTS` | View | Optional (for easy querying) |
| `TRG_BUG_REPORTS_UPDATED` | Trigger | Optional (auto-update timestamp) |
| `AJX_LOG_BUG_REPORT` | APEX Ajax Callback | Yes (for APEX logging) |
| `G_BUG_WEBHOOK_URL` | Application Substitution | Yes |
| `G_BUG_WEBHOOK_KEY` | Application Substitution | Yes |

---

## Quick Start Guide

### 1. Include the Script
```html
<script src="https://your-cdn.com/bug-reporter.js"></script>
```

### 2. Initialize (Minimal)
```javascript
BugReporter.init({
  webhookUrl: 'https://n8n.example.com/webhook/bugs',
  webhookApiKey: 'your-api-key'
});
```

### 3. (Optional) Create Database Objects
Run the SQL from the Database Table Design section above.

### 4. Done!
The floating bug button will appear on your page.
