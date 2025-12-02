# Date Parser Guide

## Overview

The `date_parser` procedure in `UR_UTILS` provides smart date format detection and parsing with support for ~80 formats, text numbers, special values, and year inference.

---

## Quick Start

### Detect Format from Samples
```sql
SELECT ur_utils.detect_date_format_simple('["27-Nov-2024", "15-Dec-2024", "01-Jan-2025"]') FROM dual;
-- Returns: DD-MON-YYYY
```

### Parse a Date Safely
```sql
SELECT ur_utils.parse_date_safe('27-Nov-2024', 'DD-MON-YYYY') FROM dual;
-- Returns: 27-NOV-24 (DATE)
```

### Full Detection with Details
```sql
DECLARE
    v_alert        CLOB;
    v_format       VARCHAR2(100);
    v_confidence   NUMBER;
    v_date         DATE;
    v_has_year     VARCHAR2(1);
    v_is_ambiguous VARCHAR2(1);
    v_specials     VARCHAR2(500);
    v_all_formats  CLOB;
    v_status       VARCHAR2(1);
    v_message      VARCHAR2(4000);
BEGIN
    ur_utils.date_parser(
        p_mode            => 'DETECT',
        p_sample_values   => '["27/11/2024", "15/12/2024", "31/01/2025"]',
        p_debug_flag      => 'N',
        p_alert_clob      => v_alert,
        p_format_mask_out => v_format,
        p_confidence      => v_confidence,
        p_converted_date  => v_date,
        p_has_year        => v_has_year,
        p_is_ambiguous    => v_is_ambiguous,
        p_special_values  => v_specials,
        p_all_formats     => v_all_formats,
        p_status          => v_status,
        p_message         => v_message
    );
    DBMS_OUTPUT.PUT_LINE('Format: ' || v_format || ' (' || v_confidence || '%)');
END;
```

---

## Modes

| Mode | Purpose | Key Parameters |
|------|---------|----------------|
| `DETECT` | Detect format from JSON array of samples | `p_sample_values` (CLOB) |
| `PARSE` | Parse single date string | `p_date_string`, `p_format_mask`, `p_start_date` |
| `TEST` | Run internal test suite | None |

---

## Supported Formats (~80)

### ISO (Unambiguous)
`YYYY-MM-DD`, `YYYY-MM-DD HH24:MI:SS`, `YYYYMMDD`, `YYYY/MM/DD`

### Month Name (Unambiguous)
`DD-MON-YYYY`, `DD MON YYYY`, `MONTH DD, YYYY`, `MON DD YYYY`, `DD-MON`, `MON DD`

### Day Name (Unambiguous)
`DY DD-MON-YYYY`, `DAY DD MONTH YYYY`, `DY, DD MON`, `DAY, MONTH DD, YYYY`

### Numeric (Ambiguous - DD/MM vs MM/DD)
`DD/MM/YYYY`, `MM/DD/YYYY`, `DD-MM-YYYY`, `DD.MM.YYYY`, `DD/MM/RR`, `DD/MM`

---

## Confidence Scoring

Base score = (matching samples / total samples) × 100

| Modifier | Effect |
|----------|--------|
| ISO/DAYNAME/MONTHNAME category | +15% |
| `YYYY-MM-DD` format | +10% |
| 2-digit year (RR) | -10% |
| No year format | -15% |
| Ambiguous (DD/MM vs MM/DD) | -20% |

**Cap**: 100%

---

## Smart Features

### 1. Text Number Conversion
Automatically converts written numbers:
- `twenty-first November` → `21 November`
- `the sixteenth of December` → `16 December`

### 2. Preprocessing (10 Steps)
- Normalizes day names: `Thursday` → `Thu`, `Thurs` → `Thu`
- Removes filler words: `the`, `of`, `on`, `in`
- Strips ordinal suffixes: `1st` → `1`, `21st` → `21`
- Removes decorative day names: `Thu 27-Nov` → `27-Nov`
- Removes AD/BC and parenthetical content

### 3. DD/MM vs MM/DD Disambiguation
Analyzes sample values to determine format:
- If any value has first number > 12: **DD/MM** (European)
- If any value has second number > 12: **MM/DD** (US)
- If all values ≤ 12: **Ambiguous** (defaults to DD/MM)

### 4. Year Inference (for no-year formats)
When format has no year and `p_start_date` is provided:
- **With day name**: Validates which year matches the day of week
- **Without day name**: Uses sequential logic (month before start = next year)

```sql
-- With start_date = 2024-11-15
-- "Wed 01 Jan" → 2025-01-01 (Wed matches 2025, not 2024)
-- "15 Nov" → 2024-11-15 (Nov >= Nov in start date)
-- "01 Feb" → 2025-02-01 (Feb < Nov, so next year)
```

### 5. Special Values Detection
Recognizes and filters: `TODAY`, `YESTERDAY`, `TOMORROW`, `N/A`, `TBD`, `PENDING`, `NULL`, `NONE`, `ASAP`, `EOD`, `EOW`, `CURRENT`, `NOW`

---

## Output Parameters

| Parameter | Description |
|-----------|-------------|
| `p_format_mask_out` | Detected/used format mask |
| `p_confidence` | Detection confidence (0-100) |
| `p_converted_date` | Parsed DATE (PARSE mode) |
| `p_has_year` | 'Y' if format includes year |
| `p_is_ambiguous` | 'Y' if DD/MM vs MM/DD ambiguous |
| `p_special_values` | Comma-separated special values found |
| `p_all_formats` | JSON array of all matching formats |
| `p_status` | 'S'=Success, 'E'=Error, 'W'=Warning |
| `p_message` | Status message |

---

## Integration Points

- **P1002 (Template Creation)**: Use `DETECT` mode to auto-detect date format from column samples
- **P1010 (Data Loading)**: Use `PARSE` mode to convert date strings using stored format

---

## Debugging

Enable debug logging:
```sql
p_debug_flag => 'Y'
```
Debug trace is appended to `p_message`.

---

## Run Tests

```sql
DECLARE
    v_result  CLOB;
    v_status  VARCHAR2(1);
    v_message VARCHAR2(4000);
BEGIN
    ur_utils.test_date_parser(
        p_test_type   => 'ALL',
        p_debug_flag  => 'Y',
        p_result_json => v_result,
        p_status      => v_status,
        p_message     => v_message
    );
    DBMS_OUTPUT.PUT_LINE(v_message);
    DBMS_OUTPUT.PUT_LINE(v_result);
END;
```
