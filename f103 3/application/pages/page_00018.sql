prompt --application/pages/page_00018
begin
--   Manifest
--     PAGE: 00018
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
 p_id=>18
,p_name=>'Load Data tt'
,p_alias=>'LOAD-DATA-TT'
,p_step_title=>'Load Data tt'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'https://cdn.jsdelivr.net/npm/sweetalert2@11'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// function showAlert(title, message, icon=''success'', timer=2500) {',
'//   const showConfirmation = (icon === ''error'' || icon === ''warning'');',
'//   Swal.fire({',
'//     position: ''top-end'',',
'//     icon: icon,',
'//     title: title,',
'//     text: message,',
'//     showConfirmButton: showConfirmation,',
'//     toast: true,',
'//     timer: showConfirmation ? undefined : timer',
'//   });',
'// }',
'',
'',
'// function showAlert(title, message, icon = ''success'', timer = 2500) {',
'//   const showConfirmation = (icon === ''error'' || icon === ''warning'');',
'',
'//   Swal.fire({',
'//     toast: true,',
'//     position: ''top-end'',',
'//     icon: icon,',
'//     title: title,',
'//     text: message,',
'//     showConfirmButton: showConfirmation,',
'//     timer: showConfirmation ? undefined : timer,',
'//     timerProgressBar: !showConfirmation,',
'//     didOpen: (toast) => {',
'//       if (!showConfirmation) {',
'//         toast.onmouseenter = Swal.stopTimer;',
'//         toast.onmouseleave = Swal.resumeTimer;',
'//       }',
'//     }',
'//   });',
'// }',
'',
'function showAlert(title, message, icon = ''success'', timer = 2500) {',
'',
'const showConfirmation = (icon === ''error'' || icon === ''warning'');',
'',
'const Toast = Swal.mixin({',
'  toast: true,',
'  position: "top-end",',
'  showConfirmButton: showConfirmation,',
'  timer: 3000,',
'  timerProgressBar: true,',
'  didOpen: (toast) => {',
'    toast.onmouseenter = Swal.stopTimer;',
'    toast.onmouseleave = Swal.resumeTimer;',
'  }',
'});',
'Toast.fire({',
'  icon: icon,',
'  title: message',
'});',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49667682828004511)
,p_plug_name=>'Main Region'
,p_region_name=>'mainRegion'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>120
,p_location=>null
,p_plug_customized=>'1'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40138367831294107)
,p_plug_name=>'Data Mapping'
,p_parent_plug_id=>wwv_flow_imp.id(49667682828004511)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(40069164430268940)
,p_plug_name=>'Data Mapping Collection'
,p_region_name=>'MY_IG_MAPPING'
,p_parent_plug_id=>wwv_flow_imp.id(40138367831294107)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*select seq_id, c001 AS Source, c003 AS Mapping_Type, c002 AS Target,',
'c004 AS default_value, :P18_TEMPLATE_LOV AS LOV',
'from APEX_COLLECTIONS',
'where 1 = 1',
'and collection_name = ''UR_DATA_MAPPING_COLLECTION''',
'and :P18_TEMPLATE_LOV is not null*/',
'SELECT ',
'    seq_id,',
'    c003 AS mapping_type,',
'    c001 AS source,',
'    c002 AS target,',
'    c004 AS default_value,',
'    :P18_TEMPLATE_LOV AS lov',
'FROM apex_collections',
'WHERE collection_name = ''UR_DATA_MAPPING_COLLECTION''',
'  AND :P18_TEMPLATE_LOV IS NOT NULL',
'--ORDER BY seq_id;',
'',
'',
'',
'',
'',
''))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P1001_TEMPLATE_KEY,P18_TEMPLATE_LOV'
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
 p_id=>wwv_flow_imp.id(40524957035045906)
,p_name=>'MAPPING_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAPPING_TYPE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Mapping Type'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>false
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(40543639483619292)
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
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(40544699657619303)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
,p_use_as_row_header=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(40544834556619304)
,p_name=>'APEX$ROW_SELECTOR'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob
,p_use_as_row_header=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(40546060930619316)
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
 p_id=>wwv_flow_imp.id(40546113794619317)
,p_name=>'LOV'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOV'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Lov'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>2000
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
 p_id=>wwv_flow_imp.id(43044265990023436)
,p_name=>'SOURCE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SOURCE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Source'
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
 p_id=>wwv_flow_imp.id(43044358696023437)
,p_name=>'TARGET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TARGET'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Target'
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
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(40543528912619291)
,p_internal_uid=>40543528912619291
,p_is_editable=>true
,p_edit_operations=>'u'
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
 p_id=>wwv_flow_imp.id(40550082871659803)
,p_interactive_grid_id=>wwv_flow_imp.id(40543528912619291)
,p_static_id=>'100532'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(40550299544659803)
,p_report_id=>wwv_flow_imp.id(40550082871659803)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40550676947659806)
,p_view_id=>wwv_flow_imp.id(40550299544659803)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(40543639483619292)
,p_is_visible=>true
,p_is_frozen=>false
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40556988860692150)
,p_view_id=>wwv_flow_imp.id(40550299544659803)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(40544699657619303)
,p_is_visible=>true
,p_is_frozen=>true
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40618094652771856)
,p_view_id=>wwv_flow_imp.id(40550299544659803)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(40524957035045906)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40775166582239185)
,p_view_id=>wwv_flow_imp.id(40550299544659803)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(40546060930619316)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(40776065052239191)
,p_view_id=>wwv_flow_imp.id(40550299544659803)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(40546113794619317)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(44119655627586478)
,p_view_id=>wwv_flow_imp.id(40550299544659803)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(43044265990023436)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(44120524223586482)
,p_view_id=>wwv_flow_imp.id(40550299544659803)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(43044358696023437)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49664737302004481)
,p_plug_name=>'File_Load'
,p_parent_plug_id=>wwv_flow_imp.id(49667682828004511)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
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
 p_id=>wwv_flow_imp.id(49415507214430191)
,p_plug_name=>'Report'
,p_parent_plug_id=>wwv_flow_imp.id(49664737302004481)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- SELECT ID, application_id, name, filename, mime_type, created_on, blob_content',
'-- FROM APEX_APPLICATION_TEMP_FILES',
'-- WHERE NAME = :P18_FILE_LOAD',
'',
'SELECT ''ID'' AS attribute, TO_CHAR(ID) AS value',
'  FROM APEX_APPLICATION_TEMP_FILES',
' WHERE NAME = :P18_FILE_LOAD',
'UNION ALL',
'SELECT ''FILENAME'', FILENAME FROM APEX_APPLICATION_TEMP_FILES WHERE NAME = :P18_FILE_LOAD',
'UNION ALL',
'SELECT ''Records'', to_char(records-1) FROM temp_blob WHERE NAME = :P18_FILE_LOAD'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P18_FILE_LOAD'
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
 p_id=>wwv_flow_imp.id(49415577897430192)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_enable_mail_download=>'Y'
,p_owner=>'VKANT'
,p_internal_uid=>49415577897430192
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(49666348680004497)
,p_db_column_name=>'ATTRIBUTE'
,p_display_order=>10
,p_column_identifier=>'P'
,p_column_label=>'Attribute'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(49666451003004498)
,p_db_column_name=>'VALUE'
,p_display_order=>20
,p_column_identifier=>'Q'
,p_column_label=>'Value'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(49616607556846345)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'92503'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ATTRIBUTE:VALUE:'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49666552733004499)
,p_plug_name=>'TEMPLATE_ATTRIBUTES'
,p_title=>'Template Attributes'
,p_parent_plug_id=>wwv_flow_imp.id(49667682828004511)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>100
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49936090129888494)
,p_plug_name=>'Collection'
,p_title=>'File Data Profile'
,p_parent_plug_id=>wwv_flow_imp.id(49667682828004511)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>90
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT seq_id, c001 AS name, c002 AS data_type',
'  FROM apex_collections',
' WHERE collection_name = :P18_COLLECTION_NAME'))
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
 p_id=>wwv_flow_imp.id(49936359892888496)
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
 p_id=>wwv_flow_imp.id(49936463843888497)
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
 p_id=>wwv_flow_imp.id(49936492592888498)
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
 p_id=>wwv_flow_imp.id(49936620039888499)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
,p_use_as_row_header=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(49936703813888500)
,p_name=>'APEX$ROW_SELECTOR'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob
,p_use_as_row_header=>false
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(49936224661888495)
,p_internal_uid=>49936224661888495
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
 p_id=>wwv_flow_imp.id(49973273421976574)
,p_interactive_grid_id=>wwv_flow_imp.id(49936224661888495)
,p_static_id=>'96069'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(49973441392976574)
,p_report_id=>wwv_flow_imp.id(49973273421976574)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(49973942202976578)
,p_view_id=>wwv_flow_imp.id(49973441392976574)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(49936359892888496)
,p_is_visible=>true
,p_is_frozen=>false
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(49974808087976582)
,p_view_id=>wwv_flow_imp.id(49973441392976574)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(49936463843888497)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(49975720146976586)
,p_view_id=>wwv_flow_imp.id(49973441392976574)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(49936492592888498)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(49977815101982546)
,p_view_id=>wwv_flow_imp.id(49973441392976574)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(49936620039888499)
,p_is_visible=>true
,p_is_frozen=>true
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15257931256427209)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(40138367831294107)
,p_button_name=>'Data_Load'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Data Load'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15264392160427236)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(49664737302004481)
,p_button_name=>'FETCH_TEMPLATE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Fetch Template'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15267264499427250)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_imp.id(49666552733004499)
,p_button_name=>'DEFINE_TEMPLATE'
,p_button_static_id=>'defineTemplate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Define Template'
,p_warn_on_unsaved_changes=>null
,p_confirm_message=>'Are you sure you want to define a new Template?'
,p_confirm_style=>'warning'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40139823856294118)
,p_name=>'P18_TEMPLATE_LOV'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(40138367831294107)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT Template_Name || '' - '' || Score || ''%'' AS display_value,',
'       Template_id AS return_value',
'  FROM JSON_TABLE(',
'    :P18_TEMPLATE_JSON,',
'    ''$[*]''',
'    COLUMNS (',
'      Template_id   VARCHAR2(100) PATH ''$.Template_id'',',
'      Template_Name VARCHAR2(4000) PATH ''$.Template_Name'',',
'      Score         NUMBER PATH ''$.Score''',
'    )',
'  )',
'WHERE Template_id IS NOT NULL',
'ORDER BY Score DESC, Template_Name'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P18_HOTEL_LIST'
,p_ajax_items_to_submit=>'P18_HOTEL_LIST'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40146420637294146)
,p_name=>'P18_AI_REPONSE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(49664737302004481)
,p_use_cache_before_default=>'NO'
,p_prompt=>'AI Response'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT JSON_ARRAYAGG(jsobj) AS final_json',
'FROM (',
'  -- Target type entries from UR_TEMPLATES',
'  SELECT JSON_OBJECT(',
'           ''Type'' VALUE ''Target'',',
'           ''template_id'' VALUE ID,',
'           ''definition'' VALUE TO_CLOB(DEFINITION) FORMAT JSON',
'         ) AS jsobj',
'  FROM UR_TEMPLATES',
'  WHERE hotel_id = ''3B9B828094379CA8E063DD59000AC846''',
'  and ROWNUM <5',
'',
'  UNION ALL',
'',
'  -- Source type entry from temp_blob',
'  SELECT JSON_OBJECT(',
'           ''Type'' VALUE ''Source'',',
'           ''file_id'' VALUE TO_CHAR(id),',
'           ''definition'' VALUE TO_CLOB(columns) FORMAT JSON',
'         ) AS jsobj',
'  FROM temp_blob',
'  WHERE id = 10367474368641719',
');'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'Y',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40149482454294161)
,p_name=>'P18_HOTEL_ID'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(49666552733004499)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Hotel ID'
,p_source=>'P18_HOTEL_LIST'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40149649466294163)
,p_name=>'P18_FILE_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(49666552733004499)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Hotel ID'
,p_source=>'P18_P1_FILE_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40153636778294180)
,p_name=>'P18_COLLECTION_NAME'
,p_item_sequence=>70
,p_source=>'UR_DATA_MAPPING'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40527513529045928)
,p_name=>'P18_RESULT_MSG'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(40138367831294107)
,p_prompt=>'New'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_display_when_type=>'NEVER'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40546431685619316)
,p_name=>'18_P1001_TEMPLATE_KEY'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(40138367831294107)
,p_use_cache_before_default=>'NO'
,p_prompt=>'P1001_TEMPLATE_KEY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40560869547619384)
,p_name=>'P18_MAPPING_COLLECTION_NAME'
,p_item_sequence=>80
,p_source=>'''UR_DATA_MAPPING_COLLECTION'''
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40561039602619386)
,p_name=>'P18_TEMPLATE_ID'
,p_item_sequence=>60
,p_use_cache_before_default=>'NO'
,p_source=>':P18_TEMPLATE_LOV'
,p_source_type=>'EXPRESSION'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(40563221021619408)
,p_name=>'P18_TEMPLATE_JSON'
,p_item_sequence=>100
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49156041225491931)
,p_name=>'P18_FILE_LOAD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(49664737302004481)
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'allow_multiple_files', 'N',
  'display_as', 'DROPZONE_BLOCK',
  'purge_file_at', 'SESSION',
  'storage_type', 'APEX_APPLICATION_TEMP_FILES')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49441673996430335)
,p_name=>'P18_P1_FILE_ID'
,p_item_sequence=>50
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SUBSTR(:P18_FILE_LOAD, 1, INSTR(:P18_FILE_LOAD, ''/'') - 1) AS file_id',
'FROM DUAL;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49689457112004611)
,p_name=>'P18_AI_INPUT'
,p_item_sequence=>90
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT JSON_ARRAYAGG(jsobj) AS final_json',
'FROM (',
'  -- Target type entries from UR_TEMPLATES',
'  SELECT JSON_OBJECT(',
'           ''Type'' VALUE ''Target'',',
'           ''template_id'' VALUE ID,',
'           ''definition'' VALUE TO_CLOB(DEFINITION) FORMAT JSON',
'         ) AS jsobj',
'  FROM UR_TEMPLATES',
'  WHERE hotel_id = ''3B9B828094379CA8E063DD59000AC846''',
'  and ROWNUM <5',
'',
'  UNION ALL',
'',
'  -- Source type entry from temp_blob',
'  SELECT JSON_OBJECT(',
'           ''Type'' VALUE ''Source'',',
'           ''file_id'' VALUE TO_CHAR(id),',
'           ''definition'' VALUE TO_CLOB(columns) FORMAT JSON',
'         ) AS jsobj',
'  FROM temp_blob',
'  WHERE id = 10367474368641719',
');'))
,p_item_default_type=>'SQL_QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49691885303004635)
,p_name=>'P18_HOTEL_LIST'
,p_is_required=>true
,p_item_sequence=>110
,p_prompt=>'Hotel'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'  nvl(Hotel_NAME,''Name'') as Name,',
'ID as ID',
'FROM',
'UR_HOTELS',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49962231761888637)
,p_name=>'P18_ALERT_TITLE'
,p_item_sequence=>10
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49962347868888638)
,p_name=>'P18_ALERT_MESSAGE'
,p_item_sequence=>20
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(49962404366888639)
,p_name=>'P18_ALERT_ICON'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50019069410913740)
,p_name=>'P18_TEMPLATE_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(49666552733004499)
,p_prompt=>'Template Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50019318675913742)
,p_name=>'P18_TEMPLATE_TYPE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(49666552733004499)
,p_prompt=>'Template Type'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(50031625795913806)
,p_name=>'P18_ALERT_TIMER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15277583904427297)
,p_name=>'File Loaded'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P18_FILE_LOAD'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15278081589427299)
,p_event_id=>wwv_flow_imp.id(15277583904427297)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15278577767427300)
,p_event_id=>wwv_flow_imp.id(15277583904427297)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF APEX_COLLECTION.COLLECTION_EXISTS(:P18_MAPPING_COLLECTION_NAME) THEN',
'        APEX_COLLECTION.DELETE_COLLECTION(:P18_MAPPING_COLLECTION_NAME);',
'    END IF;',
'END;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15279029415427302)
,p_event_id=>wwv_flow_imp.id(15277583904427297)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49664737302004481)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15279543110427303)
,p_event_id=>wwv_flow_imp.id(15277583904427297)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_TEMPLATE_JSON'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15280008926427304)
,p_event_id=>wwv_flow_imp.id(15277583904427297)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_name=>'Fetch Templates'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_output CLOB;',
'  v_status VARCHAR2(1);',
'  v_msg    VARCHAR2(4000);',
'BEGIN',
'  -- Call your procedure with desired inputs:',
'  UR_UTILS.FETCH_TEMPLATES(',
'    p_file_id    => 10367474368641719,',
'    p_hotel_id   => ''3B9B828094379CA8E063DD59000AC846'',',
'    p_min_score  => 90,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P18_TEMPLATE_JSON := v_output;',
'  ELSE',
'    :P18_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_02=>'P18_P1_FILE_ID,P18_HOTEL_LIST'
,p_attribute_03=>'P18_TEMPLATE_JSON'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15280569747427306)
,p_event_id=>wwv_flow_imp.id(15277583904427297)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_TEMPLATE_JSON'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15281013478427307)
,p_event_id=>wwv_flow_imp.id(15277583904427297)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'showAlert(',
'    $v("P18_ALERT_TITLE"),',
'    $v("P18_P1_FILE_ID"),',
'    $v("P18_ALERT_ICON"),',
'    $v("P18_ALERT_TIMER")',
');'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15281592002427309)
,p_event_id=>wwv_flow_imp.id(15277583904427297)
,p_event_result=>'TRUE'
,p_action_sequence=>110
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_GENERATE_TEXT_AI'
,p_attribute_01=>'ITEM'
,p_attribute_02=>'P18_AI_INPUT'
,p_attribute_04=>'ITEM'
,p_attribute_05=>'P18_AI_REPONSE'
,p_attribute_07=>'Y'
,p_wait_for_result=>'Y'
,p_ai_remote_server_id=>wwv_flow_imp.id(7949156321027603)
,p_ai_system_prompt=>wwv_flow_string.join(wwv_flow_t_varchar2(
'# System Prompt: AI Agent for JSON Template Matching',
'',
'You are an expert software engineer specializing in Oracle APEX, JavaScript, and JSON data structures.',
'',
'## Input Description',
'',
'- You will receive a single JSON array containing multiple JSON objects with the following types:',
'  - **Source JSON object**: Identified with `"Type": "Source"`, contains:',
'    - `file_id` (string)',
'    - `definition` (array of fields), each field has:',
'      - `name` (string)',
'      - `data_type` or `data-type` (string, case insensitive)',
'      - Other irrelevant keys (ignore)',
'  - **Target JSON objects**: Each identified with `"Type": "Target"`, contains:',
'    - `template_id` (string)',
'    - `definition` (array of fields), each field has:',
'      - `name` (string)',
'      - `data_type` (string, case insensitive)',
'',
'- The order or case of field names and data types may vary.',
'- Field comparison is **case-insensitive**.',
'- The target templates array may contain multiple templates.',
'',
'## Task',
'',
'1. Extract the **Source** fields and their data types.',
'2. For each **Target** template:',
'   - Extract its fields and data types.',
'   - Compare it against the **Source** fields **by name and data type**, ignoring field order and case.',
'   - Calculate a **matching score %** rounded to the nearest integer (0-100) defined as follows:',
'',
'### Scoring Method (Important!)',
'',
'- Let:',
'  - `S` = number of fields in Source',
'  - `T` = number of fields in Target',
'  - `M` = number of matching fields (field name and data type equal, ignoring case)',
'- Compute **Score** as:',
'',
'Score = (2 * M) / (S + T) * 100',
'',
'',
'- This score reflects the harmonic mean of matching fields relative to both Source and Target field counts.',
'',
'3. Output the results as an **array of JSON objects**, each with:',
' - `"Template_id"`: the template_id string from the Target object',
' - `"Score"`: the integer matching score percentage',
' ',
'4. Sort the array in **descending order** by the Score.',
'',
'5. If **no Target templates have a match (Score > 0)**, return a single-item array containing an empty JSON object: `[{}]`.',
'',
'## Output Format (Strictly only this JSON, no extra text or explanation)',
'',
'```json',
'[',
'{',
'  "Template_id": "<template_id_1>",',
'  "Score": <score_int_1>',
'},',
'{',
'  "Template_id": "<template_id_2>",',
'  "Score": <score_int_2>',
'}',
']',
'',
'or if no matches:',
'',
'[{}]'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15281977914427310)
,p_name=>'Page_Load_DA'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15282463598427311)
,p_event_id=>wwv_flow_imp.id(15281977914427310)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_output CLOB;',
'  v_status VARCHAR2(1);',
'  v_msg    VARCHAR2(4000);',
'BEGIN',
'  -- Call your procedure with desired inputs:',
'  UR_UTILS.FETCH_TEMPLATES(',
'    p_file_id    => :P18_P1_FILE_ID,',
'    p_hotel_id   => ''3B9B828094379CA8E063DD59000AC846'',',
'    p_min_score  => 90,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P18_TEMPLATE_JSON := v_output;',
'  ELSE',
'    :P18_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15282822841427312)
,p_name=>'Change_Hotel'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P18_HOTEL_LIST'
,p_condition_element=>'P18_HOTEL_LIST'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15283300151427314)
,p_event_id=>wwv_flow_imp.id(15282822841427312)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49667682828004511)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15283866066427316)
,p_event_id=>wwv_flow_imp.id(15282822841427312)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49667682828004511)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15284331260427317)
,p_event_id=>wwv_flow_imp.id(15282822841427312)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'  IF apex_collection.collection_exists(:P18_MAPPING_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(''UR_DATA_MAPPING_COLLECTION'');',
'  END IF;',
'END;  '))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15284881452427318)
,p_event_id=>wwv_flow_imp.id(15282822841427312)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.region("MY_IG_MAPPING").widget().interactiveGrid("getViews").grid.model.clearChanges();',
'apex.region("MY_IG_MAPPING").widget().interactiveGrid("getActions").set("edit", false);'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15285377046427320)
,p_event_id=>wwv_flow_imp.id(15282822841427312)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_TEMPLATE_LOV'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15285808847427321)
,p_event_id=>wwv_flow_imp.id(15282822841427312)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(40069164430268940)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15286347487427323)
,p_event_id=>wwv_flow_imp.id(15282822841427312)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49664737302004481)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15286701909427324)
,p_name=>'DEFINE_TEMPLATE_CLICK'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15267264499427250)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15287228808427326)
,p_event_id=>wwv_flow_imp.id(15286701909427324)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_json_clob      CLOB;',
'  l_status         BOOLEAN;',
'  l_message        VARCHAR2(4000);',
'  l_template_key   VARCHAR2(110);',
'  l_define_status  BOOLEAN;',
'  l_define_message VARCHAR2(4000);',
'  l_exists         NUMBER;',
'BEGIN',
'  -- Get JSON from collection',
'  ur_utils.get_collection_json(',
'    p_collection_name => :P18_COLLECTION_NAME,',
'    p_json_clob       => l_json_clob,',
'    p_status          => l_status,',
'    p_message         => l_message',
'  );',
'',
'  IF NOT l_status THEN',
'    apex_debug.message(''Failed to retrieve JSON definition: '' || l_message);',
'',
'    :P18_ALERT_TITLE   := ''Error'';',
'    :P18_ALERT_MESSAGE := l_message;',
'    :P18_ALERT_ICON    := ''error'';',
'',
'    raise_application_error(-20001, ''Failed to retrieve JSON definition: '' || l_message);',
'  END IF;',
'',
'  l_template_key := ur_utils.Clean_TEXT(:P18_TEMPLATE_NAME);',
'',
'  -- Check if template key exists',
'  SELECT COUNT(*)',
'    INTO l_exists',
'    FROM UR_TEMPLATES',
'   WHERE KEY = l_template_key;',
'',
'  IF l_exists > 0 THEN',
'    :P18_ALERT_TITLE   := ''Warning'';',
'    :P18_ALERT_MESSAGE := ''Template key "'' || l_template_key || ''" already exists.'';',
'    :P18_ALERT_ICON    := ''warning'';',
'    RETURN;  -- Exit gracefully, no exception raised',
'  END IF;',
'',
'  -- Insert new template as key is unique',
'  INSERT INTO UR_TEMPLATES (',
'    KEY,',
'    NAME,',
'    Hotel_ID,',
'    TYPE,',
'    ACTIVE,',
'    DEFINITION,',
'    CREATED_BY,',
'    CREATED_ON,',
'    UPDATED_BY,',
'    UPDATED_ON',
'  ) VALUES (',
'    l_template_key,',
'    :P18_TEMPLATE_NAME,',
'    :P18_HOTEL_LIST,',
'    :P18_TEMPLATE_TYPE,',
'    ''Y'',',
'    l_json_clob,',
'    HEXTORAW(''3AB2E656C7307FD1E063DD59000A5850''),',
'    SYSTIMESTAMP,',
'    HEXTORAW(''3AB2E656C7307FD1E063DD59000A5850''),',
'    SYSTIMESTAMP',
'  );',
'',
'  COMMIT;',
'',
'  -- Continue with define_db_object as before',
'  ur_utils.define_db_object(',
'    p_template_key => l_template_key,',
'    p_status       => l_define_status,',
'    p_message      => l_define_message',
'  );',
'',
'  IF l_define_status THEN',
'',
'    IF apex_collection.collection_exists(:P18_COLLECTION_NAME) THEN',
'        apex_collection.delete_collection(:P18_COLLECTION_NAME);',
'    END IF;',
'    ',
'    :P18_ALERT_ICON    := ''success'';',
'    :P18_ALERT_MESSAGE := ''Template Created Successfully - '' || l_template_key;',
'    :P18_ALERT_TITLE   := ''Success!'';',
'  ELSE',
'    :P18_ALERT_TITLE   := ''Error'';',
'    :P18_ALERT_MESSAGE := l_define_message;',
'    :P18_ALERT_ICON    := ''error'';',
'',
'    raise_application_error(-20002, ''Template creation failed: '' || l_define_message);',
'  END IF;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    apex_debug.message(''Exception: '' || SQLERRM);',
'',
'    :P18_ALERT_TITLE   := ''Error'';',
'    :P18_ALERT_MESSAGE := SQLERRM;',
'    :P18_ALERT_ICON    := ''error'';',
'',
'    raise;',
'END;'))
,p_attribute_02=>'P18_TEMPLATE_NAME,P18_TEMPLATE_TYPE'
,p_attribute_03=>'P18_ALERT_TITLE,P18_ALERT_MESSAGE,P18_ALERT_ICON,P18_ALERT_TIMER'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15287728757427327)
,p_event_id=>wwv_flow_imp.id(15286701909427324)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// console.log(',
'//     $v("P18_ALERT_TITLE"),',
'//     $v("P18_ALERT_MESSAGE"),',
'//     $v("P18_ALERT_ICON"),',
'//     $v("P18_ALERT_TIMER")',
'// );',
'',
'showAlert(',
'    $v("P18_ALERT_TITLE"),',
'    $v("P18_ALERT_MESSAGE"),',
'    $v("P18_ALERT_ICON"),',
'    $v("P18_ALERT_TIMER")',
');',
'',
'',
'// showAlert(',
'//     "Success!",',
'//     "P18_ALERT_MESSAGE",',
'//     "success"',
'// );'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15288186530427328)
,p_name=>'Template Selected'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P18_TEMPLATE_LOV'
,p_condition_element=>'P18_TEMPLATE_LOV'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15288618717427330)
,p_event_id=>wwv_flow_imp.id(15288186530427328)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1001_TEMPLATE_KEY,P18_TEMPLATE_ID'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>':P18_TEMPLATE_LOV'
,p_attribute_07=>'P18_TEMPLATE_LOV,P18_TEMPLATE_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15289198555427331)
,p_event_id=>wwv_flow_imp.id(15288186530427328)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(40069164430268940)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15289618415427333)
,p_event_id=>wwv_flow_imp.id(15288186530427328)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_status  VARCHAR2(1);',
'    v_message VARCHAR2(4000);',
'BEGIN',
'    UR_UTILS.LOAD_DATA_MAPPING_COLLECTION(',
'        p_file_id         => :P18_P1_FILE_ID,',
'        p_template_id    => :P18_TEMPLATE_LOV,',
'        p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'        p_status          => v_status,',
'        p_message         => v_message',
'    );',
'',
'    DBMS_OUTPUT.PUT_LINE(''Status : '' || v_status);',
'    DBMS_OUTPUT.PUT_LINE(''Message: '' || v_message);',
'END;'))
,p_attribute_02=>'P18_TEMPLATE_LOV,P18_P1_FILE_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15290115033427334)
,p_event_id=>wwv_flow_imp.id(15288186530427328)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(40069164430268940)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15290601717427335)
,p_event_id=>wwv_flow_imp.id(15288186530427328)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(40069164430268940)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15291074363427336)
,p_name=>'Load Data on Button Click'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15257931256427209)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15291546066427338)
,p_event_id=>wwv_flow_imp.id(15291074363427336)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Load Data in Selected Table'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_status   BOOLEAN;',
'    l_message  VARCHAR2(4000);',
'BEGIN',
'    ur_utils_test.Load_Data (',
'        p_file_id         => :P18_P1_FILE_ID,        -- NUMBER',
'        p_template_key    => :P18_TEMPLATE_LOV,      -- VARCHAR2',
'        p_hotel_id        => :P18_HOTEL_LIST, -- RAW(16), convert varchar2 hex to raw',
'        p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'        p_status          => l_status,',
'        p_message         => l_message',
'    );',
'',
'    COMMIT;',
'',
'    /*IF l_status THEN',
'        :P18_ALERT_ICON    := ''success'';',
'        :P18_ALERT_TITLE   := ''Success!'';',
'        :P18_ALERT_MESSAGE := l_message;',
'    ELSE',
'        :P18_ALERT_ICON    := ''error'';',
'        :P18_ALERT_TITLE   := ''Upload Failed'';',
'        :P18_ALERT_MESSAGE := l_message;',
'    END IF;*/',
'    IF l_status = TRUE THEN',
'    :P18_ALERT_ICON := ''success'';',
'    :P18_ALERT_TITLE   := ''Success!'';',
'        :P18_ALERT_MESSAGE := l_message;',
'ELSIF l_status = FALSE THEN',
'    :P18_ALERT_ICON := ''error'';',
'     :P18_ALERT_TITLE   := ''Upload Failed'';',
'        :P18_ALERT_MESSAGE := l_message;',
'END IF;',
'',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        :P18_ALERT_ICON    := ''error'';',
'        :P18_ALERT_TITLE   := ''Unexpected Error'';',
'        :P18_ALERT_MESSAGE := SQLERRM;',
'        RAISE;',
'END;',
'',
'',
'',
''))
,p_attribute_02=>'P18_P1_FILE_ID,P18_TEMPLATE_LOV,P18_HOTEL_ID'
,p_attribute_03=>'P18_RESULT_MSG,P18_ALERT_TITLE,P18_ALERT_MESSAGE,P18_ALERT_TIMER,P18_ALERT_ICON'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15292044939427340)
,p_event_id=>wwv_flow_imp.id(15291074363427336)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*showAlert(',
'    "Debug Message",',
'    $v("P18_P1_FILE_ID") + "-" + $v("P18_TEMPLATE_LOV") + "-" + $v("P18_HOTEL_LIST"),',
'    $v("P18_ALERT_ICON"),',
'    $v("P18_ALERT_TIMER")',
'*/',
'showAlert(',
'    $v("P18_ALERT_TITLE"),',
'    $v("P18_ALERT_MESSAGE"),',
'    $v("P18_ALERT_ICON"),',
'    $v("P18_ALERT_TIMER")',
');',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15276605129427294)
,p_name=>'Reset Hotel'
,p_event_sequence=>110
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15277128259427296)
,p_event_id=>wwv_flow_imp.id(15276605129427294)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_HOTEL_ID,P18_HOTEL_LIST'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15292449056427341)
,p_name=>'Clicked'
,p_event_sequence=>120
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15264392160427236)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15292989761427342)
,p_event_id=>wwv_flow_imp.id(15292449056427341)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_output CLOB;',
'  v_status VARCHAR2(1);',
'  v_msg    VARCHAR2(4000);',
'BEGIN',
'  -- Call your procedure with desired inputs:',
'  UR_UTILS.FETCH_TEMPLATES(',
'    p_file_id    => :P18_P1_FILE_ID,',
'    p_hotel_id   => :P18_HOTEL_LIST,',
'    p_min_score  => 90,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P18_TEMPLATE_JSON := v_output;',
'    ur_utils.add_alert(p_existing_json => :P18_ALERT_MESSAGE,',
'                        p_message       => v_msg,',
'                        p_icon          => v_status,',
'                        p_updated_json  => :P18_ALERT_MESSAGE);',
'  ELSE',
'    :P18_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_02=>'P18_P1_FILE_ID,P18_HOTEL_LIST'
,p_attribute_03=>'P18_TEMPLATE_JSON,P18_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15293429429427344)
,p_event_id=>wwv_flow_imp.id(15292449056427341)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'showAlert(',
'    $v("P18_ALERT_TITLE"),',
'    $v("P18_P1_FILE_ID") + $v("P18_HOTEL_LIST"),',
'    $v("P18_ALERT_ICON"),',
'    $v("P18_ALERT_TIMER")',
');'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15293964837427345)
,p_event_id=>wwv_flow_imp.id(15292449056427341)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P18_TEMPLATE_LOV'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15294384402427346)
,p_name=>'Changed'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P18_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15294858486427348)
,p_event_id=>wwv_flow_imp.id(15294384402427346)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P18_ALERT_MESSAGE");  // get the string from hidden page item',
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
 p_id=>wwv_flow_imp.id(15272070370427269)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(49936090129888494)
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
'        p_c002            => :data_type);',
'        ',
'    when ''U'' then',
'        APEX_COLLECTION.UPDATE_MEMBER (',
'        p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'        p_seq             => :SEQ_ID,',
'        p_c001            => :name ,',
'        p_c002            => :data_type);',
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
,p_internal_uid=>15272070370427269
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15263635002427233)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(40069164430268940)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Data Mapping Collection - Save Interactive Grid Data'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    case :APEX$ROW_STATUS',
'    when ''C'' then',
'        :SEQ_ID := APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'        p_c001            => :source ,',
'        p_c002            => :target,',
'        p_c003            => :mapping_type);',
'        ',
'    when ''U'' then',
'        APEX_COLLECTION.UPDATE_MEMBER (',
'        p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'        p_seq             => :SEQ_ID,',
'        p_c001            => :source ,',
'        p_c002            => :target,',
'        p_c003            => :mapping_type);',
'    when ''D'' then',
'        APEX_COLLECTION.DELETE_MEMBER (',
'        p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'        p_seq             => :SEQ_ID);',
'    end case;',
'end;',
'',
''))
,p_attribute_05=>'Y'
,p_attribute_06=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>15263635002427233
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15276252045427293)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'File Profiling and Collection'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_profile_clob CLOB;',
'  v_records NUMBER;',
'  v_columns CLOB;',
'',
'  -- Variables for parsing v_columns JSON',
'  CURSOR cur_columns IS',
'    SELECT jt.name, jt.data_type',
'      FROM JSON_TABLE(',
'             v_columns,',
'             ''$[*]''',
'             COLUMNS (',
'               name VARCHAR2(100) PATH ''$.name'',',
'               data_type VARCHAR2(20) PATH ''$."data-type"''',
'             )',
'           ) jt;',
'',
'BEGIN',
'  -- Create or truncate APEX collection before processing',
'  IF apex_collection.collection_exists(:P18_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(:P18_COLLECTION_NAME);',
'  END IF;',
'',
'  IF apex_collection.collection_exists(:P18_MAPPING_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(:P18_MAPPING_COLLECTION_NAME);',
'  END IF;',
'  ',
'  apex_collection.create_collection(:P18_COLLECTION_NAME);',
'',
'  FOR r IN (',
'    SELECT ID, APPLICATION_ID, NAME, FILENAME, MIME_TYPE, CREATED_ON, BLOB_CONTENT',
'      FROM APEX_APPLICATION_TEMP_FILES',
'     WHERE NAME = :P18_FILE_LOAD',
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
'  FOR rec IN (',
'    SELECT ID, BLOB_CONTENT, filename, name',
'      FROM temp_BLOB',
'     WHERE profile IS NULL -- only parse if profile not yet loaded',
'  ) LOOP',
'    -- Call APEX_DATA_PARSER.GET_FILE_PROFILE on the blob content',
'    SELECT apex_data_parser.discover(',
'             p_content => rec.BLOB_CONTENT,',
'             p_file_name => rec.filename',
'           )',
'      INTO v_profile_clob',
'      FROM dual;',
'',
'    -- Extract "parsed-rows"',
'    SELECT TO_NUMBER(JSON_VALUE(v_profile_clob, ''$."parsed-rows"''))',
'      INTO v_records',
'      FROM dual;',
'',
'    -- Extract filtered columns with mapped data types',
'    SELECT TO_CLOB(',
'             JSON_ARRAYAGG(',
'               JSON_OBJECT(',
'                 ''name'' VALUE sanitize_column_name(jt.name),',
'                 ''data-type'' VALUE CASE jt.data_type',
'                                    WHEN 1 THEN ''TEXT''',
'                                    WHEN 2 THEN ''NUMBER''',
'                                    WHEN 3 THEN ''DATE''',
'                                    ELSE ''TEXT''',
'                                  END,',
'                 ''pos'' VALUE ''COL'' || LPAD(TO_CHAR(jt.ord), 3, ''0'')',
'               )',
'             )',
'           )',
'    INTO v_columns',
'    FROM JSON_TABLE(',
'             v_profile_clob,',
'             ''$."columns"[*]''',
'             COLUMNS (',
'               ord FOR ORDINALITY,',
'               name VARCHAR2(100) PATH ''$.name'',',
'               data_type NUMBER PATH ''$."data-type"''',
'             )',
'    ) jt;',
'',
'    -- Insert each column into APEX collection',
'    FOR col IN cur_columns LOOP',
'      apex_collection.add_member(',
'        p_collection_name => :P18_COLLECTION_NAME,',
'        p_c001            => col.name,',
'        p_c002            => col.data_type',
'      );',
'    END LOOP;',
'',
'    -- Update temp_BLOB table',
'    UPDATE temp_BLOB',
'       SET profile = v_profile_clob,',
'           records = v_records,',
'           columns = v_columns',
'     WHERE ID = rec.ID;',
'  END LOOP;',
'',
'  COMMIT;',
'',
'',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>15276252045427293
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15275840377427292)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Templates'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'    DECLARE',
'      v_output CLOB;',
'      v_status VARCHAR2(1);',
'      v_msg    VARCHAR2(4000);',
'    BEGIN',
'      -- Call your procedure with desired inputs:',
'      UR_UTILS.FETCH_TEMPLATES(',
'        p_file_id    => 10367474368641719,',
'        p_hotel_id   => ''3B9B828094379CA8E063DD59000AC846'',',
'        p_min_score  => 90,',
'        p_debug_flag => ''N'',',
'        p_output_json => v_output,',
'        p_status    => v_status,',
'        p_message   => v_msg',
'      );',
'',
'      IF v_status = ''S'' THEN',
'        :P18_TEMPLATE_JSON := v_output;',
'      ELSE',
'        :P18_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'        apex_debug.message(''Template matching error: '' || v_msg);',
'      END IF;',
'    END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>15275840377427292
);
wwv_flow_imp.component_end;
end;
/
