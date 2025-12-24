# Untapped Revenue (UR) - Functional User Guide

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
10. [Administration](#10-administration)
11. [Support Features](#11-support-features)
12. [Appendices](#appendices)

---

## Role Reference

Throughout this guide, role requirements are indicated using badges:

| Badge | Meaning |
|-------|---------|
| 🔓 **All Users** | Available to all authenticated users |
| 📖 **Reader+** | Requires Reader role or higher |
| ✏️ **Contributor+** | Requires Contributor role or higher |
| 🔧 **Admin Only** | Requires Administrator role |

**Role Hierarchy:**
```
Administrator (full access)
    └── Contributor (read + write)
            └── Reader (read-only)
```

---

## 1. Introduction

### 1.1 Welcome to Untapped Revenue

**Untapped Revenue (UR)** is a comprehensive hotel revenue management and optimization system. The application helps hotel properties maximize revenue through:

- **Dynamic Pricing Strategies**: Automated rate adjustments based on market conditions
- **Event Management**: Track events that impact hotel demand
- **Competitive Analysis**: Monitor market positioning
- **Data Integration**: Import and manage hotel operational data
- **Reporting**: Comprehensive analytics and exports

### 1.2 Application Roles

The application supports three user roles with different access levels:

| Role | Description |
|------|-------------|
| **Reader** | View-only access to all data and reports. Can export reports but cannot create or modify data. |
| **Contributor** | Full read/write access to operational features. Can create, edit, and delete hotels, events, templates, strategies, and overrides. |
| **Administrator** | All Contributor capabilities plus user management, access control, system configuration, and activity monitoring. |

### 1.3 Key Features by Role

| Feature | Reader | Contributor | Administrator |
|---------|:------:|:-----------:|:-------------:|
| View hotels, events, data | ✓ | ✓ | ✓ |
| Run and export reports | ✓ | ✓ | ✓ |
| Create/edit hotels | | ✓ | ✓ |
| Create/edit events | | ✓ | ✓ |
| Manage data templates | | ✓ | ✓ |
| Create pricing strategies | | ✓ | ✓ |
| Manage price overrides | | ✓ | ✓ |
| User management | | | ✓ |
| Access control | | | ✓ |
| System configuration | | | ✓ |
| Activity monitoring | | | ✓ |

---

## 2. Getting Started

### 2.1 Logging into the Application

🔓 **All Users**

1. Navigate to the application URL provided by your administrator
2. Enter your **Username** (typically your email address)
3. Enter your **Password**
4. Click **Sign In**

> **Note:** Your account is managed through Oracle APEX workspace accounts. Contact your administrator if you need to reset your password.

### 2.2 Understanding the Home Page

🔓 **All Users**

After logging in, you will see the **Home** page with:

- **Navigation Menu**: Located on the left side (or accessible via the hamburger menu on mobile)
- **Header Bar**: Contains your user menu, feedback, and help options
- **Hotel Selector**: A dropdown in the header to filter data by specific hotel or view all hotels

### 2.3 Navigation Menu Overview

🔓 **All Users**

The navigation menu provides access to available features based on your role:

| Menu Item | Icon | Description | Minimum Role |
|-----------|------|-------------|--------------|
| **Hotel Management** | Building | Hotels, clusters, room types, contacts, addresses | Reader |
| **Event Management** | Cake/Event | Events affecting hotel demand | Reader |
| **Hotel Data** | University | Templates, data loading, reservations | Reader |
| **Strategies** | Calculator | Pricing algorithms | Reader |
| **Reports** | Files | Reports and analytics | Reader |
| **Administration** | Wrench | User management, configuration | Administrator |

### 2.4 The Hotel Selector

🔓 **All Users**

The **Hotel Selector** dropdown in the header filters data across all pages:

- **Show All Data**: View data for all hotels
- **Specific Hotel**: Filter all pages to show only data for the selected hotel
- The selection persists across pages during your session

### 2.5 Installing as a Progressive Web App (PWA)

🔓 **All Users**

Untapped Revenue can be installed as an app on your device for easier access:

**On Desktop (Chrome/Edge):**
1. Click the **Install App** icon in the navigation bar
2. Follow the browser prompts to install
3. The app will appear in your Start menu or Applications folder

**On Mobile:**
1. Tap the browser menu (three dots)
2. Select **Add to Home Screen** or **Install App**
3. The app icon will appear on your home screen

### 2.6 User Settings and Preferences

🔓 **All Users**

Access your personal settings by clicking your username in the top-right corner:

1. Click your **username** in the header
2. Select **Settings** from the dropdown
3. Available settings include:
   - **Theme Preference**: Choose between light and dark mode
   - **Push Notifications**: Enable or disable browser notifications

---

## 3. Hotel Management

### 3.1 Viewing Hotels

📖 **Reader+**

1. Click **Hotel Management** > **Hotels**
2. The Hotels page displays an interactive grid with all hotel properties

**Grid Columns:**

| Column | Description |
|--------|-------------|
| **Hotel Name** | The name of the hotel property |
| **Cluster** | The hotel group/cluster the property belongs to |
| **Star Rating** | Hotel star rating (1-5) |
| **Address** | Physical location of the hotel |
| **Contact** | Primary contact person |
| **Opening Date** | When the hotel opened or joined the system |
| **Currency** | Default currency for the hotel |
| **Capacity** | Total room capacity |
| **Primary Strategy** | Assigned pricing strategy/algorithm |

**Grid Features:**
- **Sort**: Click any column header to sort ascending/descending
- **Filter**: Use the search box above the grid to filter results
- **Column Visibility**: Right-click the header row to show/hide columns
- **Export**: Use the Actions menu to download data

### 3.2 Viewing Hotel Details

📖 **Reader+**

1. Click on the **Hotel Name** link in the grid
2. A modal dialog opens showing:
   - Basic hotel information
   - Associated cluster
   - Address and contact details
   - Assigned pricing strategy
   - Association dates

### 3.3 Managing Hotel Clusters

#### Viewing Clusters

📖 **Reader+**

1. Click **Hotel Management** > **Manage Cluster**
2. View all clusters in the interactive grid
3. Click a cluster name to see details

#### Creating a New Cluster

✏️ **Contributor+**

1. Click **Hotel Management** > **Manage Cluster**
2. Click the **Add Cluster** button
3. Fill in the fields:

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

✏️ **Contributor+**

1. Click on the cluster name in the grid
2. Modify the desired fields
3. Click **Save Changes**

#### Deleting a Cluster

✏️ **Contributor+**

1. Open the cluster by clicking its name
2. Click the **Delete** button
3. Confirm the deletion

> **Warning:** Deleting a cluster may affect hotels associated with it. Ensure hotels are reassigned before deletion.

### 3.4 Managing Hotels

#### Creating a New Hotel

✏️ **Contributor+**

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

✏️ **Contributor+**

1. Click on the hotel name in the grid
2. A modal form opens with current values
3. Modify the desired fields
4. Click **Save Changes**

#### Deleting a Hotel

✏️ **Contributor+**

1. Open the hotel form
2. Click **Delete**
3. Confirm the deletion

> **Warning:** Deleting a hotel removes all associated data including room types, events, and reservations. This action cannot be undone.

### 3.5 Managing Room Types

Room types define the different accommodation categories for each hotel.

#### Viewing Room Types

📖 **Reader+**

1. Click **Hotel Management** > **Room Types**
2. Select a hotel from the filter dropdown
3. View room types in the grid

| Column | Description |
|--------|-------------|
| **Room Type Name** | Name of the room category |
| **Max Occupancy** | Maximum number of guests (1-10) |
| **Bed Type** | Type of bed(s) in the room |
| **Description** | Additional room details |
| **Price** | Base room rate |
| **Supplement Type** | Additional pricing rules |
| **Supplement Price Range** | Min/max supplement amounts |

#### Adding a Room Type

✏️ **Contributor+**

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

**Bed Types:**

| Bed Type | Description |
|----------|-------------|
| Single | One single bed |
| Double | One double/full bed |
| Twin | Two single beds |
| Queen | One queen-size bed |
| King | One king-size bed |
| Suite | Multiple rooms/beds |

**Supplement Types:**

| Supplement Type | Description |
|-----------------|-------------|
| Per Person | Additional charge per extra guest |
| Per Night | Additional charge per night |
| Flat Rate | One-time additional charge |
| Percentage | Percentage-based supplement |

### 3.6 Managing Contacts

#### Viewing Contacts

📖 **Reader+**

1. Click **Hotel Management** > **Contact Directory**
2. Filter by hotel if needed
3. View all contacts in the grid

| Column | Description |
|--------|-------------|
| Contact Name | Full name |
| Position | Job title |
| Email | Email address |
| Phone | Contact phone |
| Contact Type | Category |
| Primary | Primary contact indicator |

#### Adding a Contact

✏️ **Contributor+**

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

> **Note:** Only one contact per hotel can be marked as Primary.

**Contact Types:**

| Contact Type | Description |
|--------------|-------------|
| General Manager | Property GM |
| Revenue Manager | Pricing/revenue contact |
| Front Desk | Reception contact |
| Sales | Sales department |
| Reservations | Booking department |
| Operations | Operations contact |

### 3.7 Managing Addresses

#### Viewing Addresses

📖 **Reader+**

1. Click **Hotel Management** > **Address Book**
2. Filter by hotel if needed
3. View address details

#### Adding an Address

✏️ **Contributor+**

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

**UK Postcode Lookup:**

For UK addresses, the application provides automatic postcode lookup:

1. Enter the **Post Code** field
2. Tab out of the field or wait a moment
3. The **City** and **Country** fields auto-populate via the postcodes.io API
4. Verify and adjust if needed

---

## 4. Event Management

Events are external factors (conferences, concerts, sports events, etc.) that impact hotel demand.

### 4.1 Viewing Events

📖 **Reader+**

1. Click **Event Management** in the navigation menu
2. The interactive grid displays all events
3. Use the hotel filter to narrow results

**Grid Columns:**

| Column | Description |
|--------|-------------|
| **Hotel Name** | Associated hotel(s) |
| **Event Name** | Name of the event |
| **Event Type** | Category (Conference, Concert, Sports, etc.) |
| **Start Date** | When the event begins |
| **End Date** | When the event ends |
| **Frequency** | How often it occurs (Annual, One-time, etc.) |
| **Attendance** | Expected number of attendees |
| **Impact Type** | Type of demand impact |
| **Impact Level** | Severity of impact (Low, Medium, High) |
| **Description** | Event details |
| **Location** | Postcode, city, and country |

### 4.2 Event Types

| Event Type | Description | Typical Impact |
|------------|-------------|----------------|
| **Conference** | Business conferences/conventions | Medium-High |
| **Concert** | Music performances | High |
| **Sports** | Sporting events | Medium-High |
| **Festival** | Cultural/community festivals | Medium |
| **Exhibition** | Trade shows | Medium |
| **Holiday** | Public holidays | Variable |
| **Wedding** | Large wedding events | Low-Medium |
| **Corporate** | Corporate gatherings | Medium |

### 4.3 Understanding Impact Levels

| Impact Level | Score Range | Description |
|--------------|-------------|-------------|
| **Low** | 1-25 | Minor increase in demand (~5-15%) |
| **Medium** | 26-50 | Moderate demand increase (~15-30%) |
| **High** | 51-75 | Significant demand surge (~30-50%) |
| **Critical** | 76-100 | Major event, peak demand (>50%) |

### 4.4 Adding Events

✏️ **Contributor+**

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

**Frequency Options:**

| Frequency | Description |
|-----------|-------------|
| One-time | Single occurrence |
| Annual | Occurs once per year |
| Monthly | Occurs every month |
| Weekly | Occurs every week |
| Bi-annual | Twice per year |

### 4.5 Editing Events

✏️ **Contributor+**

1. Click on the event row in the grid
2. Modify fields as needed
3. Click **Save Changes**

### 4.6 Deleting Events

✏️ **Contributor+**

1. Open the event form
2. Click **Delete**
3. Confirm deletion

### 4.7 Bulk Event Upload

✏️ **Contributor+**

For loading multiple events at once:

#### Downloading the Template

1. Navigate to **Event Management**
2. Click **Download Template**
3. Save the Excel template file

#### Template Format

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

📖 **Reader+**

Templates define how data files (CSV/Excel) are mapped to database tables. They specify:

- Which columns in the file map to which database fields
- Data type expectations
- Validation rules (qualifiers)
- Transformation rules

### 5.2 Creating Templates

✏️ **Contributor+**

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

✏️ **Contributor+**

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

✏️ **Contributor+**

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

📖 **Reader+** (View) | ✏️ **Contributor+** (Manage)

The Interface Dashboard shows data load history and status.

#### Viewing Load History

1. Click **Hotel Data** > **Interface Dashboard**
2. View all load operations in the grid

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

✏️ **Contributor+**

1. Open the failed load details
2. Click **Reprocess**
3. The system attempts to reprocess the file

#### Downloading Source Files

📖 **Reader+**

1. Open the load details
2. Click **Download File**
3. The original uploaded file downloads

---

## 6. Pricing Strategies

### 6.1 Understanding Algorithms

📖 **Reader+**

Algorithms (also called Strategies) are pricing rules that automatically adjust hotel rates based on various factors:

- Market demand
- Events
- Occupancy levels
- Competitive positioning
- Day of week
- Lead time (booking window)

### 6.2 Creating Algorithms

✏️ **Contributor+**

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

The expression builder allows you to create pricing formulas.

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
| `SUM()` | Sum of values | `SUM(attr1, attr2, attr3)` |
| `AVERAGE()` | Average of values | `AVERAGE(attr1, attr2)` |
| `COUNT()` | Count of values | `COUNT(attr1, attr2)` |

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

✏️ **Contributor+**

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

| Day | Typical Modifier | Example |
|-----|------------------|---------|
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

✏️ **Contributor+**

Algorithms support version control.

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

> **Note:** Only one version can be active at a time.

### 6.5 Assigning Strategies to Hotels

✏️ **Contributor+**

#### Primary Strategy Assignment

1. Open the hotel form
2. Select **Primary Strategy** from the dropdown
3. Save the hotel

The primary strategy is used for all standard pricing calculations.

---

## 7. Price Overrides

### 7.1 Understanding Price Overrides

📖 **Reader+**

Price overrides allow manual price adjustments that bypass the automatic pricing algorithm. Use them for:

- Special promotions
- Error corrections
- VIP pricing
- Emergency rate changes

### 7.2 Viewing Price Overrides

📖 **Reader+**

1. Click **Hotel Data** > **Price Override**
2. View all overrides in the grid
3. Filter by hotel or date range

### 7.3 Creating Price Overrides

✏️ **Contributor+**

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

📖 **Reader+**

1. Click **Hotel Data** > **Reservation Update**
2. View reservations in the interactive grid
3. Filter by hotel, date range, or status

**Grid Columns:**

| Column | Description |
|--------|-------------|
| **Hotel** | Property name |
| **Reservation ID** | Booking reference |
| **Guest Name** | Name on the reservation |
| **Check-in Date** | Arrival date |
| **Check-out Date** | Departure date |
| **Room Type** | Booked room category |
| **Status** | Current booking status |
| **Exception Type** | Any exceptions or flags |

### 8.2 Adding Reservations

✏️ **Contributor+**

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

### 8.3 Understanding Reservation Exceptions

📖 **Reader+**

Exceptions flag unusual reservation situations:

| Exception Type | Description |
|----------------|-------------|
| **Cancellation** | Booking was cancelled |
| **No-Show** | Guest did not arrive |
| **Early Departure** | Guest left before scheduled checkout |
| **Late Checkout** | Extended stay past checkout time |
| **Override** | Manual price or rate adjustment applied |
| **Rate Dispute** | Price disagreement |
| **Overbooking** | Double booking |

### 8.4 Handling Cancellations

✏️ **Contributor+**

1. Open the reservation
2. Change status to **Cancelled**
3. Select **Cancellation Reason**
4. Add notes if applicable
5. Save

**Cancellation Reasons:**

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

### 9.1 Accessing the Report Dashboard

📖 **Reader+**

1. Click **Reports** in the navigation menu
2. Select **Run Reports** or access the **Report Dashboard** directly

### 9.2 Selecting a Report

📖 **Reader+**

On the Report Dashboard:

1. **Select Hotel**: Choose a specific hotel or "All Hotels" from the dropdown
2. **Select Report**: Choose the report type you want to run
3. **Set Parameters**: Enter any required date ranges or filters
4. Click **Run Report** to generate results

### 9.3 Understanding Report Data

📖 **Reader+**

Reports display in an interactive grid format with:

- **Sortable columns**: Click headers to sort
- **Filterable data**: Use column filters for refined views
- **Conditional formatting**: Color-coded cells based on values
- **Aggregations**: Totals and summaries where applicable

### 9.4 Exporting to Excel

📖 **Reader+**

To export report data to Excel with formatting preserved:

1. Generate your report as described above
2. Click the **Export to Excel** button
3. The file downloads as an `.xlsx` file with:
   - All data from the report
   - Column formatting preserved
   - Conditional formatting applied
   - Proper column widths

> **Technical Note:** Excel exports use the ExcelJS library to maintain formatting and styling.

### 9.5 Exporting to PDF

📖 **Reader+**

To export report data to PDF:

1. Generate your report
2. Click the **Export to PDF** button
3. The file downloads as a `.pdf` file with:
   - Formatted table layout
   - All visible data
   - Professional styling

> **Technical Note:** PDF exports use the jsPDF library with autotable plugin.

### 9.6 Report Summary View

📖 **Reader+**

For aggregated views of report data:

1. Click **Reports** > **Report Summary**
2. View summarized data across hotels
3. Use this for high-level analysis and trends

### 9.7 Creating Report Templates

✏️ **Contributor+**

#### Designing a Report Template

1. Click **Reports** > **Report Templates** (if available)
2. Click **Create Template**
3. Configure:
   - Template name
   - Data source
   - Columns to include
   - Column order and aliases

#### Adding Conditional Formatting

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

---

## 10. Administration

🔧 **Admin Only**

This section covers administrator-only features.

### 10.1 Administration Dashboard

1. Click **Administration** in the navigation menu
2. The Administration Dashboard provides quick access to all admin features:

| Section | Description |
|---------|-------------|
| **Configuration** | Application settings and features |
| **Access Control** | User management and permissions |
| **Activity** | Usage monitoring and reports |
| **Feedback** | User feedback management |

### 10.2 User Management

#### Viewing All Users

1. Click **Administration** > **User Management**
2. View the user list:

| Column | Description |
|--------|-------------|
| **Username** | User's login ID |
| **Full Name** | Display name |
| **Email** | Contact email |
| **User Type** | Account type |
| **Status** | Active/Inactive |
| **Roles** | Assigned roles |
| **Last Login** | Most recent login |
| **Created** | Account creation date |

#### User Status Types

| Status | Description |
|--------|-------------|
| **Active** | User can log in and access the application |
| **Inactive** | User cannot log in (account disabled) |
| **Pending** | Awaiting activation/approval |
| **Locked** | Account locked due to security policy |

#### Creating Individual Users

1. Navigate to **Administration** > **User Management**
2. Click **Add User**
3. Enter user details:

| Field | Description | Required |
|-------|-------------|----------|
| **Username** | Login ID (typically email) | Yes |
| **Email** | User's email address | Yes |
| **First Name** | User's first name | No |
| **Last Name** | User's last name | No |
| **User Type** | Type of user account | Yes |
| **Status** | Active or Inactive | Yes |

4. Select the appropriate role:

| Role | Description |
|------|-------------|
| **Reader** | View-only access |
| **Contributor** | Read and write access |
| **Administrator** | Full access including admin features |

5. Click **Create User**

#### Editing Users

1. Click on the username in the list
2. Modify the desired fields
3. Click **Save Changes**

#### Deactivating Users

1. Open the user's record
2. Change **Status** to **Inactive**
3. Save changes

> **Note:** Deactivating is preferred over deleting. It preserves audit history and allows reactivation.

#### Bulk User Creation

1. Click **Administration** > **Add Multiple Users**
2. Enter users in the text area, one per line:

```
john.smith@hotel.com
jane.doe@hotel.com
bob.wilson@hotel.com
```

Or use CSV format:

```
email,first_name,last_name
john.smith@hotel.com,John,Smith
jane.doe@hotel.com,Jane,Doe
```

3. Click **Next**
4. Select the default role for all users
5. Click **Create Users**
6. Review the results

#### User Types

| User Type | Description |
|-----------|-------------|
| **Standard** | Regular application user |
| **API** | System integration account |
| **Service** | Automated process account |
| **Guest** | Temporary access account |

### 10.3 Access Control Configuration

#### Understanding Access Control

Untapped Revenue uses role-based access control (RBAC) with three tiers:

```
Administrator
    └── Contributor
            └── Reader
```

Each higher role includes all permissions of lower roles.

#### Access Control Scope

The **ACCESS_CONTROL_SCOPE** setting determines default access:

| Setting | Description | Use Case |
|---------|-------------|----------|
| **ACL_ONLY** | Only users explicitly added to the access control list can access | Most secure; recommended for production |
| **ALL_USERS** | Any authenticated APEX user can access as a Reader | Open access for development/testing |

#### Changing Access Control Scope

1. Navigate to **Administration** > **Configure Access Control**
2. Select the desired scope
3. Click **Apply Changes**

> **Warning:** Changing to ALL_USERS significantly reduces security. Use only in controlled environments.

#### Managing User Access

1. Click **Administration** > **Manage User Access**
2. View all users with their assigned roles
3. To assign roles:
   - Open a user's access record
   - Check the roles to assign
   - Save changes

#### Multiple Roles

Users can have multiple roles assigned. The effective permission is the highest role:

| Assigned Roles | Effective Access |
|----------------|------------------|
| Reader only | Reader |
| Reader + Contributor | Contributor |
| All three | Administrator |

### 10.4 Activity Monitoring

#### Activity Dashboard

1. Click **Administration** > **Activity Dashboard**
2. View aggregated activity metrics:

| Metric | Description |
|--------|-------------|
| **Active Users** | Users logged in today |
| **Page Views** | Total page views |
| **Top Pages** | Most visited pages |
| **Recent Activity** | Latest user actions |

#### Page Performance

Monitor page load times:

1. Click **Activity Dashboard** > **Page Performance**
2. Review performance data:

| Metric | Description | Target |
|--------|-------------|--------|
| **Median Time** | Typical page load | < 2 seconds |
| **95th Percentile** | Slow page loads | < 5 seconds |
| **Max Time** | Slowest load | < 10 seconds |

#### Page Views

Track page popularity:

1. Click **Activity Dashboard** > **Page Views**
2. View statistics per page

#### Automations Log

Track automated processes:

1. Click **Activity Dashboard** > **Automations Log**
2. View automation execution history

| Column | Description |
|--------|-------------|
| **Automation Name** | Name of the process |
| **Start Time** | When it started |
| **End Time** | When it completed |
| **Status** | Success/Failed |
| **Messages** | Output or errors |

#### Log Messages

Review application logs:

1. Click **Activity Dashboard** > **Log Messages**
2. Filter and search logs by Level, Date Range, User, or Component

| Level | Description | Action |
|-------|-------------|--------|
| **Error** | Something failed | Investigate immediately |
| **Warning** | Potential issue | Review and monitor |
| **Info** | Normal operation | No action needed |
| **Debug** | Detailed diagnostic | For troubleshooting |

### 10.5 Application Configuration

#### Configuration Options

1. Click **Administration** > **Configuration Options**
2. View and modify settings:

| Setting | Description | Values |
|---------|-------------|--------|
| **ACCESS_CONTROL_SCOPE** | Default access level | ACL_ONLY, ALL_USERS |
| **FEEDBACK_ATTACHMENTS_YN** | Allow feedback attachments | Y, N |

#### Build Options (Feature Toggles)

Enable or disable application features:

| Feature | ID | Description |
|---------|-------|-------------|
| **Access Control** | APPLICATION_ACCESS_CONTROL | Role-based user authentication |
| **Activity Reporting** | APPLICATION_ACTIVITY_REPORTING | Usage reports and charts |
| **Feedback** | APPLICATION_FEEDBACK | User feedback mechanism |
| **Configuration Options** | APPLICATION_CONFIGURATION | Admin feature toggles |
| **About Page** | APPLICATION_ABOUT_PAGE | Application info page |
| **Theme Style Selection** | APPLICATION_THEME_STYLE_SELECTION | Theme customization |
| **Push Notifications** | APPLICATION_PUSH_NOTIFICATIONS | Browser notifications |
| **User Settings** | APPLICATION_USER_SETTINGS | Personal settings page |

> **Warning:** Disabling core features may impact application functionality. Test in a non-production environment first.

#### Application Appearance

1. Click **Administration** > **Application Appearance**
2. Configure:

| Setting | Description |
|---------|-------------|
| **Theme Style** | Color scheme (Vita, Redwood, etc.) |
| **Icon Style** | Navigation icon set |
| **Default Mode** | Light or Dark mode default |

### 10.6 Feedback Management

1. Click **Administration** > **Manage Feedback**
2. View all user feedback submissions:

| Column | Description |
|--------|-------------|
| **ID** | Feedback reference |
| **Submitted By** | User who submitted |
| **Date** | Submission date |
| **Type** | Category of feedback |
| **Status** | Current status |
| **Page** | Where submitted from |
| **Summary** | Brief description |

#### Feedback Status

| Status | Description |
|--------|-------------|
| **New** | Unreviewed feedback |
| **Open** | Under investigation |
| **Closed** | Resolved/completed |
| **Deferred** | Postponed for later |

#### Managing Feedback

1. Click on a feedback item
2. Read the full details
3. View any attachments
4. Update status and add response notes
5. Save changes

### 10.7 Security Best Practices

| Guideline | Recommendation |
|-----------|----------------|
| Least Privilege | Assign minimum required access |
| Regular Review | Audit roles quarterly |
| Prompt Removal | Deactivate departed users immediately |
| Administrator Limit | Minimize admin count |
| ACL_ONLY Mode | Use in production environments |
| Document | Keep role assignments documented |
| Audit | Track and review access changes |

---

## 11. Support Features

### 11.1 Submitting Feedback

🔓 **All Users**

1. Click the **Feedback** link in the navigation bar (top right)
2. Enter your feedback message
3. Optionally attach a file (if enabled)
4. Click **Submit**

Your feedback is sent to application administrators for review.

### 11.2 Using the Help Page

🔓 **All Users**

1. Click the **Help** icon (question mark) in the navigation bar
2. Browse available help topics
3. Search for specific guidance

### 11.3 About Page Information

🔓 **All Users**

1. Click your username in the header
2. Select **About** from the dropdown
3. View:
   - Application name and version
   - Build information
   - Support contact details

---

## Appendices

### A. User Role Permissions Matrix

| Feature | Reader | Contributor | Administrator |
|---------|:------:|:-----------:|:-------------:|
| View Hotels | ✓ | ✓ | ✓ |
| Edit Hotels | | ✓ | ✓ |
| View Events | ✓ | ✓ | ✓ |
| Edit Events | | ✓ | ✓ |
| Run Reports | ✓ | ✓ | ✓ |
| Create Reports | | ✓ | ✓ |
| View Strategies | ✓ | ✓ | ✓ |
| Edit Strategies | | ✓ | ✓ |
| Load Data | | ✓ | ✓ |
| Manage Users | | | ✓ |
| Configure Access | | | ✓ |
| View Activity | | | ✓ |
| Manage Feedback | | | ✓ |
| Configure App | | | ✓ |

### B. Data Import Template Formats

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

### C. Algorithm Expression Reference

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
SUM(values) - Sum of values
AVERAGE(values) - Average of values
COUNT(values) - Count of values
```

### D. Event Types and Impact Levels

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

### E. Troubleshooting Common Issues

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

#### User Access Problems

| Cause | Solution |
|-------|----------|
| Wrong credentials | Reset password via APEX admin |
| Account inactive | Activate the user account |
| No roles assigned | Assign at least Reader role |
| ACL_ONLY without ACL entry | Add user to access control |

### F. Glossary

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
| **PWA** | Progressive Web App - installable web application |
| **RBAC** | Role-Based Access Control |

### G. Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl + F` | Open search/filter |
| `Enter` | Submit current form |
| `Esc` | Close modal dialog |
| `Tab` | Move to next field |

### H. Browser Compatibility

Untapped Revenue works best with:

- Google Chrome (recommended)
- Microsoft Edge
- Mozilla Firefox
- Safari (latest versions)

For optimal experience, ensure your browser is up to date.

### I. Page Reference

| Page | Alias | Purpose | Minimum Role |
|------|-------|---------|--------------|
| 1 | HOME | Home page | Reader |
| 9 | HOTEL-EVENTS | Event management | Reader |
| 10 | MANAGE-CLUSTER | Hotel clusters | Reader |
| 11 | HOTELS | Hotel list | Reader |
| 12 | CREATE-CONTACT-FORM | Create contact | Contributor |
| 13 | CREATE-ROOM-TYPES | Create room types | Contributor |
| 15 | REPORT-DASHBOARD | Run reports | Reader |
| 17 | CREATE-ADDRESS-FORM | Create address | Contributor |
| 19 | RESERVATION-UPDATE | Reservations | Reader |
| 20 | CREATE-EVENTS | Create event | Contributor |
| 22 | CREATE-RESERVATION-FORM | Create reservation | Contributor |
| 23 | CREATE-HOTEL-FORM | Create hotel | Contributor |
| 27 | UPLOAD-EVENTS | Bulk event upload | Contributor |
| 29 | TEMPLATE-LIST | Data templates | Reader |
| 1050 | ALGORITHM | Pricing algorithms | Reader |
| 1071 | CREATE-PRICE-OVERRIDES | Create override | Contributor |
| 1075 | PRICE-OVERRIDES | Override list | Reader |
| 10000 | ADMINISTRATION | Admin dashboard | Administrator |
| 10010 | CONFIGURATION-OPTIONS | App configuration | Administrator |
| 10030 | ACTIVITY-DASHBOARD | Usage monitoring | Administrator |
| 10040 | CONFIGURE-ACCESS-CONTROL | Access control | Administrator |
| 10041 | MANAGE-USER-ACCESS | User roles | Administrator |
| 10053 | MANAGE-FEEDBACK | Feedback management | Administrator |
| 1611 | USER-MANAGMENT | User list | Administrator |

---

**Need Help?**

- Use the in-app **Feedback** feature to submit questions
- Contact your system administrator
- Check the role badges in this guide to verify your access level

---

*This is the combined functional user guide for the Untapped Revenue application. Role requirements are indicated using badges throughout the document.*
