# Untapped Revenue (UR) - Administrator User Guide

**Application Version:** Oracle APEX 24.2.11
**Application ID:** 106
**Last Updated:** December 2024

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Getting Started](#2-getting-started)
3. [Contributor Features Overview](#3-contributor-features-overview)
4. [Administration Dashboard](#4-administration-dashboard)
5. [User Management](#5-user-management)
6. [Access Control Configuration](#6-access-control-configuration)
7. [Activity Monitoring](#7-activity-monitoring)
8. [Application Configuration](#8-application-configuration)
9. [Feedback Management](#9-feedback-management)
10. [Security Best Practices](#10-security-best-practices)
11. [Troubleshooting](#11-troubleshooting)
12. [Appendices](#appendices)

---

## 1. Introduction

### 1.1 Welcome to Untapped Revenue Administration

As an **Administrator** of Untapped Revenue, you have full access to all application features plus administrative capabilities. This guide focuses on the administration-specific features. For operational features (hotels, events, data management, pricing), refer to the **Contributor User Guide**.

### 1.2 Administrator Responsibilities

As an Administrator, you are responsible for:

- **User Management**: Creating, editing, and deactivating user accounts
- **Access Control**: Assigning roles and permissions to users
- **System Monitoring**: Tracking application usage and performance
- **Configuration**: Enabling/disabling features and configuring settings
- **Security**: Ensuring proper access controls and audit compliance
- **Support**: Managing user feedback and resolving issues

### 1.3 Full Access Overview

| Feature Area | Access Level |
|--------------|--------------|
| All Contributor Features | Full Access |
| Administration Dashboard | Full Access |
| User Management | Full Access |
| Access Control Configuration | Full Access |
| Activity Reports | Full Access |
| Application Configuration | Full Access |
| Build Options Management | Full Access |
| Feedback Management | Full Access |

---

## 2. Getting Started

### 2.1 Administrator Login

1. Navigate to the application URL
2. Enter your administrator credentials
3. Click **Sign In**

Upon login, you'll see the standard navigation plus access to the **Administration** section.

### 2.2 Administrator Navigation

As an Administrator, you have access to an additional menu:

| Menu Item | Icon | Description |
|-----------|------|-------------|
| **Administration** | Wrench | Access all admin features |

The Administration menu contains:

- Configuration Options
- Application Appearance
- Activity Dashboard
- User Management
- Access Control
- Feedback Management

### 2.3 Quick Access to Admin Features

From any page, access administration via:

1. Click **Administration** in the navigation menu
2. Or click your username > **Administration**

---

## 3. Contributor Features Overview

As an Administrator, you have full access to all Contributor features. For detailed documentation on these features, refer to the **Contributor User Guide**:

| Feature | Guide Section |
|---------|---------------|
| Hotel Management | Contributor Guide Section 3 |
| Event Management | Contributor Guide Section 4 |
| Data Management | Contributor Guide Section 5 |
| Pricing Strategies | Contributor Guide Section 6 |
| Price Overrides | Contributor Guide Section 7 |
| Reservations | Contributor Guide Section 8 |
| Reporting | Contributor Guide Section 9 |

---

## 4. Administration Dashboard

### 4.1 Accessing the Dashboard

1. Click **Administration** in the navigation menu
2. The Administration Dashboard displays

### 4.2 Dashboard Overview

The Administration Dashboard provides quick access to all admin features:

| Section | Description |
|---------|-------------|
| **Configuration** | Application settings and features |
| **Access Control** | User management and permissions |
| **Activity** | Usage monitoring and reports |
| **Feedback** | User feedback management |

### 4.3 Dashboard Cards

Each card shows:

- Feature name and icon
- Quick statistics (if applicable)
- Click to access the feature

---

## 5. User Management

### 5.1 Accessing User Management

1. Click **Administration** > **User Management**
2. Or navigate to the **Manage User Access** page

### 5.2 Viewing All Users

The User Management page displays:

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

### 5.3 User Status Types

| Status | Description |
|--------|-------------|
| **Active** | User can log in and access the application |
| **Inactive** | User cannot log in (account disabled) |
| **Pending** | Awaiting activation/approval |
| **Locked** | Account locked due to security policy |

### 5.4 Creating Individual Users

#### Step 1: Open Create User Form

1. Navigate to **Administration** > **User Management**
2. Click **Add User**

#### Step 2: Enter User Details

| Field | Description | Required |
|-------|-------------|----------|
| **Username** | Login ID (typically email) | Yes |
| **Email** | User's email address | Yes |
| **First Name** | User's first name | No |
| **Last Name** | User's last name | No |
| **User Type** | Type of user account | Yes |
| **Status** | Active or Inactive | Yes |

#### Step 3: Assign Role

Select the appropriate role:

| Role | Description |
|------|-------------|
| **Reader** | View-only access |
| **Contributor** | Read and write access |
| **Administrator** | Full access including admin features |

#### Step 4: Save

1. Review the entered information
2. Click **Create User**
3. User receives notification (if email configured)

### 5.5 Editing Users

1. Click on the username in the list
2. Modify the desired fields
3. Click **Save Changes**

#### Common Edits

| Edit Type | When to Use |
|-----------|-------------|
| Change Role | User needs different access level |
| Update Email | Contact information changed |
| Change Status | Activate or deactivate user |
| Update Name | Name correction |

### 5.6 Deactivating Users

To disable a user's access:

1. Open the user's record
2. Change **Status** to **Inactive**
3. Save changes

> **Note:** Deactivating is preferred over deleting. It preserves audit history and allows reactivation.

### 5.7 Bulk User Creation

For adding multiple users at once:

#### Step 1: Start Bulk Creation

1. Click **Administration** > **Add Multiple Users**
2. The wizard opens at Step 1

#### Step 2: Enter User List

Enter users in the text area, one per line:

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

Click **Next**

#### Step 3: Assign Roles

1. Select the default role for all users
2. Optionally customize individual roles
3. Review the user list

#### Step 4: Complete

1. Click **Create Users**
2. Review the results:
   - Successfully created users
   - Any errors or duplicates

### 5.8 User Types

| User Type | Description |
|-----------|-------------|
| **Standard** | Regular application user |
| **API** | System integration account |
| **Service** | Automated process account |
| **Guest** | Temporary access account |

---

## 6. Access Control Configuration

### 6.1 Understanding Access Control

Untapped Revenue uses role-based access control (RBAC) with three tiers:

```
Administrator
    └── Contributor
            └── Reader
```

Each higher role includes all permissions of lower roles.

### 6.2 Accessing Access Control Settings

1. Click **Administration** > **Configure Access Control**
2. The Access Control Configuration page opens

### 6.3 Access Control Scope

The **ACCESS_CONTROL_SCOPE** setting determines default access:

| Setting | Description | Use Case |
|---------|-------------|----------|
| **ACL_ONLY** | Only users explicitly added to the access control list can access | Most secure; recommended for production |
| **ALL_USERS** | Any authenticated APEX user can access as a Reader | Open access for development/testing |

#### Changing Access Control Scope

1. Navigate to Access Control Configuration
2. Select the desired scope
3. Click **Apply Changes**

> **Warning:** Changing to ALL_USERS significantly reduces security. Use only in controlled environments.

### 6.4 Role Definitions

#### Reader Role

| Permission | Allowed |
|------------|---------|
| View hotels, events, data | Yes |
| Run reports | Yes |
| Export data | Yes |
| Create/edit data | No |
| Access Administration | No |

#### Contributor Role

| Permission | Allowed |
|------------|---------|
| All Reader permissions | Yes |
| Create/edit hotels, events | Yes |
| Manage templates and data loads | Yes |
| Create pricing strategies | Yes |
| Manage price overrides | Yes |
| Access Administration | No |

#### Administrator Role

| Permission | Allowed |
|------------|---------|
| All Contributor permissions | Yes |
| User management | Yes |
| Access control configuration | Yes |
| Application configuration | Yes |
| Activity monitoring | Yes |
| Feedback management | Yes |

### 6.5 Managing User Access

#### Viewing Current Access

1. Click **Administration** > **Manage User Access**
2. View all users with their assigned roles

#### Assigning Roles

1. Open a user's access record
2. Check the roles to assign:
   - [ ] Reader
   - [ ] Contributor
   - [ ] Administrator
3. Save changes

#### Multiple Roles

Users can have multiple roles assigned. The effective permission is the highest role:

| Assigned Roles | Effective Access |
|----------------|------------------|
| Reader only | Reader |
| Reader + Contributor | Contributor |
| All three | Administrator |

#### Removing Access

1. Open the user's access record
2. Uncheck all roles
3. Save changes
4. User loses application access

---

## 7. Activity Monitoring

### 7.1 Activity Dashboard

Monitor application usage and user activity:

1. Click **Administration** > **Activity Dashboard**
2. View aggregated activity metrics

#### Dashboard Metrics

| Metric | Description |
|--------|-------------|
| **Active Users** | Users logged in today |
| **Page Views** | Total page views |
| **Top Pages** | Most visited pages |
| **Recent Activity** | Latest user actions |

### 7.2 Page Performance

Monitor page load times and performance:

1. Click **Activity Dashboard** > **Page Performance**
2. Review performance data:

| Metric | Description | Target |
|--------|-------------|--------|
| **Median Time** | Typical page load | < 2 seconds |
| **95th Percentile** | Slow page loads | < 5 seconds |
| **Max Time** | Slowest load | < 10 seconds |
| **Load Count** | Number of loads | N/A |

#### Identifying Slow Pages

1. Sort by **Median Time** descending
2. Review pages exceeding targets
3. Investigate causes:
   - Complex queries
   - Large data sets
   - Inefficient processes

### 7.3 Page Views

Track page popularity and usage patterns:

1. Click **Activity Dashboard** > **Page Views**
2. View statistics:

| Data | Description |
|------|-------------|
| **Page Name** | Application page |
| **View Count** | Number of views |
| **Unique Users** | Distinct users |
| **Last Viewed** | Most recent view |

#### Usage Analysis

- **High traffic pages**: Prioritize for optimization
- **Unused pages**: Consider removal or promotion
- **Peak times**: Identify busy periods

### 7.4 Automations Log

Track automated processes:

1. Click **Activity Dashboard** > **Automations Log**
2. View automation execution history:

| Column | Description |
|--------|-------------|
| **Automation Name** | Name of the process |
| **Start Time** | When it started |
| **End Time** | When it completed |
| **Status** | Success/Failed |
| **Messages** | Output or errors |

### 7.5 Log Messages

Review application logs:

1. Click **Activity Dashboard** > **Log Messages**
2. Filter and search logs:

| Filter | Description |
|--------|-------------|
| **Level** | Error, Warning, Info, Debug |
| **Date Range** | Time period |
| **User** | Specific user |
| **Component** | Application area |

#### Log Levels

| Level | Description | Action |
|-------|-------------|--------|
| **Error** | Something failed | Investigate immediately |
| **Warning** | Potential issue | Review and monitor |
| **Info** | Normal operation | No action needed |
| **Debug** | Detailed diagnostic | For troubleshooting |

---

## 8. Application Configuration

### 8.1 Configuration Options

Manage application-wide settings:

1. Click **Administration** > **Configuration Options**
2. View and modify settings

### 8.2 Application Settings

| Setting | Description | Values |
|---------|-------------|--------|
| **ACCESS_CONTROL_SCOPE** | Default access level | ACL_ONLY, ALL_USERS |
| **FEEDBACK_ATTACHMENTS_YN** | Allow feedback attachments | Y, N |

### 8.3 Build Options (Feature Toggles)

Enable or disable application features:

1. Access Configuration Options
2. View Build Options section
3. Toggle features on/off

#### Available Features

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

#### Toggling Features

1. Find the feature in the list
2. Click the toggle switch
3. Confirm the change

> **Warning:** Disabling core features may impact application functionality. Test in a non-production environment first.

### 8.4 Application Appearance

Customize the application theme:

1. Click **Administration** > **Application Appearance**
2. Configure appearance settings:

| Setting | Description |
|---------|-------------|
| **Theme Style** | Color scheme (Vita, Redwood, etc.) |
| **Icon Style** | Navigation icon set |
| **Default Mode** | Light or Dark mode default |

#### Applying Theme Changes

1. Select new theme style
2. Click **Apply Changes**
3. Changes apply application-wide

---

## 9. Feedback Management

### 9.1 Accessing Feedback

1. Click **Administration** > **Manage Feedback**
2. View all user feedback submissions

### 9.2 Feedback List

| Column | Description |
|--------|-------------|
| **ID** | Feedback reference |
| **Submitted By** | User who submitted |
| **Date** | Submission date |
| **Type** | Category of feedback |
| **Status** | Current status |
| **Page** | Where submitted from |
| **Summary** | Brief description |

### 9.3 Feedback Status

| Status | Description |
|--------|-------------|
| **New** | Unreviewed feedback |
| **Open** | Under investigation |
| **Closed** | Resolved/completed |
| **Deferred** | Postponed for later |

### 9.4 Managing Feedback

#### Reviewing Feedback

1. Click on a feedback item
2. Read the full details
3. View any attachments

#### Updating Status

1. Open the feedback item
2. Change the status dropdown
3. Add response notes
4. Save changes

#### Best Practices

- Review new feedback daily
- Respond to users when possible
- Track patterns for system improvements
- Close resolved items promptly

---

## 10. Security Best Practices

### 10.1 Role Assignment Guidelines

| Guideline | Recommendation |
|-----------|----------------|
| Least Privilege | Assign minimum required access |
| Regular Review | Audit roles quarterly |
| Prompt Removal | Deactivate departed users immediately |
| Administrator Limit | Minimize admin count |

### 10.2 Access Control Recommendations

1. **Use ACL_ONLY mode** in production
2. **Document** role assignments
3. **Audit** access changes
4. **Review** inactive users monthly

### 10.3 Audit Trail Usage

Track changes using built-in auditing:

1. WHO columns (created_by, updated_by)
2. WHEN columns (created_on, updated_on)
3. Activity logs for user actions

### 10.4 Session Management

| Setting | Value | Purpose |
|---------|-------|---------|
| Session Timeout | 30 minutes | Auto-logout inactive users |
| Rejoin Sessions | Disabled | Prevent session hijacking |
| Browser Cache | Disabled | Protect sensitive data |
| Secure Cookies | Recommended | Encrypt session data |

### 10.5 Password Policies

Work with your APEX Workspace Administrator to enforce:

- Minimum password length (8+ characters)
- Complexity requirements
- Password expiration
- Login attempt limits

---

## 11. Troubleshooting

### 11.1 Common Admin Issues

#### Users Cannot Log In

| Cause | Solution |
|-------|----------|
| Wrong credentials | Reset password via APEX admin |
| Account inactive | Activate the user account |
| No roles assigned | Assign at least Reader role |
| ACL_ONLY without ACL entry | Add user to access control |

#### Users Missing Features

| Cause | Solution |
|-------|----------|
| Wrong role | Assign correct role |
| Feature disabled | Enable in Build Options |
| Page authorization | Check page authorization scheme |

#### Performance Issues

| Symptom | Investigation |
|---------|---------------|
| Slow page loads | Check Page Performance report |
| Timeouts | Review log messages for errors |
| High load | Check concurrent user count |

### 11.2 User Access Problems

#### "Not Authorized" Errors

1. Check user's assigned roles
2. Verify ACCESS_CONTROL_SCOPE setting
3. Confirm page authorization requirements
4. Review application-level security scheme

#### Missing Navigation Items

1. Check user's role (some menus role-restricted)
2. Verify Build Options for features
3. Confirm navigation list authorizations

### 11.3 Performance Issues

#### Identifying Bottlenecks

1. Review **Page Performance** report
2. Check **Log Messages** for errors
3. Monitor database performance (outside APEX)

#### Common Solutions

| Issue | Solution |
|-------|----------|
| Slow queries | Optimize SQL, add indexes |
| Large data sets | Implement pagination |
| Complex processes | Optimize PL/SQL code |
| Many users | Scale infrastructure |

### 11.4 Error Resolution

#### Application Errors

1. Note the error message
2. Check **Log Messages** for details
3. Review error stack trace
4. Consult Oracle APEX documentation

#### Data Errors

1. Check data validation rules
2. Review constraint violations
3. Verify foreign key references
4. Check data type mismatches

---

## Appendices

### A. User Role Permissions Matrix

| Feature | Reader | Contributor | Administrator |
|---------|--------|-------------|---------------|
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

### B. Build Options Reference

| Build Option | Static ID | Default |
|--------------|-----------|---------|
| Access Control | APPLICATION_ACCESS_CONTROL | Include |
| Activity Reporting | APPLICATION_ACTIVITY_REPORTING | Include |
| Feedback | APPLICATION_FEEDBACK | Include |
| Configuration Options | APPLICATION_CONFIGURATION | Include |
| About Page | APPLICATION_ABOUT_PAGE | Include |
| Theme Style Selection | APPLICATION_THEME_STYLE_SELECTION | Include |
| Push Notifications | APPLICATION_PUSH_NOTIFICATIONS | Include |
| User Settings | APPLICATION_USER_SETTINGS | Include |

### C. Security Configuration Reference

| Setting | Location | Purpose |
|---------|----------|---------|
| Page Protection | Application Properties | Enable checksum validation |
| Checksum Salt | Application Properties | Unique hash key |
| Bookmark Checksum | Application Properties | SH512 algorithm |
| Session Rejoin | Application Properties | Disabled for security |
| Browser Cache | Application Properties | Disabled for security |

### D. Application Settings Reference

| Setting Name | Valid Values | Description |
|--------------|--------------|-------------|
| ACCESS_CONTROL_SCOPE | ACL_ONLY, ALL_USERS | Default access level |
| FEEDBACK_ATTACHMENTS_YN | Y, N | Allow file attachments |

### E. Database Tables Reference

| Table | Description |
|-------|-------------|
| UR_HOTELS | Hotel properties |
| UR_HOTEL_GROUPS | Hotel clusters |
| UR_ADDRESSES | Physical addresses |
| UR_CONTACTS | Contact information |
| UR_EVENTS | Market events |
| UR_ALGOS | Pricing algorithms |
| UR_ALGO_VERSIONS | Algorithm versions |
| UR_HOTEL_ROOM_TYPES | Room types |
| UR_HOTEL_PRICE_OVERRIDE | Price overrides |
| UR_HOTEL_RESERVATIONS | Reservation data |
| UR_TEMPLATES | Data import templates |
| UR_INTERFACE_LOGS | Import/export logs |
| UR_USERS | Application users |
| UR_VK_SEGMENT_QUALIFIER | Validation qualifiers |

### F. Page Reference for Administrators

| Page | Alias | Purpose |
|------|-------|---------|
| 10000 | ADMINISTRATION | Admin dashboard |
| 10010 | CONFIGURATION-OPTIONS | App configuration |
| 10020 | APPLICATION-APPEARANCE | Theme settings |
| 10030 | ACTIVITY-DASHBOARD | Usage monitoring |
| 10033 | PAGE-PERFORMANCE | Performance metrics |
| 10034 | PAGE-VIEWS | Page view stats |
| 10035 | AUTOMATIONS-LOG | Automation history |
| 10036 | LOG-MESSAGES | Application logs |
| 10040 | CONFIGURE-ACCESS-CONTROL | Access control setup |
| 10041 | MANAGE-USER-ACCESS | User role management |
| 10043 | ADD-MULTIPLE-USERS-STEP-1 | Bulk user creation |
| 10044 | ADD-MULTIPLE-USERS-STEP-2 | Bulk user roles |
| 10053 | MANAGE-FEEDBACK | Feedback management |
| 1611 | USER-MANAGMENT | User list |
| 1612 | CREATE-USER-FORM | Create user form |

---

## Quick Reference Card

### Common Admin Tasks

| Task | Path |
|------|------|
| Add user | Administration > User Management > Add User |
| Assign role | Administration > Manage User Access |
| View activity | Administration > Activity Dashboard |
| Enable feature | Administration > Configuration Options |
| Change theme | Administration > Application Appearance |
| Review feedback | Administration > Manage Feedback |

### Emergency Procedures

| Situation | Action |
|-----------|--------|
| Security breach | 1. Deactivate compromised accounts 2. Review logs 3. Change ACCESS_CONTROL_SCOPE to ACL_ONLY |
| System overload | 1. Check Page Performance 2. Review active users 3. Consider restricting access |
| Data corruption | 1. Stop data loads 2. Review Interface Logs 3. Contact DBA |

---

**Administrator Support**

For issues beyond this guide:
- Consult Oracle APEX documentation
- Contact your DBA for database issues
- Review application log messages
- Submit feedback through the application

---

*This guide is for Administrator users of the Untapped Revenue application. Administrators have full access to all features documented in the Reader and Contributor guides.*
