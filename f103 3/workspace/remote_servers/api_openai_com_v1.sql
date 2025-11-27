prompt --workspace/remote_servers/api_openai_com_v1
begin
--   Manifest
--     REMOTE SERVER: api-openai-com-v1
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_imp_workspace.create_remote_server(
 p_id=>wwv_flow_imp.id(9330950226250161)
,p_name=>'api-openai-com-v1'
,p_static_id=>'api_openai_com_v1'
,p_base_url=>nvl(wwv_flow_application_install.get_remote_server_base_url('api_openai_com_v1'),'https://api.openai.com/v1/')
,p_https_host=>nvl(wwv_flow_application_install.get_remote_server_https_host('api_openai_com_v1'),'')
,p_server_type=>'WEB_SERVICE'
,p_ords_timezone=>nvl(wwv_flow_application_install.get_remote_server_ords_tz('api_openai_com_v1'),'')
,p_remote_sql_default_schema=>nvl(wwv_flow_application_install.get_remote_server_default_db('api_openai_com_v1'),'')
,p_mysql_sql_modes=>nvl(wwv_flow_application_install.get_remote_server_sql_mode('api_openai_com_v1'),'')
,p_prompt_on_install=>false
,p_ai_is_builder_service=>false
,p_ai_model_name=>nvl(wwv_flow_application_install.get_remote_server_ai_model('api_openai_com_v1'),'')
,p_ai_http_headers=>nvl(wwv_flow_application_install.get_remote_server_ai_headers('api_openai_com_v1'),'')
,p_ai_attributes=>nvl(wwv_flow_application_install.get_remote_server_ai_attrs('api_openai_com_v1'),'')
);
wwv_flow_imp.component_end;
end;
/
