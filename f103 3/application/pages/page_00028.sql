prompt --application/pages/page_00028
begin
--   Manifest
--     PAGE: 00028
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
 p_id=>28
,p_name=>'Templates_test'
,p_alias=>'TEMPLATES-TEST'
,p_step_title=>'Templates_test'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(35328178190544444)
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
 p_id=>wwv_flow_imp.id(35325232664544414)
,p_plug_name=>'File_Load'
,p_title=>'1. Load Template'
,p_parent_plug_id=>wwv_flow_imp.id(35328178190544444)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(35076002576970124)
,p_plug_name=>'Report'
,p_title=>'Details'
,p_parent_plug_id=>wwv_flow_imp.id(35325232664544414)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_new_grid_column=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- SELECT ID, application_id, name, filename, mime_type, created_on, blob_content',
'-- FROM APEX_APPLICATION_TEMP_FILES',
'-- WHERE NAME = :P28_FILE_LOAD',
'',
'/*SELECT ''File ID'' AS attribute, TO_CHAR(ID) AS value',
'  FROM APEX_APPLICATION_TEMP_FILES',
' WHERE NAME = :P28_FILE_LOAD',
'UNION ALL',
'SELECT ''File Name'', FILENAME FROM APEX_APPLICATION_TEMP_FILES WHERE NAME = :P28_FILE_LOAD',
'UNION ALL',
'SELECT ''Records'', to_char(records-1) FROM temp_blob WHERE NAME = :P28_FILE_LOAD*/',
'SELECT ''ID'' AS attribute, TO_CHAR(f.id) AS value',
'FROM apex_application_temp_files f',
'WHERE f.name = :P28_FILE_LOAD',
'',
'UNION ALL',
'',
'SELECT ''FILENAME'', f.filename',
'FROM apex_application_temp_files f',
'WHERE f.name = :P28_FILE_LOAD',
'',
'UNION ALL',
'',
'SELECT ''Records'',',
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
'WHERE f.name = :P28_FILE_LOAD',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P28_FILE_LOAD'
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
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(35076073259970125)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_enable_mail_download=>'Y'
,p_owner=>'VKANT'
,p_internal_uid=>35076073259970125
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(35326844042544430)
,p_db_column_name=>'ATTRIBUTE'
,p_display_order=>10
,p_column_identifier=>'P'
,p_column_label=>'Attribute'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(35326946365544431)
,p_db_column_name=>'VALUE'
,p_display_order=>20
,p_column_identifier=>'Q'
,p_column_label=>'Value'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(35277102919386278)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'92503'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ATTRIBUTE:VALUE:'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(35327048095544432)
,p_plug_name=>'TEMPLATE_ATTRIBUTES'
,p_title=>'3. Save'
,p_parent_plug_id=>wwv_flow_imp.id(35328178190544444)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(35670812533453644)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_imp.id(35327048095544432)
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
 p_id=>wwv_flow_imp.id(35670695580453643)
,p_plug_name=>'Coll'
,p_title=>'2. Define Mapping'
,p_parent_plug_id=>wwv_flow_imp.id(35328178190544444)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(35596585492428427)
,p_plug_name=>'Collection'
,p_title=>'File Data Profile'
,p_region_name=>'Collection_grid'
,p_parent_plug_id=>wwv_flow_imp.id(35670695580453643)
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc:margin-top-lg'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT seq_id, c001 AS name, c002 AS data_type, c003 as qualifier,',
'c004 as default_value, c005 as mapping_type',
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
 p_id=>wwv_flow_imp.id(25771116498805643)
,p_name=>'DEFAULT_VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEFAULT_VALUE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Default Value'
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
 p_id=>wwv_flow_imp.id(25771213802805644)
,p_name=>'MAPPING_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAPPING_TYPE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Mapping Type'
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
 p_id=>wwv_flow_imp.id(35596855255428429)
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
 p_id=>wwv_flow_imp.id(35596959206428430)
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
 p_id=>wwv_flow_imp.id(35596987955428431)
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
 p_id=>wwv_flow_imp.id(35597115402428432)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(35597199176428433)
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
 p_id=>wwv_flow_imp.id(37840610324393402)
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
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(35596720024428428)
,p_internal_uid=>35596720024428428
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
,p_show_toolbar=>false
,p_toolbar_buttons=>null
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
 p_id=>wwv_flow_imp.id(35633768784516507)
,p_interactive_grid_id=>wwv_flow_imp.id(35596720024428428)
,p_static_id=>'96069'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(35633936755516507)
,p_report_id=>wwv_flow_imp.id(35633768784516507)
,p_view_type=>'GRID'
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(26060333091024584)
,p_view_id=>wwv_flow_imp.id(35633936755516507)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(25771116498805643)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(26061214332024588)
,p_view_id=>wwv_flow_imp.id(35633936755516507)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(25771213802805644)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(35634437565516511)
,p_view_id=>wwv_flow_imp.id(35633936755516507)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(35596855255428429)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(35635303450516515)
,p_view_id=>wwv_flow_imp.id(35633936755516507)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(35596959206428430)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(35636215509516519)
,p_view_id=>wwv_flow_imp.id(35633936755516507)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(35596987955428431)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(35638310464522479)
,p_view_id=>wwv_flow_imp.id(35633936755516507)
,p_display_seq=>0
,p_column_id=>wwv_flow_imp.id(35597115402428432)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(37846310783393667)
,p_view_id=>wwv_flow_imp.id(35633936755516507)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(37840610324393402)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26032529121003027)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(35670812533453644)
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
 p_id=>wwv_flow_imp.id(34812528623031835)
,p_name=>'P28_FILE_LOAD'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(35325232664544414)
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:margin-top-none'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'allow_multiple_files', 'N',
  'display_as', 'DROPZONE_BLOCK',
  'purge_file_at', 'SESSION',
  'storage_type', 'APEX_APPLICATION_TEMP_FILES')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35087425287970186)
,p_name=>'28_P1_FILE_ID'
,p_item_sequence=>50
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SUBSTR(:P28_FILE_LOAD, 1, INSTR(:P28_FILE_LOAD, ''/'') - 1) AS file_id',
'FROM DUAL;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35335208403544462)
,p_name=>'P28_AI_RESPONSE'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35337636594544486)
,p_name=>'P28_HOTEL_LIST'
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
 p_id=>wwv_flow_imp.id(35607983053428488)
,p_name=>'P28_ALERT_TITLE'
,p_item_sequence=>10
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35608099160428489)
,p_name=>'P28_ALERT_MESSAGE'
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
 p_id=>wwv_flow_imp.id(35608155658428490)
,p_name=>'P28_ALERT_ICON'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35672688769453630)
,p_name=>'P28_TEMPLATE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(35670812533453644)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35672938034453632)
,p_name=>'P28_TEMPLATE_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(35670812533453644)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35677377087453657)
,p_name=>'P28_ALERT_TIMER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26047164902003082)
,p_name=>'File Loaded'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P28_FILE_LOAD'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26048148963003085)
,p_event_id=>wwv_flow_imp.id(26047164902003082)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26047661737003083)
,p_event_id=>wwv_flow_imp.id(26047164902003082)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35325232664544414)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26048501838003086)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P28_TEMPLATE_LOV'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26049094551003088)
,p_event_id=>wwv_flow_imp.id(26048501838003086)
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
 p_id=>wwv_flow_imp.id(26049436132003089)
,p_name=>'Page_Load_DA'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26050941184003093)
,p_event_id=>wwv_flow_imp.id(26049436132003089)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35328178190544444)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26051440451003094)
,p_event_id=>wwv_flow_imp.id(26049436132003089)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_TEMPLATE_NAME,P28_TEMPLATE_TYPE'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26049952428003090)
,p_event_id=>wwv_flow_imp.id(26049436132003089)
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
 p_id=>wwv_flow_imp.id(26051995081003096)
,p_event_id=>wwv_flow_imp.id(26049436132003089)
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
 p_id=>wwv_flow_imp.id(26050413038003092)
,p_event_id=>wwv_flow_imp.id(26049436132003089)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35596585492428427)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26042369690003068)
,p_name=>'Change_Hotel'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P28_HOTEL_LIST,P0_HOTEL_ID'
,p_condition_element=>'P0_HOTEL_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26043366852003071)
,p_event_id=>wwv_flow_imp.id(26042369690003068)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35328178190544444)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26042894563003069)
,p_event_id=>wwv_flow_imp.id(26042369690003068)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_FILE_LOAD'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'NULL'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26045842598003078)
,p_event_id=>wwv_flow_imp.id(26042369690003068)
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
 p_id=>wwv_flow_imp.id(26045320041003077)
,p_event_id=>wwv_flow_imp.id(26042369690003068)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_name=>'delete page item of page load'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_FILE_LOAD'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26043853380003072)
,p_event_id=>wwv_flow_imp.id(26042369690003068)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'delete page item of page load'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35076002576970124)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26044320089003074)
,p_event_id=>wwv_flow_imp.id(26042369690003068)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'Y'
,p_name=>'template name clear'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_TEMPLATE_NAME'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26044869651003075)
,p_event_id=>wwv_flow_imp.id(26042369690003068)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'Y'
,p_name=>'template typeclear'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_TEMPLATE_TYPE'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26052359202003097)
,p_name=>'Save Interactive Grid'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26032529121003027)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26052889996003098)
,p_event_id=>wwv_flow_imp.id(26052359202003097)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35596585492428427)
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.region("Collection_grid").widget().interactiveGrid("getActions").invoke("save");',
'',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26053325612003100)
,p_event_id=>wwv_flow_imp.id(26052359202003097)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35596585492428427)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26053804423003101)
,p_event_id=>wwv_flow_imp.id(26052359202003097)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Do you want to define new template?'
,p_attribute_03=>'warning'
,p_attribute_04=>'fa-warning'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26054329844003103)
,p_event_id=>wwv_flow_imp.id(26052359202003097)
,p_event_result=>'TRUE'
,p_action_sequence=>40
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
'  v_key := ur_utils.Clean_TEXT(:P28_TEMPLATE_NAME);',
'  SELECT COUNT(*) INTO v_exists FROM UR_TEMPLATES WHERE KEY = v_key;',
'',
'  IF v_exists > 0 THEN',
'    ur_utils.add_alert(v_alerts, ''Template key "'' || v_key || ''" already exists.'', ''warning'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RETURN;',
'  END IF;',
'',
'  INSERT INTO UR_TEMPLATES (KEY, NAME, Hotel_ID, TYPE, ACTIVE, DEFINITION)',
'  VALUES (v_key, :P28_TEMPLATE_NAME, :P0_HOTEL_ID, :P28_TEMPLATE_TYPE, ''Y'', v_json);',
'  COMMIT;',
'INSERT INTO DEBUG_LOG (MESSAGE) VALUES (V_JSON);',
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
'  IF :P28_TEMPLATE_TYPE = ''RST'' THEN',
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
'  :P28_FILE_LOAD := NULL;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    apex_debug.message(''Ex: '' || SQLERRM);',
'    ur_utils.add_alert(v_alerts, SQLERRM, ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RAISE;',
'END;',
''))
,p_attribute_02=>'P28_TEMPLATE_NAME,P28_TEMPLATE_TYPE,P28_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_03=>'P28_ALERT_TITLE,P28_ALERT_MESSAGE,P28_ALERT_TIMER,P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26040568195003062)
,p_name=>'DEFINE_TEMPLATE_CLICK'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26032529121003027)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26041048689003064)
,p_event_id=>wwv_flow_imp.id(26040568195003062)
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
'  v_key := ur_utils.Clean_TEXT(:P28_TEMPLATE_NAME);',
'  SELECT COUNT(*) INTO v_exists FROM UR_TEMPLATES WHERE KEY = v_key;',
'',
'  IF v_exists > 0 THEN',
'    ur_utils.add_alert(v_alerts, ''Template key "'' || v_key || ''" already exists.'', ''warning'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RETURN;',
'  END IF;',
'',
'  INSERT INTO UR_TEMPLATES (KEY, NAME, Hotel_ID, TYPE, ACTIVE, DEFINITION)',
'  VALUES (v_key, :P28_TEMPLATE_NAME, :P0_HOTEL_ID, :P28_TEMPLATE_TYPE, ''Y'', v_json);',
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
'  IF :P28_TEMPLATE_TYPE = ''RST'' THEN',
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
'  :P28_FILE_LOAD := NULL;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    apex_debug.message(''Ex: '' || SQLERRM);',
'    ur_utils.add_alert(v_alerts, SQLERRM, ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RAISE;',
'END;',
''))
,p_attribute_02=>'P28_TEMPLATE_NAME,P28_TEMPLATE_TYPE,P28_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_03=>'P28_ALERT_TITLE,P28_ALERT_MESSAGE,P28_ALERT_ICON,P28_ALERT_TIMER,P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26041408004003065)
,p_event_id=>wwv_flow_imp.id(26040568195003062)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35596585492428427)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26041958583003067)
,p_event_id=>wwv_flow_imp.id(26040568195003062)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P28_TEMPLATE_NAME,P28_TEMPLATE_TYPE,P1_FILE_ID'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26039675166003059)
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
 p_id=>wwv_flow_imp.id(26040177121003061)
,p_event_id=>wwv_flow_imp.id(26039675166003059)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var title = $v(''P28_ALERT_TITLE'') || ''Notification'';',
'var message = $v(''P28_ALERT_MESSAGE'');',
'var icon  = $v(''P28_ALERT_ICON'') || ''success'';',
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
'  $s(''P28_ALERT_MESSAGE'','''');',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26046269255003079)
,p_name=>'Changed'
,p_event_sequence=>110
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P28_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26046719662003081)
,p_event_id=>wwv_flow_imp.id(26046269255003079)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P28_ALERT_MESSAGE");  // get the string from hidden page item',
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
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26031491030003023)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(35596585492428427)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Collections - Save File Profile'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    case :APEX$ROW_STATUS',
'    when ''C'' then',
'        :SEQ_ID := APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'        p_c001            => :name ,',
'        p_c003            => :qualifier ,',
'        p_c002            => :data_type,',
'        p_c004            => :qualifier,',
'        p_c005            => :mapping_type);',
'        ',
'    when ''U'' then',
'        APEX_COLLECTION.UPDATE_MEMBER (',
'        p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'        p_seq             => :SEQ_ID,',
'        p_c001            => :name ,',
'        p_c003            => :qualifier ,',
'        p_c002            => :data_type,',
'        p_c004            => :default_value,',
'        p_c005            => :mapping_type);',
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
,p_internal_uid=>26031491030003023
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26039225002003058)
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
'              TRIM(:P28_TEMPLATE_NAME),',
'              ''^[^A-Za-z0-9]+|[^A-Za-z0-9]+$'', ''''',
'            ),',
'            ''[^A-Za-z0-9]+'', ''_''',
'          ),',
'          ''_+'', ''_''',
'        ),',
'        1, 110',
'      )',
'    ),',
'    :P28_TEMPLATE_NAME,',
'    :P28_TEMPLATE_TYPE,',
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
'--   :P28_AI_RESPONSE := ''Insert Successful'';',
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
'    -- :P28_AI_RESPONSE := ''Insert Failed: '' || SQLERRM;',
'    apex_debug.message(''Insert Failed: '' || SQLERRM);',
'    -- RETURN ''Failed ''||SQLERRM;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Blah blah blah'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(26032529121003027)
,p_process_success_message=>'Succesfully Done'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>26039225002003058
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26038829081003056)
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
'     WHERE NAME = :P28_FILE_LOAD',
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
'  -- Process each temp_BLOB record',
'  FOR rec IN (',
'    SELECT ID, BLOB_CONTENT, filename, name',
'      FROM temp_BLOB',
'     WHERE profile IS NULL -- only parse if profile not yet loaded',
'  ) LOOP',
'    -- Call APEX_DATA_PARSER to get file profile',
'    SELECT apex_data_parser.discover(',
'             p_content => rec.BLOB_CONTENT,',
'             p_file_name => rec.filename',
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
'    FOR col IN (',
'  SELECT jt.name, jt.data_type',
'    FROM JSON_TABLE(',
'           v_columns,',
'           ''$[*]''',
'           COLUMNS (',
'             name       VARCHAR2(100) PATH ''$.name'',',
'             data_type  VARCHAR2(20) PATH ''$."data-type"''',
'           )',
'         ) jt',
') LOOP',
'  apex_collection.add_member(',
'    p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'    p_c001            => sanitize_column_name(col.name),',
'    p_c002            => col.data_type',
'  );',
'END LOOP;',
'',
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
,p_internal_uid=>26038829081003056
);
wwv_flow_imp.component_end;
end;
/
