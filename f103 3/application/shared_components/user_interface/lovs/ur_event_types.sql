prompt --application/shared_components/user_interface/lovs/ur_event_types
begin
--   Manifest
--     UR EVENT TYPES
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
 p_id=>wwv_flow_imp.id(12921639157580743)
,p_lov_name=>'UR EVENT TYPES'
,p_lov_query=>'.'||wwv_flow_imp.id(12921639157580743)||'.'
,p_location=>'STATIC'
,p_version_scn=>45437154892977
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12921955471580748)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Weddings'
,p_lov_return_value=>'Weddings'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12922359675580751)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Product Launch'
,p_lov_return_value=>'Product Launch'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12922799224580753)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Networking Events'
,p_lov_return_value=>'Networking Events'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12923129634580754)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Birthdays and Anniversaries'
,p_lov_return_value=>'Birthdays and Anniversaries'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(12923593850580755)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'Community Festivals'
,p_lov_return_value=>'Community Festivals'
);
wwv_flow_imp.component_end;
end;
/
