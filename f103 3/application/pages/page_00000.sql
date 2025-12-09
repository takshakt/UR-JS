prompt --application/pages/page_00000
begin
--   Manifest
--     PAGE: 00000
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
 p_id=>0
,p_name=>'Global Page'
,p_step_title=>'Global Page'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'D'
,p_page_component_map=>'14'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(25697469516364507)
,p_plug_name=>'Hotel Selector'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12881528989327102)
,p_name=>'P0_ALERT_MESSAGE'
,p_item_sequence=>30
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(25696812640364501)
,p_name=>'P0_HOTEL_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(25697469516364507)
,p_item_default=>'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'
,p_prompt=>'Hotel Name'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISPLAY_VALUE, RETURN_VALUE FROM (',
'  SELECT NVL(HOTEL_NAME, ''Name'') AS DISPLAY_VALUE,',
'         RAWTOHEX(ID) AS RETURN_VALUE,',
'         2 AS SORT_ORDER',
'  FROM UR_HOTELS',
'  WHERE NVL(ASSOCIATION_END_DATE, SYSDATE) >= SYSDATE',
'  UNION ALL',
'  SELECT ''-- Show all data --'' AS DISPLAY_VALUE,',
'         ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'' AS RETURN_VALUE,',
'         1 AS SORT_ORDER',
'  FROM DUAL',
')',
'ORDER BY SORT_ORDER, DISPLAY_VALUE'))
,p_cHeight=>1
,p_display_when=>wwv_flow_string.join(wwv_flow_t_varchar2(
'INSTR('':1026:17:1023:9:19:1075:1001:1002:29:1010:28:1601:33:1006:24:15:167:27:32:'', '':''||:APP_PAGE_ID||'':'') > 0',
'-- removinge strategy page 1050 from the global hotel'))
,p_display_when2=>'PLSQL'
,p_display_when_type=>'EXPRESSION'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--large:t-Form-fieldContainer--noPadding:t-Form-fieldContainer--normalDisplay'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(28720602057061102)
,p_name=>'P0_USERNAME'
,p_item_sequence=>40
,p_use_cache_before_default=>'NO'
,p_item_default=>'&APP_USER.'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12881614238327103)
,p_name=>'Changed'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P0_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12881784055327104)
,p_event_id=>wwv_flow_imp.id(12881614238327103)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P0_ALERT_MESSAGE");  // get the string from hidden page item',
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
 p_id=>wwv_flow_imp.id(9903648984138615)
,p_name=>'Page load'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(25696949470364502)
,p_name=>'Connect Hotel ID '
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P0_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(25697070030364503)
,p_event_id=>wwv_flow_imp.id(25696949470364502)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
':G_HOTEL_ID := :P0_HOTEL_ID;',
''))
,p_attribute_02=>'P0_HOTEL_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp.component_end;
end;
/
