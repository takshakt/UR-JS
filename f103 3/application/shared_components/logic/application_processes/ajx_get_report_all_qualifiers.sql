prompt --application/shared_components/logic/application_processes/ajx_get_report_all_qualifiers
begin
--   Manifest
--     APPLICATION PROCESS: AJX_GET_REPORT_ALL_QUALIFIERS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(18133869080481287)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJX_GET_REPORT_ALL_QUALIFIERS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_json CLOB;',
'BEGIN',
'    APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'    APEX_JSON.OPEN_OBJECT; -- root',
'    APEX_JSON.OPEN_ARRAY(''data''); -- array start',
'',
'    FOR rec IN (',
'        SELECT NAME,',
'               SUBSTR(KEY, 1, INSTR(KEY, ''.'') - 1) AS temp_name  ',
'        FROM UR_ALGO_ATTRIBUTES ',
'        WHERE ATTRIBUTE_QUALIFIER = ''STAY_DATE'' ',
'          AND HOTEL_ID = APEX_APPLICATION.G_X01',
'    ) LOOP',
'        APEX_JSON.OPEN_OBJECT;',
'        APEX_JSON.WRITE(''name'', rec.NAME);',
'        APEX_JSON.WRITE(''temp_name'', rec.temp_name);',
'        APEX_JSON.CLOSE_OBJECT;',
'    END LOOP;',
'',
'    APEX_JSON.CLOSE_ARRAY; -- data',
'    APEX_JSON.CLOSE_OBJECT; -- root',
'',
'    l_json := APEX_JSON.GET_CLOB_OUTPUT;',
'    APEX_JSON.FREE_OUTPUT;',
'    HTP.P(l_json);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45648437039551
);
wwv_flow_imp.component_end;
end;
/
