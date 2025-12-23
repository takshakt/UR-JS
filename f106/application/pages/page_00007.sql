prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>25186177142438240
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_page.create_page(
 p_id=>7
,p_name=>'Hotel Address'
,p_alias=>'ADDRESSFROM'
,p_page_mode=>'MODAL'
,p_step_title=>'Hotel Address'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11874001523677264)
,p_plug_name=>'Check'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'UR_ADDRESSES'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11882784523677305)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11883193697677306)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(11882784523677305)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11884519928677311)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(11882784523677305)
,p_button_name=>'DELETE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_confirm_message=>'&APP_TEXT$DELETE_MSG!RAW.'
,p_confirm_style=>'danger'
,p_button_condition=>'P7_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11884992522677312)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(11882784523677305)
,p_button_name=>'UPDATE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P7_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11885359081677314)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(11882784523677305)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_button_condition=>'P7_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11874327146677267)
,p_name=>'P7_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11874719112677271)
,p_name=>'P7_STREET_ADDRESS'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_prompt=>'Street Address'
,p_source=>'STREET_ADDRESS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>200
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11875159631677274)
,p_name=>'P7_CITY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_prompt=>'City'
,p_source=>'CITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11875529148677275)
,p_name=>'P7_COUNTY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_prompt=>'County'
,p_source=>'COUNTY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11875926254677277)
,p_name=>'P7_POST_CODE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_prompt=>'Post Code'
,p_source=>'POST_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11876377479677278)
,p_name=>'P7_COUNTRY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_prompt=>'Country'
,p_source=>'COUNTRY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11876702688677280)
,p_name=>'P7_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11877123943677281)
,p_name=>'P7_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11877575629677283)
,p_name=>'P7_CREATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11877940043677286)
,p_name=>'P7_UPDATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11878337251677288)
,p_name=>'P7_HOTEL_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_prompt=>'Hotel Name'
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select hotel_name as d, rawtohex(id) as return ',
'from ur_hotels',
'WHERE nvl(ASSOCIATION_END_DATE,sysdate) >= sysdate',
'UNION ALL',
'select ''-- Select Hotel --'' as d, ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'' as return from dual',
'ORDER BY d'))
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11878776391677289)
,p_name=>'P7_PRIMARY_ADDRESS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_prompt=>'Primary Address'
,p_source=>'PRIMARY_ADDRESS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:Yes;Y,No;N'
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12186718299821538)
,p_name=>'P7_ADDRESS_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_item_source_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_prompt=>'Hotel Address'
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT STREET_ADDRESS || '', '' || CITY || '', '' || POST_CODE AS display_value,',
'       RAWTOHEX(ID) AS return_value',
'FROM UR_ADDRESSES',
'WHERE HOTEL_ID = HEXTORAW(:P7_HOTEL_ID)',
'ORDER BY display_value',
''))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- Define New --'
,p_lov_cascade_parent_items=>'P7_HOTEL_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12356760462267918)
,p_name=>'P31_HOTEL_ID'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(11874001523677264)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11883292424677306)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11883193697677306)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11884050109677310)
,p_event_id=>wwv_flow_imp.id(11883292424677306)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12186810643821539)
,p_name=>'Populate Data'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12356565790267916)
,p_event_id=>wwv_flow_imp.id(12186810643821539)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// pass the currently selected hotel hex into the dialog',
'var hotelHex = $v(''P7_HOTEL_ID'') || '''';',
'apex.navigation.dialog(',
'  ''f?p=&APP_ID.:31:&SESSION.::NO:31:P31_HOTEL_ID:'' + encodeURIComponent(hotelHex),',
'  { title: ''Define New Address'' }',
');',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12186980107821540)
,p_event_id=>wwv_flow_imp.id(12186810643821539)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_STREET_ADDRESS,P7_CITY,P7_COUNTY,P7_POST_CODE,P7_COUNTRY,P7_PRIMARY_ADDRESS'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT STREET_ADDRESS,',
'       CITY,',
'       COUNTY,',
'       POST_CODE,',
'       COUNTRY,',
'       PRIMARY_ADDRESS',
'FROM UR_ADDRESSES',
'WHERE :P7_HOTEL_ID IS NOT NULL',
'  AND REGEXP_LIKE(:P7_HOTEL_ID, ''^[0-9A-F]{32}$'')   -- must be 32 hex chars',
'  AND HOTEL_ID = HEXTORAW(:P7_HOTEL_ID)',
''))
,p_attribute_07=>'P7_HOTEL_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12187027464821541)
,p_name=>'New_1'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_ADDRESS_ID'
,p_condition_element=>'P7_ADDRESS_ID'
,p_triggering_condition_type=>'NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12187152503821542)
,p_event_id=>wwv_flow_imp.id(12187027464821541)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_STREET_ADDRESS,P7_CITY,P7_COUNTY,P7_POST_CODE,P7_COUNTRY,P7_PRIMARY_ADDRESS'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT STREET_ADDRESS,',
'       CITY,',
'       COUNTY,',
'       POST_CODE,',
'       COUNTRY,',
'       PRIMARY_ADDRESS',
'FROM UR_ADDRESSES',
'WHERE ID = HEXTORAW(:P7_ADDRESS_ID)',
'  AND :P7_ADDRESS_ID IS NOT NULL',
'  AND :P7_ADDRESS_ID != ''DEFINE_NEW''',
''))
,p_attribute_07=>'P7_HOTEL_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12357011243267921)
,p_name=>'Alert Template'
,p_event_sequence=>40
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12357189501267922)
,p_event_id=>wwv_flow_imp.id(12357011243267921)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'main alert js'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function runP7AlertMessage() {',
'  var messagesJson = $v("P7_ALERT_MESSAGE"); ',
'',
'  if (messagesJson) {',
'    try {',
'      var parsed = JSON.parse(messagesJson);',
'',
'      if (Array.isArray(parsed)) {',
'        showAlertToastr(parsed);',
'      } else if (parsed && typeof parsed === ''object'') {',
'        showAlertToastr([parsed]);',
'      } else {',
'        showAlertToastr(messagesJson);',
'      }',
'    } catch (e) {',
'      showAlertToastr(messagesJson);',
'    }',
'  }',
'}',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12546055627179934)
,p_name=>'Generate post-code'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_POST_CODE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12546192992179935)
,p_event_id=>wwv_flow_imp.id(12546055627179934)
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
'    -- fallback: postcode parts (outcode = district, incode = inward)',
'    ''result.outcode'',',
'    ''result.incode''',
'  );',
'BEGIN',
'  -- clear outputs first',
'  :P7_CITY := NULL;',
'  :P7_COUNTRY := NULL;',
'',
'  l_pc := TRIM(:P7_POST_CODE);',
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
'  -- log raw response (first 32k) for debug',
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
'    :P7_CITY := l_city;',
'    :P7_COUNTRY := l_country;',
'    APEX_DEBUG.MESSAGE(''Final chosen city: '' || NVL(l_city,''<null>'') || '' | country: '' || NVL(l_country,''<null>''));',
'',
'  ELSE',
'    -- no match or not found',
'    :P7_CITY := NULL;',
'    :P7_COUNTRY := NULL;',
'    APEX_DEBUG.MESSAGE(''Postcodes.io returned status '' || NVL(TO_CHAR(l_status_n),''<null>'') || '' for '' || :P20_POST_CODE);',
'  END IF;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    :P7_CITY := NULL;',
'    :P7_COUNTRY := NULL;',
'    APEX_DEBUG.MESSAGE(''Postcode lookup error: '' || SQLERRM);',
'    IF l_response IS NOT NULL THEN',
'      APEX_DEBUG.MESSAGE(''Raw response (error): '' || SUBSTR(l_response,1,32000));',
'    END IF;',
'END;',
''))
,p_attribute_02=>'P7_POST_CODE'
,p_attribute_03=>'P7_CITY,P7_COUNTRY'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(16387591972516908)
,p_name=>'Delete row'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11884519928677311)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16387815841516911)
,p_event_id=>wwv_flow_imp.id(16387591972516908)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DELETE FROM UR_ADDRESSES WHERE ID = :P7_ID;',
'',
'  IF SQL%ROWCOUNT = 0 THEN',
'    :P0_ALERT_MESSAGE := ''No record found with ID = '' || :P12_ID;',
'  ELSE',
'    :P0_ALERT_MESSAGE := ''Record deleted successfully'';',
'    COMMIT;',
'  END IF;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    :P0_ALERT_MESSAGE := ''Deletion failed: '' || SQLERRM;',
'    RAISE;',
'END;'))
,p_attribute_02=>'P7_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16387968322516912)
,p_event_id=>wwv_flow_imp.id(16387591972516908)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16387617759516909)
,p_event_id=>wwv_flow_imp.id(16387591972516908)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(16522294214238618)
,p_name=>'Update Row'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11884992522677312)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16522374123238619)
,p_event_id=>wwv_flow_imp.id(16522294214238618)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  IF :P7_ID IS NOT NULL THEN',
'    UPDATE UR_ADDRESSES',
'    SET HOTEL_ID         = hextoraw(:P7_HOTEL_ID),',
'        STREET_ADDRESS   = :P7_STREET_ADDRESS,',
'        CITY             = :P7_CITY,',
'        COUNTY           = :P7_COUNTY,',
'        POST_CODE        = :P7_POST_CODE,',
'        COUNTRY          = :P7_COUNTRY,',
'        PRIMARY_ADDRESS  = :P7_PRIMARY_ADDRESS,',
'        UPDATED_BY       = hextoraw(:P7_UPDATED_BY),',
'        UPDATED_ON       = SYSDATE',
'    WHERE ID = hextoraw(:P7_ID);',
'    ',
'    IF SQL%ROWCOUNT = 0 THEN',
'      :P0_ALERT_MESSAGE := ''No address found with ADDRESS_ID = '' || :P7_ID;',
'    ELSE',
'      :P0_ALERT_MESSAGE := ''Address updated successfully'';',
'      COMMIT;',
'    END IF;',
'  ELSE',
'    :P0_ALERT_MESSAGE := ''Address ID is required for update'';',
'  END IF;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    :P0_ALERT_MESSAGE := ''Update failed: '' || SQLERRM;',
'    RAISE;',
'END;'))
,p_attribute_02=>'P7_ID,P7_HOTEL_ID,P7_ADDRESS_ID,P7_STREET_ADDRESS,P7_CITY,P7_COUNTY,P7_POST_CODE,P7_COUNTRY,P7_CREATED_BY,P7_UPDATED_BY,P7_CREATED_ON,P7_UPDATED_ON,P7_PRIMARY_ADDRESS,P31_HOTEL_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16522521901238621)
,p_event_id=>wwv_flow_imp.id(16522294214238618)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16522417329238620)
,p_event_id=>wwv_flow_imp.id(16522294214238618)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(18157615537285642)
,p_name=>'New'
,p_event_sequence=>80
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(11874001523677264)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18157749472285643)
,p_event_id=>wwv_flow_imp.id(18157615537285642)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(11874001523677264)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11886059355677316)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(11874001523677264)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Check'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>11886059355677316
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11886481874677317)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Data Updated!'
,p_internal_uid=>11886481874677317
);
wwv_flow_imp.component_end;
end;
/
