prompt --application/pages/page_01002
begin
--   Manifest
--     PAGE: 01002
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
 p_id=>1002
,p_name=>'Templates v2'
,p_alias=>'TEMPLATES-V2'
,p_step_title=>'Templates v2'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(39508588529042054)
,p_plug_name=>'Main Region'
,p_region_name=>'mainRegion'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>90
,p_location=>null
,p_plug_customized=>'1'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(29951197948436302)
,p_plug_name=>'File_Preview'
,p_title=>'2. Preview File'
,p_parent_plug_id=>wwv_flow_imp.id(39508588529042054)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>60
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(29951234249436303)
,p_plug_name=>'Controls'
,p_parent_plug_id=>wwv_flow_imp.id(29951197948436302)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(29951304007436304)
,p_plug_name=>'Preview'
,p_region_name=>'FILE_PREVIEW'
,p_parent_plug_id=>wwv_flow_imp.id(29951197948436302)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT line_number,',
'       col001, col002, col003, col004, col005,',
'       col006, col007, col008, col009, col010',
'FROM TABLE(',
'    apex_data_parser.parse(',
'        p_content         => (SELECT blob_content FROM temp_blob WHERE NAME = :P1002_FILE_NAME_HIDDEN),',
'        p_file_name       => (SELECT filename FROM temp_blob WHERE NAME = :P1002_FILE_NAME_HIDDEN),',
'        p_xlsx_sheet_name => NULLIF(:P1002_SHEET_NAME, ''''),    -- Use sheet_file_name from GET_XLSX_WORKSHEETS',
'        --         p_xlsx_sheet_name => COALESCE(',
'        --     NULLIF(:P1002_SHEET_NAME, ''''),',
'        --     (SELECT MIN(sheet_file_name) KEEP (DENSE_RANK FIRST ORDER BY sheet_sequence)',
'        --      FROM TABLE(apex_data_parser.get_xlsx_worksheets(',
'        --          p_content => (SELECT blob_content FROM temp_blob WHERE NAME = :P1002_FILE_LOAD)',
'        --      ))',
'        --     )',
'        -- ),',
'        p_skip_rows       => NVL(:P1002_SKIP_ROWS, 0),              -- 0 = first row is header',
'        p_max_rows        => 20              -- Limit preview rows',
'    )',
')',
'WHERE :P1002_FILE_NAME_HIDDEN IS NOT NULL;'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P1002_SHEET_NAME,P1002_SKIP_ROWS,P1002_FILE_NAME_HIDDEN'
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
 p_id=>wwv_flow_imp.id(29951923965436310)
,p_name=>'LINE_NUMBER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LINE_NUMBER'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Line Number'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>10
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>true
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(29952096878436311)
,p_name=>'COL001'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL001'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col001'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>20
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(29952176142436312)
,p_name=>'COL002'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL002'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col002'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(29952282133436313)
,p_name=>'COL003'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL003'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col003'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(29952396811436314)
,p_name=>'COL004'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL004'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col004'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(29952417453436315)
,p_name=>'COL005'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL005'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col005'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(29952513419436316)
,p_name=>'COL006'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL006'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col006'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(29952619635436317)
,p_name=>'COL007'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL007'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col007'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(29952734460436318)
,p_name=>'COL008'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL008'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col008'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(29952872180436319)
,p_name=>'COL009'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL009'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col009'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(29952975139436320)
,p_name=>'COL010'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COL010'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Col010'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(29951852155436309)
,p_internal_uid=>29951852155436309
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
 p_id=>wwv_flow_imp.id(30251403611403250)
,p_interactive_grid_id=>wwv_flow_imp.id(29951852155436309)
,p_static_id=>'302515'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(30251631180403250)
,p_report_id=>wwv_flow_imp.id(30251403611403250)
,p_view_type=>'GRID'
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30252115831403257)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(29951923965436310)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30253070717403262)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(29952096878436311)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30253819250403267)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(29952176142436312)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30254761797403271)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(29952282133436313)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30255671630403275)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(29952396811436314)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30256593066403279)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(29952417453436315)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30257448108403283)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(29952513419436316)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30258347968403287)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(29952619635436317)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30259240893403292)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(29952734460436318)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30260159051403296)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(29952872180436319)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(30261075092403300)
,p_view_id=>wwv_flow_imp.id(30251631180403250)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(29952975139436320)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(39505643003042024)
,p_plug_name=>'File_Load'
,p_title=>'1. Load Template'
,p_parent_plug_id=>wwv_flow_imp.id(39508588529042054)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>50
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(39507458434042042)
,p_plug_name=>'TEMPLATE_ATTRIBUTES'
,p_title=>'4. Save'
,p_parent_plug_id=>wwv_flow_imp.id(39508588529042054)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>80
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(39851222871951254)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_imp.id(39507458434042042)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody:margin-top-lg:margin-left-md'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(39851105918951253)
,p_plug_name=>'Coll'
,p_title=>'3. Define Mapping'
,p_parent_plug_id=>wwv_flow_imp.id(39508588529042054)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>70
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(39776995830926037)
,p_plug_name=>'Collection'
,p_title=>'File Data Profile'
,p_region_name=>'Collection_grid'
,p_parent_plug_id=>wwv_flow_imp.id(39851105918951253)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc:margin-top-lg'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT seq_id, c001 AS name, c002 AS data_type, c003 as qualifier,  ',
'     c005 mapping_type,',
'',
'        c004 as default_value,c007 as format_mask',
'  FROM apex_collections',
' WHERE collection_name = ''UR_FILE_DATA_PROFILES'''))
,p_plug_source_type=>'NATIVE_IG'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'File Data Profile'
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(33349095798790139)
,p_name=>'FORMAT_MASK'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FORMAT_MASK'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Format Mask'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
,p_help_text=>'Oracle date format mask (e.g., DD-MON-YYYY). Auto-detected for DATE columns.'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(39777265593926039)
,p_name=>'SEQ_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SEQ_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Seq Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>true
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(39777369544926040)
,p_name=>'NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
 p_id=>wwv_flow_imp.id(39777398293926041)
,p_name=>'DATA_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DATA_TYPE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Data Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC:TEXT;VARCHAR2,NUMBER;NUMBER,DATE;DATE'
,p_lov_display_extra=>true
,p_lov_display_null=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>false
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(39777525740926042)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(39777609514926043)
,p_name=>'APEX$ROW_SELECTOR'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(42021020662891012)
,p_name=>'QUALIFIER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUALIFIER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Qualifier'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(10464223217255649)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(55978892341306259)
,p_name=>'MAPPING_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAPPING_TYPE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Mapping Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(10018491218303621)
,p_lov_display_extra=>true
,p_lov_display_null=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'Maps To'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(57251406854753712)
,p_name=>'DEFAULT_VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEFAULT_VALUE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Calculation'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
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
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(39777130362926038)
,p_internal_uid=>39777130362926038
,p_is_editable=>true
,p_edit_operations=>'u:d'
,p_lost_update_check_type=>'VALUES'
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>false
,p_define_chart_view=>false
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
,p_oracle_text_index_column=>'SEQ_ID'
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(39814179123014117)
,p_interactive_grid_id=>wwv_flow_imp.id(39777130362926038)
,p_static_id=>'96069'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(39814347094014117)
,p_report_id=>wwv_flow_imp.id(39814179123014117)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(34200243157142089)
,p_view_id=>wwv_flow_imp.id(39814347094014117)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(33349095798790139)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39814847904014121)
,p_view_id=>wwv_flow_imp.id(39814347094014117)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(39777265593926039)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>108.45100000000002
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39815713789014125)
,p_view_id=>wwv_flow_imp.id(39814347094014117)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(39777369544926040)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>329.462
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39816625848014129)
,p_view_id=>wwv_flow_imp.id(39814347094014117)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(39777398293926041)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39818720803020089)
,p_view_id=>wwv_flow_imp.id(39814347094014117)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(39777525740926042)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>60.228999999999985
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(42026721121891277)
,p_view_id=>wwv_flow_imp.id(39814347094014117)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(42021020662891012)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(56471468433327268)
,p_view_id=>wwv_flow_imp.id(39814347094014117)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(55978892341306259)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(57256997598754351)
,p_view_id=>wwv_flow_imp.id(39814347094014117)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(57251406854753712)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(45951785558308831)
,p_plug_name=>'Templates'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(8558440305922134)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(30214074201500693)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(39851222871951254)
,p_button_name=>'DEFINE_TEMPLATE'
,p_button_static_id=>'defineTemplate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Define Template'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29951460306436305)
,p_name=>'P1002_SKIP_ROWS'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(29951234249436303)
,p_use_cache_before_default=>'NO'
,p_item_default=>'0'
,p_prompt=>'Skip Rows'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:0;0,1;1,2;2,3;3,4;4,5;5,6;6,7;7,8;8,9;9,10;10,11;11,12;12,13;13,14;14,15;15,16;16,17;17,18;18,19;19,20;20'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29951599131436306)
,p_name=>'P1002_FILE_TYPE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(29951234249436303)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Type'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'       CASE apex_data_parser.get_file_type(filename)',
'           WHEN 1 THEN ''MS Excel File (.XLSX, .XLS)''',
'           WHEN 2 THEN ''CSV File (.CSV, .TXT''',
'           WHEN 3 THEN ''XML File (.XML)''',
'           WHEN 4 THEN ''JSON File (.JSON)''',
'           ELSE ''UNKNOWN''',
'       END AS display_value',
'FROM temp_blob',
'WHERE name = :P1002_FILE_NAME_HIDDEN;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29951621110436307)
,p_name=>'P1002_SHEET_NAME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(29951234249436303)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Excel Sheet Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT sheet_display_name AS display,',
'       SHEET_FILE_NAME AS return',
'FROM TABLE(',
'    apex_data_parser.get_xlsx_worksheets(',
'        p_content => (SELECT blob_content',
'                      FROM temp_blob',
'                      WHERE NAME = :P1002_FILE_NAME_HIDDEN)',
'    )',
')',
'ORDER BY sheet_sequence;'))
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_display_when=>'P1002_FILE_TYPE'
,p_display_when2=>'MS Excel File (.XLSX, .XLS)'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29954055355436331)
,p_name=>'P1002_FILE_NAME_HIDDEN'
,p_item_sequence=>100
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29954437367436335)
,p_name=>'P1002_FILE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(29951234249436303)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File ID'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'       ID',
'FROM temp_blob',
'WHERE name = :P1002_FILE_NAME_HIDDEN;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29954540611436336)
,p_name=>'P1002_FILE_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(29951234249436303)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Name'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'       filename',
'FROM temp_blob',
'WHERE name = :P1002_FILE_NAME_HIDDEN;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29954632198436337)
,p_name=>'P1002_FILE_RECORDS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(29951234249436303)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Records'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'       TO_CHAR(',
'         (SELECT COUNT(*)',
'          FROM TABLE(',
'                 apex_data_parser.parse(',
'                   p_content   => f.blob_content,',
'                   p_file_name => f.filename,',
unistr('                   p_max_rows  => NULL,       -- \2705 parse ALL rows, not just 200'),
'                   p_skip_rows => 1           -- skip header row if needed',
'                 )',
'               )',
'         )',
'       ) AS value',
'FROM apex_application_temp_files f',
'WHERE f.name = :P1002_FILE_NAME_HIDDEN;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(38994029658529503)
,p_name=>'P1002_FILE_LOAD'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(39505643003042024)
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:margin-top-none'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'allow_multiple_files', 'N',
  'display_as', 'DROPZONE_BLOCK',
  'purge_file_at', 'SESSION',
  'storage_type', 'APEX_APPLICATION_TEMP_FILES')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39268932051467867)
,p_name=>'1002_P1_FILE_ID'
,p_item_sequence=>50
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SUBSTR(:P1002_FILE_LOAD, 1, INSTR(:P1002_FILE_LOAD, ''/'') - 1) AS file_id',
'FROM DUAL;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39516715167042143)
,p_name=>'P1002_AI_RESPONSE'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39519143358042167)
,p_name=>'P1002_HOTEL_LIST'
,p_is_required=>true
,p_item_sequence=>70
,p_prompt=>'Hotel'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'  nvl(Hotel_NAME,''Name'') as Name,',
'ID as ID',
'FROM',
'UR_HOTELS',
'WHERE nvl(ASSOCIATION_END_DATE,sysdate) >= sysdate',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39789489816926169)
,p_name=>'P1002_ALERT_TITLE'
,p_item_sequence=>10
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39789605923926170)
,p_name=>'P1002_ALERT_MESSAGE'
,p_data_type=>'CLOB'
,p_item_sequence=>20
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39789662421926171)
,p_name=>'P1002_ALERT_ICON'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39854130004951296)
,p_name=>'P1002_TEMPLATE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(39851222871951254)
,p_prompt=>'Template Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39854379269951298)
,p_name=>'P1002_TEMPLATE_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(39851222871951254)
,p_prompt=>'Template Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'UR TEMPLATE TYPES'
,p_lov=>'.'||wwv_flow_imp.id(9646161429519087)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(39858883850951338)
,p_name=>'P1002_ALERT_TIMER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30230474414500773)
,p_name=>'File Loaded'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1002_FILE_LOAD'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30231416529500776)
,p_event_id=>wwv_flow_imp.id(30230474414500773)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30230967792500775)
,p_event_id=>wwv_flow_imp.id(30230474414500773)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(29951197948436302)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(29953035664436321)
,p_event_id=>wwv_flow_imp.id(30230474414500773)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1002_FILE_TYPE'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30231831287500777)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1002_TEMPLATE_LOV'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30232358907500779)
,p_event_id=>wwv_flow_imp.id(30231831287500777)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'BEGIN',
'  -- Insert the template',
'  INSERT INTO UR_TEMPLATES (',
'    KEY,',
'    NAME,',
'    TYPE,',
'    ACTIVE,',
'    DEFINITION,',
'    CREATED_BY,',
'    CREATED_ON,',
'    UPDATED_BY,',
'    UPDATED_ON',
'  ) VALUES (',
'    ''EXP_TEMPLATE_''|| ROUND(',
'    (CAST(SYSTIMESTAMP AT TIME ZONE ''UTC'' AS DATE) - DATE ''1970-01-01'') * 86400',
'  ),',
'    ''Expense Template ''|| ROUND(',
'    (CAST(SYSTIMESTAMP AT TIME ZONE ''UTC'' AS DATE) - DATE ''1970-01-01'') * 86400',
'  ),',
'    ''RMS'',',
'    ''Y'',  -- or hardcode ''ADMIN''',
'    ''[{"name":"EMPLOYEE_NAME","data-type":1,"data-type-len":100,"selector":"Employee Name","is-json":false},{"name":"EXPENSE_ID","data-type":2,"selector":"Expense Id","is-json":false},{"name":"EXP_TYPE","data-type":1,"data-type-len":50,"selector":"Ex'
||'p Type","is-json":false},{"name":"PROJECT_NAME","data-type":1,"data-type-len":100,"selector":"Project Name","is-json":false},{"name":"EXPENSE_PURPOSE","data-type":1,"data-type-len":50,"selector":"Expense Purpose","is-json":false},{"name":"EXPENSE_DAT'
||'E_FROM","data-type":3,"selector":"Expense Date From","format-mask":"DD\"-\"MON\"-\"RR","is-json":false},{"name":"EXPENSE_DATE_TO","data-type":3,"selector":"Expense Date To","format-mask":"DD\"-\"MON\"-\"RR","is-json":false},{"name":"STATUS","data-typ'
||'e":1,"data-type-len":50,"selector":"Status","is-json":false},{"name":"CURRENCY","data-type":1,"data-type-len":50,"selector":"Currency","is-json":false},{"name":"CLAIM_AMOUNT","data-type":2,"selector":"Claim Amount","is-json":false},{"name":"EXPENSE_A'
||'TTACHMENT","data-type":2,"selector":"Expense Attachment","is-json":false},{"name":"EXPENSE_COMMENT","data-type":1,"data-type-len":32767,"selector":"Expense Comment","is-json":false},{"name":"CREATED_BY","data-type":1,"data-type-len":50,"selector":"Cr'
||'eated By","is-json":false},{"name":"CREATION_DATE","data-type":3,"selector":"Creation Date","format-mask":"YYYY\"-\"MM\"-\"DD\" \"HH24\":\"MI\":\"SS","is-json":false},{"name":"LAST_UPDATED_BY","data-type":1,"data-type-len":50,"selector":"Last Updated'
||' By","is-json":false},{"name":"LAST_UPDATE_DATE","data-type":3,"selector":"Last Update Date","format-mask":"YYYY\"-\"MM\"-\"DD\" \"HH24\":\"MI\":\"SS","is-json":false}]'',',
'    ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP,',
'        ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP',
'  );',
'END;',
''))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30232752970500780)
,p_name=>'Page_Load_DA'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30234215640500784)
,p_event_id=>wwv_flow_imp.id(30232752970500780)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(39508588529042054)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30234708165500786)
,p_event_id=>wwv_flow_imp.id(30232752970500780)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1002_TEMPLATE_NAME,P1002_TEMPLATE_TYPE'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30233252599500781)
,p_event_id=>wwv_flow_imp.id(30232752970500780)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'APEX_COLLECTION.TRUNCATE_COLLECTION(''UR_FILE_DATA_PROFILES'');'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30235224863500787)
,p_event_id=>wwv_flow_imp.id(30232752970500780)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'  APEX_COLLECTION.TRUNCATE_COLLECTION(''UR_FILE_DATA_PROFILES'');'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30233775934500783)
,p_event_id=>wwv_flow_imp.id(30232752970500780)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(39776995830926037)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30225210896500758)
,p_name=>'Change_Hotel'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1002_HOTEL_LIST,P0_HOTEL_ID'
,p_condition_element=>'P0_HOTEL_ID'
,p_triggering_condition_type=>'NOT_EQUALS'
,p_triggering_expression=>'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30226258511500761)
,p_event_id=>wwv_flow_imp.id(30225210896500758)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(39508588529042054)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30227298363500764)
,p_event_id=>wwv_flow_imp.id(30225210896500758)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(39508588529042054)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30225797927500760)
,p_event_id=>wwv_flow_imp.id(30225210896500758)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1002_FILE_LOAD'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'NULL'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30229193378500770)
,p_event_id=>wwv_flow_imp.id(30225210896500758)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'APEX_COLLECTION.TRUNCATE_COLLECTION(''UR_FILE_DATA_PROFILES'');'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30228635946500768)
,p_event_id=>wwv_flow_imp.id(30225210896500758)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_name=>'delete page item of page load'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1002_FILE_LOAD'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30227674904500765)
,p_event_id=>wwv_flow_imp.id(30225210896500758)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'Y'
,p_name=>'template name clear'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1002_TEMPLATE_NAME'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30228179902500767)
,p_event_id=>wwv_flow_imp.id(30225210896500758)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'Y'
,p_name=>'template typeclear'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1002_TEMPLATE_TYPE'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30235602035500788)
,p_name=>'Save Interactive Grid'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(30214074201500693)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30236164265500790)
,p_event_id=>wwv_flow_imp.id(30235602035500788)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(39776995830926037)
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.region("Collection_grid").widget().interactiveGrid("getActions").invoke("save");',
'',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30236640788500791)
,p_event_id=>wwv_flow_imp.id(30235602035500788)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(39776995830926037)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30237673141500794)
,p_event_id=>wwv_flow_imp.id(30235602035500788)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_json CLOB; v_sanitized_json CLOB; v_alerts CLOB := NULL;',
'  v_ok VARCHAR2(1); v_msg VARCHAR2(4000); v_key VARCHAR2(4000);',
'  v_val_status VARCHAR2(1); v_san_status VARCHAR2(1); v_san_msg VARCHAR2(4000);',
'  v_exists NUMBER; v_def_ok BOOLEAN; v_def_msg VARCHAR2(4000);',
'  v_view_ok BOOLEAN; v_view_msg VARCHAR2(4000);',
'  v_algo_ok BOOLEAN; v_algo_msg VARCHAR2(4000);',
'  v_metadata CLOB; v_sheet_display_name VARCHAR2(200);',
'  v_file_id NUMBER; v_file_type NUMBER;',
'  v_base_key VARCHAR2(4000); v_suffix NUMBER := 1;',
'BEGIN',
'  SELECT COUNT(*)',
'  INTO v_exists',
'  FROM UR_TEMPLATES',
'  WHERE HOTEL_ID = :P0_HOTEL_ID',
'    AND UPPER(NAME) = UPPER(:P1002_TEMPLATE_NAME);',
'  IF v_exists > 0 THEN',
'    ur_utils.add_alert(v_alerts,',
'      ''Template name "'' || :P1002_TEMPLATE_NAME || ''" already exists for this hotel.'',',
'      ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RETURN;',
'  END IF;',
'  ur_utils.get_collection_json(''UR_FILE_DATA_PROFILES'', v_json, v_ok, v_msg);',
'  IF v_ok = ''E'' THEN',
'    ur_utils.add_alert(v_alerts, v_msg, ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts; RETURN;',
'  END IF;',
'  ur_utils.VALIDATE_TEMPLATE_DEFINITION(v_json, v_alerts, v_val_status);',
'  IF v_val_status = ''E'' THEN :P0_ALERT_MESSAGE := v_alerts; RETURN; END IF;',
'',
'  ur_utils.sanitize_template_definition(v_json, ''COL'', v_sanitized_json, v_san_status, v_san_msg);',
'  IF v_san_status = ''E'' THEN',
'    ur_utils.add_alert(v_alerts, v_san_msg, ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts; RETURN;',
'  ELSIF v_san_status IN (''S'',''W'') THEN ',
'    ur_utils.add_alert(v_alerts, v_san_msg, ''success'', NULL, NULL, v_alerts);',
'  END IF;',
'v_base_key := ur_utils.Clean_TEXT(:P1002_TEMPLATE_NAME); ',
'v_key := v_base_key; ',
'LOOP ',
'SELECT COUNT(*) INTO v_exists ',
'FROM UR_TEMPLATES ',
'WHERE KEY = v_key; ',
'EXIT WHEN v_exists = 0; ',
'v_key := v_base_key || ''_'' || v_suffix;',
' v_suffix := v_suffix + 1; ',
' END LOOP;',
'  IF :P1002_SHEET_NAME IS NOT NULL THEN',
'    SELECT sheet_display_name INTO v_sheet_display_name',
'    FROM TABLE(apex_data_parser.get_xlsx_worksheets(',
'        p_content => (SELECT blob_content FROM temp_blob WHERE NAME = :P1002_FILE_NAME_HIDDEN)))',
'    WHERE SHEET_FILE_NAME = :P1002_SHEET_NAME AND ROWNUM = 1;',
'  END IF;',
'  SELECT ID, JSON_VALUE(profile, ''$."file-type"'' RETURNING NUMBER)',
'  INTO v_file_id, v_file_type FROM temp_blob WHERE name = :P1002_FILE_NAME_HIDDEN;',
'  SELECT JSON_OBJECT(',
'    ''skip_rows'' VALUE NVL(:P1002_SKIP_ROWS, 0), ''sheet_file_name'' VALUE :P1002_SHEET_NAME,',
'    ''sheet_display_name'' VALUE v_sheet_display_name, ''file_type'' VALUE v_file_type,',
'    ''file_id'' VALUE v_file_id) INTO v_metadata FROM DUAL;',
'  INSERT INTO UR_TEMPLATES (KEY, NAME, Hotel_ID, TYPE, ACTIVE, DEFINITION, METADATA)',
'  VALUES (v_key, :P1002_TEMPLATE_NAME, :P0_HOTEL_ID, :P1002_TEMPLATE_TYPE, ''Y'', v_sanitized_json, v_metadata);',
'  COMMIT;',
'  ur_utils.define_db_object(v_key, v_def_ok, v_def_msg);',
'  ur_utils.add_alert(v_alerts, v_def_msg, CASE WHEN v_def_ok THEN ''success'' ELSE ''error'' END, NULL, NULL, v_alerts);',
'  IF apex_collection.collection_exists(''UR_FILE_DATA_PROFILES'') THEN',
'    apex_collection.delete_collection(''UR_FILE_DATA_PROFILES'');',
'  END IF;',
'  IF :P1002_TEMPLATE_TYPE = ''RST'' THEN',
'    ur_utils.create_ranking_view(v_key, v_view_ok, v_view_msg);',
'    IF v_view_ok THEN',
'      ur_utils.add_alert(v_alerts, v_view_msg, ''success'', NULL, NULL, v_alerts); COMMIT;',
'    ELSE',
'      ur_utils.add_alert(v_alerts, ''Ranking view failed: '' || v_view_msg, ''warning'', NULL, NULL, v_alerts);',
'      :P0_ALERT_MESSAGE := v_alerts; RETURN;',
'    END IF;',
'  END IF;',
'  ur_utils.manage_algo_attributes(v_key, ''C'', NULL, v_algo_ok, v_algo_msg);',
'  ur_utils.add_alert(v_alerts, v_algo_msg, CASE WHEN v_algo_ok THEN ''success'' ELSE ''error'' END, NULL, NULL, v_alerts);',
'  :P0_ALERT_MESSAGE := v_alerts;',
'  :P1002_FILE_LOAD := NULL;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    apex_debug.message(''Ex: '' || SQLERRM);',
'    ur_utils.add_alert(v_alerts, SQLERRM, ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts; RAISE;',
'END;'))
,p_attribute_02=>'P1002_TEMPLATE_NAME,P1002_TEMPLATE_TYPE,P1002_HOTEL_LIST,P0_HOTEL_ID,1002_P1_FILE_ID,P1002_FILE_TYPE,P1002_SHEET_NAME,P1002_SKIP_ROWS,P1002_FILE_NAME_HIDDEN'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30223322778500751)
,p_name=>'DEFINE_TEMPLATE_CLICK'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(30214074201500693)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30223861026500753)
,p_event_id=>wwv_flow_imp.id(30223322778500751)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_json       CLOB;',
'  v_ok         VARCHAR2(1);',
'  v_msg        VARCHAR2(4000);',
'  v_key        VARCHAR2(4000);',
'  v_exists     NUMBER;',
'  v_alerts     CLOB := NULL;',
'  v_val_status VARCHAR2(1); -- New variable for validation status',
'  v_def_ok     BOOLEAN;',
'  v_def_msg    VARCHAR2(4000);',
'  v_view_ok    BOOLEAN;',
'  v_view_msg   VARCHAR2(4000);',
'  -- Separate variables for manage_algo_attributes',
'  v_algo_ok    BOOLEAN;',
'  v_algo_msg   VARCHAR2(4000);',
'BEGIN',
'  ur_utils.get_collection_json(''UR_FILE_DATA_PROFILES'', v_json, v_ok, v_msg);',
'',
'  IF v_ok = ''E'' THEN',
'    ur_utils.add_alert(v_alerts, v_msg, ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RETURN;',
'  END IF;',
'',
'  -- Call the new validation procedure',
'  ur_utils.VALIDATE_TEMPLATE_DEFINITION(',
'      p_json_clob  => v_json,',
'      p_alert_clob => v_alerts,',
'      p_status     => v_val_status',
'  );',
'',
'  -- Check the status returned by the procedure',
'  IF v_val_status = ''E'' THEN',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RETURN;',
'  END IF;',
'',
'  v_key := ur_utils.Clean_TEXT(:P1002_TEMPLATE_NAME);',
'  SELECT COUNT(*) INTO v_exists FROM UR_TEMPLATES WHERE KEY = v_key;',
'',
'  IF v_exists > 0 THEN',
'    ur_utils.add_alert(v_alerts, ''Template key "'' || v_key || ''" already exists.'', ''warning'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RETURN;',
'  END IF;',
'',
'  INSERT INTO UR_TEMPLATES (KEY, NAME, Hotel_ID, TYPE, ACTIVE, DEFINITION)',
'  VALUES (v_key, :P1002_TEMPLATE_NAME, :P0_HOTEL_ID, :P1002_TEMPLATE_TYPE, ''Y'', v_json);',
'  COMMIT;',
'',
'  ur_utils.define_db_object(v_key, v_def_ok, v_def_msg);',
'',
'  IF v_def_ok THEN',
'    ur_utils.add_alert(v_alerts, v_def_msg, ''success'', NULL, NULL, v_alerts);',
'  ELSE',
'    ur_utils.add_alert(v_alerts, v_def_msg, ''error'', NULL, NULL, v_alerts);',
'  END IF;',
'',
'  IF apex_collection.collection_exists(''UR_FILE_DATA_PROFILES'') THEN',
'    apex_collection.delete_collection(''UR_FILE_DATA_PROFILES'');',
'  END IF;',
'',
'  ---------------------------------------------------------------------------',
'  -- RST -> create ranking view first, then attributes',
'  -- non-RST -> only attributes',
'  ---------------------------------------------------------------------------',
'  IF :P1002_TEMPLATE_TYPE = ''RST'' THEN',
'',
'    -- use view vars for create_ranking_view',
'    ur_utils.create_ranking_view(v_key, v_view_ok, v_view_msg);',
'',
'    IF v_view_ok THEN',
'      ur_utils.add_alert(v_alerts, v_view_msg, ''success'', NULL, NULL, v_alerts);',
'      COMMIT;',
'    ELSE',
'      ur_utils.add_alert(v_alerts, ''Ranking view failed: '' || v_view_msg, ''warning'', NULL, NULL, v_alerts);',
'      -- stop further processing for RST if view creation failed (matches earlier behaviour)',
'      :P0_ALERT_MESSAGE := v_alerts;',
'      RETURN;',
'    END IF;',
'',
'    -- after successful view creation, create algo attributes (use algo vars)',
'    ur_utils.manage_algo_attributes(v_key, ''C'', NULL, v_algo_ok, v_algo_msg);',
'    IF v_algo_ok THEN',
'      ur_utils.add_alert(v_alerts, v_algo_msg, ''success'', NULL, NULL, v_alerts);',
'    ELSE',
'      ur_utils.add_alert(v_alerts, v_algo_msg, ''error'', NULL, NULL, v_alerts);',
'    END IF;',
'',
'  ELSE',
'    -- Non-RST: directly create algo attributes (use algo vars)',
'    ur_utils.manage_algo_attributes(v_key, ''C'', NULL, v_algo_ok, v_algo_msg);',
'    IF v_algo_ok THEN',
'      ur_utils.add_alert(v_alerts, v_algo_msg, ''success'', NULL, NULL, v_alerts);',
'    ELSE',
'      ur_utils.add_alert(v_alerts, v_algo_msg, ''error'', NULL, NULL, v_alerts);',
'    END IF;',
'  END IF;',
'',
'  ---------------------------------------------------------------------------',
'  -- finalize',
'  ---------------------------------------------------------------------------',
'  :P0_ALERT_MESSAGE := v_alerts;',
'  :P1002_FILE_LOAD := NULL;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    apex_debug.message(''Ex: '' || SQLERRM);',
'    ur_utils.add_alert(v_alerts, SQLERRM, ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RAISE;',
'END;',
''))
,p_attribute_02=>'P1002_TEMPLATE_NAME,P1002_TEMPLATE_TYPE,P1002_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_03=>'P1002_ALERT_TITLE,P1002_ALERT_MESSAGE,P1002_ALERT_ICON,P1002_ALERT_TIMER,P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30224387405500755)
,p_event_id=>wwv_flow_imp.id(30223322778500751)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(39776995830926037)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30224853820500757)
,p_event_id=>wwv_flow_imp.id(30223322778500751)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1002_TEMPLATE_NAME,P1002_TEMPLATE_TYPE,P1_FILE_ID'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30222432101500748)
,p_name=>'New_3'
,p_event_sequence=>100
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'body'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'showAlert'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30222950066500750)
,p_event_id=>wwv_flow_imp.id(30222432101500748)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var title = $v(''P1002_ALERT_TITLE'') || ''Notification'';',
'var message = $v(''P1002_ALERT_MESSAGE'');',
'var icon  = $v(''P1002_ALERT_ICON'') || ''success'';',
'',
'if(message){',
'  Swal.fire({',
'    position: ''top-end'',',
'    icon: icon,',
'    title: title,',
'    text: message,',
'    showConfirmButton: false,',
'    timer: 2500',
'  });',
'  ',
'  $s(''P1002_ALERT_MESSAGE'','''');',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30229526274500771)
,p_name=>'Changed'
,p_event_sequence=>110
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1002_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30230041040500772)
,p_event_id=>wwv_flow_imp.id(30229526274500771)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P1002_ALERT_MESSAGE");  // get the string from hidden page item',
'',
'if (messagesJson) {',
'  try {',
'    // Try parsing the string',
'    var parsed = JSON.parse(messagesJson);',
'',
'    // Check if parsed result is array or object',
'    if (Array.isArray(parsed)) {',
'      // It''s an array - pass as is',
'      showAlertToastr(parsed);',
'    } else if (parsed && typeof parsed === ''object'') {',
'      // Single object - pass it wrapped in array for consistency ',
'      showAlertToastr([parsed]);',
'    } else {',
unistr('      // Parsed to something else (string/number) \2014 just pass original string'),
'      showAlertToastr(messagesJson);',
'    }',
'  } catch (e) {',
unistr('    // Parsing failed \2014 probably plain text, pass as is'),
'    showAlertToastr(messagesJson);',
'  }',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30238075343500795)
,p_name=>'New'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P0_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30238577681500797)
,p_event_id=>wwv_flow_imp.id(30238075343500795)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let data = JSON.parse($v(''P0_ALERT_MESSAGE''));',
'',
'apex.message.clearErrors();',
'',
'apex.message.showPageSuccess(',
'    data[0].title + '': '' + data[0].message',
');',
'',
'// OR if using custom toast region:',
'//',
'// apex.message.showErrors([{',
'//     type: "error",',
'//     location: ["page"],',
'//     message: data[0].message,',
'//     unsafe: false',
'// }]);',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(30221545617500744)
,p_name=>'New_2'
,p_event_sequence=>130
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_imp.id(39776995830926037)
,p_triggering_element=>'DEFAULT_VALUE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(30222061816500747)
,p_event_id=>wwv_flow_imp.id(30221545617500744)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'alert'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(29953196016436322)
,p_name=>'change skip rows'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1002_SKIP_ROWS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(29953218520436323)
,p_event_id=>wwv_flow_imp.id(29953196016436322)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(29951304007436304)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(29953324232436324)
,p_name=>'Change Sheet Name'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1002_SHEET_NAME'
,p_condition_element=>'P1002_SHEET_NAME'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(29953444748436325)
,p_event_id=>wwv_flow_imp.id(29953324232436324)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(29951304007436304)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(29954138141436332)
,p_name=>'REFRESH_FILE_PROFILE'
,p_event_sequence=>160
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1002_SKIP_ROWS,P1002_SHEET_NAME'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(29954295186436333)
,p_event_id=>wwv_flow_imp.id(29954138141436332)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_status  VARCHAR2(1);',
'    v_message VARCHAR2(4000);',
'    v_alerts  CLOB;',
'BEGIN',
'    ur_utils.refresh_file_profile_and_collection(',
'        p_file_name       => :P1002_FILE_NAME_HIDDEN,',
'        p_skip_rows       => NVL(:P1002_SKIP_ROWS, 0),',
'        p_sheet_name      => :P1002_SHEET_NAME,',
'        p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'        p_status          => v_status,',
'        p_message         => v_message',
'    );',
'',
'    ur_utils.add_alert(',
'        p_existing_json => v_alerts,',
'        p_message       => v_message,',
'        p_icon          => CASE v_status WHEN ''S'' THEN ''success'' ELSE ''error'' END,',
'        p_title         => NULL,',
'        p_timeout       => NULL,',
'        p_updated_json  => v_alerts',
'    );',
'',
'    :P0_ALERT_MESSAGE := v_alerts;',
'END;'))
,p_attribute_02=>'P1002_FILE_NAME_HIDDEN,P1002_SKIP_ROWS,P1002_SHEET_NAME'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(29954374681436334)
,p_event_id=>wwv_flow_imp.id(29954138141436332)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(39776995830926037)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33349187759790140)
,p_name=>'Change to Date'
,p_event_sequence=>170
,p_triggering_element_type=>'COLUMN'
,p_triggering_region_id=>wwv_flow_imp.id(39776995830926037)
,p_triggering_element=>'DATA_TYPE'
,p_condition_element_type=>'COLUMN'
,p_condition_element=>'DATA_TYPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'DATE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33349445257790143)
,p_event_id=>wwv_flow_imp.id(33349187759790140)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'COLUMN'
,p_affected_elements=>'FORMAT_MASK'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33349294526790141)
,p_event_id=>wwv_flow_imp.id(33349187759790140)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_seq_id NUMBER := :SEQ_ID;',
'    v_column_name VARCHAR2(100) := :NAME;',
'    v_file_id NUMBER;',
'    v_format_mask VARCHAR2(100) := NULL;',
'    v_sample_values CLOB;',
'    v_extract_status VARCHAR2(1);',
'    v_extract_msg VARCHAR2(4000);',
'    v_alert_clob CLOB := NULL;',
'    v_confidence NUMBER;',
'    v_converted_date DATE;',
'    v_has_year VARCHAR2(1);',
'    v_is_ambiguous VARCHAR2(1);',
'    v_special_values VARCHAR2(500);',
'    v_all_formats CLOB;',
'    v_detect_status VARCHAR2(1);',
'    v_detect_msg VARCHAR2(4000);',
'BEGIN',
'    -- Get file_id from temp_blob',
'    BEGIN',
'        SELECT ID INTO v_file_id FROM temp_blob WHERE name = :P1002_FILE_NAME_HIDDEN AND ROWNUM = 1;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            ur_utils.add_alert(v_alert_clob, ''Column "'' || v_column_name || ''": File not found for format detection.'', ''error'', NULL, NULL, v_alert_clob);',
'            :P0_ALERT_MESSAGE := v_alert_clob;',
'            RETURN;',
'    END;',
'',
'    -- Extract sample values',
'    ur_utils.extract_column_sample_values(v_file_id, v_column_name, NVL(:P1002_SKIP_ROWS, 0), :P1002_SHEET_NAME, v_sample_values, v_extract_status, v_extract_msg);',
'',
'    IF v_extract_status = ''S'' AND v_sample_values IS NOT NULL THEN',
'        -- Detect format',
'        ur_utils.date_parser(''DETECT'', NULL, NULL, v_sample_values, NULL, NULL, NULL, 90, ''N'', v_alert_clob, v_format_mask, v_confidence, v_converted_date, v_has_year, v_is_ambiguous, v_special_values, v_all_formats, v_detect_status, v_detect_msg);',
'',
'        -- Update collection with detected format',
'        IF v_detect_status IN (''S'', ''W'') AND v_format_mask IS NOT NULL THEN',
'            apex_collection.update_member_attribute(''UR_FILE_DATA_PROFILES'', v_seq_id, 2, ''DATE'');',
'            apex_collection.update_member_attribute(''UR_FILE_DATA_PROFILES'', v_seq_id, 7, v_format_mask);',
'            ',
'            -- Set alert message based on result',
'            IF v_is_ambiguous = ''Y'' THEN',
'                ur_utils.add_alert(v_alert_clob, ''Column "'' || v_column_name || ''": Ambiguous format detected as "'' || v_format_mask || ''" (confidence: '' || ROUND(v_confidence) || ''%). Please verify.'', ''warning'', NULL, NULL, v_alert_clob);',
'            ELSE',
'                ur_utils.add_alert(v_alert_clob, ''Column "'' || v_column_name || ''": Format detected as "'' || v_format_mask || ''" (confidence: '' || ROUND(v_confidence) || ''%)'', ''success'', NULL, NULL, v_alert_clob);',
'            END IF;',
'        ELSE',
'            ur_utils.add_alert(v_alert_clob, ''Column "'' || v_column_name || ''": Unable to detect format. Please enter manually.'', ''warning'', NULL, NULL, v_alert_clob);',
'        END IF;',
'    ELSE',
'        ur_utils.add_alert(v_alert_clob, ''Column "'' || v_column_name || ''": Sample extraction failed. '' || v_extract_msg, ''error'', NULL, NULL, v_alert_clob);',
'    END IF;',
'',
'    -- Return alert message to display',
'    :P0_ALERT_MESSAGE := v_alert_clob;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ur_utils.add_alert(v_alert_clob, ''Column "'' || v_column_name || ''": Error during format detection. '' || SQLERRM, ''error'', NULL, NULL, v_alert_clob);',
'        :P0_ALERT_MESSAGE := v_alert_clob;',
'END;'))
,p_attribute_02=>'P1002_SKIP_ROWS,P1002_FILE_NAME_HIDDEN,P1002_SHEET_NAME,SEQ_ID,NAME'
,p_attribute_03=>'P0_ALERT_MESSAGE,FORMAT_MASK'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33349645369790145)
,p_event_id=>wwv_flow_imp.id(33349187759790140)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var formatMask = apex.item("FORMAT_MASK").getValue();',
'',
'if (formatMask) {',
'    var ig$ = apex.region("Collection_grid").widget().interactiveGrid;',
'    var model = ig$.getViews().grid.model;',
'    var record = ig$.getActions().invoke("get-current-record");',
'    ',
'    if (record) {',
'        model.setValue(record, "FORMAT_MASK", formatMask);',
'    }',
'}'))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33349396114790142)
,p_event_id=>wwv_flow_imp.id(33349187759790140)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(39776995830926037)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30221170973500742)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    FOR rec IN (',
'        SELECT seq_id',
'        FROM apex_collections',
'        WHERE collection_name = ''UR_FILE_DATA_PROFILES''',
'          AND c005 IS NULL',
'    )',
'    LOOP',
'        APEX_COLLECTION.UPDATE_MEMBER(',
'            p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'            p_seq             => rec.seq_id,',
'            p_c005            => ''Maps To''',
'        );',
'    END LOOP;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>30221170973500742
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30212920831500687)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(39776995830926037)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Collections - Save File Profile'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_status  VARCHAR2(10);',
'    v_message VARCHAR2(4000);',
'begin',
unistr('  -- \D83D\DD25 Apply default if user did not change mapping_type'),
'    IF :mapping_type IS NULL THEN',
'        :mapping_type := ''Maps To'';',
'    END IF;',
'',
'   validate_profile_row(',
'        p_name          => :name,',
'        p_data_type     => :data_type,',
'        p_mapping_type  => :mapping_type,',
'        p_default_value => :default_value,',
'        p_collection    => ''UR_FILE_DATA_PROFILES'',',
'        o_status        => v_status,',
'        o_message       => v_message',
'    );',
'',
'     IF v_status = ''ERROR'' THEN',
'',
'',
'        -- Register error so IG stops saving, but without popup',
'        apex_error.add_error(',
'            p_message          => V_MESSAGE,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'',
'        RETURN;',
'    END IF;',
'',
'',
'    case :APEX$ROW_STATUS',
'    when ''C'' then',
'        :SEQ_ID := APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'        p_c001            => :name ,',
'        p_c003            => :qualifier ,',
'        p_c002            => :data_type,',
'        p_c005            => :mapping_type,',
'        p_c004            => :default_value);',
'        ',
'    when ''U'' then',
'        APEX_COLLECTION.UPDATE_MEMBER (',
'        p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'        p_seq             => :SEQ_ID,',
'        p_c001            => :name ,',
'        p_c003            => :qualifier ,',
'        p_c002            => :data_type,',
'        p_c005            => :mapping_type,',
'         p_c004            => :default_value);',
'    when ''D'' then',
'        APEX_COLLECTION.DELETE_MEMBER (',
'        p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'        p_seq             => :SEQ_ID);',
'    end case;',
'end;',
'',
''))
,p_attribute_05=>'Y'
,p_attribute_06=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>30212920831500687
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30220795721500741)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_json CLOB;',
'BEGIN',
'  l_json := UR_utils.get_collection_json(''UR_FILE_DATA_PROFILES'');',
'',
'  INSERT INTO UR_TEMPLATES (',
'    KEY,',
'    NAME,',
'    TYPE,',
'    ACTIVE,',
'    DEFINITION,',
'    CREATED_BY,',
'    CREATED_ON,',
'    UPDATED_BY,',
'    UPDATED_ON',
'  ) VALUES (',
'    UPPER(',
'      SUBSTR(',
'        REGEXP_REPLACE(',
'          REGEXP_REPLACE(',
'            REGEXP_REPLACE(',
'              TRIM(:P1002_TEMPLATE_NAME),',
'              ''^[^A-Za-z0-9]+|[^A-Za-z0-9]+$'', ''''',
'            ),',
'            ''[^A-Za-z0-9]+'', ''_''',
'          ),',
'          ''_+'', ''_''',
'        ),',
'        1, 110',
'      )',
'    ),',
'    :P1002_TEMPLATE_NAME,',
'    :P1002_TEMPLATE_TYPE,',
'    ''Y'',  -- or hardcode ''ADMIN''',
'    l_json,',
'    ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP,',
'    ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP',
'  );',
'',
'  apex_debug.message(''Debug info: '' || l_json);',
'  ',
'  apex_pwa.send_push_notification (',
'    p_application_id => 103,',
'    p_user_name      => ''VKANT'',',
'    p_title          => ''Template Created Successfully.'',',
'    p_body           => ''Order #123456 will arrive within 3 days.'' );',
'',
'--   :P1002_AI_RESPONSE := ''Insert Successful'';',
'apex_pwa.push_queue;',
'-- RETURN ''SUCCESS'';',
'',
'--   apex.message.showToast(',
'--     pMessage => ''Changes saved'',',
'--     pPosition => ''top-right'',   -- or ''top-left'', ''bottom-right'', ''bottom-left''',
'--     pDuration => 3000,          -- milliseconds; 0 means sticky until closed',
'--     pCloseIcon => true,         -- show a close (x) icon',
'--     pStyle => ''success''         -- values: ''success'', ''warning'', ''error'', ''information''',
'--   );',
'',
'-- apex_application.g_print_success_message := ''Record saved successfully!'';',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    -- :P1002_AI_RESPONSE := ''Insert Failed: '' || SQLERRM;',
'    apex_debug.message(''Insert Failed: '' || SQLERRM);',
'    -- RETURN ''Failed ''||SQLERRM;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Blah blah blah'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(30214074201500693)
,p_process_success_message=>'Succesfully Done'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>30220795721500741
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(30220348854500739)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Create File Profile and Collection Loading'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_profile_clob CLOB;',
'  v_records      NUMBER;',
'  v_columns      CLOB;',
'',
'  -- Cursor to iterate over JSON columns',
'  CURSOR cur_columns IS',
'    SELECT jt.name, jt.data_type',
'      FROM JSON_TABLE(',
'             v_columns,',
'             ''$[*]''',
'             COLUMNS (',
'               name       VARCHAR2(100) PATH ''$.name'',',
'               data_type  VARCHAR2(20) PATH ''$."data-type"''',
'             )',
'           ) jt;',
'',
'  -- Helper function to sanitize column names',
'  FUNCTION sanitize_column_name(p_name IN VARCHAR2) RETURN VARCHAR2 IS',
'  v_name VARCHAR2(4000);',
'BEGIN',
'  -- Replace non-alphanumeric characters with underscore',
'  v_name := REGEXP_REPLACE(p_name, ''[^A-Za-z0-9]'', ''_'');',
'',
'  -- Replace multiple consecutive underscores with a single underscore',
'  v_name := REGEXP_REPLACE(v_name, ''_+'', ''_'');',
'',
'  -- Trim leading and trailing underscores',
'  v_name := REGEXP_REPLACE(v_name, ''^_+|_+$'', '''');',
'',
'  -- Convert to uppercase',
'  RETURN UPPER(v_name);',
'END;',
'',
'',
'BEGIN',
'  -- Create or truncate APEX collection before processing',
'  IF apex_collection.collection_exists(''UR_FILE_DATA_PROFILES'') THEN',
'    apex_collection.delete_collection(''UR_FILE_DATA_PROFILES'');',
'  END IF;',
'  ',
'  apex_collection.create_collection(''UR_FILE_DATA_PROFILES'');',
'',
'  -- Copy uploaded file to temp table',
'  FOR r IN (',
'    SELECT ID, APPLICATION_ID, NAME, FILENAME, MIME_TYPE, CREATED_ON, BLOB_CONTENT',
'      FROM APEX_APPLICATION_TEMP_FILES',
'     WHERE NAME = :P1002_FILE_LOAD',
'  ) LOOP',
'    INSERT INTO temp_BLOB (',
'      ID,',
'      APPLICATION_ID,',
'      NAME,',
'      FILENAME,',
'      MIME_TYPE,',
'      CREATED_ON,',
'      BLOB_CONTENT',
'    ) VALUES (',
'      r.ID,',
'      r.APPLICATION_ID,',
'      r.NAME,',
'      r.FILENAME,',
'      r.MIME_TYPE,',
'      r.CREATED_ON,',
'      r.BLOB_CONTENT',
'    );',
'  END LOOP;',
'',
'    :P1002_FILE_NAME_HIDDEN := :P1002_FILE_LOAD;',
'',
'  -- Process each temp_BLOB record',
'  FOR rec IN (',
'    SELECT ID, BLOB_CONTENT, filename, name',
'      FROM temp_BLOB',
'     WHERE profile IS NULL -- only parse if profile not yet loaded',
'  ) LOOP',
'    -- Call APEX_DATA_PARSER to get file profile',
'    SELECT apex_data_parser.discover(',
'             p_content => rec.BLOB_CONTENT,',
'             p_file_name => rec.filename,',
'             p_max_rows => 99999',
'           )',
'      INTO v_profile_clob',
'      FROM dual;',
'',
'    -- Extract parsed row count',
'    SELECT TO_NUMBER(JSON_VALUE(v_profile_clob, ''$."parsed-rows"''))',
'      INTO v_records',
'      FROM dual;',
'',
'    -- Extract columns and map data types',
'   /* SELECT TO_CLOB(',
'             JSON_ARRAYAGG(',
'               JSON_OBJECT(',
'                 ''name'' VALUE jt.name,',
'                 ''data-type'' VALUE CASE jt.data_type',
'                                    WHEN 1 THEN ''TEXT''',
'                                    WHEN 2 THEN ''NUMBER''',
'                                    WHEN 3 THEN ''DATE''',
'                                    ELSE ''TEXT''',
'                                  END',
'               )',
'             )',
'           )',
'      INTO v_columns',
'      FROM JSON_TABLE(',
'             v_profile_clob,',
'             ''$."columns"[*]''',
'             COLUMNS (',
'               name       VARCHAR2(100) PATH ''$.name'',',
'               data_type  NUMBER       PATH ''$."data-type"''',
'             )',
'           ) jt; commented to handle large files with 30+columns*/',
unistr('           -- \2705 Build columns JSON safely as CLOB'),
'    SELECT (',
'             SELECT JSON_ARRAYAGG(',
'                      JSON_OBJECT(',
'                        ''name'' VALUE jt.name,',
'                        ''data-type'' VALUE CASE jt.data_type',
'                                           WHEN 1 THEN ''TEXT''',
'                                           WHEN 2 THEN ''NUMBER''',
'                                           WHEN 3 THEN ''DATE''',
'                                           ELSE ''TEXT''',
'                                         END',
'                      )',
'                    RETURNING CLOB',
'                    )',
'             FROM JSON_TABLE(',
'                    v_profile_clob,',
'                    ''$."columns"[*]''',
'                    COLUMNS (',
'                      name       VARCHAR2(200) PATH ''$.name'',',
'                      data_type  NUMBER        PATH ''$."data-type"''',
'                    )',
'                  ) jt',
'           )',
'      INTO v_columns',
'      FROM dual;',
'',
'      FOR col IN (',
'    SELECT jt.name, jt.data_type',
'      FROM JSON_TABLE(',
'             v_columns,',
'             ''$[*]''',
'             COLUMNS (',
'               name       VARCHAR2(100) PATH ''$.name'',',
'               data_type  VARCHAR2(20) PATH ''$."data-type"''',
'             )',
'           ) jt',
'  ) LOOP',
'    DECLARE',
'        v_format_mask VARCHAR2(100) := NULL;',
'        v_sample_values CLOB;',
'        v_extract_status VARCHAR2(1);',
'        v_extract_msg VARCHAR2(4000);',
'        v_column_display VARCHAR2(200);',
'    BEGIN',
'        v_column_display := sanitize_column_name(col.name);',
'        ',
'        -- Only detect format for DATE columns',
'        IF col.data_type = ''DATE'' THEN',
'            -- Extract sample values (366 rows after skip_rows)',
'            ur_utils.extract_column_sample_values(rec.ID, v_column_display, NVL(:P1002_SKIP_ROWS, 0), :P1002_SHEET_NAME, v_sample_values, v_extract_status, v_extract_msg);',
'',
'            IF v_extract_status = ''S'' AND v_sample_values IS NOT NULL THEN',
'                -- Use simple detection wrapper',
'                v_format_mask := ur_utils.detect_date_format_simple(v_sample_values);',
'                ',
'                IF v_format_mask IS NOT NULL THEN',
'                    apex_debug.message(''Column "'' || v_column_display || ''": Format detected as "'' || v_format_mask || ''"'');',
'                ELSE',
'                    apex_debug.message(''Column "'' || v_column_display || ''": Unable to detect format'');',
'                END IF;',
'            ELSE',
'                apex_debug.message(''Column "'' || v_column_display || ''": Sample extraction failed - '' || v_extract_msg);',
'            END IF;',
'        END IF;',
'',
'        -- Add to collection with format_mask (NULL for non-DATE or detection failure)',
'        apex_collection.add_member(',
'          p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'          p_c001            => v_column_display,',
'          p_c002            => col.data_type,',
'          p_c007            => v_format_mask',
'        );',
'        ',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            apex_debug.message(''Column "'' || v_column_display || ''": Error - '' || SQLERRM);',
'            ',
'            -- Add member without format_mask',
'            apex_collection.add_member(',
'              p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'              p_c001            => sanitize_column_name(col.name),',
'              p_c002            => col.data_type,',
'              p_c007            => NULL',
'            );',
'    END;',
'  END LOOP;',
'',
'    -- Update temp_BLOB table with profile info',
'    UPDATE temp_BLOB',
'       SET profile = v_profile_clob,',
'           records = v_records,',
'           columns = v_columns',
'     WHERE ID = rec.ID;',
'  END LOOP;',
'',
'  COMMIT;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>30220348854500739
);
wwv_flow_imp.component_end;
end;
/
