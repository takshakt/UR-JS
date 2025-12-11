DECLARE
    v_file_id         NUMBER;
    v_column_name     VARCHAR2(100);
    v_skip_rows       NUMBER := 0;
    v_xlsx_sheet_name VARCHAR2(100) := NULL;
    v_sample_values   CLOB;
    v_status          VARCHAR2(1);
    v_message         VARCHAR2(4000);
    v_format_mask     VARCHAR2(100);
    v_confidence      NUMBER;
    v_detect_status   VARCHAR2(1);
    v_detect_message  VARCHAR2(4000);
    v_alert_clob      CLOB;
    v_converted_date  DATE;
    v_has_year        VARCHAR2(1);
    v_is_ambiguous    VARCHAR2(1);
    v_special_values  VARCHAR2(500);
    v_all_formats     CLOB;

    -- For parse testing
    v_parse_status    VARCHAR2(1);
    v_parse_message   VARCHAR2(4000);
    v_test_values     JSON_ARRAY_T;
    v_test_value      VARCHAR2(200);
    v_parsed_date     DATE;
    v_success_count   NUMBER := 0;
    v_fail_count      NUMBER := 0;
    v_null_count      NUMBER := 0;
BEGIN
    -- Step 1: Find a recent file upload with a date column
    BEGIN
        SELECT ID INTO v_file_id
        FROM temp_BLOB
        WHERE ROWNUM = 1
        AND id = 34219859980982169
        ORDER BY CREATED_ON DESC;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: No files found in temp_BLOB table');
            RETURN;
    END;

    -- Step 2: Set the column name to extract
    v_column_name := 'COLUMN';

    DBMS_OUTPUT.PUT_LINE('==========================================================');
    DBMS_OUTPUT.PUT_LINE('Testing extract_column_sample_values');
    DBMS_OUTPUT.PUT_LINE('==========================================================');
    DBMS_OUTPUT.PUT_LINE('File ID: ' || v_file_id);
    DBMS_OUTPUT.PUT_LINE('Column Name: ' || v_column_name);
    DBMS_OUTPUT.PUT_LINE('Skip Rows: ' || v_skip_rows);
    DBMS_OUTPUT.PUT_LINE('');

    -- Step 3: Extract sample values
    ur_utils.extract_column_sample_values(
        p_file_id         => v_file_id,
        p_column_name     => v_column_name,
        p_skip_rows       => v_skip_rows,
        p_xlsx_sheet_name => v_xlsx_sheet_name,
        p_sample_values   => v_sample_values,
        p_status          => v_status,
        p_message         => v_message
    );

    DBMS_OUTPUT.PUT_LINE('Extract Status: ' || v_status);
    DBMS_OUTPUT.PUT_LINE('Extract Message: ' || v_message);
    DBMS_OUTPUT.PUT_LINE('');

    IF v_status = 'S' THEN
        -- Display first 500 characters of sample values
        DBMS_OUTPUT.PUT_LINE('Sample Values (first 500 chars):');
        DBMS_OUTPUT.PUT_LINE(SUBSTR(v_sample_values, 1, 500));
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Total Length: ' || LENGTH(v_sample_values) || ' characters');
        DBMS_OUTPUT.PUT_LINE('');

        -- Step 4: Test date format detection
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Testing date_parser in DETECT mode');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');

        ur_utils.date_parser(
            p_mode            => 'DETECT',
            p_sample_values   => v_sample_values,
            p_min_confidence  => 90,
            p_debug_flag      => 'N',
            p_alert_clob      => v_alert_clob,
            p_format_mask_out => v_format_mask,
            p_confidence      => v_confidence,
            p_converted_date  => v_converted_date,
            p_has_year        => v_has_year,
            p_is_ambiguous    => v_is_ambiguous,
            p_special_values  => v_special_values,
            p_all_formats     => v_all_formats,
            p_status          => v_detect_status,
            p_message         => v_detect_message
        );

        DBMS_OUTPUT.PUT_LINE('Detect Status: ' || v_detect_status);
        DBMS_OUTPUT.PUT_LINE('Detect Message: ' || v_detect_message);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Detected Format Mask: ' || NVL(v_format_mask, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Confidence: ' || NVL(TO_CHAR(v_confidence), 'NULL') || '%');
        DBMS_OUTPUT.PUT_LINE('Has Year: ' || NVL(v_has_year, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Is Ambiguous: ' || NVL(v_is_ambiguous, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Special Values: ' || NVL(v_special_values, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('');

        IF v_all_formats IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('All Candidate Formats (first 1000 chars):');
            DBMS_OUTPUT.PUT_LINE(SUBSTR(v_all_formats, 1, 1000));
            DBMS_OUTPUT.PUT_LINE('');
        END IF;

        -- Step 5: Test PARSE mode with detected format
        IF v_format_mask IS NOT NULL AND v_detect_status IN ('S', 'W') THEN
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Testing date_parser in PARSE mode');
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Using detected format: ' || v_format_mask);
            DBMS_OUTPUT.PUT_LINE('');

            -- Parse the JSON array to test individual values
            BEGIN
                v_test_values := JSON_ARRAY_T.parse(v_sample_values);

                -- First, show special values and how they parse
                DBMS_OUTPUT.PUT_LINE('Special Values Processing:');
                DBMS_OUTPUT.PUT_LINE('');

                FOR i IN 0 .. v_test_values.get_size - 1 LOOP
                    v_test_value := v_test_values.get_string(i);

                    IF UPPER(v_test_value) IN ('TODAY', 'TOMORROW', 'YESTERDAY') THEN
                        -- Test parsing special values with parse_date_safe
                        v_parsed_date := ur_utils.parse_date_safe(
                            p_value       => v_test_value,
                            p_format_mask => v_format_mask,
                            p_start_date  => SYSDATE
                        );

                        IF v_parsed_date IS NOT NULL THEN
                            DBMS_OUTPUT.PUT_LINE('⊙ Special: "' || v_test_value || '" => ' ||
                                               TO_CHAR(v_parsed_date, 'DD-MON-YYYY') ||
                                               ' (handled as special keyword)');
                        ELSE
                            DBMS_OUTPUT.PUT_LINE('⊙ Special: "' || v_test_value || '" => NULL (not recognized)');
                        END IF;
                    END IF;
                END LOOP;

                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('Regular Date Values (first 10):');
                DBMS_OUTPUT.PUT_LINE('');

                v_success_count := 0;
                v_fail_count := 0;

                FOR i IN 0 .. LEAST(9, v_test_values.get_size - 1) LOOP
                    v_test_value := v_test_values.get_string(i);

                    -- Process only non-special values for the first 10
                    IF UPPER(v_test_value) NOT IN ('TODAY', 'TOMORROW', 'YESTERDAY') THEN
                        -- Test parsing with detected format
                        v_parsed_date := ur_utils.parse_date_safe(
                            p_value       => v_test_value,
                            p_format_mask => v_format_mask,
                            p_start_date  => SYSDATE
                        );

                        IF v_parsed_date IS NOT NULL THEN
                            DBMS_OUTPUT.PUT_LINE('✓ Value: "' || v_test_value || '" => ' || TO_CHAR(v_parsed_date, 'DD-MON-YYYY'));
                            v_success_count := v_success_count + 1;
                        ELSE
                            DBMS_OUTPUT.PUT_LINE('✗ Value: "' || v_test_value || '" => NULL (parse failed)');
                            v_fail_count := v_fail_count + 1;
                        END IF;
                    END IF;
                END LOOP;

                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('Parse Summary (first 10 values):');
                DBMS_OUTPUT.PUT_LINE('  Success: ' || v_success_count);
                DBMS_OUTPUT.PUT_LINE('  Failed:  ' || v_fail_count);
                DBMS_OUTPUT.PUT_LINE('');

                -- Test all values for statistics
                v_success_count := 0;
                v_fail_count := 0;
                v_null_count := 0;

                DBMS_OUTPUT.PUT_LINE('Testing ALL ' || v_test_values.get_size || ' sample values...');

                FOR i IN 0 .. v_test_values.get_size - 1 LOOP
                    v_test_value := v_test_values.get_string(i);

                    IF v_test_value IS NULL THEN
                        v_null_count := v_null_count + 1;
                    ELSIF UPPER(v_test_value) NOT IN ('TODAY', 'TOMORROW', 'YESTERDAY') THEN
                        v_parsed_date := ur_utils.parse_date_safe(
                            p_value       => v_test_value,
                            p_format_mask => v_format_mask,
                            p_start_date  => SYSDATE
                        );

                        IF v_parsed_date IS NOT NULL THEN
                            v_success_count := v_success_count + 1;
                        ELSE
                            v_fail_count := v_fail_count + 1;
                            -- Show first 5 failures
                            IF v_fail_count <= 5 THEN
                                DBMS_OUTPUT.PUT_LINE('  Failed to parse: "' || v_test_value || '"');
                            END IF;
                        END IF;
                    END IF;
                END LOOP;

                DBMS_OUTPUT.PUT_LINE('');
                DBMS_OUTPUT.PUT_LINE('Complete Parse Statistics:');
                DBMS_OUTPUT.PUT_LINE('  Total values:  ' || v_test_values.get_size);
                DBMS_OUTPUT.PUT_LINE('  Parsed OK:     ' || v_success_count || ' (' || ROUND(v_success_count * 100 / NULLIF(v_test_values.get_size, 0), 2) || '%)');
                DBMS_OUTPUT.PUT_LINE('  Parse failed:  ' || v_fail_count || ' (' || ROUND(v_fail_count * 100 / NULLIF(v_test_values.get_size, 0), 2) || '%)');
                DBMS_OUTPUT.PUT_LINE('  NULL values:   ' || v_null_count);

                IF v_fail_count > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('');
                    DBMS_OUTPUT.PUT_LINE('⚠ WARNING: Some values failed to parse with detected format!');
                    DBMS_OUTPUT.PUT_LINE('  This suggests the format detection may be incomplete.');
                END IF;

            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('ERROR parsing sample values JSON: ' || SQLERRM);
            END;

        ELSE
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('SKIPPING PARSE mode test - no format detected');
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
        END IF;

    ELSE
        DBMS_OUTPUT.PUT_LINE('ERROR: Sample extraction failed');
    END IF;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('==========================================================');
    DBMS_OUTPUT.PUT_LINE('Test Complete');
    DBMS_OUTPUT.PUT_LINE('==========================================================');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('EXCEPTION: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
END;
/
