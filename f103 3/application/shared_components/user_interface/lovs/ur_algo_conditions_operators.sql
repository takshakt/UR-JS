prompt --application/shared_components/user_interface/lovs/ur_algo_conditions_operators
begin
--   Manifest
--     UR ALGO CONDITIONS OPERATORS
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
 p_id=>wwv_flow_imp.id(14015089005891584)
,p_lov_name=>'UR ALGO CONDITIONS OPERATORS'
,p_lov_query=>'.'||wwv_flow_imp.id(14015089005891584)||'.'
,p_location=>'STATIC'
,p_version_scn=>45437402293765
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14015387103891586)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'>'
,p_lov_return_value=>'>'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14015738037891587)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'>='
,p_lov_return_value=>'>='
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14016122973891588)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'<'
,p_lov_return_value=>'<'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14016520590891589)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'<='
,p_lov_return_value=>'<='
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14016981894891591)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'='
,p_lov_return_value=>'='
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14587918036271546)
,p_lov_disp_sequence=>15
,p_lov_disp_value=>'!='
,p_lov_return_value=>'!='
);
wwv_flow_imp.component_end;
end;
/
