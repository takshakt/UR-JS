prompt --application/shared_components/logic/application_processes/download_file
begin
--   Manifest
--     APPLICATION PROCESS: DOWNLOAD_FILE
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(18364649581104687)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DOWNLOAD_FILE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_blob   BLOB;',
'  l_mime   VARCHAR2(255);',
'  l_name   VARCHAR2(400);',
'BEGIN',
'  SELECT blob_content, mime_type, filename',
'    INTO l_blob, l_mime, l_name',
'    FROM (',
'      SELECT blob_content, mime_type, filename',
'      FROM temp_blob',
'      WHERE filename = apex_application.g_x01',
'      ORDER BY created_on DESC',
'    )',
'   WHERE ROWNUM = 1;',
'',
'  sys.htp.init;',
'  owa_util.mime_header(NVL(l_mime, ''text/plain''), FALSE);',
'  htp.p(''Content-length: '' || dbms_lob.getlength(l_blob));',
'  htp.p(''Content-Disposition: attachment; filename="'' || l_name || ''"'');',
'  owa_util.http_header_close;',
'  wpg_docload.download_file(l_blob);',
'  apex_application.stop_apex_engine;',
'EXCEPTION',
'  WHEN NO_DATA_FOUND THEN',
'    htp.p(''File not found.'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45648466798130
);
wwv_flow_imp.component_end;
end;
/
