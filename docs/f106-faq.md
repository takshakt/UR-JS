# Untapped Revenue (UR) - Frequently Asked Questions (FAQ)

**Application Version:** Oracle APEX 24.2.11
**Application ID:** 106
**Last Updated:** December 2024

---

## Table of Contents

1. [General Questions](#1-general-questions)
2. [Login & Access](#2-login--access)
3. [Hotel Management](#3-hotel-management)
4. [Event Management](#4-event-management)
5. [Data Management & Templates](#5-data-management--templates)
6. [Pricing Strategies & Algorithms](#6-pricing-strategies--algorithms)
7. [Price Overrides](#7-price-overrides)
8. [Reservations](#8-reservations)
9. [Reporting & Exports](#9-reporting--exports)
10. [Administration](#10-administration)
11. [Mobile & PWA](#11-mobile--pwa)
12. [Troubleshooting](#12-troubleshooting)

---

## 1. General Questions

### Q: What is Untapped Revenue (UR)?

**A:** Untapped Revenue is a comprehensive hotel revenue management and optimization system built on Oracle APEX. It helps hotel properties maximize revenue through dynamic pricing strategies, event impact analysis, competitive positioning, and data-driven decision making.

---

### Q: What are the main features of the application?

**A:** The main features include:

| Feature | Description |
|---------|-------------|
| **Hotel Management** | Manage hotel properties, clusters, room types, contacts, and addresses |
| **Event Management** | Track local and regional events that impact hotel demand |
| **Data Templates** | Create mappings to import external data files (CSV/Excel) |
| **Pricing Strategies** | Build automated pricing algorithms with multiple conditions |
| **Price Overrides** | Apply manual price adjustments for special situations |
| **Reservations** | Track and manage booking data and exceptions |
| **Reporting** | Generate reports with Excel and PDF export capabilities |
| **Administration** | Manage users, access control, and system configuration |

---

### Q: What browsers are supported?

**A:** The application works best with:

- Google Chrome (recommended)
- Microsoft Edge
- Mozilla Firefox
- Safari (latest versions)

For optimal experience, ensure your browser is up to date.

---

### Q: Can I use the application on mobile devices?

**A:** Yes. The application is responsive and works on tablets and smartphones. You can also install it as a Progressive Web App (PWA) for a native app-like experience.

---

### Q: What is the Hotel Selector and how does it work?

**A:** The Hotel Selector is a dropdown in the application header that filters data across all pages. When you select a specific hotel, all grids, reports, and forms will show only data related to that hotel. Select "All Hotels" to view combined data. Your selection persists during your session.

---

## 2. Login & Access

### Q: How do I log into the application?

**A:**
1. Navigate to the application URL provided by your administrator
2. Enter your username (typically your email address)
3. Enter your password
4. Click **Sign In**

---

### Q: I forgot my password. How do I reset it?

**A:** Contact your APEX workspace administrator to reset your password. The application uses Oracle APEX workspace accounts for authentication, so password resets are handled at the workspace level.

---

### Q: What are the different user roles?

**A:** There are three roles:

| Role | Access Level |
|------|--------------|
| **Reader** | View-only access. Can view all data and run/export reports but cannot create or modify anything. |
| **Contributor** | Full read/write access to operational features. Can create, edit, and delete hotels, events, templates, strategies, and overrides. |
| **Administrator** | All Contributor access plus user management, access control configuration, system settings, and activity monitoring. |

---

### Q: Why can't I see certain menu items or features?

**A:** Menu visibility depends on your assigned role:

- **Administration menu**: Only visible to Administrators
- **Create/Edit buttons**: Only visible to Contributors and Administrators
- **Some features may be disabled**: Check with your administrator if specific build options are turned off

---

### Q: I can log in but get "Not Authorized" errors. What's wrong?

**A:** This typically means:

1. You haven't been assigned a role in the access control list
2. The ACCESS_CONTROL_SCOPE is set to ACL_ONLY and you're not in the ACL
3. The specific page requires a higher role than you have

Contact your administrator to verify your role assignment.

---

### Q: Can I have multiple roles assigned?

**A:** Yes. Users can have multiple roles, and the effective permission is the highest role assigned. For example, if you have both Reader and Contributor roles, you'll have Contributor-level access.

---

## 3. Hotel Management

### Q: How do I add a new hotel?

**A:** (Requires Contributor or Administrator role)

1. Click **Hotel Management** > **Hotels**
2. Click the **Add Hotel** button
3. Fill in the required fields (Hotel Name and Cluster are required)
4. Optionally set capacity, currency, primary strategy, and other details
5. Click **Create**

---

### Q: What is a hotel cluster?

**A:** A cluster is a grouping of related hotel properties. Clusters help organize hotels by brand, region, ownership, or any other logical grouping. Every hotel must belong to a cluster.

---

### Q: How do I assign a pricing strategy to a hotel?

**A:** (Requires Contributor or Administrator role)

1. Click **Hotel Management** > **Hotels**
2. Click on the hotel name to open the edit form
3. Select a strategy from the **Primary Strategy** dropdown
4. Click **Save Changes**

---

### Q: Can a hotel have multiple addresses or contacts?

**A:** Yes. Hotels can have multiple addresses and contacts. One of each can be marked as "Primary" for display purposes. The primary address and contact appear in the main hotel grid.

---

### Q: What happens when I delete a hotel?

**A:** Deleting a hotel removes all associated data including:
- Room types
- Events linked to that hotel
- Reservations
- Price overrides
- Loaded data from templates

**This action cannot be undone.** Consider deactivating rather than deleting if you need to preserve historical data.

---

### Q: How do I set up room types for a hotel?

**A:** (Requires Contributor or Administrator role)

1. Click **Hotel Management** > **Room Types**
2. Click **Add Room Type**
3. Select the hotel
4. Enter the room type name, max occupancy, bed type, and pricing details
5. Click **Save**

---

### Q: What are supplement types for room types?

**A:** Supplements are additional charges applied to room rates:

| Type | Description |
|------|-------------|
| **Per Person** | Extra charge for each additional guest beyond base occupancy |
| **Per Night** | Additional nightly charge |
| **Flat Rate** | One-time additional charge regardless of stay length |
| **Percentage** | Percentage added to the base rate |

---

## 4. Event Management

### Q: What types of events can I track?

**A:** The system supports various event types:

- Conference
- Concert
- Sports
- Festival
- Exhibition
- Holiday
- Wedding
- Corporate

Each event type has typical impact patterns on hotel demand.

---

### Q: How are event impact levels calculated?

**A:** Impact levels indicate how significantly an event affects hotel demand:

| Level | Score Range | Expected Demand Increase |
|-------|-------------|-------------------------|
| Low | 1-25 | ~5-15% |
| Medium | 26-50 | ~15-30% |
| High | 51-75 | ~30-50% |
| Critical | 76-100 | >50% |

These levels can be used in pricing algorithms to automatically adjust rates.

---

### Q: Can I upload multiple events at once?

**A:** Yes. (Requires Contributor or Administrator role)

1. Navigate to **Event Management**
2. Click **Download Template** to get the Excel template
3. Fill in your event data following the template format
4. Click **Upload Events**
5. Select your file and click **Upload**
6. Review validation results and confirm

---

### Q: Can an event be associated with multiple hotels?

**A:** Yes. When creating an event, you can select multiple hotels that will be affected by the event. This is useful for regional events that impact several properties.

---

### Q: What is event frequency and how is it used?

**A:** Frequency indicates how often an event occurs:

| Frequency | Description |
|-----------|-------------|
| One-time | Single occurrence, won't repeat |
| Annual | Happens once per year (same dates next year) |
| Bi-annual | Twice per year |
| Monthly | Occurs every month |
| Weekly | Occurs every week |

This helps with forecasting and automatic event renewal for recurring events.

---

## 5. Data Management & Templates

### Q: What is a data template?

**A:** A data template defines how to import external data files (CSV or Excel) into the system. It maps file columns to database fields and specifies validation rules (qualifiers) for data integrity.

---

### Q: How do I create a new data template?

**A:** (Requires Contributor or Administrator role)

1. Click **Hotel Data** > **Add New Template**
2. Enter template name, type, and description
3. Upload a sample file
4. Map each file column to the corresponding database field
5. Set qualifiers (Required, Unique, Date Format, etc.)
6. Save the template

---

### Q: What are qualifiers in templates?

**A:** Qualifiers are validation rules applied to template columns:

| Qualifier | Description |
|-----------|-------------|
| **Required** | Column must have a value (cannot be empty) |
| **Unique** | Values must not duplicate within the file |
| **Date** | Must be a valid date (format auto-detected) |
| **Number** | Must be numeric |
| **Lookup** | Must match an existing value in reference data |

---

### Q: What date formats are supported for data imports?

**A:** The system supports approximately 80 date formats, including:

- DD-MON-YYYY (25-DEC-2024)
- YYYY-MM-DD (2024-12-25)
- DD/MM/YYYY (25/12/2024)
- MM/DD/YYYY (12/25/2024)
- Various formats with time components
- Different separators (-, /, .)

The system automatically detects the format from sample values.

---

### Q: My data load failed. How do I see what went wrong?

**A:**

1. Click **Hotel Data** > **Interface Dashboard**
2. Find your failed load in the grid (Status = Failed)
3. Click on the row to open details
4. Click **View Errors** to see:
   - Row numbers with errors
   - Column names
   - Error messages
   - Original values that failed validation

---

### Q: Can I reprocess a failed data load?

**A:** Yes. (Requires Contributor or Administrator role)

1. Open the failed load details from the Interface Dashboard
2. Click **Reprocess**
3. The system will attempt to reprocess the file

Note: You may need to fix the source data or template issues first.

---

### Q: What happens to my data when I delete a template?

**A:** Deleting a template does NOT delete the data that was previously loaded using that template. It only removes the template definition. You won't be able to use that template for future loads.

---

## 6. Pricing Strategies & Algorithms

### Q: What is a pricing algorithm/strategy?

**A:** A pricing algorithm (also called a strategy) is a set of rules that automatically calculates hotel room rates based on various factors like:

- Market demand and occupancy
- Event impact scores
- Competitive positioning
- Day of week
- Lead time (booking window)
- Stay window (date ranges)

---

### Q: How do I create a pricing algorithm?

**A:** (Requires Contributor or Administrator role)

1. Click **Strategies** in the navigation menu
2. Click **Add Algorithm**
3. Enter a name and description
4. Use the expression builder to create your pricing formula
5. Configure constraints (stay window, lead time, day of week, etc.)
6. Validate the expression
7. Save the algorithm

---

### Q: What functions can I use in algorithm expressions?

**A:** Supported functions include:

| Function | Description | Example |
|----------|-------------|---------|
| `MIN(a, b)` | Returns the smaller value | `MIN(rate, 200)` |
| `MAX(a, b)` | Returns the larger value | `MAX(rate, 50)` |
| `ROUND(value, decimals)` | Rounds to decimal places | `ROUND(rate, 2)` |
| `IF(condition, true, false)` | Conditional logic | `IF(occupancy > 80, rate * 1.1, rate)` |
| `SUM(values)` | Sum of values | `SUM(attr1, attr2)` |
| `AVERAGE(values)` | Average of values | `AVERAGE(attr1, attr2, attr3)` |
| `ABS(value)` | Absolute value | `ABS(difference)` |

---

### Q: What variables can I use in expressions?

**A:** Common variables include:

| Variable | Description |
|----------|-------------|
| `base_rate` | Standard room rate |
| `occupancy` | Current occupancy percentage |
| `event_score` | Calculated event impact score |
| `lead_time` | Days until check-in |
| `dow` | Day of week (1-7) |
| `comp_rank` | Competitive set ranking |

You can also reference any attributes defined in your templates using `#ATTRIBUTE_ID#` syntax.

---

### Q: What is algorithm versioning?

**A:** Versioning allows you to create multiple versions of an algorithm while preserving history:

- Each modification can be saved as a new version
- Only one version is "active" at a time
- You can view version history to see changes over time
- Previous versions can be reactivated if needed

This provides an audit trail and rollback capability.

---

### Q: How do I test an algorithm before activating it?

**A:**

1. Create a new version of the algorithm
2. Use the **Preview** or **Evaluate** function to see calculated prices
3. Review the results for sample dates
4. If satisfied, activate the new version

---

### Q: What are stay windows and lead times?

**A:**

- **Stay Window**: The date range during which the algorithm rule applies (e.g., Dec 1 - Dec 31)
- **Lead Time**: The booking window, measured as days between booking date and check-in date (e.g., 7-30 days in advance)

These constraints help you apply different pricing strategies for different periods and booking patterns.

---

### Q: What is competitive ranking in algorithms?

**A:** Competitive ranking compares your hotel's price position against competitors:

- **Bottom Rank (R1, R2, R3...)**: Ranked from cheapest to most expensive
- **Top Rank**: Ranked from most expensive to cheapest
- **Own Property Rank**: Your hotel's position in the ranking

This allows dynamic pricing based on market position.

---

### Q: What is rank shifting?

**A:** Rank shifting handles scenarios where competitors are sold out (have $0 or NULL prices). If an algorithm references a rank that doesn't exist (e.g., R8 when only 6 competitors have valid prices), the system automatically shifts to use available ranks while maintaining relative positions.

---

## 7. Price Overrides

### Q: What is a price override?

**A:** A price override is a manual price adjustment that bypasses the automatic pricing algorithm. Use overrides for:

- Special promotions
- Error corrections
- VIP/corporate rates
- Emergency rate changes
- Last-minute deals

---

### Q: What types of overrides are available?

**A:**

| Override Type | Description |
|---------------|-------------|
| **Fixed Rate** | Set an exact price (e.g., $99/night) |
| **Percentage Increase** | Increase by a percentage (e.g., +10%) |
| **Percentage Decrease** | Decrease by a percentage (e.g., -15%) |
| **Flat Increase** | Add a fixed amount (e.g., +$20) |
| **Flat Decrease** | Subtract a fixed amount (e.g., -$25) |

---

### Q: Do price overrides require approval?

**A:** This depends on your organization's configuration. Some setups require administrator approval for overrides, while others allow contributors to apply overrides immediately. Check with your administrator for your organization's workflow.

---

### Q: Can I override prices for a specific room type only?

**A:** Yes. When creating an override, you can select a specific room type or leave it blank to apply to all room types for the hotel.

---

### Q: How long does an override last?

**A:** Each override has a Start Date and End Date. The override is active only during this period. After the end date, normal algorithm pricing resumes.

---

## 8. Reservations

### Q: How do I view reservations?

**A:**

1. Click **Hotel Data** > **Reservation Update**
2. Use the hotel selector to filter by property
3. Use column filters to search by date, guest name, status, etc.

---

### Q: What are reservation exceptions?

**A:** Exceptions flag unusual reservation situations:

| Exception | Description |
|-----------|-------------|
| **Cancellation** | Booking was cancelled |
| **No-Show** | Guest did not arrive |
| **Early Departure** | Guest left before scheduled checkout |
| **Late Checkout** | Extended stay past checkout time |
| **Rate Dispute** | Price disagreement |
| **Overbooking** | Double booking situation |
| **Override** | Manual rate adjustment was applied |

---

### Q: How do I record a cancellation?

**A:** (Requires Contributor or Administrator role)

1. Open the reservation from the grid
2. Change the status to **Cancelled**
3. Select a cancellation reason
4. Add any notes
5. Save

---

### Q: Can I import reservations from another system?

**A:** Yes. Create a data template that maps your reservation export file format to the UR_HOTEL_RESERVATIONS table. Then use the data loading feature to import reservations.

---

## 9. Reporting & Exports

### Q: How do I run a report?

**A:**

1. Click **Reports** > **Run Reports** (or **Report Dashboard**)
2. Select a hotel (or "All Hotels")
3. Choose the report type
4. Set any required parameters (dates, filters)
5. Click **Run Report**

---

### Q: What export formats are available?

**A:** Reports can be exported to:

- **Excel (.xlsx)**: Preserves formatting, conditional formatting, and column widths
- **PDF (.pdf)**: Professional formatted document with table layout

---

### Q: Why is my Excel export missing formatting?

**A:** Excel exports should preserve formatting. If formatting is missing:

1. Make sure you're using the **Export to Excel** button (not the browser print function)
2. Check that your browser isn't blocking file downloads
3. Open the file with Microsoft Excel or a compatible application

---

### Q: Can I save my report filters for later use?

**A:** Yes. Most report grids have an **Actions** menu with a **Save Report** option. This saves your current filter settings, column order, and sort preferences as a named report that you can reload later.

---

### Q: How do I export a very large report?

**A:** For large datasets:

1. Consider filtering to reduce the data volume first
2. Export may take longer - wait for the progress indicator
3. If timeouts occur, export in smaller date ranges or by individual hotels

---

## 10. Administration

### Q: How do I add a new user?

**A:** (Requires Administrator role)

1. Click **Administration** > **User Management**
2. Click **Add User**
3. Enter username, email, and other details
4. Select the user's role (Reader, Contributor, or Administrator)
5. Click **Create User**

---

### Q: How do I add multiple users at once?

**A:** (Requires Administrator role)

1. Click **Administration** > **Add Multiple Users**
2. Enter email addresses, one per line (or use CSV format)
3. Click **Next**
4. Select the default role for all users
5. Click **Create Users**
6. Review results for any errors

---

### Q: How do I change a user's role?

**A:** (Requires Administrator role)

1. Click **Administration** > **Manage User Access**
2. Find the user in the list
3. Click to open their access record
4. Check/uncheck the desired roles
5. Save changes

---

### Q: What is the difference between ACL_ONLY and ALL_USERS access control scope?

**A:**

| Setting | Behavior |
|---------|----------|
| **ACL_ONLY** | Only users explicitly added to the access control list can access the application. Most secure; recommended for production. |
| **ALL_USERS** | Any authenticated APEX user can access as a Reader by default. Use only for development/testing environments. |

---

### Q: How do I deactivate a user who has left the organization?

**A:** (Requires Administrator role)

1. Click **Administration** > **User Management**
2. Find the user and click to open their record
3. Change **Status** to **Inactive**
4. Save changes

Deactivating (rather than deleting) preserves audit history.

---

### Q: How do I view application usage and activity?

**A:** (Requires Administrator role)

1. Click **Administration** > **Activity Dashboard**
2. View metrics like active users, page views, and recent activity
3. Click into specific reports:
   - **Page Performance**: Load times and optimization opportunities
   - **Page Views**: Popular pages and usage patterns
   - **Automations Log**: Scheduled process history
   - **Log Messages**: Application errors and warnings

---

### Q: How do I enable or disable application features?

**A:** (Requires Administrator role)

1. Click **Administration** > **Configuration Options**
2. Find the feature in the Build Options section
3. Toggle the feature on or off
4. Confirm the change

Available toggles include Feedback, Activity Reporting, Push Notifications, Theme Selection, and more.

---

### Q: How do I change the application theme/appearance?

**A:** (Requires Administrator role)

1. Click **Administration** > **Application Appearance**
2. Select a Theme Style (Vita, Redwood, etc.)
3. Choose Icon Style if applicable
4. Set Default Mode (Light or Dark)
5. Click **Apply Changes**

---

## 11. Mobile & PWA

### Q: How do I install the app on my phone or tablet?

**A:**

**On iOS (Safari):**
1. Open the application in Safari
2. Tap the Share button
3. Select **Add to Home Screen**
4. Tap **Add**

**On Android (Chrome):**
1. Open the application in Chrome
2. Tap the menu (three dots)
3. Select **Install App** or **Add to Home Screen**
4. Follow the prompts

---

### Q: What's the difference between using the browser and the PWA?

**A:** The PWA (Progressive Web App) provides:

- Home screen icon for quick access
- Fullscreen experience without browser UI
- Faster loading with cached resources
- Works offline for viewing cached data

Functionality is identical to the browser version.

---

### Q: Do I need an internet connection to use the app?

**A:** Yes, an active internet connection is required for most operations since data is stored on the server. Some recently viewed data may be available offline in the PWA, but you cannot make changes without connectivity.

---

### Q: Why do some features look different on mobile?

**A:** The application uses responsive design to adapt to smaller screens:

- Navigation collapses into a hamburger menu
- Grids may show fewer columns (swipe or scroll horizontally)
- Forms stack vertically for easier input
- Some complex features may be simplified

All core functionality remains available.

---

## 12. Troubleshooting

### Q: The page is loading slowly. What can I do?

**A:**

1. Check your internet connection
2. Clear your browser cache
3. Try a different browser
4. Reduce the data range (use filters)
5. Report persistent issues to your administrator

---

### Q: I'm getting validation errors when loading data. How do I fix them?

**A:** Common validation errors and solutions:

| Error | Cause | Solution |
|-------|-------|----------|
| "Column not found" | File headers don't match template | Update template or fix file headers |
| "Invalid date" | Date format doesn't match | Check expected format in template |
| "Duplicate key" | Record already exists | Remove duplicates or use update mode |
| "Required field missing" | Empty value in required column | Fill in all required fields |
| "Invalid reference" | Lookup value doesn't exist | Ensure reference data exists first |

---

### Q: My algorithm expression shows "Syntax error". What's wrong?

**A:** Common expression issues:

| Issue | Example | Fix |
|-------|---------|-----|
| Missing operator | `rate 1.1` | Add operator: `rate * 1.1` |
| Unbalanced parentheses | `MAX(rate, 100` | Close parenthesis: `MAX(rate, 100)` |
| Invalid function | `AVG(a,b)` | Use correct name: `AVERAGE(a,b)` |
| Typo in variable | `baes_rate` | Fix spelling: `base_rate` |

---

### Q: I can't see hotels that I know exist. Why?

**A:** Possible reasons:

1. **Hotel Selector**: Check if a specific hotel is selected in the header dropdown
2. **Filters**: Clear any active column filters in the grid
3. **Access**: You may only have access to specific hotels (contact administrator)
4. **Status**: The hotel may be inactive or deleted

---

### Q: How do I report a bug or request a feature?

**A:**

1. Click **Feedback** in the navigation bar (top right)
2. Describe the issue or feature request
3. Attach a screenshot if helpful (if attachments are enabled)
4. Submit the feedback

Your feedback goes to the application administrators.

---

### Q: The application shows "Session Expired". What happened?

**A:** Sessions expire after a period of inactivity (typically 30 minutes). When this happens:

1. Click **Sign In** to start a new session
2. Any unsaved work may be lost
3. Save your work frequently, especially in long forms

---

### Q: I accidentally deleted something. Can it be recovered?

**A:** It depends on what was deleted:

- **Hotels, Events, Reservations**: Deletions are permanent. Contact your DBA if recent backups exist.
- **Templates**: Deleted templates don't affect previously loaded data.
- **Users**: Consider deactivating rather than deleting to preserve history.
- **Algorithms**: If versioned, previous versions may still exist.

Prevention tip: Always confirm deletion prompts carefully.

---

### Q: Excel/PDF export isn't working. What should I check?

**A:**

1. **Pop-up blocker**: Allow pop-ups for the application URL
2. **Downloads folder**: Check if file was downloaded to a different location
3. **File size**: Very large exports may timeout - try filtering data first
4. **Browser**: Try a different browser (Chrome recommended)

---

### Q: I'm seeing different data than my colleague. Why?

**A:** Possible reasons:

1. **Hotel Selector**: Different hotels selected in the header
2. **Filters**: Different column filters applied
3. **Saved Reports**: Using different saved report configurations
4. **Cache**: Clear browser cache and refresh
5. **Timing**: Data may have changed between views

---

### Q: How do I contact support?

**A:**

1. Use the in-app **Feedback** feature (preferred method)
2. Contact your system administrator
3. Check the **Help** section for documentation
4. View the **About** page for version and contact information

---

## Quick Tips

| Tip | Description |
|-----|-------------|
| **Use keyboard shortcuts** | `Ctrl+F` for search, `Esc` to close dialogs, `Tab` between fields |
| **Save frequently** | Don't leave forms open too long without saving |
| **Use filters** | Narrow down large datasets for faster performance |
| **Check the Hotel Selector** | Most common cause of "missing" data |
| **Export before changes** | Download data before making bulk modifications |
| **Use version control** | Create new algorithm versions before making changes |

---

*For additional help, use the Feedback feature or contact your system administrator.*
