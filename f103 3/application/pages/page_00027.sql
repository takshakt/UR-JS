prompt --application/pages/page_00027
begin
--   Manifest
--     PAGE: 00027
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
 p_id=>27
,p_name=>'Events Data Load'
,p_alias=>'EVENTS-DATA-LOAD'
,p_page_mode=>'MODAL'
,p_step_title=>'Events Data Load'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27851656201985215)
,p_plug_name=>'Button Bar'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noUI'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P27_FILE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27853670063985225)
,p_plug_name=>'Data Source'
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27854002312985228)
,p_plug_name=>'Upload a File'
,p_parent_plug_id=>wwv_flow_imp.id(27853670063985225)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P27_FILE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(27856195559985239)
,p_plug_name=>'Loaded File'
,p_parent_plug_id=>wwv_flow_imp.id(27853670063985225)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>40
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P27_FILE'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(27857741532985246)
,p_name=>'Preview'
,p_template=>4072358936313175081
,p_display_sequence=>50
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--scrollBody:t-Form--stretchInputs'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--staticRowColors:t-Report--rowHighlight:t-Report--horizontalBorders:t-Report--hideNoPagination'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'  p.line_number,',
'  p.col001 AS EVENT_NAME,',
'  p.col002 AS EVENT_TYPE,',
'  p.col003 AS EVENT_START_DATE,',
'  p.col004 AS EVENT_END_DATE,',
'  p.col005 AS ESTIMATED_ATTENDANCE,',
'',
'  CASE LOWER(p.col006)',
'      WHEN ''high''   THEN 3',
'      WHEN ''medium'' THEN 2',
'      WHEN ''low''    THEN 1',
'      ELSE NULL',
'  END AS IMPACT_LEVEL,',
'',
'  p.col007 AS DESCRIPTION,',
'  p.col008 AS CITY,',
'  p.col009 AS POSTCODE,',
'  p.col010 AS COUNTRY,',
'  p.col011 AS EVENT_FREQUENCY,',
'',
'  CASE LOWER(p.col012)',
'      WHEN ''positive'' THEN ''+1''',
'      WHEN ''negative'' THEN ''-1''',
'      ELSE NULL',
'  END AS IMPACT_TYPE',
'',
'FROM apex_application_temp_files f,',
'     TABLE(',
'       apex_data_parser.parse(',
'         p_content   => f.blob_content,',
'         p_file_name => f.filename,',
'         p_max_rows  => 100',
'       )',
'     ) p',
'WHERE f.name = :P27_FILE;',
''))
,p_display_when_condition=>'P27_FILE'
,p_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P0_HOTEL_ID,P27_HOTEL_ID'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_headings_type=>'NO_HEADINGS'
,p_query_num_rows=>50
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_no_data_found=>'no data found'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_query_row_count_max=>500
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_prn_output=>'N'
,p_prn_format=>'PDF'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(27858169842985257)
,p_query_column_id=>1
,p_column_alias=>'LINE_NUMBER'
,p_column_display_sequence=>1
,p_column_heading=>'Line Number'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28775446491726019)
,p_query_column_id=>2
,p_column_alias=>'EVENT_NAME'
,p_column_display_sequence=>31
,p_column_heading=>'Event Name'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28775595319726020)
,p_query_column_id=>3
,p_column_alias=>'EVENT_TYPE'
,p_column_display_sequence=>41
,p_column_heading=>'Event Type'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28775689932726021)
,p_query_column_id=>4
,p_column_alias=>'EVENT_START_DATE'
,p_column_display_sequence=>51
,p_column_heading=>'Event Start Date'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28775710282726022)
,p_query_column_id=>5
,p_column_alias=>'EVENT_END_DATE'
,p_column_display_sequence=>61
,p_column_heading=>'Event End Date'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28775849477726023)
,p_query_column_id=>6
,p_column_alias=>'ESTIMATED_ATTENDANCE'
,p_column_display_sequence=>71
,p_column_heading=>'Estimated Attendance'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28775990710726024)
,p_query_column_id=>7
,p_column_alias=>'IMPACT_LEVEL'
,p_column_display_sequence=>81
,p_column_heading=>'Impact Level'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28776019053726025)
,p_query_column_id=>8
,p_column_alias=>'DESCRIPTION'
,p_column_display_sequence=>91
,p_column_heading=>'Description'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28776157905726026)
,p_query_column_id=>9
,p_column_alias=>'CITY'
,p_column_display_sequence=>101
,p_column_heading=>'City'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28776284010726027)
,p_query_column_id=>10
,p_column_alias=>'POSTCODE'
,p_column_display_sequence=>111
,p_column_heading=>'Postcode'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(28776351202726028)
,p_query_column_id=>11
,p_column_alias=>'COUNTRY'
,p_column_display_sequence=>121
,p_column_heading=>'Country'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(31803600613175005)
,p_query_column_id=>12
,p_column_alias=>'EVENT_FREQUENCY'
,p_column_display_sequence=>131
,p_column_heading=>'Event Frequency'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(31803792935175006)
,p_query_column_id=>13
,p_column_alias=>'IMPACT_TYPE'
,p_column_display_sequence=>141
,p_column_heading=>'Impact Type'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27852135337985219)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(27851656201985215)
,p_button_name=>'CLEAR'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Clear'
,p_button_position=>'NEXT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(27852495725985220)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(27851656201985215)
,p_button_name=>'LOAD'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Load Data'
,p_button_position=>'NEXT'
,p_button_execute_validations=>'N'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27854489745985230)
,p_name=>'P27_FILE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(27854002312985228)
,p_prompt=>'Upload a File'
,p_display_as=>'NATIVE_FILE'
,p_grid_label_column_span=>0
,p_field_template=>2040785906935475274
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'allow_multiple_files', 'N',
  'display_as', 'DROPZONE_BLOCK',
  'dropzone_description', 'Supported formats EXCEL',
  'max_file_size', '10000',
  'purge_file_at', 'SESSION',
  'storage_type', 'APEX_APPLICATION_TEMP_FILES')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27854849763985235)
,p_name=>'P27_ERROR_ROW_COUNT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27854002312985228)
,p_display_as=>'NATIVE_HIDDEN'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(27856521866985241)
,p_name=>'P27_FILE_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(27856195559985239)
,p_item_default=>'Pasted Data'
,p_prompt=>'Loaded File'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(28774049161726005)
,p_name=>'P27_FILE_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(27854002312985228)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(28775252204726017)
,p_name=>'P27_HOTEL_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(27854002312985228)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(28774502789726010)
,p_computation_sequence=>10
,p_computation_item=>'P27_FILE_NAME'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select filename',
'from apex_application_temp_files',
'where name = :P27_FILE',
''))
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(28774730393726012)
,p_computation_sequence=>10
,p_computation_item=>'P27_FILE_ID'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P27_FILE',
''))
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(27857439191985245)
,p_validation_name=>'Is valid file type'
,p_validation_sequence=>10
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF apex_data_parser.assert_file_type(',
'       p_file_name => :P27_FILE,',
'       p_file_type => apex_data_parser.c_file_type_csv )',
'   OR',
'   apex_data_parser.assert_file_type(',
'       p_file_name => :P27_FILE,',
'       p_file_type => apex_data_parser.c_file_type_xlsx )',
'THEN',
'    RETURN TRUE;',
'ELSE',
'    RETURN FALSE;',
'END IF;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Invalid file type. Supported file types EXCEL.'
,p_associated_item=>wwv_flow_imp.id(27854489745985230)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(28775321801726018)
,p_validation_name=>'Warning  '
,p_validation_sequence=>20
,p_validation=>'RETURN :P0_HOTEL_ID IS NOT NULL;'
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'"Please select hotel before uploading a file."'
,p_associated_item=>wwv_flow_imp.id(28775252204726017)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(27855258736985236)
,p_name=>'Upload a File'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P27_FILE'
,p_condition_element=>'P27_FILE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(27855760712985238)
,p_event_id=>wwv_flow_imp.id(27855258736985236)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27852939525985222)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_DATA_LOADING'
,p_process_name=>'Load Data'
,p_attribute_01=>wwv_flow_imp.id(31293373313321789)
,p_attribute_02=>'FILE'
,p_attribute_03=>'P27_FILE'
,p_attribute_08=>'P27_ERROR_ROW_COUNT'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(27852495725985220)
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>27852939525985222
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(27853386567985224)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_SESSION_STATE'
,p_process_name=>'Clear Cache'
,p_attribute_01=>'CLEAR_CACHE_CURRENT_PAGE'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':REQUEST = ''CLEAR'' or :P27_ERROR_ROW_COUNT = 0'
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_internal_uid=>27853386567985224
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(28776482830726029)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'TEST LOAD FILE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_cnt          PLS_INTEGER := 0;',
'  l_line_number  PLS_INTEGER;',
'',
'  -- File values (after ID,HOTEL_ID)',
'  l_id_file         VARCHAR2(4000);',
'  l_hotel_file      VARCHAR2(4000);',
'  l_event_name      VARCHAR2(4000);',
'  l_event_type      VARCHAR2(4000);',
'  l_event_start_raw VARCHAR2(4000);',
'  l_event_end_raw   VARCHAR2(4000);',
'  l_est_raw         VARCHAR2(4000);',
'  l_impact_level    VARCHAR2(4000);',
'  l_description     CLOB;',
'',
'  l_start_date DATE;',
'  l_end_date   DATE;',
'  l_est_num    NUMBER;',
'',
'  l_file_count PLS_INTEGER;',
'  l_hotel_id_raw RAW(16);  -- PL/SQL variable for HOTEL_ID',
'',
'BEGIN',
'  -- Must have hotel id selected',
'  IF :P27_HOTEL_ID IS NULL THEN',
'    raise_application_error(-20001, ''Hotel is not selected. Please select hotel before loading.'');',
'  END IF;',
'',
'  -- Strict validation: must be 32-character hex',
'  IF NOT REGEXP_LIKE(:P27_HOTEL_ID, ''^[0-9A-Fa-f]{32}$'') THEN',
'    raise_application_error(-20002, ''Invalid HOTEL_ID format. Must be a 32-character hex string.'');',
'  END IF;',
'',
'  -- Convert to RAW safely',
'  l_hotel_id_raw := HEXTORAW(:P27_HOTEL_ID);',
'',
'  -- Must have file uploaded',
'  IF :P27_FILE IS NULL THEN',
'    raise_application_error(-20003, ''No file uploaded.'');',
'  END IF;',
'',
'  SELECT COUNT(*) INTO l_file_count',
'  FROM apex_application_temp_files',
'  WHERE name = :P27_FILE;',
'',
'  IF l_file_count = 0 THEN',
'    raise_application_error(-20004, ''File not found in temp table.'');',
'  END IF;',
'',
'  FOR r IN (',
'    SELECT p.*',
'    FROM apex_application_temp_files f,',
'         TABLE(',
'           apex_data_parser.parse(',
'             p_content      => f.blob_content,',
'             p_file_name    => f.filename,',
'             p_max_rows     => NULL',
'           )',
'         ) p',
'    WHERE f.name = :P27_FILE',
'    ORDER BY p.line_number',
'  ) LOOP',
'',
'    l_line_number := r.line_number;',
'',
'    -- File column mapping EXACTLY matches your XLSX:',
'    l_id_file         := r.col001;  -- ID (ignored)',
'    l_hotel_file      := r.col002;  -- HOTEL_ID (ignored)',
'    l_event_name      := r.col003;',
'    l_event_type      := r.col004;',
'    l_event_start_raw := r.col005;',
'    l_event_end_raw   := r.col006;',
'    l_est_raw         := r.col007;',
'    l_impact_level    := r.col008;',
'    l_description     := r.col009;',
'',
'    -- Convert estimated attendance to number',
'    BEGIN',
'      l_est_num := TO_NUMBER(l_est_raw);',
'    EXCEPTION',
'      WHEN OTHERS THEN l_est_num := NULL;',
'    END;',
'',
'    -- Convert start and end dates',
'    BEGIN',
'      l_start_date := TO_DATE(l_event_start_raw, ''YYYY-MM-DD'');',
'      l_end_date   := TO_DATE(l_event_end_raw,   ''YYYY-MM-DD'');',
'    EXCEPTION',
'      WHEN OTHERS THEN',
'        l_start_date := NULL;',
'        l_end_date := NULL;',
'    END;',
'',
'    -- Insert into UR_EVENTS using safe RAW variable',
'    INSERT INTO UR_EVENTS (',
'      ID,',
'      HOTEL_ID,',
'      EVENT_NAME,',
'      EVENT_TYPE,',
'      EVENT_START_DATE,',
'      EVENT_END_DATE,',
'      ESTIMATED_ATTENDANCE,',
'      IMPACT_LEVEL,',
'      DESCRIPTION,',
'      CREATED_ON,',
'      CREATED_BY',
'    )',
'    VALUES (',
'      SYS_GUID(),',
'      l_hotel_id_raw,',
'      l_event_name,',
'      l_event_type,',
'      l_start_date,',
'      l_end_date,',
'      l_est_num,',
'      l_impact_level,',
'      l_description,',
'      SYSDATE,',
'      :APP_USER',
'    );',
'',
'    l_cnt := l_cnt + 1;',
'',
'  END LOOP;',
'',
'  -- Clean up temp file',
'  DELETE FROM apex_application_temp_files WHERE name = :P27_FILE;',
'',
'  COMMIT;',
'',
'  apex_application.g_print_success_message :=',
'    ''Upload complete. Rows loaded: '' || l_cnt;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    ROLLBACK;',
'    raise_application_error(',
'      -20010,',
'      ''Data Load failed on line '' || NVL(l_line_number,1) ||',
'      '' - Error: '' || SQLERRM',
'    );',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>28776482830726029
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31583964737340201)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Custom Data Load'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_blob BLOB;',
'    l_counter PLS_INTEGER := 0;',
'    l_start_date DATE;',
'    l_end_date   DATE;',
'    l_impact_level NUMBER;',
'    l_impact_type  NUMBER;',
'BEGIN',
'    SELECT blob_content',
'      INTO l_blob',
'      FROM apex_application_temp_files',
'     WHERE name = :P27_FILE;',
'',
'    FOR rec IN (',
'        SELECT *',
'          FROM TABLE(',
'                 apex_data_parser.parse(',
'                     p_content   => l_blob,',
'                     p_file_name => :P27_FILE',
'                 )',
'               )',
'    )',
'    LOOP',
'        l_counter := l_counter + 1;',
'',
'        IF l_counter = 1 THEN',
'            CONTINUE; -- skip header row',
'        END IF;',
'',
'        BEGIN',
'            l_start_date :=',
'                CASE WHEN rec.col003 IS NOT NULL THEN TO_DATE(rec.col003,''YYYY-MM-DD'') END;',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                l_start_date := NULL;',
'                DBMS_OUTPUT.PUT_LINE(''Invalid Start Date at row '' || l_counter || '': '' || rec.col003);',
'        END;',
'',
'        BEGIN',
'            l_end_date :=',
'                CASE WHEN rec.col004 IS NOT NULL THEN TO_DATE(rec.col004,''YYYY-MM-DD'') END;',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                l_end_date := NULL;',
'                DBMS_OUTPUT.PUT_LINE(''Invalid End Date at row '' || l_counter || '': '' || rec.col004);',
'        END;',
'',
'        l_impact_level :=',
'            CASE LOWER(rec.col006)',
'                WHEN ''high''   THEN 3',
'                WHEN ''medium'' THEN 2',
'                WHEN ''low''    THEN 1',
'                ELSE NULL',
'            END;',
'',
'        l_impact_type :=',
'            CASE LOWER(rec.col012)',
'                WHEN ''positive'' THEN ''+1''',
'                WHEN ''negative'' THEN ''-1''',
'                ELSE NULL',
'            END;',
'',
'        INSERT INTO ur_events (',
'            hotel_id,',
'            event_name,',
'            event_type,',
'            event_start_date,',
'            event_end_date,',
'            estimated_attendance,',
'            impact_level,',
'            description,',
'            city,',
'            postcode,',
'            country,',
'            event_frequency,',
'            impact_type',
'        ) VALUES (',
'            :P0_HOTEL_ID,',
'            rec.col001,',
'            rec.col002,',
'            l_start_date,',
'            l_end_date,',
'            CASE WHEN rec.col005 IS NOT NULL THEN TO_NUMBER(rec.col005) END,',
'            l_impact_level,',
'            rec.col007,',
'            rec.col008,',
'            rec.col009,',
'            rec.col010,',
'            rec.col011,',
'            l_impact_type',
'        );',
'',
'    END LOOP;',
'',
'    COMMIT;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(27852495725985220)
,p_internal_uid=>31583964737340201
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(28774669424726011)
,p_process_sequence=>30
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SET_FILENAME'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_fname VARCHAR2(4000);',
'BEGIN',
'    SELECT filename',
'    INTO l_fname',
'    FROM apex_application_temp_files',
'    WHERE name = :P27_FILE;',
'',
'    :P27_FILE_NAME := l_fname;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(27852495725985220)
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>28774669424726011
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(31803570885175004)
,p_process_sequence=>40
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'close dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(27852495725985220)
,p_process_success_message=>'Data Updated!'
,p_internal_uid=>31803570885175004
);
wwv_flow_imp.component_end;
end;
/
