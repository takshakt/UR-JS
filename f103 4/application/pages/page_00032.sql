prompt --application/pages/page_00032
begin
--   Manifest
--     PAGE: 00032
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
 p_id=>32
,p_name=>'Template Update Interface v2'
,p_alias=>'TEMPLATE-UPDATE-INTERFACE-V2'
,p_step_title=>'Template Update Interface v2'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(32991612765781501)
,p_plug_name=>'Main Region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(32992116807781506)
,p_plug_name=>'File_Preview'
,p_title=>'2. Preview File'
,p_parent_plug_id=>wwv_flow_imp.id(32991612765781501)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>70
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(32992226682781507)
,p_plug_name=>'Controls'
,p_parent_plug_id=>wwv_flow_imp.id(32992116807781506)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(32993974728781524)
,p_plug_name=>'Preview'
,p_parent_plug_id=>wwv_flow_imp.id(32992116807781506)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
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
'        p_content         => (SELECT blob_content FROM temp_blob WHERE id = :P32_FILE_ID),',
'        p_file_name       => (SELECT filename FROM temp_blob WHERE id = :P32_FILE_ID),',
'        p_xlsx_sheet_name => NULLIF(:P32_SHEET_NAME, ''''),    -- Use sheet_file_name from GET_XLSX_WORKSHEETS',
'        --         p_xlsx_sheet_name => COALESCE(',
'        --     NULLIF(:P1002_SHEET_NAME, ''''),',
'        --     (SELECT MIN(sheet_file_name) KEEP (DENSE_RANK FIRST ORDER BY sheet_sequence)',
'        --      FROM TABLE(apex_data_parser.get_xlsx_worksheets(',
'        --          p_content => (SELECT blob_content FROM temp_blob WHERE NAME = :P1002_FILE_LOAD)',
'        --      ))',
'        --     )',
'        -- ),',
'        p_skip_rows       => NVL(:P32_SKIP_ROWS, 0),              -- 0 = first row is header',
'        p_max_rows        => 20              -- Limit preview rows',
'    )',
')',
'WHERE :P32_file_name_2 IS NOT NULL;'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P32_SKIP_ROWS,P32_SHEET_NAME,P32_FILE_ID,P32_FILE_NAME_2'
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
 p_id=>wwv_flow_imp.id(32994108352781526)
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
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(32994266315781527)
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
 p_id=>wwv_flow_imp.id(32994345871781528)
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
 p_id=>wwv_flow_imp.id(32994486526781529)
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
 p_id=>wwv_flow_imp.id(32994532660781530)
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
 p_id=>wwv_flow_imp.id(32994686624781531)
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
 p_id=>wwv_flow_imp.id(32994737394781532)
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
 p_id=>wwv_flow_imp.id(32994825006781533)
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
 p_id=>wwv_flow_imp.id(32994977355781534)
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
 p_id=>wwv_flow_imp.id(32995011497781535)
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
 p_id=>wwv_flow_imp.id(32995135509781536)
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
 p_id=>wwv_flow_imp.id(32994081520781525)
,p_internal_uid=>32994081520781525
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
 p_id=>wwv_flow_imp.id(33604566372188699)
,p_interactive_grid_id=>wwv_flow_imp.id(32994081520781525)
,p_static_id=>'336046'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(33604724201188699)
,p_report_id=>wwv_flow_imp.id(33604566372188699)
,p_view_type=>'GRID'
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33605246641188706)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(32994108352781526)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33606171486188712)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(32994266315781527)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33607023058188717)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(32994345871781528)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33607958063188721)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(32994486526781529)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33608852043188725)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(32994532660781530)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33609724767188729)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(32994686624781531)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33610641279188733)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(32994737394781532)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33611512312188738)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(32994825006781533)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33612426701188742)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(32994977355781534)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33613397686188746)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(32995011497781535)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(33614250552188750)
,p_view_id=>wwv_flow_imp.id(33604724201188699)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(32995135509781536)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47881562974887284)
,p_plug_name=>'Template Details'
,p_title=>'1. Template Details'
,p_parent_plug_id=>wwv_flow_imp.id(32991612765781501)
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>60
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(47881717758887285)
,p_plug_name=>'Template Info'
,p_parent_plug_id=>wwv_flow_imp.id(47881562974887284)
,p_region_template_options=>'#DEFAULT#:t-ContentBlock--h1:t-Region--removeHeader js-removeLandmark'
,p_plug_template=>2322115667525957943
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html_output  CLOB := NULL;',
'    l_count        NUMBER;',
'    l_sql          VARCHAR2(1000);',
'    l_count1        NUMBER;',
'    l_sql1          VARCHAR2(1000);',
'BEGIN',
'    -- Start container',
'    l_html_output := ''<div class="fancy-card-list">'';',
'',
'    -- Loop through template records',
'    FOR rec IN (',
'        SELECT t.name,',
'               t.active,',
'               t.type,',
'               t.db_object_name,',
'               h.hotel_name,',
'               t.DB_VIEW_OBJECT_NAME,',
'               NVL(COUNT(a.key), 0) AS attribute_count',
'          FROM ur_templates t',
'          LEFT JOIN ur_hotels h',
'            ON h.id = t.hotel_id',
'          LEFT JOIN ur_algo_attributes a',
'    ON a.template_id = t.id',
'         WHERE t.id = :P32_TEMPLATE_LIST',
'         GROUP BY ',
'    t.name,',
'    t.active,',
'    t.type,',
'    t.db_object_name,',
'    h.hotel_name,',
'    t.db_view_object_name',
'         ORDER BY t.name',
'    )',
'    LOOP',
'        -- Get record count from the table specified in DB_OBJECT_NAME',
'        BEGIN',
'            l_sql := ''SELECT COUNT(*) FROM '' || rec.db_object_name;',
'            EXECUTE IMMEDIATE l_sql INTO l_count;',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                l_count := 0; -- In case table doesn''t exist or invalid',
'        END;',
'',
'        /*BEGIN',
'            l_sql1 := ''SELECT COUNT(*) FROM '' || rec.key;',
'            EXECUTE IMMEDIATE l_sql1 INTO l_count1;',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                l_count1 := 0; -- In case table doesn''t exist or invalid',
'        END;*/',
'',
'        -- Start individual card',
'        l_html_output := l_html_output || ''<div class="fancy-card '';',
'',
'        /*IF rec.active = ''Y'' THEN',
'            l_html_output := l_html_output || ''is-active" data-type="'' || rec.type || ''">'';',
'        ELSE',
'            l_html_output := l_html_output || ''is-inactive" data-type="'' || rec.type || ''">'';',
'        END IF;*/',
'',
'        -- Card header',
'        l_html_output := l_html_output || ''<div class="card-header">'';',
'       -- l_html_output := l_html_output || ''<h3>'' || APEX_ESCAPE.HTML(rec.name) || ''</h3>'';',
'       -- l_html_output := l_html_output || ''<span class="card-type">'' || APEX_ESCAPE.HTML(rec.type) || ''</span>'';',
'        l_html_output := l_html_output || ''</div>'';',
'',
'        -- Card body',
'        l_html_output := l_html_output || ''<div class="card-body">'';',
'        --l_html_output := l_html_output || ''<p>Status: <strong>'' ||',
unistr('          --  CASE WHEN rec.active = ''Y'' THEN ''Active \2705'' ELSE ''Inactive \274C'' END || ''</strong></p>'';'),
'        l_html_output := l_html_output || ''<p>Hotel: <strong>'' || NVL(rec.hotel_name, ''N/A'') || ''</strong></p>'';',
'        l_html_output := l_html_output || ''<p>Table: <strong>'' || rec.db_object_name || ''</strong></p>'';',
'        IF rec.DB_VIEW_OBJECT_NAME IS NOT NULL THEN',
'    l_html_output := l_html_output || ''<p>View: <strong>'' || rec.DB_VIEW_OBJECT_NAME || ''</strong></p>'';',
'END IF;',
'        l_html_output := l_html_output || ''<p>Record Count: <strong>'' || l_count || ''</strong></p>'';',
'        l_html_output := l_html_output || ''<p>Attribute Count: <strong>'' || rec.attribute_count || ''</strong></p>'';',
'        l_html_output := l_html_output || ''</div>'';',
'',
'        -- End card',
'        l_html_output := l_html_output || ''</div>'';',
'    END LOOP;',
'',
'    -- End container',
'    l_html_output := l_html_output || ''</div>'';',
'',
'    RETURN l_html_output;',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P32_TEMPLATE_LIST'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(55440163740903476)
,p_plug_name=>'Note'
,p_parent_plug_id=>wwv_flow_imp.id(47881562974887284)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>'Note : Before making any changes to the template mapping you will need to delete your loaded data. Please note that deletion cannot be undone.'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(55440109709903475)
,p_plug_name=>'Template Mapping'
,p_title=>'3. Template Mapping'
,p_parent_plug_id=>wwv_flow_imp.id(32991612765781501)
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
 p_id=>wwv_flow_imp.id(47880149367887269)
,p_plug_name=>'Template Definition'
,p_region_name=>'Template_Definition'
,p_parent_plug_id=>wwv_flow_imp.id(55440109709903475)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--removeHeader js-removeLandmark'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>80
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT seq_id,',
'       c001 AS name,',
'       c002 AS data_type,',
'       c003 AS qualifier,',
'       c004 AS value,',
'       c005 as mapping_type,',
'       c006 as original_name',
'  FROM apex_collections',
' WHERE collection_name = ''TEMPLATE_DATA''',
' and :P32_TEMPLATE_LIST is not null',
''))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P32_TEMPLATE_LIST'
,p_prn_content_disposition=>'ATTACHMENT'
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(47881516464887283)
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
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(47884484340887313)
,p_name=>'QUALIFIER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUALIFIER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Qualifier'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
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
 p_id=>wwv_flow_imp.id(58048304144707411)
,p_name=>'MAPPING_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAPPING_TYPE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Mapping Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(60073439901789270)
,p_name=>'NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Name'
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
 p_id=>wwv_flow_imp.id(60073486038789271)
,p_name=>'DATA_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DATA_TYPE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Data Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC:TEXT;VARCHAR,NUMBER;NUMBER,DATE;DATE'
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
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(60073612486789272)
,p_name=>'VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VALUE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Value'
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
 p_id=>wwv_flow_imp.id(60073736054789273)
,p_name=>'ORIGINAL_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ORIGINAL_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Original Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
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
 p_id=>wwv_flow_imp.id(60073778028789274)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(60073932900789275)
,p_name=>'APEX$ROW_SELECTOR'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(47880155599887270)
,p_internal_uid=>47880155599887270
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>true
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SET'
,p_show_total_row_count=>false
,p_show_toolbar=>false
,p_toolbar_buttons=>null
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
 p_id=>wwv_flow_imp.id(47906149409127942)
,p_interactive_grid_id=>wwv_flow_imp.id(47880155599887270)
,p_static_id=>'156293'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>10
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(47906255030127944)
,p_report_id=>wwv_flow_imp.id(47906149409127942)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(48720646461445273)
,p_view_id=>wwv_flow_imp.id(47906255030127944)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(47881516464887283)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>79
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(48768708512014891)
,p_view_id=>wwv_flow_imp.id(47906255030127944)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(47884484340887313)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(58533933675330551)
,p_view_id=>wwv_flow_imp.id(47906255030127944)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(58048304144707411)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60086407816798023)
,p_view_id=>wwv_flow_imp.id(47906255030127944)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(60073439901789270)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60087280760798027)
,p_view_id=>wwv_flow_imp.id(47906255030127944)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(60073486038789271)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60088142907798032)
,p_view_id=>wwv_flow_imp.id(47906255030127944)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(60073612486789272)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60089023952798036)
,p_view_id=>wwv_flow_imp.id(47906255030127944)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(60073736054789273)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60095881741877982)
,p_view_id=>wwv_flow_imp.id(47906255030127944)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(60073778028789274)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>111.94399999999999
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(55440433645903478)
,p_plug_name=>'Button_Holder'
,p_parent_plug_id=>wwv_flow_imp.id(55440109709903475)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>100
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(48880790322106789)
,p_plug_name=>'Template List'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_plug_new_grid_row=>false
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(32278434102901807)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(47881562974887284)
,p_button_name=>'Delete_Template_Data'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--warning'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete Loaded Data'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(32281736087901823)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(55440433645903478)
,p_button_name=>'create_template'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(32281372509901822)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(55440433645903478)
,p_button_name=>'Delete_Template'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delete Template'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(32992380844781508)
,p_name=>'P32_FILE_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(32992226682781507)
,p_prompt=>'File Id'
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
 p_id=>wwv_flow_imp.id(32992873546781513)
,p_name=>'P32_FILE_TYPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(32992226682781507)
,p_prompt=>'File Type'
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
 p_id=>wwv_flow_imp.id(32993008248781515)
,p_name=>'P32_SHEET_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(32992226682781507)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    JSON_VALUE(metadata, ''$.sheet_file_name'') AS sheet_file_name',
'FROM ur_templates',
'WHERE id = :P32_TEMPLATE_LIST'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Excel Sheet Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT sheet_display_name AS display,',
'       SHEET_FILE_NAME AS return',
'FROM TABLE(',
'    apex_data_parser.get_xlsx_worksheets(',
'        p_content => (SELECT blob_content',
'                      FROM temp_blob',
'                      WHERE id = (SELECT ',
'    JSON_VALUE(metadata, ''$.file_id'')',
'FROM ur_templates',
'WHERE id = :P32_TEMPLATE_LIST))',
'    )',
')',
'ORDER BY sheet_sequence;'))
,p_lov_cascade_parent_items=>'P32_TEMPLATE_LIST'
,p_ajax_items_to_submit=>'P32_TEMPLATE_LIST'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(32993261982781517)
,p_name=>'P32_SKIP_ROWS'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(32992226682781507)
,p_use_cache_before_default=>'NO'
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT ',
'  JSON_VALUE(metadata, ''$.skip_rows'')',
' ',
'         ',
' ',
'  FROM ur_templates',
' -- WHERE id = :P32_TEMPLATE_LIST;',
'  WHERE id = hextoraw(:P32_TEMPLATE_LIST);',
'',
'  ',
'',
' ',
'',
'',
'',
'',
''))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Skip Rows'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:1;1,2;2,3;3,4;4,5;5,6;6,7;7,8;8,9;9,10;10'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(32996519966781550)
,p_name=>'P32_FILE_NAME_2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(32992226682781507)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(34042917896823108)
,p_name=>'P32_FILE_NAME_HIDDEN'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(32992226682781507)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Name 1'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'       filename',
'FROM temp_blob',
'WHERE id = :P32_FILE_ID'))
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
 p_id=>wwv_flow_imp.id(44824975484081743)
,p_name=>'P32_TEMPLATE_LIST'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(48880790322106789)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT name AS display_value,',
'       id           AS return_value',
'FROM ur_templates',
'WHERE hotel_id = HEXTORAW(:P0_HOTEL_ID)',
'AND (:P32_STATUS_ON = ''ALL'' OR',
'    ACTIVE =:P32_STATUS_ON)',
'--AND (:P32_STATUS_ON = ''ALL'' OR ACTIVE = :P32_STATUS_ON)',
'--WHERE hotel_id = HEXTORAW(:P32_LOCAL_HOTEL_ID)',
'',
''))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P0_HOTEL_ID'
,p_ajax_items_to_submit=>'P32_STATUS_ON'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44834842145081817)
,p_name=>'P32_HOTEL_LIST'
,p_item_sequence=>40
,p_prompt=>'Hotel'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT NVL(hotel_name, ''Name'') AS display_value,',
'       RAWTOHEX(id)            AS return_value',
'  FROM ur_hotels',
'WHERE nvl(ASSOCIATION_END_DATE,sysdate) >= sysdate',
'',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(48880627211106811)
,p_name=>'P32_TEMPLATE_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(47881562974887284)
,p_item_default=>'select type from ur_templates where id = :P32_TEMPLATE_LIST'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Template type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'UR TEMPLATE TYPES'
,p_lov=>'.'||wwv_flow_imp.id(9646161429519087)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(48883380729106838)
,p_name=>'P32_TEMPLATE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(47881562974887284)
,p_prompt=>'Template Name'
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
 p_id=>wwv_flow_imp.id(48889311698106873)
,p_name=>'P32_ALERT_MESSAGE'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(48893595908106915)
,p_name=>'P32_FORCE_REWRITE'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49002728343105811)
,p_name=>'P32_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(47881562974887284)
,p_prompt=>'Status (Active / Inactive)'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49012011690105879)
,p_name=>'P32_DATA_EXISTS'
,p_item_sequence=>100
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59499883893573577)
,p_name=>'P32_LOCAL_HOTEL_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(25697469516364507)
,p_display_as=>'NATIVE_HIDDEN'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(59637420304502470)
,p_name=>'P32_IG_VALIDATION_FLAG'
,p_item_sequence=>110
,p_use_cache_before_default=>'NO'
,p_item_default=>'OK'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(63504039499455895)
,p_name=>'P32_STATUS_ON'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(48880790322106789)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:ACTIVE;Y,INACTIVE;N,BOTH;ALL'
,p_colspan=>4
,p_field_template=>3031561666792084173
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(32289347059901879)
,p_computation_sequence=>10
,p_computation_item=>'P32_LOCAL_HOTEL_ID'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P0_HOTEL_ID',
''))
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32296111308901902)
,p_name=>'Page_load_DA'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32297617326901908)
,p_event_id=>wwv_flow_imp.id(32296111308901902)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47881562974887284)
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32991771221781502)
,p_event_id=>wwv_flow_imp.id(32296111308901902)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(32991612765781501)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32298173454901909)
,p_event_id=>wwv_flow_imp.id(32296111308901902)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_TEMPLATE_LIST,P32_TEMPLATE_NAME,P0_HOTEL_ID'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Select Hotel...'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32297124606901905)
,p_event_id=>wwv_flow_imp.id(32296111308901902)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_TEMPLATE_LIST,P32_TEMPLATE_NAME,P0_HOTEL_ID'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32296639844901904)
,p_event_id=>wwv_flow_imp.id(32296111308901902)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_STATUS_ON'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32303681838901925)
,p_name=>'change template'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_TEMPLATE_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32306625990901934)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'populate collection'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_json_clob CLOB;',
'BEGIN',
'',
'    -- Exit if no template selected',
'    IF :P32_TEMPLATE_LIST IS NULL THEN',
'        RETURN;',
'    END IF;',
'    -- 1. Fetch the JSON CLOB from UR_TEMPLATES',
'    SELECT definition',
'      INTO l_json_clob',
'      FROM ur_templates',
'     WHERE id = :P32_TEMPLATE_LIST;',
'',
'    -- 2. Delete collection if already exists',
'    IF APEX_COLLECTION.COLLECTION_EXISTS(''TEMPLATE_DATA'') THEN',
'        APEX_COLLECTION.DELETE_COLLECTION(''TEMPLATE_DATA'');',
'    END IF;',
'',
'    -- 3. Create collection',
'    APEX_COLLECTION.CREATE_COLLECTION(''TEMPLATE_DATA'');',
'',
'    -- 4. Parse JSON and insert into collection',
'    FOR r IN (',
'        SELECT *',
'          FROM JSON_TABLE(',
'                 l_json_clob,',
'                 ''$[*]'' ',
'                 COLUMNS (',
'                     name       VARCHAR2(4000) PATH ''$.name'',',
'                     data_type  VARCHAR2(4000) PATH ''$.data_type'',',
'                     value      VARCHAR2(4000) PATH ''$.value'',',
'                     qualifier  VARCHAR2(4000) PATH ''$.qualifier'',',
'                     mapping_type  VARCHAR2(4000) PATH ''$.mapping_type'',',
'                    original_name  VARCHAR2(4000) PATH ''$.original_name''',
'                 )',
'             )',
'    ) LOOP',
'        APEX_COLLECTION.ADD_MEMBER(',
'            p_collection_name => ''TEMPLATE_DATA'',',
'            p_c001            => r.name,',
'            p_c002            => r.data_type,',
'            p_c003            => r.qualifier,',
'            p_c004            => r.value,',
'            p_c005            => r.mapping_type,',
'            p_c006            => r.original_name',
'        );',
'    END LOOP;',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32305106377901929)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47880149367887269)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32306138192901932)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47881717758887285)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32992478566781509)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'new_file_id'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(32992226682781507)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32307631629901937)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_TEMPLATE_TYPE'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32304610530901928)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_TEMPLATE_NAME'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32307152668901935)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47881562974887284)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32304125083901926)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_TEMPLATE_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'select name from ur_templates where id = :P32_TEMPLATE_LIST'
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32308156029901938)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_TEMPLATE_TYPE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'select type from ur_templates where id = :P32_TEMPLATE_LIST'
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32305606109901931)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>110
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_STATUS'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'select active from ur_templates where id = :P32_TEMPLATE_LIST'
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32992503350781510)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>120
,p_execute_on_page_init=>'N'
,p_name=>'file_id'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_FILE_ID'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    JSON_VALUE(metadata, ''$.file_id'') AS file_id',
'FROM ur_templates',
'WHERE id = :P32_TEMPLATE_LIST'))
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32992643128781511)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>130
,p_execute_on_page_init=>'N'
,p_name=>'file_name'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_FILE_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    JSON_VALUE(metadata, ''$.sheet_file_name'') AS sheet_file_name',
'FROM ur_templates',
'WHERE id = :P32_TEMPLATE_LIST'))
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32992952046781514)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>140
,p_execute_on_page_init=>'N'
,p_name=>'file_type'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_FILE_TYPE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    JSON_VALUE(metadata, ''$.file_type'') AS file_type',
'FROM ur_templates',
'WHERE id = :P32_TEMPLATE_LIST'))
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32993141801781516)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>150
,p_execute_on_page_init=>'N'
,p_name=>'SHEET_FILE_NAME'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_SHEET_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'       1',
'FROM TABLE(',
'    apex_data_parser.get_xlsx_worksheets(',
'        p_content => (SELECT blob_content',
'                      FROM temp_blob',
'                      WHERE id = (SELECT ',
'    JSON_VALUE(metadata, ''$.file_id'') AS file_id',
'FROM ur_templates',
'WHERE id = :P32_TEMPLATE_LIST))',
'    )',
')',
'ORDER BY sheet_sequence;'))
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32993819682781523)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>160
,p_execute_on_page_init=>'N'
,p_name=>'SKIP_ROWS'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_SKIP_ROWS'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    JSON_VALUE(metadata, ''$.skip_rows'') AS SKIP_ROWS',
'FROM ur_templates',
'WHERE id = :P32_TEMPLATE_LIST'))
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32995414270781539)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>170
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_name           VARCHAR2(100);',
'  v_type           VARCHAR2(50);',
'  v_skip_rows      NUMBER;',
'  v_sheet          VARCHAR2(200);',
'  v_file_type      VARCHAR2(50); ',
'  v_db_object_name VARCHAR2(200);',
'  v_records        NUMBER;',
'  -- Declare a variable to hold the dynamic SQL string',
'  v_sql_query      VARCHAR2(500); ',
'  v_xml_sheet_name VARCHAR2(500); ',
'  v_file_id   VARCHAR2(500); ',
'BEGIN',
'  -- 1. Fetch template details including the dynamic table name',
'  SELECT name, type, db_object_name, ',
'  JSON_VALUE(metadata, ''$.sheet_file_name''),',
' ',
'         JSON_VALUE(metadata, ''$.skip_rows'' RETURNING NUMBER DEFAULT 0 ON ERROR),',
'         JSON_VALUE(metadata, ''$.sheet_display_name'') || '' ('' || JSON_VALUE(metadata, ''$.sheet_file_name'') || '')'' as sheet_name,',
'         CASE JSON_VALUE(metadata, ''$.file_type'' RETURNING NUMBER DEFAULT 0 ON ERROR)',
'             WHEN 1 THEN ''1 - MS Excel (.xlsx, .xls)''',
'             WHEN 2 THEN ''2 - CSV (.csv, .txt)''',
'             WHEN 3 THEN ''3 - JSON''',
'             WHEN 4 THEN ''4 - XML (.xml)''',
'             ELSE ''N/A''',
'         END,',
'         JSON_VALUE(metadata, ''$.file_id'')',
'  INTO v_name, v_type, v_db_object_name, v_xml_sheet_name, v_skip_rows, v_sheet, v_file_type,v_file_id',
'  FROM ur_templates',
' -- WHERE id = :P32_TEMPLATE_LIST;',
'  WHERE id = hextoraw(:P32_TEMPLATE_LIST);',
'',
'  -- 2. Construct the dynamic SQL statement',
'  v_sql_query := ''SELECT COUNT(*) FROM '' || v_db_object_name;',
'',
'  -- 3. Execute the dynamic SQL',
'  -- EXECUTE IMMEDIATE runs the string in v_sql_query and puts the result INTO v_records',
'  EXECUTE IMMEDIATE v_sql_query INTO v_records; ',
'',
'  -- 4. Assign results to APEX page items (or bind variables)',
'--  :P1011_TEMPLATE_NAME := v_name;',
'-- :P1011_TEMPLATE_TYPE := v_type;',
'  :P32_SKIP_ROWS := v_skip_rows;',
'  :P32_SHEET_NAME := v_sheet;',
'  :P32_file_name_2 := v_sheet;',
'  :P32_FILE_TYPE := v_file_type;',
'  :P32_FILE_ID := v_file_id;',
'',
'   -- TEST STATIC VALUE',
'--  :P32_file_name_2 := ''TEST_STATIC_FILENAME.csv'';',
'  commit;',
' -- :p := v_records; -- Assuming you''ll need to display this count',
'END;'))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_03=>'P32_FILE_TYPE,P32_SHEET_NAME,P32_SKIP_ROWS,P32_FILE_ID,P32_FILE_NAME_2'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_server_condition_type=>'ITEM_IS_NOT_NULL'
,p_server_condition_expr1=>'P32_TEMPLATE_LIST'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(34042267789823101)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>180
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_name           VARCHAR2(100);',
'  v_type           VARCHAR2(50);',
'  v_skip_rows      NUMBER;',
'  v_sheet          VARCHAR2(200);',
'  v_file_type      VARCHAR2(50); ',
'  v_db_object_name VARCHAR2(200);',
'  v_records        NUMBER;',
'  -- Declare a variable to hold the dynamic SQL string',
'  v_sql_query      VARCHAR2(500); ',
'  v_xml_sheet_name VARCHAR2(500); ',
'  v_file_id   VARCHAR2(500); ',
'BEGIN',
'  -- 1. Fetch template details including the dynamic table name',
'  SELECT db_object_name, ',
'  JSON_VALUE(metadata, ''$.sheet_file_name'')',
' ',
'         ',
'  INTO  v_db_object_name, v_xml_sheet_name',
'  FROM ur_templates',
' -- WHERE id = :P32_TEMPLATE_LIST;',
'  WHERE id = hextoraw(:P32_TEMPLATE_LIST);',
'',
'  -- 2. Construct the dynamic SQL statement',
'  v_sql_query := ''SELECT COUNT(*) FROM '' || v_db_object_name;',
'',
'  -- 3. Execute the dynamic SQL',
'  -- EXECUTE IMMEDIATE runs the string in v_sql_query and puts the result INTO v_records',
'  EXECUTE IMMEDIATE v_sql_query INTO v_records; ',
'',
'',
'  :P32_file_name_2 := v_sheet;',
' ',
'',
'   -- TEST STATIC VALUE',
'--  :P32_file_name_2 := ''TEST_STATIC_FILENAME.csv'';',
'  commit;',
' -- :p := v_records; -- Assuming you''ll need to display this count',
'END;'))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_03=>'P32_FILE_NAME_2'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(34042385913823102)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>190
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_FILE_NAME_2'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  -- 1. Fetch template details including the dynamic table name',
'  SELECT ',
'  JSON_VALUE(metadata, ''$.sheet_file_name'')',
' ',
'         ',
' ',
'  FROM ur_templates',
' -- WHERE id = :P32_TEMPLATE_LIST;',
'  WHERE id = hextoraw(:P32_TEMPLATE_LIST);',
'',
'  ',
'',
' ',
'',
'',
'',
'',
''))
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(34043053165823109)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>200
,p_execute_on_page_init=>'N'
,p_name=>'filename'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_FILE_NAME_HIDDEN'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'       filename',
'FROM temp_blob',
'WHERE id = :P32_TEMPLATE_LIST;'))
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(34042481263823103)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>210
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_SKIP_ROWS'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  -- 1. Fetch template details including the dynamic table name',
'  SELECT ',
'  JSON_VALUE(metadata, ''$.skip_rows'')',
' ',
'         ',
' ',
'  FROM ur_templates',
' -- WHERE id = :P32_TEMPLATE_LIST;',
'  WHERE id = hextoraw(:P32_TEMPLATE_LIST);',
'',
'  ',
'',
' ',
'',
'',
'',
'',
''))
,p_attribute_07=>'P32_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32996337803781548)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>220
,p_execute_on_page_init=>'N'
,p_name=>'preview'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(32993974728781524)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(34042732404823106)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>230
,p_execute_on_page_init=>'N'
,p_name=>'preview_sr'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_SKIP_ROWS'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(34043124169823110)
,p_event_id=>wwv_flow_imp.id(32303681838901925)
,p_event_result=>'TRUE'
,p_action_sequence=>240
,p_execute_on_page_init=>'N'
,p_name=>'preview_filename'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_FILE_NAME_2'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32308533409901939)
,p_name=>'Create Template button click'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(32281736087901823)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32315576987901959)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'saves_template_type'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(4000);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'BEGIN',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P32_TEMPLATE_LIST || ''","TYPE":"'' || :P32_TEMPLATE_TYPE || ''"}'',',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'--   DBMS_OUTPUT.put_line(''Status: '' || l_status);',
'--   DBMS_OUTPUT.put_line(''Message (metadata JSON): '' || l_message);',
'',
'',
'',
'  :P32_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
' ',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_TYPE,P32_TEMPLATE_LIST'
,p_attribute_03=>'P32_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32315042881901958)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'saves template name'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(4000);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'  v_key        VARCHAR2(4000);',
'  v_exists     NUMBER;',
'   l_temp    VARCHAR2(4000);',
'   v_existing_id  RAW(16);',
'    v_current_id   RAW(16);',
'BEGIN',
'v_key := ur_utils.Clean_TEXT(:P32_TEMPLATE_NAME);',
'',
' /* SELECT COUNT(*) INTO v_exists FROM UR_TEMPLATES WHERE KEY = v_key;',
'',
'  IF v_exists > 0 THEN',
'    ur_utils.add_alert(l_message, ''Template key "'' || v_key || ''" already exists.'', ''warning'', NULL, NULL, l_status);',
'    :P0_ALERT_MESSAGE := l_message;',
'     --:P0_ALERT_MESSAGE := DBMS_LOB.SUBSTR(l_message, 4000, 1);',
'    RETURN;',
'  END IF;*/',
'',
'',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P32_TEMPLATE_LIST || ''","NAME":"'' || :P32_TEMPLATE_NAME || ''"}'',',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'--   DBMS_OUTPUT.put_line(''Status: '' || l_status);',
'--   DBMS_OUTPUT.put_line(''Message (metadata JSON): '' || l_message);',
'',
'',
'',
'  :P32_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'/*l_temp := DBMS_LOB.SUBSTR(l_message, 3900, 1);',
'  :P32_ALERT_MESSAGE := ''[{ "message":"'' || l_temp || ''", "icon":"'' || l_icon || ''", "title":"'' || l_title || ''"}]'';*/',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_NAME,P32_TEMPLATE_LIST'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32313537126901953)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'saves template name'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status       VARCHAR2(4000);',
'  l_message      CLOB;',
'  l_icon         VARCHAR2(50);',
'  l_title        VARCHAR2(100);',
'',
'  v_key          VARCHAR2(4000);',
'  v_current_id   RAW(16);  -- ID of template with THIS NAME',
'  v_edit_id      RAW(16);  -- ID of template we are editing',
'  v_current_name varchar2(100);',
'  v_existing_name varchar2(100);',
'BEGIN',
'',
'v_current_name := ''12_11_3'';',
'v_existing_name := ''12_11_4'';',
'  ',
'  IF v_current_name IS NOT NULL AND v_current_name = v_existing_name THEN',
'    ',
'    :P0_ALERT_MESSAGE :=',
'      ''[{ "message":"Template name '''''' || v_key || '''''' already exists.", "icon":"warning"}]'';',
'',
'    --apex_application.g_unrecoverable_error := TRUE;',
'    RETURN;   -- STOP DA EXECUTION',
'',
'  ELSE',
'    -- *************************************************',
unistr('    -- SAFE \2192 DO THE UPDATE'),
'    -- *************************************************',
'    Graph_SQL.proc_crud_json(',
'      p_mode    => ''U'',',
'      p_table   => ''UR_TEMPLATES'',',
'      p_payload => ''{"ID":"''|| :P32_TEMPLATE_LIST || ''","NAME":"'' || :P32_TEMPLATE_NAME || ''"}'',',
'      p_debug   => ''N'',',
'      p_status  => l_status,',
'      p_message => l_message,',
'      p_icon    => l_icon,',
'      p_title   => l_title',
'    );',
'',
'   :P32_ALERT_MESSAGE :=',
'  ''[{ "message":"'' || DBMS_LOB.SUBSTR(l_message, 32767, 1) ||',
'  ''", "icon":"'' || l_status ||',
'  ''"}]'';',
'',
'',
'  END IF;',
'',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_NAME,P32_TEMPLATE_LIST'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32313099841901952)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'save_Status'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(4000);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'BEGIN',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P32_TEMPLATE_LIST || ''","ACTIVE":"'' || :P32_STATUS || ''"}'',',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'--   DBMS_OUTPUT.put_line(''Status: '' || l_status);',
'--   DBMS_OUTPUT.put_line(''Message (metadata JSON): '' || l_message);',
'',
'',
'',
'  :P32_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST,P32_STATUS'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32314034172901955)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'saves_IG'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(55440109709903475)
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.region("Template_Definition").widget().interactiveGrid("getActions").invoke("save");',
'',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32314545788901956)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47880149367887269)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32312539144901951)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure you want to update the definition?'
,p_attribute_03=>'warning'
,p_attribute_04=>'fa-warning'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(34042658555823105)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_status  VARCHAR2(4000);',
'    v_message CLOB;',
'    v_metadata CLOB; ',
'    v_sheet_display_name VARCHAR2(200);',
'    v_file_id NUMBER;',
'    v_file_type NUMBER;',
'BEGIN',
'',
'    IF :P32_SHEET_NAME IS NOT NULL THEN',
'    SELECT sheet_display_name INTO v_sheet_display_name',
'    FROM TABLE(apex_data_parser.get_xlsx_worksheets(',
'        p_content => (SELECT blob_content FROM temp_blob WHERE ID = :P32_FILE_ID)))',
'    WHERE SHEET_FILE_NAME = :P32_SHEET_NAME AND ROWNUM = 1;',
'  END IF;',
'  ',
'   SELECT ID, JSON_VALUE(profile, ''$."file-type"'' RETURNING NUMBER)',
'  INTO v_file_id, v_file_type FROM temp_blob  WHERE ID = :P32_FILE_ID;',
'  SELECT JSON_OBJECT(',
'    ''skip_rows'' VALUE NVL(:P32_SKIP_ROWS, 0), ''sheet_file_name'' VALUE :P32_FILE_NAME_2,',
'    ''sheet_display_name'' VALUE v_sheet_display_name, ''file_type'' VALUE v_file_type,',
'    ''file_id'' VALUE v_file_id) INTO v_metadata FROM DUAL;',
'',
'',
' UPDATE ur_templates',
'       SET metadata = v_metadata,',
'           updated_on = SYSTIMESTAMP',
'     WHERE id = :P32_TEMPLATE_LIST;',
'',
'    COMMIT;',
'',
'    :P0_ALERT_MESSAGE := v_message;',
'END;',
''))
,p_attribute_02=>'P32_FILE_ID,P32_FILE_TYPE,P32_SHEET_NAME,P32_FILE_NAME_2,P32_SKIP_ROWS'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32310067581901943)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'N'
,p_name=>'13/10_saves new_definition'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_status  VARCHAR2(4000);',
'    v_message CLOB;',
'    v_metadata CLOB; ',
'    v_sheet_display_name VARCHAR2(200);',
'    v_file_id NUMBER;',
'    v_file_type NUMBER;',
'BEGIN',
'',
'',
' /*   IF :P32_SHEET_NAME IS NOT NULL THEN',
'    SELECT sheet_display_name INTO v_sheet_display_name',
'    FROM TABLE(apex_data_parser.get_xlsx_worksheets(',
'        p_content => (SELECT blob_content FROM temp_blob WHERE ID = :P32_FILE_ID)))',
'    WHERE SHEET_FILE_NAME = :P32_SHEET_NAME AND ROWNUM = 1;',
'  END IF;',
'  ',
'   SELECT ID, JSON_VALUE(profile, ''$."file-type"'' RETURNING NUMBER)',
'  INTO v_file_id, v_file_type FROM temp_blob  WHERE ID = :P32_FILE_ID;',
'  SELECT JSON_OBJECT(',
'    ''skip_rows'' VALUE NVL(:P32_SKIP_ROWS, 0), ''sheet_file_name'' VALUE :P32_FILE_NAME_2,',
'    ''sheet_display_name'' VALUE v_sheet_display_name, ''file_type'' VALUE v_file_type,',
'    ''file_id'' VALUE v_file_id) INTO v_metadata FROM DUAL;',
'*/',
'',
' UPDATE ur_templates',
'       SET metadata = v_metadata,',
'           updated_on = SYSTIMESTAMP',
'     WHERE id = :P32_TEMPLATE_LIST;',
'',
'    COMMIT;',
'',
'    update_template_definition(',
'        p_template_id     => :P32_TEMPLATE_LIST,',
'        p_collection_name => ''TEMPLATE_DATA'',',
'        p_template_type   => :P32_TEMPLATE_TYPE,',
'        p_is_update       => ''Y'',  -- Set ''Y'' to recreate DB object',
'        p_status          => v_status,',
'        p_message         => v_message',
'    );',
'',
'    :P0_ALERT_MESSAGE := v_message;',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST,P32_TEMPLATE_TYPE,P32_FILE_ID,P32_FILE_TYPE,P32_SHEET_NAME,P32_SKIP_ROWS'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32310541248901945)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>110
,p_execute_on_page_init=>'N'
,p_name=>'Validation1'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_count NUMBER;',
'BEGIN',
'  SELECT COUNT(*) INTO l_count',
'    /*FROM UR_VK_SEGMENT_QUALIFIER1_T',
'   WHERE  1 = 1;*/',
'FROM ur_templates t',
'          LEFT JOIN ur_hotels h',
'            ON h.id = t.hotel_id',
'         WHERE t.id = :P32_TEMPLATE_LIST;',
'',
'  IF l_count > 0 THEN',
'    :P32_DATA_EXISTS := ''Y'';',
'  ELSE',
'    :P32_DATA_EXISTS := ''N'';',
'  END IF;',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_03=>'P32_DATA_EXISTS'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32311566112901948)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>120
,p_execute_on_page_init=>'N'
,p_name=>'1'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.message.confirm(',
'  "Data already exists. Do you want to truncate it?",',
'  function(okPressed) {',
'    if (okPressed) {',
'      // trigger next dynamic action (custom event) attached to the same button',
'      apex.event.trigger(''#create_template'', ''truncateConfirmed'');',
'    }',
'    // if not okPressed -> do nothing',
'  }',
');',
''))
,p_client_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_client_condition_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$v(''P32_DATA_EXISTS'') === ''Y''',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32311006357901946)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>130
,p_execute_on_page_init=>'N'
,p_name=>'2'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_json        CLOB;',
'  v_ok          varchar2(1);',
'  v_msg         VARCHAR2(4000);',
'  v_key         VARCHAR2(110);',
'  v_exists      NUMBER;',
'  v_alerts      CLOB := NULL;',
'  v_val_status  VARCHAR2(1);',
'  v_def_ok      BOOLEAN;',
'  v_def_msg     VARCHAR2(4000);',
'  v_view_ok     BOOLEAN;',
'  v_view_msg    VARCHAR2(4000);',
'  v_table_name varchar2(4000);',
'  v_key_temp varchar2(100);',
'BEGIN',
'  -- Generate JSON from APEX collection',
'  ur_utils.get_collection_json(''TEMPLATE_DATA'', v_json, v_ok, v_msg);',
'',
'',
'    --ur_utils.add_alert(v_alerts, v_msg, v_ok, NULL, NULL, v_alerts);',
'',
'',
'',
'',
' ',
'insert into debug_log(message) values(v_json);',
'  -- Validate template JSON',
'  ur_utils.VALIDATE_TEMPLATE_DEFINITION(',
'    p_json_clob  => v_json,',
'    p_alert_clob => v_alerts,',
'    p_status     => v_val_status',
'  );',
'-- Check the status returned by the procedure',
'ur_utils.add_alert(v_alerts, v_msg, v_val_status, NULL, NULL, v_alerts);',
' ',
'   -- Hardcoded key and name',
'v_key := ur_utils.Clean_TEXT(:P32_TEMPLATE_LIST);',
'',
'  SELECT COUNT(*) INTO v_exists FROM UR_TEMPLATES WHERE id = v_key;',
'',
'  ',
'',
unistr('  -- \2705 Update existing definition'),
'  UPDATE UR_TEMPLATES',
'     SET DEFINITION = v_json,',
'         UPDATED_ON = SYSTIMESTAMP/*,       -- optional if you have this column',
'         UPDATED_BY = NVL(:APP_USER, USER)*/ -- optional if audit columns exist',
'   WHERE id = v_key;',
'',
'  COMMIT;',
'',
'select KEY into v_key_temp from ur_templates where id = v_key;',
'',
'',
'  /* ur_utils.define_db_object(v_key_temp, v_def_ok, v_def_msg);',
'    ur_utils.add_alert(v_alerts, v_def_msg, ''success'', null, null, v_alerts);',
'',
'    ur_utils.manage_algo_attributes(v_key, ''C'', NULL, v_def_ok, v_def_msg);',
'     ur_utils.add_alert(v_alerts, v_def_msg, ''error'', null, null, v_alerts);',
' */',
' :P0_ALERT_MESSAGE := v_alerts;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    apex_debug.message(''Ex: '' || SQLERRM);',
'    ur_utils.add_alert(v_alerts, SQLERRM, ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RAISE;',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_client_condition_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$v(''P32_DATA_EXISTS'') === ''N''',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32309053447901941)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>140
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name VARCHAR2(4000);',
'    v_count NUMBER;',
'BEGIN',
'    -- Get table name for selected template',
'    SELECT db_object_name',
'      INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P32_TEMPLATE_LIST;',
'',
'    ',
'',
'    -- Count rows in the table',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    -- Pass count back to a page item',
'    :P32_FORCE_REWRITE := CASE WHEN v_count > 0 THEN ''CONFIRM'' ELSE ''OK'' END;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P32_FORCE_REWRITE := ''ERROR'';',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_03=>'P32_FORCE_REWRITE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32309543896901942)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>150
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name VARCHAR2(4000);',
'    v_count      NUMBER := 0;',
'BEGIN',
'    -- Get table name for the selected template',
'    SELECT db_object_name',
'      INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P32_TEMPLATE_LIST;',
'',
'    --:P32_TABLE_NAME := v_table_name;',
'',
'    -- Count rows in the table',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    :P32_TABLE_COUNT := v_count;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P32_TABLE_COUNT := 0;',
'    WHEN OTHERS THEN',
'        :P32_TABLE_COUNT := 0;',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32312023116901949)
,p_event_id=>wwv_flow_imp.id(32308533409901939)
,p_event_result=>'TRUE'
,p_action_sequence=>160
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Convert page item value to number',
'var tableCount = parseInt($v(''P32_TABLE_COUNT''), 10);',
'',
'// Only show confirm if table has rows',
'if (tableCount > 0) {',
'    if (!confirm(''The table already has data. Do you want to continue?'')) {',
unistr('        // User clicked No \2192 stop further True Actions'),
'        return false;',
'    }',
'}',
unistr('// User clicked Yes \2192 next True Actions will run'),
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32293443318901894)
,p_name=>'Alert Message'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32293901566901895)
,p_event_id=>wwv_flow_imp.id(32293443318901894)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P32_ALERT_MESSAGE");  // get the string from hidden page item',
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
 p_id=>wwv_flow_imp.id(32315961348901960)
,p_name=>'show and hide region'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P0_HOTEL_ID'
,p_condition_element=>'P0_HOTEL_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32317862083901966)
,p_event_id=>wwv_flow_imp.id(32315961348901960)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(55440109709903475)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32319346254901971)
,p_event_id=>wwv_flow_imp.id(32315961348901960)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47881562974887284)
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32316480877901962)
,p_event_id=>wwv_flow_imp.id(32315961348901960)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(48880790322106789)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32318330042901968)
,p_event_id=>wwv_flow_imp.id(32315961348901960)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47881562974887284)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32317433612901965)
,p_event_id=>wwv_flow_imp.id(32315961348901960)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_TEMPLATE_LIST'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32318832498901969)
,p_event_id=>wwv_flow_imp.id(32315961348901960)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47881717758887285)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32316958264901963)
,p_event_id=>wwv_flow_imp.id(32315961348901960)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(48880790322106789)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32298595867901910)
,p_name=>'Show and hide region'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_TEMPLATE_LIST'
,p_condition_element=>'P32_TEMPLATE_LIST'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32300576621901916)
,p_event_id=>wwv_flow_imp.id(32298595867901910)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(55440109709903475)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32991851048781503)
,p_event_id=>wwv_flow_imp.id(32298595867901910)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(32991612765781501)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32300047584901914)
,p_event_id=>wwv_flow_imp.id(32298595867901910)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(55440109709903475)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32299594313901913)
,p_event_id=>wwv_flow_imp.id(32298595867901910)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47881717758887285)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32299098953901912)
,p_event_id=>wwv_flow_imp.id(32298595867901910)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47881562974887284)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32294375944901896)
,p_name=>'Change Template name'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_TEMPLATE_NAME'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'focusout'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32294818444901898)
,p_event_id=>wwv_flow_imp.id(32294375944901896)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(10);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'BEGIN',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P32_TEMPLATE_LIST || ''","NAME":"'' || :P32_TEMPLATE_NAME || ''"}'',',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'--   DBMS_OUTPUT.put_line(''Status: '' || l_status);',
'--   DBMS_OUTPUT.put_line(''Message (metadata JSON): '' || l_message);',
'',
'',
'',
'  :P32_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_NAME,P32_TEMPLATE_LIST'
,p_attribute_03=>'P32_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32295290762901899)
,p_name=>'change template type'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_TEMPLATE_TYPE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'focusout'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32295753420901901)
,p_event_id=>wwv_flow_imp.id(32295290762901899)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(10);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'BEGIN',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P32_TEMPLATE_LIST || ''","TYPE":"'' || :P32_TEMPLATE_TYPE || ''"}'',',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'--   DBMS_OUTPUT.put_line(''Status: '' || l_status);',
'--   DBMS_OUTPUT.put_line(''Message (metadata JSON): '' || l_message);',
'',
'',
'',
'  :P32_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST,P32_TEMPLATE_TYPE'
,p_attribute_03=>'P32_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32301836569901919)
,p_name=>'Change status'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_STATUS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32302393214901921)
,p_event_id=>wwv_flow_imp.id(32301836569901919)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(10);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'BEGIN',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P32_TEMPLATE_LIST || ''","ACTIVE":"'' || :P32_STATUS || ''"}'',',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'--   DBMS_OUTPUT.put_line(''Status: '' || l_status);',
'--   DBMS_OUTPUT.put_line(''Message (metadata JSON): '' || l_message);',
'',
'',
'',
'  :P32_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST,P32_STATUS'
,p_attribute_03=>'P32_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32290011377901882)
,p_name=>'delete template data'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(32278434102901807)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32293053483901893)
,p_event_id=>wwv_flow_imp.id(32290011377901882)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'no data found'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DECLARE',
'    v_table_name  VARCHAR2(255);',
'    v_count       NUMBER := 0;',
'    v_alerts      CLOB := NULL;',
'BEGIN',
' ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''No data found in table "'' || v_table_name || ''".'',',
'            p_icon          => ''info'',',
'            p_title         => ''Nothing to Truncate'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'   ',
'',
'    -- Assign to global alert page item',
'    :P0_ALERT_MESSAGE := v_alerts;',
'end;'))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_client_condition_expression=>'$v(''P32_DATA_EXISTS'') === ''N'''
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32291083422901887)
,p_event_id=>wwv_flow_imp.id(32290011377901882)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'confirmation1'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name VARCHAR2(255);',
'    v_count      NUMBER := 0;',
'BEGIN',
'    SELECT db_object_name',
'      INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P32_TEMPLATE_LIST;',
'',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    IF v_count > 0 THEN',
'        :P32_DATA_EXISTS := ''Y'';',
'    ELSE',
'        :P32_DATA_EXISTS := ''N'';',
'    END IF;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P32_DATA_EXISTS := ''N'';',
'    WHEN OTHERS THEN',
'        :P32_DATA_EXISTS := ''N'';',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_03=>'P32_DATA_EXISTS'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32292594182901891)
,p_event_id=>wwv_flow_imp.id(32290011377901882)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.message.confirm(',
'  "Data already exists. Do you want to truncate it?",',
'  function(okPressed) {',
'    if (okPressed) {',
'      // trigger next dynamic action (custom event) attached to the same button',
'      apex.event.trigger(''#Delete_Template_Data'', ''truncateConfirmed'');',
'    }',
'    // if not okPressed -> do nothing',
'  }',
');',
''))
,p_client_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_client_condition_expression=>'$v(''P32_DATA_EXISTS'') === ''Y'''
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32290543749901885)
,p_event_id=>wwv_flow_imp.id(32290011377901882)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'1'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($v(''P32_DATA_EXISTS'') === ''Y'') {',
'    apex.message.confirm(',
'        "Data exists! Are you sure you want to truncate?", // message',
'        function(okPressed) { // callback',
'            if (okPressed) {',
'                // user clicked Yes',
'                apex.page.submit({request: "TRUNCATE"});',
'            } else {',
'                // user clicked No, do nothing',
'            }',
'        }',
'    );',
'} else {',
'    apex.message.alert("No data to truncate.");',
'}',
'',
'/*',
'if ($v(''P32_DATA_EXISTS'') !== ''Y'') {',
'    apex.message.alert("No data to truncate.");',
'    return false;',
'}',
'apex.message.confirm(',
'    "Data exists! Are you sure?",',
'    function(okPressed) {',
'        if (!okPressed) return false;',
'    }',
');',
'*/',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32291501439901888)
,p_event_id=>wwv_flow_imp.id(32290011377901882)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Please note that deletion cannot be undone. Do you want to continue?'
,p_attribute_03=>'warning'
,p_attribute_04=>'fa-warning'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32292077666901890)
,p_event_id=>wwv_flow_imp.id(32290011377901882)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_name=>'truncate table'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name  VARCHAR2(255);',
'    v_count       NUMBER := 0;',
'    v_alerts      CLOB := NULL;',
'BEGIN',
'    -- Fetch table name',
'    SELECT db_object_name',
'      INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P32_TEMPLATE_LIST;',
'',
'    -- Count data before truncating',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    IF v_count > 0 THEN',
unistr('        -- Table has data \2192 truncate it'),
'        EXECUTE IMMEDIATE ''TRUNCATE TABLE '' || v_table_name;',
'',
'        -- Add success message',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''Table "'' || v_table_name || ''" truncated successfully ('' || v_count || '' records deleted).'',',
'            p_icon          => ''success'',',
'            p_title         => ''Truncate Successful'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'    ELSE',
'        -- No data found to truncate',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''No data found in table "'' || v_table_name || ''".'',',
'            p_icon          => ''info'',',
'            p_title         => ''Nothing to Truncate'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'    END IF;',
'',
'    -- Assign to global alert page item',
'    :P0_ALERT_MESSAGE := v_alerts;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''No template found for the selected ID.'',',
'            p_icon          => ''error'',',
'            p_title         => ''Error'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'        :P0_ALERT_MESSAGE := v_alerts;',
'',
'    WHEN OTHERS THEN',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''Error: '' || SQLERRM,',
'            p_icon          => ''error'',',
'            p_title         => ''Unexpected Error'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'        :P0_ALERT_MESSAGE := v_alerts;',
'END;',
''))
,p_attribute_02=>'P32_TEMPLATE_LIST'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32300936074901917)
,p_name=>'Delete database objects'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(32281372509901822)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32301401329901918)
,p_event_id=>wwv_flow_imp.id(32300936074901917)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_status  BOOLEAN;',
'    l_message VARCHAR2(4000);',
'    l_template_key varchar2(240);',
'BEGIN',
'select key from ur',
'    define_db_object_1(',
'        p_template_key => :P32_TEMPLATE_NAME,  -- your template key',
'        p_status       => l_status,',
'        p_message      => l_message,',
'        p_mode         => ''D''             -- D = Delete',
'    );',
'',
'    DBMS_OUTPUT.put_line(''Status: '' || CASE WHEN l_status THEN ''Success'' ELSE ''Failure'' END);',
'    DBMS_OUTPUT.put_line(''Message: '' || l_message);',
'END;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32302700761901922)
,p_name=>'REFRESH THE TEMPLATE LIST'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_STATUS_ON'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32303212116901924)
,p_event_id=>wwv_flow_imp.id(32302700761901922)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P32_TEMPLATE_LIST'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32993380980781518)
,p_name=>'change skip rows'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_SKIP_ROWS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32993403527781519)
,p_event_id=>wwv_flow_imp.id(32993380980781518)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(32993974728781524)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32993517465781520)
,p_name=>'Refresh File profile'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_SKIP_ROWS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32993662505781521)
,p_event_id=>wwv_flow_imp.id(32993517465781520)
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
'        p_file_name       => :P32_file_name_2,',
'        p_skip_rows       => NVL(:P32_SKIP_ROWS, 0),',
'        p_sheet_name      => :P32_SHEET_NAME,',
'        p_collection_name => ''TEMPLATE_DATA'',',
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
,p_attribute_02=>'P32_SHEET_NAME,P32_SKIP_ROWS,P32_FILE_NAME_2'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32993711419781522)
,p_event_id=>wwv_flow_imp.id(32993517465781520)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(32993974728781524)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(34042844274823107)
,p_event_id=>wwv_flow_imp.id(32993517465781520)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(47880149367887269)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(32995876369781543)
,p_name=>'New'
,p_event_sequence=>150
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P32_SHEET_NAME'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(32995985661781544)
,p_event_id=>wwv_flow_imp.id(32995876369781543)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(32993974728781524)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(32289659354901880)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'TRUNCATE_DATA_PROCESS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name VARCHAR2(255);',
'    v_count      NUMBER := 0;',
'    v_alerts     CLOB := NULL;',
'BEGIN',
'    SELECT db_object_name INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P32_TEMPLATE_LIST;',
'',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    IF v_count > 0 THEN',
'        EXECUTE IMMEDIATE ''TRUNCATE TABLE '' || v_table_name;',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''Table "'' || v_table_name || ''" truncated successfully ('' || v_count || '' records deleted).'',',
'            p_icon          => ''success'',',
'            p_title         => ''Truncate Successful'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'    ELSE',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''No data found in table "'' || v_table_name || ''".'',',
'            p_icon          => ''info'',',
'            p_title         => ''Nothing to Truncate'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'    END IF;',
'',
'   ',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'TRUNCATE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'success!'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>32289659354901880
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(32286966379901854)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(47880149367887269)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Template Definition - Save Interactive Grid Data'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_status  VARCHAR2(10);',
'    v_message VARCHAR2(4000);',
'    l_temp CLOB;',
'BEGIN',
'',
'',
'   CASE :APEX$ROW_STATUS',
'    WHEN ''C'' THEN',
'        :SEQ_ID := apex_collection.add_member(',
'            p_collection_name => ''TEMPLATE_DATA'',',
'            p_c001            => :NAME,',
'            p_c002            => :DATA_TYPE,',
'            p_c003            => :QUALIFIER,',
'            p_c004            => :VALUE,',
'            p_c005            => :MAPPING_TYPE,',
'            p_c006            => :ORIGINAL_NAME',
'        );',
'',
'        INSERT INTO debug_log(message)',
'        VALUES(''INSERT - SEQ:''||:SEQ_ID||'' C006:''||NVL(:ORIGINAL_NAME,''NULL''));',
'',
'    WHEN ''U'' THEN',
'        apex_collection.update_member(',
'            p_collection_name => ''TEMPLATE_DATA'',',
'            p_seq             => :SEQ_ID,',
'            p_c001            => :NAME,',
'            p_c002            => :DATA_TYPE,',
'            p_c003            => :QUALIFIER,',
'            p_c004            => :VALUE,',
'            p_c005            => :MAPPING_TYPE,',
'            p_c006            => :ORIGINAL_NAME',
'        );',
'',
'        INSERT INTO debug_log(message)',
'        VALUES(''UPDATE - SEQ:''||:SEQ_ID||'' C006:''||NVL(:ORIGINAL_NAME,''NULL''));',
'',
'    WHEN ''D'' THEN',
'        apex_collection.delete_member(',
'            p_collection_name => ''TEMPLATE_DATA'',',
'            p_seq             => :SEQ_ID',
'        );',
'',
'        INSERT INTO debug_log(message)',
'        VALUES(''DELETE - SEQ:''||:SEQ_ID);',
'END CASE;',
'/** added on 26/11  **/',
' /* validate_profile_row(',
'        p_name          => :name,',
'        p_data_type     => :data_type,',
'        p_mapping_type  => :mapping_type,',
'        p_default_value => :VALUE,',
'        p_collection    => ''TEMPLATE_DATA'',',
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
'    END IF;*/',
'/**** end of 26/11 added new code ***/',
'END;',
''))
,p_attribute_05=>'Y'
,p_attribute_06=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>32286966379901854
);
wwv_flow_imp.component_end;
end;
/
