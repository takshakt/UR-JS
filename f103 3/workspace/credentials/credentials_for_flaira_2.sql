prompt --workspace/credentials/credentials_for_flaira_2
begin
--   Manifest
--     CREDENTIAL: Credentials for flaira (2)
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(8456952281859371)
,p_name=>'Credentials for flaira (2)'
,p_static_id=>'credentials_for_flaira_2_'
,p_authentication_type=>'HTTP_HEADER'
,p_valid_for_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'https://api.openai.com/v1',
''))
,p_prompt_on_install=>true
);
wwv_flow_imp.component_end;
end;
/
