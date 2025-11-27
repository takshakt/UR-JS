prompt --application/pages/page_00012
begin
--   Manifest
--     PAGE: 00012
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
 p_id=>12
,p_name=>'Hotel Contact'
,p_alias=>'CONTACT'
,p_page_mode=>'MODAL'
,p_step_title=>'Hotel Contact'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11917991869486065)
,p_plug_name=>'Contact'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'UR_CONTACTS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11926730982486099)
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
 p_id=>wwv_flow_imp.id(16388102828516914)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(11926730982486099)
,p_button_name=>'Close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(14106912065783042)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(11926730982486099)
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
,p_button_condition=>'P12_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(16521661688238612)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(11926730982486099)
,p_button_name=>'UPDATE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P12_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11929381495486108)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(11926730982486099)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_button_condition=>'P12_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11918316212486067)
,p_name=>'P12_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11918700619486069)
,p_name=>'P12_HOTEL_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_default=>'SELECT HOTEL_NAME AS D, ID AS RETURN FROM UR_HOTELS WHERE ID = :P12_HOTEL_ID'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Hotel Name'
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select hotel_name as d, rawtohex(id) as return',
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
 p_id=>wwv_flow_imp.id(11919187393486070)
,p_name=>'P12_CONTACT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_prompt=>'Contact Name'
,p_source=>'CONTACT_NAME'
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
 p_id=>wwv_flow_imp.id(11919597630486072)
,p_name=>'P12_POSITION_TITLE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_prompt=>'Position Title'
,p_source=>'POSITION_TITLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_begin_on_new_line=>'N'
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
 p_id=>wwv_flow_imp.id(11919917554486073)
,p_name=>'P12_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_prompt=>'Email'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>150
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'EMAIL',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11920359083486075)
,p_name=>'P12_PHONE_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_prompt=>'Phone Number'
,p_source=>'PHONE_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEL',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11920768782486076)
,p_name=>'P12_CONTACT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_prompt=>'Contact Type'
,p_source=>'CONTACT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR CONTACT TYPES'
,p_lov=>'.'||wwv_flow_imp.id(12370700856411856)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
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
 p_id=>wwv_flow_imp.id(11921153477486078)
,p_name=>'P12_PRIMARY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_prompt=>'Primary'
,p_source=>'PRIMARY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:Yes;Y,No;N'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11921502309486079)
,p_name=>'P12_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11921912301486081)
,p_name=>'P12_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11922709457486084)
,p_name=>'P12_UPDATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12184345710821514)
,p_name=>'P12_CONTACT_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(16522110327238617)
,p_name=>'P12_CREATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_item_source_plug_id=>wwv_flow_imp.id(11917991869486065)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12184120707821512)
,p_name=>'Populate Hotel Details'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P12_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12184207135821513)
,p_event_id=>wwv_flow_imp.id(12184120707821512)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_CREATED_ON'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT HOTEL_NAME, STAR_RATING, ADDRESS_ID, CONTACT_ID, OPENING_DATE, CURRENCY_CODE, ASSOCIATION_START_DATE, ASSOCIATION_END_DATE, ',
'ASSOCIATED_USER_ID, ALGORITHM_ID, IMAGE_NAME, IMG_TYPE',
'FROM UR_HOTELS ',
'WHERE ID = :P12_HOTEL_ID'))
,p_attribute_07=>'P12_HOTEL_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12184445403821515)
,p_event_id=>wwv_flow_imp.id(12184120707821512)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_CONTACT_ID'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CONTACT_ID',
'FROM UR_HOTELS',
'WHERE ID = :P12_HOTEL_ID'))
,p_attribute_07=>'P12_HOTEL_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12184551013821516)
,p_event_id=>wwv_flow_imp.id(12184120707821512)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P12_CONTACT_NAME,P12_POSITION_TITLE,P12_EMAIL,P12_PHONE_NUMBER,P12_CONTACT_TYPE,P12_PRIMARY'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT CONTACT_NAME,',
'       POSITION_TITLE,',
'       EMAIL,',
'       PHONE_NUMBER,',
'       CONTACT_TYPE,',
'       PRIMARY',
'FROM UR_CONTACTS',
'WHERE ID = :P12_CONTACT_ID'))
,p_attribute_07=>'P12_CONTACT_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(16387189069516904)
,p_name=>'Delete Row'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(14106912065783042)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16387213816516905)
,p_event_id=>wwv_flow_imp.id(16387189069516904)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DELETE FROM UR_CONTACTS WHERE ID = :P12_ID;',
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
,p_attribute_02=>'P12_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16387347376516906)
,p_event_id=>wwv_flow_imp.id(16387189069516904)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16387798061516910)
,p_event_id=>wwv_flow_imp.id(16387189069516904)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(16388298539516915)
,p_name=>'New'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(16388102828516914)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16388398001516916)
,p_event_id=>wwv_flow_imp.id(16388298539516915)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(16521761772238613)
,p_name=>'UPDATE ROW'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(16521661688238612)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16521864800238614)
,p_event_id=>wwv_flow_imp.id(16521761772238613)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  IF :P12_ID IS NOT NULL THEN',
'  ',
'    IF :P12_PRIMARY = ''Y'' THEN',
'      UPDATE UR_CONTACTS',
'         SET "PRIMARY" = ''N''',
'       WHERE HOTEL_ID = hextoraw(:P12_HOTEL_ID)',
'         AND ID != hextoraw(:P12_ID)',
'         AND "PRIMARY" = ''Y'';',
'    END IF;',
'    ',
'    UPDATE UR_CONTACTS',
'       SET HOTEL_ID       = hextoraw(:P12_HOTEL_ID),',
'           CONTACT_NAME   = :P12_CONTACT_NAME,',
'           POSITION_TITLE = :P12_POSITION_TITLE,',
'           EMAIL          = :P12_EMAIL,',
'           PHONE_NUMBER   = :P12_PHONE_NUMBER,',
'           CONTACT_TYPE   = :P12_CONTACT_TYPE,',
'           "PRIMARY"      = :P12_PRIMARY,',
'           UPDATED_BY     = hextoraw(:P12_UPDATED_BY),',
'           UPDATED_ON     = SYSDATE',
'     WHERE ID = hextoraw(:P12_ID);',
'',
'    IF SQL%ROWCOUNT = 0 THEN',
'      :P0_ALERT_MESSAGE := ''No record found with ID = '' || :P12_ID;',
'    ELSE',
'      :P0_ALERT_MESSAGE := ''Record updated successfully'';',
'      COMMIT;',
'    END IF;',
'',
'  ELSE',
'    :P0_ALERT_MESSAGE := ''Contact ID is required for update'';',
'  END IF;',
'',
'EXCEPTION',
'  WHEN DUP_VAL_ON_INDEX THEN',
'    :P0_ALERT_MESSAGE := ''Only one PRIMARY contact allowed per hotel.'';',
'        ROLLBACK;',
'  WHEN OTHERS THEN',
'    :P0_ALERT_MESSAGE := ''Update failed: '' || SQLERRM;',
'    RAISE;',
'        ROLLBACK;',
'END;',
''))
,p_attribute_02=>'P12_ID,P12_HOTEL_ID,P12_CONTACT_ID,P12_CONTACT_NAME,P12_POSITION_TITLE,P12_EMAIL,P12_PHONE_NUMBER,P12_CONTACT_TYPE,P12_PRIMARY,P12_CREATED_BY,P12_UPDATED_BY,P12_UPDATED_ON,P12_CREATED_ON'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16521920800238615)
,p_event_id=>wwv_flow_imp.id(16521761772238613)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16522015840238616)
,p_event_id=>wwv_flow_imp.id(16521761772238613)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11930135114486110)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(11917991869486065)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Contact'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_process_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Only one primary contact is allowed per hotel.',
''))
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>11930135114486110
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11930531028486112)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Data Updated!'
,p_internal_uid=>11930531028486112
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11929768731486109)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(11917991869486065)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Contact MD'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>11929768731486109
);
wwv_flow_imp.component_end;
end;
/
