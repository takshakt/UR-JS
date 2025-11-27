prompt --application/pages/page_01070
begin
--   Manifest
--     PAGE: 01070
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
 p_id=>1070
,p_name=>'Hotel Price Override'
,p_alias=>'HOTEL-PRICE-OVERRIDE'
,p_page_mode=>'MODAL'
,p_step_title=>'Rate Adjustment'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function formatDate(dt) {',
'  return dt.toISOString().split(''T'')[0];',
'}',
'',
'flatpickr("#P1070_STAY_DATE_1", {',
'  mode: "range",',
'  dateFormat: "Y-m-d",',
'  allowInput: true,',
'  onClose: function(selectedDates) {',
'    if (selectedDates.length === 2) {',
'      const start = formatDate(selectedDates[0]);',
'      const end = formatDate(selectedDates[1]);',
'      apex.item("P1070_START_DATE").setValue(start);',
'      apex.item("P1070_END_DATE").setValue(end);',
'    }',
'  }',
'});',
''))
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(17846602092661938)
,p_plug_name=>'Hotel Price Override'
,p_title=>'Rate Adjustment'
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
 p_id=>wwv_flow_imp.id(17860632207763901)
,p_plug_name=>'Override Card - Main'
,p_parent_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(18058093034429302)
,p_plug_name=>'Main'
,p_parent_plug_id=>wwv_flow_imp.id(17860632207763901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_plug_new_grid_row=>false
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9642610130450630)
,p_plug_name=>'Date'
,p_parent_plug_id=>wwv_flow_imp.id(18058093034429302)
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
 p_id=>wwv_flow_imp.id(9642712267450631)
,p_plug_name=>'Data'
,p_parent_plug_id=>wwv_flow_imp.id(18058093034429302)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
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
 p_id=>wwv_flow_imp.id(17860790555763902)
,p_plug_name=>'Override Card - Audit'
,p_parent_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_location=>null
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(17853929595661975)
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
 p_id=>wwv_flow_imp.id(17854318106661976)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(17853929595661975)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(17855747567661982)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(17853929595661975)
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
 p_id=>wwv_flow_imp.id(17856126222661983)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(17853929595661975)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_condition=>'P1070_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(18275617574452005)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(17853929595661975)
,p_button_name=>'CREATE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P1070_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17846975876661939)
,p_name=>'P1070_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(17860632207763901)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17847303037661946)
,p_name=>'P1070_STAY_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9642610130450630)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_prompt=>'Stay Date'
,p_format_mask=>'YYYY-MM-DD'
,p_source=>'STAY_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
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
 p_id=>wwv_flow_imp.id(17847739877661950)
,p_name=>'P1070_HOTEL_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(17860632207763901)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17848150564661951)
,p_name=>'P1070_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9642712267450631)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_item_default=>'RETAIL'
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
 p_id=>wwv_flow_imp.id(17848519608661953)
,p_name=>'P1070_PRICE'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9642712267450631)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
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
 p_id=>wwv_flow_imp.id(17848968821661954)
,p_name=>'P1070_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(9642712267450631)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_prompt=>'Reason'
,p_source=>'REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR HOTEL PRICE OVERRIDE REASON'
,p_lov=>'.'||wwv_flow_imp.id(17929612222098296)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>120
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
 p_id=>wwv_flow_imp.id(17849329988661956)
,p_name=>'P1070_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(17860790555763902)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17849755275661958)
,p_name=>'P1070_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(17860790555763902)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17850192944661959)
,p_name=>'P1070_CREATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(17860790555763902)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_prompt=>'Created On'
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17850526202661961)
,p_name=>'P1070_UPDATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(17860790555763902)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_prompt=>'Updated On'
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(17978140659354998)
,p_name=>'P1070_HOTEL_LIST'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_prompt=>'Hotel'
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
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
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18058349315429305)
,p_name=>'P1070_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(17860632207763901)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_source=>'STAY_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(18058476608429306)
,p_name=>'P1070_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(17860632207763901)
,p_item_source_plug_id=>wwv_flow_imp.id(17846602092661938)
,p_source=>'STAY_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(17854477319661976)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(17854318106661976)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17855210253661980)
,p_event_id=>wwv_flow_imp.id(17854477319661976)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(18275251320452001)
,p_name=>'Delete Row'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(17855747567661982)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18275388913452002)
,p_event_id=>wwv_flow_imp.id(18275251320452001)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DELETE FROM UR_HOTEL_PRICE_OVERRIDE WHERE ID = HEXTORAW(:P1070_ID);',
'  IF SQL%ROWCOUNT = 0 THEN',
'    :P0_ALERT_MESSAGE := ''No record found with given ID: '' || :P1070_ID;',
'  ELSE',
'    COMMIT;',
'    :P0_ALERT_MESSAGE := ''Record deleted successfully'';',
'  END IF;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    :P0_ALERT_MESSAGE := ''Deletion failed: '' || SQLERRM;',
'    RAISE;',
'END;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18275447494452003)
,p_event_id=>wwv_flow_imp.id(18275251320452001)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'DELETE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9642895875450632)
,p_name=>'Clicked'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(18275617574452005)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9642928518450633)
,p_event_id=>wwv_flow_imp.id(9642895875450632)
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
'  l_payload CLOB;',
'',
'BEGIN',
'  l_payload := ''{',
'    "STAY_DATE":"''|| :P1070_STAY_DATE ||''",',
'    "HOTEL_ID":"''|| :P1070_HOTEL_LIST ||''",',
'    "TYPE":"''|| :P1070_TYPE ||''",',
'    "PRICE":''|| :P1070_PRICE ||'',',
'    "REASON":"''|| :P1070_REASON||''"',
'    }'';',
'',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''C'',',
'    p_table   => ''UR_HOTEL_PRICE_OVERRIDE'',',
'    p_payload => l_payload,',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'  DBMS_OUTPUT.PUT_LINE(''Insert status='' || l_status || '', message='' || l_message);',
'  :P0_ALERT_MESSAGE := ''l_message''; ',
'END;'))
,p_attribute_02=>'P1070_STAY_DATE,P1070_TYPE,P1070_PRICE,P1070_REASON,P1070_HOTEL_LIST'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17857308531661988)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(17846602092661938)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Hotel Price Override'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>17857308531661988
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(18058584590429307)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Custom process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status      VARCHAR2(10);',
'  l_message     CLOB;',
'  l_json_clob   CLOB := NULL;',
'  l_start_date  DATE;',
'  l_end_date    DATE;',
'  l_price       NUMBER;',
'  l_type        VARCHAR2(50);',
'  l_existing    NUMBER := 0;',
'  l_new_id      RAW(16);  -- moved here to main DECLARE section',
'BEGIN',
'  apex_debug.message(''ENTER SAVE_PRICE_OVERRIDE -- REQUEST=%s'', :REQUEST);',
'  apex_debug.message(''P1070_ID=%s, HOTEL_ID=%s, START=%s, END=%s, PRICE=%s'',',
'                     :P1070_ID, :P1070_HOTEL_ID, :P1070_START_DATE, :P1070_END_DATE, :P1070_PRICE);',
'',
'  -- Parse start date',
'  BEGIN',
'    l_start_date :=',
'      CASE',
'        WHEN REGEXP_LIKE(:P1070_START_DATE, ''^\d{4}-\d{2}-\d{2}$'') THEN TO_DATE(:P1070_START_DATE,''YYYY-MM-DD'')',
'        WHEN REGEXP_LIKE(:P1070_START_DATE, ''^\d{2}/\d{2}/\d{4}$'') THEN TO_DATE(:P1070_START_DATE,''MM/DD/YYYY'')',
'        WHEN REGEXP_LIKE(:P1070_START_DATE, ''^\d{2}-\w{3}-\d{4}$'') THEN TO_DATE(:P1070_START_DATE,''DD-MON-YYYY'')',
'        ELSE TO_DATE(:P1070_START_DATE)',
'      END;',
'    l_end_date :=',
'      CASE',
'        WHEN REGEXP_LIKE(:P1070_END_DATE, ''^\d{4}-\d{2}-\d{2}$'') THEN TO_DATE(:P1070_END_DATE,''YYYY-MM-DD'')',
'        WHEN REGEXP_LIKE(:P1070_END_DATE, ''^\d{2}/\d{2}/\d{4}$'') THEN TO_DATE(:P1070_END_DATE,''MM/DD/YYYY'')',
'        WHEN REGEXP_LIKE(:P1070_END_DATE, ''^\d{2}-\w{3}-\d{4}$'') THEN TO_DATE(:P1070_END_DATE,''DD-MON-YYYY'')',
'        ELSE TO_DATE(:P1070_END_DATE)',
'      END;',
'  EXCEPTION',
'    WHEN OTHERS THEN',
'      l_message := ''Invalid date format: '' || NVL(:P1070_START_DATE,''NULL'') || '' / '' || NVL(:P1070_END_DATE,''NULL'');',
'      apex_debug.message(l_message);',
'      RAISE_APPLICATION_ERROR(-20001, l_message);',
'  END;',
'',
'  -- Parse price',
'  BEGIN',
'    l_price := TO_NUMBER(:P1070_PRICE);',
'  EXCEPTION',
'    WHEN VALUE_ERROR THEN',
'      l_message := ''Invalid numeric value for price: '' || NVL(:P1070_PRICE,''NULL'');',
'      apex_debug.message(l_message);',
'      RAISE_APPLICATION_ERROR(-20002, l_message);',
'  END;',
'',
'  l_type := NVL(:P1070_TYPE,''Retail'');',
'',
'  --------------------------------------------------------------------',
'  -- Decide Insert vs Update:',
'  -- 1) If user submitted with REQUEST = ''CREATE'' -> force insert',
'  -- 2) Else, if P1070_ID present, verify it exists -> update',
'  -- 3) Otherwise -> insert',
'  --------------------------------------------------------------------',
'  IF :REQUEST = ''CREATE'' THEN',
'    l_existing := 0;',
'    apex_debug.message(''Mode: FORCE INSERT (REQUEST=CREATE)'');',
'  ELSIF :P1070_ID IS NOT NULL THEN',
'    BEGIN',
'      SELECT COUNT(*) INTO l_existing',
'      FROM UR_HOTEL_PRICE_OVERRIDE',
'      WHERE ID = HEXTORAW(:P1070_ID);',
'      apex_debug.message(''Existence check for ID %s -> %d'', :P1070_ID, l_existing);',
'    EXCEPTION',
'      WHEN OTHERS THEN',
'        apex_debug.message(''Error checking existence for ID %s: %s'', :P1070_ID, SQLERRM);',
'        l_existing := 0;',
'    END;',
'  ELSE',
'    l_existing := 0;',
'    apex_debug.message(''Mode: INSERT (no ID provided)'');',
'  END IF;',
'',
'  IF NVL(l_existing,0) > 0 THEN',
'    -- UPDATE',
'    UPDATE UR_HOTEL_PRICE_OVERRIDE',
'       SET STAY_DATE  = l_start_date,',
'           HOTEL_ID   = HEXTORAW(:P1070_HOTEL_ID),',
'           TYPE       = l_type,',
'           PRICE      = l_price,',
'           REASON     = :P1070_REASON,',
'           UPDATED_BY = SYS_GUID(),',
'           UPDATED_ON = SYSDATE',
'     WHERE ID = HEXTORAW(:P1070_ID);',
'    IF SQL%ROWCOUNT = 0 THEN',
'      RAISE_APPLICATION_ERROR(-20003, ''Update attempted but no row affected.'');',
'    END IF;',
'    l_message := ''Price override updated successfully.'';',
'    apex_debug.message(l_message);',
'  ELSE',
'    -- INSERT block wrapped in BEGIN ... EXCEPTION ... END to catch errors',
'    BEGIN',
'      l_new_id := SYS_GUID();',
'      INSERT INTO UR_HOTEL_PRICE_OVERRIDE (',
'        ID, STAY_DATE, HOTEL_ID, TYPE, PRICE, REASON,',
'        CREATED_BY, UPDATED_BY, CREATED_ON, UPDATED_ON, STATUS',
'      ) VALUES (',
'        l_new_id,',
'        l_start_date,',
'        HEXTORAW(:P1070_HOTEL_ID),',
'        l_type,',
'        l_price,',
'        :P1070_REASON,',
'        SYS_GUID(),    -- consider using actual user id instead of GUID if column is varchar',
'        SYS_GUID(),',
'        SYSDATE,',
'        SYSDATE,',
'        ''A''',
'      )',
'      RETURNING ID INTO l_new_id;',
'',
'      IF SQL%ROWCOUNT = 0 THEN',
'        apex_debug.message(''INSERT executed but SQL%ROWCOUNT = 0'');',
'        RAISE_APPLICATION_ERROR(-20004, ''Insert attempted but no row inserted (SQL%ROWCOUNT=0).'');',
'      END IF;',
'',
'      COMMIT;',
'      ',
'      l_message := ''Price override added successfully. New ID (hex): '' || RAWTOHEX(l_new_id);',
'      apex_debug.message(''INSERT OK: '' || l_message);',
'    EXCEPTION',
'      WHEN DUP_VAL_ON_INDEX THEN',
'        ROLLBACK;',
'        apex_debug.message(''DUP_VAL_ON_INDEX on insert. Check unique constraints.'');',
'        RAISE;',
'      WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_debug.message(''INSERT EXCEPTION: '' || SQLERRM);',
'        RAISE;',
'    END;',
'  END IF;',
'',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>18058584590429307
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17857748844661989)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>17857748844661989
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17856992206661987)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(17846602092661938)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Hotel Price Override'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>17856992206661987
);
wwv_flow_imp.component_end;
end;
/
