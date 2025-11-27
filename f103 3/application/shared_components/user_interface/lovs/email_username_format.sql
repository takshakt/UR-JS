prompt --application/shared_components/user_interface/lovs/email_username_format
begin
--   Manifest
--     EMAIL_USERNAME_FORMAT
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(8695761987923030)
,p_lov_name=>'EMAIL_USERNAME_FORMAT'
,p_lov_query=>'.'||wwv_flow_imp.id(8695761987923030)||'.'
,p_location=>'STATIC'
,p_version_scn=>45069603846914
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(8696023594923031)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Email Addresses'
,p_lov_return_value=>'EMAIL'
);
wwv_flow_imp.component_end;
end;
/
