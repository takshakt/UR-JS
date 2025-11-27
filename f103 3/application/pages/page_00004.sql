prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_name=>'Interface Dashboard Details'
,p_alias=>'INTERFACE-DASHBOARD-DETAILS'
,p_page_mode=>'MODAL'
,p_step_title=>'Interface Dashboard Details'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(17369081319689644)
,p_plug_name=>'Error Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(17471754626201202)
,p_name=>'Error Details'
,p_parent_plug_id=>wwv_flow_imp.id(17369081319689644)
,p_template=>2100526641005906379
,p_display_sequence=>30
,p_region_template_options=>'#DEFAULT#:js-showMaximizeButton:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc:margin-top-md:margin-left-md'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT c001 as row_number, c002 as error',
'FROM APEX_COLLECTIONS',
'WHERE collection_name = ''ERROR_DETAILS_COLLECTION'';'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(19439616628368706)
,p_query_column_id=>1
,p_column_alias=>'ROW_NUMBER'
,p_column_display_sequence=>10
,p_column_heading=>'Row Number'
,p_column_alignment=>'CENTER'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(19439721316368707)
,p_query_column_id=>2
,p_column_alias=>'ERROR'
,p_column_display_sequence=>20
,p_column_heading=>'Error'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(18154572539285611)
,p_plug_name=>'Interface Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'WITH LOG_DATA AS (',
'  SELECT',
'    UIL.ID,',
'    UIL.INTERFACE_TYPE,',
'    UH.HOTEL_NAME,',
'    UT.Name AS TEMPLATE_NAME,',
'    TB.FILENAME,',
'    UU.FIRST_NAME || '' '' || UU.LAST_NAME AS CREATED_BY,',
'    UIL.CREATED_ON,',
'    UIL.records_successful,',
'    UIL.records_failed,',
'    UIL.records_processed,',
'    UIL.LOAD_STATUS, -- Assuming this is your status column',
'    UIL.error_JSON,',
'    UIL.ERROR_DETAILS,',
'    UIL.TEMPLATE_ID,',
'    UIL.HOTEL_ID,',
'    UIL.FILE_ID,',
'    UIL.LOAD_START_TIME,',
'    -- Calculate raw processing time in seconds (as a number)',
'    (EXTRACT(DAY FROM (nvl(UIL.LOAD_END_TIME, SYSTIMESTAMP) - UIL.LOAD_START_TIME)) * 86400) +',
'    (EXTRACT(HOUR FROM (nvl(UIL.LOAD_END_TIME, SYSTIMESTAMP) - UIL.LOAD_START_TIME)) * 3600) +',
'    (EXTRACT(MINUTE FROM (nvl(UIL.LOAD_END_TIME, SYSTIMESTAMP) - UIL.LOAD_START_TIME)) * 60) +',
'     EXTRACT(SECOND FROM (nvl(UIL.LOAD_END_TIME, SYSTIMESTAMP) - UIL.LOAD_START_TIME))',
'    AS process_time_seconds',
'  FROM UR_INTERFACE_LOGS UIL',
'  JOIN UR_USERS UU ON UU.USER_ID = UIL.created_by',
'  JOIN UR_HOTELS UH ON UH.ID = UIL.Hotel_ID',
'  JOIN UR_TEMPLATES UT ON UT.id = UIL.TEMPLATE_ID',
'  JOIN TEMP_BLOB TB ON TB.ID = UIL.FILE_ID',
'--   WHERE UIL.ID = ''412D6F0E4471D814E063265A000A6E8F''',
')',
'-- Final SELECT statement to format the output and add the status logic',
'SELECT',
'  ID AS INTERFACE_ID,',
'  INTERFACE_TYPE,',
'  HOTEL_NAME,',
'  TEMPLATE_NAME,',
'  FILENAME,',
'  LOAD_START_TIME,',
'  CREATED_BY,',
'  CREATED_ON,',
'  TO_CHAR(records_successful) || ''/'' || TO_CHAR(records_failed) || '' ('' || TO_CHAR(records_processed) || '')'' AS process_summary,',
'  ROUND(process_time_seconds, 1) || ''s'' AS process_time,',
'  ',
'  -- This CASE statement creates the dynamic Load Status',
'  CASE',
'    WHEN LOAD_STATUS = ''IN_PROGRESS'' AND process_time_seconds > 600 THEN ''Error''',
'    WHEN LOAD_STATUS = ''SUCCESS'' THEN ''Success''',
'    WHEN LOAD_STATUS = ''FAILED'' THEN ''Failed''',
'    ELSE LOAD_STATUS -- Shows ''In Progress'' (if < 600s) or any other status',
'  END AS LOAD_STATUS,',
'',
'  error_JSON,',
'  ERROR_DETAILS,',
'  TEMPLATE_ID,',
'  HOTEL_ID,',
'  FILE_ID',
'FROM LOG_DATA;'))
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(18156249482285628)
,p_plug_name=>'Interface Details - Main'
,p_parent_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(18156380168285629)
,p_plug_name=>'Interface Details - Audit'
,p_parent_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody:t-Form--slimPadding'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(18538867534841102)
,p_plug_name=>'Template Data'
,p_title=>'Template Data'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>90
,p_location=>null
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(18540833443841122)
,p_plug_name=>'New'
,p_title=>'Template Data'
,p_parent_plug_id=>wwv_flow_imp.id(18538867534841102)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>'SELECT UIL.ID AS INTERFACE_LOG_ID, UIL.HOTEL_ID, UIL.TEMPLATE_ID, UIL.INTERFACE_TYPE, UIL.LOAD_START_TIME, UIL.LOAD_END_TIME, UIL.LOAD_STATUS, UIL.RECORDS_PROCESSED, UIL.RECORDS_SUCCESSFUL, UIL.RECORDS_FAILED, UIL.ERROR_DETAILS, UIL.ERROR_JSON, UT.DB'
||'_OBJECT_NAME, UT.NAME AS TEMPLATE_NAME, UT.TYPE AS TEMPLATE_TYPE, UT.ACTIVE FROM UR_INTERFACE_LOGS UIL JOIN UR_TEMPLATES UT ON UIL.TEMPLATE_ID = UT.ID WHERE UT.DB_OBJECT_NAME IS NOT NULL;'
,p_plug_source_type=>'NATIVE_IG'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Template Data'
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
 p_id=>wwv_flow_imp.id(18541046925841124)
,p_name=>'INTERFACE_LOG_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INTERFACE_LOG_ID'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Interface Log Id'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>10
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>16
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
 p_id=>wwv_flow_imp.id(18541160353841125)
,p_name=>'HOTEL_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HOTEL_ID'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Hotel Id'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>20
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>16
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
 p_id=>wwv_flow_imp.id(18541238830841126)
,p_name=>'TEMPLATE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TEMPLATE_ID'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Template Id'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>16
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
 p_id=>wwv_flow_imp.id(18541325093841127)
,p_name=>'INTERFACE_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INTERFACE_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Interface Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>20
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
 p_id=>wwv_flow_imp.id(18541447797841128)
,p_name=>'LOAD_START_TIME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOAD_START_TIME'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Load Start Time'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
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
 p_id=>wwv_flow_imp.id(18541549833841129)
,p_name=>'LOAD_END_TIME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOAD_END_TIME'
,p_data_type=>'TIMESTAMP'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Load End Time'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
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
 p_id=>wwv_flow_imp.id(18541638006841130)
,p_name=>'LOAD_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOAD_STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Load Status'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>20
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
 p_id=>wwv_flow_imp.id(18541758613841131)
,p_name=>'RECORDS_PROCESSED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECORDS_PROCESSED'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Records Processed'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>80
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
 p_id=>wwv_flow_imp.id(18541811505841132)
,p_name=>'RECORDS_SUCCESSFUL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECORDS_SUCCESSFUL'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Records Successful'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>90
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
 p_id=>wwv_flow_imp.id(18541972079841133)
,p_name=>'RECORDS_FAILED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECORDS_FAILED'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Records Failed'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>100
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
 p_id=>wwv_flow_imp.id(18542024698841134)
,p_name=>'ERROR_DETAILS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ERROR_DETAILS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Error Details'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(18542111331841135)
,p_name=>'ERROR_JSON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ERROR_JSON'
,p_data_type=>'CLOB'
,p_session_state_data_type=>'CLOB'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Error Json'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(18542238028841136)
,p_name=>'DB_OBJECT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DB_OBJECT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Db Object Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>150
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
 p_id=>wwv_flow_imp.id(18542399754841137)
,p_name=>'TEMPLATE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TEMPLATE_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Template Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>140
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
 p_id=>wwv_flow_imp.id(18542445590841138)
,p_name=>'TEMPLATE_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TEMPLATE_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Template Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>150
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
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
 p_id=>wwv_flow_imp.id(18542524329841139)
,p_name=>'ACTIVE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTIVE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Active'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(18540975939841123)
,p_internal_uid=>18540975939841123
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
 p_id=>wwv_flow_imp.id(18579747211089340)
,p_interactive_grid_id=>wwv_flow_imp.id(18540975939841123)
,p_static_id=>'185798'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(18579923592089341)
,p_report_id=>wwv_flow_imp.id(18579747211089340)
,p_view_type=>'GRID'
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18580460483089344)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(18541046925841124)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18581311739089348)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(18541160353841125)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18582241739089352)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(18541238830841126)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18583175021089357)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(18541325093841127)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18584026274089361)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(18541447797841128)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18584921807089365)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(18541549833841129)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18585890697089369)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(18541638006841130)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18586764663089373)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(18541758613841131)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18587628302089378)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(18541811505841132)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18588587994089382)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(18541972079841133)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18589430677089386)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(18542024698841134)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18590345772089390)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(18542111331841135)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18591222305089395)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(18542238028841136)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18592143617089399)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(18542399754841137)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18593086930089403)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(18542445590841138)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(18593985976089408)
,p_view_id=>wwv_flow_imp.id(18579923592089341)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(18542524329841139)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(17473528856201220)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(17369081319689644)
,p_button_name=>'Reprocess'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Reprocess'
,p_button_position=>'CREATE'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18154787889285613)
,p_name=>'P4_INTERFACE_ID_1'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(18156249482285628)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Interface'
,p_source=>'INTERFACE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'format', 'HTML',
  'send_on_page_submit', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18154821805285614)
,p_name=>'P4_INTERFACE_TYPE_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(18156380168285629)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Type'
,p_source=>'INTERFACE_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18154995832285615)
,p_name=>'P4_HOTEL_NAME_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(18156249482285628)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Hotel'
,p_source=>'HOTEL_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155037496285616)
,p_name=>'P4_TEMPLATE_NAME_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(18156249482285628)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Template'
,p_source=>'TEMPLATE_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155157831285617)
,p_name=>'P4_FILENAME_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(18156249482285628)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'File'
,p_source=>'FILENAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155268808285618)
,p_name=>'P4_LOAD_START_TIME_1'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(18156380168285629)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Start Time'
,p_source=>'LOAD_START_TIME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155381021285619)
,p_name=>'P4_CREATED_BY_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(18156380168285629)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155454645285620)
,p_name=>'P4_CREATED_ON_1'
,p_source_data_type=>'DATE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(18156380168285629)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Created On'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155520536285621)
,p_name=>'P4_PROCESS_SUMMARY_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(18156380168285629)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Processed'
,p_source=>'PROCESS_SUMMARY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155671558285622)
,p_name=>'P4_PROCESS_TIME_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(18156380168285629)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Time'
,p_source=>'PROCESS_TIME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155707829285623)
,p_name=>'P4_LOAD_STATUS_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(18156380168285629)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Status'
,p_source=>'LOAD_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155809940285624)
,p_name=>'P4_ERROR_JSON_1'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(17369081319689644)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'JSON Error'
,p_source=>'ERROR_JSON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18155976522285625)
,p_name=>'P4_TEMPLATE_ID_1'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_source=>'TEMPLATE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18156079153285626)
,p_name=>'P4_HOTEL_ID_1'
,p_source_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18156109158285627)
,p_name=>'P4_FILE_ID_1'
,p_source_data_type=>'NUMBER'
,p_is_query_only=>true
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_source=>'FILE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18275755942452006)
,p_name=>'P4_ERROR_DETAILS_1'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(17369081319689644)
,p_item_source_plug_id=>wwv_flow_imp.id(18154572539285611)
,p_prompt=>'Error Details'
,p_source=>'ERROR_DETAILS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18276003374452009)
,p_name=>'P4_FILENAME_HIDE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(18156249482285628)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(17473065388201215)
,p_name=>'Hide IG region'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17473160953201216)
,p_event_id=>wwv_flow_imp.id(17473065388201215)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$("#sub_ig_region").hide();',
'$("#error_ig_region").hide();',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(18276394249452012)
,p_name=>'LINK'
,p_event_sequence=>40
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18276461590452013)
,p_event_id=>wwv_flow_imp.id(18276394249452012)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let fileName = $v("P4_FILENAME_1");',
'',
'if (fileName) {',
'  let downloadUrl = "wwv_flow.show?p_request=APPLICATION_PROCESS=DOWNLOAD_FILE&p_flow_id=" + $v(''pFlowId'') + "&p_flow_step_id=" + $v(''pFlowStepId'') + "&p_instance=" + $v(''pInstance'') + "&x01=" + fileName;',
'',
'  let link = `<a href="${downloadUrl}" target="_blank">${fileName}</a>`;',
'  $("#P4_FILENAME_1_DISPLAY").html(link);',
'}',
''))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17471621433201201)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'JSON collection'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_status      VARCHAR2(10);',
'    l_ai_message  CLOB;',
'BEGIN',
'    IF :P4_ERROR_JSON_1 IS NOT NULL THEN',
'        xxpel_parse_error_json(',
'            p_json_clob       => :P4_ERROR_DETAILS_1,',
'            p_collection_name => ''ERROR_COLLECTION'',',
'            p_ai_message      => l_ai_message,',
'            p_status          => l_status',
'        );',
'',
'        :P4_ERROR_JSON_1 := l_ai_message;',
'',
'        IF l_status = ''S'' THEN',
unistr('            APEX_DEBUG.MESSAGE(''\2705 Collection loaded successfully: '' || l_ai_message);'),
'        ELSIF l_status = ''W'' THEN',
unistr('            APEX_DEBUG.MESSAGE(''\26A0\FE0F Warning: '' || l_ai_message);'),
'        ELSE',
unistr('            APEX_DEBUG.MESSAGE(''\274C Error while parsing: '' || l_ai_message);'),
'        END IF;',
'    ELSE',
unistr('        APEX_DEBUG.MESSAGE(''\2139\FE0F No JSON data found in P4_ERROR_DETAILS_1.'');'),
'    END IF;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>17471621433201201
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(19439336266368703)
,p_process_sequence=>20
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Fetch Error Collection'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_status  VARCHAR2(10);',
'    l_message VARCHAR2(4000);',
'    l_log_id  UR_INTERFACE_LOGS.ID%TYPE;',
'BEGIN',
'    -- First, get a valid ID from your table for testing',
'    -- SELECT id INTO l_log_id FROM ur_interface_logs WHERE ROWNUM = 1;',
'',
'    -- Call the procedure',
'    POPULATE_ERROR_COLLECTION_FROM_LOG(',
'        p_interface_log_id => :P4_INTERFACE_ID_1,',
'        p_collection_name  => ''ERROR_DETAILS_COLLECTION'',',
'        p_status           => l_status,',
'        p_message          => l_message',
'    );',
'',
'    -- Output the results for verification',
'    DBMS_OUTPUT.PUT_LINE(''Status: '' || l_status);',
'    DBMS_OUTPUT.PUT_LINE(''Message: '' || l_message);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>19439336266368703
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(18275963393452008)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Download Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_blob   BLOB;',
'  l_mime   VARCHAR2(255);',
'  l_name   VARCHAR2(400);',
'BEGIN',
'  SELECT blob_content, mime_type, filename',
'    INTO l_blob, l_mime, l_name',
'    FROM temp_blob',
'   WHERE filename = :P4_FILENAME_1; ',
'',
'  -- Send the file for download',
'  sys.htp.init;',
'  owa_util.mime_header(l_mime, FALSE);',
'  htp.p(''Content-length: '' || dbms_lob.getlength(l_blob));',
'  htp.p(''Content-Disposition: attachment; filename="'' || l_name || ''"'');',
'  owa_util.http_header_close;',
'  wpg_docload.download_file(l_blob);',
'  apex_application.stop_apex_engine;',
'EXCEPTION',
'  WHEN NO_DATA_FOUND THEN',
'    htp.p(''File not found.'');',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>18275963393452008
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(18154631473285612)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(18154572539285611)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Interface Dashboard Details1'
,p_internal_uid=>18154631473285612
);
wwv_flow_imp.component_end;
end;
/
