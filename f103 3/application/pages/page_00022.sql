prompt --application/pages/page_00022
begin
--   Manifest
--     PAGE: 00022
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
 p_id=>22
,p_name=>'Add Reservation'
,p_alias=>'ADD-RESERVATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Add Reservation'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14298129205960998)
,p_plug_name=>'Add Reservation'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
,p_query_type=>'TABLE'
,p_query_table=>'UR_HOTEL_RESERVATIONS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13908448937313949)
,p_plug_name=>'Reservation Exception'
,p_parent_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14351271198988323)
,p_plug_name=>'Exception Main Region'
,p_parent_plug_id=>wwv_flow_imp.id(13908448937313949)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14350815142988319)
,p_plug_name=>'Exception calendar'
,p_parent_plug_id=>wwv_flow_imp.id(14351271198988323)
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
 p_id=>wwv_flow_imp.id(14350922239988320)
,p_plug_name=>'Exception Details'
,p_parent_plug_id=>wwv_flow_imp.id(14351271198988323)
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
 p_id=>wwv_flow_imp.id(14480327591902801)
,p_plug_name=>'Reservation Details'
,p_parent_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13908252723313947)
,p_plug_name=>'Reservation Details'
,p_parent_plug_id=>wwv_flow_imp.id(14480327591902801)
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
 p_id=>wwv_flow_imp.id(13908370986313948)
,p_plug_name=>'Reservation Calendar'
,p_parent_plug_id=>wwv_flow_imp.id(14480327591902801)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14324340928961097)
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
 p_id=>wwv_flow_imp.id(14324729516961098)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(14324340928961097)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(14326163126961103)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(14324340928961097)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_execute_validations=>'N'
,p_confirm_message=>'&APP_TEXT$DELETE_MSG!RAW.'
,p_confirm_style=>'danger'
,p_button_condition=>'P22_RESERVATION_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(14326566131961104)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(14324340928961097)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_button_condition=>'P22_RESERVATION_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(14326984726961105)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(14324340928961097)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_button_condition=>'P22_RESERVATION_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12884645640327133)
,p_name=>'P22_ROOM_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(13908252723313947)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Room Type'
,p_source=>'ROOM_TYPE_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ROOM_TYPE_NAME AS d,',
'       ROOM_TYPE_ID AS r',
'FROM UR_HOTEL_ROOM_TYPES',
'WHERE HOTEL_ID = HEXTORAW(:P22_HOTEL_LIST)',
'ORDER BY ROOM_TYPE_NAME;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P0_HOTEL_ID,P22_HOTEL_LIST'
,p_ajax_items_to_submit=>'P0_HOTEL_ID,P22_HOTEL_LIST'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_colspan=>4
,p_grid_column=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14298523282960999)
,p_name=>'P22_RESERVATION_ID'
,p_source_data_type=>'VARCHAR2'
,p_is_primary_key=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_source=>'ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14298995419961006)
,p_name=>'P22_RES_NUMBER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13908252723313947)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Reservation Number'
,p_source=>'RES_NUMBER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>20
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
 p_id=>wwv_flow_imp.id(14299309074961007)
,p_name=>'P22_HOTEL_ID'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14299763733961009)
,p_name=>'P22_ARRIVAL_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13908370986313948)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Arrival Date'
,p_source=>'ARRIVAL_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_and_behavior', 'MONTH-PICKER:YEAR-PICKER',
  'days_outside_month', 'SELECTABLE',
  'display_as', 'INLINE',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_on', 'FOCUS',
  'show_time', 'N',
  'use_defaults', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14300127811961011)
,p_name=>'P22_NUMBER_OF_NIGHTS'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(13908252723313947)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'RNT'
,p_source=>'NUMBER_OF_NIGHTS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'UR BOOKING DAYS'
,p_lov=>'.'||wwv_flow_imp.id(14420744575511311)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_column=>5
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14300554353961012)
,p_name=>'P22_ROOMS_BOOKED'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(13908252723313947)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Rooms'
,p_source=>'ROOMS_BOOKED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'UR BOOKING DAYS'
,p_lov=>'.'||wwv_flow_imp.id(14420744575511311)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_column=>9
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14300956518961014)
,p_name=>'P22_TOTAL_BOOKING_VALUE'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(13908252723313947)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Total Booking Value'
,p_source=>'TOTAL_BOOKING_VALUE'
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
 p_id=>wwv_flow_imp.id(14301381401961015)
,p_name=>'P22_CHARGED_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(13908252723313947)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Charged'
,p_source=>'CHARGED_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large:margin-left-sm'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14302938386961021)
,p_name=>'P22_EXCEPTION_AMOUNT'
,p_source_data_type=>'NUMBER'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(14350922239988320)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Amount Charged'
,p_source=>'EXCEPTION_AMOUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_colspan=>10
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14303351053961023)
,p_name=>'P22_LATE_CANCELLATION_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14350922239988320)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Reason'
,p_source=>'EXCEPTION_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'UR CANCELLATION REASON'
,p_lov=>'.'||wwv_flow_imp.id(14497219589034529)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>10
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14303791480961024)
,p_name=>'P22_EXCEPTION_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(14350815142988319)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Exception Date'
,p_source=>'EXCEPTION_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_and_behavior', 'MONTH-PICKER:YEAR-PICKER',
  'days_outside_month', 'SELECTABLE',
  'display_as', 'INLINE',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_on', 'FOCUS',
  'show_time', 'N',
  'use_defaults', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14305312136961030)
,p_name=>'P22_APPROVED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(14350922239988320)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Approved By'
,p_source=>'APPROVED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_COMBOBOX'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISTINCT APPROVED_BY AS d,',
'                APPROVED_BY AS r',
'FROM UR_HOTEL_RESERVATIONS',
'WHERE APPROVED_BY IS NOT NULL',
'',
'UNION',
'',
'SELECT DISTINCT APPROVED_BY_MANUAL AS d,',
'                APPROVED_BY_MANUAL AS r',
'FROM UR_HOTEL_RESERVATIONS',
'WHERE APPROVED_BY_MANUAL IS NOT NULL',
'',
'',
'ORDER BY d',
''))
,p_lov_cascade_parent_items=>'P22_HOTEL_ID'
,p_ajax_items_to_submit=>'P22_HOTEL_ID'
,p_ajax_optimize_refresh=>'N'
,p_cSize=>30
,p_colspan=>10
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'fetch_on_search', 'N',
  'manual_entries_item', 'P22_APPROVED_BY_MANUAL',
  'match_type', 'CONTAINS',
  'min_chars', '0',
  'multi_selection', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14305710552961031)
,p_name=>'P22_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(14350922239988320)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Additional Notes'
,p_source=>'NOTES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>8
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14306138120961033)
,p_name=>'P22_RESERVATION_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(13908252723313947)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Reservation Type'
,p_source=>'RESERVATION_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'UR RESERVATION TYPES'
,p_lov=>'.'||wwv_flow_imp.id(14387135225367601)||'.'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large:margin-bottom-sm'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '3',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14350442025988315)
,p_name=>'P22_RESERVATION_EXCEPTION_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13908448937313949)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Reservation Exception Type'
,p_source=>'RESERVATION_EXCEPTION_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'UR RESERVSTION EXCEPTION TYPE'
,p_lov=>'.'||wwv_flow_imp.id(14433946398557917)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14351446707988325)
,p_name=>'P22_APPROVED_BY_MANUAL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(14350922239988320)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_source=>'APPROVED_BY_MANUAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(14352074087988331)
,p_name=>'P22_HOTEL_LIST'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_item_source_plug_id=>wwv_flow_imp.id(14298129205960998)
,p_prompt=>'Hotel Name'
,p_source=>'HOTEL_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT DISPLAY_VALUE, RETURN_VALUE FROM (',
'  SELECT HOTEL_NAME AS DISPLAY_VALUE,',
'         RAWTOHEX(ID) AS RETURN_VALUE,',
'         2 AS SORT_ORDER',
'  FROM UR_HOTELS',
'  WHERE NVL(ASSOCIATION_END_DATE, SYSDATE) >= SYSDATE',
'  UNION ALL',
'  SELECT ''-- Select Hotel --'' AS DISPLAY_VALUE,',
'         ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'' AS RETURN_VALUE,',
'         1 AS SORT_ORDER',
'  FROM DUAL',
')',
'ORDER BY SORT_ORDER, DISPLAY_VALUE;',
''))
,p_lov_cascade_parent_items=>'P0_HOTEL_ID'
,p_ajax_items_to_submit=>'P0_HOTEL_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(24718103961620801)
,p_validation_name=>'Test the Hotel list error'
,p_validation_sequence=>5
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'  RETURN :P22_HOTEL_LIST <> ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'';',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Please select a valid Hotel from the list.'
,p_associated_item=>wwv_flow_imp.id(14352074087988331)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(16523695214238632)
,p_validation_name=>'Rebate validation'
,p_validation_sequence=>20
,p_validation=>'P22_CHARGED_FLAG'
,p_validation2=>'Y'
,p_validation_type=>'ITEM_IN_VALIDATION_EQ_STRING2'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Please select the Charged checkbox before adding a Rebate.',
''))
,p_validation_condition=>':P22_RESERVATION_EXCEPTION_TYPE = ''RB'''
,p_validation_condition2=>'PLSQL'
,p_validation_condition_type=>'EXPRESSION'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14324881705961098)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(14324729516961098)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14325609534961101)
,p_event_id=>wwv_flow_imp.id(14324881705961098)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14351081558988321)
,p_name=>'Exception Type Changed'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P22_RESERVATION_EXCEPTION_TYPE'
,p_condition_element=>'P22_RESERVATION_EXCEPTION_TYPE'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14351162072988322)
,p_event_id=>wwv_flow_imp.id(14351081558988321)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(14351271198988323)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14351337805988324)
,p_event_id=>wwv_flow_imp.id(14351081558988321)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(14351271198988323)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12884766936327134)
,p_name=>'Hotel ID changed'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P22_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12884800178327135)
,p_event_id=>wwv_flow_imp.id(12884766936327134)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P22_HOTEL_LIST'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(27787372851806801)
,p_name=>'Populate room types'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P0_HOTEL_ID,P22_HOTEL_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(27787471961806802)
,p_event_id=>wwv_flow_imp.id(27787372851806801)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P22_ROOM_TYPE'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14328147276961109)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'CREATE,SAVE,DELETE'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>14328147276961109
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14327365185961107)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(14298129205960998)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Add Reservation'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>14327365185961107
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14327744336961108)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_region_id=>wwv_flow_imp.id(14298129205960998)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Add Reservation'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_process_error_message=>'"Reservation Number already exists for this hotel. Please enter a unique Reservation Number."'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>':P22_HOTEL_LIST <> ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'''
,p_process_when_type=>'EXPRESSION'
,p_process_when2=>'PLSQL'
,p_process_success_message=>'Data Updated!'
,p_internal_uid=>14327744336961108
);
wwv_flow_imp.component_end;
end;
/
