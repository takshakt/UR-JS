prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
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
 p_id=>13
,p_name=>'Hotel Room Types'
,p_alias=>'TYPES'
,p_page_mode=>'MODAL'
,p_step_title=>'Hotel Room Types'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11938136421552792)
,p_plug_name=>'Types'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'UR_HOTEL_ROOM_TYPES'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14725513869617529)
,p_plug_name=>'Description'
,p_parent_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>4
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14725642147617530)
,p_plug_name=>'Room'
,p_parent_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>8
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14725777004617531)
,p_plug_name=>'Suppliment'
,p_parent_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11945415012552820)
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
 p_id=>wwv_flow_imp.id(11945860917552822)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(11945415012552820)
,p_button_name=>'CANCEL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11947285491552826)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(11945415012552820)
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
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11948038265552828)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(11945415012552820)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11938514515552793)
,p_name=>'P13_ROOM_TYPE_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14725642147617530)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_source=>'ROOM_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11938904690552795)
,p_name=>'P13_HOTEL_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_prompt=>'Hotel Name'
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT display_value,',
'       return_value',
'FROM (',
'--   SELECT ''-- Define New --'' AS display_value,',
'--          LPAD(''0'', 32, ''0'') AS return_value,  -- 32-char hex string',
'--          0                  AS sort_order',
'--   FROM dual',
'  ',
'',
'--   UNION ALL',
'',
'  SELECT NVL(HOTEL_NAME, ''Name'') AS display_value,',
'         RAWTOHEX(ID)            AS return_value,',
'         1                       AS sort_order',
'  FROM UR_HOTELS',
'  WHERE nvl(ASSOCIATION_END_DATE,sysdate) >= sysdate',
'',
')',
'ORDER BY sort_order, display_value;',
''))
,p_cHeight=>1
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11939396005552797)
,p_name=>'P13_ROOM_TYPE_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14725642147617530)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_prompt=>'Room Type Name'
,p_source=>'ROOM_TYPE_NAME'
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
 p_id=>wwv_flow_imp.id(11939789725552798)
,p_name=>'P13_MAX_OCCUPANCY'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14725642147617530)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_prompt=>'Max Occupancy'
,p_source=>'MAX_OCCUPANCY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>'STATIC2:1;1,2;2,3;3,4;4,5;5,6;6,7;7,8;8,9;9,10;10'
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>255
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'Y',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11940193466552800)
,p_name=>'P13_BED_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14725642147617530)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_prompt=>'Bed Type'
,p_source=>'BED_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR BED TYPES'
,p_lov=>'.'||wwv_flow_imp.id(16203835239910193)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>32
,p_cMaxlength=>50
,p_begin_on_new_line=>'N'
,p_colspan=>4
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
 p_id=>wwv_flow_imp.id(11940585607552802)
,p_name=>'P13_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14725513869617529)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_prompt=>'Description'
,p_source=>'DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>32
,p_cMaxlength=>250
,p_cHeight=>5
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'N',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11940991861552803)
,p_name=>'P13_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(14725642147617530)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11941342498552805)
,p_name=>'P13_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(14725642147617530)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11941729461552806)
,p_name=>'P13_CREATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(14725642147617530)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_source=>'CREATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11942198583552808)
,p_name=>'P13_UPDATED_ON'
,p_source_data_type=>'DATE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(14725642147617530)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_source=>'UPDATED_ON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(16205434558926301)
,p_name=>'P13_PRICE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(14725642147617530)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_prompt=>unistr('Price (\00A3)')
,p_source=>'PRICE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '99999',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(16205529221926302)
,p_name=>'P13_SUPPLIMENT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14725777004617531)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_prompt=>'Supplement Type'
,p_source=>'SUPPLIMENT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR ROOM SUPPLIMENT TYPES'
,p_lov=>'.'||wwv_flow_imp.id(16213380408982704)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_cMaxlength=>3
,p_colspan=>4
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
 p_id=>wwv_flow_imp.id(16205681625926303)
,p_name=>'P13_SUPPLIMENT_PRICE_MIN'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14725777004617531)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_prompt=>unistr('Supplement Price Min (\00A3)')
,p_source=>'SUPPLIEMENT_PRICE_MIN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(16205757388926304)
,p_name=>'P13_SUPPLIMENT_PRICE_MAX'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14725777004617531)
,p_item_source_plug_id=>wwv_flow_imp.id(11938136421552792)
,p_prompt=>unistr('Supplement Price Max (\00A3)')
,p_source=>'SUPPLIMENT_PRICE_MAX'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11945952171552822)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11945860917552822)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11946701335552824)
,p_event_id=>wwv_flow_imp.id(11945952171552822)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12186019719821531)
,p_name=>'New'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P13_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12186112523821532)
,p_event_id=>wwv_flow_imp.id(12186019719821531)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_HOTEL_ID'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12186254203821533)
,p_name=>'New_1'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P13_ROOM_TYPE_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12186689435821537)
,p_event_id=>wwv_flow_imp.id(12186254203821533)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_ROOM_TYPE_NAME,P13_MAX_OCCUPANCY,P13_BED_TYPE,P13_DESCRIPTION'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14107144302783044)
,p_name=>'delete row'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11947285491552826)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14107210270783045)
,p_event_id=>wwv_flow_imp.id(14107144302783044)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  DELETE FROM UR_HOTEL_ROOM_TYPES WHERE ROOM_TYPE_ID = :P13_ROOM_TYPE_ID;',
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
,p_attribute_02=>'P13_ROOM_TYPE_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(16388030126516913)
,p_event_id=>wwv_flow_imp.id(14107144302783044)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14107304835783046)
,p_event_id=>wwv_flow_imp.id(14107144302783044)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'Delete'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14724988162617523)
,p_name=>'Page Load'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14725099581617524)
,p_event_id=>wwv_flow_imp.id(14724988162617523)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_SUPPLIMENT_PRICE_MIN,P13_SUPPLIMENT_PRICE_MAX'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14725125031617525)
,p_name=>'Change Suppliment Type'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P13_SUPPLIMENT_TYPE'
,p_condition_element=>'P13_SUPPLIMENT_TYPE'
,p_triggering_condition_type=>'NOT_EQUALS'
,p_triggering_expression=>'PR'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14725298078617526)
,p_event_id=>wwv_flow_imp.id(14725125031617525)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_SUPPLIMENT_PRICE_MIN'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14725472229617528)
,p_event_id=>wwv_flow_imp.id(14725125031617525)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_SUPPLIMENT_PRICE_MIN,P13_SUPPLIMENT_PRICE_MAX'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14725372590617527)
,p_event_id=>wwv_flow_imp.id(14725125031617525)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_SUPPLIMENT_PRICE_MAX'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11948857426552831)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Process form Types'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status    VARCHAR2(10);',
'  l_message   CLOB;',
'  l_json_clob CLOB := NULL;',
'BEGIN',
'  IF :P13_ROOM_TYPE_ID IS NOT NULL THEN',
'    -- Update existing room type',
'    UPDATE UR_HOTEL_ROOM_TYPES',
'    SET HOTEL_ID     = :P13_HOTEL_ID,',
'        ROOM_TYPE_NAME = :P13_ROOM_TYPE_NAME,',
'        MAX_OCCUPANCY = :P13_MAX_OCCUPANCY,',
'        BED_TYPE     = :P13_BED_TYPE,',
'        DESCRIPTION  = :P13_DESCRIPTION,',
'        PRICE        = :P13_PRICE,',
'        SUPPLIMENT_TYPE       = :P13_SUPPLIMENT_TYPE,',
'        SUPPLIEMENT_PRICE_MIN = :P13_SUPPLIMENT_PRICE_MIN,',
'        SUPPLIMENT_PRICE_MAX  = :P13_SUPPLIMENT_PRICE_MAX,',
'        UPDATED_BY   = SYS_GUID(), -- Ideally replace with actual user ID',
'        UPDATED_ON   = SYSDATE',
'    WHERE ROOM_TYPE_ID = :P13_ROOM_TYPE_ID;',
'    ',
'    l_message := ''Room type "'' || :P13_ROOM_TYPE_NAME || ''" updated successfully.'';',
'  ELSE',
'    -- Insert new room type',
'    INSERT INTO UR_HOTEL_ROOM_TYPES (',
'      ROOM_TYPE_ID,',
'      HOTEL_ID,',
'      ROOM_TYPE_NAME,',
'      MAX_OCCUPANCY,',
'      BED_TYPE,',
'      DESCRIPTION,',
'      PRICE,',
'      SUPPLIMENT_TYPE,',
'      SUPPLIEMENT_PRICE_MIN,',
'      SUPPLIMENT_PRICE_MAX,',
'      CREATED_BY,',
'      UPDATED_BY,',
'      CREATED_ON,',
'      UPDATED_ON',
'    ) VALUES (',
'      SYS_GUID(),',
'      :P13_HOTEL_ID,',
'      :P13_ROOM_TYPE_NAME,',
'      :P13_MAX_OCCUPANCY,',
'      :P13_BED_TYPE,',
'      :P13_DESCRIPTION,',
'      :P13_PRICE,',
'      :P13_SUPPLIMENT_TYPE,',
'      :P13_SUPPLIMENT_PRICE_MIN,',
'      :P13_SUPPLIMENT_PRICE_MAX,',
'      SYS_GUID(),',
'      SYS_GUID(),',
'      SYSDATE,',
'      SYSDATE',
'    );',
'    ',
'    l_message := ''Room type "'' || :P13_ROOM_TYPE_NAME || ''" created successfully.'';',
'  END IF;',
'  ',
'  COMMIT;',
'  l_status := ''S'';',
'  UR_UTILS.add_alert(l_json_clob, l_message, l_status, NULL, NULL, l_json_clob);',
'  ',
'  :P0_ALERT_MESSAGE := l_json_clob;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    l_status := ''E'';',
'    l_message := ''Operation failed: '' || SQLERRM;',
'    UR_UTILS.add_alert(l_json_clob, l_message, l_status, NULL, NULL, l_json_clob);',
'    :P0_ALERT_MESSAGE := l_json_clob;',
'    RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(11948038265552828)
,p_internal_uid=>11948857426552831
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11949220300552832)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_process_success_message=>'Data Updated!'
,p_internal_uid=>11949220300552832
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11948411066552830)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(11938136421552792)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Types MD'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>11948411066552830
);
wwv_flow_imp.component_end;
end;
/
