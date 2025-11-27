prompt --application/pages/page_00020
begin
--   Manifest
--     PAGE: 00020
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
 p_id=>20
,p_name=>'Add Events'
,p_alias=>'ADD-EVENTS'
,p_page_mode=>'MODAL'
,p_step_title=>'Add Events'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'https://cdn.jsdelivr.net/npm/flatpickr'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(12890890599500105)
,p_plug_name=>'New Event'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(23205449817797502)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(12891972758500116)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_button_name=>'Delete'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'CLOSE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(12892093694500117)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'CREATE'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12890992303500106)
,p_name=>'P20_EVENT_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Event Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12891016587500107)
,p_name=>'P20_EVENT_TYPE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Event Type'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR EVENT TYPES'
,p_lov=>'.'||wwv_flow_imp.id(12921639157580743)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12891178734500108)
,p_name=>'P20_EVENT_DESRIPTION'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Event Description'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12891372949500110)
,p_name=>'P20_START_DATE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Start Date'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12891418147500111)
,p_name=>'P20_FREQUENCY'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Frequency'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:One time event;One time event,Monthly;Monthly,Quarterly;Quarterly,Annually;Annually'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12891532903500112)
,p_name=>'P20_ATTENDANCE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Attendance'
,p_source=>'ESTIMATED_ATTENDANCE'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Less than 10;10,Less than 100;100,Less than 1000;1000,More than 1000;1100'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12891634683500113)
,p_name=>'P20_POST_CODE'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Post Code'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12891757533500114)
,p_name=>'P20_CITY'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'City'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12891849823500115)
,p_name=>'P20_COUNTRY'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Country'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12892135703500118)
,p_name=>'P20_END_DATE'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'End Date'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'ITEM',
  'min_item', 'P20_START_DATE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12893293664500129)
,p_name=>'P20_IMPACT_TYPE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Impact Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Positive;+1,Negative;-1'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12893357573500130)
,p_name=>'P20_IMPACT_LEVEL'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_item_default=>'Medium'
,p_prompt=>'Impact Level'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Low;1,Medium;2,High;3'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12893403683500131)
,p_name=>'P20_DATE_RANGE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Date Range'
,p_placeholder=>'Start to End Date'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12894173291500138)
,p_name=>'P20_HOTEL_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Hotel Name'
,p_source=>'HOTEL_ID'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISPLAY_VALUE, RETURN_VALUE FROM (',
'  SELECT HOTEL_NAME AS DISPLAY_VALUE,',
'         RAWTOHEX(ID) AS RETURN_VALUE',
'    FROM UR_HOTELS',
'    WHERE nvl(ASSOCIATION_END_DATE,sysdate) >= sysdate',
'',
'  UNION ALL',
'  SELECT ''-- Select Hotel  --'' AS DISPLAY_VALUE,',
'         NULL AS RETURN_VALUE',
'    FROM DUAL',
')',
'ORDER BY  DISPLAY_VALUE'))
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12895164421500148)
,p_name=>'P20_EVENT_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_source=>'ID'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13478669877370108)
,p_name=>'P20_HOTEL_EVENT_LIST'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Events'
,p_source=>'ID'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISPLAY_VALUE, RETURN_VALUE',
'FROM (',
'  -- New event option (always first)',
'  SELECT ''-- Define New Event --'' AS DISPLAY_VALUE,',
'         ''00000000000000000000000000000000'' AS RETURN_VALUE,',
'         0 AS sort_order',
'  FROM dual',
'',
'  UNION ALL',
'',
'  -- Events list filtered by hotel (or common events)',
'  SELECT EVENT_NAME AS DISPLAY_VALUE,',
'         RAWTOHEX(ID) AS RETURN_VALUE,',
'         1 AS sort_order',
'    FROM UR_EVENTS,',
'    (SELECT :P20_HOTEL_ID AS P20_HOTEL_ID_VAL FROM dual) param',
'   WHERE',
'     (param.P20_HOTEL_ID_VAL = ''COMMON_EVENTS'' AND HOTEL_ID IS NULL)',
'     OR',
'     (param.P20_HOTEL_ID_VAL <> ''COMMON_EVENTS''',
'      AND HOTEL_ID = CASE',
'                       WHEN REGEXP_LIKE(param.P20_HOTEL_ID_VAL, ''^[0-9A-Fa-f]{32}$'')',
'                       THEN HEXTORAW(param.P20_HOTEL_ID_VAL)',
'                       ELSE NULL',
'                    END)',
')',
'ORDER BY sort_order, DISPLAY_VALUE'))
,p_lov_cascade_parent_items=>'P20_HOTEL_ID'
,p_ajax_items_to_submit=>'P20_HOTEL_ID'
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
 p_id=>wwv_flow_imp.id(22839823486924807)
,p_name=>'P20_ATTENDANCE_TEST'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(12890890599500105)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Attendance Test'
,p_source=>'ESTIMATED_ATTENDANCE'
,p_source_type=>'DB_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT ''\2264 10'' AS display_value, ''\2264 10'' AS return_value FROM DUAL'),
'UNION ALL',
unistr('SELECT ''\2264 100'', ''\2264 100'' FROM DUAL'),
'UNION ALL',
unistr('SELECT ''\2264 1000'', ''\2264 1000'' FROM DUAL'),
'UNION ALL',
'SELECT ''More than 1000'', ''More than 1000'' FROM DUAL'))
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12893013250500127)
,p_name=>'Postcode lookup'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P20_POST_CODE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12893178106500128)
,p_event_id=>wwv_flow_imp.id(12893013250500127)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_response CLOB;',
'  l_pc       VARCHAR2(200);',
'  l_city     VARCHAR2(4000);',
'  l_country  VARCHAR2(200);',
'  l_tmp      VARCHAR2(4000);',
'  l_status_n NUMBER := NULL;',
'',
'  TYPE t_path_tab IS TABLE OF VARCHAR2(200);',
'  l_paths t_path_tab := t_path_tab(',
'    ''result.post_town'',',
'    ''result.admin_district'',',
'    ''result.parish'',',
'    ''result.region'',',
'    ''result.admin_county'',',
'    ''result.admin_ward'',',
'    ''result.outcode'',',
'    ''result.incode''',
'  );',
'BEGIN',
'  :P20_CITY := NULL;',
'  :P20_COUNTRY := NULL;',
'',
'  l_pc := TRIM(:P20_POST_CODE);',
'  IF l_pc IS NULL THEN',
'    RETURN;',
'  END IF;',
'',
'  l_pc := UPPER(REPLACE(l_pc, '' '', ''''));',
'',
'  l_response := APEX_WEB_SERVICE.MAKE_REST_REQUEST(',
'                  p_url         => ''https://api.postcodes.io/postcodes/'' || l_pc,',
'                  p_http_method => ''GET''',
'                );',
'',
'',
'  APEX_DEBUG.MESSAGE(''Postcodes.io raw response: '' || SUBSTR(l_response,1,32000));',
'',
'  -- Parse JSON',
'  APEX_JSON.parse(l_response);',
'',
'  -- Read numeric status (200 = success)',
'  BEGIN',
'    l_status_n := APEX_JSON.get_number(p_path => ''status'');',
'  EXCEPTION WHEN OTHERS THEN',
'    l_status_n := NULL;',
'  END;',
'',
'  IF l_status_n = 200 THEN',
'    -- read country',
'    BEGIN',
'      l_country := APEX_JSON.get_varchar2(p_path => ''result.country'');',
'    EXCEPTION WHEN OTHERS THEN',
'      l_country := NULL;',
'    END;',
'',
'    -- pick the best city-like field in order',
'    FOR i IN 1 .. l_paths.COUNT LOOP',
'      BEGIN',
'        l_tmp := APEX_JSON.get_varchar2(p_path => l_paths(i));',
'      EXCEPTION WHEN OTHERS THEN',
'        l_tmp := NULL;',
'      END;',
'',
'      APEX_DEBUG.MESSAGE(''Candidate '' || l_paths(i) || '' => '' || NVL(l_tmp,''<null>''));',
'',
'      IF l_tmp IS NOT NULL THEN',
'        l_city := l_tmp;',
'        EXIT;',
'      END IF;',
'    END LOOP;',
'',
'    -- Normalize chosen city',
'    IF l_city IS NOT NULL THEN',
'      l_city := TRIM(l_city);',
'      BEGIN',
'        l_city := INITCAP(LOWER(l_city));',
'      EXCEPTION WHEN OTHERS THEN',
'        NULL;',
'      END;',
'    END IF;',
'',
'    :P20_CITY := l_city;',
'    :P20_COUNTRY := l_country;',
'    APEX_DEBUG.MESSAGE(''Final chosen city: '' || NVL(l_city,''<null>'') || '' | country: '' || NVL(l_country,''<null>''));',
'',
'  ELSE',
'    -- no match or not found',
'    :P20_CITY := NULL;',
'    :P20_COUNTRY := NULL;',
'    APEX_DEBUG.MESSAGE(''Postcodes.io returned status '' || NVL(TO_CHAR(l_status_n),''<null>'') || '' for '' || :P20_POST_CODE);',
'  END IF;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    :P20_CITY := NULL;',
'    :P20_COUNTRY := NULL;',
'    APEX_DEBUG.MESSAGE(''Postcode lookup error: '' || SQLERRM);',
'    IF l_response IS NOT NULL THEN',
'      APEX_DEBUG.MESSAGE(''Raw response (error): '' || SUBSTR(l_response,1,32000));',
'    END IF;',
'END;',
''))
,p_attribute_02=>'P20_POST_CODE'
,p_attribute_03=>'P20_CITY,P20_COUNTRY'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12895224144500149)
,p_name=>'Delete row DA'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(12891972758500116)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12895391618500150)
,p_event_id=>wwv_flow_imp.id(12895224144500149)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DELETE FROM UR_EVENTS WHERE ID = :P20_EVENT_ID;',
'  COMMIT;',
'  :P0_ALERT_MESSAGE := ''Record deleted successfully'';',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    :P0_ALERT_MESSAGE := ''Deletion failed: '' || SQLERRM;',
'    RAISE;',
'END;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13478008436370102)
,p_event_id=>wwv_flow_imp.id(12895224144500149)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'Delete'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(13478338372370105)
,p_name=>'change event list'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P20_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13478938180370111)
,p_event_id=>wwv_flow_imp.id(13478338372370105)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P20_HOTEL_EVENT_LIST'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13478846339370110)
,p_event_id=>wwv_flow_imp.id(13478338372370105)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P20_HOTEL_EVENT_LIST'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(13479059310370112)
,p_name=>'Populate data and define new'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P20_HOTEL_EVENT_LIST'
,p_condition_element=>'P20_HOTEL_EVENT_LIST'
,p_triggering_condition_type=>'NOT_IN_LIST'
,p_triggering_expression=>'00000000000000000000000000000000'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13479161863370113)
,p_event_id=>wwv_flow_imp.id(13479059310370112)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P20_EVENT_NAME, P20_EVENT_TYPE, P20_EVENT_DESRIPTION, P20_START_DATE, P20_END_DATE, P20_FREQUENCY, P20_ATTENDANCE, P20_IMPACT_TYPE, P20_IMPACT_LEVEL, P20_POST_CODE, P20_CITY, P20_COUNTRY'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT EVENT_NAME,',
'       EVENT_TYPE,',
'       DESCRIPTION,',
'  TO_CHAR(EVENT_START_DATE, ''MM-DD-YYYY'') AS EVENT_START_DATE,',
'  TO_CHAR(EVENT_END_DATE,   ''MM-DD-YYYY'') AS EVENT_END_DATE,',
'       --TO_CHAR(EVENT_START_DATE, ''YYYY-MM-DD'') || '' to '' || TO_CHAR(EVENT_END_DATE, ''YYYY-MM-DD'') AS DATE_RANGE,',
'       EVENT_FREQUENCY,',
'       ESTIMATED_ATTENDANCE,',
'       IMPACT_TYPE,',
'       IMPACT_LEVEL,',
'       POSTCODE,',
'       CITY,',
'       COUNTRY',
'  FROM UR_EVENTS',
' WHERE ID = HEXTORAW(:P20_HOTEL_EVENT_LIST)',
''))
,p_attribute_07=>'P20_HOTEL_EVENT_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13479431543370116)
,p_event_id=>wwv_flow_imp.id(13479059310370112)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_new_event_id RAW(16);',
'BEGIN',
'    IF :P20_HOTEL_EVENT_LIST = ''00000000000000000000000000000000'' THEN',
'        l_new_event_id := SYS_GUID();',
'',
'        INSERT INTO UR_EVENTS (',
'            ID,',
'            HOTEL_ID,',
'            EVENT_NAME,',
'            EVENT_TYPE,',
'            EVENT_START_DATE,',
'            EVENT_END_DATE,',
'            ESTIMATED_ATTENDANCE,',
'            IMPACT_LEVEL,',
'            IMPACT_TYPE,',
'            DESCRIPTION,',
'            CITY,',
'            POSTCODE,',
'            COUNTRY,',
'            CREATED_BY,',
'            UPDATED_BY,',
'            CREATED_ON,',
'            UPDATED_ON',
'        ) VALUES (',
'            l_new_event_id,',
'            HEXTORAW(:P20_HOTEL_ID),',
'            ''NEW EVENT'',',
'            ''TEMP TYPE'',',
'            SYSDATE,',
'            SYSDATE,',
'            NULL,',
'            NULL,',
'            NULL,',
'            NULL,',
'            NULL,',
'            NULL,',
'            NULL,',
'            HEXTORAW(:APP_USER_ID), -- assuming user id hex string bind',
'            HEXTORAW(:APP_USER_ID),',
'            SYSDATE,',
'            SYSDATE',
'        );',
'',
'        :P20_HOTEL_EVENT_LIST := RAWTOHEX(l_new_event_id);',
'    END IF;',
'END;'))
,p_attribute_02=>'P20_HOTEL_ID,P20_HOTEL_EVENT_LIST'
,p_attribute_03=>'P20_HOTEL_EVENT_LIST'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P20_HOTEL_EVENT_LIST'
,p_client_condition_expression=>'NEW'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(23205565503797503)
,p_name=>'Cancel Dialog'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(23205449817797502)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(23205613385797504)
,p_event_id=>wwv_flow_imp.id(23205565503797503)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12893801393500135)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'test temp Insert proces_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status        VARCHAR2(10);',
'  l_message       CLOB;',
'  l_icon          VARCHAR2(50);',
'  l_title         VARCHAR2(100);',
'  l_new_id        VARCHAR2(64) := NULL;',
'  l_payload       CLOB;',
'  l_json_clob     CLOB := NULL;',
'',
'  l_start_date     VARCHAR2(10);',
'  l_end_date       VARCHAR2(10);',
'  l_pos            PLS_INTEGER;',
'  l_attendance_raw VARCHAR2(50) := :P20_ATTENDANCE;',
'  l_attendance_num NUMBER;',
'BEGIN',
'  -- Parse date range',
'  l_pos := INSTR(:P20_DATE_RANGE, '' to '');',
'  IF l_pos > 0 THEN',
'    l_start_date := SUBSTR(:P20_DATE_RANGE, 1, l_pos - 1);',
'    l_end_date   := SUBSTR(:P20_DATE_RANGE, l_pos + 4);',
'  ELSE',
'    l_start_date := :P20_DATE_RANGE;',
'    l_end_date   := :P20_DATE_RANGE;',
'  END IF;',
'',
'  l_attendance_raw := REGEXP_REPLACE(l_attendance_raw, ''[^0-9]'', '''');',
'  BEGIN',
'    l_attendance_num := TO_NUMBER(l_attendance_raw);',
'  EXCEPTION',
'    WHEN VALUE_ERROR THEN',
'      l_attendance_num := NULL;',
'  END;',
'',
'  -- Construct JSON payload for insertion (could be used if hooking to proc_crud_json later)',
'  l_payload := ''{"HOTEL_ID":"'' || RAWTOHEX(SYS_GUID()) || ''",',
'                "EVENT_NAME":"'' || :P20_EVENT_NAME || ''",',
'                "EVENT_TYPE":"'' || :P20_EVENT_TYPE || ''",',
'                "EVENT_START_DATE":"'' || l_start_date || ''",',
'                "EVENT_END_DATE":"'' || l_end_date || ''",',
'                "ESTIMATED_ATTENDANCE":"'' || NVL(l_attendance_num, '''') || ''",',
'                "IMPACT_LEVEL":"'' || :P20_IMPACT_LEVEL || ''",',
'                "DESCRIPTION":"'' || :P20_EVENT_DESRIPTION || ''",',
'                "CITY":"'' || :P20_CITY || ''",',
'                "POSTCODE":"'' || :P20_POST_CODE || ''"}'';',
'',
'  -- Perform direct insert',
'  INSERT INTO UR_EVENTS (',
'    HOTEL_ID,',
'    EVENT_NAME,',
'    EVENT_TYPE,',
'    EVENT_START_DATE,',
'    EVENT_END_DATE,',
'    ESTIMATED_ATTENDANCE,',
'    IMPACT_LEVEL,',
'    DESCRIPTION,',
'    CITY,',
'    POSTCODE,',
'    COUNTRY,',
'    CREATED_BY,',
'    UPDATED_BY,',
'    CREATED_ON,',
'    UPDATED_ON',
'  ) VALUES (',
'    :P20_HOTEL_ID,             --SYS_GUID(),          ',
'    :P20_EVENT_NAME,',
'    :P20_EVENT_TYPE,',
'    TO_DATE(l_start_date, ''MM-DD-YYYY''),',
'    TO_DATE(l_end_date, ''MM-DD-YYYY''),',
'    l_attendance_num,',
'    :P20_IMPACT_LEVEL,',
'    :P20_EVENT_DESRIPTION,',
'    :P20_CITY,',
'    :P20_POST_CODE,',
'    :P20_COUNTRY,',
'    SYS_GUID(),          -- Replace with current user id',
'    SYS_GUID(),',
'    SYSDATE,',
'    SYSDATE',
'  );',
'',
'  COMMIT;',
'',
'  -- Set success alert message',
'  l_status := ''S'';',
'  l_message := ''Event "'' || :P20_EVENT_NAME || ''" created successfully.'';',
'  UR_UTILS.add_alert(l_json_clob, l_message, l_status, null, null, l_json_clob);',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    l_status := ''E'';',
'    l_message := ''Insert failed: '' || SQLERRM;',
'    UR_UTILS.add_alert(l_json_clob, l_message, l_status, null, null, l_json_clob);',
'    :P0_ALERT_MESSAGE := l_json_clob;   ',
'    RAISE;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(12892093694500117)
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>12893801393500135
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(13478108673370103)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'test temp Insert proces_1_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status        VARCHAR2(10);',
'  l_message       CLOB;',
'  l_json_clob     CLOB := NULL;',
'  l_attendance_raw VARCHAR2(50) := :P20_ATTENDANCE;',
'  l_attendance_num NUMBER;',
'  l_start_date     VARCHAR2(10);',
'  l_end_date       VARCHAR2(10);',
'  l_pos            PLS_INTEGER;',
'BEGIN',
'',
'  -- Parse Date Range as you had before',
'  l_pos := INSTR(:P20_DATE_RANGE, '' to '');',
'  IF l_pos > 0 THEN',
'    l_start_date := SUBSTR(:P20_DATE_RANGE, 1, l_pos - 1);',
'    l_end_date   := SUBSTR(:P20_DATE_RANGE, l_pos + 4);',
'  ELSE',
'    l_start_date := :P20_DATE_RANGE;',
'    l_end_date   := :P20_DATE_RANGE;',
'  END IF;',
'',
'  l_attendance_raw := REGEXP_REPLACE(l_attendance_raw, ''[^0-9]'', '''');',
'  BEGIN',
'    l_attendance_num := TO_NUMBER(l_attendance_raw);',
'  EXCEPTION',
'    WHEN VALUE_ERROR THEN',
'      l_attendance_num := NULL;',
'  END;',
'',
'  IF :P20_EVENT_ID IS NOT NULL THEN',
'    UPDATE UR_EVENTS',
'    SET EVENT_NAME          = :P20_EVENT_NAME,',
'        EVENT_TYPE          = :P20_EVENT_TYPE,',
'        EVENT_START_DATE    = TO_DATE(l_start_date, ''YYYY-MM-DD''),',
'        EVENT_END_DATE      = TO_DATE(l_end_date, ''YYYY-MM-DD''),',
'        ESTIMATED_ATTENDANCE = l_attendance_num,',
'        IMPACT_LEVEL        = :P20_IMPACT_LEVEL,',
'        IMPACT_TYPE        = :P20_IMPACT_TYPE,',
'        DESCRIPTION        = :P20_EVENT_DESRIPTION,',
'        EVENT_FREQUENCY     = :P20_FREQUENCY,',
'        CITY                = :P20_CITY,',
'        POSTCODE            = :P20_POST_CODE,',
'        COUNTRY             = :P20_COUNTRY,',
'        UPDATED_BY          = SYS_GUID(), -- replace with user ID ideally',
'        UPDATED_ON          = SYSDATE',
'    WHERE ID = :P20_EVENT_ID;',
'    l_message := ''Event "'' || :P20_EVENT_NAME || ''" updated successfully.'';',
'  ELSE',
'    -- Insert new record',
'    INSERT INTO UR_EVENTS (',
'      HOTEL_ID,',
'      EVENT_NAME,',
'      EVENT_TYPE,',
'      EVENT_START_DATE,',
'      EVENT_END_DATE,',
'      ESTIMATED_ATTENDANCE,',
'      IMPACT_LEVEL,',
'      IMPACT_TYPE,',
'      DESCRIPTION,',
'      EVENT_FREQUENCY,',
'      CITY,',
'      POSTCODE,',
'      COUNTRY,',
'      CREATED_BY,',
'      UPDATED_BY,',
'      CREATED_ON,',
'      UPDATED_ON',
'    ) VALUES (',
'      :P20_HOTEL_ID,',
'      :P20_EVENT_NAME,',
'      :P20_EVENT_TYPE,',
'      TO_DATE(l_start_date, ''YYYY-MM-DD''),',
'      TO_DATE(l_end_date, ''YYYY-MM-DD''),',
'      l_attendance_num,',
'      :P20_IMPACT_LEVEL,',
'      :P20_IMPACT_TYPE,',
'      :P20_EVENT_DESRIPTION,',
'      :P20_FREQUENCY,',
'      :P20_CITY,',
'      :P20_POST_CODE,',
'      :P20_COUNTRY,',
'      SYS_GUID(),',
'      SYS_GUID(),',
'      SYSDATE,',
'      SYSDATE',
'    );',
'    l_message := ''Event "'' || :P20_EVENT_NAME || ''" created successfully.'';',
'  END IF;',
'',
'  COMMIT;',
'',
'  l_status := ''S'';',
'  UR_UTILS.add_alert(l_json_clob, l_message, l_status, null, null, l_json_clob);',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    l_status := ''E'';',
'    l_message := ''Operation failed: '' || SQLERRM;',
'    UR_UTILS.add_alert(l_json_clob, l_message, l_status, null, null, l_json_clob);',
'    :P0_ALERT_MESSAGE := l_json_clob;',
'    RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(12892093694500117)
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>13478108673370103
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(23055493079494201)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'test temp Insert proces_1_1_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status         VARCHAR2(10);',
'  l_message        CLOB;',
'  l_json_clob      CLOB := NULL;',
'  l_attendance_raw VARCHAR2(50) := :P20_ATTENDANCE;',
'  l_attendance_num NUMBER;',
'BEGIN',
'  -- Convert attendance to numeric if possible',
'  l_attendance_raw := REGEXP_REPLACE(l_attendance_raw, ''[^0-9]'', '''');',
'  BEGIN',
'    l_attendance_num := TO_NUMBER(l_attendance_raw);',
'  EXCEPTION',
'    WHEN VALUE_ERROR THEN',
'      l_attendance_num := NULL;',
'  END;',
'',
'  IF :P20_EVENT_ID IS NOT NULL THEN',
'    -- Update existing event',
'    UPDATE UR_EVENTS',
'       SET EVENT_NAME           = :P20_EVENT_NAME,',
'           EVENT_TYPE           = :P20_EVENT_TYPE,',
'           EVENT_START_DATE     = TO_DATE(:P20_START_DATE, APEX_APPLICATION.G_DATE_FORMAT),',
'           EVENT_END_DATE       = TO_DATE(:P20_END_DATE, APEX_APPLICATION.G_DATE_FORMAT),',
'           ESTIMATED_ATTENDANCE = l_attendance_num,',
'           IMPACT_LEVEL         = :P20_IMPACT_LEVEL,',
'           IMPACT_TYPE          = :P20_IMPACT_TYPE,',
'           DESCRIPTION          = :P20_EVENT_DESRIPTION,',
'           EVENT_FREQUENCY      = :P20_FREQUENCY,',
'           CITY                 = :P20_CITY,',
'           POSTCODE             = :P20_POST_CODE,',
'           COUNTRY              = :P20_COUNTRY,',
'           UPDATED_BY           = SYS_GUID(), -- ideally replace with user ID',
'           UPDATED_ON           = SYSDATE',
'     WHERE ID = :P20_EVENT_ID;',
'',
'    l_message := ''Event "'' || :P20_EVENT_NAME || ''" updated successfully.'';',
'',
'  ELSE',
'    -- Insert new record',
'    INSERT INTO UR_EVENTS (',
'      HOTEL_ID,',
'      EVENT_NAME,',
'      EVENT_TYPE,',
'      EVENT_START_DATE,',
'      EVENT_END_DATE,',
'      ESTIMATED_ATTENDANCE,',
'      IMPACT_LEVEL,',
'      IMPACT_TYPE,',
'      DESCRIPTION,',
'      EVENT_FREQUENCY,',
'      CITY,',
'      POSTCODE,',
'      COUNTRY,',
'      CREATED_BY,',
'      UPDATED_BY,',
'      CREATED_ON,',
'      UPDATED_ON',
'    ) VALUES (',
'      :P20_HOTEL_ID,',
'      :P20_EVENT_NAME,',
'      :P20_EVENT_TYPE,',
'      TO_DATE(:P20_START_DATE, APEX_APPLICATION.G_DATE_FORMAT),',
'      TO_DATE(:P20_END_DATE, APEX_APPLICATION.G_DATE_FORMAT),',
'      l_attendance_num,',
'      :P20_IMPACT_LEVEL,',
'      :P20_IMPACT_TYPE,',
'      :P20_EVENT_DESRIPTION,',
'      :P20_FREQUENCY,',
'      :P20_CITY,',
'      :P20_POST_CODE,',
'      :P20_COUNTRY,',
'      SYS_GUID(),',
'      SYS_GUID(),',
'      SYSDATE,',
'      SYSDATE',
'    );',
'',
'    l_message := ''Event "'' || :P20_EVENT_NAME || ''" created successfully.'';',
'  END IF;',
'',
'  COMMIT;',
'',
'  l_status := ''S'';',
'  UR_UTILS.add_alert(l_json_clob, l_message, l_status, NULL, NULL, l_json_clob);',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    l_status := ''E'';',
'    l_message := ''Operation failed: '' || SQLERRM;',
'    UR_UTILS.add_alert(l_json_clob, l_message, l_status, NULL, NULL, l_json_clob);',
'    :P0_ALERT_MESSAGE := l_json_clob;',
'    RAISE;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(12892093694500117)
,p_internal_uid=>23055493079494201
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12893917364500136)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_01=>'P0_ALERT_MESSAGE'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Data Updated!'
,p_internal_uid=>12893917364500136
);
wwv_flow_imp.component_end;
end;
/
