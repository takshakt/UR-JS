prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
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
 p_id=>10
,p_name=>'Hotel Cluster'
,p_alias=>'HOTEL-GROUP'
,p_page_mode=>'MODAL'
,p_step_title=>'Hotel Cluster'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11893883553293004)
,p_plug_name=>'Hotel Group MD'
,p_region_name=>'my_region_static_id'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'UR_HOTEL_GROUPS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11902580596293040)
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
 p_id=>wwv_flow_imp.id(12546407555179938)
,p_button_sequence=>160
,p_button_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'New'
,p_button_redirect_url=>'f?p=&APP_ID.:12:&SESSION.::&DEBUG.:::'
,p_grid_new_row=>'Y'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11902958853293041)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(11902580596293040)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11904328851293046)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(11902580596293040)
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
,p_button_condition=>'P10_GROUP_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11904788706293047)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(11902580596293040)
,p_button_name=>'Update'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P10_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11905127509293049)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(11902580596293040)
,p_button_name=>'SAVE_BTN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_button_condition=>'P10_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11894293850293008)
,p_name=>'P10_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11895055986293011)
,p_name=>'P10_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_prompt=>'Description'
,p_source=>'DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>250
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
 p_id=>wwv_flow_imp.id(11895412958293013)
,p_name=>'P10_ADDRESS_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_source=>'ADDRESS_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11895825460293015)
,p_name=>'P10_CONTACT_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_source=>'CONTACT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11896145742293016)
,p_name=>'P10_ASSOCIATION_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_prompt=>'Association Start Date'
,p_source=>'ASSOCIATION_START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_and_behavior', 'MONTH-PICKER:YEAR-PICKER',
  'days_outside_month', 'VISIBLE',
  'display_as', 'INLINE',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_on', 'FOCUS',
  'show_time', 'N',
  'use_defaults', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11896553027293018)
,p_name=>'P10_ASSOCIATION_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_prompt=>'Association End Date'
,p_source=>'ASSOCIATION_END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_and_behavior', 'MONTH-PICKER:YEAR-PICKER',
  'days_outside_month', 'VISIBLE',
  'display_as', 'INLINE',
  'max_date', 'NONE',
  'min_date', 'ITEM',
  'min_item', 'P10_ASSOCIATION_START_DATE',
  'multiple_months', 'N',
  'show_on', 'FOCUS',
  'show_time', 'N',
  'use_defaults', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11896926904293019)
,p_name=>'P10_ASSOCIATED_EMP_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_source=>'ASSOCIATED_EMP_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11897366773293021)
,p_name=>'P10_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11897717211293022)
,p_name=>'P10_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11898180959293024)
,p_name=>'P10_CREATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11898507126293025)
,p_name=>'P10_UPDATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12184771891821518)
,p_name=>'P10_GROUP_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_item_source_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_prompt=>'Hotel Cluster'
,p_source=>'GROUP_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
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
 p_id=>wwv_flow_imp.id(12355630679267907)
,p_name=>'P10_CHECKSUM'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(11893883553293004)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11903080793293041)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11902958853293041)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11903898388293044)
,p_event_id=>wwv_flow_imp.id(11903080793293041)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12184837235821519)
,p_name=>'POPULATE DATA'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_GROUP_ID'
,p_condition_element=>'P10_GROUP_ID'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'DEFINE NEW'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12356041111267911)
,p_event_id=>wwv_flow_imp.id(12184837235821519)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Clear fields for new entry',
'$s("P10_ID", ""); // primary key',
'$s("P10_GROUP_ID", "");',
'$s("P10_DESCRIPTION", "");',
'$s("P10_ADDRESS_ID", "");',
'$s("P10_CONTACT_ID", "");',
'$s("P10_ASSOCIATION_START_DATE", "");',
'$s("P10_ASSOCIATION_END_DATE", "");',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12184914311821520)
,p_event_id=>wwv_flow_imp.id(12184837235821519)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P10_ADDRESS_ID,P10_CONTACT_ID,P10_DESCRIPTION,P10_ASSOCIATION_START_DATE,P10_ASSOCIATION_END_DATE,P10_ASSOCIATED_EMP_ID'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT GROUP_NAME,',
'       ADDRESS_ID,',
'       CONTACT_ID,',
'       DESCRIPTION,',
'       ASSOCIATION_START_DATE,',
'       ASSOCIATION_END_DATE,',
'       ASSOCIATED_EMP_ID',
'FROM UR_HOTEL_GROUPS',
'WHERE ID = :P10_GROUP_ID'))
,p_attribute_07=>'P10_GROUP_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12546261667179936)
,p_name=>'for new contact creation'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_CONTACT_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12546325431179937)
,p_event_id=>wwv_flow_imp.id(12546261667179936)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($v("P10_CONTACT_ID") === "-1") {',
unistr('    // clear LOV value so it doesn\2019t stay on -1'),
'    $s("P10_CONTACT_ID", "");',
'',
'    // simple redirect to Dialog B',
'    var url = "f?p=&APP_ID.:12:&SESSION.::NO:::"; ',
'    apex.navigation.redirect(url);',
'}',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12546563342179939)
,p_name=>'Dialog Closed'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(11893883553293004)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12546760379179941)
,p_event_id=>wwv_flow_imp.id(12546563342179939)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(11893883553293004)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12546607193179940)
,p_event_id=>wwv_flow_imp.id(12546563342179939)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(11893883553293004)
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Assuming your page item is P1_MY_LOV',
'//apex.item("P10_CONTACT_ID").setValue(null); // reset value',
'//apex.item("P10_CONTACT_ID").refresh();      // reload LOV',
'// Replace "my_region_static_id" with your region''s Static ID',
'apex.region("my_region_static_id").refresh();',
'',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12546897122179942)
,p_name=>'for new address creation'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_ADDRESS_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12546985543179943)
,p_event_id=>wwv_flow_imp.id(12546897122179942)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($v("P10_ADDRESS_ID") === "-1") {',
unistr('    // clear LOV value so it doesn\2019t stay on -1'),
'    $s("P10_ADDRESS_ID", "");',
'',
'    // simple redirect to Dialog B',
'    var url = "f?p=&APP_ID.:7:&SESSION.::NO:::"; ',
'    apex.navigation.redirect(url);',
'}',
'',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(16520653499238602)
,p_name=>'Delete Row'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11904328851293046)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16520703103238603)
,p_event_id=>wwv_flow_imp.id(16520653499238602)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DELETE FROM UR_HOTEL_GROUPS WHERE ID = :P10_ID;',
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
,p_attribute_02=>'P10_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16520971493238605)
,p_event_id=>wwv_flow_imp.id(16520653499238602)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16520893983238604)
,p_event_id=>wwv_flow_imp.id(16520653499238602)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(16521204561238608)
,p_name=>'Update Row'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11904788706293047)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16521376664238609)
,p_event_id=>wwv_flow_imp.id(16521204561238608)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  IF :P10_ID IS NOT NULL AND :P10_GROUP_ID IS NOT NULL THEN',
'    UPDATE UR_HOTEL_GROUPS',
'    SET GROUP_NAME             = :P10_GROUP_ID,',
'        DESCRIPTION            = :P10_DESCRIPTION,',
'        ADDRESS_ID             = hextoraw(:P10_ADDRESS_ID),',
'        CONTACT_ID             = hextoraw(:P10_CONTACT_ID),',
'        ASSOCIATION_START_DATE = :P10_ASSOCIATION_START_DATE,',
'        ASSOCIATION_END_DATE   = :P10_ASSOCIATION_END_DATE,',
'        ASSOCIATED_EMP_ID      = hextoraw(:P10_ASSOCIATED_EMP_ID),',
'        UPDATED_BY             = hextoraw(:P10_UPDATED_BY),',
'        UPDATED_ON             = SYSDATE',
'    WHERE ID = hextoraw(:P10_ID);',
'',
'    IF SQL%ROWCOUNT = 0 THEN',
'      :P0_ALERT_MESSAGE := ''No record found with ID = '' || :P10_ID;',
'    ELSE',
'      :P0_ALERT_MESSAGE := ''Record updated successfully'';',
'      COMMIT;',
'    END IF;',
'  ELSE',
'    :P0_ALERT_MESSAGE := ''Required fields missing: ID and Group Name must not be null'';',
'  END IF;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    :P0_ALERT_MESSAGE := ''Update failed: '' || SQLERRM;',
'    RAISE;',
'END;'))
,p_attribute_02=>'P10_ID,P10_GROUP_ID,P10_ADDRESS_ID,P10_CONTACT_ID,P10_DESCRIPTION,P10_ASSOCIATION_START_DATE,P10_ASSOCIATION_END_DATE,P10_ASSOCIATED_EMP_ID,P10_CREATED_BY,P10_UPDATED_BY,P10_CREATED_ON,P10_UPDATED_ON'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16521453920238610)
,p_event_id=>wwv_flow_imp.id(16521204561238608)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16521528438238611)
,p_event_id=>wwv_flow_imp.id(16521204561238608)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11905982888293051)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(11893883553293004)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Hotel Group MD'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE,SAVE_BTN'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>11905982888293051
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11906398616293053)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Data Updated!'
,p_internal_uid=>11906398616293053
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11905503959293050)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(11893883553293004)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Hotel Group MD'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>11905503959293050
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12356294782267913)
,p_process_sequence=>70
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'   IF :P10_GROUP_ID = ''DEFINE_NEW'' OR :P10_ID IS NULL THEN',
'      INSERT INTO UR_HOTEL_GROUPS (',
'         ID,',
'         GROUP_NAME,',
'         DESCRIPTION,',
'         ADDRESS_ID,',
'         CONTACT_ID,',
'         ASSOCIATION_START_DATE,',
'         ASSOCIATION_END_DATE',
'      ) VALUES (',
'         SYS_GUID(),',
'         :P10_GROUP_ID,',
'         :P10_DESCRIPTION,',
'         HEXTORAW(:P10_ADDRESS_ID),',
'         HEXTORAW(:P10_CONTACT_ID),',
'         :P10_ASSOCIATION_START_DATE,',
'         :P10_ASSOCIATION_END_DATE',
'      )',
'      RETURNING RAWTOHEX(ID) INTO :P10_ID;',
'',
'   ELSE',
'      UPDATE UR_HOTEL_GROUPS',
'      SET GROUP_NAME = :P10_GROUP_ID,',
'          DESCRIPTION = :P10_DESCRIPTION,',
'          ADDRESS_ID = HEXTORAW(:P10_ADDRESS_ID),',
'          CONTACT_ID = HEXTORAW(:P10_CONTACT_ID),',
'          ASSOCIATION_START_DATE = :P10_ASSOCIATION_START_DATE,',
'          ASSOCIATION_END_DATE   = :P10_ASSOCIATION_END_DATE',
'      WHERE ID = HEXTORAW(:P10_ID);',
'   END IF;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(11905127509293049)
,p_process_success_message=>'HOTEL GROUP SAVED SUCCESFULLY'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>12356294782267913
);
wwv_flow_imp.component_end;
end;
/
