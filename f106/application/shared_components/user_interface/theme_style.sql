prompt --application/shared_components/user_interface/theme_style
begin
--   Manifest
--     THEME STYLE: 106
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>25186177142438240
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_theme_style(
 p_id=>wwv_flow_imp.id(27365441336572937)
,p_theme_id=>42
,p_name=>'Vita - Dark (copy_1)(olive)'
,p_is_public=>true
,p_is_accessible=>false
,p_theme_roller_input_file_urls=>'#THEME_FILES#less/theme/Vita-Dark.less'
,p_theme_roller_config=>'{"classes":[],"vars":{"@g_Nav-Badge-BG":"#056AC8","@g_Nav-Badge-FG":"#ffffff","@g_NavBarMenu-Active-BG":"#786f4f","@g_NavBarMenu-Active-FG":"#ffffff","@g_Header-BG":"#786f4f","@g_Header-FG":"#ffffff","@g_Nav-Accent-BG":"#056AC8","@g_Nav-Accent-FG":"#'
||'ffffff"},"customCSS":"","useCustomLess":"N"}'
,p_theme_roller_output_file_url=>'#THEME_DB_FILES#27365441336572937.css'
,p_theme_roller_read_only=>false
);
wwv_flow_imp.component_end;
end;
/
