prompt --application/pages/page_00019
begin
--   Manifest
--     PAGE: 00019
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_page.create_page(
 p_id=>19
,p_name=>'Reservations'
,p_alias=>'RESERVATIONS'
,p_step_title=>'Reservation Update'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Hide on desktop */',
'.nav-mobile {',
'  display: none;',
'}',
'',
'@media (max-width: 768px) {',
'  /* Show only on mobile */',
'  .nav-mobile {',
'    display: block;',
'  }',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14723167422617505)
,p_plug_name=>'Main Region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14242125364905801)
,p_plug_name=>'Reservations'
,p_parent_plug_id=>wwv_flow_imp.id(14723167422617505)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    r.ID,',
'    r.RES_NUMBER,',
'    r.HOTEL_ID,',
'    h.HOTEL_NAME,',
'    TO_CHAR(r.ARRIVAL_DATE, ''MM/DD/YYYY'') AS ARRIVAL_DATE,',
'    r.NUMBER_OF_NIGHTS,',
'    r.ROOMS_BOOKED,',
'    r.TOTAL_BOOKING_VALUE,',
'    r.CHARGED_FLAG,',
'    TO_CHAR(r.EXCEPTION_DATE, ''MM/DD/YYYY'') AS EXCEPTION_DATE,',
'    r.RESERVATION_EXCEPTION_TYPE,',
'    r.EXCEPTION_REASON,',
'    r.EXCEPTION_AMOUNT,',
'    COALESCE(r.APPROVED_BY_MANUAL, r.APPROVED_BY) AS APPROVED_BY,',
'    r.NOTES,',
'    r.RESERVATION_TYPE,',
'    r.ROOM_TYPE_ID,',
'    a.ROOM_TYPE_NAME',
'FROM UR_HOTEL_RESERVATIONS r',
'LEFT JOIN UR_HOTEL_ROOM_TYPES a',
'  ON r.HOTEL_ID = a.HOTEL_ID',
' AND r.ROOM_TYPE_ID = a.ROOM_TYPE_ID',
'LEFT JOIN UR_HOTELS h',
'  ON r.HOTEL_ID = h.ID',
'--WHERE (:P19_HOTEL_LIST = ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'')',
'--   OR (:P19_HOTEL_LIST != ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'' AND r.HOTEL_ID = HEXTORAW(:P19_HOTEL_LIST))',
'WHERE (',
'       :G_HOTEL_ID IS NULL',
'       OR :G_HOTEL_ID = ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF''',
'       OR r.HOTEL_ID = HEXTORAW(:G_HOTEL_ID)',
')',
'',
''))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P0_HOTEL_ID'
,p_prn_page_header=>'Reservations'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(13908178875313946)
,p_name=>'RESERVATION_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RESERVATION_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Reservation Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>200
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>2
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14107623140783049)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14244426381905818)
,p_name=>'RES_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RES_NUMBER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Reservation Number'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_link_target=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.::P22_RESERVATION_ID,P22_APPROVED_BY,P22_ROOM_TYPE,P22_HOTEL_ID,P22_ROOM_TYPE,P22_HOTEL_ID,P22_ARRIVAL_DATE:&ID.,&APPROVED_BY.,&"Room_Types".,&HOTEL_ID.,&ROOM_TYPE_ID.,&HOTEL_NAME.,&ARRIVAL_DATE.'
,p_link_text=>'&RES_NUMBER.'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14245460391905821)
,p_name=>'HOTEL_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HOTEL_ID'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>20
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14246480453905824)
,p_name=>'ARRIVAL_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ARRIVAL_DATE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Arrival Date'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14247474386905827)
,p_name=>'NUMBER_OF_NIGHTS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NUMBER_OF_NIGHTS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Number Of Nights'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>50
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14248432998905829)
,p_name=>'ROOMS_BOOKED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ROOMS_BOOKED'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Rooms Booked'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>60
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14249472744905832)
,p_name=>'TOTAL_BOOKING_VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TOTAL_BOOKING_VALUE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Total Booking Value'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>70
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14250499878905835)
,p_name=>'CHARGED_FLAG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CHARGED_FLAG'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Charged Flag'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>1
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14260411849905864)
,p_name=>'APPROVED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPROVED_BY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Approved By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>180
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>100
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14261467934905867)
,p_name=>'NOTES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NOTES'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Notes'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>190
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>1000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14350584383988316)
,p_name=>'EXCEPTION_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EXCEPTION_DATE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Exception Date'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>210
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14350604161988317)
,p_name=>'EXCEPTION_REASON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EXCEPTION_REASON'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Exception Reason'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>220
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>250
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14350768299988318)
,p_name=>'EXCEPTION_AMOUNT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EXCEPTION_AMOUNT'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Exception Amount'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>230
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14351935342988330)
,p_name=>'RESERVATION_EXCEPTION_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RESERVATION_EXCEPTION_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Reservation Exception Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>240
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>50
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(16523716680238633)
,p_name=>'ROOM_TYPE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ROOM_TYPE_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Room Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>250
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(16523952695238635)
,p_name=>'ROOM_TYPE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ROOM_TYPE_ID'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Room Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>260
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ROOM_TYPE_NAME d,',
'       ROOM_TYPE_ID r',
'FROM UR_HOTEL_ROOM_TYPES',
'WHERE HOTEL_ID = :P19_HOTEL_LIST',
'ORDER BY ROOM_TYPE_NAME',
''))
,p_lov_display_extra=>false
,p_lov_display_null=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(23205366274797501)
,p_name=>'HOTEL_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HOTEL_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Hotel Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>280
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>100
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(14242656321905808)
,p_internal_uid=>14242656321905808
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>true
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(14243063210905810)
,p_interactive_grid_id=>wwv_flow_imp.id(14242656321905808)
,p_static_id=>'142431'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(14243245433905810)
,p_report_id=>wwv_flow_imp.id(14243063210905810)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14244892103905819)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(14244426381905818)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14245863399905822)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(14245460391905821)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14246834755905825)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(14246480453905824)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14247827040905828)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(14247474386905827)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14248816149905830)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(14248432998905829)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14249816408905833)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(14249472744905832)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14250809681905836)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(14250499878905835)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14260870080905865)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(14260411849905864)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14261834414905868)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(14261467934905867)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14367172904004390)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(14107623140783049)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14395712640431429)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(13908178875313946)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14471050662883033)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(14350584383988316)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14471926734883039)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(14350604161988317)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14492286553955457)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(14350768299988318)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(14684396704557189)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(14351935342988330)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(16708775625549288)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>17
,p_column_id=>wwv_flow_imp.id(16523716680238633)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(16746565801922799)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>18
,p_column_id=>wwv_flow_imp.id(16523952695238635)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(23210979445797755)
,p_view_id=>wwv_flow_imp.id(14243245433905810)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(23205366274797501)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(39929344864649875)
,p_interactive_grid_id=>wwv_flow_imp.id(14242656321905808)
,p_name=>'rooms'
,p_static_id=>'256868'
,p_type=>'PUBLIC'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(39929527087649875)
,p_report_id=>wwv_flow_imp.id(39929344864649875)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39931173757649884)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(14244426381905818)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39932145053649887)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(14245460391905821)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39933116409649890)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(14246480453905824)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39934108694649893)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(14247474386905827)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39935097803649895)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(14248432998905829)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39936098062649898)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(14249472744905832)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39937091335649901)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(14250499878905835)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39947151734649930)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(14260411849905864)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39948116068649933)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(14261467934905867)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40053454557748455)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(14107623140783049)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40081994294175494)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(13908178875313946)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40157332316627098)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(14350584383988316)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40158208388627104)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(14350604161988317)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40178568207699522)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(14350768299988318)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40370678358301254)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(14351935342988330)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(42395057279293353)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>17
,p_column_id=>wwv_flow_imp.id(16523716680238633)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(42432847455666864)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>18
,p_column_id=>wwv_flow_imp.id(16523952695238635)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(48897261099541820)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(23205366274797501)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(25686352017744067)
,p_view_id=>wwv_flow_imp.id(39929527087649875)
,p_execution_seq=>5
,p_name=>'exp'
,p_background_color=>'#0b36b5'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(14248432998905829)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'1'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14723260357617506)
,p_plug_name=>'Hotel'
,p_parent_plug_id=>wwv_flow_imp.id(14723167422617505)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14723432239617508)
,p_plug_name=>'Widget'
,p_title=>'Reservation Exception - Last 30 Days'
,p_region_name=>'widget_id'
,p_parent_plug_id=>wwv_flow_imp.id(14723167422617505)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>4
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'  CASE ',
'    WHEN day_sort_order IS NULL THEN ''TOTAL''',
'    ELSE MIN(day_of_week)',
'  END AS day_of_week,',
'  NVL(day_sort_order, 999) AS day_sort_order,',
'  SUM(CASE WHEN reservation_exception_type = ''NS'' THEN 1 ELSE 0 END) AS No_Shows,',
'  SUM(CASE WHEN reservation_exception_type = ''RB'' THEN 1 ELSE 0 END) AS Rebate,',
'  SUM(CASE WHEN reservation_exception_type = ''LC'' THEN 1 ELSE 0 END) AS Late_Cancellation,',
'  SUM(CASE WHEN reservation_exception_type IN (''NS'',''RB'',''LC'') THEN 1 ELSE 0 END) AS Row_Total',
'FROM (',
'  SELECT',
'    TRIM(TO_CHAR(arrival_date, ''Dy'', ''NLS_DATE_LANGUAGE=ENGLISH'')) AS day_of_week,',
'    CASE UPPER(TO_CHAR(arrival_date, ''DY'', ''NLS_DATE_LANGUAGE=ENGLISH''))',
'      WHEN ''MON'' THEN 1',
'      WHEN ''TUE'' THEN 2',
'      WHEN ''WED'' THEN 3',
'      WHEN ''THU'' THEN 4',
'      WHEN ''FRI'' THEN 5',
'      WHEN ''SAT'' THEN 6',
'      WHEN ''SUN'' THEN 7',
'    END AS day_sort_order,',
'    reservation_exception_type',
'  FROM UR_HOTEL_RESERVATIONS',
'WHERE',
'    (',
'      :G_HOTEL_ID IS NULL',
'      OR :G_HOTEL_ID = ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF''',
'      OR (',
'          LENGTH(:G_HOTEL_ID) = 32',
'          AND REGEXP_LIKE(:G_HOTEL_ID, ''^[0-9A-Fa-f]+$'')',
'          AND HOTEL_ID = HEXTORAW(:G_HOTEL_ID)',
'      )',
'    )',
'    AND arrival_date BETWEEN SYSDATE - 30 AND SYSDATE',
'    AND reservation_exception_type IN (''LC'', ''NS'', ''RB'')',
')',
'',
'GROUP BY ROLLUP(day_sort_order)',
''))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P0_HOTEL_ID'
,p_plug_read_only_when_type=>'ALWAYS'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Reservation Exception - Last 30 Days'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14724227425617516)
,p_name=>'DAY_OF_WEEK'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DAY_OF_WEEK'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Day Of Week'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>30
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>12
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14724340982617517)
,p_name=>'LATE_CANCELLATION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LATE_CANCELLATION'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Late Cancellation'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14724461491617518)
,p_name=>'NO_SHOWS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NO_SHOWS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'No Shows'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14724563654617519)
,p_name=>'REBATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REBATE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Rebate'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14724851549617522)
,p_name=>'DAY_SORT_ORDER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DAY_SORT_ORDER'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(23206316303797511)
,p_name=>'ROW_TOTAL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ROW_TOTAL'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Row Total'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(14724128352617515)
,p_internal_uid=>14724128352617515
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>false
,p_show_toolbar=>false
,p_toolbar_buttons=>null
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:PDF:XLSX'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(16185601164227288)
,p_interactive_grid_id=>wwv_flow_imp.id(14724128352617515)
,p_static_id=>'161857'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(16185867114227290)
,p_report_id=>wwv_flow_imp.id(16185601164227288)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(16186349762227297)
,p_view_id=>wwv_flow_imp.id(16185867114227290)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(14724227425617516)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(16187281230227303)
,p_view_id=>wwv_flow_imp.id(16185867114227290)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(14724340982617517)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(16188126695227307)
,p_view_id=>wwv_flow_imp.id(16185867114227290)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(14724461491617518)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(16189064523227312)
,p_view_id=>wwv_flow_imp.id(16185867114227290)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(14724563654617519)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(16200473860610393)
,p_view_id=>wwv_flow_imp.id(16185867114227290)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(14724851549617522)
,p_is_visible=>false
,p_is_frozen=>false
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(23321182951262514)
,p_view_id=>wwv_flow_imp.id(16185867114227290)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(23206316303797511)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15700560014591398)
,p_plug_name=>'Reservations'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(8558440305922134)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(14107567289783048)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(14242125364905801)
,p_button_name=>'Add_Reservation'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--padTop:t-Button--padBottom'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Add Reservation Exception'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_HOTEL_ID:&P19_HOTEL_LIST.'
,p_grid_new_row=>'Y'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(16522840083238624)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(14242125364905801)
,p_button_name=>'Add_NO_SHOW'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--padTop:t-Button--padBottom'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add No Show'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_HOTEL_ID,P22_RESERVATION_EXCEPTION_TYPE,P22_HOTEL_LIST,P22_RESERVATION_TYPE,P22_HOTEL_LIST:&P19_HOTEL_LIST.,NS,&P19_HOTEL_LIST.,TS,&P0_HOTEL_ID.'
,p_grid_new_row=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(16522915039238625)
,p_button_sequence=>35
,p_button_plug_id=>wwv_flow_imp.id(14242125364905801)
,p_button_name=>'Add_REBATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--padTop:t-Button--padBottom'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Rebate'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_HOTEL_ID,P22_RESERVATION_EXCEPTION_TYPE,P22_HOTEL_LIST,P22_RESERVATION_TYPE,P22_HOTEL_LIST:&P19_HOTEL_LIST.,RB,&P19_HOTEL_LIST.,TS,&P0_HOTEL_ID.'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(16522767234238623)
,p_button_sequence=>45
,p_button_plug_id=>wwv_flow_imp.id(14242125364905801)
,p_button_name=>'Add_Late_Cancelation'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--padTop:t-Button--padBottom'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Add Late Cancellation'
,p_button_redirect_url=>'f?p=&APP_ID.:22:&SESSION.::&DEBUG.:22:P22_HOTEL_ID,P22_RESERVATION_EXCEPTION_TYPE,P22_HOTEL_LIST,P22_RESERVATION_TYPE,P22_HOTEL_LIST:&P19_HOTEL_LIST.,LC,&P19_HOTEL_LIST.,TS,&P0_HOTEL_ID.'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14107451219783047)
,p_name=>'P19_HOTEL_LIST'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14723260357617506)
,p_item_default=>'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
,p_prompt=>'Hotel List'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISPLAY_VALUE, RETURN_VALUE FROM (',
'  SELECT NVL(HOTEL_NAME, ''Name'') AS DISPLAY_VALUE,',
'         RAWTOHEX(ID) AS RETURN_VALUE,',
'         2 AS SORT_ORDER',
'  FROM UR_HOTELS',
'  WHERE NVL(ASSOCIATION_END_DATE, SYSDATE) >= SYSDATE',
'  UNION ALL',
'  SELECT ''-- Show all data --'' AS DISPLAY_VALUE,',
'         ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'' AS RETURN_VALUE,',
'         1 AS SORT_ORDER',
'  FROM DUAL',
')',
'ORDER BY SORT_ORDER, DISPLAY_VALUE'))
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14281563969921215)
,p_name=>'Change Hotel'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P19_HOTEL_LIST,P0_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12884971836327136)
,p_event_id=>wwv_flow_imp.id(14281563969921215)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14281958301921217)
,p_event_id=>wwv_flow_imp.id(14281563969921215)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(14242125364905801)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14282705996922098)
,p_event_id=>wwv_flow_imp.id(14281563969921215)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(14242125364905801)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14282353107922096)
,p_name=>'Hotel list Change'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P19_HOTEL_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14351741622988328)
,p_name=>'Refresh'
,p_event_sequence=>30
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(14242125364905801)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14351867057988329)
,p_event_id=>wwv_flow_imp.id(14351741622988328)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(14242125364905801)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18158095320285646)
,p_event_id=>wwv_flow_imp.id(14351741622988328)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(14723432239617508)
,p_attribute_01=>'N'
);
wwv_flow_imp.component_end;
end;
/
