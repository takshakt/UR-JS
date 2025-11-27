prompt --application/shared_components/user_interface/lovs/ur_event_score
begin
--   Manifest
--     UR EVENT SCORE
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
 p_id=>wwv_flow_imp.id(14574086177037113)
,p_lov_name=>'UR EVENT SCORE'
,p_lov_query=>'.'||wwv_flow_imp.id(14574086177037113)||'.'
,p_location=>'STATIC'
,p_version_scn=>45437401414603
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14574388818037118)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'+3'
,p_lov_return_value=>'+3'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14574754511037121)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'+2'
,p_lov_return_value=>'+2'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14575119784037122)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'+1'
,p_lov_return_value=>'+1'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14575591602037123)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'0'
,p_lov_return_value=>'0'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14575959331037124)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'-1'
,p_lov_return_value=>'-1'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14576388881037125)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'-2'
,p_lov_return_value=>'-2'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14576746074037126)
,p_lov_disp_sequence=>7
,p_lov_disp_value=>'-3'
,p_lov_return_value=>'-3'
);
wwv_flow_imp.component_end;
end;
/
