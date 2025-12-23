# Untapped Revenue (UR) - Technical Developer Guide

**Application:** Untapped Revenue (UR)
**Application ID:** 106 (Internal: 103)
**APEX Version:** 24.2.11
**Schema Owner:** WKSP_DEV
**Last Updated:** December 2024

---

## Table of Contents

1. [Architecture Overview](#1-architecture-overview)
2. [Database Schema](#2-database-schema)
3. [PL/SQL Components](#3-plsql-components)
4. [Application Pages](#4-application-pages)
5. [Application Processes](#5-application-processes)
6. [JavaScript Components](#6-javascript-components)
7. [Lists of Values (LOVs)](#7-lists-of-values-lovs)
8. [Navigation & Security](#8-navigation--security)
9. [External Integrations](#9-external-integrations)
10. [Common Development Tasks](#10-common-development-tasks)
11. [Troubleshooting Guide](#11-troubleshooting-guide)
12. [Appendices](#appendices)

---

## 1. Architecture Overview

### 1.1 System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        ORACLE APEX 24.2.11                       │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Pages     │  │  Processes  │  │  JavaScript │              │
│  │  (UI/Forms) │  │  (PL/SQL)   │  │  (Client)   │              │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘              │
│         │                │                │                      │
│  ┌──────┴────────────────┴────────────────┴──────┐              │
│  │              Shared Components                 │              │
│  │  • LOVs  • Navigation  • Security  • Files    │              │
│  └───────────────────────┬───────────────────────┘              │
├──────────────────────────┼──────────────────────────────────────┤
│                          │                                       │
│  ┌───────────────────────┴───────────────────────┐              │
│  │                  Oracle Database               │              │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐        │              │
│  │  │ Tables  │  │Packages │  │Triggers │        │              │
│  │  │ (UR_*) │  │(UR_UTILS)│  │(TRG_*)  │        │              │
│  │  └─────────┘  └─────────┘  └─────────┘        │              │
│  └───────────────────────────────────────────────┘              │
└─────────────────────────────────────────────────────────────────┘

External Integrations:
┌──────────────┐  ┌──────────────┐
│ Postcodes.io │  │   OpenAI     │
│  (Address)   │  │  (AI Chat)   │
└──────────────┘  └──────────────┘
```

### 1.2 Key Design Patterns

| Pattern | Implementation |
|---------|----------------|
| **Primary Keys** | RAW(16) with SYS_GUID() default |
| **Audit Columns** | CREATED_BY, UPDATED_BY, CREATED_ON, UPDATED_ON on all tables |
| **Soft Deletes** | STATUS column for deactivation vs hard delete |
| **JSON Storage** | CLOB columns for flexible definitions (templates, reports) |
| **Version Control** | Separate version tables (UR_ALGO_VERSIONS) |
| **Global Filtering** | G_HOTEL_ID application item for hotel-scoped data |

### 1.3 File Structure

```
f106/
├── install.sql                          # Main installation script
├── workspace/
│   ├── remote_servers/                  # External API configurations
│   └── credentials/                     # API credentials
└── application/
    ├── create_application.sql           # App metadata
    ├── pages/                           # All page definitions
    │   ├── page_00000.sql              # Global Page
    │   ├── page_00001.sql              # Home
    │   └── ...                         # All other pages
    └── shared_components/
        ├── security/                    # Auth & Authorization
        │   ├── authentications/
        │   ├── authorizations/
        │   └── app_access_control/
        ├── logic/
        │   ├── application_items/
        │   ├── application_processes/   # AJAX callbacks
        │   ├── application_settings.sql
        │   └── build_options.sql
        ├── navigation/
        │   ├── lists/
        │   ├── breadcrumbs/
        │   └── tabs/
        ├── user_interface/
        │   ├── lovs/                    # Lists of Values
        │   ├── templates/
        │   └── themes/
        ├── files/                       # JS, CSS, images
        └── web_sources/                 # REST data sources
```

---

## 2. Database Schema

### 2.1 Entity Relationship Diagram

```
                            ┌──────────────────┐
                            │  UR_HOTEL_GROUPS │
                            │  (Hotel Clusters)│
                            └────────┬─────────┘
                                     │ 1
                                     │
                                     ▼ N
┌──────────────┐           ┌─────────────────┐           ┌──────────────┐
│ UR_ADDRESSES │◄──────────│    UR_HOTELS    │──────────►│ UR_CONTACTS  │
│              │ N       1 │  (Central Hub)  │ 1       N │              │
└──────────────┘           └────────┬────────┘           └──────────────┘
                                    │
        ┌───────────────┬───────────┼───────────┬───────────────┐
        │               │           │           │               │
        ▼               ▼           ▼           ▼               ▼
┌───────────────┐ ┌───────────┐ ┌────────┐ ┌─────────────┐ ┌──────────────┐
│UR_HOTEL_ROOM_│ │ UR_EVENTS │ │UR_ALGOS│ │UR_TEMPLATES │ │UR_HOTEL_     │
│    TYPES     │ │           │ │        │ │             │ │RESERVATIONS  │
└───────────────┘ └───────────┘ └────┬───┘ └─────────────┘ └──────────────┘
                                     │
                        ┌────────────┼────────────┐
                        │            │            │
                        ▼            ▼            ▼
               ┌────────────┐ ┌────────────┐ ┌──────────────┐
               │UR_ALGO_    │ │UR_ALGO_    │ │UR_HOTEL_     │
               │ VERSIONS   │ │ATTRIBUTES  │ │PRICE_OVERRIDE│
               └────────────┘ └────────────┘ └──────────────┘
```

### 2.2 Core Tables

#### 2.2.1 UR_HOTELS (Central Entity)

**Purpose:** Master table for hotel properties.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, NOT NULL | Primary key (SYS_GUID) |
| GROUP_ID | RAW(16) | FK | Reference to UR_HOTEL_GROUPS |
| HOTEL_NAME | VARCHAR2(100) | NOT NULL | Property name |
| STAR_RATING | NUMBER(1,0) | | 1-5 star rating |
| ADDRESS_ID | RAW(16) | | Reference to UR_ADDRESSES |
| CONTACT_ID | RAW(16) | | Reference to UR_CONTACTS |
| OPENING_DATE | DATE | | Hotel opening date |
| CURRENCY_CODE | VARCHAR2(3) | DEFAULT 'GBP' | ISO currency code |
| ASSOCIATION_START_DATE | DATE | | System association start |
| ASSOCIATION_END_DATE | DATE | | System association end |
| ALGORITHM_ID | RAW(16) | | Primary pricing strategy |
| IMAGE | BLOB | | Hotel image |
| IMAGE_NAME | VARCHAR2(40) | | Image filename |
| IMG_TYPE | VARCHAR2(100) | | MIME type |
| CAPACITY | NUMBER | | Total room count |
| CREATED_BY | RAW(16) | NOT NULL | Audit: creator |
| UPDATED_BY | RAW(16) | NOT NULL | Audit: last modifier |
| CREATED_ON | DATE | NOT NULL | Audit: creation date |
| UPDATED_ON | DATE | NOT NULL | Audit: last update |

**Triggers:**
- `TRG_UR_HOTELS_BI_TRG`: Sets audit columns using APP_USER_CTX
- `TRG_UR_HOTELS_ALL`: Compound trigger, calls `UR_UTILS.create_hotel_calculated_attributes`

**Sample Query:**
```sql
SELECT h.id, h.hotel_name, g.group_name, a.algorithm_name
FROM ur_hotels h
LEFT JOIN ur_hotel_groups g ON h.group_id = g.id
LEFT JOIN ur_algos a ON h.algorithm_id = a.id
WHERE h.association_end_date IS NULL OR h.association_end_date > SYSDATE;
```

---

#### 2.2.2 UR_HOTEL_GROUPS

**Purpose:** Hotel clusters/chains for grouping properties.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK | Primary key |
| GROUP_NAME | VARCHAR2(100) | NOT NULL, UNIQUE | Cluster name |
| DESCRIPTION | VARCHAR2(250) | | Cluster description |
| ADDRESS_ID | RAW(16) | | HQ address |
| CONTACT_ID | RAW(16) | | Primary contact |
| ASSOCIATION_START_DATE | DATE | | Active from |
| ASSOCIATION_END_DATE | DATE | | Active until |

---

#### 2.2.3 UR_ADDRESSES

**Purpose:** Physical address storage for hotels and clusters.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, NOT NULL | Primary key |
| STREET_ADDRESS | VARCHAR2(200) | NOT NULL | Street and number |
| CITY | VARCHAR2(100) | NOT NULL | City name |
| COUNTY | VARCHAR2(100) | | County/State |
| POST_CODE | VARCHAR2(20) | NOT NULL | Postal code |
| COUNTRY | VARCHAR2(100) | NOT NULL | Country |
| HOTEL_ID | RAW(16) | NOT NULL | Parent hotel |
| PRIMARY_ADDRESS | VARCHAR2(200) | NOT NULL | Primary flag (Y/N) |

---

#### 2.2.4 UR_CONTACTS

**Purpose:** Contact persons for hotels.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, NOT NULL | Primary key |
| HOTEL_ID | RAW(16) | | Parent hotel |
| CONTACT_NAME | VARCHAR2(100) | NOT NULL | Full name |
| POSITION_TITLE | VARCHAR2(100) | | Job title |
| EMAIL | VARCHAR2(150) | CHECK format | Email address |
| PHONE_NUMBER | VARCHAR2(30) | CHECK format | Phone |
| CONTACT_TYPE | VARCHAR2(50) | | Category |
| PRIMARY | VARCHAR2(1) | CHECK IN ('Y','N') | Primary contact flag |

**Unique Index:** `UR_CONTACTS_ONE_PRIMARY_UX` - Ensures only one primary contact per hotel.

**Trigger Logic (TRG_UR_CONTACTS_BI_TRG):**
```sql
-- Pseudocode: Enforce single primary contact
IF :NEW.PRIMARY = 'Y' THEN
    UPDATE ur_contacts SET primary = 'N'
    WHERE hotel_id = :NEW.hotel_id AND id != :NEW.id;
END IF;
```

---

#### 2.2.5 UR_HOTEL_ROOM_TYPES

**Purpose:** Room category definitions per hotel.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ROOM_TYPE_ID | RAW(16) | PK, NOT NULL | Primary key |
| HOTEL_ID | RAW(16) | NOT NULL | Parent hotel |
| ROOM_TYPE_NAME | VARCHAR2(100) | NOT NULL | Category name |
| MAX_OCCUPANCY | NUMBER(2,0) | NOT NULL | Max guests (1-10) |
| BED_TYPE | VARCHAR2(50) | | Bed configuration |
| DESCRIPTION | VARCHAR2(250) | | Details |
| PRICE | NUMBER | | Base rate |
| SUPPLIMENT_TYPE | VARCHAR2(3) | | Supplement type code |
| SUPPLIEMENT_PRICE_MIN | NUMBER | | Min supplement |
| SUPPLIMENT_PRICE_MAX | NUMBER | | Max supplement |

---

#### 2.2.6 UR_EVENTS

**Purpose:** External events affecting hotel demand.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, NOT NULL | Primary key |
| HOTEL_ID | RAW(16) | | Associated hotel |
| EVENT_NAME | VARCHAR2(200) | NOT NULL | Event name |
| EVENT_TYPE | VARCHAR2(100) | NOT NULL | Category |
| EVENT_START_DATE | DATE | NOT NULL | Start date |
| EVENT_END_DATE | DATE | NOT NULL | End date |
| ESTIMATED_ATTENDANCE | NUMBER | | Expected attendees |
| IMPACT_LEVEL | VARCHAR2(50) | | Low/Medium/High |
| DESCRIPTION | VARCHAR2(500) | | Details |
| CITY | VARCHAR2(100) | | Event city |
| POSTCODE | VARCHAR2(10) | | Event postcode |
| COUNTRY | VARCHAR2(100) | | Event country |
| EVENT_FREQUENCY | VARCHAR2(50) | | Annual/One-time/etc |
| IMPACT_TYPE | VARCHAR2(50) | | Positive/Negative |

---

#### 2.2.7 UR_ALGOS (Pricing Strategies)

**Purpose:** Master record for pricing algorithms.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, NOT NULL | Primary key |
| NAME | VARCHAR2(100) | NOT NULL, UNIQUE | Strategy name |
| DESCRIPTION | VARCHAR2(1000) | | Purpose description |
| HOTEL_ID | RAW(16) | FK | Associated hotel |
| CURRENT_VERSION_ID | RAW(16) | | Active version |

---

#### 2.2.8 UR_ALGO_VERSIONS

**Purpose:** Version history for algorithm expressions.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, NOT NULL | Primary key |
| ALGO_ID | RAW(16) | NOT NULL, FK | Parent algorithm |
| VERSION | VARCHAR2(10) | NOT NULL | Version number |
| EXPRESSION | CLOB | | Pricing expression/formula |

**Unique Constraint:** ALGO_ID + VERSION

**Trigger Logic (TRG_UR_ALGO_VERSIONS_BI_TRG):**
```sql
-- Pseudocode: Auto-increment version and update current
IF INSERTING THEN
    :NEW.version := get_next_version(:NEW.algo_id);
    UPDATE ur_algos SET current_version_id = :NEW.id
    WHERE id = :NEW.algo_id;
END IF;
```

---

#### 2.2.9 UR_ALGO_ATTRIBUTES

**Purpose:** Algorithm variables and attributes.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, NOT NULL | Primary key |
| ALGO_ID | RAW(16) | FK | Parent algorithm |
| HOTEL_ID | RAW(16) | FK | Associated hotel |
| NAME | VARCHAR2(100) | NOT NULL | Attribute name |
| KEY | VARCHAR2(120) | NOT NULL, UNIQUE | Sanitized key |
| DATA_TYPE | VARCHAR2(50) | DEFAULT 'NUMBER' | Value type |
| DESCRIPTION | VARCHAR2(1000) | | Documentation |
| TYPE | VARCHAR2(1) | DEFAULT 'M' | M=Manual, C=Calculated |
| VALUE | VARCHAR2(4000) | | Attribute value |
| TEMPLATE_ID | RAW(16) | | Source template |
| ATTRIBUTE_QUALIFIER | VARCHAR2(50) | | STAY_DATE qualifier |

**Trigger Logic:** Auto-generates KEY from NAME using `UR_UTILS.Clean_TEXT`

---

#### 2.2.10 UR_HOTEL_RESERVATIONS

**Purpose:** Booking data with exception tracking.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK | Primary key |
| RES_NUMBER | VARCHAR2(20) | NOT NULL | Booking reference |
| HOTEL_ID | RAW(16) | FK | Associated hotel |
| ARRIVAL_DATE | DATE | NOT NULL | Check-in date |
| NUMBER_OF_NIGHTS | NUMBER(3,0) | NOT NULL, >0 | Stay length |
| ROOMS_BOOKED | NUMBER(5,0) | NOT NULL, >=0 | Room count |
| TOTAL_BOOKING_VALUE | NUMBER(12,2) | NOT NULL, >=0 | Total amount |
| CHARGED_FLAG | CHAR(1) | CHECK IN ('Y','N') | Payment flag |
| EXCEPTION_AMOUNT | NUMBER(12,2) | NOT NULL, >=0 | Variance amount |
| RESERVATION_TYPE | VARCHAR2(2) | | Booking type |
| EXCEPTION_DATE | DATE | | Exception occurrence |
| EXCEPTION_REASON | VARCHAR2(250) | | Exception details |
| RESERVATION_EXCEPTION_TYPE | VARCHAR2(50) | | Exception category |
| ROOM_TYPE_ID | RAW(16) | FK | Room category |
| ATTRIBUTE1-5 | VARCHAR2(100) | | Flex fields (text) |
| ATTRIBUTE6-8 | NUMBER | | Flex fields (number) |
| ATTRIBUTE9-10 | DATE | | Flex fields (date) |

**Unique Constraint:** HOTEL_ID + RES_NUMBER

---

#### 2.2.11 UR_HOTEL_PRICE_OVERRIDE

**Purpose:** Manual price adjustments.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, NOT NULL | Primary key |
| STAY_DATE | DATE | NOT NULL | Affected date |
| HOTEL_ID | RAW(16) | NOT NULL | Associated hotel |
| TYPE | VARCHAR2(10) | DEFAULT 'Public' | Override type |
| PRICE | NUMBER(10,2) | NOT NULL, >0 | Override price |
| REASON | VARCHAR2(120) | | Justification |
| STATUS | VARCHAR2(10) | DEFAULT 'A' | A=Active |
| COMMENTS | VARCHAR2(2000) | | Additional notes |

---

#### 2.2.12 UR_TEMPLATES

**Purpose:** Data import template definitions.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK | Primary key |
| HOTEL_ID | RAW(16) | | Associated hotel |
| KEY | VARCHAR2(?) | UNIQUE | Template key |
| NAME | VARCHAR2(100) | NOT NULL | Template name |
| TYPE | VARCHAR2(50) | | Template category |
| ACTIVE | VARCHAR2(1) | | Y/N status |
| DB_OBJECT_NAME | VARCHAR2(150) | | Target table/view |
| DEFINITION | CLOB | | JSON column mapping |

**JSON Definition Structure:**
```json
{
  "columns": [
    {
      "name": "STAY_DATE",
      "data_type": "DATE",
      "source_column": "Date",
      "qualifier": "STAY_DATE",
      "required": true
    },
    {
      "name": "REVENUE",
      "data_type": "NUMBER",
      "source_column": "Total Revenue",
      "qualifier": null,
      "required": false
    }
  ]
}
```

---

#### 2.2.13 UR_INTERFACE_LOGS

**Purpose:** Data load audit trail.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, NOT NULL | Primary key |
| HOTEL_ID | RAW(16) | FK | Associated hotel |
| TEMPLATE_ID | RAW(16) | NOT NULL | Template used |
| INTERFACE_TYPE | VARCHAR2(20) | NOT NULL | IMPORT/EXPORT |
| LOAD_START_TIME | TIMESTAMP(6) | NOT NULL | Processing start |
| LOAD_END_TIME | TIMESTAMP(6) | | Processing end |
| LOAD_MAPPING | CLOB | | Column mappings used |
| LOAD_STATUS | VARCHAR2(20) | NOT NULL | SUCCESS/FAILED/IN_PROGRESS |
| RECORDS_PROCESSED | NUMBER | CHECK >=0 | Total rows |
| RECORDS_SUCCESSFUL | NUMBER | CHECK >=0 | Successful rows |
| RECORDS_FAILED | NUMBER | CHECK >=0 | Failed rows |
| ERROR_DETAILS | VARCHAR2(1000) | | Error summary |
| ERROR_JSON | CLOB | | Detailed error JSON |
| FILE_ID | NUMBER | UNIQUE | Source file reference |

---

#### 2.2.14 UR_REPORTS

**Purpose:** Custom report definitions.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| ID | RAW(16) | PK, DEFAULT SYS_GUID() | Primary key |
| HOTEL_ID | RAW(16) | | Associated hotel |
| KEY | VARCHAR2(110) | UNIQUE | Report key |
| NAME | VARCHAR2(100) | NOT NULL | Report name |
| TYPE | VARCHAR2(50) | | Report category |
| ACTIVE | VARCHAR2(1) | CHECK IN ('Y','N') | Status |
| DEFINITION | CLOB | NOT NULL | Report definition JSON |
| DB_OBJECT_NAME | VARCHAR2(150) | | Generated view name |
| DB_OBJECT_CREATED_ON | DATE | NOT NULL | View creation date |
| ROWS_COUNT | NUMBER | | Cached row count |
| TABLE_SPACE_SIZE | NUMBER | | Storage size |

---

#### 2.2.15 UR_USERS

**Purpose:** Application user management.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| USER_ID | RAW(16) | PK, DEFAULT SYS_GUID() | Primary key |
| FIRST_NAME | VARCHAR2(100) | NOT NULL | First name |
| LAST_NAME | VARCHAR2(100) | NOT NULL | Last name |
| EMAIL | VARCHAR2(150) | NOT NULL, UNIQUE | Email address |
| CONTACT_NUMBER | NUMBER | | Phone number |
| USER_TYPE | VARCHAR2(50) | NOT NULL | Employee/Contractor/Hotel Team |
| STATUS | VARCHAR2(20) | NOT NULL | Active/Inactive |
| START_DATE | DATE | | Access start |
| END_DATE | DATE | | Access end |
| LOGIN_METHOD | VARCHAR2(50) | NOT NULL | Auth method |
| PASSWORD_HASH | VARCHAR2(256) | | Hashed password |
| USER_NAME | VARCHAR2(255) | | Login username |

---

### 2.3 Temporary/Support Tables

| Table | Purpose |
|-------|---------|
| TEMP_UR_REPORTS | Temporary report workspace |
| TEMP_UR_REPORT_DASHBOARDS | Dashboard configuration cache |
| TEMP_BLOB | File upload temporary storage |
| DEBUG_LOG | Debug message logging |

---

### 2.4 Common Queries

#### Get Active Hotels with Strategies
```sql
SELECT
    h.id,
    h.hotel_name,
    g.group_name AS cluster,
    a.name AS primary_strategy,
    (SELECT COUNT(*) FROM ur_hotel_room_types WHERE hotel_id = h.id) AS room_types,
    (SELECT COUNT(*) FROM ur_events WHERE hotel_id = h.id) AS events
FROM ur_hotels h
LEFT JOIN ur_hotel_groups g ON h.group_id = g.id
LEFT JOIN ur_algos a ON h.algorithm_id = a.id
WHERE (h.association_end_date IS NULL OR h.association_end_date > SYSDATE)
ORDER BY h.hotel_name;
```

#### Get Algorithm with Current Version
```sql
SELECT
    a.id,
    a.name,
    a.description,
    v.version,
    v.expression
FROM ur_algos a
JOIN ur_algo_versions v ON a.current_version_id = v.id
WHERE a.hotel_id = :hotel_id;
```

#### Get Template Columns
```sql
SELECT
    t.id,
    t.name,
    t.type,
    JSON_QUERY(t.definition, '$.columns') AS columns_json
FROM ur_templates t
WHERE t.hotel_id = :hotel_id
  AND t.active = 'Y';
```

---

## 3. PL/SQL Components

### 3.1 Packages

#### 3.1.1 UR_UTILS (Main Utility Package)

**Location:** Referenced throughout but defined externally

**Key Functions/Procedures:**

| Name | Type | Parameters | Purpose |
|------|------|------------|---------|
| `Clean_TEXT` | Function | p_text VARCHAR2 | Sanitize text for keys |
| `create_hotel_calculated_attributes` | Procedure | p_hotel_id, p_mode, p_status OUT, p_message OUT | Initialize hotel attributes |
| `add_alert` | Procedure | Various | Add alert to JSON array |
| `validate_expression` | Function | p_expression | Validate algorithm expression |
| `get_collection_json` | Function | p_collection_name | Convert APEX collection to JSON |
| `VALIDATE_TEMPLATE_DEFINITION` | Procedure | p_definition | Validate template JSON |
| `sanitize_template_definition` | Function | p_definition | Clean template JSON |
| `define_db_object` | Procedure | p_template_id | Create database object from template |

#### 3.1.2 APP_USER_CTX (User Context)

**Purpose:** Get current user information for audit columns

**Key Functions:**

| Name | Returns | Purpose |
|------|---------|---------|
| `get_current_user_id` | RAW(16) | Returns current user's ID |

#### 3.1.3 PKG_LOG_DATA_TRG (Logging)

**Purpose:** Trigger-based logging management

**Components:**
- `g_log_data_tab`: Global log table variable
- `INIT`: Initialize logging
- `PROCESS`: Flush logs to table

#### 3.1.4 XXPEL_A001_FEEDBACK

**Purpose:** Feedback submission with JIRA integration

**Procedures:**

| Name | Parameters | Purpose |
|------|------------|---------|
| `SUBMIT_FEEDBACK` | p_feedback, p_rating, p_new_type, p_summary, p_description, p_page_id, p_app_id, p_app_user | Submit user feedback |

---

### 3.2 UR_UTILS Package (Core Utility Package)

**Location:** `/home/coder/ur-js/UR_UTILS.sql` (Body), `/home/coder/ur-js/UR_UTILS_SPEC.sql` (Spec)

**Purpose:** Central utility package providing core functionality for data processing, template management, attribute handling, and expression validation.

#### 3.2.1 Column/Name Sanitization Functions

| Function | Parameters | Returns | Purpose |
|----------|------------|---------|---------|
| `sanitize_reserved_words` | p_column_name, p_suffix | JSON VARCHAR2 | Check if column name is Oracle reserved word |
| `sanitize_column_name` | p_name | VARCHAR2 | Clean column names for Oracle compatibility |
| `Clean_TEXT` | p_text | VARCHAR2 | Sanitize text for use as keys |

**sanitize_column_name Logic:**
```sql
-- Step 1: Replace non-alphanumeric with underscore
v_name := REGEXP_REPLACE(p_name, '[^A-Za-z0-9]', '_');
-- Step 2: Collapse multiple underscores
v_name := REGEXP_REPLACE(v_name, '_+', '_');
-- Step 3: Remove leading/trailing underscores
v_name := REGEXP_REPLACE(v_name, '^_+|_+$', '');
-- Step 4: Convert to uppercase
RETURN UPPER(v_name);
```

**sanitize_reserved_words Output:**
```json
{
  "is_reserved": "true|false",
  "is_sanitized": "true|false",
  "sanitized_name": "COLUMN_NAME_COL"
}
```

#### 3.2.2 Template Management Procedures

| Procedure | Parameters | Purpose |
|-----------|------------|---------|
| `sanitize_template_definition` | p_definition_json IN, p_suffix IN, p_sanitized_json OUT, p_status OUT, p_message OUT | Sanitize all column names in template JSON |
| `VALIDATE_TEMPLATE_DEFINITION` | p_json_clob IN, p_alert_clob IN OUT, p_status OUT | Validate template definition rules |
| `define_db_object` | p_template_key, p_status OUT, p_message OUT, p_mode | Create database object from template |
| `DELETE_TEMPLATES` | Multiple filter params, p_json_output OUT | Delete templates and associated DB objects |

**Validation Rules in VALIDATE_TEMPLATE_DEFINITION:**
- Qualifiers containing 'DATE' must have data_type = 'DATE'
- All other qualifiers must have data_type = 'NUMBER'

#### 3.2.3 Attribute Value Retrieval

**Pipelined Function:**
```sql
FUNCTION GET_ATTRIBUTE_VALUE(
    p_attribute_id   IN RAW DEFAULT NULL,
    p_attribute_key  IN VARCHAR2 DEFAULT NULL,
    p_hotel_id       IN RAW DEFAULT NULL,
    p_stay_date      IN DATE DEFAULT NULL,
    p_round_digits   IN NUMBER DEFAULT 2
) RETURN UR_attribute_value_table PIPELINED;
```

**Purpose:** Retrieve attribute values for algorithm evaluation.

**Attribute Types Handled:**
| Type | Code | Description |
|------|------|-------------|
| Manual | M | Static value, returns same value for any date |
| Sourced | S | Dynamic value from template table with formula |
| Calculated | C | Computed from other attributes using formula |

**Sourced Attribute Formula Parsing:**
```sql
-- Formula format: #TABLE.COLUMN# + #TABLE2.COLUMN2#
-- Parses table references, builds dynamic SQL with JOINs
-- Uses STAY_DATE column for joining tables
```

**Calculated Attribute Qualifiers:**
| Qualifier | Description |
|-----------|-------------|
| PRICE_OVERRIDE_PUBLIC | Public price override values |
| PRICE_OVERRIDE_CORPORATE | Corporate price override values |
| PRICE_OVERRIDE_GROUP | Group price override values |
| EVENTS | Event data for dates |
| CALCULATED_OCCUPANCY | Computed occupancy percentage |

**JSON Response Structure:**
```json
{
  "attribute_id": "ABC123...",
  "attribute_name": "REVENUE",
  "attribute_key": "HOTEL_REVENUE",
  "attribute_datatype": "NUMBER",
  "attribute_qualifier": "STAY_DATE",
  "hotel_id": "DEF456...",
  "STATUS": "S|E",
  "RECORD_COUNT": 30,
  "RESPONSE_PAYLOAD": [
    {"stay_date": "01-DEC-2024", "attribute_value": 1500.00}
  ]
}
```

#### 3.2.4 Calculated Attribute Management

| Procedure | Purpose |
|-----------|---------|
| `manage_calculated_attributes` | Create/update/delete calculated attributes |
| `create_hotel_calculated_attributes` | Initialize predefined calculated attributes for new hotel |

**Predefined Calculated Attributes (created per hotel):**
- CALCULATED_OCCUPANCY: `ROUND((#ROOM_NIGHTS# / (#UR_HOTELS.CAPACITY# - #OUT_OF_ORDER_ROOMS#)) * 100)`
- OWN PROPERTY BOTTOM RANK
- OWN PROPERTY TOP RANK
- VALID COMP COUNT

#### 3.2.5 Data Loading Procedures

| Procedure | Parameters | Purpose |
|-----------|------------|---------|
| `LOAD_DATA_MAPPING_COLLECTION` | p_file_id, p_template_id, p_collection_name, p_use_original_name, p_match_datatype | Map file columns to template columns |
| `Load_Data` | p_file_id, p_template_key, p_hotel_id, p_collection_name | Load data from file using template |
| `Load_Data_v2` | Same as above | Enhanced version with better error handling |
| `fetch_templates` | p_file_id, p_hotel_id, p_min_score, etc. | Find matching templates for uploaded file |

**Column Matching Modes (p_use_original_name):**
| Mode | Description |
|------|-------------|
| 'Y' | Use original_name field only |
| 'N' | Use name field only |
| 'AUTO' | Smart mode - use original_name if present, fallback to name |

#### 3.2.6 Date Parsing System

**Main Procedure:**
```sql
PROCEDURE date_parser(
    p_mode IN VARCHAR2,              -- 'DETECT', 'PARSE', 'TEST'
    p_file_id IN NUMBER DEFAULT NULL,
    p_column_position IN NUMBER DEFAULT NULL,
    p_sample_values IN CLOB DEFAULT NULL,
    p_date_string IN VARCHAR2 DEFAULT NULL,
    p_format_mask IN VARCHAR2 DEFAULT NULL,
    p_min_confidence IN NUMBER DEFAULT 90,
    p_debug_flag IN VARCHAR2 DEFAULT 'N',
    p_alert_clob IN OUT NOCOPY CLOB,
    -- OUT parameters
    p_format_mask_out OUT VARCHAR2,
    p_confidence OUT NUMBER,
    p_converted_date OUT DATE,
    p_has_year OUT VARCHAR2,
    p_is_ambiguous OUT VARCHAR2,
    p_special_values OUT VARCHAR2,
    p_all_formats OUT CLOB,
    p_status OUT VARCHAR2,
    p_message OUT VARCHAR2
);
```

**Modes:**
| Mode | Description |
|------|-------------|
| DETECT | Detect date format from sample values |
| PARSE | Parse single date string using format |
| TEST | Run internal test suite |

**Supported Formats:** ~80 date formats including:
- DD-MON-YYYY, YYYY-MM-DD, DD/MM/YYYY, MM/DD/YYYY
- With and without time components
- Various separators (-, /, .)

**Helper Functions:**
```sql
FUNCTION detect_date_format_simple(p_sample_values CLOB) RETURN VARCHAR2;
FUNCTION parse_date_safe(p_value VARCHAR2, p_format_mask VARCHAR2, p_start_date DATE) RETURN DATE;
```

#### 3.2.7 Expression Validation

```sql
PROCEDURE validate_expression(
    p_expression IN VARCHAR2,
    p_mode IN CHAR,
    p_hotel_id IN VARCHAR2,
    p_status OUT VARCHAR2,  -- 'S' success, 'E' error
    p_message OUT VARCHAR2
);
```

**Purpose:** Validate algorithm expressions before saving.

#### 3.2.8 Error Collection Management

```sql
PROCEDURE POPULATE_ERROR_COLLECTION_FROM_LOG(
    p_interface_log_id IN UR_INTERFACE_LOGS.ID%TYPE,
    p_collection_name IN VARCHAR2,
    p_status OUT VARCHAR2,
    p_message OUT VARCHAR2
);
```

**Purpose:** Load errors from interface log into APEX collection for display.

**Collection Structure:**
| Column | Content |
|--------|---------|
| C001 | Row number |
| C002 | Error message |

#### 3.2.9 Alert/Notification Helper

```sql
PROCEDURE add_alert(
    p_existing_json IN CLOB,
    p_message IN VARCHAR2,
    p_icon IN VARCHAR2 DEFAULT NULL,
    p_title IN VARCHAR2 DEFAULT NULL,
    p_timeOut IN NUMBER DEFAULT NULL,
    p_updated_json OUT CLOB
);
```

**Purpose:** Add alert messages to JSON array for UI display.

---

### 3.3 ALGO_EVALUATOR_PKG Package (Algorithm Evaluation Engine)

**Location:** `/home/coder/ur-js/Algo_Evaluation_PKG_Body`

**Purpose:** Core pricing algorithm evaluation engine that processes algorithm expressions and returns calculated prices for stay dates.

#### 3.3.1 Main Evaluation Function

```sql
FUNCTION EVALUATE(
    p_algo_id IN ur_algos.id%TYPE,
    p_version_id IN ur_algo_versions.id%TYPE DEFAULT NULL,
    p_stay_date IN DATE DEFAULT NULL
) RETURN t_result_tab_obj PIPELINED;
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| p_algo_id | RAW(16) | Algorithm ID from UR_ALGOS |
| p_version_id | RAW(16) | Optional specific version (uses current if NULL) |
| p_stay_date | DATE | Optional filter for single date |

**Return Type:**
```sql
TYPE t_result_rec_obj AS OBJECT (
    algo_name VARCHAR2(255),
    stay_date DATE,
    day_of_week VARCHAR2(3),
    evaluated_price VARCHAR2(4000),
    applied_rule CLOB
);
TYPE t_result_tab_obj AS TABLE OF t_result_rec_obj;
```

**Usage Example:**
```sql
SELECT * FROM TABLE(ALGO_EVALUATOR_PKG.EVALUATE(
    p_algo_id => 'ABC123...',
    p_stay_date => DATE '2024-12-25'
));
```

#### 3.3.2 Helper Functions

| Function | Purpose |
|----------|---------|
| `GENERIC_MATH_EVAL` | Evaluate math functions (SUM, AVERAGE, COUNT, MIN, MAX) |
| `get_attribute_id_from_template` | Get OWN PROPERTY RANK attribute ID |
| `get_value_for_date` | Lookup value for specific date in result table |
| `FLEXIBLE_TO_DATE` | Parse date string with multiple format attempts |
| `build_dynamic_query` | Build SQL query from algorithm JSON |

#### 3.3.3 Rank Shifting System

**Purpose:** Handle scenarios where competitors are sold out (have $0 or NULL prices).

**Functions:**
| Function | Purpose |
|----------|---------|
| `get_rank_number_from_attr_id` | Extract rank number from bottom rank attribute |
| `get_top_rank_number_from_attr_id` | Extract rank number from top rank attribute |
| `get_attr_id_for_rank` | Get attribute ID for specific bottom rank |
| `get_attr_id_for_top_rank` | Get attribute ID for specific top rank |
| `get_valid_comp_count_attr_id` | Get VALID_COMP_COUNT attribute ID |
| `apply_rank_shifting` | Shift ranks when competitors unavailable |

**Rank Shifting Logic:**
```
If expression references R8, R9, R10 but only 6 competitors exist:
  → Shifts to R4, R5, R6 (keeping relative positions)

If not enough competitors for distinct ranks needed:
  → Returns NULL (expression cannot be evaluated)
```

**Attribute Patterns:**
| Pattern | Description |
|---------|-------------|
| `COMP SET BOTTOM R{N} RATE` | Bottom rank (cheapest first) |
| `COMP SET TOP R{N} RATE` | Top rank (most expensive first) |
| `OWN PROPERTY BOTTOM RANK` | Hotel's position in bottom ranking |
| `OWN PROPERTY TOP RANK` | Hotel's position in top ranking |
| `VALID COMP COUNT` | Number of competitors with valid prices |

#### 3.3.4 Algorithm JSON Structure

```json
{
  "regions": [
    {
      "name": "Region Name",
      "conditions": [
        {
          "name": "Condition Name",
          "expression": "#ATTR_ID1# + #ATTR_ID2# * 1.1",
          "occupancyThreshold": {
            "attribute": "#OCC_ATTR_ID#",
            "operator": ">=",
            "value": 80
          },
          "propertyRanking": {
            "type": "#TEMPLATE_ID#",
            "operator": "<=",
            "value": 3
          }
        }
      ],
      "filters": {
        "stayWindow": {"from": "2024-01-01", "to": "2024-12-31"},
        "leadTime": {"from": "2024-01-01", "to": "2024-12-31"},
        "daysOfWeek": [1, 2, 3, 4, 5],
        "minimumRate": 100
      }
    }
  ]
}
```

#### 3.3.5 Expression Types

| Type | Format | Example |
|------|--------|---------|
| Numeric | Attribute references + operators | `#ATTR1# + #ATTR2# * 1.1` |
| Free Text | Wrapped in tildes | `~Override Text~` |
| Function | Function with arguments | `AVERAGE(#ATTR1#, #ATTR2#, #ATTR3#)` |

**Supported Functions:**
- SUM(values)
- AVERAGE(values)
- COUNT(values)
- MIN(values)
- MAX(values)

#### 3.3.6 Evaluation Flow

```
1. Load algorithm and version
   ↓
2. Parse JSON to extract:
   - Attribute references
   - Conditions (occupancy, property ranking)
   - Expressions
   ↓
3. Pre-load attribute data via UR_UTILS.GET_ATTRIBUTE_VALUE
   (Staged in l_staged_data map)
   ↓
4. For each stay date in data:
   a. Get VALID_COMP_COUNT (for rank shifting)
   b. Apply rank shifting if needed
   c. Evaluate conditions (occupancy, ranking)
   d. If conditions pass, evaluate expression
   e. PIPE ROW with result
   ↓
5. Return pipelined results
```

#### 3.3.7 Debug Logging

```sql
PROCEDURE log_debug(p_message IN VARCHAR2);
-- Uses AUTONOMOUS_TRANSACTION
-- Writes to DEBUG_LOG table
-- Truncates to 4000 chars
```

**View Debug Logs:**
```sql
SELECT * FROM debug_log
ORDER BY log_time DESC
FETCH FIRST 50 ROWS ONLY;
```

---

### 3.4 Standalone Functions

#### FN_CLEAN_NUMBER
```sql
FUNCTION FN_CLEAN_NUMBER(p_string VARCHAR2) RETURN NUMBER
-- Purpose: Remove non-numeric characters
-- Example: FN_CLEAN_NUMBER('$1,234.56') => 1234.56
```

#### FN_SAFE_TO_DATE
```sql
FUNCTION FN_SAFE_TO_DATE(p_string VARCHAR2) RETURN DATE
-- Purpose: Safe date conversion with multiple format attempts
-- Tries: DD-MON-YYYY, YYYY-MM-DD, DD/MM/YYYY, MM/DD/YYYY
-- Returns: NULL if all formats fail
```

#### GET_MAP_CALCULATION_FUN
```sql
FUNCTION GET_MAP_CALCULATION_FUN(
    p_formula VARCHAR2,
    p_collection_name VARCHAR2
) RETURN VARCHAR2
-- Purpose: Map formula variables to collection values
```

#### GET_PROFILE_JSON
```sql
FUNCTION GET_PROFILE_JSON(
    p_blob BLOB,
    p_filename VARCHAR2
) RETURN CLOB
-- Purpose: Discover data profile from uploaded BLOB
-- Returns: JSON with column names and types
```

#### GUESS_DELIMITER
```sql
FUNCTION GUESS_DELIMITER(p_blob BLOB) RETURN VARCHAR2
-- Purpose: Auto-detect CSV delimiter
-- Checks: comma, semicolon, tab, pipe
```

#### SANITIZE_COLUMN_NAME
```sql
FUNCTION SANITIZE_COLUMN_NAME(p_name VARCHAR2) RETURN VARCHAR2
-- Purpose: Clean column names for Oracle
-- Removes: special chars, spaces, leading numbers
```

---

### 3.3 Standalone Procedures

#### XXPEL_PARSE_ERROR_JSON
```sql
PROCEDURE XXPEL_PARSE_ERROR_JSON(
    p_json_clob    IN  CLOB,
    p_collection_name IN VARCHAR2 DEFAULT 'ERROR_COLLECTION',
    p_ai_message   OUT CLOB,
    p_status       OUT VARCHAR2
)
-- Purpose: Parse error JSON and populate APEX collection
-- Creates collection with: SEQ_ID, ROW_NUM, COLUMN_NAME, ERROR_MSG, ORIGINAL_VALUE
```

#### POPULATE_ERROR_COLLECTION_FROM_LOG
```sql
PROCEDURE POPULATE_ERROR_COLLECTION_FROM_LOG(
    p_interface_log_id IN  UR_INTERFACE_LOGS.ID%TYPE,
    p_collection_name  IN  VARCHAR2,
    p_status           OUT VARCHAR2,
    p_message          OUT VARCHAR2
)
-- Purpose: Load interface log errors into APEX collection
```

#### DELETE_TEMPLATES_AND_DB_OBJECTS_JSON
```sql
PROCEDURE DELETE_TEMPLATES_AND_DB_OBJECTS_JSON(
    p_id           IN VARCHAR2 DEFAULT NULL,
    p_hotel_id     IN VARCHAR2 DEFAULT NULL,
    p_key          IN VARCHAR2 DEFAULT NULL,
    p_name         IN VARCHAR2 DEFAULT NULL,
    p_type         IN VARCHAR2 DEFAULT NULL,
    p_active       IN CHAR     DEFAULT NULL,
    p_db_obj_empty IN CHAR     DEFAULT NULL,
    p_delete_all   IN CHAR     DEFAULT 'N',
    p_debug        IN CHAR     DEFAULT 'N',
    p_json_output  OUT CLOB
)
-- Purpose: Delete templates and associated DB objects
-- Returns: JSON result with deleted items
```

#### ADD_ALERT_1
```sql
PROCEDURE ADD_ALERT_1(
    p_existing_json IN  CLOB,
    p_message       IN  VARCHAR2,
    p_icon          IN  VARCHAR2 DEFAULT NULL,
    p_title         IN  VARCHAR2 DEFAULT NULL,
    p_timeout       IN  NUMBER   DEFAULT NULL,
    p_html_safe     IN  VARCHAR2 DEFAULT 'N',
    p_updated_json  OUT CLOB
)
-- Purpose: Add alert to JSON array for UI display
```

---

### 3.4 Object Types

#### Value Containers
```sql
TYPE UR_ATTRIBUTE_VALUE_ROW AS OBJECT (
    stay_date       DATE,
    attribute_value VARCHAR2(4000)
);

TYPE UR_ATTRIBUTE_VALUE_TABLE AS TABLE OF UR_ATTRIBUTE_VALUE_ROW;
```

#### Algorithm Result Types
```sql
TYPE T_RESULT_REC_OBJ AS OBJECT (
    algo_name       VARCHAR2(255),
    stay_date       DATE,
    day_of_week     VARCHAR2(10),
    evaluated_price VARCHAR2(4000),
    applied_rule    CLOB
);

TYPE T_RESULT_TAB_OBJ AS TABLE OF T_RESULT_REC_OBJ;
```

#### Logging Types
```sql
TYPE LOG_REC_OBJ AS OBJECT (
    log_id      NUMBER,
    log_message VARCHAR2(255)
);

TYPE LOG_TAB_TYPE AS TABLE OF LOG_REC_OBJ;
```

---

### 3.5 Triggers

All tables have BEFORE INSERT/UPDATE triggers for audit columns.

**Common Trigger Pattern:**
```sql
CREATE OR REPLACE TRIGGER TRG_UR_tablename_BI_TRG
BEFORE INSERT OR UPDATE ON UR_tablename
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.id := NVL(:NEW.id, SYS_GUID());
        :NEW.created_by := NVL(:NEW.created_by, app_user_ctx.get_current_user_id());
        :NEW.created_on := NVL(:NEW.created_on, SYSDATE);
    END IF;
    :NEW.updated_by := app_user_ctx.get_current_user_id();
    :NEW.updated_on := SYSDATE;
END;
```

**Special Triggers:**

| Trigger | Table | Purpose |
|---------|-------|---------|
| TRG_UR_HOTELS_ALL | UR_HOTELS | Calls UR_UTILS.create_hotel_calculated_attributes |
| TRG_UR_CONTACTS_BI_TRG | UR_CONTACTS | Enforces single primary contact per hotel |
| TRG_UR_ALGO_VERSIONS_BI_TRG | UR_ALGO_VERSIONS | Auto-increments version, updates CURRENT_VERSION_ID |
| TRG_UR_REPORT_DASHBOARDS_BI | UR_REPORT_DASHBOARDS | Validates JSON, auto-generates KEY |

---

## 4. Application Pages

### 4.1 Page Inventory

| Page | Alias | Title | Type | Purpose |
|------|-------|-------|------|---------|
| 0 | - | Global Page | Global | App-wide components |
| 1 | HOME | Home | Standard | Landing page |
| 7 | ADDRESSFROM | Hotel Address | Modal | Address form |
| 9 | HOTEL-EVENTS1 | Hotel Events | Standard | Events grid |
| 10 | HOTEL-GROUP | Hotel Cluster | Modal | Cluster form |
| 11 | CREATE-NEW-HOTEL | New Hotel | Standard | Hotel list |
| 12 | CONTACT | Hotel Contact | Modal | Contact form |
| 13 | TYPES | Hotel Room Types | Modal | Room type form |
| 14 | HOTELS | Hotels | Standard | Hotels page |
| 15 | REPORT-DASHBOARD | Report Dashboard | Standard | Reporting |
| 17 | HOTEL-ADDRESS | Address | Standard | Address list |
| 19 | RESERVATIONS | Reservation Update | Standard | Reservations |
| 20 | ADD-EVENTS | Add Events | Modal | Event form |
| 22 | ADD-RESERVATION | Add Reservation | Modal | Reservation form |
| 23 | NEW-HOTEL | Hotel | Modal | Hotel form |
| 27 | EVENTS-DATA-LOAD | Events Data Load | Modal | Bulk event upload |
| 29 | TEMPLATE-UPDATE-INTERFACE | Template Update | Standard | Template management |
| 167 | REPORT-SUMMARY | Report Summary | Standard | Report summary |
| 1002 | TEMPLATES-V2 | Templates v2 | Standard | Template creation |
| 1006 | - | Report Template | Standard | Report design |
| 1011 | LOAD-DATA-V2 | Load Data v2 | Standard | Data loading |
| 1023 | ROOM-TYPES | Room Types | Standard | Room type list |
| 1026 | - | Contact Directory | Standard | Contact list |
| 1027 | - | Manage Cluster | Standard | Cluster list |
| 1050 | ALGORITHMS | Strategies | Standard | Algorithm builder |
| 1071 | HOTEL-PRICE-OVERRIDE1 | Hotel Price Override | Modal | Override form |
| 1075 | HOTEL-PRICE-OVERRIDE-LIST | Hotel Price Override | Standard | Override list |
| 1601 | - | Interface Dashboard | Standard | Load history |
| 1611 | USER-MANAGMENT | User Management | Standard | User list |
| 1612 | CREATE-USER-FORM | Create User Form | Modal | User form |
| 4 | INTERFACE-DASHBOARD-DETAILS | Interface Details | Modal | Load details |
| 10000 | ADMINISTRATION | Administration | Standard | Admin dashboard |
| 10010-10060 | Various | Admin pages | Modal | Configuration |

---

### 4.2 Page 0: Global Page

**Purpose:** Application-wide components visible on all pages.

**Page Items:**

| Item | Type | Purpose |
|------|------|---------|
| P0_HOTEL_ID | Select List | Global hotel filter |
| P0_ALERT_MESSAGE | Hidden | Alert message storage |

**Features:**
- Hotel selector in header
- "Show all data" option (value: FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
- Sets G_HOTEL_ID application item
- Global CSS and JavaScript includes

---

### 4.3 Page 11: Hotels List (CREATE-NEW-HOTEL)

**Purpose:** Display hotels with link to create/edit.

**Regions:**

| Region | Type | Source |
|--------|------|--------|
| Create New Hotel | Interactive Grid | UR_HOTELS join |

**SQL Source:**
```sql
SELECT
    h.id, h.group_id, h.hotel_name, h.star_rating,
    h.address_id, h.contact_id, h.opening_date,
    h.currency_code, h.association_start_date,
    h.association_end_date, h.capacity,
    g.group_name, a.name AS primary_strategy,
    addr.street_address || ', ' || addr.post_code AS address_display,
    c.contact_name AS contact_display
FROM ur_hotels h
LEFT JOIN ur_hotel_groups g ON h.group_id = g.id
LEFT JOIN ur_algos a ON h.algorithm_id = a.id
LEFT JOIN ur_addresses addr ON h.address_id = addr.id
LEFT JOIN ur_contacts c ON h.contact_id = c.id
WHERE (:P11_GROUP_LIST = 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
       OR h.group_id = HEXTORAW(:P11_GROUP_LIST))
```

**Page Items:**

| Item | Type | LOV | Purpose |
|------|------|-----|---------|
| P11_HOTEL_LIST | Select List | Active hotels | Hotel filter |
| P11_GROUP_LIST | Select List | Hotel clusters | Cluster filter |

**Dynamic Actions:**

| Name | Event | Action |
|------|-------|--------|
| Change Hotel | P11_HOTEL_LIST change | Submit page, refresh grid |
| Change Group | P11_GROUP_LIST change | Submit page, refresh grid |
| Refresh | Dialog close | Refresh grid |

**Buttons:**
- CREATE_New_Hotel → Redirect to Page 23

---

### 4.4 Page 23: Hotel Form (NEW-HOTEL)

**Purpose:** Create/Edit hotel records.

**Type:** Modal Dialog

**Table:** UR_HOTELS

**Regions:**

| Region | Type | Purpose |
|--------|------|---------|
| New Hotel | Form | CRUD operations |
| Buttons | Static | Action buttons |

**Page Items:**

| Item | Type | Validation | Purpose |
|------|------|------------|---------|
| P23_ID | Hidden | Protected | Primary key |
| P23_GROUP_ID | Select List | Required | Hotel cluster |
| P23_HOTEL_NAME | Text Field | Required | Property name |
| P23_STAR_RATING | Select List | 1-5 | Star rating |
| P23_ADDRESS_ID | Select List | Cascade by hotel | Address |
| P23_CONTACT_ID | Select List | Cascade by hotel | Contact |
| P23_OPENING_DATE | Date Picker | | Opening date |
| P23_CURRENCY_CODE | Select List | Default: GBP | Currency |
| P23_ALGORITHM_ID | Select List | | Primary strategy |
| P23_CAPACITY | Number Field | Min: 0 | Room count |

**Buttons:**

| Button | Action | Condition |
|--------|--------|-----------|
| CANCEL | Close dialog | Always |
| DELETE | Submit (delete) | P23_ID IS NOT NULL |
| SAVE | Submit (update) | P23_ID IS NOT NULL |
| CREATE | Submit (insert) | P23_ID IS NULL |

**Processes:**
- `Process form New Hotel MD`: NATIVE_FORM_DML
- `Close Dialog`: NATIVE_CLOSE_WINDOW
- `Initialize form`: NATIVE_FORM_INIT

---

### 4.5 Page 1050: Algorithm Builder (ALGORITHMS)

**Purpose:** Create and manage pricing strategies.

**Complexity:** High (51K+ tokens)

**Key Components:**

**Regions:**
- Algorithm selection
- Version selection
- Expression builder
- Attribute management
- Condition configuration
- Filter management

**JavaScript Integration:** `AlgoPGJS#MIN#.js`

**Key Page Items:**

| Item | Purpose |
|------|---------|
| P1050_ALGO_LIST | Algorithm selection |
| P1050_VERSION_LIST | Version selection |
| P1050_EXPRESSION | Expression editor |
| P1050_DEBUG_OUT | Debug output |

**Expression Builder Features:**
- Operator buttons (+, -, *, /, etc.)
- Function insertion (AVG, SUM, COUNT, MAX, MIN)
- Attribute picker modal
- Real-time validation
- Caret position tracking

**Buttons:**
- Strategy_Data: Open data modal
- Duplicate_Strategy: Clone algorithm
- Clear: Reset expression
- Delete: Remove algorithm
- Validate: Check expression syntax
- Save: Persist changes

---

### 4.6 Page 15: Report Dashboard (REPORT-DASHBOARD)

**Purpose:** Run and export reports.

**External Libraries:**
- ExcelJS (Excel export)
- FileSaver.js (File download)
- jsPDF (PDF export)
- jspdf-autotable (PDF tables)

**Key Features:**
- Tab-based report interface
- Hotel/Report selection
- Conditional formatting
- Excel export with formatting
- PDF export

**JavaScript Functions:**

```javascript
function exportToExcelWithFormatting() {
    // Uses ExcelJS to create formatted workbook
    // Applies conditional formatting rules
    // Preserves column widths and styles
}

function exportToPDFWithFormatting() {
    // Uses jsPDF with autotable
    // Applies table styling
    // Handles pagination
}

function getColumnMap() {
    // Maps report columns to data
}
```

---

### 4.7 Page 4: Interface Dashboard Details

**Purpose:** View data load details and errors.

**Type:** Modal Dialog

**Regions:**

| Region | Type | Purpose |
|--------|------|---------|
| Interface Details | Form | Load metadata |
| Error Details | Classic Report | Error collection |
| Template Data | Interactive Grid | Template info |

**Key Features:**
- Processing time calculation
- Status with timeout detection (>600s = Error)
- Error JSON parsing to collection
- File download capability
- Reprocess failed loads

**Processes:**
- `JSON collection`: Parse errors via `xxpel_parse_error_json`
- `Fetch Error Collection`: Load from `POPULATE_ERROR_COLLECTION_FROM_LOG`
- `Download Process`: Stream file via `wpg_docload`

---

## 5. Application Processes

All processes execute as **ON_DEMAND** (Ajax Callback) with **MUST_NOT_BE_PUBLIC_USER** security.

### 5.1 AJX_GET_HOTEL_TEMP_ALL

**Purpose:** Get all templates for a hotel with STAY_DATE attributes.

**Input:** `apex_application.g_x01` = Hotel name

**Output:** JSON array
```json
[
  {
    "id": "ABC123...",
    "hotel_id": "DEF456...",
    "db_object_name": "UR_TEMPLATE_HOTEL1",
    "temp_name": "Revenue Template",
    "hotel_name": "Grand Hotel"
  }
]
```

**PL/SQL Logic:**
```sql
-- Query active templates with STAY_DATE qualifier
SELECT JSON_OBJECT(
    'id' VALUE RAWTOHEX(t.id),
    'hotel_id' VALUE RAWTOHEX(t.hotel_id),
    'db_object_name' VALUE t.db_object_name,
    'temp_name' VALUE t.name,
    'hotel_name' VALUE h.hotel_name
)
FROM ur_templates t
JOIN ur_hotels h ON t.hotel_id = h.id
WHERE h.hotel_name = apex_application.g_x01
  AND t.active = 'Y'
  AND EXISTS (
      SELECT 1 FROM ur_algo_attributes
      WHERE template_id = t.id AND attribute_qualifier = 'STAY_DATE'
  );
```

---

### 5.2 AJX_GET_HOTEL_TEMPLATES

**Purpose:** Comprehensive template data retrieval.

**Input:** `apex_application.g_x01` = Hotel name

**Output:** Nested JSON
```json
{
  "grandhotel": {
    "name": "Grand Hotel",
    "templates": {
      "Revenue_Template": ["STAY_DATE", "REVENUE", "ADR"],
      "Global_Attributes": [{"id": 1, "name": "BASE_RATE"}],
      "Strategies": ["Dynamic_Pricing"],
      "Price_Override": ["Public", "Corporate"],
      "Hotel_Occupancy": ["OCCUPANCY"]
    }
  }
}
```

---

### 5.3 AJX_GET_REPORT_DATA

**Purpose:** Dynamic SQL execution for reports.

**Modes:**
1. `TEMPLATE_REPORT_DATA`: Fetch first 10 rows with all columns
2. Custom: Build SELECT with column aliases

**Input Parameters:**
- `g_x01`: Mode or column list JSON
- `g_x02`: Column list or alias JSON
- `g_x03`: Database object name
- `g_x04`: Additional parameters
- `g_x05`: Definition JSON

**PL/SQL Pattern:**
```sql
-- Build dynamic SQL
l_sql := 'SELECT ';
FOR col IN (parse columns from JSON) LOOP
    l_sql := l_sql || col.name || ' AS "' || col.alias || '",';
END LOOP;
l_sql := l_sql || ' FROM ' || l_table_name || ' ORDER BY PK_COL';

-- Execute with DBMS_SQL
l_cursor := DBMS_SQL.OPEN_CURSOR;
DBMS_SQL.PARSE(l_cursor, l_sql, DBMS_SQL.NATIVE);
-- ... fetch and format as JSON
```

---

### 5.4 AJX_MANAGE_ALGO

**Purpose:** Algorithm version management.

**Modes:**
- `SELECT`: Retrieve EXPRESSION from version
- `INSERT`: Create new version (not implemented)
- `UPDATE`: Update expression (not implemented)

**Input:**
- `g_x01`: Mode
- `g_x02`: Algo ID
- `g_x03`: Version ID (not version number!)

**Output:**
```json
{
  "success": true,
  "message": "Configuration loaded successfully.",
  "data": [{"l_payload": "{expression JSON}"}]
}
```

---

### 5.5 AJX_MANAGE_REPORT_VIEW

**Purpose:** Create/manage report views.

**Modes:**

| Mode | Action |
|------|--------|
| DELETE | Drop view, delete metadata |
| UPDATE_ALIAS | Update column aliases |
| UPDATE_EXPRESSION | Update expressions |
| Default | Create view, MERGE metadata |

**View Naming Convention:** `TEMP_{HOTEL_NAME}_{REPORT_NAME}_V`

**PL/SQL Pattern:**
```sql
-- Create view dynamically
l_view_name := 'TEMP_' || UPPER(l_hotel_name) || '_' || UPPER(l_report_name) || '_V';
l_sql := 'CREATE OR REPLACE VIEW ' || l_view_name || ' AS ' || l_definition;
EXECUTE IMMEDIATE l_sql;

-- Store metadata
MERGE INTO temp_ur_reports USING DUAL ON (key = l_key)
WHEN MATCHED THEN UPDATE SET definition = l_definition, ...
WHEN NOT MATCHED THEN INSERT (...) VALUES (...);
```

---

### 5.6 DOWNLOAD_FILE

**Purpose:** Download BLOB files.

**Input:** `g_x01` = Filename

**PL/SQL:**
```sql
SELECT blob_content, mime_type INTO l_blob, l_mime
FROM temp_blob WHERE name = apex_application.g_x01
ORDER BY id DESC FETCH FIRST 1 ROW ONLY;

OWA_UTIL.MIME_HEADER(l_mime, FALSE);
HTP.P('Content-Disposition: attachment; filename="' || l_filename || '"');
WPG_DOCLOAD.DOWNLOAD_FILE(l_blob);
APEX_APPLICATION.STOP_APEX_ENGINE;
```

---

### 5.7 SAVE_CARD_FIELD

**Purpose:** Inline field editing for hotels.

**Input:**
- `g_x01`: Record ID
- `g_x02`: Field name
- `g_x03`: New value

**PL/SQL:**
```sql
l_sql := 'UPDATE ur_hotels SET ' || l_field || ' = :1 WHERE id = HEXTORAW(:2)';
EXECUTE IMMEDIATE l_sql USING l_value, l_id;
COMMIT;
HTP.P('{"success": true}');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    HTP.P('{"success": false, "error": "' || SQLERRM || '"}');
```

---

## 6. JavaScript Components

### 6.1 File Inventory

| File | Size | Purpose |
|------|------|---------|
| algopgjs.js | 281KB | Algorithm page logic |
| dynamicreportjs.js | 595KB | Report builder |
| dynamictbl.js | ~10KB | Card view editing |
| reportdashboardjs.js | 311KB | Dashboard management |
| reportsummary.js | 66K+ | Report summary |
| gridreportsummary.js | 103K+ | Grid summary |
| showAlert.js | ~5KB | Alert/notification system |

---

### 6.2 algopgjs.js (Algorithm Page)

**Purpose:** Handle algorithm/strategy UI interactions.

**Key Objects:**

```javascript
// Static data
const operators = ['+', '-', '*', '/', '%', '(', ')'];
const expressionOperators = ['=', '!=', '<', '>', '<=', '>=', 'AND', 'OR'];
const functions = ['Average', 'Sum', 'Count', 'Max', 'Min'];

// Dynamic data (loaded via AJAX)
let attributes = [];
let propertyTypes = [];
let occupancyAttributes = [];
```

**Key Functions:**

```javascript
// Load algorithm expression with race condition protection
function load_data_expression() {
    const requestId = ++currentRequestId;

    apex.server.process('AJX_MANAGE_ALGO', {
        x01: 'SELECT',
        x02: algoId,
        x03: versionId
    }, {
        success: function(data) {
            // Check for stale response
            if (requestId !== currentRequestId) {
                console.log('Stale response ignored');
                return;
            }
            // Process data
            populateExpression(data);
        }
    });
}

// Create attribute selection modal
function createAttributeModal() {
    // Build modal HTML
    // Add filtering capability
    // Handle attribute selection
    // Insert at cursor position in expression
}

// Debounced AJAX (200ms)
const debouncedLoad = debounce(loadData, 200);
```

**Event Handlers:**
- Algorithm dropdown change
- Version dropdown change
- Operator button clicks
- Function insertion
- Expression validation

---

### 6.3 dynamicreportjs.js (Report Builder)

**Purpose:** Drag-and-drop report configuration.

**Key Functions:**

```javascript
// Load hotel-specific templates
function loadHotelTemplates(hotelName) {
    apex.server.process('AJX_GET_HOTEL_TEMPLATES', {
        x01: hotelName
    }, {
        success: function(data) {
            populateTemplateLOV(data);
            populateColumnList(data);
        }
    });
}

// Get all STAY_DATE qualifiers
function getAllQualifiers(hotelId) {
    apex.server.process('AJX_GET_REPORT_ALL_QUALIFIERS', {
        x01: hotelId
    }, {
        success: function(data) {
            buildQualifierList(data);
        }
    });
}

// Generate report definition JSON
function generateJson() {
    return {
        columns: getSelectedColumns(),
        filters: getActiveFilters(),
        conditionalFormatting: getFormatRules(),
        sorting: getSortOrder()
    };
}

// Save report configuration
function saveReport() {
    const definition = generateJson();
    apex.server.process('AJX_MANAGE_REPORT_VIEW', {
        x01: JSON.stringify(definition),
        x02: hotelId,
        x03: reportName
    });
}
```

---

### 6.4 dynamictbl.js (Card View)

**Purpose:** Inline editing for hotel cards.

```javascript
// Make field editable on click
function makeFieldEditable(element) {
    const currentValue = element.textContent;
    const input = document.createElement('input');
    input.value = currentValue;
    input.className = 'inline-edit';

    input.onblur = function() {
        saveChanges(element.dataset.id, element.dataset.field, input.value);
    };

    element.replaceWith(input);
    input.focus();
}

// Save via AJAX
function saveChanges(id, field, value) {
    apex.server.process('SAVE_CARD_FIELD', {
        x01: id,
        x02: field,
        x03: value
    }, {
        success: function(response) {
            if (response.success) {
                apex.message.showPageSuccess('Saved');
            } else {
                apex.message.showErrors([{type: 'error', message: response.error}]);
            }
        }
    });
}
```

---

### 6.5 reportdashboardjs.js (Dashboard)

**Purpose:** Tab management and dashboard persistence.

```javascript
// Populate hotel LOV with auto-selection
function populateHotelLov() {
    apex.server.process('AJX_GET_REPORT_HOTEL', {
        x01: 'HOTEL'
    }, {
        success: function(data) {
            const select = $('#P15_HOTEL_ID');
            data.forEach(h => {
                select.append(new Option(h.hotel_name, h.id));
            });
            syncFromGlobalLov();
        }
    });
}

// Load dashboard configuration
function call_dashboard_data(hotelId) {
    apex.server.process('AJX_MANAGE_REPORT_DASHBOARD', {
        x01: 'SELECT',
        x02: hotelId
    }, {
        success: function(data) {
            if (data.definition) {
                recreateTabsFromJSON(JSON.parse(data.definition));
            }
        }
    });
}

// Recreate tabs from saved config
function recreateTabsFromJSON(config) {
    clearAllTabs();
    config.tabs.forEach(tab => {
        createTab(tab.name, tab.reportId, tab.filters);
    });
}
```

---

### 6.6 showAlert.js (Notifications)

**Purpose:** Universal alert system.

```javascript
// SweetAlert2 implementation
function showAlert(input) {
    if (typeof input === 'string') {
        input = {message: input};
    }

    // Normalize icon
    const iconMap = {s: 'success', w: 'warning', e: 'error', i: 'info'};
    const icon = iconMap[input.icon] || input.icon || 'info';

    Swal.fire({
        title: input.title || '',
        text: input.message,
        icon: icon,
        timer: input.timer || (icon === 'error' ? null : 3000),
        toast: input.toast !== false,
        position: input.position || 'top-end'
    });
}

// Toastr implementation (legacy)
function showAlertToastr(input) {
    const options = {
        positionClass: 'toast-top-right',
        progressBar: true,
        timeOut: input.timer || 5000,
        closeButton: true
    };

    toastr[input.icon || 'info'](input.message, input.title, options);
}
```

---

## 7. Lists of Values (LOVs)

### 7.1 Dynamic LOVs

#### UR_HOTELS.HOTEL_NAME
```sql
SELECT hotel_name AS d, RAWTOHEX(id) AS r
FROM ur_hotels
WHERE (association_end_date IS NULL OR association_end_date > SYSDATE)
ORDER BY hotel_name;
```

#### Hotel Clusters
```sql
SELECT group_name AS d, RAWTOHEX(id) AS r
FROM ur_hotel_groups
ORDER BY group_name;
```

#### Room Types (Cascading)
```sql
SELECT room_type_name AS d, RAWTOHEX(room_type_id) AS r
FROM ur_hotel_room_types
WHERE hotel_id = HEXTORAW(:P_HOTEL_ID)
ORDER BY room_type_name;
```

#### Algorithms/Strategies
```sql
SELECT name AS d, RAWTOHEX(id) AS r
FROM ur_algos
WHERE hotel_id IS NULL OR hotel_id = HEXTORAW(:P_HOTEL_ID)
ORDER BY name;
```

---

### 7.2 Static LOVs

#### UR USER TYPE
| Display | Return |
|---------|--------|
| Employee | Employee |
| Contractor | Contractor |
| Hotel Team | Hotel Team |

#### UR TEMPLATE TYPES
| Display | Return |
|---------|--------|
| BI | Business Intelligence |
| PMS | Property Management System |
| RMS | Revenue Management System |
| RST | Rate Shopping Tool |
| MANUAL_ALGO_SETUP_ATTR | Manual Hotel Algorithm Attributes |
| OTHERS | Other |

#### UR BED TYPES
| Display | Return |
|---------|--------|
| Single | Single |
| Double | Double |
| Twin | Twin |
| Queen | Queen |
| King | King |
| Suite | Suite |

#### UR EVENT TYPES
| Display | Return |
|---------|--------|
| Conference | Conference |
| Concert | Concert |
| Sports | Sports |
| Festival | Festival |
| Exhibition | Exhibition |
| Holiday | Holiday |
| Wedding | Wedding |
| Corporate | Corporate |

#### UR IMPACT LEVELS
| Display | Return |
|---------|--------|
| Low | 1 |
| Medium | 2 |
| High | 3 |
| Critical | 4 |

#### UR USER STATUS
| Display | Return |
|---------|--------|
| Active | Active |
| Inactive | Inactive |
| Pending | Pending |
| Locked | Locked |

---

### 7.3 Complete LOV List

| LOV Name | Type | Purpose |
|----------|------|---------|
| UR_HOTELS_HOTEL_NAME | Dynamic | Hotel selection |
| UR_USER_TYPE | Static | User category |
| UR_USER_STATUS | Static | User status |
| UR_TEMPLATE_TYPES | Static | Template category |
| UR_BED_TYPES | Static | Bed configuration |
| UR_EVENT_TYPES | Static | Event category |
| UR_BOOKING_DAYS | Static | Day of week |
| UR_RESERVATION_TYPES | Static | Booking type |
| UR_RESERVSTION_EXCEPTION_TYPE | Static | Exception category |
| UR_CANCELLATION_REASON | Static | Cancel reason |
| UR_CONTACT_TYPES | Static | Contact category |
| UR_LEAD_TIME_TYPES | Static | Lead time units |
| UR_MAPPING_TYPES | Static | Mapping category |
| UR_EVENT_SCORE | Static | Impact scoring |
| UR_EXPRESSION_OPERATORS | Static | Algorithm operators |
| UR_EXPRESSION_FUNCTIONS | Static | Algorithm functions |
| UR_ALGO_CONDITIONS_OPERATORS | Static | Condition operators |
| UR_ATTRIBUTE_QUALIFIERS | Static | Attribute qualifiers |
| UR_PROPERTY_RANKING | Static | Competitive ranking |
| UR_ROOM_SUPPLIMENT_TYPES | Static | Supplement category |
| UR_HOTEL_PRICE_OVERRIDE_TYPE | Static | Override type |
| UR_HOTEL_PRICE_OVERRIDE_REASON | Static | Override reason |
| ACCESS_ROLES | Static | Security roles |
| DESKTOP_THEME_STYLES | Dynamic | Theme selection |
| FEEDBACK_STATUS | Static | Feedback status |
| FEEDBACK_RATING | Static | Feedback rating |
| EMAIL_USERNAME_FORMAT | Static | Email format |
| TIMEFRAME_4_WEEKS | Static | Time periods |
| VIEW_AS_REPORT_CHART | Static | View options |

---

## 8. Navigation & Security

### 8.1 Navigation Structure

```
Home (Page 1)
│
├── Hotel Management (Page 1020)
│   ├── Manage Cluster (Page 1027)
│   ├── Hotels (Page 11)
│   ├── Room Types (Page 1023)
│   ├── Contact Directory (Page 1026)
│   └── Address Book (Page 17)
│
├── Event Management (Page 9)
│
├── Hotel Data (Page 14)
│   ├── Add New Template (Page 1002)
│   ├── Manage Templates (Page 29)
│   ├── Load Data (Page 1011)
│   ├── Price Override (Page 1075)
│   └── Reservation Update (Page 19)
│
├── Strategies (Page 1050)
│
├── Reports (Page 21)
│   ├── Manage Reports (Page 1006)
│   ├── Run Reports (Page 15)
│   └── Report Summary (Page 167)
│
└── Administration (Page 10000) [Admin Only]
    └── Interface Dashboard (Page 1601)
```

---

### 8.2 Security Configuration

#### Authentication
- **Scheme:** Oracle APEX Accounts (NATIVE_APEX_ACCOUNTS)
- **Invalid Session:** Redirect to LOGIN page
- **Secure Cookies:** Configurable

#### Authorization Schemes

| Scheme | Type | Logic |
|--------|------|-------|
| Reader Rights | Function | Check ACCESS_CONTROL_SCOPE or has_any_roles |
| Contribution Rights | Is In Group | Administrator OR Contributor |
| Administration Rights | Is In Group | Administrator only |

#### Reader Rights Logic
```sql
IF apex_app_setting.get_value('ACCESS_CONTROL_SCOPE') = 'ALL_USERS' THEN
    RETURN TRUE;  -- Allow any authenticated user
ELSE
    RETURN apex_acl.has_user_any_roles(
        p_application_id => :APP_ID,
        p_user_name => :APP_USER
    );
END IF;
```

#### Access Control Roles

| Role | Static ID | Permissions |
|------|-----------|-------------|
| Reader | READER | View only |
| Contributor | CONTRIBUTOR | View + Edit |
| Administrator | ADMINISTRATOR | Full access |

---

### 8.3 Application Settings

| Setting | Values | Default | Purpose |
|---------|--------|---------|---------|
| ACCESS_CONTROL_SCOPE | ACL_ONLY, ALL_USERS | ACL_ONLY | Default access level |
| FEEDBACK_ATTACHMENTS_YN | Y, N | Y | Allow feedback attachments |

---

### 8.4 Build Options

| Feature | Static ID | Default |
|---------|-----------|---------|
| Access Control | APPLICATION_ACCESS_CONTROL | Include |
| Activity Reporting | APPLICATION_ACTIVITY_REPORTING | Include |
| Feedback | APPLICATION_FEEDBACK | Include |
| Configuration Options | APPLICATION_CONFIGURATION | Include |
| About Page | APPLICATION_ABOUT_PAGE | Include |
| Theme Style Selection | APPLICATION_THEME_STYLE_SELECTION | Include |
| Push Notifications | APPLICATION_PUSH_NOTIFICATIONS | Include |
| User Settings | APPLICATION_USER_SETTINGS | Include |

---

## 9. External Integrations

### 9.1 Postcodes.io (Address Lookup)

**Purpose:** UK postcode lookup for automatic city/country population.

**Usage:** Page 20 (Add Events), Page 7 (Address Form)

**JavaScript Implementation:**
```javascript
// Dynamic Action on P20_POST_CODE change
apex.server.process('POSTCODE_LOOKUP', {
    x01: $v('P20_POST_CODE')
}, {
    dataType: 'json',
    success: function(data) {
        if (data.status === 200) {
            $s('P20_CITY', data.result.admin_district);
            $s('P20_COUNTRY', data.result.country);
        }
    }
});

// Alternative: Direct fetch
fetch(`https://api.postcodes.io/postcodes/${postcode}`)
    .then(response => response.json())
    .then(data => {
        if (data.status === 200) {
            // Populate fields
        }
    });
```

---

### 9.2 OpenAI Integration

**Purpose:** AI-powered assistance.

**Configuration:**
- **Type:** NATIVE_HTTP
- **Endpoint:** /chat/completions
- **Model:** gpt-4.1-mini

**Web Source Parameters:**
| Parameter | Direction | Type | Default |
|-----------|-----------|------|---------|
| system_role | IN | VARCHAR2 | "You are a helpful assistant." |
| user_prompt | IN | VARCHAR2 | - |
| response | OUT | VARCHAR2 | - |

**Credential:** Stored separately (ID: 4674256272916921)

---

## 10. Common Development Tasks

### 10.1 Adding a New Table

1. **Create table with standard structure:**
```sql
CREATE TABLE ur_new_table (
    id              RAW(16) DEFAULT SYS_GUID() NOT NULL,
    -- Business columns
    hotel_id        RAW(16),
    name            VARCHAR2(100) NOT NULL,
    -- Audit columns
    created_by      RAW(16) NOT NULL,
    updated_by      RAW(16) NOT NULL,
    created_on      DATE NOT NULL,
    updated_on      DATE NOT NULL,
    CONSTRAINT pk_ur_new_table PRIMARY KEY (id),
    CONSTRAINT fk_ur_new_table_hotel FOREIGN KEY (hotel_id)
        REFERENCES ur_hotels(id)
);
```

2. **Create audit trigger:**
```sql
CREATE OR REPLACE TRIGGER trg_ur_new_table_bi_trg
BEFORE INSERT OR UPDATE ON ur_new_table
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        :NEW.id := NVL(:NEW.id, SYS_GUID());
        :NEW.created_by := NVL(:NEW.created_by, app_user_ctx.get_current_user_id());
        :NEW.created_on := NVL(:NEW.created_on, SYSDATE);
    END IF;
    :NEW.updated_by := app_user_ctx.get_current_user_id();
    :NEW.updated_on := SYSDATE;
END;
/
```

3. **Add to install.sql in correct order**

---

### 10.2 Creating a New Page

1. **Create page in APEX Application Builder**
2. **Add to navigation list if needed:**
```sql
-- In navigation_menu.sql
wwv_flow_imp_shared.create_list_entry(
    p_list_id => wwv_flow_imp.id(1234567),
    p_list_entry_name => 'New Feature',
    p_list_entry_link => 'f?p=&APP_ID.:NEW_PAGE:&SESSION.::&DEBUG.:::',
    p_list_entry_icon => 'fa-star',
    p_list_entry_current_for_pages => 'NEW_PAGE',
    p_security_scheme => wwv_flow_imp.id(8564201...) -- Optional
);
```

3. **Add breadcrumb entry**
4. **Set up authorization scheme**

---

### 10.3 Adding an AJAX Process

1. **Create process in Application Builder:**
   - Shared Components → Application Processes
   - Name: AJX_NEW_PROCESS
   - Point: On Demand

2. **PL/SQL Template:**
```sql
DECLARE
    l_mode    VARCHAR2(100) := apex_application.g_x01;
    l_param1  VARCHAR2(4000) := apex_application.g_x02;
    l_result  CLOB;
BEGIN
    CASE l_mode
        WHEN 'SELECT' THEN
            -- Query logic
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT('id' VALUE id, 'name' VALUE name)
            ) INTO l_result
            FROM ur_table
            WHERE hotel_id = HEXTORAW(l_param1);

        WHEN 'INSERT' THEN
            -- Insert logic
            INSERT INTO ur_table (name) VALUES (l_param1);
            l_result := '{"success": true}';

        WHEN 'DELETE' THEN
            -- Delete logic
            DELETE FROM ur_table WHERE id = HEXTORAW(l_param1);
            l_result := '{"success": true}';
    END CASE;

    HTP.P(l_result);
EXCEPTION
    WHEN OTHERS THEN
        HTP.P('{"success": false, "error": "' || SQLERRM || '"}');
END;
```

3. **JavaScript call:**
```javascript
apex.server.process('AJX_NEW_PROCESS', {
    x01: 'SELECT',
    x02: hotelId
}, {
    dataType: 'json',
    success: function(data) {
        console.log(data);
    },
    error: function(xhr, status, error) {
        console.error(error);
    }
});
```

---

### 10.4 Adding a New LOV

**Static LOV:**
```sql
wwv_flow_imp_shared.create_list_of_values(
    p_id => wwv_flow_imp.id(NEW_LOV_ID),
    p_lov_name => 'NEW_LOV_NAME',
    p_lov_query => '.',  -- Static indicator
    p_location => 'LOCAL'
);

wwv_flow_imp_shared.create_static_lov_data(
    p_id => wwv_flow_imp.id(...),
    p_lov_id => wwv_flow_imp.id(NEW_LOV_ID),
    p_lov_disp_sequence => 1,
    p_lov_disp_value => 'Display Value',
    p_lov_return_value => 'RETURN_VALUE'
);
```

**Dynamic LOV:**
```sql
wwv_flow_imp_shared.create_list_of_values(
    p_id => wwv_flow_imp.id(NEW_LOV_ID),
    p_lov_name => 'NEW_DYNAMIC_LOV',
    p_lov_query => q'[
        SELECT display_col d, RAWTOHEX(id) r
        FROM ur_table
        WHERE active = 'Y'
        ORDER BY display_col
    ]',
    p_source_type => 'SQL'
);
```

---

### 10.5 Working with JSON in CLOB Columns

**Parsing JSON:**
```sql
-- Extract array elements
SELECT jt.*
FROM ur_templates t,
     JSON_TABLE(t.definition, '$.columns[*]'
         COLUMNS (
             name VARCHAR2(100) PATH '$.name',
             data_type VARCHAR2(50) PATH '$.data_type',
             required VARCHAR2(5) PATH '$.required'
         )
     ) jt
WHERE t.id = :template_id;
```

**Building JSON:**
```sql
SELECT JSON_OBJECT(
    'id' VALUE RAWTOHEX(id),
    'name' VALUE name,
    'columns' VALUE (
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT('name' VALUE col_name, 'type' VALUE col_type)
        )
        FROM ur_template_columns WHERE template_id = t.id
    )
) AS json_result
FROM ur_templates t
WHERE id = :template_id;
```

---

### 10.6 Debug Logging

**Using DEBUG_LOG table:**
```sql
INSERT INTO debug_log (message, full_sql)
VALUES ('Processing started', l_sql);
COMMIT;
```

**Using APEX_DEBUG:**
```sql
APEX_DEBUG.INFO('Process: %s, Parameter: %s', l_process_name, l_param);
APEX_DEBUG.ERROR('Error in %s: %s', l_location, SQLERRM);
```

**View debug in APEX:**
- URL: Add `&p_trace=YES` to enable
- View: Application > Utilities > Debug Messages

---

## 11. Troubleshooting Guide

### 11.1 Common Issues

#### "ORA-01403: no data found"
**Cause:** Query returns no rows where one was expected.
**Solution:** Use NVL or exception handling:
```sql
BEGIN
    SELECT value INTO l_value FROM table WHERE id = :id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        l_value := NULL;
END;
```

#### "ORA-06502: PL/SQL: numeric or value error"
**Cause:** Data type mismatch or overflow.
**Solution:** Check VARCHAR2 lengths, use TO_CHAR/TO_NUMBER with format masks.

#### AJAX Process Returns Empty
**Cause:** Missing HTP.P() or exception not handled.
**Solution:**
```sql
BEGIN
    -- Your logic
    HTP.P(l_result);
EXCEPTION
    WHEN OTHERS THEN
        HTP.P('{"error": "' || SQLERRM || '"}');
END;
```

#### Interactive Grid Not Refreshing
**Cause:** Region static ID mismatch.
**Solution:**
```javascript
// Use correct region static ID
apex.region('your_region_static_id').refresh();
```

---

### 11.2 Performance Issues

#### Slow Page Load
1. Check Page Performance in Activity Dashboard
2. Review SQL queries for missing indexes
3. Use APEX_DEBUG.INFO to identify bottlenecks

#### Large JSON Processing
```sql
-- Use streaming for large CLOBs
DECLARE
    l_chunk VARCHAR2(32000);
    l_offset NUMBER := 1;
BEGIN
    LOOP
        l_chunk := DBMS_LOB.SUBSTR(l_clob, 32000, l_offset);
        EXIT WHEN l_chunk IS NULL;
        -- Process chunk
        l_offset := l_offset + 32000;
    END LOOP;
END;
```

---

### 11.3 Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "Access denied" | Authorization scheme failed | Check user roles |
| "Session expired" | Timeout or invalid session | Re-login |
| "File too large" | Exceeds upload limit | Check APEX instance settings |
| "Invalid JSON" | Malformed JSON in CLOB | Validate with JSON_VALUE |

---

## Appendices

### A. RAW(16) ID Handling

**Converting between RAW and VARCHAR2:**
```sql
-- RAW to VARCHAR2
SELECT RAWTOHEX(id) FROM ur_hotels;

-- VARCHAR2 to RAW
SELECT * FROM ur_hotels WHERE id = HEXTORAW(:varchar_id);
```

**In JavaScript:**
```javascript
// IDs are passed as hex strings
const hotelId = 'ABC123DEF456...'; // 32 chars
apex.server.process('PROCESS', { x01: hotelId });
```

---

### B. Date Format Reference

| Context | Format | Example |
|---------|--------|---------|
| Display | DD-MON-YYYY | 25-DEC-2024 |
| APEX Items | &APP_DATE_FORMAT. | Application setting |
| JSON | YYYY-MM-DD | 2024-12-25 |
| ISO | YYYY-MM-DD"T"HH24:MI:SS | 2024-12-25T14:30:00 |

---

### C. APEX Item Reference

| Prefix | Scope | Example |
|--------|-------|---------|
| P{n}_ | Page items | P23_HOTEL_NAME |
| G_ | Application items | G_HOTEL_ID |
| F{nn}_ | Flow/App items | F106_USER |
| AI_ | Application items | AI_GLOBAL_VAR |

---

### D. Quick Reference: Key IDs

| Object | ID Pattern |
|--------|------------|
| Application | 106 (internal: 103) |
| Admin Auth Scheme | 8565313938922218 |
| OpenAI Credential | 4674256272916921 |
| Feedback Sequence | XXPEL_WF_FEEDBACK_SEQ |

---

### E. File Upload Limits

| Setting | Value |
|---------|-------|
| Max file size | 10 MB |
| Allowed types | .xlsx, .xls, .csv |
| Temp storage | APEX_APPLICATION_TEMP_FILES |
| Persistent storage | TEMP_BLOB table |

---

### F. Useful SQL Queries for Debugging

```sql
-- Find all tables with a column
SELECT table_name, column_name
FROM user_tab_columns
WHERE column_name LIKE '%HOTEL%';

-- Check table row counts
SELECT table_name, num_rows
FROM user_tables
WHERE table_name LIKE 'UR_%';

-- Find trigger code
SELECT trigger_name, trigger_body
FROM user_triggers
WHERE table_name = 'UR_HOTELS';

-- Check APEX collections
SELECT * FROM apex_collections
WHERE collection_name = 'ERROR_COLLECTION';

-- View recent debug logs
SELECT * FROM debug_log
ORDER BY log_time DESC
FETCH FIRST 20 ROWS ONLY;
```

---

**Document Version:** 1.0
**Last Updated:** December 2024
**Maintainer:** Development Team

---

*This technical guide provides comprehensive documentation for developers working on the Untapped Revenue application. For user-focused documentation, see the Reader, Contributor, and Administrator guides.*
