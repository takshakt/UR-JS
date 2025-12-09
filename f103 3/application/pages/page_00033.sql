prompt --application/pages/page_00033
begin
--   Manifest
--     PAGE: 00033
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
 p_id=>33
,p_name=>'Template Update Interface_TEST'
,p_alias=>'TEMPLATE-UPDATE-INTERFACE-TEST'
,p_step_title=>'Template Update Interface_TEST'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41674633366226770)
,p_plug_name=>'Template Details'
,p_title=>'1. Template Details'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41674788150226771)
,p_plug_name=>'Template Info'
,p_parent_plug_id=>wwv_flow_imp.id(41674633366226770)
,p_region_template_options=>'#DEFAULT#:t-ContentBlock--h1:t-Region--removeHeader js-removeLandmark'
,p_plug_template=>2322115667525957943
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html_output  CLOB := NULL;',
'    l_count        NUMBER;',
'    l_sql          VARCHAR2(1000);',
'    l_count1        NUMBER;',
'    l_sql1          VARCHAR2(1000);',
'BEGIN',
'    -- Start container',
'    l_html_output := ''<div class="fancy-card-list">'';',
'',
'    -- Loop through template records',
'    FOR rec IN (',
'        SELECT t.name,',
'               t.active,',
'               t.type,',
'               t.db_object_name,',
'               h.hotel_name,',
'               t.DB_VIEW_OBJECT_NAME,',
'               NVL(COUNT(a.key), 0) AS attribute_count',
'          FROM ur_templates t',
'          LEFT JOIN ur_hotels h',
'            ON h.id = t.hotel_id',
'          LEFT JOIN ur_algo_attributes a',
'    ON a.template_id = t.id',
'         WHERE t.id = :P33_TEMPLATE_LIST',
'         GROUP BY ',
'    t.name,',
'    t.active,',
'    t.type,',
'    t.db_object_name,',
'    h.hotel_name,',
'    t.db_view_object_name',
'         ORDER BY t.name',
'    )',
'    LOOP',
'        -- Get record count from the table specified in DB_OBJECT_NAME',
'        BEGIN',
'            l_sql := ''SELECT COUNT(*) FROM '' || rec.db_object_name;',
'            EXECUTE IMMEDIATE l_sql INTO l_count;',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                l_count := 0; -- In case table doesn''t exist or invalid',
'        END;',
'',
'        /*BEGIN',
'            l_sql1 := ''SELECT COUNT(*) FROM '' || rec.key;',
'            EXECUTE IMMEDIATE l_sql1 INTO l_count1;',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                l_count1 := 0; -- In case table doesn''t exist or invalid',
'        END;*/',
'',
'        -- Start individual card',
'        l_html_output := l_html_output || ''<div class="fancy-card '';',
'',
'        /*IF rec.active = ''Y'' THEN',
'            l_html_output := l_html_output || ''is-active" data-type="'' || rec.type || ''">'';',
'        ELSE',
'            l_html_output := l_html_output || ''is-inactive" data-type="'' || rec.type || ''">'';',
'        END IF;*/',
'',
'        -- Card header',
'        l_html_output := l_html_output || ''<div class="card-header">'';',
'       -- l_html_output := l_html_output || ''<h3>'' || APEX_ESCAPE.HTML(rec.name) || ''</h3>'';',
'       -- l_html_output := l_html_output || ''<span class="card-type">'' || APEX_ESCAPE.HTML(rec.type) || ''</span>'';',
'        l_html_output := l_html_output || ''</div>'';',
'',
'        -- Card body',
'        l_html_output := l_html_output || ''<div class="card-body">'';',
'        --l_html_output := l_html_output || ''<p>Status: <strong>'' ||',
unistr('          --  CASE WHEN rec.active = ''Y'' THEN ''Active \2705'' ELSE ''Inactive \274C'' END || ''</strong></p>'';'),
'        l_html_output := l_html_output || ''<p>Hotel: <strong>'' || NVL(rec.hotel_name, ''N/A'') || ''</strong></p>'';',
'        l_html_output := l_html_output || ''<p>Table: <strong>'' || rec.db_object_name || ''</strong></p>'';',
'        IF rec.DB_VIEW_OBJECT_NAME IS NOT NULL THEN',
'    l_html_output := l_html_output || ''<p>View: <strong>'' || rec.DB_VIEW_OBJECT_NAME || ''</strong></p>'';',
'END IF;',
'        l_html_output := l_html_output || ''<p>Record Count: <strong>'' || l_count || ''</strong></p>'';',
'        l_html_output := l_html_output || ''<p>Attribute Count: <strong>'' || rec.attribute_count || ''</strong></p>'';',
'        l_html_output := l_html_output || ''</div>'';',
'',
'        -- End card',
'        l_html_output := l_html_output || ''</div>'';',
'    END LOOP;',
'',
'    -- End container',
'    l_html_output := l_html_output || ''</div>'';',
'',
'    RETURN l_html_output;',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P33_TEMPLATE_LIST'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49233234132242962)
,p_plug_name=>'Note'
,p_parent_plug_id=>wwv_flow_imp.id(41674633366226770)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>'Note : Before making any changes to the template mapping you will need to delete your loaded data. Please note that deletion cannot be undone.'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(42673860713446275)
,p_plug_name=>'Template List'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_plug_new_grid_row=>false
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49233180101242961)
,p_plug_name=>'Template Mapping'
,p_title=>'2. Template Mapping'
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(41673219759226755)
,p_plug_name=>'Template Definition'
,p_region_name=>'Template_Definition'
,p_parent_plug_id=>wwv_flow_imp.id(49233180101242961)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--removeHeader js-removeLandmark'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>80
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT seq_id,',
'       c001 AS name,',
'       c002 AS data_type,',
'       c003 AS qualifier,',
'       c004 AS value,',
'       c005 AS mapping_type ',
'  FROM apex_collections',
' WHERE collection_name = ''TEMPLATE_DATA''',
' and :P33_TEMPLATE_LIST is not null',
''))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P33_TEMPLATE_LIST'
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(25771390504805645)
,p_name=>'MAPPING_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MAPPING_TYPE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Mapping Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(41674096078226764)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(41674161762226765)
,p_name=>'APEX$ROW_SELECTOR'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(41674586856226769)
,p_name=>'SEQ_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SEQ_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Seq Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>70
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(41677237098226796)
,p_name=>'NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(41677343318226797)
,p_name=>'DATA_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DATA_TYPE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Data Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC:TEXT;TEXT,NUMBER;NUMBER,DATE;DATE'
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(41677554732226799)
,p_name=>'QUALIFIER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUALIFIER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Qualifier'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(10464223217255649)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(42672567753446262)
,p_name=>'VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VALUE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Value'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>32767
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(41673225991226756)
,p_internal_uid=>41673225991226756
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>true
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SET'
,p_show_total_row_count=>false
,p_show_toolbar=>false
,p_toolbar_buttons=>null
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(41699219800467428)
,p_interactive_grid_id=>wwv_flow_imp.id(41673225991226756)
,p_static_id=>'156293'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>10
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(41699325421467430)
,p_report_id=>wwv_flow_imp.id(41699219800467428)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(26112820303302890)
,p_view_id=>wwv_flow_imp.id(41699325421467430)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(25771390504805645)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(41722977772817216)
,p_view_id=>wwv_flow_imp.id(41699325421467430)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(41674096078226764)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(42513716852784759)
,p_view_id=>wwv_flow_imp.id(41699325421467430)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(41674586856226769)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>79
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(42558787710354363)
,p_view_id=>wwv_flow_imp.id(41699325421467430)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(41677237098226796)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(42559738197354368)
,p_view_id=>wwv_flow_imp.id(41699325421467430)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(41677343318226797)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(42561778903354377)
,p_view_id=>wwv_flow_imp.id(41699325421467430)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(41677554732226799)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(42689654677151791)
,p_view_id=>wwv_flow_imp.id(41699325421467430)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(42672567753446262)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(49233504037242964)
,p_plug_name=>'Button_Holder'
,p_parent_plug_id=>wwv_flow_imp.id(49233180101242961)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>100
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26071166164241266)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(41674633366226770)
,p_button_name=>'Delete_Template_Data'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--warning'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete Loaded Data'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26074468255241281)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(49233504037242964)
,p_button_name=>'create_template'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(26074076424241280)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(49233504037242964)
,p_button_name=>'Delete_Template'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Delete Template'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(38618064321421212)
,p_name=>'P33_TEMPLATE_LIST'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(42673860713446275)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Template'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT name AS display_value,',
'       id           AS return_value',
'FROM ur_templates',
'WHERE hotel_id = HEXTORAW(:P0_HOTEL_ID)',
'',
''))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P0_HOTEL_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(38626721906421248)
,p_name=>'P33_HOTEL_LIST'
,p_item_sequence=>40
,p_prompt=>'Hotel'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT NVL(hotel_name, ''Name'') AS display_value,',
'       RAWTOHEX(id)            AS return_value',
'  FROM ur_hotels',
'WHERE nvl(ASSOCIATION_END_DATE,sysdate) >= sysdate',
'',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42673266550446270)
,p_name=>'P33_TEMPLATE_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(41674633366226770)
,p_item_default=>'select type from ur_templates where id = :P33_TEMPLATE_LIST'
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Template type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'UR TEMPLATE TYPES'
,p_lov=>'.'||wwv_flow_imp.id(9646161429519087)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42676020068446297)
,p_name=>'P33_TEMPLATE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(41674633366226770)
,p_prompt=>'Template Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42681191459446304)
,p_name=>'P33_ALERT_MESSAGE'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42685475669446346)
,p_name=>'P33_FORCE_REWRITE'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42795367682445270)
,p_name=>'P33_STATUS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(41674633366226770)
,p_prompt=>'Status (Active / Inactive)'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_begin_on_new_field=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(42803891451445310)
,p_name=>'P33_DATA_EXISTS'
,p_item_sequence=>100
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26087038254241325)
,p_name=>'Page_load_DA'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26088034012241328)
,p_event_id=>wwv_flow_imp.id(26087038254241325)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41674633366226770)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26088509435241329)
,p_event_id=>wwv_flow_imp.id(26087038254241325)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_HOTEL_LIST,P33_TEMPLATE_LIST,P33_TEMPLATE_NAME,P0_HOTEL_ID'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'NULL'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26087591655241326)
,p_event_id=>wwv_flow_imp.id(26087038254241325)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_HOTEL_LIST,P33_TEMPLATE_LIST,P33_TEMPLATE_NAME,P0_HOTEL_ID'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26093198751241342)
,p_name=>'change template'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P33_TEMPLATE_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26096104138241351)
,p_event_id=>wwv_flow_imp.id(26093198751241342)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'populate collection'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_json_clob CLOB;',
'BEGIN',
'',
'    -- Exit if no template selected',
'    IF :P33_TEMPLATE_LIST IS NULL THEN',
'        RETURN;',
'    END IF;',
'    -- 1. Fetch the JSON CLOB from UR_TEMPLATES',
'    SELECT definition',
'      INTO l_json_clob',
'      FROM ur_templates',
'     WHERE id = :P33_TEMPLATE_LIST;',
'',
'    -- 2. Delete collection if already exists',
'    IF APEX_COLLECTION.COLLECTION_EXISTS(''TEMPLATE_DATA'') THEN',
'        APEX_COLLECTION.DELETE_COLLECTION(''TEMPLATE_DATA'');',
'    END IF;',
'',
'    -- 3. Create collection',
'    APEX_COLLECTION.CREATE_COLLECTION(''TEMPLATE_DATA'');',
'',
'    -- 4. Parse JSON and insert into collection',
'    FOR r IN (',
'        SELECT *',
'          FROM JSON_TABLE(',
'                 l_json_clob,',
'                 ''$[*]'' ',
'                 COLUMNS (',
'                     name       VARCHAR2(4000) PATH ''$.name'',',
'                     data_type  VARCHAR2(4000) PATH ''$.data_type'',',
'                     value      VARCHAR2(4000) PATH ''$.value'',',
'                     qualifier  VARCHAR2(4000) PATH ''$.qualifier'', ',
'                     mapping_type  VARCHAR2(4000) PATH ''$.mapping_type'' ',
'                 )',
'             )',
'    ) LOOP',
'        APEX_COLLECTION.ADD_MEMBER(',
'            p_collection_name => ''TEMPLATE_DATA'',',
'            p_c001            => r.name,',
'            p_c002            => r.data_type,',
'            p_c003            => r.qualifier,',
'            p_c004            => r.value,',
'            p_c005            => r.mapping_type',
'        );',
'    END LOOP;',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26094699104241347)
,p_event_id=>wwv_flow_imp.id(26093198751241342)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41673219759226755)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26095669771241350)
,p_event_id=>wwv_flow_imp.id(26093198751241342)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41674788150226771)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26097186595241354)
,p_event_id=>wwv_flow_imp.id(26093198751241342)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_TEMPLATE_TYPE'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26094106463241345)
,p_event_id=>wwv_flow_imp.id(26093198751241342)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_TEMPLATE_NAME'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26096692572241353)
,p_event_id=>wwv_flow_imp.id(26093198751241342)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41674633366226770)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26093687784241344)
,p_event_id=>wwv_flow_imp.id(26093198751241342)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_TEMPLATE_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'select name from ur_templates where id = :P33_TEMPLATE_LIST'
,p_attribute_07=>'P33_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26097631274241356)
,p_event_id=>wwv_flow_imp.id(26093198751241342)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_TEMPLATE_TYPE'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'select type from ur_templates where id = :P33_TEMPLATE_LIST'
,p_attribute_07=>'P33_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26095143366241349)
,p_event_id=>wwv_flow_imp.id(26093198751241342)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_STATUS'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'select active from ur_templates where id = :P33_TEMPLATE_LIST'
,p_attribute_07=>'P33_TEMPLATE_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26098059964241357)
,p_name=>'Create Template button click'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26074468255241281)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26104469942241376)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'saves_template_type'
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
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P33_TEMPLATE_LIST || ''","TYPE":"'' || :P33_TEMPLATE_TYPE || ''"}'',',
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
'  :P33_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
' ',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_TYPE,P33_TEMPLATE_LIST'
,p_attribute_03=>'P33_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26103987478241374)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'saves template name'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(4000);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'  v_key        VARCHAR2(4000);',
'  v_exists     NUMBER;',
'   l_temp    VARCHAR2(4000);',
'BEGIN',
'v_key := ur_utils.Clean_TEXT(:P33_TEMPLATE_NAME);',
'  SELECT COUNT(*) INTO v_exists FROM UR_TEMPLATES WHERE KEY = v_key;',
'',
'  IF v_exists > 0 THEN',
'    ur_utils.add_alert(l_message, ''Template key "'' || v_key || ''" already exists.'', ''warning'', NULL, NULL, l_status);',
'    --:P0_ALERT_MESSAGE := l_message;',
'     --:P0_ALERT_MESSAGE := DBMS_LOB.SUBSTR(l_message, 4000, 1);',
'    RETURN;',
'  END IF;',
'  ',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P33_TEMPLATE_LIST || ''","NAME":"'' || :P33_TEMPLATE_NAME || ''"}'',',
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
'-- :P33_ALERT_MESSAGE := ''[{ "message":"'' || DBMS_LOB.SUBSTR(l_message, 3900, 1) ||',
'  --                     ''", "icon":"'' || l_status || ''"}]'';',
'',
'/*l_temp := DBMS_LOB.SUBSTR(l_message, 3900, 1);',
'  :P33_ALERT_MESSAGE := ''[{ "message":"'' || l_temp || ''", "icon":"'' || l_icon || ''", "title":"'' || l_title || ''"}]'';*/',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_NAME,P33_TEMPLATE_LIST'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26102459837241370)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'save_Status'
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
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P33_TEMPLATE_LIST || ''","ACTIVE":"'' || :P33_STATUS || ''"}'',',
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
'  :P33_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST,P33_STATUS'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26102909189241371)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'saves_IG'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49233180101242961)
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.region("Template_Definition").widget().interactiveGrid("getActions").invoke("save");',
'',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26103445108241373)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41673219759226755)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26101993180241368)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Are you sure you want to update the definition?'
,p_attribute_03=>'warning'
,p_attribute_04=>'fa-warning'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26099503293241361)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_name=>'13/10_saves new_definition'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_status  VARCHAR2(10);',
'    v_message CLOB;',
'BEGIN',
'    update_template_definition(',
'        p_template_id     => :P33_TEMPLATE_LIST,',
'        p_collection_name => ''TEMPLATE_DATA'',',
'        p_template_type   => :P33_TEMPLATE_TYPE,',
'        p_is_update       => ''Y'',  -- Set ''Y'' to recreate DB object',
'        p_status          => v_status,',
'        p_message         => v_message',
'    );',
'',
'    :P0_ALERT_MESSAGE := v_message;',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST,P33_TEMPLATE_TYPE'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26100044712241363)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_name=>'Validation1'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_count NUMBER;',
'BEGIN',
'  SELECT COUNT(*) INTO l_count',
'    /*FROM UR_VK_SEGMENT_QUALIFIER1_T',
'   WHERE  1 = 1;*/',
'FROM ur_templates t',
'          LEFT JOIN ur_hotels h',
'            ON h.id = t.hotel_id',
'         WHERE t.id = :P33_TEMPLATE_LIST;',
'',
'  IF l_count > 0 THEN',
'    :P33_DATA_EXISTS := ''Y'';',
'  ELSE',
'    :P33_DATA_EXISTS := ''N'';',
'  END IF;',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST'
,p_attribute_03=>'P33_DATA_EXISTS'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26100960636241365)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'N'
,p_name=>'1'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.message.confirm(',
'  "Data already exists. Do you want to truncate it?",',
'  function(okPressed) {',
'    if (okPressed) {',
'      // trigger next dynamic action (custom event) attached to the same button',
'      apex.event.trigger(''#create_template'', ''truncateConfirmed'');',
'    }',
'    // if not okPressed -> do nothing',
'  }',
');',
''))
,p_client_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_client_condition_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$v(''P33_DATA_EXISTS'') === ''Y''',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26100561858241364)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>100
,p_execute_on_page_init=>'N'
,p_name=>'2'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_json        CLOB;',
'  v_ok          varchar2(1);',
'  v_msg         VARCHAR2(4000);',
'  v_key         VARCHAR2(110);',
'  v_exists      NUMBER;',
'  v_alerts      CLOB := NULL;',
'  v_val_status  VARCHAR2(1);',
'  v_def_ok      BOOLEAN;',
'  v_def_msg     VARCHAR2(4000);',
'  v_view_ok     BOOLEAN;',
'  v_view_msg    VARCHAR2(4000);',
'  v_table_name varchar2(4000);',
'  v_key_temp varchar2(100);',
'BEGIN',
'  -- Generate JSON from APEX collection',
'  ur_utils.get_collection_json(''TEMPLATE_DATA'', v_json, v_ok, v_msg);',
'',
'',
'    --ur_utils.add_alert(v_alerts, v_msg, v_ok, NULL, NULL, v_alerts);',
'',
'',
'',
'',
' ',
'insert into debug_log(message) values(v_json);',
'  -- Validate template JSON',
'  ur_utils.VALIDATE_TEMPLATE_DEFINITION(',
'    p_json_clob  => v_json,',
'    p_alert_clob => v_alerts,',
'    p_status     => v_val_status',
'  );',
'-- Check the status returned by the procedure',
'ur_utils.add_alert(v_alerts, v_msg, v_val_status, NULL, NULL, v_alerts);',
' ',
'   -- Hardcoded key and name',
'v_key := ur_utils.Clean_TEXT(:P33_TEMPLATE_LIST);',
'',
'  SELECT COUNT(*) INTO v_exists FROM UR_TEMPLATES WHERE id = v_key;',
'',
'  ',
'',
unistr('  -- \2705 Update existing definition'),
'  UPDATE UR_TEMPLATES',
'     SET DEFINITION = v_json,',
'         UPDATED_ON = SYSTIMESTAMP/*,       -- optional if you have this column',
'         UPDATED_BY = NVL(:APP_USER, USER)*/ -- optional if audit columns exist',
'   WHERE id = v_key;',
'',
'  COMMIT;',
'',
'select KEY into v_key_temp from ur_templates where id = v_key;',
'',
'',
'  /* ur_utils.define_db_object(v_key_temp, v_def_ok, v_def_msg);',
'    ur_utils.add_alert(v_alerts, v_def_msg, ''success'', null, null, v_alerts);',
'',
'    ur_utils.manage_algo_attributes(v_key, ''C'', NULL, v_def_ok, v_def_msg);',
'     ur_utils.add_alert(v_alerts, v_def_msg, ''error'', null, null, v_alerts);',
' */',
' :P0_ALERT_MESSAGE := v_alerts;',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    apex_debug.message(''Ex: '' || SQLERRM);',
'    ur_utils.add_alert(v_alerts, SQLERRM, ''error'', NULL, NULL, v_alerts);',
'    :P0_ALERT_MESSAGE := v_alerts;',
'    RAISE;',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_client_condition_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$v(''P33_DATA_EXISTS'') === ''N''',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26098556597241358)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>110
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name VARCHAR2(4000);',
'    v_count NUMBER;',
'BEGIN',
'    -- Get table name for selected template',
'    SELECT db_object_name',
'      INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P33_TEMPLATE_LIST;',
'',
'    ',
'',
'    -- Count rows in the table',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    -- Pass count back to a page item',
'    :P33_FORCE_REWRITE := CASE WHEN v_count > 0 THEN ''CONFIRM'' ELSE ''OK'' END;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P33_FORCE_REWRITE := ''ERROR'';',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST'
,p_attribute_03=>'P33_FORCE_REWRITE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26099063195241360)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>120
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name VARCHAR2(4000);',
'    v_count      NUMBER := 0;',
'BEGIN',
'    -- Get table name for the selected template',
'    SELECT db_object_name',
'      INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P33_TEMPLATE_LIST;',
'',
'    --:P33_TABLE_NAME := v_table_name;',
'',
'    -- Count rows in the table',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    :P33_TABLE_COUNT := v_count;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P33_TABLE_COUNT := 0;',
'    WHEN OTHERS THEN',
'        :P33_TABLE_COUNT := 0;',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26101468694241367)
,p_event_id=>wwv_flow_imp.id(26098059964241357)
,p_event_result=>'TRUE'
,p_action_sequence=>130
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Convert page item value to number',
'var tableCount = parseInt($v(''P33_TABLE_COUNT''), 10);',
'',
'// Only show confirm if table has rows',
'if (tableCount > 0) {',
'    if (!confirm(''The table already has data. Do you want to continue?'')) {',
unistr('        // User clicked No \2192 stop further True Actions'),
'        return false;',
'    }',
'}',
unistr('// User clicked Yes \2192 next True Actions will run'),
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26084350037241317)
,p_name=>'Alert Message'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P33_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26084857721241319)
,p_event_id=>wwv_flow_imp.id(26084350037241317)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P33_ALERT_MESSAGE");  // get the string from hidden page item',
'',
'if (messagesJson) {',
'  try {',
'    // Try parsing the string',
'    var parsed = JSON.parse(messagesJson);',
'',
'    // Check if parsed result is array or object',
'    if (Array.isArray(parsed)) {',
'      // It''s an array - pass as is',
'      showAlertToastr(parsed);',
'    } else if (parsed && typeof parsed === ''object'') {',
'      // Single object - pass it wrapped in array for consistency ',
'      showAlertToastr([parsed]);',
'    } else {',
unistr('      // Parsed to something else (string/number) \2014 just pass original string'),
'      showAlertToastr(messagesJson);',
'    }',
'  } catch (e) {',
unistr('    // Parsing failed \2014 probably plain text, pass as is'),
'    showAlertToastr(messagesJson);',
'  }',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26104863475241377)
,p_name=>'show and hide region'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P0_HOTEL_ID'
,p_condition_element=>'P0_HOTEL_ID'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26106863116241383)
,p_event_id=>wwv_flow_imp.id(26104863475241377)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49233180101242961)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26108381096241387)
,p_event_id=>wwv_flow_imp.id(26104863475241377)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41674633366226770)
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26105328342241378)
,p_event_id=>wwv_flow_imp.id(26104863475241377)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(42673860713446275)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26107382677241384)
,p_event_id=>wwv_flow_imp.id(26104863475241377)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41674633366226770)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26106350873241381)
,p_event_id=>wwv_flow_imp.id(26104863475241377)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P33_TEMPLATE_LIST'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26107839815241385)
,p_event_id=>wwv_flow_imp.id(26104863475241377)
,p_event_result=>'FALSE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41674788150226771)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26105822938241380)
,p_event_id=>wwv_flow_imp.id(26104863475241377)
,p_event_result=>'FALSE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(42673860713446275)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26088947024241330)
,p_name=>'Show and hide region'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P33_TEMPLATE_LIST'
,p_condition_element=>'P33_TEMPLATE_LIST'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26090425877241335)
,p_event_id=>wwv_flow_imp.id(26088947024241330)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49233180101242961)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26090917143241336)
,p_event_id=>wwv_flow_imp.id(26088947024241330)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(49233180101242961)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26089933378241333)
,p_event_id=>wwv_flow_imp.id(26088947024241330)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41674788150226771)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26089411723241332)
,p_event_id=>wwv_flow_imp.id(26088947024241330)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(41674633366226770)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26085273172241320)
,p_name=>'Change Template name'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P33_TEMPLATE_NAME'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'focusout'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26085762810241321)
,p_event_id=>wwv_flow_imp.id(26085273172241320)
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
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P33_TEMPLATE_LIST || ''","NAME":"'' || :P33_TEMPLATE_NAME || ''"}'',',
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
'  :P33_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_NAME,P33_TEMPLATE_LIST'
,p_attribute_03=>'P33_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26086174795241322)
,p_name=>'change template type'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P33_TEMPLATE_TYPE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'focusout'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26086698413241324)
,p_event_id=>wwv_flow_imp.id(26086174795241322)
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
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P33_TEMPLATE_LIST || ''","TYPE":"'' || :P33_TEMPLATE_TYPE || ''"}'',',
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
'  :P33_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST,P33_TEMPLATE_TYPE'
,p_attribute_03=>'P33_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26092252890241340)
,p_name=>'Change status'
,p_event_sequence=>90
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P33_STATUS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26092774301241341)
,p_event_id=>wwv_flow_imp.id(26092252890241340)
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
'    p_table   => ''UR_TEMPLATES'',',
'    p_payload => ''{"ID":"''|| :P33_TEMPLATE_LIST || ''","ACTIVE":"'' || :P33_STATUS || ''"}'',',
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
'  :P33_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST,P33_STATUS'
,p_attribute_03=>'P33_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26080986157241307)
,p_name=>'delete template data'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26071166164241266)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26083994583241316)
,p_event_id=>wwv_flow_imp.id(26080986157241307)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'no data found'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DECLARE',
'    v_table_name  VARCHAR2(255);',
'    v_count       NUMBER := 0;',
'    v_alerts      CLOB := NULL;',
'BEGIN',
' ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''No data found in table "'' || v_table_name || ''".'',',
'            p_icon          => ''info'',',
'            p_title         => ''Nothing to Truncate'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'   ',
'',
'    -- Assign to global alert page item',
'    :P0_ALERT_MESSAGE := v_alerts;',
'end;'))
,p_attribute_02=>'P33_TEMPLATE_LIST'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_client_condition_expression=>'$v(''P33_DATA_EXISTS'') === ''N'''
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26081989221241310)
,p_event_id=>wwv_flow_imp.id(26080986157241307)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'confirmation1'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name VARCHAR2(255);',
'    v_count      NUMBER := 0;',
'BEGIN',
'    SELECT db_object_name',
'      INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P33_TEMPLATE_LIST;',
'',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    IF v_count > 0 THEN',
'        :P33_DATA_EXISTS := ''Y'';',
'    ELSE',
'        :P33_DATA_EXISTS := ''N'';',
'    END IF;',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        :P33_DATA_EXISTS := ''N'';',
'    WHEN OTHERS THEN',
'        :P33_DATA_EXISTS := ''N'';',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST'
,p_attribute_03=>'P33_DATA_EXISTS'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26083460929241315)
,p_event_id=>wwv_flow_imp.id(26080986157241307)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.message.confirm(',
'  "Data already exists. Do you want to truncate it?",',
'  function(okPressed) {',
'    if (okPressed) {',
'      // trigger next dynamic action (custom event) attached to the same button',
'      apex.event.trigger(''#Delete_Template_Data'', ''truncateConfirmed'');',
'    }',
'    // if not okPressed -> do nothing',
'  }',
');',
''))
,p_client_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_client_condition_expression=>'$v(''P33_DATA_EXISTS'') === ''Y'''
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26081484963241309)
,p_event_id=>wwv_flow_imp.id(26080986157241307)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'1'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if ($v(''P33_DATA_EXISTS'') === ''Y'') {',
'    apex.message.confirm(',
'        "Data exists! Are you sure you want to truncate?", // message',
'        function(okPressed) { // callback',
'            if (okPressed) {',
'                // user clicked Yes',
'                apex.page.submit({request: "TRUNCATE"});',
'            } else {',
'                // user clicked No, do nothing',
'            }',
'        }',
'    );',
'} else {',
'    apex.message.alert("No data to truncate.");',
'}',
'',
'/*',
'if ($v(''P33_DATA_EXISTS'') !== ''Y'') {',
'    apex.message.alert("No data to truncate.");',
'    return false;',
'}',
'apex.message.confirm(',
'    "Data exists! Are you sure?",',
'    function(okPressed) {',
'        if (!okPressed) return false;',
'    }',
');',
'*/',
''))
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26082484049241312)
,p_event_id=>wwv_flow_imp.id(26080986157241307)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Please note that deletion cannot be undone. Do you want to continue?'
,p_attribute_03=>'warning'
,p_attribute_04=>'fa-warning'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26082943985241313)
,p_event_id=>wwv_flow_imp.id(26080986157241307)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_name=>'truncate table'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name  VARCHAR2(255);',
'    v_count       NUMBER := 0;',
'    v_alerts      CLOB := NULL;',
'BEGIN',
'    -- Fetch table name',
'    SELECT db_object_name',
'      INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P33_TEMPLATE_LIST;',
'',
'    -- Count data before truncating',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    IF v_count > 0 THEN',
unistr('        -- Table has data \2192 truncate it'),
'        EXECUTE IMMEDIATE ''TRUNCATE TABLE '' || v_table_name;',
'',
'        -- Add success message',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''Table "'' || v_table_name || ''" truncated successfully ('' || v_count || '' records deleted).'',',
'            p_icon          => ''success'',',
'            p_title         => ''Truncate Successful'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'    ELSE',
'        -- No data found to truncate',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''No data found in table "'' || v_table_name || ''".'',',
'            p_icon          => ''info'',',
'            p_title         => ''Nothing to Truncate'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'    END IF;',
'',
'    -- Assign to global alert page item',
'    :P0_ALERT_MESSAGE := v_alerts;',
'',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''No template found for the selected ID.'',',
'            p_icon          => ''error'',',
'            p_title         => ''Error'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'        :P0_ALERT_MESSAGE := v_alerts;',
'',
'    WHEN OTHERS THEN',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''Error: '' || SQLERRM,',
'            p_icon          => ''error'',',
'            p_title         => ''Unexpected Error'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'        :P0_ALERT_MESSAGE := v_alerts;',
'END;',
''))
,p_attribute_02=>'P33_TEMPLATE_LIST'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(26091368340241337)
,p_name=>'Delete database objects'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(26074076424241280)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(26091895117241339)
,p_event_id=>wwv_flow_imp.id(26091368340241337)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_status  BOOLEAN;',
'    l_message VARCHAR2(4000);',
'    l_template_key varchar2(240);',
'BEGIN',
'select key from ur',
'    define_db_object_1(',
'        p_template_key => :P33_TEMPLATE_NAME,  -- your template key',
'        p_status       => l_status,',
'        p_message      => l_message,',
'        p_mode         => ''D''             -- D = Delete',
'    );',
'',
'    DBMS_OUTPUT.put_line(''Status: '' || CASE WHEN l_status THEN ''Success'' ELSE ''Failure'' END);',
'    DBMS_OUTPUT.put_line(''Message: '' || l_message);',
'END;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26080591899241306)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'TRUNCATE_DATA_PROCESS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_table_name VARCHAR2(255);',
'    v_count      NUMBER := 0;',
'    v_alerts     CLOB := NULL;',
'BEGIN',
'    SELECT db_object_name INTO v_table_name',
'      FROM ur_templates',
'     WHERE id = :P33_TEMPLATE_LIST;',
'',
'    EXECUTE IMMEDIATE ''SELECT COUNT(*) FROM '' || v_table_name INTO v_count;',
'',
'    IF v_count > 0 THEN',
'        EXECUTE IMMEDIATE ''TRUNCATE TABLE '' || v_table_name;',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''Table "'' || v_table_name || ''" truncated successfully ('' || v_count || '' records deleted).'',',
'            p_icon          => ''success'',',
'            p_title         => ''Truncate Successful'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'    ELSE',
'        ur_utils.add_alert(',
'            p_existing_json => v_alerts,',
'            p_message       => ''No data found in table "'' || v_table_name || ''".'',',
'            p_icon          => ''info'',',
'            p_title         => ''Nothing to Truncate'',',
'            p_timeout       => 4000,',
'            p_updated_json  => v_alerts',
'        );',
'    END IF;',
'',
'   ',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'TRUNCATE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>'success!'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>26080591899241306
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(26078875099241299)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(41673219759226755)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Template Definition - Save Interactive Grid Data'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    CASE :APEX$ROW_STATUS',
'        WHEN ''C'' THEN',
'            :SEQ_ID := apex_collection.add_member(',
'                p_collection_name => ''TEMPLATE_DATA'',',
'                p_c001            => :NAME,',
'                p_c002            => :DATA_TYPE,',
'                p_c003            => :QUALIFIER,',
'     p_c004            => :value,',
'     p_c005 => :mapping_type',
'            );',
'',
'        WHEN ''U'' THEN',
'            apex_collection.update_member(',
'                p_collection_name => ''TEMPLATE_DATA'',',
'                p_seq             => :SEQ_ID,',
'                p_c001            => :NAME,',
'                p_c002            => :DATA_TYPE,',
'                p_c003            => :QUALIFIER,',
'                p_c004            => :VALUE,',
'     p_c005 => :mapping_type',
'            );',
'',
'        WHEN ''D'' THEN',
'            apex_collection.delete_member(',
'                p_collection_name => ''TEMPLATE_DATA'',',
'                p_seq             => :SEQ_ID',
'            );',
'    END CASE;',
'END;',
''))
,p_attribute_05=>'Y'
,p_attribute_06=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>26078875099241299
);
wwv_flow_imp.component_end;
end;
/
