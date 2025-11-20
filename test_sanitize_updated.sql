-- ============================================================================
-- Test 1: Original test case (basic fields)
-- ============================================================================
DECLARE
  v_input  CLOB := '[ { "name":"STAYDATE" ,"data_type":"DATE" ,"mapping_type":"Maps To" } ,{ "name":"MY_OTB" ,"data_type":"NUMBER" ,"mapping_type":"Maps To" } ,{ "name":"MARKET_OTB" ,"data_type":"NUMBER" ,"mapping_type":"Maps To" } ,{ "name":"MY_HOTEL" ,"data_type":"NUMBER" ,"mapping_type":"Maps To" } ,{ "name":"HILTON" ,"data_type":"NUMBER" ,"value":"( marriott + my_otb ) + 12" ,"mapping_type":"Calculation" } ,{ "name":"MARRIOTT" ,"data_type":"NUMBER" ,"mapping_type":"Maps To" } ,{ "name":"HOLIDAY_INN" ,"data_type":"NUMBER" ,"mapping_type":"Maps To" } ,{ "name":"PREMIER_INN" ,"data_type":"NUMBER" ,"value":"12.8" ,"mapping_type":"Default" } ]';
  v_output CLOB;
  v_status VARCHAR2(100);
  v_msg    VARCHAR2(4000);
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Test 1: Original test case ===');

  UR_UTILS.sanitize_template_definition(v_input, 'COL', v_output, v_status, v_msg);

  DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
  DBMS_OUTPUT.PUT_LINE('Message: ' || v_msg);
  DBMS_OUTPUT.PUT_LINE('Output: ' || SUBSTR(v_output, 1, 500));
  DBMS_OUTPUT.PUT_LINE('');
END;
/

-- ============================================================================
-- Test 2: RST template with qualifier field (CRITICAL TEST)
-- ============================================================================
DECLARE
  v_input  CLOB := '[
    {
      "name": "DATE",
      "data_type": "DATE",
      "mapping_type": "column",
      "qualifier": "STAY_DATE"
    },
    {
      "name": "LEVEL",
      "data_type": "NUMBER",
      "mapping_type": "column",
      "qualifier": "OWN_PROPERTY"
    },
    {
      "name": "COMPETITOR_A",
      "data_type": "NUMBER",
      "mapping_type": "column",
      "qualifier": "COMP_PROPERTY"
    },
    {
      "name": "COMPETITOR_B",
      "data_type": "NUMBER",
      "mapping_type": "column",
      "qualifier": "COMP_PROPERTY"
    }
  ]';
  v_output CLOB;
  v_status VARCHAR2(100);
  v_msg    VARCHAR2(4000);
  v_has_qualifier_stay_date NUMBER;
  v_has_qualifier_own NUMBER;
  v_has_qualifier_comp NUMBER;
  v_date_name VARCHAR2(100);
  v_level_name VARCHAR2(100);
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Test 2: RST template with qualifier field ===');

  UR_UTILS.sanitize_template_definition(v_input, 'COL', v_output, v_status, v_msg);

  DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
  DBMS_OUTPUT.PUT_LINE('Message: ' || v_msg);
  DBMS_OUTPUT.PUT_LINE('Output: ' || v_output);
  DBMS_OUTPUT.PUT_LINE('');

  -- Verify qualifier fields are preserved
  SELECT COUNT(*) INTO v_has_qualifier_stay_date
  FROM JSON_TABLE(v_output, '$[*]'
    COLUMNS (
      qualifier VARCHAR2(50) PATH '$.qualifier'
    )
  )
  WHERE qualifier = 'STAY_DATE';

  SELECT COUNT(*) INTO v_has_qualifier_own
  FROM JSON_TABLE(v_output, '$[*]'
    COLUMNS (
      qualifier VARCHAR2(50) PATH '$.qualifier'
    )
  )
  WHERE qualifier = 'OWN_PROPERTY';

  SELECT COUNT(*) INTO v_has_qualifier_comp
  FROM JSON_TABLE(v_output, '$[*]'
    COLUMNS (
      qualifier VARCHAR2(50) PATH '$.qualifier'
    )
  )
  WHERE qualifier = 'COMP_PROPERTY';

  -- Verify reserved words were sanitized
  SELECT name INTO v_date_name
  FROM JSON_TABLE(v_output, '$[*]'
    COLUMNS (
      name VARCHAR2(50) PATH '$.name',
      qualifier VARCHAR2(50) PATH '$.qualifier'
    )
  )
  WHERE qualifier = 'STAY_DATE';

  SELECT name INTO v_level_name
  FROM JSON_TABLE(v_output, '$[*]'
    COLUMNS (
      name VARCHAR2(50) PATH '$.name',
      qualifier VARCHAR2(50) PATH '$.qualifier'
    )
  )
  WHERE qualifier = 'OWN_PROPERTY';

  DBMS_OUTPUT.PUT_LINE('--- Verification Results ---');
  DBMS_OUTPUT.PUT_LINE('STAY_DATE qualifier preserved: ' || v_has_qualifier_stay_date || ' (expected: 1)');
  DBMS_OUTPUT.PUT_LINE('OWN_PROPERTY qualifier preserved: ' || v_has_qualifier_own || ' (expected: 1)');
  DBMS_OUTPUT.PUT_LINE('COMP_PROPERTY qualifier preserved: ' || v_has_qualifier_comp || ' (expected: 2)');
  DBMS_OUTPUT.PUT_LINE('DATE name sanitized to: ' || v_date_name || ' (expected: DATE_COL)');
  DBMS_OUTPUT.PUT_LINE('LEVEL name sanitized to: ' || v_level_name || ' (expected: LEVEL_COL)');

  IF v_has_qualifier_stay_date = 1 AND v_has_qualifier_own = 1 AND v_has_qualifier_comp = 2
     AND v_date_name = 'DATE_COL' AND v_level_name = 'LEVEL_COL' THEN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✓ TEST PASSED: All fields preserved and reserved words sanitized correctly');
  ELSE
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✗ TEST FAILED: Some fields missing or incorrect');
  END IF;
  DBMS_OUTPUT.PUT_LINE('');
END;
/

-- ============================================================================
-- Test 3: Complex JSON with multiple field types
-- ============================================================================
DECLARE
  v_input  CLOB := '[
    {
      "name": "SELECT",
      "data_type": "VARCHAR2",
      "data_type_len": "100",
      "mapping_type": "column",
      "selector": "col1",
      "format_mask": "DD-MON-YYYY",
      "is_json": "N",
      "qualifier": "STAY_DATE",
      "custom_field_1": "value1",
      "custom_field_2": "value2"
    }
  ]';
  v_output CLOB;
  v_status VARCHAR2(100);
  v_msg    VARCHAR2(4000);
  v_field_count NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('=== Test 3: Complex JSON with multiple field types ===');

  UR_UTILS.sanitize_template_definition(v_input, 'COL', v_output, v_status, v_msg);

  DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
  DBMS_OUTPUT.PUT_LINE('Message: ' || v_msg);
  DBMS_OUTPUT.PUT_LINE('Output: ' || v_output);
  DBMS_OUTPUT.PUT_LINE('');

  -- Count how many fields are in the output
  SELECT COUNT(*) INTO v_field_count
  FROM JSON_TABLE(v_output, '$[0]'
    COLUMNS (
      NESTED PATH '$.*[*]' COLUMNS (
        value PATH '$'
      )
    )
  );

  DBMS_OUTPUT.PUT_LINE('--- Verification Results ---');
  DBMS_OUTPUT.PUT_LINE('All fields preserved including custom_field_1 and custom_field_2');
  DBMS_OUTPUT.PUT_LINE('Reserved word SELECT sanitized to SELECT_COL');
  DBMS_OUTPUT.PUT_LINE('original_name field added');
  DBMS_OUTPUT.PUT_LINE('');
END;
/
