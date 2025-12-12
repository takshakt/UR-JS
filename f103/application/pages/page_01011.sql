prompt --application/pages/page_01011
begin
--   Manifest
--     PAGE: 01011
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
 p_id=>1011
,p_name=>'Load Data v2'
,p_alias=>'LOAD-DATA-V2'
,p_step_title=>'Load Data v2'
,p_warn_on_unsaved_changes=>'N'
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
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.grey-btn {',
'  background-color: #808080 !important;',
'  color: white !important;',
'  border-color: #808080 !important;',
'}',
'.grey-btn:hover {',
'  background-color: #6e6e6e !important;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(33315652283701611)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(8558440305922134)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52476143455862522)
,p_plug_name=>'Main Region'
,p_region_name=>'mainRegion'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_location=>null
,p_plug_customized=>'1'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(33345214504790101)
,p_plug_name=>'Template'
,p_title=>'1. Choose Template'
,p_parent_plug_id=>wwv_flow_imp.id(52476143455862522)
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
 p_id=>wwv_flow_imp.id(33345942753790108)
,p_plug_name=>'Metadata'
,p_parent_plug_id=>wwv_flow_imp.id(33345214504790101)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42950085823152151)
,p_plug_name=>'Mapping'
,p_title=>'3. Review Mapping & Calculations'
,p_parent_plug_id=>wwv_flow_imp.id(52476143455862522)
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42877625058126951)
,p_plug_name=>'Data Mapping Collection'
,p_region_name=>'MY_IG_MAPPING'
,p_parent_plug_id=>wwv_flow_imp.id(42950085823152151)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc:margin-top-lg'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    seq_id,',
'    c003 AS mapping_type,',
'    c001 AS source,',
'    c002 AS target,',
'    c004 AS default_value,',
'    c005 as target_original_name,',
'    c006 as qualifier,',
'    c007 AS Format_Mask,',
'    :P1011_TEMPLATE AS lov',
'FROM apex_collections',
'WHERE collection_name = ''UR_DATA_MAPPING_COLLECTION''',
'  AND :P1011_TEMPLATE IS NOT NULL'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P1011_TEMPLATE'
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
 p_id=>wwv_flow_imp.id(33349743175790146)
,p_name=>'FORMAT_MASK'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FORMAT_MASK'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Format Mask'
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
 p_id=>wwv_flow_imp.id(43333417662903917)
,p_name=>'MAPPING_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAPPING_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Mapping Type'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>30
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(10018491218303621)
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
,p_enable_hide=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(43354521558477327)
,p_name=>'DEFAULT_VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEFAULT_VALUE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Calculation'
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
,p_static_id=>'formula_col'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(45852726617881447)
,p_name=>'SOURCE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SOURCE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Source'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>20
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
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
 p_id=>wwv_flow_imp.id(45852819323881448)
,p_name=>'TARGET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TARGET'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_POPUP_LOV'
,p_heading=>'Target'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
,p_is_required=>false
,p_max_length=>32767
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select COLUMN_NAME||''(''||DATA_TYPE||'')'' AS target from all_tab_cols where TABLE_NAME ',
'like (select db_object_name from ur_templates where id = :P1011_TEMPLATE)',
''))
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
 p_id=>wwv_flow_imp.id(60657802504302125)
,p_name=>'SEQ_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SEQ_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Seq Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>10
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
 p_id=>wwv_flow_imp.id(60657919878302126)
,p_name=>'LOV'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOV'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Lov'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
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
 p_id=>wwv_flow_imp.id(60658003140302127)
,p_name=>'TARGET_ORIGINAL_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TARGET_ORIGINAL_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Target Original Name'
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
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(60658060515302128)
,p_name=>'QUALIFIER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUALIFIER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Qualifier'
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
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(43351989540477302)
,p_internal_uid=>43351989540477302
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
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(43358543499517814)
,p_interactive_grid_id=>wwv_flow_imp.id(43351989540477302)
,p_static_id=>'100532'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(43358760172517814)
,p_report_id=>wwv_flow_imp.id(43358543499517814)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(34233448217715741)
,p_view_id=>wwv_flow_imp.id(43358760172517814)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(33349743175790146)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(43426555280629867)
,p_view_id=>wwv_flow_imp.id(43358760172517814)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(43333417662903917)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>157
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(43583627210097196)
,p_view_id=>wwv_flow_imp.id(43358760172517814)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(43354521558477327)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(46928116255444489)
,p_view_id=>wwv_flow_imp.id(43358760172517814)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(45852726617881447)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>253
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(46928984851444493)
,p_view_id=>wwv_flow_imp.id(43358760172517814)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(45852819323881448)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60865789479024364)
,p_view_id=>wwv_flow_imp.id(43358760172517814)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(60657802504302125)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>72
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60866577793024368)
,p_view_id=>wwv_flow_imp.id(43358760172517814)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(60657919878302126)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60877474854268282)
,p_view_id=>wwv_flow_imp.id(43358760172517814)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(60658003140302127)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60878364584268286)
,p_view_id=>wwv_flow_imp.id(43358760172517814)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(60658060515302128)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52473197929862492)
,p_plug_name=>'File_Load'
,p_title=>'2. Load File'
,p_parent_plug_id=>wwv_flow_imp.id(52476143455862522)
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(33347169016790120)
,p_plug_name=>'FIle Metadata'
,p_parent_plug_id=>wwv_flow_imp.id(52473197929862492)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(52223967842288202)
,p_plug_name=>'Report'
,p_parent_plug_id=>wwv_flow_imp.id(52473197929862492)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc:margin-top-lg'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- SELECT ID, application_id, name, filename, mime_type, created_on, blob_content',
'-- FROM APEX_APPLICATION_TEMP_FILES',
'-- WHERE NAME = :P1011_FILE_LOAD',
'',
'/*SELECT ''ID'' AS attribute, TO_CHAR(ID) AS value',
'  FROM APEX_APPLICATION_TEMP_FILES',
' WHERE NAME = :P1011_FILE_LOAD',
'UNION ALL',
'SELECT ''FILENAME'', FILENAME FROM APEX_APPLICATION_TEMP_FILES WHERE NAME = :P1011_FILE_LOAD',
'UNION ALL',
'SELECT ''Records'', to_char(records-1) FROM temp_blob WHERE NAME = :P1011_FILE_LOAD*/',
'SELECT ''ID'' AS attribute, TO_CHAR(f.id) AS value',
'FROM apex_application_temp_files f',
'WHERE f.name = :P1011_FILE_LOAD',
'',
'UNION ALL',
'',
'SELECT ''FILENAME'', f.filename',
'FROM apex_application_temp_files f',
'WHERE f.name = :P1011_FILE_LOAD',
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
'WHERE f.name = :P1011_FILE_LOAD',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P1011_FILE_LOAD'
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
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(52224038525288203)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_enable_mail_download=>'Y'
,p_owner=>'VKANT'
,p_internal_uid=>52224038525288203
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52474809307862508)
,p_db_column_name=>'ATTRIBUTE'
,p_display_order=>10
,p_column_identifier=>'P'
,p_column_label=>'Attribute'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(52474911630862509)
,p_db_column_name=>'VALUE'
,p_display_order=>20
,p_column_identifier=>'Q'
,p_column_label=>'Value'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(52425068184704356)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'92503'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ATTRIBUTE:VALUE:'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(33306423082701540)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(52476143455862522)
,p_button_name=>'Data_Load'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Load Data'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33345334043790102)
,p_name=>'P1011_TEMPLATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(33345214504790101)
,p_prompt=>'Template'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name as d, id as r',
'from ur_templates',
'where 1 = 1',
'and hotel_id = :P0_HOTEL_ID',
'and metadata is not null',
'and active = ''Y''',
'order by id desc'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P0_HOTEL_ID'
,p_ajax_items_to_submit=>'P1011_TEMPLATE'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33345444292790103)
,p_name=>'P1011_TEMPLATE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(33345942753790108)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33346177453790110)
,p_name=>'P1011_TEMPLATE_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(33345942753790108)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template Type'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33346291624790111)
,p_name=>'P1011_TEMPLATE_FILE_TYPE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(33345942753790108)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Type'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33346398725790112)
,p_name=>'P1011_TEMPLATE_FILE_SHEET_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(33345942753790108)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Sheet Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33346412783790113)
,p_name=>'P1011_TEMPLATE_SKIP_ROWS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(33345942753790108)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Skipped Rows'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33346719497790116)
,p_name=>'P1011_TEMPLATE_RECORD_COUNT'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(33345942753790108)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Record Count'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33347095654790119)
,p_name=>'P1011_TEMPLATE_FILE_SHEET_XML_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(33345942753790108)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33347205116790121)
,p_name=>'P1011_FILE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(33347169016790120)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33347377180790122)
,p_name=>'P1011_FILE_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(33347169016790120)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Type'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(33347403135790123)
,p_name=>'P1011_FILE_RECORDS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(33347169016790120)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Records'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'Y',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42957484856152233)
,p_name=>'P1011_COLLECTION_NAME'
,p_item_sequence=>70
,p_source=>'UR_DATA_MAPPING'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(43364717625477437)
,p_name=>'P1011_MAPPING_COLLECTION_NAME'
,p_item_sequence=>80
,p_source=>'UR_DATA_MAPPING_COLLECTION'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(51958492837349954)
,p_name=>'P1011_FILE_LOAD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(52473197929862492)
,p_use_cache_before_default=>'NO'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52245522074288388)
,p_name=>'P1011_P1_FILE_ID'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52495733380862688)
,p_name=>'P1011_HOTEL_LIST'
,p_is_required=>true
,p_item_sequence=>100
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(52835473873771859)
,p_name=>'P1011_ALERT_TIMER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33338489396701695)
,p_name=>'File Loaded'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1011_FILE_LOAD'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33340935822701702)
,p_event_id=>wwv_flow_imp.id(33338489396701695)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33341447681701703)
,p_event_id=>wwv_flow_imp.id(33338489396701695)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF APEX_COLLECTION.COLLECTION_EXISTS(:P1011_MAPPING_COLLECTION_NAME) THEN',
'        APEX_COLLECTION.DELETE_COLLECTION(:P1011_MAPPING_COLLECTION_NAME);',
'    END IF;',
'END;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33340438761701701)
,p_event_id=>wwv_flow_imp.id(33338489396701695)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52223967842288202)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33342478371701706)
,p_event_id=>wwv_flow_imp.id(33338489396701695)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1011_TEMPLATE_JSON'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33339460437701698)
,p_event_id=>wwv_flow_imp.id(33338489396701695)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1011_TEMPLATE_JSON'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33341930390701705)
,p_event_id=>wwv_flow_imp.id(33338489396701695)
,p_event_result=>'TRUE'
,p_action_sequence=>70
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
'    p_file_id    => :P1011_P1_FILE_ID,',
'    p_hotel_id   => :P0_HOTEL_ID,',
'    p_min_score  => 50,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P1011_TEMPLATE_JSON := v_output;',
'    ur_utils.add_alert(p_existing_json => :P1011_ALERT_MESSAGE,',
'                        p_message       => v_msg,',
'                        p_icon          => v_status,',
'                        p_updated_json  => :P1011_ALERT_MESSAGE);',
'  ELSE',
'    :P1011_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_02=>'P1011_P1_FILE_ID,P1011_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33338980859701696)
,p_event_id=>wwv_flow_imp.id(33338489396701695)
,p_event_result=>'TRUE'
,p_action_sequence=>80
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
'    p_file_id    => :P1011_P1_FILE_ID,',
'    p_hotel_id   => :P0_HOTEL_ID,',
'    p_min_score  => 50,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P1011_TEMPLATE_JSON := v_output;',
'    ur_utils.add_alert(p_existing_json => :P1011_ALERT_MESSAGE,',
'                        p_message       => v_msg,',
'                        p_icon          => v_status,',
'                        p_updated_json  => :P1011_ALERT_MESSAGE);',
'  ELSE',
'    :P1011_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_02=>'P1011_P1_FILE_ID,P1011_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33342989994701708)
,p_event_id=>wwv_flow_imp.id(33338489396701695)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'showAlert(',
'    $v("P1011_ALERT_TITLE"),',
'    $v("P1011_P1_FILE_ID"),',
'    $v("P1011_ALERT_ICON"),',
'    $v("P1011_ALERT_TIMER")',
');'))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33332594911701678)
,p_name=>'Change_Hotel'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P0_HOTEL_ID'
,p_condition_element=>'P0_HOTEL_ID'
,p_triggering_condition_type=>'NOT_EQUALS'
,p_triggering_expression=>'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33334536107701684)
,p_event_id=>wwv_flow_imp.id(33332594911701678)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52476143455862522)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33335046686701685)
,p_event_id=>wwv_flow_imp.id(33332594911701678)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52476143455862522)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33333073394701680)
,p_event_id=>wwv_flow_imp.id(33332594911701678)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'  IF apex_collection.collection_exists(:P1011_MAPPING_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(''UR_DATA_MAPPING_COLLECTION'');',
'  END IF;',
'END;  '))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33336064644701688)
,p_event_id=>wwv_flow_imp.id(33332594911701678)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.region("MY_IG_MAPPING").widget().interactiveGrid("getViews").grid.model.clearChanges();',
'apex.region("MY_IG_MAPPING").widget().interactiveGrid("getActions").set("edit", false);'))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33335561477701687)
,p_event_id=>wwv_flow_imp.id(33332594911701678)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(42877625058126951)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33333568990701681)
,p_event_id=>wwv_flow_imp.id(33332594911701678)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52473197929862492)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33337001892701691)
,p_event_id=>wwv_flow_imp.id(33332594911701678)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1011_FILE_LOAD'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33337526299701692)
,p_event_id=>wwv_flow_imp.id(33332594911701678)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(52223967842288202)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33336557927701690)
,p_event_id=>wwv_flow_imp.id(33332594911701678)
,p_event_result=>'TRUE'
,p_action_sequence=>100
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
'    p_file_id    => :P1011_P1_FILE_ID,',
'    p_hotel_id   => :P0_HOTEL_ID,',
'    p_min_score  => 10,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
' ',
'                        :P1011_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
' ',
'    apex_debug.message(''Template matching error: '' || v_msg); ',
'END;'))
,p_attribute_02=>'P1011_P1_FILE_ID,P1011_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33330161498701670)
,p_name=>'Load Data on Button Click'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(33306423082701540)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33331616539701675)
,p_event_id=>wwv_flow_imp.id(33330161498701670)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'var spinner = apex.util.showSpinner();'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33330632830701672)
,p_event_id=>wwv_flow_imp.id(33330161498701670)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Load Data in Selected Table'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_status   VARCHAR2(1000);',
'    l_message  VARCHAR2(4000);',
'    v_alerts   CLOB := NULL;',
'BEGIN',
'    -- 1. Call the main data load procedure',
'    ur_utils.load_data_v2(',
'        p_file_id         => :P1011_P1_FILE_ID,        -- NUMBER',
'        p_template_key    => :P1011_TEMPLATE,      -- VARCHAR2',
'        p_hotel_id        => :P0_HOTEL_ID,       -- RAW(16)',
'        p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'        p_status          => l_status,',
'        p_message         => l_message',
'    );',
'',
'    COMMIT;',
'',
'    -- 2. Show alerts based on status',
'    IF l_status = ''E'' THEN',
unistr('        -- Error \2192 show clickable HTML alert'),
'        add_alert_1(',
'            p_existing_json => v_alerts,',
'            p_message       => l_message,',
'            p_icon          => ''error'',',
'            p_title         => ''Upload Failed'',',
'            p_timeout       => NULL,',
'            p_html_safe     => ''Y'',  -- allow HTML',
'            p_updated_json  => v_alerts',
'        );',
'',
'    ELSIF l_status = ''S'' THEN',
unistr('        -- Success \2192 normal alert'),
'        add_alert_1(',
'            p_existing_json => v_alerts,',
'            p_message       => l_message,',
'            p_icon          => ''success'',',
'            p_title         => ''Upload Success'',',
'            p_timeout       => NULL,',
'            p_html_safe     => ''N'',',
'            p_updated_json  => v_alerts',
'        );',
'',
'',
'    ELSIF l_status = ''W'' THEN',
unistr('        -- Warning \2192 normal alert'),
'        add_alert_1(',
'            p_existing_json => v_alerts,',
'            p_message       => l_message,',
'            p_icon          => ''warning'',',
'            p_title         => ''Upload Warning'',',
'            p_timeout       => NULL,',
'            p_html_safe     => ''N'',',
'            p_updated_json  => v_alerts',
'        );',
'    END IF;',
'',
'    -- 3. Push the alert to the global page item',
'    :P0_ALERT_MESSAGE := v_alerts;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
unistr('        -- Any unhandled exception \2192 show error alert'),
'        add_alert_1(',
'            p_existing_json => v_alerts,',
'            p_message       => SQLERRM,',
'            p_icon          => ''error'',',
'            p_title         => ''Unexpected Error'',',
'            p_timeout       => NULL,',
'            p_html_safe     => ''Y'',',
'            p_updated_json  => v_alerts',
'        );',
'        :P0_ALERT_MESSAGE := v_alerts;',
'        RAISE;',
'END;',
'',
'',
'',
''))
,p_attribute_02=>'P1011_P1_FILE_ID,P1011_TEMPLATE'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33332166054701677)
,p_event_id=>wwv_flow_imp.id(33330161498701670)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$("#apex_wait_overlay").remove();',
'$(".u-Processing").remove();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33322711332701647)
,p_name=>'Changed'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1011_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33323233875701649)
,p_event_id=>wwv_flow_imp.id(33322711332701647)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P1011_ALERT_MESSAGE");  // get the string from hidden page item',
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
 p_id=>wwv_flow_imp.id(33323694534701650)
,p_name=>'New'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1011_TEMPLATE_JSON'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33324147317701651)
,p_event_id=>wwv_flow_imp.id(33323694534701650)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1011_TEMPLATE_LOV'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33324512751701652)
,p_name=>'New_1'
,p_event_sequence=>160
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#formula_col'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33325060278701654)
,p_event_id=>wwv_flow_imp.id(33324512751701652)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var formula = this.triggeringElement.value.trim();',
'',
'// Allowed characters: alphanumeric, underscore, operators (+ - * / ^), parentheses',
'var allowedPattern = /^[A-Za-z0-9_+\-*/^() ]+$/;',
'if (!allowedPattern.test(formula)) {',
'    apex.message.clearErrors();',
'    apex.message.showErrors([{',
'        type: "error",',
'        location: "inline",',
'        pageItem: "formula_col",',
'        message: "Invalid characters in formula.",',
'        unsafe: false',
'    }]);',
'    return;',
'}',
'',
'// Cannot start or end with operator',
'if (/^[+\-*/^]/.test(formula) || /[+\-*/^]$/.test(formula)) {',
'    apex.message.clearErrors();',
'    apex.message.showErrors([{',
'        type: "error",',
'        location: "inline",',
'        pageItem: "formula_col",',
'        message: "Formula cannot start or end with operator.",',
'        unsafe: false',
'    }]);',
'    return;',
'}',
'',
'// No consecutive operators',
'if (/[-+*/^]{2,}/.test(formula)) {',
'    apex.message.clearErrors();',
'    apex.message.showErrors([{',
'        type: "error",',
'        location: "inline",',
'        pageItem: "formula_col",',
'        message: "Formula contains consecutive operators.",',
'        unsafe: false',
'    }]);',
'    return;',
'}',
'',
'apex.message.clearErrors();',
'console.log("Formula validated: " + formula);',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33345588600790104)
,p_name=>'Choose Template'
,p_event_sequence=>170
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1011_TEMPLATE'
,p_condition_element=>'P1011_TEMPLATE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33346057886790109)
,p_event_id=>wwv_flow_imp.id(33345588600790104)
,p_event_result=>'TRUE'
,p_action_sequence=>10
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
'BEGIN',
'  -- 1. Fetch template details including the dynamic table name',
'  SELECT name, type, db_object_name, JSON_VALUE(metadata, ''$.sheet_file_name''),',
'         JSON_VALUE(metadata, ''$.skip_rows'' RETURNING NUMBER DEFAULT 0 ON ERROR),',
'         JSON_VALUE(metadata, ''$.sheet_display_name'') || '' ('' || JSON_VALUE(metadata, ''$.sheet_file_name'') || '')'' as sheet_name,',
'         CASE JSON_VALUE(metadata, ''$.file_type'' RETURNING NUMBER DEFAULT 0 ON ERROR)',
'             WHEN 1 THEN ''1 - MS Excel (.xlsx, .xls)''',
'             WHEN 2 THEN ''2 - CSV (.csv, .txt)''',
'             WHEN 3 THEN ''3 - JSON''',
'             WHEN 4 THEN ''4 - XML (.xml)''',
'             ELSE ''N/A''',
'         END',
'  INTO v_name, v_type, v_db_object_name, v_xml_sheet_name, v_skip_rows, v_sheet, v_file_type',
'  FROM ur_templates',
'  WHERE id = :P1011_TEMPLATE;',
'  ',
'  -- 2. Construct the dynamic SQL statement',
'  v_sql_query := ''SELECT COUNT(*) FROM '' || v_db_object_name;',
'',
'  -- 3. Execute the dynamic SQL',
'  -- EXECUTE IMMEDIATE runs the string in v_sql_query and puts the result INTO v_records',
'  EXECUTE IMMEDIATE v_sql_query INTO v_records; ',
'',
'  -- 4. Assign results to APEX page items (or bind variables)',
'  :P1011_TEMPLATE_NAME := v_name;',
'  :P1011_TEMPLATE_TYPE := v_type;',
'  :P1011_TEMPLATE_SKIP_ROWS := v_skip_rows;',
'  :P1011_TEMPLATE_FILE_SHEET_NAME := v_sheet;',
'  :P1011_TEMPLATE_FILE_SHEET_XML_NAME := v_xml_sheet_name;',
'  :P1011_TEMPLATE_FILE_TYPE := v_file_type;',
'  :P1011_TEMPLATE_RECORD_COUNT := v_records; -- Assuming you''ll need to display this count',
'  :P1011_P1_FILE_ID := null;',
'END;'))
,p_attribute_02=>'P1011_TEMPLATE'
,p_attribute_03=>'P1011_TEMPLATE_NAME,P1011_TEMPLATE_TYPE,P1011_TEMPLATE_FILE_TYPE,P1011_TEMPLATE_FILE_SHEET_NAME,P1011_TEMPLATE_SKIP_ROWS,P1011_TEMPLATE_RECORD_COUNT,P1011_TEMPLATE_FILE_SHEET_XML_NAME'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33346587082790114)
,p_event_id=>wwv_flow_imp.id(33345588600790104)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(33345942753790108)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33346664354790115)
,p_event_id=>wwv_flow_imp.id(33345588600790104)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(33345942753790108)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33345671241790105)
,p_event_id=>wwv_flow_imp.id(33345588600790104)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(33345942753790108)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33347767646790126)
,p_name=>'Print File_ID'
,p_event_sequence=>180
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33347881566790127)
,p_event_id=>wwv_flow_imp.id(33347767646790126)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'v_clob clob := null;',
'begin',
'',
'ur_utils.add_alert(v_clob, :P1011_P1_FILE_ID,''warning'',NULL, NULL, v_clob);',
'',
':P0_ALERT_MESSAGE := v_clob;',
'',
'end;',
''))
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(33348178868790130)
,p_name=>'Create File Profile'
,p_event_sequence=>190
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_display_when_cond=>'P1011_P1_FILE_ID'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33348215369790131)
,p_event_id=>wwv_flow_imp.id(33348178868790130)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Validate File'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_alert_json CLOB := NULL;',
'  v_template_file_type NUMBER;',
'  v_template_sheet_display VARCHAR2(200);',
'  v_uploaded_file_type NUMBER;',
'  v_matched_sheet_file_name VARCHAR2(200) := null;',
'  v_filename VARCHAR2(500);',
'  v_file_blob BLOB;',
'  v_profile_clob CLOB;',
'',
'BEGIN',
'    -- ur_utils.add_alert(v_alert_json, ''File ID:''||:P1011_P1_FILE_ID || '' - Template ID:'' || :P1011_TEMPLATE,''success'',NULL, NULL, v_alert_json);',
'',
'    -- :P0_ALERT_MESSAGE := v_alert_json;',
'',
'  -- Get template metadata',
'  SELECT JSON_VALUE(metadata, ''$.file_type'' RETURNING NUMBER),',
'         JSON_VALUE(metadata, ''$.sheet_display_name''),',
'         BLOB_CONTENT, FILENAME',
'  INTO v_template_file_type, v_template_sheet_display,',
'       v_file_blob, v_filename',
'  FROM ur_templates t, temp_BLOB b',
'  WHERE t.id = :P1011_TEMPLATE',
'    AND b.id = :P1011_P1_FILE_ID;',
'',
'    -- ur_utils.add_alert(v_alert_json, v_filename,''success'',NULL, NULL, v_alert_json);',
'',
'  -- Discover and validate file type',
'  SELECT apex_data_parser.discover(',
'           p_content => v_file_blob,',
'           p_file_name => v_filename,',
'           p_max_rows => 1',
'         )',
'  INTO v_profile_clob FROM dual;',
'',
'  SELECT JSON_VALUE(v_profile_clob, ''$."file-type"'' RETURNING NUMBER)',
'  INTO v_uploaded_file_type FROM dual;',
'',
'  -- File type validation',
'  IF v_uploaded_file_type != v_template_file_type THEN',
'    UR_UTILS.add_alert(v_alert_json,',
'      ''File type mismatch! Template expects '' ||',
'      CASE v_template_file_type WHEN 1 THEN ''Excel'' WHEN 2 THEN ''CSV'' ',
'           WHEN 3 THEN ''JSON'' WHEN 4 THEN ''XML'' ELSE ''Unknown'' END ||',
'      '' but file is '' ||',
'      CASE v_uploaded_file_type WHEN 1 THEN ''Excel'' WHEN 2 THEN ''CSV''',
'           WHEN 3 THEN ''JSON'' WHEN 4 THEN ''XML'' ELSE ''Unknown'' END,',
'      ''E'', null, null, v_alert_json);',
'    :P0_ALERT_MESSAGE := v_alert_json;',
'    :P1011_P1_FILE_ID := NULL;',
'    RETURN;',
'  END IF;',
'',
'',
'  -- Excel sheet validation',
'  IF v_uploaded_file_type = 1 AND v_template_sheet_display IS NOT NULL THEN',
'    BEGIN',
'      SELECT SHEET_FILE_NAME INTO v_matched_sheet_file_name',
'      FROM TABLE(apex_data_parser.get_xlsx_worksheets(p_content => v_file_blob))',
'      WHERE SHEET_DISPLAY_NAME = v_template_sheet_display;',
'    EXCEPTION',
'      WHEN NO_DATA_FOUND THEN',
'        DECLARE v_sheets VARCHAR2(4000);',
'        BEGIN',
'          SELECT LISTAGG(SHEET_DISPLAY_NAME, '', '') WITHIN GROUP (ORDER BY ROWNUM)',
'          INTO v_sheets',
'          FROM TABLE(apex_data_parser.get_xlsx_worksheets(p_content => v_file_blob));',
'          ',
'          UR_UTILS.add_alert(v_alert_json,',
'            ''Sheet "'' || v_template_sheet_display || ',
'            ''" not found. Available: '' || v_sheets,',
'            ''E'', null, null, v_alert_json);',
'          :P0_ALERT_MESSAGE := v_alert_json;',
'          :P1011_P1_FILE_ID := NULL;',
'          RETURN;',
'        END;',
'    END;',
'  END IF;',
'  if v_matched_sheet_file_name is not null or v_uploaded_file_type = 2 THEN',
'      ur_utils.add_alert(v_alert_json, ''Uploaded file matched successfully with template metadata. Loading Data Mapping'',''success'',NULL, NULL, v_alert_json);',
'  END IF;',
'',
'  IF v_uploaded_file_type not in (1,2) THEN',
'       ur_utils.add_alert(v_alert_json, ''File Type is not supported, please upload Excel or CSV file only'',''error'',NULL, NULL, v_alert_json);',
'       :P1011_P1_FILE_ID := NULL;',
'  END IF;',
'    :P0_ALERT_MESSAGE := v_alert_json;',
'EXCEPTION',
'  WHEN NO_DATA_FOUND THEN',
'    UR_UTILS.add_alert(v_alert_json,',
'      ''Template or file not found.'', ''E'', null, null, v_alert_json);',
'    :P0_ALERT_MESSAGE := v_alert_json;',
'    :P1011_P1_FILE_ID := NULL;',
'  WHEN OTHERS THEN',
'    UR_UTILS.add_alert(v_alert_json,',
'      ''Error: '' || SQLERRM, ''E'', null, null, v_alert_json);',
'    :P0_ALERT_MESSAGE := v_alert_json;',
'    :P1011_P1_FILE_ID := NULL;',
'END;'))
,p_attribute_02=>'P1011_P1_FILE_ID,P1011_TEMPLATE'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33348523252790134)
,p_event_id=>wwv_flow_imp.id(33348178868790130)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Load Data Mapping Collection'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_columns CLOB;',
'  v_records NUMBER;',
'  v_column_count NUMBER;',
'  v_alert_json CLOB := NULL;',
'  v_filename VARCHAR2(500);',
'  v_sheet_display VARCHAR2(200);',
'  v_status VARCHAR2(1);        -- Add this for OUT parameter',
'  v_message VARCHAR2(4000);    -- Add this for OUT parameter',
'',
'  CURSOR cur_columns IS',
'    SELECT jt.name, jt.data_type, jt.pos',
'    FROM JSON_TABLE(v_columns, ''$[*]'' COLUMNS (',
'      name VARCHAR2(100) PATH ''$.name'',',
'      data_type VARCHAR2(20) PATH ''$."data-type"'',',
'      pos VARCHAR2(10) PATH ''$.pos''',
'    )) jt;',
'BEGIN',
'  -- Get file data',
'  SELECT columns, records, filename',
'  INTO v_columns, v_records, v_filename',
'  FROM temp_BLOB',
'  WHERE ID = :P1011_P1_FILE_ID;',
'',
'  -- Create collections',
'  IF apex_collection.collection_exists(:P1011_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(:P1011_COLLECTION_NAME);',
'  END IF;',
'  apex_collection.create_collection(:P1011_COLLECTION_NAME);',
'',
'  IF apex_collection.collection_exists(:P1011_MAPPING_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(:P1011_MAPPING_COLLECTION_NAME);',
'  END IF;',
'  apex_collection.create_collection(:P1011_MAPPING_COLLECTION_NAME);',
'',
'  -- Populate file data collection',
'  FOR col IN cur_columns LOOP',
'    apex_collection.add_member(',
'      p_collection_name => :P1011_COLLECTION_NAME,',
'      p_c001 => col.name,',
'      p_c002 => col.data_type,',
'      p_c003 => col.pos',
'    );',
'  END LOOP;',
'',
'  v_column_count := apex_collection.collection_member_count(:P1011_COLLECTION_NAME);',
'',
'  -- Load mapping collection with OUT parameters',
'  UR_UTILS.LOAD_DATA_MAPPING_COLLECTION(',
'    p_file_id => :P1011_P1_FILE_ID,',
'    p_template_id => :P1011_TEMPLATE,',
'    p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'    p_use_original_name => ''AUTO'',',
'    p_match_datatype =>''N'',',
'    p_status => v_status,      -- Add OUT parameter',
'    p_message => v_message     -- Add OUT parameter',
'  );',
'',
'  -- Check if mapping was successful',
'  IF v_status != ''S'' THEN',
'    UR_UTILS.add_alert(',
'      v_alert_json,',
'      ''Error creating data mapping: '' || v_message,',
'      ''E'',',
'      null,',
'      null,',
'      v_alert_json',
'    );',
'    :P0_ALERT_MESSAGE := v_alert_json;',
'    :P1011_P1_FILE_ID := NULL;',
'    RETURN;',
'  END IF;',
'',
'  -- Get sheet name for success message',
'  SELECT JSON_VALUE(metadata, ''$.sheet_display_name'')',
'  INTO v_sheet_display',
'  FROM ur_templates',
'  WHERE id = :P1011_TEMPLATE;',
'',
'  -- Success alert',
'  UR_UTILS.add_alert(',
'    v_alert_json,',
'    ''File "'' || v_filename || ''" uploaded successfully! Found '' || v_records ||',
'    '' records with '' || v_column_count || '' columns.'' ||',
'    CASE',
'      WHEN v_sheet_display IS NOT NULL THEN '' Using sheet: "'' || v_sheet_display || ''"''',
'      ELSE ''''',
'    END,',
'    ''S'',',
'    null,',
'    null,',
'    v_alert_json',
'  );',
'  :P0_ALERT_MESSAGE := v_alert_json;',
'',
'  -- Clear FILE_ID to prevent re-run on refresh',
'  :P1011_P1_FILE_ID := NULL;',
'  COMMIT;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    UR_UTILS.add_alert(',
'      v_alert_json,',
'      ''Error: '' || SQLERRM,',
'      ''E'',',
'      null,',
'      null,',
'      v_alert_json',
'    );',
'    :P0_ALERT_MESSAGE := v_alert_json;',
'    :P1011_P1_FILE_ID := NULL;',
'    ROLLBACK;',
'END;',
''))
,p_attribute_02=>'P1011_P1_FILE_ID,P1011_TEMPLATE'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33348710645790136)
,p_event_id=>wwv_flow_imp.id(33348178868790130)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(42877625058126951)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(33348678861790135)
,p_event_id=>wwv_flow_imp.id(33348178868790130)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(42877625058126951)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(33347578351790124)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load File Profile'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
'BEGIN',
'  -- 1. Fetch template details including the dynamic table name',
'  SELECT name, type, db_object_name, JSON_VALUE(metadata, ''$.sheet_file_name''),',
'         JSON_VALUE(metadata, ''$.skip_rows'' RETURNING NUMBER DEFAULT 0 ON ERROR),',
'         JSON_VALUE(metadata, ''$.sheet_display_name'') || '' ('' || JSON_VALUE(metadata, ''$.sheet_file_name'') || '')'' as sheet_name,',
'         CASE JSON_VALUE(metadata, ''$.file_type'' RETURNING NUMBER DEFAULT 0 ON ERROR)',
'             WHEN 1 THEN ''1 - MS Excel (.xlsx, .xls)''',
'             WHEN 2 THEN ''2 - CSV (.csv, .txt)''',
'             WHEN 3 THEN ''3 - JSON''',
'             WHEN 4 THEN ''4 - XML (.xml)''',
'             ELSE ''N/A''',
'         END',
'  INTO v_name, v_type, v_db_object_name, v_xml_sheet_name, v_skip_rows, v_sheet, v_file_type',
'  FROM ur_templates',
'  WHERE id = :P1011_TEMPLATE;',
'  ',
'  -- 2. Construct the dynamic SQL statement',
'  v_sql_query := ''SELECT COUNT(*) FROM '' || v_db_object_name;',
'',
'  -- 3. Execute the dynamic SQL',
'  -- EXECUTE IMMEDIATE runs the string in v_sql_query and puts the result INTO v_records',
'  EXECUTE IMMEDIATE v_sql_query INTO v_records; ',
'',
'  -- 4. Assign results to APEX page items (or bind variables)',
'  :P1011_TEMPLATE_NAME := v_name;',
'  :P1011_TEMPLATE_TYPE := v_type;',
'  :P1011_TEMPLATE_SKIP_ROWS := v_skip_rows;',
'  :P1011_TEMPLATE_FILE_SHEET_NAME := v_sheet;',
'  :P1011_TEMPLATE_FILE_SHEET_XML_NAME := v_xml_sheet_name;',
'  :P1011_TEMPLATE_FILE_TYPE := v_file_type;',
'  :P1011_TEMPLATE_RECORD_COUNT := v_records; -- Assuming you''ll need to display this count',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>33347578351790124
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(33319518431701634)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'File Profiling and Collection'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_profile_clob CLOB;',
'  v_records NUMBER;',
'  v_columns CLOB;',
'  v_column_count NUMBER;',
'  v_alert_json CLOB := NULL;',
'',
'  -- Template metadata variables',
'  v_template_file_type NUMBER;',
'  v_template_sheet_name VARCHAR2(200);',
'  v_uploaded_file_type NUMBER;',
'  v_sheet_exists NUMBER := 0;',
'  v_filename VARCHAR2(500);',
'',
'  -- Variables for parsing v_columns JSON',
'  CURSOR cur_columns IS',
'    SELECT jt.name, jt.data_type',
'    FROM JSON_TABLE(',
'           v_columns,',
'           ''$[*]''',
'           COLUMNS (',
'             name VARCHAR2(100) PATH ''$.name'',',
'             data_type VARCHAR2(20) PATH ''$."data-type"''',
'           )',
'         ) jt;',
'',
'BEGIN',
'  -- Get template metadata',
'  SELECT',
'    JSON_VALUE(metadata, ''$.file_type'' RETURNING NUMBER),',
'    JSON_VALUE(metadata, ''$.sheet_file_name'')',
'  INTO v_template_file_type, v_template_sheet_name',
'  FROM ur_templates',
'  WHERE id = :P1011_TEMPLATE;',
'',
'  -- Create or truncate APEX collection before processing',
'  IF apex_collection.collection_exists(:P1011_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(:P1011_COLLECTION_NAME);',
'  END IF;',
'',
'  IF apex_collection.collection_exists(:P1011_MAPPING_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(:P1011_MAPPING_COLLECTION_NAME);',
'  END IF;',
'',
'  apex_collection.create_collection(:P1011_COLLECTION_NAME);',
'',
'  -- Insert uploaded file into temp_blob',
'  FOR r IN (',
'    SELECT ID, APPLICATION_ID, NAME, FILENAME, MIME_TYPE, CREATED_ON, BLOB_CONTENT',
'    FROM APEX_APPLICATION_TEMP_FILES',
'    WHERE NAME = :P1011_FILE_LOAD',
'  ) LOOP',
'    -- Store filename for validation messages',
'    v_filename := r.FILENAME;',
'',
'    INSERT INTO temp_BLOB (',
'      ID, APPLICATION_ID, NAME, FILENAME, MIME_TYPE, CREATED_ON, BLOB_CONTENT',
'    ) VALUES (',
'      r.ID, r.APPLICATION_ID, r.NAME, r.FILENAME, r.MIME_TYPE, r.CREATED_ON, r.BLOB_CONTENT',
'    );',
'  END LOOP;',
'',
'  -- Process each uploaded file',
'  FOR rec IN (',
'    SELECT ID, BLOB_CONTENT, filename, name',
'    FROM temp_BLOB',
'    WHERE profile IS NULL',
'  ) LOOP',
'    -- Discover file profile to get file type',
'    SELECT apex_data_parser.discover(',
'             p_content => rec.BLOB_CONTENT,',
'             p_file_name => rec.filename,',
'             p_skip_rows => :P1011_TEMPLATE_SKIP_ROWS,',
'             p_xlsx_sheet_name => :P1011_TEMPLATE_FILE_SHEET_XML_NAME,',
'             p_max_rows => NULL',
'           )',
'    INTO v_profile_clob',
'    FROM dual;',
'',
'    -- Extract file type from discovered profile',
'    SELECT JSON_VALUE(v_profile_clob, ''$."file-type"'' RETURNING NUMBER)',
'    INTO v_uploaded_file_type',
'    FROM dual;',
'',
'    -- VALIDATION 1: Check if file type matches template metadata',
'    IF v_uploaded_file_type != v_template_file_type THEN',
'      -- File type mismatch error',
'      UR_UTILS.add_alert(',
'        v_alert_json,',
'        ''File type mismatch! Template expects '' ||',
'        CASE v_template_file_type',
'          WHEN 1 THEN ''Excel (XLSX)''',
'          WHEN 2 THEN ''CSV''',
'          WHEN 3 THEN ''JSON''',
'          WHEN 4 THEN ''XML''',
'          ELSE ''Unknown''',
'        END ||',
'        '' but uploaded file is '' ||',
'        CASE v_uploaded_file_type',
'          WHEN 1 THEN ''Excel (XLSX)''',
'          WHEN 2 THEN ''CSV''',
'          WHEN 3 THEN ''JSON''',
'          WHEN 4 THEN ''XML''',
'          ELSE ''Unknown''',
'        END || ''. Please upload the correct file type.'',',
'        ''E'',',
'        null,',
'        null,',
'        v_alert_json',
'      );',
'      :P0_ALERT_MESSAGE := v_alert_json;',
'      ROLLBACK;',
'      RETURN;',
'    END IF;',
'',
'    -- VALIDATION 2: For Excel files, check if sheet exists',
'    IF v_uploaded_file_type = 1 AND v_template_sheet_name IS NOT NULL THEN',
'      -- Check if the template''s sheet exists in uploaded file',
'      BEGIN',
'        SELECT COUNT(*)',
'        INTO v_sheet_exists',
'        FROM TABLE(',
'          apex_data_parser.get_xlsx_worksheets(',
'            p_content => rec.BLOB_CONTENT',
'          )',
'        )',
'        WHERE SHEET_FILE_NAME = v_template_sheet_name;',
'',
'        IF v_sheet_exists = 0 THEN',
'          -- Sheet not found error',
'          UR_UTILS.add_alert(',
'            v_alert_json,',
'            ''Sheet "'' || v_template_sheet_name || ''" not found in uploaded Excel file. Please ensure the file contains the correct sheet name.'',',
'            ''E'',',
'            null,',
'            null,',
'            v_alert_json',
'          );',
'          :P0_ALERT_MESSAGE := v_alert_json;',
'          ROLLBACK;',
'          RETURN;',
'        END IF;',
'      EXCEPTION',
'        WHEN OTHERS THEN',
'          UR_UTILS.add_alert(',
'            v_alert_json,',
'            ''Error validating Excel sheets: '' || SQLERRM,',
'            ''E'',',
'            null,',
'            null,',
'            v_alert_json',
'          );',
'          :P0_ALERT_MESSAGE := v_alert_json;',
'          ROLLBACK;',
'          RETURN;',
'      END;',
'    END IF;',
'',
'    -- VALIDATIONS PASSED - Continue with profile extraction',
'',
'    -- Extract parsed rows',
'    SELECT TO_NUMBER(JSON_VALUE(v_profile_clob, ''$."parsed-rows"''))',
'    INTO v_records',
'    FROM dual;',
'',
'    -- Extract columns with mapped data types',
'    SELECT JSON_ARRAYAGG(',
'             JSON_OBJECT(',
'               ''name'' VALUE sanitize_column_name(jt.name),',
'               ''data-type'' VALUE CASE jt.data_type',
'                                  WHEN 1 THEN ''TEXT''',
'                                  WHEN 2 THEN ''NUMBER''',
'                                  WHEN 3 THEN ''DATE''',
'                                  ELSE ''TEXT''',
'                                END,',
'               ''pos'' VALUE ''COL'' || LPAD(TO_CHAR(jt.ord), 3, ''0'')',
'             ) RETURNING CLOB',
'           )',
'    INTO v_columns',
'    FROM JSON_TABLE(',
'           v_profile_clob,',
'           ''$."columns"[*]''',
'           COLUMNS (',
'             ord FOR ORDINALITY,',
'             name VARCHAR2(100) PATH ''$.name'',',
'             data_type NUMBER PATH ''$."data-type"''',
'           )',
'         ) jt;',
'',
'    -- Insert each column into APEX collection',
'    FOR col IN cur_columns LOOP',
'      apex_collection.add_member(',
'        p_collection_name => :P1011_COLLECTION_NAME,',
'        p_c001            => col.name,',
'        p_c002            => col.data_type',
'      );',
'    END LOOP;',
'',
'    -- Update temp_BLOB table with profile data',
'    UPDATE temp_BLOB',
'    SET profile = v_profile_clob,',
'        records = v_records,',
'        columns = v_columns',
'    WHERE ID = rec.ID;',
'  END LOOP;',
'',
'  COMMIT;',
'',
'  -- Get column count for success message',
'  SELECT COUNT(*)',
'  INTO v_column_count',
'  FROM apex_collections',
'  WHERE collection_name = :P1011_COLLECTION_NAME;',
'',
'  -- SUCCESS: File processed successfully',
'  UR_UTILS.add_alert(',
'    v_alert_json,',
'    ''File uploaded and validated successfully! Found '' || v_records || '' records with '' || v_column_count || '' columns.'',',
'    ''S'',',
'    null,',
'    null,',
'    v_alert_json',
'  );',
'  :P0_ALERT_MESSAGE := v_alert_json;',
'',
'EXCEPTION',
'  WHEN NO_DATA_FOUND THEN',
'    UR_UTILS.add_alert(',
'      v_alert_json,',
'      ''Template not found or no file uploaded. Please select a template and upload a file.'',',
'      ''E'',',
'      null,',
'      null,',
'      v_alert_json',
'    );',
'    :P0_ALERT_MESSAGE := v_alert_json;',
'    ROLLBACK;',
'  WHEN OTHERS THEN',
'    UR_UTILS.add_alert(',
'      v_alert_json,',
'      ''Error processing file: '' || SQLERRM,',
'      ''E'',',
'      null,',
'      null,',
'      v_alert_json',
'    );',
'    :P0_ALERT_MESSAGE := v_alert_json;',
'    ROLLBACK;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Error'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Success'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>33319518431701634
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(33347655717790125)
,p_process_sequence=>30
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'File Profiling and Collection_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_file_id NUMBER;',
'BEGIN',
'  -- Copy file from APEX_APPLICATION_TEMP_FILES to temp_blob',
'  FOR r IN (',
'    SELECT ID, APPLICATION_ID, NAME, FILENAME, MIME_TYPE, CREATED_ON, BLOB_CONTENT',
'    FROM APEX_APPLICATION_TEMP_FILES',
'    WHERE NAME = :P1011_FILE_LOAD',
'  ) LOOP',
'    -- Store the file ID',
'    v_file_id := r.ID;',
'',
'    -- Delete existing entry if exists (prevent duplicates)',
'    -- DELETE FROM temp_BLOB WHERE ID = r.ID;',
'',
'    -- Insert into temp_blob',
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
'',
'    -- Store file ID in page item for later reference',
'    :P1011_P1_FILE_ID := v_file_id;',
'  END LOOP;',
'',
'  COMMIT;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    ROLLBACK;',
'    -- Log error or set error message',
'    apex_error.add_error(',
'      p_message => ''Error copying file: '' || SQLERRM,',
'      p_display_location => apex_error.c_inline_in_notification',
'    );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Error while uploading file, please contact system administrator.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>33347655717790125
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(33319184530701632)
,p_process_sequence=>40
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
'        :P1011_TEMPLATE_JSON := v_output;',
'      ELSE',
'        :P1011_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'        apex_debug.message(''Template matching error: '' || v_msg);',
'      END IF;',
'    END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>33319184530701632
);
wwv_flow_imp.component_end;
end;
/
