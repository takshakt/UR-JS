prompt --application/shared_components/user_interface/lovs/ur_hotel_price_override_reason
begin
--   Manifest
--     UR HOTEL PRICE OVERRIDE REASON
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
 p_id=>wwv_flow_imp.id(17929612222098296)
,p_lov_name=>'UR HOTEL PRICE OVERRIDE REASON'
,p_lov_query=>'.'||wwv_flow_imp.id(17929612222098296)||'.'
,p_location=>'STATIC'
,p_version_scn=>45828713777832
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17929948981098298)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Competitor Price Action'
,p_lov_return_value=>'COMPETITOR_PRICE_ACTION'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17930356195098300)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Low Demand Forecast'
,p_lov_return_value=>'LOW_DEMAND_FORECAST'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17930772591098301)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'High Demand Forecast'
,p_lov_return_value=>'HIGH_DEMAND_FORECAST'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17931128140098302)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Boost Last-Minute Occupancy'
,p_lov_return_value=>'BOOST_LAST_MINUTE_OCCUPANCY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17931546006098303)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'New Local Event'
,p_lov_return_value=>'NEW_LOCAL_EVENT'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17931951672098305)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'Local Event Cancellation'
,p_lov_return_value=>'LOCAL_EVENT_CANCELLATION'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17932376180098306)
,p_lov_disp_sequence=>7
,p_lov_disp_value=>'Incorrect Rate Loaded in System'
,p_lov_return_value=>'INCORRECT_RATE_LOADED'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17932788936098307)
,p_lov_disp_sequence=>8
,p_lov_disp_value=>'Rate Parity Adjustment'
,p_lov_return_value=>'RATE_PARITY_ADJUSTMENT'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(17933512204098310)
,p_lov_disp_sequence=>10
,p_lov_disp_value=>'Package Inclusion Adjustment'
,p_lov_return_value=>'PACKAGE_INCLUSION_ADJUSTMENT'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27885590992667464)
,p_lov_disp_sequence=>11
,p_lov_disp_value=>'Rate Parity Adjustment'
,p_lov_return_value=>'PACKAGE_INCLUSION_ADJUSTMENT'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27885823382667466)
,p_lov_disp_sequence=>12
,p_lov_disp_value=>'Incorrect rate loaded in the system'
,p_lov_return_value=>'INCORRECT_RATE_LOADED_IN_THE_SYSTEM'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27886256381667467)
,p_lov_disp_sequence=>13
,p_lov_disp_value=>'Package inclusion adjustment'
,p_lov_return_value=>'RATE_PARITY_ADJUSTMENT'
);
wwv_flow_imp.component_end;
end;
/
