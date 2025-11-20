CREATE OR REPLACE PACKAGE ur_utils AS

    -- ============================================================================
    -- FUNCTION: sanitize_reserved_words
    -- ============================================================================
    FUNCTION sanitize_reserved_words(
        p_column_name IN VARCHAR2,
        p_suffix      IN VARCHAR2 DEFAULT 'COL'
    ) RETURN VARCHAR2;

    -- ============================================================================
    -- PROCEDURE: sanitize_template_definition
    -- ============================================================================
    PROCEDURE sanitize_template_definition(
        p_definition_json IN  CLOB,
        p_suffix          IN  VARCHAR2 DEFAULT 'COL',
        p_sanitized_json  OUT CLOB,
        p_status          OUT VARCHAR2,
        p_message         OUT VARCHAR2
    );

    -- ============================================================================
    -- PROCEDURE: POPULATE_ERROR_COLLECTION_FROM_LOG
    -- ============================================================================
    PROCEDURE POPULATE_ERROR_COLLECTION_FROM_LOG(
        p_interface_log_id IN  UR_INTERFACE_LOGS.ID%TYPE,
        p_collection_name  IN  VARCHAR2,
        p_status           OUT VARCHAR2,
        p_message          OUT VARCHAR2
    );

    -- ============================================================================
    -- PROCEDURE: VALIDATE_TEMPLATE_DEFINITION
    -- ============================================================================
    PROCEDURE VALIDATE_TEMPLATE_DEFINITION(
        p_json_clob  IN            CLOB,
        p_alert_clob IN OUT NOCOPY CLOB,
        p_status     OUT           VARCHAR2
    );

    -- ============================================================================
    -- FUNCTION: GET_ATTRIBUTE_VALUE (Pipelined)
    -- ============================================================================
    FUNCTION GET_ATTRIBUTE_VALUE(
        p_attribute_id   IN RAW      DEFAULT NULL,
        p_attribute_key  IN VARCHAR2 DEFAULT NULL,
        p_hotel_id       IN RAW      DEFAULT NULL,
        p_stay_date      IN DATE     DEFAULT NULL,
        p_round_digits   IN NUMBER   DEFAULT 2
    ) RETURN UR_attribute_value_table PIPELINED;

    -- ============================================================================
    -- PROCEDURE: build_json_response
    -- ============================================================================
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
    );

    -- ============================================================================
    -- PROCEDURE: GET_ATTRIBUTE_VALUE (Main)
    -- ============================================================================
    PROCEDURE GET_ATTRIBUTE_VALUE(
        p_attribute_id  IN  RAW      DEFAULT NULL,
        p_attribute_key IN  VARCHAR2 DEFAULT NULL,
        p_hotel_id      IN  RAW      DEFAULT NULL,
        p_stay_date     IN  DATE     DEFAULT NULL,
        p_round_digits  IN  NUMBER   DEFAULT 2,
        p_debug_flag    IN  BOOLEAN  DEFAULT FALSE,
        p_response_clob OUT CLOB
    );

    -- ============================================================================
    -- FUNCTION: Clean_TEXT
    -- ============================================================================
    FUNCTION Clean_TEXT(
        p_text IN VARCHAR2
    ) RETURN VARCHAR2;

    -- ============================================================================
    -- FUNCTION: normalize_json
    -- ============================================================================
    FUNCTION normalize_json(
        p_json CLOB
    ) RETURN CLOB;

    -- ============================================================================
    -- PROCEDURE: get_collection_json
    -- ============================================================================
    PROCEDURE get_collection_json(
        p_collection_name IN  VARCHAR2,
        p_json_clob       OUT CLOB,
        p_status          OUT VARCHAR2,
        p_message         OUT VARCHAR2
    );

    -- ============================================================================
    -- PROCEDURE: define_db_object
    -- ============================================================================
    PROCEDURE define_db_object(
        p_template_key IN  VARCHAR2,
        p_status       OUT BOOLEAN,
        p_message      OUT VARCHAR2,
        p_mode         IN  VARCHAR2 DEFAULT 'N'
    );

    -- ============================================================================
    -- PROCEDURE: create_ranking_view
    -- ============================================================================
    PROCEDURE create_ranking_view(
        p_template_key IN  VARCHAR2,
        p_status       OUT BOOLEAN,
        p_message      OUT VARCHAR2
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

    -- ============================================================================
    -- PROCEDURE: Load_Data
    -- ============================================================================
    PROCEDURE Load_Data(
        p_file_id         IN  NUMBER,
        p_template_key    IN  VARCHAR2,
        p_hotel_id        IN  RAW,
        p_collection_name IN  VARCHAR2,
        p_status          OUT BOOLEAN,
        p_message         OUT VARCHAR2
    );

    -- ============================================================================
    -- PROCEDURE: fetch_templates
    -- ============================================================================
    -- ✨ UPDATED: Added p_use_original_name and p_match_datatype parameters
    --
    -- Purpose: Match and score templates based on field definitions
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
    PROCEDURE fetch_templates(
        p_file_id           IN  NUMBER,
        p_hotel_id          IN  VARCHAR2,
        p_min_score         IN  NUMBER   DEFAULT 90,
        p_debug_flag        IN  VARCHAR2 DEFAULT 'N',
        p_use_original_name IN  VARCHAR2 DEFAULT 'AUTO',
        p_match_datatype    IN  VARCHAR2 DEFAULT 'Y',
        p_output_json       OUT CLOB,
        p_status            OUT VARCHAR2,
        p_message           OUT VARCHAR2
    );

    -- ============================================================================
    -- PROCEDURE: DELETE_TEMPLATES
    -- ============================================================================
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
    );

    -- ============================================================================
    -- PROCEDURE: manage_algo_attributes
    -- ============================================================================
    PROCEDURE manage_algo_attributes(
        p_template_key   IN  VARCHAR2,
        p_mode           IN  CHAR,
        p_attribute_key  IN  VARCHAR2 DEFAULT NULL,
        p_status         OUT BOOLEAN,
        p_message        OUT VARCHAR2
    );

    -- ============================================================================
    -- PROCEDURE: add_alert
    -- ============================================================================
    PROCEDURE add_alert(
        p_existing_json IN  CLOB,
        p_message       IN  VARCHAR2,
        p_icon          IN  VARCHAR2 DEFAULT NULL,
        p_title         IN  VARCHAR2 DEFAULT NULL,
        p_timeout       IN  NUMBER   DEFAULT NULL,
        p_updated_json  OUT CLOB
    );

    -- ============================================================================
    -- PROCEDURE: validate_expression
    -- ============================================================================
    PROCEDURE validate_expression(
        p_expression IN  VARCHAR2,
        p_mode       IN  CHAR,
        p_hotel_id   IN  VARCHAR2,
        p_status     OUT VARCHAR2,
        p_message    OUT VARCHAR2
    );

END ur_utils;
/
