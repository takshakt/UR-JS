prompt --application/pages/page_00024
begin
--   Manifest
--     PAGE: 00024
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
 p_id=>24
,p_name=>'Load Data_test'
,p_alias=>'LOAD-DATA-TEST'
,p_step_title=>'Load Data_test'
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
 p_id=>wwv_flow_imp.id(45437098286114245)
,p_plug_name=>'Main Region'
,p_region_name=>'mainRegion'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
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
 p_id=>wwv_flow_imp.id(35907783289403841)
,p_plug_name=>'TEMPLATE'
,p_title=>'2. Choose Template'
,p_parent_plug_id=>wwv_flow_imp.id(45437098286114245)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
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
 p_id=>wwv_flow_imp.id(45705574636321925)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_imp.id(35907783289403841)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody:margin-top-lg'
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
 p_id=>wwv_flow_imp.id(35911040653403874)
,p_plug_name=>'Mapping'
,p_title=>'3. Map Data'
,p_parent_plug_id=>wwv_flow_imp.id(45437098286114245)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>120
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(35838579888378674)
,p_plug_name=>'Data Mapping Collection'
,p_region_name=>'MY_IG_MAPPING'
,p_parent_plug_id=>wwv_flow_imp.id(35911040653403874)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*select seq_id, c001 AS Source, c003 AS Mapping_Type, c002 AS Target,',
'c004 AS default_value, :P24_TEMPLATE_LOV AS LOV',
'from APEX_COLLECTIONS',
'where 1 = 1',
'and collection_name = ''UR_DATA_MAPPING_COLLECTION''',
'and :P24_TEMPLATE_LOV is not null*/',
'SELECT ',
'    seq_id,',
'    c003 AS mapping_type,',
'    c001 AS source,',
'    c002 AS target,',
'    c004 AS default_value,',
'    :P24_TEMPLATE_LOV AS lov',
'FROM apex_collections',
'WHERE collection_name = ''UR_DATA_MAPPING_COLLECTION''',
'  AND :P24_TEMPLATE_LOV IS NOT NULL',
'--ORDER BY seq_id;',
'',
'',
'',
'',
'',
''))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P24_TEMPLATE_LOV'
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
 p_id=>wwv_flow_imp.id(36294372493155640)
,p_name=>'MAPPING_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAPPING_TYPE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Mapping Type'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
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
 p_id=>wwv_flow_imp.id(36313054941729026)
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
 p_id=>wwv_flow_imp.id(36314115115729037)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(36314250014729038)
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
 p_id=>wwv_flow_imp.id(36315476388729050)
,p_name=>'DEFAULT_VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEFAULT_VALUE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Calculation'
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
 p_id=>wwv_flow_imp.id(36315529252729051)
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
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(38813681448133170)
,p_name=>'SOURCE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SOURCE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Source'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
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
 p_id=>wwv_flow_imp.id(38813774154133171)
,p_name=>'TARGET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TARGET'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_POPUP_LOV'
,p_heading=>'Target'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
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
'like (select db_object_name from ur_templates where id = :P24_TEMPLATE_LOV)',
'',
'',
'',
'--''UR_UR_BHAUMIK_30_SEP_T'' --:P24_TEMPLATE_LOV',
'',
' /*select  c002 AS target',
'from APEX_COLLECTIONS',
'where 1 = 1',
'and collection_name = ''UR_DATA_MAPPING_COLLECTION''',
'AND :P24_TEMPLATE_LOV IS NOT NULL*/'))
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
 p_id=>wwv_flow_imp.id(36312944370729025)
,p_internal_uid=>36312944370729025
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
 p_id=>wwv_flow_imp.id(36319498329769537)
,p_interactive_grid_id=>wwv_flow_imp.id(36312944370729025)
,p_static_id=>'100532'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(36319715002769537)
,p_report_id=>wwv_flow_imp.id(36319498329769537)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(36320092405769540)
,p_view_id=>wwv_flow_imp.id(36319715002769537)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(36313054941729026)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>83
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(36326404318801884)
,p_view_id=>wwv_flow_imp.id(36319715002769537)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(36314115115729037)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>40
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(36387510110881590)
,p_view_id=>wwv_flow_imp.id(36319715002769537)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(36294372493155640)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>157.5
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(36544582040348919)
,p_view_id=>wwv_flow_imp.id(36319715002769537)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(36315476388729050)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(36545480510348925)
,p_view_id=>wwv_flow_imp.id(36319715002769537)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(36315529252729051)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39889071085696212)
,p_view_id=>wwv_flow_imp.id(36319715002769537)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(38813681448133170)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(39889939681696216)
,p_view_id=>wwv_flow_imp.id(36319715002769537)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(38813774154133171)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(45434152760114215)
,p_plug_name=>'File_Load'
,p_title=>'1. Load File'
,p_parent_plug_id=>wwv_flow_imp.id(45437098286114245)
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
 p_id=>wwv_flow_imp.id(45184922672539925)
,p_plug_name=>'Report'
,p_parent_plug_id=>wwv_flow_imp.id(45434152760114215)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc:margin-top-lg'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- SELECT ID, application_id, name, filename, mime_type, created_on, blob_content',
'-- FROM APEX_APPLICATION_TEMP_FILES',
'-- WHERE NAME = :P24_FILE_LOAD',
'',
'/*SELECT ''ID'' AS attribute, TO_CHAR(ID) AS value',
'  FROM APEX_APPLICATION_TEMP_FILES',
' WHERE NAME = :P24_FILE_LOAD',
'UNION ALL',
'SELECT ''FILENAME'', FILENAME FROM APEX_APPLICATION_TEMP_FILES WHERE NAME = :P24_FILE_LOAD',
'UNION ALL',
'SELECT ''Records'', to_char(records-1) FROM temp_blob WHERE NAME = :P24_FILE_LOAD*/',
'SELECT ''ID'' AS attribute, TO_CHAR(f.id) AS value',
'FROM apex_application_temp_files f',
'WHERE f.name = :P24_FILE_LOAD',
'',
'UNION ALL',
'',
'SELECT ''FILENAME'', f.filename',
'FROM apex_application_temp_files f',
'WHERE f.name = :P24_FILE_LOAD',
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
'WHERE f.name = :P24_FILE_LOAD',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P24_FILE_LOAD'
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
 p_id=>wwv_flow_imp.id(45184993355539926)
,p_max_row_count=>'1000000'
,p_show_search_bar=>'N'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_enable_mail_download=>'Y'
,p_owner=>'VKANT'
,p_internal_uid=>45184993355539926
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(45435764138114231)
,p_db_column_name=>'ATTRIBUTE'
,p_display_order=>10
,p_column_identifier=>'P'
,p_column_label=>'Attribute'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(45435866461114232)
,p_db_column_name=>'VALUE'
,p_display_order=>20
,p_column_identifier=>'Q'
,p_column_label=>'Value'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(45386023014956079)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_type=>'REPORT'
,p_report_alias=>'92503'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ATTRIBUTE:VALUE:'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26270709470953257)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(45705574636321925)
,p_button_name=>'FETCH_TEMPLATE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Analyse Template'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
,p_grid_column_span=>3
,p_grid_column=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26266964605953236)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(45437098286114245)
,p_button_name=>'Data_Load'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Load Data'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35909330405403859)
,p_name=>'P24_AI_REPONSE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(45434152760114215)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35912552011403876)
,p_name=>'P24_TEMPLATE_LOV'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(45705574636321925)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT Template_Name || '' - '' || Score || ''%'' AS display_value,',
'       Template_id AS return_value',
'  FROM JSON_TABLE(',
'    :P24_TEMPLATE_JSON,',
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
,p_lov_cascade_parent_items=>'P0_HOTEL_ID'
,p_ajax_items_to_submit=>'P0_HOTEL_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>6
,p_grid_column=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(35917752504403911)
,p_name=>'P24_COLLECTION_NAME'
,p_item_sequence=>70
,p_source=>'UR_DATA_MAPPING'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(36324985273729115)
,p_name=>'P24_MAPPING_COLLECTION_NAME'
,p_item_sequence=>80
,p_source=>'UR_DATA_MAPPING_COLLECTION'
,p_source_type=>'STATIC'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(36327336747729139)
,p_name=>'P24_TEMPLATE_JSON'
,p_item_sequence=>100
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(44918950993601644)
,p_name=>'P24_FILE_LOAD'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(45434152760114215)
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
 p_id=>wwv_flow_imp.id(45205789722540066)
,p_name=>'P24_P1_FILE_ID'
,p_item_sequence=>50
,p_use_cache_before_default=>'NO'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SUBSTR(:P24_FILE_LOAD, 1, INSTR(:P24_FILE_LOAD, ''/'') - 1) AS file_id',
'FROM DUAL;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45456001029114366)
,p_name=>'P24_HOTEL_LIST'
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
 p_id=>wwv_flow_imp.id(45726347487998368)
,p_name=>'P24_ALERT_TITLE'
,p_item_sequence=>10
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45726463594998369)
,p_name=>'P24_ALERT_MESSAGE'
,p_item_sequence=>20
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45726520092998370)
,p_name=>'P24_ALERT_ICON'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(45795741522023537)
,p_name=>'P24_ALERT_TIMER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26297872408953364)
,p_name=>'File Loaded'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_FILE_LOAD'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26300217713953372)
,p_event_id=>wwv_flow_imp.id(26297872408953364)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26300760949953373)
,p_event_id=>wwv_flow_imp.id(26297872408953364)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF APEX_COLLECTION.COLLECTION_EXISTS(:P24_MAPPING_COLLECTION_NAME) THEN',
'        APEX_COLLECTION.DELETE_COLLECTION(:P24_MAPPING_COLLECTION_NAME);',
'    END IF;',
'END;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26299737099953370)
,p_event_id=>wwv_flow_imp.id(26297872408953364)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(45434152760114215)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26301784341953376)
,p_event_id=>wwv_flow_imp.id(26297872408953364)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_TEMPLATE_JSON'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26298703641953367)
,p_event_id=>wwv_flow_imp.id(26297872408953364)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_TEMPLATE_JSON'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26301209136953374)
,p_event_id=>wwv_flow_imp.id(26297872408953364)
,p_event_result=>'TRUE'
,p_action_sequence=>100
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
'    p_file_id    => :P24_P1_FILE_ID,',
'    p_hotel_id   => :P0_HOTEL_ID,',
'    p_min_score  => 50,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P24_TEMPLATE_JSON := v_output;',
'    ur_utils.add_alert(p_existing_json => :P24_ALERT_MESSAGE,',
'                        p_message       => v_msg,',
'                        p_icon          => v_status,',
'                        p_updated_json  => :P24_ALERT_MESSAGE);',
'  ELSE',
'    :P24_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_02=>'P24_P1_FILE_ID,P24_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_03=>'P24_TEMPLATE_JSON,P24_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26298289898953366)
,p_event_id=>wwv_flow_imp.id(26297872408953364)
,p_event_result=>'TRUE'
,p_action_sequence=>110
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
'    p_file_id    => :P24_P1_FILE_ID,',
'    p_hotel_id   => :P0_HOTEL_ID,',
'    p_min_score  => 50,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P24_TEMPLATE_JSON := v_output;',
'    ur_utils.add_alert(p_existing_json => :P24_ALERT_MESSAGE,',
'                        p_message       => v_msg,',
'                        p_icon          => v_status,',
'                        p_updated_json  => :P24_ALERT_MESSAGE);',
'  ELSE',
'    :P24_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_02=>'P24_P1_FILE_ID,P24_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_03=>'P24_TEMPLATE_JSON,P24_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26299238484953369)
,p_event_id=>wwv_flow_imp.id(26297872408953364)
,p_event_result=>'TRUE'
,p_action_sequence=>120
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_TEMPLATE_LOV'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26302267882953377)
,p_event_id=>wwv_flow_imp.id(26297872408953364)
,p_event_result=>'TRUE'
,p_action_sequence=>130
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'showAlert(',
'    $v("P24_ALERT_TITLE"),',
'    $v("P24_P1_FILE_ID"),',
'    $v("P24_ALERT_ICON"),',
'    $v("P24_ALERT_TIMER")',
');'))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26302666980953378)
,p_name=>'Page_Load_DA1'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26304171160953383)
,p_event_id=>wwv_flow_imp.id(26302666980953378)
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
'    p_file_id    => :P24_P1_FILE_ID,',
'    p_hotel_id   => ''3B9B828094379CA8E063DD59000AC846'',',
'    p_min_score  => 90,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P24_TEMPLATE_JSON := v_output;',
'  ELSE',
'    :P24_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26303107675953380)
,p_event_id=>wwv_flow_imp.id(26302666980953378)
,p_event_result=>'TRUE'
,p_action_sequence=>20
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
'    p_file_id    => :P24_P1_FILE_ID,',
'    p_hotel_id   => :P0_HOTEL_ID,',
'    p_min_score  => 50,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P24_TEMPLATE_JSON := v_output;',
'    ur_utils.add_alert(p_existing_json => :P24_ALERT_MESSAGE,',
'                        p_message       => v_msg,',
'                        p_icon          => v_status,',
'                        p_updated_json  => :P24_ALERT_MESSAGE);',
'  ELSE',
'    :P24_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_02=>'P24_HOTEL_LIST,P24_FILE_LOAD,P0_HOTEL_ID'
,p_attribute_03=>'P24_TEMPLATE_JSON,P24_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26303686085953381)
,p_event_id=>wwv_flow_imp.id(26302666980953378)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_TEMPLATE_LOV'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26291954675953347)
,p_name=>'Change_Hotel'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P0_HOTEL_ID'
,p_condition_element=>'P0_HOTEL_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26293921634953353)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(45437098286114245)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26294476379953355)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(45437098286114245)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26292410109953349)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Begin',
'  IF apex_collection.collection_exists(:P24_MAPPING_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(''UR_DATA_MAPPING_COLLECTION'');',
'  END IF;',
'END;  '))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26295470955953358)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
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
 p_id=>wwv_flow_imp.id(26293483065953352)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_TEMPLATE_LOV'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26294971374953356)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35838579888378674)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26292988329953351)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(45434152760114215)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26296471339953361)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_FILE_LOAD'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26296941322953362)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(45184922672539925)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26295987256953359)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
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
'    p_file_id    => :P24_P1_FILE_ID,',
'    p_hotel_id   => :P0_HOTEL_ID,',
'    p_min_score  => 10,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
' ',
'                        :P24_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
' ',
'    apex_debug.message(''Template matching error: '' || v_msg); ',
'END;'))
,p_attribute_02=>'P24_P1_FILE_ID,P24_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_03=>'P24_TEMPLATE_JSON,P24_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26297494131953363)
,p_event_id=>wwv_flow_imp.id(26291954675953347)
,p_event_result=>'TRUE'
,p_action_sequence=>110
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_TEMPLATE_LOV'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26284751730953326)
,p_name=>'Template Selected'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_TEMPLATE_LOV'
,p_condition_element=>'P24_TEMPLATE_LOV'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26285778025953329)
,p_event_id=>wwv_flow_imp.id(26284751730953326)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35838579888378674)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26286700690953332)
,p_event_id=>wwv_flow_imp.id(26284751730953326)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_TEMPLATE_ID'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>':P24_TEMPLATE_LOV'
,p_attribute_07=>'P24_TEMPLATE_LOV,P24_TEMPLATE_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26286277610953331)
,p_event_id=>wwv_flow_imp.id(26284751730953326)
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
'        p_file_id         => :P24_P1_FILE_ID,',
'        p_template_id    => :P24_TEMPLATE_LOV,',
'        p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'        p_status          => v_status,',
'        p_message         => v_message',
'    );',
'',
'    DBMS_OUTPUT.PUT_LINE(''Status : '' || v_status);',
'    DBMS_OUTPUT.PUT_LINE(''Message: '' || v_message);',
'END;'))
,p_attribute_02=>'P24_TEMPLATE_LOV,P24_P1_FILE_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26287250027953334)
,p_event_id=>wwv_flow_imp.id(26284751730953326)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35838579888378674)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26285299266953328)
,p_event_id=>wwv_flow_imp.id(26284751730953326)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(35838579888378674)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26289555065953340)
,p_name=>'Load Data on Button Click'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26266964605953236)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26291051927953345)
,p_event_id=>wwv_flow_imp.id(26289555065953340)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'var spinner = apex.util.showSpinner();'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26290082392953342)
,p_event_id=>wwv_flow_imp.id(26289555065953340)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Load Data in Selected Table'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_status   VARCHAR2(10);',
'    l_message  VARCHAR2(4000);',
'    v_alerts   CLOB := NULL;',
'BEGIN',
'    -- 1. Call the main data load procedure',
'    XX_LOCAL_Load_Data_4(',
'        p_file_id         => :P24_P1_FILE_ID,        -- NUMBER',
'        p_template_key    => :P24_TEMPLATE_LOV,      -- VARCHAR2',
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
,p_attribute_02=>'P24_P1_FILE_ID,P24_TEMPLATE_LOV'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26290511427953343)
,p_event_id=>wwv_flow_imp.id(26289555065953340)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*showAlert(',
'    "Debug Message",',
'    $v("P24_P1_FILE_ID") + "-" + $v("P24_TEMPLATE_LOV") + "-" + $v("P0_HOTEL_ID"),',
'    $v("P24_ALERT_ICON"),',
'    $v("P24_ALERT_TIMER")',
'*/',
'showAlert(',
'    $v("P24_ALERT_TITLE"),',
'    $v("P24_ALERT_MESSAGE"),',
'    $v("P24_ALERT_ICON"),',
'    $v("P24_ALERT_TIMER")',
');',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26291586226953346)
,p_event_id=>wwv_flow_imp.id(26289555065953340)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$("#apex_wait_overlay").remove();',
'$(".u-Processing").remove();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26282059194953319)
,p_name=>'Reset Hotel'
,p_event_sequence=>110
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26282530055953320)
,p_event_id=>wwv_flow_imp.id(26282059194953319)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P0_HOTEL_ID'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26280103619953313)
,p_name=>'Clicked'
,p_event_sequence=>120
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26270709470953257)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26281185694953316)
,p_event_id=>wwv_flow_imp.id(26280103619953313)
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
'    p_file_id    => :P24_P1_FILE_ID,',
'    p_hotel_id   => :P0_HOTEL_ID,',
'    p_min_score  => 10,',
'    p_debug_flag => ''N'',',
'    p_output_json => v_output,',
'    p_status    => v_status,',
'    p_message   => v_msg',
'  );',
'',
'  IF v_status = ''S'' THEN',
'    :P24_TEMPLATE_JSON := v_output;',
'    ur_utils.add_alert(p_existing_json => :P24_ALERT_MESSAGE,',
'                        p_message       => v_msg,',
'                        p_icon          => v_status,',
'                        p_updated_json  => :P24_ALERT_MESSAGE);',
'  ELSE',
'    :P24_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'    apex_debug.message(''Template matching error: '' || v_msg);',
'  END IF;',
'END;'))
,p_attribute_02=>'P24_P1_FILE_ID,P24_HOTEL_LIST,P0_HOTEL_ID'
,p_attribute_03=>'P24_TEMPLATE_JSON,P24_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26280693714953314)
,p_event_id=>wwv_flow_imp.id(26280103619953313)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_TEMPLATE_LOV'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26281688906953317)
,p_event_id=>wwv_flow_imp.id(26280103619953313)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'showAlert(',
'    $v("P24_ALERT_TITLE"),',
'    $v("P24_P1_FILE_ID") + $v("P0_HOTEL_ID"),',
'    $v("P24_ALERT_ICON"),',
'    $v("P24_ALERT_TIMER")',
');'))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26282971547953321)
,p_name=>'Changed'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26283409769953323)
,p_event_id=>wwv_flow_imp.id(26282971547953321)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P24_ALERT_MESSAGE");  // get the string from hidden page item',
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
 p_id=>wwv_flow_imp.id(26283896630953324)
,p_name=>'New'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P24_TEMPLATE_JSON'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26284358183953325)
,p_event_id=>wwv_flow_imp.id(26283896630953324)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P24_TEMPLATE_LOV'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26287670664953335)
,p_name=>'Page_Load_DA'
,p_event_sequence=>150
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26288691428953338)
,p_event_id=>wwv_flow_imp.id(26287670664953335)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(45437098286114245)
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26288177360953336)
,p_event_id=>wwv_flow_imp.id(26287670664953335)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P0_HOTEL_ID'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'NULL'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26289165340953339)
,p_event_id=>wwv_flow_imp.id(26287670664953335)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P0_HOTEL_ID'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26276190730953286)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(35838579888378674)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Data Mapping Collection - Save Interactive Grid Data'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    case :APEX$ROW_STATUS',
'    when ''C'' then',
'        :SEQ_ID := APEX_COLLECTION.ADD_MEMBER(',
'    p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'    p_c001            => :source,',
'    p_c002            => :target,',
'    p_c003            => :mapping_type,',
'     p_c004            => :default_value',
');',
'',
'        ',
'    when ''U'' then',
'        APEX_COLLECTION.UPDATE_MEMBER (',
'        p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'        p_seq             => :SEQ_ID,',
'        p_c001            => :source ,',
'        p_c002            => :target,',
'        p_c003            => :mapping_type,',
'        p_c004            => :default_value);',
'    when ''D'' then',
'        APEX_COLLECTION.DELETE_MEMBER (',
'        p_collection_name => ''UR_DATA_MAPPING_COLLECTION'',',
'        p_seq             => :SEQ_ID);',
'    end case;',
'',
'  ',
'end;',
'',
''))
,p_attribute_05=>'Y'
,p_attribute_06=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>26276190730953286
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26279786941953311)
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
'  IF apex_collection.collection_exists(:P24_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(:P24_COLLECTION_NAME);',
'  END IF;',
'',
'  IF apex_collection.collection_exists(:P24_MAPPING_COLLECTION_NAME) THEN',
'    apex_collection.delete_collection(:P24_MAPPING_COLLECTION_NAME);',
'  END IF;',
'  ',
'  apex_collection.create_collection(:P24_COLLECTION_NAME);',
'',
'  FOR r IN (',
'    SELECT ID, APPLICATION_ID, NAME, FILENAME, MIME_TYPE, CREATED_ON, BLOB_CONTENT',
'      FROM APEX_APPLICATION_TEMP_FILES',
'     WHERE NAME = :P24_FILE_LOAD',
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
'   /* SELECT TO_CLOB(',
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
'    ) jt; commented when columns are more than 30*/',
'    SELECT JSON_ARRAYAGG(',
'         JSON_OBJECT(',
'           ''name'' VALUE sanitize_column_name(jt.name),',
'           ''data-type'' VALUE CASE jt.data_type',
'                              WHEN 1 THEN ''TEXT''',
'                              WHEN 2 THEN ''NUMBER''',
'                              WHEN 3 THEN ''DATE''',
'                              ELSE ''TEXT''',
'                            END,',
'           ''pos'' VALUE ''COL'' || LPAD(TO_CHAR(jt.ord), 3, ''0'')',
'         ) RETURNING CLOB',
'       )',
'INTO v_columns',
'FROM JSON_TABLE(',
'         v_profile_clob,',
'         ''$."columns"[*]''',
'         COLUMNS (',
'           ord FOR ORDINALITY,',
'           name VARCHAR2(100) PATH ''$.name'',',
'           data_type NUMBER PATH ''$."data-type"''',
'         )',
'     ) jt;',
'',
'',
'    -- Insert each column into APEX collection',
'    FOR col IN cur_columns LOOP',
'      apex_collection.add_member(',
'        p_collection_name => :P24_COLLECTION_NAME,',
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
,p_internal_uid=>26279786941953311
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26279379243953309)
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
'        :P24_TEMPLATE_JSON := v_output;',
'      ELSE',
'        :P24_TEMPLATE_JSON := ''[{}]''; -- fallback empty',
'        apex_debug.message(''Template matching error: '' || v_msg);',
'      END IF;',
'    END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>26279379243953309
);
wwv_flow_imp.component_end;
end;
/
