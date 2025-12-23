prompt --application/shared_components/user_interface/lovs/ur_cancellation_reason
begin
--   Manifest
--     UR CANCELLATION REASON
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
 p_id=>wwv_flow_imp.id(14497219589034529)
,p_lov_name=>'UR CANCELLATION REASON'
,p_lov_query=>'.'||wwv_flow_imp.id(14497219589034529)||'.'
,p_location=>'STATIC'
,p_version_scn=>45437391358336
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14497545620034531)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Customer Illness or Emergency'
,p_lov_return_value=>'Customer Illness or Emergency'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14497973368034533)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Travel Delay or Transportation Issues'
,p_lov_return_value=>'Travel Delay or Transportation Issues'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14498353231034534)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Change of Plans / Itinerary'
,p_lov_return_value=>'Change of Plans / Itinerary'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14498722280034535)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Hotel Overbooking / No Availability'
,p_lov_return_value=>'Hotel Overbooking / No Availability'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14499142091034537)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'Billing or Payment Issues'
,p_lov_return_value=>'Billing or Payment Issues'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14499561158034538)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'Weather Conditions or Natural Disasters'
,p_lov_return_value=>'Weather Conditions or Natural Disasters'
);
wwv_flow_imp.component_end;
end;
/
