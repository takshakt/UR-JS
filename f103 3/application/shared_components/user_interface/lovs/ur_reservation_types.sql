prompt --application/shared_components/user_interface/lovs/ur_reservation_types
begin
--   Manifest
--     UR RESERVATION TYPES
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(14387135225367601)
,p_lov_name=>'UR RESERVATION TYPES'
,p_lov_query=>'.'||wwv_flow_imp.id(14387135225367601)||'.'
,p_location=>'STATIC'
,p_version_scn=>45828679441477
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14387443234367603)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Transient'
,p_lov_return_value=>'TS'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14388215077367606)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Groups'
,p_lov_return_value=>'GR'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14387842963367605)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Crew'
,p_lov_return_value=>'CR'
);
wwv_flow_imp.component_end;
end;
/
