DECLARE
  l_clob CLOB;
  l_status   VARCHAR2(10);
  l_message  CLOB;
  l_icon     VARCHAR2(50);
  l_title    VARCHAR2(100);
  l_payload  CLOB;
  l_view_name VARCHAR2(20000);
  l_report_id VARCHAR2(20000);
BEGIN
  APEX_JSON.INITIALIZE_CLOB_OUTPUT;
  APEX_JSON.OPEN_ARRAY;
  APEX_JSON.OPEN_OBJECT;
IF apex_application.g_x01 = 'DELETE' THEN
        SELECT DB_OBJECT_NAME INTO l_view_name FROM TEMP_UR_REPORTS WHERE ID = apex_application.g_x02;
        APEX_JSON.WRITE('STATUS', 'SUCCESS');
                APEX_JSON.WRITE('VIEW_NAME', 'TEMP_RPT1_V');
        APEX_JSON.WRITE('l_message', l_view_name);
        delete from TEMP_UR_REPORTS WHERE ID = apex_application.g_x02;
        EXECUTE IMMEDIATE ' Drop view '||l_view_name||' ' ;

ELSIF apex_application.g_x01 = 'UPDATE_ALIAS' THEN     
              APEX_JSON.WRITE('STATUS', 'SUCCESS');
                    MERGE INTO TEMP_UR_REPORTS T
            USING (
              SELECT apex_application.g_x02 AS HOTEL_ID,
                     apex_application.g_x03 AS REPORT_NAME ,
                     TO_CHAR(apex_application.g_x04) AS COLUMN_ALIAS
              FROM DUAL
            ) S
            ON (T.name = S.REPORT_NAME AND T.HOTEL_ID = S.HOTEL_ID)
            WHEN MATCHED THEN
              UPDATE SET T.COLUMN_ALIAS = S.COLUMN_ALIAS ;

              APEX_JSON.WRITE('l_message', 'DATA UPDATED');


ELSIF apex_application.g_x01 = 'UPDATE_EXPRESSION' THEN     
              APEX_JSON.WRITE('STATUS', 'SUCCESS');
                    MERGE INTO TEMP_UR_REPORTS T
            USING (
              SELECT apex_application.g_x02 AS HOTEL_ID,
                     apex_application.g_x03 AS REPORT_NAME ,
                     TO_CHAR(apex_application.g_x04) AS EXPRESSIONS_CLOB
              FROM DUAL
            ) S
            ON (T.name = S.REPORT_NAME AND T.HOTEL_ID = S.HOTEL_ID)
            WHEN MATCHED THEN
              UPDATE SET T.EXPRESSIONS_CLOB = S.EXPRESSIONS_CLOB ;

              APEX_JSON.WRITE('l_message', 'DATA UPDATED');

ELSE

              l_payload := apex_application.g_x04;
    SELECT 'TEMP_'||REPLACE(REGEXP_REPLACE(HOTEL_NAME, '[^A-Za-z0-9_]', ''), ' ', '_')||'_'||apex_application.g_x04||'_V' INTO l_view_name FROM UR_HOTELS WHERE ID = apex_application.g_x03;
    EXECUTE IMMEDIATE ' CREATE OR REPLACE VIEW '||l_view_name||' AS '||apex_application.g_x01||'  ';
        
        APEX_JSON.WRITE('STATUS', 'SUCCESS');
        APEX_JSON.WRITE('VIEW_NAME', 'TEMP_RPT1_V'); 
        MERGE INTO TEMP_UR_REPORTS T
USING (
  SELECT apex_application.g_x03 AS HOTEL_ID,
         apex_application.g_x04 AS REPORT_NAME,   
         TO_CHAR(apex_application.g_x02) AS DEFINITION,
         l_view_name AS DB_OBJECT_NAME,
         TO_CHAR(apex_application.g_x05) AS DEFINITION_JSON
  FROM DUAL
) S
ON (T.name = S.REPORT_NAME AND T.HOTEL_ID = S.HOTEL_ID)
WHEN MATCHED THEN
  UPDATE SET T.DEFINITION     = S.DEFINITION,
             T.DB_OBJECT_NAME = S.DB_OBJECT_NAME,
             T.DEFINITION_JSON = S.DEFINITION_JSON
WHEN NOT MATCHED THEN
  INSERT (HOTEL_ID, name, DEFINITION, DB_OBJECT_NAME,DEFINITION_JSON,COLUMN_ALIAS, EXPRESSIONS_CLOB)
  VALUES (S.HOTEL_ID, S.REPORT_NAME, S.DEFINITION, S.DB_OBJECT_NAME,S.DEFINITION_JSON,S.DEFINITION_JSON 
  , '{"columnConfiguration": {"hotel": null,"template": null,"selectedColumns": []},"columnMetadata": [],"formulas": {},"filters": {},"conditionalFormatting": {}}' );

        SELECT ID INTO l_report_id FROM TEMP_UR_REPORTS WHERE name = apex_application.g_x04 AND HOTEL_ID = apex_application.g_x03;

  
    APEX_JSON.WRITE('l_message', l_view_name);
    APEX_JSON.WRITE('l_report_id', l_report_id);
END IF;

   APEX_JSON.CLOSE_OBJECT;
   
  -- End JSON array
  APEX_JSON.CLOSE_ARRAY;

  l_clob := APEX_JSON.GET_CLOB_OUTPUT;
  APEX_JSON.FREE_OUTPUT;

  HTP.P(l_clob);
  
EXCEPTION
  WHEN OTHERS THEN
    HTP.P('{"error": "' || SQLERRM || '"}');
END;