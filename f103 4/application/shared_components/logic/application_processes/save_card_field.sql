prompt --application/shared_components/logic/application_processes/save_card_field
begin
--   Manifest
--     APPLICATION PROCESS: SAVE_CARD_FIELD
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
 p_id=>wwv_flow_imp.id(11403687349560056)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_CARD_FIELD'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_id        VARCHAR2(255) := APEX_APPLICATION.G_X01;',
'  l_field     VARCHAR2(255) := APEX_APPLICATION.G_X02;',
'  l_new_value VARCHAR2(4000) := APEX_APPLICATION.G_X03;',
'  l_sql       VARCHAR2(4000);',
'BEGIN',
'  IF l_id IS NULL OR l_field IS NULL THEN',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(''success'', FALSE);',
'    APEX_JSON.WRITE(''message'', ''ID and Field Name cannot be null.'');',
'    APEX_JSON.CLOSE_OBJECT;',
'    RETURN;',
'  END IF;',
'',
'  l_sql := ''UPDATE UR_HOTELS SET "'' || l_field || ''" = :new_value WHERE ID = :id'';',
'',
'  EXECUTE IMMEDIATE l_sql',
'    USING l_new_value, l_id;',
'',
'  COMMIT; ',
'',
'  APEX_JSON.OPEN_OBJECT;',
'  APEX_JSON.WRITE(''success'', TRUE);',
'  APEX_JSON.WRITE(''message'', ''Update successful for '' || l_field || '' to '' || l_new_value);',
'  APEX_JSON.CLOSE_OBJECT;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    ROLLBACK; -- Rollback on error',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(''success'', FALSE);',
'    APEX_JSON.WRITE(''message'', SQLERRM);',
'    APEX_JSON.CLOSE_OBJECT;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45373211511323
);
wwv_flow_imp.component_end;
end;
/
