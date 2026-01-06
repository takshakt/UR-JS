# Bug Reporter Plugin

A portable, drop-in bug reporting widget for Oracle APEX applications. Captures screenshots, console errors, session data, and submits to webhooks (n8n compatible).

## Features

- **One-file solution** - Single JavaScript file with embedded CSS
- **Zero dependencies** - Works standalone, jQuery optional
- **APEX auto-detection** - Automatically captures APEX session data when available
- **Screenshot capture** - Automatic viewport screenshot using html2canvas
- **Console log capture** - Captures errors and warnings with stack traces
- **File attachments** - Drag & drop file uploads (configurable limits)
- **Theme support** - Light/dark mode with auto-detection
- **Webhook integration** - Submits to n8n or any webhook endpoint
- **Privacy-aware** - Configurable sensitive field redaction
- **Responsive** - Works on desktop and mobile

---

## Quick Start

### 1. Include the Script

Add to your APEX application's JavaScript file URL or inline:

```html
<script src="/path/to/bug-reporter.js"></script>
```

Or upload to APEX Static Application Files and reference it.

### 2. Initialize

Add this JavaScript to your **Global Page (Page 0)** or **Application JavaScript**:

```javascript
// Minimal setup - just webhook URL and API key
BugReporter.init({
  webhookUrl: 'https://your-n8n-instance.com/webhook/bug-report',
  webhookApiKey: 'your-api-key-here'
});
```

### 3. Done!

A floating bug button will appear in the bottom-right corner of every page.

---

## Configuration Options

```javascript
BugReporter.init({
  // ═══════════════════════════════════════════════════════════
  // REQUIRED
  // ═══════════════════════════════════════════════════════════
  webhookUrl: 'https://your-n8n.com/webhook/bug-report',
  webhookApiKey: 'your-api-key',           // Sent as X-API-Key header

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - Appearance
  // ═══════════════════════════════════════════════════════════
  position: 'bottom-right',                // bottom-right, bottom-left, top-right, top-left
  theme: 'auto',                           // auto, light, dark
  buttonIcon: 'bug',                       // bug, help, support
  buttonText: '',                          // Text shown on hover
  accentColor: '#4f46e5',                  // Primary color
  zIndex: 99999,                           // Z-index for overlay

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
  // OPTIONAL - APEX Integration
  // ═══════════════════════════════════════════════════════════
  apexProcessName: 'AJX_LOG_BUG_REPORT',   // Set to null to disable

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - User Info (auto-detected from APEX)
  // ═══════════════════════════════════════════════════════════
  userName: '',
  userEmail: '',
  userRole: '',

  // ═══════════════════════════════════════════════════════════
  // OPTIONAL - Callbacks
  // ═══════════════════════════════════════════════════════════
  onOpen: () => {},
  onSubmit: (data) => {},
  onSuccess: (response) => {},
  onError: (error) => {}
});

// Below code only applicable if we want Bug Reporter Button colour same as Header colour.

 const btn = document.querySelector('.bug-reporter-btn');

if (btn) {
  const headerBg =
    getComputedStyle(document.documentElement)
      .getPropertyValue('--ut-header-background-color')
      .trim();

  btn.style.setProperty(
    'background-color',
    headerBg,
    'important'
  );
}
```

---

## APEX Integration Setup

Follow these steps to enable database logging in APEX:

### Step 1: Create the Database Table

Run this SQL in SQL Workshop or your database:

```sql
-- ═══════════════════════════════════════════════════════════════════════════
-- BUG_REPORTS - Main table for storing bug reports
-- ═══════════════════════════════════════════════════════════════════════════
CREATE TABLE BUG_REPORTS (
  -- Primary Key
  ID                 RAW(16) DEFAULT SYS_GUID() PRIMARY KEY,

  -- Core Issue Data
  TITLE              VARCHAR2(500) NOT NULL,
  DESCRIPTION        CLOB,
  URGENCY            VARCHAR2(20) CHECK (URGENCY IN ('low', 'medium', 'high', 'critical')),
  IMPACT             VARCHAR2(50) CHECK (IMPACT IN ('single_user', 'team', 'multiple_teams', 'organization')),
  STATUS             VARCHAR2(30) DEFAULT 'NEW' CHECK (STATUS IN ('NEW', 'TRIAGED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED', 'WONT_FIX')),

  -- Reporter
  REPORTER           VARCHAR2(255),

  -- All Diagnostic Data as JSON
  REPORT_DATA        CLOB CONSTRAINT CHK_REPORT_DATA_JSON CHECK (REPORT_DATA IS JSON),

  -- Binary Data
  SCREENSHOT_BLOB    BLOB,
  ATTACHMENTS_BLOB   BLOB,
  ATTACHMENTS_META   CLOB CONSTRAINT CHK_ATTACH_META_JSON CHECK (ATTACHMENTS_META IS JSON OR ATTACHMENTS_META IS NULL),

  -- Webhook Tracking
  WEBHOOK_SENT       VARCHAR2(1) DEFAULT 'N' CHECK (WEBHOOK_SENT IN ('Y', 'N')),
  WEBHOOK_RESPONSE   CLOB,
  WEBHOOK_SENT_AT    TIMESTAMP,

  -- AI Analysis (Future)
  AI_ANALYSIS        CLOB CONSTRAINT CHK_AI_ANALYSIS_JSON CHECK (AI_ANALYSIS IS JSON OR AI_ANALYSIS IS NULL),

  -- Audit Fields
  CREATED_BY         VARCHAR2(255),
  CREATED_ON         TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
  UPDATED_BY         VARCHAR2(255),
  UPDATED_ON         TIMESTAMP,
  RESOLVED_AT        TIMESTAMP
);

-- Indexes
CREATE INDEX IDX_BUG_REPORTS_STATUS ON BUG_REPORTS(STATUS);
CREATE INDEX IDX_BUG_REPORTS_REPORTER ON BUG_REPORTS(REPORTER);
CREATE INDEX IDX_BUG_REPORTS_CREATED ON BUG_REPORTS(CREATED_ON);
CREATE INDEX IDX_BUG_REPORTS_URGENCY ON BUG_REPORTS(URGENCY);
```

### Step 2: Create the Update Trigger

```sql
CREATE OR REPLACE TRIGGER TRG_BUG_REPORTS_UPDATED
BEFORE UPDATE ON BUG_REPORTS
FOR EACH ROW
BEGIN
  :NEW.UPDATED_ON := SYSTIMESTAMP;
  :NEW.UPDATED_BY := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
END;
/
```

### Step 3: Create the View (Optional but Recommended)

```sql
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
```

### Step 4: Create APEX Ajax Callback

1. Go to **Shared Components** > **Application Processes**
2. Click **Create**
3. Configure:
   - **Name:** `AJX_LOG_BUG_REPORT`
   - **Point:** `Ajax Callback`
   - **Condition:** None (always available)

4. Add this PL/SQL Code:

```sql
DECLARE
  l_report_json   CLOB := apex_application.g_x01;
  l_screenshot_b64 VARCHAR2(32767);
  l_id            RAW(16);
  l_json          JSON_OBJECT_T;
  l_title         VARCHAR2(500);
  l_description   CLOB;
  l_urgency       VARCHAR2(20);
  l_impact        VARCHAR2(50);
  l_reporter      VARCHAR2(255);
  l_screenshot    BLOB;
BEGIN
  -- Parse the JSON payload
  l_json := JSON_OBJECT_T.parse(l_report_json);

  -- Extract top-level fields
  l_title       := l_json.get_string('title');
  l_description := l_json.get_clob('description');
  l_urgency     := l_json.get_string('urgency');
  l_impact      := l_json.get_string('impact');

  -- Get reporter name from nested object
  BEGIN
    l_reporter := l_json.get_object('reporter').get_string('userName');
  EXCEPTION
    WHEN OTHERS THEN
      l_reporter := :APP_USER;
  END;

  -- Handle screenshot (sent via f01 array)
  IF apex_application.g_f01.COUNT > 0 AND apex_application.g_f01(1) IS NOT NULL THEN
    l_screenshot_b64 := apex_application.g_f01(1);
    -- Remove data URL prefix if present
    IF INSTR(l_screenshot_b64, 'base64,') > 0 THEN
      l_screenshot_b64 := SUBSTR(l_screenshot_b64, INSTR(l_screenshot_b64, 'base64,') + 7);
    END IF;
    -- Convert base64 to BLOB
    l_screenshot := apex_web_service.clobbase642blob(l_screenshot_b64);
  END IF;

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
    l_screenshot,
    :APP_USER
  )
  RETURNING ID INTO l_id;

  -- Return success response
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

### Step 5: Create Application Substitution Strings (Optional)

If you want to configure webhook settings via APEX:

1. Go to **Shared Components** > **Application Definition Attributes**
2. Scroll to **Substitution Strings**
3. Add:
   - `G_BUG_WEBHOOK_URL` = Your webhook URL
   - `G_BUG_WEBHOOK_KEY` = Your API key

Then initialize like this:

```javascript
BugReporter.init({
  webhookUrl: '&G_BUG_WEBHOOK_URL.',
  webhookApiKey: '&G_BUG_WEBHOOK_KEY.'
});
```

### Step 6: Upload the JavaScript File

1. Go to **Shared Components** > **Static Application Files**
2. Click **Upload File**
3. Upload `bug-reporter.js`
4. Note the reference path (e.g., `#APP_FILES#bug-reporter.js`)

### Step 7: Include in Application

1. Go to **Shared Components** > **User Interface Attributes**
2. Click on your theme
3. In **JavaScript** > **File URLs**, add:
   ```
   #APP_FILES#bug-reporter.js
   ```

4. In **JavaScript** > **Execute when Page Loads**, add:
   ```javascript
   BugReporter.init({
     webhookUrl: '&G_BUG_WEBHOOK_URL.',
     webhookApiKey: '&G_BUG_WEBHOOK_KEY.'
   });
   ```

---

## Webhook Payload Structure

The webhook receives a JSON payload with this structure:

```json
{
  "reportId": "550e8400-e29b-41d4-a716-446655440000",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "title": "Button not responding",
  "description": "When I click the submit button nothing happens",
  "urgency": "high",
  "impact": "team",

  "reporter": {
    "userName": "john.doe",
    "userEmail": "john@example.com",
    "userRole": "Manager",
    "ipAddress": ""
  },

  "apex": {
    "available": true,
    "appId": "103",
    "pageId": "10",
    "sessionId": "123456789012345",
    "appUser": "JOHN.DOE",
    "debugMode": false,
    "pageItems": {
      "P10_CUSTOMER_ID": "42",
      "P10_ORDER_DATE": "2024-01-15"
    },
    "errors": []
  },

  "console": {
    "errors": [
      {
        "message": "Uncaught TypeError: Cannot read property 'submit' of null",
        "stack": "TypeError: Cannot read property...",
        "timestamp": "2024-01-15T10:29:55.000Z"
      }
    ],
    "warnings": []
  },

  "environment": {
    "browser": "Chrome 120",
    "os": "Windows 10/11",
    "screenResolution": "1920x1080",
    "viewportSize": "1200x800",
    "timezone": "America/New_York",
    "language": "en-US",
    "online": true,
    "userAgent": "Mozilla/5.0...",
    "url": "https://example.com/ords/f?p=103:10:123456789",
    "referrer": "https://example.com/ords/f?p=103:1"
  },

  "screenshot": "data:image/png;base64,iVBORw0KGgo...",

  "attachments": [
    {
      "name": "error-log.txt",
      "type": "text/plain",
      "size": 1234,
      "data": "base64-encoded-content"
    }
  ]
}
```

---

## n8n Workflow Example

Create an n8n workflow to process bug reports:

1. **Webhook node** - Receive the payload
2. **IF node** - Route by urgency (critical → immediate alert)
3. **Slack/Email node** - Send notifications
4. **HTTP Request node** - Create ticket in Jira/GitHub/etc.
5. **Respond to Webhook node** - Return success

---

## API Reference

### Global Methods

```javascript
// Initialize (required)
BugReporter.init(options);

// Open the modal programmatically
BugReporter.open();

// Close the modal
BugReporter.close();

// Update user info dynamically
BugReporter.setUserInfo('John Doe', 'john@example.com', 'Admin');

// Destroy and cleanup
BugReporter.destroy();
```

### Callbacks

```javascript
BugReporter.init({
  // Called when modal opens
  onOpen: () => {
    console.log('Bug reporter opened');
  },

  // Called when form is submitted (before API calls)
  onSubmit: (payload) => {
    console.log('Submitting:', payload);
  },

  // Called on successful submission
  onSuccess: (response) => {
    console.log('Report ID:', response.reportId);
  },

  // Called on error
  onError: (error) => {
    console.error('Submission failed:', error);
  }
});
```

---

## Customization

### Custom Accent Color

```javascript
BugReporter.init({
  accentColor: '#10b981',  // Green
  // ... other options
});
```

### Different Button Positions

```javascript
BugReporter.init({
  position: 'bottom-left',  // or 'top-right', 'top-left'
  // ... other options
});
```

### Disable APEX Integration

```javascript
BugReporter.init({
  apexProcessName: null,  // Webhook only, no database logging
  // ... other options
});
```

### Add Custom Sensitive Fields

```javascript
BugReporter.init({
  sensitiveFields: [
    'password', 'credit_card', 'ssn', 'pin', 'cvv',
    'api_key', 'secret', 'token', 'auth'
  ],
  // ... other options
});
```

---

## Browser Support

- Chrome 60+
- Firefox 60+
- Safari 12+
- Edge 79+
- Opera 47+

---

## License

MIT License - Feel free to use in commercial projects.

---

## Troubleshooting

### Screenshot not capturing
- Ensure html2canvas CDN is accessible
- Check for CORS issues with external images/iframes

### APEX process not working
- Verify the process name matches exactly: `AJX_LOG_BUG_REPORT`
- Check that the table `BUG_REPORTS` exists
- Review APEX debug logs for errors

### Webhook not receiving data
- Verify the webhook URL is correct and accessible
- Check the API key if authentication is required
- Look for CORS errors in browser console

### Form items not captured
- Ensure items follow APEX naming convention (P{page}_ITEM_NAME)
- Check that `enableFormCapture` is `true`
- Sensitive fields are automatically redacted
