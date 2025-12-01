/*
================================================================================
  QUICK DATE TESTING UTILITY
================================================================================
  Usage: Run this script and modify the dates in the test section at the bottom.

  Two ways to test:
  1. Single date: Test preprocessing and format detection
  2. Multiple dates: Test format detection with sample array
================================================================================
*/

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

-- Quick test procedure for a single date string
CREATE OR REPLACE PROCEDURE test_single_date(p_date_str VARCHAR2) IS
    v_preprocessed VARCHAR2(500);
    v_format       VARCHAR2(100);
    v_confidence   NUMBER;
    v_is_ambiguous VARCHAR2(1);
    v_has_year     VARCHAR2(1);
    v_specials     VARCHAR2(500);
    v_all_formats  CLOB;
    v_status       VARCHAR2(1);
    v_message      VARCHAR2(4000);
    v_parsed_date  DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
    DBMS_OUTPUT.PUT_LINE('INPUT: "' || p_date_str || '"');
    DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');

    -- Step 1: Preprocess
    v_preprocessed := ur_date_parser_test.preprocess_date_sample(p_date_str);
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('1. PREPROCESSED: "' || v_preprocessed || '"');

    -- Step 2: Detect format (use preprocessed string for detection)
    ur_date_parser_test.detect_date_format(
        p_sample_values  => '["' || v_preprocessed || '"]',
        p_format_mask    => v_format,
        p_confidence     => v_confidence,
        p_is_ambiguous   => v_is_ambiguous,
        p_has_year       => v_has_year,
        p_special_values => v_specials,
        p_all_formats    => v_all_formats,
        p_status         => v_status,
        p_message        => v_message
    );

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('2. FORMAT DETECTION:');
    IF v_status = 'S' THEN
        DBMS_OUTPUT.PUT_LINE('   Format Mask:  ' || v_format);
        DBMS_OUTPUT.PUT_LINE('   Confidence:   ' || v_confidence || '%');
        DBMS_OUTPUT.PUT_LINE('   Has Year:     ' || v_has_year);
        DBMS_OUTPUT.PUT_LINE('   Ambiguous:    ' || v_is_ambiguous);

        -- Step 3: Parse the date
        -- Check if input has a day name (for year inference when no year in format)
        DECLARE
            v_has_day_name BOOLEAN;
            v_day_name     VARCHAR2(20);
            v_stripped     VARCHAR2(500);
            v_inferred     DATE;
            v_used_inference BOOLEAN := FALSE;
        BEGIN
            v_has_day_name := REGEXP_LIKE(v_preprocessed, '(^|[^a-zA-Z])(Mon|Tue|Wed|Thu|Fri|Sat|Sun|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)([^a-zA-Z]|$)', 'i');

            IF v_has_day_name THEN
                -- Extract the day name for display
                v_day_name := REGEXP_SUBSTR(v_preprocessed, '(Mon|Tue|Wed|Thu|Fri|Sat|Sun|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)', 1, 1, 'i');
            END IF;

            -- First try direct parsing with detected format
            v_parsed_date := ur_date_parser_test.fn_try_date(v_preprocessed, v_format);

            -- If parse failed and has day name, try stripping day name
            IF v_parsed_date IS NULL AND v_has_day_name THEN
                v_stripped := REGEXP_REPLACE(v_preprocessed, '(^|[^a-zA-Z])(Mon|Tue|Wed|Thu|Fri|Sat|Sun|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)([^a-zA-Z]|$)', '\1\3', 1, 0, 'i');
                v_stripped := REGEXP_REPLACE(v_stripped, '^\s*,?\s*', '');
                v_stripped := TRIM(v_stripped);

                v_parsed_date := ur_date_parser_test.fn_try_date(v_stripped, v_format);
            END IF;

            -- If format has no year AND we have a day name, use fn_infer_year for smart year detection
            IF v_has_year = 'N' AND v_has_day_name THEN
                v_inferred := ur_date_parser_test.fn_infer_year(
                    p_date_str   => p_date_str,
                    p_start_date => TO_CHAR(SYSDATE, 'YYYY-MM-DD')
                );
                IF v_inferred IS NOT NULL THEN
                    v_parsed_date := v_inferred;
                    v_used_inference := TRUE;
                END IF;
            -- If format has no year but no day name, use simple year inference (sequential logic)
            ELSIF v_has_year = 'N' AND v_parsed_date IS NOT NULL THEN
                v_inferred := ur_date_parser_test.fn_infer_year(
                    p_date_str   => p_date_str,
                    p_start_date => TO_CHAR(SYSDATE, 'YYYY-MM-DD')
                );
                IF v_inferred IS NOT NULL THEN
                    v_parsed_date := v_inferred;
                    v_used_inference := TRUE;
                END IF;
            END IF;

            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('3. PARSED DATE:');
            IF v_parsed_date IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('   Result:       ' || TO_CHAR(v_parsed_date, 'YYYY-MM-DD'));
                DBMS_OUTPUT.PUT_LINE('   Day Name:     ' || TO_CHAR(v_parsed_date, 'Day'));
                DBMS_OUTPUT.PUT_LINE('   Full Format:  ' || TO_CHAR(v_parsed_date, 'Day, DD Month YYYY'));
                IF v_used_inference THEN
                    IF v_has_day_name THEN
                        DBMS_OUTPUT.PUT_LINE('   (Year inferred using day name "' || v_day_name || '" validation)');
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('   (Year inferred using sequential logic)');
                    END IF;
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('   *** Could not parse with detected format ***');
            END IF;
        END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('   Status: ERROR');
        DBMS_OUTPUT.PUT_LINE('   Message: ' || v_message);
    END IF;

    IF v_specials IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('   Special Values Detected: ' || v_specials);
    END IF;

    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Quick test for multiple dates (batch format detection)
CREATE OR REPLACE PROCEDURE test_date_batch(p_dates_json CLOB) IS
    v_format       VARCHAR2(100);
    v_confidence   NUMBER;
    v_is_ambiguous VARCHAR2(1);
    v_has_year     VARCHAR2(1);
    v_specials     VARCHAR2(500);
    v_all_formats  CLOB;
    v_status       VARCHAR2(1);
    v_message      VARCHAR2(4000);
BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
    DBMS_OUTPUT.PUT_LINE('BATCH FORMAT DETECTION');
    DBMS_OUTPUT.PUT_LINE('═══════════════════════════════════════════════════════════════');
    DBMS_OUTPUT.PUT_LINE('Input: ' || SUBSTR(p_dates_json, 1, 200));

    ur_date_parser_test.detect_date_format(
        p_sample_values  => p_dates_json,
        p_format_mask    => v_format,
        p_confidence     => v_confidence,
        p_is_ambiguous   => v_is_ambiguous,
        p_has_year       => v_has_year,
        p_special_values => v_specials,
        p_all_formats    => v_all_formats,
        p_status         => v_status,
        p_message        => v_message
    );

    DBMS_OUTPUT.PUT_LINE('');
    IF v_status = 'S' THEN
        DBMS_OUTPUT.PUT_LINE('RESULT:');
        DBMS_OUTPUT.PUT_LINE('  Format Mask:  ' || v_format);
        DBMS_OUTPUT.PUT_LINE('  Confidence:   ' || v_confidence || '%');
        DBMS_OUTPUT.PUT_LINE('  Has Year:     ' || v_has_year);
        DBMS_OUTPUT.PUT_LINE('  Ambiguous:    ' || v_is_ambiguous);
        IF v_specials IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('  Specials:     ' || v_specials);
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || v_message);
    END IF;
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Quick single-line conversion test
CREATE OR REPLACE FUNCTION quick_date_convert(
    p_date_str IN VARCHAR2,
    p_format   IN VARCHAR2 DEFAULT NULL
) RETURN VARCHAR2 IS
    v_format       VARCHAR2(100) := p_format;
    v_preprocessed VARCHAR2(500);
    v_parsed_date  DATE;
    v_confidence   NUMBER;
    v_is_ambiguous VARCHAR2(1);
    v_has_year     VARCHAR2(1);
    v_specials     VARCHAR2(500);
    v_all_formats  CLOB;
    v_status       VARCHAR2(1);
    v_message      VARCHAR2(4000);
    v_has_day_name BOOLEAN;
    v_stripped     VARCHAR2(500);
    v_inferred     DATE;
    v_note         VARCHAR2(100) := '';
BEGIN
    -- Preprocess
    v_preprocessed := ur_date_parser_test.preprocess_date_sample(p_date_str);

    -- Check if input has a day name
    v_has_day_name := REGEXP_LIKE(v_preprocessed, '(^|[^a-zA-Z])(Mon|Tue|Wed|Thu|Fri|Sat|Sun|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)([^a-zA-Z]|$)', 'i');

    -- Auto-detect format if not provided
    -- Use preprocessed string for detection (day names normalized, parenthetical removed, etc.)
    IF v_format IS NULL THEN
        ur_date_parser_test.detect_date_format(
            p_sample_values  => '["' || v_preprocessed || '"]',
            p_format_mask    => v_format,
            p_confidence     => v_confidence,
            p_is_ambiguous   => v_is_ambiguous,
            p_has_year       => v_has_year,
            p_special_values => v_specials,
            p_all_formats    => v_all_formats,
            p_status         => v_status,
            p_message        => v_message
        );

        IF v_status != 'S' THEN
            RETURN 'ERROR: ' || v_message;
        END IF;
    ELSE
        -- If format provided, determine if it has year
        IF v_format LIKE '%YYYY%' OR v_format LIKE '%YY%' OR v_format LIKE '%RR%' THEN
            v_has_year := 'Y';
        ELSE
            v_has_year := 'N';
        END IF;
    END IF;

    -- Try to parse directly
    v_parsed_date := ur_date_parser_test.fn_try_date(v_preprocessed, v_format);

    -- If parse failed and has day name, try stripping day name
    IF v_parsed_date IS NULL AND v_has_day_name THEN
        v_stripped := REGEXP_REPLACE(v_preprocessed, '(^|[^a-zA-Z])(Mon|Tue|Wed|Thu|Fri|Sat|Sun|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)([^a-zA-Z]|$)', '\1\3', 1, 0, 'i');
        v_stripped := REGEXP_REPLACE(v_stripped, '^\s*,?\s*', '');
        v_stripped := TRIM(v_stripped);

        v_parsed_date := ur_date_parser_test.fn_try_date(v_stripped, v_format);
    END IF;

    -- If format has no year, use fn_infer_year for smart year inference
    IF v_has_year = 'N' THEN
        v_inferred := ur_date_parser_test.fn_infer_year(
            p_date_str   => p_date_str,
            p_start_date => TO_CHAR(SYSDATE, 'YYYY-MM-DD')
        );
        IF v_inferred IS NOT NULL THEN
            v_parsed_date := v_inferred;
            IF v_has_day_name THEN
                v_note := ' [year inferred via day name]';
            ELSE
                v_note := ' [year inferred]';
            END IF;
        END IF;
    END IF;

    IF v_parsed_date IS NOT NULL THEN
        RETURN TO_CHAR(v_parsed_date, 'YYYY-MM-DD') || ' (format: ' || v_format || v_note || ')';
    END IF;

    -- Try original string as fallback
    v_parsed_date := ur_date_parser_test.fn_try_date(p_date_str, v_format);
    IF v_parsed_date IS NOT NULL THEN
        RETURN TO_CHAR(v_parsed_date, 'YYYY-MM-DD') || ' (format: ' || v_format || ')';
    END IF;

    RETURN 'PARSE FAILED (detected format: ' || v_format || ')';
END;
/

SHOW ERRORS

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════════════
PROMPT   QUICK DATE TESTING UTILITIES CREATED
PROMPT ════════════════════════════════════════════════════════════════════════════════
PROMPT
PROMPT   Usage Examples:
PROMPT
PROMPT   1. Test a single date (detailed output):
PROMPT      EXEC test_single_date('27-Nov-2024');
PROMPT      EXEC test_single_date('Fri 15 Nov');
PROMPT      EXEC test_single_date('the twenty-first of December');
PROMPT
PROMPT   2. Quick conversion (single line result):
PROMPT      SELECT quick_date_convert('27/11/2024') FROM dual;
PROMPT      SELECT quick_date_convert('Nov 15, 2024') FROM dual;
PROMPT      SELECT quick_date_convert('twenty-first December 2024') FROM dual;
PROMPT
PROMPT   3. Batch format detection:
PROMPT      EXEC test_date_batch('["27-Nov-2024", "15-Dec-2024", "01-Jan-2025"]');
PROMPT      EXEC test_date_batch('["27/11/2024", "15/12/2024", "31/01/2025"]');
PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════════════
PROMPT

-- ================================================================================
-- TEST YOUR DATES HERE - Modify these examples:
-- ================================================================================

PROMPT
PROMPT Running sample tests...
PROMPT

-- ================================================================================
-- COMPREHENSIVE DATE FORMAT TESTS (50 variations)
-- All dates represent November 27, 2026 (a Thursday)
-- ================================================================================

PROMPT
PROMPT === STANDARD NUMERIC FORMATS ===
EXEC test_single_date('27/11/2026');
EXEC test_single_date('27-11-2026');
EXEC test_single_date('27.11.2026');
EXEC test_single_date('11/27/2026');
EXEC test_single_date('11-27-2026');
EXEC test_single_date('11.27.2026');

PROMPT
PROMPT === ISO FORMATS ===
EXEC test_single_date('2026/11/27');
EXEC test_single_date('2026-11-27');
EXEC test_single_date('2026.11.27');
EXEC test_single_date('2026 11 27');

PROMPT
PROMPT === MONTH NAME FORMATS (Short) ===
EXEC test_single_date('27-NOV-2026');
EXEC test_single_date('27.NOV.2026');
EXEC test_single_date('27/Nov/2026');
EXEC test_single_date('NOV 27, 2026');
EXEC test_single_date('Nov 27 2026');
EXEC test_single_date('Nov/27/2026');
EXEC test_single_date('2026-Nov-27');
EXEC test_single_date('2026/Nov/27');

PROMPT
PROMPT === MONTH NAME FORMATS (Full) ===
EXEC test_single_date('November 27, 2026');
EXEC test_single_date('27 November 2026');
EXEC test_single_date('27 November, 2026');
EXEC test_single_date('November 27 2026');
EXEC test_single_date('27-November-2026');
EXEC test_single_date('November-27-2026');
EXEC test_single_date('November/27/2026');
EXEC test_single_date('2026 November 27');
EXEC test_single_date('2026, November 27');
EXEC test_single_date('2026, 27 November');

PROMPT
PROMPT === 2-DIGIT YEAR FORMATS ===
EXEC test_single_date('27/11/26');
EXEC test_single_date('11/27/26');
EXEC test_single_date('26/11/27');
EXEC test_single_date('27 November, 26');

PROMPT
PROMPT === ORDINAL FORMATS ===
EXEC test_single_date('27th of November, 2026');
EXEC test_single_date('November 27th, 2026');
EXEC test_single_date('27th November, 2026');
EXEC test_single_date('27th November 2026');
EXEC test_single_date('27th-Nov-2026');
EXEC test_single_date('27th of Nov, 2026');

PROMPT
PROMPT === DAY NAME FORMATS (Short - Oracle uses 3-letter: Mon, Tue, Wed, Thu, Fri, Sat, Sun) ===
EXEC test_single_date('Thu, 27/11/2026');
EXEC test_single_date('Thu, 27-NOV-2026');
EXEC test_single_date('Thu 27 November 2026');
EXEC test_single_date('Thu 27th Nov 2026');

PROMPT
PROMPT === DAY NAME FORMATS (Full) ===
EXEC test_single_date('Thursday, 27 November 2026');
EXEC test_single_date('Thu, November 27, 2026');
EXEC test_single_date('Thu, November 27th, 2026');

PROMPT
PROMPT === SPACE-SEPARATED FORMATS ===
EXEC test_single_date('27 11 2026');

PROMPT
PROMPT === UNUSUAL/EDGE CASE FORMATS ===
EXEC test_single_date('27/11/2026 AD');
EXEC test_single_date('AD 2026-11-27');
EXEC test_single_date('27/11/2026 - Thursday');
EXEC test_single_date('27-11-2026 (Weekday: Thurs)');

PROMPT
PROMPT === DAY NAME BEFORE DATE (decorative) ===
EXEC test_single_date('Thursday 27/11/2026');
EXEC test_single_date('Thursday, 27/11/2026');
EXEC test_single_date('Thursday - 27/11/2026');
EXEC test_single_date('Thurs 27-11-2026');
EXEC test_single_date('Thu 27-Nov-2026');

PROMPT
PROMPT ════════════════════════════════════════════════════════════════════════════════
PROMPT   TEST COMPLETE - Review results above
PROMPT ════════════════════════════════════════════════════════════════════════════════
PROMPT
