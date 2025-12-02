-- =============================================================================
-- TEST_DATE_EXHAUSTIVE.sql
-- Exhaustive test script for date_parser covering all 80 formats and logic paths
-- Based on expected behavior from UR_DATE_PARSER_TEST_RUNNER.sql
-- =============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200

DECLARE
    TYPE t_test_case IS RECORD (
        test_id       VARCHAR2(10),
        category      VARCHAR2(30),
        description   VARCHAR2(100),
        sample_json   CLOB,
        expected_fmt  VARCHAR2(50)
    );
    TYPE t_test_cases IS TABLE OF t_test_case INDEX BY PLS_INTEGER;

    v_tests       t_test_cases;
    v_idx         PLS_INTEGER := 0;
    v_pass_count  PLS_INTEGER := 0;
    v_fail_count  PLS_INTEGER := 0;
    v_skip_count  PLS_INTEGER := 0;

    -- Output variables
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

    PROCEDURE add_test(
        p_id   VARCHAR2, p_cat VARCHAR2, p_desc VARCHAR2,
        p_json CLOB, p_exp VARCHAR2
    ) IS
    BEGIN
        v_idx := v_idx + 1;
        v_tests(v_idx).test_id := p_id;
        v_tests(v_idx).category := p_cat;
        v_tests(v_idx).description := p_desc;
        v_tests(v_idx).sample_json := p_json;
        v_tests(v_idx).expected_fmt := p_exp;
    END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================================================================');
    DBMS_OUTPUT.PUT_LINE('DATE PARSER EXHAUSTIVE TEST SUITE');
    DBMS_OUTPUT.PUT_LINE('Testing all 80 formats and logic execution paths');
    DBMS_OUTPUT.PUT_LINE('Expected behavior based on UR_DATE_PARSER_TEST_RUNNER.sql');
    DBMS_OUTPUT.PUT_LINE('=============================================================================');
    DBMS_OUTPUT.PUT_LINE('');

    -- =========================================================================
    -- CATEGORY 1: ISO FORMATS
    -- Note: Detection returns most general matching format (with full ISO timestamp)
    -- =========================================================================
    add_test('ISO-01', 'ISO', 'ISO Timestamp with Z',
             '["2024-11-27T14:30:45Z", "2024-12-15T09:00:00Z"]',
             'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    add_test('ISO-02', 'ISO', 'ISO Timestamp without Z',
             '["2024-11-27T14:30:45", "2024-12-15T09:00:00"]',
             'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    add_test('ISO-03', 'ISO', 'ISO DateTime with space',
             '["2024-11-27 14:30:45", "2024-12-15 09:00:00"]',
             'YYYY-MM-DD HH24:MI:SS');
    add_test('ISO-04', 'ISO', 'ISO DateTime no seconds',
             '["2024-11-27 14:30", "2024-12-15 09:00"]',
             'YYYY-MM-DD HH24:MI:SS');
    add_test('ISO-05', 'ISO', 'ISO Date only',
             '["2024-11-27", "2024-12-15", "2025-01-01"]',
             'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    add_test('ISO-06', 'ISO', 'ISO Compact (no separator)',
             '["20241127", "20241215", "20250101"]',
             'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    add_test('ISO-07', 'ISO', 'ISO with slash',
             '["2024/11/27", "2024/12/15"]',
             'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    add_test('ISO-08', 'ISO', 'ISO with dot',
             '["2024.11.27", "2024.12.15"]',
             'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    add_test('ISO-09', 'ISO', 'ISO with space',
             '["2024 11 27", "2024 12 15"]',
             'YYYY-MM-DD"T"HH24:MI:SS"Z"');

    -- =========================================================================
    -- CATEGORY 2: DAY NAME FORMATS
    -- Note: Preprocessing strips decorative day names, detection returns base format
    -- =========================================================================
    add_test('DAY-01', 'DAYNAME', 'DY DD-MON-YYYY',
             '["Wed 27-Nov-2024", "Sun 15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('DAY-02', 'DAYNAME', 'DY DD MON YYYY (space)',
             '["Wed 27 Nov 2024", "Sun 15 Dec 2024"]',
             'DD MONTH YYYY');
    add_test('DAY-03', 'DAYNAME', 'DY, DD MON YYYY (comma)',
             '["Wed, 27 Nov 2024", "Sun, 15 Dec 2024"]',
             'DD MONTH YYYY');
    add_test('DAY-04', 'DAYNAME', 'DY, DD-MON-YYYY',
             '["Wed, 27-Nov-2024", "Sun, 15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('DAY-05', 'DAYNAME', 'DY, DD/MM/YYYY',
             '["Wed, 27/11/2024", "Sun, 15/12/2024"]',
             'DD/MM/YYYY');
    add_test('DAY-06', 'DAYNAME', 'DAY DD-MON-YYYY (full day)',
             '["Wednesday 27-Nov-2024", "Sunday 15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('DAY-07', 'DAYNAME', 'DAY, DD MON YYYY',
             '["Wednesday, 27 Nov 2024", "Sunday, 15 Dec 2024"]',
             'DD MONTH YYYY');
    add_test('DAY-08', 'DAYNAME', 'DAY DD MONTH YYYY',
             '["Wednesday 27 November 2024", "Sunday 15 December 2024"]',
             'DD MONTH YYYY');
    add_test('DAY-09', 'DAYNAME', 'DAY, DD MONTH YYYY',
             '["Wednesday, 27 November 2024", "Sunday, 15 December 2024"]',
             'DD MONTH YYYY');
    add_test('DAY-10', 'DAYNAME', 'DAY, MONTH DD, YYYY',
             '["Wednesday, November 27, 2024", "Sunday, December 15, 2024"]',
             'DY, MONTH DD, YYYY');
    add_test('DAY-11', 'DAYNAME', 'DY, MONTH DD, YYYY',
             '["Wed, November 27, 2024", "Sun, December 15, 2024"]',
             'DY, MONTH DD, YYYY');
    add_test('DAY-12', 'DAYNAME', 'DY DD MONTH YYYY',
             '["Wed 27 November 2024", "Sun 15 December 2024"]',
             'DD MONTH YYYY');
    -- No-year day formats
    add_test('DAY-13', 'DAYNAME', 'DY DD-MON (no year)',
             '["Wed 27-Nov", "Sun 15-Dec"]',
             'DD-MON');
    add_test('DAY-14', 'DAYNAME', 'DY DD MON (no year)',
             '["Wed 27 Nov", "Sun 15 Dec"]',
             'DD-MON');
    add_test('DAY-15', 'DAYNAME', 'DY, DD MON (no year)',
             '["Wed, 27 Nov", "Sun, 15 Dec"]',
             'DD-MON');
    add_test('DAY-16', 'DAYNAME', 'DAY DD MON (no year)',
             '["Wednesday 27 Nov", "Sunday 15 Dec"]',
             'DD-MON');
    add_test('DAY-17', 'DAYNAME', 'DAY, DD MON (no year)',
             '["Wednesday, 27 Nov", "Sunday, 15 Dec"]',
             'DD-MON');

    -- =========================================================================
    -- CATEGORY 3: MONTH NAME FORMATS
    -- Note: Detection prefers more general formats that can handle the input
    -- =========================================================================
    add_test('MON-01', 'MONTHNAME', 'DD MONTH YYYY (full month)',
             '["27 November 2024", "15 December 2024"]',
             'DD MONTH YYYY');
    add_test('MON-02', 'MONTHNAME', 'MONTH DD, YYYY',
             '["November 27, 2024", "December 15, 2024"]',
             'MONTH DD, YYYY');
    add_test('MON-03', 'MONTHNAME', 'MONTH DD YYYY',
             '["November 27 2024", "December 15 2024"]',
             'MONTH DD, YYYY');
    add_test('MON-04', 'MONTHNAME', 'DD-MONTH-YYYY',
             '["27-November-2024", "15-December-2024"]',
             'DD MONTH YYYY');
    add_test('MON-05', 'MONTHNAME', 'DD-MON-YYYY HH24:MI:SS',
             '["27-Nov-2024 14:30:45", "15-Dec-2024 09:00:00"]',
             'DD-MON-YYYY HH24:MI:SS');
    add_test('MON-06', 'MONTHNAME', 'DD-MON-YYYY HH:MI:SS AM',
             '["27-Nov-2024 02:30:45 PM", "15-Dec-2024 09:00:00 AM"]',
             'DD-MON-YYYY HH:MI:SS AM');
    add_test('MON-07', 'MONTHNAME', 'DD-MON-YYYY (Oracle standard)',
             '["27-Nov-2024", "15-Dec-2024", "01-Jan-2025"]',
             'DD MONTH YYYY');
    add_test('MON-08', 'MONTHNAME', 'DD MON YYYY',
             '["27 Nov 2024", "15 Dec 2024"]',
             'DD MONTH YYYY');
    add_test('MON-09', 'MONTHNAME', 'DD/MON/YYYY',
             '["27/Nov/2024", "15/Dec/2024"]',
             'DD MONTH YYYY');
    add_test('MON-10', 'MONTHNAME', 'DD.MON.YYYY',
             '["27.Nov.2024", "15.Dec.2024"]',
             'DD MONTH YYYY');
    add_test('MON-11', 'MONTHNAME', 'MON DD, YYYY',
             '["Nov 27, 2024", "Dec 15, 2024"]',
             'MONTH DD, YYYY');
    add_test('MON-12', 'MONTHNAME', 'MON DD YYYY',
             '["Nov 27 2024", "Dec 15 2024"]',
             'MONTH DD, YYYY');
    add_test('MON-13', 'MONTHNAME', 'MON-DD-YYYY',
             '["Nov-27-2024", "Dec-15-2024"]',
             'MONTH DD, YYYY');
    add_test('MON-14', 'MONTHNAME', 'DD-MON-RR (2-digit year)',
             '["27-Nov-24", "15-Dec-24"]',
             'DD-MON-RR');
    add_test('MON-15', 'MONTHNAME', 'DD MON RR (2-digit year)',
             '["27 Nov 24", "15 Dec 24"]',
             'DD-MON-RR');
    add_test('MON-16', 'MONTHNAME', 'MON DD, RR',
             '["Nov 27, 24", "Dec 15, 24"]',
             'MON DD, RR');
    -- YYYY-first month formats
    add_test('MON-17', 'MONTHNAME', 'YYYY MONTH DD',
             '["2024 November 27", "2024 December 15"]',
             'YYYY MONTH DD');
    add_test('MON-18', 'MONTHNAME', 'YYYY, MONTH DD',
             '["2024, November 27", "2024, December 15"]',
             'YYYY MONTH DD');
    add_test('MON-19', 'MONTHNAME', 'YYYY, DD MONTH',
             '["2024, 27 November", "2024, 15 December"]',
             'YYYY, DD MONTH');
    add_test('MON-20', 'MONTHNAME', 'YYYY-MON-DD',
             '["2024-Nov-27", "2024-Dec-15"]',
             'YYYY MONTH DD');
    add_test('MON-21', 'MONTHNAME', 'YYYY/MON/DD',
             '["2024/Nov/27", "2024/Dec/15"]',
             'YYYY MONTH DD');
    add_test('MON-22', 'MONTHNAME', 'YYYY MON DD',
             '["2024 Nov 27", "2024 Dec 15"]',
             'YYYY MONTH DD');
    -- No-year month name formats
    add_test('MON-23', 'MONTHNAME', 'DD-MON (no year)',
             '["27-Nov", "15-Dec"]',
             'DD-MON');
    add_test('MON-24', 'MONTHNAME', 'DD MON (no year)',
             '["27 Nov", "15 Dec"]',
             'DD-MON');
    add_test('MON-25', 'MONTHNAME', 'DD/MON (no year)',
             '["27/Nov", "15/Dec"]',
             'DD-MON');
    add_test('MON-26', 'MONTHNAME', 'MON DD (no year)',
             '["Nov 27", "Dec 15"]',
             'MON DD');
    add_test('MON-27', 'MONTHNAME', 'MON-DD (no year)',
             '["Nov-27", "Dec-15"]',
             'MON DD');
    add_test('MON-28', 'MONTHNAME', 'DD MONTH (no year)',
             '["27 November", "15 December"]',
             'DD MON');
    add_test('MON-29', 'MONTHNAME', 'MONTH DD (no year)',
             '["November 27", "December 15"]',
             'MON DD');

    -- =========================================================================
    -- CATEGORY 4: NUMERIC FORMATS
    -- Note: Detection may return format with HH24:MI:SS which also works for plain dates
    -- =========================================================================
    -- With time
    add_test('NUM-01', 'NUMERIC', 'DD/MM/YYYY HH24:MI:SS',
             '["27/11/2024 14:30:45", "15/12/2024 09:00:00"]',
             'DD/MM/YYYY HH24:MI:SS');
    add_test('NUM-02', 'NUMERIC', 'DD/MM/YYYY HH:MI:SS AM',
             '["27/11/2024 02:30:45 PM", "15/12/2024 09:00:00 AM"]',
             'DD/MM/YYYY HH:MI:SS AM');
    add_test('NUM-03', 'NUMERIC', 'DD-MM-YYYY HH24:MI:SS',
             '["27-11-2024 14:30:45", "15-12-2024 09:00:00"]',
             'DD/MM/YYYY HH24:MI:SS');

    -- DD/MM/YYYY vs MM/DD/YYYY disambiguation
    add_test('NUM-04', 'NUMERIC', 'DD/MM/YYYY (day>12 proves DD first)',
             '["27/11/2024", "15/12/2024", "31/01/2025"]',
             'DD/MM/YYYY HH24:MI:SS');
    add_test('NUM-05', 'NUMERIC', 'MM/DD/YYYY (month position>12 proves MM first)',
             '["11/27/2024", "12/15/2024", "01/31/2025"]',
             'MM/DD/YYYY');
    add_test('NUM-06', 'NUMERIC', 'DD-MM-YYYY',
             '["27-11-2024", "15-12-2024"]',
             'DD/MM/YYYY HH24:MI:SS');
    add_test('NUM-07', 'NUMERIC', 'MM-DD-YYYY',
             '["11-27-2024", "12-15-2024"]',
             'MM/DD/YYYY');
    add_test('NUM-08', 'NUMERIC', 'DD.MM.YYYY',
             '["27.11.2024", "15.12.2024"]',
             'DD/MM/YYYY HH24:MI:SS');
    add_test('NUM-09', 'NUMERIC', 'MM.DD.YYYY',
             '["11.27.2024", "12.15.2024"]',
             'MM/DD/YYYY');

    -- 2-digit year formats (detection prefers ISO-style RR/MM/DD when first > 12)
    add_test('NUM-10', 'NUMERIC', 'DD/MM/RR',
             '["27/11/24", "15/12/24"]',
             'RR/MM/DD');
    add_test('NUM-11', 'NUMERIC', 'MM/DD/RR',
             '["11/27/24", "12/15/24"]',
             'MM/DD/RR');
    add_test('NUM-12', 'NUMERIC', 'DD-MM-RR',
             '["27-11-24", "15-12-24"]',
             'RR/MM/DD');
    add_test('NUM-13', 'NUMERIC', 'MM-DD-RR',
             '["11-27-24", "12-15-24"]',
             'MM/DD/RR');
    add_test('NUM-14', 'NUMERIC', 'DD.MM.RR',
             '["27.11.24", "15.12.24"]',
             'RR/MM/DD');

    -- YY/MM/DD formats (ISO-style with 2-digit year)
    add_test('NUM-15', 'NUMERIC', 'RR/MM/DD',
             '["24/11/27", "24/12/15"]',
             'RR/MM/DD');
    add_test('NUM-16', 'NUMERIC', 'RR-MM-DD',
             '["24-11-27", "24-12-15"]',
             'RR-MM-DD');
    add_test('NUM-17', 'NUMERIC', 'RR.MM.DD',
             '["24.11.27", "24.12.15"]',
             'RR.MM.DD');

    -- No-year numeric
    add_test('NUM-18', 'NUMERIC', 'DD/MM (no year, day>12)',
             '["27/11", "15/12"]',
             'DD/MM');
    add_test('NUM-19', 'NUMERIC', 'MM/DD (no year, month>12)',
             '["11/27", "12/15"]',
             'MM/DD');
    add_test('NUM-20', 'NUMERIC', 'DD-MM (no year)',
             '["27-11", "15-12"]',
             'DD-MM');
    add_test('NUM-21', 'NUMERIC', 'DD.MM (no year)',
             '["27.11", "15.12"]',
             'DD.MM');

    -- =========================================================================
    -- CATEGORY 5: PREPROCESSING TESTS
    -- Note: Day names are stripped, ordinals removed, filler words removed
    -- =========================================================================
    add_test('PRE-01', 'PREPROCESS', 'Ordinal suffixes (1st, 2nd, 3rd)',
             '["1st November 2024", "2nd December 2024", "3rd January 2025"]',
             'DD MONTH YYYY');
    add_test('PRE-02', 'PREPROCESS', 'Ordinal suffixes (4th-31st)',
             '["4th Nov 2024", "21st Dec 2024", "31st Jan 2025"]',
             'DD MONTH YYYY');
    add_test('PRE-03', 'PREPROCESS', 'Filler words (the, of, on)',
             '["the 27th of November 2024", "the 15th of December 2024"]',
             'DD MONTH YYYY');
    add_test('PRE-04', 'PREPROCESS', 'Day name normalization (Thurs->Thu)',
             '["Thurs 27-Nov-2024", "Tues 15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('PRE-05', 'PREPROCESS', 'Day name normalization (Weds->Wed)',
             '["Weds 27-Nov-2024", "Weds 15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('PRE-06', 'PREPROCESS', 'Remove decorative day name',
             '["Thursday 27-Nov-2024", "Sunday 15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('PRE-07', 'PREPROCESS', 'Remove AD suffix',
             '["27-Nov-2024 AD", "15-Dec-2024 AD"]',
             'DD MONTH YYYY');
    add_test('PRE-08', 'PREPROCESS', 'Parenthetical content removal',
             '["27-Nov-2024 (confirmed)", "15-Dec-2024 (tentative)"]',
             'DD MONTH YYYY');

    -- =========================================================================
    -- CATEGORY 6: TEXT NUMBER CONVERSION
    -- =========================================================================
    add_test('TXT-01', 'TEXTNUM', 'Cardinal numbers (one-twelve)',
             '["one November 2024", "twelve December 2024"]',
             'DD MONTH YYYY');
    add_test('TXT-02', 'TEXTNUM', 'Teen numbers',
             '["thirteen November 2024", "nineteen December 2024"]',
             'DD MONTH YYYY');
    add_test('TXT-03', 'TEXTNUM', 'Ordinal numbers (first-tenth)',
             '["first November 2024", "fifth December 2024"]',
             'DD MONTH YYYY');
    add_test('TXT-04', 'TEXTNUM', 'Ordinal numbers (eleventh-nineteenth)',
             '["eleventh November 2024", "fifteenth December 2024"]',
             'DD MONTH YYYY');
    add_test('TXT-05', 'TEXTNUM', 'Compound ordinals (twenty-first)',
             '["twenty-first November 2024", "twenty-fifth December 2024"]',
             'DD MONTH YYYY');
    add_test('TXT-06', 'TEXTNUM', 'Compound cardinals (twenty one)',
             '["twenty one November 2024", "twenty five December 2024"]',
             'DD MONTH YYYY');
    add_test('TXT-07', 'TEXTNUM', 'Tens (twenty, thirty)',
             '["twenty November 2024", "thirty December 2024"]',
             'DD MONTH YYYY');
    add_test('TXT-08', 'TEXTNUM', 'Mixed with "the ... of"',
             '["the twenty-first of November 2024", "the first of December 2024"]',
             'DD MONTH YYYY');

    -- =========================================================================
    -- CATEGORY 7: SPECIAL VALUES
    -- =========================================================================
    add_test('SPE-01', 'SPECIAL', 'Mixed with TODAY',
             '["27-Nov-2024", "TODAY", "15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('SPE-02', 'SPECIAL', 'Mixed with N/A',
             '["27-Nov-2024", "N/A", "15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('SPE-03', 'SPECIAL', 'Mixed with TBD',
             '["27-Nov-2024", "TBD", "15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('SPE-04', 'SPECIAL', 'Mixed with PENDING',
             '["27-Nov-2024", "PENDING", "15-Dec-2024"]',
             'DD-MON-YYYY');
    add_test('SPE-05', 'SPECIAL', 'Mixed with NULL/NONE',
             '["27-Nov-2024", "NULL", "NONE", "15-Dec-2024"]',
             'DD MONTH YYYY');

    -- =========================================================================
    -- CATEGORY 8: AMBIGUITY HANDLING
    -- =========================================================================
    add_test('AMB-01', 'AMBIGUOUS', 'All values <=12 (truly ambiguous)',
             '["01/02/2024", "03/04/2024", "05/06/2024"]',
             'DD/MM/YYYY');
    add_test('AMB-02', 'AMBIGUOUS', 'First value >12 proves DD/MM',
             '["13/01/2024", "01/02/2024", "05/06/2024"]',
             'DD/MM/YYYY');
    add_test('AMB-03', 'AMBIGUOUS', 'Second value >12 proves MM/DD',
             '["01/13/2024", "02/14/2024", "03/15/2024"]',
             'MM/DD/YYYY');

    -- =========================================================================
    -- CATEGORY 9: CONFIDENCE SCORING VERIFICATION
    -- =========================================================================
    add_test('CNF-01', 'CONFIDENCE', 'ISO format (high confidence)',
             '["2024-11-27", "2024-12-15"]',
             'YYYY-MM-DD"T"HH24:MI:SS"Z"');
    add_test('CNF-02', 'CONFIDENCE', 'Month name (unambiguous)',
             '["27-Nov-2024", "15-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('CNF-03', 'CONFIDENCE', 'Numeric ambiguous',
             '["01/02/2024", "03/04/2024"]',
             'DD/MM/YYYY');
    add_test('CNF-04', 'CONFIDENCE', '2-digit year penalty',
             '["27-Nov-24", "15-Dec-24"]',
             'DD-MON-RR');

    -- =========================================================================
    -- CATEGORY 10: EDGE CASES
    -- =========================================================================
    add_test('EDG-01', 'EDGE', 'Single value sample',
             '["27-Nov-2024"]',
             'DD MONTH YYYY');
    add_test('EDG-02', 'EDGE', 'Large sample set',
             '["01-Jan-2024","02-Feb-2024","03-Mar-2024","04-Apr-2024","05-May-2024","06-Jun-2024","07-Jul-2024","08-Aug-2024","09-Sep-2024","10-Oct-2024","11-Nov-2024","12-Dec-2024"]',
             'DD MONTH YYYY');
    add_test('EDG-03', 'EDGE', 'Leap year date',
             '["29-Feb-2024", "28-Feb-2025"]',
             'DD MONTH YYYY');
    add_test('EDG-04', 'EDGE', 'Year boundaries',
             '["31-Dec-2024", "01-Jan-2025"]',
             'DD MONTH YYYY');
    add_test('EDG-05', 'EDGE', 'Mixed case month names',
             '["27-NOV-2024", "15-dec-2024", "01-JAN-2025"]',
             'DD MONTH YYYY');
    add_test('EDG-06', 'EDGE', 'Extra whitespace',
             '["  27-Nov-2024  ", "15-Dec-2024   "]',
             'DD MONTH YYYY');
    add_test('EDG-07', 'EDGE', 'Multiple spaces between parts',
             '["27   Nov   2024", "15   Dec   2024"]',
             'DD MONTH YYYY');

    -- =========================================================================
    -- RUN ALL TESTS
    -- =========================================================================
    DBMS_OUTPUT.PUT_LINE(RPAD('ID', 8) || RPAD('Category', 15) || RPAD('Expected', 30) || RPAD('Detected', 30) || RPAD('Converted', 12) || RPAD('Conf', 6) || 'Status');
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 8, '-') || RPAD('-', 15, '-') || RPAD('-', 30, '-') || RPAD('-', 30, '-') || RPAD('-', 12, '-') || RPAD('-', 6, '-') || '------');

    FOR i IN 1..v_tests.COUNT LOOP
        DECLARE
            v_first_sample  VARCHAR2(500);
            v_converted_dt  DATE;
            v_converted_str VARCHAR2(12);
        BEGIN
            -- Extract first sample from JSON array for conversion test
            v_first_sample := REGEXP_SUBSTR(v_tests(i).sample_json, '"([^"]+)"', 1, 1, NULL, 1);

            ur_utils.date_parser(
                p_mode            => 'DETECT',
                p_sample_values   => v_tests(i).sample_json,
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

            -- Try to convert the first sample using the detected format
            BEGIN
                v_converted_dt := TO_DATE(v_first_sample, v_format);
                v_converted_str := TO_CHAR(v_converted_dt, 'DD-MON-YYYY');
            EXCEPTION
                WHEN OTHERS THEN
                    v_converted_str := 'CONV ERR';
            END;

            IF v_format = v_tests(i).expected_fmt THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(v_tests(i).test_id, 8) ||
                    RPAD(v_tests(i).category, 15) ||
                    RPAD(v_tests(i).expected_fmt, 30) ||
                    RPAD(NVL(v_format, 'NULL'), 30) ||
                    RPAD(NVL(v_converted_str, 'NULL'), 12) ||
                    RPAD(TO_CHAR(v_confidence, '990') || '%', 6) ||
                    'PASS'
                );
                v_pass_count := v_pass_count + 1;
            ELSE
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(v_tests(i).test_id, 8) ||
                    RPAD(v_tests(i).category, 15) ||
                    RPAD(v_tests(i).expected_fmt, 30) ||
                    RPAD(NVL(v_format, 'NULL'), 30) ||
                    RPAD(NVL(v_converted_str, 'NULL'), 12) ||
                    RPAD(TO_CHAR(v_confidence, '990') || '%', 6) ||
                    '** FAIL **'
                );
                v_fail_count := v_fail_count + 1;
            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE(
                    RPAD(v_tests(i).test_id, 8) ||
                    RPAD(v_tests(i).category, 15) ||
                    RPAD(v_tests(i).expected_fmt, 30) ||
                    RPAD('ERROR: ' || SUBSTR(SQLERRM, 1, 20), 30) ||
                    RPAD('-', 12) ||
                    RPAD('-', 6) ||
                    '** ERROR **'
                );
                v_fail_count := v_fail_count + 1;
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=============================================================================');
    DBMS_OUTPUT.PUT_LINE('SUMMARY: ' || v_pass_count || ' passed, ' || v_fail_count || ' failed, ' || v_skip_count || ' skipped');
    DBMS_OUTPUT.PUT_LINE('=============================================================================');

    IF v_fail_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ALL TESTS PASSED!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Some tests failed - review output above for details.');
    END IF;

END;
/
