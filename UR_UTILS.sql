create or replace PACKAGE BODY ur_utils IS

-- --------------------------------------------------------------------------
-- Function Implementation: sanitize_reserved_words
-- --------------------------------------------------------------------------
FUNCTION sanitize_reserved_words(
  p_column_name IN VARCHAR2,
  p_suffix      IN VARCHAR2 DEFAULT 'COL'
) RETURN VARCHAR2
IS
  v_upper_name       VARCHAR2(128);
  v_is_reserved      VARCHAR2(5) := 'false';
  v_is_sanitized     VARCHAR2(5) := 'false';
  v_sanitized_name   VARCHAR2(128);
  v_result_json      VARCHAR2(500);

  -- Oracle 91 Core Reserved Words
  TYPE t_reserved_array IS TABLE OF VARCHAR2(30);
  c_reserved_words t_reserved_array := t_reserved_array(
    'ACCESS', 'ADD', 'ALL', 'ALTER', 'AND', 'ANY', 'AS', 'ASC', 'AUDIT',
    'BETWEEN', 'BY', 'CHAR', 'CHECK', 'CLUSTER', 'COLUMN', 'COMMENT',
    'COMPRESS', 'CONNECT', 'CREATE', 'CURRENT', 'DATE', 'DECIMAL',
    'DEFAULT', 'DELETE', 'DESC', 'DISTINCT', 'DROP', 'ELSE', 'EXCLUSIVE',
    'EXISTS', 'FILE', 'FLOAT', 'FOR', 'FROM', 'GRANT', 'GROUP', 'HAVING',
    'IDENTIFIED', 'IMMEDIATE', 'IN', 'INCREMENT', 'INDEX', 'INITIAL',
    'INSERT', 'INTEGER', 'INTERSECT', 'INTO', 'IS', 'LEVEL', 'LIKE',
    'LOCK', 'LONG', 'MAXEXTENTS', 'MINUS', 'MODE', 'MODIFY', 'NOAUDIT',
    'NOCOMPRESS', 'NOT', 'NOTFOUND', 'NOWAIT', 'NULL', 'NUMBER', 'OF',
    'OFFLINE', 'ON', 'ONLINE', 'OPTION', 'OR', 'ORDER', 'PCTFREE', 'PRIOR',
    'PRIVILEGES', 'PUBLIC', 'RAW', 'RENAME', 'RESOURCE', 'REVOKE', 'ROW',
    'ROWID', 'ROWNUM', 'ROWS', 'SELECT', 'SESSION', 'SET', 'SHARE', 'SIZE',
    'SMALLINT', 'SQL', 'START', 'SUCCESSFUL', 'SYNONYM', 'SYSDATE', 'TABLE',
    'THEN', 'TO', 'TRIGGER', 'UID', 'UNION', 'UNIQUE', 'UPDATE', 'USER',
    'VALIDATE', 'VALUES', 'VARCHAR', 'VARCHAR2', 'VIEW', 'WHENEVER',
    'WHERE', 'WITH'
  );

  -- Additional High-Priority Keywords (most commonly problematic)
  c_keywords t_reserved_array := t_reserved_array(
    -- Data Types
    'BINARY', 'BLOB', 'BOOLEAN', 'BYTE', 'CLOB', 'DOUBLE', 'INT',
    'INTERVAL', 'JSON', 'NCHAR', 'NCLOB', 'NVARCHAR2', 'PRECISION',
    'REAL', 'TIMESTAMP',
    -- Common Functions
    'ABS', 'AVG', 'CAST', 'CEIL', 'COALESCE', 'CONCAT', 'COUNT', 'CUBE',
    'DECODE', 'DENSE_RANK', 'EXTRACT', 'FIRST', 'FLOOR', 'GREATEST',
    'LAG', 'LAST', 'LEAD', 'LEAST', 'LENGTH', 'LISTAGG', 'LOWER', 'LPAD',
    'LTRIM', 'MAX', 'MEDIAN', 'MIN', 'NVL', 'NVL2', 'RANK', 'REGEXP_LIKE',
    'REGEXP_REPLACE', 'REPLACE', 'ROLLUP', 'ROUND', 'ROW_NUMBER', 'RPAD',
    'RTRIM', 'SUBSTR', 'SUM', 'TRIM', 'TRUNC', 'UPPER', 'VARIANCE',
    -- PL/SQL
    'ARRAY', 'BEGIN', 'BINARY_INTEGER', 'BODY', 'BULK', 'CALL', 'CASE',
    'CLOSE', 'CONSTANT', 'CONTINUE', 'CURSOR', 'DECLARE', 'DO', 'ELSIF',
    'EXCEPTION', 'EXECUTE', 'EXIT', 'FETCH', 'FORALL', 'FUNCTION', 'GOTO',
    'IF', 'LOOP', 'OPEN', 'PACKAGE', 'PRAGMA', 'PROCEDURE', 'RAISE',
    'RETURN',
    -- Database Objects
    'CONSTRAINT', 'DATABASE', 'DIMENSION', 'DIRECTORY', 'EDITION',
    'FLASHBACK', 'HIERARCHY', 'INDEXTYPE', 'JAVA', 'LIBRARY',
    'MATERIALIZED', 'OPERATOR', 'OUTLINE', 'PARTITION', 'PROFILE', 'PURGE',
    'QUEUE', 'ROLE', 'ROLLBACK', 'SCHEMA', 'SEGMENT', 'SEQUENCE',
    'SNAPSHOT', 'TABLESPACE', 'TYPE',
    -- Transaction
    'COMMIT', 'FORCE', 'ISOLATION', 'NEXT', 'REFERENCES', 'SAVEPOINT',
    'SERIALIZABLE', 'SQLCODE', 'SQLERRM', 'TRANSACTION', 'WORK', 'READ',
    'WRITE', 'REPEATABLE', 'UNCOMMITTED', 'LOCAL', 'GLOBAL', 'TEMP',
    'TEMPORARY', 'CASCADE',
    -- Commonly Problematic
    'ACTION', 'ACTIVE', 'AMOUNT', 'APPEND', 'APPLY', 'ASYNC', 'AWAIT',
    'CHANGE', 'CLASS', 'CODE', 'CONDITION', 'CONFIG', 'CONNECTION',
    'CONTENT', 'DEPTH', 'DESCRIPTION', 'END', 'EVENT', 'FALSE', 'FINAL',
    'FORMAT', 'GRAPH', 'NAME', 'STATUS', 'TYPE'
  );

BEGIN
  -- Convert to uppercase for comparison
  v_upper_name := UPPER(TRIM(p_column_name));

  -- Step 1: Replace one or more spaces with single underscore
  v_sanitized_name := REGEXP_REPLACE(v_upper_name, ' +', '_');

  -- Step 2: Remove special characters except allowed ones
  -- Keep: A-Z, 0-9, _ - % . and common currency symbols ($, GBP, Euro, Yen)
  v_sanitized_name := REGEXP_REPLACE(
    v_sanitized_name,
    '[^A-Z0-9_\-\%\.' || CHR(36) || CHR(163) || CHR(8364) || CHR(165) || ']',
    ''
  );

  -- Step 3: Collapse multiple consecutive underscores into single underscore
  v_sanitized_name := REGEXP_REPLACE(v_sanitized_name, '_+', '_');

  -- Check if name was sanitized (spaces replaced, special chars removed, or underscores collapsed)
  IF v_sanitized_name != v_upper_name THEN
    v_is_sanitized := 'true';
  END IF;

  -- Check against core reserved words
  FOR i IN 1..c_reserved_words.COUNT LOOP
    IF v_sanitized_name = c_reserved_words(i) THEN
      v_is_reserved := 'true';
      v_sanitized_name := v_sanitized_name || '_' || UPPER(p_suffix);
      EXIT;
    END IF;
  END LOOP;

  -- If not found in reserved, check keywords
  IF v_is_reserved = 'false' THEN
    FOR i IN 1..c_keywords.COUNT LOOP
      IF v_sanitized_name = c_keywords(i) THEN
        v_is_reserved := 'true';
        v_sanitized_name := v_sanitized_name || '_' || UPPER(p_suffix);
        EXIT;
      END IF;
    END LOOP;
  END IF;

  -- Build result JSON
  v_result_json := JSON_OBJECT(
    'is_reserved'     VALUE v_is_reserved,
    'is_sanitized'    VALUE v_is_sanitized,
    'sanitized_name'  VALUE v_sanitized_name
  );

  RETURN v_result_json;

EXCEPTION
  WHEN OTHERS THEN
    -- Return error info in JSON
    RETURN JSON_OBJECT(
      'is_reserved'     VALUE 'false',
      'is_sanitized'    VALUE 'false',
      'sanitized_name'  VALUE p_column_name,
      'error'           VALUE SQLERRM
    );
END sanitize_reserved_words;

-- ============================================================================
-- FUNCTION: sanitize_column_name
-- ============================================================================
-- Purpose: Normalize column names by removing special characters,
--          collapsing multiple underscores, and removing leading/trailing
--          underscores. Used across file upload, template creation, and
--          data loading for consistent column name handling.
--
-- Parameters:
--   p_name: Column name to sanitize
--
-- Returns: Sanitized column name in UPPERCASE
--
-- Processing Steps:
--   1. Replace non-alphanumeric characters with underscores
--   2. Collapse multiple consecutive underscores into single underscore
--   3. Remove leading and trailing underscores
--   4. Convert to uppercase
--
-- Examples:
--   'Hotel  Name'           -> 'HOTEL_NAME'
--   'Price__$__Rate'        -> 'PRICE_RATE'
--   '__Status___'           -> 'STATUS'
--   'HOTEL___INDIGO___CARDIFF' -> 'HOTEL_INDIGO_CARDIFF'
-- ============================================================================
FUNCTION sanitize_column_name(p_name IN VARCHAR2) RETURN VARCHAR2 IS
    v_name VARCHAR2(4000);
BEGIN
    -- Step 1: Replace non-alphanumeric characters with underscore
    v_name := REGEXP_REPLACE(p_name, '[^A-Za-z0-9]', '_');

    -- Step 2: Collapse multiple consecutive underscores into single underscore
    v_name := REGEXP_REPLACE(v_name, '_+', '_');

    -- Step 3: Remove leading and trailing underscores
    v_name := REGEXP_REPLACE(v_name, '^_+|_+$', '');

    -- Step 4: Convert to uppercase
    RETURN UPPER(v_name);

EXCEPTION
    WHEN OTHERS THEN
        -- On error, return original name in uppercase
        RETURN UPPER(p_name);
END sanitize_column_name;

-- ============================================================================
-- PROCEDURE: sanitize_template_definition
-- ============================================================================
-- Purpose: Process template definition JSON and sanitize reserved words
-- Input:
--   p_definition_json: Template definition JSON (array of column objects)
--   p_suffix: Suffix to append for reserved words (default: 'COL')
-- Output:
--   p_sanitized_json: New JSON with sanitized names and original_name added
--   p_status: 'S' (Success), 'E' (Error), or 'W' (Warning)
--   p_message: Status message
-- ============================================================================
PROCEDURE sanitize_template_definition(
  p_definition_json IN  CLOB,
  p_suffix          IN  VARCHAR2 DEFAULT 'COL',
  p_sanitized_json  OUT CLOB,
  p_status          OUT VARCHAR2,
  p_message         OUT VARCHAR2
)
IS
  l_array           JSON_ARRAY_T;
  l_obj             JSON_OBJECT_T;
  v_column_count    NUMBER := 0;
  v_reserved_count  NUMBER := 0;
  v_sanitized_count NUMBER := 0;
  v_check_result    VARCHAR2(500);
  v_is_reserved     VARCHAR2(10);
  v_is_sanitized    VARCHAR2(10);
  v_sanitized_name  VARCHAR2(128);
  v_name            VARCHAR2(128);
  v_original_name   VARCHAR2(128);

BEGIN
  -- Initialize output parameters
  p_status := 'S';
  p_message := '';
  p_sanitized_json := NULL;

  -- Validate input
  IF p_definition_json IS NULL THEN
    p_status := 'E';
    p_message := 'Input JSON is null';
    RETURN;
  END IF;

  -- Parse and modify JSON in-place
  BEGIN
    -- Parse JSON array (creates a mutable object)
    l_array := JSON_ARRAY_T(p_definition_json);
    v_column_count := l_array.get_size;

    IF v_column_count = 0 THEN
      p_status := 'E';
      p_message := 'No columns found in JSON array';
      RETURN;
    END IF;

    -- Loop through each element (0-based indexing)
    FOR i IN 0..v_column_count - 1 LOOP
      -- Get the object from the array
      l_obj := TREAT(l_array.get(i) AS JSON_OBJECT_T);

      -- Read the name field
      v_name := l_obj.get_string('name');

      -- Get or set original_name
      IF l_obj.has('original_name') THEN
        v_original_name := l_obj.get_string('original_name');
      ELSE
        v_original_name := v_name;
        -- Add original_name field to preserve the original name
        l_obj.put('original_name', v_original_name);
      END IF;

      -- Check if reserved word or needs sanitization
      v_check_result := sanitize_reserved_words(v_name, p_suffix);
      v_is_reserved := JSON_VALUE(v_check_result, '$.is_reserved');
      v_is_sanitized := JSON_VALUE(v_check_result, '$.is_sanitized');
      v_sanitized_name := JSON_VALUE(v_check_result, '$.sanitized_name');

      -- Update name if it was sanitized (special chars) or is a reserved word
      IF v_is_sanitized = 'true' OR v_is_reserved = 'true' THEN
        -- Modify the name field IN-PLACE
        l_obj.put('name', v_sanitized_name);

        -- Track counts separately for clear messaging
        IF v_is_reserved = 'true' THEN
          v_reserved_count := v_reserved_count + 1;
        END IF;
        IF v_is_sanitized = 'true' THEN
          v_sanitized_count := v_sanitized_count + 1;
        END IF;
      END IF;

      -- ALL OTHER FIELDS ARE AUTOMATICALLY PRESERVED
      -- (data_type, mapping_type, value, qualifier, selector, format_mask, is_json, etc.)

      -- Ensure mapping_type is always set (safe inline version)
DECLARE
  l_elem JSON_ELEMENT_T;
  l_map  VARCHAR2(4000);
BEGIN
  IF NOT l_obj.has('mapping_type') THEN
    l_map := NULL;
  ELSE
    l_elem := l_obj.get('mapping_type'); -- may be NULL if key present but value missing
    IF l_elem IS NULL OR l_elem.is_null THEN
      l_map := NULL;
    ELSE
      l_map := l_obj.get_string('mapping_type');
    END IF;
  END IF;

  IF l_map IS NULL OR TRIM(l_map) = '' THEN
    l_obj.put('mapping_type', 'Maps To');
  END IF;
END;



    END LOOP;

    -- Convert modified array back to CLOB
    p_sanitized_json := l_array.to_clob;

    -- Set success message
    p_message := 'Processed ' || v_column_count || ' columns. ' ||
                 'Sanitized ' || v_sanitized_count || ' column names (spaces/special chars). ' ||
                 'Renamed ' || v_reserved_count || ' reserved words.';

  EXCEPTION
    WHEN OTHERS THEN
      p_status := 'E';
      p_message := 'Error processing JSON: ' || SQLERRM;
      p_sanitized_json := NULL;
  END;

END sanitize_template_definition;

    PROCEDURE POPULATE_ERROR_COLLECTION_FROM_LOG (
        p_interface_log_id IN  UR_INTERFACE_LOGS.ID%TYPE,
        p_collection_name  IN  VARCHAR2,
        p_status           OUT VARCHAR2,
        p_message          OUT VARCHAR2
    )
    IS
        l_error_json CLOB;
        l_json_array_count NUMBER;
    BEGIN
        -- Initialize OUT parameters to a default error state.
        p_status  := 'E';
        p_message := 'An unexpected error occurred during processing.';

        -- Step 1: Validate inputs
        IF p_interface_log_id IS NULL THEN
            p_status  := 'E';
            p_message := 'Error: The Interface Log ID cannot be null.';
            RETURN;
        END IF;

        IF p_collection_name IS NULL OR TRIM(p_collection_name) IS NULL THEN
            p_status  := 'E';
            p_message := 'Error: The Collection Name cannot be null or empty.';
            RETURN;
        END IF;

        -- Step 2: Fetch the ERROR_JSON from the logs table
        BEGIN
            SELECT error_json
            INTO   l_error_json
            FROM   ur_interface_logs
            WHERE  id = p_interface_log_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_status  := 'E';
                p_message := 'Error: No record found for Interface Log ID: ' || RAWTOHEX(p_interface_log_id) || '.';
                RETURN;
        END;

        -- Step 3: Check if the fetched JSON is null or empty
        IF l_error_json IS NULL OR DBMS_LOB.GETLENGTH(l_error_json) = 0 THEN
            p_status  := 'W';
            p_message := 'Warning: The error log for the specified ID is empty. No data to populate.';
            -- It's a good practice to still ensure the collection is empty in this case.
            APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(p_collection_name => p_collection_name);
            RETURN;
        END IF;

        -- Step 4: Parse the JSON and check for validity
        BEGIN
            APEX_JSON.PARSE(l_error_json);
        EXCEPTION
            WHEN OTHERS THEN
                -- APEX_JSON raises an unhandled exception (ORA-20987) for parse errors.
                p_status  := 'E';
                p_message := 'Error: Failed to parse the ERROR_JSON content. The JSON string may be malformed.';
                RETURN;
        END;

        -- Step 5: Initialize the APEX Collection
        -- This creates the collection if it doesn't exist or clears it if it does.
        APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(
            p_collection_name => p_collection_name
        );

        -- Step 6: Loop through the JSON array and populate the collection
        l_json_array_count := APEX_JSON.GET_COUNT(p_path => '.');

        IF l_json_array_count > 0 THEN
            FOR i IN 1..l_json_array_count LOOP
                -- Add members to the collection.
                -- c001 for row number, c002 for the error message.
                APEX_COLLECTION.ADD_MEMBER(
                    p_collection_name => p_collection_name,
                    p_c001            => APEX_JSON.GET_VARCHAR2(p_path => '[%d].row', p0 => i),
                    p_c002            => APEX_JSON.GET_VARCHAR2(p_path => '[%d].error', p0 => i)
                );
            END LOOP;
            
            p_status  := 'S';
            p_message := 'Success: Collection ''' || p_collection_name || ''' has been populated with ' || l_json_array_count || ' error(s).';

        ELSE
            -- This handles cases where the JSON is valid but is an empty array, e.g., '[]'.
            p_status  := 'W';
            p_message := 'Warning: The error log contains an empty array. The collection is empty.';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            -- A final catch-all for any other unexpected Oracle errors.
            p_status  := 'E';
            p_message := 'An unexpected system error occurred: ' || SQLERRM;
    END POPULATE_ERROR_COLLECTION_FROM_LOG;


    PROCEDURE VALIDATE_TEMPLATE_DEFINITION(
        p_json_clob  IN            CLOB,
        p_alert_clob IN OUT NOCOPY CLOB,
        p_status     OUT           VARCHAR2
    ) IS
        l_error_found BOOLEAN := FALSE;
    BEGIN
        -- Loop through each JSON object in the array where a 'qualifier' exists.
        FOR r IN (
            SELECT
                nm,
                dt,
                qlf
            FROM
                JSON_TABLE(p_json_clob, '$[*]'
                    COLUMNS (
                        nm  VARCHAR2(255) PATH '$.name',
                        dt  VARCHAR2(50)  PATH '$.data_type',
                        qlf VARCHAR2(255) PATH '$.qualifier'
                    )
                )
            WHERE
                qlf IS NOT NULL
        ) LOOP
            -- RULE 1: Qualifiers with 'DATE' in the name must have a 'DATE' data_type.
            IF INSTR(UPPER(r.qlf), 'DATE') > 0 THEN
                IF r.dt <> 'DATE' THEN
                    l_error_found := TRUE;
                    ur_utils.add_alert(
                        p_alert_clob,
                        'Field "' || r.nm || '": Qualifier "' || r.qlf || '" must be DATE.',
                        'error',
                        NULL,
                        NULL,
                        p_alert_clob
                    );
                END IF;
            -- RULE 2: All other qualifiers must have a 'NUMBER' data_type.
            ELSE
                IF r.dt <> 'NUMBER' THEN
                    l_error_found := TRUE;
                    ur_utils.add_alert(
                        p_alert_clob,
                        'Field "' || r.nm || '": Qualifier "' || r.qlf || '" must be NUMBER.',
                        'error',
                        NULL,
                        NULL,
                        p_alert_clob
                    );
                END IF;
            END IF;
        END LOOP;

        -- Set the final status ('S'uccess or 'E'rror) and add a success message if needed.
        IF l_error_found THEN
            p_status := 'E';
        ELSE
            p_status := 'S';
            ur_utils.add_alert(p_alert_clob, 'Template definition validated successfully.', 'success', NULL, NULL, p_alert_clob);
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            ur_utils.add_alert(p_alert_clob, 'Unexpected validation error: ' || SQLERRM, 'error', NULL, NULL, p_alert_clob);
    END VALIDATE_TEMPLATE_DEFINITION;

    --------------------------------------------------------------------------------

    FUNCTION GET_ATTRIBUTE_VALUE(
        p_attribute_id   IN RAW      DEFAULT NULL,
        p_attribute_key  IN VARCHAR2 DEFAULT NULL,
        p_hotel_id       IN RAW      DEFAULT NULL,
        p_stay_date      IN DATE     DEFAULT NULL,
        p_round_digits   IN NUMBER   DEFAULT 2
    ) RETURN UR_attribute_value_table PIPELINED AS
        l_response_clob CLOB;
        l_status        VARCHAR2(1);
    BEGIN
        -- This internal call remains the same. The JSON it produces should have
        -- the attribute_value as a number, date string, or text string.
        GET_ATTRIBUTE_VALUE(
            p_attribute_id  => p_attribute_id,
            p_attribute_key => p_attribute_key,
            p_hotel_id      => p_hotel_id,
            p_stay_date     => p_stay_date,
            p_round_digits  => p_round_digits,
            p_debug_flag    => FALSE,
            p_response_clob => l_response_clob
        );

        l_status := JSON_VALUE(l_response_clob, '$.STATUS');

        IF l_status = 'S' THEN
            FOR rec IN (
                SELECT
                    TO_DATE(jt.stay_date, 'DD-MON-YYYY') AS stay_date,
                    jt.attribute_value
                FROM
                    JSON_TABLE(
                        l_response_clob,
                        '$.RESPONSE_PAYLOAD[*]'
                        COLUMNS (
                            stay_date       VARCHAR2(20)   PATH '$.stay_date',
                            -- MODIFIED: Read the value as VARCHAR2 to handle all types.
                            attribute_value VARCHAR2(4000) PATH '$.attribute_value'
                        )
                    ) jt
            ) LOOP
                -- This now works for any data type since attribute_value is a string.
                PIPE ROW(UR_attribute_value_row(rec.stay_date, rec.attribute_value));
            END LOOP;
        END IF;

        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            -- Gracefully exit on error
            RETURN;
    END GET_ATTRIBUTE_VALUE;

    --------------------------------------------------------------------------------

    -- =================================================================
    --  MAIN PROCEDURE IMPLEMENTATION (Returns JSON CLOB)
    -- =================================================================
    PROCEDURE build_json_response(
        p_status                 IN VARCHAR2,
        p_message                IN CLOB,
        p_attribute_id           IN RAW,
        p_attribute_name         IN VARCHAR2,
        p_attribute_key          IN VARCHAR2,
        p_attribute_datatype     IN VARCHAR2,
        p_attribute_qualifier    IN VARCHAR2,
        p_attribute_static_val   IN VARCHAR2,
        p_hotel_id               IN RAW,
        p_stay_date              IN DATE,
        p_debug_flag             IN BOOLEAN,
        p_record_count           IN NUMBER,
        p_payload_array          IN JSON_ARRAY_T,
        p_response_clob          OUT CLOB
    ) IS
        l_json_obj JSON_OBJECT_T;
    BEGIN
        l_json_obj := JSON_OBJECT_T();
        l_json_obj.put('attribute_id', NVL(RAWTOHEX(p_attribute_id), ''));
        l_json_obj.put('attribute_name', NVL(p_attribute_name, ''));
        l_json_obj.put('attribute_key', NVL(p_attribute_key, ''));
        l_json_obj.put('attribute_datatype', NVL(p_attribute_datatype, ''));
        l_json_obj.put('attribute_qualifier', NVL(p_attribute_qualifier, ''));
        l_json_obj.put('attribute_static_value', NVL(p_attribute_static_val, ''));
        l_json_obj.put('hotel_id', NVL(RAWTOHEX(p_hotel_id), ''));
        l_json_obj.put('stay_date', NVL(TO_CHAR(p_stay_date, 'YYYY-MM-DD'), ''));
        l_json_obj.put('DEBUG_FLAG', CASE WHEN p_debug_flag THEN 'TRUE' ELSE 'FALSE' END);
        l_json_obj.put('RESPONSE_TIME', TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD"T"HH24:MI:SS.FF"Z"'));
        l_json_obj.put('STATUS', p_status);
        l_json_obj.put('RECORD_COUNT', NVL(p_record_count, 0));
        l_json_obj.put('MESSAGE', NVL(p_message, ''));

        -- Handle NULL payload array
        IF p_payload_array IS NOT NULL THEN
            l_json_obj.put('RESPONSE_PAYLOAD', p_payload_array);
        ELSE
            l_json_obj.put('RESPONSE_PAYLOAD', JSON_ARRAY_T());
        END IF;

        p_response_clob := l_json_obj.to_clob;
    EXCEPTION
        WHEN OTHERS THEN
            p_response_clob := '{"STATUS":"E", "MESSAGE":"Failed to generate final JSON response: ' || SQLERRM || '"}';
    END build_json_response;

    --------------------------------------------------------------------------------

    PROCEDURE GET_ATTRIBUTE_VALUE(
        p_attribute_id  IN  RAW      DEFAULT NULL,
        p_attribute_key IN  VARCHAR2 DEFAULT NULL,
        p_hotel_id      IN  RAW      DEFAULT NULL,
        p_stay_date     IN  DATE     DEFAULT NULL,
        p_round_digits  IN  NUMBER   DEFAULT 2,
        p_debug_flag    IN  BOOLEAN  DEFAULT FALSE,
        p_response_clob OUT CLOB
    ) IS
        l_attribute_rec     UR_ALGO_ATTRIBUTES%ROWTYPE;
        l_template_rec      UR_TEMPLATES%ROWTYPE;
        l_sql_stmt          VARCHAR2(8000);
        l_cursor            SYS_REFCURSOR;
        l_stay_date_val     DATE;
        l_attribute_val_out VARCHAR2(4000);
        l_records_fetched   NUMBER := 0;
        l_json_payload_arr  JSON_ARRAY_T := JSON_ARRAY_T();
        l_json_row_obj      JSON_OBJECT_T;
        l_status            VARCHAR2(1) := 'S';
        l_message           CLOB;
        l_debug_log         CLOB;

        PROCEDURE append_debug(p_log_entry IN VARCHAR2) IS
        BEGIN
            IF p_debug_flag THEN
                l_debug_log := l_debug_log || TO_CHAR(SYSTIMESTAMP, 'HH24:MI:SS.FF') || ' - ' || NVL(p_log_entry, '(null)') || CHR(10);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                -- Silently ignore debug logging errors to prevent breaking main logic
                NULL;
        END append_debug;

    BEGIN
        append_debug('Procedure started.');

        IF (p_attribute_id IS NULL AND p_attribute_key IS NULL) OR (p_attribute_id IS NOT NULL AND p_attribute_key IS NOT NULL) THEN
            l_message := 'Validation Error: Provide either p_attribute_id or p_attribute_key, but not both.';
            build_json_response('E', l_message, NULL, NULL, p_attribute_key, NULL, NULL, NULL, p_hotel_id, p_stay_date, p_debug_flag, 0, JSON_ARRAY_T(), p_response_clob);
            RETURN;
        END IF;

        BEGIN
            IF p_attribute_id IS NOT NULL THEN
                SELECT * INTO l_attribute_rec FROM UR_ALGO_ATTRIBUTES WHERE ID = p_attribute_id;
            ELSE
                SELECT * INTO l_attribute_rec FROM UR_ALGO_ATTRIBUTES WHERE KEY = p_attribute_key;
            END IF;
            append_debug('Found attribute with ID: ' || RAWTOHEX(l_attribute_rec.ID) || ', TYPE: ' || l_attribute_rec.TYPE || ', VALUE: ' || l_attribute_rec.VALUE);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_message := 'Attribute not found for the specified ID or KEY.';
                build_json_response('E', l_message, p_attribute_id, NULL, p_attribute_key, NULL, NULL, NULL, p_hotel_id, p_stay_date, p_debug_flag, 0, JSON_ARRAY_T(), p_response_clob);
                RETURN;
        END;

        IF l_attribute_rec.TYPE = 'M' THEN
            append_debug('Attribute type is Manual. Using static value.');
            -- FIX: Only add record if stay_date is not NULL
            IF p_stay_date IS NOT NULL THEN
                l_json_row_obj := JSON_OBJECT_T();
                l_json_row_obj.put('stay_date', TO_CHAR(p_stay_date, 'DD-MON-YYYY'));
                CASE UPPER(l_attribute_rec.DATA_TYPE)
                    WHEN 'NUMBER' THEN
                        l_json_row_obj.put('attribute_value', ROUND(TO_NUMBER(l_attribute_rec.VALUE), p_round_digits));
                    ELSE
                        l_json_row_obj.put('attribute_value', l_attribute_rec.VALUE);
                END CASE;
                l_json_payload_arr.append(l_json_row_obj);
                l_records_fetched := 1;
                l_message         := 'Manual value returned.';
            ELSE
                append_debug('Skipped Manual attribute record with NULL stay_date.');
                l_message         := 'Manual value skipped (NULL stay_date).';
            END IF;

ELSIF l_attribute_rec.TYPE = 'S' THEN
    append_debug('Attribute type is Sourced. Parsing value formula.');
    DECLARE
        TYPE t_table_map IS TABLE OF VARCHAR2(10) INDEX BY VARCHAR2(150);
        l_tables             t_table_map;
        l_formula            VARCHAR2(4000) := l_attribute_rec.VALUE;
        l_expression         VARCHAR2(4000) := l_formula;
        l_from_clause        VARCHAR2(4000);
        l_where_clause       VARCHAR2(1000) := ' WHERE 1=1';
        l_stay_date_column   VARCHAR2(150); -- This variable is the target of our change
        l_base_table_alias   VARCHAR2(10)   := 't1';
        l_table_counter      NUMBER         := 1;
        l_pos                NUMBER         := 1;
        l_source_ref         VARCHAR2(200);
    BEGIN
        -- ### MODIFIED LOGIC: Determine the STAY_DATE column name ###
        IF l_attribute_rec.TEMPLATE_ID IS NOT NULL THEN
            -- **[1] Original Logic: Use Template ID if it exists**
            append_debug('Template ID found. Looking up STAY_DATE column from template definition.');
            -- Check if OWN_PROPERTY/COMP_PROPERTY with a VIEW object - only then use hardcoded STAY_DATE
            IF l_attribute_rec.ATTRIBUTE_QUALIFIER IN ('OWN_PROPERTY', 'COMP_PROPERTY') THEN
                DECLARE
                    l_db_object_name  VARCHAR2(128);
                    l_object_type     VARCHAR2(30);
                BEGIN
                    -- Extract DB object name from formula (e.g., #UR_TMPLT_XXX.COLUMN# -> UR_TMPLT_XXX)
                    l_db_object_name := REGEXP_SUBSTR(l_formula, '#([^#.]+)\.', 1, 1, NULL, 1);
                    append_debug('Extracted DB object name from formula: ' || l_db_object_name);

                    -- Check the object type (VIEW or TABLE)
                    BEGIN
                        SELECT object_type
                        INTO   l_object_type
                        FROM   USER_OBJECTS
                        WHERE  object_name = UPPER(l_db_object_name)
                          AND  object_type IN ('TABLE', 'VIEW')
                        FETCH FIRST 1 ROWS ONLY;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            l_object_type := NULL;
                            append_debug('DB object not found in USER_OBJECTS: ' || l_db_object_name);
                    END;

                    append_debug('DB object type: ' || NVL(l_object_type, 'UNKNOWN'));

                    IF l_object_type = 'VIEW' THEN
                        -- VIEW: Use hardcoded STAY_DATE
                        l_stay_date_column := 'STAY_DATE';
                        append_debug('Object is a VIEW. Using default STAY_DATE column.');
                    END IF;
                END;
            END IF;

            -- For non-VIEW cases (TABLE or other qualifiers), look up from template definition
            IF l_stay_date_column IS NULL THEN
                append_debug('Looking up STAY_DATE column from template definition.');
                BEGIN
                    SELECT * INTO l_template_rec FROM UR_TEMPLATES WHERE ID = l_attribute_rec.TEMPLATE_ID;
                    SELECT jt.name
                    INTO   l_stay_date_column
                    FROM   JSON_TABLE(l_template_rec.DEFINITION, '$[*]' COLUMNS (name VARCHAR2(100) PATH '$.name', qualifier VARCHAR2(100) PATH '$.qualifier')) jt
                    WHERE  jt.qualifier = 'STAY_DATE';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        RAISE_APPLICATION_ERROR(-20004, 'Critical error: The associated template definition requires a column with the ''STAY_DATE'' qualifier.');
                END;
            END IF;
        ELSE
            -- **[2] New Logic: Introspect the formula if no Template ID**
            append_debug('Template ID is NULL. Starting non-templated attribute logic.');

            IF p_hotel_id IS NULL THEN
                append_debug('Validation failed: p_hotel_id is NULL for a non-templated Sourced attribute.');
                l_message := 'Validation Error: A Hotel ID must be provided to retrieve values for this attribute configuration.';
                build_json_response('E', l_message, l_attribute_rec.ID, l_attribute_rec.NAME, l_attribute_rec.KEY, l_attribute_rec.DATA_TYPE, l_attribute_rec.ATTRIBUTE_QUALIFIER, l_attribute_rec.VALUE, p_hotel_id, p_stay_date, p_debug_flag, 0, JSON_ARRAY_T(), p_response_clob);
                RETURN;
            END IF;

            append_debug('Template ID is NULL. Introspecting formula to find base table and verify STAY_DATE column.');
            
            DECLARE
                l_base_table_name VARCHAR2(128);
                l_column_exists   NUMBER;
            BEGIN
                -- Extract the first table name from the formula (e.g., from #TABLE.COLUMN#)
                l_base_table_name := REGEXP_SUBSTR(l_formula, '#([^#.]+)\.', 1, 1, NULL, 1);

                IF l_base_table_name IS NULL THEN
                    RAISE_APPLICATION_ERROR(-20006, 'Invalid formula format. Cannot determine base table from value: ' || l_formula);
                END IF;
                
                append_debug('Inferred base table is: ' || l_base_table_name);

                -- Check if a 'STAY_DATE' column exists in that table
                SELECT COUNT(*)
                INTO   l_column_exists
                FROM   ALL_TAB_COLUMNS
                WHERE  TABLE_NAME = UPPER(l_base_table_name)
                  AND  COLUMN_NAME = 'STAY_DATE';

                IF l_column_exists > 0 THEN
                    l_stay_date_column := 'STAY_DATE';
                ELSE
                    RAISE_APPLICATION_ERROR(-20007, 'Configuration error: The base table ''' || l_base_table_name || ''' for this attribute does not have a required ''STAY_DATE'' column.');
                END IF;
            END;
        END IF;

        append_debug('Determined Stay Date column is: ' || l_stay_date_column);

        -- 1. Parse all source references and build FROM clause (This logic remains the same)
        LOOP
            l_source_ref := REGEXP_SUBSTR(l_formula, '#([^#]+)#', l_pos, 1, NULL, 1);
            EXIT WHEN l_source_ref IS NULL;

                    DECLARE
                        l_table_name VARCHAR2(150) := REGEXP_SUBSTR(l_source_ref, '^[^.]+');
                        l_col_name   VARCHAR2(150) := REGEXP_SUBSTR(l_source_ref, '[^.]+$');
                        l_alias      VARCHAR2(10);
                    BEGIN
                        IF NOT l_tables.EXISTS(l_table_name) THEN
                            l_alias              := 't' || l_table_counter;
                            l_tables(l_table_name) := l_alias;

                            IF l_table_counter = 1 THEN
                                l_from_clause := DBMS_ASSERT.ENQUOTE_NAME(l_table_name) || ' ' || l_alias;
                            ELSE
                                l_from_clause := l_from_clause || ' LEFT JOIN ' || DBMS_ASSERT.ENQUOTE_NAME(l_table_name) || ' ' || l_alias ||
                                                 ' ON ' || l_base_table_alias || '.' || DBMS_ASSERT.ENQUOTE_NAME(l_stay_date_column) || ' = ' || l_alias || '.' || DBMS_ASSERT.ENQUOTE_NAME(l_stay_date_column);
                            END IF;
                            l_table_counter := l_table_counter + 1;
                        ELSE
                            l_alias := l_tables(l_table_name);
                        END IF;

                        l_expression := REPLACE(l_expression, '#' || l_source_ref || '#', l_alias || '.' || DBMS_ASSERT.ENQUOTE_NAME(l_col_name));
                    END;
                    l_pos := REGEXP_INSTR(l_formula, '#', l_pos, 2) + 1;
                END LOOP;

                IF l_from_clause IS NULL THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Invalid Sourced Attribute: Formula is missing a source reference like #TABLE.COLUMN#.');
                END IF;

                -- 2. Validate expression (now includes brackets)
                DECLARE
                    l_validation_check VARCHAR2(4000);
                BEGIN
                    l_validation_check := REGEXP_REPLACE(l_expression, '[''a-zA-Z0-9_."''\(\)0-9\.\+\*\/ \t\r\n-]', '');
                    IF l_validation_check IS NOT NULL THEN
                        RAISE_APPLICATION_ERROR(-20003, 'Invalid Sourced Attribute: Formula contains illegal characters.');
                    END IF;
                END;

                -- 4. Build final SQL (Conditionally apply ROUND based on data type)
                IF p_stay_date IS NOT NULL THEN l_where_clause := l_where_clause || ' AND TRUNC(' || l_base_table_alias || '.' || DBMS_ASSERT.ENQUOTE_NAME(l_stay_date_column) || ') = TRUNC(:stay_date)'; END IF;
                IF p_hotel_id IS NOT NULL THEN l_where_clause := l_where_clause || ' AND ' || l_base_table_alias || '.' || DBMS_ASSERT.ENQUOTE_NAME('HOTEL_ID') || ' = :hotel_id'; END IF;

                IF l_attribute_rec.DATA_TYPE = 'NUMBER' THEN
                    append_debug('Data type is NUMBER, applying ROUND().');
                    l_sql_stmt := 'SELECT ' || l_base_table_alias || '.' || DBMS_ASSERT.ENQUOTE_NAME(l_stay_date_column) ||
                                  ', ROUND((' || l_expression || '), :round_digits)' ||
                                  ' FROM ' || l_from_clause || l_where_clause;
                ELSE
                    append_debug('Data type is ' || l_attribute_rec.DATA_TYPE || ', not applying ROUND().');
                    l_sql_stmt := 'SELECT ' || l_base_table_alias || '.' || DBMS_ASSERT.ENQUOTE_NAME(l_stay_date_column) ||
                                  ', ' || l_expression ||
                                  ' FROM ' || l_from_clause || l_where_clause;
                END IF;

                append_debug('Dynamic SQL: ' || l_sql_stmt);

                -- Open the cursor with the correct bind variables based on the data type
                IF l_attribute_rec.DATA_TYPE = 'NUMBER' THEN
                    -- This block handles NUMBER types, which always need :round_digits
                    CASE
                        WHEN p_stay_date IS NOT NULL AND p_hotel_id IS NOT NULL THEN
                            OPEN l_cursor FOR l_sql_stmt USING p_round_digits, p_stay_date, p_hotel_id;
                        WHEN p_stay_date IS NOT NULL AND p_hotel_id IS NULL THEN
                            OPEN l_cursor FOR l_sql_stmt USING p_round_digits, p_stay_date;
                        WHEN p_stay_date IS NULL AND p_hotel_id IS NOT NULL THEN
                            OPEN l_cursor FOR l_sql_stmt USING p_round_digits, p_hotel_id;
                        ELSE
                            OPEN l_cursor FOR l_sql_stmt USING p_round_digits;
                    END CASE;
                ELSE
                    -- This block handles non-NUMBER types (DATE, VARCHAR2, etc.), which do NOT have :round_digits
                    CASE
                        WHEN p_stay_date IS NOT NULL AND p_hotel_id IS NOT NULL THEN
                            OPEN l_cursor FOR l_sql_stmt USING p_stay_date, p_hotel_id;
                        WHEN p_stay_date IS NOT NULL AND p_hotel_id IS NULL THEN
                            OPEN l_cursor FOR l_sql_stmt USING p_stay_date;
                        WHEN p_stay_date IS NULL AND p_hotel_id IS NOT NULL THEN
                            OPEN l_cursor FOR l_sql_stmt USING p_hotel_id;
                        ELSE
                            -- No bind variables are needed if all parameters are null for non-numeric types
                            OPEN l_cursor FOR l_sql_stmt;
                    END CASE;
                END IF;



                LOOP
                    FETCH l_cursor INTO l_stay_date_val, l_attribute_val_out;
                    EXIT WHEN l_cursor%NOTFOUND;

                    -- FIX: Only add record if stay_date is not NULL
                    IF l_stay_date_val IS NOT NULL THEN
                        l_records_fetched := l_records_fetched + 1;
                        l_json_row_obj := JSON_OBJECT_T();
                        l_json_row_obj.put('stay_date', TO_CHAR(l_stay_date_val, 'DD-MON-YYYY'));

                        -- Conditionally handle the attribute value based on its data type
                        CASE UPPER(l_attribute_rec.DATA_TYPE)
                            WHEN 'NUMBER' THEN
                                l_json_row_obj.put('attribute_value', TO_NUMBER(l_attribute_val_out));
                            ELSE -- For DATE, VARCHAR2, etc., treat as a string
                                l_json_row_obj.put('attribute_value', l_attribute_val_out);
                        END CASE;

                        l_json_payload_arr.append(l_json_row_obj);
                    ELSE
                        append_debug('Skipped Sourced attribute record with NULL stay_date.');
                    END IF;
                END LOOP;
                CLOSE l_cursor;
            END;

        -- ==================================================================================
        -- TYPE = 'C' (Calculated) - Template-agnostic calculated attributes
        -- ==================================================================================
        ELSIF l_attribute_rec.TYPE = 'C' THEN
            append_debug('Attribute type is Calculated. Processing formula.');

            DECLARE
                l_formula           VARCHAR2(4000) := l_attribute_rec.VALUE;
                l_qualifier         VARCHAR2(50) := l_attribute_rec.ATTRIBUTE_QUALIFIER;
                l_price_type        VARCHAR2(20);
                l_hotel_capacity    NUMBER;
                l_attr_hotel_id     RAW(16) := NVL(p_hotel_id, l_attribute_rec.HOTEL_ID);

                -- For formula-based calculations
                TYPE t_date_values IS TABLE OF NUMBER INDEX BY VARCHAR2(20); -- stay_date string -> value
                TYPE t_attr_data IS TABLE OF t_date_values INDEX BY VARCHAR2(200); -- attr_key -> date_values
                l_attr_data         t_attr_data;
                l_all_dates         DBMS_SQL.VARCHAR2_TABLE;
                l_date_idx          NUMBER := 0;
                l_ref_key           VARCHAR2(200);
                l_pos               NUMBER;
                l_resolved_formula  VARCHAR2(4000);
                l_ref_value         NUMBER;
                l_calc_result       NUMBER;
                l_date_str          VARCHAR2(20);
                l_ref_response      CLOB;
                l_ref_json          JSON_OBJECT_T;
                l_ref_payload       JSON_ARRAY_T;
                l_ref_item          JSON_OBJECT_T;
                l_ref_stay_date     VARCHAR2(20);
                l_ref_attr_value    VARCHAR2(100);

            BEGIN
                -- Validate hotel_id is provided for calculated attributes
                IF l_attr_hotel_id IS NULL THEN
                    append_debug('Validation failed: hotel_id is NULL for Calculated attribute.');
                    l_message := 'Validation Error: A Hotel ID must be provided to retrieve calculated attribute values.';
                    build_json_response('E', l_message, l_attribute_rec.ID, l_attribute_rec.NAME, l_attribute_rec.KEY, l_attribute_rec.DATA_TYPE, l_attribute_rec.ATTRIBUTE_QUALIFIER, l_attribute_rec.VALUE, p_hotel_id, p_stay_date, p_debug_flag, 0, JSON_ARRAY_T(), p_response_clob);
                    RETURN;
                END IF;

                -- ============================================================
                -- PRICE OVERRIDE ATTRIBUTES
                -- ============================================================
                IF l_qualifier IN ('PRICE_OVERRIDE_PUBLIC', 'PRICE_OVERRIDE_CORPORATE', 'PRICE_OVERRIDE_GROUP') THEN
                    append_debug('Processing Price Override attribute. Qualifier: ' || l_qualifier);

                    -- Determine price type from qualifier
                    CASE l_qualifier
                        WHEN 'PRICE_OVERRIDE_PUBLIC' THEN l_price_type := 'PUBLIC';
                        WHEN 'PRICE_OVERRIDE_CORPORATE' THEN l_price_type := 'CORPORATE';
                        WHEN 'PRICE_OVERRIDE_GROUP' THEN l_price_type := 'GROUP';
                    END CASE;

                    append_debug('Price type: ' || l_price_type);

                    -- Query price overrides
                    FOR rec IN (
                        SELECT STAY_DATE, PRICE
                        FROM UR_HOTEL_PRICE_OVERRIDE
                        WHERE HOTEL_ID = l_attr_hotel_id
                          AND STATUS = 'A'
                          AND UPPER(TYPE) = l_price_type
                          AND (p_stay_date IS NULL OR TRUNC(STAY_DATE) = TRUNC(p_stay_date))
                        ORDER BY STAY_DATE
                    ) LOOP
                        l_records_fetched := l_records_fetched + 1;
                        l_json_row_obj := JSON_OBJECT_T();
                        l_json_row_obj.put('stay_date', TO_CHAR(rec.STAY_DATE, 'DD-MON-YYYY'));
                        l_json_row_obj.put('attribute_value', ROUND(rec.PRICE, p_round_digits));
                        l_json_payload_arr.append(l_json_row_obj);
                        append_debug('Price Override: ' || TO_CHAR(rec.STAY_DATE, 'DD-MON-YYYY') || ' = ' || rec.PRICE);
                    END LOOP;

                    l_message := l_records_fetched || ' price override records fetched.';

                -- ============================================================
                -- EVENTS ATTRIBUTE
                -- ============================================================
                ELSIF l_qualifier = 'EVENTS' THEN
                    append_debug('Processing Events attribute.');

                    -- Query events with date expansion
                    FOR rec IN (
                        SELECT DISTINCT d.stay_date,
                               get_events_for_date(l_attr_hotel_id, d.stay_date) AS event_string
                        FROM (
                            SELECT EVENT_START_DATE + LEVEL - 1 AS stay_date
                            FROM UR_EVENTS
                            WHERE HOTEL_ID = l_attr_hotel_id
                              AND (p_stay_date IS NULL OR p_stay_date BETWEEN EVENT_START_DATE AND EVENT_END_DATE)
                            CONNECT BY LEVEL <= EVENT_END_DATE - EVENT_START_DATE + 1
                               AND PRIOR ID = ID
                               AND PRIOR SYS_GUID() IS NOT NULL
                        ) d
                        WHERE d.stay_date IS NOT NULL
                          AND (p_stay_date IS NULL OR TRUNC(d.stay_date) = TRUNC(p_stay_date))
                        ORDER BY d.stay_date
                    ) LOOP
                        IF rec.event_string IS NOT NULL THEN
                            l_records_fetched := l_records_fetched + 1;
                            l_json_row_obj := JSON_OBJECT_T();
                            l_json_row_obj.put('stay_date', TO_CHAR(rec.stay_date, 'DD-MON-YYYY'));
                            l_json_row_obj.put('attribute_value', rec.event_string);
                            l_json_payload_arr.append(l_json_row_obj);
                            append_debug('Event: ' || TO_CHAR(rec.stay_date, 'DD-MON-YYYY') || ' = ' || rec.event_string);
                        END IF;
                    END LOOP;

                    l_message := l_records_fetched || ' event records fetched.';

                -- ============================================================
                -- FORMULA-BASED CALCULATED ATTRIBUTES (e.g., OCCUPANCY_PCT)
                -- ============================================================
                ELSE
                    append_debug('Processing standard calculated formula: ' || l_formula);

                    IF l_formula IS NULL THEN
                        append_debug('Formula is NULL, cannot calculate.');
                        l_message := 'Calculated attribute has no formula defined.';
                        build_json_response('W', l_message, l_attribute_rec.ID, l_attribute_rec.NAME, l_attribute_rec.KEY, l_attribute_rec.DATA_TYPE, l_attribute_rec.ATTRIBUTE_QUALIFIER, l_attribute_rec.VALUE, p_hotel_id, p_stay_date, p_debug_flag, 0, JSON_ARRAY_T(), p_response_clob);
                        RETURN;
                    END IF;

                    -- Step 1: Extract all attribute references and fetch their values
                    l_pos := 1;
                    LOOP
                        l_ref_key := REGEXP_SUBSTR(l_formula, '#([^#]+)#', l_pos, 1, NULL, 1);
                        EXIT WHEN l_ref_key IS NULL;

                        append_debug('Found reference: #' || l_ref_key || '#');

                        -- Check if it's a direct table.column reference
                        IF INSTR(l_ref_key, '.') > 0 THEN
                            -- Direct table reference (e.g., UR_HOTELS.CAPACITY)
                            DECLARE
                                l_table_name VARCHAR2(100) := SUBSTR(l_ref_key, 1, INSTR(l_ref_key, '.') - 1);
                                l_col_name   VARCHAR2(100) := SUBSTR(l_ref_key, INSTR(l_ref_key, '.') + 1);
                                l_direct_val NUMBER;
                            BEGIN
                                IF UPPER(l_table_name) = 'UR_HOTELS' THEN
                                    EXECUTE IMMEDIATE 'SELECT ' || DBMS_ASSERT.ENQUOTE_NAME(l_col_name) ||
                                                      ' FROM UR_HOTELS WHERE ID = :hotel_id'
                                    INTO l_direct_val USING l_attr_hotel_id;

                                    append_debug('Direct table ref ' || l_ref_key || ' = ' || l_direct_val);

                                    -- Store as a constant for all dates
                                    l_attr_data(l_ref_key)('__CONSTANT__') := l_direct_val;
                                END IF;
                            EXCEPTION
                                WHEN OTHERS THEN
                                    append_debug('Error fetching direct ref ' || l_ref_key || ': ' || SQLERRM);
                                    l_attr_data(l_ref_key)('__CONSTANT__') := NULL;
                            END;
                        ELSE
                            -- Attribute reference - need to look up by qualifier
                            BEGIN
                                -- Check if multiple attributes exist with the same qualifier
                                DECLARE
                                    l_attr_count NUMBER;
                                BEGIN
                                    SELECT COUNT(*)
                                    INTO l_attr_count
                                    FROM ur_algo_attributes
                                    WHERE UPPER(ATTRIBUTE_QUALIFIER) = UPPER(l_ref_key)
                                      AND (hotel_id = l_attr_hotel_id OR hotel_id IS NULL);

                                    IF l_attr_count > 1 THEN
                                        append_debug('WARNING: Multiple attributes found (' || l_attr_count || ') for qualifier "' || l_ref_key || '". Using first match based on hotel_id precedence.');
                                    ELSIF l_attr_count = 0 THEN
                                        append_debug('WARNING: No attributes found for qualifier "' || l_ref_key || '".');
                                    END IF;
                                END;

                                -- Find attribute by qualifier matching the reference
                                FOR attr_rec IN (
                                    SELECT ID, KEY
                                    FROM ur_algo_attributes
                                    WHERE UPPER(ATTRIBUTE_QUALIFIER) = UPPER(l_ref_key)
                                      AND (hotel_id = l_attr_hotel_id OR hotel_id IS NULL)
                                    ORDER BY hotel_id NULLS LAST
                                    FETCH FIRST 1 ROWS ONLY
                                ) LOOP
                                    append_debug('Resolved ' || l_ref_key || ' to attribute key: ' || attr_rec.KEY);

                                    -- Fetch attribute values
                                    GET_ATTRIBUTE_VALUE(
                                        p_attribute_id  => attr_rec.ID,
                                        p_hotel_id      => l_attr_hotel_id,
                                        p_stay_date     => p_stay_date,
                                        p_round_digits  => p_round_digits,
                                        p_debug_flag    => p_debug_flag,  -- Pass through debug flag to see nested errors
                                        p_response_clob => l_ref_response
                                    );

                                    -- Parse response and store values by date
                                    l_ref_json := JSON_OBJECT_T.parse(l_ref_response);
                                    IF l_ref_json.get_string('STATUS') = 'S' OR l_ref_json.get_string('STATUS') = 'W' THEN
                                        l_ref_payload := l_ref_json.get_array('RESPONSE_PAYLOAD');
                                        IF l_ref_payload IS NOT NULL THEN
                                            FOR i IN 0 .. l_ref_payload.get_size - 1 LOOP
                                                BEGIN
                                                    l_ref_item := TREAT(l_ref_payload.get(i) AS JSON_OBJECT_T);
                                                    l_ref_stay_date := l_ref_item.get_string('stay_date');
                                                    l_ref_attr_value := l_ref_item.get_string('attribute_value');

                                                    -- FIX: Skip records with NULL stay_date to prevent ORA-06502
                                                    IF l_ref_stay_date IS NOT NULL THEN
                                                        l_attr_data(l_ref_key)(l_ref_stay_date) := safe_to_number(l_ref_attr_value);

                                                        -- Collect unique dates
                                                        IF NOT l_all_dates.EXISTS(l_date_idx) OR l_all_dates(l_date_idx) != l_ref_stay_date THEN
                                                            -- Check if date already exists
                                                            DECLARE
                                                                l_found BOOLEAN := FALSE;
                                                            BEGIN
                                                                FOR j IN 1 .. l_date_idx LOOP
                                                                    IF l_all_dates(j) = l_ref_stay_date THEN
                                                                        l_found := TRUE;
                                                                        EXIT;
                                                                    END IF;
                                                                END LOOP;
                                                                IF NOT l_found THEN
                                                                    l_date_idx := l_date_idx + 1;
                                                                    l_all_dates(l_date_idx) := l_ref_stay_date;
                                                                END IF;
                                                            END;
                                                        END IF;

                                                        append_debug('Stored ' || l_ref_key || '[' || l_ref_stay_date || '] = ' || l_ref_attr_value);
                                                    ELSE
                                                        append_debug('Skipped ' || l_ref_key || ' with NULL stay_date, value: ' || l_ref_attr_value);
                                                    END IF;
                                                EXCEPTION
                                                    WHEN OTHERS THEN
                                                        append_debug('Error processing ' || l_ref_key || ' record ' || i || ': ' || SQLERRM || ' (stay_date=' || l_ref_stay_date || ', value=' || l_ref_attr_value || ')');
                                                END;
                                            END LOOP;
                                        END IF;
                                    END IF;
                                END LOOP;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    append_debug('Attribute not found for qualifier: ' || l_ref_key);
                                WHEN OTHERS THEN
                                    append_debug('Error fetching attribute ' || l_ref_key || ': ' || SQLERRM);
                            END;
                        END IF;

                        l_pos := REGEXP_INSTR(l_formula, '#', l_pos, 2) + 1;
                    END LOOP;

                    -- Step 2: Calculate formula for each unique date
                    append_debug('Calculating formula for ' || l_date_idx || ' dates.');

                    -- FIX: Check if we have any dates before attempting calculation
                    IF l_date_idx = 0 THEN
                        append_debug('No dates available for calculation. All referenced attributes may have NULL stay_dates or no records.');
                        l_message := '0 calculated records fetched (no valid dates).';
                    ELSE
                        FOR i IN 1 .. l_date_idx LOOP
                            l_date_str := l_all_dates(i);
                            l_resolved_formula := l_formula;

                            append_debug('Processing date: ' || l_date_str);

                            -- Substitute all references with values
                            l_pos := 1;
                            LOOP
                                l_ref_key := REGEXP_SUBSTR(l_formula, '#([^#]+)#', l_pos, 1, NULL, 1);
                                EXIT WHEN l_ref_key IS NULL;

                                -- Get value for this reference and date
                                IF l_attr_data.EXISTS(l_ref_key) THEN
                                    IF l_attr_data(l_ref_key).EXISTS('__CONSTANT__') THEN
                                        l_ref_value := l_attr_data(l_ref_key)('__CONSTANT__');
                                    ELSIF l_date_str IS NOT NULL AND l_attr_data(l_ref_key).EXISTS(l_date_str) THEN
                                        l_ref_value := l_attr_data(l_ref_key)(l_date_str);
                                        -- Handle NULL values for OUT_OF_ORDER_ROOMS - default to 0
                                        IF l_ref_value IS NULL AND UPPER(l_ref_key) = 'OUT_OF_ORDER_ROOMS' THEN
                                            l_ref_value := 0;
                                            append_debug('Attribute ' || l_ref_key || ' has NULL value for ' || l_date_str || ', defaulting to 0');
                                        END IF;
                                    ELSE
                                        -- Date not found in attribute data
                                        IF UPPER(l_ref_key) = 'OUT_OF_ORDER_ROOMS' THEN
                                            l_ref_value := 0;  -- Default to 0 when date not found
                                            append_debug('Attribute ' || l_ref_key || ' has no data for ' || l_date_str || ', defaulting to 0');
                                        ELSE
                                            l_ref_value := NULL;
                                        END IF;
                                    END IF;
                                ELSE
                                    -- Missing attribute case
                                    -- Special handling for attributes that should default to 0 when not found
                                    IF UPPER(l_ref_key) = 'OUT_OF_ORDER_ROOMS' THEN
                                        l_ref_value := 0;  -- Default to 0 instead of NULL
                                        append_debug('Attribute ' || l_ref_key || ' not found, defaulting to 0');
                                    ELSE
                                        l_ref_value := NULL;
                                    END IF;
                                END IF;

                            -- Substitute in formula
                            IF l_ref_value IS NOT NULL THEN
                                l_resolved_formula := REPLACE(l_resolved_formula, '#' || l_ref_key || '#', TO_CHAR(l_ref_value));
                            ELSE
                                l_resolved_formula := REPLACE(l_resolved_formula, '#' || l_ref_key || '#', 'NULL');
                            END IF;

                            l_pos := REGEXP_INSTR(l_formula, '#', l_pos, 2) + 1;
                        END LOOP;

                        append_debug('Resolved formula: ' || l_resolved_formula);

                        -- Evaluate the formula safely
                        l_calc_result := evaluate_expression(l_resolved_formula);

                        append_debug('Calculated result: ' || NVL(TO_CHAR(l_calc_result), 'NULL'));

                        -- FIX: Add to results only if result is not NULL AND stay_date is not NULL
                        IF l_calc_result IS NOT NULL AND l_date_str IS NOT NULL THEN
                            l_records_fetched := l_records_fetched + 1;
                            l_json_row_obj := JSON_OBJECT_T();
                            l_json_row_obj.put('stay_date', l_date_str);

                            IF l_attribute_rec.DATA_TYPE = 'NUMBER' THEN
                                l_json_row_obj.put('attribute_value', ROUND(l_calc_result, p_round_digits));
                            ELSE
                                l_json_row_obj.put('attribute_value', TO_CHAR(l_calc_result));
                            END IF;

                            l_json_payload_arr.append(l_json_row_obj);
                        END IF;
                    END LOOP;

                    l_message := l_records_fetched || ' calculated records fetched.';
                    END IF; -- Close the IF l_date_idx = 0 check
                END IF;
            END;

        ELSE
            RAISE_APPLICATION_ERROR(-20005, 'Attribute validation error: Unknown TYPE ''' || l_attribute_rec.TYPE || '''. Must be ''M'' (Manual), ''S'' (Sourced), or ''C'' (Calculated).');
        END IF;

        IF l_message IS NULL THEN
            l_message := l_records_fetched || ' records fetched successfully.';
            IF l_records_fetched = 0 AND l_attribute_rec.TYPE != 'M' THEN
                l_status  := 'W';
                l_message := 'No records found for the given criteria.';
            END IF;
        END IF;

        IF p_debug_flag THEN
            l_message := l_message || CHR(10) || '--- DEBUG LOG ---' || CHR(10) || l_debug_log;
        END IF;

        build_json_response(l_status, l_message, l_attribute_rec.ID, l_attribute_rec.NAME, l_attribute_rec.KEY, l_attribute_rec.DATA_TYPE, l_attribute_rec.ATTRIBUTE_QUALIFIER, l_attribute_rec.VALUE, p_hotel_id, p_stay_date, p_debug_flag, l_records_fetched, l_json_payload_arr, p_response_clob);

    EXCEPTION
        WHEN OTHERS THEN
            IF l_cursor%ISOPEN THEN
                CLOSE l_cursor;
            END IF;
            l_status  := 'E';
            l_message := 'An unexpected error occurred: ' || SQLERRM;
            append_debug(l_message);
            IF p_debug_flag THEN
                l_message := l_message || CHR(10) || '--- DEBUG LOG ---' || CHR(10) || l_debug_log;
            END IF;
            build_json_response(
                'E',
                l_message,
                l_attribute_rec.ID,
                NVL(l_attribute_rec.NAME, 'UNKNOWN'),
                NVL(l_attribute_rec.KEY, p_attribute_key),
                NVL(l_attribute_rec.DATA_TYPE, 'UNKNOWN'),
                NVL(l_attribute_rec.ATTRIBUTE_QUALIFIER, 'UNKNOWN'),
                NVL(l_attribute_rec.VALUE, 'UNKNOWN'),
                p_hotel_id,
                p_stay_date,
                p_debug_flag,
                0,
                JSON_ARRAY_T(),
                p_response_clob
            );
    END GET_ATTRIBUTE_VALUE;

    --------------------------------------------------------------------------------

    FUNCTION Clean_TEXT(p_text IN VARCHAR2) RETURN VARCHAR2 IS
        v_clean VARCHAR2(4000);
    BEGIN
        v_clean := UPPER(
            SUBSTR(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(
                        REGEXP_REPLACE(
                            TRIM(p_text),
                            '^[^A-Za-z0-9]+|[^A-Za-z0-9]+$',
                            ''
                        ),
                        '[^A-Za-z0-9]+',
                        '_'
                    ),
                    '_+',
                    '_'
                ),
                1,
                110
            )
        );
        RETURN v_clean;
    END Clean_TEXT;

    --------------------------------------------------------------------------------

    FUNCTION normalize_json(p_json CLOB) RETURN CLOB IS
    BEGIN
        RETURN REPLACE(REPLACE(p_json, '"data-type"', '"data_type"'), '"DATA-TYPE"', '"data_type"');
    END normalize_json;

    --------------------------------------------------------------------------------

    PROCEDURE get_collection_json(
        p_collection_name IN  VARCHAR2,
        p_json_clob       OUT CLOB,
        p_status          OUT VARCHAR2,
        p_message         OUT VARCHAR2
    ) IS
        l_count NUMBER;
    BEGIN
        SELECT
            COUNT(*)
        INTO l_count
        FROM
            apex_collections
        WHERE
            collection_name = p_collection_name;

        IF l_count = 0 THEN
            p_status    := 'E';
            p_message   := 'Failure: Collection "' || p_collection_name || '" does not exist or is empty';
            p_json_clob := NULL;
            RETURN;
        END IF;

        -- Initialize and build JSON output
        apex_json.initialize_clob_output;
        apex_json.open_array;

        FOR rec IN (
            SELECT
                c001,
                c002,
                c003,
                c004,
                c005,
                c006,
                c007
            FROM
                apex_collections
            WHERE
                collection_name = p_collection_name
            ORDER BY
                seq_id
        ) LOOP
            apex_json.open_object;
            apex_json.write('name', rec.c001);
            apex_json.write('data_type', rec.c002);
            apex_json.write('qualifier', rec.c003);
            apex_json.write('value', rec.c004);
            apex_json.write('mapping_type', rec.c005);
            apex_json.write('original_name', rec.c006);
            apex_json.write('format_mask', rec.c007);
            apex_json.close_object;
        END LOOP;

        apex_json.close_array;

        p_json_clob := apex_json.get_clob_output;

        apex_json.free_output;

        p_status  := 'S';
        p_message := 'JSON generated for collection "' || p_collection_name || '"';

    EXCEPTION
        WHEN OTHERS THEN
            p_status    := 'E';
            p_message   := 'Failure: ' || SQLERRM;
            p_json_clob := NULL;
    END get_collection_json;

    --------------------------------------------------------------------------------

    PROCEDURE define_db_object(
        p_template_key IN  VARCHAR2,
        p_status       OUT BOOLEAN,
        p_message      OUT VARCHAR2,
        p_mode         IN  VARCHAR2 DEFAULT 'N' -- 'N' = new create, 'U' = update/replace existing
    ) IS
        v_db_object_name VARCHAR2(130);
        v_sql            CLOB;
        v_col_defs       CLOB := '';
        v_unique_defs    CLOB := '';
        v_definition     CLOB;
        v_exists         NUMBER;
        v_trigger_name   VARCHAR2(130);
        l_col_name       VARCHAR2(100);
    BEGIN
        -- 🔒 Lock and fetch details
        SELECT
            db_object_name,
            definition
        INTO
            v_db_object_name,
            v_definition
        FROM
            ur_templates
        WHERE
            key = p_template_key
        FOR UPDATE;

        IF v_definition IS NULL THEN
            p_status  := FALSE;
            p_message := 'Failure: Definition JSON is NULL for template_key ' || p_template_key;
            RETURN;
        END IF;

        -- Generate table name if not already defined
        IF v_db_object_name IS NULL THEN
            v_db_object_name := 'UR_TMPLT_' || UPPER(p_template_key) || '_T';
        END IF;

        -- 🔍 Check if table exists
        SELECT
            COUNT(*)
        INTO v_exists
        FROM
            all_tables
        WHERE
            table_name = UPPER(v_db_object_name);

        -- 🧩 Handle based on mode
        IF v_exists > 0 THEN
            IF p_mode = 'N' THEN
                p_status  := FALSE;
                p_message := 'Failure: Table ' || v_db_object_name || ' already exists.';
                RETURN;
            ELSIF p_mode = 'U' THEN
                -- Drop existing trigger if exists
                BEGIN
                    v_trigger_name := v_db_object_name || '_BI_TRG';
                    EXECUTE IMMEDIATE 'DROP TRIGGER "' || v_trigger_name || '"';
                EXCEPTION
                    WHEN OTHERS THEN
                        NULL; -- ignore if not exists
                END;

                -- Drop existing table
                BEGIN
                    EXECUTE IMMEDIATE 'DROP TABLE "' || v_db_object_name || '" CASCADE CONSTRAINTS';
                EXCEPTION
                    WHEN OTHERS THEN
                        p_status  := FALSE;
                        p_message := 'Failure dropping existing table: ' || SQLERRM;
                        RETURN;
                END;
            END IF;
        END IF;

        -- Start with ID RAW(16) as primary key column
        v_col_defs := '"REC_ID" RAW(16)';

        -- Parse JSON definition
        FOR rec IN (
            SELECT
                jt.name,
                jt.data_type,
                jt.qualifier
            FROM
                JSON_TABLE(
                    normalize_json(v_definition),
                    '$[*]' COLUMNS (
                        name      VARCHAR2(100) PATH '$.name',
                        data_type VARCHAR2(30)  PATH '$.data_type',
                        qualifier VARCHAR2(30)  PATH '$.qualifier'
                    )
                ) jt
        ) LOOP
            -- Sanitize and normalize column name
            l_col_name := UPPER(TRIM(BOTH '_' FROM rec.name));
            l_col_name := REGEXP_REPLACE(l_col_name, '_{2,}', '_');
            -- l_col_name := REGEXP_REPLACE(l_col_name, '[^A-Za-z0-9]', '_');  -- ADDED THIS LINE ON 26/11

            INSERT INTO DEBUG_LOG (MESSAGE) VALUES (l_col_name);
            v_col_defs := v_col_defs || ', ';

            -- Map data types
            IF UPPER(rec.data_type) = 'TEXT' THEN
                v_col_defs := v_col_defs || '"' || l_col_name || '" VARCHAR2(4000)';
            ELSIF UPPER(rec.data_type) = 'NUMBER' THEN
                v_col_defs := v_col_defs || '"' || l_col_name || '" NUMBER';
            ELSIF UPPER(rec.data_type) = 'DATE' THEN
                v_col_defs := v_col_defs || '"' || l_col_name || '" DATE';
            ELSE
                v_col_defs := v_col_defs || '"' || l_col_name || '" VARCHAR2(4000)';
            END IF;

            -- Add unique constraint for special qualifiers
            IF UPPER(rec.qualifier) = 'STAY_DATE' THEN
                v_unique_defs :=
                    v_unique_defs ||
                    ', CONSTRAINT "' || v_db_object_name || '_' || l_col_name || '_UQ" UNIQUE ("' ||
                    l_col_name || '")';
            END IF;
        END LOOP;

        -- Add WHO / AUDIT columns
        v_col_defs :=
            v_col_defs ||
            ', CREATED_BY RAW(16), UPDATED_BY RAW(16), CREATED_ON DATE, UPDATED_ON DATE, HOTEL_ID RAW(16), INTERFACE_LOG_ID RAW(16)';

        -- Build CREATE TABLE DDL
        v_sql :=
            'CREATE TABLE "' || v_db_object_name || '" (' ||
            v_col_defs ||
            ', CONSTRAINT "' || v_db_object_name || '_PK" PRIMARY KEY ("REC_ID")' ||
            v_unique_defs || ')';

        EXECUTE IMMEDIATE v_sql;

        -- Create or replace trigger
        v_trigger_name := v_db_object_name || '_BI_TRG';
        v_sql          := '
CREATE OR REPLACE EDITIONABLE TRIGGER "' || v_trigger_name || '"
BEFORE INSERT OR UPDATE ON "' || v_db_object_name || '"
FOR EACH ROW
DECLARE
  v_user_id UR_USERS.USER_ID%TYPE;
BEGIN
  SELECT USER_ID INTO v_user_id
    FROM UR_USERS
   WHERE USER_NAME = SYS_CONTEXT(''APEX$SESSION'', ''APP_USER'');

  IF :NEW.REC_ID IS NULL THEN
    :NEW.REC_ID := SYS_GUID();
  END IF;

  IF INSERTING THEN
    :NEW.CREATED_BY := v_user_id;
    :NEW.CREATED_ON := SYSDATE;
    :NEW.UPDATED_BY := v_user_id;
    :NEW.UPDATED_ON := SYSDATE;
  ELSIF UPDATING THEN
    :NEW.UPDATED_BY := v_user_id;
    :NEW.UPDATED_ON := SYSDATE;
  END IF;
END ' || v_trigger_name || ';
';
        EXECUTE IMMEDIATE v_sql;

        -- Update UR_TEMPLATES
        UPDATE ur_templates
        SET
            db_object_name         = v_db_object_name,
            db_object_created_on   = SYSDATE
        WHERE
            key = p_template_key;

        COMMIT;

        p_status := TRUE;
        IF p_mode = 'U' THEN
            p_message := 'Success: Table "' || v_db_object_name || '" redefined (replaced) successfully.';
        ELSE
            p_message := 'Success: Table "' || v_db_object_name || '" created with ID primary key and trigger.';
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_status  := FALSE;
            p_message := 'Failure: Template key not found';
        WHEN OTHERS THEN
            p_status  := FALSE;
            p_message := 'Failure: ' || SQLERRM;
    END define_db_object;

    --------------------------------------------------------------------------------

    PROCEDURE create_ranking_view(
        p_template_key IN  VARCHAR2,
        p_status       OUT BOOLEAN,
        p_message      OUT VARCHAR2
    ) IS
        -- Metadata Variables
        v_definition       CLOB;
        v_data_table_name  VARCHAR2(128);
        v_view_name        VARCHAR2(128);
        v_sdate_col        VARCHAR2(128);
        v_own_property_col VARCHAR2(128);
        v_comp_property_list CLOB;  -- Only competitor properties (COMP_PROPERTY qualifier)

        -- Dynamic SQL Variables
        v_sql              CLOB;
        v_pivot_clause     CLOB; -- For inside the subquery
        v_final_columns    CLOB; -- For the final SELECT list
        v_comp_count       NUMBER := 0;  -- Count of competitor properties only
        v_exists           NUMBER;

    BEGIN
        -- Step 1: Lock row and get metadata
        SELECT
            definition,
            db_object_name
        INTO
            v_definition,
            v_data_table_name
        FROM
            ur_templates
        WHERE
            key = p_template_key
        FOR UPDATE;

        -- Step 2: Validation checks
        IF v_definition IS NULL THEN
            p_status  := FALSE;
            p_message := 'Failure: Definition JSON is NULL.';
            ROLLBACK;
            RETURN;
        END IF;
        IF v_data_table_name IS NULL THEN
            p_status  := FALSE;
            p_message := 'Failure: DB object not yet defined.';
            ROLLBACK;
            RETURN;
        END IF;
        SELECT COUNT(*) INTO v_exists FROM user_tables WHERE table_name = UPPER(v_data_table_name);
        IF v_exists = 0 THEN
            p_status  := FALSE;
            p_message := 'Failure: Source table ' || v_data_table_name || ' does not exist.';
            ROLLBACK;
            RETURN;
        END IF;

        -- Step 3: Parse JSON to get column names and count all properties
        SELECT jt.name
        INTO   v_sdate_col
        FROM   JSON_TABLE(v_definition, '$[*]' COLUMNS (name VARCHAR2(128) PATH '$.name', qualifier VARCHAR2(128) PATH '$.qualifier')) jt
        WHERE  jt.qualifier = 'STAY_DATE';

        SELECT jt.name
        INTO   v_own_property_col
        FROM   JSON_TABLE(v_definition, '$[*]' COLUMNS (name VARCHAR2(128) PATH '$.name', qualifier VARCHAR2(128) PATH '$.qualifier')) jt
        WHERE  jt.qualifier = 'OWN_PROPERTY';

        -- Get only COMP_PROPERTY columns for competitor ranking (excludes OWN_PROPERTY)
        SELECT
            LISTAGG('"' || jt.name || '"', ', ') WITHIN GROUP(
                ORDER BY
                    jt.name
            ),
            COUNT(jt.name)
        INTO
            v_comp_property_list,
            v_comp_count
        FROM
            JSON_TABLE(v_definition, '$[*]' COLUMNS (name VARCHAR2(128) PATH '$.name', qualifier VARCHAR2(128) PATH '$.qualifier')) jt
        WHERE
            jt.qualifier = 'COMP_PROPERTY';

        -- Step 4: Build the dynamic PIVOT and final column list clauses
        -- Generate RANK_N columns based on competitor count only (OWN_PROPERTY excluded from ranking)
        FOR i IN 1..v_comp_count LOOP
            v_pivot_clause := v_pivot_clause ||
                              'MAX(CASE WHEN overall_rank = ' || i || ' THEN hotel_name END) AS "RANK_' || i || '_NAME",' || CHR(10) ||
                              'MAX(CASE WHEN overall_rank = ' || i || ' THEN price END) AS "RANK_' || i || '_RATE",' || CHR(10);

            v_final_columns := v_final_columns ||
                               'p."RANK_' || i || '_NAME",' || CHR(10) ||
                               'p."RANK_' || i || '_RATE",' || CHR(10);
        END LOOP;
        v_pivot_clause  := RTRIM(v_pivot_clause, ',' || CHR(10));
        v_final_columns := RTRIM(v_final_columns, ',' || CHR(10));


        -- Step 5: Build the final CREATE VIEW statement
        -- New logic:
        --   1. Exclude OWN_PROPERTY from competitor rankings (RANK_1 to RANK_N are competitors only)
        --   2. Filter out invalid prices ($0, NULL, non-numeric) from competitor ranking
        --   3. Calculate OWN_PROPERTY_RANK separately (ties go against own property - worse rank)
        --   4. Add VALID_COMP_COUNT for rank shifting in evaluation engine
        v_view_name := 'UR_TMPLT_' || p_template_key || '_RANK_V';

        v_sql := 'CREATE OR REPLACE VIEW "' || v_view_name || '" AS ' || CHR(10) ||
                 -- CTE 1: Get valid competitor prices only (exclude own property, filter out $0/NULL/non-numeric)
                 'WITH valid_competitors AS (' || CHR(10) ||
                 '  SELECT ' || CHR(10) ||
                 '      "HOTEL_ID",' || CHR(10) ||
                 '      "' || v_sdate_col || '",' || CHR(10) ||
                 '      hotel_name,' || CHR(10) ||
                 '      TO_NUMBER(REPLACE(price, '','', '''')) AS price' || CHR(10) ||
                 '  FROM "' || v_data_table_name || '"' || CHR(10) ||
                 '  UNPIVOT (price FOR hotel_name IN (' || v_comp_property_list || '))' || CHR(10) ||
                 '  WHERE REGEXP_LIKE(price, ''^[0-9,.]+$'')' || CHR(10) ||
                 '    AND TO_NUMBER(REPLACE(price, '','', '''')) > 0' || CHR(10) ||
                 '),' || CHR(10) ||
                 -- CTE 2: Rank valid competitors by price (ascending - cheapest = rank 1)
                 'competitors_ranked AS (' || CHR(10) ||
                 '  SELECT ' || CHR(10) ||
                 '      "HOTEL_ID",' || CHR(10) ||
                 '      "' || v_sdate_col || '",' || CHR(10) ||
                 '      hotel_name,' || CHR(10) ||
                 '      price,' || CHR(10) ||
                 '      ROW_NUMBER() OVER(PARTITION BY "' || v_sdate_col || '" ORDER BY price ASC) as overall_rank' || CHR(10) ||
                 '  FROM valid_competitors' || CHR(10) ||
                 '),' || CHR(10) ||
                 -- CTE 3: Get own property price data (filter out invalid prices)
                 'own_property_data AS (' || CHR(10) ||
                 '  SELECT ' || CHR(10) ||
                 '      "HOTEL_ID",' || CHR(10) ||
                 '      "' || v_sdate_col || '",' || CHR(10) ||
                 '      TO_NUMBER(REPLACE("' || v_own_property_col || '", '','', '''')) AS own_price' || CHR(10) ||
                 '  FROM "' || v_data_table_name || '"' || CHR(10) ||
                 '  WHERE REGEXP_LIKE("' || v_own_property_col || '", ''^[0-9,.]+$'')' || CHR(10) ||
                 '    AND TO_NUMBER(REPLACE("' || v_own_property_col || '", '','', '''')) > 0' || CHR(10) ||
                 '),' || CHR(10) ||
                 -- CTE 4: Calculate own property rank against valid competitors
                 -- Ties go AGAINST own property (use <= to count equal prices, pushing own to worse rank)
                 'own_property_rank AS (' || CHR(10) ||
                 '  SELECT ' || CHR(10) ||
                 '      o."HOTEL_ID",' || CHR(10) ||
                 '      o."' || v_sdate_col || '",' || CHR(10) ||
                 '      o.own_price,' || CHR(10) ||
                 '      (SELECT COUNT(*) + 1 FROM valid_competitors vc' || CHR(10) ||
                 '       WHERE vc."' || v_sdate_col || '" = o."' || v_sdate_col || '"' || CHR(10) ||
                 '         AND vc.price <= o.own_price) AS own_rank' || CHR(10) ||
                 '  FROM own_property_data o' || CHR(10) ||
                 '),' || CHR(10) ||
                 -- CTE 5: Pivot competitors into RANK_N_NAME and RANK_N_RATE columns
                 'pivoted_competitors AS (' || CHR(10) ||
                 '  SELECT ' || CHR(10) ||
                 '      "' || v_sdate_col || '",' || CHR(10) ||
                 '      "HOTEL_ID",' || CHR(10) ||
                 '      ' || v_pivot_clause || CHR(10) ||
                 '  FROM competitors_ranked' || CHR(10) ||
                 '  GROUP BY "' || v_sdate_col || '", "HOTEL_ID"' || CHR(10) ||
                 ')' || CHR(10) ||
                 -- Final SELECT: Combine pivoted competitors with own property data
                 'SELECT ' || CHR(10) ||
                 '  p."' || v_sdate_col || '" AS "STAY_DATE",' || CHR(10) ||
                 '  p."HOTEL_ID",' || CHR(10) ||
                 '  opr.own_price AS "OWN_PROPERTY_RATE",' || CHR(10) ||
                 '  opr.own_rank AS "OWN_PROPERTY_RANK",' || CHR(10) ||
                 '  (SELECT COUNT(*) FROM valid_competitors vc WHERE vc."' || v_sdate_col || '" = p."' || v_sdate_col || '") AS "VALID_COMP_COUNT",' || CHR(10) ||
                 '  ' || v_final_columns || CHR(10) ||
                 'FROM pivoted_competitors p' || CHR(10) ||
                 'LEFT JOIN own_property_rank opr ON p."' || v_sdate_col || '" = opr."' || v_sdate_col || '"';

        -- Step 6: Execute the dynamic SQL
        EXECUTE IMMEDIATE v_sql;

        -- Update UR_TEMPLATES with the new db_view_object_name and timestamp
        UPDATE ur_templates
        SET
            db_view_object_name        = v_view_name,
            db_view_object_created_on  = SYSDATE
        WHERE
            key = p_template_key;

        COMMIT;
        p_status  := TRUE;
        p_message := 'Success! Ranking view "' || v_view_name || '" created or replaced.';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             p_status  := TRUE;
          --  p_status  := FALSE;
           -- p_message := 'Failure: Could not find a required qualifier (STAY_DATE, OWN_PROPERTY) in template key ''' || p_template_key || '''.'; commented on 7/11
          
            ROLLBACK;
        WHEN OTHERS THEN
            p_status := FALSE;
            p_message := 'Failure: ' || SQLERRM;
            DBMS_OUTPUT.PUT_LINE('--- FAILED SQL ---');
            DBMS_OUTPUT.PUT_LINE(v_sql);
            DBMS_OUTPUT.PUT_LINE('------------------');
            ROLLBACK;
    END create_ranking_view;

    --------------------------------------------------------------------------------

    PROCEDURE LOAD_DATA_MAPPING_COLLECTION(
        p_file_id           IN  VARCHAR2,
        p_template_id       IN  VARCHAR2,
        p_collection_name   IN  VARCHAR2,
        p_use_original_name IN  VARCHAR2 DEFAULT 'AUTO',
        p_match_datatype    IN  VARCHAR2 DEFAULT 'Y',
        p_status            OUT VARCHAR2,
        p_message           OUT VARCHAR2
    ) IS
        -- Local variables
        v_seq_id                 NUMBER;
        v_use_original_name_use  VARCHAR2(10);
        v_match_datatype_use     VARCHAR2(10);
    BEGIN
        -- Initialize outputs
        p_status  := 'S';
        p_message := 'Processing completed successfully.';

        ------------------------------------------------------------------------
        -- Step 0: Validate and normalize input parameters
        ------------------------------------------------------------------------
        -- Validate p_use_original_name
        v_use_original_name_use := UPPER(NVL(p_use_original_name, 'AUTO'));
        IF v_use_original_name_use NOT IN ('Y', 'N', 'AUTO') THEN
            v_use_original_name_use := 'AUTO';
        END IF;

        -- Validate p_match_datatype
        v_match_datatype_use := UPPER(NVL(p_match_datatype, 'Y'));
        IF v_match_datatype_use NOT IN ('Y', 'N') THEN
            v_match_datatype_use := 'Y';
        END IF;

        ------------------------------------------------------------------------
        -- Step 0.5: Re-parse file from temp_blob using template metadata
        ------------------------------------------------------------------------
        DECLARE
            v_file_type NUMBER;
            v_skip_rows NUMBER;
            v_sheet_file_name VARCHAR2(200);
            v_sheet_display_name VARCHAR2(200);
            v_matched_sheet_file_name VARCHAR2(200);
            v_file_blob BLOB;
            v_filename VARCHAR2(500);
            v_profile CLOB;
            v_columns CLOB;
        BEGIN
            -- Get template metadata
            BEGIN
                SELECT
                    JSON_VALUE(metadata, '$.file_type' RETURNING NUMBER),
                    JSON_VALUE(metadata, '$.skip_rows' RETURNING NUMBER DEFAULT 0 ON ERROR),
                    JSON_VALUE(metadata, '$.sheet_file_name'),
                    JSON_VALUE(metadata, '$.sheet_display_name')
                INTO v_file_type, v_skip_rows, v_sheet_file_name, v_sheet_display_name
                FROM ur_templates
                WHERE id = p_template_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_status := 'E';
                    p_message := 'Template not found for ID: ' || p_template_id;
                    RETURN;
            END;

            -- Get file from temp_blob
            BEGIN
                SELECT BLOB_CONTENT, FILENAME
                INTO v_file_blob, v_filename
                FROM temp_BLOB
                WHERE ID = p_file_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_status := 'E';
                    p_message := 'File not found for ID: ' || p_file_id;
                    RETURN;
            END;

            -- Re-parse file based on file type
            BEGIN
                IF v_file_type = 1 THEN
                    -- Excel: Match by sheet_display_name to get sheet_file_name
                    IF v_sheet_display_name IS NOT NULL THEN
                        BEGIN
                            -- Find the actual sheet_file_name by matching sheet_display_name
                            SELECT SHEET_FILE_NAME
                            INTO v_matched_sheet_file_name
                            FROM TABLE(
                                apex_data_parser.get_xlsx_worksheets(
                                    p_content => v_file_blob
                                )
                            )
                            WHERE SHEET_DISPLAY_NAME = v_sheet_display_name;

                            -- Use the matched sheet_file_name for parsing
                            v_profile := apex_data_parser.discover(
                                p_content => v_file_blob,
                                p_file_name => v_filename,
                                p_skip_rows => NVL(v_skip_rows, 0),
                                p_xlsx_sheet_name => v_matched_sheet_file_name,
                                p_max_rows => NULL
                            );
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                -- Fallback: try using sheet_file_name directly if display name doesn't match
                                v_profile := apex_data_parser.discover(
                                    p_content => v_file_blob,
                                    p_file_name => v_filename,
                                    p_skip_rows => NVL(v_skip_rows, 0),
                                    p_xlsx_sheet_name => v_sheet_file_name,
                                    p_max_rows => NULL
                                );
                        END;
                    ELSE
                        -- No sheet_display_name, use sheet_file_name directly
                        v_profile := apex_data_parser.discover(
                            p_content => v_file_blob,
                            p_file_name => v_filename,
                            p_skip_rows => NVL(v_skip_rows, 0),
                            p_xlsx_sheet_name => v_sheet_file_name,
                            p_max_rows => NULL
                        );
                    END IF;
                ELSIF v_file_type = 2 THEN
                    -- CSV: Use skip_rows ONLY
                    v_profile := apex_data_parser.discover(
                        p_content => v_file_blob,
                        p_file_name => v_filename,
                        p_skip_rows => NVL(v_skip_rows, 0),
                        p_max_rows => NULL
                    );
                ELSE
                    -- JSON/XML or other: Use defaults
                    v_profile := apex_data_parser.discover(
                        p_content => v_file_blob,
                        p_file_name => v_filename,
                        p_max_rows => NULL
                    );
                END IF;
            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_message := 'Error re-parsing file: ' || SQLERRM;
                    RETURN;
            END;

            -- Extract columns with correct data types and sanitize names
            BEGIN
                DECLARE
                    l_json_array JSON_ARRAY_T := JSON_ARRAY_T();
                    l_json_obj   JSON_OBJECT_T;
                    v_sanitized_name VARCHAR2(200);
                    v_data_type_str  VARCHAR2(20);
                BEGIN
                    FOR rec IN (
                        SELECT
                            jt.ord,
                            jt.name,
                            jt.data_type
                        FROM JSON_TABLE(
                               v_profile,
                               '$."columns"[*]'
                               COLUMNS (
                                 ord FOR ORDINALITY,
                                 name VARCHAR2(100) PATH '$.name',
                                 data_type NUMBER PATH '$."data-type"'
                               )
                             ) jt
                    ) LOOP
                        -- Sanitize the column name using our function
                        v_sanitized_name := sanitize_column_name(rec.name);

                        -- Map data type number to string
                        v_data_type_str := CASE rec.data_type
                                             WHEN 1 THEN 'TEXT'
                                             WHEN 2 THEN 'NUMBER'
                                             WHEN 3 THEN 'DATE'
                                             ELSE 'TEXT'
                                           END;

                        -- Build JSON object for this column
                        l_json_obj := JSON_OBJECT_T();
                        l_json_obj.put('name', v_sanitized_name);
                        l_json_obj.put('data_type', v_data_type_str);
                        l_json_obj.put('pos', 'COL' || LPAD(TO_CHAR(rec.ord), 3, '0'));

                        -- Add to array
                        l_json_array.append(l_json_obj);
                    END LOOP;

                    -- Convert array to CLOB
                    v_columns := l_json_array.to_clob();
                END;

                -- Update temp_blob with correctly parsed columns
                UPDATE temp_BLOB
                SET columns = v_columns,
                    profile = v_profile
                WHERE ID = p_file_id;

                COMMIT;
            EXCEPTION
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_message := 'Error extracting columns: ' || SQLERRM;
                    RETURN;
            END;
        END;

        ------------------------------------------------------------------------
        -- Step 1: Create or truncate the APEX collection
        ------------------------------------------------------------------------
        BEGIN
            IF APEX_COLLECTION.COLLECTION_EXISTS(p_collection_name) THEN
                APEX_COLLECTION.DELETE_COLLECTION(p_collection_name);
            END IF;

            APEX_COLLECTION.CREATE_COLLECTION(p_collection_name);

        EXCEPTION
            WHEN OTHERS THEN
                p_status  := 'E';
                p_message := 'Failed to create or truncate collection "' || p_collection_name || '": ' || SQLERRM;
                RETURN;
        END;

        ------------------------------------------------------------------------
        -- Step 2: Insert data from TEMP_BLOB JSON into collection (c001)
        ------------------------------------------------------------------------
        BEGIN
            FOR rec IN (
                SELECT
                    jt.name || ' (' || jt.data_type || ')' AS column_desc,
                    jt.col_position
                FROM
                    TEMP_BLOB t,
                    JSON_TABLE(
                        normalize_json(t.columns),
                        '$[*]' COLUMNS (
                            name       VARCHAR2(100) PATH '$.name',
                            data_type  VARCHAR2(100) PATH '$.data_type',
                            col_position VARCHAR2(100) PATH '$.pos'
                        )
                    ) jt
                WHERE
                    t.id = p_file_id
            ) LOOP
                APEX_COLLECTION.ADD_MEMBER(
                    p_collection_name => p_collection_name,
                    p_c001            => rec.column_desc,
                    p_c004            => rec.col_position
                );
            END LOOP;

        EXCEPTION
            WHEN OTHERS THEN
                p_status  := 'E';
                p_message := 'Failed to insert data from TEMP_BLOB (File ID: ' || p_file_id || '): ' || SQLERRM;
                RETURN;
        END;

        ------------------------------------------------------------------------
        -- Step 3: Update existing collection members with matching data from UR_TEMPLATES
        -- Now extracts: name, original_name, data_type, mapping_type, value, qualifier
        ------------------------------------------------------------------------
        BEGIN
            FOR rec IN (
                SELECT
                    jt.name,
                    jt.original_name,
                    jt.data_type,
                    NVL(jt.mapping_type, 'Maps To') AS mapping_type,
                    jt.value,
                    jt.qualifier,
                    jt.format_mask,
                    jt.name || ' (' || jt.data_type || ')' AS column_desc
                FROM
                    UR_TEMPLATES t,
                    JSON_TABLE(
                        normalize_json(t.definition),
                        '$[*]' COLUMNS (
                            name          VARCHAR2(100) PATH '$.name',
                            original_name VARCHAR2(100) PATH '$.original_name',
                            data_type     VARCHAR2(100) PATH '$.data_type',
                            mapping_type  VARCHAR2(100) PATH '$.mapping_type',
                            value         VARCHAR2(4000) PATH '$.value',
                            qualifier     VARCHAR2(100) PATH '$.qualifier',
                            format_mask   VARCHAR2(100) PATH '$.format_mask'
                        )
                    ) jt
                WHERE
                    t.id = p_template_id
                ORDER BY
                    t.id DESC
            ) LOOP
                BEGIN
                    -- Determine which template name to use for matching
                    DECLARE
                        v_template_match_name VARCHAR2(100);
                        v_source_name         VARCHAR2(100);
                        v_source_data_type    VARCHAR2(100);
                        v_match_found         BOOLEAN := FALSE;
                    BEGIN
                        -- Determine template name based on p_use_original_name
                        IF v_use_original_name_use = 'Y' THEN
                            -- Use original_name only
                            v_template_match_name := LOWER(TRIM(rec.original_name));
                        ELSIF v_use_original_name_use = 'N' THEN
                            -- Use name only
                            v_template_match_name := LOWER(TRIM(rec.name));
                        ELSE  -- 'AUTO'
                            -- AUTO mode: use original_name if available and not empty, else use name
                            v_template_match_name := LOWER(TRIM(NVL(NULLIF(rec.original_name, ''), rec.name)));
                        END IF;

                        -- Try to find matching collection member with flexible matching
                        FOR coll_rec IN (
                            SELECT seq_id, c001
                            FROM apex_collections
                            WHERE collection_name = p_collection_name
                              AND c001 IS NOT NULL
                        ) LOOP
                            -- Extract source name and data type from c001 format "NAME (TYPE)"
                            v_source_name      := LOWER(TRIM(REGEXP_SUBSTR(coll_rec.c001, '^[^(]+')));
                            v_source_data_type := LOWER(TRIM(REGEXP_SUBSTR(coll_rec.c001, '\(([^)]+)\)', 1, 1, NULL, 1)));

                            -- Skip if we couldn't extract a valid source name or template name
                            IF v_source_name IS NULL OR v_template_match_name IS NULL THEN
                                CONTINUE;
                            END IF;

                            -- Check if names match (case-insensitive)
                            IF v_source_name = v_template_match_name THEN
                                -- If matching data type is required, check it
                                IF v_match_datatype_use = 'Y' THEN
                                    IF v_source_data_type = LOWER(TRIM(rec.data_type)) THEN
                                        v_seq_id := coll_rec.seq_id;
                                        v_match_found := TRUE;
                                        EXIT;
                                    END IF;
                                ELSE
                                    -- Data type matching not required
                                    v_seq_id := coll_rec.seq_id;
                                    v_match_found := TRUE;
                                    EXIT;
                                END IF;
                            END IF;
                        END LOOP;

                        IF NOT v_match_found THEN
                            RAISE NO_DATA_FOUND;
                        END IF;
                    END;

                    -- Update c002: Target column descriptor
                    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                        p_collection_name => p_collection_name,
                        p_seq             => v_seq_id,
                        p_attr_number     => 2,
                        p_attr_value      => rec.column_desc
                    );

                    -- Update c003: mapping_type from template (was hardcoded 'Maps To')
                    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                        p_collection_name => p_collection_name,
                        p_seq             => v_seq_id,
                        p_attr_number     => 3,
                        p_attr_value      => rec.mapping_type
                    );

                    -- Update c004: value from template (for Calculation/Default)
                    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                        p_collection_name => p_collection_name,
                        p_seq             => v_seq_id,
                        p_attr_number     => 4,
                        p_attr_value      => rec.value
                    );

                    -- Update c005: original_name from template
                    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                        p_collection_name => p_collection_name,
                        p_seq             => v_seq_id,
                        p_attr_number     => 5,
                        p_attr_value      => rec.original_name
                    );

                    -- Update c006: qualifier from template
                    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                        p_collection_name => p_collection_name,
                        p_seq             => v_seq_id,
                        p_attr_number     => 6,
                        p_attr_value      => rec.qualifier
                    );

                    -- Update c007: format_mask from template (NEW for date parser integration)
                    APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                        p_collection_name => p_collection_name,
                        p_seq             => v_seq_id,
                        p_attr_number     => 7,
                        p_attr_value      => rec.format_mask
                    );

                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- No matching collection member found — ignore gracefully
                        NULL;
                    WHEN OTHERS THEN
                        p_status  := 'E';
                        p_message := 'Failed to update member attribute in collection "' || p_collection_name || '" for "'
                                     || rec.column_desc || '": ' || SQLERRM;
                        RETURN;
                END;
            END LOOP;

        EXCEPTION
            WHEN OTHERS THEN
                p_status  := 'E';
                p_message := 'Failed to update collection members from UR_TEMPLATES (ID: ' || p_template_id || '): ' || SQLERRM;
                RETURN;
        END;

    EXCEPTION
        WHEN OTHERS THEN
            p_status  := 'E';
            p_message := 'Unexpected error occurred: ' || SQLERRM;
    END LOAD_DATA_MAPPING_COLLECTION;

    --------------------------------------------------------------------------------

    PROCEDURE Load_Data(
        p_file_id         IN  NUMBER,
        p_template_key    IN  VARCHAR2,
        p_hotel_id        IN  RAW,
        p_collection_name IN  VARCHAR2,
        p_status          OUT BOOLEAN,
        p_message         OUT VARCHAR2
    ) IS
        -------------------------------------------------------------------
        -- Variables
        -------------------------------------------------------------------
        l_blob          BLOB;
        l_file_name     VARCHAR2(255);
        l_table_name    VARCHAR2(255);
        l_template_id   RAW(16);
        l_total_rows    NUMBER := 0;
        l_success_cnt   NUMBER := 0;
        l_fail_cnt      NUMBER := 0;
        l_log_id        RAW(16);
        l_error_json    CLOB := '[';
        l_apex_user     VARCHAR2(255) := NVL(v('APP_USER'), 'APEX_USER');
        l_sql           CLOB;

        -- Dynamic headers
        TYPE t_headers IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
        v_headers       t_headers;
        v_col_count     PLS_INTEGER := 0;

        -- JSON / dynamic variables
        v_profile_clob  CLOB;
        v_sql_json      CLOB;
        c               SYS_REFCURSOR;
        v_row_json      CLOB;
        v_line_number   NUMBER;

        -- Row processing
        l_cols          VARCHAR2(32767);
        l_vals          VARCHAR2(32767);
        l_set           VARCHAR2(32767);
        l_stay_col_name VARCHAR2(200);
        l_stay_val      VARCHAR2(4000);

    BEGIN
        INSERT INTO debug_log(message) VALUES ('START Load_Data - file_id=' || p_file_id);

        -------------------------------------------------------------------
        -- 0. Check for duplicate upload
        -------------------------------------------------------------------
        SELECT
            COUNT(*)
        INTO l_total_rows
        FROM
            ur_interface_logs
        WHERE
            file_id = p_file_id AND load_status = 'SUCCESS';

        IF l_total_rows > 0 THEN
            p_status  := FALSE;
            p_message := 'Failure: File is already uploaded successfully.';
            INSERT INTO debug_log(message) VALUES (p_message);
            RETURN;
        END IF;

        -------------------------------------------------------------------
        -- 1. Get blob and file name
        -------------------------------------------------------------------
        SELECT
            blob_content,
            filename
        INTO
            l_blob,
            l_file_name
        FROM
            temp_blob
        WHERE
            id = p_file_id;

        INSERT INTO debug_log(message) VALUES ('Got blob and filename: ' || NVL(l_file_name, '<null>'));

        -------------------------------------------------------------------
        -- 2. Get target table name + template id
        -------------------------------------------------------------------
        SELECT
            db_object_name,
            id
        INTO
            l_table_name,
            l_template_id
        FROM
            ur_templates
        WHERE
            upper(id) = upper(p_template_key);

        INSERT INTO debug_log(message) VALUES ('Target table: ' || l_table_name || ', template_id: ' || RAWTOHEX(l_template_id));

        -------------------------------------------------------------------
        -- 3. Get STAY_DATE column name from template definition (if any)
        -------------------------------------------------------------------
        BEGIN
            SELECT
                jt.name
            INTO l_stay_col_name
            FROM
                ur_templates t,
                JSON_TABLE(
                    t.definition,
                    '$[*]'
                    COLUMNS (
                        name      VARCHAR2(200) PATH '$.name',
                        qualifier VARCHAR2(200) PATH '$.qualifier'
                    )
                ) jt
            WHERE
                t.id = l_template_id AND UPPER(jt.qualifier) = 'STAY_DATE'
            FETCH FIRST 1 ROWS ONLY;
            INSERT INTO debug_log(message) VALUES ('Found STAY_DATE column in template: ' || l_stay_col_name);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                l_stay_col_name := NULL;
                INSERT INTO debug_log(message) VALUES ('No STAY_DATE configured in template');
        END;

        -------------------------------------------------------------------
        -- 4. Discover file profile
        -------------------------------------------------------------------
        v_profile_clob := apex_data_parser.discover(
            p_content   => l_blob,
            p_file_name => l_file_name
        );

        INSERT INTO debug_log(message) VALUES ('apex_data_parser.discover done');

        -------------------------------------------------------------------
        -- 5. Insert initial log row
        -------------------------------------------------------------------
        l_log_id := sys_guid();
        INSERT INTO ur_interface_logs (
            id, hotel_id, template_id, interface_type,
            load_start_time, load_status, created_by, updated_by,
            created_on, updated_on, file_id
        ) VALUES (
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

        INSERT INTO debug_log(message) VALUES ('Inserted ur_interface_logs id=' || RAWTOHEX(l_log_id));

        -------------------------------------------------------------------
        -- 6. Get dynamic headers from file
        -------------------------------------------------------------------
        FOR r IN (
            SELECT
                column_position,
                column_name
            FROM
                TABLE(apex_data_parser.get_columns(v_profile_clob))
            ORDER BY
                column_position
        ) LOOP
            v_headers(r.column_position) := r.column_name;
            v_col_count                  := r.column_position;
        END LOOP;

        INSERT INTO debug_log(message) VALUES ('Detected ' || v_col_count || ' columns from file.');
        IF v_col_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'No columns detected in uploaded file.');
        END IF;

        -------------------------------------------------------------------
        -- 7. Build JSON SQL
        -------------------------------------------------------------------
        v_sql_json := 'SELECT p.line_number, JSON_OBJECT(';
        FOR i IN 1..v_col_count LOOP
            IF i > 1 THEN
                v_sql_json := v_sql_json || ', ';
            END IF;
            v_sql_json := v_sql_json || '''' || REPLACE(v_headers(i), '''', '''''') || ''' VALUE NVL(p.col' || LPAD(i, 3, '0') || ', '''')';
        END LOOP;
        v_sql_json := v_sql_json || ') AS row_json FROM TABLE(apex_data_parser.parse(p_content => :1, p_file_name => :2, p_skip_rows => 1)) p';

        INSERT INTO debug_log(message) VALUES ('Built SQL for JSON parse (len=' || LENGTH(v_sql_json) || ')');

        -------------------------------------------------------------------
        -- 8. Process each row
        -------------------------------------------------------------------
        OPEN c FOR v_sql_json USING l_blob, l_file_name;
        LOOP
            FETCH c INTO v_line_number, v_row_json;
            EXIT WHEN c%NOTFOUND;

            l_total_rows := l_total_rows + 1;
            INSERT INTO debug_log(message) VALUES ('--- Processing row #' || l_total_rows || ' line=' || NVL(TO_CHAR(v_line_number), 'N/A'));

            -- Reset dynamic variables
            l_cols     := NULL;
            l_vals     := NULL;
            l_set      := NULL;
            l_stay_val := NULL;

            BEGIN
                DECLARE
                    l_elem          JSON_ELEMENT_T := JSON_ELEMENT_T.parse(v_row_json);
                    l_obj           JSON_OBJECT_T;
                    l_keys          JSON_KEY_LIST;
                    l_col           VARCHAR2(4000);
                    l_val           VARCHAR2(4000);
                    l_val_formatted VARCHAR2(4000);
                BEGIN
                    IF NOT l_elem.is_object THEN
                        RAISE_APPLICATION_ERROR(-20002, 'Row not a JSON object');
                    END IF;

                    l_obj  := TREAT(l_elem AS JSON_OBJECT_T);
                    l_keys := l_obj.get_keys;

                    FOR j IN 1..l_keys.count LOOP
                        l_col := sanitize_column_name(l_keys(j));
                        l_val := l_obj.get_string(l_keys(j));

                        -- Capture STAY_DATE value
                        IF l_stay_col_name IS NOT NULL AND l_col = UPPER(l_stay_col_name) THEN
                            l_stay_val := l_val;
                        END IF;

                        -- Format value
                        l_val_formatted := NULL;
                        IF l_val IS NOT NULL AND REGEXP_LIKE(l_val, '^-?\d+(\.\d+)?$') THEN
                            l_val_formatted := TO_CHAR(TO_NUMBER(l_val));
                        END IF;

                        IF l_val_formatted IS NULL THEN
                            l_val_formatted := '''' || REPLACE(NVL(l_val, ''), '''', '''''') || '''';
                        END IF;

                        -- Append to dynamic SQL parts
                        IF l_set IS NOT NULL THEN
                            l_set  := l_set || ', ';
                            l_cols := l_cols || ', ';
                            l_vals := l_vals || ', ';
                        END IF;

                        l_set  := NVL(l_set, '') || l_col || ' = ' || l_val_formatted;
                        l_cols := NVL(l_cols, '') || l_col;
                        l_vals := NVL(l_vals, '') || l_val_formatted;
                    END LOOP;

                    -- Always append HOTEL_ID to the set/insert
                    IF NVL(l_cols, '') <> '' THEN
                        l_cols := l_cols || ', HOTEL_ID';
                        l_vals := l_vals || ', HEXTORAW(''' || RAWTOHEX(p_hotel_id) || ''')';
                        l_set  := l_set || ', HOTEL_ID = ''' || p_hotel_id || '''';
                    END IF;

                    ----------------------------------------------------------------
                    -- UPSERT logic (update first, then insert)
                    ----------------------------------------------------------------
                    l_sql := 'UPDATE ' || l_table_name ||
                             ' SET ' || l_set ||
                             ' WHERE HOTEL_ID = HEXTORAW(''' || RAWTOHEX(p_hotel_id) || ''')';

                    -- Optional: include STAY_DATE if available
                    IF l_stay_val IS NOT NULL THEN
                        l_sql := l_sql || ' AND ' || l_stay_col_name || ' = ''' || REPLACE(l_stay_val, '''', '''''') || '''';
                    END IF;

                    -- Debug
                    INSERT INTO debug_log(message) VALUES ('UPDATE SQL: ' || SUBSTR(l_sql, 1, 2000));

                    EXECUTE IMMEDIATE l_sql;

                    IF SQL%ROWCOUNT = 0 THEN
                        -- No row updated → INSERT
                        l_cols := l_cols || ', HOTEL_ID';
                        l_vals := l_vals || ', HEXTORAW(''' || RAWTOHEX(p_hotel_id) || ''')';

                        l_sql := 'INSERT INTO ' || l_table_name || ' (' || l_cols || ') VALUES (' || l_vals || ')';
                        INSERT INTO debug_log(message) VALUES ('INSERT SQL: ' || SUBSTR(l_sql, 1, 2000));
                        EXECUTE IMMEDIATE l_sql;
                    END IF;

                    l_success_cnt := l_success_cnt + 1;

                END;
            EXCEPTION
                WHEN OTHERS THEN
                    l_fail_cnt   := l_fail_cnt + 1;
                    l_error_json := l_error_json || '{"row":' || l_total_rows || ',"error":"' || REPLACE(SQLERRM, '"', '''') || '"},';
            END;
        END LOOP;
        CLOSE c;

        -- finalize error JSON
        IF l_error_json IS NOT NULL AND l_error_json <> '[' THEN
            IF SUBSTR(l_error_json, -1) = ',' THEN
                l_error_json := SUBSTR(l_error_json, 1, LENGTH(l_error_json) - 1);
            END IF;
            l_error_json := l_error_json || ']';
        ELSE
            l_error_json := NULL;
        END IF;

        COMMIT;

        -- Update log
        UPDATE ur_interface_logs
        SET
            load_end_time   = systimestamp,
            load_status     = 'SUCCESS',
            updated_on      = sysdate,
            error_json      = l_error_json
        WHERE
            id = l_log_id;

        p_status  := TRUE;
        p_message := 'Success: Upload completed → Total=' || l_total_rows || ', Success=' || l_success_cnt || ', Failed=' || l_fail_cnt;

        INSERT INTO debug_log(message) VALUES ('Completed Load_Data - ' || p_message);

    EXCEPTION
        WHEN OTHERS THEN
            BEGIN
                UPDATE ur_interface_logs
                SET
                    load_end_time   = systimestamp,
                    load_status     = 'FAILED',
                    updated_on      = sysdate
                WHERE
                    id = l_log_id;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;

            ROLLBACK;
            p_status  := FALSE;
            p_message := 'Failure: ' || SQLERRM;
    END Load_Data;

    --------------------------------------------------------------------------------

    PROCEDURE fetch_templates(
        p_file_id           IN  NUMBER,
        p_hotel_id          IN  VARCHAR2,
        p_min_score         IN  NUMBER DEFAULT 90,
        p_debug_flag        IN  VARCHAR2 DEFAULT 'N',
        p_use_original_name IN  VARCHAR2 DEFAULT 'AUTO',
        p_match_datatype    IN  VARCHAR2 DEFAULT 'Y',
        p_output_json       OUT CLOB,
        p_status            OUT VARCHAR2,
        p_message           OUT VARCHAR2
    ) IS
        -- Local types
        TYPE t_name_type_rec IS RECORD(
            name          VARCHAR2(100),
            original_name VARCHAR2(100),
            data_type     VARCHAR2(30)
        );
        TYPE t_name_type_tab IS TABLE OF t_name_type_rec;

        TYPE t_template_rec IS RECORD(
            id         VARCHAR2(50),
            name       VARCHAR2(200),
            definition t_name_type_tab
        );
        TYPE t_template_tab IS TABLE OF t_template_rec INDEX BY PLS_INTEGER;

        -- Variables
        v_source_clob         CLOB;
        v_source_normalized   CLOB;

        v_target_id           VARCHAR2(50);
        v_target_name         VARCHAR2(200);
        v_target_def_clob     CLOB;
        v_target_normalized   CLOB;

        v_source_defs         t_name_type_tab := t_name_type_tab();
        v_target_defs         t_name_type_tab := t_name_type_tab();

        v_templates           t_template_tab;
        v_count_templates     PLS_INTEGER := 0;

        v_json_output         CLOB := '[';
        v_min_score_use       NUMBER;
        v_separator           VARCHAR2(1) := '';

        v_match_count         NUMBER;
        v_score               NUMBER;

        v_use_original_name_use VARCHAR2(10);
        v_match_datatype_use    VARCHAR2(10);

        CURSOR c_targets IS
            SELECT
                ID,
                NAME,
                DEFINITION
            FROM
                UR_TEMPLATES
            WHERE
                hotel_id = p_hotel_id
                and active = 'Y';

        -- Debug procedure
        PROCEDURE debug(p_msg VARCHAR2) IS
        BEGIN
            IF UPPER(p_debug_flag) = 'Y' THEN
                DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || p_msg);
            END IF;
        END;

        -- Normalize data-type keys in JSON string (case sensitive replacement)
        FUNCTION normalize_json(p_json CLOB) RETURN CLOB IS
        BEGIN
            RETURN REPLACE(REPLACE(p_json, '"data-type"', '"data_type"'), '"DATA-TYPE"', '"data_type"');
        END;

        -- Parse definition JSON into PL/SQL collection
        FUNCTION parse_definition(p_clob CLOB) RETURN t_name_type_tab IS
            l_defs t_name_type_tab := t_name_type_tab();
            idx    PLS_INTEGER := 0;
        BEGIN
            FOR rec IN (
                SELECT
                    lower(trim(name)) AS name,
                    lower(trim(original_name)) AS original_name,
                    lower(trim(data_type)) AS data_type
                FROM
                    JSON_TABLE(
                        p_clob,
                        '$[*]' COLUMNS (
                            name          VARCHAR2(100) PATH '$.name',
                            original_name VARCHAR2(100) PATH '$.original_name',
                            data_type     VARCHAR2(30)  PATH '$.data_type'
                        )
                    )
            ) LOOP
                idx := idx + 1;
                l_defs.EXTEND;
                l_defs(idx).name          := rec.name;
                l_defs(idx).original_name := rec.original_name;
                l_defs(idx).data_type     := rec.data_type;
            END LOOP;
            RETURN l_defs;
        EXCEPTION
            WHEN OTHERS THEN
                RETURN NULL;
        END;

        -- Count matches with configurable matching logic
        -- NOTE: Source (uploaded file) always uses 'name' field only
        --       Target (template) applies the parameter-based logic to choose between 'original_name' and 'name'
        FUNCTION count_matches(
            p_source            t_name_type_tab,
            p_target            t_name_type_tab,
            p_use_original_name VARCHAR2,
            p_match_datatype    VARCHAR2
        ) RETURN NUMBER IS
            v_count        NUMBER := 0;
            v_source_name  VARCHAR2(100);
            v_target_name  VARCHAR2(100);
            v_name_match   BOOLEAN;
            v_type_match   BOOLEAN;
        BEGIN
            FOR i IN 1..p_source.COUNT LOOP
                -- Source (uploaded file) always uses 'name' field only (no original_name expected)
                v_source_name := p_source(i).name;

                FOR j IN 1..p_target.COUNT LOOP
                    -- Determine which name to use for target (template) based on mode
                    IF UPPER(p_use_original_name) = 'Y' THEN
                        -- Use original_name only
                        v_target_name := p_target(j).original_name;
                    ELSIF UPPER(p_use_original_name) = 'N' THEN
                        -- Use name only
                        v_target_name := p_target(j).name;
                    ELSE
                        -- AUTO mode: use original_name if available and not empty, else use name
                        v_target_name := NVL(NULLIF(p_target(j).original_name, ''), p_target(j).name);
                    END IF;

                    -- Check name match
                    v_name_match := (v_source_name = v_target_name);

                    -- Check data type match if enabled
                    IF UPPER(p_match_datatype) = 'Y' THEN
                        v_type_match := (p_source(i).data_type = p_target(j).data_type);
                    ELSE
                        -- If data type matching is disabled, consider it always matched
                        v_type_match := TRUE;
                    END IF;

                    -- Count as match if both conditions are met
                    IF v_name_match AND v_type_match THEN
                        v_count := v_count + 1;
                        EXIT;
                    END IF;
                END LOOP;
            END LOOP;
            RETURN v_count;
        END;

    BEGIN
        -- Validate inputs and assign to local variable
        v_min_score_use := NVL(p_min_score, 90);
        IF v_min_score_use < 0 OR v_min_score_use > 100 THEN
            v_min_score_use := 90;
        END IF;

        -- Validate and normalize p_use_original_name parameter
        v_use_original_name_use := UPPER(NVL(p_use_original_name, 'AUTO'));
        IF v_use_original_name_use NOT IN ('Y', 'N', 'AUTO') THEN
            v_use_original_name_use := 'AUTO';
        END IF;

        -- Validate and normalize p_match_datatype parameter
        v_match_datatype_use := UPPER(NVL(p_match_datatype, 'Y'));
        IF v_match_datatype_use NOT IN ('Y', 'N') THEN
            v_match_datatype_use := 'Y';
        END IF;

        IF p_file_id IS NULL THEN
            p_status      := 'E';
            p_message     := 'File ID must be provided';
            p_output_json := NULL;
            RETURN;
        END IF;

        IF p_hotel_id IS NULL THEN
            p_status      := 'E';
            p_message     := 'Hotel ID must be provided';
            p_output_json := NULL;
            RETURN;
        END IF;

        debug('Starting processing...');
        debug('File ID: ' || p_file_id);
        debug('Hotel ID: ' || p_hotel_id);
        debug('Minimum Score: ' || v_min_score_use);
        debug('Use Original Name: ' || v_use_original_name_use);
        debug('Match Data Type: ' || v_match_datatype_use);

        -- Fetch and normalize source CLOB
        BEGIN
            SELECT columns INTO v_source_clob FROM temp_blob WHERE id = p_file_id;
            IF v_source_clob IS NULL THEN
                p_status      := 'E';
                p_message     := 'Source definition not found for file_id ' || p_file_id;
                p_output_json := NULL;
                RETURN;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_status      := 'E';
                p_message     := 'Source file not found for id ' || p_file_id;
                p_output_json := NULL;
                RETURN;
            WHEN OTHERS THEN
                p_status      := 'E';
                p_message     := 'Error fetching source definition: ' || SQLERRM;
                p_output_json := NULL;
                RETURN;
        END;

        v_source_normalized := normalize_json(v_source_clob);

        -- Parse source defs
        v_source_defs := parse_definition(v_source_normalized);
        IF v_source_defs IS NULL OR v_source_defs.COUNT = 0 THEN
            p_status      := 'E';
            p_message     := 'Cannot parse source definition JSON or empty definition';
            p_output_json := NULL;
            RETURN;
        END IF;
        debug('Parsed Source definitions: ' || v_source_defs.COUNT || ' fields');

        -- Initialize JSON output
        v_json_output     := '[';
        v_count_templates := 0;

        -- Loop over target templates from cursor
        FOR r_target IN c_targets LOOP
            v_target_id       := r_target.ID;
            v_target_name     := r_target.NAME;
            v_target_def_clob := r_target.DEFINITION;

            IF v_target_def_clob IS NULL THEN
                debug('Skipping template ' || v_target_id || ' due to NULL definition');
                CONTINUE;
            END IF;

            v_target_normalized := normalize_json(v_target_def_clob);

            v_target_defs := parse_definition(v_target_normalized);
            IF v_target_defs IS NULL OR v_target_defs.COUNT = 0 THEN
                debug('Skipping template ' || v_target_id || ' due to parsing error or empty definition');
                CONTINUE;
            END IF;

            v_match_count := count_matches(v_source_defs, v_target_defs, v_use_original_name_use, v_match_datatype_use);

            v_score := ROUND((2 * v_match_count) / (v_source_defs.COUNT + v_target_defs.COUNT) * 100);

            debug(
                'Template ' || v_target_id || ' (' || v_target_name || '): Matches=' ||
                v_match_count || ', Score=' || v_score
            );

            IF v_score >= v_min_score_use THEN
                IF v_count_templates > 0 THEN
                    v_json_output := v_json_output || ',';
                END IF;
                v_json_output     := v_json_output || '{"Template_id":"' || v_target_id ||
                                     '","Template_Name":"' || REPLACE(v_target_name, '"', '\"') ||
                                     '","Score":' || v_score || '}';
                v_count_templates := v_count_templates + 1;
            END IF;
        END LOOP;

        v_json_output := v_json_output || ']';

        IF v_count_templates = 0 THEN
            p_output_json := '[{}]';
            p_message     := 'No templates matched the minimum score threshold';
            debug('No matching templates found.');
        ELSE
            p_output_json := v_json_output;
            p_message     := 'Templates matched: ' || v_count_templates;
            debug('Matching templates count: ' || v_count_templates);
        END IF;

        p_status := 'S';

    EXCEPTION
        WHEN OTHERS THEN
            p_status      := 'E';
            p_message     := 'Unexpected error: ' || SQLERRM;
            p_output_json := NULL;
    END fetch_templates;

    --------------------------------------------------------------------------------

    PROCEDURE DELETE_TEMPLATES(
        p_id           IN  VARCHAR2 DEFAULT NULL,
        p_hotel_id     IN  VARCHAR2 DEFAULT NULL,
        p_key          IN  VARCHAR2 DEFAULT NULL,
        p_name         IN  VARCHAR2 DEFAULT NULL,
        p_type         IN  VARCHAR2 DEFAULT NULL,
        p_active       IN  CHAR     DEFAULT NULL,
        p_db_obj_empty IN  CHAR     DEFAULT NULL,
        p_delete_all   IN  CHAR     DEFAULT 'N',
        p_debug        IN  CHAR     DEFAULT 'N',
        p_json_output  OUT CLOB
    ) AS
        v_sql          VARCHAR2(1000);
        v_rows_count   NUMBER;
        v_status       CHAR(1);
        v_message      VARCHAR2(4000);
        v_json_list    CLOB := '[';
        v_first        BOOLEAN := TRUE;

        CURSOR c_templates IS
            SELECT
                id,
                hotel_id,
                key,
                name,
                type,
                active,
                db_object_name
            FROM
                ur_templates
            WHERE
                (p_delete_all = 'Y' OR (p_id IS NULL OR id = p_id)) AND (p_delete_all = 'Y' OR (p_hotel_id IS NULL OR hotel_id = p_hotel_id)) AND (p_delete_all = 'Y' OR (p_key IS NULL OR key = p_key)) AND (p_delete_all = 'Y' OR (p_name IS NULL OR name = p_name)) AND (p_delete_all = 'Y' OR (p_type IS NULL OR type = p_type)) AND (p_delete_all = 'Y' OR (p_active IS NULL OR active = p_active));

        -- Helper to escape JSON strings (basic)
        FUNCTION json_escape(str IN VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            RETURN REPLACE(REPLACE(REPLACE(REPLACE(str, '\', '\\'), '"', '\"'), CHR(10), '\n'), CHR(13), '');
        EXCEPTION
            WHEN OTHERS THEN
                RETURN '';
        END;

        PROCEDURE dbg(p_msg VARCHAR2) IS
        BEGIN
            IF p_debug = 'Y' THEN
                apex_debug.message(p_msg);
            END IF;
        END;

        PROCEDURE append_result(
            p_id          IN VARCHAR2,
            p_hotel_id    IN VARCHAR2,
            p_key         IN VARCHAR2,
            p_name        IN VARCHAR2,
            p_type        IN VARCHAR2,
            p_active      IN CHAR,
            p_db_obj_name IN VARCHAR2,
            p_status      IN CHAR,
            p_message     IN VARCHAR2
        ) IS
        BEGIN
            IF v_first THEN
                v_first := FALSE;
            ELSE
                v_json_list := v_json_list || ',';
            END IF;

            v_json_list := v_json_list || '{' ||
                           '"id":"' || json_escape(p_id) || '",' ||
                           '"hotel_id":"' || json_escape(p_hotel_id) || '",' ||
                           '"key":"' || json_escape(p_key) || '",' ||
                           '"name":"' || json_escape(p_name) || '",' ||
                           '"type":"' || json_escape(p_type) || '",' ||
                           '"active":"' || json_escape(p_active) || '",' ||
                           '"db_object_name":"' || json_escape(p_db_obj_name) || '",' ||
                           '"status":"' || json_escape(p_status) || '",' ||
                           '"message":"' || json_escape(p_message) || '"' ||
                           '}';
        END;

    BEGIN
        dbg('Started DELETE_TEMPLATES_AND_DB_OBJECTS_JSON procedure.');

        FOR rec IN c_templates LOOP
            dbg('Processing template ID=' || rec.id || ', DB_OBJECT_NAME=' || rec.db_object_name);

            IF rec.db_object_name IS NULL THEN
                v_status  := 'E';
                v_message := 'No DB_OBJECT_NAME specified for template, skipping.';
                dbg(v_message);
                append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, NULL, v_status, v_message);
                CONTINUE;
            END IF;

            -- Check if table should be empty before deleting
            IF p_db_obj_empty = 'Y' THEN
                v_sql := 'SELECT COUNT(*) FROM ' || rec.db_object_name;
                BEGIN
                    EXECUTE IMMEDIATE v_sql INTO v_rows_count;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_rows_count := -1; -- can't count, treat as error or non-empty
                END;

                IF v_rows_count > 0 THEN
                    v_status  := 'E';
                    v_message := 'DB Object table [' || rec.db_object_name || '] is not empty (ROWS=' || v_rows_count || '), skipping deletion.';
                    dbg(v_message);
                    append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);
                    CONTINUE;
                END IF;
                dbg('DB Object table [' || rec.db_object_name || '] is empty, proceeding.');
            END IF;

            -- Try to drop the table and delete template
            BEGIN
                v_sql := 'DROP TABLE ' || rec.db_object_name || ' CASCADE CONSTRAINTS';
                dbg('Executing: ' || v_sql);
                EXECUTE IMMEDIATE v_sql;

                dbg('Dropped table ' || rec.db_object_name);

                DELETE FROM ur_templates WHERE id = rec.id;

                dbg('Deleted template id=' || rec.id);

                v_status  := 'S';
                v_message := 'Successfully dropped table and deleted template.';
                append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);

            EXCEPTION
                WHEN OTHERS THEN
                    v_status  := 'E';
                    v_message := 'Error dropping table or deleting template: ' || SQLERRM;
                    dbg(v_message);
                    append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);
            END;
        END LOOP;

        v_json_list   := v_json_list || ']';
        p_json_output := v_json_list;

        dbg('Completed DELETE_TEMPLATES_AND_DB_OBJECTS_JSON procedure.');
    END DELETE_TEMPLATES;

    --------------------------------------------------------------------------------

   PROCEDURE manage_algo_attributes(
        p_template_key   IN  VARCHAR2,
        p_mode           IN  CHAR,
        p_attribute_key  IN  VARCHAR2 DEFAULT NULL,
        p_status         OUT BOOLEAN,
        p_message        OUT VARCHAR2
    ) IS
      -- Original Variables
      v_db_object_name UR_TEMPLATES.DB_OBJECT_NAME%TYPE;
      v_definition     UR_TEMPLATES.DEFINITION%TYPE;
      v_hotel_id       UR_TEMPLATES.HOTEL_ID%TYPE;
      v_user_id        RAW(16);
      v_insert_count   NUMBER := 0;
      v_delete_count   NUMBER := 0;
      v_template_id    RAW(16);
      v_attr_qualifier VARCHAR2(4000) := NULL;

      -- New Variables for RST logic
      v_template_type        UR_TEMPLATES.TYPE%TYPE;
      v_db_view_object_name  UR_TEMPLATES.DB_VIEW_OBJECT_NAME%TYPE;
      v_own_property_count   NUMBER := 0;
      v_comp_property_count  NUMBER := 0;
      v_object_exists        NUMBER := 0;
      v_column_exists        NUMBER := 0;

      -- Local helper procedure updated to accept qualifier name
        PROCEDURE create_rst_attribute (
          p_attr_name       IN VARCHAR2,
          p_attr_key        IN VARCHAR2,
          p_attr_val        IN VARCHAR2,
          p_qualifier_name  IN VARCHAR2,
          p_data_type       IN VARCHAR2 DEFAULT 'NUMBER'
      ) IS
          v_exists NUMBER;
      BEGIN
          SELECT COUNT(*) INTO v_exists FROM ur_algo_attributes WHERE key = p_attr_key;
          IF v_exists = 0 THEN
              INSERT INTO ur_algo_attributes (
                  id, algo_id, hotel_id, name, key, data_type, description, type, value, template_id, attribute_qualifier,
                  created_by, updated_by, created_on, updated_on
              ) VALUES (
                  SYS_GUID(), NULL, v_hotel_id, p_attr_name, p_attr_key, p_data_type,
                  NULL,
                  'S', 
                  '#' || p_attr_val || '#', -- Value wrapped in #
                  v_template_id,
                  p_qualifier_name,
                  v_user_id, v_user_id, SYSDATE, SYSDATE
              );
              v_insert_count := v_insert_count + 1;
          END IF;
      END create_rst_attribute;

    BEGIN
      -- Initialization
      p_status := FALSE;
      p_message := NULL;

      -- Obtain needed data from UR_TEMPLATES
      BEGIN
        SELECT db_object_name, definition, hotel_id, id, type, db_view_object_name
        INTO v_db_object_name, v_definition, v_hotel_id, v_template_id, v_template_type, v_db_view_object_name
        FROM ur_templates
        WHERE key = p_template_key;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_message := 'Failure: Template key not found: ' || p_template_key;
          RETURN;
      END;

      IF v_db_object_name IS NULL THEN
        p_message := 'Failure: DB_OBJECT_NAME not defined for template_key ' || p_template_key;
        RETURN;
      END IF;

      -- Get USER_ID once for audit columns
      BEGIN
        SELECT USER_ID INTO v_user_id
        FROM UR_USERS
        WHERE USER_NAME = SYS_CONTEXT('APEX$SESSION', 'APP_USER');
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_user_id := NULL;
      END;

      IF p_mode = 'C' THEN
        IF v_definition IS NULL THEN
          p_message := 'Failure: Definition JSON is NULL for template_key ' || p_template_key;
          RETURN;
        END IF;

        -- ====================================================================================
        -- START: LOGIC FOR RST TEMPLATES
        -- ====================================================================================
        IF v_template_type = 'RST' THEN
          -- Count OWN_PROPERTY and COMP_PROPERTY qualifiers
          SELECT
            COUNT(CASE WHEN UPPER(jt.qualifier) = 'OWN_PROPERTY' THEN 1 END),
            COUNT(CASE WHEN UPPER(jt.qualifier) = 'COMP_PROPERTY' THEN 1 END)
          INTO v_own_property_count, v_comp_property_count
          FROM JSON_TABLE(v_definition, '$[*]' COLUMNS (qualifier VARCHAR2(30) PATH '$.qualifier')) jt;

          -- Check if the special qualifiers exist to trigger the RST logic
          IF v_own_property_count > 0 AND v_comp_property_count > 0 THEN
            -- 1. Validate DB_VIEW_OBJECT_NAME
            IF v_db_view_object_name IS NULL THEN
              p_message := 'Failure: DB_VIEW_OBJECT_NAME is not defined for RST template ' || p_template_key;
              RETURN;
            END IF;

            -- 2. Validate the view/object exists
            BEGIN
              SELECT 1 INTO v_object_exists FROM user_objects
              WHERE object_name = UPPER(v_db_view_object_name) AND object_type IN ('VIEW', 'TABLE', 'SYNONYM');
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                v_object_exists := 0;
            END;

            IF v_object_exists = 0 THEN
              p_message := 'Failure: The specified DB_VIEW_OBJECT_NAME ''' || v_db_view_object_name || ''' does not exist.';
              RETURN;
            END IF;

            -- 3. Validate and create attributes for OWN_PROPERTY and VALID_COMP_COUNT
            FOR r_col IN (
                SELECT 'OWN_PROPERTY_RANK' AS col_name FROM DUAL
                UNION ALL
                SELECT 'OWN_PROPERTY_RATE' AS col_name FROM DUAL
                UNION ALL
                SELECT 'VALID_COMP_COUNT' AS col_name FROM DUAL
            ) LOOP
                SELECT COUNT(*) INTO v_column_exists FROM user_tab_columns
                WHERE table_name = UPPER(v_db_view_object_name) AND column_name = r_col.col_name;

                IF v_column_exists = 0 THEN
                    p_message := 'Failure: Required column ' || r_col.col_name || ' not found in view ' || v_db_view_object_name;
                    RETURN;
                END IF;
            END LOOP;

            create_rst_attribute('OWN PROPERTY RANK', v_db_view_object_name || '.OWN_PROPERTY_RANK', v_db_view_object_name || '.OWN_PROPERTY_RANK', 'OWN_PROPERTY');
            create_rst_attribute('OWN PROPERTY RATE', v_db_view_object_name || '.OWN_PROPERTY_RATE', v_db_view_object_name || '.OWN_PROPERTY_RATE', 'OWN_PROPERTY');
            -- Create VALID_COMP_COUNT attribute for rank shifting logic in evaluation engine
            create_rst_attribute('VALID COMP COUNT', v_db_view_object_name || '.VALID_COMP_COUNT', v_db_view_object_name || '.VALID_COMP_COUNT', 'COMP_PROPERTY');
            
            -- 4. Create attributes for COMP_PROPERTY (RANK_1 to RANK_N where N = number of COMP_PROPERTY columns)
            FOR i IN 1 .. v_comp_property_count LOOP
              DECLARE
                l_col_name   VARCHAR2(100) := 'RANK_' || i || '_RATE';
                l_attr_name  VARCHAR2(100) := 'COMP SET R' || i || ' RATE';
                l_attr_key   VARCHAR2(200) := v_db_view_object_name || '.' || l_col_name;
              BEGIN
                -- Validate that the required rank column exists
                SELECT COUNT(*) INTO v_column_exists FROM user_tab_columns
                WHERE table_name = UPPER(v_db_view_object_name) AND column_name = l_col_name;

                IF v_column_exists = 0 THEN
                  p_message := 'Failure: Required column ' || l_col_name || ' not found in view ' || v_db_view_object_name || '.';
                  ROLLBACK;
                  RETURN;
                END IF;
                
                -- Create the attribute using the helper
                create_rst_attribute(l_attr_name, l_attr_key, l_attr_key, 'COMP_PROPERTY');
              END;
            END LOOP;
          END IF;
        END IF;

        -- ====================================================================================
        -- STANDARD ATTRIBUTE CREATION FOR ALL TEMPLATES (RST AND NON-RST)
        -- ====================================================================================
        -- For RST: Creates standard attributes for all qualifiers including OWN_PROPERTY and COMP_PROPERTY
        -- For Non-RST: Creates standard attributes for all qualifiers
        FOR rec IN (
            SELECT jt.name, jt.data_type, jt.qualifier
            FROM JSON_TABLE(
              v_definition, '$[*]' COLUMNS (
                name      VARCHAR2(100) PATH '$.name',
                data_type VARCHAR2(30)  PATH '$.data_type',
                qualifier VARCHAR2(30)  PATH '$.qualifier'
              )
            ) jt
            WHERE jt.qualifier IS NOT NULL
              AND UPPER(jt.qualifier) <> 'UNIQUE'
          )
          LOOP
            DECLARE
              l_col_name VARCHAR2(150) := UPPER(REGEXP_REPLACE(TRIM(rec.name), '_+$', ''));
              v_key      VARCHAR2(150) := v_db_object_name || '.' || l_col_name;
              v_exists   NUMBER;
            BEGIN
              SELECT COUNT(*) INTO v_exists FROM ur_algo_attributes WHERE key = v_key;
              IF v_exists = 0 THEN
                INSERT INTO ur_algo_attributes (
                  id, algo_id, hotel_id, name, key, data_type, description, type, value, template_id, attribute_qualifier,
                  created_by, updated_by, created_on, updated_on
                ) VALUES (
                  SYS_GUID(), NULL, v_hotel_id, l_col_name, v_key, NVL(UPPER(rec.data_type), 'NUMBER'),
                  NULL, 'S', 
                  '#' || v_key || '#', -- Value wrapped in #
                  v_template_id, rec.qualifier,
                  v_user_id, v_user_id, SYSDATE, SYSDATE
                );
                v_insert_count := v_insert_count + 1;
              END IF;
            END;
          END LOOP;

        COMMIT;
        p_status := TRUE;
        p_message := 'Success: ' || v_insert_count || ' attribute'
                   || CASE WHEN v_insert_count = 1 THEN '' ELSE 's' END
                   || ' inserted for template_key ' || p_template_key;

      ELSIF p_mode = 'D' THEN
        -- Delete logic remains unchanged
        IF p_attribute_key IS NOT NULL THEN
          IF p_attribute_key LIKE v_db_object_name || '.%' OR p_attribute_key LIKE v_db_view_object_name || '.%' THEN
            DELETE FROM ur_algo_attributes WHERE key = p_attribute_key;
            v_delete_count := SQL%ROWCOUNT;
            COMMIT;
            p_status := TRUE;
            IF v_delete_count > 0 THEN
              p_message := 'Success: ' || v_delete_count || ' attribute deleted with key ' || p_attribute_key;
            ELSE
              p_message := 'Info: No attribute found to delete with key ' || p_attribute_key;
            END IF;
          ELSE
            p_status := FALSE;
            p_message := 'Failure: Attribute key does not belong to template ' || p_template_key;
          END IF;
        ELSE
          DELETE FROM ur_algo_attributes WHERE template_id = v_template_id; -- Safer delete by template_id
          v_delete_count := SQL%ROWCOUNT;
          COMMIT;
          p_status := TRUE;
          p_message := 'Success: ' || v_delete_count || ' attribute'
                       || CASE WHEN v_delete_count = 1 THEN '' ELSE 's' END
                       || ' deleted for template_key ' || p_template_key;
        END IF;

       ELSIF p_mode = 'U' THEN
        p_status := TRUE;
        p_message := 'Update Implemented successfully';
 

      ELSE
        p_status := FALSE;
        p_message := 'Invalid mode: ' || p_mode || '. Valid modes are C, U, D.';
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        ROLLBACK;
        p_status := FALSE;
        p_message := 'Failure: ' || SQLERRM;
    END manage_algo_attributes;

    --------------------------------------------------------------------------------

    PROCEDURE add_alert(
        p_existing_json IN  CLOB,
        p_message       IN  VARCHAR2,
        p_icon          IN  VARCHAR2 DEFAULT NULL,
        p_title         IN  VARCHAR2 DEFAULT NULL,
        p_timeout       IN  NUMBER   DEFAULT NULL,
        p_updated_json  OUT CLOB
    ) IS
        l_json_array json_array_t;
        l_new_object json_object_t;
    BEGIN
        -- Create the new JSON object
        l_new_object := new json_object_t();
        l_new_object.put('message', p_message);
        l_new_object.put('icon', nvl(p_icon, 'success'));
        l_new_object.put('title', nvl(p_title, ''));

        IF p_timeout IS NOT NULL THEN
            l_new_object.put('timeOut', to_char(p_timeout));
        END IF;

        -- Append the new object to the existing array or create a new array
        IF p_existing_json IS NULL OR trim(p_existing_json) = '' THEN
            -- Create a new array with the new object
            l_json_array := new json_array_t();
        ELSE
            -- Parse the existing JSON string into a JSON array
            l_json_array := json_array_t(p_existing_json);
        END IF;

        -- Append the new object
        l_json_array.append(l_new_object);

        -- Convert the JSON array back to a CLOB
        p_updated_json := l_json_array.to_clob;
    END add_alert;

    --------------------------------------------------------------------------------

    PROCEDURE validate_expression(
        p_expression IN  VARCHAR2,
        p_mode       IN  CHAR,
        p_hotel_id   IN  VARCHAR2,
        p_status     OUT VARCHAR2, -- 'S' or 'E'
        p_message    OUT VARCHAR2
    ) IS
        TYPE t_str_list IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
        v_attributes         t_str_list;
        v_functions          t_str_list;
        v_operators          t_str_list;
        v_attr_count         NUMBER := 0;
        v_func_count         NUMBER := 0;
        v_oper_count         NUMBER := 0;

        TYPE t_token_rec IS RECORD(
            token     VARCHAR2(4000),
            start_pos PLS_INTEGER,
            end_pos   PLS_INTEGER
        );
        TYPE t_token_tab IS TABLE OF t_token_rec INDEX BY PLS_INTEGER;
        v_tokens             t_token_tab;
        v_token_count        PLS_INTEGER := 0;

        TYPE t_token_tab_nt IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
        v_unmatched_tokens   t_token_tab;
        v_unmatched_count    PLS_INTEGER := 0;

        -- To mark tokens consumed by multi-word operators
        TYPE t_bool_tab IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;
        v_token_consumed     t_bool_tab;

        v_mode               CHAR := UPPER(p_mode);

        -- Trim and uppercase token helper
        FUNCTION normalize_token(p_token VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            RETURN UPPER(TRIM(p_token));
        END;

        -- Strip function parameters, e.g. "ROUND (n,d)" -> "ROUND"
        FUNCTION normalize_func_name(p_func VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            RETURN REGEXP_REPLACE(UPPER(TRIM(p_func)), '\s*\(.*\)$');
        END;

        -- Checks if token is numeric
        FUNCTION is_number(p_token VARCHAR2) RETURN BOOLEAN IS
        BEGIN
            RETURN REGEXP_LIKE(p_token, '^[+-]?(\d+(\.\d*)?|\.\d+)([Ee][+-]?\d+)?$');
        END;

        -- Check presence in list
        FUNCTION is_in_list(
            p_token VARCHAR2,
            p_list  t_str_list,
            cnt     NUMBER
        ) RETURN BOOLEAN IS
        BEGIN
            FOR i IN 1..cnt LOOP
                IF p_list(i) = p_token THEN
                    RETURN TRUE;
                END IF;
            END LOOP;
            RETURN FALSE;
        END;

        -- Check if token valid: attribute, operator, function, number, parentheses
        FUNCTION is_token_valid(p_token VARCHAR2) RETURN BOOLEAN IS
            l_token VARCHAR2(100) := p_token;
        BEGIN
            -- Parentheses always valid tokens
            IF l_token IN ('(', ')') THEN
                RETURN TRUE;
            END IF;

            -- Strip trailing '(' from function calls
            IF SUBSTR(l_token, -1) = '(' THEN
                l_token := SUBSTR(l_token, 1, LENGTH(l_token) - 1);
            END IF;

            -- Check if number
            IF is_number(l_token) THEN
                RETURN TRUE;
            END IF;

            l_token := normalize_token(l_token);

            IF is_in_list(l_token, v_attributes, v_attr_count) THEN
                RETURN TRUE;
            ELSIF is_in_list(l_token, v_functions, v_func_count) THEN
                RETURN TRUE;
            ELSIF is_in_list(l_token, v_operators, v_oper_count) THEN
                RETURN TRUE;
            END IF;

            RETURN FALSE;
        END;

        PROCEDURE load_functions(
            p_list  OUT t_str_list,
            p_count OUT NUMBER
        ) IS
        BEGIN
            p_list.DELETE;
            p_count := 0;
            FOR r IN (
                SELECT
                    return_value
                FROM
                    apex_application_lov_entries
                WHERE
                    list_of_values_name = 'UR EXPRESSION FUNCTIONS'
                ORDER BY
                    return_value
            ) LOOP
                p_count        := p_count + 1;
                p_list(p_count) := normalize_func_name(r.return_value);
            END LOOP;
            IF p_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20010, 'Functions LOV missing or empty');
            END IF;
        END;

        PROCEDURE load_operators(
            p_list  OUT t_str_list,
            p_count OUT NUMBER
        ) IS
        BEGIN
            p_list.DELETE;
            p_count := 0;
            FOR r IN (
                SELECT
                    return_value
                FROM
                    apex_application_lov_entries
                WHERE
                    list_of_values_name = 'UR EXPRESSION OPERATORS'
                ORDER BY
                    return_value
            ) LOOP
                p_count        := p_count + 1;
                p_list(p_count) := UPPER(TRIM(r.return_value));
            END LOOP;
            IF p_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20011, 'Operators LOV missing or empty');
            END IF;
        END;

        PROCEDURE load_attributes(
            p_hotel_id IN  VARCHAR2,
            p_list     OUT t_str_list,
            p_count    OUT NUMBER
        ) IS
        BEGIN
            p_list.DELETE;
            p_count := 0;
            FOR r IN (
                SELECT
                    key
                FROM
                    ur_algo_attributes
                WHERE
                    hotel_id = p_hotel_id
            ) LOOP
                p_count        := p_count + 1;
                p_list(p_count) := UPPER(TRIM(r.key));
            END LOOP;
            IF p_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20012, 'Attributes missing for hotel_id ' || p_hotel_id);
            END IF;
        END;

        -- Tokenizer splitting expression into tokens, tracking start/end pos
        PROCEDURE tokenize_expression(
            p_expr  IN  VARCHAR2,
            p_tokens OUT t_token_tab,
            p_count OUT NUMBER
        ) IS
            l_pos         PLS_INTEGER := 1;
            l_len         PLS_INTEGER := LENGTH(p_expr);
            l_token       VARCHAR2(4000);
            l_token_start PLS_INTEGER;
            l_token_end   PLS_INTEGER;
        BEGIN
            p_tokens.DELETE;
            p_count := 0;
            WHILE l_pos <= l_len LOOP
                l_token := REGEXP_SUBSTR(
                    p_expr,
                    '([A-Za-z0-9_\.]+|\d+(\.\d+)?|\(|\)|\S)',
                    l_pos,
                    1,
                    'i'
                );
                EXIT WHEN l_token IS NULL;
                l_token_start := INSTR(p_expr, l_token, l_pos);
                l_token_end   := l_token_start + LENGTH(l_token) - 1;
                p_count       := p_count + 1;
                p_tokens(p_count) := t_token_rec(token => l_token, start_pos => l_token_start, end_pos => l_token_end);
                l_pos         := l_token_end + 1;
                WHILE l_pos <= l_len AND SUBSTR(p_expr, l_pos, 1) = ' ' LOOP
                    l_pos := l_pos + 1;
                END LOOP;
            END LOOP;
        END;

        FUNCTION build_json_errors(
            p_unmatched t_token_tab,
            p_count     PLS_INTEGER
        ) RETURN VARCHAR2 IS
            v_json VARCHAR2(4000) := '[';
        BEGIN
            IF p_count = 0 THEN
                RETURN '[]';
            END IF;
            FOR i IN 1..p_count LOOP
                v_json := v_json || '{"token":"' || p_unmatched(i).token ||
                          '","start":' || p_unmatched(i).start_pos ||
                          ',"end":' || p_unmatched(i).end_pos || '}';
                IF i < p_count THEN
                    v_json := v_json || ',';
                END IF;
            END LOOP;
            v_json := v_json || ']';
            RETURN v_json;
        END;

        -- Return number of consecutive tokens matched as an operator starting at start_idx
        FUNCTION get_longest_operator_match(start_idx IN PLS_INTEGER) RETURN PLS_INTEGER IS
            combined      VARCHAR2(4000);
            max_words     CONSTANT PLS_INTEGER := 4; -- max operator words count
            words_count   PLS_INTEGER;
            l_len         PLS_INTEGER := LEAST(max_words, v_token_count - start_idx + 1);
            i             PLS_INTEGER;
        BEGIN
            FOR words_count IN REVERSE 1..l_len LOOP
                combined := '';
                FOR i IN start_idx..start_idx + words_count - 1 LOOP
                    IF combined IS NULL OR combined = '' THEN
                        combined := UPPER(TRIM(v_tokens(i).token));
                    ELSE
                        combined := combined || ' ' || UPPER(TRIM(v_tokens(i).token));
                    END IF;
                END LOOP;
                IF is_in_list(combined, v_operators, v_oper_count) THEN
                    RETURN words_count;
                END IF;
            END LOOP;
            RETURN 0;
        END;

    BEGIN
        p_status  := 'E';
        p_message := NULL;

        IF v_mode NOT IN ('V', 'C') THEN
            p_status  := 'E';
            p_message := 'Invalid mode "' || p_mode || '". Valid are V or C.';
            RETURN;
        END IF;

        IF p_hotel_id IS NULL THEN
            p_status  := 'E';
            p_message := 'hotel_id is mandatory';
            RETURN;
        END IF;

        IF p_expression IS NULL OR LENGTH(TRIM(p_expression)) = 0 THEN
            p_status  := 'E';
            p_message := 'Expression is empty';
            RETURN;
        END IF;

        load_functions(v_functions, v_func_count);
        load_operators(v_operators, v_oper_count);
        load_attributes(p_hotel_id, v_attributes, v_attr_count);

        tokenize_expression(p_expression, v_tokens, v_token_count);

        -- Initialize consumed array
        v_token_consumed.DELETE;

        DECLARE
            i             PLS_INTEGER := 1;
            words_matched PLS_INTEGER := 0;
        BEGIN
            WHILE i <= v_token_count LOOP
                words_matched := get_longest_operator_match(i);
                IF words_matched > 0 THEN
                    FOR j IN i..i + words_matched - 1 LOOP
                        v_token_consumed(j) := TRUE;
                    END LOOP;
                    i := i + words_matched;
                ELSE
                    -- Single token valid check
                    v_token_consumed(i) := is_token_valid(normalize_token(v_tokens(i).token));
                    i                   := i + 1;
                END IF;
            END LOOP;
        END;

        IF v_mode = 'V' THEN
            v_unmatched_tokens.DELETE;
            v_unmatched_count := 0;
            FOR i IN 1..v_token_count LOOP
                IF v_token_consumed.EXISTS(i) AND v_token_consumed(i) = FALSE THEN
                    v_unmatched_count                       := v_unmatched_count + 1;
                    v_unmatched_tokens(v_unmatched_count) := v_tokens(i);
                END IF;
            END LOOP;

            IF v_unmatched_count > 0 THEN
                p_status  := 'E';
                p_message := 'Invalid tokens: ' || build_json_errors(v_unmatched_tokens, v_unmatched_count);
            ELSE
                p_status  := 'S';
                p_message := 'Expression validated successfully.';
            END IF;

        ELSIF v_mode = 'C' THEN
            p_status  := 'S';
            p_message := '';
            FOR i IN 1..v_token_count LOOP
                IF v_token_consumed.EXISTS(i) AND v_token_consumed(i) = TRUE THEN
                    p_message := p_message || v_tokens(i).token || ' ';
                END IF;
            END LOOP;
            p_message := RTRIM(p_message);
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_status  := 'E';
            p_message := 'Failure: ' || SQLERRM;
    END validate_expression;


-- ============================================================================
-- DATE PARSER: Comprehensive date format detection and parsing
-- ============================================================================
-- Migrated from UR_DATE_PARSER_TEST package with enhancements for:
--   - Debug logging
--   - Alert compliance
--   - Mode-based operation (DETECT, PARSE, TEST)
--   - Integration with P1002 (Template Creation) and P1010 (Data Loading)
-- ============================================================================

-- Simple format detection wrapper (returns format mask only)
FUNCTION detect_date_format_simple(
    p_sample_values IN CLOB
) RETURN VARCHAR2 DETERMINISTIC IS
    v_alert_clob     CLOB;
    v_format_mask    VARCHAR2(100);
    v_confidence     NUMBER;
    v_converted_date DATE;
    v_has_year       VARCHAR2(1);
    v_is_ambiguous   VARCHAR2(1);
    v_special_values VARCHAR2(500);
    v_all_formats    CLOB;
    v_status         VARCHAR2(1);
    v_message        VARCHAR2(4000);
BEGIN
    date_parser(
        p_mode            => 'DETECT',
        p_sample_values   => p_sample_values,
        p_debug_flag      => 'N',
        p_alert_clob      => v_alert_clob,
        p_format_mask_out => v_format_mask,
        p_confidence      => v_confidence,
        p_converted_date  => v_converted_date,
        p_has_year        => v_has_year,
        p_is_ambiguous    => v_is_ambiguous,
        p_special_values  => v_special_values,
        p_all_formats     => v_all_formats,
        p_status          => v_status,
        p_message         => v_message
    );
    RETURN v_format_mask;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END detect_date_format_simple;

-- Safe date parsing wrapper (returns NULL on failure)
FUNCTION parse_date_safe(
    p_value       IN VARCHAR2,
    p_format_mask IN VARCHAR2,
    p_start_date  IN DATE DEFAULT NULL
) RETURN DATE DETERMINISTIC IS
    v_alert_clob     CLOB;
    v_format_mask    VARCHAR2(100);
    v_confidence     NUMBER;
    v_converted_date DATE;
    v_has_year       VARCHAR2(1);
    v_is_ambiguous   VARCHAR2(1);
    v_special_values VARCHAR2(500);
    v_all_formats    CLOB;
    v_status         VARCHAR2(1);
    v_message        VARCHAR2(4000);
BEGIN
    date_parser(
        p_mode            => 'PARSE',
        p_date_string     => p_value,
        p_format_mask     => p_format_mask,
        p_start_date      => p_start_date,
        p_debug_flag      => 'N',
        p_alert_clob      => v_alert_clob,
        p_format_mask_out => v_format_mask,
        p_confidence      => v_confidence,
        p_converted_date  => v_converted_date,
        p_has_year        => v_has_year,
        p_is_ambiguous    => v_is_ambiguous,
        p_special_values  => v_special_values,
        p_all_formats     => v_all_formats,
        p_status          => v_status,
        p_message         => v_message
    );
    RETURN v_converted_date;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END parse_date_safe;

--------------------------------------------------------------------------------
-- PROCEDURE: extract_column_sample_values
-- PURPOSE: Extract sample values from uploaded file for date format detection
-- PARAMETERS:
--   p_file_id: ID from temp_BLOB table
--   p_column_name: Sanitized column name to extract
--   p_skip_rows: Number of header rows to skip
--   p_xlsx_sheet_name: Excel sheet name (NULL for CSV/other)
--   p_sample_values: OUT CLOB containing JSON array of sample values
--   p_status: OUT 'S'=success, 'E'=error
--   p_message: OUT status message
--------------------------------------------------------------------------------
PROCEDURE extract_column_sample_values(
    p_file_id         IN  NUMBER,
    p_column_name     IN  VARCHAR2,
    p_skip_rows       IN  NUMBER   DEFAULT 0,
    p_xlsx_sheet_name IN  VARCHAR2 DEFAULT NULL,
    p_sample_values   OUT CLOB,
    p_status          OUT VARCHAR2,
    p_message         OUT VARCHAR2
) IS
    v_file_blob    BLOB;
    v_filename     VARCHAR2(500);
    v_profile      CLOB;
    v_sql          CLOB;
    v_col_position NUMBER;
    TYPE t_samples IS TABLE OF VARCHAR2(4000);
    v_samples      t_samples := t_samples();
    v_json_array   JSON_ARRAY_T;
BEGIN
    p_status := 'S';
    p_sample_values := NULL;

    -- Get file from temp_blob
    BEGIN
        SELECT BLOB_CONTENT, FILENAME, profile
        INTO v_file_blob, v_filename, v_profile
        FROM temp_BLOB
        WHERE ID = p_file_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_status := 'E';
            p_message := 'File not found for ID: ' || p_file_id;
            RETURN;
    END;

    -- Find column position from profile
    BEGIN
        SELECT jt.col_position
        INTO v_col_position
        FROM JSON_TABLE(
            v_profile,
            '$."columns"[*]'
            COLUMNS (
                col_position FOR ORDINALITY,
                name VARCHAR2(200) PATH '$.name'
            )
        ) jt
        WHERE sanitize_column_name(jt.name) = UPPER(TRIM(p_column_name))
          AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_status := 'E';
            p_message := 'Column not found in profile: ' || p_column_name;
            RETURN;
    END;

    -- Build dynamic SQL to extract column values (max 366 rows)
    v_sql := 'SELECT COL' || LPAD(v_col_position, 3, '0') || ' FROM TABLE(';

    IF p_xlsx_sheet_name IS NOT NULL THEN
        v_sql := v_sql || 'apex_data_parser.parse(' ||
                 'p_content => :blob, ' ||
                 'p_file_name => :fname, ' ||
                 'p_skip_rows => :skip, ' ||
                 'p_xlsx_sheet_name => :sheet, ' ||
                 'p_max_rows => 366))';
    ELSE
        v_sql := v_sql || 'apex_data_parser.parse(' ||
                 'p_content => :blob, ' ||
                 'p_file_name => :fname, ' ||
                 'p_skip_rows => :skip, ' ||
                 'p_max_rows => 366))';
    END IF;

    -- Execute and collect values
    BEGIN
        IF p_xlsx_sheet_name IS NOT NULL THEN
            EXECUTE IMMEDIATE v_sql
            BULK COLLECT INTO v_samples
            USING v_file_blob, v_filename, p_skip_rows, p_xlsx_sheet_name;
        ELSE
            EXECUTE IMMEDIATE v_sql
            BULK COLLECT INTO v_samples
            USING v_file_blob, v_filename, p_skip_rows;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Error extracting sample values: ' || SQLERRM;
            RETURN;
    END;

    -- Convert to JSON array format: ["value1", "value2", ...]
    v_json_array := JSON_ARRAY_T();
    FOR i IN 1..v_samples.COUNT LOOP
        IF v_samples(i) IS NOT NULL AND TRIM(v_samples(i)) IS NOT NULL THEN
            v_json_array.append(v_samples(i));
        END IF;
    END LOOP;

    -- Convert to CLOB
    p_sample_values := v_json_array.to_clob();
    p_message := 'Extracted ' || v_json_array.get_size() || ' sample values';

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'Unexpected error: ' || SQLERRM;
END extract_column_sample_values;

-- Main date parser procedure
PROCEDURE date_parser(
    -- MODE CONTROL
    p_mode             IN  VARCHAR2,
    -- INPUT PARAMETERS
    p_file_id          IN  NUMBER   DEFAULT NULL,
    p_column_position  IN  NUMBER   DEFAULT NULL,
    p_sample_values    IN  CLOB     DEFAULT NULL,
    p_date_string      IN  VARCHAR2 DEFAULT NULL,
    p_format_mask      IN  VARCHAR2 DEFAULT NULL,
    p_start_date       IN  DATE     DEFAULT NULL,
    p_min_confidence   IN  NUMBER   DEFAULT 90,
    -- CONTROL PARAMETERS
    p_debug_flag       IN  VARCHAR2 DEFAULT 'N',
    p_alert_clob       IN OUT NOCOPY CLOB,
    -- OUTPUT PARAMETERS
    p_format_mask_out  OUT VARCHAR2,
    p_confidence       OUT NUMBER,
    p_converted_date   OUT DATE,
    p_has_year         OUT VARCHAR2,
    p_is_ambiguous     OUT VARCHAR2,
    p_special_values   OUT VARCHAR2,
    p_all_formats      OUT CLOB,
    p_status           OUT VARCHAR2,
    p_message          OUT VARCHAR2
) IS
    -- Debug log
    l_debug_log CLOB;

    -- Constants for patterns (Oracle regex doesn't support \b, so we use boundary patterns)
    c_day_pattern_short  CONSTANT VARCHAR2(100) := '(^|[^a-zA-Z])(Mon|Tue|Wed|Thu|Fri|Sat|Sun)([^a-zA-Z]|$)';
    c_day_pattern_full   CONSTANT VARCHAR2(100) := '(^|[^a-zA-Z])(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)([^a-zA-Z]|$)';
    c_month_pattern_short CONSTANT VARCHAR2(200) := '(^|[^a-zA-Z])(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)([^a-zA-Z]|$)';
    c_month_pattern_full  CONSTANT VARCHAR2(500) := '(^|[^a-zA-Z])(January|February|March|April|May|June|July|August|September|October|November|December)([^a-zA-Z]|$)';

    -- Type definitions for format library
    TYPE t_date_structure IS RECORD (
        has_day_name_short   VARCHAR2(1),
        has_day_name_full    VARCHAR2(1),
        has_day_name         VARCHAR2(1),
        has_month_name_short VARCHAR2(1),
        has_month_name_full  VARCHAR2(1),
        has_month_name       VARCHAR2(1),
        has_4digit_year      VARCHAR2(1),
        has_2digit_year      VARCHAR2(1),
        has_time             VARCHAR2(1),
        has_ampm             VARCHAR2(1),
        has_timezone         VARCHAR2(1),
        has_text_numbers     VARCHAR2(1),
        separators           VARCHAR2(20),
        primary_separator    VARCHAR2(5),
        numeric_group_count  NUMBER
    );

    TYPE t_format_def IS RECORD (
        format_mask    VARCHAR2(50),
        category       VARCHAR2(20),
        has_year       VARCHAR2(1),
        has_day_name   VARCHAR2(1),
        has_month_name VARCHAR2(1),
        is_ambiguous   VARCHAR2(1),
        alternate      VARCHAR2(50)
    );
    TYPE t_format_lib IS TABLE OF t_format_def INDEX BY PLS_INTEGER;

    TYPE t_format_result IS RECORD (
        format_mask    VARCHAR2(100),
        confidence     NUMBER,
        match_count    NUMBER,
        category       VARCHAR2(30),
        has_year       VARCHAR2(1),
        is_ambiguous   VARCHAR2(1)
    );
    TYPE t_format_results IS TABLE OF t_format_result INDEX BY PLS_INTEGER;

    ---------------------------------------------------------------------------
    -- Debug helper procedure
    ---------------------------------------------------------------------------
    PROCEDURE append_debug(p_entry VARCHAR2) IS
    BEGIN
        IF UPPER(p_debug_flag) = 'Y' THEN
            l_debug_log := l_debug_log ||
                TO_CHAR(SYSTIMESTAMP, 'HH24:MI:SS.FF3') || ' - ' ||
                p_entry || CHR(10);
        END IF;
    END append_debug;

    ---------------------------------------------------------------------------
    -- fn_try_date: Safe date parsing - returns NULL on failure
    ---------------------------------------------------------------------------
    FUNCTION fn_try_date(
        p_string IN VARCHAR2,
        p_format IN VARCHAR2
    ) RETURN DATE IS
        v_date DATE;
    BEGIN
        IF p_string IS NULL OR p_format IS NULL THEN
            RETURN NULL;
        END IF;
        v_date := TO_DATE(TRIM(p_string), p_format);
        -- Validate year is reasonable
        IF EXTRACT(YEAR FROM v_date) < 1900 OR EXTRACT(YEAR FROM v_date) > 2100 THEN
            RETURN NULL;
        END IF;
        RETURN v_date;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END fn_try_date;

    ---------------------------------------------------------------------------
    -- convert_text_numbers: Convert text numbers to digits
    ---------------------------------------------------------------------------
    FUNCTION convert_text_numbers(
        p_input IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_result VARCHAR2(500);
    BEGIN
        IF p_input IS NULL THEN
            RETURN NULL;
        END IF;

        -- Pad with spaces to enable word boundary matching
        v_result := ' ' || p_input || ' ';

        -- Process LONGEST strings first to avoid partial replacements
        -- Compound ordinals (twenty-first, twenty-second, etc.)
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?first(\s)', '\1 21 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?second(\s)', '\1 22 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?third(\s)', '\1 23 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?fourth(\s)', '\1 24 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?fifth(\s)', '\1 25 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?sixth(\s)', '\1 26 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?seventh(\s)', '\1 27 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?eighth(\s)', '\1 28 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?ninth(\s)', '\1 29 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirty[- ]?first(\s)', '\1 31 \2', 1, 0, 'i');

        -- Compound cardinals (twenty-one, twenty-two, etc.)
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?one(\s)', '\1 21 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?two(\s)', '\1 22 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?three(\s)', '\1 23 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?four(\s)', '\1 24 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?five(\s)', '\1 25 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?six(\s)', '\1 26 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?seven(\s)', '\1 27 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?eight(\s)', '\1 28 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty[- ]?nine(\s)', '\1 29 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirty[- ]?one(\s)', '\1 31 \2', 1, 0, 'i');

        -- Single-word ordinals (longest first)
        v_result := REGEXP_REPLACE(v_result, '(\s)seventeenth(\s)', '\1 17 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eighteenth(\s)', '\1 18 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)nineteenth(\s)', '\1 19 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirteenth(\s)', '\1 13 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fourteenth(\s)', '\1 14 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fifteenth(\s)', '\1 15 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)sixteenth(\s)', '\1 16 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twentieth(\s)', '\1 20 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirtieth(\s)', '\1 30 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eleventh(\s)', '\1 11 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twelfth(\s)', '\1 12 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)seventh(\s)', '\1 7 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eighth(\s)', '\1 8 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fourth(\s)', '\1 4 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)second(\s)', '\1 2 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)third(\s)', '\1 3 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fifth(\s)', '\1 5 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)sixth(\s)', '\1 6 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)ninth(\s)', '\1 9 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)tenth(\s)', '\1 10 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)first(\s)', '\1 1 \2', 1, 0, 'i');

        -- Single-word cardinals (longest first)
        v_result := REGEXP_REPLACE(v_result, '(\s)seventeen(\s)', '\1 17 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eighteen(\s)', '\1 18 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)nineteen(\s)', '\1 19 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirteen(\s)', '\1 13 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fourteen(\s)', '\1 14 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)fifteen(\s)', '\1 15 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)sixteen(\s)', '\1 16 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eleven(\s)', '\1 11 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twelve(\s)', '\1 12 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)twenty(\s)', '\1 20 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)thirty(\s)', '\1 30 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)seven(\s)', '\1 7 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)eight(\s)', '\1 8 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)three(\s)', '\1 3 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)four(\s)', '\1 4 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)five(\s)', '\1 5 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)nine(\s)', '\1 9 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)ten(\s)', '\1 10 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)one(\s)', '\1 1 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)two(\s)', '\1 2 \2', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)six(\s)', '\1 6 \2', 1, 0, 'i');

        -- Clean up multiple spaces and trim
        v_result := REGEXP_REPLACE(v_result, '\s+', ' ');
        v_result := TRIM(v_result);

        RETURN v_result;
    END convert_text_numbers;

    ---------------------------------------------------------------------------
    -- cleanup_date_string: Remove filler words
    ---------------------------------------------------------------------------
    FUNCTION cleanup_date_string(
        p_input IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_result VARCHAR2(500);
    BEGIN
        IF p_input IS NULL THEN
            RETURN NULL;
        END IF;

        -- Pad with spaces to enable word boundary matching
        v_result := ' ' || p_input || ' ';

        -- Remove common filler words (case-insensitive)
        v_result := REGEXP_REPLACE(v_result, '(\s)the(\s)', ' ', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)of(\s)', ' ', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)on(\s)', ' ', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)in(\s)', ' ', 1, 0, 'i');
        v_result := REGEXP_REPLACE(v_result, '(\s)day(\s)', ' ', 1, 0, 'i');

        -- Normalize multiple spaces after removal
        v_result := REGEXP_REPLACE(v_result, '\s+', ' ');

        -- Handle comma-space normalization
        v_result := REGEXP_REPLACE(v_result, '\s*,\s*', ', ');

        RETURN TRIM(v_result);
    END cleanup_date_string;

    ---------------------------------------------------------------------------
    -- strip_day_name: Remove day name from date string
    ---------------------------------------------------------------------------
    FUNCTION strip_day_name(
        p_input IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_result VARCHAR2(500);
    BEGIN
        IF p_input IS NULL THEN
            RETURN NULL;
        END IF;

        v_result := p_input;

        -- Remove short day names (Mon, Tue, etc.)
        v_result := REGEXP_REPLACE(v_result, '(^|[^a-zA-Z])(Mon|Tue|Wed|Thu|Fri|Sat|Sun)([^a-zA-Z]|$)', '\1\3', 1, 0, 'i');

        -- Remove full day names (Monday, Tuesday, etc.)
        v_result := REGEXP_REPLACE(v_result, '(^|[^a-zA-Z])(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)([^a-zA-Z]|$)', '\1\3', 1, 0, 'i');

        -- Clean up: remove leading/trailing commas and spaces
        v_result := REGEXP_REPLACE(v_result, '^\s*,?\s*', '');
        v_result := REGEXP_REPLACE(v_result, '\s*,?\s*$', '');
        v_result := REGEXP_REPLACE(v_result, '\s+', ' ');

        RETURN TRIM(v_result);
    END strip_day_name;

    ---------------------------------------------------------------------------
    -- preprocess_dy_sample: Lightweight preprocessing that preserves day names
    -- Used for testing DY/DAY formats where day name is part of the format
    ---------------------------------------------------------------------------
    FUNCTION preprocess_dy_sample(
        p_sample IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_clean VARCHAR2(500);
    BEGIN
        IF p_sample IS NULL THEN
            RETURN NULL;
        END IF;

        v_clean := TRIM(p_sample);

        -- Normalize day name abbreviations (but don't remove them!)
        -- Also uppercase them because Oracle's DY format is case-sensitive
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])Thurs([^a-zA-Z]|$)', '\1THU\2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])Tues([^a-zA-Z]|$)', '\1TUE\2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])Weds([^a-zA-Z]|$)', '\1WED\2', 1, 0, 'i');

        -- Uppercase all day names for Oracle's DY format (case-sensitive)
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Mon)(day)?([^a-zA-Z]|$)', '\1MON\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Tue)(sday)?([^a-zA-Z]|$)', '\1TUE\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Wed)(nesday)?([^a-zA-Z]|$)', '\1WED\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Thu)(rsday)?([^a-zA-Z]|$)', '\1THU\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Fri)(day)?([^a-zA-Z]|$)', '\1FRI\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Sat)(urday)?([^a-zA-Z]|$)', '\1SAT\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Sun)(day)?([^a-zA-Z]|$)', '\1SUN\4', 1, 0, 'i');

        -- Remove parenthetical content
        v_clean := REGEXP_REPLACE(v_clean, '\s*\([^)]*\)', '');

        -- Selective text number conversion (only safe patterns that won't corrupt day names)
        -- Pad with spaces for word boundary matching
        v_clean := ' ' || v_clean || ' ';

        -- Convert compound ordinals (safe - won't corrupt day names)
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty[- ]?first(\s)', '\1 21 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty[- ]?second(\s)', '\1 22 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty[- ]?third(\s)', '\1 23 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty[- ]?fourth(\s)', '\1 24 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty[- ]?fifth(\s)', '\1 25 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty[- ]?sixth(\s)', '\1 26 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty[- ]?seventh(\s)', '\1 27 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty[- ]?eighth(\s)', '\1 28 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty[- ]?ninth(\s)', '\1 29 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)thirty[- ]?first(\s)', '\1 31 \2', 1, 0, 'i');

        -- Convert standalone ordinals that are safe
        v_clean := REGEXP_REPLACE(v_clean, '(\s)seventeenth(\s)', '\1 17 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)eighteenth(\s)', '\1 18 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)nineteenth(\s)', '\1 19 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)eleventh(\s)', '\1 11 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twelfth(\s)', '\1 12 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)first(\s)', '\1 1 \2', 1, 0, 'i');

        -- DO NOT convert: second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth
        -- These would corrupt Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

        -- Convert cardinals (numbers, not ordinals - these are safe)
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twenty(\s)', '\1 20 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)thirty(\s)', '\1 30 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)eleven(\s)', '\1 11 \2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)twelve(\s)', '\1 12 \2', 1, 0, 'i');

        v_clean := TRIM(v_clean);

        -- Remove filler words (but NOT "day" since it's part of day names!)
        v_clean := ' ' || v_clean || ' ';
        v_clean := REGEXP_REPLACE(v_clean, '(\s)the(\s)', ' ', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)of(\s)', ' ', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)on(\s)', ' ', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(\s)in(\s)', ' ', 1, 0, 'i');
        -- Note: NOT removing "day" here because it's part of day names (Monday, Tuesday, etc.)
        v_clean := REGEXP_REPLACE(v_clean, '\s+', ' ');
        v_clean := REGEXP_REPLACE(v_clean, '\s*,\s*', ', ');
        v_clean := TRIM(v_clean);

        -- Strip ordinal suffixes
        v_clean := REGEXP_REPLACE(v_clean, '(\d+)(st|nd|rd|th)([^a-zA-Z]|$)', '\1\3', 1, 0, 'i');

        -- Uppercase month names for Oracle's MON/MONTH format (case-sensitive)
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Jan)(uary)?([^a-zA-Z]|$)', '\1JAN\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Feb)(ruary)?([^a-zA-Z]|$)', '\1FEB\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Mar)(ch)?([^a-zA-Z]|$)', '\1MAR\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Apr)(il)?([^a-zA-Z]|$)', '\1APR\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(May)([^a-zA-Z]|$)', '\1MAY\3', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Jun)(e)?([^a-zA-Z]|$)', '\1JUN\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Jul)(y)?([^a-zA-Z]|$)', '\1JUL\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Aug)(ust)?([^a-zA-Z]|$)', '\1AUG\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Sep)(tember)?([^a-zA-Z]|$)', '\1SEP\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Oct)(ober)?([^a-zA-Z]|$)', '\1OCT\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Nov)(ember)?([^a-zA-Z]|$)', '\1NOV\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Dec)(ember)?([^a-zA-Z]|$)', '\1DEC\4', 1, 0, 'i');

        -- Final cleanup
        v_clean := TRIM(REGEXP_REPLACE(v_clean, '\s+', ' '));

        RETURN v_clean;
    END preprocess_dy_sample;

    ---------------------------------------------------------------------------
    -- preprocess_date_sample: Full preprocessing pipeline (10 steps)
    ---------------------------------------------------------------------------
    FUNCTION preprocess_date_sample(
        p_raw IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_clean VARCHAR2(500);
    BEGIN
        IF p_raw IS NULL THEN
            RETURN NULL;
        END IF;

        -- Step 1: Trim whitespace
        v_clean := TRIM(p_raw);

        -- Step 2: Normalize multiple spaces
        v_clean := REGEXP_REPLACE(v_clean, '\s+', ' ');

        -- Step 3: Remove AD/BC prefix/suffix
        v_clean := REGEXP_REPLACE(v_clean, '(^|\s)AD(\s|$)', ' ', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|\s)BC(\s|$)', ' ', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|\s)A\.D\.(\s|$)', ' ', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|\s)B\.C\.(\s|$)', ' ', 1, 0, 'i');

        -- Step 4: Normalize day abbreviations to Oracle 3-letter format
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Mon)(days?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Tue)(sdays?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Wed)(nesdays?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Thu)(rsdays?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Fri)(days?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Sat)(urdays?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])(Sun)(days?)?([^a-zA-Z]|$)', '\1\2\4', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])Thurs([^a-zA-Z]|$)', '\1Thu\2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])Tues([^a-zA-Z]|$)', '\1Tue\2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '(^|[^a-zA-Z])Weds([^a-zA-Z]|$)', '\1Wed\2', 1, 0, 'i');

        -- Step 5: Remove parenthetical content
        v_clean := REGEXP_REPLACE(v_clean, '\s*\([^)]*\)', '');

        -- Step 6: Remove decorative day names
        v_clean := REGEXP_REPLACE(v_clean, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)[,]?\s*[-]?\s*(\d)', '\2', 1, 0, 'i');
        v_clean := REGEXP_REPLACE(v_clean, '\s+[-]?\s*(Mon|Tue|Wed|Thu|Fri|Sat|Sun)$', '', 1, 0, 'i');

        -- Step 7: Convert text numbers to digits
        v_clean := convert_text_numbers(v_clean);

        -- Step 8: Remove filler words
        v_clean := cleanup_date_string(v_clean);

        -- Step 9: Strip ordinal suffixes
        v_clean := REGEXP_REPLACE(v_clean, '(\d+)(st|nd|rd|th)([^a-zA-Z]|$)', '\1\3', 1, 0, 'i');

        -- Step 10: Final cleanup
        v_clean := TRIM(REGEXP_REPLACE(v_clean, '\s+', ' '));

        RETURN v_clean;
    END preprocess_date_sample;

    ---------------------------------------------------------------------------
    -- analyze_date_structure: Analyze structure of a date string
    ---------------------------------------------------------------------------
    FUNCTION analyze_date_structure(
        p_sample IN VARCHAR2
    ) RETURN t_date_structure IS
        v_result t_date_structure;
    BEGIN
        -- Check for day names (short)
        v_result.has_day_name_short := CASE
            WHEN REGEXP_LIKE(p_sample, c_day_pattern_short, 'i')
            THEN 'Y' ELSE 'N' END;

        -- Check for day names (full)
        v_result.has_day_name_full := CASE
            WHEN REGEXP_LIKE(p_sample, c_day_pattern_full, 'i')
            THEN 'Y' ELSE 'N' END;

        -- Combined day name flag
        v_result.has_day_name := CASE
            WHEN v_result.has_day_name_short = 'Y' OR v_result.has_day_name_full = 'Y'
            THEN 'Y' ELSE 'N' END;

        -- Check for month names (short)
        v_result.has_month_name_short := CASE
            WHEN REGEXP_LIKE(p_sample, c_month_pattern_short, 'i')
            THEN 'Y' ELSE 'N' END;

        -- Check for month names (full)
        v_result.has_month_name_full := CASE
            WHEN REGEXP_LIKE(p_sample, c_month_pattern_full, 'i')
            THEN 'Y' ELSE 'N' END;

        -- Combined month name flag
        v_result.has_month_name := CASE
            WHEN v_result.has_month_name_short = 'Y' OR v_result.has_month_name_full = 'Y'
            THEN 'Y' ELSE 'N' END;

        -- Check for 4-digit year
        v_result.has_4digit_year := CASE
            WHEN REGEXP_LIKE(p_sample, '(^|[^0-9])(19|20)[0-9]{2}([^0-9]|$)')
            THEN 'Y' ELSE 'N' END;

        -- Check for 2-digit year
        v_result.has_2digit_year := CASE
            WHEN v_result.has_4digit_year = 'N' AND REGEXP_LIKE(p_sample, '(^|[^0-9])[0-9]{2}([^0-9]|$)')
            THEN 'Y' ELSE 'N' END;

        -- Check for time component
        v_result.has_time := CASE
            WHEN REGEXP_LIKE(p_sample, '[0-9]{1,2}:[0-9]{2}(:[0-9]{2})?')
            THEN 'Y' ELSE 'N' END;

        -- Check for AM/PM
        v_result.has_ampm := CASE
            WHEN REGEXP_LIKE(p_sample, '(^|[^a-zA-Z])(AM|PM|A\.M\.|P\.M\.)([^a-zA-Z]|$)', 'i')
            THEN 'Y' ELSE 'N' END;

        -- Check for timezone
        v_result.has_timezone := CASE
            WHEN REGEXP_LIKE(p_sample, '(Z|[+-][0-9]{2}:?[0-9]{2}|UTC|GMT)\s*$', 'i')
            THEN 'Y' ELSE 'N' END;

        -- Check for text numbers
        v_result.has_text_numbers := CASE
            WHEN REGEXP_LIKE(p_sample,
                '(^|[^a-zA-Z])(one|two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|' ||
                'thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty|thirty|' ||
                'first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth|' ||
                'eleventh|twelfth|thirteenth|fourteenth|fifteenth|sixteenth|seventeenth|' ||
                'eighteenth|nineteenth|twentieth|thirtieth|twenty-first|twenty-second|' ||
                'twenty-third|twenty-fourth|twenty-fifth|twenty-sixth|twenty-seventh|' ||
                'twenty-eighth|twenty-ninth|thirty-first)([^a-zA-Z]|$)', 'i')
            THEN 'Y' ELSE 'N' END;

        -- Detect all separators used
        v_result.separators := '';
        IF INSTR(p_sample, '/') > 0 THEN v_result.separators := v_result.separators || '/'; END IF;
        IF INSTR(p_sample, '-') > 0 THEN v_result.separators := v_result.separators || '-'; END IF;
        IF INSTR(p_sample, '.') > 0 THEN v_result.separators := v_result.separators || '.'; END IF;
        IF INSTR(p_sample, ',') > 0 THEN v_result.separators := v_result.separators || ','; END IF;
        IF INSTR(p_sample, ' ') > 0 THEN v_result.separators := v_result.separators || ' '; END IF;

        -- Primary separator
        v_result.primary_separator := CASE
            WHEN INSTR(p_sample, '/') > 0 THEN '/'
            WHEN INSTR(p_sample, '-') > 0 THEN '-'
            WHEN INSTR(p_sample, '.') > 0 THEN '.'
            ELSE ' '
        END;

        -- Count numeric groups
        v_result.numeric_group_count := REGEXP_COUNT(p_sample, '\d+');

        RETURN v_result;
    END analyze_date_structure;

    ---------------------------------------------------------------------------
    -- detect_special_values: Find special values in samples
    ---------------------------------------------------------------------------
    FUNCTION detect_special_values(
        p_sample_values IN CLOB
    ) RETURN VARCHAR2 IS
        v_specials VARCHAR2(500) := '';
        TYPE t_special_list IS TABLE OF VARCHAR2(20);
        v_known_specials t_special_list := t_special_list(
            'TODAY', 'YESTERDAY', 'TOMORROW',
            'N/A', 'NA', 'TBD', 'TBA', 'PENDING',
            'NULL', 'NONE', 'ASAP', 'EOD', 'EOW',
            'CURRENT', 'NOW'
        );
    BEGIN
        IF p_sample_values IS NULL THEN
            RETURN NULL;
        END IF;

        FOR i IN 1..v_known_specials.COUNT LOOP
            IF REGEXP_LIKE(p_sample_values, '"' || v_known_specials(i) || '"', 'i') THEN
                v_specials := v_specials || v_known_specials(i) || ',';
            END IF;
        END LOOP;

        RETURN RTRIM(v_specials, ',');
    END detect_special_values;

    ---------------------------------------------------------------------------
    -- initialize_format_library: Build the format library (~80 formats)
    ---------------------------------------------------------------------------
    FUNCTION initialize_format_library RETURN t_format_lib IS
        v_formats t_format_lib;
        v_idx PLS_INTEGER := 0;

        PROCEDURE add_format(
            p_mask VARCHAR2, p_cat VARCHAR2, p_year VARCHAR2,
            p_day VARCHAR2, p_mon VARCHAR2, p_amb VARCHAR2, p_alt VARCHAR2 DEFAULT NULL
        ) IS
        BEGIN
            v_idx := v_idx + 1;
            v_formats(v_idx).format_mask := p_mask;
            v_formats(v_idx).category := p_cat;
            v_formats(v_idx).has_year := p_year;
            v_formats(v_idx).has_day_name := p_day;
            v_formats(v_idx).has_month_name := p_mon;
            v_formats(v_idx).is_ambiguous := p_amb;
            v_formats(v_idx).alternate := p_alt;
        END;
    BEGIN
        -- Category 1: ISO formats (highest priority, unambiguous)
        add_format('YYYY-MM-DD"T"HH24:MI:SS"Z"', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY-MM-DD"T"HH24:MI:SS', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY-MM-DD HH24:MI:SS', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY-MM-DD HH24:MI', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY-MM-DD', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYYMMDD', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY/MM/DD', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY.MM.DD', 'ISO', 'Y', 'N', 'N', 'N');
        add_format('YYYY MM DD', 'ISO', 'Y', 'N', 'N', 'N');

        -- Category 2: Day name formats (unambiguous)
        add_format('DY DD-MON-YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY DD MON YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY, DD MON YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY, DD-MON-YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY, DD/MM/YYYY', 'DAYNAME', 'Y', 'Y', 'N', 'N');
        add_format('DAY DD-MON-YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DAY, DD MON YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DAY DD MONTH YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DAY, DD MONTH YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DAY, MONTH DD, YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY, MONTH DD, YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY DD MONTH YYYY', 'DAYNAME', 'Y', 'Y', 'Y', 'N');
        add_format('DY DD-MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');
        add_format('DY DD MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');
        add_format('DY, DD MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');
        add_format('DAY DD MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');
        add_format('DAY, DD MON', 'DAYNAME', 'N', 'Y', 'Y', 'N');

        -- Category 3: Month name formats (unambiguous)
        add_format('DD MONTH YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MONTH DD, YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MONTH DD YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MONTH-YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MON-YYYY HH24:MI:SS', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MON-YYYY HH:MI:SS AM', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MON-YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD MON YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD/MON/YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD.MON.YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MON DD, YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MON DD YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MON-DD-YYYY', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD-MON-RR', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('DD MON RR', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('MON DD, RR', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        -- YYYY-first month name formats
        add_format('YYYY MONTH DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY, MONTH DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY, DD MONTH', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY-MON-DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY/MON/DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');
        add_format('YYYY MON DD', 'MONTHNAME', 'Y', 'N', 'Y', 'N');

        -- No-year month name formats
        add_format('DD-MON', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('DD MON', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('DD/MON', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('MON DD', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('MON-DD', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('DD MONTH', 'MONTHNAME', 'N', 'N', 'Y', 'N');
        add_format('MONTH DD', 'MONTHNAME', 'N', 'N', 'Y', 'N');

        -- Category 4: Numeric formats WITH year (ambiguous)
        add_format('DD/MM/YYYY HH24:MI:SS', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM/DD/YYYY HH24:MI:SS');
        add_format('DD/MM/YYYY HH:MI:SS AM', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM/DD/YYYY HH:MI:SS AM');
        add_format('DD/MM/YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM/DD/YYYY');
        add_format('MM/DD/YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD/MM/YYYY');
        add_format('DD-MM-YYYY HH24:MI:SS', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM-DD-YYYY HH24:MI:SS');
        add_format('DD-MM-YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM-DD-YYYY');
        add_format('MM-DD-YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD-MM-YYYY');
        add_format('DD.MM.YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM.DD.YYYY');
        add_format('MM.DD.YYYY', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD.MM.YYYY');

        -- 2-digit year numeric
        add_format('DD/MM/RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM/DD/RR');
        add_format('MM/DD/RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD/MM/RR');
        add_format('DD-MM-RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM-DD-RR');
        add_format('MM-DD-RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'DD-MM-RR');
        add_format('DD.MM.RR', 'NUMERIC', 'Y', 'N', 'N', 'Y', 'MM.DD.RR');
        -- YY/MM/DD formats (ISO-style with 2-digit year)
        add_format('RR/MM/DD', 'NUMERIC', 'Y', 'N', 'N', 'N');
        add_format('RR-MM-DD', 'NUMERIC', 'Y', 'N', 'N', 'N');
        add_format('RR.MM.DD', 'NUMERIC', 'Y', 'N', 'N', 'N');

        -- No-year numeric (highly ambiguous)
        add_format('DD/MM', 'NUMERIC', 'N', 'N', 'N', 'Y', 'MM/DD');
        add_format('MM/DD', 'NUMERIC', 'N', 'N', 'N', 'Y', 'DD/MM');
        add_format('DD-MM', 'NUMERIC', 'N', 'N', 'N', 'Y', 'MM-DD');
        add_format('DD.MM', 'NUMERIC', 'N', 'N', 'N', 'Y', 'MM.DD');

        RETURN v_formats;
    END initialize_format_library;

    ---------------------------------------------------------------------------
    -- disambiguate_dd_mm: Resolve DD/MM vs MM/DD ambiguity
    ---------------------------------------------------------------------------
    FUNCTION disambiguate_dd_mm(
        p_samples IN CLOB
    ) RETURN VARCHAR2 IS
        v_first_max  NUMBER := 0;
        v_second_max NUMBER := 0;
        v_first_num  NUMBER;
        v_second_num NUMBER;
        v_parts      VARCHAR2(100);
    BEGIN
        -- Extract numeric components and find max values
        FOR rec IN (
            SELECT val
            FROM JSON_TABLE(p_samples, '$[*]' COLUMNS (val VARCHAR2(100) PATH '$'))
            WHERE ROWNUM <= 50
        ) LOOP
            -- Extract first two numeric groups
            v_parts := REGEXP_REPLACE(rec.val, '[^0-9]+', ',');
            BEGIN
                v_first_num := TO_NUMBER(REGEXP_SUBSTR(v_parts, '[^,]+', 1, 1));
                v_second_num := TO_NUMBER(REGEXP_SUBSTR(v_parts, '[^,]+', 1, 2));

                IF v_first_num > v_first_max THEN v_first_max := v_first_num; END IF;
                IF v_second_num > v_second_max THEN v_second_max := v_second_num; END IF;
            EXCEPTION
                WHEN OTHERS THEN NULL;
            END;
        END LOOP;

        -- Decision matrix
        IF v_first_max > 12 AND v_second_max <= 12 THEN
            RETURN 'DD_FIRST';  -- European format
        ELSIF v_first_max <= 12 AND v_second_max > 12 THEN
            RETURN 'MM_FIRST';  -- US format
        ELSIF v_first_max > 12 AND v_second_max > 12 THEN
            RETURN 'ERROR';     -- Invalid data
        ELSE
            RETURN 'AMBIGUOUS'; -- Cannot determine, default to European
        END IF;
    END disambiguate_dd_mm;

    ---------------------------------------------------------------------------
    -- fn_infer_year: Smart year inference using day name when available
    ---------------------------------------------------------------------------
    FUNCTION fn_infer_year(
        p_date_str   IN VARCHAR2,
        p_start      IN DATE,
        p_format     IN VARCHAR2 DEFAULT NULL
    ) RETURN DATE IS
        v_start_year     NUMBER;
        v_start_mon      NUMBER;
        v_parsed_mon     NUMBER;
        v_parsed_day     NUMBER;
        v_day_name       VARCHAR2(20);
        v_candidate_date DATE;
        v_result         DATE;
        v_clean_str      VARCHAR2(200);
    BEGIN
        IF p_date_str IS NULL OR p_start IS NULL THEN
            RETURN NULL;
        END IF;

        v_start_year := EXTRACT(YEAR FROM p_start);
        v_start_mon := EXTRACT(MONTH FROM p_start);

        -- Step 1: Check if day name is present
        v_day_name := REGEXP_SUBSTR(p_date_str, c_day_pattern_short, 1, 1, 'i', 2);
        IF v_day_name IS NULL THEN
            v_day_name := REGEXP_SUBSTR(p_date_str, c_day_pattern_full, 1, 1, 'i', 2);
        END IF;

        -- Step 2: Extract day and month - remove day name first
        v_clean_str := REGEXP_REPLACE(p_date_str, c_day_pattern_short || ',?\s*', '\1\3', 1, 0, 'i');
        v_clean_str := REGEXP_REPLACE(v_clean_str, c_day_pattern_full || ',?\s*', '\1\3', 1, 0, 'i');
        v_clean_str := TRIM(v_clean_str);
        v_clean_str := preprocess_date_sample(v_clean_str);

        -- Try various formats to parse day and month
        BEGIN
            v_candidate_date := TO_DATE(v_clean_str, 'DD-MON');
            v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
            v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
        EXCEPTION
            WHEN OTHERS THEN
                BEGIN
                    v_candidate_date := TO_DATE(v_clean_str, 'DD MON');
                    v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
                    v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
                EXCEPTION
                    WHEN OTHERS THEN
                        BEGIN
                            v_candidate_date := TO_DATE(v_clean_str, 'DD/MM');
                            v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
                            v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
                        EXCEPTION
                            WHEN OTHERS THEN
                                BEGIN
                                    v_candidate_date := TO_DATE(v_clean_str, 'MON DD');
                                    v_parsed_mon := EXTRACT(MONTH FROM v_candidate_date);
                                    v_parsed_day := EXTRACT(DAY FROM v_candidate_date);
                                EXCEPTION
                                    WHEN OTHERS THEN
                                        RETURN NULL;
                                END;
                        END;
                END;
        END;

        -- Step 3: Determine year using day name validation OR sequential logic
        IF v_day_name IS NOT NULL THEN
            -- SMART PATH: Use day name to find correct year
            v_candidate_date := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || v_start_year, 'DD-MM-YYYY');

            IF UPPER(TO_CHAR(v_candidate_date, 'DY')) = UPPER(SUBSTR(v_day_name, 1, 3)) THEN
                v_result := v_candidate_date;
            ELSE
                -- Try next year
                v_candidate_date := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || (v_start_year + 1), 'DD-MM-YYYY');
                IF UPPER(TO_CHAR(v_candidate_date, 'DY')) = UPPER(SUBSTR(v_day_name, 1, 3)) THEN
                    v_result := v_candidate_date;
                ELSE
                    -- Try previous year
                    v_candidate_date := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || (v_start_year - 1), 'DD-MM-YYYY');
                    IF UPPER(TO_CHAR(v_candidate_date, 'DY')) = UPPER(SUBSTR(v_day_name, 1, 3)) THEN
                        v_result := v_candidate_date;
                    ELSE
                        -- Fall back to sequential logic
                        IF v_parsed_mon < v_start_mon THEN
                            v_result := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || (v_start_year + 1), 'DD-MM-YYYY');
                        ELSE
                            v_result := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || v_start_year, 'DD-MM-YYYY');
                        END IF;
                    END IF;
                END IF;
            END IF;
        ELSE
            -- FALLBACK PATH: No day name, use sequential logic
            IF v_parsed_mon < v_start_mon THEN
                v_result := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || (v_start_year + 1), 'DD-MM-YYYY');
            ELSE
                v_result := TO_DATE(v_parsed_day || '-' || v_parsed_mon || '-' || v_start_year, 'DD-MM-YYYY');
            END IF;
        END IF;

        RETURN v_result;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END fn_infer_year;

    ---------------------------------------------------------------------------
    -- detect_format_internal: Main format detection logic
    ---------------------------------------------------------------------------
    PROCEDURE detect_format_internal(
        p_samples        IN  CLOB,
        p_min_confidence IN  NUMBER,
        p_format_mask    OUT VARCHAR2,
        p_confidence     OUT NUMBER,
        p_has_year       OUT VARCHAR2,
        p_is_ambiguous   OUT VARCHAR2,
        p_special_values OUT VARCHAR2,
        p_all_formats    OUT CLOB,
        p_status         OUT VARCHAR2,
        p_message        OUT VARCHAR2
    ) IS
        v_formats       t_format_lib;
        v_structure     t_date_structure;
        v_results       t_format_results;
        v_sample        VARCHAR2(500);
        v_preprocessed  VARCHAR2(500);
        v_sample_count  NUMBER := 0;
        v_match_count   NUMBER;
        v_best_idx      PLS_INTEGER := 0;
        v_best_score    NUMBER := 0;
        v_dd_mm_result  VARCHAR2(20);
        v_result_idx    PLS_INTEGER := 0;
        v_score         NUMBER;
        v_json          CLOB;
    BEGIN
        p_status := 'S';
        p_confidence := 0;
        p_is_ambiguous := 'N';
        p_has_year := 'Y';

        append_debug('detect_format_internal started');

        -- Check for empty input
        IF p_samples IS NULL OR LENGTH(p_samples) < 3 THEN
            p_status := 'E';
            p_message := 'No sample values provided';
            append_debug('ERROR: No sample values');
            RETURN;
        END IF;

        -- Detect special values first
        p_special_values := detect_special_values(p_samples);
        append_debug('Special values detected: ' || NVL(p_special_values, 'none'));

        -- Count samples
        SELECT COUNT(*) INTO v_sample_count
        FROM JSON_TABLE(p_samples, '$[*]' COLUMNS (val VARCHAR2(500) PATH '$'))
        WHERE val IS NOT NULL
          AND TRIM(val) IS NOT NULL
          AND UPPER(TRIM(val)) NOT IN ('TODAY','YESTERDAY','TOMORROW','N/A','NA','TBD','NULL','NONE','-');

        append_debug('Valid sample count: ' || v_sample_count);

        IF v_sample_count = 0 THEN
            p_status := 'E';
            p_message := 'No valid date samples found (only special values)';
            append_debug('ERROR: No valid samples');
            RETURN;
        END IF;

        -- Get first sample for structure analysis
        SELECT val INTO v_sample
        FROM JSON_TABLE(p_samples, '$[*]' COLUMNS (val VARCHAR2(500) PATH '$'))
        WHERE val IS NOT NULL AND TRIM(val) IS NOT NULL
          AND UPPER(TRIM(val)) NOT IN ('TODAY','YESTERDAY','TOMORROW','N/A','NA','TBD','NULL','NONE','-')
          AND ROWNUM = 1;

        -- Analyze structure
        v_structure := analyze_date_structure(v_sample);
        append_debug('Structure analysis - Day name: ' || v_structure.has_day_name ||
                     ', Month name: ' || v_structure.has_month_name ||
                     ', 4-digit year: ' || v_structure.has_4digit_year ||
                     ', Separators: ' || v_structure.separators);

        -- Initialize format library
        v_formats := initialize_format_library;
        append_debug('Format library initialized with ' || v_formats.COUNT || ' formats');

        -- Test each format against all samples
        FOR i IN 1..v_formats.COUNT LOOP
            v_match_count := 0;

            -- Filter by structure (optimization)
            IF v_formats(i).has_day_name = 'Y' AND v_structure.has_day_name = 'N' THEN
                CONTINUE;
            END IF;
            IF v_formats(i).has_month_name = 'Y' AND v_structure.has_month_name = 'N' THEN
                CONTINUE;
            END IF;
            IF v_formats(i).has_month_name = 'N' AND v_structure.has_month_name = 'Y' THEN
                CONTINUE;
            END IF;

            -- Test against all samples
            FOR rec IN (
                SELECT val
                FROM JSON_TABLE(p_samples, '$[*]' COLUMNS (val VARCHAR2(500) PATH '$'))
                WHERE val IS NOT NULL AND TRIM(val) IS NOT NULL
                  AND UPPER(TRIM(val)) NOT IN ('TODAY','YESTERDAY','TOMORROW','N/A','NA','TBD','NULL','NONE','-')
            ) LOOP
                v_preprocessed := preprocess_date_sample(rec.val);

                -- Try direct parse first
                -- For DY/DAY formats, use pattern matching instead of TO_DATE
                -- Oracle's DY format doesn't work reliably without year
                IF v_formats(i).has_day_name = 'Y' THEN
                    -- Use pattern matching for DY formats
                    IF v_formats(i).format_mask = 'DY DD-MON' THEN
                        -- Pattern: day-name space digits hyphen month-name (NO YEAR at end)
                        IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+\d{1,2}\s*-\s*(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s*$', 'i') THEN
                            v_match_count := v_match_count + 1;
                        END IF;
                    ELSIF v_formats(i).format_mask = 'DY DD-MON-YYYY' THEN
                        -- Pattern: day-name space digits hyphen month-name hyphen 4-digit-year
                        IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+\d{1,2}\s*-\s*(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s*-\s*\d{4}\s*$', 'i') THEN
                            v_match_count := v_match_count + 1;
                        END IF;
                    ELSIF v_formats(i).format_mask = 'DY DD MON' THEN
                        -- Pattern: day-name space digits space month-name (NO YEAR at end)
                        IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+\d{1,2}\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s*$', 'i') THEN
                            v_match_count := v_match_count + 1;
                        END IF;
                    ELSIF v_formats(i).format_mask = 'DY DD MON YYYY' THEN
                        -- Pattern: day-name space digits space month-name space 4-digit-year
                        IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s+\d{1,2}\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{4}\s*$', 'i') THEN
                            v_match_count := v_match_count + 1;
                        END IF;
                    ELSIF v_formats(i).format_mask = 'DY, DD MON' THEN
                        -- Pattern: day-name comma space digits space month-name (NO YEAR at end)
                        IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s*,\s*\d{1,2}\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s*$', 'i') THEN
                            v_match_count := v_match_count + 1;
                        END IF;
                    ELSIF v_formats(i).format_mask = 'DY, DD MON YYYY' THEN
                        -- Pattern: day-name comma space digits space month-name space 4-digit-year
                        IF REGEXP_LIKE(rec.val, '^(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s*,\s*\d{1,2}\s+(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{4}\s*$', 'i') THEN
                            v_match_count := v_match_count + 1;
                        END IF;
                    ELSE
                        -- For other DY formats with year, try parsing normally
                        IF v_formats(i).has_year = 'Y' THEN
                            IF fn_try_date(preprocess_dy_sample(rec.val), v_formats(i).format_mask) IS NOT NULL THEN
                                v_match_count := v_match_count + 1;
                            END IF;
                        END IF;
                    END IF;
                ELSIF fn_try_date(v_preprocessed, v_formats(i).format_mask) IS NOT NULL THEN
                    v_match_count := v_match_count + 1;
                -- If format has no day name but input has one, try stripping day name
                ELSIF v_formats(i).has_day_name = 'N' AND v_structure.has_day_name = 'Y' THEN
                    IF fn_try_date(strip_day_name(v_preprocessed), v_formats(i).format_mask) IS NOT NULL THEN
                        v_match_count := v_match_count + 1;
                    END IF;
                END IF;
            END LOOP;

            -- Record results for formats with matches
            IF v_match_count > 0 THEN
                v_result_idx := v_result_idx + 1;
                v_results(v_result_idx).format_mask := v_formats(i).format_mask;
                v_results(v_result_idx).match_count := v_match_count;
                v_results(v_result_idx).category := v_formats(i).category;
                v_results(v_result_idx).has_year := v_formats(i).has_year;
                v_results(v_result_idx).is_ambiguous := v_formats(i).is_ambiguous;

                -- Calculate confidence score
                v_score := (v_match_count / v_sample_count) * 100;

                -- Apply modifiers
                IF v_formats(i).category IN ('ISO', 'DAYNAME', 'MONTHNAME') THEN
                    v_score := v_score * 1.15;
                END IF;
                -- Strong bonus for DY formats when input actually has day names
                IF v_formats(i).has_day_name = 'Y' AND v_structure.has_day_name = 'Y' THEN
                    v_score := v_score * 1.20;  -- 20% bonus for DY format matching DY input
                END IF;
                IF v_formats(i).format_mask LIKE 'YYYY-MM-DD%' THEN
                    v_score := v_score * 1.10;
                END IF;
                IF v_formats(i).format_mask LIKE '%RR%' THEN
                    v_score := v_score * 0.90;
                END IF;
                IF v_formats(i).has_year = 'N' THEN
                    v_score := v_score * 0.85;
                END IF;
                IF v_formats(i).is_ambiguous = 'Y' THEN
                    v_score := v_score * 0.80;
                END IF;

                -- Separator match bonus: prefer formats that match input separators
                IF v_structure.primary_separator = '-' AND v_formats(i).format_mask LIKE '%-%'
                   AND v_formats(i).format_mask NOT LIKE '% %' THEN
                    v_score := v_score * 1.05;  -- Bonus for matching dash separator
                ELSIF v_structure.primary_separator = '/' AND v_formats(i).format_mask LIKE '%/%' THEN
                    v_score := v_score * 1.05;  -- Bonus for matching slash separator
                ELSIF v_structure.primary_separator = '.' AND v_formats(i).format_mask LIKE '%.%' THEN
                    v_score := v_score * 1.05;  -- Bonus for matching dot separator
                ELSIF v_structure.primary_separator = ' ' AND v_formats(i).format_mask LIKE '% %'
                   AND v_formats(i).format_mask NOT LIKE '%-%' THEN
                    v_score := v_score * 1.05;  -- Bonus for matching space separator
                END IF;

                -- MON vs MONTH preference: prefer shorter format when input uses abbreviation
                IF v_structure.has_month_name_short = 'Y' AND v_structure.has_month_name_full = 'N' THEN
                    IF v_formats(i).format_mask LIKE '%MON%' AND v_formats(i).format_mask NOT LIKE '%MONTH%' THEN
                        v_score := v_score * 1.03;  -- Prefer MON over MONTH for abbreviated input
                    END IF;
                ELSIF v_structure.has_month_name_full = 'Y' THEN
                    IF v_formats(i).format_mask LIKE '%MONTH%' THEN
                        v_score := v_score * 1.03;  -- Prefer MONTH for full month name input
                    END IF;
                END IF;

                -- Exact length match bonus: penalize formats with extra components not in input
                IF v_formats(i).format_mask LIKE '%HH%' AND v_structure.has_time = 'N' THEN
                    v_score := v_score * 0.95;  -- Penalize time formats when no time in input
                END IF;
                IF v_formats(i).format_mask LIKE '%"T"%' OR v_formats(i).format_mask LIKE '%"Z"%' THEN
                    IF NOT REGEXP_LIKE(v_sample, 'T|Z') THEN
                        v_score := v_score * 0.95;  -- Penalize ISO timestamp format for plain dates
                    END IF;
                END IF;

                v_results(v_result_idx).confidence := LEAST(ROUND(v_score, 1), 100);

                -- Track best result
                IF v_results(v_result_idx).confidence > v_best_score THEN
                    v_best_score := v_results(v_result_idx).confidence;
                    v_best_idx := v_result_idx;
                END IF;
            END IF;
        END LOOP;

        append_debug('Matching formats found: ' || v_result_idx);

        -- Check if we found any matches
        IF v_best_idx = 0 THEN
            p_status := 'E';
            p_message := 'No matching date format found for samples';
            append_debug('ERROR: No matching format');
            RETURN;
        END IF;

        -- Handle DD/MM vs MM/DD ambiguity
        IF v_results(v_best_idx).is_ambiguous = 'Y' THEN
            v_dd_mm_result := disambiguate_dd_mm(p_samples);
            append_debug('Disambiguation result: ' || v_dd_mm_result);

            IF v_dd_mm_result = 'DD_FIRST' THEN
                p_is_ambiguous := 'N';
                IF v_results(v_best_idx).format_mask LIKE 'MM%' THEN
                    v_results(v_best_idx).format_mask := REPLACE(v_results(v_best_idx).format_mask, 'MM/', 'DD/');
                    v_results(v_best_idx).format_mask := REPLACE(v_results(v_best_idx).format_mask, '/DD/', '/MM/');
                END IF;
            ELSIF v_dd_mm_result = 'MM_FIRST' THEN
                p_is_ambiguous := 'N';
                IF v_results(v_best_idx).format_mask LIKE 'DD%' THEN
                    v_results(v_best_idx).format_mask := REPLACE(v_results(v_best_idx).format_mask, 'DD/', 'MM/');
                    v_results(v_best_idx).format_mask := REPLACE(v_results(v_best_idx).format_mask, '/MM/', '/DD/');
                END IF;
            ELSE
                p_is_ambiguous := 'Y';
            END IF;
        END IF;

        -- Set output values
        p_format_mask := v_results(v_best_idx).format_mask;
        p_confidence := v_results(v_best_idx).confidence;
        p_has_year := v_results(v_best_idx).has_year;

        append_debug('Best format: ' || p_format_mask || ' (confidence: ' || p_confidence || '%)');

        -- Build JSON array of all formats (sorted by confidence)
        v_json := '[';
        FOR i IN 1..v_result_idx LOOP
            IF i > 1 THEN v_json := v_json || ','; END IF;
            v_json := v_json || '{"format":"' || v_results(i).format_mask ||
                      '","confidence":' || v_results(i).confidence ||
                      ',"category":"' || v_results(i).category ||
                      '","has_year":"' || v_results(i).has_year || '"}';
        END LOOP;
        v_json := v_json || ']';
        p_all_formats := v_json;

        p_message := 'Detected format: ' || p_format_mask ||
                     ' (Confidence: ' || p_confidence || '%)' ||
                     ' [PKG-v2.6-DY-NOYEAR-FIX-2025-12-15]' ||
                     CASE WHEN p_is_ambiguous = 'Y' THEN ' - AMBIGUOUS (defaulting to European DD/MM)' ELSE '' END;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Detection error: ' || SQLERRM;
            append_debug('EXCEPTION: ' || SQLERRM);
    END detect_format_internal;

    ---------------------------------------------------------------------------
    -- parse_date_internal: Parse a single date using specified format
    ---------------------------------------------------------------------------
    PROCEDURE parse_date_internal(
        p_date_str    IN  VARCHAR2,
        p_format      IN  VARCHAR2,
        p_start       IN  DATE,
        p_result_date OUT DATE,
        p_status      OUT VARCHAR2,
        p_message     OUT VARCHAR2
    ) IS
        v_preprocessed VARCHAR2(500);
        v_date         DATE;
        v_upper_str    VARCHAR2(500);
    BEGIN
        p_status := 'S';

        IF p_date_str IS NULL THEN
            p_result_date := NULL;
            p_message := 'Input date string is NULL';
            RETURN;
        END IF;

        append_debug('parse_date_internal: input="' || p_date_str || '", format="' || p_format || '"');

        -- Handle special values FIRST (before any format-based parsing)
        v_upper_str := UPPER(TRIM(p_date_str));

        CASE v_upper_str
            WHEN 'TODAY' THEN
                p_result_date := TRUNC(SYSDATE);
                p_message := 'Special value TODAY converted to ' || TO_CHAR(p_result_date, 'YYYY-MM-DD');
                append_debug('Special value TODAY -> ' || TO_CHAR(p_result_date, 'YYYY-MM-DD'));
                RETURN;
            WHEN 'YESTERDAY' THEN
                p_result_date := TRUNC(SYSDATE) - 1;
                p_message := 'Special value YESTERDAY converted to ' || TO_CHAR(p_result_date, 'YYYY-MM-DD');
                append_debug('Special value YESTERDAY -> ' || TO_CHAR(p_result_date, 'YYYY-MM-DD'));
                RETURN;
            WHEN 'TOMORROW' THEN
                p_result_date := TRUNC(SYSDATE) + 1;
                p_message := 'Special value TOMORROW converted to ' || TO_CHAR(p_result_date, 'YYYY-MM-DD');
                append_debug('Special value TOMORROW -> ' || TO_CHAR(p_result_date, 'YYYY-MM-DD'));
                RETURN;
            WHEN 'N/A' THEN
                p_result_date := NULL;
                p_message := 'Special value N/A treated as NULL';
                append_debug('Special value N/A -> NULL');
                RETURN;
            WHEN 'NA' THEN
                p_result_date := NULL;
                p_message := 'Special value NA treated as NULL';
                append_debug('Special value NA -> NULL');
                RETURN;
            WHEN 'TBD' THEN
                p_result_date := NULL;
                p_message := 'Special value TBD treated as NULL';
                append_debug('Special value TBD -> NULL');
                RETURN;
            WHEN 'NULL' THEN
                p_result_date := NULL;
                p_message := 'Special value NULL treated as NULL';
                append_debug('Special value NULL -> NULL');
                RETURN;
            WHEN 'NONE' THEN
                p_result_date := NULL;
                p_message := 'Special value NONE treated as NULL';
                append_debug('Special value NONE -> NULL');
                RETURN;
            WHEN '-' THEN
                p_result_date := NULL;
                p_message := 'Special value - treated as NULL';
                append_debug('Special value - -> NULL');
                RETURN;
            WHEN '--' THEN
                p_result_date := NULL;
                p_message := 'Special value -- treated as NULL';
                append_debug('Special value -- -> NULL');
                RETURN;
            ELSE
                NULL; -- Continue with format-based parsing
        END CASE;

        -- Special handling for DY/DAY formats
        -- Oracle's TO_DATE doesn't work reliably with DY without year, so use fn_infer_year directly
        IF (p_format LIKE '%DY%' OR p_format LIKE '%DAY%') AND p_format NOT LIKE '%YYYY%' AND p_format NOT LIKE '%RR%' THEN
            -- DY format without year - use year inference which validates day names
            append_debug('DY format without year - using fn_infer_year');
            v_date := fn_infer_year(p_date_str, NVL(p_start, SYSDATE), p_format);
            IF v_date IS NOT NULL THEN
                p_result_date := v_date;
                p_message := 'Parsed with day name validation to ' || TO_CHAR(v_date, 'YYYY-MM-DD');
                append_debug('Parsed with day name validation: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));
            ELSE
                p_result_date := NULL;
                p_status := 'E';
                p_message := 'Failed to parse DY format with format ' || p_format;
                append_debug('DY parse failed');
            END IF;
            RETURN;
        END IF;

        -- Standard parsing for non-DY formats
        -- Preprocess the date string
        v_preprocessed := preprocess_date_sample(p_date_str);
        append_debug('Preprocessed: "' || v_preprocessed || '"');

        -- Try to parse
        v_date := fn_try_date(v_preprocessed, p_format);

        IF v_date IS NOT NULL THEN
            p_result_date := v_date;
            p_message := 'Successfully parsed to ' || TO_CHAR(v_date, 'YYYY-MM-DD');
            append_debug('Parsed successfully: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));
        ELSE
            -- Try stripping day name if present
            -- WORKAROUND: For DY/DAY formats with year, also strip day name from format mask
            IF (p_format LIKE '%DY%' OR p_format LIKE '%DAY%') AND (p_format LIKE '%YYYY%' OR p_format LIKE '%RR%') THEN
                -- Strip day name from value AND format mask
                v_date := fn_try_date(
                    strip_day_name(v_preprocessed),
                    -- Remove DY, DAY from format mask
                    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(p_format, 'DY, ', ''), 'DY ', ''), 'DAY, ', ''), 'DAY ', ''), ',  ', ' ')
                );
            ELSE
                -- Original logic for other formats
                v_date := fn_try_date(strip_day_name(v_preprocessed), p_format);
            END IF;

            IF v_date IS NOT NULL THEN
                p_result_date := v_date;
                p_message := 'Parsed (after stripping day name) to ' || TO_CHAR(v_date, 'YYYY-MM-DD');
                append_debug('Parsed after strip: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));
                RETURN;
            END IF;

            -- If not parsed yet, try year inference
            IF TRUE THEN
                -- Try year inference if no year in format
                IF p_format NOT LIKE '%YYYY%' AND p_format NOT LIKE '%RR%' AND p_start IS NOT NULL THEN
                    v_date := fn_infer_year(p_date_str, p_start, p_format);
                    IF v_date IS NOT NULL THEN
                        p_result_date := v_date;
                        p_message := 'Parsed (with year inference) to ' || TO_CHAR(v_date, 'YYYY-MM-DD');
                        append_debug('Parsed with year inference: ' || TO_CHAR(v_date, 'YYYY-MM-DD'));
                    ELSE
                        p_result_date := NULL;
                        p_status := 'E';
                        p_message := 'Failed to parse date with format ' || p_format;
                        append_debug('Parse failed');
                    END IF;
                ELSE
                    p_result_date := NULL;
                    p_status := 'E';
                    p_message := 'Failed to parse date with format ' || p_format;
                    append_debug('Parse failed');
                END IF;
            END IF;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            p_result_date := NULL;
            p_status := 'E';
            p_message := 'Parse error: ' || SQLERRM;
            append_debug('EXCEPTION: ' || SQLERRM);
    END parse_date_internal;

-- Main procedure body starts here
BEGIN
    -- Initialize outputs
    p_status := 'S';
    p_message := '';
    p_format_mask_out := NULL;
    p_confidence := 0;
    p_converted_date := NULL;
    p_has_year := 'Y';
    p_is_ambiguous := 'N';
    p_special_values := NULL;
    p_all_formats := NULL;

    append_debug('date_parser started - mode=' || p_mode);

    -- Mode dispatcher
    CASE UPPER(p_mode)
        WHEN 'DETECT' THEN
            append_debug('Entering DETECT mode');
            detect_format_internal(
                p_samples        => p_sample_values,
                p_min_confidence => p_min_confidence,
                p_format_mask    => p_format_mask_out,
                p_confidence     => p_confidence,
                p_has_year       => p_has_year,
                p_is_ambiguous   => p_is_ambiguous,
                p_special_values => p_special_values,
                p_all_formats    => p_all_formats,
                p_status         => p_status,
                p_message        => p_message
            );

            -- Add alerts based on results
            IF p_status = 'S' THEN
                IF p_confidence < p_min_confidence THEN
                    add_alert(
                        p_existing_json => p_alert_clob,
                        p_message       => 'Date format confidence (' || p_confidence ||
                                          '%) below threshold. Review format: ' || p_format_mask_out,
                        p_icon          => 'warning',
                        p_title         => 'Low Confidence Detection',
                        p_timeout       => NULL,
                        p_updated_json  => p_alert_clob
                    );
                END IF;

                IF p_is_ambiguous = 'Y' THEN
                    add_alert(
                        p_existing_json => p_alert_clob,
                        p_message       => 'Ambiguous date format (DD/MM vs MM/DD). Defaulting to European (DD/MM).',
                        p_icon          => 'info',
                        p_title         => 'Date Format Ambiguity',
                        p_timeout       => 5000,
                        p_updated_json  => p_alert_clob
                    );
                END IF;

                IF p_special_values IS NOT NULL THEN
                    add_alert(
                        p_existing_json => p_alert_clob,
                        p_message       => 'Special values detected: ' || p_special_values,
                        p_icon          => 'info',
                        p_title         => 'Special Date Values',
                        p_timeout       => 5000,
                        p_updated_json  => p_alert_clob
                    );
                END IF;
            ELSE
                add_alert(
                    p_existing_json => p_alert_clob,
                    p_message       => 'Unable to detect date format. Please specify manually.',
                    p_icon          => 'error',
                    p_title         => 'Format Detection Failed',
                    p_timeout       => NULL,
                    p_updated_json  => p_alert_clob
                );
            END IF;

        WHEN 'PARSE' THEN
            append_debug('Entering PARSE mode');
            parse_date_internal(
                p_date_str    => p_date_string,
                p_format      => p_format_mask,
                p_start       => p_start_date,
                p_result_date => p_converted_date,
                p_status      => p_status,
                p_message     => p_message
            );
            p_format_mask_out := p_format_mask;

        WHEN 'TEST' THEN
            append_debug('Entering TEST mode - running internal test suite');
            -- Test mode returns test results in p_message
            p_message := 'Test mode not yet implemented in UR_UTILS. Use test_date_parser procedure instead.';
            p_status := 'W';

        ELSE
            p_status := 'E';
            p_message := 'Invalid mode: ' || p_mode || '. Valid modes are: DETECT, PARSE, TEST';
            append_debug('ERROR: Invalid mode');
    END CASE;

    -- Append debug log to message if enabled
    IF UPPER(p_debug_flag) = 'Y' AND l_debug_log IS NOT NULL THEN
        p_message := p_message || CHR(10) ||
                     '--- DEBUG LOG ---' || CHR(10) || l_debug_log;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'date_parser error: ' || SQLERRM;
        IF UPPER(p_debug_flag) = 'Y' AND l_debug_log IS NOT NULL THEN
            p_message := p_message || CHR(10) ||
                         '--- DEBUG LOG ---' || CHR(10) || l_debug_log;
        END IF;
END date_parser;

-- Backend testing procedure
PROCEDURE test_date_parser(
    p_test_type    IN  VARCHAR2 DEFAULT 'ALL',
    p_debug_flag   IN  VARCHAR2 DEFAULT 'Y',
    p_result_json  OUT CLOB,
    p_status       OUT VARCHAR2,
    p_message      OUT VARCHAR2
) IS
    v_alert_clob     CLOB;
    v_format_mask    VARCHAR2(100);
    v_confidence     NUMBER;
    v_converted_date DATE;
    v_has_year       VARCHAR2(1);
    v_is_ambiguous   VARCHAR2(1);
    v_special_values VARCHAR2(500);
    v_all_formats    CLOB;
    v_test_status    VARCHAR2(1);
    v_test_message   VARCHAR2(4000);
    v_pass_count     NUMBER := 0;
    v_fail_count     NUMBER := 0;
    v_results        CLOB;

    PROCEDURE run_test(
        p_name     VARCHAR2,
        p_samples  CLOB,
        p_expected VARCHAR2
    ) IS
    BEGIN
        date_parser(
            p_mode            => 'DETECT',
            p_sample_values   => p_samples,
            p_debug_flag      => 'N',
            p_alert_clob      => v_alert_clob,
            p_format_mask_out => v_format_mask,
            p_confidence      => v_confidence,
            p_converted_date  => v_converted_date,
            p_has_year        => v_has_year,
            p_is_ambiguous    => v_is_ambiguous,
            p_special_values  => v_special_values,
            p_all_formats     => v_all_formats,
            p_status          => v_test_status,
            p_message         => v_test_message
        );

        IF v_test_status = 'S' AND (p_expected IS NULL OR v_format_mask = p_expected) THEN
            v_pass_count := v_pass_count + 1;
            v_results := v_results || '{"test":"' || p_name || '","status":"PASS","format":"' ||
                         v_format_mask || '","confidence":' || v_confidence || '},';
        ELSE
            v_fail_count := v_fail_count + 1;
            v_results := v_results || '{"test":"' || p_name || '","status":"FAIL","format":"' ||
                         NVL(v_format_mask, 'NULL') || '","expected":"' || NVL(p_expected, 'any') ||
                         '","message":"' || REPLACE(v_test_message, '"', '\"') || '"},';
        END IF;
    END run_test;

BEGIN
    p_status := 'S';
    v_results := '[';

    -- Run test suite based on test type
    IF p_test_type IN ('ALL', 'DETECT') THEN
        run_test('ISO Format', '["2024-11-27", "2024-12-15", "2025-01-01"]', 'YYYY-MM-DD');
        run_test('Oracle Standard', '["27-Nov-2024", "15-Dec-2024", "01-Jan-2025"]', 'DD-MON-YYYY');
        run_test('European Numeric', '["27/11/2024", "15/12/2024", "01/01/2025"]', NULL);
        run_test('Day Name Format', '["Fri 27-Nov-2024", "Sun 15-Dec-2024", "Wed 01-Jan-2025"]', NULL);
        run_test('Full Month Name', '["27 November 2024", "15 December 2024", "01 January 2025"]', 'DD MONTH YYYY');
        run_test('No Year', '["27-Nov", "15-Dec", "01-Jan"]', 'DD-MON');
        run_test('Text Numbers', '["sixteen November 2024", "twenty-first December 2024"]', NULL);
        run_test('With Special Values', '["27-Nov-2024", "TODAY", "N/A", "15-Dec-2024"]', 'DD-MON-YYYY');
        run_test('US Disambiguated', '["12/27/2024", "12/15/2024", "01/05/2025"]', NULL);
        run_test('Ambiguous', '["01/02/2024", "05/06/2024", "08/09/2024"]', NULL);
    END IF;

    -- Remove trailing comma and close array
    IF LENGTH(v_results) > 1 THEN
        v_results := RTRIM(v_results, ',');
    END IF;
    v_results := v_results || ']';

    -- Build result JSON
    p_result_json := '{"passed":' || v_pass_count ||
                     ',"failed":' || v_fail_count ||
                     ',"total":' || (v_pass_count + v_fail_count) ||
                     ',"tests":' || v_results || '}';

    p_message := 'Test complete: ' || v_pass_count || ' passed, ' || v_fail_count || ' failed';

    IF v_fail_count > 0 THEN
        p_status := 'W';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'Test error: ' || SQLERRM;
        p_result_json := '{"error":"' || REPLACE(SQLERRM, '"', '\"') || '"}';
END test_date_parser;
    --------------------------------------------------------------------------------
    -- CALCULATED ATTRIBUTES HELPER FUNCTIONS
    --------------------------------------------------------------------------------

    -- Safe conversion to number - returns NULL if conversion fails
    FUNCTION safe_to_number(p_value IN VARCHAR2) RETURN NUMBER IS
    BEGIN
        IF p_value IS NULL THEN
            RETURN NULL;
        END IF;
        RETURN TO_NUMBER(p_value);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END safe_to_number;

    -- Safe division - returns NULL if denominator is 0 or NULL
    FUNCTION safe_divide(p_numerator IN NUMBER, p_denominator IN NUMBER) RETURN NUMBER IS
    BEGIN
        IF p_denominator IS NULL OR p_denominator = 0 THEN
            RETURN NULL;
        END IF;
        IF p_numerator IS NULL THEN
            RETURN NULL;
        END IF;
        RETURN p_numerator / p_denominator;
    END safe_divide;

    -- Evaluate a mathematical expression string safely
    FUNCTION evaluate_expression(
        p_expression IN VARCHAR2
    ) RETURN NUMBER IS
        l_result NUMBER;
        l_safe_expr VARCHAR2(4000);
    BEGIN
        IF p_expression IS NULL THEN
            RETURN NULL;
        END IF;

        -- Check if expression contains NULL (cannot evaluate)
        IF INSTR(UPPER(p_expression), 'NULL') > 0 THEN
            RETURN NULL;
        END IF;

        -- Validate expression safety - only allow numbers, operators, parentheses, and math functions
        -- Note: Put minus sign at the end of character class to avoid it being interpreted as a range
        l_safe_expr := REGEXP_REPLACE(p_expression, '[0-9\.\+\*\/\(\)\s\-]', '');
        l_safe_expr := REGEXP_REPLACE(l_safe_expr, '(ROUND|ABS|CEIL|FLOOR|TRUNC)', '', 1, 0, 'i');
        l_safe_expr := TRIM(l_safe_expr);

        IF l_safe_expr IS NOT NULL AND LENGTH(l_safe_expr) > 0 THEN
            -- Expression contains unsafe characters
            DBMS_OUTPUT.PUT_LINE('EVALUATE_EXPRESSION: Unsafe characters detected: [' || l_safe_expr || '] in expression: ' || p_expression);
            RETURN NULL;
        END IF;

        -- Execute the expression
        EXECUTE IMMEDIATE 'SELECT ' || p_expression || ' FROM DUAL' INTO l_result;
        RETURN l_result;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('EVALUATE_EXPRESSION: Error evaluating [' || p_expression || ']: ' || SQLERRM);
            RETURN NULL;
    END evaluate_expression;

    -- Get events for a specific hotel and stay date
    FUNCTION get_events_for_date(
        p_hotel_id  IN RAW,
        p_stay_date IN DATE
    ) RETURN VARCHAR2 IS
        l_result VARCHAR2(4000);
    BEGIN
        SELECT LISTAGG(
            EVENT_NAME || ' (' || NVL(EVENT_FREQUENCY, 'N/A') || ', ' ||
            NVL(TO_CHAR(safe_to_number(IMPACT_TYPE) * safe_to_number(IMPACT_LEVEL)), 'N/A') || ')',
            ', '
        ) WITHIN GROUP (ORDER BY EVENT_NAME)
        INTO l_result
        FROM UR_EVENTS
        WHERE HOTEL_ID = p_hotel_id
          AND p_stay_date BETWEEN EVENT_START_DATE AND EVENT_END_DATE;

        RETURN l_result;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
            RETURN NULL;
    END get_events_for_date;

    -- Validate calculated formula syntax and check for circular dependencies
    FUNCTION validate_calculated_formula(
        p_formula       IN VARCHAR2,
        p_attribute_key IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 IS
        l_ref_count     NUMBER := 0;
        l_open_count    NUMBER := 0;
        l_close_count   NUMBER := 0;
        l_pos           NUMBER := 1;
        l_ref_key       VARCHAR2(200);
        l_ref_exists    NUMBER;
        l_formula_copy  VARCHAR2(4000);
    BEGIN
        IF p_formula IS NULL THEN
            RETURN 'Formula cannot be NULL';
        END IF;

        -- Check balanced # delimiters
        l_formula_copy := p_formula;
        l_open_count := LENGTH(p_formula) - LENGTH(REPLACE(p_formula, '#', ''));
        IF MOD(l_open_count, 2) != 0 THEN
            RETURN 'Unbalanced # delimiters in formula';
        END IF;

        -- Check for self-reference (circular dependency)
        IF p_attribute_key IS NOT NULL AND INSTR(UPPER(p_formula), '#' || UPPER(p_attribute_key) || '#') > 0 THEN
            RETURN 'Circular dependency detected: formula references itself';
        END IF;

        -- Validate all referenced attributes exist (for non-table references)
        LOOP
            l_ref_key := REGEXP_SUBSTR(p_formula, '#([^#]+)#', l_pos, 1, NULL, 1);
            EXIT WHEN l_ref_key IS NULL;

            -- Skip table.column references (e.g., UR_HOTELS.CAPACITY)
            IF INSTR(l_ref_key, '.') = 0 THEN
                -- This is an attribute reference, check if it exists
                SELECT COUNT(*) INTO l_ref_exists
                FROM ur_algo_attributes
                WHERE UPPER(KEY) = UPPER(l_ref_key);

                IF l_ref_exists = 0 THEN
                    RETURN 'Referenced attribute not found: ' || l_ref_key;
                END IF;
            END IF;

            l_pos := REGEXP_INSTR(p_formula, '#', l_pos, 2) + 1;
            l_ref_count := l_ref_count + 1;

            -- Safety limit
            IF l_ref_count > 50 THEN
                RETURN 'Formula has too many references (max 50)';
            END IF;
        END LOOP;

        -- Validate operators are safe
        l_formula_copy := p_formula;
        -- Remove all valid elements
        l_formula_copy := REGEXP_REPLACE(l_formula_copy, '#[^#]+#', ''); -- Remove references
        l_formula_copy := REGEXP_REPLACE(l_formula_copy, '[0-9\.\+\-\*\/\(\)\s,]', ''); -- Remove operators/numbers
        l_formula_copy := REGEXP_REPLACE(l_formula_copy, '(ROUND|ABS|CEIL|FLOOR|TRUNC|NVL|COALESCE)', '', 1, 0, 'i'); -- Remove allowed functions
        l_formula_copy := TRIM(l_formula_copy);

        IF l_formula_copy IS NOT NULL AND LENGTH(l_formula_copy) > 0 THEN
            RETURN 'Formula contains invalid characters or functions: ' || l_formula_copy;
        END IF;

        RETURN NULL; -- Valid
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Validation error: ' || SQLERRM;
    END validate_calculated_formula;

    -- Check for circular dependencies using DFS
    FUNCTION has_circular_dependency(
        p_attribute_key IN VARCHAR2,
        p_formula       IN VARCHAR2,
        p_visited       IN VARCHAR2 DEFAULT NULL,
        p_depth         IN NUMBER DEFAULT 0
    ) RETURN BOOLEAN IS
        l_pos           NUMBER := 1;
        l_ref_key       VARCHAR2(200);
        l_ref_formula   VARCHAR2(4000);
        l_visited       VARCHAR2(4000);
        l_has_cycle     BOOLEAN := FALSE;
    BEGIN
        -- Prevent infinite recursion
        IF p_depth > 10 THEN
            RETURN TRUE;
        END IF;

        l_visited := NVL(p_visited, '') || '|' || UPPER(p_attribute_key) || '|';

        -- Check each reference in the formula
        LOOP
            l_ref_key := REGEXP_SUBSTR(p_formula, '#([^#]+)#', l_pos, 1, NULL, 1);
            EXIT WHEN l_ref_key IS NULL;

            -- Skip table.column references
            IF INSTR(l_ref_key, '.') = 0 THEN
                -- Check if this reference creates a cycle
                IF INSTR(l_visited, '|' || UPPER(l_ref_key) || '|') > 0 THEN
                    RETURN TRUE;
                END IF;

                -- Get the formula of the referenced attribute and recurse
                BEGIN
                    SELECT VALUE INTO l_ref_formula
                    FROM ur_algo_attributes
                    WHERE UPPER(KEY) = UPPER(l_ref_key)
                      AND TYPE = 'C';

                    IF l_ref_formula IS NOT NULL THEN
                        l_has_cycle := has_circular_dependency(l_ref_key, l_ref_formula, l_visited, p_depth + 1);
                        IF l_has_cycle THEN
                            RETURN TRUE;
                        END IF;
                    END IF;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL; -- Not a calculated attribute, no cycle possible from here
                END;
            END IF;

            l_pos := REGEXP_INSTR(p_formula, '#', l_pos, 2) + 1;
        END LOOP;

        RETURN FALSE;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN TRUE; -- Assume circular on error
    END has_circular_dependency;

    --------------------------------------------------------------------------------
    -- PROCEDURE: manage_calculated_attributes
    -- Purpose: Create, Update, Delete template-agnostic calculated attributes
    --------------------------------------------------------------------------------
    PROCEDURE manage_calculated_attributes(
        p_mode              IN  CHAR,
        p_attribute_key     IN  VARCHAR2 DEFAULT NULL,
        p_attribute_name    IN  VARCHAR2 DEFAULT NULL,
        p_formula           IN  VARCHAR2 DEFAULT NULL,
        p_data_type         IN  VARCHAR2 DEFAULT 'NUMBER',
        p_description       IN  VARCHAR2 DEFAULT NULL,
        p_hotel_id          IN  RAW DEFAULT NULL,
        p_qualifier         IN  VARCHAR2 DEFAULT NULL,
        p_source_table      IN  VARCHAR2 DEFAULT NULL,
        p_source_config     IN  CLOB DEFAULT NULL,
        p_delete_all_hotel  IN  BOOLEAN DEFAULT FALSE,
        p_status            OUT BOOLEAN,
        p_message           OUT VARCHAR2
    ) IS
        v_user_id           RAW(16);
        v_exists            NUMBER;
        v_validation_error  VARCHAR2(4000);
        v_insert_count      NUMBER := 0;
        v_delete_count      NUMBER := 0;
        v_attr_value        VARCHAR2(4000);
    BEGIN
        p_status := FALSE;
        p_message := NULL;

        -- Get current user ID
        BEGIN
            SELECT USER_ID INTO v_user_id
            FROM UR_USERS
            WHERE USER_NAME = SYS_CONTEXT('APEX$SESSION', 'APP_USER');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_user_id := NULL;
        END;

        -- MODE: CREATE
        IF p_mode = 'C' THEN
            -- Validate required parameters
            IF p_attribute_key IS NULL THEN
                p_message := 'Failure: p_attribute_key is required for Create mode';
                RETURN;
            END IF;

            IF p_attribute_name IS NULL THEN
                p_message := 'Failure: p_attribute_name is required for Create mode';
                RETURN;
            END IF;

            -- Check if attribute already exists
            SELECT COUNT(*) INTO v_exists FROM ur_algo_attributes WHERE UPPER(KEY) = UPPER(p_attribute_key);
            IF v_exists > 0 THEN
                p_message := 'Failure: Attribute with key ' || p_attribute_key || ' already exists';
                RETURN;
            END IF;

            -- Validate formula if provided
            IF p_formula IS NOT NULL THEN
                v_validation_error := validate_calculated_formula(p_formula, p_attribute_key);
                IF v_validation_error IS NOT NULL THEN
                    p_message := 'Failure: ' || v_validation_error;
                    RETURN;
                END IF;

                -- Check for circular dependencies
                IF has_circular_dependency(p_attribute_key, p_formula) THEN
                    p_message := 'Failure: Circular dependency detected in formula';
                    RETURN;
                END IF;

                v_attr_value := p_formula;
            ELSIF p_source_table IS NOT NULL THEN
                -- For direct table lookups, store source config as value
                v_attr_value := p_source_config;
            ELSE
                p_message := 'Failure: Either p_formula or p_source_table must be provided';
                RETURN;
            END IF;

            -- Insert the calculated attribute
            INSERT INTO ur_algo_attributes (
                id, algo_id, hotel_id, name, key, data_type, description,
                type, value, template_id, attribute_qualifier,
                created_by, updated_by, created_on, updated_on
            ) VALUES (
                SYS_GUID(),
                NULL,
                p_hotel_id,
                p_attribute_name,
                p_attribute_key,
                NVL(UPPER(p_data_type), 'NUMBER'),
                p_description,
                'C',  -- Calculated type
                v_attr_value,
                NULL, -- Template agnostic
                p_qualifier,
                v_user_id, v_user_id, SYSDATE, SYSDATE
            );

            COMMIT;
            p_status := TRUE;
            p_message := 'Success: Calculated attribute ' || p_attribute_key || ' created successfully';

        -- MODE: UPDATE
        ELSIF p_mode = 'U' THEN
            IF p_attribute_key IS NULL THEN
                p_message := 'Failure: p_attribute_key is required for Update mode';
                RETURN;
            END IF;

            -- Check if attribute exists
            SELECT COUNT(*) INTO v_exists FROM ur_algo_attributes
            WHERE UPPER(KEY) = UPPER(p_attribute_key) AND TYPE = 'C';

            IF v_exists = 0 THEN
                p_message := 'Failure: Calculated attribute with key ' || p_attribute_key || ' not found';
                RETURN;
            END IF;

            -- Validate new formula if provided
            IF p_formula IS NOT NULL THEN
                v_validation_error := validate_calculated_formula(p_formula, p_attribute_key);
                IF v_validation_error IS NOT NULL THEN
                    p_message := 'Failure: ' || v_validation_error;
                    RETURN;
                END IF;

                IF has_circular_dependency(p_attribute_key, p_formula) THEN
                    p_message := 'Failure: Circular dependency detected in formula';
                    RETURN;
                END IF;
            END IF;

            -- Update the attribute
            UPDATE ur_algo_attributes
            SET name = NVL(p_attribute_name, name),
                value = NVL(p_formula, NVL(p_source_config, value)),
                data_type = NVL(UPPER(p_data_type), data_type),
                description = NVL(p_description, description),
                attribute_qualifier = NVL(p_qualifier, attribute_qualifier),
                updated_by = v_user_id,
                updated_on = SYSDATE
            WHERE UPPER(KEY) = UPPER(p_attribute_key) AND TYPE = 'C';

            COMMIT;
            p_status := TRUE;
            p_message := 'Success: Calculated attribute ' || p_attribute_key || ' updated successfully';

        -- MODE: DELETE
        ELSIF p_mode = 'D' THEN
            -- Delete all calculated attributes for a hotel
            IF p_delete_all_hotel AND p_hotel_id IS NOT NULL THEN
                DELETE FROM ur_algo_attributes
                WHERE hotel_id = p_hotel_id AND TYPE = 'C' AND template_id IS NULL;

                v_delete_count := SQL%ROWCOUNT;
                COMMIT;
                p_status := TRUE;
                p_message := 'Success: ' || v_delete_count || ' calculated attribute(s) deleted for hotel';
                RETURN;
            END IF;

            -- Delete specific attribute
            IF p_attribute_key IS NOT NULL THEN
                -- Check if attribute is referenced by other calculated attributes
                SELECT COUNT(*) INTO v_exists
                FROM ur_algo_attributes
                WHERE TYPE = 'C'
                  AND UPPER(VALUE) LIKE '%#' || UPPER(p_attribute_key) || '#%'
                  AND UPPER(KEY) != UPPER(p_attribute_key);

                IF v_exists > 0 THEN
                    p_message := 'Failure: Cannot delete attribute ' || p_attribute_key ||
                                 ' - it is referenced by ' || v_exists || ' other calculated attribute(s)';
                    RETURN;
                END IF;

                DELETE FROM ur_algo_attributes
                WHERE UPPER(KEY) = UPPER(p_attribute_key) AND TYPE = 'C';

                v_delete_count := SQL%ROWCOUNT;
                COMMIT;

                IF v_delete_count > 0 THEN
                    p_status := TRUE;
                    p_message := 'Success: Calculated attribute ' || p_attribute_key || ' deleted';
                ELSE
                    p_message := 'Info: No calculated attribute found with key ' || p_attribute_key;
                END IF;
            ELSE
                p_message := 'Failure: Either p_attribute_key or (p_delete_all_hotel and p_hotel_id) required for Delete mode';
            END IF;

        ELSE
            p_message := 'Failure: Invalid mode ' || p_mode || '. Valid modes are C (Create), U (Update), D (Delete)';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_status := FALSE;
            p_message := 'Failure: ' || SQLERRM;
    END manage_calculated_attributes;

    --------------------------------------------------------------------------------
    -- PROCEDURE: create_hotel_calculated_attributes
    -- Purpose: Create all 5 predefined calculated attributes for a new hotel
    --------------------------------------------------------------------------------
  PROCEDURE create_hotel_calculated_attributes(
        p_hotel_id  IN  RAW,
        p_mode      IN Varchar2,
        p_status    OUT BOOLEAN,
        p_message   OUT VARCHAR2
    ) IS
    --PRAGMA AUTONOMOUS_TRANSACTION;
        v_user_id       RAW(16);
        v_key_prefix    VARCHAR2(50);
        v_insert_count  NUMBER := 0;
         v_delete_count  NUMBER := 0;
    BEGIN
        p_status := FALSE;
        p_message := NULL;

        IF p_hotel_id IS NULL THEN
            p_message := 'Failure: p_hotel_id is required';
            RETURN;
        END IF;

        -- Get current user ID
        BEGIN
            SELECT USER_ID INTO v_user_id
            FROM UR_USERS
            WHERE USER_NAME = SYS_CONTEXT('APEX$SESSION', 'APP_USER');
           

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_user_id := NULL;
        END;

        -- Use hotel ID as key prefix
        v_key_prefix := RAWTOHEX(p_hotel_id);

        ---------------------------------------------------------------------
    --  MODE : CREATE (Insert all 5 default attributes)
    ---------------------------------------------------------------------
    IF UPPER(p_mode) = 'CREATE' THEN

        -- 1. Insert OCCUPANCY attribute
        INSERT INTO ur_algo_attributes (
            id, algo_id, hotel_id, name, key, data_type, description,
            type, value, template_id, attribute_qualifier,
            created_by, updated_by, created_on, updated_on
        ) VALUES (
            SYS_GUID(), NULL, p_hotel_id,
            'Occupancy',
            v_key_prefix || '.OCCUPANCY',
            'NUMBER',
            'Daily occupancy percentage (rooms sold / available rooms)',
            'C',
            'ROUND((#ROOM_NIGHTS# / (#UR_HOTELS.CAPACITY# - #OUT_OF_ORDER_ROOMS#)) * 100)',
            NULL,
            'CALCULATED_OCCUPANCY',
            v_user_id, v_user_id, SYSDATE, SYSDATE
        );
        v_insert_count := v_insert_count + 1;

        -- 2. Insert PUBLIC_PRICE_OVERRIDE attribute
        INSERT INTO ur_algo_attributes (
            id, algo_id, hotel_id, name, key, data_type, description,
            type, value, template_id, attribute_qualifier,
            created_by, updated_by, created_on, updated_on
        ) VALUES (
            SYS_GUID(), NULL, p_hotel_id,
            'Public Price Override',
            v_key_prefix || '.PUBLIC_PRICE_OVERRIDE',
            'NUMBER',
            'Overridden public room price for specific dates',
            'C',
            '{"type": "Public", "status": "A"}',
            NULL,
            'PRICE_OVERRIDE_PUBLIC',
            v_user_id, v_user_id, SYSDATE, SYSDATE
        );
        v_insert_count := v_insert_count + 1;

        -- 3. Insert CORPORATE_PRICE_OVERRIDE attribute
        INSERT INTO ur_algo_attributes (
            id, algo_id, hotel_id, name, key, data_type, description,
            type, value, template_id, attribute_qualifier,
            created_by, updated_by, created_on, updated_on
        ) VALUES (
            SYS_GUID(), NULL, p_hotel_id,
            'Corporate Price Override',
            v_key_prefix || '.CORPORATE_PRICE_OVERRIDE',
            'NUMBER',
            'Overridden corporate room price for specific dates',
            'C',
            '{"type": "Corporate", "status": "A"}',
            NULL,
            'PRICE_OVERRIDE_CORPORATE',
            v_user_id, v_user_id, SYSDATE, SYSDATE
        );
        v_insert_count := v_insert_count + 1;

        -- 4. Insert GROUP_PRICE_OVERRIDE attribute
        INSERT INTO ur_algo_attributes (
            id, algo_id, hotel_id, name, key, data_type, description,
            type, value, template_id, attribute_qualifier,
            created_by, updated_by, created_on, updated_on
        ) VALUES (
            SYS_GUID(), NULL, p_hotel_id,
            'Group Price Override',
            v_key_prefix || '.GROUP_PRICE_OVERRIDE',
            'NUMBER',
            'Overridden group room price for specific dates',
            'C',
            '{"type": "Group", "status": "A"}',
            NULL,
            'PRICE_OVERRIDE_GROUP',
            v_user_id, v_user_id, SYSDATE, SYSDATE
        );
        v_insert_count := v_insert_count + 1;

        -- 5. Insert HOTEL_EVENTS attribute
        INSERT INTO ur_algo_attributes (
            id, algo_id, hotel_id, name, key, data_type, description,
            type, value, template_id, attribute_qualifier,
            created_by, updated_by, created_on, updated_on
        ) VALUES (
            SYS_GUID(), NULL, p_hotel_id,
            'Hotel Events',
            v_key_prefix || '.HOTEL_EVENTS',
            'VARCHAR2',
            'Events affecting hotel on each stay date',
            'C',
            NULL, -- Events are fetched directly from UR_EVENTS table
            NULL,
            'EVENTS',
            v_user_id, v_user_id, SYSDATE, SYSDATE
        );
        v_insert_count := v_insert_count + 1;

       -- COMMIT;
        p_status := TRUE;
        p_message := 'Success: ' || v_insert_count || ' calculated attributes created for hotel ' || v_key_prefix;

         ---------------------------------------------------------------------
    --  MODE : DELETE 
    ---------------------------------------------------------------------
    ELSIF UPPER(p_mode) = 'DELETE' THEN

        DELETE FROM ur_algo_attributes
         WHERE hotel_id = p_hotel_id AND TYPE = 'C' AND template_id IS NULL;

        v_delete_count := SQL%ROWCOUNT;

        p_status  := TRUE;
        p_message := 'Success: ' || v_delete_count || ' attributes deleted';

    ---------------------------------------------------------------------
    ELSE
        p_status  := FALSE;
        p_message := 'Invalid mode: ' || p_mode;
    END IF;

    EXCEPTION
        WHEN OTHERS THEN
            --ROLLBACK;
            p_status := FALSE;
            p_message := 'Failure: ' || SQLERRM;
    END create_hotel_calculated_attributes;

    -- ============================================================================
    -- PROCEDURE: refresh_file_profile_and_collection
    -- ============================================================================
    PROCEDURE refresh_file_profile_and_collection (
        p_file_name             IN  VARCHAR2,
        p_skip_rows             IN  NUMBER   DEFAULT 0,
        p_sheet_name            IN  VARCHAR2 DEFAULT NULL,
        p_collection_name       IN  VARCHAR2 DEFAULT 'UR_FILE_DATA_PROFILES',
        p_status                OUT VARCHAR2,
        p_message               OUT VARCHAR2
    ) AS
        v_blob            BLOB;
        v_filename        VARCHAR2(400);
        v_file_type       NUMBER;
        v_profile_clob    CLOB;
        v_records         NUMBER;
        v_columns         CLOB;
        v_file_id         NUMBER;
        v_effective_sheet VARCHAR2(200);
        v_col_count       NUMBER := 0;
        v_step            VARCHAR2(100);
    BEGIN
        p_status  := 'S';
        p_message := '';

        ----------------------------------------------------------------------
        -- Step 1: Validate input parameters
        ----------------------------------------------------------------------
        v_step := 'Parameter Validation';

        IF p_file_name IS NULL OR TRIM(p_file_name) IS NULL THEN
            p_status  := 'E';
            p_message := 'File name parameter is required.';
            RETURN;
        END IF;

        IF p_skip_rows < 0 THEN
            p_status  := 'E';
            p_message := 'Skip rows cannot be negative. Provided: ' || p_skip_rows;
            RETURN;
        END IF;

        ----------------------------------------------------------------------
        -- Step 2: Check file exists in temp_blob
        ----------------------------------------------------------------------
        v_step := 'File Lookup';

        BEGIN
            SELECT id, blob_content, filename
              INTO v_file_id, v_blob, v_filename
              FROM temp_blob
             WHERE name = p_file_name;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_status  := 'E';
                p_message := 'File not found in temp_blob: ' || p_file_name;
                RETURN;
            WHEN TOO_MANY_ROWS THEN
                p_status  := 'E';
                p_message := 'Multiple files found with same name: ' || p_file_name;
                RETURN;
        END;

        IF v_blob IS NULL OR DBMS_LOB.GETLENGTH(v_blob) = 0 THEN
            p_status  := 'E';
            p_message := 'File content is empty. File ID: ' || v_file_id;
            RETURN;
        END IF;

        ----------------------------------------------------------------------
        -- Step 3: Detect file type (1=Excel, 2=CSV)
        ----------------------------------------------------------------------
        v_step := 'File Type Detection';

        BEGIN
            v_file_type := apex_data_parser.get_file_type(p_file_name => v_filename);
        EXCEPTION
            WHEN OTHERS THEN
                p_status  := 'E';
                p_message := 'Failed to detect file type: ' || v_filename || '. ' || SQLERRM;
                RETURN;
        END;

        IF v_file_type NOT IN (1, 2, 3, 4) THEN
            p_status  := 'E';
            p_message := 'Unsupported file type. File: ' || v_filename || ', Type: ' || NVL(TO_CHAR(v_file_type), 'NULL');
            RETURN;
        END IF;

        ----------------------------------------------------------------------
        -- Step 4: Determine effective sheet name (Excel files only, type=1)
        ----------------------------------------------------------------------
        v_step := 'Sheet Name Resolution';

        IF v_file_type = 1 THEN  -- Excel (XLSX/XLS)
            IF p_sheet_name IS NOT NULL AND TRIM(p_sheet_name) IS NOT NULL THEN
                -- Validate provided sheet exists
                DECLARE
                    v_sheet_exists NUMBER;
                BEGIN
                    SELECT COUNT(*)
                      INTO v_sheet_exists
                      FROM TABLE(apex_data_parser.get_xlsx_worksheets(p_content => v_blob))
                     WHERE sheet_file_name = p_sheet_name;

                    IF v_sheet_exists = 0 THEN
                        p_status  := 'E';
                        p_message := 'Sheet not found in workbook: ' || p_sheet_name;
                        RETURN;
                    END IF;

                    v_effective_sheet := p_sheet_name;
                EXCEPTION
                    WHEN OTHERS THEN
                        p_status  := 'E';
                        p_message := 'Failed to validate sheet: ' || SQLERRM;
                        RETURN;
                END;
            ELSE
                -- Default to first sheet
                BEGIN
                    SELECT MIN(sheet_file_name) KEEP (DENSE_RANK FIRST ORDER BY sheet_sequence)
                      INTO v_effective_sheet
                      FROM TABLE(apex_data_parser.get_xlsx_worksheets(p_content => v_blob));

                    IF v_effective_sheet IS NULL THEN
                        p_status  := 'E';
                        p_message := 'No worksheets found in Excel file.';
                        RETURN;
                    END IF;
                EXCEPTION
                    WHEN OTHERS THEN
                        p_status  := 'E';
                        p_message := 'Failed to get worksheets: ' || SQLERRM;
                        RETURN;
                END;
            END IF;
        ELSE
            -- CSV/XML/JSON (type 2, 3, 4) - no sheet concept
            v_effective_sheet := NULL;
        END IF;

        ----------------------------------------------------------------------
        -- Step 5: Get file profile using discover()
        ----------------------------------------------------------------------
        v_step := 'Profile Discovery';

        BEGIN
            SELECT apex_data_parser.discover(
                       p_content         => v_blob,
                       p_file_name       => v_filename,
                       p_skip_rows       => p_skip_rows,
                       p_xlsx_sheet_name => v_effective_sheet,
                       p_max_rows        => null
                   )
              INTO v_profile_clob
              FROM dual;
        EXCEPTION
            WHEN OTHERS THEN
                p_status  := 'E';
                p_message := 'Profile discovery failed. Skip: ' || p_skip_rows ||
                             ', Sheet: ' || NVL(v_effective_sheet, 'N/A') || '. ' || SQLERRM;
                RETURN;
        END;

        IF v_profile_clob IS NULL THEN
            p_status  := 'E';
            p_message := 'Profile discovery returned NULL.';
            RETURN;
        END IF;

        ----------------------------------------------------------------------
        -- Step 6: Extract parsed row count
        ----------------------------------------------------------------------
        v_step := 'Row Count Extraction';

        BEGIN
            SELECT TO_NUMBER(JSON_VALUE(v_profile_clob, '$."parsed-rows"'))
              INTO v_records
              FROM dual;
        EXCEPTION
            WHEN OTHERS THEN
                v_records := 0;
        END;

        IF v_records = 0 AND p_skip_rows > 0 THEN
            p_status  := 'E';
            p_message := 'No data rows found. Skip rows (' || p_skip_rows || ') may exceed file row count.';
            RETURN;
        END IF;

        ----------------------------------------------------------------------
        -- Step 7: Build columns JSON
        ----------------------------------------------------------------------
        v_step := 'Column Extraction';

        BEGIN
            SELECT JSON_ARRAYAGG(
                       JSON_OBJECT(
                           'name'      VALUE jt.name,
                           'data-type' VALUE CASE jt.data_type
                                                 WHEN 1 THEN 'TEXT'
                                                 WHEN 2 THEN 'NUMBER'
                                                 WHEN 3 THEN 'DATE'
                                                 ELSE 'TEXT'
                                             END,
                           'pos'       VALUE jt.col_position
                       )
                       RETURNING CLOB
                   )
              INTO v_columns
              FROM JSON_TABLE(
                       v_profile_clob,
                       '$."columns"[*]'
                       COLUMNS (
                           name          VARCHAR2(200) PATH '$.name',
                           data_type     NUMBER        PATH '$."data-type"',
                           col_position  NUMBER        PATH '$."column-position"'
                       )
                   ) jt;
        EXCEPTION
            WHEN OTHERS THEN
                p_status  := 'E';
                p_message := 'Failed to extract columns: ' || SQLERRM;
                RETURN;
        END;

        IF v_columns IS NULL OR v_columns = '[]' THEN
            p_status  := 'E';
            p_message := 'No columns found in file profile.';
            RETURN;
        END IF;

        ----------------------------------------------------------------------
        -- Step 8: Update temp_blob
        ----------------------------------------------------------------------
        v_step := 'Update temp_blob';

        BEGIN
            UPDATE temp_blob
               SET profile = v_profile_clob,
                   records = v_records,
                   columns = v_columns
             WHERE id = v_file_id;

            IF SQL%ROWCOUNT = 0 THEN
                p_status  := 'E';
                p_message := 'Failed to update temp_blob. File ID: ' || v_file_id;
                ROLLBACK;
                RETURN;
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_status  := 'E';
                p_message := 'temp_blob update error: ' || SQLERRM;
                ROLLBACK;
                RETURN;
        END;

        ----------------------------------------------------------------------
        -- Step 9: Manage collection
        ----------------------------------------------------------------------
        v_step := 'Collection Management';

        BEGIN
            IF apex_collection.collection_exists(p_collection_name) THEN
                apex_collection.truncate_collection(p_collection_name);
            ELSE
                apex_collection.create_collection(p_collection_name);
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                p_status  := 'E';
                p_message := 'Collection error (' || p_collection_name || '): ' || SQLERRM;
                ROLLBACK;
                RETURN;
        END;

        ----------------------------------------------------------------------
        -- Step 10: Populate collection
        ----------------------------------------------------------------------
        v_step := 'Collection Population';

        BEGIN
            FOR col IN (
                SELECT jt.name,
                       jt.data_type,
                       jt.col_position
                  FROM JSON_TABLE(
                           v_columns,
                           '$[*]'
                           COLUMNS (
                               name         VARCHAR2(200) PATH '$.name',
                               data_type    VARCHAR2(20)  PATH '$."data-type"',
                               col_position NUMBER        PATH '$.pos'
                           )
                       ) jt
                 ORDER BY jt.col_position
            ) LOOP
                apex_collection.add_member(
                    p_collection_name => p_collection_name,
                    p_c001            => sanitize_column_name(col.name),
                    p_c002            => col.data_type,
                    p_n001            => col.col_position
                );
                v_col_count := v_col_count + 1;
            END LOOP;
        EXCEPTION
            WHEN OTHERS THEN
                p_status  := 'E';
                p_message := 'Failed to populate collection: ' || SQLERRM;
                ROLLBACK;
                RETURN;
        END;

        IF v_col_count = 0 THEN
            p_status  := 'E';
            p_message := 'No columns added to collection.';
            ROLLBACK;
            RETURN;
        END IF;

        ----------------------------------------------------------------------
        -- Success
        ----------------------------------------------------------------------
        COMMIT;

        p_status  := 'S';
        p_message := 'Profile refreshed. ' ||
                     'Type: ' || CASE v_file_type WHEN 1 THEN 'Excel' WHEN 2 THEN 'CSV' ELSE 'Other' END ||
                     ', Sheet: ' || NVL(v_effective_sheet, 'N/A') ||
                     ', Skip: ' || p_skip_rows ||
                     ', Rows: ' || v_records ||
                     ', Cols: ' || v_col_count;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            p_status  := 'E';
            p_message := 'Error at [' || v_step || ']: ' || SQLERRM;
    END refresh_file_profile_and_collection;

PROCEDURE Load_Data_V2 (
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
    l_insert_cnt  NUMBER := 0;  -- Track INSERT operations (WHEN NOT MATCHED)
    l_update_cnt  NUMBER := 0;  -- Track UPDATE operations (WHEN MATCHED)
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
        orig_col    VARCHAR2(32000),
        format_mask VARCHAR2(100)
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

    -- Template metadata for file parsing
    v_file_type              NUMBER;
    v_skip_rows              NUMBER;
    v_sheet_file_name        VARCHAR2(200);
    v_sheet_display_name     VARCHAR2(200);
    v_matched_sheet_file_name VARCHAR2(200);
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

    -- 2. Get target table name + template id + metadata
    SELECT db_object_name, id, definition,
           JSON_VALUE(metadata, '$.file_type' RETURNING NUMBER),
           JSON_VALUE(metadata, '$.skip_rows' RETURNING NUMBER DEFAULT 0 ON ERROR),
           JSON_VALUE(metadata, '$.sheet_file_name'),
           JSON_VALUE(metadata, '$.sheet_display_name')
      INTO l_table_name, l_template_id, l_json,
           v_file_type, v_skip_rows, v_sheet_file_name, v_sheet_display_name
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
        ur_utils.sanitize_column_name(jt.original_name) AS orig_col,
        CASE
            WHEN jt.mapping_type = 'Maps To' THEN jt.name
            WHEN jt.mapping_type IN ('Default', 'Calculation') THEN TRIM(jt.value)
        END                  AS parser_col,
        jt.mapping_type      AS map_type,
        jt.format_mask       AS format_mask,
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
                 original_name  VARCHAR2(4000) PATH '$.original_name',
                 format_mask   VARCHAR2(100)  PATH '$.format_mask'
         ) jt
    WHERE t.id = l_template_id
)
LOOP
    -- Assign to associative array
    l_mapping(UPPER(TRIM(rec.src_col))).src_col     := TRIM(rec.src_col);
    l_mapping(UPPER(TRIM(rec.src_col))).tgt_col     := TRIM(rec.tgt_col);
    l_mapping(UPPER(TRIM(rec.src_col))).parser_col  := TRIM(rec.parser_col);
    l_mapping(UPPER(TRIM(rec.src_col))).data_type   := rec.datatype1;
    l_mapping(UPPER(TRIM(rec.src_col))).map_type    := TRIM(rec.map_type);
    l_mapping(UPPER(TRIM(rec.src_col))).orig_col    := ur_utils.sanitize_column_name(rec.orig_col);
    l_mapping(UPPER(TRIM(rec.src_col))).format_mask := TRIM(rec.format_mask);

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
                                -- Use format_mask if available, otherwise fallback to common formats
                                IF l_mapping(k).format_mask IS NOT NULL THEN
                                    v_expr := 'ur_utils.parse_date_safe(TRIM(p.' || l_mapping(k).parser_col ||
                                              '), ''' || l_mapping(k).format_mask || ''') as ' || upper(l_mapping(k).parser_col);
                                ELSE
                                    -- Backward compatibility fallback for templates without format_mask
                                    v_expr := 'CASE ' ||
                                              ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{4}-\d{2}-\d{2}$'') ' ||
                                              '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''YYYY-MM-DD'') ' ||
                                              ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}/\d{2}/\d{4}$'') ' ||
                                              '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD/MM/YYYY'') ' ||
                                              ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-[A-Z]{3}-\d{4}$'', ''i'') ' ||
                                              '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MON-YYYY'') ' ||
                                              ' ELSE NULL END as ' || upper(l_mapping(k).parser_col);
                                END IF;

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
    -- 4. Discover file profile with proper skip_rows and sheet parameters
    -------------------------------------------------------------------
    BEGIN
        IF v_file_type = 1 THEN
            -- Excel: Handle sheet selection
            IF v_sheet_display_name IS NOT NULL THEN
                BEGIN
                    -- Find the actual sheet_file_name by matching sheet_display_name
                    SELECT SHEET_FILE_NAME
                    INTO v_matched_sheet_file_name
                    FROM TABLE(
                        apex_data_parser.get_xlsx_worksheets(
                            p_content => l_blob
                        )
                    )
                    WHERE SHEET_DISPLAY_NAME = v_sheet_display_name;

                    -- Use the matched sheet_file_name for parsing
                    v_profile_clob := apex_data_parser.discover(
                        p_content => l_blob,
                        p_file_name => l_file_name,
                        p_skip_rows => NVL(v_skip_rows, 0),
                        p_xlsx_sheet_name => v_matched_sheet_file_name
                    );
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- Fallback: try using sheet_file_name directly
                        v_profile_clob := apex_data_parser.discover(
                            p_content => l_blob,
                            p_file_name => l_file_name,
                            p_skip_rows => NVL(v_skip_rows, 0),
                            p_xlsx_sheet_name => v_sheet_file_name
                        );
                END;
            ELSE
                -- No sheet_display_name, use sheet_file_name directly
                v_profile_clob := apex_data_parser.discover(
                    p_content => l_blob,
                    p_file_name => l_file_name,
                    p_skip_rows => NVL(v_skip_rows, 0),
                    p_xlsx_sheet_name => v_sheet_file_name
                );
            END IF;
        ELSIF v_file_type = 2 THEN
            -- CSV: Use skip_rows only
            v_profile_clob := apex_data_parser.discover(
                p_content => l_blob,
                p_file_name => l_file_name,
                p_skip_rows => NVL(v_skip_rows, 0)
            );
        ELSE
            -- Other file types: Use defaults
            v_profile_clob := apex_data_parser.discover(
                p_content => l_blob,
                p_file_name => l_file_name
            );
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error parsing file: ' || SQLERRM);
    END;

    INSERT INTO debug_log(message) VALUES('apex_data_parser.discover done with skip_rows=' || NVL(v_skip_rows, 0));

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
    -- 7. Build JSON SQL with proper skip_rows and sheet parameters
    -------------------------------------------------------------------
    v_sql_json := 'SELECT p.line_number, JSON_OBJECT(';
    FOR i IN 1..v_col_count LOOP
        IF i > 1 THEN v_sql_json := v_sql_json || ', '; END IF;
        v_sql_json := v_sql_json || '''' || REPLACE(v_headers(i), '''', '''''') || ''' VALUE NVL(p.col' || LPAD(i,3,'0') || ', '''')';
    END LOOP;

    -- Build parse call based on file type
    IF v_file_type = 1 THEN
        -- Excel with sheet
        IF v_matched_sheet_file_name IS NOT NULL THEN
            v_sql_json := v_sql_json || ') AS row_json FROM TABLE(apex_data_parser.parse(p_content => :1, p_file_name => :2, p_skip_rows => :3, p_xlsx_sheet_name => :4)) p';
        ELSE
            v_sql_json := v_sql_json || ') AS row_json FROM TABLE(apex_data_parser.parse(p_content => :1, p_file_name => :2, p_skip_rows => :3, p_xlsx_sheet_name => :4)) p';
        END IF;
    ELSE
        -- CSV or other: skip_rows only
        v_sql_json := v_sql_json || ') AS row_json FROM TABLE(apex_data_parser.parse(p_content => :1, p_file_name => :2, p_skip_rows => :3)) p';
    END IF;

    INSERT INTO debug_log(message) VALUES('Built SQL for JSON parse (len=' || LENGTH(v_sql_json) || ')');

    -------------------------------------------------------------------
    -- 8. Process each row
    -------------------------------------------------------------------
    IF v_file_type = 1 THEN
        -- Excel: pass sheet parameter
        OPEN c FOR v_sql_json USING l_blob, l_file_name, NVL(v_skip_rows, 0) + 1,
                                     NVL(v_matched_sheet_file_name, v_sheet_file_name);
    ELSE
        -- CSV or other: skip_rows only
        OPEN c FOR v_sql_json USING l_blob, l_file_name, NVL(v_skip_rows, 0) + 1;
    END IF;
    LOOP
        FETCH c INTO v_line_number, v_row_json;
        EXIT WHEN c%NOTFOUND;

        l_total_rows := l_total_rows + 1;
        INSERT INTO debug_log(message) VALUES('--- Processing row #' || l_total_rows || ' line=' || NVL(TO_CHAR(v_line_number),'N/A'));
        INSERT INTO debug_log(message) VALUES('--- v_row_json row #' || v_row_json || ' line=' || NVL(TO_CHAR(v_line_number),'N/A'));

        -- Reset dynamic variables
        -- l_cols := NULL;  -- DO NOT reset - already built from template mapping (lines 198-311)
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
                l_stay_date_invalid BOOLEAN := FALSE;  -- Flag for critical stay_date validation failure
            BEGIN
                IF NOT l_elem.is_object THEN
                    RAISE_APPLICATION_ERROR(-20002,'Row not a JSON object');
                END IF;

                l_obj := TREAT(l_elem AS JSON_OBJECT_T);
                l_keys := l_obj.get_keys;

                FOR j IN 1..l_keys.count LOOP
                    --l_col := UPPER(REPLACE(REPLACE(l_keys(j), '__', '_'), ' ', '_'));
                    l_col := ur_utils.sanitize_column_name(l_keys(j));

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

                        -- Validate DATE columns using format_mask if available
                        IF l_expected_type = 'DATE' AND l_val IS NOT NULL AND LENGTH(TRIM(l_val)) > 0 THEN
                            DECLARE
                                v_test_date DATE;
                                v_format_mask VARCHAR2(100);
                            BEGIN
                                -- Get format_mask from mapping if available
                                v_format_mask := l_mapping(UPPER(l_col)).format_mask;

                                IF v_format_mask IS NOT NULL THEN
                                    -- Use advanced parser with detected format
                                    v_test_date := ur_utils.parse_date_safe(l_val, v_format_mask, SYSDATE);
                                ELSE
                                    -- Fallback to old validation function
                                    v_test_date := fn_safe_to_date(l_val);
                                END IF;

                                IF v_test_date IS NULL THEN
                                    -- Check if this is the STAY_DATE column (critical validation)
                                    IF l_stay_col_name IS NOT NULL AND l_col = UPPER(l_stay_col_name) THEN
                                        l_stay_date_invalid := TRUE;  -- Set critical error flag
                                        l_warning_detail := 'CRITICAL: STAY_DATE "' || l_col || '": Invalid date "' ||
                                                           SUBSTR(l_val, 1, 50) ||
                                                           CASE WHEN LENGTH(l_val) > 50 THEN '...' ELSE '' END ||
                                                           '" - row will be rejected';
                                    ELSE
                                        -- Regular date column - just warning
                                        l_is_valid := FALSE;
                                        l_warning_detail := 'Column "' || l_col || '": Expected date value, got "' ||
                                                           SUBSTR(l_val, 1, 50) ||
                                                           CASE WHEN LENGTH(l_val) > 50 THEN '...' ELSE '' END ||
                                                           '" - value will be set to NULL';
                                    END IF;
                                END IF;
                            EXCEPTION
                                WHEN OTHERS THEN
                                    -- If this is STAY_DATE column, mark as critical error
                                    IF l_stay_col_name IS NOT NULL AND l_col = UPPER(l_stay_col_name) THEN
                                        l_stay_date_invalid := TRUE;
                                        l_warning_detail := 'CRITICAL: STAY_DATE validation error for "' ||
                                                           SUBSTR(l_val, 1, 50) || '" - row will be rejected';
                                    ELSE
                                        -- If validation fails, mark as invalid
                                        l_is_valid := FALSE;
                                        l_warning_detail := 'Column "' || l_col || '": Date validation error for "' ||
                                                           SUBSTR(l_val, 1, 50) || '"';
                                    END IF;
                            END;
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

                        -- Validate stay_date is not empty/NULL
                        IF l_stay_val IS NULL OR LENGTH(TRIM(l_stay_val)) = 0 THEN
                            l_stay_date_invalid := TRUE;
                            l_row_warnings := l_row_warnings ||
                                CASE WHEN l_row_warnings IS NOT NULL THEN '; ' ELSE '' END ||
                                'CRITICAL: STAY_DATE is empty/NULL - row will be rejected';
                        END IF;
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
                        -- l_cols := l_cols || ', ';  -- REMOVED - don't rebuild column list here!
                        l_vals := l_vals || ', ';
                    END IF;

                    l_set  := NVL(l_set,'')  || l_col || ' = ' || l_val_formatted;
                    -- l_cols := NVL(l_cols,'') || l_col;  -- REMOVED - use template column names only!
                    --l_col_u := l_col_u ||'t.' || l_col ||' = '||'s.'||l_col ||' ,';
                    l_col_s := l_col_s ||'s.'||l_col||',';
                    l_vals := NVL(l_vals,'') || l_val_formatted;
                END LOOP;

                -- ============================================================
                -- Skip row execution if stay_date is invalid
                -- ============================================================
                IF l_stay_date_invalid THEN
                    -- Log as failed row
                    l_fail_cnt := l_fail_cnt + 1;
                    l_error_json := l_error_json ||
                        '{"row":' || NVL(TO_CHAR(l_total_rows), '0') ||
                        ',"line":' || NVL(TO_CHAR(v_line_number), 'null') ||
                        ',"status":"FAILED"' ||
                        ',"error":"Invalid STAY_DATE value cannot be parsed as date"' ||
                        CASE WHEN l_row_warnings IS NOT NULL
                             THEN ',"data_issues":"' || REPLACE(REPLACE(l_row_warnings, '"', ''''), CHR(10), ' ') || '"'
                             ELSE ''
                        END || '},';

                    -- Skip to next row (don't execute INSERT/MERGE)
                    GOTO skip_row_execution;
                END IF;
                -- ============================================================

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
    -- Convert stay_val using format_mask if available, otherwise use old function
    DECLARE
        v_stay_date DATE;
        v_format_mask VARCHAR2(100);
    BEGIN
        v_format_mask := l_mapping(UPPER(l_stay_col_name)).format_mask;

        IF v_format_mask IS NOT NULL THEN
            -- Use advanced parser with detected format
            v_stay_date := ur_utils.parse_date_safe(l_stay_val, v_format_mask, SYSDATE);
        ELSE
            -- Fallback to old function
            v_stay_date := fn_safe_to_date(l_stay_val);
        END IF;

        l_stay_val := TO_CHAR(v_stay_date, 'DD/MM/YYYY');
    EXCEPTION
        WHEN OTHERS THEN
            -- Safety net: mark as invalid instead of allowing NULL
            l_stay_date_invalid := TRUE;
            l_row_warnings := l_row_warnings ||
                CASE WHEN l_row_warnings IS NOT NULL THEN '; ' ELSE '' END ||
                'CRITICAL: STAY_DATE conversion failed unexpectedly';
            l_stay_val := NULL;
    END;

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
             VALUES (s.HOTEL_ID, s.'|| REPLACE(l_cols, ',', ', s.') ||', s.INTERFACE_LOG_ID)';
ELSE
    --  No STAY_DATE in template → simple INSERT only
    l_sql_main :=
        'INSERT INTO '|| l_table_name ||' (HOTEL_ID,'|| l_cols ||',INTERFACE_LOG_ID)
         SELECT '''||p_hotel_id||''' AS HOTEL_ID,'|| l_cols ||','''||l_log_id||''' AS INTERFACE_LOG_ID '||
        '  FROM ( SELECT  '||l_vals_calculation||' FROM ( SELECT ' || rtrim(l_sql_select, ', ')  ||' FROM DUAL)p'|| 
        ' WHERE 1=1 )';
END IF;



        INSERT INTO debug_log(message) VALUES('--- l_sql_main:>   '||l_sql_main);

                -- ============================================================
                -- Final check: Skip execution if stay_date became invalid during conversion
                -- ============================================================
                IF l_stay_date_invalid THEN
                    -- Log as failed row
                    l_fail_cnt := l_fail_cnt + 1;
                    l_error_json := l_error_json ||
                        '{"row":' || NVL(TO_CHAR(l_total_rows), '0') ||
                        ',"line":' || NVL(TO_CHAR(v_line_number), 'null') ||
                        ',"status":"FAILED"' ||
                        ',"error":"Invalid STAY_DATE value cannot be parsed as date"' ||
                        CASE WHEN l_row_warnings IS NOT NULL
                             THEN ',"data_issues":"' || REPLACE(REPLACE(l_row_warnings, '"', ''''), CHR(10), ' ') || '"'
                             ELSE ''
                        END || '},';

                    -- Skip to next row (don't execute INSERT/MERGE)
                    GOTO skip_row_execution;
                END IF;
                -- ============================================================

                -- Check if this will be INSERT or UPDATE (only for MERGE operations with stay_date)
                IF l_stay_col_name IS NOT NULL THEN
                    DECLARE
                        v_exists NUMBER := 0;
                    BEGIN
                        EXECUTE IMMEDIATE
                            'SELECT COUNT(*) FROM ' || l_table_name ||
                            ' WHERE HOTEL_ID = :1 AND TO_CHAR(' || l_stay_col_name || ', ''DD/MM/YYYY'') = :2'
                            INTO v_exists
                            USING p_hotel_id, l_stay_val;

                        IF v_exists > 0 THEN
                            l_update_cnt := l_update_cnt + 1;  -- Record exists, will be UPDATE
                        ELSE
                            l_insert_cnt := l_insert_cnt + 1;  -- Record doesn't exist, will be INSERT
                        END IF;
                    END;
                ELSE
                    -- No STAY_DATE qualifier, so it's always INSERT
                    l_insert_cnt := l_insert_cnt + 1;
                END IF;

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

        <<skip_row_execution>>
        NULL;  -- Label target for skipping invalid stay_date rows
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
                l_total_rows || ' rows uploaded successfully' ||
                CASE WHEN l_stay_col_name IS NOT NULL THEN
                    ' (' || l_insert_cnt || ' inserted, ' || l_update_cnt || ' updated)'
                ELSE '' END || '.'

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
                l_success_cnt || ' rows uploaded' ||
                CASE WHEN l_stay_col_name IS NOT NULL THEN
                    ' (' || l_insert_cnt || ' inserted, ' || l_update_cnt || ' updated)'
                ELSE '' END ||
                ' with ' || l_warning_cnt || ' data quality warnings</a>'

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
                l_success_cnt || ' rows uploaded' ||
                CASE WHEN l_stay_col_name IS NOT NULL THEN
                    ' (' || l_insert_cnt || ' inserted, ' || l_update_cnt || ' updated)'
                ELSE '' END ||
                ', ' || l_fail_cnt || ' failed' ||
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
END Load_Data_V2;


END ur_utils;
/