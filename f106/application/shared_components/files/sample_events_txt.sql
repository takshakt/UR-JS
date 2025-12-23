prompt --application/shared_components/files/sample_events_txt
begin
--   Manifest
--     APP STATIC FILES: 106
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>25186177142438240
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '4556454E545F4E414D452C4556454E545F545950452C4556454E545F53544152545F444154452C4556454E545F454E445F444154452C455354494D415445445F415454454E44414E43452C494D504143545F4C4556454C2C4445534352495054494F4E2C';
wwv_flow_imp.g_varchar2_table(2) := '434954592C504F5354434F44452C434F554E5452592C4556454E545F4652455155454E43592C494D504143545F54595045';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(28841928936818229)
,p_file_name=>'sample events.txt'
,p_mime_type=>'text/plain'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
