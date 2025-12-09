prompt --application/shared_components/logic/application_processes/ajx_get_hotel_temp_all
begin
--   Manifest
--     APPLICATION PROCESS: AJX_GET_HOTEL_TEMP_ALL
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
 p_id=>wwv_flow_imp.id(12953111970538217)
,p_process_sequence=>1
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJX_GET_HOTEL_TEMP_ALL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_clob CLOB;',
'BEGIN',
'  APEX_JSON.INITIALIZE_CLOB_OUTPUT;',
'',
'  -- Start JSON array',
'  APEX_JSON.OPEN_ARRAY;',
'',
'  FOR rec IN (',
'    SELECT UT.ID,',
'           UT.HOTEL_ID,',
'           UT.DB_OBJECT_NAME,',
'           UT.NAME AS TEMP_NAME,',
'           UH.HOTEL_NAME',
'      FROM UR_TEMPLATES UT',
'      JOIN UR_HOTELS UH ON UH.ID = UT.HOTEL_ID',
'     WHERE UPPER(UH.HOTEL_NAME) = UPPER(apex_application.g_x01)',
'     --AND UPPER(UT.DEFINITION) like ''%STAY_DATE%''',
'     -- and UT.ID in (select TEMPLATE_ID FROM UR_ALGO_ATTRIBUTES where ATTRIBUTE_QUALIFIER = ''STAY_DATE'' and HOTEL_ID = rec_hotel.ID )',
'       AND UPPER(UT.DEFINITION) LIKE ''%''||(select NAME FROM UR_ALGO_ATTRIBUTES where ATTRIBUTE_QUALIFIER = ''STAY_DATE'' and TEMPLATE_ID  = UT.ID)||''%''',
'       and UT.ACTIVE = ''Y''',
'  ) LOOP',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(''id'', rec.id);',
'    APEX_JSON.WRITE(''hotel_id'', rec.hotel_id);',
'    APEX_JSON.WRITE(''db_object_name'', rec.db_object_name);',
'    APEX_JSON.WRITE(''temp_name'', rec.temp_name);',
'    APEX_JSON.WRITE(''hotel_name'', rec.hotel_name);',
'    APEX_JSON.CLOSE_OBJECT;',
'  END LOOP;',
'',
'  -- Add Hotel_Occupancy metadata entry',
'  FOR rec_hotel IN (',
'    SELECT UH.ID AS hotel_id, UH.HOTEL_NAME',
'      FROM UR_HOTELS UH',
'     WHERE UPPER(UH.HOTEL_NAME) = UPPER(apex_application.g_x01)',
'  ) LOOP',
'    APEX_JSON.OPEN_OBJECT;',
'    APEX_JSON.WRITE(''id'', rec_hotel.hotel_id);',
'    APEX_JSON.WRITE(''hotel_id'', rec_hotel.hotel_id);',
'    APEX_JSON.WRITE(''db_object_name'', ''UR_HOTELS'');',
'    APEX_JSON.WRITE(''temp_name'', ''Hotel_Occupancy'');',
'    APEX_JSON.WRITE(''hotel_name'', rec_hotel.hotel_name);',
'    APEX_JSON.CLOSE_OBJECT;',
'  END LOOP;',
'',
'  -- End JSON array',
'  APEX_JSON.CLOSE_ARRAY;',
'',
'  l_clob := APEX_JSON.GET_CLOB_OUTPUT;',
'  APEX_JSON.FREE_OUTPUT;',
'',
'  HTP.P(l_clob);',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    HTP.P(''{"error": "'' || SQLERRM || ''"}'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_security_scheme=>'MUST_NOT_BE_PUBLIC_USER'
,p_version_scn=>45851953359048
);
wwv_flow_imp.component_end;
end;
/
