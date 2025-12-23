prompt --application/shared_components/logic/application_processes/ajx_get_temp_col_details
begin
--   Manifest
--     APPLICATION PROCESS: AJX_GET_TEMP_COL_DETAILS
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>25186177142438240
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(13474710824262164)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJX_GET_TEMP_COL_DETAILS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_json CLOB;',
'BEGIN',
'    APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'',
'    APEX_JSON.OPEN_OBJECT; -- hotelData root',
'',
'    FOR rec_hotel IN (',
'        SELECT DISTINCT UH.ID, LOWER(REPLACE(UH.HOTEL_NAME,'' '','''')) AS hotel_key, UH.HOTEL_NAME',
'        FROM UR_HOTELS UH',
'        WHERE upper(UH.HOTEL_NAME) = upper(apex_application.g_x01)  -- <-- value from JS',
'    ) LOOP',
'        APEX_JSON.OPEN_OBJECT(rec_hotel.hotel_key); -- hotel key like "hilton"',
'',
'        APEX_JSON.WRITE(''name'', rec_hotel.HOTEL_NAME);',
'       APEX_JSON.OPEN_OBJECT(''templates'');',
'',
'        FOR rec_tpl IN (',
'            SELECT UT.ID, UT.DEFINITION, UT.NAME',
'            FROM UR_TEMPLATES UT',
'            WHERE UT.HOTEL_ID = rec_hotel.ID ',
'           -- AND UPPER(UT.DEFINITION) like ''%"NAME":"STAY_DATE"%''',
'           -- and UT.ID in (select TEMPLATE_ID FROM UR_ALGO_ATTRIBUTES where ATTRIBUTE_QUALIFIER = ''STAY_DATE'' and HOTEL_ID = rec_hotel.ID )',
'            AND UPPER(UT.DEFINITION) LIKE ''%''||(select NAME FROM UR_ALGO_ATTRIBUTES where ATTRIBUTE_QUALIFIER = ''STAY_DATE'' and TEMPLATE_ID  = UT.ID)||''%''',
'        ) LOOP',
'            -- Use template name as key',
'            APEX_JSON.OPEN_ARRAY(rec_tpl.NAME);',
'           -- APEX_JSON.WRITE(''DB_OBJECT_NAME'',rec_tpl.DB_OBJECT_NAME);',
'           /** FOR rec_col IN (',
'                SELECT jt."name" AS col_name',
'                FROM JSON_TABLE(rec_tpl.DEFINITION, ''$[*]''',
'                     COLUMNS ("name" VARCHAR2(200) PATH ''$.name'')) jt',
'            ) LOOP',
'                APEX_JSON.WRITE(rec_col.col_name);',
'            END LOOP;',
'            */',
'            FOR rec_col IN (',
'                SELECT ',
'                    jt."name" AS col_name,',
'                    jt."data_type" AS data_type',
'                FROM JSON_TABLE(',
'                    rec_tpl.DEFINITION, ''$[*]''',
'                    COLUMNS (',
'                        "name"      VARCHAR2(200) PATH ''$.name'',',
'                        "data_type" VARCHAR2(200) PATH ''$.data_type''',
'                    )',
'                ) jt',
'            ) LOOP',
'                APEX_JSON.WRITE(rec_col.col_name || ''#'' || rec_col.data_type||''#'');',
'            END LOOP;',
'            APEX_JSON.CLOSE_ARRAY;',
'        END LOOP;',
'',
'        APEX_JSON.CLOSE_OBJECT; -- templates ',
'        ',
'',
'        APEX_JSON.CLOSE_OBJECT; -- hotel',
'    END LOOP;',
'',
'    APEX_JSON.CLOSE_OBJECT; -- hotelData',
'',
'    l_json := APEX_JSON.GET_CLOB_OUTPUT;',
'    APEX_JSON.FREE_OUTPUT;',
'',
'    -- Return JSON to JS',
'    HTP.P(l_json);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45648463149361
);
wwv_flow_imp.component_end;
end;
/
