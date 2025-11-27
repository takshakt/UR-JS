prompt --application/shared_components/navigation/lists/navigation_menu
begin
--   Manifest
--     LIST: Navigation Menu
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(8558978835922138)
,p_name=>'Navigation Menu'
,p_list_status=>'PUBLIC'
,p_version_scn=>45851759983604
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(10490026312115713)
,p_list_item_display_sequence=>15
,p_list_item_link_text=>'Hotel Management'
,p_list_item_link_target=>'f?p=&APP_ID.:1020:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-building'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'1020,1023,1024,1025,1025'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(10881218503916436)
,p_list_item_display_sequence=>55
,p_list_item_link_text=>'Manage Cluster'
,p_list_item_link_target=>'f?p=&APP_ID.:1027:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-podcast'
,p_parent_list_item_id=>wwv_flow_imp.id(10490026312115713)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13603850418394588)
,p_list_item_display_sequence=>56
,p_list_item_link_text=>'Hotels'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-meeting-room'
,p_parent_list_item_id=>wwv_flow_imp.id(10490026312115713)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(10730187033163105)
,p_list_item_display_sequence=>58
,p_list_item_link_text=>'Room Types'
,p_list_item_link_target=>'f?p=&APP_ID.:1023:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-bath'
,p_parent_list_item_id=>wwv_flow_imp.id(10490026312115713)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(10765969794536823)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Contact Directory'
,p_list_item_link_target=>'f?p=&APP_ID.:1026:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-phone-square'
,p_parent_list_item_id=>wwv_flow_imp.id(10490026312115713)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(10778582946540850)
,p_list_item_display_sequence=>10020
,p_list_item_link_text=>'Address Book'
,p_list_item_link_target=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-taxi'
,p_parent_list_item_id=>wwv_flow_imp.id(10490026312115713)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(10877313631827616)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Event Management'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-birthday-cake'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(15689157068470336)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Hotel Data'
,p_list_item_link_target=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-university'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'14,1070'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(8777317324025862)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Add New Template'
,p_list_item_link_target=>'f?p=&APP_ID.:1001:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-layers'
,p_parent_list_item_id=>wwv_flow_imp.id(15689157068470336)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'1001'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(23216073527110995)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Manage Templates'
,p_list_item_link_target=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-pencil'
,p_parent_list_item_id=>wwv_flow_imp.id(15689157068470336)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'29'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(9869761620619585)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Load Data'
,p_list_item_link_target=>'f?p=&APP_ID.:1010:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-cloud-check'
,p_parent_list_item_id=>wwv_flow_imp.id(15689157068470336)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'1010'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(17886663119874598)
,p_list_item_display_sequence=>320
,p_list_item_link_text=>'Price Override'
,p_list_item_link_target=>'f?p=&APP_ID.:1075:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-analytics'
,p_parent_list_item_id=>wwv_flow_imp.id(15689157068470336)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'1075,1071'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(30207590582500629)
,p_list_item_display_sequence=>340
,p_list_item_link_text=>'Templates v2'
,p_list_item_link_target=>'f?p=&APP_ID.:1002:&APP_SESSION.::&DEBUG.:::'
,p_parent_list_item_id=>wwv_flow_imp.id(15689157068470336)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'1002'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(19687573748008468)
,p_list_item_display_sequence=>10060
,p_list_item_link_text=>'Reservation Update'
,p_list_item_link_target=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-ban'
,p_parent_list_item_id=>wwv_flow_imp.id(15689157068470336)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(12461139180188313)
,p_list_item_display_sequence=>160
,p_list_item_link_text=>'Strategies'
,p_list_item_link_target=>'f?p=&APP_ID.:1050:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-calculator'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'1050'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(15884188683819305)
,p_list_item_display_sequence=>310
,p_list_item_link_text=>'Reports'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-files-o'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(12815911773870641)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'Manage Reports'
,p_list_item_link_target=>'f?p=&APP_ID.:1006:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-notebook'
,p_parent_list_item_id=>wwv_flow_imp.id(15884188683819305)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'1006'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(13490057784952042)
,p_list_item_display_sequence=>300
,p_list_item_link_text=>'Run Reports'
,p_list_item_link_target=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-dashboard'
,p_parent_list_item_id=>wwv_flow_imp.id(15884188683819305)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'15'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(27223648835332272)
,p_list_item_display_sequence=>330
,p_list_item_link_text=>'Report Summary'
,p_list_item_link_target=>'f?p=&APP_ID.:167:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-file-o'
,p_parent_list_item_id=>wwv_flow_imp.id(15884188683819305)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'167'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(8750339910923326)
,p_list_item_display_sequence=>10000
,p_list_item_link_text=>'Administration'
,p_list_item_link_target=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-user-wrench'
,p_security_scheme=>wwv_flow_imp.id(8565313938922218)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(14713689902561124)
,p_list_item_display_sequence=>220
,p_list_item_link_text=>'Interface Dashboard'
,p_list_item_link_target=>'f?p=&APP_ID.:1601:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-gamepad'
,p_parent_list_item_id=>wwv_flow_imp.id(8750339910923326)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'1601'
);
wwv_flow_imp.component_end;
end;
/
