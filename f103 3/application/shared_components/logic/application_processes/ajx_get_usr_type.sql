prompt --application/shared_components/logic/application_processes/ajx_get_usr_type
begin
--   Manifest
--     APPLICATION PROCESS: AJX_GET_USR_TYPE
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
 p_id=>wwv_flow_imp.id(28714487824000760)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJX_GET_USR_TYPE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_user_type UR_USERS.user_type%TYPE;',
'  l_username  VARCHAR2(255) := APEX_APPLICATION.G_X01;',
'BEGIN',
'  SELECT user_type',
'    INTO l_user_type',
'    FROM UR_USERS',
'   WHERE UPPER(user_name) = UPPER(l_username);',
'',
'  -- Output valid JSON',
'  HTP.P(''{"type": "'' || REPLACE(l_user_type, ''"'', ''\"'') || ''"}'');',
'',
'EXCEPTION',
'  WHEN NO_DATA_FOUND THEN',
'    HTP.P(''{"type": "NOT_FOUND"}'');',
'  WHEN OTHERS THEN',
'    HTP.P(''{"type": "ERROR", "message": "'' || REPLACE(SQLERRM, ''"'', ''\"'') || ''"}'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45851669647072
);
wwv_flow_imp.component_end;
end;
/
