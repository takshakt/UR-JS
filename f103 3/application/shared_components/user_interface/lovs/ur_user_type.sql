prompt --application/shared_components/user_interface/lovs/ur_user_type
begin
--   Manifest
--     UR USER TYPE
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
 p_id=>wwv_flow_imp.id(15587918992732346)
,p_lov_name=>'UR USER TYPE'
,p_lov_query=>'.'||wwv_flow_imp.id(15587918992732346)||'.'
,p_location=>'STATIC'
,p_version_scn=>45526804238167
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15588229397732349)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Employee'
,p_lov_return_value=>'Employee'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15588693354732352)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Contractor'
,p_lov_return_value=>'Contractor'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15589034604732354)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Hotel Team'
,p_lov_return_value=>'Hotel Team'
);
wwv_flow_imp.component_end;
end;
/
