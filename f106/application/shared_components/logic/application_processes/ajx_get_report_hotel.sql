prompt --application/shared_components/logic/application_processes/ajx_get_report_hotel
begin
--   Manifest
--     APPLICATION PROCESS: AJX_GET_REPORT_HOTEL
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>25186177142438240
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(12853541223808182)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJX_GET_REPORT_HOTEL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_clob CLOB;',
'BEGIN',
'  APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'  APEX_JSON.OPEN_ARRAY;',
'',
'  IF apex_application.g_x01 = ''HOTEL'' THEN',
'      FOR rec IN (SELECT ID, HOTEL_NAME FROM UR_HOTELS order by upper(hotel_name)) LOOP',
'        APEX_JSON.OPEN_OBJECT;',
'        APEX_JSON.WRITE(''ID'', rec.ID);',
'        APEX_JSON.WRITE(''HOTEL_NAME'', rec.HOTEL_NAME);',
'        APEX_JSON.CLOSE_OBJECT;',
'      END LOOP;',
'',
'  ELSIF apex_application.g_x01 = ''REPORT_DETAIL'' THEN',
'     FOR rec IN (SELECT ID, NAME, DEFINITION, DEFINITION_JSON, DB_OBJECT_NAME, COLUMN_ALIAS, EXPRESSIONS_CLOB',
'                 FROM TEMP_UR_REPORTS',
'                 WHERE ID = apex_application.g_x02) LOOP',
'        APEX_JSON.OPEN_OBJECT;',
'        APEX_JSON.WRITE(''ID'', rec.ID);',
'        APEX_JSON.WRITE(''REPORT_NAME'', rec.NAME);',
'        APEX_JSON.WRITE(''DEFINITION'', rec.DEFINITION);',
'        APEX_JSON.WRITE(''DB_OBJECT_NAME'', rec.DB_OBJECT_NAME);',
'        APEX_JSON.WRITE(''DEFINITION_JSON'', rec.DEFINITION_JSON);',
'        APEX_JSON.WRITE(''COLUMN_ALIAS'', rec.COLUMN_ALIAS);',
'        APEX_JSON.WRITE(''EXPRESSIONS_CLOB'', rec.EXPRESSIONS_CLOB);',
'        APEX_JSON.CLOSE_OBJECT;',
'     END LOOP; ',
'',
'  ELSE',
'    FOR rec IN (SELECT ID, NAME, DEFINITION FROM TEMP_UR_REPORTS',
'                WHERE HOTEL_ID = apex_application.g_x02) LOOP',
'        APEX_JSON.OPEN_OBJECT;',
'        APEX_JSON.WRITE(''ID'', rec.ID);',
'        APEX_JSON.WRITE(''REPORT_NAME'', rec.NAME);',
'        APEX_JSON.WRITE(''DEFINITION'', rec.DEFINITION);',
'        APEX_JSON.CLOSE_OBJECT;',
'    END LOOP;',
'  END IF;',
'',
'  APEX_JSON.CLOSE_ARRAY;',
'',
'  l_clob := APEX_JSON.GET_CLOB_OUTPUT;',
'  APEX_JSON.FREE_OUTPUT;',
'',
'  HTP.P(l_clob);',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    APEX_JSON.FREE_OUTPUT;',
'    APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'    APEX_JSON.OPEN_ARRAY;',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(''STATUS'', ''ERROR'');',
'    APEX_JSON.WRITE(''error'', SQLERRM);',
'    APEX_JSON.CLOSE_OBJECT;',
'    APEX_JSON.CLOSE_ARRAY;',
'    HTP.P(APEX_JSON.GET_CLOB_OUTPUT);',
'    APEX_JSON.FREE_OUTPUT;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45852359724428
);
wwv_flow_imp.component_end;
end;
/
