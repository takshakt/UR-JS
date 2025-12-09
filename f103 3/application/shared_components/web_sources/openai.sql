prompt --application/shared_components/web_sources/openai
begin
--   Manifest
--     WEB SOURCE: OpenAI
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_web_source_module(
 p_id=>wwv_flow_imp.id(9333912540250188)
,p_name=>'OpenAI'
,p_static_id=>'openai'
,p_web_source_type=>'NATIVE_HTTP'
,p_data_profile_id=>wwv_flow_imp.id(9331197531250164)
,p_remote_server_id=>wwv_flow_imp.id(9330950226250161)
,p_url_path_prefix=>'/chat/completions'
,p_credential_id=>wwv_flow_imp.id(9330674445250158)
,p_version_scn=>45069637622803
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(9334578383250199)
,p_web_src_module_id=>wwv_flow_imp.id(9333912540250188)
,p_name=>'Content-Type'
,p_param_type=>'HEADER'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'application/json'
,p_is_static=>true
);
wwv_flow_imp_shared.create_web_source_operation(
 p_id=>wwv_flow_imp.id(9334139137250194)
,p_web_src_module_id=>wwv_flow_imp.id(9333912540250188)
,p_operation=>'POST'
,p_database_operation=>'FETCH_COLLECTION'
,p_url_pattern=>'.'
,p_request_body_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'{',
'  "model": "gpt-4.1-mini",',
'  "messages": [',
'    {"role": "system", "content": "#system_role#"},',
'    {"role": "user", "content": "#user_prompt#"}',
'  ]',
'}'))
,p_force_error_for_http_404=>false
,p_allow_fetch_all_rows=>false
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(9335302558282055)
,p_web_src_module_id=>wwv_flow_imp.id(9333912540250188)
,p_web_src_operation_id=>wwv_flow_imp.id(9334139137250194)
,p_name=>'system_role'
,p_param_type=>'BODY'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
,p_value=>'You are a helpful assistant.'
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(9336788228291760)
,p_web_src_module_id=>wwv_flow_imp.id(9333912540250188)
,p_web_src_operation_id=>wwv_flow_imp.id(9334139137250194)
,p_name=>'user_prompt'
,p_param_type=>'BODY'
,p_data_type=>'VARCHAR2'
,p_is_required=>false
);
wwv_flow_imp_shared.create_web_source_param(
 p_id=>wwv_flow_imp.id(9337327361307745)
,p_web_src_module_id=>wwv_flow_imp.id(9333912540250188)
,p_web_src_operation_id=>wwv_flow_imp.id(9334139137250194)
,p_name=>'response'
,p_param_type=>'BODY'
,p_is_required=>false
,p_direction=>'OUT'
);
wwv_flow_imp.component_end;
end;
/
