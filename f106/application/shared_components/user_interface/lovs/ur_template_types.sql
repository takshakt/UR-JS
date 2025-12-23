prompt --application/shared_components/user_interface/lovs/ur_template_types
begin
--   Manifest
--     UR TEMPLATE TYPES
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
 p_id=>wwv_flow_imp.id(9646161429519087)
,p_lov_name=>'UR TEMPLATE TYPES'
,p_lov_query=>'.'||wwv_flow_imp.id(9646161429519087)||'.'
,p_location=>'STATIC'
,p_version_scn=>45437401578093
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(9646423725519095)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'BI'
,p_lov_return_value=>'BI'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(9646886307519099)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'PMS'
,p_lov_return_value=>'PMS'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(9647224804519100)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'RMS'
,p_lov_return_value=>'RMS'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14578695835077247)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Rate Shopping Tool'
,p_lov_return_value=>'RST'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(9654890870569477)
,p_lov_disp_sequence=>14
,p_lov_disp_value=>'Manual Hotel Algorithm Attributes'
,p_lov_return_value=>'MANUAL_ALGO_SETUP_ATTR'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(9647617239519101)
,p_lov_disp_sequence=>99
,p_lov_disp_value=>'Others'
,p_lov_return_value=>'OTHERS'
);
wwv_flow_imp.component_end;
end;
/
