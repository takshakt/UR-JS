# Bug Reporter - APEX Plugin

A drop-in bug reporting solution for Oracle APEX applications. Install once, use everywhere.

## Quick Install (5 Minutes)

### Step 1: Run Database Script

1. Open **SQL Workshop** > **SQL Scripts**
2. Upload and run: `install_bug_reporter.sql`

This creates:
- `BUG_REPORTS` table
- Performance indexes
- Audit trigger
- Helper view

### Step 2: Create Ajax Callback

1. Go to **Shared Components** > **Application Processes**
2. Click **Create**
3. Configure:
   | Setting | Value |
   |---------|-------|
   | Name | `AJX_BUG_REPORTER_LOG` |
   | Sequence | `10` |
   | Point | `Ajax Callback` |
   | Condition | No Condition |

4. Copy the PL/SQL code from `apex_ajax_callback.sql`
5. Click **Create Process**

### Step 3: Upload JavaScript

1. Go to **Shared Components** > **Static Application Files**
2. Click **Upload File**
3. Upload: `bug-reporter.js` (from parent directory)
4. Note the file reference: `#APP_FILES#bug-reporter.js`

### Step 4: Add to Global Page

1. Open **Page 0** (Global Page)
2. Add JavaScript File URL:
   - Go to **Page Properties** > **JavaScript** > **File URLs**
   - Add: `#APP_FILES#bug-reporter.js`

3. Create Dynamic Action:
   - **When**: Page Load
   - **Action**: Execute JavaScript Code
   - **Code**:
   ```javascript
   BugReporter.init({
     webhookUrl: 'https://your-n8n-webhook.com/bug-report',
     webhookApiKey: 'your-api-key',
     apexProcessName: 'AJX_BUG_REPORTER_LOG'
   });
   ```

### Step 5: Done!

A floating bug button now appears on every page.

---

## Configuration Options

```javascript
BugReporter.init({
  // Webhook Settings
  webhookUrl: 'https://your-webhook.com',    // n8n or any webhook
  webhookApiKey: 'your-api-key',             // Sent as X-API-Key header

  // Appearance
  position: 'bottom-right',    // bottom-right, bottom-left, top-right, top-left
  theme: 'auto',               // auto, light, dark
  buttonIcon: 'bug',           // bug, help, support
  accentColor: '#4f46e5',      // Any hex color

  // APEX Integration
  apexProcessName: 'AJX_BUG_REPORTER_LOG',  // null to disable DB logging

  // Attachments
  maxFiles: 3,                 // Max number of attachments
  maxFileSize: 5 * 1024 * 1024 // 5MB per file
});
```

---

## Using APEX Substitution Strings

Store webhook settings in Application Items:

1. Create Application Items:
   - `G_BUG_WEBHOOK_URL`
   - `G_BUG_WEBHOOK_KEY`

2. Set values in **Application Computation** or **Security** settings

3. Reference in JavaScript:
```javascript
BugReporter.init({
  webhookUrl: '&G_BUG_WEBHOOK_URL.',
  webhookApiKey: '&G_BUG_WEBHOOK_KEY.',
  apexProcessName: 'AJX_BUG_REPORTER_LOG'
});
```

---

## Files Included

| File | Purpose |
|------|---------|
| `install_bug_reporter.sql` | Creates all database objects |
| `apex_ajax_callback.sql` | PL/SQL code for APEX process |
| `uninstall_bug_reporter.sql` | Removes all database objects |
| `../bug-reporter.js` | Main JavaScript widget |

---

## Viewing Bug Reports

Query the `V_BUG_REPORTS` view:

```sql
SELECT
  ID_HEX,
  TITLE,
  URGENCY,
  IMPACT,
  STATUS,
  REPORTER,
  BROWSER,
  OS,
  CREATED_ON,
  AGE_HOURS
FROM V_BUG_REPORTS
ORDER BY CREATED_ON DESC;
```

### Create a Simple Report Page

1. Create a new page with **Interactive Report**
2. Source: `V_BUG_REPORTS`
3. Add columns as needed

---

## Webhook Payload

The webhook receives:

```json
{
  "reportId": "uuid",
  "timestamp": "2024-01-15T10:30:00Z",
  "title": "Issue title",
  "description": "Issue description",
  "urgency": "high",
  "impact": "team",
  "reporter": {
    "userName": "JOHN.DOE",
    "userEmail": "john@example.com"
  },
  "apex": {
    "appId": "103",
    "pageId": "10",
    "sessionId": "123456789",
    "pageItems": { ... }
  },
  "console": {
    "errors": [...],
    "warnings": [...]
  },
  "environment": {
    "browser": "Chrome 120",
    "os": "Windows 11",
    "url": "..."
  },
  "screenshot": "data:image/png;base64,..."
}
```

---

## Uninstall

1. Run `uninstall_bug_reporter.sql` in SQL Workshop
2. Delete the Application Process `AJX_BUG_REPORTER_LOG`
3. Remove `bug-reporter.js` from Static Files
4. Remove the Dynamic Action from Page 0

---

## Troubleshooting

### Button doesn't appear
- Check browser console for JavaScript errors
- Verify `bug-reporter.js` is loaded (Network tab)
- Ensure Dynamic Action fires on Page Load

### Reports not saving to database
- Verify `AJX_BUG_REPORTER_LOG` process exists
- Check process name matches exactly (case-sensitive)
- Enable APEX Debug to see errors

### Webhook not receiving data
- Test webhook URL with curl/Postman first
- Check for CORS issues in browser console
- Verify API key is correct

### Screenshot not capturing
- html2canvas loads from CDN - check network access
- Some elements (iframes, cross-origin images) may not capture

---

## Support

For issues and feature requests, create an issue in the repository.
