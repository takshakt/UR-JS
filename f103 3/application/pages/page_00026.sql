prompt --application/pages/page_00026
begin
--   Manifest
--     PAGE: 00026
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
 p_id=>26
,p_name=>'Strategy Data'
,p_alias=>'STRATEGY-DATA'
,p_page_mode=>'MODAL'
,p_step_title=>'Strategy Data'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>2100407606326202693
,p_page_template_options=>'#DEFAULT#'
,p_dialog_height=>'800'
,p_dialog_width=>'1200'
,p_dialog_resizable=>'Y'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(19350144592156984)
,p_plug_name=>'Strategy Data'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>'SELECT * FROM TABLE(ALGO_EVALUATOR_PKG.EVALUATE(:P26_STRATEGY,:P26_STRATEGY_VERSION, NULL))'
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P26_HOTEL_LIST,P26_STRATEGY,P26_STRATEGY_VERSION'
,p_prn_page_header=>'Strategy Data'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(19351416810156997)
,p_name=>'STAY_DATE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STAY_DATE'
,p_data_type=>'DATE'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Stay Date'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>20
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(19352464377157002)
,p_name=>'EVALUATED_PRICE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EVALUATED_PRICE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Evaluated Price'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(19353459177157006)
,p_name=>'APPLIED_RULE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APPLIED_RULE'
,p_data_type=>'CLOB'
,p_session_state_data_type=>'CLOB'
,p_is_query_only=>true
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Applied Rule'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_stretch=>'A'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'Y',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_item_height=>3
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(19439853177368708)
,p_name=>'ALGO_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ALGO_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Strategy'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>10
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>255
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(19439934974368709)
,p_name=>'STAY_DAY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DAY_OF_WEEK'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Stay Day'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>30
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>3
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(19350613565156988)
,p_internal_uid=>19350613565156988
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SET'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_enable_mail_download=>true
,p_fixed_header=>'NONE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(19351089531156991)
,p_interactive_grid_id=>wwv_flow_imp.id(19350613565156988)
,p_static_id=>'193511'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(19351248184156992)
,p_report_id=>wwv_flow_imp.id(19351089531156991)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9053155642632)
,p_view_id=>wwv_flow_imp.id(19351248184156992)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(19439853177368708)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>234.312
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(9992651642638)
,p_view_id=>wwv_flow_imp.id(19351248184156992)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(19439934974368709)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>121.344
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(19351886042157000)
,p_view_id=>wwv_flow_imp.id(19351248184156992)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(19351416810156997)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>131
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(19352823851157004)
,p_view_id=>wwv_flow_imp.id(19351248184156992)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(19352464377157002)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>175
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(19353860727157007)
,p_view_id=>wwv_flow_imp.id(19351248184156992)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(19353459177157006)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(19881912744504311)
,p_plug_name=>'Filters'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(19882319413504315)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(19881912744504311)
,p_button_name=>'Fetch_Data'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Run Test'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9642390385450627)
,p_name=>'P26_STRATEGY_ID'
,p_item_sequence=>40
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19440068823368710)
,p_name=>'P26_STRATEGY_VERSION_ID'
,p_item_sequence=>50
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19882023538504312)
,p_name=>'P26_STRATEGY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(19881912744504311)
,p_prompt=>'Strategy'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name as d, id as r',
'from UR_ALGOS',
'where hotel_id = :P26_HOTEL_LIST'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P26_HOTEL_LIST'
,p_ajax_items_to_submit=>'P26_HOTEL_LIST'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19882196864504313)
,p_name=>'P26_STRATEGY_VERSION'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(19881912744504311)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select id',
'from ur_algo_versions',
'where id = (select CURRENT_VERSION_ID from UR_ALGOS where id = :P26_STRATEGY )',
''))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Version'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select version as d, id as r',
'from ur_algo_versions',
'where algo_id = :P26_STRATEGY',
'order by version desc'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P26_STRATEGY'
,p_ajax_items_to_submit=>'P26_STRATEGY'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(19882214971504314)
,p_name=>'P26_HOTEL_LIST'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(19881912744504311)
,p_prompt=>'Hotel List'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select hotel_name as d, id as r',
'from ur_hotels'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(18156402164285630)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P26_STRATEGY_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18156559271285631)
,p_event_id=>wwv_flow_imp.id(18156402164285630)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(19350144592156984)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(19882468538504316)
,p_name=>'New_1'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(19882535389504317)
,p_event_id=>wwv_flow_imp.id(19882468538504316)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P26_HOTEL_LIST,P26_STRATEGY,P26_STRATEGY_VERSION'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(19882620658504318)
,p_event_id=>wwv_flow_imp.id(19882468538504316)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(19350144592156984)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(19882709401504319)
,p_name=>'New_2'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(19882319413504315)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(19882855554504320)
,p_event_id=>wwv_flow_imp.id(19882709401504319)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(19350144592156984)
,p_attribute_01=>'N'
);
wwv_flow_imp.component_end;
end;
/
