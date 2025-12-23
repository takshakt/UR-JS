prompt --application/shared_components/user_interface/lovs/ur_user_status
begin
--   Manifest
--     UR USER STATUS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>25186177142438240
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(15589373391739364)
,p_lov_name=>'UR USER STATUS'
,p_lov_query=>'.'||wwv_flow_imp.id(15589373391739364)||'.'
,p_location=>'STATIC'
,p_version_scn=>45526804264543
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15589664894739366)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Pending'
,p_lov_return_value=>'Pending'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15590056436739368)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Approved'
,p_lov_return_value=>'Approved'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15590456122739369)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Inactive'
,p_lov_return_value=>'Inactive'
);
wwv_flow_imp.component_end;
end;
/
