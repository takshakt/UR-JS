prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(8558440305922134)
,p_name=>'Breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(8558632471922135)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(8751287395923332)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(8778281765025872)
,p_short_name=>'Add New Template'
,p_link=>'f?p=&APP_ID.:1001:&SESSION.::&DEBUG.:::'
,p_page_id=>1001
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(10490841779115730)
,p_short_name=>'Hotel Management'
,p_link=>'f?p=&APP_ID.:1020:&SESSION.::&DEBUG.:::'
,p_page_id=>1020
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(10537427713842342)
,p_short_name=>'Hotel Card'
,p_link=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(11391256438988879)
,p_short_name=>'test'
,p_link=>'f?p=&APP_ID.:16:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>16
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13389149835785920)
,p_short_name=>'test'
,p_link=>'f?p=&APP_ID.:5:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(13490977245952049)
,p_short_name=>'Run Reports'
,p_link=>'f?p=&APP_ID.:15:&SESSION.::&DEBUG.:::'
,p_page_id=>15
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15599865524845920)
,p_short_name=>'Manage Templates'
,p_link=>'f?p=&APP_ID.:29:&SESSION.::&DEBUG.:::'
,p_page_id=>29
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15622208513167395)
,p_short_name=>'User Management'
,p_link=>'f?p=&APP_ID.:1611:&SESSION.::&DEBUG.:::'
,p_page_id=>1611
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15689990234470342)
,p_short_name=>'Hotel Data'
,p_link=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15694775860538897)
,p_short_name=>'Interface Dashboard'
,p_link=>'f?p=&FLOW_ID.:1601:&SESSION.'
,p_page_id=>1601
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15695590414546465)
,p_short_name=>'Strategies'
,p_link=>'f?p=&APP_ID.:1050:&SESSION.::&DEBUG.:::'
,p_page_id=>1050
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15696541760549838)
,p_short_name=>'Strategies'
,p_link=>'f?p=&APP_ID.:1050:&SESSION.::&DEBUG.:::'
,p_page_id=>1050
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15699258788566313)
,p_short_name=>'Load Data'
,p_link=>'f?p=&APP_ID.:1010:&SESSION.::&DEBUG.:::'
,p_page_id=>1010
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15700990921591401)
,p_short_name=>'Reservation Update'
,p_link=>'f?p=&APP_ID.:19:&SESSION.::&DEBUG.:::'
,p_page_id=>19
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15745895991884811)
,p_short_name=>'Hotels'
,p_link=>'f?p=&FLOW_ID.:11:&SESSION.'
,p_page_id=>11
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15747135492917095)
,p_short_name=>'Event Management'
,p_link=>'f?p=&FLOW_ID.:9:&SESSION.'
,p_page_id=>9
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15747928223964141)
,p_short_name=>'Address Book'
,p_link=>'f?p=&APP_ID.:17:&SESSION.::&DEBUG.:::'
,p_page_id=>17
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15748589238974526)
,p_short_name=>'Room Types'
,p_link=>'f?p=&FLOW_ID.:1023:&SESSION.'
,p_page_id=>1023
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15749127495982511)
,p_short_name=>'Contact Directory'
,p_link=>'f?p=&APP_ID.:1026:&SESSION.::&DEBUG.:::'
,p_page_id=>1026
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15749798294986872)
,p_short_name=>'Manage Cluster'
,p_link=>'f?p=&APP_ID.:1027:&SESSION.::&DEBUG.:::'
,p_page_id=>1027
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15881747492763211)
,p_short_name=>'Manage Reports'
,p_link=>'f?p=&APP_ID.:1006:&SESSION.::&DEBUG.:::'
,p_page_id=>1006
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(15885038670819310)
,p_short_name=>'Reporting'
,p_link=>'f?p=&APP_ID.:21:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>21
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(17893492478874632)
,p_short_name=>'Price Override'
,p_link=>'f?p=&APP_ID.:1075:&SESSION.::&DEBUG.:::'
,p_page_id=>1075
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(17972651947303021)
,p_short_name=>'test DNU'
,p_link=>'f?p=&APP_ID.:30:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>30
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(18398585744878613)
,p_short_name=>'Report Summary'
,p_link=>'f?p=&APP_ID.:67:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>67
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(27224583641332288)
,p_short_name=>'Report Summary'
,p_link=>'f?p=&APP_ID.:167:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>167
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(30217940470500725)
,p_short_name=>'Add New Template v2'
,p_link=>'f?p=&APP_ID.:1002:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1002
);
wwv_flow_imp.component_end;
end;
/
