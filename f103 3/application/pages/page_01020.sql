prompt --application/pages/page_01020
begin
--   Manifest
--     PAGE: 01020
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
 p_id=>1020
,p_name=>'Page Template'
,p_alias=>'PAGE-TEMPLATE1'
,p_step_title=>'Page Template'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'https://cdn.jsdelivr.net/npm/sweetalert2@11'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'function showAlert(title, message, icon = ''success'', timer = 2500) {',
'',
'    const showConfirmation = (icon === ''error'' || icon === ''warning'');',
'',
'    const Toast = Swal.mixin({',
'        toast: true,',
'        position: "top-end",',
'        showConfirmButton: showConfirmation,',
'        timer: 3000,',
'        timerProgressBar: true,',
'        didOpen: (toast) => {',
'            toast.onmouseenter = Swal.stopTimer;',
'            toast.onmouseleave = Swal.resumeTimer;',
'        }',
'    });',
'',
'    Toast.fire({',
'        icon: icon,',
'        title: message',
'    });',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(10490325109115720)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(8558440305922134)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29902423361781321)
,p_name=>'P1020_ALERT_TITLE'
,p_item_sequence=>10
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29902539468781322)
,p_name=>'P1020_ALERT_MESSAGE'
,p_item_sequence=>20
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29902595966781323)
,p_name=>'P1020_ALERT_ICON'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(29971817395806490)
,p_name=>'P1020_ALERT_TIMER'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10494482121115755)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1020_FILE_LOAD'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10494952513115756)
,p_event_id=>wwv_flow_imp.id(10494482121115755)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10495344475115758)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1020_TEMPLATE_LOV'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10495895362115760)
,p_event_id=>wwv_flow_imp.id(10495344475115758)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'BEGIN',
'  -- Insert the template',
'  INSERT INTO UR_TEMPLATES (',
'    KEY,',
'    NAME,',
'    TYPE,',
'    ACTIVE,',
'    DEFINITION,',
'    CREATED_BY,',
'    CREATED_ON,',
'    UPDATED_BY,',
'    UPDATED_ON',
'  ) VALUES (',
'    ''EXP_TEMPLATE_''|| ROUND(',
'    (CAST(SYSTIMESTAMP AT TIME ZONE ''UTC'' AS DATE) - DATE ''1970-01-01'') * 86400',
'  ),',
'    ''Expense Template ''|| ROUND(',
'    (CAST(SYSTIMESTAMP AT TIME ZONE ''UTC'' AS DATE) - DATE ''1970-01-01'') * 86400',
'  ),',
'    ''RMS'',',
'    ''Y'',  -- or hardcode ''ADMIN''',
'    ''[{"name":"EMPLOYEE_NAME","data-type":1,"data-type-len":100,"selector":"Employee Name","is-json":false},{"name":"EXPENSE_ID","data-type":2,"selector":"Expense Id","is-json":false},{"name":"EXP_TYPE","data-type":1,"data-type-len":50,"selector":"Ex'
||'p Type","is-json":false},{"name":"PROJECT_NAME","data-type":1,"data-type-len":100,"selector":"Project Name","is-json":false},{"name":"EXPENSE_PURPOSE","data-type":1,"data-type-len":50,"selector":"Expense Purpose","is-json":false},{"name":"EXPENSE_DAT'
||'E_FROM","data-type":3,"selector":"Expense Date From","format-mask":"DD\"-\"MON\"-\"RR","is-json":false},{"name":"EXPENSE_DATE_TO","data-type":3,"selector":"Expense Date To","format-mask":"DD\"-\"MON\"-\"RR","is-json":false},{"name":"STATUS","data-typ'
||'e":1,"data-type-len":50,"selector":"Status","is-json":false},{"name":"CURRENCY","data-type":1,"data-type-len":50,"selector":"Currency","is-json":false},{"name":"CLAIM_AMOUNT","data-type":2,"selector":"Claim Amount","is-json":false},{"name":"EXPENSE_A'
||'TTACHMENT","data-type":2,"selector":"Expense Attachment","is-json":false},{"name":"EXPENSE_COMMENT","data-type":1,"data-type-len":32767,"selector":"Expense Comment","is-json":false},{"name":"CREATED_BY","data-type":1,"data-type-len":50,"selector":"Cr'
||'eated By","is-json":false},{"name":"CREATION_DATE","data-type":3,"selector":"Creation Date","format-mask":"YYYY\"-\"MM\"-\"DD\" \"HH24\":\"MI\":\"SS","is-json":false},{"name":"LAST_UPDATED_BY","data-type":1,"data-type-len":50,"selector":"Last Updated'
||' By","is-json":false},{"name":"LAST_UPDATE_DATE","data-type":3,"selector":"Last Update Date","format-mask":"YYYY\"-\"MM\"-\"DD\" \"HH24\":\"MI\":\"SS","is-json":false}]'',',
'    ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP,',
'        ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP',
'  );',
'END;',
''))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10496245784115761)
,p_name=>'Page_Load_DA'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10493159366115749)
,p_name=>'New_3'
,p_event_sequence=>90
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'body'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'showAlert'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10493668855115753)
,p_event_id=>wwv_flow_imp.id(10493159366115749)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var title = $v(''P1020_ALERT_TITLE'') || ''Notification'';',
'var message = $v(''P1020_ALERT_MESSAGE'');',
'var icon  = $v(''P1020_ALERT_ICON'') || ''success'';',
'',
'if(message){',
'  Swal.fire({',
'    position: ''top-end'',',
'    icon: icon,',
'    title: title,',
'    text: message,',
'    showConfirmButton: false,',
'    timer: 2500',
'  });',
'  ',
'  $s(''P1020_ALERT_MESSAGE'','''');',
'}'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(10492781105115748)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_json CLOB;',
'BEGIN',
'  l_json := UR_utils.get_collection_json(''UR_FILE_DATA_PROFILES'');',
'',
'  INSERT INTO UR_TEMPLATES (',
'    KEY,',
'    NAME,',
'    TYPE,',
'    ACTIVE,',
'    DEFINITION,',
'    CREATED_BY,',
'    CREATED_ON,',
'    UPDATED_BY,',
'    UPDATED_ON',
'  ) VALUES (',
'    UPPER(',
'      SUBSTR(',
'        REGEXP_REPLACE(',
'          REGEXP_REPLACE(',
'            REGEXP_REPLACE(',
'              TRIM(:P1020_TEMPLATE_NAME),',
'              ''^[^A-Za-z0-9]+|[^A-Za-z0-9]+$'', ''''',
'            ),',
'            ''[^A-Za-z0-9]+'', ''_''',
'          ),',
'          ''_+'', ''_''',
'        ),',
'        1, 110',
'      )',
'    ),',
'    :P1020_TEMPLATE_NAME,',
'    :P1020_TEMPLATE_TYPE,',
'    ''Y'',  -- or hardcode ''ADMIN''',
'    l_json,',
'    ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP,',
'    ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP',
'  );',
'',
'  apex_debug.message(''Debug info: '' || l_json);',
'  ',
'  apex_pwa.send_push_notification (',
'    p_application_id => 103,',
'    p_user_name      => ''VKANT'',',
'    p_title          => ''Template Created Successfully.'',',
'    p_body           => ''Order #123456 will arrive within 3 days.'' );',
'',
'--   :P1020_AI_RESPONSE := ''Insert Successful'';',
'apex_pwa.push_queue;',
'-- RETURN ''SUCCESS'';',
'',
'--   apex.message.showToast(',
'--     pMessage => ''Changes saved'',',
'--     pPosition => ''top-right'',   -- or ''top-left'', ''bottom-right'', ''bottom-left''',
'--     pDuration => 3000,          -- milliseconds; 0 means sticky until closed',
'--     pCloseIcon => true,         -- show a close (x) icon',
'--     pStyle => ''success''         -- values: ''success'', ''warning'', ''error'', ''information''',
'--   );',
'',
'-- apex_application.g_print_success_message := ''Record saved successfully!'';',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    -- :P1020_AI_RESPONSE := ''Insert Failed: '' || SQLERRM;',
'    apex_debug.message(''Insert Failed: '' || SQLERRM);',
'    -- RETURN ''Failed ''||SQLERRM;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Blah blah blah'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Succesfully Done'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>10492781105115748
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(10492314283115745)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_profile_clob CLOB;',
'  v_records NUMBER;',
'  v_columns CLOB;',
'',
'  -- Variables for parsing v_columns JSON',
'  CURSOR cur_columns IS',
'    SELECT jt.name, jt.data_type',
'      FROM JSON_TABLE(',
'             v_columns,',
'             ''$[*]''',
'             COLUMNS (',
'               name VARCHAR2(100) PATH ''$.name'',',
'               data_type VARCHAR2(20) PATH ''$."data-type"''',
'             )',
'           ) jt;',
'',
'BEGIN',
'  -- Create or truncate APEX collection before processing',
'  IF apex_collection.collection_exists(''UR_FILE_DATA_PROFILES'') THEN',
'    apex_collection.delete_collection(''UR_FILE_DATA_PROFILES'');',
'  END IF;',
'  ',
'  apex_collection.create_collection(''UR_FILE_DATA_PROFILES'');',
'',
'  FOR r IN (',
'    SELECT ID, APPLICATION_ID, NAME, FILENAME, MIME_TYPE, CREATED_ON, BLOB_CONTENT',
'      FROM APEX_APPLICATION_TEMP_FILES',
'     WHERE NAME = :P1020_FILE_LOAD',
'  ) LOOP',
'    INSERT INTO temp_BLOB (',
'      ID,',
'      APPLICATION_ID,',
'      NAME,',
'      FILENAME,',
'      MIME_TYPE,',
'      CREATED_ON,',
'      BLOB_CONTENT',
'    ) VALUES (',
'      r.ID,',
'      r.APPLICATION_ID,',
'      r.NAME,',
'      r.FILENAME,',
'      r.MIME_TYPE,',
'      r.CREATED_ON,',
'      r.BLOB_CONTENT',
'    );',
'  END LOOP;',
'',
'  FOR rec IN (',
'    SELECT ID, BLOB_CONTENT, filename, name',
'      FROM temp_BLOB',
'     WHERE profile IS NULL -- only parse if profile not yet loaded',
'  ) LOOP',
'    -- Call APEX_DATA_PARSER.GET_FILE_PROFILE on the blob content',
'    SELECT apex_data_parser.discover(',
'             p_content => rec.BLOB_CONTENT,',
'             p_file_name => rec.filename',
'           )',
'      INTO v_profile_clob',
'      FROM dual;',
'',
'    -- Extract "parsed-rows"',
'    SELECT TO_NUMBER(JSON_VALUE(v_profile_clob, ''$."parsed-rows"''))',
'      INTO v_records',
'      FROM dual;',
'',
'    -- Extract filtered columns with mapped data types',
'    SELECT TO_CLOB(',
'             JSON_ARRAYAGG(',
'               JSON_OBJECT(',
'                 ''name'' VALUE jt.name,',
'                 ''data-type'' VALUE CASE jt.data_type',
'                                    WHEN 1 THEN ''TEXT''',
'                                    WHEN 2 THEN ''NUMBER''',
'                                    WHEN 3 THEN ''DATE''',
'                                    ELSE ''TEXT''',
'                                  END',
'               )',
'             )',
'           )',
'      INTO v_columns',
'      FROM JSON_TABLE(v_profile_clob, ''$."columns"[*]''',
'             COLUMNS (',
'               name       VARCHAR2(100) PATH ''$.name'',',
'               data_type  NUMBER       PATH ''$."data-type"''',
'             )',
'          ) jt;',
'',
'    -- Insert each column into APEX collection',
'    FOR col IN cur_columns LOOP',
'      apex_collection.add_member(',
'        p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'        p_c001            => col.name,',
'        p_c002            => col.data_type',
'      );',
'    END LOOP;',
'',
'    -- Update temp_BLOB table',
'    UPDATE temp_BLOB',
'       SET profile = v_profile_clob,',
'           records = v_records,',
'           columns = v_columns',
'     WHERE ID = rec.ID;',
'  END LOOP;',
'',
'  COMMIT;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>10492314283115745
);
wwv_flow_imp.component_end;
end;
/
