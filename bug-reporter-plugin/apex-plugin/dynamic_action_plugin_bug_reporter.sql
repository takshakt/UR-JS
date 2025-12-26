prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- This file contains the Dynamic Action Plugin: Bug Reporter
-- To install: Import this file via Shared Components > Plug-ins > Import
--
--------------------------------------------------------------------------------

prompt --application/shared_components/plugins/dynamic_action_type/bug_reporter
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(999999999999999901)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.BUGREPORTER.DA'
,p_display_name=>'Bug Reporter'
,p_category=>'EXECUTE'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- ═══════════════════════════════════════════════════════════════════════════',
'-- Bug Reporter Plugin - PL/SQL Package',
'-- ═══════════════════════════════════════════════════════════════════════════',
'',
'FUNCTION render (',
'    p_dynamic_action IN apex_plugin.t_dynamic_action,',
'    p_plugin         IN apex_plugin.t_plugin',
') RETURN apex_plugin.t_dynamic_action_render_result',
'IS',
'    l_result apex_plugin.t_dynamic_action_render_result;',
'    ',
'    -- Plugin Attributes',
'    l_webhook_url     VARCHAR2(4000) := p_dynamic_action.attribute_01;',
'    l_webhook_api_key VARCHAR2(4000) := p_dynamic_action.attribute_02;',
'    l_position        VARCHAR2(100)  := NVL(p_dynamic_action.attribute_03, ''bottom-right'');',
'    l_theme           VARCHAR2(100)  := NVL(p_dynamic_action.attribute_04, ''auto'');',
'    l_button_icon     VARCHAR2(100)  := NVL(p_dynamic_action.attribute_05, ''bug'');',
'    l_accent_color    VARCHAR2(100)  := NVL(p_dynamic_action.attribute_06, ''#4f46e5'');',
'    l_enable_apex_log VARCHAR2(10)   := NVL(p_dynamic_action.attribute_07, ''Y'');',
'    l_max_files       NUMBER         := NVL(p_dynamic_action.attribute_08, 3);',
'    l_max_file_size   NUMBER         := NVL(p_dynamic_action.attribute_09, 5);',
'    ',
'    l_js_code CLOB;',
'BEGIN',
'    -- Add plugin files to page',
'    apex_javascript.add_library(',
'        p_name      => ''bug-reporter'',',
'        p_directory => p_plugin.file_prefix,',
'        p_version   => NULL',
'    );',
'    ',
'    -- Build initialization JavaScript',
'    l_js_code := ''BugReporter.init({'' ||',
'        ''webhookUrl:"'' || apex_escape.js_literal(l_webhook_url, ''"'') || ''",'' ||',
'        ''webhookApiKey:"'' || apex_escape.js_literal(l_webhook_api_key, ''"'') || ''",'' ||',
'        ''position:"'' || apex_escape.js_literal(l_position, ''"'') || ''",'' ||',
'        ''theme:"'' || apex_escape.js_literal(l_theme, ''"'') || ''",'' ||',
'        ''buttonIcon:"'' || apex_escape.js_literal(l_button_icon, ''"'') || ''",'' ||',
'        ''accentColor:"'' || apex_escape.js_literal(l_accent_color, ''"'') || ''",'' ||',
'        ''apexProcessName:'' || CASE WHEN l_enable_apex_log = ''Y'' THEN ''"AJX_BUG_REPORTER_LOG"'' ELSE ''null'' END || '','' ||',
'        ''maxFiles:'' || l_max_files || '','' ||',
'        ''maxFileSize:'' || (l_max_file_size * 1024 * 1024) || '','' ||',
'        ''userName:"'' || apex_escape.js_literal(V(''APP_USER''), ''"'') || ''",'' ||',
'        ''userEmail:"'' || apex_escape.js_literal(V(''G_USER_EMAIL''), ''"'') || ''"'' ||',
'    ''});'';',
'    ',
'    l_result.javascript_function := ''function(){'' || l_js_code || ''}'';',
'    ',
'    RETURN l_result;',
'END render;',
'',
'-- ═══════════════════════════════════════════════════════════════════════════',
'-- Ajax Callback for saving bug reports to database',
'-- ═══════════════════════════════════════════════════════════════════════════',
'FUNCTION ajax (',
'    p_dynamic_action IN apex_plugin.t_dynamic_action,',
'    p_plugin         IN apex_plugin.t_plugin',
') RETURN apex_plugin.t_dynamic_action_ajax_result',
'IS',
'    l_result apex_plugin.t_dynamic_action_ajax_result;',
'BEGIN',
'    -- This is handled by the application-level AJAX callback',
'    -- AJX_BUG_REPORTER_LOG',
'    NULL;',
'    RETURN l_result;',
'END ajax;'))
,p_api_version=>2
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'ONLOAD'
,p_substitute_attributes=>true
,p_version_identifier=>'1.0.0'
,p_about_url=>'https://github.com/your-repo/bug-reporter-plugin'
,p_files_version=>1
);
end;
/

prompt --application/shared_components/plugins/dynamic_action_type/bug_reporter/attributes
begin
-- Attribute 1: Webhook URL
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(999999999999999902)
,p_plugin_id=>wwv_flow_imp.id(999999999999999901)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Webhook URL'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>''
,p_is_translatable=>false
,p_help_text=>'The URL of your webhook endpoint (e.g., n8n webhook URL). Leave empty to only save to database.'
);

-- Attribute 2: Webhook API Key
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(999999999999999903)
,p_plugin_id=>wwv_flow_imp.id(999999999999999901)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Webhook API Key'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>''
,p_is_translatable=>false
,p_help_text=>'API key sent as X-API-Key header to the webhook.'
);

-- Attribute 3: Button Position
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(999999999999999904)
,p_plugin_id=>wwv_flow_imp.id(999999999999999901)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Button Position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'bottom-right'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Position of the floating bug report button on the page.'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999905)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999904)
,p_display_sequence=>10
,p_display_value=>'Bottom Right'
,p_return_value=>'bottom-right'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999906)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999904)
,p_display_sequence=>20
,p_display_value=>'Bottom Left'
,p_return_value=>'bottom-left'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999907)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999904)
,p_display_sequence=>30
,p_display_value=>'Top Right'
,p_return_value=>'top-right'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999908)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999904)
,p_display_sequence=>40
,p_display_value=>'Top Left'
,p_return_value=>'top-left'
);

-- Attribute 4: Theme
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(999999999999999909)
,p_plugin_id=>wwv_flow_imp.id(999999999999999901)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Theme'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'auto'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Color theme for the bug reporter UI.'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999910)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999909)
,p_display_sequence=>10
,p_display_value=>'Auto (System Preference)'
,p_return_value=>'auto'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999911)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999909)
,p_display_sequence=>20
,p_display_value=>'Light'
,p_return_value=>'light'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999912)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999909)
,p_display_sequence=>30
,p_display_value=>'Dark'
,p_return_value=>'dark'
);

-- Attribute 5: Button Icon
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(999999999999999913)
,p_plugin_id=>wwv_flow_imp.id(999999999999999901)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Button Icon'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'bug'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Icon displayed on the floating button.'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999914)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999913)
,p_display_sequence=>10
,p_display_value=>'Bug'
,p_return_value=>'bug'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999915)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999913)
,p_display_sequence=>20
,p_display_value=>'Help'
,p_return_value=>'help'
);

wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(999999999999999916)
,p_plugin_attribute_id=>wwv_flow_imp.id(999999999999999913)
,p_display_sequence=>30
,p_display_value=>'Support'
,p_return_value=>'support'
);

-- Attribute 6: Accent Color
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(999999999999999917)
,p_plugin_id=>wwv_flow_imp.id(999999999999999901)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Accent Color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#4f46e5'
,p_is_translatable=>false
,p_help_text=>'Primary accent color for the bug reporter UI.'
);

-- Attribute 7: Enable APEX Database Logging
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(999999999999999918)
,p_plugin_id=>wwv_flow_imp.id(999999999999999901)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Save to Database'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
,p_help_text=>'When enabled, bug reports are saved to the BUG_REPORTS table in addition to calling the webhook.'
);

-- Attribute 8: Max Files
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(999999999999999919)
,p_plugin_id=>wwv_flow_imp.id(999999999999999901)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Max Attachments'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'3'
,p_is_translatable=>false
,p_help_text=>'Maximum number of file attachments allowed per report.'
);

-- Attribute 9: Max File Size (MB)
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(999999999999999920)
,p_plugin_id=>wwv_flow_imp.id(999999999999999901)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Max File Size (MB)'
,p_attribute_type=>'INTEGER'
,p_is_required=>true
,p_default_value=>'5'
,p_is_translatable=>false
,p_help_text=>'Maximum size per attachment file in megabytes.'
);
end;
/

prompt --application/end_environment
set define on
