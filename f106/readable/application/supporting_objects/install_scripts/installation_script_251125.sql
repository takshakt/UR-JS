create or replace FUNCTION FN_CLEAN_NUMBER (p_string IN VARCHAR2)
RETURN NUMBER
IS
    l_cleaned_string VARCHAR2(4000);
BEGIN
    IF p_string IS NULL THEN
        RETURN NULL;
    END IF;

    -- Remove all characters that are not digits, a decimal point, or a leading minus sign
    l_cleaned_string := REGEXP_REPLACE(p_string, '[^0-9.-]', '');

    -- Handle invalid cases or non-numeric results
    IF l_cleaned_string IS NULL 
       OR l_cleaned_string IN ('-', '.', '', '--', '..')
       OR REGEXP_LIKE(l_cleaned_string, '^-?[0-9]*\.?[0-9]*$') = FALSE THEN
        RETURN NULL;
    END IF;

    BEGIN
        RETURN TO_NUMBER(l_cleaned_string);
    EXCEPTION
        WHEN VALUE_ERROR THEN
            RETURN NULL;
        WHEN OTHERS THEN
            RETURN NULL;
    END;
END FN_CLEAN_NUMBER;
/
create or replace FUNCTION fn_safe_to_date(p_string IN VARCHAR2)
RETURN DATE
IS
BEGIN
    IF p_string IS NULL THEN
        RETURN NULL;
    END IF;

    -- Attempt 1: YYYY-MM-DD (most common standard)
    BEGIN RETURN TO_DATE(p_string, 'YYYY-MM-DD'); EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- Attempt 2: DD-MON-YYYY (e.g., 20-OCT-2025)
    BEGIN RETURN TO_DATE(p_string, 'DD-MON-YYYY'); EXCEPTION WHEN OTHERS THEN NULL; END;

    -- Attempt 3: DD/MM/YYYY
    BEGIN RETURN TO_DATE(p_string, 'DD/MM/YYYY'); EXCEPTION WHEN OTHERS THEN NULL; END;

    -- Attempt 4: MM/DD/YYYY
    BEGIN RETURN TO_DATE(p_string, 'MM/DD/YYYY'); EXCEPTION WHEN OTHERS THEN NULL; END;

    -- Attempt 5: DD-MON-RR (handles 2-digit years)
    BEGIN RETURN TO_DATE(p_string, 'DD-MON-RR'); EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- If all attempts fail, return NULL
    RETURN NULL;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END fn_safe_to_date;
/
create or replace FUNCTION GET_MAP_CALCULATION_FUN(p_formula IN VARCHAR2, p_collection_name IN VARCHAR2)
RETURN VARCHAR2 IS
    l_formula VARCHAR2(4000) := p_formula;
BEGIN
    FOR rec IN (
        SELECT regexp_substr(c001, '^[^(]+') src_col, 
               regexp_substr(c002, '^[^(]+') tgt_col
        FROM apex_collections
        WHERE collection_name = p_collection_name
    ) LOOP
        l_formula := REGEXP_REPLACE(
                        l_formula, 
                        'p\.' || rec.src_col || '(\b|[^a-zA-Z0-9_])', 
                        'p.' || rec.tgt_col || '\1'
                     );
    END LOOP;

    RETURN l_formula;
END;
/
create or replace FUNCTION get_profile_json (
  p_blob     BLOB,
  p_filename VARCHAR2
) RETURN CLOB IS
  l_result  apex_data_parser.t_parser_profile;
BEGIN
  l_result := apex_data_parser.discover(
    p_content   => p_blob,
    p_file_name => p_filename
  );
  RETURN l_result.profile;
END;
/
create or replace FUNCTION guess_delimiter (
    p_blob IN BLOB
) RETURN VARCHAR2 IS
    l_raw        RAW(32767);
    l_varchar2   VARCHAR2(32767);
    l_first_line VARCHAR2(4000);
    l_comma_count NUMBER := 0;
    l_semicolon_count NUMBER := 0;
    l_pipe_count NUMBER := 0;
    l_tab_count NUMBER := 0;
    l_crlf_pos NUMBER;
    l_lf_pos NUMBER;
BEGIN
    -- Read the first part of the BLOB
    l_raw := DBMS_LOB.SUBSTR(p_blob, 32767, 1);
    
    -- Convert RAW to VARCHAR2
    l_varchar2 := UTL_RAW.CAST_TO_VARCHAR2(l_raw);
    
    -- Find the end of the first line (CRLF or LF)
    l_crlf_pos := INSTR(l_varchar2, CHR(13) || CHR(10));
    l_lf_pos := INSTR(l_varchar2, CHR(10));

    IF l_crlf_pos > 0 THEN
        l_first_line := SUBSTR(l_varchar2, 1, l_crlf_pos - 1);
    ELSIF l_lf_pos > 0 THEN
        l_first_line := SUBSTR(l_varchar2, 1, l_lf_pos - 1);
    ELSE
        l_first_line := l_varchar2;
    END IF;

    -- Count occurrences of common delimiters
    l_comma_count := REGEXP_COUNT(l_first_line, ',');
    l_semicolon_count := REGEXP_COUNT(l_first_line, ';');
    l_pipe_count := REGEXP_COUNT(l_first_line, '\|');
    l_tab_count := REGEXP_COUNT(l_first_line, CHR(9));
    
    -- Determine the most likely delimiter
    IF l_comma_count > l_semicolon_count AND l_comma_count > l_pipe_count AND l_comma_count > l_tab_count THEN
        RETURN ',';
    ELSIF l_semicolon_count > l_comma_count AND l_semicolon_count > l_pipe_count AND l_semicolon_count > l_tab_count THEN
        RETURN ';';
    ELSIF l_pipe_count > l_comma_count AND l_pipe_count > l_semicolon_count AND l_pipe_count > l_tab_count THEN
        RETURN '|';
    ELSIF l_tab_count > 0 THEN -- Tabs are a common delimiter but are hard to distinguish with text
        RETURN CHR(9);
    ELSE
        -- Default to comma or return null if none are found
        RETURN ',';
    END IF;
END;
/
create or replace FUNCTION normalize_json_1 (p_json CLOB) RETURN CLOB IS
BEGIN
  RETURN REPLACE(REPLACE(p_json, '"data-type"', '"data_type"'), '"DATA-TYPE"', '"data_type"');
END normalize_json_1;
/
create or replace FUNCTION sanitize_column_name(p_name IN VARCHAR2) 
   RETURN VARCHAR2
IS
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
END sanitize_column_name;
/
create or replace FUNCTION XXUR_GET_QULIFIER_TEMP_FUN(p_temp_name in varchar2)
return VARCHAR2
IS 
v_name varchar2(20000);
BEGIN
SELECT NAME INTO v_name
           FROM UR_ALGO_ATTRIBUTES 
          WHERE ATTRIBUTE_QUALIFIER = 'STAY_DATE' 
            AND KEY LIKE ''||p_temp_name||'.%' ; 
RETURN v_name;
END;
/














































  CREATE MATERIALIZED VIEW ""."UR_16_OCT_CP_14_D1_MV" ("REC_ID", "STAY_DATE")
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 10 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" 
  BUILD IMMEDIATE
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" 
  REFRESH FAST ON COMMIT
  WITH PRIMARY KEY USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE DISABLE CONCURRENT REFRESH
  AS SELECT REC_ID, STAY_DATE
FROM UR_16_OCT_CP_14_D1_T;

  CREATE UNIQUE INDEX "SYS_C_SNAP$_1UR_16_OCT_CP_14_D1_T_PK" ON "UR_16_OCT_CP_14_D1_MV" ("REC_ID") 
  ;

   COMMENT ON MATERIALIZED VIEW "UR_16_OCT_CP_14_D1_MV"  IS 'snapshot table for snapshot WKSP_DEV.UR_16_OCT_CP_14_D1_MV';









create or replace PACKAGE ALGO_EVALUATOR_PKG IS

  FUNCTION build_dynamic_query(p_rules_json IN CLOB) RETURN CLOB;

  FUNCTION EVALUATE(
    p_algo_id    IN ur_algos.id%TYPE,
    p_version_id IN ur_algo_versions.id%TYPE DEFAULT NULL,
    p_stay_date  IN DATE DEFAULT NULL
  ) RETURN t_result_tab_obj PIPELINED;


    TYPE t_result_rec IS RECORD (
    stay_date       DATE,
    evaluated_price NUMBER,
    applied_rule    CLOB
  );
  TYPE t_result_tab IS TABLE OF t_result_rec;

    FUNCTION GENERIC_MATH_EVAL(
    p_function_name IN VARCHAR2,
    p_values IN VARCHAR2
  ) RETURN NUMBER;


END ALGO_EVALUATOR_PKG;
/
create or replace PACKAGE app_user_ctx IS
  PROCEDURE set_current_user_id(p_user_id IN UR_USERS.USER_ID%TYPE);
  PROCEDURE clear_current_user_id;
  FUNCTION get_current_user_id RETURN UR_USERS.USER_ID%TYPE;
END app_user_ctx;
/
create or replace PACKAGE Graph_SQL AS
  PROCEDURE proc_crud_json(
    p_mode      IN VARCHAR2,    -- C=Create, U=Update, D=Delete, F=Fetch metadata
    p_table     IN VARCHAR2,    -- Table name (must be in user's schema)
    p_payload   IN CLOB,        -- JSON payload string
    p_debug     IN VARCHAR2 DEFAULT 'N', -- 'Y' or 'N'
    p_status    OUT VARCHAR2,   -- S=Success, E=Error
    p_message   OUT CLOB,       -- Message or JSON (for Fetch mode)
    p_icon      OUT VARCHAR2,   -- ✅ added: icon type (success, error, info, warning…)
    p_title     OUT VARCHAR2    -- ✅ added: alert title (Success!, Update Failed, etc.)
  );

END graph_SQL;
/
create or replace PACKAGE pkg_generic_crud AS
  PROCEDURE proc_crud_json(
    p_mode      IN VARCHAR2,    -- C=Create, U=Update, D=Delete, F=Fetch metadata
    p_table     IN VARCHAR2,    -- Table name (must be in user's schema)
    p_payload   IN CLOB,        -- JSON payload string
    p_debug     IN VARCHAR2 DEFAULT 'N', -- 'Y' or 'N'
    p_status    OUT VARCHAR2,   -- S=Success, E=Error
    p_message   OUT CLOB,       -- Message or JSON (for Fetch mode)
    p_icon      OUT VARCHAR2,   -- ✅ added: icon type (success, error, info, warning…)
    p_title     OUT VARCHAR2    -- ✅ added: alert title (Success!, Update Failed, etc.)
  );

END pkg_generic_crud;
/
create or replace PACKAGE ur_users_pkg IS

  TYPE t_result IS RECORD (
    status   VARCHAR2(20),   -- 'OK' | 'ERROR' | 'PENDING'
    message  VARCHAR2(4000),
    username VARCHAR2(255)
  );

  -- Main helper: create user row, create APEX account (if privileged) or enqueue for admin.
  FUNCTION create_user_full(
    p_first_name      IN VARCHAR2,
    p_last_name       IN VARCHAR2,
    p_email           IN VARCHAR2,
    p_contact_number  IN NUMBER DEFAULT NULL,
    p_user_type       IN VARCHAR2 DEFAULT 'ENDUSER',
    p_status          IN VARCHAR2 DEFAULT 'ACTIVE',
    p_start_date      IN DATE DEFAULT NULL,
    p_end_date        IN DATE DEFAULT NULL,
    p_login_method    IN VARCHAR2 DEFAULT 'APEX',
    p_app_id          IN NUMBER DEFAULT NULL,          -- application id for role assignment (optional)
    p_preferred_roles IN VARCHAR2 DEFAULT NULL         -- comma-separated role static IDs
  ) RETURN t_result;

  -- Enqueue for admin (explicit enqueue API)
  PROCEDURE enqueue_user_for_admin(
    p_first_name IN VARCHAR2,
    p_last_name  IN VARCHAR2,
    p_email      IN VARCHAR2,
    p_contact_number IN NUMBER DEFAULT NULL,
    p_user_type IN VARCHAR2 DEFAULT 'ENDUSER',
    p_start_date IN DATE DEFAULT NULL,
    p_end_date   IN DATE DEFAULT NULL,
    p_login_method IN VARCHAR2 DEFAULT 'APEX',
    p_base_username IN VARCHAR2 DEFAULT NULL,
    p_suggested_username IN VARCHAR2 DEFAULT NULL,
    p_preferred_roles IN VARCHAR2 DEFAULT NULL
  );

  -- Admin/privileged: process pending rows (to be run by workspace admin schema / scheduled job)
  PROCEDURE process_pending_users(
    p_processor IN VARCHAR2 DEFAULT NULL  -- who ran it (optional)
  );

END ur_users_pkg;
/
create or replace PACKAGE ur_user_mgmt IS
-- Create user and send notification
PROCEDURE create_user (
p_first      IN VARCHAR2,
p_last       IN VARCHAR2,
p_email      IN VARCHAR2,
p_contact    IN NUMBER,
p_user_type  IN VARCHAR2,
p_status     IN VARCHAR2,
p_start_date IN DATE DEFAULT SYSDATE,
p_end_date   IN DATE DEFAULT NULL,
p_login_method IN VARCHAR2 DEFAULT 'APEX'
);
END ur_user_mgmt;
/
create or replace PACKAGE ur_utils IS

  FUNCTION sanitize_reserved_words(
  p_column_name IN VARCHAR2,
  p_suffix      IN VARCHAR2 DEFAULT 'COL'
) RETURN VARCHAR2;

  PROCEDURE sanitize_template_definition(
  p_definition_json IN  CLOB,
  p_suffix          IN  VARCHAR2 DEFAULT 'COL',
  p_sanitized_json  OUT CLOB,
  p_status          OUT VARCHAR2,
  p_message         OUT VARCHAR2
);


  -- Modified get_collection_json procedure (returns JSON plus status/message)
  PROCEDURE get_collection_json(
    p_collection_name IN VARCHAR2,
    p_json_clob OUT CLOB,
    p_status OUT VARCHAR2,
    p_message OUT VARCHAR2
  );
  
  PROCEDURE POPULATE_ERROR_COLLECTION_FROM_LOG (
    p_interface_log_id IN  UR_INTERFACE_LOGS.ID%TYPE,
    p_collection_name  IN  VARCHAR2,
    p_status           OUT VARCHAR2,
    p_message          OUT VARCHAR2
    );

  PROCEDURE VALIDATE_TEMPLATE_DEFINITION (
      p_json_clob   IN            CLOB,
      p_alert_clob  IN OUT NOCOPY CLOB,
      p_status      OUT           VARCHAR2
  );
  
  FUNCTION GET_ATTRIBUTE_VALUE (
    p_attribute_id    IN  RAW       DEFAULT NULL,
    p_attribute_key   IN  VARCHAR2  DEFAULT NULL,
    p_hotel_id        IN  RAW       DEFAULT NULL,
    p_stay_date       IN  DATE      DEFAULT NULL,
    p_round_digits    IN  NUMBER    DEFAULT 2
  ) RETURN UR_attribute_value_table PIPELINED;

  PROCEDURE GET_ATTRIBUTE_VALUE (
    p_attribute_id    IN  RAW       DEFAULT NULL,
    p_attribute_key   IN  VARCHAR2  DEFAULT NULL,
    p_hotel_id        IN  RAW       DEFAULT NULL,
    p_stay_date       IN  DATE      DEFAULT NULL,
    p_round_digits    IN  NUMBER    DEFAULT 2,
    p_debug_flag      IN  BOOLEAN   DEFAULT FALSE,
    p_response_clob   OUT CLOB
  );

  PROCEDURE manage_algo_attributes(
    p_template_key   IN  VARCHAR2,
    p_mode           IN  CHAR,
    p_attribute_key  IN  VARCHAR2 DEFAULT NULL,
    p_status         OUT BOOLEAN,
    p_message        OUT VARCHAR2
  );

    procedure add_alert(
        p_existing_json   IN  CLOB,
        p_message         IN  VARCHAR2,
        p_icon            IN  VARCHAR2 DEFAULT NULL,
        p_title           IN  VARCHAR2 DEFAULT NULL,
        p_timeOut         IN  NUMBER   DEFAULT NULL,
        p_updated_json    OUT CLOB
    );
  PROCEDURE define_db_object(
    p_template_key IN VARCHAR2,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2,
    p_mode         IN  VARCHAR2 DEFAULT 'N'
  );

  PROCEDURE create_ranking_view(
    p_template_key IN VARCHAR2,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2
);

    -- ============================================================================
    -- PROCEDURE: LOAD_DATA_MAPPING_COLLECTION
    -- ============================================================================
    -- ✨ UPDATED: Added configurable matching parameters
    --
    -- Purpose: Populate an APEX collection with mapped data between uploaded
    --          file columns and template-defined columns
    --
    -- New Parameters:
    --   p_use_original_name - Controls which field name to use for matching
    --                         'Y'    = Use original_name only
    --                         'N'    = Use name only
    --                         'AUTO' = Smart mode (use original_name if present,
    --                                  otherwise fall back to name)
    --   p_match_datatype    - Controls data type matching
    --                         'Y' = Match requires name + data_type
    --                         'N' = Match on name only (ignore data_type)
    -- ============================================================================
    PROCEDURE LOAD_DATA_MAPPING_COLLECTION(
        p_file_id           IN  VARCHAR2,
        p_template_id       IN  VARCHAR2,
        p_collection_name   IN  VARCHAR2,
        p_use_original_name IN  VARCHAR2 DEFAULT 'AUTO',
        p_match_datatype    IN  VARCHAR2 DEFAULT 'Y',
        p_status            OUT VARCHAR2,
        p_message           OUT VARCHAR2
    );
  
  FUNCTION Clean_TEXT(p_text IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE Load_Data (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT boolean,
    p_message         OUT VARCHAR2);
    
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
);

    PROCEDURE DELETE_TEMPLATES (
    p_id           IN VARCHAR2 DEFAULT NULL,
    p_hotel_id     IN VARCHAR2 DEFAULT NULL,
    p_key          IN VARCHAR2 DEFAULT NULL,
    p_name         IN VARCHAR2 DEFAULT NULL,
    p_type         IN VARCHAR2 DEFAULT NULL,
    p_active       IN CHAR DEFAULT NULL,
    p_db_obj_empty IN CHAR DEFAULT NULL,
    p_delete_all   IN CHAR DEFAULT 'N',
    p_debug        IN CHAR DEFAULT 'N',
    p_json_output  OUT CLOB
  );

  FUNCTION normalize_json (p_json CLOB) RETURN CLOB; 

  PROCEDURE validate_expression (
    p_expression IN VARCHAR2,
    p_mode       IN CHAR,
    p_hotel_id   IN VARCHAR2,
    p_status     OUT VARCHAR2,  -- 'S' for success, 'E' for error
    p_message    OUT VARCHAR2
  );

--       PROCEDURE validate_profile_row (
--       p_name          IN VARCHAR2,
--       p_data_type     IN VARCHAR2,
--       p_mapping_type  IN VARCHAR2,
--       p_default_value IN VARCHAR2,
--       p_collection    IN VARCHAR2,
--       p_status        OUT VARCHAR2,
--       p_message       OUT VARCHAR2
--   );


END ur_utils;
/
create or replace PACKAGE ur_utils_test IS

  -- Modified get_collection_json procedure (returns JSON plus status/message)
  PROCEDURE get_collection_json(
    p_collection_name IN VARCHAR2,
    p_json_clob OUT CLOB,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2
  );

  PROCEDURE manage_algo_attributes(
    p_template_key   IN  VARCHAR2,
    p_mode           IN  CHAR,
    p_attribute_key  IN  VARCHAR2 DEFAULT NULL,
    p_status         OUT BOOLEAN,
    p_message        OUT VARCHAR2
  );

    procedure add_alert(
        p_existing_json   IN  CLOB,
        p_message         IN  VARCHAR2,
        p_icon            IN  VARCHAR2 DEFAULT NULL,
        p_title           IN  VARCHAR2 DEFAULT NULL,
        p_timeOut         IN  NUMBER   DEFAULT NULL,
        p_updated_json    OUT CLOB
    );
  PROCEDURE define_db_object(
    p_template_key IN VARCHAR2,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2
  );

  PROCEDURE LOAD_DATA_MAPPING_COLLECTION (
    p_file_id         IN  VARCHAR2,
    p_template_id     IN  VARCHAR2,
    p_collection_name IN  VARCHAR2,
    p_status          OUT VARCHAR2,
    p_message         OUT VARCHAR2
  );
  
  FUNCTION Clean_TEXT(p_text IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE Load_Data (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT boolean,
    p_message         OUT VARCHAR2);
    
  PROCEDURE fetch_templates(
    p_file_id      IN NUMBER,
    p_hotel_id     IN VARCHAR2,
    p_min_score    IN NUMBER DEFAULT 90,
    p_debug_flag   IN VARCHAR2 DEFAULT 'N',
    p_output_json  OUT CLOB,
    p_status       OUT VARCHAR2,
    p_message      OUT VARCHAR2
  );

    PROCEDURE DELETE_TEMPLATES (
    p_id           IN VARCHAR2 DEFAULT NULL,
    p_hotel_id     IN VARCHAR2 DEFAULT NULL,
    p_key          IN VARCHAR2 DEFAULT NULL,
    p_name         IN VARCHAR2 DEFAULT NULL,
    p_type         IN VARCHAR2 DEFAULT NULL,
    p_active       IN CHAR DEFAULT NULL,
    p_db_obj_empty IN CHAR DEFAULT NULL,
    p_delete_all   IN CHAR DEFAULT 'N',
    p_debug        IN CHAR DEFAULT 'N',
    p_json_output  OUT CLOB
  );

  FUNCTION normalize_json (p_json CLOB) RETURN CLOB; 

  PROCEDURE validate_expression (
    p_expression IN VARCHAR2,
    p_mode       IN CHAR,
    p_hotel_id   IN VARCHAR2,
    p_status     OUT VARCHAR2,  -- 'S' for success, 'E' for error
    p_message    OUT VARCHAR2
  );

END ur_utils_test;
/
create or replace PACKAGE ur_utils_test_1 IS

  -- Modified get_collection_json procedure (returns JSON plus status/message)
  PROCEDURE get_collection_json(
    p_collection_name IN VARCHAR2,
    p_json_clob OUT CLOB,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2
  );

  PROCEDURE manage_algo_attributes(
    p_template_key   IN  VARCHAR2,
    p_mode           IN  CHAR,
    p_attribute_key  IN  VARCHAR2 DEFAULT NULL,
    p_status         OUT BOOLEAN,
    p_message        OUT VARCHAR2
  );

    procedure add_alert(
        p_existing_json   IN  CLOB,
        p_message         IN  VARCHAR2,
        p_icon            IN  VARCHAR2 DEFAULT NULL,
        p_title           IN  VARCHAR2 DEFAULT NULL,
        p_timeOut         IN  NUMBER   DEFAULT NULL,
        p_updated_json    OUT CLOB
    );
  PROCEDURE define_db_object(
    p_template_key IN VARCHAR2,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2
  );

  PROCEDURE LOAD_DATA_MAPPING_COLLECTION (
    p_file_id         IN  VARCHAR2,
    p_template_id     IN  VARCHAR2,
    p_collection_name IN  VARCHAR2,
    p_status          OUT VARCHAR2,
    p_message         OUT VARCHAR2
  );
  
  FUNCTION Clean_TEXT(p_text IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE Load_Data (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT boolean,
    p_message         OUT VARCHAR2);
    
  PROCEDURE fetch_templates(
    p_file_id      IN NUMBER,
    p_hotel_id     IN VARCHAR2,
    p_min_score    IN NUMBER DEFAULT 90,
    p_debug_flag   IN VARCHAR2 DEFAULT 'N',
    p_output_json  OUT CLOB,
    p_status       OUT VARCHAR2,
    p_message      OUT VARCHAR2
  );

    PROCEDURE DELETE_TEMPLATES (
    p_id           IN VARCHAR2 DEFAULT NULL,
    p_hotel_id     IN VARCHAR2 DEFAULT NULL,
    p_key          IN VARCHAR2 DEFAULT NULL,
    p_name         IN VARCHAR2 DEFAULT NULL,
    p_type         IN VARCHAR2 DEFAULT NULL,
    p_active       IN CHAR DEFAULT NULL,
    p_db_obj_empty IN CHAR DEFAULT NULL,
    p_delete_all   IN CHAR DEFAULT 'N',
    p_debug        IN CHAR DEFAULT 'N',
    p_json_output  OUT CLOB
  );

  FUNCTION normalize_json (p_json CLOB) RETURN CLOB; 

  PROCEDURE validate_expression (
    p_expression IN VARCHAR2,
    p_mode       IN CHAR,
    p_hotel_id   IN VARCHAR2,
    p_status     OUT VARCHAR2,  -- 'S' for success, 'E' for error
    p_message    OUT VARCHAR2
  );

END ur_utils_test_1;
/
create or replace PACKAGE XXPEL_A001_FEEDBACK AS
  -- Procedure: Submit feedback, create JIRA issue, send notifications
  PROCEDURE SUBMIT_FEEDBACK(
    p_feedback       IN VARCHAR2,
    p_rating         IN VARCHAR2,
    p_new_type       IN VARCHAR2,
    p_summary        IN VARCHAR2,
    p_description    IN VARCHAR2,
    p_page_id        IN NUMBER,
    p_app_id         IN NUMBER,
    p_app_user       IN VARCHAR2
  );
END XXPEL_A001_FEEDBACK;
/





















































create or replace PROCEDURE add_alert_1(
        p_existing_json IN  CLOB,
        p_message       IN  VARCHAR2,
        p_icon          IN  VARCHAR2 DEFAULT NULL,
        p_title         IN  VARCHAR2 DEFAULT NULL,
        p_timeout       IN  NUMBER   DEFAULT NULL,
        p_html_safe     IN  VARCHAR2 DEFAULT 'N',  -- NEW: Y = allow HTML
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
        l_new_object.put('html', nvl(p_html_safe, 'N')); -- NEW key

        IF p_timeout IS NOT NULL THEN
            l_new_object.put('timeOut', to_char(p_timeout));
        END IF;

        -- Append to existing JSON array
        IF p_existing_json IS NULL OR trim(p_existing_json) = '' THEN
            l_json_array := new json_array_t();
        ELSE
            l_json_array := json_array_t(p_existing_json);
        END IF;

        l_json_array.append(l_new_object);

        p_updated_json := l_json_array.to_clob;
    END add_alert_1;
/
create or replace PROCEDURE call_ai_chat_completion (
    p_system_msg  IN VARCHAR2,
    p_user_prompt IN CLOB,           -- JSON format string, e.g. '{"text": "Hello"}'
    p_model_id    IN VARCHAR2,
    p_web_cred    IN VARCHAR2,
    p_completion  OUT CLOB,
    p_token_count OUT NUMBER
) IS
    l_http_request   UTL_HTTP.req;
    l_http_response  UTL_HTTP.resp;
    l_response_text  CLOB;
    
    l_url           VARCHAR2(4000) := 'https://api.openai.com/v1/chat/completions';
    l_api_key       VARCHAR2(4000);
    
    l_body_json     CLOB;
    l_msg_array     JSON_ARRAY_T;
    l_payload       JSON_OBJECT_T;
    
    l_json_response JSON_OBJECT_T;
    l_choices       JSON_ARRAY_T;
    l_usage         JSON_OBJECT_T;
    
    -- to read chunks from response
    l_buffer        VARCHAR2(32767);
BEGIN
    -- Retrieve API key from APEX Web Credential (which securely stores API Key as Password)
    l_api_key := APEX_WEB_CREDENTIAL.GET_PASSWORD(p_web_cred);

    -- Compose the messages array (with system and user message)
    l_msg_array := JSON_ARRAY_T();
    l_msg_array.APPEND(JSON_OBJECT_T('role' VALUE 'system', 'content' VALUE p_system_msg));
    l_msg_array.APPEND(JSON_OBJECT_T('role' VALUE 'user', 'content' VALUE l_user_message));
    -- user prompt is passed as JSON string (already JSON formatted)
    -- Assume p_user_prompt is JSON string representing message object(s),

    -- We'll parse p_user_prompt as JSON to get user message(s)
    -- Two options:
    -- - if p_user_prompt is a single message string (just text), wrap it
    -- - if p_user_prompt is JSON array or JSON object representing messages, append all

    -- For flexibility, let's assume p_user_prompt is JSON string representing user message text, simple.

    -- Alternative: If user prompt is a JSON object with {"text": "..."} then:
    DECLARE
        l_user_msg JSON_OBJECT_T;
    BEGIN
        l_user_msg := JSON_OBJECT_T.parse(p_user_prompt);
        l_msg_array.APPEND(JSON_OBJECT_T('role' VALUE 'user', 'content' VALUE l_user_msg.get_String('text')));
    EXCEPTION
        WHEN OTHERS THEN
          -- fallback: treat p_user_prompt as plain text
          l_msg_array.APPEND(JSON_OBJECT_T('role' VALUE 'user' VALUE p_user_prompt));
    END;

    -- Build payload JSON object
    l_payload := JSON_OBJECT_T();
    l_payload.put('model', p_model_id);
    l_payload.put('messages', l_msg_array);
    
    -- Convert l_payload to clob
    l_body_json := l_payload.to_clob;

    -- Prepare HTTPS request
    l_http_request := UTL_HTTP.begin_request(
        url => l_url,
        method => 'POST',
        http_version => 'HTTP/1.1'
    );

    -- Set headers
    UTL_HTTP.set_header(l_http_request, 'Content-Type', 'application/json');
    UTL_HTTP.set_header(l_http_request, 'Authorization', 'Bearer ' || l_api_key);

    -- Write payload
    UTL_HTTP.write_text(l_http_request, l_body_json);

    -- Get Response
    l_http_response := UTL_HTTP.get_response(l_http_request);

    l_response_text := EMPTY_CLOB();
    DBMS_LOB.createtemporary(l_response_text, TRUE);

    BEGIN
        LOOP
            UTL_HTTP.read_text(l_http_response, l_buffer, 32767);
            DBMS_LOB.writeappend(l_response_text, LENGTH(l_buffer), l_buffer);
        END LOOP;
    EXCEPTION
        WHEN UTL_HTTP.END_OF_BODY THEN
            NULL;
    END;
    UTL_HTTP.end_response(l_http_response);

    -- Parse JSON response
    l_json_response := JSON_OBJECT_T.parse(l_response_text);

    -- Get completion text (first choice)
    l_choices := l_json_response.get_Array('choices');
    IF l_choices.COUNT > 0 THEN
        p_completion := l_choices.get_Object(1).get_String('message').get_String('content');
    ELSE
        p_completion := NULL;
    END IF;

    -- Get token count from usage
    l_usage := l_json_response.get_Object('usage');
    IF l_usage IS NOT NULL THEN
        p_token_count := l_usage.get_Number('total_tokens');
    ELSE
        p_token_count := NULL;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Return error message in output variable
        p_completion := 'Error: ' || SQLERRM;
        p_token_count := NULL;
END call_openai_chat_completion;
/
create or replace PROCEDURE call_openai_chat_completion (
    p_system_msg IN VARCHAR2,
    p_user_msg   IN VARCHAR2,
    p_result     OUT CLOB
) AS
    l_url      VARCHAR2(32767) := 'https://api.openai.com/v1/chat/completions';
    l_body     CLOB;
    l_response CLOB;
    l_api_key  VARCHAR2(4000);
BEGIN
    -- Get API key from application item
    l_api_key := 'xsdcsdfsdf';

    -- Build JSON request body
    l_body := json_object(
                 'model' VALUE 'gpt-4o-mini',
                 'messages' VALUE json_array(
                     json_object('role' VALUE 'system', 'content' VALUE p_system_msg),
                     json_object('role' VALUE 'user',   'content' VALUE p_user_msg)
                 )
              );

    -- Call API
    l_response := apex_web_service.make_rest_request(
        p_url         => l_url,
        p_http_method => 'POST',
        p_body        => l_body,
        p_http_headers => apex_t_varchar2(
                              'Content-Type', 'application/json',
                              'Authorization', 'Bearer ' || l_api_key
                          )
    );

    -- Parse the response
    SELECT json_value(l_response, '$.choices[0].message.content')
      INTO p_result
      FROM dual;

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'Error: ' || SQLERRM;
END call_openai_chat_completion;
/
create or replace PROCEDURE define_db_object_1(
    p_template_key IN VARCHAR2,
    p_status       OUT BOOLEAN,
    p_message      OUT VARCHAR2,
    p_mode         IN  VARCHAR2 DEFAULT 'N'  -- 'N' = new create, 'U' = update/replace existing
) IS
    v_db_object_name VARCHAR2(30);
    v_sql            CLOB;
    v_col_defs       CLOB := '';
    v_unique_defs    CLOB := '';
    v_definition     CLOB;
    v_exists         NUMBER;
    v_trigger_name   VARCHAR2(130);
    l_col_name       VARCHAR2(100);
    v_template_id VARCHAR2(240);
BEGIN
    -- 🔒 Lock and fetch details
    SELECT db_object_name, definition,id
      INTO v_db_object_name, v_definition,v_template_id
      FROM ur_templates
     WHERE key = p_template_key
     FOR UPDATE;

    IF v_definition IS NULL THEN
        p_status := FALSE;
        p_message := 'Failure: Definition JSON is NULL for template_key ' || p_template_key;
        RETURN;
    END IF;

    -- Generate table name if not already defined
    IF v_db_object_name IS NULL THEN
        v_db_object_name := 'UR_' || UPPER(p_template_key) || '_T';
    END IF;

    -- 🔍 Check if table exists
    SELECT COUNT(*)
      INTO v_exists
      FROM all_tables
     WHERE table_name = UPPER(v_db_object_name);

    -- 🧩 Handle based on mode
    --IF v_exists > 0 THEN
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
                WHEN OTHERS THEN NULL; -- ignore if not exists
            END;

            -- Drop existing table
            BEGIN
                EXECUTE IMMEDIATE 'DROP TABLE "' || v_db_object_name || '" CASCADE CONSTRAINTS';
            EXCEPTION
                WHEN OTHERS THEN
                    p_status := FALSE;
                    p_message := 'Failure dropping existing table: ' || SQLERRM;
                    RETURN;
            END;
        ELSIF p_mode = 'D' THEN
    BEGIN
        v_trigger_name := v_db_object_name || '_BI_TRG';
        EXECUTE IMMEDIATE 'DROP TRIGGER "' || v_trigger_name || '"';
    EXCEPTION
        WHEN OTHERS THEN NULL; -- ignore if not exists
    END;

    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE "' || v_db_object_name || '" CASCADE CONSTRAINTS';
    EXCEPTION
        WHEN OTHERS THEN
            p_status := FALSE;
            p_message := 'Failure dropping table: ' || SQLERRM;
            RETURN;
    END;

    --delete from ur_algo_attributes using template_id
    DELETE FROM UR_ALGO_ATTRIBUTES
    WHERE TEMPLATE_ID = V_TEMPLATE_ID;

    -- Optionally, clear the DB_OBJECT_NAME in ur_templates
    UPDATE ur_templates
       Sdb_object_name = NULL,
           db_object_created_on = NULL
     WHERE key = p_template_key;

    COMMIT;

    p_status := TRUE;
    p_message := 'Success: Template "' || p_template_key || '" and related DB objects deleted.';
    RETURN;

    --    END IF;
    END IF;

    -- Start with ID RAW(16) as primary key column
    v_col_defs := '"REC_ID" RAW(16)';

    -- Parse JSON definition
    FOR rec IN (
        SELECT jt.name, jt.data_type, jt.qualifier
        FROM JSON_TABLE(
                 normalize_json_1(v_definition),
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
    v_sql := '
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
       SET db_object_name       = v_db_object_name,
           db_object_created_on = SYSDATE
     WHERE key = p_template_key;

    COMMIT;

    p_status  := TRUE;
    IF p_mode = 'U' THEN
        p_message := 'Success: Table "' || v_db_object_name || '" redefined (replaced) successfully.';
    ELSE
        p_message := 'Success: Table "' || v_db_object_name || '" created with ID primary key and trigger.';
    END IF;


EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_status := FALSE;
        p_message := 'Failure: Template key not found';
    WHEN OTHERS THEN
        p_status := FALSE;
        p_message := 'Failure: ' || SQLERRM;
END define_db_object_1;
/
create or replace PROCEDURE DELETE_TEMPLATES_1(
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

              --  DELETE FROM ur_templates WHERE id = rec.id;

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
    END DELETE_TEMPLATES_1;
/
create or replace PROCEDURE DELETE_TEMPLATES_AND_DB_OBJECTS_JSON (
  p_id            IN VARCHAR2 DEFAULT NULL,
  p_hotel_id      IN VARCHAR2 DEFAULT NULL,
  p_key           IN VARCHAR2 DEFAULT NULL,
  p_name          IN VARCHAR2 DEFAULT NULL,
  p_type          IN VARCHAR2 DEFAULT NULL,
  p_active        IN CHAR DEFAULT NULL,           -- 'Y' or 'N'
  p_db_obj_empty  IN CHAR DEFAULT NULL,           -- 'Y' = only if table is empty, else skip
  p_delete_all    IN CHAR DEFAULT 'N',            -- 'Y' to delete EVERYTHING
  p_debug         IN CHAR DEFAULT 'N',            -- 'Y' to log debug messages to APEX debug
  p_json_output   OUT CLOB
)
AS
  v_sql            VARCHAR2(1000);
  v_rows_count     NUMBER;
  v_status         CHAR(1);
  v_message        VARCHAR2(4000);
  v_json_list      CLOB := '[';
  v_first          BOOLEAN := TRUE;
  v_tmp_json       CLOB;

  CURSOR c_templates IS
    SELECT id, hotel_id, key, name, type, active, db_object_name
    FROM ur_templates
    WHERE (p_delete_all = 'Y'
          OR (p_id IS NULL OR id = p_id))
      AND (p_delete_all = 'Y'
           OR (p_hotel_id IS NULL OR hotel_id = p_hotel_id))
      AND (p_delete_all = 'Y'
           OR (p_key IS NULL OR key = p_key))
      AND (p_delete_all = 'Y'
           OR (p_name IS NULL OR name = p_name))
      AND (p_delete_all = 'Y'
           OR (p_type IS NULL OR type = p_type))
      AND (p_delete_all = 'Y'
           OR (p_active IS NULL OR active = p_active));
           
  -- Helper to escape JSON strings - simple version; improves safety
  FUNCTION json_escape(str IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN REPLACE(REPLACE(REPLACE(REPLACE(str, '\', '\\'), '"', '\"'), CHR(10), '\n'), CHR(13), '');
  EXCEPTION WHEN OTHERS THEN
    RETURN '';
  END;

  PROCEDURE dbg(p_msg VARCHAR2) IS
  BEGIN
    IF p_debug = 'Y' THEN
      apex_debug.message(p_msg);
    END IF;
  END;

  PROCEDURE append_result (
    p_id            IN VARCHAR2,
    p_hotel_id      IN VARCHAR2,
    p_key           IN VARCHAR2,
    p_name          IN VARCHAR2,
    p_type          IN VARCHAR2,
    p_active        IN CHAR,
    p_db_obj_name   IN VARCHAR2,
    p_status        IN CHAR,
    p_message       IN VARCHAR2
  ) IS
  BEGIN
    IF v_first THEN
      v_first := FALSE;
    ELSE
      v_json_list := v_json_list || ',';
    END IF;

    v_json_list := v_json_list || '{' ||
      '"id":"'          || json_escape(p_id)          || '",' ||
      '"hotel_id":"'    || json_escape(p_hotel_id)    || '",' ||
      '"key":"'         || json_escape(p_key)         || '",' ||
      '"name":"'        || json_escape(p_name)        || '",' ||
      '"type":"'        || json_escape(p_type)        || '",' ||
      '"active":"'      || json_escape(p_active)      || '",' ||
      '"db_object_name":"' || json_escape(p_db_obj_name) || '",' ||
      '"status":"'      || json_escape(p_status)      || '",' ||
      '"message":"'     || json_escape(p_message)     || '"' ||
    '}';
  END;
BEGIN
  dbg('Started DELETE_TEMPLATES_AND_DB_OBJECTS_JSON procedure.');

  FOR rec IN c_templates LOOP
    dbg('Processing template ID=' || rec.id || ', DB_OBJECT_NAME=' || rec.db_object_name);

    IF rec.db_object_name IS NULL THEN
      v_status := 'E';
      v_message := 'No DB_OBJECT_NAME specified for template, skipping.';
      dbg(v_message);
      append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, NULL, v_status, v_message);
      CONTINUE;
    END IF;

    -- -- Check if table exists in user schema
    -- SELECT COUNT(*)
    --   INTO v_rows_count
    --   FROM all_tables
    --  WHERE table_name = rec.db_object_name
    --    AND owner = USER;

    -- IF v_rows_count = 0 THEN
    --   v_status := 'E';
    --   v_message := 'DB Object [' || rec.db_object_name || '] does not exist or is not a table.';
    --   dbg(v_message);
    --   append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);
    --   CONTINUE;
    -- END IF;

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
        v_status := 'E';
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

      v_status := 'S';
      v_message := 'Successfully dropped table and deleted template.';
      append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);

    EXCEPTION
      WHEN OTHERS THEN
        v_status := 'E';
        v_message := 'Error dropping table or deleting template: ' || SQLERRM;
        dbg(v_message);
        append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);
    END;
  END LOOP;

  v_json_list := v_json_list || ']';

  p_json_output := v_json_list;

  dbg('Completed DELETE_TEMPLATES_AND_DB_OBJECTS_JSON procedure.');
END DELETE_TEMPLATES_AND_DB_OBJECTS_JSON;
/
create or replace PROCEDURE generic_crud_proc (
  p_mode      IN VARCHAR2,
  p_table     IN VARCHAR2,
  p_payload   IN CLOB,
  p_debug     IN VARCHAR2 DEFAULT 'N',
  p_status    OUT VARCHAR2,
  p_message   OUT CLOB
) IS
  -- Types for column metadata
  TYPE t_col_rec IS RECORD (
    column_name  VARCHAR2(100),
    data_type    VARCHAR2(30),
    nullable     CHAR(1)
  );
  TYPE t_col_tab IS TABLE OF t_col_rec INDEX BY PLS_INTEGER;

  v_columns     t_col_tab;
  v_pk_cols     SYS.ODCIVARCHAR2LIST;

  v_col_cnt     PLS_INTEGER := 0;
  v_pk_cnt      PLS_INTEGER := 0;

  v_json_obj    JSON_OBJECT_T;
  v_sql         CLOB;
  v_cursor      INTEGER DEFAULT DBMS_SQL.OPEN_CURSOR;
  v_col_value_varchar   VARCHAR2(4000);
  v_col_value_number    NUMBER;
  v_col_value_date      DATE;
  v_col_value_raw       RAW(16);

  v_bind_idx    INTEGER;
  v_col_meta    t_col_rec;

  v_missing     SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
  v_err_msg     VARCHAR2(4000);

  PROCEDURE log_debug(p_msg VARCHAR2) IS
  BEGIN
    IF UPPER(p_debug) = 'Y' THEN
      BEGIN
        APEX_DEBUG.MESSAGE('DEBUG: ' || p_msg);
      EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('DEBUG: ' || p_msg);
      END;
    END IF;
  END;

  FUNCTION hex_to_raw16(hexstr VARCHAR2) RETURN RAW IS
  BEGIN
    IF LENGTH(hexstr) = 32 THEN
      RETURN HEXTORAW(hexstr);
    ELSE
      RETURN NULL;
    END IF;
  END;

  -- Utility to validate mandatory columns present in JSON
PROCEDURE validate_mandatory_cols IS
BEGIN
  FOR i IN 1 .. v_col_cnt LOOP
    IF v_columns(i).nullable = 'N' THEN
      IF NOT v_json_obj.has(v_columns(i).column_name) THEN
        v_missing.EXTEND;
        v_missing(v_missing.COUNT) := v_columns(i).column_name;
      END IF;
    END IF;
  END LOOP;

  IF v_missing.COUNT > 0 THEN
    DECLARE
      v_list_str VARCHAR2(4000);
    BEGIN
      SELECT LISTAGG(column_value, ', ') WITHIN GROUP (ORDER BY column_value)
        INTO v_list_str
        FROM TABLE(v_missing);
      v_err_msg := 'Mandatory columns missing: ' || v_list_str;
    END;
    RAISE_APPLICATION_ERROR(-20001, v_err_msg);
  END IF;
END;

  -- Utility to fetch column metadata dynamically
  PROCEDURE load_metadata IS
  BEGIN
    SELECT column_name, data_type, nullable
      BULK COLLECT INTO v_columns
      FROM all_tab_columns
     WHERE table_name = UPPER(p_table)
       AND owner = USER
     ORDER BY column_id;

    IF v_columns.COUNT = 0 THEN
      v_err_msg := 'Table "' || p_table || '" does not exist or no columns found.';
      RAISE_APPLICATION_ERROR(-20002, v_err_msg);
    END IF;

    SELECT acc.column_name
      BULK COLLECT INTO v_pk_cols
      FROM all_constraints ac
      JOIN all_cons_columns acc ON ac.constraint_name = acc.constraint_name AND ac.owner = acc.owner
     WHERE ac.constraint_type = 'P'
       AND ac.table_name = UPPER(p_table)
       AND ac.owner = USER
     ORDER BY acc.position;

    v_col_cnt := v_columns.COUNT;
    v_pk_cnt := v_pk_cols.COUNT;
  END;

  -- Procedure to generate sample payloads JSON (for F mode)
  FUNCTION sample_payload_json RETURN CLOB IS
    v_json JSON_OBJECT_T := JSON_OBJECT_T();
    v_sample_create JSON_OBJECT_T := JSON_OBJECT_T();
    v_sample_update JSON_OBJECT_T := JSON_OBJECT_T();
    v_sample_delete JSON_OBJECT_T := JSON_OBJECT_T();
  BEGIN
    FOR i IN 1 .. v_col_cnt LOOP
      IF v_columns(i).data_type LIKE 'VARCHAR2%' THEN
        v_sample_create.put(v_columns(i).column_name, v_columns(i).column_name || '_sample');
        v_sample_update.put(v_columns(i).column_name, v_columns(i).column_name || '_updated');
      ELSIF v_columns(i).data_type LIKE 'NUMBER%' THEN
        v_sample_create.put(v_columns(i).column_name, 123);
        v_sample_update.put(v_columns(i).column_name, 456);
      ELSIF v_columns(i).data_type LIKE 'DATE%' THEN
        v_sample_create.put(v_columns(i).column_name, TO_CHAR(SYSDATE, 'YYYY-MM-DD"T"HH24:MI:SS'));
        v_sample_update.put(v_columns(i).column_name, TO_CHAR(SYSDATE+1, 'YYYY-MM-DD"T"HH24:MI:SS'));
      ELSIF v_columns(i).data_type = 'RAW' THEN
        -- UUID as 32 char hex string
        v_sample_create.put(v_columns(i).column_name, 'A1B2C3D4E5F60718293A4B5C6D7E8F90');
        v_sample_update.put(v_columns(i).column_name, 'F0E8D7C6B5A4938271607F5E4D3C2B1A');
      END IF;
    END LOOP;
    -- For delete and update PK columns required:
    FOR i IN 1 .. v_pk_cnt LOOP
      v_sample_delete.put(v_pk_cols(i), 'A1B2C3D4E5F60718293A4B5C6D7E8F90');
      v_sample_update.put(v_pk_cols(i), 'A1B2C3D4E5F60718293A4B5C6D7E8F90');
    END LOOP;

    v_json.put('table_name', p_table);
    v_json.put('columns', JSON_ARRAY_T());
    FOR i IN 1 .. v_col_cnt LOOP
      DECLARE
        v_col_obj JSON_OBJECT_T := JSON_OBJECT_T();
      BEGIN
        v_col_obj.put('column_name', v_columns(i).column_name);
        v_col_obj.put('data_type', v_columns(i).data_type);
        v_col_obj.put('nullable', v_columns(i).nullable);
        v_col_obj.put('sample_value', v_sample_create.get(v_columns(i).column_name));
        v_json.get_Array('columns').append(v_col_obj);
      END;
    END LOOP;

    v_json.put('sample_create_payload', v_sample_create);
    v_json.put('sample_update_payload', v_sample_update);
    v_json.put('sample_delete_payload', v_sample_delete);

    RETURN v_json.to_clob;
  END;

BEGIN
  p_status := 'E';
  p_message := NULL;

  log_debug('Starting procedure for mode=' || p_mode || ', table=' || p_table);

  -- Validate mode input
  IF p_mode NOT IN ('C','U','D','F') THEN
    p_message := 'Invalid mode. Allowed values: C (Create), U (Update), D (Delete), F (Fetch metadata).';
    RETURN;
  END IF;

  -- Load table metadata
  load_metadata;
  log_debug('Metadata loaded: ' || v_col_cnt || ' columns, ' || v_pk_cnt || ' primary key columns.');

  IF p_mode = 'F' THEN
    -- Return metadata JSON and sample payloads
    p_message := sample_payload_json;
    p_status := 'S';
    RETURN;
  END IF;

  -- Parse JSON payload
  v_json_obj := JSON_OBJECT_T.parse(p_payload);
  log_debug('Payload parsed.');

  -- Validate mandatory columns if C or U
  IF p_mode IN ('C', 'U') THEN
    validate_mandatory_cols;
    log_debug('Mandatory columns validation passed.');
  END IF;

  -- Build dynamic DML and execute with DBMS_SQL
  IF p_mode = 'C' THEN
    -- INSERT
    v_sql := 'INSERT INTO ' || p_table || ' (';
    FOR i IN 1 .. v_col_cnt LOOP
      IF v_json_obj.has(v_columns(i).column_name) THEN
        IF i > 1 AND v_sql NOT LIKE '%($' THEN
          v_sql := v_sql || ', ';
        END IF;
        v_sql := v_sql || v_columns(i).column_name;
      END IF;
    END LOOP;
    v_sql := v_sql || ') VALUES (';
    FOR i IN 1 .. v_col_cnt LOOP
      IF v_json_obj.has(v_columns(i).column_name) THEN
        IF i > 1 AND v_sql NOT LIKE '%($' THEN
          v_sql := v_sql || ', ';
        END IF;
        v_sql := v_sql || ':' || v_columns(i).column_name;
      END IF;
    END LOOP;
    v_sql := v_sql || ')';

    log_debug('Insert SQL: ' || v_sql);

    DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);

    -- Bind variables
    v_bind_idx := 0;
    FOR i IN 1 .. v_col_cnt LOOP
      IF v_json_obj.has(v_columns(i).column_name) THEN
        v_bind_idx := v_bind_idx + 1;
        v_col_meta := v_columns(i);

        IF v_col_meta.data_type LIKE 'VARCHAR2%' THEN
          v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_varchar);

        ELSIF v_col_meta.data_type LIKE 'NUMBER%' THEN
          v_col_value_number := v_json_obj.get_Number(v_col_meta.column_name);
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_number);

        ELSIF v_col_meta.data_type LIKE 'DATE%' THEN
          -- Parse ISO8601 to DATE
          v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
          v_col_value_date := TO_TIMESTAMP_TZ(v_col_value_varchar, 'YYYY-MM-DD"T"HH24:MI:SS.FF TZH:TZM');
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_date);

        ELSIF v_col_meta.data_type = 'RAW' THEN
          -- Expect 32 char hex string for UUID
          v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
          v_col_value_raw := hex_to_raw16(v_col_value_varchar);
          IF v_col_value_raw IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Invalid UUID format for column ' || v_col_meta.column_name);
          END IF;
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_raw);

        ELSE
          -- Default varchar2
          v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_varchar);
        END IF;
      END IF;
    END LOOP;

    -- Execute statement
    IF DBMS_SQL.EXECUTE(v_cursor) = 1 THEN
      p_status := 'S';
      p_message := 'Insert successful';
    ELSE
      p_status := 'E';
      p_message := 'Insert affected ' || SQL%ROWCOUNT || ' rows (expected 1).';
    END IF;
    DBMS_SQL.CLOSE_CURSOR(v_cursor);

  ELSIF p_mode = 'U' THEN
    -- UPDATE: SET columns present in payload except PK; WHERE pk cols from payload

    v_sql := 'UPDATE ' || p_table || ' SET ';
    DECLARE 
      v_sep BOOLEAN := FALSE;
    BEGIN
      FOR i IN 1 .. v_col_cnt LOOP
        IF v_json_obj.has(v_columns(i).column_name) AND NOT v_pk_cols.exists(v_pk_cols.FIRST) THEN
          IF v_pk_cols.exists(i) AND v_pk_cols(i) = v_columns(i).column_name THEN
            NULL; -- skip PK columns for SET clause
          ELSE
            IF v_sep THEN
              v_sql := v_sql || ', ';
            END IF;
            v_sql := v_sql || v_columns(i).column_name || ' = :' || v_columns(i).column_name;
            v_sep := TRUE;
          END IF;
        END IF;
      END LOOP;
    END;
    -- WHERE clause with PK columns
    v_sql := v_sql || ' WHERE ';
    FOR i IN 1 .. v_pk_cnt LOOP
      IF i > 1 THEN
        v_sql := v_sql || ' AND ';
      END IF;
      v_sql := v_sql || v_pk_cols(i) || ' = :' || v_pk_cols(i);
    END LOOP;

    log_debug('Update SQL: ' || v_sql);

    DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);

    -- Bind SET columns values
    FOR i IN 1 .. v_col_cnt LOOP
      IF v_json_obj.has(v_columns(i).column_name) THEN
        IF v_pk_cols.EXISTS(1) AND v_pk_cols.exists(i) AND v_pk_pk_cols(i) = v_columns(i).column_name THEN
          NULL; -- skip here, will bind below as PK
        ELSE
          v_col_meta := v_columns(i);
          IF v_col_meta.data_type LIKE 'VARCHAR2%' THEN
            v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
            DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_varchar);
          ELSIF v_col_meta.data_type LIKE 'NUMBER%' THEN
            v_col_value_number := v_json_obj.get_Number(v_col_meta.column_name);
            DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_number);
          ELSIF v_col_meta.data_type LIKE 'DATE%' THEN
            v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
            v_col_value_date := TO_TIMESTAMP_TZ(v_col_value_varchar, 'YYYY-MM-DD"T"HH24:MI:SS.FF TZH:TZM');
            DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_date);
          ELSIF v_col_meta.data_type = 'RAW' THEN
            v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
            v_col_value_raw := hex_to_raw16(v_col_value_varchar);
            IF v_col_value_raw IS NULL THEN
              RAISE_APPLICATION_ERROR(-20003, 'Invalid UUID format for column ' || v_col_meta.column_name);
            END IF;
            DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_raw);
          ELSE
            v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
            DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_varchar);
          END IF;
        END IF;
      END IF;
    END LOOP;

    -- Bind PK columns for WHERE clause
    FOR i IN 1 .. v_pk_cnt LOOP
      v_col_meta.column_name := v_pk_cols(i);
      -- Push PK metadata to find data_type
      FOR j IN 1 .. v_col_cnt LOOP
        IF v_columns(j).column_name = v_col_meta.column_name THEN
          v_col_meta := v_columns(j);
          EXIT;
        END IF;
      END LOOP;

      IF NOT v_json_obj.has(v_col_meta.column_name) THEN
        RAISE_APPLICATION_ERROR(-20004, 'Primary key column missing in payload for UPDATE: ' || v_col_meta.column_name);
      END IF;

      IF v_col_meta.data_type LIKE 'VARCHAR2%' THEN
        v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
        DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_varchar);
      ELSIF v_col_meta.data_type LIKE 'NUMBER%' THEN
        v_col_value_number := v_json_obj.get_Number(v_col_meta.column_name);
        DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_number);
      ELSIF v_col_meta.data_type LIKE 'DATE%' THEN
        v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
        v_col_value_date := TO_TIMESTAMP_TZ(v_col_value_varchar, 'YYYY-MM-DD"T"HH24:MI:SS.FF TZH:TZM');
        DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_date);
      ELSIF v_col_meta.data_type = 'RAW' THEN
        v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
        v_col_value_raw := hex_to_raw16(v_col_value_varchar);
        IF v_col_value_raw IS NULL THEN
          RAISE_APPLICATION_ERROR(-20003, 'Invalid UUID format for column ' || v_col_meta.column_name);
        END IF;
        DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_raw);
      ELSE
        v_col_value_varchar := v_json_obj.get_String(v_col_meta.column_name);
        DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_meta.column_name, v_col_value_varchar);
      END IF;
    END LOOP;

    IF DBMS_SQL.EXECUTE(v_cursor) >= 0 THEN
      p_status := 'S';
      p_message := 'Update successful.';
    ELSE
      p_status := 'E';
      p_message := 'Update affected zero rows.';
    END IF;
    DBMS_SQL.CLOSE_CURSOR(v_cursor);

  ELSIF p_mode = 'D' THEN
    -- DELETE: WHERE clause on PK columns

    IF v_pk_cnt = 0 THEN
      RAISE_APPLICATION_ERROR(-20005, 'Table ' || p_table || ' does not have a primary key; cannot delete generically.');
    END IF;

    v_sql := 'DELETE FROM ' || p_table || ' WHERE ';
    FOR i IN 1 .. v_pk_cnt LOOP
      IF i > 1 THEN
        v_sql := v_sql || ' AND ';
      END IF;
      v_sql := v_sql || v_pk_cols(i) || ' = :' || v_pk_cols(i);
    END LOOP;

    log_debug('Delete SQL: ' || v_sql);

    DBMS_SQL.PARSE(v_cursor, v_sql, DBMS_SQL.NATIVE);

    -- Bind PK values
    FOR i IN 1 .. v_pk_cnt LOOP
      DECLARE
        v_col_name VARCHAR2(100) := v_pk_cols(i);
        v_col_type VARCHAR2(30);
        v_val_varchar VARCHAR2(4000);
        v_val_number NUMBER;
        v_val_date DATE;
        v_val_raw RAW(16);
      BEGIN
        FOR j IN 1 .. v_col_cnt LOOP
          IF v_columns(j).column_name = v_col_name THEN
            v_col_type := v_columns(j).data_type;
            EXIT;
          END IF;
        END LOOP;

        IF NOT v_json_obj.has(v_col_name) THEN
          RAISE_APPLICATION_ERROR(-20006, 'Primary key ' || v_col_name || ' missing from payload for DELETE');
        END IF;

        IF v_col_type LIKE 'VARCHAR2%' THEN
          v_val_varchar := v_json_obj.get_String(v_col_name);
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_name, v_val_varchar);
        ELSIF v_col_type LIKE 'NUMBER%' THEN
          v_val_number := v_json_obj.get_Number(v_col_name);
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_name, v_val_number);
        ELSIF v_col_type LIKE 'DATE%' THEN
          v_val_varchar := v_json_obj.get_String(v_col_name);
          v_val_date := TO_TIMESTAMP_TZ(v_val_varchar, 'YYYY-MM-DD"T"HH24:MI:SS.FF TZH:TZM');
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_name, v_val_date);
        ELSIF v_col_type = 'RAW' THEN
          v_val_varchar := v_json_obj.get_String(v_col_name);
          v_val_raw := hex_to_raw16(v_val_varchar);
          IF v_val_raw IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Invalid UUID format for column ' || v_col_name);
          END IF;
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_name, v_val_raw);
        ELSE
          v_val_varchar := v_json_obj.get_String(v_col_name);
          DBMS_SQL.BIND_VARIABLE(v_cursor, ':' || v_col_name, v_val_varchar);
        END IF;
      END;
    END LOOP;

    IF DBMS_SQL.EXECUTE(v_cursor) >= 0 THEN
      p_status := 'S';
      p_message := 'Delete successful.';
    ELSE
      p_status := 'E';
      p_message := 'Delete affected zero rows.';
    END IF;
    DBMS_SQL.CLOSE_CURSOR(v_cursor);

  END IF;

EXCEPTION
  WHEN JSON_VALUE_ERROR THEN
    p_status := 'E';
    p_message := 'Invalid JSON input.';
  WHEN OTHERS THEN
    IF DBMS_SQL.IS_OPEN(v_cursor) THEN
      DBMS_SQL.CLOSE_CURSOR(v_cursor);
    END IF;
    p_status := 'E';
    p_message := 'Error: ' || SQLERRM;
END generic_crud_proc;
/
create or replace PROCEDURE json_to_apex_collection(
    p_collection_name IN VARCHAR2,
    p_json_clob       IN CLOB,
    p_status          OUT VARCHAR2,
    p_message         OUT VARCHAR2
)
AS
    v_json_arr   apex_json.t_values;  -- apex_json collection variable
    v_count      INTEGER;
    v_keys       apex_t_varchar2; -- list of all unique keys found (max 10)
    v_rec_values apex_t_varchar2; -- temp holding values of one JSON object
    v_obj        PLS_INTEGER;
    v_key        VARCHAR2(255);
    v_path       VARCHAR2(1000);
    
    -- procedure to flatten keys from a JSON object recursively
    PROCEDURE flatten_keys(
        p_path IN VARCHAR2,
        p_obj IN apex_json.t_values
    ) IS
        v_sub_keys apex_t_varchar2;
        v_key_count INTEGER;
        v_sub_key VARCHAR2(200);
        v_full_key VARCHAR2(400);
        v_i PLS_INTEGER;
    BEGIN
        IF apex_json.get_type(p_obj) = apex_json.c_object THEN
            v_sub_keys := apex_json.get_keys(p_obj);
            v_key_count := v_sub_keys.COUNT;
            FOR v_i IN 1 .. v_key_count LOOP
                v_sub_key := v_sub_keys(v_i);
                IF p_path IS NULL THEN
                    v_full_key := v_sub_key;
                ELSE
                    v_full_key := p_path || '_' || v_sub_key;
                END IF;
                -- Check if key is not already in list, add it (max 10 keys)
                IF v_keys.COUNT < 10 AND v_keys.EXISTS(v_full_key) = FALSE THEN
                    IF NOT v_keys.EXISTS(v_full_key) AND NOT (v_full_key MEMBER OF v_keys) THEN
                        v_keys.EXTEND;
                        v_keys(v_keys.COUNT) := v_full_key;
                    END IF;
                END IF;
                -- Now check if this key's value is object -> recurse
                IF apex_json.get_type(apex_json.get_value(p_obj,v_sub_key)) = apex_json.c_object THEN
                    flatten_keys(v_full_key, apex_json.get_value(p_obj,v_sub_key));
                END IF;
            END LOOP;
        END IF;
    END flatten_keys;
    
    -- procedure to get value for a flattened key path, for one JSON object
    FUNCTION get_flat_value(
        p_obj IN apex_json.t_values,
        p_key_path IN VARCHAR2
    ) RETURN VARCHAR2 IS
        v_parts apex_t_varchar2 := apex_string.split(p_key_path,'_');
        v_val apex_json.t_values := p_obj;
        v_i PLS_INTEGER;
        v_ret VARCHAR2(4000);
    BEGIN
        FOR v_i IN 1 .. v_parts.count LOOP
            IF apex_json.get_type(v_val) = apex_json.c_object THEN
                v_val := apex_json.get_value(v_val, v_parts(v_i));
            ELSE
                RETURN NULL;
            END IF;
        END LOOP;
        
        -- Now v_val is the final JSON scalar value - convert to string
        CASE apex_json.get_type(v_val)
            WHEN apex_json.c_null THEN v_ret := NULL;
            WHEN apex_json.c_string THEN v_ret := apex_json.get_varchar2(v_val);
            WHEN apex_json.c_number THEN v_ret := TO_CHAR(apex_json.get_number(v_val));
            WHEN apex_json.c_boolean THEN
                IF apex_json.get_boolean(v_val) THEN
                    v_ret := 'TRUE';
                ELSE
                    v_ret := 'FALSE';
                END IF;
            ELSE
                v_ret := apex_json.to_clob(v_val); -- fallback to string
        END CASE;
        RETURN v_ret;
    EXCEPTION WHEN OTHERS THEN
        RETURN NULL;
    END;
    
BEGIN
    p_status := NULL;
    p_message := NULL;
    
    IF p_collection_name IS NULL OR TRIM(p_collection_name) = '' THEN
        p_status := 'E';
        p_message := 'Collection name must not be empty';
        RETURN;
    END IF;
    IF p_json_clob IS NULL OR DBMS_LOB.GETLENGTH(p_json_clob) = 0 THEN
        p_status := 'E';
        p_message := 'JSON CLOB input empty';
        RETURN;
    END IF;
    
    -- Delete existing collection if exists
    IF apex_collection.collection_exists(p_collection_name) THEN
        apex_collection.delete_collection(p_collection_name);
    END IF;
    
    apex_collection.create_collection(p_collection_name);
    
    BEGIN
        -- parse json array from clob
        apex_json.parse(p_json_clob);
        
        IF apex_json.get_type(NULL) != apex_json.c_array THEN
            -- Not an array at root
            p_status := 'E';
            p_message := 'Input JSON is not an array at root';
            RETURN;
        END IF;
        
    EXCEPTION WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'Error parsing JSON: ' || SQLERRM;
        RETURN;
    END;
    
    v_count := apex_json.get_count(NULL);
    IF v_count = 0 THEN
        p_status := 'W';
        p_message := 'JSON array is empty';
        RETURN;
    END IF;
    
    -- Clear keys list
    v_keys := apex_t_varchar2();
    
    -- Extract keys with flattening from first element only (for columns)
    flatten_keys(NULL, apex_json.get_values(NULL)(1));

    -- Ensure max 10 keys (APEX_COLLECTION limit)
    IF v_keys.COUNT > 10 THEN
        p_status := 'W';
        p_message := 'Too many keys in JSON, only first 10 keys processed';
        v_keys.TRIM(v_keys.COUNT - 10);
    END IF;
    
    -- Now loop through each JSON object in array and insert rows
    FOR v_obj IN 1 .. v_count LOOP
        v_rec_values := apex_t_varchar2();
        -- For each key in v_keys get the flattened string value for object
        FOR i IN 1 .. v_keys.COUNT LOOP
            v_rec_values.EXTEND;
            v_rec_values(i) := get_flat_value(apex_json.get_values(NULL)(v_obj), v_keys(i));
            -- NULLs allowed
        END LOOP;
        
        -- Insert to collection row with C001..C010
        apex_collection.add_member(
            p_collection_name => p_collection_name,
            p_c001 => CASE WHEN v_keys.COUNT >= 1 THEN v_rec_values(1) ELSE NULL END,
            p_c002 => CASE WHEN v_keys.COUNT >= 2 THEN v_rec_values(2) ELSE NULL END,
            p_c003 => CASE WHEN v_keys.COUNT >= 3 THEN v_rec_values(3) ELSE NULL END,
            p_c004 => CASE WHEN v_keys.COUNT >= 4 THEN v_rec_values(4) ELSE NULL END,
            p_c005 => CASE WHEN v_keys.COUNT >= 5 THEN v_rec_values(5) ELSE NULL END,
            p_c006 => CASE WHEN v_keys.COUNT >= 6 THEN v_rec_values(6) ELSE NULL END,
            p_c007 => CASE WHEN v_keys.COUNT >= 7 THEN v_rec_values(7) ELSE NULL END,
            p_c008 => CASE WHEN v_keys.COUNT >= 8 THEN v_rec_values(8) ELSE NULL END,
            p_c009 => CASE WHEN v_keys.COUNT >= 9 THEN v_rec_values(9) ELSE NULL END,
            p_c010 => CASE WHEN v_keys.COUNT >= 10 THEN v_rec_values(10) ELSE NULL END
        );
    END LOOP;
    
    -- Optionally add headers as one extra member at beginning or store keys in collection name reference
    
    p_status := 'S';
    p_message := 'Added ' || v_count || ' rows with ' || v_keys.COUNT || ' columns to APEX collection "' || p_collection_name || '"';

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'Unexpected error: ' || SQLERRM;
END json_to_apex_collection;
/
create or replace PROCEDURE json_to_collection (
    p_collection_name IN  VARCHAR2,
    p_json_clob       IN  CLOB,
    p_status          OUT VARCHAR2,
    p_message         OUT VARCHAR2
)
AS
    /**************************************************************************************************
    * Procedure: json_to_collection (Backward-Compatible Version)
    * Author:    Gemini
    * Date:      15-OCT-2025
    *
    * Description:
    * Parses a JSON CLOB and populates an APEX collection. This version is designed for
    * maximum compatibility with older APEX versions (pre-18.1).
    *
    * - It uses EXECUTE IMMEDIATE instead of the newer APEX_EXEC package.
    * - It uses APEX_JSON.GET_DATA_TYPE instead of IS_OBJECT/IS_ARRAY.
    * - Flattens nested JSON objects.
    * - Creates a header row (seq_id=1) and subsequent data rows.
    *
    * Parameters:
    * p_collection_name (IN)  - The name of the APEX collection.
    * p_json_clob       (IN)  - The JSON CLOB to process.
    * p_status          (OUT) - Result status: 'S' (Success), 'E' (Error), 'W' (Warning).
    * p_message         (OUT) - A message describing the outcome.
    **************************************************************************************************/

    l_json_values   apex_json.t_values;
    l_headers       apex_t_varchar2;
    l_json_paths    apex_t_varchar2;
    l_array_count   PLS_INTEGER;

    -- Recursively finds all leaf-node keys and their full paths.
    PROCEDURE find_paths (
        p_path        IN VARCHAR2,
        p_prefix_path IN VARCHAR2
    )
    IS
        l_keys apex_t_varchar2;
    BEGIN
        l_keys := apex_json.get_members(p_values => l_json_values, p_path => p_path);

        FOR i IN 1 .. l_keys.count LOOP
            DECLARE
                l_key          VARCHAR2(255)  := l_keys(i);
                l_current_path VARCHAR2(4000) := p_path || '.' || l_key;
                l_final_path   VARCHAR2(4000) := p_prefix_path || l_key;
            BEGIN
                -- Changed: Using get_data_type for backward compatibility instead of is_object.
                IF apex_json.get_data_type(p_values => l_json_values, p_path => l_current_path) = 'object' THEN
                    find_paths(
                        p_path        => l_current_path,
                        p_prefix_path => l_final_path || '.'
                    );
                ELSE
                    apex_string.push(l_headers, l_key);
                    apex_string.push(l_json_paths, l_final_path);
                END IF;
            END;
        END LOOP;
    END find_paths;

BEGIN
    -- 1. Initialize and clean the collection
    p_status := 'S';
    p_message := 'Collection "' || p_collection_name || '" populated successfully.';
    apex_collection.create_or_truncate_collection(p_collection_name => p_collection_name);

    -- 2. Validate Input
    IF p_json_clob IS NULL OR dbms_lob.getlength(p_json_clob) = 0 THEN
        p_status := 'W';
        p_message := 'Input JSON is empty. Collection was cleared.';
        RETURN;
    END IF;

    -- 3. Parse and Validate JSON structure
    apex_json.parse(p_values => l_json_values, p_source => p_json_clob);

    -- Changed: Using get_data_type for backward compatibility instead of is_array.
    IF apex_json.get_data_type(p_values => l_json_values, p_path => '.') <> 'array' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Input CLOB is not a valid JSON array.');
    END IF;

    l_array_count := apex_json.get_count(p_values => l_json_values, p_path => '.');
    IF l_array_count = 0 THEN
        p_status := 'W';
        p_message := 'Input JSON array is empty. Collection was cleared.';
        RETURN;
    END IF;

    -- 4. Discover keys/headers from the first object
    find_paths(p_path => '[1]', p_prefix_path => '');

    IF l_headers.count = 0 THEN
        p_status := 'W';
        p_message := 'JSON objects appear to be empty. Collection was cleared.';
        RETURN;
    END IF;

    IF l_headers.count > 50 THEN
        RAISE_APPLICATION_ERROR(-20002, 'JSON has >50 flattened attributes, exceeding APEX collection column limit.');
    END IF;

    -- 5. Add Header Row (seq_id = 1)
    -- Changed: Replaced apex_exec with EXECUTE IMMEDIATE for backward compatibility.
    DECLARE
        l_sql VARCHAR2(4000);
    BEGIN
        l_sql := 'BEGIN apex_collection.add_member(p_collection_name => ''' || p_collection_name || '''';
        FOR i IN 1 .. l_headers.count LOOP
            -- Escape single quotes in header names, just in case
            l_sql := l_sql || ', p_c' || LPAD(i, 3, '0') || ' => ''' || REPLACE(l_headers(i), '''', '''''') || '''';
        END LOOP;
        l_sql := l_sql || '); END;';
        EXECUTE IMMEDIATE l_sql;
    END;

    -- 6. Add Data Rows (seq_id >= 2)
    FOR i IN 1 .. l_array_count LOOP
        DECLARE
            l_sql   VARCHAR2(32767);
            l_value VARCHAR2(4000);
        BEGIN
            l_sql := 'BEGIN apex_collection.add_member(p_collection_name => ''' || p_collection_name || '''';
            FOR j IN 1 .. l_json_paths.count LOOP
                l_value := apex_json.get_varchar2(
                               p_values => l_json_values,
                               p_path   => '[%s].%s',
                               p0       => i,
                               p1       => l_json_paths(j)
                           );
                -- Escape single quotes in the data value to prevent PL/SQL errors
                l_sql := l_sql || ', p_c' || LPAD(j, 3, '0') || ' => ''' || REPLACE(l_value, '''', '''''') || '''';
            END LOOP;
            l_sql := l_sql || '); END;';
            EXECUTE IMMEDIATE l_sql;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'An unexpected error occurred: ' || SQLERRM;
END json_to_collection;
/
create or replace PROCEDURE load_data_standalone (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT BOOLEAN,
    p_message         OUT VARCHAR2
) IS
    l_blob        BLOB;
    l_file_name   VARCHAR2(255);
    l_table_name  VARCHAR2(255);
    l_template_id RAW(16);
    l_log_id      RAW(16);
    l_apex_user   VARCHAR2(255) := NVL(v('APP_USER'),'APEX_USER');

    TYPE t_map_rec IS RECORD (
        src_col     VARCHAR2(128),
        tgt_col     VARCHAR2(128),
        parser_col  VARCHAR2(20),
        data_type   VARCHAR2(50)
    );

    TYPE t_map IS TABLE OF t_map_rec INDEX BY VARCHAR2(128);
    l_mapping t_map;

    l_cols        VARCHAR2(32767);
    l_vals        VARCHAR2(32767);
    l_insert_vals VARCHAR2(32767);
    l_update_list VARCHAR2(32767);
    l_sql         CLOB;
    k             VARCHAR2(128);
    l_key_col     VARCHAR2(128);  -- dynamic key column (STAY_DATE)
BEGIN
    -- 0. Get file blob and name
    SELECT blob_content, filename
      INTO l_blob, l_file_name
      FROM temp_blob
     WHERE id = p_file_id;

    -- 1. Get target table + template
    SELECT db_object_name, id
      INTO l_table_name, l_template_id
      FROM ur_templates
     WHERE upper(id) = upper(p_template_key);

    -- 2. Insert interface log
    l_log_id := sys_guid();
    INSERT INTO ur_interface_logs(
        id, hotel_id, template_id, interface_type, load_start_time,
        load_status, created_by, updated_by, created_on, updated_on, file_id
    ) VALUES (
        l_log_id, p_hotel_id, l_template_id, 'UPLOAD', SYSTIMESTAMP,
        'IN_PROGRESS',
        hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
        hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
        SYSDATE, SYSDATE, p_file_id
    );

    -- 3. Load mapping from collection
    FOR rec IN (
        SELECT regexp_substr(c001, '^[^(]+') src_col,
               regexp_substr(c002, '^[^(]+') tgt_col,
               TRIM(c004) parser_col,
               UPPER(regexp_replace(c001, '^[^(]+\(([^)]+)\).*', '\1')) datatype
          FROM apex_collections
         WHERE collection_name = p_collection_name
           AND c003 = 'Maps To'
           AND c004 IS NOT NULL
    ) LOOP
        l_mapping(UPPER(TRIM(rec.src_col))).src_col    := TRIM(rec.src_col);
        l_mapping(UPPER(TRIM(rec.src_col))).tgt_col    := TRIM(rec.tgt_col);
        l_mapping(UPPER(TRIM(rec.src_col))).parser_col := TRIM(rec.parser_col);
        l_mapping(UPPER(TRIM(rec.src_col))).data_type  := TRIM(rec.datatype);

        -- Identify key column dynamically
        IF UPPER(TRIM(rec.tgt_col)) = 'STAY_DATE' THEN
            l_key_col := TRIM(rec.parser_col);  -- e.g., COL003
        END IF;
    END LOOP;

    IF l_mapping.COUNT = 0 OR l_key_col IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'No mapped columns or key column (STAY_DATE) found!');
    END IF;

    -- 4. Build dynamic SELECT, UPDATE, INSERT parts
    k := l_mapping.FIRST;
    WHILE k IS NOT NULL LOOP
        IF l_mapping.EXISTS(k) THEN
            -- SELECT part
            IF l_vals IS NOT NULL THEN l_vals := l_vals || ', '; END IF;
            l_vals := l_vals || 'p.'||l_mapping(k).parser_col||' AS "'||l_mapping(k).tgt_col||'"';

            -- UPDATE list (skip key columns)
            IF l_mapping(k).tgt_col NOT IN ('HOTEL_ID','STAY_DATE') THEN
                IF l_update_list IS NOT NULL THEN l_update_list := l_update_list || ', '; END IF;
                IF l_mapping(k).data_type = 'NUMBER' THEN
                    l_update_list := l_update_list || '"'||l_mapping(k).tgt_col||'" = CASE WHEN REGEXP_LIKE(src.'||l_mapping(k).parser_col||',''^-?\d+(\.\d+)?$'') THEN TO_NUMBER(src.'||l_mapping(k).parser_col||') ELSE NULL END';
                ELSIF l_mapping(k).data_type = 'DATE' THEN
                    l_update_list := l_update_list || '"'||l_mapping(k).tgt_col||'" = TO_DATE(src.'||l_mapping(k).parser_col||', ''YYYY-MM-DD'')';
                ELSE
                    l_update_list := l_update_list || '"'||l_mapping(k).tgt_col||'" = src.'||l_mapping(k).parser_col;
                END IF;
            END IF;

            -- INSERT values
            IF l_insert_vals IS NOT NULL THEN l_insert_vals := l_insert_vals || ', '; END IF;
            l_insert_vals := l_insert_vals || 'src.'||l_mapping(k).parser_col;
        END IF;
        k := l_mapping.NEXT(k);
    END LOOP;

    -- Build column list for INSERT
    l_cols := '';
    k := l_mapping.FIRST;
    WHILE k IS NOT NULL LOOP
        IF l_mapping.EXISTS(k) THEN
            IF l_cols IS NOT NULL AND l_cols <> '' THEN l_cols := l_cols || ', '; END IF;
            l_cols := l_cols || '"'||l_mapping(k).tgt_col||'"';
        END IF;
        k := l_mapping.NEXT(k);
    END LOOP;

    -- 5. Build dynamic MERGE SQL
    l_sql := '
MERGE INTO '||l_table_name||' tgt
USING (
    SELECT :hotel_id AS HOTEL_ID, '||l_vals||'
    FROM TABLE(apex_data_parser.parse(p_content => :b1, p_file_name => :b2)) p
    WHERE p.line_number > 1
) src
ON (tgt.HOTEL_ID = src.HOTEL_ID AND tgt."'||UPPER(l_key_col)||'" = src."'||UPPER(l_key_col)||'")
WHEN MATCHED THEN
    UPDATE SET '||l_update_list||'
WHEN NOT MATCHED THEN
    INSERT (HOTEL_ID, '||l_cols||')
    SELECT :hotel_id, '||l_insert_vals||' FROM src';

    -- Debug log
    INSERT INTO debug_log(message) VALUES('MERGE SQL: '||l_sql);
    COMMIT;

    -- 6. Execute dynamic MERGE
    EXECUTE IMMEDIATE l_sql
      USING p_hotel_id, l_blob, l_file_name;

    -- 7. Update interface log
    UPDATE ur_interface_logs
       SET load_end_time = SYSTIMESTAMP,
           load_status = 'SUCCESS',
           updated_by = hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
           updated_on = SYSDATE
     WHERE id = l_log_id;

    COMMIT;

    p_status := TRUE;
    p_message := 'Success: Upload completed. Rows='||SQL%ROWCOUNT;

EXCEPTION
    WHEN OTHERS THEN
        p_status := FALSE;
        p_message := 'Failure: '||SQLERRM;
        INSERT INTO debug_log(message) VALUES('ERROR: '||SQLERRM);
        COMMIT;

        UPDATE ur_interface_logs
           SET load_end_time = SYSTIMESTAMP,
               load_status = 'FAILED',
               updated_by = hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
               updated_on = SYSDATE
         WHERE id = l_log_id;

        ROLLBACK;
END load_data_standalone;
/
create or replace PROCEDURE load_data_t (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT BOOLEAN,
    p_message         OUT VARCHAR2
) IS
    l_blob        BLOB;
    l_file_name   VARCHAR2(255);
    l_table_name  VARCHAR2(255);
    l_template_id RAW(16);
    l_log_id      RAW(16);
    l_apex_user   VARCHAR2(255) := NVL(v('APP_USER'),'APEX_USER');

    TYPE t_map_rec IS RECORD (
        src_col     VARCHAR2(128),
        tgt_col     VARCHAR2(128),
        parser_col  VARCHAR2(20),
        data_type   VARCHAR2(50)
    );

    TYPE t_map IS TABLE OF t_map_rec INDEX BY VARCHAR2(128);
    l_mapping t_map;

    l_cols VARCHAR2(32767);
    l_vals VARCHAR2(32767);
    l_update_list VARCHAR2(32767);
    l_sql CLOB;
    k VARCHAR2(128);
    l_key_col VARCHAR2(128);  -- dynamic key column (e.g., STAY_DATE)
BEGIN
    -- 0. Get file blob and name
    SELECT blob_content, filename
      INTO l_blob, l_file_name
      FROM temp_blob
     WHERE id = p_file_id;

    -- 1. Get target table + template
    SELECT db_object_name, id
      INTO l_table_name, l_template_id
      FROM ur_templates
     WHERE upper(id) = upper(p_template_key);

    -- 2. Insert interface log
    l_log_id := sys_guid();
    INSERT INTO ur_interface_logs(
        id, hotel_id, template_id, interface_type, load_start_time,
        load_status, created_by, updated_by, created_on, updated_on, file_id
    ) VALUES (
        l_log_id, p_hotel_id, l_template_id, 'UPLOAD', SYSTIMESTAMP,
        'IN_PROGRESS',
        hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
        hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
        SYSDATE, SYSDATE, p_file_id
    );

    -- 3. Load mapping from collection
    FOR rec IN (
        SELECT regexp_substr(c001, '^[^(]+') src_col,
               regexp_substr(c002, '^[^(]+') tgt_col,
               TRIM(c004) parser_col,
               UPPER(regexp_replace(c001, '^[^(]+\(([^)]+)\).*', '\1')) datatype
          FROM apex_collections
         WHERE collection_name = p_collection_name
           AND c003 = 'Maps To'
           AND c004 IS NOT NULL
    ) LOOP
        l_mapping(UPPER(TRIM(rec.src_col))).src_col    := TRIM(rec.src_col);
        l_mapping(UPPER(TRIM(rec.src_col))).tgt_col    := TRIM(rec.tgt_col);
        l_mapping(UPPER(TRIM(rec.src_col))).parser_col := TRIM(rec.parser_col);
        l_mapping(UPPER(TRIM(rec.src_col))).data_type  := TRIM(rec.datatype);

        -- Identify key column dynamically
        IF UPPER(TRIM(rec.tgt_col)) = 'STAY_DATE' THEN
            l_key_col := TRIM(rec.parser_col);  -- e.g., COL003
        END IF;
    END LOOP;

    IF l_mapping.COUNT = 0 OR l_key_col IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001,'No mapped columns or key column (STAY_DATE) found!');
    END IF;

    -- 4. Build dynamic SELECT, UPDATE, INSERT parts
    k := l_mapping.FIRST;
    WHILE k IS NOT NULL LOOP
        IF l_mapping.EXISTS(k) THEN
            -- SELECT part
            IF l_vals IS NOT NULL THEN l_vals := l_vals || ', '; END IF;
            l_vals := l_vals || 'p.'||l_mapping(k).parser_col||' AS "'||l_mapping(k).tgt_col||'"';

            -- UPDATE list (skip key columns)
            IF l_mapping(k).tgt_col NOT IN ('HOTEL_ID','STAY_DATE') THEN
                IF l_update_list IS NOT NULL THEN l_update_list := l_update_list || ', '; END IF;
                IF l_mapping(k).data_type = 'NUMBER' THEN
                    l_update_list := l_update_list || '"'||l_mapping(k).tgt_col||'" = CASE WHEN REGEXP_LIKE(src.'||l_mapping(k).parser_col||',''^-?\d+(\.\d+)?$'') THEN TO_NUMBER(src.'||l_mapping(k).parser_col||') ELSE NULL END';
                ELSIF l_mapping(k).data_type = 'DATE' THEN
                    l_update_list := l_update_list || '"'||l_mapping(k).tgt_col||'" = TO_DATE(src.'||l_mapping(k).parser_col||', ''YYYY-MM-DD'')';
                ELSE
                    l_update_list := l_update_list || '"'||l_mapping(k).tgt_col||'" = src.'||l_mapping(k).parser_col;
                END IF;
            END IF;
        END IF;
        k := l_mapping.NEXT(k);
    END LOOP;

    -- Build column list for INSERT
    l_cols := '';
    k := l_mapping.FIRST;
    WHILE k IS NOT NULL LOOP
        IF l_mapping.EXISTS(k) THEN
            IF l_cols IS NOT NULL AND l_cols <> '' THEN l_cols := l_cols || ', '; END IF;
            l_cols := l_cols || '"'||l_mapping(k).tgt_col||'"';
        END IF;
        k := l_mapping.NEXT(k);
    END LOOP;

    -- 5. Build dynamic MERGE SQL
    l_sql := '
MERGE INTO '||l_table_name||' tgt
USING (
    SELECT :hotel_id AS HOTEL_ID, '||l_vals||'
    FROM TABLE(apex_data_parser.parse(p_content => :b1, p_file_name => :b2)) p
    WHERE p.line_number > 1
) src
ON (tgt.HOTEL_ID = src.HOTEL_ID AND tgt."'||UPPER(l_key_col)||'" = src."'||UPPER(l_key_col)||'")
WHEN MATCHED THEN
    UPDATE SET '||l_update_list||'
WHEN NOT MATCHED THEN
    INSERT (HOTEL_ID, '||l_cols||')
    VALUES (:hotel_id, '||l_cols||')';

    INSERT INTO debug_log(message) VALUES('MERGE SQL: '||l_sql);
    COMMIT;

    -- 6. Execute dynamic MERGE
    EXECUTE IMMEDIATE l_sql
      USING p_hotel_id, l_blob, l_file_name, p_hotel_id;

    -- 7. Update interface log
    UPDATE ur_interface_logs
       SET load_end_time = SYSTIMESTAMP,
           load_status = 'SUCCESS',
           updated_by = hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
           updated_on = SYSDATE
     WHERE id = l_log_id;

    COMMIT;

    p_status := TRUE;
    p_message := 'Success: Upload completed. Rows='||SQL%ROWCOUNT;

EXCEPTION
    WHEN OTHERS THEN
        p_status := FALSE;
        p_message := 'Failure: '||SQLERRM;
        INSERT INTO debug_log(message) VALUES('ERROR: '||SQLERRM);
        COMMIT;
        UPDATE ur_interface_logs
           SET load_end_time = SYSTIMESTAMP,
               load_status = 'FAILED',
               updated_by = hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
               updated_on = SYSDATE
         WHERE id = l_log_id;
        ROLLBACK;
END load_data_t;
/
create or replace PROCEDURE match_templates(
    p_file_id      IN NUMBER,
    p_hotel_id     IN VARCHAR2,
    p_min_score    IN NUMBER DEFAULT 90,
    p_debug_flag   IN VARCHAR2 DEFAULT 'N',
    p_output_json  OUT CLOB,
    p_status       OUT VARCHAR2,
    p_message      OUT VARCHAR2
) IS
    -- Local types
    TYPE t_name_type_rec IS RECORD(
        name       VARCHAR2(100),
        data_type  VARCHAR2(30)
    );
    TYPE t_name_type_tab IS TABLE OF t_name_type_rec;

    TYPE t_template_rec IS RECORD(
        id         VARCHAR2(50),
        name       VARCHAR2(200),
        definition t_name_type_tab
    );
    TYPE t_template_tab IS TABLE OF t_template_rec INDEX BY PLS_INTEGER;

    -- Variables
    v_source_clob       CLOB;
    v_source_normalized CLOB;
    
    v_target_id         VARCHAR2(50);
    v_target_name       VARCHAR2(200);
    v_target_def_clob   CLOB;
    v_target_normalized CLOB;

    v_source_defs       t_name_type_tab := t_name_type_tab();
    v_target_defs       t_name_type_tab := t_name_type_tab();

    v_templates         t_template_tab;
    v_count_templates   PLS_INTEGER := 0;

    v_json_output       CLOB := '[';
    v_min_score_use     NUMBER;
    v_separator         VARCHAR2(1) := '';

    v_match_count       NUMBER;
    v_score             NUMBER;

    CURSOR c_targets IS
      SELECT ID, NAME, DEFINITION FROM UR_TEMPLATES WHERE hotel_id = p_hotel_id;

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
        idx     PLS_INTEGER := 0;
    BEGIN
        FOR rec IN (
            SELECT lower(trim(name)) AS name, lower(trim(data_type)) AS data_type FROM JSON_TABLE(
                p_clob,
                '$[*]' COLUMNS (
                    name VARCHAR2(100) PATH '$.name',
                    data_type VARCHAR2(30) PATH '$.data_type'
                )
            )
        ) LOOP
            idx := idx + 1;
            l_defs.EXTEND;
            l_defs(idx).name := rec.name;
            l_defs(idx).data_type := rec.data_type;
        END LOOP;
        RETURN l_defs;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;

    -- Count matches (name + data_type case-insensitive)
    FUNCTION count_matches(p_source t_name_type_tab, p_target t_name_type_tab) RETURN NUMBER IS
        v_count NUMBER := 0;
    BEGIN
        FOR i IN 1 .. p_source.COUNT LOOP
            FOR j IN 1 .. p_target.COUNT LOOP
                IF p_source(i).name = p_target(j).name AND p_source(i).data_type = p_target(j).data_type THEN
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

    IF p_file_id IS NULL THEN
        p_status := 'E';
        p_message := 'File ID must be provided';
        p_output_json := NULL;
        RETURN;
    END IF;

    IF p_hotel_id IS NULL THEN
        p_status := 'E';
        p_message := 'Hotel ID must be provided';
        p_output_json := NULL;
        RETURN;
    END IF;

    debug('Starting processing...');
    debug('File ID: ' || p_file_id);
    debug('Hotel ID: ' || p_hotel_id);
    debug('Minimum Score: ' || v_min_score_use);

    -- Fetch and normalize source CLOB
    BEGIN
        SELECT columns INTO v_source_clob FROM temp_blob WHERE id = p_file_id;
        IF v_source_clob IS NULL THEN
            p_status := 'E';
            p_message := 'Source definition not found for file_id ' || p_file_id;
            p_output_json := NULL;
            RETURN;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_status := 'E';
            p_message := 'Source file not found for id ' || p_file_id;
            p_output_json := NULL;
            RETURN;
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Error fetching source definition: ' || SQLERRM;
            p_output_json := NULL;
            RETURN;
    END;

    v_source_normalized := normalize_json(v_source_clob);

    -- Parse source defs
    v_source_defs := parse_definition(v_source_normalized);
    IF v_source_defs IS NULL OR v_source_defs.COUNT = 0 THEN
        p_status := 'E';
        p_message := 'Cannot parse source definition JSON or empty definition';
        p_output_json := NULL;
        RETURN;
    END IF;
    debug('Parsed Source definitions: ' || v_source_defs.COUNT || ' fields');

    -- Initialize JSON output
    v_json_output := '[';
    v_count_templates := 0;

    -- Loop over target templates from cursor
    FOR r_target IN c_targets LOOP
        v_target_id := r_target.ID;
        v_target_name := r_target.NAME;
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

        v_match_count := count_matches(v_source_defs, v_target_defs);

        v_score := ROUND((2 * v_match_count) / (v_source_defs.COUNT + v_target_defs.COUNT) * 100);

        debug('Template ' || v_target_id || ' (' || v_target_name || '): Matches=' || 
              v_match_count || ', Score=' || v_score);

        IF v_score >= v_min_score_use THEN
            IF v_count_templates > 0 THEN
                v_json_output := v_json_output || ',';
            END IF;
            v_json_output := v_json_output || '{"Template_id":"' || v_target_id || 
                            '","Template_Name":"' || REPLACE(v_target_name,'"','\"') || 
                            '","Score":' || v_score || '}';
            v_count_templates := v_count_templates + 1;
        END IF;
    END LOOP;

    v_json_output := v_json_output || ']';

    IF v_count_templates = 0 THEN
        p_output_json := '[{}]';
        p_message := 'No templates matched the minimum score threshold';
        debug('No matching templates found.');
    ELSE
        p_output_json := v_json_output;
        p_message := 'Templates matched: ' || v_count_templates;
        debug('Matching templates count: ' || v_count_templates);
    END IF;

    p_status := 'S';

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'Unexpected error: ' || SQLERRM;
        p_output_json := NULL;
END match_templates;
/
create or replace PROCEDURE POPULATE_ERROR_COLLECTION_FROM_LOG (
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
/
create or replace PROCEDURE prc_insert_hotel_group IS
  l_payload  CLOB;
  l_status   VARCHAR2(10);
  l_message  CLOB;
BEGIN
  -- Example JSON payload
  l_payload := '{
    "ID": "3d6da1647275228de063dd59000a9241",
    "GROUP_NAME": "Luxury Hotels",
    "CREATED_BY": "3d6da164727f228de063dd59000a9241",
    "UPDATED_BY": "3d6da1647281228de063dd59000a9241",
    "CREATED_ON": "2025-08-28",
    "UPDATED_ON": "2025-08-28"
  }';

  pkg_generic_crud.proc_crud_json(
    p_mode    => 'C',
    p_table   => 'UR_HOTEL_GROUPS',
    p_payload => l_payload,
    p_debug   => 'Y',
    p_status  => l_status,
    p_message => l_message
  );

  DBMS_OUTPUT.put_line('Insert Status  : ' || l_status);
  DBMS_OUTPUT.put_line('Insert Message : ' || l_message);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('Error in prc_insert_hotel_group: ' || SQLERRM);
END;
/
create or replace PROCEDURE p_generic_crud(
    p_mode         IN VARCHAR2,    -- 'C', 'U', 'D', 'F'
    p_table_name   IN VARCHAR2,    -- Table name (case-insensitive)
    p_payload      IN CLOB,        -- JSON payload (for C/U/D)
    p_debug        IN VARCHAR2 DEFAULT 'N', -- 'Y' for debug output
    p_status       OUT VARCHAR2,   -- 'S' for success, 'E' for error
    p_message      OUT CLOB        -- Success/Error/Info messages or result
) AS
    -- Local Variables
    l_sql         VARCHAR2(32767);
    l_cols        SYS_REFCURSOR;
    l_column_list VARCHAR2(4000);
    l_col_val_bind VARCHAR2(4000);
    l_primary_key_col VARCHAR2(255);
    l_pk_value   VARCHAR2(4000);
    l_bind_vars  DBMS_SQL.VARCHAR2_TABLE;
    l_datatype   VARCHAR2(50);
    l_mandatory  VARCHAR2(1);
    l_unique     VARCHAR2(1);
    l_cnt        INTEGER;
    -- For Fetch Mode
    l_json       CLOB;
    l_payload_json apex_json.t_values;
    l_idx        NUMBER;
    l_col_name   varchar2(255);
    -- Misc
    l_id_value   VARCHAR2(4000);
    l_found_pk   NUMBER;
    l_dynamic_sql VARCHAR2(32767);

    -- Helper subroutines
    PROCEDURE debug(msg VARCHAR2) IS
    BEGIN
        IF UPPER(p_debug) = 'Y' THEN
            APEX_DEBUG.MESSAGE('[GEN_CRUD] ' || msg);
        END IF;
    END;

    -- Fetch a single value from JSON (by key)
    FUNCTION json_get(payload CLOB, key VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN apex_json.get_varchar2(p_path => '$."'||key||'"', p_source => payload);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;

    -- Get comma-separated columns and binds for the payload, filtering only valid columns
    PROCEDURE build_column_lists(table_name IN VARCHAR2, payload IN CLOB, 
                               out_cols OUT VARCHAR2, out_vals OUT VARCHAR2, 
                               out_updates OUT VARCHAR2) IS
        l_cols_arr  apex_t_varchar2;
        l_vals_arr  apex_t_varchar2;
        l_upd_arr   apex_t_varchar2;
        l_sql2      VARCHAR2(2000);
        l_val       VARCHAR2(4000);
        l_col       VARCHAR2(255);
        l_coltype   VARCHAR2(64);
        l_idx       INTEGER := 1;
    BEGIN
        FOR c IN (SELECT column_name, data_type FROM user_tab_columns 
                    WHERE table_name = UPPER(table_name)) LOOP
            l_val := json_get(payload, c.column_name);
            IF l_val IS NOT NULL THEN
                l_cols_arr(l_idx) := c.column_name;
                l_vals_arr(l_idx) := ':'||l_idx;
                l_upd_arr(l_idx) := c.column_name||' = :'||l_idx;
                l_idx := l_idx + 1;
            END IF;
        END LOOP;
        out_cols := LISTAGG(l_cols_arr, ', ');
        out_vals := LISTAGG(l_vals_arr, ', ');
        out_updates := LISTAGG(l_upd_arr, ', ');
    END;

    -- Returns the primary key column for a table
    FUNCTION get_pk_column (table_name IN VARCHAR2) RETURN VARCHAR2 IS
        l_pk_col VARCHAR2(255);
    BEGIN
        SELECT column_name INTO l_pk_col
        FROM user_cons_columns
        WHERE constraint_name = (
            SELECT constraint_name FROM user_constraints
             WHERE table_name = UPPER(table_name)
               AND constraint_type = 'P'
               AND ROWNUM = 1
        ) AND rownum = 1;
        RETURN l_pk_col;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
    END;

    -- Checks for required (NOT NULL and no default) columns
    PROCEDURE get_mandatory_columns(table_name IN VARCHAR2, out_msg OUT CLOB) IS
        l_json CLOB := '{"mandatoryColumns":[';
        l_cnt  INTEGER := 0;
    BEGIN
        FOR c IN (SELECT column_name, data_type, data_length, nullable, data_default 
                    FROM user_tab_columns 
                    WHERE table_name = UPPER(table_name)) LOOP
            IF c.nullable = 'N' AND (c.data_default IS NULL OR TRIM(c.data_default) IS NULL) THEN
                IF l_cnt > 0 THEN l_json := l_json || ','; END IF;
                l_json := l_json || '{"column":"' || c.column_name || '","data_type":"' || c.data_type || '"}';
                l_cnt := l_cnt + 1;
            END IF;
        END LOOP;
        l_json := l_json || ']}';
        out_msg := l_json;
    END;

BEGIN
    -- Set debug context
    IF UPPER(p_debug) = 'Y' THEN
        APEX_DEBUG.ENABLE;
        debug('Procedure invoked in mode: '||p_mode||', Table='||p_table_name);
    END IF;

    IF UPPER(p_mode) = 'F' THEN
        -- FETCH mode: Retrieve metadata and provide sample C/U/D example payloads
        l_json := '{"fields":[';
        l_cnt := 0;
        FOR c IN (SELECT column_name, data_type, data_length, nullable, data_default 
                    FROM user_tab_columns WHERE table_name = UPPER(p_table_name)) LOOP
            IF l_cnt > 0 THEN l_json := l_json || ','; END IF;
            l_json := l_json||'{"column":"'||c.column_name
                     ||'","data_type":"'||c.data_type
                     ||'","length":'||NVL(c.data_length,0)
                     ||',"nullable":"'||c.nullable
                     ||'","default":"'||REPLACE(NVL(c.data_default,'null'),'"','\"')||'"}';
            l_cnt := l_cnt + 1;
        END LOOP;
        l_json := l_json || ']';

        -- Find PK
        l_primary_key_col := get_pk_column(p_table_name);

        -- Sample Example
        l_json := l_json ||
          ',"sampleExamples":{' ||
          '"Create":"p_mode=''C'', p_table_name='''||p_table_name||''', p_payload={...MandatoryCols...}",' ||
          '"Update":"p_mode=''U'', p_table_name='''||p_table_name||''', p_payload={'||l_primary_key_col||':<value>, ...fields...}",' ||
          '"Delete":"p_mode=''D'', p_table_name='''||p_table_name||''', p_payload={'||l_primary_key_col||':<value>}"' ||
          '} }';
        p_status := 'S';
        p_message := l_json;
        RETURN;
    END IF;

    -- All other modes (C/U/D) require table to exist, payload to be valid
    -- Find primary key column
    l_primary_key_col := get_pk_column(p_table_name);

    IF l_primary_key_col IS NULL THEN
        p_status := 'E';
        p_message := '{"error":"Primary key not found for table '||p_table_name||'"}';
        RETURN;
    END IF;

    -- Parse payload as JSON
    apex_json.parse(l_payload_json, p_payload);
    l_id_value := apex_json.get_varchar2(p_path => '$."'||l_primary_key_col||'"', p_values => l_payload_json);

    IF UPPER(p_mode) = 'C' THEN
        -- Gather mandatory fields
        debug('Checking mandatory fields');
        FOR c IN (SELECT column_name, data_type, nullable FROM user_tab_columns 
                   WHERE table_name = UPPER(p_table_name)) LOOP
            IF c.nullable='N' THEN
                l_col_name := c.column_name;
                IF apex_json.get_varchar2(p_path => '$."'||l_col_name||'"', p_values => l_payload_json) IS NULL THEN
                    p_status := 'E';
                    p_message := '{"error":"Mandatory field '||l_col_name||' is missing"}';
                    RETURN;
                END IF;
            END IF;
        END LOOP;

        -- Insert statement
        l_column_list := '';
        l_col_val_bind := '';
        l_idx := 1;
        FOR c IN (SELECT column_name FROM user_tab_columns WHERE table_name = UPPER(p_table_name)) LOOP
            l_col_name := c.column_name;
            IF apex_json.get_varchar2(p_path => '$."'||l_col_name||'"', p_values => l_payload_json) IS NOT NULL THEN
                IF l_column_list IS NOT NULL AND l_column_list <> '' THEN
                    l_column_list := l_column_list || ', ';
                    l_col_val_bind := l_col_val_bind || ', ';
                END IF;
                l_column_list := l_column_list || l_col_name;
                l_col_val_bind := l_col_val_bind || ':'||l_idx;
                l_bind_vars(l_idx) := apex_json.get_varchar2(p_path => '$."'||l_col_name||'"', p_values => l_payload_json);
                l_idx := l_idx + 1;
            END IF;
        END LOOP;

        l_sql := 'INSERT INTO '||p_table_name||' ('||l_column_list||') VALUES ('||l_col_val_bind||')';
        debug('Insert SQL: '||l_sql);
        EXECUTE IMMEDIATE l_sql USING l_bind_vars;
        p_status := 'S';
        p_message := '{"msg":"Row inserted successfully","' || l_primary_key_col || '":"' || l_bind_vars(1) || '"}';
        RETURN;
    ELSIF UPPER(p_mode) = 'U' THEN
        -- Require primary key value
        IF l_id_value IS NULL THEN
            p_status := 'E';
            p_message := '{"error":"Primary key value required for Update"}';
            RETURN;
        END IF;
        -- Build set clause
        l_column_list := '';
        l_col_val_bind := '';
        l_idx := 1;
        FOR c IN (SELECT column_name FROM user_tab_columns WHERE table_name = UPPER(p_table_name) AND column_name <> l_primary_key_col) LOOP
            l_col_name := c.column_name;
            IF apex_json.get_varchar2(p_path => '$."'||l_col_name||'"', p_values => l_payload_json) IS NOT NULL THEN
                IF l_column_list IS NOT NULL AND l_column_list <> '' THEN
                    l_column_list := l_column_list || ', ';
                END IF;
                l_column_list := l_column_list || l_col_name || ' = :'||l_idx;
                l_bind_vars(l_idx) := apex_json.get_varchar2(p_path => '$."'||l_col_name||'"', p_values => l_payload_json);
                l_idx := l_idx + 1;
            END IF;
        END LOOP;
        IF l_column_list IS NULL OR l_column_list = '' THEN
            p_status := 'E';
            p_message := '{"error":"No updatable fields provided"}';
            RETURN;
        END IF;

        l_sql := 'UPDATE '||p_table_name||' SET '||l_column_list
                 ||' WHERE '||l_primary_key_col||' = :'||l_idx;
        l_bind_vars(l_idx) := l_id_value;
        debug('Update SQL: '||l_sql);

        EXECUTE IMMEDIATE l_sql USING l_bind_vars;
        p_status := 'S';
        p_message := '{"msg":"Row updated successfully","'||l_primary_key_col||'":"' || l_id_value || '"}';
        RETURN;
    ELSIF UPPER(p_mode) = 'D' THEN
        -- Require primary key value
        IF l_id_value IS NULL THEN
            p_status := 'E';
            p_message := '{"error":"Primary key value required for Delete"}';
            RETURN;
        END IF;

        l_sql := 'DELETE FROM '||p_table_name||' WHERE '||l_primary_key_col||' = :1';
        debug('Delete SQL: '||l_sql);

        EXECUTE IMMEDIATE l_sql USING l_id_value;
        p_status := 'S';
        p_message := '{"msg":"Row deleted successfully","'||l_primary_key_col||'":"' || l_id_value || '"}';
        RETURN;
    ELSE
        p_status := 'E';
        p_message := '{"error":"Unsupported mode - use C,U,D,F"}';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := '{"error":"'||SQLERRM||'"}';
        debug('ERROR encountered: '||SQLERRM);
END p_generic_crud;
/
create or replace PROCEDURE update_template_definition (
    p_template_id        IN  VARCHAR2,
    p_collection_name    IN  VARCHAR2,
    p_template_type      IN  VARCHAR2 DEFAULT NULL,
    p_is_update          IN  VARCHAR2 DEFAULT 'N',
    p_status             OUT VARCHAR2,
    p_message            OUT CLOB
)
IS
    v_json         CLOB;
    v_ok           VARCHAR2(1);
    v_msg          VARCHAR2(4000);
    v_alerts       CLOB := NULL;
    v_val_status   VARCHAR2(1);

    v_old_json     CLOB;
    v_bd_object    VARCHAR2(255);
    v_sql          VARCHAR2(4000);
    v_data_count   NUMBER := 0;

    v_def_ok       BOOLEAN;
    v_def_msg      VARCHAR2(4000);

    v_view_ok      BOOLEAN;
    v_view_msg     VARCHAR2(4000);

    v_template_key VARCHAR2(4000);

    v_json_new   JSON_OBJECT_T;
    v_json_old   JSON_OBJECT_T;
    v_same_json  BOOLEAN := FALSE;

    v_san_msg VARCHAR2(4000);
    v_san_status VARCHAR2(1);
    v_sanitized_json CLOB;
BEGIN
    -------------------------------------------------------------------
    -- DEBUG START
    -------------------------------------------------------------------
    INSERT INTO debug_log(message) VALUES ('START update_template_definition');

    -------------------------------------------------------------------
    -- 1. Extract JSON
    -------------------------------------------------------------------
    ur_utils.get_collection_json(p_collection_name, v_json, v_ok, v_msg);

    IF v_ok = 'E' THEN
        ur_utils.add_alert(v_alerts, v_msg, 'error', NULL, NULL, v_alerts);
        p_status := 'E';
        p_message := v_alerts;
        RETURN;
    END IF;

    -------------------------------------------------------------------
    -- 2. Validate JSON
    -------------------------------------------------------------------
    ur_utils.validate_template_definition(
        p_json_clob  => v_json,
        p_alert_clob => v_alerts,
        p_status     => v_val_status
    );

    IF v_val_status = 'E' THEN
        p_status := 'E';
        p_message := v_alerts;
        RETURN;
    END IF;

    -------------------------------------------------------------------
    -- Sanitize JSON
    -------------------------------------------------------------------
    ur_utils.sanitize_template_definition(v_json, 'COL', v_sanitized_json, v_san_status, v_san_msg);

    IF v_san_status = 'E' THEN
        ur_utils.add_alert(v_alerts, v_san_msg, 'error', NULL, NULL, v_alerts);
        p_message := v_alerts;
        RETURN;
    END IF;

    -------------------------------------------------------------------
    -- 3. Fetch existing template
    -------------------------------------------------------------------
    SELECT definition, db_object_name, key
    INTO v_old_json, v_bd_object, v_template_key
    FROM ur_templates
    WHERE id = p_template_id;

    -------------------------------------------------------------------
    -- 4. Check table data
    -------------------------------------------------------------------
    IF v_bd_object IS NOT NULL THEN
        BEGIN
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || v_bd_object INTO v_data_count;
        EXCEPTION WHEN OTHERS THEN
            v_data_count := 0;
        END;
    END IF;

    -------------------------------------------------------------------
    -- 5. Compare JSON
    -------------------------------------------------------------------
    BEGIN
        v_json_new := JSON_OBJECT_T.parse(v_json);
        v_json_old := JSON_OBJECT_T.parse(v_old_json);
        v_same_json := v_json_new.equals(v_json_old);
    EXCEPTION
    WHEN OTHERS THEN
        v_same_json := FALSE;
    END;

    -------------------------------------------------------------------
-- 6. JSON SAME OR DIFFERENT
-------------------------------------------------------------------
IF v_same_json THEN

    ---------------------------------------------------------------
    -- JSON IS IDENTICAL
    ---------------------------------------------------------------
    IF v_data_count > 0 THEN
        ur_utils.add_alert(
            v_alerts,
            'Data exists in ' || v_bd_object || '. No structural changes allowed.',
            'warning', NULL, NULL, v_alerts
        );
    ELSE
        ur_utils.add_alert(
            v_alerts,
            'Definition unchanged. No update required.',
            'info', NULL, NULL, v_alerts
        );
    END IF;

ELSE

    ---------------------------------------------------------------
    -- JSON IS DIFFERENT
    ---------------------------------------------------------------

    ---------------------------------------------------------------
    -- 6A. DELETE OLD TEMPLATE OBJECTS
    ---------------------------------------------------------------
    DECLARE
        v_del_json CLOB;
    BEGIN
        DELETE_TEMPLATES_1(
            p_id           => p_template_id,
            p_hotel_id     => NULL,
            p_key          => v_template_key,
            p_name         => NULL,
            p_type         => NULL,
            p_active       => NULL,
            p_db_obj_empty => 'N',
            p_delete_all   => 'N',
            p_debug        => 'N',
            p_json_output  => v_del_json
        );

        INSERT INTO debug_log(message)
        VALUES ('DELETE_TEMPLATES output: ' ||
                DBMS_LOB.SUBSTR(v_del_json, 4000));
    END;
DELETE FROM UR_ALGO_ATTRIBUTES
                WHERE template_id = p_template_id;

                -- Drop view if exists: {key}_VW
        BEGIN
            EXECUTE IMMEDIATE 'DROP VIEW  UR_TMPLT_' || v_template_key || '_RANK_V';
        EXCEPTION
            WHEN OTHERS THEN NULL;
        END;


                
                
    ---------------------------------------------------------------
    -- 6B. UPDATE TEMPLATE WITH NEW JSON
    ---------------------------------------------------------------
    UPDATE ur_templates
       SET definition = v_sanitized_json,
           type       = p_template_type,
           updated_on = SYSTIMESTAMP
     WHERE id = p_template_id;

    COMMIT;

    ---------------------------------------------------------------
    -- 6C. RECREATE DB OBJECTS
    ---------------------------------------------------------------
    IF UPPER(p_is_update) = 'Y' THEN

        -- FIX: refresh key BEFORE creating anything
SELECT key, definition
INTO v_template_key, v_sanitized_json
FROM ur_templates
WHERE id = p_template_id;

-- NOW create table using the correct key
ur_utils.define_db_object(v_template_key, v_def_ok, v_def_msg);


        

        -- recreate ranking view
        IF UPPER(p_template_type) = 'RST' THEN
        INSERT INTO debug_log (message)
    VALUES ('RST ');
            ur_utils.create_ranking_view(v_template_key, v_view_ok, v_view_msg);
            commit;
            IF v_view_ok THEN
      ur_utils.add_alert(v_alerts, v_view_msg, 'success', NULL, NULL, v_alerts);
      COMMIT;
    ELSE
      ur_utils.add_alert(v_alerts, 'Ranking view failed: ' || v_view_msg, 'warning', NULL, NULL, v_alerts);
      --:P0_ALERT_MESSAGE := v_alerts; RETURN;
    END IF;
        END IF;

              ur_utils.manage_algo_attributes(
        v_template_key,
        'C',
        NULL,
        v_def_ok,
        v_def_msg
    );
    ur_utils.add_alert(v_alerts, v_def_msg, CASE WHEN v_def_ok THEN 'success' ELSE 'error' END, NULL, NULL, v_alerts);
     ur_utils.create_ranking_view(v_template_key, v_view_ok, v_view_msg);
            commit;

    INSERT INTO debug_log (message)
    VALUES ('manage_algo_attributes: ' ||
            CASE WHEN v_def_ok THEN 'OK' ELSE v_def_msg END);

    COMMIT;

    END IF;

END IF;  -- <<<<<<<<<< THIS WAS MISSING

    -------------------------------------------------------------------
    -- END
    -------------------------------------------------------------------
    p_status  := 'S';
    p_message := v_alerts;

EXCEPTION
    WHEN OTHERS THEN
        ur_utils.add_alert(v_alerts, 'Error: ' || SQLERRM, 'error', NULL, NULL, v_alerts);
        p_status := 'E';
        p_message := v_alerts;
END update_template_definition;
/
create or replace PROCEDURE ur_upload_file_proc (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT BOOLEAN,
    p_message         OUT VARCHAR2
) IS
    l_blob        BLOB;
    l_file_name   VARCHAR2(255);
    l_table_name  VARCHAR2(255);
    l_template_id RAW(16);
    l_total_rows  NUMBER := 0;
    l_success_cnt NUMBER := 0;
    l_fail_cnt    NUMBER := 0;
    l_log_id      RAW(16);
    l_error_json  CLOB := '[';
    l_first_err   BOOLEAN := TRUE;

    -- mapping record type
    TYPE t_map_rec IS RECORD (
        src_col     VARCHAR2(128),  
        tgt_col     VARCHAR2(128),  
        parser_col  VARCHAR2(20),   
        data_type   VARCHAR2(50)
    );
    TYPE t_map IS TABLE OF t_map_rec INDEX BY VARCHAR2(128);

    l_mapping   t_map;
    l_apex_user VARCHAR2(255) := NVL(v('APP_USER'),'APEX_USER');

    l_cols   VARCHAR2(32767);
    l_vals   VARCHAR2(32767);
    l_sql    CLOB;
    k        VARCHAR2(128);
    v_expr   VARCHAR2(4000);
    l_map_count NUMBER;

    l_existing_cnt NUMBER;
BEGIN
    -------------------------------------------------------------------
    -- 0. DUPLICATE CHECK
    -------------------------------------------------------------------
    SELECT COUNT(*)
      INTO l_existing_cnt
      FROM ur_interface_logs
     WHERE file_id     = p_file_id
       AND load_status = 'SUCCESS';

    IF l_existing_cnt > 0 THEN
        p_status  := FALSE;
        p_message := 'Failure: File ID '||p_file_id||' is already uploaded successfully.';
        RETURN;
    END IF;

    -- 1. Get blob and file name
    SELECT blob_content, filename
      INTO l_blob, l_file_name
      FROM temp_blob
     WHERE id = p_file_id;

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

    -- 4. Load mapping
    FOR rec IN (
        SELECT regexp_substr(c001, '^[^(]+')                    src_col,
               regexp_substr(c002, '^[^(]+')                    tgt_col,
               TRIM(c004)                                       parser_col,
               UPPER(regexp_replace(c001, '^[^(]+\(([^)]+)\).*', '\1')) datatype
          FROM apex_collections
         WHERE collection_name = p_collection_name
           AND c003 = 'Maps To'
           AND c004 IS NOT NULL
    ) LOOP
        l_mapping(UPPER(TRIM(rec.src_col))).src_col    := TRIM(rec.src_col);
        l_mapping(UPPER(TRIM(rec.src_col))).tgt_col    := TRIM(rec.tgt_col);
        l_mapping(UPPER(TRIM(rec.src_col))).parser_col := TRIM(rec.parser_col);
        l_mapping(UPPER(TRIM(rec.src_col))).data_type  := TRIM(rec.datatype);
    END LOOP;

    l_map_count := l_mapping.count;
    IF l_map_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No mapped columns found in collection!');
    END IF;

    -- 5. Build dynamic column list and values
    k := l_mapping.first;
    WHILE k IS NOT NULL LOOP
        IF l_mapping.exists(k)
           AND l_mapping(k).tgt_col IS NOT NULL
           AND l_mapping(k).parser_col IS NOT NULL
        THEN
            IF l_cols IS NOT NULL THEN
                l_cols := l_cols || ',';
                l_vals := l_vals || ',';
            END IF;

            l_cols := l_cols || l_mapping(k).tgt_col;

            -- safe conversions
            IF l_mapping(k).data_type = 'NUMBER' THEN
                v_expr := 'CASE WHEN REGEXP_LIKE(p.'|| l_mapping(k).parser_col ||', ''^-?\d+(\.\d+)?$'') '||
                          'THEN TO_NUMBER(p.'|| l_mapping(k).parser_col ||') ELSE NULL END';
            ELSIF l_mapping(k).data_type = 'DATE' THEN
                v_expr := 'CASE '||
                          ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-\d{2}-\d{4}\s+\d{2}:\d{2}:\d{2}$'') '||
                          '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MM-YYYY HH24:MI:SS'') '||
                          ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-[A-Z]{3}-\d{4}\s+\d{2}:\d{2}:\d{2}$'', ''i'') '||
                          '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MON-YYYY HH24:MI:SS'') '||
                          ' ELSE NULL END';
            ELSE
                v_expr := 'p.'|| l_mapping(k).parser_col;
            END IF;

            l_vals := l_vals || v_expr;
        END IF;
        k := l_mapping.next(k);
    END LOOP;

    ----------------------------------------------------------------
    -- 6. Try BULK insert, fallback to row-by-row on failure
    ----------------------------------------------------------------
    l_sql :=
        'INSERT INTO '|| l_table_name ||' (HOTEL_ID,'|| l_cols ||',INTERFACE_LOG_ID) '||
        'SELECT :hotel_id,'|| l_vals ||',:log_id '||
        '  FROM TABLE(apex_data_parser.parse(p_content => :b1, p_file_name => :b2)) p '||
        ' WHERE p.line_number > 1';

    BEGIN
        EXECUTE IMMEDIATE l_sql USING p_hotel_id, l_log_id, l_blob, l_file_name;
        l_success_cnt := SQL%ROWCOUNT;
        l_total_rows  := l_success_cnt;
exception
    when others then
        l_fail_cnt := l_fail_cnt + 1;
        -- build comma-separated row data dynamically
        declare
            l_rowdata   clob := '';
            l_val       varchar2(4000);
            i           integer := 1;
            key         varchar2(128);
            l_col_count integer := 0;
            col_array   dbms_sql.varchar2_table;
            l_errmsg    varchar2(4000); -- store SQLERRM
        begin
            l_errmsg := sqlerrm; -- capture the error message

            -- Prepare array of headers (columns) for the error row
            key := l_header.first;
            while key is not null loop
                l_col_count := l_col_count + 1;
                col_array(l_col_count) := key;
                key := l_header.next(key);
            end loop;

            for j in 1 .. l_col_count loop
                execute immediate
                   'begin :x := rec.' || l_header(col_array(j)).tgt_col || '; end;'
                using out l_val;
                if j > 1 then
                    l_rowdata := l_rowdata || ',';
                end if;
                l_rowdata := l_rowdata || nvl(l_val,'');
            end loop;

            if not l_first_err then
                l_error_json := l_error_json || ',';
            end if;

            -- build JSON with PL/SQL variable l_errmsg
            l_error_json := l_error_json ||
                json_object(
                  'File_ID' value 10114138698744212,
                  'Template_ID' value l_template_id,
                  'error' value json_object(
                      'Line_Number' value rec.line_number,
                      'data' value l_rowdata,
                      'message' value l_errmsg
                  )
                );

            l_first_err := false;
        end;
end;


    ----------------------------------------------------------------
    -- 7. Update log entry
    ----------------------------------------------------------------
    l_error_json := l_error_json || ']';

    UPDATE ur_interface_logs
       SET load_end_time      = systimestamp,
           load_status        = CASE WHEN l_fail_cnt = 0 THEN 'SUCCESS' ELSE 'FAILED' END,
           records_processed  = l_total_rows,
           records_successful = l_success_cnt,
           records_failed     = l_fail_cnt,
           error_json         = CASE WHEN l_fail_cnt > 0 THEN l_error_json ELSE NULL END,
           updated_by         = hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
           updated_on         = sysdate
     WHERE id = l_log_id;

    COMMIT;

    p_status  := (l_fail_cnt = 0);
    p_message := CASE WHEN l_fail_cnt = 0
                 THEN 'Success: Upload completed for File ID '||p_file_id||
                      ' → Total='||l_total_rows||', Success='||l_success_cnt
                 ELSE 'Completed with errors: Total='||l_total_rows||
                      ', Success='||l_success_cnt||', Failed='||l_fail_cnt END;

EXCEPTION
    WHEN OTHERS THEN
        p_status  := FALSE;
        p_message := 'Failure: '||SQLERRM;

        UPDATE ur_interface_logs
           SET load_end_time = systimestamp,
               load_status   = 'FAILED',
               error_json    = l_error_json || '{"error":"' || REPLACE(SQLERRM,'"','''') || '"}]',
               updated_on    = sysdate
         WHERE id = l_log_id;

        ROLLBACK;
END ur_upload_file_proc;
/
create or replace PROCEDURE validate_or_clean_expression (
    p_expression IN VARCHAR2,
    p_mode IN CHAR,
    p_hotel_id IN VARCHAR2,
    p_status OUT VARCHAR2, -- 'S' or 'E'
    p_message OUT VARCHAR2
) IS
  TYPE t_str_list IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
  v_attributes t_str_list;
  v_functions t_str_list;
  v_operators t_str_list;
  v_attr_count NUMBER := 0;
  v_func_count NUMBER := 0;
  v_oper_count NUMBER := 0;

  TYPE t_token_rec IS RECORD (
    token VARCHAR2(4000),
    start_pos PLS_INTEGER,
    end_pos PLS_INTEGER
  );
  TYPE t_token_tab IS TABLE OF t_token_rec INDEX BY PLS_INTEGER;
  v_tokens t_token_tab;
  v_token_count PLS_INTEGER := 0;

  TYPE t_token_tab_nt IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
  v_unmatched_tokens t_token_tab;
  v_unmatched_count PLS_INTEGER := 0;

  -- To mark tokens consumed by multi-word operators
  TYPE t_bool_tab IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;
  v_token_consumed t_bool_tab;

  v_mode CHAR := UPPER(p_mode);

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
  FUNCTION is_in_list(p_token VARCHAR2, p_list t_str_list, cnt NUMBER) RETURN BOOLEAN IS
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

  PROCEDURE load_functions(p_list OUT t_str_list, p_count OUT NUMBER) IS
  BEGIN
    p_list.DELETE;
    p_count := 0;
    FOR r IN (
      SELECT return_value FROM apex_application_lov_entries
      WHERE list_of_values_name = 'UR EXPRESSION FUNCTIONS'
      ORDER BY return_value
    ) LOOP
      p_count := p_count + 1;
      p_list(p_count) := normalize_func_name(r.return_value);
    END LOOP;
    IF p_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20010, 'Functions LOV missing or empty');
    END IF;
  END;

  PROCEDURE load_operators(p_list OUT t_str_list, p_count OUT NUMBER) IS
  BEGIN
    p_list.DELETE;
    p_count := 0;
    FOR r IN (
      SELECT return_value FROM apex_application_lov_entries
      WHERE list_of_values_name = 'UR EXPRESSION OPERATORS'
      ORDER BY return_value
    ) LOOP
      p_count := p_count + 1;
      p_list(p_count) := UPPER(TRIM(r.return_value));
    END LOOP;
    IF p_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20011, 'Operators LOV missing or empty');
    END IF;
  END;

  PROCEDURE load_attributes(p_hotel_id IN VARCHAR2, p_list OUT t_str_list, p_count OUT NUMBER) IS
  BEGIN
    p_list.DELETE;
    p_count := 0;
    FOR r IN (
      SELECT key FROM ur_algo_attributes WHERE hotel_id = p_hotel_id
    ) LOOP
      p_count := p_count + 1;
      p_list(p_count) := UPPER(TRIM(r.key));
    END LOOP;
    IF p_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20012, 'Attributes missing for hotel_id ' || p_hotel_id);
    END IF;
  END;

  -- Tokenizer splitting expression into tokens, tracking start/end pos
  PROCEDURE tokenize_expression(p_expr IN VARCHAR2, p_tokens OUT t_token_tab, p_count OUT NUMBER) IS
    l_pos PLS_INTEGER := 1;
    l_len PLS_INTEGER := LENGTH(p_expr);
    l_token VARCHAR2(4000);
    l_token_start PLS_INTEGER;
    l_token_end PLS_INTEGER;
  BEGIN
    p_tokens.DELETE;
    p_count := 0;
    WHILE l_pos <= l_len LOOP
      l_token := REGEXP_SUBSTR(p_expr,
        '([A-Za-z0-9_\.]+|\d+(\.\d+)?|\(|\)|\S)',
        l_pos,
        1,
        'i');
      EXIT WHEN l_token IS NULL;
      l_token_start := INSTR(p_expr, l_token, l_pos);
      l_token_end := l_token_start + LENGTH(l_token) - 1;
      p_count := p_count + 1;
      p_tokens(p_count) := t_token_rec(token => l_token, start_pos => l_token_start, end_pos => l_token_end);
      l_pos := l_token_end + 1;
      WHILE l_pos <= l_len AND SUBSTR(p_expr, l_pos, 1) = ' ' LOOP
        l_pos := l_pos + 1;
      END LOOP;
    END LOOP;
  END;

  FUNCTION build_json_errors(p_unmatched t_token_tab, p_count PLS_INTEGER) RETURN VARCHAR2 IS
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
    combined VARCHAR2(4000);
    max_words CONSTANT PLS_INTEGER := 4; -- max operator words count
    words_count PLS_INTEGER;
    l_len PLS_INTEGER := LEAST(max_words, v_token_count - start_idx + 1);
    i PLS_INTEGER;
  BEGIN
    FOR words_count IN REVERSE 1 .. l_len LOOP
      combined := '';
      FOR i IN start_idx .. start_idx + words_count - 1 LOOP
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
  p_status := 'E';
  p_message := NULL;

  IF v_mode NOT IN ('V', 'C') THEN
    p_status := 'E';
    p_message := 'Invalid mode "' || p_mode || '". Valid are V or C.';
    RETURN;
  END IF;

  IF p_hotel_id IS NULL THEN
    p_status := 'E';
    p_message := 'hotel_id is mandatory';
    RETURN;
  END IF;

  IF p_expression IS NULL OR LENGTH(TRIM(p_expression)) = 0 THEN
    p_status := 'E';
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
    i PLS_INTEGER := 1;
    words_matched PLS_INTEGER := 0;
  BEGIN
    WHILE i <= v_token_count LOOP
      words_matched := get_longest_operator_match(i);
      IF words_matched > 0 THEN
        FOR j IN i .. i + words_matched - 1 LOOP
          v_token_consumed(j) := TRUE;
        END LOOP;
        i := i + words_matched;
      ELSE
        -- Single token valid check
        v_token_consumed(i) := is_token_valid(normalize_token(v_tokens(i).token));
        i := i + 1;
      END IF;
    END LOOP;
  END;

  IF v_mode = 'V' THEN
    v_unmatched_tokens.DELETE;
    v_unmatched_count := 0;
    FOR i IN 1 .. v_token_count LOOP
      IF v_token_consumed.EXISTS(i) AND v_token_consumed(i) = FALSE THEN
        v_unmatched_count := v_unmatched_count + 1;
        v_unmatched_tokens(v_unmatched_count) := v_tokens(i);
      END IF;
    END LOOP;

    IF v_unmatched_count > 0 THEN
      p_status := 'E';
      p_message := 'Invalid tokens: ' || build_json_errors(v_unmatched_tokens, v_unmatched_count);
    ELSE
      p_status := 'S';
      p_message := 'Expression validated successfully.';
    END IF;

  ELSIF v_mode = 'C' THEN
    p_status := 'S';
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
    p_status := 'E';
    p_message := 'Failure: ' || SQLERRM;
END validate_or_clean_expression;
/
create or replace PROCEDURE validate_profile_row (
        p_name          IN VARCHAR2,
        p_data_type     IN VARCHAR2,
        p_mapping_type  IN VARCHAR2,
        p_default_value IN VARCHAR2,
        p_collection    IN VARCHAR2,
        o_status        OUT VARCHAR2,
        o_message       OUT VARCHAR2
    )
    IS
        v_type   VARCHAR2(100);

        v_formula           VARCHAR2(4000);
v_prev_is_operator  BOOLEAN := FALSE;


    BEGIN
        ----------------------------------------------------------------------
        -- DEFAULT: Success
        ----------------------------------------------------------------------
        o_status  := 'SUCCESS';
        o_message := 'Validation passed';
       v_formula := TRIM(REPLACE(p_default_value, ' ', ''));

        ----------------------------------------------------------------------
        -- (1) Default value must be numeric (max 2 decimals)
        ----------------------------------------------------------------------
        /*IF p_mapping_type = 'Default' and p_default_value IS NOT NULL and p_data_type = 'NUMBER' THEN
            IF NOT REGEXP_LIKE(p_default_value, '^\d+(\.\d{1,2})?$') THEN
                o_status  := 'ERROR';
                o_message := 'Default value must be numeric with max 2 decimals.';
                RETURN;
            END IF;
        END IF;*/
        IF p_mapping_type = 'Default' then
            if p_default_value IS NULL then
               o_status  := 'ERROR';
               o_message := 'Default value must be mentioned.';
                RETURN; 
            elsif
                p_default_value IS NOT NULL and p_data_type = 'NUMBER' THEN
                IF NOT REGEXP_LIKE(p_default_value, '^\d+(\.\d{1,2})?$') THEN
                    o_status  := 'ERROR';
                    o_message := 'Default value must be numeric with max 2 decimals.';
                RETURN;
                END IF;
            end if;


        end if;


        ----------------------------------------------------------------------
        -- (2) Calculation only allowed for NUMBER columns
        ----------------------------------------------------------------------
        IF p_mapping_type = 'Calculation' AND p_data_type <> 'NUMBER' THEN
            o_status  := 'ERROR';
            o_message := 'Calculation is allowed only for NUMBER-type fields.';
            RETURN;
        END IF;


        ----------------------------------------------------------------------
        -- (3) Formula validation → every referenced field must be NUMBER type
        ----------------------------------------------------------------------
        /*IF p_mapping_type = 'Calculation' AND p_default_value IS NOT NULL THEN
            
            FOR t IN (
                SELECT DISTINCT REGEXP_SUBSTR(p_default_value, '[A-Za-z0-9_]+', 1, LEVEL) AS token
                FROM dual
                CONNECT BY REGEXP_SUBSTR(p_default_value, '[A-Za-z0-9_]+', 1, LEVEL) IS NOT NULL
            )
            LOOP
                BEGIN
                    SELECT c002
                      INTO v_type
                      FROM apex_collections
                     WHERE collection_name = p_collection
                       AND upper(c001) = upper(t.token);

                    IF v_type <> 'NUMBER' THEN
                        o_status  := 'ERROR';
                        o_message := 'Field "'||t.token||'" is not NUMBER type. Invalid formula.';
                        RETURN;
                    END IF;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN 
                        NULL; -- token does not match any column (operators/numbers)
                END;
            END LOOP;
        END IF;*/
IF p_mapping_type = 'Calculation' THEN

    v_formula := TRIM(REPLACE(p_default_value, ' ', ''));

    IF v_formula IS NULL THEN
        o_status := 'ERROR';
        o_message := 'Calculation formula must be mentioned.';
        RETURN;
    END IF;

    -- Allow A-Z, 0-9, _, +, -, *, /, ^ and parentheses
    IF NOT REGEXP_LIKE(v_formula, '^[A-Za-z0-9_+\*\/^\(\)-]+$') THEN
        o_status := 'ERROR';
        o_message := 'Formula contains invalid characters.';
        RETURN;
    END IF;


  -- Cannot start with ANY operator
IF SUBSTR(v_formula, 1, 1) IN ('+', '-', '*', '/', '^') THEN
    o_status := 'ERROR';
    o_message := 'Formula cannot start with an operator.';
    RETURN;
END IF;
 
IF REGEXP_LIKE(v_formula, '[\+\-\*\/\^]$') THEN
        o_status := 'ERROR';
        o_message := 'Formula cannot end with an operator.';
        RETURN;
    END IF;
-- Check for ending operators explicitly
IF SUBSTR(v_formula, -1) IN ('+', '-', '*', '/', '^') THEN
    o_status := 'ERROR';
    o_message := 'Formula cannot end with an operator.';
    RETURN;
END IF;

    -- Prevent invalid operator combinations (e.g., ++, *-, /*, +*)
    IF REGEXP_LIKE(v_formula, '([\+\-\*\/\^]{2,})') THEN
        o_status := 'ERROR';
        o_message := 'Formula contains invalid consecutive operators.';
        RETURN;
    END IF;
-- Prevent invalid operator combinations
-- Allowed: A-Z, 0-9, _, (), + - * / ^
-- But operator cannot be followed by another operator except: unary minus after * / ^ or (
/*IF REGEXP_LIKE(v_formula,
    '(\\+\\+|--|\\+-|-\\+|\\+\\*|\\*\\+|\\+/|/\\+|\\*\\*|//|\\^\\^|\\^\\+|\\+\\^)'
) THEN
    o_status := 'ERROR';
    o_message := 'Formula contains invalid operator combinations.';
    RETURN;
END IF;*/
--IF REGEXP_LIKE(v_formula, '([+\-*/^]{2,})') THEN
  --  o_status := 'ERROR';
    --o_message := 'Formula contains invalid operator usage.';
    --RETURN;
--END IF;


    -- Parentheses count check
    IF LENGTH(v_formula) - LENGTH(REPLACE(v_formula, '(', '')) 
       != 
       LENGTH(v_formula) - LENGTH(REPLACE(v_formula, ')', ''))
    THEN
        o_status := 'ERROR';
        o_message := 'Parentheses mismatch in formula.';
        RETURN;
    END IF;

    ----------------------------------------------------------------------
    -- Token validation (column names must exist in collection)
    ----------------------------------------------------------------------
    FOR t IN (
        SELECT DISTINCT REGEXP_SUBSTR(v_formula, '[A-Za-z_][A-Za-z0-9_]*', 1, LEVEL) AS token
        FROM dual
        CONNECT BY REGEXP_SUBSTR(v_formula, '[A-Za-z_][A-Za-z0-9_]*', 1, LEVEL) IS NOT NULL
    )
    LOOP
        BEGIN
            SELECT c002
              INTO v_type
              FROM apex_collections
             WHERE collection_name = p_collection
               AND UPPER(c001) = UPPER(t.token);

            IF v_type <> 'NUMBER' THEN
                o_status := 'ERROR';
                o_message := 'Field "'||t.token||'" must be NUMBER type.';
                RETURN;
            END IF;

        EXCEPTION WHEN NO_DATA_FOUND THEN
            o_status  := 'ERROR';
            o_message := 'Unknown field "'||t.token||'" in formula.';
            RETURN;
        END;
    END LOOP;

END IF;
    

    END validate_profile_row;
/
create or replace PROCEDURE xxpel_parse_error_json (
    p_json_clob      IN  CLOB,
    p_collection_name IN VARCHAR2 DEFAULT 'ERROR_COLLECTION',
    p_ai_message     OUT CLOB,
    p_status         OUT VARCHAR2
) AS
    l_json_data   JSON_ARRAY_T;
    l_obj         JSON_OBJECT_T;
    l_error_obj   JSON_OBJECT_T;
    l_file_id     VARCHAR2(50);
    l_template_id VARCHAR2(100);
    l_line_no     NUMBER;
    l_message     VARCHAR2(4000);
    l_count       PLS_INTEGER := 0;
BEGIN
    -- Drop and recreate collection
    IF apex_collection.collection_exists(p_collection_name) THEN
        apex_collection.delete_collection(p_collection_name);
    END IF;

    apex_collection.create_collection(p_collection_name);

    -- Parse the JSON array
    l_json_data := JSON_ARRAY_T.parse(p_json_clob);

    FOR i IN 0 .. l_json_data.get_size - 1 LOOP
        l_obj := TREAT(l_json_data.get(i) AS JSON_OBJECT_T);

        l_file_id     := l_obj.get_string('File_ID');
        l_template_id := l_obj.get_string('Template_ID');
        l_error_obj   := l_obj.get_object('error');
        l_line_no     := l_error_obj.get_number('Line_Number');
        l_message     := l_error_obj.get_string('message');

        apex_collection.add_member(
            p_collection_name => p_collection_name,
            p_c001 => l_file_id,
            p_c002 => l_template_id,
            p_c003 => TO_CHAR(l_line_no),
            p_c004 => l_message
        );

        l_count := l_count + 1;
    END LOOP;

    -- Status and AI message logic
    IF l_count > 0 THEN
        p_status := 'S';
        p_ai_message := 'Parsed ' || l_count || ' errors successfully.';
    ELSE
        p_status := 'W';
        p_ai_message := 'No errors found in the JSON input.';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_ai_message := 'Error while parsing JSON: ' || SQLERRM;
END;
/
create or replace PROCEDURE XX_LOCAL_Load_Data (
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
    v_expr   VARCHAR2(32000);
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
                               -- v_expr := 'CASE WHEN REGEXP_LIKE(p.'|| l_mapping(k).parser_col ||', ''^-?\d+(\.\d+)?$'') '||
                               --           'THEN TO_NUMBER(p.'|| l_mapping(k).parser_col ||') ELSE NULL END'; 
                                v_expr := 'CASE WHEN REGEXP_LIKE(p.'|| l_mapping(k).parser_col ||', ''^-?\d+(\.\d+)?$'') '||
                                         'THEN TO_NUMBER(p.'|| l_mapping(k).parser_col ||' DEFAULT NULL ON CONVERSION ERROR) ELSE NULL END  as ' || l_mapping(k).parser_col ||' ';           

                                /*v_expr := 
    'CASE 
        WHEN REGEXP_LIKE(p.' || l_mapping(k).parser_col || 
        ', ''^-?(\d+(\.\d+)?|\.\d+)$'') 
        THEN TO_NUMBER(p.' || l_mapping(k).parser_col || 
        ' DEFAULT NULL ON CONVERSION ERROR) 
        ELSE NULL 
     END AS ' || l_mapping(k).parser_col;*/



                            ELSIF l_mapping(k).data_type = 'DATE' THEN
                                v_expr := 'CASE '||
                              -- Full datetime with DD-MM-YYYY
                              ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-\d{2}-\d{4}\s+\d{2}:\d{2}:\d{2}$'') '||
                              '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MM-YYYY HH24:MI:SS'') '||

                              -- Full datetime with DD/MM/YYYY
                              ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}/\d{2}/\d{4}\s+\d{2}:\d{2}:\d{2}$'') '||
                              '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD/MM/YYYY HH24:MI:SS'') '||

                              -- Full datetime with DD-MON-YYYY (your case)
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

                              -- Fallback
                              ' ELSE NULL END as ' || l_mapping(k).parser_col ||' ';

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
l_stay_val := TO_CHAR(fn_safe_to_date(l_stay_val), 'DD/MM/YYYY');
          
            
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
        'values (s.HOTEL_ID, '||rtrim(l_col_s, ', ')||',s.INTERFACE_LOG_ID)';


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


    p_status  := case when l_total_rows = l_fail_cnt then 'E' ELSE 'S' END;
    p_message := case when l_total_rows = l_fail_cnt then 'Failure' ELSE 'Success' END||': Upload completed → Total=' || l_total_rows || ', Success=' || l_success_cnt || ', Failed=' || l_fail_cnt;

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
END XX_LOCAL_Load_Data;
/
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

                    ELSIF UPPER(NVL(l_mapping(k).map_type, '')) = 'IGNORE' THEN
                          -- <-- KEY CHANGE: Ignore mapping -> always insert NULL for this target column
                         v_expr := 'NULL AS "' || l_mapping(k).tgt_col || '"';                                         

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
   /* p_message := case when l_total_rows = l_fail_cnt then 'Failure'                      when l_total_rows = l_success_cnt then 'Success'
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
create or replace PROCEDURE XX_LOCAL_Load_Data_2 (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT VARCHAR2,
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
    l_vals_calculation   VARCHAR2(32767);
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

    -- 4. Discover STAY_DATE column
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

    -- 5. Load mapping directly from collection
    FOR rec IN (
        SELECT regexp_substr(c001, '^[^(]+')                    src_col,
               regexp_substr(c002, '^[^(]+')                    tgt_col,
               CASE WHEN c003 = 'Maps To' THEN regexp_substr(c002, '^[^(]+') 
                    WHEN c003 in ('Default','Calculation')  THEN TRIM(c004)  END parser_col,
               c003                                             map_type,
               (SELECT DATA_TYPE 
                  FROM all_tab_cols 
                 WHERE TABLE_NAME LIKE (SELECT db_object_name 
                                         FROM ur_templates 
                                        WHERE id = l_template_id)
                   AND upper(COLUMN_NAME) LIKE upper(TRIM(regexp_substr(c002, '^[^(]+'))) ) datatype1
          FROM apex_collections
         WHERE collection_name = p_collection_name
    ) LOOP 
        l_mapping(UPPER(TRIM(rec.src_col))).src_col    := TRIM(rec.src_col);
        l_mapping(UPPER(TRIM(rec.src_col))).tgt_col    := TRIM(rec.tgt_col);
        l_mapping(UPPER(TRIM(rec.src_col))).parser_col := TRIM(rec.parser_col);
        l_mapping(UPPER(TRIM(rec.src_col))).data_type  := rec.datatype1;
        l_mapping(UPPER(TRIM(rec.src_col))).map_type   := TRIM(rec.map_type);
        INSERT INTO debug_log(message) VALUES('rec.src_col: ' || rec.src_col);
        INSERT INTO debug_log(message) VALUES('rec.tgt_col : ' || rec.tgt_col);
        INSERT INTO debug_log(message) VALUES('rec.parser_col : ' || rec.parser_col);
        INSERT INTO debug_log(message) VALUES('rec.map_type : ' || rec.map_type);
        INSERT INTO debug_log(message) VALUES('rec.data_type-----> : ' ||rec.datatype1);
    COMMIT;
    END LOOP;

    l_map_count := l_mapping.count;
    IF l_map_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No mapped columns found in collection!');
    END IF;

    -------------------------------------------------------------------
    -- 6. Build dynamic column list and safe value expressions
    -------------------------------------------------------------------
    k := l_mapping.first;
    WHILE k IS NOT NULL LOOP
        IF l_mapping.exists(k) AND l_mapping(k).tgt_col IS NOT NULL THEN
            IF l_cols IS NOT NULL THEN
                l_cols := l_cols || ',';
                l_vals_calculation := l_vals_calculation || ',';
            END IF;

            l_cols := '"' || l_mapping(k).tgt_col || '"';  -- quote to avoid reserved words

            IF l_mapping(k).map_type = 'Default' THEN
                v_expr := l_mapping(k).parser_col || ' AS "' || l_mapping(k).tgt_col || '"';

            ELSIF l_mapping(k).map_type = 'Calculation' THEN
                v_expr := REGEXP_REPLACE(
                             l_mapping(k).parser_col,
                             '#[^.]+\.(\w+)#',
                             'p.\1'
                          );
                v_expr := GET_MAP_CALCULATION_FUN(v_expr,p_collection_name) || ' AS "' || l_mapping(k).tgt_col || '"';

            ELSE
                -- Safe conversion logic
                /*IF l_mapping(k).data_type = 'NUMBER' THEN
                    v_expr := 'CASE WHEN REGEXP_LIKE(TRIM(p.' || l_mapping(k).parser_col || '), ''^-?\d+(\.\d+)?$'') ' ||
                              'THEN TO_NUMBER(TRIM(p.' || l_mapping(k).parser_col || ')) ELSE NULL END AS "' || l_mapping(k).tgt_col || '"';*/
          if      
    /*l_mapping(k).data_type = 'NUMBER' THEN
        -- ✅ Replace this block with FN_CLEAN_NUMBER
       -- v_expr := 'FN_CLEAN_NUMBER(p.' || l_mapping(k).parser_col || ') AS "' || l_mapping(k).tgt_col || '"';
       v_expr := 'FN_CLEAN_NUMBER(''' || REPLACE(l_obj.get_string(l_mapping(k).parser_col), '''', '''''') || ''') AS "' || l_mapping(k).tgt_col || '"';
*/
l_mapping(k).data_type = 'NUMBER' THEN
        v_expr := 'CASE ' ||
              ' WHEN REGEXP_LIKE(REGEXP_REPLACE(p.' || l_mapping(k).parser_col || ', ''[^0-9\.-]'',''''), ''^-?\d+(\.\d+)?$'') ' ||
              ' THEN TO_NUMBER(REGEXP_REPLACE(p.' || l_mapping(k).parser_col || ', ''[^0-9\.-]'','''')) ' ||
              ' ELSE NULL END AS "' || l_mapping(k).tgt_col || '"';




                


                ELSIF l_mapping(k).data_type = 'DATE' THEN
                    v_expr := 'CASE ' ||
                              ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}/\d{2}/\d{4}$'') '||
                              ' THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD/MM/YYYY'') '||
                              ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{4}-\d{2}-\d{2}$'') '||
                              ' THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''YYYY-MM-DD'') '||
                              ' ELSE NULL END AS "' || l_mapping(k).tgt_col || '"';

                ELSE
                    v_expr := 'p.'|| l_mapping(k).parser_col || ' AS "' || l_mapping(k).tgt_col || '"';
                END IF;
            END IF;

            l_vals_calculation := l_vals_calculation || v_expr;
        END IF;
        k := l_mapping.next(k);
    END LOOP;

    INSERT INTO debug_log(message) VALUES('l_cols: ' || l_cols);
    INSERT INTO debug_log(message) VALUES('l_vals_calculation: ' || l_vals_calculation);
    COMMIT;

    -------------------------------------------------------------------
    -- 7. File parsing and row processing (unchanged)
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
                    /****from here l_val_formatted := NULL;
                    IF l_val IS NOT NULL AND REGEXP_LIKE(l_val,'^-?\d+(\.\d+)?$') THEN
                        l_val_formatted := TO_CHAR(TO_NUMBER(l_val));
                    END IF;

                    IF l_val_formatted IS NULL THEN
                        l_val_formatted := '''' || REPLACE(NVL(l_val,''), '''', '''''') || '''';
                    END IF; till here org code*****/
                    -- Format numeric value using FN_CLEAN_NUMBER
l_val_formatted := NULL;

/*IF l_mapping.exists(UPPER(l_col)) AND l_mapping(UPPER(l_col)).data_type = 'NUMBER' THEN
    -- Call your reusable function to safely convert string to number
    l_val_formatted := 'FN_CLEAN_NUMBER(''' || REPLACE(NVL(l_val,''), '''', '''''') || ''')';
   

ELSE
    -- Keep old logic for non-numbers
    l_val_formatted := '''' || REPLACE(NVL(l_val,''), '''', '''''') || '''';
END IF;*/
IF l_mapping.exists(UPPER(l_col)) AND l_mapping(UPPER(l_col)).data_type = 'NUMBER' THEN
    -- Clean number safely before inserting
    IF TRIM(l_val) IS NULL THEN
        l_val_formatted := 'NULL';
    ELSIF REGEXP_LIKE(REGEXP_REPLACE(l_val, '[^0-9\.\-]', ''), '^-?\d+(\.\d+)?$') THEN
        l_val_formatted := TO_CHAR(TO_NUMBER(REGEXP_REPLACE(l_val, '[^0-9\.\-]', '')));
    ELSE
        l_val_formatted := 'NULL'; -- non-numeric text becomes NULL instead of throwing 06502
    END IF;
ELSE
    -- Non-number columns remain same
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


   -- p_status  := case when l_total_rows = l_fail_cnt then 'E' ELSE 'S' END;
   p_status  := case when l_total_rows = l_fail_cnt then 'E' 
                    when l_total_rows = l_success_cnt then 'S'
                    ELSE 'W' END;
    --p_message := case when l_total_rows = l_fail_cnt then 'Failure' ELSE 'Success' END||': Upload completed → Total=' || l_total_rows || ', Success=' || l_success_cnt || ', Failed=' || l_fail_cnt;
/*p_message := '<span style="color:red;">Failure: ' || l_fail_cnt || ' rows failed. ' ||
                 '<a href="' || APEX_PAGE.GET_URL(
                     p_page   => 1601,
                     --p_items  => 'P1601_LOG_ID',
                     --p_values => RAWTOHEX(l_log_id)
                 ) || '" target="_blank">Click here to view errors</a></span>' ||
                 '<br>Total=' || l_total_rows || ', Success=' || l_success_cnt || ', Failed=' || l_fail_cnt;*/
                 p_message :=
    '<span style="color:red;">Failure: ' || l_fail_cnt || ' rows failed. ' ||
    '<a href="' ||
        APEX_PAGE.GET_URL(
            p_page        => 4,
            p_items       => 'P4_INTERFACE_ID_1',
            p_vues      => RAWTOHEX(l_log_id),
            p_request     => 'MODAL'
        ) ||
    '" class="u-success-text" data-dialog="true">Click here to view errors</a></span>' ||
    '<br>Total=' || l_total_rows || ', Success=' || l_success_cnt || ', Failed=' || l_fail_cnt;

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
create or replace PROCEDURE XX_LOCAL_Load_Data_3 (
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
               WHEN  c003 in ('Default','Calculation')  THEN TRIM(c004)  
               WHEN c003 in ('Ignore') THEN regexp_substr(c002, '^[^(]+') END                                    parser_col,
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
                    
                       ELSIF UPPER(NVL(l_mapping(k).map_type, '')) = 'IGNORE' THEN
        -- <-- KEY CHANGE: Ignore mapping -> always insert NULL for this target column
        v_expr := 'NULL AS "' || l_mapping(k).tgt_col || '"';
                    
                    
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
                     INSERT INTO debug_log(message) VALUES(l_stay_col_name||'--- check stay_datete:>   '||l_col);
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
                AP_PAGE.GET_URL(
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
END XX_LOCAL_Load_Data_3;
/
create or replace PROCEDURE XX_LOCAL_Load_Data_4 (
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
                        v_expr :=   l_mapping(k).parser_col ||' AS ' || l_mapping(k).tgt_col;
                        
                    ELSIF l_mapping(k).map_type = 'Calculation' THEN
                        v_expr := REGEXP_REPLACE(
                                                 l_mapping(k).parser_col,
                                                 '#[^.]+\.(\w+)#',
                                                 'p.\1'
                                               ) ;
                        v_expr := GET_MAP_CALCULATION_FUN(v_expr,p_collection_name)||' AS ' || l_mapping(k).tgt_col;    

                    ELSIF UPPER(NVL(l_mapping(k).map_type, '')) = 'IGNORE' THEN
                          -- <-- KEY CHANGE: Ignore mapping -> always insert NULL for this target column
                         v_expr := 'NULL AS "' || l_mapping(k).tgt_col || '"';                                         

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
                    l_sql_select := l_sql_select|| ''''||l_val || ''' as '|| l_col||' , ';

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



        INSERT INTO dO debug_log(message) VALUES('--- l_sql_main:>   '||l_sql_main);
        
            
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
END XX_LOCAL_Load_Data_4;
/





















































create or replace TYPE attribute_value_row AS OBJECT (
    stay_date       DATE,
    attribute_value NUMBER
)
/
create or replace TYPE attribute_value_table AS TABLE OF attribute_value_row
/
create or replace TYPE log_rec_obj AS OBJECT (
    log_id        NUMBER,
    log_message   VARCHAR2(255)
)
/
create or replace TYPE log_tab_type AS TABLE OF log_rec_obj;
CREATE OR REPLACE PACKAGE pkg_log_data_trg AS
    -- Global variable now uses the SQL type
    g_log_data_tab log_tab_type;

    PROCEDURE init;
    PROCEDURE process;
END pkg_log_data_trg
/
create or replace TYPE my_date_list IS TABLE OF DATE
/
create or replace TYPE t_result_rec_obj IS OBJECT (
  algo_name VARCHAR2(255),
  stay_date DATE,
  day_of_week VARCHAR2(10),
  evaluated_price VARCHAR2(4000),  -- Changed from NUMBER to VARCHAR2
  applied_rule CLOB
)
/
create or replace TYPE t_result_tab_obj AS TABLE OF t_result_rec_obj
/
create or replace TYPE UR_attribute_value_row AS OBJECT (
    stay_date        DATE,
    attribute_value  VARCHAR2(4000)
)
/
create or replace TYPE UR_attribute_value_table IS TABLE OF UR_attribute_value_row
/









create or replace PACKAGE BODY ALGO_EVALUATOR_PKG AS

  
  PROCEDURE log_debug(p_message IN VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO debug_log (message)
    VALUES (SUBSTR(p_message, 1, 4000));
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- Don't let logging break the main code
  END log_debug;

  -- [Functions GENERIC_MATH_EVAL, get_attribute_id_from_template, get_value_for_date, FLEXIBLE_TO_DATE, and build_dynamic_query remain unchanged from the previous version]

  FUNCTION GENERIC_MATH_EVAL(p_function_name IN VARCHAR2, p_values IN VARCHAR2) RETURN NUMBER IS
    l_sum   NUMBER := 0; l_count NUMBER := 0; l_min   NUMBER; l_max   NUMBER; l_val   NUMBER;
  BEGIN
  FOR r IN (
      SELECT num
      FROM (
          SELECT
              TO_NUMBER(TRIM(REGEXP_SUBSTR(p_values, '[^,]+', 1, LEVEL)) DEFAULT NULL ON CONVERSION ERROR) AS num
          FROM
              DUAL
          CONNECT BY
              LEVEL <= REGEXP_COUNT(p_values, ',') + 1
      )
      WHERE num IS NOT NULL
  ) LOOP
      l_val := r.num;
      l_sum := l_sum + l_val;
      l_count := l_count + 1;
      IF l_min IS NULL OR l_val < l_min THEN l_min := l_val; END IF;
      IF l_max IS NULL OR l_val > l_max THEN l_max := l_val; END IF;
  END LOOP;

    CASE UPPER(p_function_name)
      WHEN 'SUM'     THEN RETURN l_sum;
      WHEN 'AVERAGE' THEN RETURN CASE WHEN l_count > 0 THEN l_sum / l_count ELSE 0 END;
      WHEN 'COUNT'   THEN RETURN l_count;
      WHEN 'MIN'     THEN RETURN l_min;
      WHEN 'MAX'     THEN RETURN l_max;
      ELSE RETURN NULL;
    END CASE;
  END GENERIC_MATH_EVAL;

  FUNCTION get_attribute_id_from_template(p_template_id VARCHAR2) RETURN VARCHAR2 IS
    l_attr_id VARCHAR2(255);
  BEGIN
    SELECT id INTO l_attr_id FROM ur_algo_attributes WHERE template_id = p_template_id AND name = 'OWN PROPERTY RANK' AND ROWNUM = 1;
    RETURN l_attr_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
  END get_attribute_id_from_template;

  FUNCTION get_value_for_date(p_data_table IN t_result_tab, p_target_date IN DATE) RETURN NUMBER IS
  BEGIN
    IF p_data_table IS NULL THEN RETURN NULL; END IF;
    FOR i IN 1 .. p_data_table.COUNT LOOP
      IF p_data_table(i).stay_date = p_target_date THEN RETURN p_data_table(i).evaluated_price; END IF;
    END LOOP;
    RETURN NULL;
  END get_value_for_date;

  FUNCTION FLEXIBLE_TO_DATE(p_date_string IN VARCHAR2) RETURN DATE IS
  BEGIN
    IF p_date_string IS NULL THEN RETURN NULL; END IF;
    BEGIN RETURN TO_DATE(SUBSTR(p_date_string, 1, 10), 'MM/DD/YYYY'); EXCEPTION WHEN OTHERS THEN
      BEGIN RETURN TO_DATE(SUBSTR(p_date_string, 1, 10), 'YYYY-MM-DD'); EXCEPTION WHEN OTHERS THEN
        BEGIN RETURN TO_DATE(SUBSTR(p_date_string, 1, 10), 'DD/MM/YYYY'); EXCEPTION WHEN OTHERS THEN
          BEGIN RETURN TO_DATE(SUBSTR(p_date_string, 1, 10), 'DD-MM-YYYY'); EXCEPTION WHEN OTHERS THEN
            BEGIN RETURN TO_DATE(SUBSTR(p_date_string, 1, 11), 'DD-MON-YYYY'); EXCEPTION WHEN OTHERS THEN RETURN NULL; END;
          END;
        END;
      END;
    END;
  END FLEXIBLE_TO_DATE;

  FUNCTION build_dynamic_query(p_rules_json IN CLOB) RETURN CLOB IS
     l_sql_select      CLOB := 'SELECT base.STAY_DATE, '; l_sql_from        CLOB; l_sql_where       CLOB := ' WHERE 1=1 ';
     l_price_case_stmt CLOB := 'CASE '; l_rule_case_stmt  CLOB := 'CASE '; TYPE t_alias_map IS TABLE OF VARCHAR2(10) INDEX BY VARCHAR2(255);
     l_aliases         t_alias_map; l_alias_counter   PLS_INTEGER := 1; l_base_alias      VARCHAR2(10); l_current_id      VARCHAR2(255);
     l_regions_count   PLS_INTEGER; TYPE t_attr_tab IS TABLE OF VARCHAR2(255); l_attr_collection t_attr_tab := t_attr_tab();
     TYPE t_set_map IS TABLE OF BOOLEAN INDEX BY VARCHAR2(255); l_unique_attrs t_set_map; l_occ_attr_raw VARCHAR2(255);
     l_pr_template  VARCHAR2(255); l_expr_raw      VARCHAR2(32767); l_pos           PLS_INTEGER; l_attr_in_expr VARCHAR2(255);
    BEGIN
      FOR cond_rec IN (SELECT cond_json FROM JSON_TABLE(p_rules_json, '$.regions[*].conditions[*]' COLUMNS (cond_json CLOB FORMAT JSON PATH '$')) conds) LOOP
        l_occ_attr_raw := JSON_VALUE(cond_rec.cond_json, '$.occupancyThreshold.attribute');
        l_pr_template := JSON_VALUE(cond_rec.cond_json, '$.propertyRanking.type');
        l_expr_raw := JSON_VALUE(cond_rec.cond_json, '$.expression');
        IF l_occ_attr_raw IS NOT NULL THEN l_unique_attrs(REGEXP_REPLACE(l_occ_attr_raw, '^#|#$', '')) := TRUE; END IF;
        IF l_pr_template IS NOT NULL THEN DECLARE l_pr_attr VARCHAR2(255); BEGIN l_pr_attr := get_attribute_id_from_template(l_pr_template); IF l_pr_attr IS NOT NULL THEN l_unique_attrs(l_pr_attr) := TRUE; END IF; END; END IF;
        l_pos := 1;
        LOOP l_attr_in_expr := REGEXP_SUBSTR(l_expr_raw, '#[A-F0-9]+#', l_pos); EXIT WHEN l_attr_in_expr IS NULL; l_unique_attrs(REGEXP_REPLACE(l_attr_in_expr, '^#|#$', '')) := TRUE; l_pos := INSTR(l_expr_raw, l_attr_in_expr, l_pos) + LENGTH(l_attr_in_expr); END LOOP;
      END LOOP;
      l_attr_collection.DELETE;
      DECLARE l_key VARCHAR2(255); BEGIN l_key := l_unique_attrs.FIRST; WHILE l_key IS NOT NULL LOOP l_attr_collection.EXTEND; l_attr_collection(l_attr_collection.COUNT) := l_key; l_key := l_unique_attrs.NEXT(l_key); END LOOP; END;
      IF l_attr_collection.COUNT = 0 THEN RETURN q'[SELECT NULL, NULL, 'ERROR: No attributes found in JSON' FROM DUAL]'; END IF;
      FOR i IN 1 .. l_attr_collection.COUNT LOOP l_aliases(l_attr_collection(i)) := 'a' || l_alias_counter; l_alias_counter := l_alias_counter + 1; END LOOP;
      l_base_alias := l_aliases(l_attr_collection(1)); l_sql_from := ' FROM TABLE(ur_utils.GET_ATTRIBUTE_VALUE(p_attribute_id => ''' || l_attr_collection(1) || ''')) ' || l_base_alias;
      FOR i IN 2 .. l_attr_collection.COUNT LOOP l_sql_from := l_sql_from || ' LEFT JOIN TABLE(ur_utils.GET_ATTRIBUTE_VALUE(p_attribute_id => ''' || l_attr_collection(i) || ''')) ' || l_aliases(l_attr_collection(i)) || ' ON ' || l_base_alias || '.STAY_DATE = ' || l_aliases(l_attr_collection(i)) || '.STAY_DATE '; END LOOP;
      FOR f IN (SELECT stay_from, stay_to, lead_from, lead_to, days_of_week, min_rate FROM JSON_TABLE(p_rules_json, '$.regions[0].filters' COLUMNS (stay_from DATE PATH '$.stayWindow.from', stay_to DATE PATH '$.stayWindow.to', lead_from DATE PATH '$.leadTime.from', lead_to DATE PATH '$.leadTime.to', days_of_week VARCHAR2(100) FORMAT JSON PATH '$.daysOfWeek', min_rate NUMBER PATH '$.minimumRate'))) LOOP
        l_sql_where := l_sql_where || ' AND ' || l_base_alias || '.STAY_DATE BETWEEN TO_DATE(''' || TO_CHAR(f.stay_from, 'YYYY-MM-DD') || ''', ''YYYY-MM-DD'') AND TO_DATE(''' || TO_CHAR(f.stay_to, 'YYYY-MM-DD') || ''', ''YYYY-MM-DD'')';
        l_sql_where := l_sql_where || ' AND TRUNC(SYSDATE) BETWEEN TO_DATE(''' || TO_CHAR(f.lead_from, 'YYYY-MM-DD') || ''', ''YYYY-MM-DD'') AND TO_DATE(''' || TO_CHAR(f.lead_to, 'YYYY-MM-DD') || ''', ''YYYY-MM-DD'')';
        IF f.days_of_week IS NOT NULL AND f.days_of_week <> '[]' THEN l_sql_where := l_sql_where || ' AND TO_CHAR('||l_base_alias||'.STAY_DATE, ''D'') IN (' || REPLACE(REPLACE(f.days_of_week, '[', ''), ']', '') || ') '; END IF;
        l_sql_where := l_sql_where || ' AND ' || l_base_alias || '.ATTRIBUTE_VALUE >= ' || f.min_rate;
      END LOOP;
      l_sql_where := l_sql_where || ' AND (' || l_base_alias || '.STAY_DATE = :b_stay_date_filter OR :b_stay_date_null_check IS NULL) ';
      l_regions_count := TO_NUMBER(JSON_VALUE(p_rules_json, '$.regions.size()'));
      FOR i IN 0 .. l_regions_count - 1 LOOP
        DECLARE
          l_when_clause VARCHAR2(32000) := 'WHEN ('; l_expr VARCHAR2(4000) := JSON_VALUE(p_rules_json, '$.regions[' || i || '].conditions[0].expression');
          l_region_name VARCHAR2(255) := JSON_VALUE(p_rules_json, '$.regions[' || i || '].name'); l_cond_name VARCHAR2(255) := JSON_VALUE(p_rules_json, '$.regions[' || i || '].conditions[0].name');
          l_full_rule_name VARCHAR2(512) := REPLACE(l_region_name || ' / ' || l_cond_name, '''', '''''');
        BEGIN
          FOR j IN 0 .. TO_NUMBER(JSON_VALUE(p_rules_json, '$.regions[' || i || '].conditions.size()')) - 1 LOOP
            DECLARE
              l_cond_path VARCHAR2(200) := '$.regions[' || i || '].conditions[' || j || ']'; l_occ_attr_raw VARCHAR2(255) := JSON_VALUE(p_rules_json, l_cond_path || '.occupancyThreshold.attribute');
              l_occ_attr VARCHAR2(255) := REGEXP_REPLACE(NVL(l_occ_attr_raw, ''), '^#|#$', ''); l_pr_template_id VARCHAR2(255) := JSON_VALUE(p_rules_json, l_cond_path || '.propertyRanking.type');
              l_pr_attr VARCHAR2(255) := get_attribute_id_from_template(l_pr_template_id); l_occ_op VARCHAR2(10) := JSON_VALUE(p_rules_json, l_cond_path || '.occupancyThreshold.operator');
              l_occ_val NUMBER := TO_NUMBER(JSON_VALUE(p_rules_json, l_cond_path || '.occupancyThreshold.value')); l_pr_op VARCHAR2(10) := JSON_VALUE(p_rules_json, l_cond_path || '.propertyRanking.operator');
              l_pr_val NUMBER := TO_NUMBER(JSON_VALUE(p_rules_json, l_cond_path || '.propertyRanking.value'));
            BEGIN
              IF l_occ_attr IS NOT NULL AND l_aliases.EXISTS(l_occ_attr) THEN l_when_clause := l_when_clause || l_aliases(l_occ_attr) || '.ATTRIBUTE_VALUE ' || l_occ_op || ' ' || l_occ_val || ' AND '; END IF;
              IF l_pr_attr IS NOT NULL AND l_aliases.EXISTS(l_pr_attr) THEN l_when_clause := l_when_clause || l_aliases(l_pr_attr) || '.ATTRIBUTE_VALUE ' || l_pr_op || ' ' || l_pr_val || ' AND '; END IF;
            END;
          END LOOP;
          l_when_clause := RTRIM(l_when_clause, ' AND ') || ')';
          l_current_id := l_aliases.FIRST;
          WHILE l_current_id IS NOT NULL LOOP l_expr := REPLACE(l_expr, '#' || l_current_id || '#', l_aliases(l_current_id) || '.ATTRIBUTE_VALUE'); l_current_id := l_aliases.NEXT(l_current_id); END LOOP;
          l_price_case_stmt := l_price_case_stmt || l_when_clause || ' THEN ' || l_expr || ' ';
          l_rule_case_stmt  := l_rule_case_stmt || l_when_clause || ' THEN ''' || l_full_rule_name || ''' ';
        END;
      END LOOP;
      l_price_case_stmt := l_price_case_stmt || ' ELSE NULL END'; l_rule_case_stmt  := l_rule_case_stmt || ' ELSE ''No Rule Applied'' END';
      l_sql_select := l_sql_select || l_price_case_stmt || ' AS EVALUATED_PRICE, ' || l_rule_case_stmt || ' AS APPLIED_RULE';
      RETURN l_sql_select || l_sql_from || l_sql_where;
    END build_dynamic_query;

FUNCTION EVALUATE(
    p_algo_id    IN ur_algos.id%TYPE,
    p_version_id IN ur_algo_versions.id%TYPE DEFAULT NULL,
    p_stay_date  IN DATE DEFAULT NULL
  ) RETURN t_result_tab_obj PIPELINED IS
    l_rules_json         CLOB;
    TYPE t_alias_map IS TABLE OF VARCHAR2(255) INDEX BY VARCHAR2(255);
    l_aliases t_alias_map;
    l_current_id         VARCHAR2(255);
    TYPE t_staged_data_map IS TABLE OF t_result_tab INDEX BY VARCHAR2(255);
    l_staged_data t_staged_data_map;
    TYPE t_date_set IS TABLE OF BOOLEAN INDEX BY VARCHAR2(255);
    l_date_set t_date_set;
    l_all_dates SYS.ODCIDATELIST := SYS.ODCIDATELIST();
    l_distinct_dates     SYS.ODCIDATELIST := SYS.ODCIDATELIST();
    l_hotel_id ur_algos.hotel_id%TYPE;
    TYPE t_event_score_map IS TABLE OF NUMBER INDEX BY VARCHAR2(10);
    l_event_scores t_event_score_map;
    TYPE t_lead_date_map IS TABLE OF DATE INDEX BY VARCHAR2(255);
    l_lead_dates t_lead_date_map; -- << CORRECTED THIS LINE
    l_lead_attr_ids t_date_set;

    -- ++ NEW VARIABLES
    l_algo_name         ur_algos.name%TYPE;
    l_effective_algo_id ur_algos.id%TYPE;
    l_version_id_to_use ur_algo_versions.id%TYPE;
    -- / NEW VARIABLES
  BEGIN
    log_debug('EVALUATE START: p_algo_id=' || p_algo_id || ', p_version_id=' || p_version_id || ', p_stay_date=' || TO_CHAR(p_stay_date, 'YYYY-MM-DD')); -- (new log line)

    -- ++ MODIFIED LOGIC: Determine which version and algo to use
    BEGIN
      IF p_version_id IS NOT NULL THEN
        -- A specific version is provided, use it directly.
        l_version_id_to_use := p_version_id;
        SELECT av.expression, av.algo_id, a.name, a.hotel_id
        INTO l_rules_json, l_effective_algo_id, l_algo_name, l_hotel_id
        FROM ur_algo_versions av
        JOIN ur_algos a ON av.algo_id = a.id
        WHERE av.id = l_version_id_to_use;
      ELSE
        -- No version ID provided, use the algo_id to find the current version.
        l_effective_algo_id := p_algo_id;
        SELECT a.current_version_id, a.name, a.hotel_id
        INTO l_version_id_to_use, l_algo_name, l_hotel_id
        FROM ur_algos a
        WHERE a.id = l_effective_algo_id;

        SELECT expression INTO l_rules_json
        FROM ur_algo_versions
        WHERE id = l_version_id_to_use;
      END IF;
      
      log_debug('Algo details loaded: l_effective_algo_id=' || l_effective_algo_id || ', l_version_id_to_use=' || l_version_id_to_use || ', l_hotel_id=' || l_hotel_id); -- (new log line)
      log_debug('Rules JSON size: ' || DBMS_LOB.GETLENGTH(l_rules_json)); -- (new log line)
      
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        log_debug('EVALUATE ERROR: Algorithm or Version not found for p_algo_id=' || p_algo_id || ', p_version_id=' || p_version_id); -- (new log line)
        PIPE ROW(t_result_rec_obj(l_algo_name, NULL, NULL, NULL, 'ERROR: Algorithm or Version not found.'));
        RETURN;
    END;
    -- / MODIFIED LOGIC

    FOR rec IN (SELECT JSON_VALUE(cond_json, '$.occupancyThreshold.attribute') as occ_attr, JSON_VALUE(cond_json, '$.propertyRanking.type') as pr_template, JSON_VALUE(cond_json, '$.expression') as expr, JSON_VALUE(lead_time_json, '$.attribute') as lead_attr FROM JSON_TABLE(l_rules_json, '$.regions[*]' COLUMNS (lead_time_json CLOB FORMAT JSON PATH '$.filters.leadTime', NESTED PATH '$.conditions[*]' COLUMNS (cond_json CLOB FORMAT JSON PATH '$')))) LOOP
      DECLARE
        l_occ_attr VARCHAR2(255) := REGEXP_REPLACE(NVL(rec.occ_attr, ''), '^#|#$', ''); l_pr_attr_id VARCHAR2(255);
        l_lead_attr VARCHAR2(255) := REGEXP_REPLACE(NVL(rec.lead_attr, ''), '^#|#$', ''); l_pos PLS_INTEGER := 1;
        l_attr_in_expr VARCHAR2(255); l_clean_attr VARCHAR2(255);
      BEGIN
        IF l_occ_attr IS NOT NULL AND NOT l_aliases.EXISTS(l_occ_attr) THEN l_aliases(l_occ_attr) := l_occ_attr; END IF;
        IF l_lead_attr IS NOT NULL AND NOT l_aliases.EXISTS(l_lead_attr) THEN l_aliases(l_lead_attr) := l_lead_attr; l_lead_attr_ids(l_lead_attr) := TRUE; END IF;
        IF rec.pr_template IS NOT NULL THEN l_pr_attr_id := get_attribute_id_from_template(REPLACE(rec.pr_template, '#', '')); IF l_pr_attr_id IS NOT NULL AND NOT l_aliases.EXISTS(l_pr_attr_id) THEN l_aliases(l_pr_attr_id) := l_pr_attr_id; END IF; END IF;
        -- Only extract attributes from expression if it's NOT free text (not wrapped in ~text~)
        IF NOT REGEXP_LIKE(rec.expr, '^~.*~$') THEN
          LOOP l_attr_in_expr := REGEXP_SUBSTR(rec.expr, '#[A-F0-9]+#', l_pos); EXIT WHEN l_attr_in_expr IS NULL; l_clean_attr := REGEXP_REPLACE(l_attr_in_expr, '^#|#$', ''); IF NOT l_aliases.EXISTS(l_clean_attr) THEN l_aliases(l_clean_attr) := l_clean_attr; END IF; l_pos := INSTR(rec.expr, l_attr_in_expr, l_pos) + LENGTH(l_attr_in_expr); END LOOP;
        END IF;
      END;
    END LOOP;

    log_debug('Alias parsing complete. Found ' || l_aliases.COUNT || ' unique attributes.'); -- (new log line)

    IF l_aliases.COUNT = 0 THEN 
      log_debug('EVALUATE ERROR: No attributes found in JSON. Halting.'); -- (new log line)
      PIPE ROW(t_result_rec_obj(l_algo_name, NULL, NULL, NULL, 'ERROR: No attributes found in JSON')); 
      RETURN; 
    END IF;

    DECLARE
      TYPE t_event_rec IS RECORD ( event_date_str VARCHAR2(10), max_score NUMBER ); TYPE t_event_tab IS TABLE OF t_event_rec; l_event_list t_event_tab;
    BEGIN
      SELECT TO_CHAR(event_date, 'YYYY-MM-DD'), MAX(score) BULK COLLECT INTO l_event_list FROM (SELECT e.event_start_date + level - 1 AS event_date, (e.impact_level * e.impact_type) AS score FROM ur_events e WHERE e.hotel_id = l_hotel_id CONNECT BY level <= e.event_end_date - e.event_start_date + 1 AND PRIOR e.id = e.id AND PRIOR sys_guid() IS NOT NULL) GROUP BY event_date;
      FOR i IN 1 .. l_event_list.COUNT LOOP l_event_scores(l_event_list(i).event_date_str) := l_event_list(i).max_score; END LOOP;
      log_debug('Loaded ' || l_event_list.COUNT || ' event scores.'); -- (new log line)
    END;

    log_debug('Starting data load for ' || l_aliases.COUNT || ' attributes...'); -- (new log line)
    l_current_id := l_aliases.FIRST;
    WHILE l_current_id IS NOT NULL LOOP
      log_debug('Loading data for attribute: ' || l_current_id); -- (new log line)
      IF l_lead_attr_ids.EXISTS(l_current_id) THEN
        log_debug('... (as lead date attribute)'); -- (new log line)
        FOR rec IN (SELECT stay_date, attribute_value FROM TABLE(ur_utils.GET_ATTRIBUTE_VALUE(p_attribute_id => l_current_id, p_hotel_id => l_hotel_id)) WHERE attribute_value IS NOT NULL) LOOP
          DECLARE l_converted_date DATE; BEGIN l_converted_date := FLEXIBLE_TO_DATE(rec.attribute_value); IF l_converted_date IS NOT NULL THEN l_lead_dates(TO_CHAR(rec.stay_date, 'YYYY-MM-DD') || l_current_id) := l_converted_date; END IF; END;
        END LOOP;
      ELSE
        log_debug('... (as standard value attribute)'); -- (new log line)
        SELECT stay_date, TO_NUMBER(attribute_value), NULL BULK COLLECT INTO l_staged_data(l_current_id) FROM TABLE(ur_utils.GET_ATTRIBUTE_VALUE(p_attribute_id => l_current_id, p_hotel_id => l_hotel_id)) WHERE attribute_value IS NOT NULL;
        log_debug('... Loaded ' || l_staged_data(l_current_id).COUNT || ' rows into staged data.'); -- (new log line)
      END IF;
      
      FOR rec IN (SELECT stay_date FROM TABLE(ur_utils.GET_ATTRIBUTE_VALUE(p_attribute_id => l_current_id, p_hotel_id => l_hotel_id))) LOOP 
        l_date_set(TO_CHAR(rec.stay_date, 'YYYY-MM-DD')) := TRUE; 
      END LOOP;
      
      l_current_id := l_aliases.NEXT(l_current_id);
    END LOOP;
    log_debug('Data loading complete. Total unique dates found: ' || l_date_set.COUNT); -- (new log line)

    DECLARE v_date_key VARCHAR2(255) := l_date_set.FIRST; BEGIN WHILE v_date_key IS NOT NULL LOOP l_distinct_dates.EXTEND; l_distinct_dates(l_distinct_dates.LAST) := TO_DATE(v_date_key, 'YYYY-MM-DD'); v_date_key := l_date_set.NEXT(v_date_key); END LOOP; END;

    log_debug('Populated distinct dates collection. Count: ' || l_distinct_dates.COUNT); -- (new log line)
    
    IF l_distinct_dates.COUNT = 0 THEN
      log_debug('WARNING: Distinct dates collection is EMPTY. Main loop will be skipped. No rows will be returned.'); -- (new log line)
    END IF;

    <<date_loop>>
    FOR d IN (SELECT COLUMN_VALUE AS stay_date FROM TABLE(l_distinct_dates) ORDER BY COLUMN_VALUE) LOOP
      DECLARE
        v_stay_date DATE := d.stay_date;
        v_any_rule_matched_for_date BOOLEAN := FALSE;
        l_failure_details_json CLOB := NULL;
      BEGIN
        log_debug('--- Processing date: ' || TO_CHAR(v_stay_date, 'YYYY-MM-DD') || ' ---'); -- (new log line)

        IF p_stay_date IS NOT NULL AND v_stay_date != p_stay_date THEN
          log_debug('Skipping date ' || TO_CHAR(v_stay_date, 'YYYY-MM-DD') || ' as it does not match p_stay_date filter.'); -- (new log line)
          GOTO next_date;
        END IF;

        <<regions_loop>>
        FOR region_rec IN (
          SELECT region_name, stay_from, stay_to, conditions, days_of_week, minimum_rate, sequence, lead_attr_raw, lead_type, lead_from_val, lead_to_val, lead_value
          FROM JSON_TABLE(l_rules_json, '$.regions[*]' COLUMNS (
            region_name  VARCHAR2(255) PATH '$.name', stay_from DATE PATH '$.filters.stayWindow.from', stay_to DATE PATH '$.filters.stayWindow.to',
            conditions   CLOB FORMAT JSON PATH '$.conditions', days_of_week VARCHAR2(100) FORMAT JSON PATH '$.filters.daysOfWeek',
            minimum_rate NUMBER PATH '$.filters.minimumRate', sequence NUMBER PATH '$.sequence',
            lead_attr_raw  VARCHAR2(255) PATH '$.filters.leadTime.attribute', lead_type VARCHAR2(50) PATH '$.filters.leadTime.type',
            lead_from_val  DATE PATH '$.filters.leadTime.from', lead_to_val DATE PATH '$.filters.leadTime.to',
            lead_value     NUMBER PATH '$.filters.leadTime.value'
          )) ORDER BY sequence
        ) LOOP
          DECLARE
            l_filters_passed BOOLEAN := TRUE;
            l_filter_failure_json CLOB := NULL;
            l_lead_time_json CLOB := 'null';
          BEGIN
            log_debug('Checking Region: ' || region_rec.region_name); -- (new log line)
          
            IF NOT (v_stay_date BETWEEN region_rec.stay_from AND region_rec.stay_to) THEN
              l_filters_passed := FALSE;
              l_filter_failure_json := '{"filter_name":"stay_window", "actual":"'||TO_CHAR(v_stay_date, 'YYYY-MM-DD')||'", "required":"'||TO_CHAR(region_rec.stay_from, 'YYYY-MM-DD')||' to '||TO_CHAR(region_rec.stay_to, 'YYYY-MM-DD')||'", "passed":false}';
              log_debug('... FILTER FAILED: Stay Window. ' || l_filter_failure_json); -- (new log line)
            ELSIF region_rec.days_of_week IS NOT NULL AND region_rec.days_of_week <> '[]' AND INSTR(region_rec.days_of_week, TO_CHAR(v_stay_date, 'D')) = 0 THEN
              l_filters_passed := FALSE;
              l_filter_failure_json := '{"filter_name":"day_of_week", "actual":"'||TO_CHAR(v_stay_date, 'D')||'", "required":'||REPLACE(region_rec.days_of_week,'"','\"')||', "passed":false}';
              log_debug('... FILTER FAILED: Day of Week. ' || l_filter_failure_json); -- (new log line)
            ELSIF region_rec.lead_type IS NOT NULL THEN
              DECLARE
                lt_passes BOOLEAN := TRUE; lt_attr_id VARCHAR2(255); actual_lt_date DATE; lt_key VARCHAR2(265);
              BEGIN
                lt_attr_id := REGEXP_REPLACE(NVL(region_rec.lead_attr_raw, ''), '^#|#$', ''); lt_key := TO_CHAR(v_stay_date, 'YYYY-MM-DD') || lt_attr_id;
                IF l_lead_dates.EXISTS(lt_key) THEN actual_lt_date := l_lead_dates(lt_key); ELSE actual_lt_date := NULL; END IF;
                IF actual_lt_date IS NULL THEN lt_passes := FALSE; END IF;
                CASE region_rec.lead_type
                  WHEN 'date_range' THEN
                    IF lt_passes AND NOT (actual_lt_date BETWEEN region_rec.lead_from_val AND region_rec.lead_to_val) THEN lt_passes := FALSE; END IF;
                    l_lead_time_json := '{"filter_name":"lead_time", "type":"date_range", "attribute":"'||lt_attr_id||'", "actual":"'||TO_CHAR(actual_lt_date, 'YYYY-MM-DD')||'", "from":"'||TO_CHAR(region_rec.lead_from_val, 'YYYY-MM-DD')||'", "to":"'||TO_CHAR(region_rec.lead_to_val, 'YYYY-MM-DD')||'"}';
                  WHEN 'days' THEN
                    IF lt_passes AND (TRUNC(v_stay_date) - TRUNC(actual_lt_date)) < region_rec.lead_value THEN lt_passes := FALSE; END IF;
                    l_lead_time_json := '{"filter_name":"lead_time", "type":"days", "attribute":"'||lt_attr_id||'", "actual_lead_days":'||(TRUNC(v_stay_date) - TRUNC(actual_lt_date))||', "required_lead_days":'||region_rec.lead_value||'}';
                  ELSE l_lead_time_json := '{"filter_name":"lead_time", "type":"unknown"}';
                END CASE;
                IF NOT lt_passes THEN
                  l_filters_passed := FALSE;
                  l_filter_failure_json := RTRIM(l_lead_time_json, '}') || ', "passed": false}';
                  log_debug('... FILTER FAILED: Lead Time. ' || l_filter_failure_json); -- (new log line)
                END IF;
              END;
            END IF;
            
            IF l_filters_passed THEN
              log_debug('... Filters PASSED for Region: ' || region_rec.region_name); -- (new log line)
              FOR cond_rec IN (
                SELECT cond_name, expr, occ_attr, occ_op, occ_val, pr_type, pr_op, pr_val, es_op, es_val, sequence
                FROM JSON_TABLE(region_rec.conditions, '$[*]' COLUMNS (
                  cond_name VARCHAR2(255) PATH '$.name', expr VARCHAR2(4000) PATH '$.expression', sequence NUMBER PATH '$.sequence',
                  occ_attr VARCHAR2(255) PATH '$.occupancyThreshold.attribute', occ_op VARCHAR2(10) PATH '$.occupancyThreshold.operator', occ_val NUMBER PATH '$.occupancyThreshold.value',
                  pr_type VARCHAR2(255) PATH '$.propertyRanking.type', pr_op VARCHAR2(10) PATH '$.propertyRanking.operator', pr_val NUMBER PATH '$.propertyRanking.value',
                  es_op VARCHAR2(10) PATH '$.eventScore.operator', es_val NUMBER PATH '$.eventScore.value'
                )) ORDER BY sequence
              ) LOOP
                DECLARE
                  l_expr CLOB := cond_rec.expr; l_eval_result NUMBER; l_applied_rule_json CLOB; v_condition_met BOOLEAN := TRUE;
                  l_actual_occ_val NUMBER := NULL; l_occ_attr_id VARCHAR2(255); l_pr_template_id VARCHAR2(255); l_pr_attr_id VARCHAR2(255);
                  l_actual_pr_val NUMBER := NULL; l_actual_event_score NUMBER := NULL; l_date_key VARCHAR2(10); l_attr_json CLOB;
                  l_raw_expr VARCHAR2(4000); l_eval_copy VARCHAR2(4000); l_expr_outcome NUMBER; l_attr_val VARCHAR2(4000);
                  l_attr_counter INTEGER := 0; l_failed_cond_json CLOB; l_check_result NUMBER; l_occ_failed BOOLEAN := NULL;
                  l_pr_failed BOOLEAN := NULL; l_ev_failed BOOLEAN := NULL; l_attr_in_expr VARCHAR2(255); l_pos PLS_INTEGER;
                  -- Variables for free text expression support
                  l_is_free_text BOOLEAN := FALSE;
                  l_text_result VARCHAR2(4000);
                BEGIN
                  log_debug('...... Checking Condition: ' || cond_rec.cond_name); -- (new log line)

                  -- Detect if expression is free text (wrapped in ~text~)
                  l_is_free_text := REGEXP_LIKE(cond_rec.expr, '^~.*~$');
                  log_debug('......... Expression type: ' || CASE WHEN l_is_free_text THEN 'FREE_TEXT' ELSE 'MATHEMATICAL' END);

                  l_occ_failed := NULL;
                  IF cond_rec.occ_attr IS NOT NULL THEN 
                    l_occ_attr_id := REPLACE(cond_rec.occ_attr, '#', ''); 
                    IF l_staged_data.EXISTS(l_occ_attr_id) THEN 
                      l_actual_occ_val := get_value_for_date(l_staged_data(l_occ_attr_id), v_stay_date); 
                      EXECUTE IMMEDIATE 'BEGIN :result := CASE WHEN :val1 ' || cond_rec.occ_op || ' :val2 THEN 1 ELSE 0 END; END;' USING OUT l_check_result, IN l_actual_occ_val, IN cond_rec.occ_val; 
                      IF l_check_result = 0 OR l_actual_occ_val IS NULL THEN 
                        log_debug('......... Occupancy FAILED. Actual: ' || NVL(TO_CHAR(l_actual_occ_val), 'NULL') || ' ' || cond_rec.occ_op || ' ' || cond_rec.occ_val); -- (new log line)
                        l_occ_failed := TRUE; v_condition_met := FALSE; 
                      ELSE 
                        l_occ_failed := FALSE; 
                      END IF; 
                    ELSE 
                      log_debug('......... Occupancy FAILED. Attribute data missing: ' || l_occ_attr_id); -- (new log line)
                      l_occ_failed := TRUE; v_condition_met := FALSE; 
                    END IF; 
                  END IF;
                  
                  l_pr_failed := NULL;
                  IF v_condition_met AND cond_rec.pr_type IS NOT NULL THEN 
                    l_pr_template_id := REPLACE(cond_rec.pr_type, '#', ''); 
                    l_pr_attr_id := get_attribute_id_from_template(l_pr_template_id); 
                    IF l_pr_attr_id IS NOT NULL AND l_staged_data.EXISTS(l_pr_attr_id) THEN 
                      l_actual_pr_val := get_value_for_date(l_staged_data(l_pr_attr_id), v_stay_date); 
                      EXECUTE IMMEDIATE 'BEGIN :result := CASE WHEN :val1 ' || cond_rec.pr_op || ' :val2 THEN 1 ELSE 0 END; END;' USING OUT l_check_result, IN l_actual_pr_val, IN cond_rec.pr_val; 
                      IF l_check_result = 0 OR l_actual_pr_val IS NULL THEN 
                        log_debug('......... Property Ranking FAILED. Actual: ' || NVL(TO_CHAR(l_actual_pr_val), 'NULL') || ' ' || cond_rec.pr_op || ' ' || cond_rec.pr_val); -- (new log line)
                        l_pr_failed := TRUE; v_condition_met := FALSE; 
                      ELSE 
                        l_pr_failed := FALSE; 
                      END IF; 
                    ELSE 
                      log_debug('......... Property Ranking FAILED. Attribute data missing: ' || l_pr_attr_id); -- (new log line)
                      l_pr_failed := TRUE; v_condition_met := FALSE; 
                    END IF; 
                  END IF;
                  
                  l_ev_failed := NULL;
                  IF v_condition_met AND cond_rec.es_val IS NOT NULL THEN 
                    l_date_key := TO_CHAR(v_stay_date, 'YYYY-MM-DD'); 
                    IF l_event_scores.EXISTS(l_date_key) THEN 
                      l_actual_event_score := l_event_scores(l_date_key); 
                    ELSE 
                      l_actual_event_score := 0; 
                    END IF; 
                    EXECUTE IMMEDIATE 'BEGIN :result := CASE WHEN :val1 ' || cond_rec.es_op || ' :val2 THEN 1 ELSE 0 END; END;' USING OUT l_check_result, IN l_actual_event_score, IN cond_rec.es_val; 
                    IF l_check_result = 0 THEN 
                      log_debug('......... Event Score FAILED. Actual: ' || NVL(TO_CHAR(l_actual_event_score), 'NULL') || ' ' || cond_rec.es_op || ' ' || cond_rec.es_val); -- (new log line)
                      l_ev_failed := TRUE; v_condition_met := FALSE; 
                    ELSE 
                      l_ev_failed := FALSE; 
                    END IF; 
                  END IF;
                  
                  IF v_condition_met THEN
                    log_debug('......... Condition MET. Evaluating expression: ' || cond_rec.expr); -- (new log line)

                    -- Handle Free Text Expression
                    IF l_is_free_text THEN
                      -- Extract text between tildas
                      l_text_result := REGEXP_REPLACE(cond_rec.expr, '^~|~$', '');
                      log_debug('............ Free text result: ' || l_text_result); -- (new log line)

                      -- Build JSON output for free text (no expression values, no numeric result)
                      l_attr_json := '{}';
                      l_applied_rule_json := '{'
                        || '"region":"' || REPLACE(region_rec.region_name,'"','\"')
                        || '", "condition":"' || REPLACE(cond_rec.cond_name,'"','\"')
                        || '", "stay_date":"' || TO_CHAR(v_stay_date,'YYYY-MM-DD')
                        || '", "filters":{'
                        || '"stay_window":"' || TO_CHAR(region_rec.stay_from,'YYYY-MM-DD') || ' to ' || TO_CHAR(region_rec.stay_to,'YYYY-MM-DD') || '"'
                        || ', "lead_time":' || l_lead_time_json
                        || CASE WHEN region_rec.days_of_week IS NOT NULL THEN ', "days_of_week":' || REPLACE(region_rec.days_of_week,'"','\"') ELSE '' END
                        || '}'
                        || ', "occupancy":' || CASE WHEN cond_rec.occ_attr IS NOT NULL THEN '{"attr":"' || REPLACE(cond_rec.occ_attr,'#','') || '", "actual":' || NVL(TO_CHAR(l_actual_occ_val),'null') || ', "operator":"' || cond_rec.occ_op || '", "threshold":' || TO_CHAR(cond_rec.occ_val) || ', "failed":' || CASE WHEN l_occ_failed THEN 'true' ELSE 'false' END || '}' ELSE 'null' END
                        || ', "property_ranking":' || CASE WHEN cond_rec.pr_type IS NOT NULL THEN '{"attr":"' || NVL(l_pr_attr_id,'') || '", "actual":' || NVL(TO_CHAR(l_actual_pr_val),'null') || ', "operator":"' || cond_rec.pr_op || '", "threshold":' || TO_CHAR(cond_rec.pr_val) || ', "failed":' || CASE WHEN l_pr_failed THEN 'true' ELSE 'false' END || '}' ELSE 'null' END
                        || ', "event_score":' || CASE WHEN cond_rec.es_val IS NOT NULL THEN '{"actual":' || NVL(TO_CHAR(l_actual_event_score),'null') || ', "operator":"' || cond_rec.es_op || '", "threshold":' || TO_CHAR(cond_rec.es_val) || ', "failed":' || CASE WHEN l_ev_failed THEN 'true' ELSE 'false' END || '}' ELSE 'null' END
                        || ', "expression":"' || REPLACE(cond_rec.expr,'"','\"')
                        || '", "expression_values":' || l_attr_json
                        || ', "evaluated_outcome":null'
                        || ', "result_type":"text"'
                        || ', "result":"' || REPLACE(l_text_result,'"','\"') || '"'
                        || '}';

                      PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), l_text_result, l_applied_rule_json));
                      log_debug('... PIPED ROW (free text) for date ' || TO_CHAR(v_stay_date, 'YYYY-MM-DD')); -- (new log line)

                    ELSE
                      -- Handle Mathematical Expression (existing logic)
                      l_raw_expr := cond_rec.expr; l_eval_copy := cond_rec.expr; l_attr_json := '{'; l_attr_counter := 0; l_pos := 1;
                      LOOP l_attr_in_expr := REGEXP_SUBSTR(cond_rec.expr, '#[A-F0-9]+#', 1, l_pos); EXIT WHEN l_attr_in_expr IS NULL; l_current_id := REGEXP_REPLACE(l_attr_in_expr, '^#|#$', ''); l_attr_val := TO_CHAR(get_value_for_date(l_staged_data(l_current_id), v_stay_date)); l_eval_copy := REPLACE(l_eval_copy, '#' || l_current_id || '#', NVL(l_attr_val, '0')); IF l_attr_counter > 0 THEN l_attr_json := l_attr_json || ','; END IF; l_attr_json := l_attr_json || '"' || l_current_id || '":' || NVL(l_attr_val, 'null'); l_pos := l_pos + 1; l_attr_counter := l_attr_counter + 1; END LOOP;
                      l_attr_json := l_attr_json || '}';

                      log_debug('............ Expression with values: ' || l_eval_copy); -- (new log line)

                      l_eval_copy := REGEXP_REPLACE(l_eval_copy, '(AVERAGE|SUM|COUNT|MAX|MIN)\s*\((.*?)\)', 'ALGO_EVALUATOR_PKG.GENERIC_MATH_EVAL(''\1'', ''\2'')', 1, 0, 'i');

                      log_debug('............ Final parsable expression: ' || l_eval_copy); -- (new log line)

                      EXECUTE IMMEDIATE 'SELECT ' || l_eval_copy || ' FROM DUAL' INTO l_expr_outcome;
                      l_eval_result := l_expr_outcome;

                      log_debug('............ Expression result: ' || l_eval_result); -- (new log line)

                      l_applied_rule_json := '{' || '"region":"' || REPLACE(region_rec.region_name,'"','\"') || '", "condition":"' || REPLACE(cond_rec.cond_name,'"','\"') || '", "stay_date":"' || TO_CHAR(v_stay_date,'YYYY-MM-DD') || '", "filters":{' || '"stay_window":"' || TO_CHAR(region_rec.stay_from,'YYYY-MM-DD') || ' to ' || TO_CHAR(region_rec.stay_to,'YYYY-MM-DD') || '"' || ', "lead_time":' || l_lead_time_json || CASE WHEN region_rec.days_of_week IS NOT NULL THEN ', "days_of_week":' || REPLACE(region_rec.days_of_week,'"','\"') ELSE '' END || CASE WHEN region_rec.minimum_rate IS NOT NULL THEN ', "minimum_rate":' || TO_CHAR(region_rec.minimum_rate) ELSE '' END || '}' || ', "occupancy":' || CASE WHEN cond_rec.occ_attr IS NOT NULL THEN '{"attr":"' || REPLACE(cond_rec.occ_attr,'#','') || '", "actual":' || NVL(TO_CHAR(l_actual_occ_val),'null') || ', "operator":"' || cond_rec.occ_op || '", "threshold":' || TO_CHAR(cond_rec.occ_val) || ', "failed":' || CASE WHEN l_occ_failed THEN 'true' ELSE 'false' END || '}' ELSE 'null' END || ', "property_ranking":' || CASE WHEN cond_rec.pr_type IS NOT NULL THEN '{"attr":"' || NVL(l_pr_attr_id,'') || '", "actual":' || NVL(TO_CHAR(l_actual_pr_val),'null') || ', "operator":"' || cond_rec.pr_op || '", "threshold":' || TO_CHAR(cond_rec.pr_val) || ', "failed":' || CASE WHEN l_pr_failed THEN 'true' ELSE 'false' END || '}' ELSE 'null' END || ', "event_score":' || CASE WHEN cond_rec.es_val IS NOT NULL THEN '{"actual":' || NVL(TO_CHAR(l_actual_event_score),'null') || ', "operator":"' || cond_rec.es_op || '", "threshold":' || TO_CHAR(cond_rec.es_val) || ', "failed":' || CASE WHEN l_ev_failed THEN 'true' ELSE 'false' END || '}' ELSE 'null' END || ', "expression":"' || REPLACE(cond_rec.expr,'"','\"') || '", "expression_values":' || l_attr_json || ', "evaluated_outcome":' || NVL(TO_CHAR(l_expr_outcome),'null');

                      IF region_rec.minimum_rate IS NOT NULL AND l_eval_result < region_rec.minimum_rate THEN
                        l_applied_rule_json := l_applied_rule_json || ', "note":"min_rate_applied"';
                        l_eval_result := region_rec.minimum_rate;
                        log_debug('............ Applying minimum rate: ' || l_eval_result); -- (new log line)
                      END IF;

                      l_applied_rule_json := l_applied_rule_json || ', "result_type":"numeric", "result":' || TO_CHAR(l_eval_result) || '}';

                      PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), TO_CHAR(l_eval_result), l_applied_rule_json));
                      log_debug('... PIPED ROW (numeric) for date ' || TO_CHAR(v_stay_date, 'YYYY-MM-DD')); -- (new log line)
                    END IF;

                    v_any_rule_matched_for_date := TRUE;
                    GOTO end_date_processing;
                  ELSE
                    -- [This section builds l_failed_cond_json, which is good]
                    log_debug('......... Condition NOT MET.'); -- (new log line)
                    -- ... (your existing code for l_failed_cond_json)
                    l_raw_expr := cond_rec.expr; l_eval_copy := cond_rec.expr; l_attr_json := '{'; l_attr_counter := 0; l_pos := 1;
                    LOOP l_attr_in_expr := REGEXP_SUBSTR(cond_rec.expr, '#[A-F0-9]+#', 1, l_pos); EXIT WHEN l_attr_in_expr IS NULL; l_current_id := REGEXP_REPLACE(l_attr_in_expr, '^#|#$', ''); l_attr_val := TO_CHAR(get_value_for_date(l_staged_data(l_current_id), v_stay_date)); l_eval_copy := REPLACE(l_eval_copy, '#' || l_current_id || '#', NVL(l_attr_val, '0')); IF l_attr_counter > 0 THEN l_attr_json := l_attr_json || ','; END IF; l_attr_json := l_attr_json || '"' || l_current_id || '":' || NVL(l_attr_val, 'null'); l_pos := l_pos + 1; l_attr_counter := l_attr_counter + 1; END LOOP;
                    l_attr_json := l_attr_json || '}';
                    BEGIN
                      -- Only evaluate if NOT free text expression
                      IF NOT REGEXP_LIKE(cond_rec.expr, '^~.*~$') THEN
                        l_eval_copy := REGEXP_REPLACE(l_eval_copy, '(AVERAGE|SUM|COUNT|MAX|MIN)\s*\((.*?)\)', 'ALGO_EVALUATOR_PKG.GENERIC_MATH_EVAL(''\1'', ''\2'')', 1, 0, 'i');
                        EXECUTE IMMEDIATE 'SELECT ' || l_eval_copy || ' FROM DUAL' INTO l_expr_outcome;
                      ELSE
                        -- Free text expressions don't have numeric outcomes
                        l_expr_outcome := NULL;
                      END IF;
                    EXCEPTION
                      WHEN OTHERS THEN
                        l_expr_outcome := NULL;
                    END;
                    l_failed_cond_json := '{' || '"region":"' || REPLACE(region_rec.region_name,'"','\"') || '", "condition":"' || REPLACE(cond_rec.cond_name,'"','\"') || '", "stay_date":"' || TO_CHAR(v_stay_date,'YYYY-MM-DD') || '", "filters":{' || '"stay_window":"' || TO_CHAR(region_rec.stay_from,'YYYY-MM-DD') || ' to ' || TO_CHAR(region_rec.stay_to,'YYYY-MM-DD') || '"' || ', "lead_time":' || l_lead_time_json || CASE WHEN region_rec.days_of_week IS NOT NULL THEN ', "days_of_week":' || REPLACE(region_rec.days_of_week,'"','\"') ELSE '' END || CASE WHEN region_rec.minimum_rate IS NOT NULL THEN ', "minimum_rate":' || TO_CHAR(region_rec.minimum_rate) ELSE '' END || '}' || ', "occupancy":' || CASE WHEN cond_rec.occ_attr IS NOT NULL THEN '{"attr":"' || REPLACE(cond_rec.occ_attr,'#','') || '", "actual":' || NVL(TO_CHAR(l_actual_occ_val),'null') || ', "operator":"' || cond_rec.occ_op || '", "threshold":' || TO_CHAR(cond_rec.occ_val) || ', "failed":' || CASE WHEN l_occ_failed THEN 'true' ELSE 'false' END || '}' ELSE 'null' END || ', "property_ranking":' || CASE WHEN cond_rec.pr_type IS NOT NULL THEN '{"attr":"' || NVL(l_pr_attr_id,'') || '", "actual":' || NVL(TO_CHAR(l_actual_pr_val),'null') || ', "operator":"' || cond_rec.pr_op || '", "threshold":' || TO_CHAR(cond_rec.pr_val) || ', "failed":' || CASE WHEN l_pr_failed THEN 'true' ELSE 'false' END || '}' ELSE 'null' END || ', "event_score":' || CASE WHEN cond_rec.es_val IS NOT NULL THEN '{"actual":' || NVL(TO_CHAR(l_actual_event_score),'null') || ', "operator":"' || cond_rec.es_op || '", "threshold":' || TO_CHAR(cond_rec.es_val) || ', "failed":' || CASE WHEN l_ev_failed THEN 'true' ELSE 'false' END || '}' ELSE 'null' END || ', "expression":"' || REPLACE(cond_rec.expr,'"','\"') || '", "expression_values":' || l_attr_json || ', "evaluated_outcome":' || NVL(TO_CHAR(l_expr_outcome),'null') || ', "result":null' || ', "note":"condition_not_met"' || '}';
                    IF l_failure_details_json IS NULL THEN l_failure_details_json := '[' || l_failed_cond_json; ELSE l_failure_details_json := l_failure_details_json || ',' || l_failed_cond_json; END IF;
                  END IF;
                END;
              END LOOP;
            ELSE
              -- [This section builds l_full_filter_fail_json, which is good]
              DECLARE
                l_full_filter_fail_json CLOB;
              BEGIN
                l_full_filter_fail_json := '{'
                  || '"region":"' || REPLACE(region_rec.region_name,'"','\"')
                  || '", "condition":null'
                  || ', "stay_date":"' || TO_CHAR(v_stay_date,'YYYY-MM-DD')
                  || '", "note":"filter_not_met"'
                  || ', "failed_filter":' || l_filter_failure_json
                  || '}';
                IF l_failure_details_json IS NULL THEN l_failure_details_json := '[' || l_full_filter_fail_json; ELSE l_failure_details_json := l_failure_details_json || ',' || l_full_filter_fail_json; END IF;
              END;
            END IF;
          END;
        END LOOP;

        <<end_date_processing>>
        IF NOT v_any_rule_matched_for_date THEN
          log_debug('... No rule matched for ' || TO_CHAR(v_stay_date, 'YYYY-MM-DD') || '. Piping failure JSON.'); -- (new log line)
          IF l_failure_details_json IS NOT NULL THEN
            l_failure_details_json := l_failure_details_json || ']';
            PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), NULL, l_failure_details_json));
          ELSE
            PIPE ROW(t_result_rec_obj(l_algo_name, v_stay_date, TO_CHAR(v_stay_date, 'Dy'), NULL, '[{"note":"No Applicable Rules or Filters Found","stay_date":"' || TO_CHAR(v_stay_date,'YYYY-MM-DD') || '"}]'));
          END IF;
        END IF;

      <<next_date>>
      NULL;
      END;
    END LOOP;

    log_debug('EVALUATE complete. Exiting function.'); -- (new log line)
    RETURN;
  EXCEPTION
    WHEN OTHERS THEN
      log_debug('EVALUATE FATAL ERROR: ' || SQLERRM || ' - BACKTRACE: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE); -- (new log line)
      PIPE ROW(t_result_rec_obj(l_algo_name, NULL, NULL, NULL, 'FATAL ERROR: ' || SQLERRM || ': ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE));
      RETURN;
  END EVALUATE;

END ALGO_EVALUATOR_PKG;
/
create or replace PACKAGE BODY app_user_ctx IS
  g_user_id UR_USERS.USER_ID%TYPE;
  PROCEDURE set_current_user_id(p_user_id IN UR_USERS.USER_ID%TYPE) IS
  BEGIN
    g_user_id := p_user_id;
  END;
  PROCEDURE clear_current_user_id IS
  BEGIN
    g_user_id := NULL;
  END;
  FUNCTION get_current_user_id RETURN UR_USERS.USER_ID%TYPE IS
  BEGIN
    RETURN g_user_id;
  END;
END app_user_ctx;
/
create or replace PACKAGE BODY Graph_SQL AS

  -- Type to hold column info
  TYPE t_colrec IS RECORD (
    col_name    VARCHAR2(30),
    data_type   VARCHAR2(30),
    nullable    VARCHAR2(1),   -- 'Y' or 'N'
    data_length NUMBER,
    data_precision NUMBER,
    data_scale  NUMBER,
    is_pk       BOOLEAN,
    default_val VARCHAR2(4000)
  );
  TYPE t_colrec_tab IS TABLE OF t_colrec INDEX BY PLS_INTEGER;

  -- Debug utility
  PROCEDURE dbg(p_msg VARCHAR2, p_debug_flag VARCHAR2) IS
  BEGIN
    IF p_debug_flag = 'Y' THEN
      BEGIN
        APEX_DEBUG.MESSAGE(p_msg);
        
      EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.put_line(p_msg);
      END;
    END IF;
  END;

  -- Get table metadata
  FUNCTION get_table_columns(p_table VARCHAR2) RETURN t_colrec_tab IS
    cols t_colrec_tab;
    idx  PLS_INTEGER := 0;
    TYPE t_varchar2_tab IS TABLE OF VARCHAR2(30);
    pk_cols t_varchar2_tab;
  BEGIN
    -- Fetch PKs
    SELECT cols.column_name
    BULK COLLECT INTO pk_cols
    FROM user_constraints cons
    JOIN user_cons_columns cols
      ON cons.constraint_name = cols.constraint_name
    WHERE cons.constraint_type = 'P'
      AND cons.table_name = UPPER(p_table);

    -- Fetch all columns
    FOR r IN (
      SELECT column_name, data_type, nullable,
             data_length, data_precision, data_scale, data_default
      FROM user_tab_columns
      WHERE table_name = UPPER(p_table)
      ORDER BY column_id
    ) LOOP
      idx := idx + 1;
      cols(idx).col_name := r.column_name;
      cols(idx).data_type := r.data_type;
      cols(idx).nullable := r.nullable;
      cols(idx).data_length := r.data_length;
      cols(idx).data_precision := r.data_precision;
      cols(idx).data_scale := r.data_scale;
      cols(idx).is_pk := (r.column_name MEMBER OF pk_cols);
      cols(idx).default_val := r.data_default;
    END LOOP;

    RETURN cols;
  END;

  -- Sample value helper
  FUNCTION sample_value(p_col t_colrec) RETURN VARCHAR2 IS
  BEGIN
    IF p_col.is_pk THEN
      IF UPPER(p_col.data_type) = 'RAW' THEN
        RETURN LOWER(RAWTOHEX(SYS_GUID()));
      ELSE
        RETURN 'PK_VALUE';
      END IF;
    END IF;

    CASE UPPER(p_col.data_type)
      WHEN 'NUMBER' THEN RETURN '123';
      WHEN 'DATE' THEN RETURN TO_CHAR(SYSDATE, 'YYYY-MM-DD');
      WHEN 'TIMESTAMP(6)' THEN RETURN TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD"T"HH24:MI:SS');
      WHEN 'RAW' THEN RETURN LOWER(RAWTOHEX(SYS_GUID()));
      ELSE RETURN 'SampleText';
    END CASE;
  END;

  -- Main procedure
  PROCEDURE proc_crud_json(
    p_mode      IN VARCHAR2,
    p_table     IN VARCHAR2,
    p_payload   IN CLOB,
    p_debug     IN VARCHAR2 DEFAULT 'N',
    p_status    OUT VARCHAR2,
    p_message   OUT CLOB,
    p_icon out varchar2,
    p_title out varchar2
  ) IS
    l_cols t_colrec_tab;
  BEGIN
    dbg('Start proc_crud_json, mode='||p_mode, p_debug);

    ------------------------------------------------------------------
    -- F = FETCH METADATA
    ------------------------------------------------------------------
    IF UPPER(p_mode) = 'F' THEN
      l_cols := get_table_columns(p_table);
      IF l_cols.COUNT = 0 THEN
        p_status := 'E';
        p_message := 'Table "'||p_table||'" does not exist or has no columns';
        RETURN;
      END IF;
    
      -- Build JSON metadata
      DECLARE
        l_json_response JSON_OBJECT_T := JSON_OBJECT_T();
        l_fields       JSON_ARRAY_T := JSON_ARRAY_T();
        l_mandatories  JSON_ARRAY_T := JSON_ARRAY_T();
        l_sample_c     JSON_OBJECT_T := JSON_OBJECT_T();
        l_sample_u     JSON_OBJECT_T := JSON_OBJECT_T();
        l_sample_d     JSON_OBJECT_T := JSON_OBJECT_T();
      BEGIN
        FOR i IN 1 .. l_cols.COUNT LOOP
          DECLARE
            l_field_obj JSON_OBJECT_T := JSON_OBJECT_T();
          BEGIN
          
            l_field_obj.put('column_name', l_cols(i).col_name);
            l_field_obj.put('data_type', l_cols(i).data_type);
            l_field_obj.put('nullable', l_cols(i).nullable);
            l_field_obj.put('is_primary_key', CASE WHEN l_cols(i).is_pk THEN 'Y' ELSE 'N' END);
            l_field_obj.put('default_value', l_cols(i).default_val);
            l_field_obj.put('sample_value', sample_value(l_cols(i)));
            l_fields.append(l_field_obj);

            IF l_cols(i).nullable = 'N' OR l_cols(i).is_pk THEN
              l_mandatories.append(l_cols(i).col_name);
              l_sample_c.put(l_cols(i).col_name, sample_value(l_cols(i)));
            END IF;

            IF l_cols(i).is_pk THEN
              l_sample_u.put(l_cols(i).col_name, sample_value(l_cols(i)));
              l_sample_d.put(l_cols(i).col_name, sample_value(l_cols(i)));
            ELSE
              IF l_cols(i).nullable = 'Y' THEN
                l_sample_u.put(l_cols(i).col_name, sample_value(l_cols(i)));
              END IF;
            END IF;
          END;
        END LOOP;

        l_json_response.put('fields', l_fields);
        l_json_response.put('mandatory_columns', l_mandatories);
        l_json_response.put('sample_create_payload', l_sample_c);
        l_json_response.put('sample_update_payload', l_sample_u);
        l_json_response.put('sample_delete_payload', l_sample_d);

        p_status := 'S';
        p_message := l_json_response.to_string;
      END;


------------------------------------------------------------------
-- C = CREATE / INSERT (dynamic, JSON-driven)
------------------------------------------------------------------
ELSIF UPPER(p_mode) = 'C' THEN
  dbg('Entering CREATE mode for table '||p_table, p_debug);

  DECLARE
    l_sql         VARCHAR2(32767);
    l_insert_cols VARCHAR2(32767) := '';
    l_insert_vals VARCHAR2(32767) := '';
    l_val         VARCHAR2(4000);
    l_clob         clob;
    c             INTEGER;
    rc            INTEGER;
    l_any_found   BOOLEAN := FALSE;
    l_new_id      RAW(16);  -- Generate SYS_GUID manually
  BEGIN
    -- Generate new ID
    l_new_id := SYS_GUID();

    -- Load column metadata for the target table
    l_cols := get_table_columns(p_table);
    IF l_cols.COUNT = 0 THEN
      p_status  := 'E';
      p_message := 'Table "'||p_table||'" does not exist or has no columns';
      RETURN;
    END IF;
    -- Build column and bind lists
    FOR i IN 1 .. l_cols.COUNT LOOP
    
      IF UPPER(l_cols(i).col_name) = 'ID' THEN
         l_val := (l_new_id);  -- assign SYS_GUID for ID
      ELSE
            l_val :=  json_query( p_payload , '$."'||l_cols(i).col_name||'"' returning clob)  ;   -- Need to add col type if clob type  ---------------------------------------------
       -- l_val := json_value(p_payload, '$."'||l_cols(i).col_name||'"');
      END IF;
      IF l_val IS NOT NULL THEN
        l_any_found := TRUE;
        l_insert_cols := l_insert_cols || l_cols(i).col_name || ',';
        l_insert_vals := l_insert_vals || ':' || l_cols(i).col_name || ',';
      END IF;
    END LOOP;
    IF NOT l_any_found THEN
      p_status  := 'E';
      p_message := 'No matching columns found in payload for insert';
      RETURN;
    END IF;
    l_insert_cols := RTRIM(l_insert_cols, ',');
    l_insert_vals := RTRIM(l_insert_vals, ',');
    -- Compose SQL
    l_sql := 'INSERT INTO ' || p_table || ' (' || l_insert_cols || ') ' ||
             'VALUES (' || l_insert_vals || ')';
    dbg('Generated INSERT SQL: '||l_sql, p_debug);
    -- Parse and bind
    c := DBMS_SQL.open_cursor;
    DBMS_SQL.parse(c, l_sql, DBMS_SQL.native);
    -- Bind values
    FOR i IN 1 .. l_cols.COUNT LOOP
      IF UPPER(l_cols(i).col_name) = 'ID' THEN
        DBMS_SQL.bind_variable(c, ':'||l_cols(i).col_name, l_new_id);
      ELSE
       -- l_val := json_query( p_payload , '$."'||l_cols(i).col_name||'"' returning clob) ;
        if upper(l_cols(i).data_type) = 'CLOB' then
         l_clob := json_query( p_payload , '$."'||l_cols(i).col_name||'"' returning clob) ;
        else
            l_val := json_value(p_payload, '$."'||l_cols(i).col_name||'"');
        end if;

       -- l_val := json_value(p_payload, '$."'||l_cols(i).col_name||'"');
        IF l_val IS NOT NULL OR l_clob IS NOT NULL THEN        
         -- DBMS_SQL.bind_variable(c, ':'||l_cols(i).col_name, l_val); 
         if upper(l_cols(i).data_type) = 'CLOB' then
            dbms_sql.bind_variable(c, ':'||l_cols(i).col_name, l_clob);  -- l_val must be CLOB
        else
            dbms_sql.bind_variable(c, ':'||l_cols(i).col_name, to_char(l_val));
        end if;
        END IF;
      END IF;
      
    END LOOP;
    rc := DBMS_SQL.execute(c);
    DBMS_SQL.close_cursor(c);
    p_status  := 'S';
    p_message := 'Inserted '||rc||' row(s). New ID =' || RAWTOHEX(l_new_id) || '';
  EXCEPTION
    WHEN OTHERS THEN
      IF DBMS_SQL.is_open(c) THEN
        DBMS_SQL.close_cursor(c);
      END IF;
      p_status  := 'E';
      p_message := 'Insert failed: '||SQLERRM;
      dbg('Insert failed: '||SQLERRM, p_debug);
  END;



    ------------------------------------------------------------------
    -- U = UPDATE
    ------------------------------------------------------------------
ELSIF UPPER(p_mode) = 'U' THEN
   dbg('--- UPDATE MODE START ---', p_debug);

   DECLARE
     l_sql       VARCHAR2(32767);
     l_set_list  VARCHAR2(32767);
     l_pk_col    VARCHAR2(128);
     c           INTEGER;
     l_rows      INTEGER;
     l_val       VARCHAR2(4000);
     l_first     BOOLEAN := TRUE;
   BEGIN
     -- 1. Get primary key column
     SELECT ucc.column_name
       INTO l_pk_col
       FROM user_constraints uc
       JOIN user_cons_columns ucc 
         ON uc.constraint_name = ucc.constraint_name
      WHERE uc.table_name = UPPER(p_table)
        AND uc.constraint_type = 'P'
        AND ROWNUM = 1;

     dbg('Primary Key Column=' || l_pk_col, p_debug);

     -- 2. Build SET clause dynamically in PL/SQL
     l_set_list := '';
     FOR rec IN (
       SELECT column_name
       FROM user_tab_columns
       WHERE table_name = UPPER(p_table)
         AND column_name <> l_pk_col
       ORDER BY column_id
     )
     LOOP
       l_val := json_value(p_payload, '$."'||rec.column_name||'"' returning varchar2(4000));
       IF l_val IS NOT NULL THEN
         IF l_first THEN
           l_set_list := '"'||rec.column_name||'" = :'||rec.column_name;
           l_first := FALSE;
         ELSE
           l_set_list := l_set_list || ', "'||rec.column_name||'" = :'||rec.column_name;
         END IF;
       END IF;
     END LOOP;

     IF l_set_list IS NULL THEN
       p_status  := 'E';
       p_message := 'No updatable columns found in JSON payload.';
       RETURN;
     END IF;

     -- 3. Final UPDATE statement
     l_sql := 'UPDATE ' || p_table || ' SET ' || l_set_list ||
              ' WHERE "' || l_pk_col || '" = :'||l_pk_col;

     dbg('Final Update SQL = ' || l_sql, p_debug);

     -- 4. Parse and bind
     c := dbms_sql.open_cursor;
     dbms_sql.parse(c, l_sql, dbms_sql.native);

     -- Bind non-PK values
     FOR rec IN (
       SELECT column_name
       FROM user_tab_columns
       WHERE table_name = UPPER(p_table)
         AND column_name <> l_pk_col
     )
     LOOP
       l_val := json_value(p_payload, '$."'||rec.column_name||'"' returning varchar2(4000));
       IF l_val IS NOT NULL THEN
         dbms_sql.bind_variable(c, ':'||rec.column_name, l_val);
         dbg('Binding '||rec.column_name||'='||l_val, p_debug);
       END IF;
     END LOOP;

     -- Bind PK
     l_val := json_value(p_payload, '$."'||l_pk_col||'"' returning varchar2(4000));
     IF l_val IS NOT NULL THEN
       dbms_sql.bind_variable(c, ':'||l_pk_col, l_val);
       dbg('Binding PK '||l_pk_col||'='||l_val, p_debug);
     END IF;

     -- 5. Execute
     l_rows := dbms_sql.execute(c);
     dbms_sql.close_cursor(c);

     p_status  := 'S';
     p_message := 'Updated '||l_rows||' hotel successfully.';
    p_icon  := 'success';
    p_title := 'Success!';

   


     dbg('--- UPDATE MODE END ---', p_debug);
   EXCEPTION
     WHEN OTHERS THEN
       IF dbms_sql.is_open(c) THEN
         dbms_sql.close_cursor(c);
       END IF;
       p_status  := 'E';
       p_message := 'Update failed: '||SQLERRM;
        p_icon  := 'error';
    p_title := 'Update Failed';
       dbg('Update failed: '||SQLERRM, p_debug);
   END;




------------------------------------------------------------------
-- D = DELETE
------------------------------------------------------------------
ELSIF p_mode = 'D' THEN
    -- Delete record(s) based on primary key(s)
    DECLARE
        l_pk_col VARCHAR2(200);
        l_pk_val VARCHAR2(4000);
        l_sql    VARCHAR2(4000);
    BEGIN
        -- Fetch the primary key column dynamically
        SELECT cols.column_name
        INTO   l_pk_col
        FROM   all_constraints cons
        JOIN   all_cons_columns cols
        ON     cons.constraint_name = cols.constraint_name
        AND    cons.owner = cols.owner
        WHERE  cons.constraint_type = 'P'
        AND    cons.table_name = UPPER(p_table)
        AND    ROWNUM = 1;

        -- Extract PK value from JSON
        l_pk_val := json_value(p_payload, '$."' || l_pk_col || '"');

        IF l_pk_val IS NULL THEN
            p_status  := 'E';
            p_message := 'Primary key '||l_pk_col||' not found in payload';
            RETURN;
        END IF;

        -- Build DELETE SQL
        l_sql := 'DELETE FROM ' || p_table || ' WHERE ' || l_pk_col || ' = :pk';

        IF p_debug = 'Y' THEN
            dbms_output.put_line('DELETE SQL: ' || l_sql);
            dbms_output.put_line('PK VALUE : ' || l_pk_val);
        END IF;

        -- Execute delete
        EXECUTE IMMEDIATE l_sql USING l_pk_val;

        p_status  := 'S';
        p_message := 'Delete successful.';

    EXCEPTION
        WHEN OTHERS THEN
            p_status  := 'E';
            p_message := 'Delete failed: ' || SQLERRM;
    END;

    ------------------------------------------------------------------
    -- Other modes not implemented yet
    ------------------------------------------------------------------
    ELSE
      p_status := 'E';
      p_message := 'Mode '||p_mode||' not implemented';
    END IF;

  END proc_crud_json;

END Graph_SQL;
/
create or replace PACKAGE BODY pkg_generic_crud AS

  -- Type to hold column info
  TYPE t_colrec IS RECORD (
    col_name    VARCHAR2(30),
    data_type   VARCHAR2(30),
    nullable    VARCHAR2(1),   -- 'Y' or 'N'
    data_length NUMBER,
    data_precision NUMBER,
    data_scale  NUMBER,
    is_pk       BOOLEAN,
    default_val VARCHAR2(4000)
  );
  TYPE t_colrec_tab IS TABLE OF t_colrec INDEX BY PLS_INTEGER;

  -- Debug utility
  PROCEDURE dbg(p_msg VARCHAR2, p_debug_flag VARCHAR2) IS
  BEGIN
    IF p_debug_flag = 'Y' THEN
      BEGIN
        APEX_DEBUG.MESSAGE(p_msg);
      EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.put_line(p_msg);
      END;
    END IF;
  END;

  -- Get table metadata
  FUNCTION get_table_columns(p_table VARCHAR2) RETURN t_colrec_tab IS
    cols t_colrec_tab;
    idx  PLS_INTEGER := 0;
    TYPE t_varchar2_tab IS TABLE OF VARCHAR2(30);
    pk_cols t_varchar2_tab;
  BEGIN
    -- Fetch PKs
    SELECT cols.column_name
    BULK COLLECT INTO pk_cols
    FROM user_constraints cons
    JOIN user_cons_columns cols
      ON cons.constraint_name = cols.constraint_name
    WHERE cons.constraint_type = 'P'
      AND cons.table_name = UPPER(p_table);

    -- Fetch all columns
    FOR r IN (
      SELECT column_name, data_type, nullable,
             data_length, data_precision, data_scale, data_default
      FROM user_tab_columns
      WHERE table_name = UPPER(p_table)
      ORDER BY column_id
    ) LOOP
      idx := idx + 1;
      cols(idx).col_name := r.column_name;
      cols(idx).data_type := r.data_type;
      cols(idx).nullable := r.nullable;
      cols(idx).data_length := r.data_length;
      cols(idx).data_precision := r.data_precision;
      cols(idx).data_scale := r.data_scale;
      cols(idx).is_pk := (r.column_name MEMBER OF pk_cols);
      cols(idx).default_val := r.data_default;
    END LOOP;

    RETURN cols;
  END;

  -- Sample value helper
  FUNCTION sample_value(p_col t_colrec) RETURN VARCHAR2 IS
  BEGIN
    IF p_col.is_pk THEN
      IF UPPER(p_col.data_type) = 'RAW' THEN
        RETURN LOWER(RAWTOHEX(SYS_GUID()));
      ELSE
        RETURN 'PK_VALUE';
      END IF;
    END IF;

    CASE UPPER(p_col.data_type)
      WHEN 'NUMBER' THEN RETURN '123';
      WHEN 'DATE' THEN RETURN TO_CHAR(SYSDATE, 'YYYY-MM-DD');
      WHEN 'TIMESTAMP(6)' THEN RETURN TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD"T"HH24:MI:SS');
      WHEN 'RAW' THEN RETURN LOWER(RAWTOHEX(SYS_GUID()));
      ELSE RETURN 'SampleText';
    END CASE;
  END;

  -- Main procedure
  PROCEDURE proc_crud_json(
    p_mode      IN VARCHAR2,
    p_table     IN VARCHAR2,
    p_payload   IN CLOB,
    p_debug     IN VARCHAR2 DEFAULT 'N',
    p_status    OUT VARCHAR2,
    p_message   OUT CLOB,
    p_icon out varchar2,
    p_title out varchar2
  ) IS
    l_cols t_colrec_tab;
  BEGIN
    dbg('Start proc_crud_json, mode='||p_mode, p_debug);

    ------------------------------------------------------------------
    -- F = FETCH METADATA
    ------------------------------------------------------------------
    IF UPPER(p_mode) = 'F' THEN
      l_cols := get_table_columns(p_table);
      IF l_cols.COUNT = 0 THEN
        p_status := 'E';
        p_message := 'Table "'||p_table||'" does not exist or has no columns';
        RETURN;
      END IF;

      -- Build JSON metadata
      DECLARE
        l_json_response JSON_OBJECT_T := JSON_OBJECT_T();
        l_fields       JSON_ARRAY_T := JSON_ARRAY_T();
        l_mandatories  JSON_ARRAY_T := JSON_ARRAY_T();
        l_sample_c     JSON_OBJECT_T := JSON_OBJECT_T();
        l_sample_u     JSON_OBJECT_T := JSON_OBJECT_T();
        l_sample_d     JSON_OBJECT_T := JSON_OBJECT_T();
      BEGIN
        FOR i IN 1 .. l_cols.COUNT LOOP
          DECLARE
            l_field_obj JSON_OBJECT_T := JSON_OBJECT_T();
          BEGIN
            l_field_obj.put('column_name', l_cols(i).col_name);
            l_field_obj.put('data_type', l_cols(i).data_type);
            l_field_obj.put('nullable', l_cols(i).nullable);
            l_field_obj.put('is_primary_key', CASE WHEN l_cols(i).is_pk THEN 'Y' ELSE 'N' END);
            l_field_obj.put('default_value', l_cols(i).default_val);
            l_field_obj.put('sample_value', sample_value(l_cols(i)));
            l_fields.append(l_field_obj);

            IF l_cols(i).nullable = 'N' OR l_cols(i).is_pk THEN
              l_mandatories.append(l_cols(i).col_name);
              l_sample_c.put(l_cols(i).col_name, sample_value(l_cols(i)));
            END IF;

            IF l_cols(i).is_pk THEN
              l_sample_u.put(l_cols(i).col_name, sample_value(l_cols(i)));
              l_sample_d.put(l_cols(i).col_name, sample_value(l_cols(i)));
            ELSE
              IF l_cols(i).nullable = 'Y' THEN
                l_sample_u.put(l_cols(i).col_name, sample_value(l_cols(i)));
              END IF;
            END IF;
          END;
        END LOOP;

        l_json_response.put('fields', l_fields);
        l_json_response.put('mandatory_columns', l_mandatories);
        l_json_response.put('sample_create_payload', l_sample_c);
        l_json_response.put('sample_update_payload', l_sample_u);
        l_json_response.put('sample_delete_payload', l_sample_d);

        p_status := 'S';
        p_message := l_json_response.to_string;
      END;


------------------------------------------------------------------
-- C = CREATE / INSERT (dynamic, JSON-driven)
------------------------------------------------------------------
ELSIF UPPER(p_mode) = 'C' THEN
  dbg('Entering CREATE mode for table '||p_table, p_debug);

  DECLARE
    l_sql         VARCHAR2(32767);
    l_insert_cols VARCHAR2(32767) := '';
    l_insert_vals VARCHAR2(32767) := '';
    l_val         VARCHAR2(4000);
    c             INTEGER;
    rc            INTEGER;
    l_any_found   BOOLEAN := FALSE;
  BEGIN
    -- Load column metadata for the target table
    l_cols := get_table_columns(p_table);
    IF l_cols.COUNT = 0 THEN
      p_status  := 'E';
      p_message := 'Table "'||p_table||'" does not exist or has no columns';
      RETURN;
    END IF;

    -- Build column and bind placeholder lists from JSON
    FOR i IN 1 .. l_cols.COUNT LOOP
      -- Pull value from JSON; non-existent key or JSON null -> NULL
      l_val := json_value(p_payload, '$."'||l_cols(i).col_name||'"');

      IF p_debug = 'Y' THEN
        dbg('JSON check for column '||l_cols(i).col_name||' -> '||
            CASE WHEN l_val IS NULL THEN 'NULL/absent' ELSE l_val END, p_debug);
      END IF;

      -- Only include columns that have a non-NULL value in payload
      IF l_val IS NOT NULL THEN
        l_any_found := TRUE;
        -- Note: do not quote column names here; they are from data dictionary and uppercase-safe
        l_insert_cols := l_insert_cols || l_cols(i).col_name || ',';
        l_insert_vals := l_insert_vals || ':' || l_cols(i).col_name || ',';
      END IF;
    END LOOP;

    IF NOT l_any_found THEN
      p_status  := 'E';
      p_message := 'No matching columns found in payload for insert';
      RETURN;
    END IF;

    -- Trim trailing commas
    l_insert_cols := RTRIM(l_insert_cols, ',');
    l_insert_vals := RTRIM(l_insert_vals, ',');

    -- Compose SQL
    l_sql := 'INSERT INTO ' || p_table || ' (' || l_insert_cols || ') VALUES (' || l_insert_vals || ')';
    dbg('Generated INSERT SQL: '||l_sql, p_debug);

    -- Parse and bind
    c := DBMS_SQL.open_cursor;
    DBMS_SQL.parse(c, l_sql, DBMS_SQL.native);

    -- Bind only the columns we actually included (non-NULL in payload)
    FOR i IN 1 .. l_cols.COUNT LOOP
      l_val := json_value(p_payload, '$."'||l_cols(i).col_name||'"');
      IF l_val IS NOT NULL THEN
        DBMS_SQL.bind_variable(c, ':'||l_cols(i).col_name, l_val);
        dbg('Binding '||l_cols(i).col_name||'='||l_val, p_debug);
      END IF;
    END LOOP;

    rc := DBMS_SQL.execute(c);
    DBMS_SQL.close_cursor(c);

    p_status  := 'S';
    p_message := 'Inserted '||rc||' row(s)';

  EXCEPTION
    WHEN OTHERS THEN
      IF DBMS_SQL.is_open(c) THEN
        DBMS_SQL.close_cursor(c);
      END IF;
      p_status  := 'E';
      p_message := 'Insert failed: '||SQLERRM;
      dbg('Insert failed: '||SQLERRM, p_debug);
  END;


    ------------------------------------------------------------------
    -- U = UPDATE
    ------------------------------------------------------------------
ELSIF UPPER(p_mode) = 'U' THEN
   dbg('--- UPDATE MODE START ---', p_debug);

   DECLARE
     l_sql       VARCHAR2(32767);
     l_set_list  VARCHAR2(32767);
     l_pk_col    VARCHAR2(128);
     c           INTEGER;
     l_rows      INTEGER;
     l_val       VARCHAR2(4000);
     l_first     BOOLEAN := TRUE;
   BEGIN
     -- 1. Get primary key column
     SELECT ucc.column_name
       INTO l_pk_col
       FROM user_constraints uc
       JOIN user_cons_columns ucc 
         ON uc.constraint_name = ucc.constraint_name
      WHERE uc.table_name = UPPER(p_table)
        AND uc.constraint_type = 'P'
        AND ROWNUM = 1;

     dbg('Primary Key Column=' || l_pk_col, p_debug);

     -- 2. Build SET clause dynamically in PL/SQL
     l_set_list := '';
     FOR rec IN (
       SELECT column_name
       FROM user_tab_columns
       WHERE table_name = UPPER(p_table)
         AND column_name <> l_pk_col
       ORDER BY column_id
     )
     LOOP
       l_val := json_value(p_payload, '$."'||rec.column_name||'"' returning varchar2(4000));
       IF l_val IS NOT NULL THEN
         IF l_first THEN
           l_set_list := '"'||rec.column_name||'" = :'||rec.column_name;
           l_first := FALSE;
         ELSE
           l_set_list := l_set_list || ', "'||rec.column_name||'" = :'||rec.column_name;
         END IF;
       END IF;
     END LOOP;

     IF l_set_list IS NULL THEN
       p_status  := 'E';
       p_message := 'No updatable columns found in JSON payload.';
       RETURN;
     END IF;

     -- 3. Final UPDATE statement
     l_sql := 'UPDATE ' || p_table || ' SET ' || l_set_list ||
              ' WHERE "' || l_pk_col || '" = :'||l_pk_col;

     dbg('Final Update SQL = ' || l_sql, p_debug);

     -- 4. Parse and bind
     c := dbms_sql.open_cursor;
     dbms_sql.parse(c, l_sql, dbms_sql.native);

     -- Bind non-PK values
     FOR rec IN (
       SELECT column_name
       FROM user_tab_columns
       WHERE table_name = UPPER(p_table)
         AND column_name <> l_pk_col
     )
     LOOP
       l_val := json_value(p_payload, '$."'||rec.column_name||'"' returning varchar2(4000));
       IF l_val IS NOT NULL THEN
         dbms_sql.bind_variable(c, ':'||rec.column_name, l_val);
         dbg('Binding '||rec.column_name||'='||l_val, p_debug);
       END IF;
     END LOOP;

     -- Bind PK
     l_val := json_value(p_payload, '$."'||l_pk_col||'"' returning varchar2(4000));
     IF l_val IS NOT NULL THEN
       dbms_sql.bind_variable(c, ':'||l_pk_col, l_val);
       dbg('Binding PK '||l_pk_col||'='||l_val, p_debug);
     END IF;

     -- 5. Execute
     l_rows := dbms_sql.execute(c);
     dbms_sql.close_cursor(c);

     p_status  := 'S';
     p_message := 'Updated '||l_rows||' hotel successfully.';
    p_icon  := 'success';
    p_title := 'Success!';

   


     dbg('--- UPDATE MODE END ---', p_debug);
   EXCEPTION
     WHEN OTHERS THEN
       IF dbms_sql.is_open(c) THEN
         dbms_sql.close_cursor(c);
       END IF;
       p_status  := 'E';
       p_message := 'Update failed: '||SQLERRM;
        p_icon  := 'error';
    p_title := 'Update Failed';
       dbg('Update failed: '||SQLERRM, p_debug);
   END;




------------------------------------------------------------------
-- D = DELETE
------------------------------------------------------------------
ELSIF p_mode = 'D' THEN
    -- Delete record(s) based on primary key(s)
    DECLARE
        l_pk_col VARCHAR2(200);
        l_pk_val VARCHAR2(4000);
        l_sql    VARCHAR2(4000);
    BEGIN
        -- Fetch the primary key column dynamically
        SELECT cols.column_name
        INTO   l_pk_col
        FROM   all_constraints cons
        JOIN   all_cons_columns cols
        ON     cons.constraint_name = cols.constraint_name
        AND    cons.owner = cols.owner
        WHERE  cons.constraint_type = 'P'
        AND    cons.table_name = UPPER(p_table)
        AND    ROWNUM = 1;

        -- Extract PK value from JSON
        l_pk_val := json_value(p_payload, '$."' || l_pk_col || '"');

        IF l_pk_val IS NULL THEN
            p_status  := 'E';
            p_message := 'Primary key '||l_pk_col||' not found in payload';
            RETURN;
        END IF;

        -- Build DELETE SQL
        l_sql := 'DELETE FROM ' || p_table || ' WHERE ' || l_pk_col || ' = :pk';

        IF p_debug = 'Y' THEN
            dbms_output.put_line('DELETE SQL: ' || l_sql);
            dbms_output.put_line('PK VALUE : ' || l_pk_val);
        END IF;

        -- Execute delete
        EXECUTE IMMEDIATE l_sql USING l_pk_val;

        p_status  := 'S';
        p_message := 'Delete successful.';

    EXCEPTION
        WHEN OTHERS THEN
            p_status  := 'E';
            p_message := 'Delete failed: ' || SQLERRM;
    END;

    ------------------------------------------------------------------
    -- Other modes not implemented yet
    ------------------------------------------------------------------
    ELSE
      p_status := 'E';
      p_message := 'Mode '||p_mode||' not implemented';
    END IF;

  END proc_crud_json;

END pkg_generic_crud;
/
create or replace PACKAGE BODY ur_users_pkg IS
  -----------------------------------------------------------------------
  -- Internal helper: generate base username (first letter + last, cleaned)
  -----------------------------------------------------------------------
  FUNCTION gen_base_username(p_first IN VARCHAR2, p_last IN VARCHAR2) RETURN VARCHAR2 IS
    l_first VARCHAR2(200);
    l_last  VARCHAR2(200);
    l_raw   VARCHAR2(400);
  BEGIN
    -- copy to locals (can't assign to IN params)
    l_first := NVL(TRIM(p_first), 'x');
    l_last  := NVL(TRIM(p_last), 'user');

    l_raw := LOWER(SUBSTR(l_first,1,1) || l_last);
    RETURN REGEXP_REPLACE(l_raw, '[^a-z0-9]', '');
  END gen_base_username;

  -----------------------------------------------------------------------
  -- Ensure uniqueness: check UR_USERS table and APEX accounts, append digits
  -----------------------------------------------------------------------
  FUNCTION ensure_unique_username(p_base IN VARCHAR2) RETURN VARCHAR2 IS
    l_try        VARCHAR2(255) := p_base;
    l_counter    PLS_INTEGER := 1;
    l_exists     NUMBER;
    l_apex_userid NUMBER;
  BEGIN
    LOOP
      SELECT COUNT(*) INTO l_exists FROM UR_USERS WHERE LOWER(USER_NAME) = LOWER(l_try);

      IF l_exists = 0 THEN
        -- Check APEX repository safely
        BEGIN
          l_apex_userid := APEX_UTIL.GET_USER_ID(l_try);
        EXCEPTION
          WHEN OTHERS THEN
            l_apex_userid := NULL;
        END;
        IF l_apex_userid IS NOT NULL THEN
          l_exists := 1;
        END IF;
      END IF;

      IF l_exists = 0 THEN
        RETURN l_try;
      END IF;

      l_counter := l_counter + 1;
      l_try := p_base || TO_CHAR(l_counter);
      l_exists := 0;
    END LOOP;
  END ensure_unique_username;

  -----------------------------------------------------------------------
  -- create apex user (requires workspace admin privileges)
  -----------------------------------------------------------------------
  PROCEDURE do_create_apex_user(
    p_user_name IN VARCHAR2,
    p_first_name IN VARCHAR2,
    p_last_name  IN VARCHAR2,
    p_email      IN VARCHAR2,
    p_allow_app_building_yn IN VARCHAR2 DEFAULT 'N'
  ) IS
    l_temp_pwd VARCHAR2(100);
  BEGIN
    l_temp_pwd := dbms_random.string('A', 12); -- simple temp pwd
    APEX_UTIL.CREATE_USER(
      p_user_name                    => p_user_name,
      p_first_name                   => p_first_name,
      p_last_name                    => p_last_name,
      p_email_address                => p_email,
      p_web_password                 => l_temp_pwd,
      p_web_password_format          => 'CLEAR_TEXT',
      p_change_password_on_first_use => 'Y',
      p_allow_app_building_yn        => p_allow_app_building_yn
    );
    -- we intentionally do NOT email the temp password
  END do_create_apex_user;

  -----------------------------------------------------------------------
  -- assign application-level roles (APEX_ACL)
  -- p_roles: comma-separated role static IDs (e.g. 'ADMIN,USER')
  -----------------------------------------------------------------------
  PROCEDURE assign_app_roles(
    p_app_id IN NUMBER,
    p_user_name IN VARCHAR2,
    p_roles IN VARCHAR2
  ) IS
    l_app_id NUMBER := NVL(p_app_id, apex_application.g_flow_id);
    l_role_list DBMS_UTILITY.LNAME_ARRAY;
    l_cnt INTEGER := 0;
    l_role VARCHAR2(4000);
    l_pos PLS_INTEGER := 1;
    l_token VARCHAR2(4000);
  BEGIN
    IF p_roles IS NULL THEN
      RETURN;
    END IF;

    -- split comma separated roles (simple loop)
    WHILE l_pos <= LENGTH(p_roles) LOOP
      l_token := TRIM(REGEXP_SUBSTR(p_roles, '[^,]+', 1, l_pos));
      EXIT WHEN l_token IS NULL;
      BEGIN
        APEX_ACL.ADD_USER_ROLE(
          p_application_id => l_app_id,
          p_user_name      => p_user_name,
          p_role_static_id => l_token
        );
      EXCEPTION WHEN OTHERS THEN
        NULL; -- record-level logging could be added
      END;
      l_pos := l_pos + 1;
    END LOOP;
  END assign_app_roles;

  -----------------------------------------------------------------------
  -- send welcome email (no password)
  -----------------------------------------------------------------------
  PROCEDURE do_send_welcome_email(
    p_to       IN VARCHAR2,
    p_username IN VARCHAR2,
    p_first    IN VARCHAR2,
    p_last     IN VARCHAR2
  ) IS
    l_subject VARCHAR2(4000);
    l_body    CLOB;
    l_login_url VARCHAR2(2000) := 'https://gce17f00a19c10b-prod.adb.uk-london-1.oraclecloudapps.com/ords/r/dev/ur/login?session=101555937796515';
  BEGIN
    l_subject := 'Welcome to Our Application';
    l_body := 'Hello ' || NVL(p_first || ' ' || p_last, p_username) || CHR(10) || CHR(10) ||
              'Your account has been created.' || CHR(10) ||
              'Username: ' || p_username || CHR(10) || CHR(10) ||
              'To set your password, please use the application login page and click "Forgot Password" or use the reset flow.' || CHR(10) ||
              'Login here: ' || l_login_url || CHR(10) || CHR(10) ||
              'If you did not expect this email, contact support.';
    APEX_MAIL.SEND(
      p_to   => p_to,
      p_from => 'no-reply@yourdomain.com',
      p_subj => l_subject,
      p_body => l_body
    );
    -- try immediate push (harmless if queue job also handles)
    BEGIN
      APEX_MAIL.PUSH_QUEUE;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;
  EXCEPTION WHEN OTHERS THEN NULL;
  END do_send_welcome_email;

  -----------------------------------------------------------------------
  -- Public: create user full
  -----------------------------------------------------------------------
  FUNCTION create_user_full(
    p_first_name      IN VARCHAR2,
    p_last_name       IN VARCHAR2,
    p_email           IN VARCHAR2,
    p_contact_number  IN NUMBER DEFAULT NULL,
    p_user_type       IN VARCHAR2 DEFAULT 'ENDUSER',
    p_status          IN VARCHAR2 DEFAULT 'ACTIVE',
    p_start_date      IN DATE DEFAULT NULL,
    p_end_date        IN DATE DEFAULT NULL,
    p_login_method    IN VARCHAR2 DEFAULT 'APEX',
    p_app_id          IN NUMBER DEFAULT NULL,
    p_preferred_roles IN VARCHAR2 DEFAULT NULL
  ) RETURN t_result IS
    l_result t_result;
    l_username VARCHAR2(255);
    l_base VARCHAR2(255);
    l_user_id RAW(16);
  BEGIN
    l_result.status := 'ERROR';
    l_result.message := NULL;
    l_result.username := NULL;

    -- generate username & uniqueness
    l_base := gen_base_username(p_first_name, p_last_name);
    l_username := ensure_unique_username(l_base);

    -- insert into UR_USERS table (replaces your automatic DML)
    INSERT INTO UR_USERS (
      USER_ID, FIRST_NAME, LAST_NAME, EMAIL, CONTACT_NUMBER, USER_TYPE, STATUS,
      START_DATE, END_DATE, LOGIN_METHOD, USER_NAME
    )
    VALUES (
      SYS_GUID(), p_first_name, p_last_name, p_email, p_contact_number, p_user_type, p_status,
      p_start_date, p_end_date, p_login_method, l_username
    )
    RETURNING USER_ID INTO l_user_id;

    COMMIT;

    -- Try to create APEX account; if we lack privileges, enqueue for admin
    BEGIN
      do_create_apex_user(l_username, p_first_name, p_last_name, p_email);
      -- assign app roles if any
      IF p_preferred_roles IS NOT NULL THEN
        assign_app_roles(p_app_id, l_username, p_preferred_roles);
      END IF;
      -- send welcome email
      do_send_welcome_email(p_email, l_username, p_first_name, p_last_name);
      l_result.status := 'OK';
      l_result.message := 'User row created and APEX account created; email queued.';
      l_result.username := l_username;
      RETURN l_result;
    EXCEPTION
      WHEN OTHERS THEN
        -- most common reason: not a workspace admin. Enqueue for admin processing.
        enqueue_user_for_admin(
          p_first_name => p_first_name,
          p_last_name  => p_last_name,
          p_email      => p_email,
          p_contact_number => p_contact_number,
          p_user_type => p_user_type,
          p_start_date => p_start_date,
          p_end_date => p_end_date,
          p_login_method => p_login_method,
          p_base_username => l_base,
          p_suggested_username => l_username,
          p_preferred_roles => p_preferred_roles
        );
        l_result.status := 'PENDING';
        l_result.message := 'User row created in UR_USERS; APEX user creation queued for admin. Reason: ' || SQLERRM;
        l_result.username := l_username;
        RETURN l_result;
    END;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      l_result.status := 'ERROR';
      l_result.message := 'Creation failed: ' || SQLERRM;
      RETURN l_result;
  END create_user_full;

  -----------------------------------------------------------------------
  -- Enqueue for admin
  -----------------------------------------------------------------------
  PROCEDURE enqueue_user_for_admin(
    p_first_name IN VARCHAR2,
    p_last_name  IN VARCHAR2,
    p_email      IN VARCHAR2,
    p_contact_number IN NUMBER DEFAULT NULL,
    p_user_type IN VARCHAR2 DEFAULT 'ENDUSER',
    p_start_date IN DATE DEFAULT NULL,
    p_end_date   IN DATE DEFAULT NULL,
    p_login_method IN VARCHAR2 DEFAULT 'APEX',
    p_base_username IN VARCHAR2 DEFAULT NULL,
    p_suggested_username IN VARCHAR2 DEFAULT NULL,
    p_preferred_roles IN VARCHAR2 DEFAULT NULL
  ) IS
  BEGIN
    INSERT INTO UR_USERS_PENDING (
      FIRST_NAME, LAST_NAME, EMAIL, CONTACT_NUMBER, USER_TYPE,
      START_DATE, END_DATE, LOGIN_METHOD, BASE_USERNAME, SUGGESTED_USERNAME,
      PREFERRED_ROLES, CREATED_ON, PROCESSED_FLAG
    ) VALUES (
      p_first_name, p_last_name, p_email, p_contact_number, p_user_type,
      p_start_date, p_end_date, p_login_method, p_base_username, p_suggested_username,
      p_preferred_roles, SYSDATE, 'N'
    );
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      NULL; -- consider logging
  END enqueue_user_for_admin;

  -----------------------------------------------------------------------
  -- Admin: process pending rows. Run as admin or scheduled job owned by privileged schema
  -----------------------------------------------------------------------
  PROCEDURE process_pending_users(p_processor IN VARCHAR2 DEFAULT NULL) IS
    CURSOR c_pending IS
      SELECT PEND_ID, FIRST_NAME, LAST_NAME, EMAIL, SUGGESTED_USERNAME, PREFERRED_ROLES
      FROM UR_USERS_PENDING
      WHERE PROCESSED_FLAG = 'N'
      FOR UPDATE SKIP LOCKED;
    l_rec c_pending%ROWTYPE;
    l_apex_err VARCHAR2(4000);
  BEGIN
    FOR l_rec IN c_pending LOOP
      BEGIN
        -- create apex user (must run as workspace admin)
        do_create_apex_user(l_rec.SUGGESTED_USERNAME, l_rec.FIRST_NAME, l_rec.LAST_NAME, l_rec.EMAIL);
        -- assign roles if any (use current app context or modify to pass app_id)
        IF l_rec.PREFERRED_ROLES IS NOT NULL THEN
          assign_app_roles(NULL, l_rec.SUGGESTED_USERNAME, l_rec.PREFERRED_ROLES);
        END IF;
        -- send email
        do_send_welcome_email(l_rec.EMAIL, l_rec.SUGGESTED_USERNAME, l_rec.FIRST_NAME, l_rec.LAST_NAME);

        -- mark processed
        UPDATE UR_USERS_PENDING
        SET PROCESSED_FLAG = 'Y',
            PROCESSOR = p_processor,
            PROCESSED_ON = SYSDATE,
            NOTES = 'Processed OK'
        WHERE PEND_ID = l_rec.PEND_ID;
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          l_apex_err := SQLERRM;
          UPDATE UR_USERS_PENDING
          SET PROCESSED_FLAG = 'E',
              PROCESSOR = p_processor,
              PROCESSED_ON = SYSDATE,
              NOTES = 'Error: ' || l_apex_err
          WHERE PEND_ID = l_rec.PEND_ID;
          COMMIT;
      END;
    END LOOP;
  END process_pending_users;

END ur_users_pkg;
/
create or replace PACKAGE BODY ur_user_mgmt IS

PROCEDURE create_user (
    p_first      IN VARCHAR2,
    p_last       IN VARCHAR2,
    p_email      IN VARCHAR2,
    p_contact    IN NUMBER,
    p_user_type  IN VARCHAR2,
    p_status     IN VARCHAR2,
    p_start_date IN DATE DEFAULT SYSDATE,
    p_end_date   IN DATE DEFAULT NULL,
    p_login_method IN VARCHAR2 DEFAULT 'APEX'
) IS
    v_username   VARCHAR2(255);
    v_guid       RAW(16) := SYS_GUID();
    v_app_id     NUMBER := NVL(TO_NUMBER(SYS_CONTEXT('APEX$SESSION','APP_ID')), 101); -- fallback app id
    v_body       CLOB;
BEGIN
    -- 1. Build username (first letter of first name + full last name, lowercase)
    v_username := LOWER(SUBSTR(p_first,1,1) || p_last);

    -- 2. Insert into UR_USERS
    INSERT INTO ur_users (
        user_id, first_name, last_name, email,
        contact_number, user_type, status,
        start_date, end_date, login_method, user_name
    )
    VALUES (
        v_guid, p_first, p_last, p_email,
        p_contact, p_user_type, p_status,
        p_start_date, p_end_date, p_login_method, v_username
    );

    -- 3. Create APEX user (no password, force reset on first login)
    APEX_UTIL.CREATE_USER (
        p_user_name      => v_username,
        p_email_address  => p_email,
        p_developer_privs => 'ADMIN:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
        p_change_password_on_first_use => 'Y',
        p_web_password   => NULL
    );

    -- 4. Prepare email body
    v_body := 'Dear ' || p_first || ' ' || p_last || ',' || CHR(10) ||
              'Your user account has been created.' || CHR(10) ||
              'Username: ' || v_username || CHR(10) ||
              'Login: https://gce17f00a19c10b-prod.adb.uk-london-1.oraclecloudapps.com/ords/r/dev/ur/login' || CHR(10) ||
              'Please reset your password on first login.';

    -- 5. Send email
    APEX_MAIL.SEND(
        p_to      => p_email,
        p_from    => 'no-reply@yourdomain.com',
        p_subj    => 'Your User Account Has Been Created',
        p_body    => v_body
    );

    COMMIT;
END create_user;

END ur_user_mgmt;
/
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
  v_sanitized_name := v_upper_name;

  -- Check against core reserved words
  FOR i IN 1..c_reserved_words.COUNT LOOP
    IF v_upper_name = c_reserved_words(i) THEN
      v_is_reserved := 'true';
      v_sanitized_name := v_upper_name || '_' || UPPER(p_suffix);
      EXIT;
    END IF;
  END LOOP;

  -- If not found in reserved, check keywords
  IF v_is_reserved = 'false' THEN
    FOR i IN 1..c_keywords.COUNT LOOP
      IF v_upper_name = c_keywords(i) THEN
        v_is_reserved := 'true';
        v_sanitized_name := v_upper_name || '_' || UPPER(p_suffix);
        EXIT;
      END IF;
    END LOOP;
  END IF;

  -- Build result JSON
  v_result_json := JSON_OBJECT(
    'is_reserved'     VALUE v_is_reserved,
    'sanitized_name'  VALUE v_sanitized_name
  );

  RETURN v_result_json;

EXCEPTION
  WHEN OTHERS THEN
    -- Return error info in JSON
    RETURN JSON_OBJECT(
      'is_reserved'     VALUE 'false',
      'sanitized_name'  VALUE p_column_name,
      'error'           VALUE SQLERRM
    );
END sanitize_reserved_words;

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
  v_check_result    VARCHAR2(500);
  v_is_reserved     VARCHAR2(10);
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

      -- Check if reserved word
      v_check_result := sanitize_reserved_words(v_name, p_suffix);
      v_is_reserved := JSON_VALUE(v_check_result, '$.is_reserved');

      IF v_is_reserved = 'true' THEN
        v_sanitized_name := JSON_VALUE(v_check_result, '$.sanitized_name');
        v_reserved_count := v_reserved_count + 1;

        -- Modify the name field IN-PLACE
        l_obj.put('name', v_sanitized_name);
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
                 'Sanitized ' || v_reserved_count || ' reserved words.';

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
        l_json_obj.put('attribute_id', RAWTOHEX(p_attribute_id));
        l_json_obj.put('attribute_name', p_attribute_name);
        l_json_obj.put('attribute_key', p_attribute_key);
        l_json_obj.put('attribute_datatype', p_attribute_datatype);
        l_json_obj.put('attribute_qualifier', p_attribute_qualifier);
        l_json_obj.put('attribute_static_value', p_attribute_static_val);
        l_json_obj.put('hotel_id', RAWTOHEX(p_hotel_id));
        l_json_obj.put('stay_date', TO_CHAR(p_stay_date, 'YYYY-MM-DD'));
        l_json_obj.put('DEBUG_FLAG', CASE WHEN p_debug_flag THEN 'TRUE' ELSE 'FALSE' END);
        l_json_obj.put('RESPONSE_TIME', TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD"T"HH24:MI:SS.FF"Z"'));
        l_json_obj.put('STATUS', p_status);
        l_json_obj.put('RECORD_COUNT', p_record_count);
        l_json_obj.put('MESSAGE', p_message);
        l_json_obj.put('RESPONSE_PAYLOAD', p_payload_array);

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
                l_debug_log := l_debug_log || TO_CHAR(SYSTIMESTAMP, 'HH24:MI:SS.FF') || ' - ' || p_log_entry || CHR(10);
            END IF;
        END append_debug;

    BEGIN
        append_debug('Procedure started.');

        IF (p_attribute_id IS NULL AND p_attribute_key IS NULL) OR (p_attribute_id IS NOT NULL AND p_attribute_key IS NOT NULL) THEN
            l_message := 'Validation Error: Provide either p_attribute_id or p_attribute_key, but not both.';
            build_json_response('E', l_message, NULL, NULL, p_attribute_key, NULL, NULL, NULL, p_hotel_id, p_stay_date, p_debug_flag, 0, JSON_ARRAY_T('[]'), p_response_clob);
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
                build_json_response('E', l_message, p_attribute_id, NULL, p_attribute_key, NULL, NULL, NULL, p_hotel_id, p_stay_date, p_debug_flag, 0, JSON_ARRAY_T('[]'), p_response_clob);
                RETURN;
        END;

        IF l_attribute_rec.TYPE = 'M' THEN
            append_debug('Attribute type is Manual. Using static value.');
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
                build_json_response('E', l_message, l_attribute_rec.ID, l_attribute_rec.NAME, l_attribute_rec.KEY, l_attribute_rec.DATA_TYPE, l_attribute_rec.ATTRIBUTE_QUALIFIER, l_attribute_rec.VALUE, p_hotel_id, p_stay_date, p_debug_flag, 0, JSON_ARRAY_T('[]'), p_response_clob);
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
                END LOOP;
                CLOSE l_cursor;
            END;
        ELSE
            RAISE_APPLICATION_ERROR(-20005, 'Attribute validation error: Unknown TYPE ''' || l_attribute_rec.TYPE || '''. Must be ''M'' (Manual) or ''S'' (Sourced).');
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
                JSON_ARRAY_T('[]'),
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
                c006
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

        -- ParsSON definition
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
        v_property_list    CLOB;

        -- Dynamic SQL Variables
        v_sql              CLOB;
        v_pivot_clause     CLOB; -- For inside the subquery
        v_final_columns    CLOB; -- For the final SELECT list
        v_property_count   NUMBER := 0;
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

        SELECT
            LISTAGG('"' || jt.name || '"', ', ') WITHIN GROUP(
                ORDER BY
                    jt.name
            ),
            COUNT(jt.name)
        INTO
            v_property_list,
            v_property_count
        FROM
            JSON_TABLE(v_definition, '$[*]' COLUMNS (name VARCHAR2(128) PATH '$.name', qualifier VARCHAR2(128) PATH '$.qualifier')) jt
        WHERE
            jt.qualifier IN ('OWN_PROPERTY', 'COMP_PROPERTY');

        -- Step 4: Build the dynamic PIVOT and final column list clauses
        -- (REMOVED HOTEL_ID from this pivot logic)
        FOR i IN 1..v_property_count LOOP
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
        v_view_name := 'UR_TMPLT_' || p_template_key || '_RANK_V';

        v_sql := 'CREATE OR REPLACE VIEW "' || v_view_name || '" AS ' || CHR(10) ||
                 'WITH all_properties_ranked AS (' || CHR(10) ||
                 '  SELECT ' || CHR(10) ||
                 '      "HOTEL_ID",' || CHR(10) ||                          -- 1. Select base HOTEL_ID here
                 '      "' || v_sdate_col || '",' || CHR(10) ||
                 '      hotel_name,' || CHR(10) ||
                 '      CASE WHEN REGEXP_LIKE(price, ''^[0-9,.]+$'') THEN TO_NUMBER(REPLACE(price, '','', '''')) ELSE NULL END AS price,' || CHR(10) ||
                 '      ROW_NUMBER() OVER(PARTITION BY "' || v_sdate_col || '" ORDER BY CASE WHEN REGEXP_LIKE(price, ''^[0-9,.]+$'') THEN TO_NUMBER(REPLACE(price, '','', '''')) ELSE NULL END ASC NULLS LAST) as overall_rank' || CHR(10) ||
                 '  FROM "' || v_data_table_name || '"' || CHR(10) ||
                 '  UNPIVOT (price FOR hotel_name IN (' || v_property_list || '))' || CHR(10) ||
                 ')' || CHR(10) ||
                 'SELECT ' || CHR(10) ||
                 '  p."' || v_sdate_col || '" AS "STAY_DATE",' || CHR(10) ||
                 '  p."HOTEL_ID",' || CHR(10) ||                           -- 2. Select HOTEL_ID from the pivot subquery 'p'
                 '  own.price AS "OWN_PROPERTY_RATE",' || CHR(10) ||
                 '  own.overall_rank AS "OWN_PROPERTY_RANK",' || CHR(10) ||
                 '  ' || v_final_columns || CHR(10) ||
                 'FROM (' || CHR(10) ||
                 '  SELECT ' || CHR(10) ||
                 '      "' || v_sdate_col || '",' || CHR(10) ||
                 '      "HOTEL_ID",' || CHR(10) ||                         -- 3. Select HOTEL_ID in the 'p' subquery
                 '      ' || v_pivot_clause || CHR(10) ||
                 '  FROM all_properties_ranked ' || CHR(10) ||
                 '  GROUP BY "' || v_sdate_col || '", "HOTEL_ID"' || CHR(10) || -- 4. Add HOTEL_ID to the GROUP BY
                 ') p' || CHR(10) ||
                 'JOIN (' || CHR(10) ||
                 '  SELECT "' || v_sdate_col || '", price, overall_rank FROM all_properties_ranked WHERE hotel_name = ''' || v_own_property_col || '''' || CHR(10) ||
                 ') own ON p."' || v_sdate_col || '" = own."' || v_sdate_col || '"';

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
                        normalmalize_json(t.columns),
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
                            qualifier     VARCHAR2(100) PATH '$.qualifier'
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
                hotel_id = p_hotel_id;

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

            -- 3. Validate and create attributes for OWN_PROPERTY
            FOR r_col IN (
                SELECT 'OWN_PROPERTY_RANK' AS col_name FROM DUAL
                UNION ALL
                SELECT 'OWN_PROPERTY_RATE' AS col_name FROM DUAL
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
            
            -- 4. Create attributes for COMP_PROPERTY
            FOR i IN 1 .. (v_comp_property_count + 1) LOOP
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

END ur_utils;
/
create or replace PACKAGE BODY ur_utils_test IS

    FUNCTION Clean_TEXT(p_text IN VARCHAR2) RETURN VARCHAR2 IS
      v_clean VARCHAR2(4000);
    BEGIN
      v_clean := UPPER(
                   SUBSTR(
                     REGEXP_REPLACE(
                       REGEXP_REPLACE(
                         REGEXP_REPLACE(
                           TRIM(p_text),
                           '^[^A-Za-z0-9]+|[^A-Za-z0-9]+$', ''
                         ),
                         '[^A-Za-z0-9]+', '_'
                       ),
                       '_+', '_'
                     ),
                     1, 110
                   )
                 );
      RETURN v_clean;
    END Clean_TEXT;

FUNCTION normalize_json (p_json CLOB) RETURN CLOB IS
BEGIN
  RETURN REPLACE(REPLACE(p_json, '"data-type"', '"data_type"'), '"DATA-TYPE"', '"data_type"');
END normalize_json;

  PROCEDURE get_collection_json(
    p_collection_name IN VARCHAR2,
    p_json_clob OUT CLOB,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2
  ) IS
    l_count NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM apex_collections
     WHERE collection_name = p_collection_name;

    IF l_count = 0 THEN
      p_status := FALSE;
      p_message := 'Failure: Collection "' || p_collection_name || '" does not exist or is empty';
      p_json_clob := NULL;
      RETURN;
    END IF;

    -- Initialize and build JSON output
    apex_json.initialize_clob_output;
    apex_json.open_array;

    FOR rec IN (
      SELECT c001, c002, c003
        FROM apex_collections
       WHERE collection_name = p_collection_name
       ORDER BY seq_id
    )
    LOOP
      apex_json.open_object;
      apex_json.write('name', rec.c001);
      apex_json.write('data_type', rec.c002);
      apex_json.write('qualifier', rec.c003);
      apex_json.close_object;
    END LOOP;

    apex_json.close_array;

    p_json_clob := apex_json.get_clob_output;

    apex_json.free_output;

    p_status := TRUE;
    p_message := 'Success: JSON generated for collection "' || p_collection_name || '"';

  EXCEPTION
    WHEN OTHERS THEN
      p_status := FALSE;
      p_message := 'Failure: ' || SQLERRM;
      p_json_clob := NULL;
  END get_collection_json;



 PROCEDURE define_db_object(
    p_template_key IN VARCHAR2,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2
) IS
    v_db_object_name VARCHAR2(30);
    v_sql            CLOB;
    v_col_defs       CLOB := '';
    v_unique_defs    CLOB := '';
    v_definition     CLOB;
    v_exists         NUMBER;
    v_trigger_name   VARCHAR2(130);
    l_col_name       VARCHAR2(100);
BEGIN
    -- Lock row in UR_TEMPLATES and get DB_OBJECT_NAME and definition
    SELECT db_object_name, definition
    INTO v_db_object_name, v_definition
    FROM ur_templates
    WHERE key = p_template_key
    FOR UPDATE;

    IF v_db_object_name IS NOT NULL THEN
      p_status := FALSE;
      p_message := 'Failure: Table already defined as ' || v_db_object_name;
      RETURN;
    END IF;

    IF v_definition IS NULL THEN
      p_status := FALSE;
      p_message := 'Failure: Definition JSON is NULL for template_key ' || p_template_key;
      RETURN;
    END IF;

    -- Generate table name (adjust prefix as needed)
    v_db_object_name := 'UR_' || UPPER(p_template_key) || '_T';

    -- Check if table exists
    SELECT COUNT(*)
    INTO v_exists
    FROM all_tables
    WHERE table_name = UPPER(v_db_object_name);

    IF v_exists > 0 THEN
      p_status := FALSE;
      p_message := 'Failure: Table ' || v_db_object_name || ' already exists in schema';
      RETURN;
    END IF;

    -- Start with ID RAW(16) as primary key column
    v_col_defs := '"REC_ID" RAW(16)';

    -- Parse JSON and build column definitions
    FOR rec IN (
      SELECT jt.name, jt.data_type, jt.qualifier
      FROM JSON_TABLE(
  normalize_json(v_definition),
  '$[*]' COLUMNS (
    name       VARCHAR2(100) PATH '$.name',
    data_type  VARCHAR2(30)  PATH '$.data_type',
    qualifier  VARCHAR2(30)  PATH '$.qualifier'
  )
) jt

    )
    LOOP
      -- sanitize column name: trim underscores and collapse multiple
      l_col_name := UPPER(TRIM(BOTH '_' FROM rec.name));
      l_col_name := REGEXP_REPLACE(l_col_name, '_{2,}', '_');

      v_col_defs := v_col_defs || ', ';

      -- Map data type including DATE
      IF UPPER(rec.data_type) = 'TEXT' THEN
        v_col_defs := v_col_defs || '"' || l_col_name || '" VARCHAR2(4000)';
      ELSIF UPPER(rec.data_type) = 'NUMBER' THEN
        v_col_defs := v_col_defs || '"' || l_col_name || '" NUMBER';
      ELSIF UPPER(rec.data_type) = 'DATE' THEN
        v_col_defs := v_col_defs || '"' || l_col_name || '" DATE';
      ELSE
        -- Default to VARCHAR2 for unknown type
        v_col_defs := v_col_defs || '"' || l_col_name || '" VARCHAR2(4000)';
      END IF;

      -- Collect STAY_DATE constraint definitions
      IF UPPER(rec.qualifier) = 'STAY_DATE' THEN
        v_unique_defs := v_unique_defs 
          || ', CONSTRAINT "' || v_db_object_name || '_' || l_col_name || '_UQ" UNIQUE ("' || l_col_name || '")';
      END IF;
    END LOOP;

    -- Add WHO columns + HOTEL_ID RAW(16)
    v_col_defs := v_col_defs
      || ', CREATED_BY RAW(16), UPDATED_BY RAW(16), CREATED_ON DATE, UPDATED_ON DATE, HOTEL_ID RAW(16), INTERFACE_LOG_ID RAW(16)';

    -- Build final CREATE TABLE DDL
    v_sql := 'CREATE TABLE "' || v_db_object_name || '" (' 
        || v_col_defs 
        || ', CONSTRAINT "' || v_db_object_name || '_PK" PRIMARY KEY ("REC_ID")'
        || v_unique_defs
        || ')';

    EXECUTE IMMEDIATE v_sql;

    -- Create trigger to auto-generate ID (if NULL) using SYS_GUID()
    v_trigger_name := v_db_object_name || '_BI_TRG';

    v_sql := '
CREATE OR REPLACE EDITIONABLE TRIGGER "' || v_trigger_name || '"
BEFORE INSERT OR UPDATE ON "' || v_db_object_name || '"
FOR EACH ROW
DECLARE
  v_user_id UR_USERS.USER_ID%TYPE;
BEGIN
  -- Get the USER_ID once
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

    -- Update UR_TEMPLATES with the new db_object_name and timestamp
    UPDATE ur_templates
    SET db_object_name = v_db_object_name,
        db_object_created_on = SYSDATE
    WHERE key = p_template_key;

    COMMIT;

    p_status := TRUE;
    p_message := 'Success: Table "' || v_db_object_name || '" created with ID primary key and trigger';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_status := FALSE;
      p_message := 'Failure: Template key not found';
    WHEN OTHERS THEN
      p_status := FALSE;
      p_message := 'Failure: ' || SQLERRM;
END define_db_object;


PROCEDURE LOAD_DATA_MAPPING_COLLECTION (
    p_file_id         IN  VARCHAR2,
    p_template_id    IN  VARCHAR2,
    p_collection_name IN  VARCHAR2,
    p_status          OUT VARCHAR2,
    p_message         OUT VARCHAR2
) IS

    -- Local variables
    v_seq_id NUMBER;

BEGIN
    -- Initialize outputs
    p_status := 'S';
    p_message := 'Processing completed successfully.';

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
            p_status := 'E';
            p_message := 'Failed to create or truncate collection "' || p_collection_name || '": ' || SQLERRM;
            RETURN;
    END;

    ------------------------------------------------------------------------
    -- Step 2: Insert data from TEMP_BLOB JSON into collection (c001)
    ------------------------------------------------------------------------
    BEGIN
        FOR rec IN (
            SELECT jt.name || ' (' || jt.data_type || ')' AS column_desc, jt.col_position
            FROM TEMP_BLOB t,
                 JSON_TABLE(
    normalize_json(t.columns),
    '$[*]' COLUMNS (
       name      VARCHAR2(100) PATH '$.name',
       data_type VARCHAR2(100) PATH '$.data_type',
       col_position VARCHAR2(100) PATH '$.pos'
    )

                 ) jt
            WHERE t.id = p_file_id
        ) LOOP
            APEX_COLLECTION.ADD_MEMBER(
                p_collection_name => p_collection_name,
                p_c001            => rec.column_desc,
                p_c004            => rec.col_position
            );
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Failed to insert data from TEMP_BLOB (File ID: ' || p_file_id || '): ' || SQLERRM;
            RETURN;
    END;

    ------------------------------------------------------------------------
    -- Step 3: Update existing collection members with matching data from UR_TEMPLATES (c002, c003)
    ------------------------------------------------------------------------
    BEGIN
        FOR rec IN (
            SELECT jt.name || ' (' || jt.data_type || ')' AS column_desc
            FROM UR_TEMPLATES t,
                 JSON_TABLE(
    normalize_json(t.definition),
    '$[*]' COLUMNS (
       name      VARCHAR2(100) PATH '$.name',
       data_type VARCHAR2(100) PATH '$.data_type'
    )
)
 jt
            WHERE t.id = p_template_id
            ORDER BY t.id DESC
        ) LOOP
            BEGIN
                -- Find the seq_id for matching collection member
                SELECT seq_id 
                INTO v_seq_id
                FROM apex_collections
                WHERE collection_name = p_collection_name
                  AND c001 = rec.column_desc;

                -- Update c002 and c003 attributes
                APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                    p_collection_name => p_collection_name,
                    p_seq             => v_seq_id,
                    p_attr_number     => 2,
                    p_attr_value      => rec.column_desc
                );

                APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                    p_collection_name => p_collection_name,
                    p_seq             => v_seq_id,
                    p_attr_number     => 3,
                    p_attr_value      => 'Maps To'
                );
                
                  


            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- No matching collection member found — ignore gracefully
                    NULL;
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_message := 'Failed to update member attribute in collection "' || p_collection_name || '" for "' 
                                 || rec.column_desc || '": ' || SQLERRM;
                    RETURN;
            END;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Failed to update collection members from UR_TEMPLATES (ID: ' || p_template_id || '): ' || SQLERRM;
            RETURN;
    END;

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'Unexpected error occurred: ' || SQLERRM;
END LOAD_DATA_MAPPING_COLLECTION;

PROCEDURE Load_Data (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT boolean,
    p_message         OUT VARCHAR2
) IS
    l_blob        BLOB;
    l_file_name   VARCHAR2(255);
    l_table_name  VARCHAR2(255);
    l_template_id RAW(16);
    l_total_rows  NUMBER := 0;
    l_success_cnt NUMBER := 0;
    l_fail_cnt    NUMBER := 0;
    l_log_id      RAW(16);
    l_error_json  CLOB := '[';
    l_first_err   BOOLEAN := TRUE;
    l_collection_name VARCHAR2(255);
    l_debug boolean := FALSE;

    -- mapping record type
    TYPE t_map_rec IS RECORD (
        src_col     VARCHAR2(128),  
        tgt_col     VARCHAR2(128),  
        parser_col  VARCHAR2(20),   
        data_type   VARCHAR2(50)
    );
    TYPE t_map IS TABLE OF t_map_rec INDEX BY VARCHAR2(128);

    l_mapping   t_map;
    l_apex_user VARCHAR2(255) := NVL(v('APP_USER'),'APEX_USER');

    l_cols   VARCHAR2(32767);
    l_vals_calculation   VARCHAR2(32767);
    l_sql    CLOB;
    k        VARCHAR2(128);
    v_expr   VARCHAR2(4000);
    l_map_count NUMBER;
    l_table_name_1 varchar2(480) := 'UR_VK_NEW_CHINAR_T_INTERFACE';
    l_update_1 CLOB;
    l_sql_temp clob;
    l_sql_select clob;

    -- ADDED: variable for duplicate check
    l_existing_cnt NUMBER;
    v_cursor   INTEGER;
    v_cols     VARCHAR2(1000) := 'hotel_id, booking_id, number_of_rooms';
    v_desc_tab DBMS_SQL.DESC_TAB;
    v_col_cnt  INTEGER;
    v_value    VARCHAR2(4000);
    v_col_val  VARCHAR2(4000);
    v_status   INTEGER;
BEGIN
  XX_LOCAL_Load_Data (
    p_file_id         => p_file_id        
    ,p_template_key    => p_template_key   
    ,p_hotel_id        => p_hotel_id       
    ,p_collection_name => p_collection_name
    ,p_status          => p_status         
    ,p_message         => p_message        
);

EXCEPTION
    WHEN OTHERS THEN
        DECLARE
            l_err_msg VARCHAR2(4000);
        BEGIN
            l_err_msg := SQLERRM;

            p_status  := FALSE;
            p_message := 'Failure: '|| l_err_msg;

            UPDATE ur_interface_logs
               SET load_end_time = systimestamp,
                   load_status   = 'FAILED',
                   error_json    = l_error_json || '{"error":"' || REPLACE(l_err_msg,'"','''') || '"}]',
                   updated_on    = sysdate
             WHERE id = l_log_id;

            ROLLBACK;
        END;


END Load_Data;









PROCEDURE fetch_templates(
    p_file_id      IN NUMBER,
    p_hotel_id     IN VARCHAR2,
    p_min_score    IN NUMBER DEFAULT 90,
    p_debug_flag   IN VARCHAR2 DEFAULT 'N',
    p_output_json  OUT CLOB,
    p_status       OUT VARCHAR2,
    p_message      OUT VARCHAR2
) IS
    -- Local types
    TYPE t_name_type_rec IS RECORD(
        name       VARCHAR2(100),
        data_type  VARCHAR2(30)
    );
    TYPE t_name_type_tab IS TABLE OF t_name_type_rec;

    TYPE t_template_rec IS RECORD(
        id         VARCHAR2(50),
        name       VARCHAR2(200),
        definition t_name_type_tab
    );
    TYPE t_template_tab IS TABLE OF t_template_rec INDEX BY PLS_INTEGER;

    -- Variables
    v_source_clob       CLOB;
    v_source_normalized CLOB;
    
    v_target_id         VARCHAR2(50);
    v_target_name       VARCHAR2(200);
    v_target_def_clob   CLOB;
    v_target_normalized CLOB;

    v_source_defs       t_name_type_tab := t_name_type_tab();
    v_target_defs       t_name_type_tab := t_name_type_tab();

    v_templates         t_template_tab;
    v_count_templates   PLS_INTEGER := 0;

    v_json_output       CLOB := '[';
    v_min_score_use     NUMBER;
    v_separator         VARCHAR2(1) := '';

    v_match_count       NUMBER;
    v_score             NUMBER;

    CURSOR c_targets IS
      SELECT ID, NAME, DEFINITION FROM UR_TEMPLATES WHERE hotel_id = p_hotel_id;

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
        idx     PLS_INTEGER := 0;
    BEGIN
        FOR rec IN (
            SELECT lower(trim(name)) AS name, lower(trim(data_type)) AS data_type FROM JSON_TABLE(
                p_clob,
                '$[*]' COLUMNS (
                    name VARCHAR2(100) PATH '$.name',
                    data_type VARCHAR2(30) PATH '$.data_type'
                )
            )
        ) LOOP
            idx := idx + 1;
            l_defs.EXTEND;
            l_defs(idx).name := rec.name;
            l_defs(idx).data_type := rec.data_type;
        END LOOP;
        RETURN l_defs;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;

    -- Count matches (name + data_type case-insensitive)
    FUNCTION count_matches(p_source t_name_type_tab, p_target t_name_type_tab) RETURN NUMBER IS
        v_count NUMBER := 0;
    BEGIN
        FOR i IN 1 .. p_source.COUNT LOOP
            FOR j IN 1 .. p_target.COUNT LOOP
                IF p_source(i).name = p_target(j).name AND p_source(i).data_type = p_target(j).data_type THEN
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

    IF p_file_id IS NULL THEN
        p_status := 'E';
        p_message := 'File ID must be provided';
        p_output_json := NULL;
        RETURN;
    END IF;

    IF p_hotel_id IS NULL THEN
        p_status := 'E';
        p_message := 'Hotel ID must be provided';
        p_output_json := NULL;
        RETURN;
    END IF;

    debug('Starting processing...');
    debug('File ID: ' || p_file_id);
    debug('Hotel ID: ' || p_hotel_id);
    debug('Minimum Score: ' || v_min_score_use);

    -- Fetch and normalize source CLOB
    BEGIN
        SELECT columns INTO v_source_clob FROM temp_blob WHERE id = p_file_id;
        IF v_source_clob IS NULL THEN
            p_status := 'E';
            p_message := 'Source definition not found for file_id ' || p_file_id;
            p_output_json := NULL;
            RETURN;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_status := 'E';
            p_message := 'Source file not found for id ' || p_file_id;
            p_output_json := NULL;
            RETURN;
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Error fetching source definition: ' || SQLERRM;
            p_output_json := NULL;
            RETURN;
    END;

    v_source_normalized := normalize_json(v_source_clob);

    -- Parse source defs
    v_source_defs := parse_definition(v_source_normalized);
    IF v_source_defs IS NULL OR v_source_defs.COUNT = 0 THEN
        p_status := 'E';
        p_message := 'Cannot parse source definition JSON or empty definition';
        p_output_json := NULL;
        RETURN;
    END IF;
    debug('Parsed Source definitions: ' || v_source_defs.COUNT || ' fields');

    -- Initialize JSON output
    v_json_output := '[';
    v_count_templates := 0;

    -- Loop over target templates from cursor
    FOR r_target IN c_targets LOOP
        v_target_id := r_target.ID;
        v_target_name := r_target.NAME;
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

        v_match_count := count_matches(v_source_defs, v_target_defs);

        v_score := ROUND((2 * v_match_count) / (v_source_defs.COUNT + v_target_defs.COUNT) * 100);

        debug('Template ' || v_target_id || ' (' || v_target_name || '): Matches=' || 
              v_match_count || ', Score=' || v_score);

        IF v_score >= v_min_score_use THEN
            IF v_count_templates > 0 THEN
                v_json_output := v_json_output || ',';
            END IF;
            v_json_output := v_json_output || '{"Template_id":"' || v_target_id || 
                            '","Template_Name":"' || REPLACE(v_target_name,'"','\"') || 
                            '","Score":' || v_score || '}';
            v_count_templates := v_count_templates + 1;
        END IF;
    END LOOP;

    v_json_output := v_json_output || ']';

    IF v_count_templates = 0 THEN
        p_output_json := '[{}]';
        p_message := 'No templates matched the minimum score threshold';
        debug('No matching templates found.');
    ELSE
        p_output_json := v_json_output;
        p_message := 'Templates matched: ' || v_count_templates;
        debug('Matching templates count: ' || v_count_templates);
    END IF;

    p_status := 'S';

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'Unexpected error: ' || SQLERRM;
        p_output_json := NULL;
END fetch_templates;

PROCEDURE DELETE_TEMPLATES (
    p_id            IN VARCHAR2 DEFAULT NULL,
    p_hotel_id      IN VARCHAR2 DEFAULT NULL,
    p_key           IN VARCHAR2 DEFAULT NULL,
    p_name          IN VARCHAR2 DEFAULT NULL,
    p_type          IN VARCHAR2 DEFAULT NULL,
    p_active        IN CHAR DEFAULT NULL,
    p_db_obj_empty  IN CHAR DEFAULT NULL,
    p_delete_all    IN CHAR DEFAULT 'N',
    p_debug         IN CHAR DEFAULT 'N',
    p_json_output   OUT CLOB
  )
  AS
    v_sql            VARCHAR2(1000);
    v_rows_count     NUMBER;
    v_status         CHAR(1);
    v_message        VARCHAR2(4000);
    v_json_list      CLOB := '[';
    v_first          BOOLEAN := TRUE;

    CURSOR c_templates IS
      SELECT id, hotel_id, key, name, type, active, db_object_name
      FROM ur_templates
      WHERE (p_delete_all = 'Y'
            OR (p_id IS NULL OR id = p_id))
        AND (p_delete_all = 'Y'
             OR (p_hotel_id IS NULL OR hotel_id = p_hotel_id))
        AND (p_delete_all = 'Y'
             OR (p_key IS NULL OR key = p_key))
        AND (p_delete_all = 'Y'
             OR (p_name IS NULL OR name = p_name))
        AND (p_delete_all = 'Y'
             OR (p_type IS NULL OR type = p_type))
        AND (p_delete_all = 'Y'
             OR (p_active IS NULL OR active = p_active));

    -- Helper to escape JSON strings (basic)
    FUNCTION json_escape(str IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
      RETURN REPLACE(REPLACE(REPLACE(REPLACE(str, '\', '\\'), '"', '\"'), CHR(10), '\n'), CHR(13), '');
    EXCEPTION WHEN OTHERS THEN
      RETURN '';
    END;

    PROCEDURE dbg(p_msg VARCHAR2) IS
    BEGIN
      IF p_debug = 'Y' THEN
        apex_debug.message(p_msg);
      END IF;
    END;

    PROCEDURE append_result (
      p_id            IN VARCHAR2,
      p_hotel_id      IN VARCHAR2,
      p_key           IN VARCHAR2,
      p_name          IN VARCHAR2,
      p_type          IN VARCHAR2,
      p_active        IN CHAR,
      p_db_obj_name   IN VARCHAR2,
      p_status        IN CHAR,
      p_message       IN VARCHAR2
    ) IS
    BEGIN
      IF v_first THEN
        v_first := FALSE;
      ELSE
        v_json_list := v_json_list || ',';
      END IF;

      v_json_list := v_json_list || '{' ||
        '"id":"'          || json_escape(p_id)          || '",' ||
        '"hotel_id":"'    || json_escape(p_hotel_id)    || '",' ||
        '"key":"'         || json_escape(p_key)         || '",' ||
        '"name":"'        || json_escape(p_name)        || '",' ||
        '"type":"'        || json_escape(p_type)        || '",' ||
        '"active":"'      || json_escape(p_active)      || '",' ||
        '"db_object_name":"' || json_escape(p_db_obj_name) || '",' ||
        '"status":"'      || json_escape(p_status)      || '",' ||
        '"message":"'     || json_escape(p_message)     || '"' ||
      '}';
    END;

  BEGIN
    dbg('Started DELETE_TEMPLATES_AND_DB_OBJECTS_JSON procedure.');

    FOR rec IN c_templates LOOP
      dbg('Processing template ID=' || rec.id || ', DB_OBJECT_NAME=' || rec.db_object_name);

      IF rec.db_object_name IS NULL THEN
        v_status := 'E';
        v_message := 'No DB_OBJECT_NAME specified for template, skipping.';
        dbg(v_message);
        append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, NULL, v_status, v_message);
        CONTINUE;
      END IF;

      -- Check if table exists in user schema
    --   SELECT COUNT(*)
    --     INTO v_rows_count
    --     FROM all_tables
    --    WHERE table_name = rec.db_object_name
    --      AND owner = USER;

    --   IF v_rows_count = 0 THEN
    --     v_status := 'E';
    --     v_message := 'DB Object [' || rec.db_object_name || '] does not exist or is not a table.';
    --     dbg(v_message);
    --     append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);
    --     CONTINUE;
    --   END IF;

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
          v_status := 'E';
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

        v_status := 'S';
        v_message := 'Successfully dropped table and deleted template.';
        append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);

      EXCEPTION
        WHEN OTHERS THEN
          v_status := 'E';
          v_message := 'Error dropping table or deleting template: ' || SQLERRM;
          dbg(v_message);
          append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);
      END;
    END LOOP;

    v_json_list := v_json_list || ']';

    p_json_output := v_json_list;

    dbg('Completed DELETE_TEMPLATES_AND_DB_OBJECTS_JSON procedure.');
  END DELETE_TEMPLATES;

PROCEDURE manage_algo_attributes(
    p_template_key   IN  VARCHAR2,
    p_mode           IN  CHAR,
    p_attribute_key  IN  VARCHAR2 DEFAULT NULL,
    p_status         OUT BOOLEAN,
    p_message        OUT VARCHAR2
) IS
  v_db_object_name UR_TEMPLATES.DB_OBJECT_NAME%TYPE;
  v_definition     UR_TEMPLATES.DEFINITION%TYPE;
  v_hotel_id       UR_TEMPLATES.HOTEL_ID%TYPE;
  v_user_id        RAW(16);
  v_insert_count   NUMBER := 0;
  v_delete_count   NUMBER := 0;
BEGIN
  -- Initialization
  p_status := FALSE;
  p_message := NULL;

  -- Obtain needed data from UR_TEMPLATES
  BEGIN
    SELECT db_object_name, definition, hotel_id
    INTO v_db_object_name, v_definition, v_hotel_id
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

    -- Insert attributes for all columns with qualifier <> 'UNIQUE'
    FOR rec IN (
      SELECT jt.name, jt.data_type, jt.qualifier
      FROM JSON_TABLE(
        v_definition,
        '$[*]' COLUMNS (
          name       VARCHAR2(100) PATH '$.name',
          data_type  VARCHAR2(30)  PATH '$.data_type',
          qualifier  VARCHAR2(30)  PATH '$.qualifier'
        )
      ) jt
      WHERE jt.qualifier IS NOT NULL
        AND UPPER(jt.qualifier) <> 'UNIQUE'
    )
    LOOP
      DECLARE
        l_col_name VARCHAR2(150);
        v_key      VARCHAR2(150);
        v_exists   NUMBER;
      BEGIN
        -- Normalize column name (remove trailing underscores, spaces, upper-case)
    --  l_col_name := UPPER(TRIM(BOTH '_' FROM TRIM(rec.name)));
-- Normalize: trim spaces, collapse multiple underscores, and remove trailing underscores
l_col_name := UPPER(
                REGEXP_REPLACE(
                  TRIM(rec.name),      -- trim spaces
                  '_+$',               -- remove trailing underscores
                  ''
                )
              );


        v_key := v_db_object_name || '.' || l_col_name;

        SELECT COUNT(*) INTO v_exists FROM ur_algo_attributes WHERE key = v_key;
        IF v_exists = 0 THEN
          INSERT INTO ur_algo_attributes (
            id, algo_id, hotel_id, name, key, data_type, description, type, value,
            created_by, updated_by, created_on, updated_on
          ) VALUES (
            SYS_GUID(),
            NULL, -- algo_id set to NULL as requested
            v_hotel_id,
            l_col_name,
            v_key,
            NVL(UPPER(rec.data_type), 'NUMBER'),
            NULL,
            'S',
            v_key,
            v_user_id,
            v_user_id,
            SYSDATE,
            SYSDATE
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
    IF p_attribute_key IS NOT NULL THEN
      IF p_attribute_key LIKE v_db_object_name || '.%' THEN
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
      DELETE FROM ur_algo_attributes WHERE key LIKE v_db_object_name || '.%';
      v_delete_count := SQL%ROWCOUNT;
      COMMIT;

      p_status := TRUE;
      p_message := 'Success: ' || v_delete_count || ' attribute'
                   || CASE WHEN v_delete_count = 1 THEN '' ELSE 's' END
                   || ' deleted for template_key ' || p_template_key;
    END IF;

  ELSIF p_mode = 'U' THEN
    p_status := FALSE;
    p_message := 'Update mode not yet implemented';

  ELSE
    p_status := FALSE;
    p_message := 'Invalid mode: ' || p_mode || '. Valid modes are C, U, D.';
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    p_status := FALSE;
    p_message := 'Failure: ' || SQLERRM;
END manage_algo_attributes;


procedure add_alert(
    p_existing_json in clob,
    p_message in varchar2,
    p_icon in varchar2 default null,
    p_title in varchar2 default null,
    p_timeout in number default null,
    p_updated_json out clob
) is
    l_json_array json_array_t;
    l_new_object json_object_t;
begin
    -- Create the new JSON object
    l_new_object := new json_object_t();
    l_new_object.put('message', p_message);
    l_new_object.put('icon', nvl(p_icon, 'success'));
    l_new_object.put('title', nvl(p_title, ''));

    if p_timeout is not null then
        l_new_object.put('timeOut', to_char(p_timeout));
    end if;

    -- Append the new object to the existing array or create a new array
    if p_existing_json is null or trim(p_existing_json) = '' then
        -- Create a new array with the new object
        l_json_array := new json_array_t();
    else
        -- Parse the existing JSON string into a JSON array
        l_json_array := json_array_t(p_existing_json);
    end if;

    -- Append the new object
    l_json_array.append(l_new_object);

    -- Convert the JSON array back to a CLOB
    p_updated_json := l_json_array.to_clob;
end add_alert;

PROCEDURE validate_expression (
    p_expression IN VARCHAR2,
    p_mode IN CHAR,
    p_hotel_id IN VARCHAR2,
    p_status OUT VARCHAR2, -- 'S' or 'E'
    p_message OUT VARCHAR2
) IS
  TYPE t_str_list IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
  v_attributes t_str_list;
  v_functions t_str_list;
  v_operators t_str_list;
  v_attr_count NUMBER := 0;
  v_func_count NUMBER := 0;
  v_oper_count NUMBER := 0;

  TYPE t_token_rec IS RECORD (
    token VARCHAR2(4000),
    start_pos PLS_INTEGER,
    end_pos PLS_INTEGER
  );
  TYPE t_token_tab IS TABLE OF t_token_rec INDEX BY PLS_INTEGER;
  v_tokens t_token_tab;
  v_token_count PLS_INTEGER := 0;

  TYPE t_token_tab_nt IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
  v_unmatched_tokens t_token_tab;
  v_unmatched_count PLS_INTEGER := 0;

  -- To mark tokens consumed by multi-word operators
  TYPE t_bool_tab IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;
  v_token_consumed t_bool_tab;

  v_mode CHAR := UPPER(p_mode);

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
  FUNCTION is_in_list(p_token VARCHAR2, p_list t_str_list, cnt NUMBER) RETURN BOOLEAN IS
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

  PROCEDURE load_functions(p_list OUT t_str_list, p_count OUT NUMBER) IS
  BEGIN
    p_list.DELETE;
    p_count := 0;
    FOR r IN (
      SELECT return_value FROM apex_application_lov_entries
      WHERE list_of_values_name = 'UR EXPRESSION FUNCTIONS'
      ORDER BY return_value
    ) LOOP
      p_count := p_count + 1;
      p_list(p_count) := normalize_func_name(r.return_value);
    END LOOP;
    IF p_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20010, 'Functions LOV missing or empty');
    END IF;
  END;

  PROCEDURE load_operators(p_list OUT t_str_list, p_count OUT NUMBER) IS
  BEGIN
    p_list.DELETE;
    p_count := 0;
    FOR r IN (
      SELECT return_value FROM apex_application_lov_entries
      WHERE list_of_values_name = 'UR EXPRESSION OPERATORS'
      ORDER BY return_value
    ) LOOP
      p_count := p_count + 1;
      p_list(p_count) := UPPER(TRIM(r.return_value));
    END LOOP;
    IF p_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20011, 'Operators LOV missing or empty');
    END IF;
  END;

  PROCEDURE load_attributes(p_hotel_id IN VARCHAR2, p_list OUT t_str_list, p_count OUT NUMBER) IS
  BEGIN
    p_list.DELETE;
    p_count := 0;
    FOR r IN (
      SELECT key FROM ur_algo_attributes WHERE hotel_id = p_hotel_id
    ) LOOP
      p_count := p_count + 1;
      p_list(p_count) := UPPER(TRIM(r.key));
    END LOOP;
    IF p_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20012, 'Attributes missing for hotel_id ' || p_hotel_id);
    END IF;
  END;

  -- Tokenizer splitting expression into tokens, tracking start/end pos
  PROCEDURE tokenize_expression(p_expr IN VARCHAR2, p_tokens OUT t_token_tab, p_count OUT NUMBER) IS
    l_pos PLS_INTEGER := 1;
    l_len PLS_INTEGER := LENGTH(p_expr);
    l_token VARCHAR2(4000);
    l_token_start PLS_INTEGER;
    l_token_end PLS_INTEGER;
  BEGIN
    p_tokens.DELETE;
    p_count := 0;
    WHILE l_pos <= l_len LOOP
      l_token := REGEXP_SUBSTR(p_expr,
        '([A-Za-z0-9_\.]+|\d+(\.\d+)?|\(|\)|\S)',
        l_pos,
        1,
        'i');
      EXIT WHEN l_token IS NULL;
      l_token_start := INSTR(p_expr, l_token, l_pos);
      l_token_end := l_token_start + LENGTH(l_token) - 1;
      p_count := p_count + 1;
      p_tokens(p_count) := t_token_rec(token => l_token, start_pos => l_token_start, end_pos => l_token_end);
      l_pos := l_token_end + 1;
      WHILE l_pos <= l_len AND SUBSTR(p_expr, l_pos, 1) = ' ' LOOP
        l_pos := l_pos + 1;
      END LOOP;
    END LOOP;
  END;

  FUNCTION build_json_errors(p_unmatched t_token_tab, p_count PLS_INTEGER) RETURN VARCHAR2 IS
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
    combined VARCHAR2(4000);
    max_words CONSTANT PLS_INTEGER := 4; -- max operator words count
    words_count PLS_INTEGER;
    l_len PLS_INTEGER := LEAST(max_words, v_token_count - start_idx + 1);
    i PLS_INTEGER;
  BEGIN
    FOR words_count IN REVERSE 1 .. l_len LOOP
      combined := '';
      FOR i IN start_idx .. start_idx + words_count - 1 LOOP
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
  p_status := 'E';
  p_message := NULL;

  IF v_mode NOT IN ('V', 'C') THEN
    p_status := 'E';
    p_message := 'Invalid mode "' || p_mode || '". Valid are V or C.';
    RETURN;
  END IF;

  IF p_hotel_id IS NULL THEN
    p_status := 'E';
    p_message := 'hotel_id is mandatory';
    RETURN;
  END IF;

  IF p_expression IS NULL OR LENGTH(TRIM(p_expression)) = 0 THEN
    p_status := 'E';
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
    i PLS_INTEGER := 1;
    words_matched PLS_INTEGER := 0;
  BEGIN
    WHILE i <= v_token_count LOOP
      words_matched := get_longest_operator_match(i);
      IF words_matched > 0 THEN
        FOR j IN i .. i + words_matched - 1 LOOP
          v_token_consumed(j) := TRUE;
        END LOOP;
        i := i + words_matched;
      ELSE
        -- Single token valid check
        v_token_consumed(i) := is_token_valid(normalize_token(v_tokens(i).token));
        i := i + 1;
      END IF;
    END LOOP;
  END;

  IF v_mode = 'V' THEN
    v_unmatched_tokens.DELETE;
    v_unmatched_count := 0;
    FOR i IN 1 .. v_token_count LOOP
      IF v_token_consumed.EXISTS(i) AND v_token_consumed(i) = FALSE THEN
        v_unmatched_count := v_unmatched_count + 1;
        v_unmatched_tokens(v_unmatched_count) := v_tokens(i);
      END IF;
    END LOOP;

    IF v_unmatched_count > 0 THEN
      p_status := 'E';
      p_message := 'Invalid tokens: ' || build_json_errors(v_unmatched_tokens, v_unmatched_count);
    ELSE
      p_status := 'S';
      p_message := 'Expression validated successfully.';
    END IF;

  ELSIF v_mode = 'C' THEN
    p_status := 'S';
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
    p_status := 'E';
    p_message := 'Failure: ' || SQLERRM;
END validate_expression;


END ur_utils_test;
/
create or replace PACKAGE BODY UR_UTILS_TEST_1 IS

    FUNCTION Clean_TEXT(p_text IN VARCHAR2) RETURN VARCHAR2 IS
      v_clean VARCHAR2(4000);
    BEGIN
      v_clean := UPPER(
                   SUBSTR(
                     REGEXP_REPLACE(
                       REGEXP_REPLACE(
                         REGEXP_REPLACE(
                           TRIM(p_text),
                           '^[^A-Za-z0-9]+|[^A-Za-z0-9]+$', ''
                         ),
                         '[^A-Za-z0-9]+', '_'
                       ),
                       '_+', '_'
                     ),
                     1, 110
                   )
                 );
      RETURN v_clean;
    END Clean_TEXT;

FUNCTION normalize_json (p_json CLOB) RETURN CLOB IS
BEGIN
  RETURN REPLACE(REPLACE(p_json, '"data-type"', '"data_type"'), '"DATA-TYPE"', '"data_type"');
END normalize_json;

  PROCEDURE get_collection_json(
    p_collection_name IN VARCHAR2,
    p_json_clob OUT CLOB,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2
  ) IS
    l_count NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_count
      FROM apex_collections
     WHERE collection_name = p_collection_name;

    IF l_count = 0 THEN
      p_status := FALSE;
      p_message := 'Failure: Collection "' || p_collection_name || '" does not exist or is empty';
      p_json_clob := NULL;
      RETURN;
    END IF;

    -- Initialize and build JSON output
    apex_json.initialize_clob_output;
    apex_json.open_array;

    FOR rec IN (
      SELECT c001, c002, c003
        FROM apex_collections
       WHERE collection_name = p_collection_name
       ORDER BY seq_id
    )
    LOOP
      apex_json.open_object;
      apex_json.write('name', rec.c001);
      apex_json.write('data_type', rec.c002);
      apex_json.write('qualifier', rec.c003);
      apex_json.close_object;
    END LOOP;

    apex_json.close_array;

    p_json_clob := apex_json.get_clob_output;

    apex_json.free_output;

    p_status := TRUE;
    p_message := 'Success: JSON generated for collection "' || p_collection_name || '"';

  EXCEPTION
    WHEN OTHERS THEN
      p_status := FALSE;
      p_message := 'Failure: ' || SQLERRM;
      p_json_clob := NULL;
  END get_collection_json;



 PROCEDURE define_db_object(
    p_template_key IN VARCHAR2,
    p_status OUT BOOLEAN,
    p_message OUT VARCHAR2
) IS
    v_db_object_name VARCHAR2(30);
    v_sql            CLOB;
    v_col_defs       CLOB := '';
    v_unique_defs    CLOB := '';
    v_definition     CLOB;
    v_exists         NUMBER;
    v_trigger_name   VARCHAR2(130);
    l_col_name       VARCHAR2(100);
BEGIN
    -- Lock row in UR_TEMPLATES and get DB_OBJECT_NAME and definition
    SELECT db_object_name, definition
    INTO v_db_object_name, v_definition
    FROM ur_templates
    WHERE key = p_template_key
    FOR UPDATE;

    IF v_db_object_name IS NOT NULL THEN
      p_status := FALSE;
      p_message := 'Failure: Table already defined as ' || v_db_object_name;
      RETURN;
    END IF;

    IF v_definition IS NULL THEN
      p_status := FALSE;
      p_message := 'Failure: Definition JSON is NULL for template_key ' || p_template_key;
      RETURN;
    END IF;

    -- Generate table name (adjust prefix as needed)
    v_db_object_name := 'UR_' || UPPER(p_template_key) || '_T';

    -- Check if table exists
    SELECT COUNT(*)
    INTO v_exists
    FROM all_tables
    WHERE table_name = UPPER(v_db_object_name);

    IF v_exists > 0 THEN
      p_status := FALSE;
      p_message := 'Failure: Table ' || v_db_object_name || ' already exists in schema';
      RETURN;
    END IF;

    -- Start with ID RAW(16) as primary key column
    v_col_defs := '"REC_ID" RAW(16)';

    -- Parse JSON and build column definitions
    FOR rec IN (
      SELECT jt.name, jt.data_type, jt.qualifier
      FROM JSON_TABLE(
  normalize_json(v_definition),
  '$[*]' COLUMNS (
    name       VARCHAR2(100) PATH '$.name',
    data_type  VARCHAR2(30)  PATH '$.data_type',
    qualifier  VARCHAR2(30)  PATH '$.qualifier'
  )
) jt

    )
    LOOP
      -- sanitize column name: trim underscores and collapse multiple
      l_col_name := UPPER(TRIM(BOTH '_' FROM rec.name));
      l_col_name := REGEXP_REPLACE(l_col_name, '_{2,}', '_');

      v_col_defs := v_col_defs || ', ';

      -- Map data type including DATE
      IF UPPER(rec.data_type) = 'TEXT' THEN
        v_col_defs := v_col_defs || '"' || l_col_name || '" VARCHAR2(4000)';
      ELSIF UPPER(rec.data_type) = 'NUMBER' THEN
        v_col_defs := v_col_defs || '"' || l_col_name || '" NUMBER';
      ELSIF UPPER(rec.data_type) = 'DATE' THEN
        v_col_defs := v_col_defs || '"' || l_col_name || '" DATE';
      ELSE
        -- Default to VARCHAR2 for unknown type
        v_col_defs := v_col_defs || '"' || l_col_name || '" VARCHAR2(4000)';
      END IF;

      -- Collect STAY_DATE constraint definitions
      IF UPPER(rec.qualifier) = 'STAY_DATE' THEN
        v_unique_defs := v_unique_defs 
          || ', CONSTRAINT "' || v_db_object_name || '_' || l_col_name || '_UQ" UNIQUE ("' || l_col_name || '")';
      END IF;
    END LOOP;

    -- Add WHO columns + HOTEL_ID RAW(16)
    v_col_defs := v_col_defs
      || ', CREATED_BY RAW(16), UPDATED_BY RAW(16), CREATED_ON DATE, UPDATED_ON DATE, HOTEL_ID RAW(16), INTERFACE_LOG_ID RAW(16)';

    -- Build final CREATE TABLE DDL
    v_sql := 'CREATE TABLE "' || v_db_object_name || '" (' 
        || v_col_defs 
        || ', CONSTRAINT "' || v_db_object_name || '_PK" PRIMARY KEY ("REC_ID")'
        || v_unique_defs
        || ')';

    EXECUTE IMMEDIATE v_sql;

    -- Create trigger to auto-generate ID (if NULL) using SYS_GUID()
    v_trigger_name := v_db_object_name || '_BI_TRG';

    v_sql := '
CREATE OR REPLACE EDITIONABLE TRIGGER "' || v_trigger_name || '"
BEFORE INSERT OR UPDATE ON "' || v_db_object_name || '"
FOR EACH ROW
DECLARE
  v_user_id UR_USERS.USER_ID%TYPE;
BEGIN
  -- Get the USER_ID once
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

    -- Update UR_TEMPLATES with the new db_object_name and timestamp
    UPDATE ur_templates
    SET db_object_name = v_db_object_name,
        db_object_created_on = SYSDATE
    WHERE key = p_template_key;

    COMMIT;

    p_status := TRUE;
    p_message := 'Success: Table "' || v_db_object_name || '" created with ID primary key and trigger';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_status := FALSE;
      p_message := 'Failure: Template key not found';
    WHEN OTHERS THEN
      p_status := FALSE;
      p_message := 'Failure: ' || SQLERRM;
END define_db_object;


PROCEDURE LOAD_DATA_MAPPING_COLLECTION (
    p_file_id         IN  VARCHAR2,
    p_template_id    IN  VARCHAR2,
    p_collection_name IN  VARCHAR2,
    p_status          OUT VARCHAR2,
    p_message         OUT VARCHAR2
) IS

    -- Local variables
    v_seq_id NUMBER;

BEGIN
    -- Initialize outputs
    p_status := 'S';
    p_message := 'Processing completed successfully.';

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
            p_status := 'E';
            p_message := 'Failed to create or truncate collection "' || p_collection_name || '": ' || SQLERRM;
            RETURN;
    END;

    ------------------------------------------------------------------------
    -- Step 2: Insert data from TEMP_BLOB JSON into collection (c001)
    ------------------------------------------------------------------------
    BEGIN
        FOR rec IN (
            SELECT jt.name || ' (' || jt.data_type || ')' AS column_desc, jt.col_position
            FROM TEMP_BLOB t,
                 JSON_TABLE(
    normalize_json(t.columns),
    '$[*]' COLUMNS (
       name      VARCHAR2(100) PATH '$.name',
       data_type VARCHAR2(100) PATH '$.data_type',
       col_position VARCHAR2(100) PATH '$.pos'
    )

                 ) jt
            WHERE t.id = p_file_id
        ) LOOP
            APEX_COLLECTION.ADD_MEMBER(
                p_collection_name => p_collection_name,
                p_c001            => rec.column_desc,
                p_c004            => rec.col_position
            );
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Failed to insert data from TEMP_BLOB (File ID: ' || p_file_id || '): ' || SQLERRM;
            RETURN;
    END;

    ------------------------------------------------------------------------
    -- Step 3: Update existing collection members with matching data from UR_TEMPLATES (c002, c003)
    ------------------------------------------------------------------------
    BEGIN
        FOR rec IN (
            SELECT jt.name || ' (' || jt.data_type || ')' AS column_desc
            FROM UR_TEMPLATES t,
                 JSON_TABLE(
    normalize_json(t.definition),
    '$[*]' COLUMNS (
       name      VARCHAR2(100) PATH '$.name',
       data_type VARCHAR2(100) PATH '$.data_type'
    )
)
 jt
            WHERE t.id = p_template_id
            ORDER BY t.id DESC
        ) LOOP
            BEGIN
                -- Find the seq_id for matching collection member
                SELECT seq_id 
                INTO v_seq_id
                FROM apex_collections
                WHERE collection_name = p_collection_name
                  AND c001 = rec.column_desc;

                -- Update c002 and c003 attributes
                APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                    p_collection_name => p_collection_name,
                    p_seq             => v_seq_id,
                    p_attr_number     => 2,
                    p_attr_value      => rec.column_desc
                );

                APEX_COLLECTION.UPDATE_MEMBER_ATTRIBUTE(
                    p_collection_name => p_collection_name,
                    p_seq             => v_seq_id,
                    p_attr_number     => 3,
                    p_attr_value      => 'Maps To'
                );

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- No matching collection member found — ignore gracefully
                    NULL;
                WHEN OTHERS THEN
                    p_status := 'E';
                    p_message := 'Failed to update member attribute in collection "' || p_collection_name || '" for "' 
                                 || rec.column_desc || '": ' || SQLERRM;
                    RETURN;
            END;
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Failed to update collection members from UR_TEMPLATES (ID: ' || p_template_id || '): ' || SQLERRM;
            RETURN;
    END;

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'Unexpected error occurred: ' || SQLERRM;
END LOAD_DATA_MAPPING_COLLECTION;

PROCEDURE Load_Data (
    p_file_id         IN  NUMBER,
    p_template_key    IN  VARCHAR2,
    p_hotel_id        IN  RAW,
    p_collection_name IN  VARCHAR2,
    p_status          OUT boolean,
    p_message         OUT VARCHAR2
) IS
    l_blob        BLOB;
    l_file_name   VARCHAR2(255);
    l_table_name  VARCHAR2(255);
    l_template_id RAW(16);
    l_total_rows  NUMBER := 0;
    l_success_cnt NUMBER := 0;
    l_fail_cnt    NUMBER := 0;
    l_log_id      RAW(16);
    l_error_json  CLOB := '[';
    l_first_err   BOOLEAN := TRUE;
    l_collection_name VARCHAR2(255);
    l_debug boolean := FALSE;

    -- mapping record type
    TYPE t_map_rec IS RECORD (
        src_col     VARCHAR2(128),  
        tgt_col     VARCHAR2(128),  
        parser_col  VARCHAR2(20),   
        data_type   VARCHAR2(50)
    );
    TYPE t_map IS TABLE OF t_map_rec INDEX BY VARCHAR2(128);

    l_mapping   t_map;
    l_apex_user VARCHAR2(255) := NVL(v('APP_USER'),'APEX_USER');

    l_cols   VARCHAR2(32767);
    l_vals   VARCHAR2(32767);
    l_sql    CLOB;
    k        VARCHAR2(128);
    v_expr   VARCHAR2(4000);
    l_map_count NUMBER;
    l_table_name_1 varchar2(480) := 'UR_VK_NEW_CHINAR_T_INTERFACE';
    l_update_1 CLOB;
    l_sql_temp clob;
    l_sql_select clob;

    -- ADDED: variable for duplicate check
    l_existing_cnt NUMBER;
    v_cursor   INTEGER;
    v_cols     VARCHAR2(1000) := 'hotel_id, booking_id, number_of_rooms';
    v_desc_tab DBMS_SQL.DESC_TAB;
    v_col_cnt  INTEGER;
    v_value    VARCHAR2(4000);
    v_col_val  VARCHAR2(4000);
    v_status   INTEGER;
    l_rows_fetched    NUMBER;
    l_cursor_id       INTEGER;
    l_col_count       NUMBER;
    l_describe_tab    DBMS_SQL.DESC_TAB;
    l_column_value    VARCHAR2(4000);
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
        p_status  := FALSE;
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

    -- 4. Load mapping directly from collection
    FOR rec IN (
        SELECT regexp_substr(c001, '^[^(]+')                    src_col,
               regexp_substr(c002, '^[^(]+')                    tgt_col,
               TRIM(c004)                                       parser_col,
               UPPER(regexp_replace(c001, '^[^(]+\(([^)]+)\).*', '\1')) datatype
          FROM apex_collections
         WHERE collection_name = p_collection_name
           AND c003 = 'Maps To'
           AND c004 IS NOT NULL
    ) LOOP
        l_mapping(UPPER(TRIM(rec.src_col))).src_col    := TRIM(rec.src_col);
        l_mapping(UPPER(TRIM(rec.src_col))).tgt_col    := TRIM(rec.tgt_col);
        l_mapping(UPPER(TRIM(rec.src_col))).parser_col := TRIM(rec.parser_col);
        l_mapping(UPPER(TRIM(rec.src_col))).data_type  := TRIM(rec.datatype);
INSERT INTO debug_log(message) VALUES('rec.src_col: ' || rec.src_col);
    INSERT INTO debug_log(message) VALUES('rec.tgt_col : ' || rec.tgt_col);
     INSERT INTO debug_log(message) VALUES('rec.parser_col : ' || rec.parser_col);
    commit;
    END LOOP;

    l_map_count := l_mapping.count;
    IF l_map_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No mapped columns found in collection!');
    END IF;

    -- 5. Build dynamic column list and values
    k := l_mapping.first;
    WHILE k IS NOT NULL LOOP
        IF l_mapping.exists(k)
           AND l_mapping(k).tgt_col IS NOT NULL
           AND l_mapping(k).parser_col IS NOT NULL
        THEN
            IF l_cols IS NOT NULL THEN
                l_cols := l_cols || ',';
                l_vals := l_vals || ',';
            END IF;
            INSERT INTO debug_log(message) VALUES('In while loop 1 l_cols: ' || l_cols);
            INSERT INTO debug_log(message) VALUES('In while loop 1 l_vals: ' || l_vals);
            l_cols := l_cols || l_mapping(k).tgt_col;
            INSERT INTO debug_log(message) VALUES('In while loop 1 l_cols: ' || l_cols);
            -- safe conversions
            IF l_mapping(k).data_type = 'NUMBER' THEN
                v_expr := 'CASE WHEN REGEXP_LIKE(p.'|| l_mapping(k).parser_col ||', ''^-?\d+(\.\d+)?$'') '||
                          'THEN TO_NUMBER(p.'|| l_mapping(k).parser_col ||') ELSE NULL END';
             
            ELSIF l_mapping(k).data_type = 'DATE' THEN
                v_expr := 'CASE '||
                          -- Full datetime with DD-MM-YYYY
                          ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}-\d{2}-\d{4}\s+\d{2}:\d{2}:\d{2}$'') '||
                          '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD-MM-YYYY HH24:MI:SS'') '||

                          -- Full datetime with DD/MM/YYYY
                          ' WHEN REGEXP_LIKE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''^\d{2}/\d{2}/\d{4}\s+\d{2}:\d{2}:\d{2}$'') '||
                          '      THEN TO_DATE(TRIM(p.'|| l_mapping(k).parser_col ||'), ''DD/MM/YYYY HH24:MI:SS'') '||

                          -- Full datetime with DD-MON-YYYY (your case)
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

                          -- Fallback
                          ' ELSE NULL END';



                        ELSE
                            v_expr := 'p.'|| l_mapping(k).parser_col;
                            INSERT INTO debug_log(message) VALUES('v_expr: ' || v_expr);
               
                        END IF;

            l_vals := l_vals || v_expr;
        END IF;
        k := l_mapping.next(k);
    END LOOP;


    -- 6. Build INSERT statement (HOTEL_ID injected as constant)
    /*l_sql :=
        'INSERT INTO '|| l_table_name ||' (HOTEL_ID,'|| l_cols ||',INTERFACE_LOG_ID) '||
        'SELECT :hotel_id,'|| l_vals ||',:log_id '||
        '  FROM TABLE(apex_data_parser.parse(p_content => :b1, p_file_name => :b2)) p '||
        ' WHERE p.line_number > 1';

            EXECUTE IMMEDIATE l_sql USING p_hotel_id, l_log_id, l_blob, l_file_name;

*/
       -- l_blob := UTL_RAW.CAST_TO_RAW('header1,header2' || CHR(10) || 'data1,data2');
    
    -- 1. Construct the SQL query with bind variable placeholders
    -- Note: l_vals is concatenated because the list of columns is dynamic.
    -- All other *values* are passed via bind variables.
    l_sql := 'SELECT :p_hotel_id, ' || l_vals || ', :l_log_id ' ||
             ' FROM TABLE(apex_data_parser.parse(p_content => :p_content, p_file_name => :p_file_name)) p ' ||
             ' where 1=1';

    INSERT INTO debug_log(message) VALUES('l_vals 0.11112 :>>>>>>>>>>>>>>>>>> '||l_vals ); 
    
    -- Open & parse
    l_cursor_id := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(l_cursor_id, l_sql, DBMS_SQL.NATIVE);
    
    INSERT INTO debug_log(message) VALUES('l_vals 0.1111222222 :>>>>>>>>>>>>>>>>>> '||l_vals ); 
    
    -- Bind variables
    DBMS_SQL.BIND_VARIABLE(l_cursor_id, ':p_hotel_id', p_hotel_id);
    DBMS_SQL.BIND_VARIABLE(l_cursor_id, ':l_log_id', l_log_id);
    DBMS_SQL.BIND_VARIABLE(l_cursor_id, ':p_content', l_blob);
    DBMS_SQL.BIND_VARIABLE(l_cursor_id, ':p_file_name', l_file_name);

    INSERT INTO debug_log(message) VALUES('l_vals 0.2 :>>>>>>>>>>>>>>>>>> '||l_vals ); 
    INSERT INTO debug_log(message) VALUES('p_hotel_id 0.20 :>>>>>>>>>>>>>>>>>> '||p_hotel_id ); 
    INSERT INTO debug_log(message) VALUES('l_blob 0.21 :>>>>>>>>>>>>>>>>>> '||l_blob); 
    INSERT INTO debug_log(message) VALUES('l_log_id 0.21 :>>>>>>>>>>>>>>>>>> '||l_log_id ); 
    INSERT INTO debug_log(message) VALUES('l_file_name 0.22 :>>>>>>>>>>>>>>>>>> '||l_file_name );

    -- Describe columns to get the actual column count
    DBMS_SQL.DESCRIBE_COLUMNS(l_cursor_id, l_col_count, l_describe_tab);
    
    INSERT INTO debug_log(message) VALUES('l_col_count:>>'||l_col_count);

    -- Define columns
    FOR i IN 1 .. l_col_count LOOP
        DBMS_SQL.DEFINE_COLUMN(l_cursor_id, i, l_column_value, 4000);
    END LOOP;

    -- Execute the cursor
    l_rows_fetched := DBMS_SQL.EXECUTE_AND_FETCH(l_cursor_id); 
    INSERT INTO debug_log(message) VALUES('l_rows_fetched:>>>'||l_rows_fetched);

    -- Fetch rows
    WHILE DBMS_SQL.FETCH_ROWS(l_cursor_id) > 0 LOOP
        FOR i IN 1 .. l_col_count LOOP
            DBMS_SQL.COLUMN_VALUE(l_cursor_id, i, l_column_value);
            INSERT INTO debug_log(message) VALUES('Column ' || i || ': ' || l_column_value);
        END LOOP;
    END LOOP;

    DBMS_SQL.CLOSE_CURSOR(l_cursor_id);


    INSERT INTO debug_log(message) VALUES('Cursor closed successfully');


INSERT INTO debug_log(message) VALUES('l_sql: ' || l_sql);    
   commit;
    EXECUTE IMMEDIATE l_sql USING p_hotel_id, l_log_id, l_blob, l_file_name;

    l_success_cnt := SQL%ROWCOUNT;
    l_total_rows  := l_success_cnt;

    -- 7. Update log entry
    UPDATE ur_interface_logs
       SET load_end_time      = systimestamp,
           load_status        = CASE WHEN l_fail_cnt = 0 THEN 'SUCCESS' ELSE 'FAILED' END,
           records_processed  = l_total_rows,
           records_successful = l_success_cnt,
           records_failed     = l_fail_cnt,
           error_json         = CASE WHEN l_fail_cnt > 0 THEN l_error_json || ']' ELSE NULL END,
           updated_by         = hextoraw(rawtohex(utl_raw.cast_to_raw(l_apex_user))),
           updated_on         = sysdate
     WHERE id = l_log_id;

    COMMIT;

    -- OUT params
    p_status  := TRUE;
    p_message := 'Success: Upload completed for File ID  
                  → Total=' || l_total_rows ||
                 ', Success=' || l_success_cnt ||
                 ', Failed=' || l_fail_cnt;

EXCEPTION
    WHEN OTHERS THEN

        /*DECLARE
            l_err_msg VARCHAR2(4000);
        BEGIN
            l_err_msg := SQLERRM;

            p_status  := FALSE;
            p_message := 'Failure: '|| l_err_msg;

            UPDATE ur_interface_logs
               SET load_end_time = systimestamp,
                   load_status   = 'FAILED',
                   error_json    = l_error_json || '{"error":"' || REPLACE(l_err_msg,'"','''') || '"}]',
                   updated_on    = sysdate
             WHERE id = l_log_id;

            ROLLBACK;
        END;*/
        l_table_name_1 := l_table_name || '_INTERFACE';
         l_sql := 'CREATE TABLE ' || l_table_name_1 ||
             ' AS SELECT * FROM ' || l_table_name || ' WHERE 1=0';

    EXECUTE IMMEDIATE l_sql;

         l_sql :=
        'INSERT INTO '|| l_table_name_1 ||' (HOTEL_ID,'|| l_cols ||',INTERFACE_LOG_ID) '||
        'SELECT :hotel_id,'|| l_vals ||',:log_id '||
        '  FROM TABLE(apex_data_parser.parse(p_content => :b1, p_file_name => :b2)) p '||
        ' WHERE p.line_number > 1';
        EXECUTE IMMEDIATE l_sql USING p_hotel_id, l_log_id, l_blob, l_file_name;
        commit;
     
    -- Build dynamic update set clause
    SELECT LISTAGG('t.'||column_name||' = s.'||column_name, ', ')
             WITHIN GROUP (ORDER BY column_id)
      INTO l_update_1
      FROM user_tab_columns
     WHERE table_name = UPPER(l_table_name)
       AND column_name NOT IN ('STAY_DATE','HOTEL_ID');  -- exclude key columns

    -- Build merge SQL
    l_sql :=
        'MERGE INTO '||l_table_name||' t '||
        'USING '||l_table_name_1||' s '||
        '   ON (t.STAY_DATE = s.STAY_DATE AND t.HOTEL_ID = s.HOTEL_ID) '||
        ' WHEN MATCHED THEN '||
        '   UPDATE SET '|| l_update_1;

    --dbms_output.put_line(l_sql); -- debug
    EXECUTE IMMEDIATE l_sql;
    COMMIT;
    -- Step 4: clean up interface table
        EXECUTE IMMEDIATE 'drop TABLE '|| l_table_name_1;
        commit;

         l_success_cnt := SQL%ROWCOUNT; -- rows inserted
        l_fail_cnt    := 0;            -- since all go to _INT
        l_total_rows  := l_success_cnt;

        p_status  := TRUE;
        p_message := 'Success: Update completed for File ID '||p_file_id||
                     ' → Total=' || l_total_rows ||
                     ', Success=' || l_success_cnt ||
                     ', Failed=' || l_fail_cnt;

--END;


END Load_Data;


PROCEDURE fetch_templates(
    p_file_id      IN NUMBER,
    p_hotel_id     IN VARCHAR2,
    p_min_score    IN NUMBER DEFAULT 90,
    p_debug_flag   IN VARCHAR2 DEFAULT 'N',
    p_output_json  OUT CLOB,
    p_status       OUT VARCHAR2,
    p_message      OUT VARCHAR2
) IS
    -- Local types
    TYPE t_name_type_rec IS RECORD(
        name       VARCHAR2(100),
        data_type  VARCHAR2(30)
    );
    TYPE t_name_type_tab IS TABLE OF t_name_type_rec;

    TYPE t_template_rec IS RECORD(
        id         VARCHAR2(50),
        name       VARCHAR2(200),
        definition t_name_type_tab
    );
    TYPE t_template_tab IS TABLE OF t_template_rec INDEX BY PLS_INTEGER;

    -- Variables
    v_source_clob       CLOB;
    v_source_normalized CLOB;
    
    v_target_id         VARCHAR2(50);
    v_target_name       VARCHAR2(200);
    v_target_def_clob   CLOB;
    v_target_normalized CLOB;

    v_source_defs       t_name_type_tab := t_name_type_tab();
    v_target_defs       t_name_type_tab := t_name_type_tab();

    v_templates         t_template_tab;
    v_count_templates   PLS_INTEGER := 0;

    v_json_output       CLOB := '[';
    v_min_score_use     NUMBER;
    v_separator         VARCHAR2(1) := '';

    v_match_count       NUMBER;
    v_score             NUMBER;

    CURSOR c_targets IS
      SELECT ID, NAME, DEFINITION FROM UR_TEMPLATES WHERE hotel_id = p_hotel_id;

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
        idx     PLS_INTEGER := 0;
    BEGIN
        FOR rec IN (
            SELECT lower(trim(name)) AS name, lower(trim(data_type)) AS data_type FROM JSON_TABLE(
                p_clob,
                '$[*]' COLUMNS (
                    name VARCHAR2(100) PATH '$.name',
                    data_type VARCHAR2(30) PATH '$.data_type'
                )
            )
        ) LOOP
            idx := idx + 1;
            l_defs.EXTEND;
            l_defs(idx).name := rec.name;
            l_defs(idx).data_type := rec.data_type;
        END LOOP;
        RETURN l_defs;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;

    -- Count matches (name + data_type case-insensitive)
    FUNCTION count_matches(p_source t_name_type_tab, p_target t_name_type_tab) RETURN NUMBER IS
        v_count NUMBER := 0;
    BEGIN
        FOR i IN 1 .. p_source.COUNT LOOP
            FOR j IN 1 .. p_target.COUNT LOOP
                IF p_source(i).name = p_target(j).name AND p_source(i).data_type = p_target(j).data_type THEN
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

    IF p_file_id IS NULL THEN
        p_status := 'E';
        p_message := 'File ID must be provided';
        p_output_json := NULL;
        RETURN;
    END IF;

    IF p_hotel_id IS NULL THEN
        p_status := 'E';
        p_message := 'Hotel ID must be provided';
        p_output_json := NULL;
        RETURN;
    END IF;

    debug('Starting processing...');
    debug('File ID: ' || p_file_id);
    debug('Hotel ID: ' || p_hotel_id);
    debug('Minimum Score: ' || v_min_score_use);

    -- Fetch and normalize source CLOB
    BEGIN
        SELECT columns INTO v_source_clob FROM temp_blob WHERE id = p_file_id;
        IF v_source_clob IS NULL THEN
            p_status := 'E';
            p_message := 'Source definition not found for file_id ' || p_file_id;
            p_output_json := NULL;
            RETURN;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_status := 'E';
            p_message := 'Source file not found for id ' || p_file_id;
            p_output_json := NULL;
            RETURN;
        WHEN OTHERS THEN
            p_status := 'E';
            p_message := 'Error fetching source definition: ' || SQLERRM;
            p_output_json := NULL;
            RETURN;
    END;

    v_source_normalized := normalize_json(v_source_clob);

    -- Parse source defs
    v_source_defs := parse_definition(v_source_normalized);
    IF v_source_defs IS NULL OR v_source_defs.COUNT = 0 THEN
        p_status := 'E';
        p_message := 'Cannot parse source definition JSON or empty definition';
        p_output_json := NULL;
        RETURN;
    END IF;
    debug('Parsed Source definitions: ' || v_source_defs.COUNT || ' fields');

    -- Initialize JSON output
    v_json_output := '[';
    v_count_templates := 0;

    -- Loop over target templates from cursor
    FOR r_target IN c_targets LOOP
        v_target_id := r_target.ID;
        v_target_name := r_target.NAME;
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

        v_match_count := count_matches(v_source_defs, v_target_defs);

        v_score := ROUND((2 * v_match_count) / (v_source_defs.COUNT + v_target_defs.COUNT) * 100);

        debug('Template ' || v_target_id || ' (' || v_target_name || '): Matches=' || 
              v_match_count || ', Score=' || v_score);

        IF v_score >= v_min_score_use THEN
            IF v_count_templates > 0 THEN
                v_json_output := v_json_output || ',';
            END IF;
            v_json_output := v_json_output || '{"Template_id":"' || v_target_id || 
                            '","Template_Name":"' || REPLACE(v_target_name,'"','\"') || 
                            '","Score":' || v_score || '}';
            v_count_templates := v_count_templates + 1;
        END IF;
    END LOOP;

    v_json_output := v_json_output || ']';

    IF v_count_templates = 0 THEN
        p_output_json := '[{}]';
        p_message := 'No templates matched the minimum score threshold';
        debug('No matching templates found.');
    ELSE
        p_output_json := v_json_output;
        p_message := 'Templates matched: ' || v_count_templates;
        debug('Matching templates count: ' || v_count_templates);
    END IF;

    p_status := 'S';

EXCEPTION
    WHEN OTHERS THEN
        p_status := 'E';
        p_message := 'Unexpected error: ' || SQLERRM;
        p_output_json := NULL;
END fetch_templates;

PROCEDURE DELETE_TEMPLATES (
    p_id            IN VARCHAR2 DEFAULT NULL,
    p_hotel_id      IN VARCHAR2 DEFAULT NULL,
    p_key           IN VARCHAR2 DEFAULT NULL,
    p_name          IN VARCHAR2 DEFAULT NULL,
    p_type          IN VARCHAR2 DEFAULT NULL,
    p_active        IN CHAR DEFAULT NULL,
    p_db_obj_empty  IN CHAR DEFAULT NULL,
    p_delete_all    IN CHAR DEFAULT 'N',
    p_debug         IN CHAR DEFAULT 'N',
    p_json_output   OUT CLOB
  )
  AS
    v_sql            VARCHAR2(1000);
    v_rows_count     NUMBER;
    v_status         CHAR(1);
    v_message        VARCHAR2(4000);
    v_json_list      CLOB := '[';
    v_first          BOOLEAN := TRUE;

    CURSOR c_templates IS
      SELECT id, hotel_id, key, name, type, active, db_object_name
      FROM ur_templates
      WHERE (p_delete_all = 'Y'
            OR (p_id IS NULL OR id = p_id))
        AND (p_delete_all = 'Y'
             OR (p_hotel_id IS NULL OR hotel_id = p_hotel_id))
        AND (p_delete_all = 'Y'
             OR (p_key IS NULL OR key = p_key))
        AND (p_delete_all = 'Y'
             OR (p_name IS NULL OR name = p_name))
        AND (p_delete_all = 'Y'
             OR (p_type IS NULL OR type = p_type))
        AND (p_delete_all = 'Y'
             OR (p_active IS NULL OR active = p_active));

    -- Helper to escape JSON strings (basic)
    FUNCTION json_escape(str IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
      RETURN REPLACE(REPLACE(REPLACE(REPLACE(str, '\', '\\'), '"', '\"'), CHR(10), '\n'), CHR(13), '');
    EXCEPTION WHEN OTHERS THEN
      RETURN '';
    END;

    PROCEDURE dbg(p_msg VARCHAR2) IS
    BEGIN
      IF p_debug = 'Y' THEN
        apex_debug.message(p_msg);
      END IF;
    END;

    PROCEDURE append_result (
      p_id            IN VARCHAR2,
      p_hotel_id      IN VARCHAR2,
      p_key           IN VARCHAR2,
      p_name          IN VARCHAR2,
      p_type          IN VARCHAR2,
      p_active        IN CHAR,
      p_db_obj_name   IN VARCHAR2,
      p_status        IN CHAR,
      p_message       IN VARCHAR2
    ) IS
    BEGIN
      IF v_first THEN
        v_first := FALSE;
      ELSE
        v_json_list := v_json_list || ',';
      END IF;

      v_json_list := v_json_list || '{' ||
        '"id":"'          || json_escape(p_id)          || '",' ||
        '"hotel_id":"'    || json_escape(p_hotel_id)    || '",' ||
        '"key":"'         || json_escape(p_key)         || '",' ||
        '"name":"'        || json_escape(p_name)        || '",' ||
        '"type":"'        || json_escape(p_type)        || '",' ||
        '"active":"'      || json_escape(p_active)      || '",' ||
        '"db_object_name":"' || json_escape(p_db_obj_name) || '",' ||
        '"status":"'      || json_escape(p_status)      || '",' ||
        '"message":"'     || json_escape(p_message)     || '"' ||
      '}';
    END;

  BEGIN
    dbg('Started DELETE_TEMPLATES_AND_DB_OBJECTS_JSON procedure.');

    FOR rec IN c_templates LOOP
      dbg('Processing template ID=' || rec.id || ', DB_OBJECT_NAME=' || rec.db_object_name);

      IF rec.db_object_name IS NULL THEN
        v_status := 'E';
        v_message := 'No DB_OBJECT_NAME specified for template, skipping.';
        dbg(v_message);
        append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, NULL, v_status, v_message);
        CONTINUE;
      END IF;

      -- Check if table exists in user schema
    --   SELECT COUNT(*)
    --     INTO v_rows_count
    --     FROM all_tables
    --    WHERE table_name = rec.db_object_name
    --      AND owner = USER;

    --   IF v_rows_count = 0 THEN
    --     v_status := 'E';
    --     v_message := 'DB Object [' || rec.db_object_name || '] does not exist or is not a table.';
    --     dbg(v_message);
    --     append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);
    --     CONTINUE;
    --   END IF;

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
          v_status := 'E';
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

        v_status := 'S';
        v_message := 'Successfully dropped table and deleted template.';
        append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);

      EXCEPTION
        WHEN OTHERS THEN
          v_status := 'E';
          v_message := 'Error dropping table or deleting template: ' || SQLERRM;
          dbg(v_message);
          append_result(rec.id, rec.hotel_id, rec.key, rec.name, rec.type, rec.active, rec.db_object_name, v_status, v_message);
      END;
    END LOOP;

    v_json_list := v_json_list || ']';

    p_json_output := v_json_list;

    dbg('Completed DELETE_TEMPLATES_AND_DB_OBJECTS_JSON procedure.');
  END DELETE_TEMPLATES;

PROCEDURE manage_algo_attributes(
    p_template_key   IN  VARCHAR2,
    p_mode           IN  CHAR,
    p_attribute_key  IN  VARCHAR2 DEFAULT NULL,
    p_status         OUT BOOLEAN,
    p_message        OUT VARCHAR2
) IS
  v_db_object_name UR_TEMPLATES.DB_OBJECT_NAME%TYPE;
  v_definition     UR_TEMPLATES.DEFINITION%TYPE;
  v_hotel_id       UR_TEMPLATES.HOTEL_ID%TYPE;
  v_user_id        RAW(16);
  v_insert_count   NUMBER := 0;
  v_delete_count   NUMBER := 0;
BEGIN
  -- Initialization
  p_status := FALSE;
  p_message := NULL;

  -- Obtain needed data from UR_TEMPLATES
  BEGIN
    SELECT db_object_name, definition, hotel_id
    INTO v_db_object_name, v_definition, v_hotel_id
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

    -- Insert attributes for all columns with qualifier <> 'UNIQUE'
    FOR rec IN (
      SELECT jt.name, jt.data_type, jt.qualifier
      FROM JSON_TABLE(
        v_definition,
        '$[*]' COLUMNS (
          name       VARCHAR2(100) PATH '$.name',
          data_type  VARCHAR2(30)  PATH '$.data_type',
          qualifier  VARCHAR2(30)  PATH '$.qualifier'
        )
      ) jt
      WHERE jt.qualifier IS NOT NULL
        AND UPPER(jt.qualifier) <> 'UNIQUE'
    )
    LOOP
      DECLARE
        l_col_name VARCHAR2(150);
        v_key      VARCHAR2(150);
        v_exists   NUMBER;
      BEGIN
        -- Normalize column name (remove trailing underscores, spaces, upper-case)
    --  l_col_name := UPPER(TRIM(BOTH '_' FROM TRIM(rec.name)));
-- Normalize: trim spaces, collapse multiple underscores, and remove trailing underscores
l_col_name := UPPER(
                REGEXP_REPLACE(
                  TRIM(rec.name),      -- trim spaces
                  '_+$',               -- remove trailing underscores
                  ''
                )
              );


        v_key := v_db_object_name || '.' || l_col_name;

        SELECT COUNT(*) INTO v_exists FROM ur_algo_attributes WHERE key = v_key;
        IF v_exists = 0 THEN
          INSERT INTO ur_algo_attributes (
            id, algo_id, hotel_id, name, key, data_type, description, type, value,
            created_by, updated_by, created_on, updated_on
          ) VALUES (
            SYS_GUID(),
            NULL, -- algo_id set to NULL as requested
            v_hotel_id,
            l_col_name,
            v_key,
            NVL(UPPER(rec.data_type), 'NUMBER'),
            NULL,
            'S',
            v_key,
            v_user_id,
            v_user_id,
            SYSDATE,
            SYSDATE
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
    IF p_attribute_key IS NOT NULL THEN
      IF p_attribute_key LIKE v_db_object_name || '.%' THEN
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
      DELETE FROM ur_algo_attributes WHERE key LIKE v_db_object_name || '.%';
      v_delete_count := SQL%ROWCOUNT;
      COMMIT;

      p_status := TRUE;
      p_message := 'Success: ' || v_delete_count || ' attribute'
                   || CASE WHEN v_delete_count = 1 THEN '' ELSE 's' END
                   || ' deleted for template_key ' || p_template_key;
    END IF;

  ELSIF p_mode = 'U' THEN
    p_status := FALSE;
    p_message := 'Update mode not yet implemented';

  ELSE
    p_status := FALSE;
    p_message := 'Invalid mode: ' || p_mode || '. Valid modes are C, U, D.';
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    p_status := FALSE;
    p_message := 'Failure: ' || SQLERRM;
END manage_algo_attributes;


procedure add_alert(
    p_existing_json in clob,
    p_message in varchar2,
    p_icon in varchar2 default null,
    p_title in varchar2 default null,
    p_timeout in number default null,
    p_updated_json out clob
) is
    l_json_array json_array_t;
    l_new_object json_object_t;
begin
    -- Create the new JSON object
    l_new_object := new json_object_t();
    l_new_object.put('message', p_message);
    l_new_object.put('icon', nvl(p_icon, 'success'));
    l_new_object.put('title', nvl(p_title, ''));

    if p_timeout is not null then
        l_new_object.put('timeOut', to_char(p_timeout));
    end if;

    -- Append the new object to the existing array or create a new array
    if p_existing_json is null or trim(p_existing_json) = '' then
        -- Create a new array with the new object
        l_json_array := new json_array_t();
    else
        -- Parse the existing JSON string into a JSON array
        l_json_array := json_array_t(p_existing_json);
    end if;

    -- Append the new object
    l_json_array.append(l_new_object);

    -- Convert the JSON array back to a CLOB
    p_updated_json := l_json_array.to_clob;
end add_alert;

PROCEDURE validate_expression (
    p_expression IN VARCHAR2,
    p_mode IN CHAR,
    p_hotel_id IN VARCHAR2,
    p_status OUT VARCHAR2, -- 'S' or 'E'
    p_message OUT VARCHAR2
) IS
  TYPE t_str_list IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
  v_attributes t_str_list;
  v_functions t_str_list;
  v_operators t_str_list;
  v_attr_count NUMBER := 0;
  v_func_count NUMBER := 0;
  v_oper_count NUMBER := 0;

  TYPE t_token_rec IS RECORD (
    token VARCHAR2(4000),
    start_pos PLS_INTEGER,
    end_pos PLS_INTEGER
  );
  TYPE t_token_tab IS TABLE OF t_token_rec INDEX BY PLS_INTEGER;
  v_tokens t_token_tab;
  v_token_count PLS_INTEGER := 0;

  TYPE t_token_tab_nt IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
  v_unmatched_tokens t_token_tab;
  v_unmatched_count PLS_INTEGER := 0;

  -- To mark tokens consumed by multi-word operators
  TYPE t_bool_tab IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;
  v_token_consumed t_bool_tab;

  v_mode CHAR := UPPER(p_mode);

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
  FUNCTION is_in_list(p_token VARCHAR2, p_list t_str_list, cnt NUMBER) RETURN BOOLEAN IS
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

  PROCEDURE load_functions(p_list OUT t_str_list, p_count OUT NUMBER) IS
  BEGIN
    p_list.DELETE;
    p_count := 0;
    FOR r IN (
      SELECT return_value FROM apex_application_lov_entries
      WHERE list_of_values_name = 'UR EXPRESSION FUNCTIONS'
      ORDER BY return_value
    ) LOOP
      p_count := p_count + 1;
      p_list(p_count) := normalize_func_name(r.return_value);
    END LOOP;
    IF p_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20010, 'Functions LOV missing or empty');
    END IF;
  END;

  PROCEDURE load_operators(p_list OUT t_str_list, p_count OUT NUMBER) IS
  BEGIN
    p_list.DELETE;
    p_count := 0;
    FOR r IN (
      SELECT return_value FROM apex_application_lov_entries
      WHERE list_of_values_name = 'UR EXPRESSION OPERATORS'
      ORDER BY return_value
    ) LOOP
      p_count := p_count + 1;
      p_list(p_count) := UPPER(TRIM(r.return_value));
    END LOOP;
    IF p_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20011, 'Operators LOV missing or empty');
    END IF;
  END;

  PROCEDURE load_attributes(p_hotel_id IN VARCHAR2, p_list OUT t_str_list, p_count OUT NUMBER) IS
  BEGIN
    p_list.DELETE;
    p_count := 0;
    FOR r IN (
      SELECT key FROM ur_algo_attributes WHERE hotel_id = p_hotel_id
    ) LOOP
      p_count := p_count + 1;
      p_list(p_count) := UPPER(TRIM(r.key));
    END LOOP;
    IF p_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20012, 'Attributes missing for hotel_id ' || p_hotel_id);
    END IF;
  END;

  -- Tokenizer splitting expression into tokens, tracking start/end pos
  PROCEDURE tokenize_expression(p_expr IN VARCHAR2, p_tokens OUT t_token_tab, p_count OUT NUMBER) IS
    l_pos PLS_INTEGER := 1;
    l_len PLS_INTEGER := LENGTH(p_expr);
    l_token VARCHAR2(4000);
    l_token_start PLS_INTEGER;
    l_token_end PLS_INTEGER;
  BEGIN
    p_tokens.DELETE;
    p_count := 0;
    WHILE l_pos <= l_len LOOP
      l_token := REGEXP_SUBSTR(p_expr,
        '([A-Za-z0-9_\.]+|\d+(\.\d+)?|\(|\)|\S)',
        l_pos,
        1,
        'i');
      EXIT WHEN l_token IS NULL;
      l_token_start := INSTR(p_expr, l_token, l_pos);
      l_token_end := l_token_start + LENGTH(l_token) - 1;
      p_count := p_count + 1;
      p_tokens(p_count) := t_token_rec(token => l_token, start_pos => l_token_start, end_pos => l_token_end);
      l_pos := l_token_end + 1;
      WHILE l_pos <= l_len AND SUBSTR(p_expr, l_pos, 1) = ' ' LOOP
        l_pos := l_pos + 1;
      END LOOP;
    END LOOP;
  END;

  FUNCTION build_json_errors(p_unmatched t_token_tab, p_count PLS_INTEGER) RETURN VARCHAR2 IS
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
    combined VARCHAR2(4000);
    max_words CONSTANT PLS_INTEGER := 4; -- max operator words count
    words_count PLS_INTEGER;
    l_len PLS_INTEGER := LEAST(max_words, v_token_count - start_idx + 1);
    i PLS_INTEGER;
  BEGIN
    FOR words_count IN REVERSE 1 .. l_len LOOP
      combined := '';
      FOR i IN start_idx .. start_idx + words_count - 1 LOOP
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
  p_status := 'E';
  p_message := NULL;

  IF v_mode NOT IN ('V', 'C') THEN
    p_status := 'E';
    p_message := 'Invalid mode "' || p_mode || '". Valid are V or C.';
    RETURN;
  END IF;

  IF p_hotel_id IS NULL THEN
    p_status := 'E';
    p_message := 'hotel_id is mandatory';
    RETURN;
  END IF;

  IF p_expression IS NULL OR LENGTH(TRIM(p_expression)) = 0 THEN
    p_status := 'E';
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
    i PLS_INTEGER := 1;
    words_matched PLS_INTEGER := 0;
  BEGIN
    WHILE i <= v_token_count LOOP
      words_matched := get_longest_operator_match(i);
      IF words_matched > 0 THEN
        FOR j IN i .. i + words_matched - 1 LOOP
          v_token_consumed(j) := TRUE;
        END LOOP;
        i := i + words_matched;
      ELSE
        -- Single token valid check
        v_token_consumed(i) := is_token_valid(normalize_token(v_tokens(i).token));
        i := i + 1;
      END IF;
    END LOOP;
  END;

  IF v_mode = 'V' THEN
    v_unmatched_tokens.DELETE;
    v_unmatched_count := 0;
    FOR i IN 1 .. v_token_count LOOP
      IF v_token_consumed.EXISTS(i) AND v_token_consumed(i) = FALSE THEN
        v_unmatched_count := v_unmatched_count + 1;
        v_unmatched_tokens(v_unmatched_count) := v_tokens(i);
      END IF;
    END LOOP;

    IF v_unmatched_count > 0 THEN
      p_status := 'E';
      p_message := 'Invalid tokens: ' || build_json_errors(v_unmatched_tokens, v_unmatched_count);
    ELSE
      p_status := 'S';
      p_message := 'Expression validated successfully.';
    END IF;

  ELSIF v_mode = 'C' THEN
    p_status := 'S';
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
    p_status := 'E';
    p_message := 'Failure: ' || SQLERRM;
END validate_expression;


END UR_UTILS_TEST_1;
/
create or replace PACKAGE BODY XXPEL_A001_FEEDBACK AS

  FUNCTION get_profile_value(p_key VARCHAR2) RETURN VARCHAR2 IS
    v_return_value VARCHAR2(4000);
  BEGIN
    SELECT VALUE INTO v_return_value FROM XXPEL_WF_GLOBAL_PROFILES_TBL WHERE KEY = p_key;
    RETURN v_return_value;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_profile_value;

  PROCEDURE SUBMIT_FEEDBACK(
    p_feedback       IN VARCHAR2,
    p_rating         IN VARCHAR2,
    p_new_type       IN VARCHAR2,
    p_summary        IN VARCHAR2,
    p_description    IN VARCHAR2,
    p_page_id        IN NUMBER,
    p_app_id         IN NUMBER,
    p_app_user       IN VARCHAR2
  ) IS
    L_FEEDBACK_ID     NUMBER;
    L_EMAIL_login     VARCHAR2(2000);
    L_EMAIL           VARCHAR2(2000);
    L_EMAIL_ENABLE    VARCHAR2(2000);
    L_CLOB            CLOB;
    L_JIRA_PAYLOAD    CLOB;
    L_ISSUE_KEY       VARCHAR2(100);
    L_ISSUE_URL       VARCHAR2(4000);
    L_JIRA_URL        VARCHAR2(4000);
    L_JIRA_USERNAME   VARCHAR2(2000);
    L_JIRA_API_TOKEN  VARCHAR2(4000);
    L_EMAIL_FROM      VARCHAR2(4000);
    L_NEW_TYPE        VARCHAR2(100) := NVL(p_new_type, 'Feedback');
    L_SUMMARY         VARCHAR2(4000) := p_summary;
    L_DESCRIPTION     VARCHAR2(4000) := p_description;
    
    L_JIRA_BROWSE_URL VARCHAR2(4000);
     L_feedback_type VARCHAR2(4000);
BEGIN
 /*   IF p_new_type IS NULL THEN
      L_DESCRIPTION := p_feedback;
      L_SUMMARY := p_rating;
    END IF;*/
SELECT DECODE(p_new_type,2,'Bug',3,'Enhancement Request','Feedback') INTO L_feedback_type
 from dual;
    L_EMAIL := get_profile_value('FEEDBACK_EMAIL_ADDR');
    L_EMAIL_ENABLE := get_profile_value('ENABLE_FEEDBACK_EMAIL');
    L_JIRA_URL := get_profile_value('JIRA_API_URL');
    L_JIRA_USERNAME := get_profile_value('JIRA_USERNAME');
    L_JIRA_API_TOKEN := get_profile_value('JIRA_API_TOKEN');
    L_EMAIL_FROM := get_profile_value('EMAIL_FROM_ADDR');
    L_JIRA_BROWSE_URL := get_profile_value('JIRA_BROWSE_URL');

    BEGIN
    --  SELECT 'sahilmagdum@projecteidos.com' INTO L_EMAIL_login FROM dual;
      SELECT EMAIL
      INTO L_EMAIL_login FROM ur_users WHERE upper(USER_NAME) =  upper(v('app_user'));
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        L_EMAIL_login := 'unknown@yourdomain.com';
    END;

    apex_util.submit_feedback(
      p_comment        => p_feedback,
      p_application_id => p_app_id,
      p_page_id        => p_page_id,
      p_rating         => p_rating,
      p_ATTRIBUTE_01   => L_feedback_type,
      p_ATTRIBUTE_02   => L_SUMMARY,
      p_ATTRIBUTE_03   => L_DESCRIPTION,
      p_ATTRIBUTE_04   => L_FEEDBACK_ID
    );

    -- JIRA integration
    IF L_feedback_type IN ('Bug', 'Enhancement Request') THEN
      L_JIRA_PAYLOAD := '{
        "fields": {
          "project": {"key": "FOUR"},
          "summary": "' || REPLACE(L_SUMMARY, '"', '\"') || ' - Feedback Ref: ' || L_FEEDBACK_ID || '",
          "description": {
            "type": "doc",
            "version": 1,
            "content": [{
              "type": "paragraph",
              "content": [
                {"type": "text", "text": "Type: ' || L_feedback_type || '"}, {"type": "hardBreak"},
                {"type": "text", "text": "Feedback Ref: ' || L_FEEDBACK_ID || '"}, {"type": "hardBreak"},
                {"type": "text", "text": "Raised by: ' || L_EMAIL_login || '"}, {"type": "hardBreak"},
                {"type": "text", "text": "Description: ' || REPLACE(L_DESCRIPTION, '"', '\"') || '"}
              ]
            }]
          },
          "issuetype": {"name": "' || L_feedback_type || '"}
        }
      }';

      apex_web_service.g_request_headers(1).name := 'Content-Type';
      apex_web_service.g_request_headers(1).value := 'application/json';

      L_CLOB := apex_web_service.make_rest_request(
        p_url => L_JIRA_URL,
        p_http_method => 'POST',
        p_username => L_JIRA_USERNAME,
        p_password => L_JIRA_API_TOKEN,
        p_body => L_JIRA_PAYLOAD
      );

      apex_json.parse(L_CLOB);
      L_ISSUE_KEY := apex_json.get_varchar2(p_path => 'key');
      L_ISSUE_URL := L_JIRA_URL || L_ISSUE_KEY;
    END IF;

    -- Email to feedback submitter
    apex_mail.send(
      p_from => L_EMAIL_FROM,
      p_to => L_EMAIL_login,
      p_subj => 'Your feedback has been submitted - Ref: ' || L_FEEDBACK_ID,
      p_body => 'Your ' || L_feedback_type || ' request has been submitted. Summary: ' || L_SUMMARY,
      p_body_html =>
        'Hi,<br><br>Your feedback has been submitted.<br><br>' ||
        'Summary: ' || L_SUMMARY || '<br>' ||
        'Description: ' || L_DESCRIPTION || 
        CASE WHEN L_ISSUE_KEY IS NOT NULL THEN '<br>JIRA Issue: <a href="' || L_ISSUE_URL || '" target="_blank">' || L_ISSUE_KEY || '</a>' ELSE '' END ||
        '<br><br>Regards,<br>Workforce Management Team'
    );
    apex_mail.push_queue;

    -- Email to internal team / managers if email enabled & configured
    IF NVL(UPPER(L_EMAIL_ENABLE),'N') = 'Y' AND L_EMAIL IS NOT NULL THEN
      apex_mail.send(
        p_from => L_EMAIL_FROM,
        p_to => L_EMAIL,
        p_subj => 'A new ' || L_feedback_type || ' has been raised for Workforce - Ref: ' || L_FEEDBACK_ID,
        p_body => 'Your ' || L_feedback_type || ' request has been submitted. Summary: ' || L_SUMMARY,
        p_body_html =>
          'Hi,<br><br>A new ' || L_feedback_type || ' has been raised.<br><br>' ||
          'Summary: ' || L_SUMMARY || '<br>' ||
          'Description: ' || L_DESCRIPTION || '<br>' ||
          'Requestor: ' || L_EMAIL_login || 
          CASE WHEN L_ISSUE_KEY IS NOT NULL THEN '<br>JIRA Issue: <a href="' || L_ISSUE_URL || '" target="_blank">' || L_ISSUE_KEY || '</a>' ELSE '' END ||
          '<br><br>Please review accordingly.<br><br>Regards,<br>Workforce Management Team'
      );
      apex_mail.push_queue;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
END SUBMIT_FEEDBACK;

END XXPEL_A001_FEEDBACK;
/






















































































 