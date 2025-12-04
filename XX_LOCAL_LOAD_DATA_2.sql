create or replace PROCEDURE XX_LOCAL_Load_Data_2 (
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
    
    --taking mapping from template definition
    l_json clob;

    -- mapping record type
    TYPE t_map_rec IS RECORD (
        src_col     VARCHAR2(32000),  
        tgt_col     VARCHAR2(32000),  
        parser_col  VARCHAR2(32000),   
        data_type   VARCHAR2(1000),
        map_type    VARCHAR2(1000),
        orig_col    VARCHAR2(32000)
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

    -- Warning tracking for column-level issues (row succeeded but with data quality issues)
    l_warning_json   CLOB := '[';
    l_warning_cnt    NUMBER := 0;
    l_row_warnings   VARCHAR2(32767);  -- Accumulates warnings for current row
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
    SELECT db_object_name, id , definition
      INTO l_table_name, l_template_id, l_json
      FROM ur_templates
     WHERE upper(id) = upper(p_template_key);

    
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

--load from tempalte definition




        -- 4. Load mapping directly from collection
 FOR rec IN (
    SELECT 
        jt.name             AS src_col,
        jt.name             AS tgt_col,
        jt.original_name             AS orig_col,
        CASE 
            WHEN jt.mapping_type = 'Maps To' THEN jt.name
            WHEN jt.mapping_type IN ('Default', 'Calculation') THEN TRIM(jt.value)
        END                  AS parser_col,
        jt.mapping_type      AS map_type,
        (
            SELECT data_type
              FROM all_tab_cols
             WHERE table_name = (
                       SELECT db_object_name
                         FROM ur_templates
                        WHERE id = l_template_id
                   )
               AND UPPER(column_name) = UPPER(TRIM(jt.name))
               AND ROWNUM = 1
        )                    AS datatype1
    FROM ur_templates t,
         JSON_TABLE(
             t.definition,
             '$[*]'
             COLUMNS
                 name          VARCHAR2(100)  PATH '$.name',
                 data_type     VARCHAR2(50)   PATH '$.data_type',
                 qualifier     VARCHAR2(100)  PATH '$.qualifier',
                 mapping_type  VARCHAR2(50)   PATH '$.mapping_type',
                 value         VARCHAR2(4000) PATH '$.value',
                 original_name  VARCHAR2(4000) PATH '$.original_name'
         ) jt
    WHERE t.id = l_template_id
)
LOOP
    -- Assign to associative array
    l_mapping(UPPER(TRIM(rec.src_col))).src_col    := TRIM(rec.src_col);
    l_mapping(UPPER(TRIM(rec.src_col))).tgt_col    := TRIM(rec.tgt_col);
    l_mapping(UPPER(TRIM(rec.src_col))).parser_col := TRIM(rec.parser_col);
    l_mapping(UPPER(TRIM(rec.src_col))).data_type  := rec.datatype1;
    l_mapping(UPPER(TRIM(rec.src_col))).map_type   := TRIM(rec.map_type);
    l_mapping(UPPER(TRIM(rec.src_col))).orig_col   := TRIM(rec.orig_col);

    -- Debug logging
    INSERT INTO debug_log(message) VALUES('rec.src_col: ' || rec.src_col);
    INSERT INTO debug_log(message) VALUES('rec.tgt_col : ' || rec.tgt_col);
    INSERT INTO debug_log(message) VALUES('rec.parser_col : ' || rec.parser_col);
    INSERT INTO debug_log(message) VALUES('rec.map_type : ' || rec.map_type);
    INSERT INTO debug_log(message) VALUES('rec.data_type-----> : ' || rec.datatype1);
    COMMIT;
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
                        v_expr :=   l_mapping(k).parser_col ||' AS ' || upper(l_mapping(k).tgt_col);
                        
                    ELSIF l_mapping(k).map_type = 'Calculation' THEN
                        v_expr := REGEXP_REPLACE(
                                                 l_mapping(k).parser_col,
                                                 '#[^.]+\.(\w+)#',
                                                 'p.\1'
                                               ) ;
                        -- Apply GET_MAP_CALCULATION_FUN first
                        v_expr := GET_MAP_CALCULATION_FUN(v_expr, p_collection_name);
                        INSERT INTO debug_log(message) VALUES('Calculation v_expr before FN_CLEAN_NUMBER wrap: ' || v_expr);

                        -- First, wrap column references WITH p. prefix: p.COLUMN -> FN_CLEAN_NUMBER(p.COLUMN)
                        v_expr := REGEXP_REPLACE(
                                                 v_expr,
                                                 'p\.([A-Za-z_][A-Za-z0-9_]*)',
                                                 'FN_CLEAN_NUMBER(p.\1)'
                                               );
                        -- Then, wrap standalone column references WITHOUT p. prefix (but not numbers, keywords, or already wrapped)
                        -- Match word boundaries: column names not preceded by 'p.' or '(' and not followed by '('
                        v_expr := REGEXP_REPLACE(
                                                 v_expr,
                                                 '(^|[^A-Za-z0-9_.])([A-Za-z_][A-Za-z0-9_]*)([^A-Za-z0-9_(]|$)',
                                                 '\1FN_CLEAN_NUMBER(p.\2)\3'
                                               );
                        INSERT INTO debug_log(message) VALUES('Calculation v_expr after FN_CLEAN_NUMBER wrap: ' || v_expr);
                        v_expr := '(' || v_expr || ') AS "' || UPPER(l_mapping(k).tgt_col) || '"';



                    ELSIF UPPER(NVL(l_mapping(k).map_type, '')) = 'IGNORE' THEN
                          -- <-- KEY CHANGE: Ignore mapping -> always insert NULL for this target column
                         v_expr := 'NULL AS "' || upper(l_mapping(k).tgt_col) || '"';                                         

                    ELSE    
                            -- safe conversions
                            IF l_mapping(k).data_type = 'NUMBER' THEN  
                              /* -- v_expr := 'CASE WHEN REGEXP_LIKE(p.'|| l_mapping(k).parser_col ||', ''^-?\d+(\.\d+)?$'') '||
                               --           'THEN TO_NUMBER(p.'|| l_mapping(k).parser_col ||') ELSE NULL END'; 
                                v_expr := 'CASE WHEN REGEXP_LIKE(p.'|| l_mapping(k).parser_col ||', ''^-?\d+(\.\d+)?$'') '||
                                         'THEN TO_NUMBER(p.'|| l_mapping(k).parser_col ||' DEFAULT NULL ON CONVERSION ERROR) ELSE NULL END  as ' || l_mapping(k).parser_col ||' ';           

                             l_mapping(k).data_type = 'NUMBER' THEN*/
        -- ✅ Replace this block with FN_CLEAN_NUMBER
        v_expr := 'FN_CLEAN_NUMBER(p.' || l_mapping(k).parser_col || ') AS "' || upper(l_mapping(k).tgt_col) || '"';
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
  ' ELSE NULL END as ' || upper(l_mapping(k).parser_col);


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
        l_row_warnings := NULL;  -- Reset warnings for this row


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

                -- Column validation variables
                l_expected_type    VARCHAR2(100);
                l_is_valid         BOOLEAN;
                l_warning_detail   VARCHAR2(4000);
            BEGIN
                IF NOT l_elem.is_object THEN
                    RAISE_APPLICATION_ERROR(-20002,'Row not a JSON object');
                END IF;

                l_obj := TREAT(l_elem AS JSON_OBJECT_T);
                l_keys := l_obj.get_keys;

                FOR j IN 1..l_keys.count LOOP
                    --l_col := UPPER(REPLACE(REPLACE(l_keys(j), '__', '_'), ' ', '_'));
                    l_col := sanitize_column_name(l_keys(j));

                    k := l_mapping.first;
                    WHILE k IS NOT NULL LOOP
                        IF l_mapping.exists(k)
                           AND l_mapping(k).tgt_col IS NOT NULL 
                        THEN
                        INSERT INTO debug_log(message) VALUES('--- l_col:>   '||upper(l_mapping(k).orig_col));
                                if upper(l_col) = upper(l_mapping(k).orig_col) then
                                    l_col := upper(l_mapping(k).tgt_col);
                                end if;

                            k := l_mapping.next(k);
                        end if;
                    END LOOP;
                    

                    l_val := l_obj.get_string(l_keys(j));
                    INSERT INTO debug_log(message) VALUES('--- l_col:>' || l_col );
                    INSERT INTO debug_log(message) VALUES('--- l_val:>' || l_val );

                    -- ============================================================
                    -- COLUMN-LEVEL VALIDATION: Check data quality and log warnings
                    -- ============================================================
                    IF l_mapping.exists(UPPER(l_col)) THEN
                        l_expected_type := l_mapping(UPPER(l_col)).data_type;
                        l_is_valid := TRUE;
                        l_warning_detail := NULL;

                        -- Validate NUMBER columns
                        IF l_expected_type = 'NUMBER' AND l_val IS NOT NULL AND LENGTH(TRIM(l_val)) > 0 THEN
                            -- Check if value is numeric (after cleaning)
                            IF FN_CLEAN_NUMBER(l_val) IS NULL AND TRIM(l_val) IS NOT NULL THEN
                                l_is_valid := FALSE;
                                l_warning_detail := 'Column "' || l_col || '": Expected numeric value, got "' ||
                                                   SUBSTR(l_val, 1, 50) ||
                                                   CASE WHEN LENGTH(l_val) > 50 THEN '...' ELSE '' END ||
                                                   '" - value will be set to NULL';
                            END IF;
                        END IF;

                        -- Validate DATE columns
                        IF l_expected_type = 'DATE' AND l_val IS NOT NULL AND LENGTH(TRIM(l_val)) > 0 THEN
                            IF fn_safe_to_date(l_val) IS NULL THEN
                                l_is_valid := FALSE;
                                l_warning_detail := 'Column "' || l_col || '": Expected date value, got "' ||
                                                   SUBSTR(l_val, 1, 50) ||
                                                   CASE WHEN LENGTH(l_val) > 50 THEN '...' ELSE '' END ||
                                                   '" - value will be set to NULL';
                            END IF;
                        END IF;

                        -- Validate CALCULATION columns (check if source values used in calculation are valid)
                        IF l_mapping(UPPER(l_col)).map_type = 'Calculation' AND l_val IS NOT NULL AND LENGTH(TRIM(l_val)) > 0 THEN
                            IF FN_CLEAN_NUMBER(l_val) IS NULL AND TRIM(l_val) IS NOT NULL THEN
                                l_is_valid := FALSE;
                                l_warning_detail := 'Column "' || l_col || '" (used in calculation): Non-numeric value "' ||
                                                   SUBSTR(l_val, 1, 50) ||
                                                   CASE WHEN LENGTH(l_val) > 50 THEN '...' ELSE '' END ||
                                                   '" - calculation result will be NULL';
                            END IF;
                        END IF;

                        -- Accumulate warnings for this row
                        IF NOT l_is_valid AND l_warning_detail IS NOT NULL THEN
                            IF l_row_warnings IS NOT NULL THEN
                                l_row_warnings := l_row_warnings || '; ';
                            END IF;
                            l_row_warnings := l_row_warnings || l_warning_detail;
                        END IF;
                    END IF;
                    -- ============================================================

                    l_sql_select := l_sql_select|| ''''|| REPLACE(l_val, '''', '''''') || ''' as '|| l_col||' , ';

                    -- Capture STAY_DATE value
                     INSERT INTO debug_log(message) VALUES(l_stay_col_name||'--- check stay_date:>   '||l_col);
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
INSERT INTO debug_log(message) VALUES('--- l_val_formatted:>' || l_val_formatted );
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
    --  No STAY_DATE in template → simple INSERT only
    l_sql_main :=
        'INSERT INTO '|| l_table_name ||' (HOTEL_ID,'|| l_cols ||',INTERFACE_LOG_ID)
         SELECT '''||p_hotel_id||''' AS HOTEL_ID,'|| l_cols ||','''||l_log_id||''' AS INTERFACE_LOG_ID '||
        '  FROM ( SELECT  '||l_vals_calculation||' FROM ( SELECT ' || rtrim(l_sql_select, ', ')  ||' FROM DUAL)p'|| 
        ' WHERE 1=1 )';
END IF;



        INSERT INTO debug_log(message) VALUES('--- l_sql_main:>   '||l_sql_main);
        
            
                EXECUTE IMMEDIATE l_sql_main;

                l_success_cnt := l_success_cnt + 1;

                -- ============================================================
                -- LOG WARNINGS: Row succeeded but had data quality issues
                -- ============================================================
                IF l_row_warnings IS NOT NULL THEN
                    l_warning_cnt := l_warning_cnt + 1;
                    l_warning_json := l_warning_json ||
                        '{"row":' || l_total_rows ||
                        ',"line":' || NVL(TO_CHAR(v_line_number), 'null') ||
                        ',"status":"WARNING"' ||
                        ',"details":"' || REPLACE(REPLACE(l_row_warnings, '"', ''''), CHR(10), ' ') || '"},';
                END IF;
                -- ============================================================

            END;
        EXCEPTION
            WHEN OTHERS THEN
                l_fail_cnt := l_fail_cnt + 1;
                -- Enhanced error message with more context
                l_error_json := l_error_json ||
                    '{"row":' || NVL(TO_CHAR(l_total_rows), '0') ||
                    ',"line":' || NVL(TO_CHAR(v_line_number), 'null') ||
                    ',"status":"FAILED"' ||
                    ',"error":"' || REPLACE(REPLACE(SQLERRM, '"', ''''), CHR(10), ' ') || '"' ||
                    CASE WHEN l_row_warnings IS NOT NULL
                         THEN ',"data_issues":"' || REPLACE(REPLACE(l_row_warnings, '"', ''''), CHR(10), ' ') || '"'
                         ELSE ''
                    END || '},';
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

    -- finalize warning JSON
    IF l_warning_json IS NOT NULL AND l_warning_json <> '[' THEN
        IF SUBSTR(l_warning_json,-1) = ',' THEN
            l_warning_json := SUBSTR(l_warning_json,1,LENGTH(l_warning_json)-1);
        END IF;
        l_warning_json := l_warning_json || ']';
    ELSE
        l_warning_json := NULL;
    END IF;

    COMMIT;

    -- Update log with both errors and warnings
    -- Note: load_status limited to 20 chars
    UPDATE ur_interface_logs
       SET load_end_time = systimestamp,
           load_status   = CASE
                             WHEN l_fail_cnt > 0 AND l_success_cnt = 0 THEN 'FAILED'
                             WHEN l_fail_cnt > 0 AND l_success_cnt > 0 THEN 'PARTIAL'
                             WHEN l_warning_cnt > 0 THEN 'WARNING'
                             ELSE 'SUCCESS'
                           END,
           updated_on    = sysdate,
           error_json    = CASE
                             WHEN l_error_json IS NOT NULL AND l_warning_json IS NOT NULL THEN
                               '{"errors":' || l_error_json || ',"warnings":' || l_warning_json || '}'
                             WHEN l_error_json IS NOT NULL THEN
                               '{"errors":' || l_error_json || '}'
                             WHEN l_warning_json IS NOT NULL THEN
                               '{"warnings":' || l_warning_json || '}'
                             ELSE NULL
                           END,
           RECORDS_PROCESSED = l_total_rows,
           RECORDS_SUCCESSFUL = l_success_cnt,
           RECORDS_FAILED = l_fail_cnt
     WHERE id = l_log_id;


    p_status  := CASE
                    WHEN l_total_rows = l_fail_cnt THEN 'E'
                    WHEN l_fail_cnt > 0 OR l_warning_cnt > 0 THEN 'W'
                    ELSE 'S'
                 END;

    p_message :=
        CASE
            -- All rows succeeded with no warnings
            WHEN l_total_rows = l_success_cnt AND l_warning_cnt = 0 THEN
                l_total_rows || ' rows uploaded successfully.'

            -- All rows succeeded but some had data quality warnings
            WHEN l_total_rows = l_success_cnt AND l_warning_cnt > 0 THEN
                '<a href="' ||
                    APEX_PAGE.GET_URL(
                        p_page        => 4,
                        p_items       => 'P4_INTERFACE_ID_1',
                        p_values      => RAWTOHEX(l_log_id),
                        p_request     => 'MODAL'
                    ) ||
                '" style="color:#000;text-decoration:underline;" data-dialog="true">' ||
                l_success_cnt || ' rows uploaded with ' || l_warning_cnt || ' data quality warnings</a>'

            -- All rows failed
            WHEN l_total_rows = l_fail_cnt THEN
                '<a href="' ||
                    APEX_PAGE.GET_URL(
                        p_page        => 4,
                        p_items       => 'P4_INTERFACE_ID_1',
                        p_values      => RAWTOHEX(l_log_id),
                        p_request     => 'MODAL'
                    ) ||
                '" style="color:#000;text-decoration:underline;" data-dialog="true">' ||
                'Upload failed: ' || l_fail_cnt || ' rows with errors</a>'

            -- Partial success (some rows failed, some succeeded)
            ELSE
                '<a href="' ||
                    APEX_PAGE.GET_URL(
                        p_page        => 4,
                        p_items       => 'P4_INTERFACE_ID_1',
                        p_values      => RAWTOHEX(l_log_id),
                        p_request     => 'MODAL'
                    ) ||
                '" style="color:#000;text-decoration:underline;" data-dialog="true">' ||
                l_success_cnt || ' rows uploaded, ' || l_fail_cnt || ' failed' ||
                CASE WHEN l_warning_cnt > 0 THEN ', ' || l_warning_cnt || ' warnings' ELSE '' END ||
                '</a>'
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
END XX_LOCAL_Load_Data_2;
/