prompt --application/shared_components/user_interface/lovs/ur_lead_time_types
begin
--   Manifest
--     UR LEAD TIME TYPES
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
 p_id=>wwv_flow_imp.id(12968322337095291)
,p_lov_name=>'UR LEAD TIME TYPES'
,p_lov_query=>'.'||wwv_flow_imp.id(12968322337095291)||'.'
,p_location=>'STATIC'
,p_version_scn=>45437161272367
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12968673259095293)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Date Range'
,p_lov_return_value=>'F'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12969036655095294)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Day(s)'
,p_lov_return_value=>'D'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12969419489095295)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Week(s)'
,p_lov_return_value=>'W'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12969844705095296)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Month(s)'
,p_lov_return_value=>'M'
);
wwv_flow_imp.component_end;
end;
/
