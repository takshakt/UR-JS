prompt --application/shared_components/logic/application_processes/ajx_manage_report_dashboard
begin
--   Manifest
--     APPLICATION PROCESS: AJX_MANAGE_REPORT_DASHBOARD
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(13749013797549241)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJX_MANAGE_REPORT_DASHBOARD'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_clob CLOB;',
'  l_status   VARCHAR2(10);',
'  l_message  CLOB;',
'  l_icon     VARCHAR2(50);',
'  l_title    VARCHAR2(100);',
'  l_payload  CLOB;',
'  l_view_name VARCHAR2(20000);',
'BEGIN',
'  APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'  APEX_JSON.OPEN_ARRAY;',
'  APEX_JSON.OPEN_OBJECT;',
'IF apex_application.g_x01 = ''DELETE'' THEN',
'        SELECT DB_OBJECT_NAME INTO l_view_name FROM TEMP_UR_REPORTS WHERE ID = apex_application.g_x02;',
'        APEX_JSON.WRITE(''STATUS'', ''SUCCESS'');',
'                APEX_JSON.WRITE(''VIEW_NAME'', ''TEMP_RPT1_V'');',
'        APEX_JSON.WRITE(''l_message'', l_view_name);',
'      --  delete from TEMP_UR_REPORTS WHERE ID = apex_application.g_x02;',
'    --    EXECUTE IMMEDIATE '' Drop view ''||l_view_name||'' '' ;',
'elsif     apex_application.g_x01 = ''SELECT'' THEN',
'        SELECT DEFINITION INTO l_payload FROM TEMP_UR_REPORT_DASHBOARDS WHERE HOTEL_ID = apex_application.g_x02;',
'     APEX_JSON.WRITE(''STATUS'', ''SUCCESS''); ',
'        APEX_JSON.WRITE(''l_payload'', l_payload);',
'',
'elsif     apex_application.g_x01 = ''SELECT_SUMMARY'' THEN',
'        SELECT SUMMARY INTO l_payload FROM TEMP_UR_REPORT_DASHBOARDS WHERE HOTEL_ID = apex_application.g_x02;',
'     APEX_JSON.WRITE(''STATUS'', ''SUCCESS''); ',
'        APEX_JSON.WRITE(''l_payload'', l_payload);',
'',
'elsif     apex_application.g_x01 = ''INSERT_SUMMARY'' THEN',
'                 APEX_JSON.WRITE(''STATUS'', ''SUCCESS'');',
'                    MERGE INTO TEMP_UR_REPORT_DASHBOARDS T',
'            USING (',
'              SELECT apex_application.g_x02 AS HOTEL_ID, ',
'                     TO_CHAR(apex_application.g_x03) AS SUMMARY ',
'              FROM DUAL',
'            ) S',
'            ON (T.HOTEL_ID = S.HOTEL_ID)',
'            WHEN MATCHED THEN',
'              UPDATE SET T.SUMMARY     = S.SUMMARY ',
'            WHEN NOT MATCHED THEN',
'              INSERT (HOTEL_ID,  SUMMARY )',
'              VALUES (S.HOTEL_ID,   S.SUMMARY );       ',
'',
'ELSE',
'--TEMP_UR_REPORT_DASHBOARDS(HOTEL_ID , DEFINITION)',
'            --  l_payload := apex_application.g_x04;',
'   -- SELECT ''TEMP_''||REPLACE(REGEXP_REPLACE(HOTEL_NAME, ''[^A-Za-z0-9_]'', ''''), '' '', ''_'')||''_''||apex_application.g_x04||''_V'' INTO l_view_name FROM UR_HOTELS WHERE ID = apex_application.g_x03;',
'',
'        ',
'        APEX_JSON.WRITE(''STATUS'', ''SUCCESS'');',
'        MERGE INTO TEMP_UR_REPORT_DASHBOARDS T',
'USING (',
'  SELECT apex_application.g_x02 AS HOTEL_ID, ',
'         TO_CHAR(apex_application.g_x03) AS DEFINITION ',
'  FROM DUAL',
') S',
'ON (T.HOTEL_ID = S.HOTEL_ID)',
'WHEN MATCHED THEN',
'  UPDATE SET T.DEFINITION     = S.DEFINITION ',
'WHEN NOT MATCHED THEN',
'  INSERT (HOTEL_ID,  DEFINITION )',
'  VALUES (S.HOTEL_ID,   S.DEFINITION );',
'',
'',
'   ',
'END IF;',
'',
'   APEX_JSON.CLOSE_OBJECT;',
'   ',
'  -- End JSON array',
'  APEX_JSON.CLOSE_ARRAY;',
'',
'  l_clob := APEX_JSON.GET_CLOB_OUTPUT;',
'  APEX_JSON.FREE_OUTPUT;',
'',
'  HTP.P(l_clob);',
'  ',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    HTP.P(''{"error": "'' || SQLERRM || ''"}'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45648503739752
);
wwv_flow_imp.component_end;
end;
/
