/*
================================================================================
  UR_DATE_PARSER_TEST - Smart Date Parsing Test Package
================================================================================
  Purpose: Standalone test package for smart date format detection and parsing
  Version: 1.0
  Date: 2024-11-29

  This package can be created independently for testing before integration
  into the main UR_UTILS package.

  Features:
  - Text number conversion (sixteen -> 16, twenty-first -> 21)
  - Ordinal suffix handling (1st, 2nd, 3rd -> 1, 2, 3)
  - Day name detection and year inference
  - Comprehensive format detection (~80 formats)
  - Ambiguity resolution (DD/MM vs MM/DD)
  - Special value handling (TODAY, YESTERDAY, N/A)
  - Confidence scoring

  Usage:
    -- Test single date conversion
    SELECT ur_date_parser_test.fn_try_date('27-Nov-2024', 'DD-MON-YYYY') FROM dual;

    -- Test preprocessing
    SELECT ur_date_parser_test.preprocess_date_sample('the twenty-first of November') FROM dual;

    -- Test format detection
    DECLARE
      v_format VARCHAR2(100);
      v_confidence NUMBER;
      v_all_formats CLOB;
    BEGIN
      ur_date_parser_test.detect_date_format(
        p_sample_values => '["27-Nov-2024", "15-Dec-2024", "01-Jan-2025"]',
        p_format_mask => v_format,
        p_confidence => v_confidence,
        p_all_formats => v_all_formats
      );
      DBMS_OUTPUT.PUT_LINE('Format: ' || v_format || ' Confidence: ' || v_confidence || '%');
    END;

  To Drop:
    DROP PACKAGE ur_date_parser_test;
================================================================================
*/

-- Package Specification
CREATE OR REPLACE PACKAGE ur_date_parser_test AS

    -- Type definitions
    TYPE t_date_structure IS RECORD (
        has_day_name_short   VARCHAR2(1),
        has_day_name_full    VARCHAR2(1),
        has_day_name         VARCHAR2(1),
        has_month_name_short VARCHAR2(1),
        has_month_name_full  VARCHAR2(1),
        has_month_name       VARCHAR2(1),
        has_4digit_year      VARCHAR2(1),
        has_2digit_year      VARCHAR2(1),
        has_time             VARCHAR2(1),
        has_ampm             VARCHAR2(1),
        has_timezone         VARCHAR2(1),
        has_text_numbers     VARCHAR2(1),
        separators           VARCHAR2(20),
        primary_separator    VARCHAR2(5),
        numeric_group_count  NUMBER
    );

    TYPE t_format_result IS RECORD (
        format_mask    VARCHAR2(100),
        confidence     NUMBER,
        match_count    NUMBER,
        category       VARCHAR2(30),
        has_year       VARCHAR2(1),
        is_ambiguous   VARCHAR2(1)
    );

    TYPE t_format_results IS TABLE OF t_format_result INDEX BY PLS_INTEGER;

    -- Core Functions
    FUNCTION fn_try_date(
        p_string IN VARCHAR2,
        p_format IN VARCHAR2
    ) RETURN DATE DETERMINISTIC;

    FUNCTION convert_text_numbers(
        p_input IN VARCHAR2
    ) RETURN VARCHAR2 DETERMINISTIC;

    FUNCTION cleanup_date_string(
        p_input IN VARCHAR2
    ) RETURN VARCHAR2 DETERMINISTIC;

    FUNCTION preprocess_date_sample(
        p_raw IN VARCHAR2
    ) RETURN VARCHAR2 DETERMINISTIC;

    FUNCTION analyze_date_structure(
        p_sample IN VARCHAR2
    ) RETURN t_date_structure;

    FUNCTION detect_special_values(
        p_sample_values IN CLOB
    ) RETURN VARCHAR2;

    FUNCTION fn_infer_year(
        p_date_str   IN VARCHAR2,
        p_start_date IN VARCHAR2,
        p_format     IN VARCHAR2 DEFAULT NULL
    ) RETURN DATE;

    FUNCTION fn_validate_day_name(
        p_date     IN DATE,
        p_day_name IN VARCHAR2
    ) RETURN VARCHAR2;

    -- Main Detection Procedure
    PROCEDURE detect_date_format(
        p_sample_values    IN  CLOB,
        p_format_mask      OUT VARCHAR2,
        p_confidence       OUT NUMBER,
        p_is_ambiguous     OUT VARCHAR2,
        p_has_year         OUT VARCHAR2,
        p_special_values   OUT VARCHAR2,
        p_all_formats      OUT CLOB,
        p_status           OUT VARCHAR2,
        p_message          OUT VARCHAR2
    );

    -- Simplified detection (returns just format mask)
    FUNCTION detect_format_simple(
        p_sample_values IN CLOB
    ) RETURN VARCHAR2;

    -- Test helper procedures
    PROCEDURE test_preprocessing(
        p_input  IN  VARCHAR2,
        p_output OUT VARCHAR2
    );

    PROCEDURE test_all_formats(
        p_sample IN VARCHAR2
    );

    PROCEDURE run_test_suite;

END ur_date_parser_test;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY ur_date_parser_test AS

    -- Constants for patterns
    -- NOTE: Oracle regex doesn't reliably support \b, so we use (^|[^a-zA-Z]) and ([^a-zA-Z]|$) for word boundaries
    c_day_pattern_short  CONSTANT VARCHAR2(100) := '(^|[^a-zA-Z])(Mon|Tue|Wed|Thu|Fri|Sat|Sun)([^a-zA-Z]|$)';
    c_day_pattern_full   CONSTANT VARCHAR2(100) := '(^|[^a-zA-Z])(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)([^a-zA-Z]|$)';
    c_month_pattern_short CONSTANT VARCHAR2(200) := '(^|[^a-zA-Z])(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)([^a-zA-Z]|$)';
    c_month_pattern_full  CONSTANT VARCHAR2(500) := '(^|[^a-zA-Z])(January|February|March|April|May|June|July|August|September|October|November|December)([^a-zA-Z]|$)';

    -- Format library (ordered by priority)
    TYPE t_format_def IS RECORD (
        format_mask    VARCHAR2(50),
        category       VARCHAR2(20),
        has_year       VARCHAR2(1),
        has_day_name   VARCHAR2(1),
        has_month_name VARCHAR2(1),
        is_ambiguous   VARCHAR2(1),
        alternate      VARCHAR2(50)
    );
    TYPE t_format_lib IS TABLE OF t_format_def INDEX BY PLS_INTEGER;

    -------------------------------------------------------------------------------
    -- fn_try_date: Safe date parsing - returns NULL on failure
    -------------------------------------------------------------------------------
    FUNCTION fn_try_date(
        p_string IN VARCHAR2,
        p_format IN VARCHAR2
    ) RETURN DATE DETERMINISTIC IS
        v_date DATE;
    BEGIN
        IF p_string IS NULL OR p_format IS NULL THEN
            RETURN NULL;
        END IF;
        v_date := TO_DATE(TRIM(p_string), p_format);
        -- Validate year is reasonable
        IF EXTRACT(YEAR FROM v_date) < 1900 OR EXTRACT(YEAR FROM v_date) > 2100 THEN
            RETURN NULL;
        END IF;
        RETURN v_date;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END fn_try_date;

    -------------------------------------------------------------------------------
    -- convert_text_numbers: Convert text numbers to digits
    -- NOTE: Oracle regex doesn't reliably support \b word boundary
    -- We use space-padding technique: pad with spaces, match with spaces, trim result
    -------------------------------------------------------------------------------
    FUNCTION convert_text_numbers(
        p_input IN VARCHAR2
    ) RETURN VARCHAR2 DETERMINISTIC IS
        v_result VARCHAR2(500);
    BEGIN
        IF p_input IS NULL THEN
            RETURN NULL;
        END IF;

        -- Pad with spaces to enable word boundary matching
        v_result := ' ' || p_input || ' ';

        -- Process LONGEST strings first to avoid partial replacements
        -- Compound ordinals (twenty-first, twenty-second, etc.)
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?first(\s)', '\1 21 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?second(\s)', '\1 22 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?third(\s)', '\1 23 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?fourth(\s)', '\1 24 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?fifth(\s)', '\1 25 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?sixth(\s)', '\1 26 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?seventh(\s)', '\1 27 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?eighth(\s)', '\1 28 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?ninth(\s)', '\1 29 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirty[- ]?first(\s)', '\1 31 \2', 1, 0, 'i');

        -- Compound cardinals (twenty-one, twenty-two, etc.)
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?one(\s)', '\1 21 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?two(\s)', '\1 22 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?three(\s)', '\1 23 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?four(\s)', '\1 24 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?five(\s)', '\1 25 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?six(\s)', '\1 26 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?seven(\s)', '\1 27 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?eight(\s)', '\1 28 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?nine(\s)', '\1 29 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirty[- ]?one(\s)', '\1 31 \2', 1, 0, 'i');

        -- Single-word ordinals (longest first)
        v_result := REGEXP_REPLACE(v_result, '(\s)seventeenth(\s)', '\1 17 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eighteenth(\s)', '\1 18 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)nineteenth(\s)', '\1 19 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirteenth(\s)', '\1 13 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fourteenth(\s)', '\1 14 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fifteenth(\s)', '\1 15 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)sixteenth(\s)', '\1 16 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twentieth(\s)', '\1 20 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirtieth(\s)', '\1 30 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eleventh(\s)', '\1 11 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twelfth(\s)', '\1 12 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)seventh(\s)', '\1 7 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eighth(\s)', '\1 8 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fourth(\s)', '\1 4 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)second(\s)', '\1 2 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)third(\s)', '\1 3 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fifth(\s)', '\1 5 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)sixth(\s)', '\1 6 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)ninth(\s)', '\1 9 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)tenth(\s)', '\1 10 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)first(\s)', '\1 1 \2', 1, 0, 'i');

        -- Single-word cardinals (longest first)
        v_result := REGEXP_REPLACE(v_result, '(\s)seventeen(\s)', '\1 17 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eighteen(\s)', '\1 18 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)nineteen(\s)', '\1 19 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirteen(\s)', '\1 13 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fourteen(\s)', '\1 14 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fifteen(\s)', '\1 15 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)sixteen(\s)', '\1 16 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eleven(\s)', '\1 11 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twelve(\s)', '\1 12 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty(\s)', '\1 20 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirty(\s)', '\1 30 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)seven(\s)', '\1 7 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eight(\s)', '\1 8 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)three(\s)', '\1 3 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)four(\s)', '\1 4 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)five(\s)', '\1 5 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)nine(\s)', '\1 9 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)ten(\s)', '\1 10 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)one(\s)', '\1 1 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)two(\s)', '\1 2 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)six(\s)', '\1 6 \2', 1, 0, 'i');

        -- Clean up multiple spaces and trim
        v_result := REGEXP_REPLACE(v_result, '\s+', ' ');
        v_result := TRIM(v_result);

        RETURN v_result;
    END convert_text_numbers;

    -------------------------------------------------------------------------------
    -- cleanup_date_string: Remove filler words
    -- NOTE: Oracle regex doesn't reliably support \b word boundary
    -- We use space-padding technique for word matching
    -------------------------------------------------------------------------------
    FUNCTION cleanup_date_string(
        p_input IN VARCHAR2
    ) RETURN VARCHAR2 DETERMINISTIC IS
        v_result VARCHAR2(500);
    BEGIN
        IF p_input IS NULL THEN
            RETURN NULL;
        END IF;

        -- Pad with spaces to enable word boundary matching
        v_result := ' ' || p_input || ' ';

        -- Remove common filler words (case-insensitive)
        -- Replace word + surrounding spaces with single space
        v_result := REGEXP_REPLACE(v_result, '(\s)the(\s)', ' ', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)of(\s)', ' ', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)on(\s)', ' ', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)in(\s)', ' ', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)day(\s)', ' ', 1, 0, 'i');

        -- Normalize multiple spaces after removal
        v_result := REGEXP_REPLACE(v_result, '\s+', ' ');

        -- Handle comma-space normalization
        v_result := REGEXP_REPLACE(v_result, '\s*,\s*', ', ');

        RETURN TRIM(v_result);
    END cleanup_date_string;

    -------------------------------------------------------------------------------
    -- strip_day_name: Remove day name from date string (for DY format fallback)
    -- Used when DY/DAY formats fail due to NLS settings
    -------------------------------------------------------------------------------
    FUNCTION strip_day_name(
        p_input IN VARCHAR2
    ) RETURN VARCHAR2 DETERMINISTIC IS
        v_result VARCHAR2(500);
    BEGIN
        IF p_input IS NULL THEN
            RETURN NULL;
        END IF;

        v_result := p_input;

        -- Remove short day names (Mon, Tue, etc.) with boundary matching
        -- Use explicit boundary pattern since Oracle doesn't support \b
        v_result := REGEXP_REPLACE(v_result, '(^|[^a-zA-Z])(Mon|Tue|Wed|Thu|Fri|Sat|Sun)([^a-zA-Z]|$)', '\1\3', 1, 0, 'i');

        -- Remove full day names (Monday, Tuesday, etc.)
        v_result := REGEXP_REPLACE(v_result, '(^|[^a-zA-Z])(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)([^a-zA-Z]|$)', '\1\3', 1, 0, 'i');

        -- Clean up: remove leading/trailing commas and spaces
        v_result := REGEXP_REPLACE(v_result, '^\s*,?\s*', '');
        v_result := REGEXP_REPLACE(v_result, '\s*,?\s*$', '');
        v_result := REGEXP_REPLACE(v_result, '\s+', ' ');

        RETURN TRIM(v_result);
    END strip_day_name;

    -------------------------------------------------------------------------------
    -- preprocess_date_sample: Full preprocessing pipeline
    -------------------------------------------------------------------------------
    FUNCTION preprocess_date_sample(
        p_raw IN VARCHAR2
    ) RETURN VARCHAR2 DETERMINISTIC IS
        v_clean VARCHAR2(500);
    BEGIN
        IF p_raw IS NULL THEN
            RETURN NULL;
        END IF;

        -- Step 1: Trim whitespace
        v_clean := TRIM(p_raw);

        -- Step 2: Normalize multiple spaces
        v_clean := REGEXP_REPLACE(v_clean, '\s+', ' ');

        -- Step 3: Remove AD/BC prefix/suffix
        v_clean := REGEXP_REPLACE(v_clean, '(^|\s)AD(\s|$)', ' ', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|\s)BC(\s|$)', ' ', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|\s)A\.D\.(\s|$)', ' ', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|\s)B\.C\.(\s|$)', ' ', 1, 0, 'i');

        -- Step 4: Normalize non-standard day abbreviations to Oracle 3-letter format
        -- e.g., "Thurs" -> "Thu", "Tues" -> "Tue", "Weds" -> "Wed", "Monday" -> "Mon"
        -- Only match actual day name variants, not words like "month" that start with "Mon"
        -- Pattern: boundary + 3-letter day + optional known suffix (day/s) + boundary
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Mon)(days?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Tue)(sdays?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Wed)(nesdays?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Thu)(rsdays?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Fri)(days?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Sat)(urdays?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Sun)(days?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        -- Also handle non-standard abbreviations like "Thurs", "Tues", "Weds"
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])Thurs([^a-zA-Z]|$)', '\1Thu\2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])Tues([^a-zA-Z]|$)', '\1Tue\2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])Weds([^a-zA-Z]|$)', '\1Wed\2', 1, 0, 'i');

        -- Step 5: Remove parenthetical content like "(Weekday: Thu)" anywhere in string
        v_clean := REGEXP_REPLACE(v_clean, '\s*\([^)]*\)', '');

        -- Step 6: Remove standalone day names that are decorative (not part of date format)
        -- Day names are already normalized to 3-letter in Step 4
        -- 6a: Remove LEADING day name followed by optional comma/separator then a digit
        --     "Thu 27/11/2026" -> "27/11/2026"
        --     "Thu, 27/11/2026" -> "27/11/2026"
        --     "Thu - 27/11/2026" -> "27/11/2026"
        --     Note: Oracle doesn't support lookahead (?=), so capture and keep the digit
        v_clean := REGEXP_REPLACE(v_clean, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)[,]?\s*[-]?\s*(\d)', '\2', 1, 0, 'i');

        -- 6b: Remove TRAILING day name after dash/hyphen or just spaces
        --     "27/11/2026 - Thu" -> "27/11/2026"
        --     "27/11/2026 Thu" -> "27/11/2026"
        v_clean := REGEXP_REPLACE(v_clean, '\s+[-]?\s*(Mon|Tue|Wed|Thu|Fri|Sat|Sun)$', '', 1, 0, 'i');

        -- Step 7: Convert text numbers to digits (sixteen -> 16, twenty-first -> 21)
        v_clean := convert_text_numbers(v_clean);

        -- Step 8: Remove filler words (the, of, on)
        v_clean := cleanup_date_string(v_clean);

        -- Step 9: Strip ordinal suffixes (1st -> 1, 2nd -> 2, etc.)
        -- Use lookahead simulation: match digit+suffix followed by space/punctuation/end
        v_clean := REGEXP_REPLACE(v_clean, '(\d+)(st|nd|rd|th)([^a-zA-Z]|$)', '\1\3', 1, 0, 'i');

        -- Step 10: Final cleanup
        v_clean := TRIM(REGEXP_REPLACE(v_clean, '\s+', ' '));

        RETURN v_clean;
    END preprocess_date_sample;

    -------------------------------------------------------------------------------
    -- analyze_date_structure: Analyze structure of a date string
    -------------------------------------------------------------------------------
    FUNCTION analyze_date_structure(
        p_sample IN VARCHAR2
    ) RETURN t_date_structure IS
        v_result t_date_structure;
    BEGIN
        -- Check for day names (short)
        v_result.has_day_name_short := CASE
            WHEN REGEXP_LIKE(p_sample, c_day_pattern_short, 'i')
            THEN 'Y' ELSE 'N' END;

        -- Check for day names (full)
        v_result.has_day_name_full := CASE
            WHEN REGEXP_LIKE(p_sample, c_day_pattern_full, 'i')
            THEN 'Y' ELSE 'N' END;

        -- Combined day name flag
        v_result.has_day_name := CASE
            WHEN v_result.has_day_name_short = 'Y' OR v_result.has_day_name_full = 'Y'
            THEN 'Y' ELSE 'N' END;

        -- Check for month names (short)
        v_result.has_month_name_short := CASE
            WHEN REGEXP_LIKE(p_sample, c_month_pattern_short, 'i')
            THEN 'Y' ELSE 'N' END;

        -- Check for month names (full)
        v_result.has_month_name_full := CASE
            WHEN REGEXP_LIKE(p_sample, c_month_pattern_full, 'i')
            THEN 'Y' ELSE 'N' END;

        -- Combined month name flag
        v_result.has_month_name := CASE
            WHEN v_result.has_month_name_short = 'Y' OR v_result.has_month_name_full = 'Y'
            THEN 'Y' ELSE 'N' END;

        -- Check for 4-digit year (use non-word boundary pattern)
        v_result.has_4digit_year := CASE
            WHEN REGEXP_LIKE(p_sample, '(^|[^0-9])(19|20)[0-9]{2}([^0-9]|$)')
            THEN 'Y' ELSE 'N' END;

        -- Check for 2-digit year (less certain)
        v_result.has_2digit_year := CASE
            WHEN v_result.has_4digit_year = 'N' AND REGEXP_LIKE(p_sample, '(^|[^0-9])[0-9]{2}([^0-9]|$)')
            THEN 'Y' ELSE 'N' END;

        -- Check for time component
        v_result.has_time := CASE
            WHEN REGEXP_LIKE(p_sample, '[0-9]{1,2}:[0-9]{2}(:[0-9]{2})?')
            THEN 'Y' ELSE 'N' END;

        -- Check for AM/PM (use non-word boundary pattern)
        v_result.has_ampm := CASE
            WHEN REGEXP_LIKE(p_sample, '(^|[^a-zA-Z])(AM|PM|A\.M\.|P\.M\.)([^a-zA-Z]|$)', 'i')
            THEN 'Y' ELSE 'N' END;

        -- Check for timezone
        v_result.has_timezone := CASE
            WHEN REGEXP_LIKE(p_sample, '(Z|[+-][0-9]{2}:?[0-9]{2}|UTC|GMT)\s*$', 'i')
            THEN 'Y' ELSE 'N' END;

        -- Check for text numbers (use non-word boundary pattern)
        v_result.has_text_numbers := CASE
            WHEN REGEXP_LIKE(p_sample,
                '(^|[^a-zA-Z])(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|' ||
                'thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|' ||
                'first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|' ||
                'eleventh|twelfth|thirteenth|fourteenth|fifteenth|sixteenth|seventeenth|' ||
                'eighteenth|nineteenth|twentieth|thirtieth|twenty-first|twenty-second|' ||
                'twenty-third|twenty-fourth|twenty-fifth|twenty-sixth|twenty-seventh|' ||
                'twenty-eighth|twenty-ninth|thirty-first)([^a-zA-Z]|$)', 'i')
            THEN 'Y' ELSE 'N' END;

        -- Detect all separators used
        v_result.separators := '';
        IF INSTR(p_sample, '/') > 0 THEN v_result.separators := v_result.separators || '/'; END IF;
        IF INSTR(p_sample, '-') > 0 THEN v_result.separators := v_result.separators || '-'; END IF;
        IF INSTR(p_sample, '.') > 0 THEN v_result.separators := v_result.separators || '.'; END IF;
        IF INSTR(p_sample, ',') > 0 THEN v_result.separators := v_result.separators || ','; END IF;
        IF INSTR(p_sample, ' ') > 0 THEN v_result.separators := v_result.separators || ' '; END IF;

        -- Primary separator (most common)
        v_result.primary_separator := CASE
            WHEN INSTR(p_sample, '/') > 0 THEN '/'
            WHEN INSTR(p_sample, '-') > 0 THEN '-'
            WHEN INSTR(p_sample, '.') > 0 THEN '.'
            ELSE ' '
        END;

        -- Count numeric groups
        v_result.numeric_group_count := REGEXP_COUNT(p_sample, '\d+');

        RETURN v_result;
    END analyze_date_structure;

    -------------------------------------------------------------------------------
    -- detect_special_values: Find special values in samples
    -------------------------------------------------------------------------------
    FUNCTION detect_special_values(
        p_sample_values IN CLOB
    ) RETURN VARCHAR2 IS
        v_specials VARCHAR2(500) := '';
        TYPE t_special_list IS TABLE OF VARCHAR2(20);
        v_known_specials t_special_list := t_special_list(
            'TODAY', 'YESTERDAY', 'TOMORROW',
            'N/A', 'NA', 'TBD', 'TBA', 'PENDING',
            'NULL', 'NONE', 'ASAP', 'EOD', 'EOW',
            'CURRENT', 'NOW'
        );
    BEGIN
        IF p_sample_values IS NULL THEN
            RETURN NULL;
        END IF;

        FOR i IN 1..v_known_specials.COUNT LOOP
            IF REGEXP_LIKE(p_sample_values, '"' || v_known_specials(i) || '"', 'i') THEN
                v_specials := v_specials || v_known_specials(i) || ',';
            END IF;
        END LOOP;

        RETURN RTRIM(v_specials, ',');
    END detect_special_values;

    -------------------------------------------------------------------------------
    -- fn_validate_day_name: Check if day name matches date
    -------------------------------------------------------------------------------
    FUNCTION fn_validate_day_name(
        p_date     IN DATE,
        p_day_name IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_expected_day VARCHAR2(20);
    BEGIN
        IF p_day_name IS NULL OR p_date IS NULL THEN
            RETURN NULL;
        END IF;

        v_expected_day := TO_CHAR(p_date, 'DY');

        IF UPPER(SUBSTR(p_day_name, 1, 3)) = UPPER(v_expected_day) THEN
            RETURN 'Y';
        ELSE
            RETURN 'N';
        END IF;
    END fn_validate_day_name;

    -------------------------------------------------------------------------------
    -- fn_infer_year: Smart year inference using day name when available
    -------------------------------------------------------------------------------
    FUNCTION fn_infer_year(
        p_date_str   IN VARCHAR2,
        p_start_date IN VARCHAR2,
        p_format     IN VARCHAR2 DEFAULT NULL
    ) RETURN DATE IS
        v_start          DATE;
        v_start_year     NUMBER;
        v_start_mon      NUMBER;
        v_parsed_mon     NUMBER;
        v_parsed_day     NUMBER;
        v_day_name       VARCHAR2(20);
        v_candidate_date DATE;
        v_result         DATE;
        v_clean_str      VARCHAR2(200);
    BEGIN
        IF p_date_str IS NULL OR p_start_date IS NULL THEN
            RETURN NULL;
        END IF;

        v_start := TO_DATE(p_start_date, 'YYYY-MM-DD');
        v_start_year := EXTRACT(YEAR FROM v_start);
        v_start_mon := EXTRACT(MONTH FROM v_start);

        -- Step 1: Check if day name is present
        -- Use subexpression parameter (2) to get just the day name, not the boundary chars
        v_day_name := REGEXP_SUBSTR(p_date_str, c_day_pattern_short, 1, 1, 'i', 2);
        IF v_day_name IS NULL THEN
            v_day_name := REGEXP_SUBSTR(p_date_str, c_day_pattern_full, 1, 1, 'i', 2);
        END IF;

        -- Step 2: Extract day and month - remove day name first
        -- Replace day name (keeping boundary chars intact by using backrefs)
        v_clean_str := REGEXP_REPLACE(p_date_str, c_day_pattern_short || ',?\s*', '\1\3', 1, 0, 'i');
        v_clean_str := REGEXP_REPLACE(v_clean_str, c_day_pattern_full || ',?\s*', '\1\3', 1, 0, 'i');
        v_clean_str := TRIM(v_clean_str);
        v_clean_str := preprocess_date_sample(v_clean_str);

        -- Try various formats to parse day and month
        BEGIN
            v_candidate_date := TO_DATE(v_clean_str, 'DD-MON');
            v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
            v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
        EXCEPTION
            WHEN OTHERS THEN
                BEGIN
                    v_candidate_date := TO_DATE(v_clean_str, 'DD MON');
                    v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
                    v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
                EXCEPTION
                    WHEN OTHERS THEN
                        BEGIN
                            v_candidate_date := TO_DATE(v_clean_str, 'DD/MM');
                            v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
                            v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
                        EXCEPTION
                            WHEN OTHERS THEN
                                BEGIN
                                    v_candidate_date := TO_DATE(v_clean_str, 'MON DD');
                                    v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
                                    v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        BEGIN
                                            v_candidate_date := TO_DATE(v_clean_str, 'DD MONTH');
                                            v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
                                            v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
                                        EXCEPTION
                                            WHEN OTHERS THEN
                                                BEGIN
                                                    v_candidate_date := TO_DATE(v_clean_str, 'MONTH DD');
                                                    v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
                                                    v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        RETURN NULL;
                                                END;
                                        END;
                                END;
                        END;
                END;
        END;

        -- Step 3: Determine year using day name validation OR sequential logic
        IF v_day_name IS NOT NULL THEN
            -- SMART PATH: Use day name to find correct year
            -- Try current year first
            v_candidate_date := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || v_start_year, 'DD-MM-YYYY');

            IF UPPER(TO_CHAR(v_candidate_date, 'DY')) = UPPER(SUBSTR(v_day_name, 1, 3)) THEN
                v_result := v_candidate_date;
            ELSE
                -- Try next year
                v_candidate_date := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || (v_start_year + 1), 'DD-MM-YYYY');
                IF UPPER(TO_CHAR(v_candidate_date, 'DY')) = UPPER(SUBSTR(v_day_name, 1, 3)) THEN
                    v_result := v_candidate_date;
                ELSE
                    -- Try previous year
                    v_candidate_date := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || (v_start_year - 1), 'DD-MM-YYYY');
                    IF UPPER(TO_CHAR(v_candidate_date, 'DY')) = UPPER(SUBSTR(v_day_name, 1, 3)) THEN
                        v_result := v_candidate_date;
                    ELSE
                        -- Fall back to sequential logic
                        IF v_parsed_mon < v_start_mon THEN
                            v_result := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || (v_start_year + 1), 'DD-MM-YYYY');
                        ELSE
                            v_result := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || v_start_year, 'DD-MM-YYYY');
                        END IF;
                    END IF;
                END IF;
            END IF;
        ELSE
            -- FALLBACK PATH: No day name, use sequential logic
            IF v_parsed_mon < v_start_mon THEN
                v_result := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || (v_start_year + 1), 'DD-MM-YYYY');
            ELSE
                v_result := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || v_start_year, 'DD-MM-YYYY');
            END IF;
        END IF;

        RETURN v_result;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END fn_infer_year;

    -------------------------------------------------------------------------------
    -- initialize_format_library: Build the format library
    -------------------------------------------------------------------------------
    FUNCTION initialize_format_library RETURN t_format_lib IS
        v_formats t_format_lib;
        v_idx PLS_INTEGER := 0;

        PROCEDURE add_format(
            p_mask VARCHAR2, p_cat VARCHAR2, p_year VARCHAR2,
            p_day VARCHAR2, p_mon VARCHAR2, p_amb VARCHAR2, p_alt VARCHAR2 DEFAULT NULL
        ) IS
        BEGIN
            v_idx := v_idx + 1;
            v_formats(v_idx).format_mask := p_mask;
            v_formats(v_idx).category := p_cat;
            v_formats(v_idx).has_year := p_year;
            v_formats(v_idx).has_day_name := p_day;
            v_formats(v_idx).has_month_name := p_mon;
            v_formats(v_idx).is_ambiguous := p_amb;
            v_formats(v_idx).alternate := p_alt;
        END;
    BEGIN
        -- Category 1: ISO formats (highest priority, unambiguous)
        add_format('YYYY-MM-DD"T"HH24:MI:SS"Z"', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY-MM-DD"T"HH24:MI:SS', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY-MM-DD HH24:MI:SS', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY-MM-DD HH24:MI', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY-MM-DD', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYYMMDD', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY/MM/DD', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY.MM.DD', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY MM DD', 'ISO', 'Y', 'N', 'N', 'N');

        -- Category 2: Day name formats (unambiguous)
        add_format('DY DD-MON-YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY DD MON YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY, DD MON YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY, DD-MON-YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY, DD/MM/YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');
        add_format('DAY DD-MON-YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DAY, DD MON YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DAY DD MONTH YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DAY, DD MONTH YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DAY, MONTH DD, YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY, MONTH DD, YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY DD MONTH YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY DD-MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');
        add_format('DY DD MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');
        add_format('DY, DD MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');
        add_format('DAY DD MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');
        add_format('DAY, DD MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');

        -- Category 3: Month name formats (unambiguous)
        add_format('DD MONTH YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MONTH DD, YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MONTH DD YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MONTH-YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MON-YYYY HH24:MI:SS', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MON-YYYY HH:MI:SS AM', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MON-YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD MON YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD/MON/YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD.MON.YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MON DD, YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MON DD YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MON-DD-YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MON-RR', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD MON RR', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MON DD, RR', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        -- YYYY-first month name formats
        add_format('YYYY MONTH DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY, MONTH DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY, DD MONTH', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY-MON-DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY/MON/DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY MON DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');

        -- No-year month name formats
        add_format('DD-MON', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('DD MON', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('DD/MON', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('MON DD', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('MON-DD', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('DD MONTH', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('MONTH DD', 'MONTHNAME', 'N', 'N', 'Y', 'N');

        -- Category 4: Numeric formats WITH year (ambiguous)
        add_format('DD/MM/YYYY HH24:MI:SS', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM/DD/YYYY HH24:MI:SS');
        add_format('DD/MM/YYYY HH:MI:SS AM', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM/DD/YYYY HH:MI:SS AM');
        add_format('DD/MM/YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM/DD/YYYY');
        add_format('MM/DD/YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD/MM/YYYY');
        add_format('DD-MM-YYYY HH24:MI:SS', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM-DD-YYYY HH24:MI:SS');
        add_format('DD-MM-YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM-DD-YYYY');
        add_format('MM-DD-YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD-MM-YYYY');
        add_format('DD.MM.YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM.DD.YYYY');
        add_format('MM.DD.YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD.MM.YYYY');

        -- 2-digit year numeric (DD/MM/YY and MM/DD/YY formats)
        add_format('DD/MM/RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM/DD/RR');
        add_format('MM/DD/RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD/MM/RR');
        add_format('DD-MM-RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM-DD-RR');
        add_format('MM-DD-RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD-MM-RR');
        add_format('DD.MM.RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM.DD.RR');
        -- YY/MM/DD formats (ISO-style with 2-digit year)
        add_format('RR/MM/DD', 'NUMERIC', 'Y', 'N', 'N', 'N');
        add_format('RR-MM-DD', 'NUMERIC', 'Y', 'N', 'N', 'N');
        add_format('RR.MM.DD', 'NUMERIC', 'Y', 'N', 'N', 'N');

        -- No-year numeric (highly ambiguous)
        add_format('DD/MM', 'NUMERIC', 'N', 'N', 'N', 'Y', 'MM/DD');
        add_format('MM/DD', 'NUMERIC', 'N', 'N', 'N', 'Y', 'DD/MM');
        add_format('DD-MM', 'NUMERIC', 'N', 'N', 'N', 'Y', 'MM-DD');
        add_format('DD.MM', 'NUMERIC', 'N', 'N', 'N', 'Y', 'MM.DD');

        RETURN v_formats;
    END initialize_format_library;

    -------------------------------------------------------------------------------
    -- disambiguate_dd_mm: Resolve DD/MM vs MM/DD ambiguity
    -------------------------------------------------------------------------------
    FUNCTION disambiguate_dd_mm(
        p_samples IN CLOB
    ) RETURN VARCHAR2 IS
        v_first_max  NUMBER := 0;
        v_second_max NUMBER := 0;
        v_first_num  NUMBER;
        v_second_num NUMBER;
        v_sample     VARCHAR2(100);
        v_parts      VARCHAR2(100);
    BEGIN
        -- Extract numeric components and find max values
        FOR rec IN (
            SELECT val
            FROM JSON_TABLE(p_samples, '$[*]' COLUMNS (val VARCHAR2(100) PATH '$'))
            WHERE ROWNUM <= 50
        ) LOOP
            -- Extract first two numeric groups
            v_parts := REGEXP_REPLACE(rec.val, '[^0-9]+', ',');
            BEGIN
                v_first_num := TO_NUMBER(REGEXP_SUBSTR(v_parts, '[^,]+', 1, 1));
                v_second_num := TO_NUMBER(REGEXP_SUBSTR(v_parts, '[^,]+', 1, 2));

                IF v_first_num > v_first_max THEN v_first_max := v_first_num; END IF;
                IF v_second_num > v_second_max THEN v_second_max := v_second_num; END IF;
            EXCEPTION
                WHEN OTHERS THEN NULL;
            END;
        END LOOP;

        -- Decision matrix
        IF v_first_max > 12 AND v_second_max <= 12 THEN
            RETURN 'DD_FIRST';  -- European format
        ELSIF v_first_max <= 12 AND v_second_max > 12 THEN
            RETURN 'MM_FIRST';  -- US format
        ELSIF v_first_max > 12 AND v_second_max > 12 THEN
            RETURN 'ERROR';     -- Invalid data
        ELSE
            RETURN 'AMBIGUOUS'; -- Cannot determine, default to European
        END IF;
    END disambiguate_dd_mm;

    -------------------------------------------------------------------------------
    -- detect_date_format: Main detection procedure
    -------------------------------------------------------------------------------
    PROCEDURE detect_date_format(
        p_sample_values    IN  CLOB,
        p_format_mask      OUT VARCHAR2,
        p_confidence       OUT NUMBER,
        p_is_ambiguous     OUT VARCHAR2,
        p_has_year         OUT VARCHAR2,
        p_special_values   OUT VARCHAR2,
        p_all_formats      OUT CLOB,
        p_status           OUT VARCHAR2,
        p_message          OUT VARCHAR2
    ) IS
        v_formats       t_format_lib;
        v_structure     t_date_structure;
        v_results       t_format_results;
        v_sample        VARCHAR2(500);
        v_preprocessed  VARCHAR2(500);
        v_sample_count  NUMBER := 0;
        v_match_count   NUMBER;
        v_best_idx      PLS_INTEGER := 0;
        v_best_score    NUMBER := 0;
        v_dd_mm_result  VARCHAR2(20);
        v_result_idx    PLS_INTEGER := 0;
        v_score         NUMBER;
        v_json          CLOB;
    BEGIN
        p_status := 'S';
        p_confidence := 0;
        p_is_ambiguous := 'N';
        p_has_year := 'Y';

        -- Check for empty input
        IF p_sample_values IS NULL OR LENGTH(p_sample_values) < 3 THEN
            p_status := 'E';
            p_message := 'No sample values provided';
            RETURN;
        END IF;

        -- Detect special values first
        p_special_values := detect_special_values(p_sample_values);

        -- Count samples
        SELECT COUNT(*) INTO v_sample_count
        FROM JSON_TABLE(p_sample_values, '$[*]' COLUMNS (val VARCHAR2(500) PATH '$'))
        WHERE val IS NOT NULL
          AND TRIM(val) IS NOT NULL
          AND UPPER(TRIM(val)) NOT IN ('TODAY','YESTERDAY','TOMORROW','N/A','NA','TBD','NULL','NONE','-');

        IF v_sample_count = 0 THEN
            p_status := 'E';
            p_message := 'No valid date samples found (only special values)';
            RETURN;
        END IF;

        -- Get first sample for structure analysis
        SELECT val INTO v_sample
        FROM JSON_TABLE(p_sample_values, '$[*]' COLUMNS (val VARCHAR2(500) PATH '$'))
        WHERE val IS NOT NULL AND TRIM(val) IS NOT NULL
          AND UPPER(TRIM(val)) NOT IN ('TODAY','YESTERDAY','TOMORROW','N/A','NA','TBD','NULL','NONE','-')
          AND ROWNUM = 1;

        -- Analyze structure
        v_structure := analyze_date_structure(v_sample);

        -- Initialize format library
        v_formats := initialize_format_library;

        -- Test each format against all samples
        FOR i IN 1..v_formats.COUNT LOOP
            v_match_count := 0;

            -- Filter by structure (optimization)
            -- Skip day name formats if no day name detected
            IF v_formats(i).has_day_name = 'Y' AND v_structure.has_day_name = 'N' THEN
                CONTINUE;
            END IF;
            -- Skip month name formats if no month name detected
            IF v_formats(i).has_month_name = 'Y' AND v_structure.has_month_name = 'N' THEN
                CONTINUE;
            END IF;
            -- Skip numeric formats if month name detected
            IF v_formats(i).has_month_name = 'N' AND v_structure.has_month_name = 'Y' THEN
                CONTINUE;
            END IF;

            -- Test against all samples
            FOR rec IN (
                SELECT val
                FROM JSON_TABLE(p_sample_values, '$[*]' COLUMNS (val VARCHAR2(500) PATH '$'))
                WHERE val IS NOT NULL AND TRIM(val) IS NOT NULL
                  AND UPPER(TRIM(val)) NOT IN ('TODAY','YESTERDAY','TOMORROW','N/A','NA','TBD','NULL','NONE','-')
            ) LOOP
                v_preprocessed := preprocess_date_sample(rec.val);

                -- Try direct parse first
                IF fn_try_date(v_preprocessed, v_formats(i).format_mask) IS NOT NULL THEN
                    v_match_count := v_match_count + 1;
                -- If format has no day name but input has one, try stripping day name
                -- This handles cases where DY formats fail due to NLS but base format works
                ELSIF v_formats(i).has_day_name = 'N' AND v_structure.has_day_name = 'Y' THEN
                    IF fn_try_date(strip_day_name(v_preprocessed), v_formats(i).format_mask) IS NOT NULL THEN
                        v_match_count := v_match_count + 1;
                    END IF;
                END IF;
            END LOOP;

            -- Record results for formats with matches
            IF v_match_count > 0 THEN
                v_result_idx := v_result_idx + 1;
                v_results(v_result_idx).format_mask := v_formats(i).format_mask;
                v_results(v_result_idx).match_count := v_match_count;
                v_results(v_result_idx).category := v_formats(i).category;
                v_results(v_result_idx).has_year := v_formats(i).has_year;
                v_results(v_result_idx).is_ambiguous := v_formats(i).is_ambiguous;

                -- Calculate confidence score
                v_score := (v_match_count / v_sample_count) * 100;

                -- Apply modifiers
                IF v_formats(i).category IN ('ISO', 'DAYNAME', 'MONTHNAME') THEN
                    v_score := v_score * 1.15;  -- Bonus for unambiguous
                END IF;
                IF v_formats(i).format_mask LIKE 'YYYY-MM-DD%' THEN
                    v_score := v_score * 1.10;  -- Bonus for ISO
                END IF;
                IF v_formats(i).format_mask LIKE '%RR%' THEN
                    v_score := v_score * 0.90;  -- Penalty for 2-digit year
                END IF;
                IF v_formats(i).has_year = 'N' THEN
                    v_score := v_score * 0.85;  -- Penalty for no year
                END IF;
                IF v_formats(i).is_ambiguous = 'Y' THEN
                    v_score := v_score * 0.80;  -- Penalty for ambiguous
                END IF;

                v_results(v_result_idx).confidence := LEAST(ROUND(v_score, 1), 100);

                -- Track best result
                IF v_results(v_result_idx).confidence > v_best_score THEN
                    v_best_score := v_results(v_result_idx).confidence;
                    v_best_idx := v_result_idx;
                END IF;
            END IF;
        END LOOP;

        -- Check if we found any matches
        IF v_best_idx = 0 THEN
            p_status := 'E';
            p_message := 'No matching date format found for samples';
            RETURN;
        END IF;

        -- Handle DD/MM vs MM/DD ambiguity
        IF v_results(v_best_idx).is_ambiguous = 'Y' THEN
            v_dd_mm_result := disambiguate_dd_mm(p_sample_values);
            IF v_dd_mm_result = 'DD_FIRST' THEN
                p_is_ambiguous := 'N';
                -- Adjust format if needed
                IF v_results(v_best_idx).format_mask LIKE 'MM%' THEN
                    v_results(v_best_idx).format_mask := REPLACE(v_results(v_best_idx).format_mask, 'MM/', 'DD/');
                    v_results(v_best_idx).format_mask := REPLACE(v_results(v_best_idx).format_mask, '/DD/', '/MM/');
                END IF;
            ELSIF v_dd_mm_result = 'MM_FIRST' THEN
                p_is_ambiguous := 'N';
                IF v_results(v_best_idx).format_mask LIKE 'DD%' THEN
                    v_results(v_best_idx).format_mask := REPLACE(v_results(v_best_idx).format_mask, 'DD/', 'MM/');
                    v_results(v_best_idx).format_mask := REPLACE(v_results(v_best_idx).format_mask, '/MM/', '/DD/');
                END IF;
            ELSE
                p_is_ambiguous := 'Y';
            END IF;
        END IF;

        -- Set output values
        p_format_mask := v_results(v_best_idx).format_mask;
        p_confidence := v_results(v_best_idx).confidence;
        p_has_year := v_results(v_best_idx).has_year;

        -- Build JSON array of all formats
        v_json := '[';
        FOR i IN 1..v_result_idx LOOP
            IF i > 1 THEN v_json := v_json || ','; END IF;
            v_json := v_json || '{"format":"' || v_results(i).format_mask ||
                      '","confidence":' || v_results(i).confidence ||
                      ',"category":"' || v_results(i).category ||
                      '","has_year":"' || v_results(i).has_year || '"}';
        END LOOP;
        v_json := v_json || ']';
        p_all_formats := v_json;

        p_message := 'Detected format: ' || p_format_mask ||
                     ' (Confidence: ' || p_confidence || '%)' ||
                     CASE WHEN p_is_ambiguous = 'Y' THEN ' - AMBIGUOUS (defaulting to European DD/MM)' ELSE '' END;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Detection error: ' || SQLERRM;
    END detect_date_format;

    -------------------------------------------------------------------------------
    -- detect_format_simple: Simplified detection returning just format mask
    -------------------------------------------------------------------------------
    FUNCTION detect_format_simple(
        p_sample_values IN CLOB
    ) RETURN VARCHAR2 IS
        v_format      VARCHAR2(100);
        v_confidence  NUMBER;
        v_ambiguous   VARCHAR2(1);
        v_has_year    VARCHAR2(1);
        v_specials    VARCHAR2(500);
        v_all_formats CLOB;
        v_status      VARCHAR2(1);
        v_message     VARCHAR2(4000);
    BEGIN
        detect_date_format(
            p_sample_values  => p_sample_values,
            p_format_mask    => v_format,
            p_confidence     => v_confidence,
            p_is_ambiguous   => v_ambiguous,
            p_has_year       => v_has_year,
            p_special_values => v_specials,
            p_all_formats    => v_all_formats,
            p_status         => v_status,
            p_message        => v_message
        );
        RETURN v_format;
    END detect_format_simple;

    -------------------------------------------------------------------------------
    -- test_preprocessing: Test helper for preprocessing
    -------------------------------------------------------------------------------
    PROCEDURE test_preprocessing(
        p_input  IN  VARCHAR2,
        p_output OUT VARCHAR2
    ) IS
    BEGIN
        p_output := preprocess_date_sample(p_input);
    END test_preprocessing;

    -------------------------------------------------------------------------------
    -- test_all_formats: Test a sample against all formats
    -------------------------------------------------------------------------------
    PROCEDURE test_all_formats(
        p_sample IN VARCHAR2
    ) IS
        v_formats      t_format_lib;
        v_preprocessed VARCHAR2(500);
        v_date         DATE;
        v_structure    t_date_structure;
    BEGIN
        v_preprocessed := preprocess_date_sample(p_sample);
        v_structure := analyze_date_structure(p_sample);
        v_formats := initialize_format_library;

        DBMS_OUTPUT.PUT_LINE('=== Testing: ' || p_sample || ' ===');
        DBMS_OUTPUT.PUT_LINE('Preprocessed: ' || v_preprocessed);
        DBMS_OUTPUT.PUT_LINE('Structure:');
        DBMS_OUTPUT.PUT_LINE('  Day Name: ' || v_structure.has_day_name);
        DBMS_OUTPUT.PUT_LINE('  Month Name: ' || v_structure.has_month_name);
        DBMS_OUTPUT.PUT_LINE('  4-digit Year: ' || v_structure.has_4digit_year);
        DBMS_OUTPUT.PUT_LINE('  Text Numbers: ' || v_structure.has_text_numbers);
        DBMS_OUTPUT.PUT_LINE('  Separators: ' || v_structure.separators);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Matching formats:');

        FOR i IN 1..v_formats.COUNT LOOP
            v_date := fn_try_date(v_preprocessed, v_formats(i).format_mask);
            IF v_date IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('  ' || RPAD(v_formats(i).format_mask, 30) ||
                                    ' -> ' || TO_CHAR(v_date, 'YYYY-MM-DD') ||
                                    ' (' || v_formats(i).category || ')');
            END IF;
        END LOOP;
    END test_all_formats;

    -------------------------------------------------------------------------------
    -- run_test_suite: Run comprehensive test suite
    -------------------------------------------------------------------------------
    PROCEDURE run_test_suite IS
        v_format      VARCHAR2(100);
        v_confidence  NUMBER;
        v_ambiguous   VARCHAR2(1);
        v_has_year    VARCHAR2(1);
        v_specials    VARCHAR2(500);
        v_all_formats CLOB;
        v_status      VARCHAR2(1);
        v_message     VARCHAR2(4000);
        v_inferred    DATE;

        PROCEDURE test_detect(p_name VARCHAR2, p_samples CLOB) IS
        BEGIN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('--- Test: ' || p_name || ' ---');
            detect_date_format(p_samples, v_format, v_confidence, v_ambiguous,
                              v_has_year, v_specials, v_all_formats, v_status, v_message);
            IF v_status = 'S' THEN
                DBMS_OUTPUT.PUT_LINE('Format: ' || v_format);
                DBMS_OUTPUT.PUT_LINE('Confidence: ' || v_confidence || '%');
                DBMS_OUTPUT.PUT_LINE('Ambiguous: ' || v_ambiguous);
                DBMS_OUTPUT.PUT_LINE('Has Year: ' || v_has_year);
                IF v_specials IS NOT NULL THEN
                    DBMS_OUTPUT.PUT_LINE('Special Values: ' || v_specials);
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('ERROR: ' || v_message);
            END IF;
        END;

        PROCEDURE test_preprocess(p_input VARCHAR2, p_expected VARCHAR2) IS
            v_result VARCHAR2(500);
        BEGIN
            v_result := preprocess_date_sample(p_input);
            DBMS_OUTPUT.PUT_LINE(RPAD(p_input, 40) || ' -> ' || v_result ||
                                CASE WHEN v_result = p_expected THEN ' [OK]' ELSE ' [FAIL: expected ' || p_expected || ']' END);
        END;

    BEGIN
        DBMS_OUTPUT.PUT_LINE('================================================================================');
        DBMS_OUTPUT.PUT_LINE('  UR_DATE_PARSER_TEST - Test Suite');
        DBMS_OUTPUT.PUT_LINE('================================================================================');

        -- Test 1: Preprocessing
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== PREPROCESSING TESTS ===');
        test_preprocess('sixteen November', '16 November');
        test_preprocess('November twenty-first', 'November 21');
        test_preprocess('the twenty-first of November, 2024', '21 November, 2024');
        test_preprocess('Friday, November sixteenth', 'Friday, November 16');
        test_preprocess('twenty-seven Nov 2024', '27 Nov 2024');
        test_preprocess('first January 2025', '1 January 2025');
        test_preprocess('the third of March', '3 March');
        test_preprocess('thirty-one December', '31 December');
        test_preprocess('27th Nov 2024', '27 Nov 2024');
        test_preprocess('1st January', '1 January');

        -- Test 2: Format Detection
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== FORMAT DETECTION TESTS ===');

        test_detect('ISO Format', '["2024-11-27", "2024-12-15", "2025-01-01"]');
        test_detect('Oracle Standard', '["27-Nov-2024", "15-Dec-2024", "01-Jan-2025"]');
        test_detect('European Numeric', '["27/11/2024", "15/12/2024", "01/01/2025"]');
        test_detect('Day Name Format', '["Fri 27-Nov-2024", "Sun 15-Dec-2024", "Wed 01-Jan-2025"]');
        test_detect('Full Month Name', '["27 November 2024", "15 December 2024", "01 January 2025"]');
        test_detect('No Year', '["27-Nov", "15-Dec", "01-Jan"]');
        test_detect('Text Numbers', '["sixteen November", "twenty-first December", "first January"]');
        test_detect('With Special Values', '["27-Nov-2024", "TODAY", "N/A", "15-Dec-2024"]');
        test_detect('US Disambiguated', '["12/27/2024", "12/15/2024", "01/05/2025"]');  -- Second value > 12
        test_detect('Ambiguous', '["01/02/2024", "05/06/2024", "08/09/2024"]');  -- All <= 12

        -- Test 3: Year Inference
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== YEAR INFERENCE TESTS ===');
        DBMS_OUTPUT.PUT_LINE('Start Date: 2024-11-15');

        v_inferred := fn_infer_year('Fri 15 Nov', '2024-11-15');
        DBMS_OUTPUT.PUT_LINE('Fri 15 Nov -> ' || NVL(TO_CHAR(v_inferred, 'DY DD-MON-YYYY'), 'NULL'));

        v_inferred := fn_infer_year('Wed 01 Jan', '2024-11-15');
        DBMS_OUTPUT.PUT_LINE('Wed 01 Jan -> ' || NVL(TO_CHAR(v_inferred, 'DY DD-MON-YYYY'), 'NULL'));

        v_inferred := fn_infer_year('15 Nov', '2024-11-15');
        DBMS_OUTPUT.PUT_LINE('15 Nov -> ' || NVL(TO_CHAR(v_inferred, 'DY DD-MON-YYYY'), 'NULL'));

        v_inferred := fn_infer_year('01 Jan', '2024-11-15');
        DBMS_OUTPUT.PUT_LINE('01 Jan -> ' || NVL(TO_CHAR(v_inferred, 'DY DD-MON-YYYY'), 'NULL'));

        v_inferred := fn_infer_year('Friday twenty-first November', '2024-11-15');
        DBMS_OUTPUT.PUT_LINE('Friday twenty-first November -> ' || NVL(TO_CHAR(v_inferred, 'DY DD-MON-YYYY'), 'NULL'));

        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('================================================================================');
        DBMS_OUTPUT.PUT_LINE('  Test Suite Complete');
        DBMS_OUTPUT.PUT_LINE('================================================================================');

    END run_test_suite;

END ur_date_parser_test;
/

-- Show any compilation errors
SHOW ERRORS PACKAGE ur_date_parser_test;
SHOW ERRORS PACKAGE BODY ur_date_parser_test;

-- Quick verification
PROMPT
PROMPT === Quick Verification ===
PROMPT

SELECT ur_date_parser_test.preprocess_date_sample('the twenty-first of November') AS preprocessed FROM dual;
SELECT ur_date_parser_test.fn_try_date('27-Nov-2024', 'DD-MON-YYYY') AS parsed_date FROM dual;
SELECT ur_date_parser_test.detect_format_simple('["27-Nov-2024", "15-Dec-2024"]') AS detected_format FROM dual;

PROMPT
PROMPT Package created successfully. Run the test suite with:
PROMPT   SET SERVEROUTPUT ON SIZE UNLIMITED
PROMPT   EXEC ur_date_parser_test.run_test_suite;
PROMPT
PROMPT Or test individual functions:
PROMPT   SELECT ur_date_parser_test.preprocess_date_sample('sixteen November') FROM dual;
PROMPT   SELECT ur_date_parser_test.detect_format_simple('["27-Nov-2024", "15-Dec-2024"]') FROM dual;
PROMPT
