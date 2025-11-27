prompt --workspace/remote_servers/flaira
begin
--   Manifest
--     REMOTE SERVER: Flaira
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
 p_id=>wwv_flow_imp.id(7949156321027603)
,p_name=>'Flaira'
,p_static_id=>'flaira'
,p_base_url=>nvl(wwv_flow_application_install.get_remote_server_base_url('flaira'),'https://api.openai.com/v1')
,p_https_host=>nvl(wwv_flow_application_install.get_remote_server_https_host('flaira'),'')
,p_server_type=>'GENERATIVE_AI'
,p_ords_timezone=>nvl(wwv_flow_application_install.get_remote_server_ords_tz('flaira'),'')
,p_credential_id=>wwv_flow_imp.id(8456952281859371)
,p_remote_sql_default_schema=>nvl(wwv_flow_application_install.get_remote_server_default_db('flaira'),'')
,p_mysql_sql_modes=>nvl(wwv_flow_application_install.get_remote_server_sql_mode('flaira'),'')
,p_prompt_on_install=>true
,p_ai_provider_type=>'OPENAI'
,p_ai_is_builder_service=>true
,p_ai_model_name=>nvl(wwv_flow_application_install.get_remote_server_ai_model('flaira'),'gpt-4.1-mini')
,p_ai_http_headers=>nvl(wwv_flow_application_install.get_remote_server_ai_headers('flaira'),'')
,p_ai_attributes=>nvl(wwv_flow_application_install.get_remote_server_ai_attrs('flaira'),'')
);
wwv_flow_imp.component_end;
end;
/
