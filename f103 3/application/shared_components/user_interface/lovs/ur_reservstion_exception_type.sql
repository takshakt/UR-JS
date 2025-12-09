prompt --application/shared_components/user_interface/lovs/ur_reservstion_exception_type
begin
--   Manifest
--     UR RESERVSTION EXCEPTION TYPE
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
 p_id=>wwv_flow_imp.id(14433946398557917)
,p_lov_name=>'UR RESERVSTION EXCEPTION TYPE'
,p_lov_query=>'.'||wwv_flow_imp.id(14433946398557917)||'.'
,p_location=>'STATIC'
,p_version_scn=>45693066506887
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14434291952557919)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Late Cancellation'
,p_lov_return_value=>'LC'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14434652756557920)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'No Show'
,p_lov_return_value=>'NS'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14435009620557921)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Rebate'
,p_lov_return_value=>'RB'
);
wwv_flow_imp.component_end;
end;
/
