prompt --workspace/credentials/app_103_push_notifications_credentials_2
begin
--   Manifest
--     CREDENTIAL: App 103 Push Notifications Credentials (2)
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>25186177142438240
,p_default_owner=>'WKSP_DEV'
);
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(4119839180590381)
,p_name=>'App 103 Push Notifications Credentials (2)'
,p_static_id=>'App_103_Push_Notifications_Credentials_2_'
,p_authentication_type=>'KEY_PAIR'
,p_prompt_on_install=>false
);
wwv_flow_imp.component_end;
end;
/
