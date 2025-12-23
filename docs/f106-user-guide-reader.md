# Untapped Revenue (UR) - Reader User Guide

**Application Version:** Oracle APEX 24.2.11
**Application ID:** 106
**Last Updated:** December 2024

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Getting Started](#2-getting-started)
3. [Viewing Hotel Information](#3-viewing-hotel-information)
4. [Viewing Events](#4-viewing-events)
5. [Running Reports](#5-running-reports)
6. [Viewing Reservations](#6-viewing-reservations)
7. [Support Features](#7-support-features)
8. [Appendix](#appendix)

---

## 1. Introduction

### 1.1 Welcome to Untapped Revenue

Welcome to **Untapped Revenue (UR)**, a comprehensive hotel revenue management and optimization system. This application helps hotel properties maximize revenue through dynamic pricing strategies, event management, and competitive analysis.

### 1.2 Your Role as a Reader

As a **Reader**, you have read-only access to the application. This means you can:

- **View** all hotel information, events, and reservation data
- **Run** reports and export them to Excel or PDF
- **Access** the Report Dashboard and view analytics
- **Submit** feedback to administrators
- **Use** Help and About pages for assistance

You **cannot**:

- Create, edit, or delete hotels, events, or other data
- Modify pricing strategies or algorithms
- Access the Administration section
- Manage users or configure application settings

### 1.3 Application Overview

Untapped Revenue manages multiple hotels and provides:

- **Hotel Management**: View hotel properties, clusters, room types, contacts, and addresses
- **Event Tracking**: View local and regional events that impact hotel demand
- **Reporting**: Run comprehensive reports with export capabilities
- **Reservation Data**: View booking information and exceptions

---

## 2. Getting Started

### 2.1 Logging into the Application

1. Navigate to the application URL provided by your administrator
2. Enter your **Username** (typically your email address)
3. Enter your **Password**
4. Click **Sign In**

> **Note:** Your account is managed through Oracle APEX workspace accounts. Contact your administrator if you need to reset your password.

### 2.2 Understanding the Home Page

After logging in, you will see the **Home** page with:

- **Navigation Menu**: Located on the left side (or accessible via the hamburger menu on mobile)
- **Header Bar**: Contains your user menu, feedback, and help options
- **Hotel Selector**: A dropdown in the header to filter data by specific hotel or view all hotels

### 2.3 Navigation Menu Overview

The navigation menu provides access to all available features:

| Menu Item | Icon | Description |
|-----------|------|-------------|
| **Hotel Management** | Building | View hotels, clusters, room types, contacts, addresses |
| **Event Management** | Cake/Event | View events affecting hotel demand |
| **Hotel Data** | University | View data templates and load history |
| **Strategies** | Calculator | View pricing algorithms (read-only) |
| **Reports** | Files | Run reports and view analytics |

### 2.4 Installing as a Progressive Web App (PWA)

Untapped Revenue can be installed as an app on your device for easier access:

**On Desktop (Chrome/Edge):**
1. Click the **Install App** icon in the navigation bar
2. Follow the browser prompts to install
3. The app will appear in your Start menu or Applications folder

**On Mobile:**
1. Tap the browser menu (three dots)
2. Select **Add to Home Screen** or **Install App**
3. The app icon will appear on your home screen

### 2.5 User Settings and Preferences

Access your personal settings by clicking your username in the top-right corner:

1. Click your **username** in the header
2. Select **Settings** from the dropdown
3. Available settings include:
   - **Theme Preference**: Choose between light and dark mode
   - **Push Notifications**: Enable or disable browser notifications

---

## 3. Viewing Hotel Information

### 3.1 Accessing the Hotels List

To view all hotels in the system:

1. Click **Hotel Management** in the navigation menu
2. Select **Hotels** from the submenu
3. The Hotels page displays an interactive grid with all hotel properties

### 3.2 Understanding the Hotels Grid

The Hotels grid displays the following information:

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

### 3.3 Viewing Hotel Details

To view detailed information about a specific hotel:

1. Click on the **Hotel Name** link in the grid
2. A modal dialog opens showing:
   - Basic hotel information
   - Associated cluster
   - Address and contact details
   - Assigned pricing strategy
   - Association dates

### 3.4 Viewing Hotel Clusters

Hotel clusters group related properties together:

1. Click **Hotel Management** > **Manage Cluster**
2. View the list of all hotel groups/clusters
3. Click a cluster name to see its details:
   - Cluster name and description
   - Associated address and contact
   - List of hotels in the cluster

### 3.5 Viewing Room Types

To see room types configured for each hotel:

1. Click **Hotel Management** > **Room Types**
2. Select a hotel from the dropdown filter
3. View room type details:

| Column | Description |
|--------|-------------|
| **Room Type Name** | Name of the room category |
| **Max Occupancy** | Maximum number of guests (1-10) |
| **Bed Type** | Type of bed(s) in the room |
| **Description** | Additional room details |
| **Price** | Base room rate |
| **Supplement Type** | Additional pricing rules |
| **Supplement Price Range** | Min/max supplement amounts |

### 3.6 Viewing Contacts

To view hotel contacts:

1. Click **Hotel Management** > **Contact Directory**
2. Filter by hotel if needed
3. View contact information:
   - Contact name and position
   - Email and phone number
   - Contact type
   - Primary contact indicator

### 3.7 Viewing Addresses

To view hotel addresses:

1. Click **Hotel Management** > **Address Book**
2. Filter by hotel if needed
3. View address details:
   - Street address
   - Post code, city, county, country
   - Primary address indicator

---

## 4. Viewing Events

### 4.1 Accessing Hotel Events

Events are external factors (conferences, concerts, sports events, etc.) that impact hotel demand:

1. Click **Event Management** in the navigation menu
2. The Hotel Events page displays an interactive grid of all events

### 4.2 Understanding Event Data

The Events grid displays:

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

### 4.3 Event Types

Common event types in the system:

| Event Type | Description |
|------------|-------------|
| **Conference** | Business conferences and conventions |
| **Concert** | Music concerts and performances |
| **Sports** | Sporting events and competitions |
| **Festival** | Cultural and community festivals |
| **Exhibition** | Trade shows and exhibitions |
| **Holiday** | Public holidays and observances |

### 4.4 Understanding Impact Levels

Impact levels indicate how significantly an event affects hotel demand:

| Impact Level | Description |
|--------------|-------------|
| **Low** | Minor increase in demand |
| **Medium** | Moderate demand increase |
| **High** | Significant demand surge |
| **Critical** | Major event causing peak demand |

### 4.5 Filtering Events

To filter the events grid:

1. **By Hotel**: Use the hotel dropdown at the top of the page
2. **By Date**: Filter using the date columns
3. **By Type**: Use the column filter for Event Type
4. **Search**: Use the search box for text-based filtering

---

## 5. Running Reports

### 5.1 Accessing the Report Dashboard

The Report Dashboard is your primary tool for viewing and exporting data:

1. Click **Reports** in the navigation menu
2. Select **Run Reports** or access the **Report Dashboard** directly

### 5.2 Selecting a Report

On the Report Dashboard:

1. **Select Hotel**: Choose a specific hotel or "All Hotels" from the dropdown
2. **Select Report**: Choose the report type you want to run
3. **Set Parameters**: Enter any required date ranges or filters
4. Click **Run Report** to generate results

### 5.3 Understanding Report Data

Reports display in an interactive grid format with:

- **Sortable columns**: Click headers to sort
- **Filterable data**: Use column filters for refined views
- **Conditional formatting**: Color-coded cells based on values
- **Aggregations**: Totals and summaries where applicable

### 5.4 Exporting to Excel

To export report data to Excel with formatting preserved:

1. Generate your report as described above
2. Click the **Export to Excel** button
3. The file downloads as an `.xlsx` file with:
   - All data from the report
   - Column formatting preserved
   - Conditional formatting applied
   - Proper column widths

> **Technical Note:** Excel exports use the ExcelJS library to maintain formatting and styling.

### 5.5 Exporting to PDF

To export report data to PDF:

1. Generate your report
2. Click the **Export to PDF** button
3. The file downloads as a `.pdf` file with:
   - Formatted table layout
   - All visible data
   - Professional styling

> **Technical Note:** PDF exports use the jsPDF library with autotable plugin.

### 5.6 Report Summary View

For aggregated views of report data:

1. Click **Reports** > **Report Summary**
2. View summarized data across hotels
3. Use this for high-level analysis and trends

---

## 6. Viewing Reservations

### 6.1 Accessing Reservation Data

To view hotel reservations:

1. Click **Hotel Data** in the navigation menu
2. Select **Reservation Update** (view mode for Readers)
3. The reservations grid displays booking data

### 6.2 Understanding Reservation Data

The Reservations grid shows:

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

### 6.3 Understanding Reservation Exceptions

Exceptions flag unusual or noteworthy reservations:

| Exception Type | Description |
|----------------|-------------|
| **Cancellation** | Booking was cancelled |
| **No-Show** | Guest did not arrive |
| **Early Departure** | Guest left before scheduled checkout |
| **Late Checkout** | Extended stay past checkout time |
| **Override** | Manual price or rate adjustment applied |

---

## 7. Support Features

### 7.1 Submitting Feedback

To provide feedback to administrators:

1. Click the **Feedback** link in the navigation bar (top right)
2. Enter your feedback message
3. Optionally attach a file (if enabled)
4. Click **Submit**

Your feedback is sent to application administrators for review.

### 7.2 Using the Help Page

For in-application help:

1. Click the **Help** icon (question mark) in the navigation bar
2. Browse available help topics
3. Search for specific guidance

### 7.3 About Page Information

To view application information:

1. Click your username in the header
2. Select **About** from the dropdown
3. View:
   - Application name and version
   - Build information
   - Support contact details

---

## Appendix

### A. Glossary of Terms

| Term | Definition |
|------|------------|
| **Algorithm** | A pricing strategy that automatically adjusts rates |
| **Cluster** | A group of related hotel properties |
| **Event Score** | A numerical value indicating event impact on demand |
| **Impact Level** | Rating of how significantly an event affects bookings |
| **Lead Time** | Days between booking date and check-in date |
| **Override** | A manual price adjustment bypassing automatic pricing |
| **PWA** | Progressive Web App - installable web application |
| **Stay Window** | Date range for which a pricing rule applies |

### B. Frequently Asked Questions (FAQ)

**Q: Why can't I edit hotel information?**
A: As a Reader, you have view-only access. Contact your administrator if you need Contributor access.

**Q: How do I reset my password?**
A: Contact your APEX workspace administrator to reset your password.

**Q: Can I save my report filters for later?**
A: Report filters can be saved using the "Save Report" feature in the Actions menu of most grids.

**Q: Why don't I see all hotels in the dropdown?**
A: You may only have access to specific hotels. Contact your administrator if you need broader access.

**Q: How often is the data updated?**
A: Data is typically updated in real-time as changes are made by Contributors and Administrators.

**Q: Can I export large reports?**
A: Yes, but very large exports may take longer to generate. For extremely large datasets, consider filtering to reduce the data volume.

### C. Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl + F` | Open search/filter |
| `Enter` | Submit current form |
| `Esc` | Close modal dialog |
| `Tab` | Move to next field |

### D. Browser Compatibility

Untapped Revenue works best with:

- Google Chrome (recommended)
- Microsoft Edge
- Mozilla Firefox
- Safari (latest versions)

For optimal experience, ensure your browser is up to date.

---

**Need Help?**
Contact your system administrator or use the Feedback feature to submit questions.

---

*This guide is for Reader users of the Untapped Revenue application. For write access and additional features, request Contributor or Administrator access from your system administrator.*
