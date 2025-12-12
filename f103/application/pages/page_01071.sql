prompt --application/pages/page_01071
begin
--   Manifest
--     PAGE: 01071
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
 p_id=>1071
,p_name=>'Hotel Price Override'
,p_alias=>'HOTEL-PRICE-OVERRIDE1'
,p_page_mode=>'MODAL'
,p_step_title=>'Hotel Price Override'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(19372553698831060)
,p_plug_name=>'Hotel Price Override'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'UR_HOTEL_PRICE_OVERRIDE'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9643032506450634)
,p_plug_name=>'Date'
,p_parent_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>90
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9643155250450635)
,p_plug_name=>'Data'
,p_parent_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_plug_new_grid_row=>false
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(19380557351831097)
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
 p_id=>wwv_flow_imp.id(19380940697831099)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(19380557351831097)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(19382330119831105)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(19380557351831097)
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
,p_button_condition=>'P1071_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(19396447782941765)
,p_button_sequence=>50
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
,p_button_condition=>'P1070_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(19382708740831106)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(19380557351831097)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_button_condition=>'P1071_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(19383188284831107)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(19380557351831097)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_button_condition=>'P1071_STATUS'
,p_button_condition2=>'A'
,p_button_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19372891571831061)
,p_name=>'P1071_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19373200094831067)
,p_name=>'P1071_STAY_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9643032506450634)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Stay Date'
,p_source=>'STAY_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>1609122147107268652
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
 p_id=>wwv_flow_imp.id(19373638951831070)
,p_name=>'P1071_HOTEL_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19374093932831071)
,p_name=>'P1071_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9643155250450635)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Type'
,p_source=>'TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'UR HOTEL PRICE OVERRIDE TYPE'
,p_lov=>'.'||wwv_flow_imp.id(17934818910111446)||'.'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19374468968831073)
,p_name=>'P1071_PRICE'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9643155250450635)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Price'
,p_source=>'PRICE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19374812780831074)
,p_name=>'P1071_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9643155250450635)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Reason'
,p_source=>'REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_ONE'
,p_named_lov=>'UR HOTEL PRICE OVERRIDE REASON'
,p_lov=>'.'||wwv_flow_imp.id(17929612222098296)||'.'
,p_cSize=>32
,p_cMaxlength=>120
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'fetch_on_search', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19375249509831076)
,p_name=>'P1071_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>16
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19375680125831077)
,p_name=>'P1071_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>16
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19376032442831079)
,p_name=>'P1071_CREATED_ON'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Created On'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19376469037831081)
,p_name=>'P1071_UPDATED_ON'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Updated On'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19376863629831082)
,p_name=>'P1071_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(9643155250450635)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Active/Inactive'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_display_when=>'P1071_STATUS'
,p_display_when2=>'A'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'off_label', 'Inactive',
  'off_value', 'I',
  'on_label', 'Active',
  'on_value', 'A',
  'use_defaults', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19388649560844878)
,p_name=>'P1071_HOTEL_LIST'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Hotel'
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
 p_id=>wwv_flow_imp.id(27536381518203302)
,p_name=>'P1071_COMMENTS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(9643155250450635)
,p_item_source_plug_id=>wwv_flow_imp.id(19372553698831060)
,p_prompt=>'Comment'
,p_source=>'COMMENTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>32
,p_cMaxlength=>150
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(19381059239831099)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(19380940697831099)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(19381894801831103)
,p_event_id=>wwv_flow_imp.id(19381059239831099)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9643222486450636)
,p_name=>'Change'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1071_HOTEL_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9643349870450637)
,p_event_id=>wwv_flow_imp.id(9643222486450636)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1071_HOTEL_ID'
,p_attribute_01=>'PLSQL_EXPRESSION'
,p_attribute_04=>':P1071_HOTEL_LIST'
,p_attribute_07=>'P1071_HOTEL_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9643401828450638)
,p_name=>'Click'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(19382330119831105)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9643542598450639)
,p_event_id=>wwv_flow_imp.id(9643401828450638)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DELETE FROM UR_HOTEL_PRICE_OVERRIDE WHERE ID = HEXTORAW(:P1071_ID);',
'  IF SQL%ROWCOUNT = 0 THEN',
'    :P0_ALERT_MESSAGE := ''No record found with given ID: '' || :P1071_ID;',
'  ELSE',
'    COMMIT;',
'    :P0_ALERT_MESSAGE := ''Record deleted successfully'';',
'  END IF;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    :P0_ALERT_MESSAGE := ''Deletion failed: '' || SQLERRM;',
'    RAISE;',
'END;'))
,p_attribute_02=>'P1071_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9643682760450640)
,p_event_id=>wwv_flow_imp.id(9643401828450638)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9643779581450641)
,p_event_id=>wwv_flow_imp.id(9643401828450638)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(25769852743805630)
,p_name=>'New'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1071_STATUS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(25769971296805631)
,p_event_id=>wwv_flow_imp.id(25769852743805630)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(10);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'BEGIN',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_HOTEL_PRICE_OVERRIDE'',',
'    p_payload => ''{"ID":"''|| :P1071_ID || ''","STATUS":"'' || :P1071_STATUS || ''"}'',',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'--   DBMS_OUTPUT.put_line(''Status: '' || l_status);',
'--   DBMS_OUTPUT.put_line(''Message (metadata JSON): '' || l_message);',
'',
'',
'',
' -- :P29_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P1071_ID,P1071_STATUS'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(25769780789805629)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Process to update and create data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'    DECLARE',
'    v_old_price  NUMBER;',
'    v_old_status VARCHAR2(1);',
'    v_type varchar2(100);',
'     v_reason varchar2(2000);',
'    v_comments     VARCHAR2(2000); ',
'BEGIN',
'    -- Only run on UPDATE (ID exists)',
'    IF :P1071_ID IS NOT NULL THEN',
'',
'        SELECT price, status, type, reason, comments',
'        INTO   v_old_price, v_old_status,v_type, v_reason, v_comments',
'        FROM   ur_hotel_price_override',
'        WHERE  id = hextoraw(:P1071_ID);',
'',
'        ----------------------------------------------------------------------',
unistr('        -- CASE 1: Status turned OFF (A \2192 I) \2192 Update only, DML will execute'),
'        ----------------------------------------------------------------------',
'        IF v_old_status = ''A'' AND :P1071_STATUS = ''I'' THEN',
'            RETURN; -- let APEX DML handle it',
'        END IF;',
'    ----------------------------------------------------------------------',
unistr('    -- CASE 2: Status = A and any key field changed \2192 Versioning'),
'    ----------------------------------------------------------------------',
'    IF v_old_status = ''A''',
'       AND :P1071_STATUS = ''A''',
'       AND (',
'                v_old_price <> :P1071_PRICE ',
'                or v_type <> :P1071_TYPE',
'                or NVL(v_reason, ''X'') <> NVL(:P1071_REASON, ''X'')',
'                or v_comments <> :P1071_COMMENTS',
'           --NVL(v_old_price, -99999) <> NVL(:P1071_PRICE, -99999)',
'         --OR NVL(:P1071_TYPE, ''X'') <> NVL(:P1071_TYPE, ''X'')',
'         --OR NVL(:P1071_REASON, ''X'') <> NVL(:P1071_REASON, ''X'')',
'           )',
'    THEN',
'',
'        -- 1. Inactivate old row',
'        UPDATE ur_hotel_price_override',
'        SET status = ''I''',
'        WHERE id = hextoraw(:P1071_ID);',
'',
'        -- 2. Insert new row with changes',
'        INSERT INTO ur_hotel_price_override (',
'            hotel_id,',
'            price,',
'            status,',
'            stay_date,',
'            type,',
'            reason,',
'            comments',
'        ) VALUES (',
'            hextoraw(:P1071_HOTEL_LIST),',
'            :P1071_PRICE,',
'            ''A'',',
'            :P1071_STAY_DATE,',
'            :P1071_TYPE,',
'            :P1071_REASON,',
'            :P1071_COMMENTS',
'',
'        );',
'',
'        RETURN;',
'    END IF;',
'    END IF;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        NULL; -- allows new-row creation',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(19383188284831107)
,p_internal_uid=>25769780789805629
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(19383910428831112)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(19372553698831060)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Hotel Price Override'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'N'
,p_attribute_06=>'N'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(19382708740831106)
,p_internal_uid=>19383910428831112
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(19384391920831113)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'SAVE,DELETE,CREATE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>19384391920831113
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(19383580912831110)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(19372553698831060)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Hotel Price Override'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>19383580912831110
);
wwv_flow_imp.component_end;
end;
/
