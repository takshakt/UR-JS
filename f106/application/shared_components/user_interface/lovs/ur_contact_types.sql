prompt --application/shared_components/user_interface/lovs/ur_contact_types
begin
--   Manifest
--     UR CONTACT TYPES
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
 p_id=>wwv_flow_imp.id(12370700856411856)
,p_lov_name=>'UR CONTACT TYPES'
,p_lov_query=>'.'||wwv_flow_imp.id(12370700856411856)||'.'
,p_location=>'STATIC'
,p_version_scn=>45436930126914
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12371057759411866)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Sales'
,p_lov_return_value=>'SALES'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12371462215411869)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Frontdesk'
,p_lov_return_value=>'FRONTDESK'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12371849163411870)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Managment'
,p_lov_return_value=>'MANAGMENT'
);
wwv_flow_imp.component_end;
end;
/
