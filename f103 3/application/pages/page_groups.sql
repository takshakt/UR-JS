prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 103
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(8566833260922231)
,p_group_name=>'Administration'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(8769138960923584)
,p_group_name=>'User Settings'
);
wwv_flow_imp.component_end;
end;
/
