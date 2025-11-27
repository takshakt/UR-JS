prompt --application/shared_components/user_interface/lovs/ur_attribute_qualifiers
begin
--   Manifest
--     UR ATTRIBUTE QUALIFIERS
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
 p_id=>wwv_flow_imp.id(10464223217255649)
,p_lov_name=>'UR ATTRIBUTE QUALIFIERS'
,p_lov_query=>'.'||wwv_flow_imp.id(10464223217255649)||'.'
,p_location=>'STATIC'
,p_version_scn=>45828717594919
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(10464954710255662)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Occupancy'
,p_lov_return_value=>'OCCUPANCY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(10465322322255663)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Booking Date'
,p_lov_return_value=>'BOOKING_DATE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(10465713222255664)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Stay Date'
,p_lov_return_value=>'STAY_DATE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27887399380787411)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'Stay Day of week'
,p_lov_return_value=>'STAY_DAY_OF_WEEK'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27887603687787413)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'Revenue'
,p_lov_return_value=>'REVENUE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27888017470787414)
,p_lov_disp_sequence=>7
,p_lov_disp_value=>'Room nights'
,p_lov_return_value=>'ROOM_NIGHTS'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27888401241787415)
,p_lov_disp_sequence=>8
,p_lov_disp_value=>'Revenue STLY'
,p_lov_return_value=>'REVENUE_STLY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27888864233787416)
,p_lov_disp_sequence=>9
,p_lov_disp_value=>'Groups RNTs'
,p_lov_return_value=>'GROUPS_RNTS'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27889255835787418)
,p_lov_disp_sequence=>10
,p_lov_disp_value=>'Groups RNTs STLY'
,p_lov_return_value=>'GROUPS_RNTS_STLY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27889758846809966)
,p_lov_disp_sequence=>11
,p_lov_disp_value=>'LY RNTs'
,p_lov_return_value=>'LY_RNTS'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27890068393809968)
,p_lov_disp_sequence=>12
,p_lov_disp_value=>'LY Occupancy'
,p_lov_return_value=>'LY_OCCUPANCY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27890475069809969)
,p_lov_disp_sequence=>13
,p_lov_disp_value=>'LY ADR'
,p_lov_return_value=>'LY_ADR'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14141713501941682)
,p_lov_disp_sequence=>14
,p_lov_disp_value=>'Own Property'
,p_lov_return_value=>'OWN_PROPERTY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27890834197829868)
,p_lov_disp_sequence=>15
,p_lov_disp_value=>'Comp Set LY Occupancy'
,p_lov_return_value=>'COMP_SET_LY_OCCUPANCY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27891187649829869)
,p_lov_disp_sequence=>16
,p_lov_disp_value=>'Comp Set LY ADR'
,p_lov_return_value=>'COMP_SET_LY_ADR'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27891557732829870)
,p_lov_disp_sequence=>17
,p_lov_disp_value=>'Out Of Order Rooms'
,p_lov_return_value=>'OUT_OF_ORDER_ROOMS'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27891983536829872)
,p_lov_disp_sequence=>18
,p_lov_disp_value=>'Rewards Redemption'
,p_lov_return_value=>'REWARDS_REDEMPTION'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27892385374829873)
,p_lov_disp_sequence=>19
,p_lov_disp_value=>'Rewards Redemption LY'
,p_lov_return_value=>'REWARDS_REDEMPTION_LY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27892771370829874)
,p_lov_disp_sequence=>20
,p_lov_disp_value=>'RMS rate'
,p_lov_return_value=>'RMS_RATE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(14579344627203815)
,p_lov_disp_sequence=>24
,p_lov_disp_value=>'Competitor Property'
,p_lov_return_value=>'COMP_PROPERTY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27943457460583408)
,p_lov_disp_sequence=>25
,p_lov_disp_value=>'Room nights STLY'
,p_lov_return_value=>'ROOM_NIGHTS_STLY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15398211188674859)
,p_lov_disp_sequence=>34
,p_lov_disp_value=>'Market Demand'
,p_lov_return_value=>'MARKET_DEMAND'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(15866568610571526)
,p_lov_disp_sequence=>44
,p_lov_disp_value=>'Current Rate'
,p_lov_return_value=>'CURRENT_RATE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(18863351915383087)
,p_lov_disp_sequence=>54
,p_lov_disp_value=>'Unique'
,p_lov_return_value=>'UNIQUE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(18863803134388538)
,p_lov_disp_sequence=>64
,p_lov_disp_value=>'Manual Price Override'
,p_lov_return_value=>'MANUAL_PRICE_OVERRIDE'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27893390752891845)
,p_lov_disp_sequence=>65
,p_lov_disp_value=>'Pick up Room nights -1 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_1_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27893640042891846)
,p_lov_disp_sequence=>66
,p_lov_disp_value=>'Pick up Revenue -1 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_1_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27894092494891847)
,p_lov_disp_sequence=>67
,p_lov_disp_value=>'Pick up Room nights -3 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_3_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27894409562891849)
,p_lov_disp_sequence=>68
,p_lov_disp_value=>'Pick up Revenue -3 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_3_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27894837985891850)
,p_lov_disp_sequence=>69
,p_lov_disp_value=>'Pick up Room nights -7 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_7_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27895898498945081)
,p_lov_disp_sequence=>70
,p_lov_disp_value=>'Pick up Revenue -7 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_7_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27896198308945083)
,p_lov_disp_sequence=>71
,p_lov_disp_value=>'Pick up Room nights -14 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_-4_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27896552840945084)
,p_lov_disp_sequence=>72
,p_lov_disp_value=>'Pick up Revenue -14 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_14_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27896992155945085)
,p_lov_disp_sequence=>73
,p_lov_disp_value=>'Pick up Room nights -28 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_28_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27897370066945087)
,p_lov_disp_sequence=>74
,p_lov_disp_value=>'Pick up Revenue -28 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_28_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27897702381959767)
,p_lov_disp_sequence=>75
,p_lov_disp_value=>'Pick up Room nights STLY-1 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_STLY_1_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27898066438959769)
,p_lov_disp_sequence=>76
,p_lov_disp_value=>'Pick up Revenue STLY -1 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_STLY_1_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27898460016959770)
,p_lov_disp_sequence=>77
,p_lov_disp_value=>'Pick up Room nights STLY-3 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_STLY_3_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27898809508959771)
,p_lov_disp_sequence=>78
,p_lov_disp_value=>'Pick up Revenue STLY -3 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_STLY_3_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27899253741959773)
,p_lov_disp_sequence=>79
,p_lov_disp_value=>'Pick up Room nights STLY-7 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_STLY_7_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27899604562991172)
,p_lov_disp_sequence=>80
,p_lov_disp_value=>'Pick up Revenue STLY-7 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_STLY_7_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27899918975991174)
,p_lov_disp_sequence=>81
,p_lov_disp_value=>'Pick up Room nights STLY-14 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_STLY_14_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27900367887991175)
,p_lov_disp_sequence=>82
,p_lov_disp_value=>'Pick up Revenue STLY-14 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_STLY_14_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27900761389991176)
,p_lov_disp_sequence=>83
,p_lov_disp_value=>'Pick up Room nights STLY-28 DAY'
,p_lov_return_value=>'PICK_UP_ROOM_NIGHTS_STLY_28_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27901169379991177)
,p_lov_disp_sequence=>84
,p_lov_disp_value=>'Pick up Revenue STLY-28 DAY'
,p_lov_return_value=>'PICK_UP_REVENUE_STLY_28_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27901746633998936)
,p_lov_disp_sequence=>85
,p_lov_disp_value=>unistr('Pick up Groups RNTs \2013 1 DAY')
,p_lov_return_value=>'PICK_UP_GROUPS_RNTS_1_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27902010199998938)
,p_lov_disp_sequence=>86
,p_lov_disp_value=>unistr('Pick up Groups RNTs \2013 7 DAY')
,p_lov_return_value=>'PICK_UP_GROUPS_RNTS_7_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27902423032998939)
,p_lov_disp_sequence=>87
,p_lov_disp_value=>unistr('Pick up Groups RNTs STLY \2013 1 DAY')
,p_lov_return_value=>'PICK_UP_GROUPS_RNTS_STLY_1_DAY'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(27902828751998940)
,p_lov_disp_sequence=>88
,p_lov_disp_value=>unistr('Pick up Groups RNTs STLY\2013 7 DAY')
,p_lov_return_value=>'PICK_UP_GROUPS_RNTS_STLY_7_DAY'
);
wwv_flow_imp.component_end;
end;
/
