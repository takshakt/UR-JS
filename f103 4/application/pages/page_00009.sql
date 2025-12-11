prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_page.create_page(
 p_id=>9
,p_name=>'Hotel Events'
,p_alias=>'HOTEL-EVENTS1'
,p_step_title=>'Hotel Events'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.download-upload-wrapper {',
'    display: flex;',
'    justify-content: flex-end;',
'    flex-wrap: wrap;',
'    gap: 8px;',
'}',
'',
'',
'#download_upload_region .t-Region-body {',
'    padding: 0;',
'}',
'',
'#download_upload_region {',
'    display: flex;',
'    justify-content: flex-end;',
'    flex-wrap: wrap;',
'    gap: 10px;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(12202741465869080)
,p_plug_name=>'Hotel Events'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    e.ID,',
'    e.HOTEL_ID,',
'    h.Hotel_NAME,            ',
'    e.EVENT_NAME,',
'    e.EVENT_TYPE,',
'    e.EVENT_START_DATE,',
'    e.EVENT_END_DATE,',
'    e.EVENT_FREQUENCY,',
'    e.ESTIMATED_ATTENDANCE AS Attendance,',
'    e.IMPACT_LEVEL,',
'    e.IMPACT_TYPE,',
'    e.DESCRIPTION,',
'    e.POSTCODE,',
'    e.CITY,',
'    e.COUNTRY',
'FROM UR_EVENTS e',
'LEFT JOIN UR_HOTELS h',
'  ON e.HOTEL_ID = h.ID',
'--WHERE',
'--   (:P9_HOTEL_LIST = ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'' OR RAWTOHEX(e.HOTEL_ID) = :P9_HOTEL_LIST)',
'WHERE (',
'  :G_HOTEL_ID IS NULL',
'  OR :G_HOTEL_ID = ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF''',
'  OR HOTEL_ID = HEXTORAW(:G_HOTEL_ID)',
')',
'',
''))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P9_HOTEL_LIST,P0_HOTEL_ID'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
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
 p_id=>wwv_flow_imp.id(12358448159267935)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>30
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(12358636732267937)
,p_name=>'EVENT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EVENT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Event Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_link_target=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.::P20_EVENT_NAME,P20_EVENT_TYPE,P20_EVENT_DESRIPTION,P20_FREQUENCY,P20_ATTENDANCE,P20_IMPACT_TYPE,P20_IMPACT_LEVEL,P20_POST_CODE,P20_CITY,P20_COUNTRY,P20_EVENT_ID,P20_HOTEL_ID,P20_HOTEL_EVENT_LIST,P20_HOTEL_EVENT_LIS'
||'T,P20_START_DATE,P20_END_DATE:&EVENT_NAME.,&EVENT_TYPE.,&DESCRIPTION.,&EVENT_FREQUENCY.,&ATTENDANCE.,&IMPACT_TYPE.,&IMPACT_LEVEL.,&POSTCODE.,&CITY.,&COUNTRY.,&ID.,&HOTEL_ID.,&EVENT_NAME.,&ID.,&EVENT_START_DATE.,&EVENT_END_DATE.'
,p_link_text=>'&EVENT_NAME.'
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
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(12358787340267938)
,p_name=>'EVENT_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EVENT_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Event Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(12358876402267939)
,p_name=>'EVENT_START_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EVENT_START_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Event Start Date'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
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
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
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
 p_id=>wwv_flow_imp.id(12358979405267940)
,p_name=>'EVENT_END_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EVENT_END_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Event End Date'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
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
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
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
 p_id=>wwv_flow_imp.id(12359148948267942)
,p_name=>'IMPACT_LEVEL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IMPACT_LEVEL'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Event Impact Level'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
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
 p_id=>wwv_flow_imp.id(12359232946267943)
,p_name=>'DESCRIPTION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DESCRIPTION'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Event Description'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>500
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(12359357533267944)
,p_name=>'CITY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CITY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'City'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(12359418132267945)
,p_name=>'POSTCODE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'POSTCODE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Postcode'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>10
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
 p_id=>wwv_flow_imp.id(12894429645500141)
,p_name=>'COUNTRY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COUNTRY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Country'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>140
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
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
 p_id=>wwv_flow_imp.id(13479239909370114)
,p_name=>'EVENT_FREQUENCY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EVENT_FREQUENCY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Event Frequency'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>150
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
 p_id=>wwv_flow_imp.id(18542614313841140)
,p_name=>'ATTENDANCE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ATTENDANCE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Event Attendance'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>160
,p_value_alignment=>'RIGHT'
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
 p_id=>wwv_flow_imp.id(22839497395924803)
,p_name=>'HOTEL_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HOTEL_ID'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>170
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(22839599815924804)
,p_name=>'HOTEL_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HOTEL_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Hotel Name'
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(22839622024924805)
,p_name=>'IMPACT_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IMPACT_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Event Impact Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>190
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
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(12358305262267934)
,p_internal_uid=>12358305262267934
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(12896825163500792)
,p_interactive_grid_id=>wwv_flow_imp.id(12358305262267934)
,p_static_id=>'128969'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(12897098030500793)
,p_report_id=>wwv_flow_imp.id(12896825163500792)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(12897552177500801)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(12358448159267935)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(12899332226500810)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(12358636732267937)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(12900286701500815)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(12358787340267938)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(12901078144500819)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(12358876402267939)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(12901999369500823)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(12358979405267940)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(12903705651500831)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(12359148948267942)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(12904696512500835)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(12359232946267943)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(12905524550500840)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(12359357533267944)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(12906472771500844)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(12359418132267945)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(13441727647837401)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(12894429645500141)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(13703927906424096)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(13479239909370114)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18600378581427094)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(18542614313841140)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(22848537940954311)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(22839497395924803)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(22849404653954315)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(22839599815924804)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(23025258640569863)
,p_view_id=>wwv_flow_imp.id(12897098030500793)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(22839622024924805)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(32612952570910455)
,p_interactive_grid_id=>wwv_flow_imp.id(12358305262267934)
,p_name=>'APS Event Management View'
,p_type=>'PRIVATE'
,p_default_view=>'GRID'
,p_application_user=>'APSTANLEY'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(32613225437910456)
,p_report_id=>wwv_flow_imp.id(32612952570910455)
,p_view_type=>'GRID'
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(32613679584910464)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(12358448159267935)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(32615459633910473)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(12358636732267937)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(32616414108910478)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(12358787340267938)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(32617205551910482)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(12358876402267939)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(32618126776910486)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(12358979405267940)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(32619833058910494)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(12359148948267942)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(32620823919910498)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(12359232946267943)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(32621651957910503)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(12359357533267944)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(32622600178910507)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(12359418132267945)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33157855055247064)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(12894429645500141)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33420055313833759)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(13479239909370114)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(38316505988836757)
,p_view_id=>wwv_flow_imp.id(32613225437910456)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(18542614313841140)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(52329190470329519)
,p_interactive_grid_id=>wwv_flow_imp.id(12358305262267934)
,p_name=>'adam with highlight'
,p_type=>'PRIVATE'
,p_default_view=>'GRID'
,p_application_user=>'APSTANLEY'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(52329463337329520)
,p_report_id=>wwv_flow_imp.id(52329190470329519)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52329917484329528)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(12358448159267935)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52331697533329537)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(12358636732267937)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52332652008329542)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(12358787340267938)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52333443451329546)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(12358876402267939)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52334364676329550)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(12358979405267940)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52336070958329558)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(12359148948267942)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52337061819329562)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(12359232946267943)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52337889857329567)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(12359357533267944)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52338838078329571)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(12359418132267945)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(52874092954666128)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(12894429645500141)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(53136293213252823)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(13479239909370114)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(58032743888255821)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(18542614313841140)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(19716366140419065)
,p_view_id=>wwv_flow_imp.id(52329463337329520)
,p_execution_seq=>5
,p_name=>'Mark Event Type'
,p_column_id=>wwv_flow_imp.id(12358787340267938)
,p_background_color=>'#fff5ce'
,p_text_color=>'#000000'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(12358787340267938)
,p_condition_operator=>'C'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'Events'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(31803252047175001)
,p_plug_name=>'New'
,p_region_name=>'download_upload_region'
,p_parent_plug_id=>wwv_flow_imp.id(12202741465869080)
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle:t-Form--stretchInputs'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>4
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(12213514696869128)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15746794628917092)
,p_plug_name=>'Event Management'
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
 p_id=>wwv_flow_imp.id(12890780367500104)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(12202741465869080)
,p_button_name=>'Add_New_Event'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--gapTop'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Add New Event'
,p_button_redirect_url=>'f?p=&APP_ID.:20:&SESSION.::&DEBUG.:20:P20_HOTEL_ID:&P0_HOTEL_ID.'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27788423350806812)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(31803252047175001)
,p_button_name=>'DOWNLOAD'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--stretch'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Download Template'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>7
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27788309087806811)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(31803252047175001)
,p_button_name=>'BULK_UPLOAD'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--stretch:t-Button--padLeft'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Upload Data'
,p_button_redirect_url=>'f?p=&APP_ID.:27:&SESSION.::&DEBUG.:CR,27:P27_HOTEL_ID:&P0_HOTEL_ID.'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(12355598852267906)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(12213514696869128)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_execute_validations=>'N'
,p_confirm_message=>'&APP_TEXT$DELETE_MSG!RAW.'
,p_confirm_style=>'danger'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12890620865500103)
,p_name=>'P9_HOTEL_LIST'
,p_item_sequence=>40
,p_item_default=>'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
,p_prompt=>'Hotel Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT Name, ID',
'FROM (',
'  SELECT NVL(Hotel_NAME, ''Name'') AS Name,',
'         ID AS ID,',
'         3 AS SortOrder',
'  FROM UR_HOTELS',
'  WHERE NVL(ASSOCIATION_END_DATE, SYSDATE) >= SYSDATE',
'  ',
'  UNION ALL',
'  ',
'  SELECT ''-- Show all data --'' AS Name,',
'         hextoraw(''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'') AS ID,  -- special marker',
'         1 AS SortOrder',
'  FROM DUAL',
')',
'ORDER BY SortOrder, Name'))
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12892268670500119)
,p_name=>'Change Hotel'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_HOTEL_LIST,P0_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(22839224950924801)
,p_event_id=>wwv_flow_imp.id(12892268670500119)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12892369964500120)
,p_event_id=>wwv_flow_imp.id(12892268670500119)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(12202741465869080)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12892583280500122)
,p_name=>'Hotel list Change'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_HOTEL_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12892617203500123)
,p_event_id=>wwv_flow_imp.id(12892583280500122)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(12202741465869080)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12187861808821549)
,p_name=>'New_1'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P9_EVENT_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12187981187821550)
,p_event_id=>wwv_flow_imp.id(12187861808821549)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P9_EVENT_NAME,P9_EVENT_TYPE,P9_EVENT_START_DATE,P9_EVENT_END_DATE,P9_ESTIMATED_ATTENDANCE,P9_IMPACT_LEVEL,P9_DESCRIPTION,P9_CITY,P9_POSTCODE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT EVENT_NAME,',
'       EVENT_TYPE,',
'       EVENT_START_DATE,',
'       EVENT_END_DATE,',
'       ESTIMATED_ATTENDANCE,',
'       IMPACT_LEVEL,',
'       DESCRIPTION,',
'       CITY,',
'       POSTCODE,',
'       COUNTRY',
'FROM UR_EVENTS',
'WHERE ID = :P9_EVENT_ID'))
,p_attribute_07=>'P9_EVENT_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12894291312500139)
,p_name=>'Refresh'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(12202741465869080)
,p_bind_type=>'live'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12894354874500140)
,p_event_id=>wwv_flow_imp.id(12894291312500139)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(12202741465869080)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(27788686821806814)
,p_name=>'DA_DOWNLOAD_SAMPLE'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27788423350806812)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(27788790735806815)
,p_event_id=>wwv_flow_imp.id(27788686821806814)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.server.process(',
'    "DOWNLOAD_SAMPLE",',
'    {},',
'    { dataType: "text" }',
');',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(28775061586726015)
,p_name=>'test download'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(27788423350806812)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(28775157825726016)
,p_event_id=>wwv_flow_imp.id(28775061586726015)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.server.process(',
'    "DOWNLOAD_SAMPLE",',
'    {},',
'    {',
'        success: function (pData) {',
'',
'            if (pData.error) {',
'                alert("Error: " + pData.error);',
'                return;',
'            }',
'',
'            // Decode base64',
'            const byteCharacters = atob(pData.content);',
'            const byteArray = new Uint8Array(byteCharacters.length);',
'',
'            for (let i = 0; i < byteCharacters.length; i++) {',
'                byteArray[i] = byteCharacters.charCodeAt(i);',
'            }',
'',
'            // Build file',
'            const blob = new Blob([byteArray], { type: pData.mime });',
'            const url = URL.createObjectURL(blob);',
'',
'            // Download',
'            const a = document.createElement("a");',
'            a.href = url;',
'            a.download = pData.filename;',
'            a.click();',
'            URL.revokeObjectURL(url);',
'        }',
'    }',
');',
''))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12217337232869140)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>12217337232869140
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(28774906600726014)
,p_process_sequence=>50
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DOWNLOAD_SAMPLE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_blob   BLOB;',
'    l_mime   VARCHAR2(200);',
'    l_b64    CLOB;',
'BEGIN',
'    SELECT file_content, mime_type',
'    INTO   l_blob, l_mime',
'    FROM   apex_application_static_files',
'    WHERE  application_id = :APP_ID',
'    AND    file_name = ''Sample Load Data Template.xlsx'';',
'',
unistr('    -- Convert BLOB \2192 Base64'),
'    l_b64 := apex_web_service.blob2clobbase64(l_blob);',
'',
'    -- Return JSON',
'    apex_json.open_object;',
'    apex_json.write(''content'', l_b64);',
'    apex_json.write(''mime'', l_mime);',
'    apex_json.write(''filename'', ''Sample Load Data Template.xlsx'');',
'    apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>28774906600726014
);
wwv_flow_imp.component_end;
end;
/
