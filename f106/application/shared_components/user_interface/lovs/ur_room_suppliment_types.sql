prompt --application/shared_components/user_interface/lovs/ur_room_suppliment_types
begin
--   Manifest
--     UR ROOM SUPPLIMENT TYPES
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
 p_id=>wwv_flow_imp.id(16213380408982704)
,p_lov_name=>'UR ROOM SUPPLIMENT TYPES'
,p_lov_query=>'.'||wwv_flow_imp.id(16213380408982704)||'.'
,p_location=>'STATIC'
,p_version_scn=>45526921045836
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(16213695066982707)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Fixed Price'
,p_lov_return_value=>'FP'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(16214031808982708)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Price Range'
,p_lov_return_value=>'PR'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(16221596946086100)
,p_lov_disp_sequence=>12
,p_lov_disp_value=>'Fixed Price %'
,p_lov_return_value=>'FPP'
);
wwv_flow_imp.component_end;
end;
/
