prompt --application/shared_components/user_interface/lovs/ur_bed_types
begin
--   Manifest
--     UR BED TYPES
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
 p_id=>wwv_flow_imp.id(16203835239910193)
,p_lov_name=>'UR BED TYPES'
,p_lov_query=>'.'||wwv_flow_imp.id(16203835239910193)||'.'
,p_location=>'STATIC'
,p_version_scn=>45526920310847
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(16204192572910205)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Single'
,p_lov_return_value=>'SINGLE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(16204559276910209)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Double'
,p_lov_return_value=>'DOUBLE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(16204932022910210)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Family'
,p_lov_return_value=>'FAMILY'
);
wwv_flow_imp.component_end;
end;
/
