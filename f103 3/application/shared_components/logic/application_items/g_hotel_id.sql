prompt --application/shared_components/logic/application_items/g_hotel_id
begin
--   Manifest
--     APPLICATION ITEM: G_HOTEL_ID
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(25703922881388811)
,p_name=>'G_HOTEL_ID'
,p_protection_level=>'I'
,p_version_scn=>45693916814340
);
wwv_flow_imp.component_end;
end;
/
