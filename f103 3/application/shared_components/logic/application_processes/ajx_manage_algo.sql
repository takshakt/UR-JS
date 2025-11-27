prompt --application/shared_components/logic/application_processes/ajx_manage_algo
begin
--   Manifest
--     APPLICATION PROCESS: AJX_MANAGE_ALGO
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
 p_id=>wwv_flow_imp.id(15031571000976823)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJX_MANAGE_ALGO'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_clob      CLOB;',
'    l_status    VARCHAR2(20);',
'    l_message   CLOB;',
'    l_icon      VARCHAR2(50);',
'    l_title     VARCHAR2(100);',
'    l_payload   CLOB;',
'BEGIN',
'    -- Log the start of the process and all incoming parameters',
'    APEX_DEBUG.MESSAGE(''--- AJX_MANAGE_ALGO START ---'');',
'    APEX_DEBUG.MESSAGE(''Mode (x01): %0'', apex_application.g_x01);',
'    APEX_DEBUG.MESSAGE(''Algo ID (x02): %0'', apex_application.g_x02);',
'    APEX_DEBUG.MESSAGE(''Version ID (x03): %0'', apex_application.g_x03);',
'',
'    APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'    APEX_JSON.OPEN_OBJECT; -- Open a single root JSON object for the response',
'',
'    IF apex_application.g_x01 = ''SELECT'' THEN',
'        APEX_DEBUG.MESSAGE(''Entering SELECT block...'');',
'        BEGIN',
'            -- Using an inner BEGIN...EXCEPTION...END block to catch specific errors',
'            ',
'            -- << BUG FIX >>: The WHERE clause now correctly uses the ID column, not the VERSION column.',
'            SELECT EXPRESSION',
'            INTO l_payload',
'            FROM UR_ALGO_VERSIONS',
'            WHERE ALGO_ID = apex_application.g_x02',
'              AND ID = apex_application.g_x03; -- Corrected from "version ="',
'',
'            APEX_DEBUG.MESSAGE(''SELECT successful. Payload CLOB length: %0'', DBMS_LOB.GETLENGTH(l_payload));',
'            ',
'            -- Write success response',
'            APEX_JSON.WRITE(''success'', true);',
'            APEX_JSON.WRITE(''message'', ''Configuration loaded successfully.'');',
'            APEX_JSON.OPEN_ARRAY(''data''); -- Nest the data in an array as per your original structure',
'            APEX_JSON.OPEN_OBJECT;',
'            APEX_JSON.WRITE(''l_payload'', l_payload);',
'            APEX_JSON.CLOSE_OBJECT;',
'            APEX_JSON.CLOSE_ARRAY;',
'',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN',
'                APEX_DEBUG.ERROR(''NO_DATA_FOUND exception for Algo ID: %0 and Version ID: %1'', apex_application.g_x02, apex_application.g_x03);',
'                APEX_JSON.WRITE(''success'', false);',
'                APEX_JSON.WRITE(''message'', ''Error: No configuration was found for the selected algorithm and version. The query returned no rows.'');',
'            WHEN OTHERS THEN',
'                APEX_DEBUG.ERROR(''Unhandled exception in SELECT block. SQLERRM: %0'', SQLERRM);',
'                APEX_JSON.WRITE(''success'', false);',
'                APEX_JSON.WRITE(''message'', ''An unexpected database error occurred during select: '' || SQLERRM);',
'        END;',
'',
'    ELSIF apex_application.g_x01 IN (''INSERT'', ''UPDATE'') THEN',
'        -- Handle INSERT or UPDATE logic here if needed',
'        APEX_DEBUG.MESSAGE(''Entering INSERT/UPDATE block...'');',
'        -- Add your insert/update logic here if required',
'        APEX_JSON.WRITE(''success'', false);',
'        APEX_JSON.WRITE(''message'', ''Operation '' || apex_application.g_x01 || '' is not yet implemented.'');',
'        ',
'    ELSE',
'        APEX_DEBUG.WARN(''Invalid mode passed: %0'', apex_application.g_x01);',
'        APEX_JSON.WRITE(''success'', false);',
'        APEX_JSON.WRITE(''message'', ''Invalid operation specified.'');',
'    END IF;',
'',
'    APEX_JSON.CLOSE_OBJECT; -- Close the root JSON object',
'    l_clob := APEX_JSON.GET_CLOB_OUTPUT;',
'    APEX_JSON.FREE_OUTPUT;',
'    ',
'    APEX_DEBUG.MESSAGE(''--- AJX_MANAGE_ALGO END ---'');',
'    HTP.P(l_clob);',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- This is a critical failure handler. It catches errors in the main block structure.',
'        APEX_DEBUG.ERROR(',
'            ''CRITICAL UNHANDLED EXCEPTION in AJX_MANAGE_ALGO. SQLERRM: %0. Backtrace: %1'',',
'            SQLERRM,',
'            DBMS_UTILITY.FORMAT_ERROR_BACKTRACE',
'        );',
'        -- Ensure a valid JSON error is returned',
'        APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'        APEX_JSON.OPEN_OBJECT;',
'        APEX_JSON.WRITE(''success'', false);',
'        APEX_JSON.WRITE(''message'', ''A critical server error occurred: '' || SQLERRM);',
'        APEX_JSON.CLOSE_OBJECT;',
'        HTP.P(APEX_JSON.GET_CLOB_OUTPUT);',
'        APEX_JSON.FREE_OUTPUT;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45527205687069
);
wwv_flow_imp.component_end;
end;
/
