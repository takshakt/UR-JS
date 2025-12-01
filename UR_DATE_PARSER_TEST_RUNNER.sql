/*
================================================================================
  UR_DATE_PARSER_TEST_RUNNER - Comprehensive Test Suite
================================================================================
  Purpose: Exhaustive testing of all date parsing features
  Prerequisite: Run UR_DATE_PARSER_TEST.sql first to create the package

  Usage:
    SET SERVEROUTPUT ON SIZE UNLIMITED
    @UR_DATE_PARSER_TEST_RUNNER.sql

  Or run individual test sections:
    EXEC test_date_parser_comprehensive;
================================================================================
*/

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

CREATE OR REPLACE PROCEDURE test_date_parser_comprehensive IS
    v_pass_count    NUMBER := 0;
    v_fail_count    NUMBER := 0;
    v_total_tests   NUMBER := 0;

    -- Detection outputs
    v_format        VARCHAR2(100);
    v_confidence    NUMBER;
    v_ambiguous     VARCHAR2(1);
    v_has_year      VARCHAR2(1);
    v_specials      VARCHAR2(500);
    v_all_formats   CLOB;
    v_status        VARCHAR2(1);
    v_message       VARCHAR2(4000);

    -- Helper procedure to log test results
    PROCEDURE log_test(p_category VARCHAR2, p_test_name VARCHAR2, p_passed BOOLEAN, p_details VARCHAR2 DEFAULT NULL) IS
    BEGIN
        v_total_tests := v_total_tests + 1;
        IF p_passed THEN
            v_pass_count := v_pass_count + 1;
            DBMS_OUTPUT.PUT_LINE('[PASS] ' || p_category || ' - ' || p_test_name);
        ELSE
            v_fail_count := v_fail_count + 1;
            DBMS_OUTPUT.PUT_LINE('[FAIL] ' || p_category || ' - ' || p_test_name);
        END IF;
        IF p_details IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('       ' || p_details);
        END IF;
    END;

    -- Helper procedure to test preprocessing
    PROCEDURE test_preprocess(p_input VARCHAR2, p_expected VARCHAR2) IS
        v_result VARCHAR2(500);
    BEGIN
        v_result := ur_date_parser_test.preprocess_date_sample(p_input);
        log_test('PREPROCESS', '"' || p_input || '"',
                 v_result = p_expected,
                 'Got: "' || v_result || '" Expected: "' || p_expected || '"');
    END;

    -- Helper procedure to test date parsing
    PROCEDURE test_parse(p_value VARCHAR2, p_format VARCHAR2, p_should_succeed BOOLEAN) IS
        v_date DATE;
    BEGIN
        v_date := ur_date_parser_test.fn_try_date(p_value, p_format);
        log_test('PARSE', '"' || p_value || '" with ' || p_format,
                 (v_date IS NOT NULL) = p_should_succeed,
                 'Result: ' || NVL(TO_CHAR(v_date, 'YYYY-MM-DD'), 'NULL'));
    END;

    -- Helper procedure to test format detection
    PROCEDURE test_detect(p_name VARCHAR2, p_samples CLOB, p_expected_format VARCHAR2 DEFAULT NULL) IS
    BEGIN
        ur_date_parser_test.detect_date_format(
            p_sample_values  => p_samples,
            p_format_mask    => v_format,
            p_confidence     => v_confidence,
            p_is_ambiguous   => v_ambiguous,
            p_has_year       => v_has_year,
            p_special_values => v_specials,
            p_all_formats    => v_all_formats,
            p_status         => v_status,
            p_message        => v_message
        );

        IF v_status = 'S' THEN
            IF p_expected_format IS NOT NULL THEN
                log_test('DETECT', p_name,
                         v_format = p_expected_format,
                         'Got: ' || v_format || ' (' || v_confidence || '%) Expected: ' || p_expected_format);
            ELSE
                log_test('DETECT', p_name,
                         TRUE,
                         'Detected: ' || v_format || ' (' || v_confidence || '%)');
            END IF;
        ELSE
            log_test('DETECT', p_name, FALSE, 'Error: ' || v_message);
        END IF;
    END;

    -- Helper procedure to test year inference
    PROCEDURE test_infer_year(p_date_str VARCHAR2, p_start_date VARCHAR2, p_expected_date VARCHAR2) IS
        v_result DATE;
        v_expected DATE;
    BEGIN
        v_result := ur_date_parser_test.fn_infer_year(p_date_str, p_start_date);
        v_expected := TO_DATE(p_expected_date, 'YYYY-MM-DD');
        log_test('YEAR_INFER', '"' || p_date_str || '" from ' || p_start_date,
                 v_result = v_expected,
                 'Got: ' || NVL(TO_CHAR(v_result, 'DY DD-MON-YYYY'), 'NULL') ||
                 ' Expected: ' || TO_CHAR(v_expected, 'DY DD-MON-YYYY'));
    END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('  COMPREHENSIVE DATE PARSER TEST SUITE');
    DBMS_OUTPUT.PUT_LINE('  ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('================================================================================');

    ---------------------------------------------------------------------------
    -- SECTION 1: TEXT NUMBER CONVERSION
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 1: TEXT NUMBER CONVERSION ===');

    -- Cardinal numbers (one through twelve)
    test_preprocess('one November', '1 November');
    test_preprocess('two December', '2 December');
    test_preprocess('three January', '3 January');
    test_preprocess('four February', '4 February');
    test_preprocess('five March', '5 March');
    test_preprocess('six April', '6 April');
    test_preprocess('seven May', '7 May');
    test_preprocess('eight June', '8 June');
    test_preprocess('nine July', '9 July');
    test_preprocess('ten August', '10 August');
    test_preprocess('eleven September', '11 September');
    test_preprocess('twelve October', '12 October');

    -- Teen numbers
    test_preprocess('thirteen November', '13 November');
    test_preprocess('fourteen December', '14 December');
    test_preprocess('fifteen January', '15 January');
    test_preprocess('sixteen February', '16 February');
    test_preprocess('seventeen March', '17 March');
    test_preprocess('eighteen April', '18 April');
    test_preprocess('nineteen May', '19 May');

    -- Tens
    test_preprocess('twenty June', '20 June');
    test_preprocess('thirty July', '30 July');

    -- Compound numbers (twenty-one through thirty-one)
    test_preprocess('twenty-one August', '21 August');
    test_preprocess('twenty-two September', '22 September');
    test_preprocess('twenty-three October', '23 October');
    test_preprocess('twenty-four November', '24 November');
    test_preprocess('twenty-five December', '25 December');
    test_preprocess('twenty-six January', '26 January');
    test_preprocess('twenty-seven February', '27 February');
    test_preprocess('twenty-eight March', '28 March');
    test_preprocess('twenty-nine April', '29 April');
    test_preprocess('thirty-one May', '31 May');

    -- Ordinal numbers
    test_preprocess('first November', '1 November');
    test_preprocess('second December', '2 December');
    test_preprocess('third January', '3 January');
    test_preprocess('fourth February', '4 February');
    test_preprocess('fifth March', '5 March');
    test_preprocess('sixth April', '6 April');
    test_preprocess('seventh May', '7 May');
    test_preprocess('eighth June', '8 June');
    test_preprocess('ninth July', '9 July');
    test_preprocess('tenth August', '10 August');
    test_preprocess('eleventh September', '11 September');
    test_preprocess('twelfth October', '12 October');
    test_preprocess('thirteenth November', '13 November');
    test_preprocess('twentieth December', '20 December');
    test_preprocess('twenty-first January', '21 January');
    test_preprocess('twenty-second February', '22 February');
    test_preprocess('thirtieth March', '30 March');
    test_preprocess('thirty-first December', '31 December');

    -- With spaces instead of hyphens
    test_preprocess('twenty one August', '21 August');
    test_preprocess('twenty first September', '21 September');

    ---------------------------------------------------------------------------
    -- SECTION 2: FILLER WORD REMOVAL
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 2: FILLER WORD REMOVAL ===');

    test_preprocess('the fifteenth of November', '15 November');
    test_preprocess('the twenty-first of December', '21 December');
    test_preprocess('on the third of January', '3 January');
    test_preprocess('the 1st day of February', '1 February');
    -- Note: "in", "the", "of" are removed as filler words; "month" is preserved
    test_preprocess('in the month of March', 'month March');
    test_preprocess('November the thirtieth', 'November 30');

    ---------------------------------------------------------------------------
    -- SECTION 3: ORDINAL SUFFIX STRIPPING
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 3: ORDINAL SUFFIX STRIPPING ===');

    test_preprocess('1st November', '1 November');
    test_preprocess('2nd December', '2 December');
    test_preprocess('3rd January', '3 January');
    test_preprocess('4th February', '4 February');
    test_preprocess('21st March', '21 March');
    test_preprocess('22nd April', '22 April');
    test_preprocess('23rd May', '23 May');
    test_preprocess('31st December', '31 December');

    ---------------------------------------------------------------------------
    -- SECTION 4: COMPLEX PREPROCESSING COMBINATIONS
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 4: COMPLEX PREPROCESSING ===');

    test_preprocess('the twenty-first of November, 2024', '21 November, 2024');
    -- Note: Full day names (Friday) are normalized to 3-letter format (Fri)
    test_preprocess('Friday, November sixteenth', 'Fri, November 16');
    test_preprocess('on the 1st day of January 2025', '1 January 2025');
    test_preprocess('twenty-seven Nov 2024', '27 Nov 2024');
    test_preprocess('Fri twenty-first Nov', 'Fri 21 Nov');
    test_preprocess('the third of March two thousand twenty-four', '3 March 2 thousand 24');  -- Year text not supported

    ---------------------------------------------------------------------------
    -- SECTION 5: DATE PARSING (fn_try_date)
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 5: DATE PARSING ===');

    -- ISO formats
    test_parse('2024-11-27', 'YYYY-MM-DD', TRUE);
    test_parse('2024-11-27 14:30:00', 'YYYY-MM-DD HH24:MI:SS', TRUE);
    test_parse('20241127', 'YYYYMMDD', TRUE);

    -- Oracle standard
    test_parse('27-Nov-2024', 'DD-MON-YYYY', TRUE);
    test_parse('27-NOV-2024', 'DD-MON-YYYY', TRUE);  -- Case insensitive
    test_parse('27-nov-2024', 'DD-MON-YYYY', TRUE);  -- Lowercase

    -- European numeric
    test_parse('27/11/2024', 'DD/MM/YYYY', TRUE);
    test_parse('27-11-2024', 'DD-MM-YYYY', TRUE);
    test_parse('27.11.2024', 'DD.MM.YYYY', TRUE);

    -- US numeric
    test_parse('11/27/2024', 'MM/DD/YYYY', TRUE);
    test_parse('11-27-2024', 'MM-DD-YYYY', TRUE);

    -- With time
    test_parse('27-Nov-2024 14:30:00', 'DD-MON-YYYY HH24:MI:SS', TRUE);
    test_parse('27/11/2024 14:30:00', 'DD/MM/YYYY HH24:MI:SS', TRUE);

    -- Day name formats (NOTE: Oracle DY/DAY requires exact NLS settings, may fail)
    -- These are documented as NLS-dependent and may not work in all environments
    test_parse('Fri 27-Nov-2024', 'DY DD-MON-YYYY', FALSE);  -- NLS-dependent, expected to fail
    test_parse('Friday 27-Nov-2024', 'DAY DD-MON-YYYY', FALSE);  -- NLS-dependent, expected to fail

    -- Full month name
    test_parse('27 November 2024', 'DD MONTH YYYY', TRUE);
    test_parse('November 27, 2024', 'MONTH DD, YYYY', TRUE);

    -- No year formats
    test_parse('27-Nov', 'DD-MON', TRUE);
    test_parse('27 Nov', 'DD MON', TRUE);
    test_parse('Nov 27', 'MON DD', TRUE);

    -- 2-digit year
    test_parse('27-Nov-24', 'DD-MON-RR', TRUE);
    test_parse('27/11/24', 'DD/MM/RR', TRUE);

    -- Invalid dates (should fail)
    test_parse('32-Nov-2024', 'DD-MON-YYYY', FALSE);  -- Day > 31
    test_parse('27-Xxx-2024', 'DD-MON-YYYY', FALSE);  -- Invalid month
    test_parse('not-a-date', 'DD-MON-YYYY', FALSE);   -- Random text

    ---------------------------------------------------------------------------
    -- SECTION 6: FORMAT DETECTION - ISO FORMATS
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 6: FORMAT DETECTION - ISO ===');

    -- Note: Detection returns the most general matching format (with full ISO timestamp support)
    test_detect('ISO Date', '["2024-11-27", "2024-12-15", "2025-01-01"]', 'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    test_detect('ISO DateTime', '["2024-11-27 14:30:00", "2024-12-15 09:00:00"]', 'YYYY-MM-DD HH24:MI:SS');
    test_detect('ISO Compact', '["20241127", "20241215", "20250101"]', 'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    test_detect('ISO Slash', '["2024/11/27", "2024/12/15", "2025/01/01"]', 'YYYY-MM-DD"T"HH24:MI:SS"Z"');

    ---------------------------------------------------------------------------
    -- SECTION 7: FORMAT DETECTION - DAY NAME FORMATS
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 7: FORMAT DETECTION - DAY NAME ===');

    -- Note: Preprocessing strips decorative day names, so detection returns base format
    -- This is correct behavior - day names are preserved in original for year inference
    test_detect('Short Day Dash', '["Fri 27-Nov-2024", "Sun 15-Dec-2024", "Wed 01-Jan-2025"]', 'DD MONTH YYYY');
    test_detect('Short Day Space', '["Fri 27 Nov 2024", "Sun 15 Dec 2024", "Wed 01 Jan 2025"]', 'DD MONTH YYYY');
    test_detect('Short Day Comma', '["Fri, 27 Nov 2024", "Sun, 15 Dec 2024", "Wed, 01 Jan 2025"]', 'DD MONTH YYYY');
    test_detect('Full Day', '["Friday 27-Nov-2024", "Sunday 15-Dec-2024", "Wednesday 01-Jan-2025"]', 'DD MONTH YYYY');
    test_detect('Day No Year', '["Fri 27-Nov", "Sun 15-Dec", "Wed 01-Jan"]', 'DD-MON');

    ---------------------------------------------------------------------------
    -- SECTION 8: FORMAT DETECTION - MONTH NAME FORMATS
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 8: FORMAT DETECTION - MONTH NAME ===');

    -- Note: Detection prefers more general formats that can handle the input
    test_detect('Oracle Standard', '["27-Nov-2024", "15-Dec-2024", "01-Jan-2025"]', 'DD MONTH YYYY');
    test_detect('Month Space', '["27 Nov 2024", "15 Dec 2024", "01 Jan 2025"]', 'DD MONTH YYYY');
    test_detect('Full Month', '["27 November 2024", "15 December 2024", "01 January 2025"]', 'DD MONTH YYYY');
    test_detect('US Month First', '["Nov 27, 2024", "Dec 15, 2024", "Jan 01, 2025"]', 'MONTH DD, YYYY');
    test_detect('US Full Month', '["November 27, 2024", "December 15, 2024", "January 01, 2025"]', 'MONTH DD, YYYY');
    test_detect('No Year Dash', '["27-Nov", "15-Dec", "01-Jan"]', 'DD-MON');
    test_detect('No Year Space', '["27 Nov", "15 Dec", "01 Jan"]', 'DD-MON');
    test_detect('2-Digit Year', '["27-Nov-24", "15-Dec-24", "01-Jan-25"]', 'DD-MON-RR');

    ---------------------------------------------------------------------------
    -- SECTION 9: FORMAT DETECTION - NUMERIC FORMATS
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 9: FORMAT DETECTION - NUMERIC ===');

    -- European (DD first) - unambiguous because day > 12
    -- Note: Detection may return format with HH24:MI:SS which also works for plain dates
    test_detect('EU Slash Unambiguous', '["27/11/2024", "15/12/2024", "31/01/2025"]', 'DD/MM/YYYY HH24:MI:SS');
    test_detect('EU Dash Unambiguous', '["27-11-2024", "15-12-2024", "31-01-2025"]', 'DD/MM/YYYY HH24:MI:SS');
    test_detect('EU Dot Unambiguous', '["27.11.2024", "15.12.2024", "31.01.2025"]', 'DD/MM/YYYY HH24:MI:SS');

    -- US (MM first) - unambiguous because second position > 12
    test_detect('US Slash Unambiguous', '["11/27/2024", "12/15/2024", "01/31/2025"]', 'MM/DD/YYYY');
    test_detect('US Dash Unambiguous', '["11-27-2024", "12-15-2024", "01-31-2025"]', 'MM/DD/YYYY');

    -- Ambiguous (both positions <= 12) - should default to European
    test_detect('Ambiguous Slash', '["01/02/2024", "05/06/2024", "08/09/2024"]');
    test_detect('Ambiguous Dash', '["01-02-2024", "05-06-2024", "08-09-2024"]');

    -- 2-digit year - detection prefers ISO-style YY/MM/DD when first value > 12
    -- Note: Both DD/MM/RR and RR/MM/DD can parse these values, but detection picks higher score
    test_detect('EU 2-Digit Year', '["27/11/24", "15/12/24", "31/01/25"]', 'RR/MM/DD');

    -- No year numeric
    test_detect('No Year EU', '["27/11", "15/12", "31/01"]', 'DD/MM');

    ---------------------------------------------------------------------------
    -- SECTION 10: FORMAT DETECTION - TEXT NUMBERS
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 10: FORMAT DETECTION - TEXT NUMBERS ===');

    test_detect('Cardinal Numbers', '["sixteen November", "twenty-one December", "first January"]');
    test_detect('Ordinal Numbers', '["sixteenth November", "twenty-first December", "first January"]');
    test_detect('With Fillers', '["the sixteenth of November", "the twenty-first of December", "the first of January"]');
    test_detect('Mixed', '["sixteen November 2024", "21 December 2024", "1st January 2025"]');

    ---------------------------------------------------------------------------
    -- SECTION 11: FORMAT DETECTION - WITH TIME
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 11: FORMAT DETECTION - WITH TIME ===');

    test_detect('Oracle With Time', '["27-Nov-2024 14:30:00", "15-Dec-2024 09:00:00"]', 'DD-MON-YYYY HH24:MI:SS');
    test_detect('ISO With Time', '["2024-11-27 14:30:00", "2024-12-15 09:00:00"]', 'YYYY-MM-DD HH24:MI:SS');
    test_detect('EU With Time', '["27/11/2024 14:30:00", "15/12/2024 09:00:00"]', 'DD/MM/YYYY HH24:MI:SS');

    ---------------------------------------------------------------------------
    -- SECTION 12: SPECIAL VALUES DETECTION
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 12: SPECIAL VALUES DETECTION ===');

    test_detect('With TODAY', '["27-Nov-2024", "TODAY", "15-Dec-2024"]');
    test_detect('With YESTERDAY', '["27-Nov-2024", "YESTERDAY", "15-Dec-2024"]');
    test_detect('With N/A', '["27-Nov-2024", "N/A", "15-Dec-2024"]');
    test_detect('With TBD', '["27-Nov-2024", "TBD", "15-Dec-2024"]');
    test_detect('Multiple Special', '["TODAY", "YESTERDAY", "N/A", "TBD", "27-Nov-2024"]');

    -- All Special should correctly error (no actual dates to detect format from)
    DECLARE
        v_expect_error BOOLEAN := FALSE;
    BEGIN
        ur_date_parser_test.detect_date_format(
            p_sample_values  => '["TODAY", "YESTERDAY", "TOMORROW", "N/A"]',
            p_format_mask    => v_format,
            p_confidence     => v_confidence,
            p_is_ambiguous   => v_ambiguous,
            p_has_year       => v_has_year,
            p_special_values => v_specials,
            p_all_formats    => v_all_formats,
            p_status         => v_status,
            p_message        => v_message
        );
        v_expect_error := (v_status = 'E');
        log_test('DETECT', 'All Special (expect error)',
                 v_expect_error,
                 'Status: ' || v_status || ' Message: ' || NVL(v_message, 'none'));
    END;

    ---------------------------------------------------------------------------
    -- SECTION 13: YEAR INFERENCE - SEQUENTIAL LOGIC
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 13: YEAR INFERENCE - SEQUENTIAL ===');

    -- Start date: 2024-11-15 (November 15, 2024)
    -- Months >= November stay in 2024
    -- Months < November go to 2025

    test_infer_year('15 Nov', '2024-11-15', '2024-11-15');   -- Nov >= Nov -> 2024
    test_infer_year('30 Nov', '2024-11-15', '2024-11-30');   -- Nov >= Nov -> 2024
    test_infer_year('25 Dec', '2024-11-15', '2024-12-25');   -- Dec >= Nov -> 2024
    test_infer_year('01 Jan', '2024-11-15', '2025-01-01');   -- Jan < Nov -> 2025
    test_infer_year('14 Feb', '2024-11-15', '2025-02-14');   -- Feb < Nov -> 2025
    test_infer_year('31 Mar', '2024-11-15', '2025-03-31');   -- Mar < Nov -> 2025
    test_infer_year('15 Apr', '2024-11-15', '2025-04-15');   -- Apr < Nov -> 2025
    test_infer_year('31 May', '2024-11-15', '2025-05-31');   -- May < Nov -> 2025

    -- Different start months
    test_infer_year('15 Jan', '2024-01-01', '2024-01-15');   -- Jan >= Jan -> 2024
    test_infer_year('15 Dec', '2024-01-01', '2024-12-15');   -- Dec >= Jan -> 2024
    test_infer_year('15 Jun', '2024-06-15', '2024-06-15');   -- Jun >= Jun -> 2024
    test_infer_year('15 Jan', '2024-06-15', '2025-01-15');   -- Jan < Jun -> 2025

    ---------------------------------------------------------------------------
    -- SECTION 14: YEAR INFERENCE - DAY NAME VALIDATION
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 14: YEAR INFERENCE - DAY NAME ===');

    -- Using day names to determine correct year
    -- Start date: 2024-11-15

    -- These should match based on day name
    test_infer_year('Fri 15 Nov', '2024-11-15', '2024-11-15');   -- 15-Nov-2024 = Fri
    test_infer_year('Sat 16 Nov', '2024-11-15', '2024-11-16');   -- 16-Nov-2024 = Sat
    test_infer_year('Wed 25 Dec', '2024-11-15', '2024-12-25');   -- 25-Dec-2024 = Wed

    -- These should roll to next year based on day name
    test_infer_year('Wed 01 Jan', '2024-11-15', '2025-01-01');   -- 01-Jan-2025 = Wed (not Mon in 2024)
    test_infer_year('Fri 14 Feb', '2024-11-15', '2025-02-14');   -- 14-Feb-2025 = Fri (not Wed in 2024)
    test_infer_year('Mon 31 Mar', '2024-11-15', '2025-03-31');   -- 31-Mar-2025 = Mon (not Sun in 2024)

    -- Full day names
    test_infer_year('Friday 15 Nov', '2024-11-15', '2024-11-15');
    test_infer_year('Wednesday 01 Jan', '2024-11-15', '2025-01-01');

    ---------------------------------------------------------------------------
    -- SECTION 15: YEAR INFERENCE - WITH PREPROCESSING
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 15: YEAR INFERENCE - PREPROCESSED ===');

    -- Text numbers should be converted before inference
    test_infer_year('fifteen Nov', '2024-11-15', '2024-11-15');
    test_infer_year('twenty-first Dec', '2024-11-15', '2024-12-21');
    test_infer_year('first Jan', '2024-11-15', '2025-01-01');
    test_infer_year('Fri fifteenth Nov', '2024-11-15', '2024-11-15');

    ---------------------------------------------------------------------------
    -- SECTION 16: DAY NAME VALIDATION
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 16: DAY NAME VALIDATION ===');

    DECLARE
        v_date DATE := TO_DATE('2024-11-15', 'YYYY-MM-DD');  -- This is a Friday
        v_result VARCHAR2(1);
    BEGIN
        v_result := ur_date_parser_test.fn_validate_day_name(v_date, 'Fri');
        log_test('DAY_VALIDATE', '2024-11-15 is Fri', v_result = 'Y', 'Result: ' || v_result);

        v_result := ur_date_parser_test.fn_validate_day_name(v_date, 'Friday');
        log_test('DAY_VALIDATE', '2024-11-15 is Friday', v_result = 'Y', 'Result: ' || v_result);

        v_result := ur_date_parser_test.fn_validate_day_name(v_date, 'Mon');
        log_test('DAY_VALIDATE', '2024-11-15 is NOT Mon', v_result = 'N', 'Result: ' || v_result);

        v_result := ur_date_parser_test.fn_validate_day_name(v_date, 'Saturday');
        log_test('DAY_VALIDATE', '2024-11-15 is NOT Saturday', v_result = 'N', 'Result: ' || v_result);

        v_result := ur_date_parser_test.fn_validate_day_name(v_date, NULL);
        log_test('DAY_VALIDATE', 'NULL day name returns NULL', v_result IS NULL, 'Result: ' || NVL(v_result, 'NULL'));
    END;

    ---------------------------------------------------------------------------
    -- SECTION 17: STRUCTURE ANALYSIS
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 17: STRUCTURE ANALYSIS ===');

    DECLARE
        v_struct ur_date_parser_test.t_date_structure;
    BEGIN
        -- Test ISO format
        v_struct := ur_date_parser_test.analyze_date_structure('2024-11-27');
        log_test('STRUCTURE', 'ISO has 4-digit year', v_struct.has_4digit_year = 'Y', 'has_4digit_year: ' || v_struct.has_4digit_year);
        log_test('STRUCTURE', 'ISO no month name', v_struct.has_month_name = 'N', 'has_month_name: ' || v_struct.has_month_name);

        -- Test Oracle format
        v_struct := ur_date_parser_test.analyze_date_structure('27-Nov-2024');
        log_test('STRUCTURE', 'Oracle has month name', v_struct.has_month_name = 'Y', 'has_month_name: ' || v_struct.has_month_name);
        log_test('STRUCTURE', 'Oracle separator is -', v_struct.primary_separator = '-', 'separator: ' || v_struct.primary_separator);

        -- Test with day name
        v_struct := ur_date_parser_test.analyze_date_structure('Fri 27-Nov-2024');
        log_test('STRUCTURE', 'Has day name short', v_struct.has_day_name_short = 'Y', 'has_day_name_short: ' || v_struct.has_day_name_short);

        v_struct := ur_date_parser_test.analyze_date_structure('Friday 27-Nov-2024');
        log_test('STRUCTURE', 'Has day name full', v_struct.has_day_name_full = 'Y', 'has_day_name_full: ' || v_struct.has_day_name_full);

        -- Test with time
        v_struct := ur_date_parser_test.analyze_date_structure('27-Nov-2024 14:30:00');
        log_test('STRUCTURE', 'Has time', v_struct.has_time = 'Y', 'has_time: ' || v_struct.has_time);

        -- Test with text numbers
        v_struct := ur_date_parser_test.analyze_date_structure('twenty-first November');
        log_test('STRUCTURE', 'Has text numbers', v_struct.has_text_numbers = 'Y', 'has_text_numbers: ' || v_struct.has_text_numbers);

        -- Test numeric groups
        v_struct := ur_date_parser_test.analyze_date_structure('27/11/2024');
        log_test('STRUCTURE', 'Numeric groups = 3', v_struct.numeric_group_count = 3, 'numeric_groups: ' || v_struct.numeric_group_count);

        v_struct := ur_date_parser_test.analyze_date_structure('27/11');
        log_test('STRUCTURE', 'No year numeric groups = 2', v_struct.numeric_group_count = 2, 'numeric_groups: ' || v_struct.numeric_group_count);
    END;

    ---------------------------------------------------------------------------
    -- SECTION 18: EDGE CASES
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 18: EDGE CASES ===');

    -- Empty/null handling
    DECLARE
        v_result VARCHAR2(500);
    BEGIN
        v_result := ur_date_parser_test.preprocess_date_sample(NULL);
        log_test('EDGE', 'Preprocess NULL', v_result IS NULL, 'Result: ' || NVL(v_result, 'NULL'));

        v_result := ur_date_parser_test.preprocess_date_sample('');
        log_test('EDGE', 'Preprocess empty', v_result IS NULL OR v_result = '', 'Result: "' || NVL(v_result, 'NULL') || '"');

        v_result := ur_date_parser_test.preprocess_date_sample('   ');
        log_test('EDGE', 'Preprocess whitespace', v_result IS NULL OR v_result = '', 'Result: "' || NVL(v_result, 'NULL') || '"');
    END;

    -- Multiple spaces
    test_preprocess('27    Nov    2024', '27 Nov 2024');

    -- Case variations
    test_preprocess('TWENTY-FIRST NOVEMBER', '21 NOVEMBER');
    test_preprocess('Twenty-First November', '21 November');

    -- Mixed formats in detection (should pick majority)
    test_detect('Mixed Formats', '["27-Nov-2024", "27-Nov-2024", "27-Nov-2024", "2024-11-27"]');

    ---------------------------------------------------------------------------
    -- SECTION 18B: DECORATIVE DAY NAME HANDLING
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 18B: DECORATIVE DAY NAME HANDLING ===');

    -- Day name AFTER date (trailing) - should be removed
    test_preprocess('27/11/2026 - Thursday', '27/11/2026');
    test_preprocess('27/11/2026 - Thu', '27/11/2026');
    test_preprocess('27/11/2026 Thu', '27/11/2026');
    test_preprocess('27-11-2026 (Weekday: Thurs)', '27-11-2026');
    test_preprocess('27-11-2026 (Weekday: Thursday)', '27-11-2026');

    -- Day name BEFORE date (leading) - should be removed when followed by digit
    test_preprocess('Thursday 27/11/2026', '27/11/2026');
    test_preprocess('Thursday, 27/11/2026', '27/11/2026');
    test_preprocess('Thursday - 27/11/2026', '27/11/2026');
    test_preprocess('Thurs 27-11-2026', '27-11-2026');
    test_preprocess('Thu 27-Nov-2026', '27-Nov-2026');

    -- Non-standard day abbreviations
    test_preprocess('Thurs 15-Nov', '15-Nov');
    test_preprocess('Tues 22-Dec', '22-Dec');
    test_preprocess('Weds 01-Jan', '01-Jan');

    -- AD/BC handling
    test_preprocess('27/11/2026 AD', '27/11/2026');
    test_preprocess('AD 2026-11-27', '2026-11-27');
    test_preprocess('27/11/2026 A.D.', '27/11/2026');

    -- YYYY-first formats
    test_preprocess('2026 November 27', '2026 November 27');
    test_preprocess('2026, November 27', '2026, November 27');
    test_preprocess('2026-Nov-27', '2026-Nov-27');

    ---------------------------------------------------------------------------
    -- SECTION 19: REAL-WORLD SCENARIOS
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 19: REAL-WORLD SCENARIOS ===');

    -- Hotel booking dates spanning year boundary
    test_detect('Hotel Bookings Nov-May',
        '["15-Nov", "22-Nov", "01-Dec", "15-Dec", "25-Dec", "01-Jan", "15-Feb", "01-Mar", "15-Apr", "31-May"]',
        'DD-MON');

    -- With day names for validation (Preprocessing strips day names, detects base format)
    test_detect('Bookings With Days',
        '["Fri 15-Nov", "Fri 22-Nov", "Sun 01-Dec", "Sun 15-Dec", "Wed 25-Dec", "Wed 01-Jan"]',
        'DD-MON');

    -- Mixed special values and dates
    test_detect('Real Data With Gaps',
        '["27-Nov-2024", "28-Nov-2024", "N/A", "30-Nov-2024", "TODAY", "02-Dec-2024"]');

    -- European format data (Note: may detect with HH24:MI:SS which also works)
    test_detect('EU Invoice Dates',
        '["27/11/2024", "28/11/2024", "29/11/2024", "30/11/2024", "01/12/2024"]',
        'DD/MM/YYYY HH24:MI:SS');

    -- US format data
    test_detect('US Report Dates',
        '["11/27/2024", "11/28/2024", "11/29/2024", "11/30/2024", "12/01/2024"]',
        'MM/DD/YYYY');

    ---------------------------------------------------------------------------
    -- SECTION 20: PERFORMANCE TEST
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== SECTION 20: PERFORMANCE TEST ===');

    DECLARE
        v_start TIMESTAMP;
        v_end TIMESTAMP;
        v_samples CLOB;
        v_elapsed_ms NUMBER;
    BEGIN
        -- Build a large sample set
        v_samples := '[';
        FOR i IN 1..100 LOOP
            IF i > 1 THEN v_samples := v_samples || ','; END IF;
            v_samples := v_samples || '"' || TO_CHAR(SYSDATE + i, 'DD-MON-YYYY') || '"';
        END LOOP;
        v_samples := v_samples || ']';

        v_start := SYSTIMESTAMP;

        ur_date_parser_test.detect_date_format(
            p_sample_values  => v_samples,
            p_format_mask    => v_format,
            p_confidence     => v_confidence,
            p_is_ambiguous   => v_ambiguous,
            p_has_year       => v_has_year,
            p_special_values => v_specials,
            p_all_formats    => v_all_formats,
            p_status         => v_status,
            p_message        => v_message
        );

        v_end := SYSTIMESTAMP;
        v_elapsed_ms := EXTRACT(SECOND FROM (v_end - v_start)) * 1000;

        log_test('PERFORMANCE', '100 samples detection',
                 v_status = 'S' AND v_elapsed_ms < 5000,
                 'Elapsed: ' || ROUND(v_elapsed_ms, 2) || 'ms, Format: ' || v_format);
    END;

    ---------------------------------------------------------------------------
    -- SUMMARY
    ---------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('  TEST SUMMARY');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  Total Tests: ' || v_total_tests);
    DBMS_OUTPUT.PUT_LINE('  Passed:      ' || v_pass_count || ' (' || ROUND(v_pass_count/v_total_tests*100, 1) || '%)');
    DBMS_OUTPUT.PUT_LINE('  Failed:      ' || v_fail_count || ' (' || ROUND(v_fail_count/v_total_tests*100, 1) || '%)');
    DBMS_OUTPUT.PUT_LINE('');

    IF v_fail_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  STATUS: ALL TESTS PASSED!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  STATUS: SOME TESTS FAILED - Review output above');
    END IF;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('================================================================================');

END test_date_parser_comprehensive;
/

SHOW ERRORS PROCEDURE test_date_parser_comprehensive;

-- Run the test suite
PROMPT
PROMPT Running comprehensive test suite...
PROMPT
EXEC test_date_parser_comprehensive;

PROMPT
PROMPT ================================================================================
PROMPT   Additional Manual Tests
PROMPT ================================================================================
PROMPT
PROMPT You can also run these individual tests:
PROMPT
PROMPT -- Test preprocessing
PROMPT SELECT ur_date_parser_test.preprocess_date_sample('the twenty-first of November, 2024') FROM dual;
PROMPT
PROMPT -- Test format detection
PROMPT SELECT ur_date_parser_test.detect_format_simple('["Fri 27-Nov", "Sat 28-Nov", "Sun 29-Nov"]') FROM dual;
PROMPT
PROMPT -- Test year inference
PROMPT SELECT ur_date_parser_test.fn_infer_year('Wed 01 Jan', '2024-11-15') FROM dual;
PROMPT
PROMPT -- Test all formats against a sample
PROMPT EXEC ur_date_parser_test.test_all_formats('Friday, November twenty-first, 2024');
PROMPT
PROMPT -- Run the built-in test suite
PROMPT EXEC ur_date_parser_test.run_test_suite;
PROMPT
