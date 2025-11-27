prompt --application/pages/page_01612
begin
--   Manifest
--     PAGE: 01612
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
 p_id=>1612
,p_name=>'Create User Form'
,p_alias=>'CREATE-USER-FORM'
,p_page_mode=>'MODAL'
,p_step_title=>'Create User'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15443841271521389)
,p_plug_name=>'Create User'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'UR_USERS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15456016556521442)
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
 p_id=>wwv_flow_imp.id(15456431773521444)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(15456016556521442)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15457879133521448)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(15456016556521442)
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
,p_button_condition=>'P1612_USER_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15458244336521450)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(15456016556521442)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P1612_USER_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(15458641482521451)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(15456016556521442)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P1612_USER_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15038567204055048)
,p_name=>'P1612_ALERT_JSON'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15444298595521391)
,p_name=>'P1612_USER_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_source=>'USER_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15444624736521396)
,p_name=>'P1612_FIRST_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'First Name'
,p_source=>'FIRST_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
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
 p_id=>wwv_flow_imp.id(15445034719521398)
,p_name=>'P1612_LAST_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'Last Name'
,p_source=>'LAST_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
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
 p_id=>wwv_flow_imp.id(15445436858521399)
,p_name=>'P1612_EMAIL'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'Email'
,p_source=>'EMAIL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>150
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'EMAIL',
  'text_case', 'LOWER',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15445830815521401)
,p_name=>'P1612_CONTACT_NUMBER'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'Contact Number'
,p_source=>'CONTACT_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15446228227521402)
,p_name=>'P1612_USER_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'User Type'
,p_source=>'USER_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR USER TYPE'
,p_lov=>'.'||wwv_flow_imp.id(15587918992732346)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>1609122147107268652
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
 p_id=>wwv_flow_imp.id(15446656430521404)
,p_name=>'P1612_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR USER STATUS'
,p_lov=>'.'||wwv_flow_imp.id(15589373391739364)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
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
 p_id=>wwv_flow_imp.id(15447064760521405)
,p_name=>'P1612_START_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'Start Date'
,p_source=>'START_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15447494586521407)
,p_name=>'P1612_END_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'End Date'
,p_source=>'END_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15447855780521409)
,p_name=>'P1612_LOGIN_METHOD'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'Login Method'
,p_source=>'LOGIN_METHOD'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:SSO;SSO,USERPASS;USERPASS'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15448282803521411)
,p_name=>'P1612_PASSWORD_HASH'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_source=>'PASSWORD_HASH'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15450285344521419)
,p_name=>'P1612_USER_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'User Name'
,p_source=>'USER_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
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
 p_id=>wwv_flow_imp.id(15450663877521420)
,p_name=>'P1612_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_item_source_plug_id=>wwv_flow_imp.id(15443841271521389)
,p_prompt=>'Special Notes'
,p_source=>'NOTES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15456589990521444)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15456431773521444)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15457379970521447)
,p_event_id=>wwv_flow_imp.id(15456589990521444)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15038662192055049)
,p_name=>'Alert JSON '
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1612_ALERT_JSON'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15038763810055050)
,p_event_id=>wwv_flow_imp.id(15038662192055049)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var alerts = $v("P1612_ALERT_JSON");',
'if (alerts) {',
'    showAlertToastr(JSON.parse(alerts));',
'}',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(15536289141851606)
,p_name=>'Delete Row'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(15457879133521448)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15536303279851607)
,p_event_id=>wwv_flow_imp.id(15536289141851606)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'DELETE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15536184986851605)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Delete Process'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_count NUMBER;',
'BEGIN',
'    DELETE FROM UR_USERS',
'     WHERE USER_ID = :P1612_USER_ID',
'     RETURNING 1 INTO l_count;',
'',
'    COMMIT;',
'',
'    IF l_count = 1 THEN',
'        APEX_UTIL.SET_SESSION_STATE(''P1612_ALERT_JSON'', ''{"status":"success","msg":"User deleted"}'');',
'    ELSE',
'        APEX_UTIL.SET_SESSION_STATE(''P1612_ALERT_JSON'', ''{"status":"error","msg":"User not found"}'');',
'    END IF;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(15457879133521448)
,p_internal_uid=>15536184986851605
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15459804694521455)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>15459804694521455
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15459042974521452)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(15443841271521389)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Create User Form'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>15459042974521452
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15459453335521453)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Process form Create User Form'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_user_id ur_users.user_id%TYPE;',
'BEGIN',
'  BEGIN',
'    SELECT user_id',
'      INTO l_user_id',
'      FROM ur_users',
'     WHERE user_name = :P1612_USER_NAME;',
'  EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'      l_user_id := NULL; ',
'  END;',
'',
'  IF l_user_id IS NOT NULL THEN',
'    app_user_ctx.set_current_user_id(l_user_id);',
'  ELSE',
'    app_user_ctx.clear_current_user_id; ',
'  END IF;',
'',
'  DECLARE',
'    v_user_name VARCHAR2(100) := :P1612_USER_NAME;',
'    v_email     VARCHAR2(200) := :P1612_EMAIL;',
'  BEGIN',
'    -- Skip user creation and role assignment API calls',
'',
'    -- Upsert into UR_USERS table',
'    MERGE INTO UR_USERS u',
'    USING (',
'        SELECT :P1612_USER_ID        AS USER_ID,',
'               :P1612_FIRST_NAME     AS FIRST_NAME,',
'               :P1612_LAST_NAME      AS LAST_NAME,',
'               v_user_name           AS USER_NAME,',
'               v_email               AS EMAIL,',
'               NVL(:P1612_USER_TYPE, ''READER'') AS USER_TYPE,',
'               :P1612_STATUS         AS STATUS,',
'               :P1612_CONTACT_NUMBER AS CONTACT_NUMBER,',
'               :P1612_LOGIN_METHOD   AS LOGIN_METHOD,',
'               :P1612_START_DATE     AS START_DATE,',
'               :P1612_END_DATE       AS END_DATE,',
'               :P1612_NOTES          AS NOTES,',
'               :P1612_PASSWORD_HASH  AS PASSWORD_HASH',
'        FROM dual',
'    ) src',
'    ON (u.USER_ID = src.USER_ID)',
'    WHEN MATCHED THEN',
'      UPDATE SET',
'        u.FIRST_NAME     = src.FIRST_NAME,',
'        u.LAST_NAME      = src.LAST_NAME,',
'        u.USER_NAME      = src.USER_NAME,',
'        u.EMAIL          = src.EMAIL,',
'        u.USER_TYPE      = src.USER_TYPE,',
'        u.STATUS         = src.STATUS,',
'        u.CONTACT_NUMBER = src.CONTACT_NUMBER,',
'        u.LOGIN_METHOD   = src.LOGIN_METHOD,',
'        u.START_DATE     = src.START_DATE,',
'        u.END_DATE       = src.END_DATE,',
'        u.NOTES          = src.NOTES,',
'        u.PASSWORD_HASH  = src.PASSWORD_HASH',
'    WHEN NOT MATCHED THEN',
'      INSERT (',
'          USER_ID,',
'          FIRST_NAME,',
'          LAST_NAME,',
'          USER_NAME,',
'          EMAIL,',
'          USER_TYPE,',
'          STATUS,',
'          CONTACT_NUMBER,',
'          LOGIN_METHOD,',
'          START_DATE,',
'          END_DATE,',
'          NOTES,',
'          PASSWORD_HASH',
'      )',
'      VALUES (',
'          src.USER_ID,',
'          src.FIRST_NAME,',
'          src.LAST_NAME,',
'          src.USER_NAME,',
'          src.EMAIL,',
'          src.USER_TYPE,',
'          src.STATUS,',
'          src.CONTACT_NUMBER,',
'          src.LOGIN_METHOD,',
'          src.START_DATE,',
'          src.END_DATE,',
'          src.NOTES,',
'          src.PASSWORD_HASH',
'      );',
'',
'    COMMIT;',
'    app_user_ctx.clear_current_user_id;',
'  EXCEPTION',
'    WHEN OTHERS THEN',
'      app_user_ctx.clear_current_user_id;',
'      RAISE;',
'  END;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    ROLLBACK;',
'    RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(15458641482521451)
,p_internal_uid=>15459453335521453
);
wwv_flow_imp.component_end;
end;
/
