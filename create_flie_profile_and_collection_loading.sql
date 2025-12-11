DECLARE
  v_profile_clob CLOB;
  v_records      NUMBER;
  v_columns      CLOB;

  -- Cursor to iterate over JSON columns
  CURSOR cur_columns IS
    SELECT jt.name, jt.data_type
      FROM JSON_TABLE(
             v_columns,
             '$[*]'
             COLUMNS (
               name       VARCHAR2(100) PATH '$.name',
               data_type  VARCHAR2(20) PATH '$."data-type"'
             )
           ) jt;

  -- Helper function to sanitize column names
  FUNCTION sanitize_column_name(p_name IN VARCHAR2) RETURN VARCHAR2 IS
  v_name VARCHAR2(4000);
BEGIN
  -- Replace non-alphanumeric characters with underscore
  v_name := REGEXP_REPLACE(p_name, '[^A-Za-z0-9]', '_');

  -- Replace multiple consecutive underscores with a single underscore
  v_name := REGEXP_REPLACE(v_name, '_+', '_');

  -- Trim leading and trailing underscores
  v_name := REGEXP_REPLACE(v_name, '^_+|_+$', '');

  -- Convert to uppercase
  RETURN UPPER(v_name);
END;


BEGIN
  -- Create or truncate APEX collection before processing
  IF apex_collection.collection_exists('UR_FILE_DATA_PROFILES') THEN
    apex_collection.delete_collection('UR_FILE_DATA_PROFILES');
  END IF;
  
  apex_collection.create_collection('UR_FILE_DATA_PROFILES');

  -- Copy uploaded file to temp table
  FOR r IN (
    SELECT ID, APPLICATION_ID, NAME, FILENAME, MIME_TYPE, CREATED_ON, BLOB_CONTENT
      FROM APEX_APPLICATION_TEMP_FILES
     WHERE NAME = :P1002_FILE_LOAD
  ) LOOP
    INSERT INTO temp_BLOB (
      ID,
      APPLICATION_ID,
      NAME,
      FILENAME,
      MIME_TYPE,
      CREATED_ON,
      BLOB_CONTENT
    ) VALUES (
      r.ID,
      r.APPLICATION_ID,
      r.NAME,
      r.FILENAME,
      r.MIME_TYPE,
      r.CREATED_ON,
      r.BLOB_CONTENT
    );
  END LOOP;

    :P1002_FILE_NAME_HIDDEN := :P1002_FILE_LOAD;

  -- Process each temp_BLOB record
  FOR rec IN (
    SELECT ID, BLOB_CONTENT, filename, name
      FROM temp_BLOB
     WHERE profile IS NULL -- only parse if profile not yet loaded
  ) LOOP
    -- Call APEX_DATA_PARSER to get file profile
    SELECT apex_data_parser.discover(
             p_content => rec.BLOB_CONTENT,
             p_file_name => rec.filename,
             p_max_rows => 99999
           )
      INTO v_profile_clob
      FROM dual;

    -- Extract parsed row count
    SELECT TO_NUMBER(JSON_VALUE(v_profile_clob, '$."parsed-rows"'))
      INTO v_records
      FROM dual;

    -- Extract columns and map data types
   /* SELECT TO_CLOB(
             JSON_ARRAYAGG(
               JSON_OBJECT(
                 'name' VALUE jt.name,
                 'data-type' VALUE CASE jt.data_type
                                    WHEN 1 THEN 'TEXT'
                                    WHEN 2 THEN 'NUMBER'
                                    WHEN 3 THEN 'DATE'
                                    ELSE 'TEXT'
                                  END
               )
             )
           )
      INTO v_columns
      FROM JSON_TABLE(
             v_profile_clob,
             '$."columns"[*]'
             COLUMNS (
               name       VARCHAR2(100) PATH '$.name',
               data_type  NUMBER       PATH '$."data-type"'
             )
           ) jt; commented to handle large files with 30+columns*/
           -- ✅ Build columns JSON safely as CLOB
    SELECT (
             SELECT JSON_ARRAYAGG(
                      JSON_OBJECT(
                        'name' VALUE jt.name,
                        'data-type' VALUE CASE jt.data_type
                                           WHEN 1 THEN 'TEXT'
                                           WHEN 2 THEN 'NUMBER'
                                           WHEN 3 THEN 'DATE'
                                           ELSE 'TEXT'
                                         END
                      )
                    RETURNING CLOB
                    )
             FROM JSON_TABLE(
                    v_profile_clob,
                    '$."columns"[*]'
                    COLUMNS (
                      name       VARCHAR2(200) PATH '$.name',
                      data_type  NUMBER        PATH '$."data-type"'
                    )
                  ) jt
           )
      INTO v_columns
      FROM dual;

    FOR col IN (
  SELECT jt.name, jt.data_type
    FROM JSON_TABLE(
           v_columns,
           '$[*]'
           COLUMNS (
             name       VARCHAR2(100) PATH '$.name',
             data_type  VARCHAR2(20) PATH '$."data-type"'
           )
         ) jt
) LOOP
  apex_collection.add_member(
    p_collection_name => 'UR_FILE_DATA_PROFILES',
    p_c001            => sanitize_column_name(col.name),
    p_c002            => col.data_type
  );
END LOOP;


    -- Update temp_BLOB table with profile info
    UPDATE temp_BLOB
       SET profile = v_profile_clob,
           records = v_records,
           columns = v_columns
     WHERE ID = rec.ID;
  END LOOP;

  COMMIT;
END;
