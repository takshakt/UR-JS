prompt --application/shared_components/logic/application_processes/get_blob
begin
--   Manifest
--     APPLICATION PROCESS: GET_BLOB
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(11717704187426377)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_BLOB'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_mime_type VARCHAR2(255);',
'  l_blob      BLOB;',
'BEGIN',
'  -- Use :ID as the bind variable passed via URL (ensure :ID matches datatype)',
'  SELECT IMG_TYPE, IMAGE ',
'    INTO l_mime_type, l_blob',
'    FROM UR_HOTELS',
'   WHERE ID = :ID;  -- Keep :ID as is (NUMBER or VARCHAR2 depending on your table)',
'',
'  owa_util.mime_header(l_mime_type, FALSE);',
'  htp.p(''Content-length: '' || DBMS_LOB.getlength(l_blob));',
'  owa_util.http_header_close;',
'  wpg_docload.download_file(l_blob);',
'EXCEPTION',
'  WHEN NO_DATA_FOUND THEN',
'    htp.p(''No image found'');',
'  WHEN OTHERS THEN',
'    htp.p(''Error: '' || SQLERRM);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45373320787877
);
wwv_flow_imp.component_end;
end;
/
