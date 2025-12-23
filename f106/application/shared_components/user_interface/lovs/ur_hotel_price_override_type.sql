prompt --application/shared_components/user_interface/lovs/ur_hotel_price_override_type
begin
--   Manifest
--     UR HOTEL PRICE OVERRIDE TYPE
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
 p_id=>wwv_flow_imp.id(17934818910111446)
,p_lov_name=>'UR HOTEL PRICE OVERRIDE TYPE'
,p_lov_query=>'.'||wwv_flow_imp.id(17934818910111446)||'.'
,p_location=>'STATIC'
,p_version_scn=>45693967753955
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17935150264111448)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Public'
,p_lov_return_value=>'PUBLIC'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17935510775111449)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Corporate'
,p_lov_return_value=>'CORPORATE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17935942172111450)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Group'
,p_lov_return_value=>'GROUP'
);
wwv_flow_imp.component_end;
end;
/
