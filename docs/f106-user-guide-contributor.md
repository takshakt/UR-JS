# Untapped Revenue (UR) - Contributor User Guide

**Application Version:** Oracle APEX 24.2.11
**Application ID:** 106
**Last Updated:** December 2024

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Getting Started](#2-getting-started)
3. [Hotel Management](#3-hotel-management)
4. [Event Management](#4-event-management)
5. [Data Management](#5-data-management)
6. [Pricing Strategies](#6-pricing-strategies)
7. [Price Overrides](#7-price-overrides)
8. [Reservations](#8-reservations)
9. [Reporting](#9-reporting)
10. [Support Features](#10-support-features)
11. [Appendices](#appendices)

---

## 1. Introduction

### 1.1 Welcome to Untapped Revenue

Welcome to **Untapped Revenue (UR)**, a comprehensive hotel revenue management and optimization system. This application helps hotel properties maximize revenue through dynamic pricing strategies, event management, and competitive analysis.

### 1.2 Your Role as a Contributor

As a **Contributor**, you have full read and write access to operational features. This means you can:

**Create, Edit, and Delete:**
- Hotels and hotel clusters
- Room types
- Contacts and addresses
- Events
- Data templates
- Pricing strategies/algorithms
- Price overrides
- Reservations

**View and Export:**
- All reports and analytics
- All hotel and event data
- Interface logs and load history

**You cannot:**
- Access the Administration section
- Manage users or user roles
- Configure application-wide settings
- Enable/disable application features

### 1.3 Differences from Reader Access

| Feature | Reader | Contributor |
|---------|--------|-------------|
| View hotel data | Yes | Yes |
| Create/edit hotels | No | **Yes** |
| View events | Yes | Yes |
| Create/edit events | No | **Yes** |
| Run reports | Yes | Yes |
| Create report templates | No | **Yes** |
| Create pricing strategies | No | **Yes** |
| Manage price overrides | No | **Yes** |
| Access Administration | No | No |

---

## 2. Getting Started

### 2.1 Logging into the Application

1. Navigate to the application URL provided by your administrator
2. Enter your **Username** (typically your email address)
3. Enter your **Password**
4. Click **Sign In**

### 2.2 Navigation Menu Overview

As a Contributor, you have access to all operational menus:

| Menu Item | Icon | Description |
|-----------|------|-------------|
| **Hotel Management** | Building | Manage hotels, clusters, room types, contacts, addresses |
| **Event Management** | Cake/Event | Manage events affecting hotel demand |
| **Hotel Data** | University | Manage templates, load data, price overrides, reservations |
| **Strategies** | Calculator | Create and manage pricing algorithms |
| **Reports** | Files | Run reports, create templates, view analytics |

### 2.3 The Hotel Selector

The **Hotel Selector** dropdown in the header is crucial for your workflow:

- **Show All Data**: View data for all hotels
- **Specific Hotel**: Filter all pages to show only data for the selected hotel
- The selection persists across pages during your session
- Item ID: `P0_HOTEL_ID` (Global Page item)

### 2.4 Installing as PWA

Untapped Revenue can be installed as a Progressive Web App for easier access. Click **Install App** in the navigation bar and follow the prompts.

---

## 3. Hotel Management

### 3.1 Managing Hotel Clusters

Hotel clusters group related properties together for organizational purposes.

#### Viewing Clusters

1. Click **Hotel Management** > **Manage Cluster**
2. View all clusters in the interactive grid

#### Creating a New Cluster

1. Click **Hotel Management** > **Manage Cluster**
2. Click the **Add Cluster** button
3. Fill in the required fields:

| Field | Description | Required |
|-------|-------------|----------|
| **Cluster Name** | Unique identifier for the group | Yes |
| **Description** | Detailed description of the cluster | No |
| **Address** | Select or create a cluster address | No |
| **Contact** | Select or create a cluster contact | No |
| **Association Start Date** | When the cluster became active | No |
| **Association End Date** | When the cluster ends (leave blank if ongoing) | No |

4. Click **Create** to save

#### Editing a Cluster

1. Click on the cluster name in the grid
2. Modify the desired fields
3. Click **Save Changes**

#### Deleting a Cluster

1. Open the cluster by clicking its name
2. Click the **Delete** button
3. Confirm the deletion

> **Warning:** Deleting a cluster may affect hotels associated with it. Ensure hotels are reassigned before deletion.

---

### 3.2 Managing Hotels

#### Viewing Hotels

1. Click **Hotel Management** > **Hotels**
2. View the hotel list in the interactive grid
3. Use the hotel selector to filter by specific properties

#### Creating a New Hotel

1. Click **Hotel Management** > **Hotels**
2. Click the **Add Hotel** button
3. Complete the hotel form:

| Field | Description | Required |
|-------|-------------|----------|
| **Hotel Name** | Property name | Yes |
| **Cluster** | Select the hotel group | Yes |
| **Star Rating** | 1-5 star rating | No |
| **Address** | Select from existing addresses or create new | No |
| **Contact** | Select primary contact | No |
| **Capacity** | Total room count | No |
| **Currency** | Default currency code (e.g., GBP, USD, EUR) | No |
| **Primary Strategy** | Select the pricing algorithm to use | No |
| **Opening Date** | When the hotel opened/joined | No |
| **Association Start Date** | When the hotel joined the system | No |
| **Association End Date** | Leave blank if ongoing | No |

4. Click **Create** to save the hotel

#### Editing a Hotel

1. Click on the hotel name in the grid
2. A modal form opens with current values
3. Modify the desired fields
4. Click **Save Changes**

#### Deleting a Hotel

1. Open the hotel form
2. Click **Delete**
3. Confirm the deletion

> **Warning:** Deleting a hotel removes all associated data including room types, events, and reservations. This action cannot be undone.

---

### 3.3 Managing Room Types

Room types define the different accommodation categories for each hotel.

#### Viewing Room Types

1. Click **Hotel Management** > **Room Types**
2. Select a hotel from the filter dropdown
3. View room types in the grid

#### Adding a Room Type

1. Navigate to **Room Types**
2. Click **Add Room Type**
3. Complete the form:

| Field | Description | Required |
|-------|-------------|----------|
| **Hotel** | Select the hotel | Yes |
| **Room Type Name** | Name (e.g., Standard Double, Deluxe Suite) | Yes |
| **Max Occupancy** | Maximum guests (1-10) | Yes |
| **Bed Type** | Select bed configuration | No |
| **Description** | Additional room details | No |
| **Price** | Base room rate | No |
| **Supplement Type** | Additional pricing rule | No |
| **Supplement Price Min** | Minimum supplement amount | No |
| **Supplement Price Max** | Maximum supplement amount | No |

4. Click **Save**

#### Bed Types

Available bed type options:

| Bed Type | Description |
|----------|-------------|
| Single | One single bed |
| Double | One double/full bed |
| Twin | Two single beds |
| Queen | One queen-size bed |
| King | One king-size bed |
| Suite | Multiple rooms/beds |

#### Supplement Types

| Supplement Type | Description |
|-----------------|-------------|
| Per Person | Additional charge per extra guest |
| Per Night | Additional charge per night |
| Flat Rate | One-time additional charge |
| Percentage | Percentage-based supplement |

---

### 3.4 Managing Contacts

#### Viewing Contacts

1. Click **Hotel Management** > **Contact Directory**
2. Filter by hotel if needed
3. View all contacts in the grid

#### Adding a Contact

1. Navigate to **Contact Directory**
2. Click **Add Contact**
3. Complete the form:

| Field | Description | Required |
|-------|-------------|----------|
| **Hotel** | Associated hotel | Yes |
| **Contact Name** | Full name | Yes |
| **Position/Title** | Job title | No |
| **Email** | Email address | No |
| **Phone Number** | Contact phone | No |
| **Contact Type** | Category of contact | No |
| **Primary** | Is this the primary contact? (Yes/No) | No |

4. Click **Save**

> **Note:** Only one contact per hotel can be marked as Primary. Setting a new primary contact will remove the primary flag from any existing primary contact.

#### Contact Types

| Contact Type | Description |
|--------------|-------------|
| General Manager | Property GM |
| Revenue Manager | Pricing/revenue contact |
| Front Desk | Reception contact |
| Sales | Sales department |
| Reservations | Booking department |
| Operations | Operations contact |

---

### 3.5 Managing Addresses

#### Viewing Addresses

1. Click **Hotel Management** > **Address Book**
2. Filter by hotel if needed

#### Adding an Address

1. Navigate to **Address Book**
2. Click **Add Address**
3. Complete the form:

| Field | Description | Required |
|-------|-------------|----------|
| **Hotel** | Associated hotel | Yes |
| **Street Address** | Street name and number | Yes |
| **Post Code** | Postal/ZIP code | No |
| **City** | City name | No |
| **County** | County/State/Province | No |
| **Country** | Country name | No |
| **Primary** | Is this the primary address? (Yes/No) | No |

4. Click **Save**

#### UK Postcode Lookup

For UK addresses, the application provides automatic postcode lookup:

1. Enter the **Post Code** field
2. Tab out of the field or wait a moment
3. The **City** and **Country** fields auto-populate via the postcodes.io API
4. Verify and adjust if needed

---

## 4. Event Management

### 4.1 Viewing Events

1. Click **Event Management** in the navigation menu
2. The interactive grid displays all events
3. Use the hotel filter to narrow results

### 4.2 Adding Events

#### Single Event Entry

1. Navigate to **Event Management**
2. Click **Add Event**
3. Complete the event form:

| Field | Description | Required |
|-------|-------------|----------|
| **Hotel** | Associated hotel(s) | Yes |
| **Event Name** | Name of the event | Yes |
| **Event Type** | Category of event | Yes |
| **Event Description** | Detailed description | No |
| **Start Date** | When the event begins | Yes |
| **End Date** | When the event ends | Yes |
| **Frequency** | How often it occurs | No |
| **Attendance** | Expected number of attendees | No |
| **Impact Type** | Type of demand impact | No |
| **Impact Level** | Severity (Low/Medium/High/Critical) | No |
| **Post Code** | Event location postal code | No |
| **City** | Event city | No |
| **Country** | Event country | No |

4. Click **Save**

#### Event Types

| Event Type | Description | Typical Impact |
|------------|-------------|----------------|
| Conference | Business conferences/conventions | Medium-High |
| Concert | Music performances | High |
| Sports | Sporting events | Medium-High |
| Festival | Cultural/community festivals | Medium |
| Exhibition | Trade shows | Medium |
| Holiday | Public holidays | Variable |
| Wedding | Large wedding events | Low-Medium |
| Corporate | Corporate gatherings | Medium |

#### Frequency Options

| Frequency | Description |
|-----------|-------------|
| One-time | Single occurrence |
| Annual | Occurs once per year |
| Monthly | Occurs every month |
| Weekly | Occurs every week |
| Bi-annual | Twice per year |

#### Impact Levels Explained

| Level | Score Range | Description |
|-------|-------------|-------------|
| Low | 1-25 | Minor demand increase (~5-15%) |
| Medium | 26-50 | Moderate increase (~15-30%) |
| High | 51-75 | Significant surge (~30-50%) |
| Critical | 76-100 | Major event, peak demand (>50%) |

### 4.3 Editing Events

1. Click on the event row in the grid
2. Modify fields as needed
3. Click **Save Changes**

### 4.4 Deleting Events

1. Open the event form
2. Click **Delete**
3. Confirm deletion

### 4.5 Bulk Event Upload

For loading multiple events at once:

#### Downloading the Template

1. Navigate to **Event Management**
2. Click **Download Template**
3. Save the Excel template file

#### Template Format

The template includes these columns:

| Column | Format | Required |
|--------|--------|----------|
| Hotel Name | Text (must match existing hotel) | Yes |
| Event Name | Text | Yes |
| Event Type | Text (must match valid type) | Yes |
| Start Date | DD-MMM-YYYY or YYYY-MM-DD | Yes |
| End Date | DD-MMM-YYYY or YYYY-MM-DD | Yes |
| Frequency | Text (must match valid option) | No |
| Attendance | Number | No |
| Impact Type | Text | No |
| Impact Level | Text (Low/Medium/High/Critical) | No |
| Description | Text | No |
| Post Code | Text | No |
| City | Text | No |
| Country | Text | No |

#### Uploading Events

1. Fill in the template with your event data
2. Navigate to **Event Management**
3. Click **Upload Events**
4. Select your completed template file
5. Click **Upload**
6. Review the validation results
7. Confirm to process the upload

---

## 5. Data Management

### 5.1 Understanding Templates

Templates define how data files (CSV/Excel) are mapped to database tables. They specify:

- Which columns in the file map to which database fields
- Data type expectations
- Validation rules (qualifiers)
- Transformation rules

### 5.2 Creating Templates

#### Step 1: Start Template Creation

1. Click **Hotel Data** > **Add New Template**
2. Enter basic template information:

| Field | Description |
|-------|-------------|
| Template Name | Unique identifier |
| Template Type | What data this template handles |
| Description | Purpose and usage notes |

#### Step 2: Upload Sample File

1. Upload a sample CSV or Excel file
2. Select the sheet (for Excel files)
3. The system previews the first 20 rows

#### Step 3: Column Mapping

For each database field, select the corresponding file column:

1. Review the list of required database fields
2. For each field, select the matching column from your file
3. Configure any transformations needed

#### Step 4: Set Qualifiers

Qualifiers add validation and transformation rules:

| Qualifier | Description |
|-----------|-------------|
| Required | Column must have a value |
| Unique | Values must not duplicate |
| Date Format | Expected date format |
| Number | Must be numeric |
| Lookup | Must match existing reference data |

#### Step 5: Save Template

1. Review your mappings
2. Click **Save Template**
3. The template is now available for data loading

### 5.3 Managing Templates

#### Viewing Templates

1. Click **Hotel Data** > **Manage Templates**
2. View all templates in the grid

#### Editing Templates

1. Click on a template name
2. Modify mappings or qualifiers
3. Save changes

#### Deleting Templates

1. Select the template
2. Click **Delete**
3. Confirm deletion

> **Warning:** Deleting a template does not delete previously loaded data.

### 5.4 Loading Data

#### Using Load Data Interface

1. Click **Hotel Data** > **Load Data**
2. Select the template to use
3. Select the hotel (if applicable)
4. Upload your data file

#### Preview and Validation

1. Review the 20-row preview
2. Check for validation errors (highlighted in red)
3. Review warnings (highlighted in yellow)
4. If errors exist, correct your file and re-upload

#### Processing the Upload

1. Click **Process Upload**
2. Monitor the progress indicator
3. Wait for completion confirmation

#### Handling Errors

If errors occur during processing:

1. Note the error messages
2. Download the error report if available
3. Correct the source data
4. Re-upload the corrected file

### 5.5 Interface Dashboard

The Interface Dashboard shows data load history and status.

#### Viewing Load History

1. Click **Hotel Data** > **Interface Dashboard** (requires admin navigation)
2. Or access via **Administration** > **Interface Dashboard**
3. View all load operations in the grid

#### Understanding Load Status

| Status | Description |
|--------|-------------|
| **Success** | Load completed without errors |
| **Failed** | Load failed with errors |
| **In Progress** | Load is currently processing |
| **Pending** | Load is queued |

#### Viewing Error Details

1. Click on a failed load row
2. Click **View Errors**
3. Review the error collection:
   - Row number
   - Column name
   - Error message
   - Original value

#### Reprocessing Failed Loads

1. Open the failed load details
2. Click **Reprocess**
3. The system attempts to reprocess the file

#### Downloading Source Files

1. Open the load details
2. Click **Download File**
3. The original uploaded file downloads

---

## 6. Pricing Strategies

### 6.1 Understanding Algorithms

Algorithms (also called Strategies) are pricing rules that automatically adjust hotel rates based on various factors:

- Market demand
- Events
- Occupancy levels
- Competitive positioning
- Day of week
- Lead time (booking window)

### 6.2 Creating Algorithms

#### Step 1: Basic Information

1. Click **Strategies** in the navigation menu
2. Click **Add Algorithm**
3. Enter basic details:

| Field | Description |
|-------|-------------|
| Algorithm Name | Unique identifier |
| Description | Purpose and logic explanation |
| Status | Active/Inactive |

#### Step 2: Expression Builder

The expression builder allows you to create pricing formulas:

**Available Operators:**

| Operator | Description | Example |
|----------|-------------|---------|
| `+` | Addition | `base_rate + 50` |
| `-` | Subtraction | `base_rate - 10` |
| `*` | Multiplication | `base_rate * 1.2` |
| `/` | Division | `total / nights` |
| `%` | Modulo | `value % 10` |

**Available Functions:**

| Function | Description | Example |
|----------|-------------|---------|
| `MIN()` | Minimum value | `MIN(rate, max_rate)` |
| `MAX()` | Maximum value | `MAX(rate, min_rate)` |
| `ROUND()` | Round to nearest | `ROUND(rate, 2)` |
| `IF()` | Conditional | `IF(occupancy > 80, rate * 1.1, rate)` |
| `ABS()` | Absolute value | `ABS(difference)` |

**Available Variables:**

| Variable | Description |
|----------|-------------|
| `base_rate` | Standard room rate |
| `occupancy` | Current occupancy percentage |
| `event_score` | Calculated event impact score |
| `lead_time` | Days until check-in |
| `dow` | Day of week (1-7) |
| `comp_rank` | Competitive set ranking |

#### Step 3: Expression Validation

1. Enter your expression
2. Click **Validate**
3. Review any syntax errors
4. Correct and re-validate until successful

### 6.3 Configuring Constraints

Constraints define when and how the algorithm applies.

#### Stay Window

Defines date ranges for the algorithm:

| Field | Description |
|-------|-------------|
| Start Date | Beginning of valid period |
| End Date | End of valid period |
| Include/Exclude | Whether to apply or skip these dates |

#### Lead Time

Booking window rules:

| Field | Description |
|-------|-------------|
| Lead Time Type | Days, Weeks, or Months |
| Minimum Lead | Minimum booking advance |
| Maximum Lead | Maximum booking advance |

#### Day of Week

Different pricing by day:

| Day | Modifier | Example |
|-----|----------|---------|
| Monday | 0.95 | 5% discount |
| Tuesday | 0.95 | 5% discount |
| Wednesday | 1.00 | No change |
| Thursday | 1.05 | 5% premium |
| Friday | 1.15 | 15% premium |
| Saturday | 1.20 | 20% premium |
| Sunday | 1.10 | 10% premium |

#### Event Score Thresholds

Adjust pricing based on event impact:

| Score Range | Rate Modifier |
|-------------|---------------|
| 0-25 | 1.00 (base rate) |
| 26-50 | 1.10 (+10%) |
| 51-75 | 1.20 (+20%) |
| 76-100 | 1.35 (+35%) |

#### Competitive Ranking

Adjust based on market position:

| Ranking | Strategy |
|---------|----------|
| 1 (Leader) | Can price at premium |
| 2-3 | Match or slight discount |
| 4-5 | Competitive pricing |
| 6+ | Value positioning |

#### Occupancy Thresholds

Dynamic pricing based on fill rate:

| Occupancy | Rate Modifier |
|-----------|---------------|
| 0-50% | 0.90 (-10%) |
| 51-70% | 1.00 (base) |
| 71-85% | 1.10 (+10%) |
| 86-95% | 1.25 (+25%) |
| 96-100% | 1.40 (+40%) |

#### Minimum Rate Protection

Set floor prices:

| Setting | Description |
|---------|-------------|
| Minimum Rate | Never go below this price |
| Per Room Type | Different minimums by room category |

### 6.4 Algorithm Versioning

Algorithms support version control:

#### Creating a New Version

1. Open an existing algorithm
2. Click **Create New Version**
3. Make your modifications
4. Save the new version

#### Version History

1. Open the algorithm
2. Click **Version History**
3. View all versions with dates and changes
4. Activate a previous version if needed

#### Activating Versions

1. Select the version to activate
2. Click **Activate**
3. Confirm the activation

> **Note:** Only one version can be active at a time. Activating a new version deactivates the current one.

### 6.5 Assigning Strategies to Hotels

#### Primary Strategy Assignment

1. Open the hotel form
2. Select **Primary Strategy** from the dropdown
3. Save the hotel

The primary strategy is used for all standard pricing calculations.

---

## 7. Price Overrides

### 7.1 Understanding Price Overrides

Price overrides allow manual price adjustments that bypass the automatic pricing algorithm. Use them for:

- Special promotions
- Error corrections
- VIP pricing
- Emergency rate changes

### 7.2 Viewing Price Overrides

1. Click **Hotel Data** > **Price Override**
2. View all overrides in the grid
3. Filter by hotel or date range

### 7.3 Creating Price Overrides

1. Navigate to the Price Override list
2. Click **Add Override**
3. Complete the form:

| Field | Description | Required |
|-------|-------------|----------|
| Hotel | Select the property | Yes |
| Room Type | Specific room or all rooms | No |
| Start Date | Override begins | Yes |
| End Date | Override ends | Yes |
| Override Type | Type of adjustment | Yes |
| Override Amount | New price or adjustment | Yes |
| Reason | Why the override is needed | Yes |
| Notes | Additional details | No |

4. Click **Submit**

### 7.4 Override Types

| Type | Description | Amount Field |
|------|-------------|--------------|
| Fixed Rate | Set exact price | Enter the price |
| Percentage Increase | Increase by % | Enter percentage |
| Percentage Decrease | Decrease by % | Enter percentage |
| Flat Increase | Add fixed amount | Enter amount |
| Flat Decrease | Subtract fixed amount | Enter amount |

### 7.5 Override Reasons

Common override reasons:

| Reason | Description |
|--------|-------------|
| Promotion | Marketing promotion |
| Corporate | Corporate negotiated rate |
| VIP | Special guest pricing |
| Error Correction | Fix pricing mistake |
| Market Adjustment | Competitive response |
| Group Rate | Group booking rate |
| Last Minute | Fill unsold inventory |

### 7.6 Override Workflow

1. **Create**: Contributor creates override (status: Pending)
2. **Review**: Administrator reviews (if approval required)
3. **Approve/Reject**: Administrator decides
4. **Apply**: Approved overrides take effect

> **Note:** Some organizations may have auto-approval for Contributors. Check with your administrator.

---

## 8. Reservations

### 8.1 Viewing Reservations

1. Click **Hotel Data** > **Reservation Update**
2. View reservations in the interactive grid
3. Filter by hotel, date range, or status

### 8.2 Adding Reservations

1. Navigate to Reservations
2. Click **Add Reservation**
3. Complete the form:

| Field | Description |
|-------|-------------|
| Hotel | Property |
| Guest Name | Reservation name |
| Check-in Date | Arrival date |
| Check-out Date | Departure date |
| Room Type | Room category |
| Rate | Booking rate |
| Source | Booking channel |
| Status | Booking status |

4. Click **Save**

### 8.3 Managing Exceptions

Exceptions flag unusual reservation situations:

#### Exception Types

| Type | Description |
|------|-------------|
| Cancellation | Booking cancelled |
| No-Show | Guest didn't arrive |
| Early Departure | Left before checkout |
| Late Checkout | Extended stay |
| Rate Dispute | Price disagreement |
| Overbooking | Double booking |

#### Handling Cancellations

1. Open the reservation
2. Change status to **Cancelled**
3. Select **Cancellation Reason**
4. Add notes if applicable
5. Save

#### Cancellation Reasons

| Reason | Description |
|--------|-------------|
| Guest Request | Guest cancelled |
| Duplicate | Duplicate booking |
| No Payment | Payment not received |
| Force Majeure | Unforeseeable circumstances |
| Hotel Error | Booking mistake |
| Overbooking | No room available |

---

## 9. Reporting

### 9.1 Running Reports

As a Contributor, you have full access to reporting:

1. Click **Reports** > **Run Reports**
2. Select hotel and report type
3. Set parameters (dates, filters)
4. Click **Run**

### 9.2 Creating Report Templates

#### Designing a Report Template

1. Click **Reports** > **Report Templates** (if available)
2. Click **Create Template**
3. Configure:
   - Template name
   - Data source
   - Columns to include
   - Column order and aliases

#### Adding Conditional Formatting

Apply visual formatting based on values:

1. Open template design
2. Click **Conditional Formatting**
3. Add rules:

| Condition | Format | Example |
|-----------|--------|---------|
| Value > threshold | Background color | Green if > target |
| Value < threshold | Background color | Red if < minimum |
| Value = specific | Text style | Bold if "Critical" |
| Contains text | Highlight | Yellow if "Error" |

4. Save the template

### 9.3 Exporting Reports

#### Excel Export

1. Run your report
2. Click **Export to Excel**
3. File downloads with:
   - All data
   - Formatting preserved
   - Conditional formatting included

#### PDF Export

1. Run your report
2. Click **Export to PDF**
3. File downloads as formatted PDF

---

## 10. Support Features

### 10.1 Submitting Feedback

1. Click **Feedback** in the navigation bar
2. Enter your message
3. Attach files if needed (when enabled)
4. Submit

### 10.2 Using Help

1. Click the **Help** icon
2. Browse or search topics
3. Contact support if needed

---

## Appendices

### A. Data Import Template Formats

#### Date Formats

| Format | Example |
|--------|---------|
| DD-MMM-YYYY | 25-DEC-2024 |
| YYYY-MM-DD | 2024-12-25 |
| DD/MM/YYYY | 25/12/2024 |
| MM/DD/YYYY | 12/25/2024 |

#### Number Formats

| Type | Format | Example |
|------|--------|---------|
| Integer | No decimals | 100 |
| Decimal | 2 decimal places | 99.99 |
| Currency | Symbol + number | £99.99 |
| Percentage | Number + % | 15% |

### B. Algorithm Expression Reference

#### Complete Operator List

```
Arithmetic: + - * / %
Comparison: = != < > <= >=
Logical: AND OR NOT
```

#### Complete Function List

```
MIN(a, b) - Returns minimum of a and b
MAX(a, b) - Returns maximum of a and b
ROUND(value, decimals) - Rounds to specified decimals
FLOOR(value) - Rounds down to integer
CEIL(value) - Rounds up to integer
ABS(value) - Returns absolute value
IF(condition, true_value, false_value) - Conditional
COALESCE(a, b, c) - Returns first non-null value
```

### C. Event Types and Impact Levels

| Event Type | Default Impact | Typical Attendance |
|------------|----------------|-------------------|
| Conference | Medium-High | 500-5000 |
| Concert | High | 5000-50000 |
| Sports | High | 10000-80000 |
| Festival | Medium | 5000-100000 |
| Exhibition | Medium | 1000-10000 |
| Holiday | Variable | N/A |
| Wedding | Low | 50-300 |
| Corporate | Low-Medium | 50-500 |

### D. Troubleshooting Common Issues

#### Data Load Errors

| Error | Cause | Solution |
|-------|-------|----------|
| "Column not found" | Template mismatch | Update template or fix file headers |
| "Invalid date" | Wrong date format | Use correct format per template |
| "Duplicate key" | Record already exists | Update instead of insert |
| "Required field missing" | Blank required column | Populate all required fields |
| "Invalid reference" | Foreign key not found | Ensure reference data exists |

#### Algorithm Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| "Syntax error" | Invalid expression | Check operators and parentheses |
| "Unknown variable" | Typo in variable name | Use valid variable names |
| "Division by zero" | Denominator is zero | Add zero-check in expression |

### E. Glossary

| Term | Definition |
|------|------------|
| **Algorithm** | Automated pricing rule set |
| **Cluster** | Group of related hotel properties |
| **Constraint** | Rule limiting when algorithm applies |
| **Event Score** | Numerical impact rating for events |
| **Lead Time** | Days between booking and arrival |
| **Override** | Manual price adjustment |
| **Qualifier** | Data validation rule in templates |
| **Stay Window** | Date range for pricing rules |
| **Template** | File mapping definition for data loads |

---

**Need More Help?**

- Use the in-app **Feedback** feature
- Contact your system administrator
- Refer to the Reader Guide for viewing-only features
- Request Administrator Guide for admin features

---

*This guide is for Contributor users of the Untapped Revenue application. For administration features, request Administrator access from your system administrator.*
