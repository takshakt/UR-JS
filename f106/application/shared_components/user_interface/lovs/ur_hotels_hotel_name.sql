prompt --application/shared_components/user_interface/lovs/ur_hotels_hotel_name
begin
--   Manifest
--     UR_HOTELS.HOTEL_NAME
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
 p_id=>wwv_flow_imp.id(14280326063905924)
,p_lov_name=>'UR_HOTELS.HOTEL_NAME'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'UR_HOTELS'
,p_return_column_name=>'HOTEL_ID'
,p_display_column_name=>'HOTEL_NAME'
,p_default_sort_column_name=>'HOTEL_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>45437387339141
);
wwv_flow_imp.component_end;
end;
/
