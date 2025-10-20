create or replace PROCEDURE XX_LOCAL_Load_Data_1 (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT varchar2,
    p_message         OUT VARCHAR2
) IS
    l_blob        BLOB;
    l_file_name   VARCHAR2(2550);
    l_table_name  VARCHAR2(2550);
    l_template_id RAW(16);
    l_total_rows  NUMBER := 0;
    l_success_cnt NUMBER := 0;
    l_fail_cnt    NUMBER := 0;
    l_log_id      RAW(16);
    l_error_json  CLOB := '[';
    l_first_err   BOOLEAN := TRUE;
    l_collection_name VARCHAR2(2550);
    l_debug boolean := FALSE;
        -- Dynamic headers
    TYPE t_headers IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    v_headers      t_headers;
    v_col_count    PLS_INTEGER := 0;

    -- JSON / dynamic variables
    v_profile_clob CLOB;
    v_sql_json     CLOB;
    c              SYS_REFCURSOR;
    v_row_json     CLOB;
    v_line_number  NUMBER;

    -- Row processing
  
    l_vals         VARCHAR2(32767);
    l_set          VARCHAR2(32767);
    l_stay_col_name VARCHAR2(200);
    l_stay_val     VARCHAR2(4000);

    -- mapping record type
    TYPE t_map_rec IS RECORD (
        src_col     VARCHAR2(32000),  
        tgt_col     VARCHAR2(32000),  
        parser_col  VARCHAR2(32000),   
        data_type   VARCHAR2(1000),
        map_type    VARCHAR2(1000)
    );
    TYPE t_map IS TABLE OF t_map_rec INDEX BY VARCHAR2(32000);

    l_mapping   t_map;
    l_apex_user VARCHAR2(255) := NVL(v('APP_USER'),'APEX_USER');

    l_cols   VARCHAR2(32767);
     l_cols_JSON   VARCHAR2(32767);
    l_vals_CALCULATION   VARCHAR2(32767);
    l_sql    CLOB;
    k        VARCHAR2(32000);
    v_expr   VARCHAR2(32767);
    l_map_count NUMBER;

    -- ADDED: variable for duplicate check
    l_existing_cnt NUMBER;
    l_error varchar2(32000);
BEGIN
    -------------------------------------------------------------------
    -- 0. DUPLICATE CHECK: stop if file already uploaded successfully
    -------------------------------------------------------------------
    SELECT COUNT(*)
      INTO l_existing_cnt
      FROM ur_interface_logs
     WHERE file_id   = p_file_id
       AND load_status = 'SUCCESS';

    IF l_existing_cnt > 0 THEN
        p_status  := 'E';
        p_message := 'Failure: File is already uploaded successfully.';
        RETURN;
    END IF;

    -- 1. Get blob and file name
    SELECT blob_content, filename
      INTO l_blob, l_file_name
      FROM temp_blob
     WHERE id = p_file_id;
     
     /*
    IF l_file_name < 0 THEN
        p_status  := FALSE;
        p_message := 'Failure: File ID '||p_file_id||' is already uploaded successfully.';
        RETURN;
    END IF;*/

    -- 2. Get target table name + template id
    SELECT db_object_name, id
      INTO l_table_name, l_template_id
      FROM ur_templates
     WHERE upper(id) = upper(p_template_key);

    -- 3. Insert log entry
    l_log_id := sys_guid();
    INSERT INTO ur_interface_logs (
        id, hotel_id, template_id, interface_type,
        load_start_time, load_status, created_by, updated_by,
        created_on, updated_on, file_id
    )
    VALUES (
        l_log_id,
        p_hotel_id,
        l_template_id,
        'UPLOAD',
        systimestamp,
        'IN_PROGRESS',
        hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
        hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
        sysdate, sysdate,
        p_file_id
    );

       BEGIN
        SELECT jt.name
          INTO l_stay_col_name
          FROM ur_templates t,
               JSON_TABLE(
                 t.definition,
                 '$[*]'
                 COLUMNS (
                   name       VARCHAR2(200) PATH '$.name',
                   qualifier  VARCHAR2(200) PATH '$.qualifier'
                 )
               ) jt
         WHERE t.id = l_template_id
           AND UPPER(jt.qualifier) = 'STAY_DATE'
         FETCH FIRST 1 ROWS ONLY;
        INSERT INTO debug_log(message) VALUES('Found STAY_DATE column in template: ' || l_stay_col_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            l_stay_col_name := NULL;
            INSERT INTO debug_log(message) VALUES('No STAY_DATE configured in template');
    END;
--l_stay_col_name := TO_CHAR(TO_DATE(l_stay_col_name,'DD/MM/YYYY'),'DD/MM/YYYY');

        -- 4. Load mapping directly from collection
    FOR rec IN (
        SELECT regexp_substr(c001, '^[^(]+')                    src_col,
               regexp_substr(c002, '^[^(]+')                    tgt_col,
               CASE WHEN c003 = 'Maps To' THEN regexp_substr(c002, '^[^(]+') 
               WHEN  c003 in ('Default','Calculation')  THEN TRIM(c004)  END                                    parser_col,
               c003                                             map_type,
             --  UPPER(regexp_replace(c001, '^[^(]+\(([^)]+)\).*', '\1')) datatype
               (select DATA_TYPE from all_tab_cols where 
               TABLE_NAME like (select db_object_name from ur_templates where id = l_template_id)
               and upper(COLUMN_NAME) like upper(TRIM(regexp_substr(c002, '^[^(]+')))   ) datatype1
          FROM apex_collections
         WHERE collection_name = p_collection_name
       --   AND c003 in ('Maps To','Default')
          -- AND c004 IS NOT NULL
    ) LOOP 
 
        l_mapping(UPPER(TRIM(rec.src_col))).src_col    := TRIM(rec.src_col);
        l_mapping(UPPER(TRIM(rec.src_col))).tgt_col    := TRIM(rec.tgt_col);
        l_mapping(UPPER(TRIM(rec.src_col))).parser_col := TRIM(rec.parser_col);
        l_mapping(UPPER(TRIM(rec.src_col))).data_type  := rec.datatype1;
        l_mapping(UPPER(TRIM(rec.src_col))).map_type  := TRIM(rec.map_type);
        INSERT INTO debug_log(message) VALUES('rec.src_col: ' || rec.src_col);
        INSERT INTO debug_log(message) VALUES('rec.tgt_col : ' || rec.tgt_col);
        INSERT INTO debug_log(message) VALUES('rec.parser_col : ' || rec.parser_col);
        INSERT INTO debug_log(message) VALUES('rec.map_type : ' || rec.map_type);
        INSERT INTO debug_log(message) VALUES('rec.data_type-----> : ' ||rec.datatype1);
    commit;
    END LOOP;
INSERT INTO debug_log(message) VALUES('l_template_id: ' || l_template_id);
    l_map_count := l_mapping.count;
    IF l_map_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No mapped columns found in collection!');
    END IF;

    -- 5. Build dynamic column list and values
    k := l_mapping.first;
    WHILE k IS NOT NULL LOOP
        IF l_mapping.exists(k)
           AND l_mapping(k).tgt_col IS NOT NULL
           --AND l_mapping(k).parser_col IS NOT NULL
        THEN
                    IF l_cols IS NOT NULL THEN
                        l_cols := l_cols || ',';
                        l_vals_calculation := l_vals_calculation || ',';
                    END IF;

                    l_cols := l_cols || l_mapping(k).tgt_col;

                    IF l_mapping(k).map_type = 'Default' THEN
                        v_expr :=   l_mapping(k).parser_col ||' AS ' || l_mapping(k).tgt_col;
                        
                    ELSIF l_mapping(k).map_type = 'Calculation' THEN
                        v_expr := REGEXP_REPLACE(
                                                 l_mapping(k).parser_col,
                                                 '#[^.]+\.(\w+)#',
                                                 'p.\1'
                                               ) ;
                        v_expr := GET_MAP_CALCULATION_FUN(v_expr,p_collection_name)||' AS ' || l_mapping(k).tgt_col;                                             

                    ELSE    
                            -- safe conversions
                            IF l_mapping(k).data_type = 'NUMBER' THEN  
                              /* -- v_expr := 'CASE WHEN REGEXP_LIKE(p.'|| l_mapping(k).parser_col ||', ''^-?\d+(\.\d+)?$'') '||
                               --           'THEN TO_NUMBER(p.'|| l_mapping(k).parser_col ||') ELSE NULL END'; 
                                v_expr := 'CASE WHEN REGEXP_LIKE(p.'|| l_mapping(k).parser_col ||', ''^-?\d+(\.\d+)?$'') '||
                                         'THEN TO_NUMBER(p.'|| l_mapping(k).parser_col ||' DEFAULT NULL ON CONVERSION ERROR) ELSE NULL END  as ' || l_mapping(k).parser_col ||' ';           

                             l_mapping(k).data_type = 'NUMBER' THEN*/
        -- ✅ Replace this block with FN_CLEAN_NUMBER
        v_expr := 'FN_CLEAN_NUMBER(p.' || l_mapping(k).parser_col || ') AS "' || l_mapping(k).tgt_col || '"';
       --v_expr := 'FN_CLEAN_NUMBER(''' || REPLACE(l_obj.get_string(l_mapping(k).parser_col), '''', '''''') || ''') AS "' || l_mapping(k).tgt_col || '"';



                            ELSIF l_mapping(k).data_type = 'DATE' THEN
   v_expr := 'CASE '||
  -- Full datetime with DD-MM-YYYY
  ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-\d{2}-\d{4}\s+\d{2}:\d{2}:\d{2}$'') '||
  '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MM-YYYY HH24:MI:SS'') '||

  -- Full datetime with DD/MM/YYYY
  ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}/\d{2}/\d{4}\s+\d{2}:\d{2}:\d{2}$'') '||
  '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD/MM/YYYY HH24:MI:SS'') '||

  -- Full datetime with DD-MON-YYYY
  ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-[A-Z]{3}-\d{4}\s+\d{2}:\d{2}:\d{2}$'', ''i'') '||
  '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MON-YYYY HH24:MI:SS'') '||

  -- Just date YYYY-MM-DD
  ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{4}-\d{2}-\d{2}$'') '||
  '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''YYYY-MM-DD'') '||

  -- Just date DD/MM/YYYY
  ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}/\d{2}/\d{4}$'') '||
  '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD/MM/YYYY'') '||

  -- Just date DD-MM-YYYY
  ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-\d{2}-\d{4}$'') '||
  '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MM-YYYY'') '||

  -- Just date DD-MON-YYYY
  ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-[A-Z]{3}-\d{4}$'', ''i'') '||
  '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MON-YYYY'') '||

  -- ✅ NEW: Just date DD-MON-RR (2-digit year)
  ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-[A-Z]{3}-\d{2}$'', ''i'') '||
  '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MON-RR'') '||

  -- Fallback
  ' ELSE NULL END as ' || l_mapping(k).parser_col;


                                INSERT INTO debug_log(message) VALUES('v_expr: ' || v_expr);

                            ELSE
                                v_expr := 'p.'|| l_mapping(k).parser_col;
                                INSERT INTO debug_log(message) VALUES('v_expr: ' || v_expr);
                   
                            END IF;
                        END IF;

                    l_vals_calculation := l_vals_calculation || v_expr;
         END IF;
        k := l_mapping.next(k);
    END LOOP;
INSERT INTO debug_log(message) VALUES('l_cols: ' || l_cols);
INSERT INTO debug_log(message) VALUES('l_vals_calculation: ' || l_vals_calculation);
commit;

     -------------------------------------------------------------------
    -- 4. Discover file profile
    -------------------------------------------------------------------
    v_profile_clob := apex_data_parser.discover(
                         p_content   => l_blob,
                         p_file_name => l_file_name
                      );

    INSERT INTO debug_log(message) VALUES('apex_data_parser.discover done');

    -------------------------------------------------------------------
    -- 5. Insert initial log row
    -------------------------------------------------------------------
    l_log_id := sys_guid();
    INSERT INTO ur_interface_logs (
        id, hotel_id, template_id, interface_type,
        load_start_time, load_status, created_by, updated_by,
        created_on, updated_on, file_id
    )
    VALUES (
        l_log_id,
        p_hotel_id,
        l_template_id,
        'UPLOAD',
        systimestamp,
        'IN_PROGRESS',
        hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
        hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
        sysdate, sysdate,
        p_file_id
    );

    INSERT INTO debug_log(message) VALUES('Inserted ur_interface_logs id=' || RAWTOHEX(l_log_id));

    -------------------------------------------------------------------
    -- 6. Get dynamic headers from file
    -------------------------------------------------------------------
    FOR r IN (
        SELECT column_position, column_name
          FROM TABLE(apex_data_parser.get_columns(v_profile_clob))
         ORDER BY column_position
    ) LOOP
        v_headers(r.column_position) := r.column_name;
        v_col_count := r.column_position;
    END LOOP;

    INSERT INTO debug_log(message) VALUES('Detected ' || v_col_count || ' columns from file.');
    IF v_col_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No columns detected in uploaded file.');
    END IF;

    -------------------------------------------------------------------
    -- 7. Build JSON SQL
    -------------------------------------------------------------------
    v_sql_json := 'SELECT p.line_number, JSON_OBJECT(';
    FOR i IN 1..v_col_count LOOP
        IF i > 1 THEN v_sql_json := v_sql_json || ', '; END IF;
        v_sql_json := v_sql_json || '''' || REPLACE(v_headers(i), '''', '''''') || ''' VALUE NVL(p.col' || LPAD(i,3,'0') || ', '''')';
    END LOOP;
    v_sql_json := v_sql_json || ') AS row_json FROM TABLE(apex_data_parser.parse(p_content => :1, p_file_name => :2, p_skip_rows => 1)) p';

    INSERT INTO debug_log(message) VALUES('Built SQL for JSON parse (len=' || LENGTH(v_sql_json) || ')');

    -------------------------------------------------------------------
    -- 8. Process each row
    -------------------------------------------------------------------
    OPEN c FOR v_sql_json USING l_blob, l_file_name;
    LOOP
        FETCH c INTO v_line_number, v_row_json;
        EXIT WHEN c%NOTFOUND;

        l_total_rows := l_total_rows + 1;
        INSERT INTO debug_log(message) VALUES('--- Processing row #' || l_total_rows || ' line=' || NVL(TO_CHAR(v_line_number),'N/A'));
        INSERT INTO debug_log(message) VALUES('--- v_row_json row #' || v_row_json || ' line=' || NVL(TO_CHAR(v_line_number),'N/A'));

        -- Reset dynamic variables
        l_cols := NULL;
        l_vals := NULL;
        l_set  := NULL;
        l_stay_val := NULL;
       

        BEGIN
            DECLARE
                l_elem JSON_ELEMENT_T := JSON_ELEMENT_T.parse(v_row_json);
                l_obj  JSON_OBJECT_T;
                l_keys JSON_KEY_LIST;
                l_col  VARCHAR2(4000);
                l_val  VARCHAR2(4000);
                l_val_formatted VARCHAR2(4000);
                l_sql_select CLOB;
                l_sql_main clob;
                l_col_u clob;
                l_col_s clob;
                v_data_type VARCHAR2(1000);
                l_key       VARCHAR2(32000);
            BEGIN
                IF NOT l_elem.is_object THEN
                    RAISE_APPLICATION_ERROR(-20002,'Row not a JSON object');
                END IF;

                l_obj := TREAT(l_elem AS JSON_OBJECT_T);
                l_keys := l_obj.get_keys;

                FOR j IN 1..l_keys.count LOOP
                    --l_col := UPPER(REPLACE(REPLACE(l_keys(j), '__', '_'), ' ', '_'));
                    l_col := sanitize_column_name(l_keys(j));

                    l_val := l_obj.get_string(l_keys(j));
                    INSERT INTO debug_log(message) VALUES('--- l_col:>' || l_col );
                    INSERT INTO debug_log(message) VALUES('--- l_val:>' || l_val );
                    l_sql_select := l_sql_select|| ''''||l_val || ''' as '|| l_col||' , ';

                    -- Capture STAY_DATE value
                    IF l_stay_col_name IS NOT NULL AND l_col = UPPER(l_stay_col_name) THEN
                        l_stay_val := l_val;
                    else
                        l_col_u := l_col_u ||'t.' || l_col ||' = '||'s.'||l_col ||' ,';    
                    END IF;

                      



                    -- Format value
                    l_val_formatted := NULL;
                    IF l_val IS NOT NULL AND REGEXP_LIKE(l_val,'^-?\d+(\.\d+)?$') THEN
                        l_val_formatted := TO_CHAR(TO_NUMBER(l_val));
                    END IF;

                    IF l_val_formatted IS NULL THEN
                        l_val_formatted := '''' || REPLACE(NVL(l_val,''), '''', '''''') || '''';
                    END IF;

                    -- Append to dynamic SQL parts
                    IF l_set IS NOT NULL THEN
                        l_set  := l_set || ', ';
                        l_cols := l_cols || ', ';
                        l_vals := l_vals || ', ';
                    END IF;

                    l_set  := NVL(l_set,'')  || l_col || ' = ' || l_val_formatted;
                    l_cols := NVL(l_cols,'') || l_col;
                    --l_col_u := l_col_u ||'t.' || l_col ||' = '||'s.'||l_col ||' ,';
                    l_col_s := l_col_s ||'s.'||l_col||',';
                    l_vals := NVL(l_vals,'') || l_val_formatted;
                END LOOP;
                INSERT INTO debug_log(message) VALUES('--- l_sql_select:> SELECT  '||l_vals_calculation||' FROM ( SELECT ' || rtrim(l_sql_select, ', ')  ||' FROM DUAL)p');
              
         l_sql_main:=    'INSERT INTO '|| l_table_name ||' (HOTEL_ID,'|| l_cols ||',INTERFACE_LOG_ID) '||
        'SELECT '''||p_hotel_id||''' AS HOTEL_ID,'|| l_cols ||','''||l_log_id||''' AS INTERFACE_LOG_ID'||
        '  FROM ( SELECT  '||l_vals_calculation||' FROM ( SELECT ' || rtrim(l_sql_select, ', ')  ||' FROM DUAL)p'||
        ' WHERE 1=1 );';

--ON (t.HOTEL_ID = '''||p_hotel_id||''' and TO_CHAR(t.'||l_stay_col_name||',''DD/MM/YYYY'') = '''|| l_stay_val||''')   For Date
--ON (t.HOTEL_ID = '''||p_hotel_id||''' and t.'||l_stay_col_name||' = '''|| l_stay_val||''')                           For char
/*l_stay_val := TO_CHAR(fn_safe_to_date(l_stay_val), 'DD/MM/YYYY');
          
            
l_sql_main :=
'MERGE INTO '|| l_table_name ||' t
USING (SELECT '''||p_hotel_id||''' AS HOTEL_ID,'|| l_cols ||','''||l_log_id||''' AS INTERFACE_LOG_ID'||
        '  FROM ( SELECT  '||l_vals_calculation||' FROM ( SELECT ' || rtrim(l_sql_select, ', ')  ||' FROM DUAL)p'||
        ' WHERE 1=1 )) s
ON (t.HOTEL_ID = '''||p_hotel_id||''' and TO_CHAR(t.'||l_stay_col_name||',''DD/MM/YYYY'') = '''|| l_stay_val||''') 
WHEN MATCHED THEN
    UPDATE SET '|| rtrim(l_col_u, ', ')  ||'
WHEN NOT MATCHED THEN
   INSERT  (HOTEL_ID,'|| l_cols ||',INTERFACE_LOG_ID) '||
        'values (s.HOTEL_ID, '||rtrim(l_col_s, ', ')||',s.INTERFACE_LOG_ID)';*/
        
        IF l_stay_col_name IS NOT NULL THEN
    -- 🟢 Use MERGE for UPSERT when STAY_DATE qualifier exists
    l_stay_val := TO_CHAR(fn_safe_to_date(l_stay_val), 'DD/MM/YYYY');

    l_sql_main :=
        'MERGE INTO '|| l_table_name ||' t
         USING (SELECT '''||p_hotel_id||''' AS HOTEL_ID,'|| l_cols ||','''||l_log_id||''' AS INTERFACE_LOG_ID '||
        '  FROM ( SELECT  '||l_vals_calculation||' FROM ( SELECT ' || rtrim(l_sql_select, ', ')  ||' FROM DUAL)p'|| 
        ' WHERE 1=1 )) s
         ON (t.HOTEL_ID = '''||p_hotel_id||''' 
             AND TO_CHAR(t.'||l_stay_col_name||',''DD/MM/YYYY'') = '''|| l_stay_val||''')
         WHEN MATCHED THEN
             UPDATE SET '|| rtrim(l_col_u, ', ')  ||'
         WHEN NOT MATCHED THEN
             INSERT (HOTEL_ID,'|| l_cols ||',INTERFACE_LOG_ID)
             VALUES (s.HOTEL_ID, '||rtrim(l_col_s, ', ')||',s.INTERFACE_LOG_ID)';
ELSE
    -- 🔵 No STAY_DATE in template → simple INSERT only
    l_sql_main :=
        'INSERT INTO '|| l_table_name ||' (HOTEL_ID,'|| l_cols ||',INTERFACE_LOG_ID)
         SELECT '''||p_hotel_id||''' AS HOTEL_ID,'|| l_cols ||','''||l_log_id||''' AS INTERFACE_LOG_ID '||
        '  FROM ( SELECT  '||l_vals_calculation||' FROM ( SELECT ' || rtrim(l_sql_select, ', ')  ||' FROM DUAL)p'|| 
        ' WHERE 1=1 )';
END IF;



        INSERT INTO debug_log(message) VALUES('--- l_sql_main:>   '||l_sql_main);
        
            
                EXECUTE IMMEDIATE l_sql_main;
           



                l_success_cnt := l_success_cnt + 1;

            END;
        EXCEPTION
            WHEN OTHERS THEN
                l_fail_cnt := l_fail_cnt + 1;
                l_error_json := l_error_json || '{"row":' || l_total_rows || ',"error":"' || REPLACE(SQLERRM,'"','''') || '"},';
        END;
    END LOOP;
    CLOSE c;

    -- finalize error JSON
    IF l_error_json IS NOT NULL AND l_error_json <> '[' THEN
        IF SUBSTR(l_error_json,-1) = ',' THEN
            l_error_json := SUBSTR(l_error_json,1,LENGTH(l_error_json)-1);
        END IF;
        l_error_json := l_error_json || ']';
    ELSE
        l_error_json := NULL;
    END IF;

    COMMIT;

    -- Update log
    UPDATE ur_interface_logs
       SET load_end_time = systimestamp,
           load_status   = case when l_fail_cnt > 0 then 'FAILED' else 'SUCCESS' end,
           updated_on    = sysdate,
           error_json    = l_error_json,
           RECORDS_PROCESSED = l_total_rows,
           RECORDS_SUCCESSFUL = l_success_cnt,
           RECORDS_FAILED = l_fail_cnt
     WHERE id = l_log_id;


    p_status  := case when l_total_rows = l_fail_cnt then 'E' 
                    when l_total_rows = l_success_cnt then 'S'
                    ELSE 'W' END;
   /* p_message := case when l_total_rows = l_fail_cnt then 'Failure' 
                      when l_total_rows = l_success_cnt then 'Success'
    ELSE 'Warning' END||': Upload completed → Total=' || l_total_rows || ', Success=' || l_success_cnt || ', Failed=' || l_fail_cnt;
*/
p_message :=
    CASE
        WHEN l_total_rows = l_success_cnt THEN
            'Success: Upload completed → Total=' || l_total_rows ||
            ', Success=' || l_success_cnt ||
            ', Failed=' || l_fail_cnt

        WHEN l_total_rows = l_fail_cnt THEN
            '<span style="color:red;">Failure: ' || l_fail_cnt || ' rows failed. ' ||
            '<a href="' ||
                APEX_PAGE.GET_URL(
                    p_page        => 4,
                    p_items       => 'P4_INTERFACE_ID_1',
                    p_values      => RAWTOHEX(l_log_id),
                    p_request     => 'MODAL'
                ) ||
            '" class="u-success-text" data-dialog="true">Click here to view errors</a></span>' ||
            '<br>Total=' || l_total_rows ||
            ', Success=' || l_success_cnt ||
            ', Failed=' || l_fail_cnt

        ELSE
            'Warning: Upload completed → Total=' || l_total_rows ||
            ', Success=' || l_success_cnt ||
            ', Failed=' || l_fail_cnt
    END;

    INSERT INTO debug_log(message) VALUES('Completed Load_Data - ' || p_message);

EXCEPTION
    WHEN OTHERS THEN
        DECLARE
            l_err_msg VARCHAR2(4000);
        BEGIN
            l_err_msg := SQLERRM;

            p_status  := 'E';
            p_message := 'Failure: '|| l_err_msg;

            UPDATE ur_interface_logs
               SET load_end_time = systimestamp,
                   load_status   = 'FAILED',
                   error_json    = l_error_json || '{"error":"' || REPLACE(l_err_msg,'"','''') || '"}]',
                   updated_on    = sysdate,
                   RECORDS_PROCESSED = l_total_rows,
                   RECORDS_SUCCESSFUL = l_success_cnt,
                   RECORDS_FAILED = l_fail_cnt
             WHERE id = l_log_id;

            ROLLBACK;
        END;
END XX_LOCAL_Load_Data_1;
/
