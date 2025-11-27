prompt --application/shared_components/user_interface/lovs/ur_expression_functions
begin
--   Manifest
--     UR EXPRESSION FUNCTIONS
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
 p_id=>wwv_flow_imp.id(12494151488529142)
,p_lov_name=>'UR EXPRESSION FUNCTIONS'
,p_lov_query=>'.'||wwv_flow_imp.id(12494151488529142)||'.'
,p_location=>'STATIC'
,p_version_scn=>45436957582683
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12494406595529144)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'AVG (n)'
,p_lov_return_value=>'AVG (n)'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12494862246529145)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'COUNT (n)'
,p_lov_return_value=>'COUNT (n)'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12495223971529146)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'MIN (n)'
,p_lov_return_value=>'MIN (n)'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12495662882529147)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'MAX (n)'
,p_lov_return_value=>'MAX (n)'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12496076358529149)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'ABS (num)'
,p_lov_return_value=>'ABS (num)'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12496440284529150)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'CEIL (num)'
,p_lov_return_value=>'CEIL (num)'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12496818605529151)
,p_lov_disp_sequence=>7
,p_lov_disp_value=>'FLOOR (num)'
,p_lov_return_value=>'FLOOR (num)'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12497276458529152)
,p_lov_disp_sequence=>8
,p_lov_disp_value=>'ROUND (num,dec)'
,p_lov_return_value=>'ROUND (num,dec)'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12497606808529153)
,p_lov_disp_sequence=>9
,p_lov_disp_value=>'TRUNC (num,dec)'
,p_lov_return_value=>'TRUNC (num,dec)'
);
wwv_flow_imp.component_end;
end;
/
