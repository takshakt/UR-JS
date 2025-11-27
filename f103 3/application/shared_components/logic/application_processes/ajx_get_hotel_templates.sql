prompt --application/shared_components/logic/application_processes/ajx_get_hotel_templates
begin
--   Manifest
--     APPLICATION PROCESS: AJX_GET_HOTEL_TEMPLATES
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
 p_id=>wwv_flow_imp.id(12856996721950922)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJX_GET_HOTEL_TEMPLATES'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_json CLOB;',
'BEGIN',
'    APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'    APEX_JSON.OPEN_OBJECT; -- root',
'',
'    FOR rec_hotel IN (',
'        SELECT DISTINCT UH.ID,',
'               LOWER(REPLACE(UH.HOTEL_NAME,'' '','''')) AS hotel_key,',
'               UH.HOTEL_NAME',
'          FROM UR_HOTELS UH',
'         WHERE UPPER(UH.HOTEL_NAME) = UPPER(apex_application.g_x01)',
'    ) LOOP',
'        -- "hotelname" object',
'        APEX_JSON.OPEN_OBJECT(rec_hotel.hotel_key);',
'',
'        -- hotel name',
'        APEX_JSON.WRITE(''name'', rec_hotel.HOTEL_NAME);',
'',
'        -- templates object',
'        APEX_JSON.OPEN_OBJECT(''templates'');',
'',
'        -- write each template array',
'        FOR rec_tpl IN (',
'            SELECT UT.ID, UT.DEFINITION, UT.NAME',
'              FROM UR_TEMPLATES UT',
'             WHERE UT.HOTEL_ID = rec_hotel.ID',
'             and UT.active = ''Y''',
'             and UT.ID in (select TEMPLATE_ID FROM UR_ALGO_ATTRIBUTES where ATTRIBUTE_QUALIFIER = ''STAY_DATE'' and HOTEL_ID = rec_hotel.ID )',
'               --AND UPPER(UT.DEFINITION) LIKE ''%''||(select NAME FROM UR_ALGO_ATTRIBUTES where ATTRIBUTE_QUALIFIER = ''STAY_DATE'' and TEMPLATE_ID  = UT.ID)||''%''',
'        ) LOOP',
'           APEX_JSON.OPEN_ARRAY(rec_tpl.NAME);',
'',
'            FOR rec_col IN (',
'                SELECT jt."name" AS col_name',
'                  FROM JSON_TABLE(rec_tpl.DEFINITION, ''$[*]''',
'                        COLUMNS ("name" VARCHAR2(200) PATH ''$.name'')) jt',
'            ) LOOP',
'                APEX_JSON.WRITE(rec_col.col_name);',
'            END LOOP;',
'            APEX_JSON.CLOSE_ARRAY;',
'        END LOOP;',
'',
'',
'        APEX_JSON.OPEN_ARRAY(''Strategies'');',
'        FOR rec_algo IN (',
'            SELECT DISTINCT REPLACE(a.name, '' '', ''_'') || ''(Strategy_Column)'' AS EVALUATED_PRICE',
'              FROM (',
'                      SELECT id, name',
'                        FROM ur_algos',
'                       WHERE hotel_id = rec_hotel.id',
'                       ORDER BY id DESC',
'                   ) a',
'                   --,TABLE(ALGO_EVALUATOR_PKG.EVALUATE(a.id, NULL)) t',
'        ) LOOP',
'            APEX_JSON.WRITE(rec_algo.EVALUATED_PRICE);',
'        END LOOP;',
'        APEX_JSON.CLOSE_ARRAY; -- Strategies ',
'',
'        -- APEX_JSON.OPEN_ARRAY(''OCCUPANCY'');',
'        -- FOR rec_algo IN (',
'        --     SELECT DISTINCT REPLACE(a.OCCUPANCY, '' '', ''_'') || ''(Occupancy_Column)'' AS HOTEL_OCCUPANCY',
'        --       FROM (',
'        --             SELECT DISTINCT OCCUPANCY',
'        --   FROM UR_HOTELS UH',
'        --  WHERE UPPER(UH.HOTEL_NAME) = UPPER(apex_application.g_x01)',
'        --            ) a',
'        --            --,TABLE(ALGO_EVALUATOR_PKG.EVALUATE(a.id, NULL)) t',
'        -- ) LOOP',
'        --     APEX_JSON.WRITE(rec_algo.HOTEL_OCCUPANCY);',
'        -- END LOOP;',
'        -- APEX_JSON.CLOSE_ARRAY; -- OCCUPANCY ',
'      ',
'',
'    APEX_JSON.OPEN_ARRAY(''Price_Override'');',
'        FOR rec_algo IN (',
'',
'                     select distinct REPLACE(TYPE, '' '', ''_'')  as Price_Override from UR_HOTEL_PRICE_OVERRIDE where HOTEL_ID =rec_hotel.id and status = ''A''',
'        ) LOOP',
'            APEX_JSON.WRITE(rec_algo.Price_Override);',
'        END LOOP;',
'        APEX_JSON.CLOSE_ARRAY; -- Price_Override',
'',
'        -- Hotel Occupancy (single value from UR_HOTELS)',
'        APEX_JSON.OPEN_ARRAY(''Hotel_Occupancy'');',
'        APEX_JSON.WRITE(''OCCUPANCY'');',
'        APEX_JSON.CLOSE_ARRAY; -- Hotel_Occupancy',
'',
'',
'        APEX_JSON.CLOSE_OBJECT; -- templates ',
'',
'        APEX_JSON.CLOSE_OBJECT; -- hotel ',
'    END LOOP;',
'',
'    APEX_JSON.CLOSE_OBJECT; -- root ',
'',
'    l_json := APEX_JSON.GET_CLOB_OUTPUT;',
'    APEX_JSON.FREE_OUTPUT;',
'',
'    HTP.P(l_json);',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
unistr('        -- \2705 Always return valid JSON for errors'),
'        APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'        APEX_JSON.OPEN_OBJECT;',
'        APEX_JSON.WRITE(''error'', SQLERRM);',
'        APEX_JSON.CLOSE_OBJECT;',
'        HTP.P(APEX_JSON.GET_CLOB_OUTPUT);',
'        APEX_JSON.FREE_OUTPUT;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45851681016562
);
wwv_flow_imp.component_end;
end;
/
