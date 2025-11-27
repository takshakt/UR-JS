prompt --application/pages/page_01024
begin
--   Manifest
--     PAGE: 01024
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
 p_id=>1024
,p_name=>'Address'
,p_alias=>'ADDRESS'
,p_step_title=>'Address'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>'#APP_FILES#Interactive report#MIN#.css'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(10790839781558215)
,p_plug_name=>'Address'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ID,',
'       STREET_ADDRESS,',
'       CITY,',
'       COUNTY,',
'       POST_CODE,',
'       COUNTRY,',
'       CREATED_BY,',
'       UPDATED_BY,',
'       CREATED_ON,',
'       UPDATED_ON,',
'       HOTEL_ID,',
'       PRIMARY_ADDRESS,',
'       -- HTML for edit button, adjust page number & param name as needed',
'       ''<a href="f?p=&APP_ID.:1024:&SESSION.::NO::P1024_ID:'' || ID || ''" ',
'           title="Edit">',
'           &#9998;',
'        </a>'' AS EDIT',
'  FROM UR_ADDRESSES',
'--WHERE HOTEL_ID = :P1024_NEW'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P1024_NEW'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(10849902168822106)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'VPALKAR'
,p_internal_uid=>10849902168822106
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850097065822107)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Id'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10851054459822117)
,p_db_column_name=>'HOTEL_ID'
,p_display_order=>20
,p_column_identifier=>'K'
,p_column_label=>'Hotel Id'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850106633822108)
,p_db_column_name=>'STREET_ADDRESS'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Street Address'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850284067822109)
,p_db_column_name=>'CITY'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'City'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850341428822110)
,p_db_column_name=>'COUNTY'
,p_display_order=>50
,p_column_identifier=>'D'
,p_column_label=>'County'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850460825822111)
,p_db_column_name=>'POST_CODE'
,p_display_order=>60
,p_column_identifier=>'E'
,p_column_label=>'Post Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850565366822112)
,p_db_column_name=>'COUNTRY'
,p_display_order=>70
,p_column_identifier=>'F'
,p_column_label=>'Country'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850642039822113)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850711220822114)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>90
,p_column_identifier=>'H'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850878402822115)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10850909289822116)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>110
,p_column_identifier=>'J'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(10851107256822118)
,p_db_column_name=>'PRIMARY_ADDRESS'
,p_display_order=>130
,p_column_identifier=>'L'
,p_column_label=>'Primary Address'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(11251659186832409)
,p_db_column_name=>'EDIT'
,p_display_order=>140
,p_column_identifier=>'M'
,p_column_label=>'Edit'
,p_column_link=>'f?p=&APP_ID.:1031:&SESSION.::&DEBUG.::P1031_ID:#ID#'
,p_column_linktext=>'<span role="img" aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(11044017427623209)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'110441'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ID:STREET_ADDRESS:CITY:COUNTY:POST_CODE:COUNTRY:CREATED_BY:UPDATED_BY:CREATED_ON:UPDATED_ON:HOTEL_ID:PRIMARY_ADDRESS'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(10752335802523893)
,p_button_sequence=>30
,p_button_name=>'New_Room_type'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'New Room Type'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11251787146832410)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(10790839781558215)
,p_button_name=>'Create'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:1031:&SESSION.::&DEBUG.:::'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(21435007538823249)
,p_name=>'P1024_HOTEL_LIST'
,p_item_sequence=>10
,p_prompt=>'Hotel List'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT',
'  nvl(Hotel_NAME,''Name'') as Name,',
'ID as ID',
'FROM',
'UR_HOTELS',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(21435067532823250)
,p_name=>'P1024_NEW'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10763771127523949)
,p_name=>'New'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_display_when_type=>'NEVER'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10760553905523938)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1024_HOTEL_LIST'
,p_condition_element=>'P1024_HOTEL_LIST'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10761064406523940)
,p_event_id=>wwv_flow_imp.id(10760553905523938)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>':P1024_NEW := :P1024_HOTEL_LIST;'
,p_attribute_02=>'P1024_HOTEL_LIST'
,p_attribute_03=>'P1024_NEW'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10761905300523943)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1024_HOTEL_SELECT'
,p_condition_element=>'P1024_HOTEL_SELECT'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10762413067523945)
,p_event_id=>wwv_flow_imp.id(10761905300523943)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--:P1024_HOTEL_SELECT',
':P1024_HOTEL_SELECT := :P1024_HOTEL_ID_T;',
''))
,p_attribute_02=>'P1024_HOTEL_SELECT'
,p_attribute_03=>'P1024_HOTEL_ID_T'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10762803272523946)
,p_name=>'New_2'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1024_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10763320883523948)
,p_event_id=>wwv_flow_imp.id(10762803272523946)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1024_CURRENCY_CODE'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'1'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10759688030523936)
,p_name=>'New_2'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1024_HOTEL_SELECT'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10760186015523937)
,p_event_id=>wwv_flow_imp.id(10759688030523936)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P1024_HOTEL_SELECT := :P1024_HOTEL_ID_T;',
''))
,p_attribute_02=>'P1024_HOTEL_SELECT'
,p_attribute_03=>'P1024_HOTEL_ID_T'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp.component_end;
end;
/
