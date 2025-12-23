prompt --application/shared_components/user_interface/lovs/ur_mapping_types
begin
--   Manifest
--     UR MAPPING TYPES
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
 p_id=>wwv_flow_imp.id(10018491218303621)
,p_lov_name=>'UR MAPPING TYPES'
,p_lov_query=>'.'||wwv_flow_imp.id(10018491218303621)||'.'
,p_location=>'STATIC'
,p_version_scn=>45526806866356
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(10018727488303640)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Maps To'
,p_lov_return_value=>'Maps To'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(10019171905303644)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Ignore'
,p_lov_return_value=>'Ignore'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(10019553827303645)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Default'
,p_lov_return_value=>'Default'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15644370086435347)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Calculation'
,p_lov_return_value=>'Calculation'
);
wwv_flow_imp.component_end;
end;
/
