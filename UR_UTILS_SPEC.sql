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

  -- ============================================================================
  -- CALCULATED ATTRIBUTES: Template-agnostic computed attributes
  -- ============================================================================
  -- Helper functions for calculated attribute evaluation
  FUNCTION safe_to_number(p_value IN VARCHAR2) RETURN NUMBER;

  FUNCTION safe_divide(p_numerator IN NUMBER, p_denominator IN NUMBER) RETURN NUMBER;

  FUNCTION evaluate_expression(p_expression IN VARCHAR2) RETURN NUMBER;

  FUNCTION get_events_for_date(p_hotel_id IN RAW, p_stay_date IN DATE) RETURN VARCHAR2;

  FUNCTION validate_calculated_formula(
    p_formula        IN VARCHAR2,
    p_attribute_key  IN VARCHAR2 DEFAULT NULL
  ) RETURN VARCHAR2;

  FUNCTION has_circular_dependency(
    p_attribute_key  IN VARCHAR2,
    p_formula        IN VARCHAR2,
    p_visited        IN VARCHAR2 DEFAULT NULL,
    p_depth          IN NUMBER DEFAULT 0
  ) RETURN BOOLEAN;

  -- Manage calculated (TYPE='C') attributes
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
  );

  -- Create predefined calculated attributes for a new hotel
  PROCEDURE create_hotel_calculated_attributes(
    p_hotel_id  IN  RAW,
     p_mode      IN varchar2,
    p_status    OUT BOOLEAN,
    p_message   OUT VARCHAR2
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


    -- ============================================================================
    -- DATE PARSER: Comprehensive date format detection and parsing
    -- ============================================================================
    -- Purpose: Unified procedure for date format detection (DETECT mode),
    --          date parsing (PARSE mode), and testing (TEST mode).
    --          Supports ~80 date formats, handles special values, resolves
    --          DD/MM vs MM/DD ambiguity, and provides confidence scoring.
    --
    -- Modes:
    --   'DETECT' - Detect date format from sample values (JSON array)
    --   'PARSE'  - Parse a single date string using specified format
    --   'TEST'   - Run internal test suite
    --
    -- For P1002 (Template Creation): Use DETECT mode to identify format mask
    -- For P1010 (Data Loading): Use PARSE mode with stored format mask
    -- ============================================================================
    PROCEDURE date_parser (
        -- MODE CONTROL
        p_mode             IN  VARCHAR2,              -- 'DETECT', 'PARSE', 'TEST'

        -- INPUT PARAMETERS (mode-dependent)
        p_file_id          IN  NUMBER   DEFAULT NULL, -- For DETECT: file to sample from
        p_column_position  IN  NUMBER   DEFAULT NULL, -- For DETECT: column position in file
        p_sample_values    IN  CLOB     DEFAULT NULL, -- For DETECT: JSON array of samples (alternative to file)
        p_date_string      IN  VARCHAR2 DEFAULT NULL, -- For PARSE: single date string
        p_format_mask      IN  VARCHAR2 DEFAULT NULL, -- For PARSE: format to use
        p_start_date       IN  DATE     DEFAULT NULL, -- For PARSE: year inference reference
        p_min_confidence   IN  NUMBER   DEFAULT 90,   -- Minimum confidence threshold

        -- CONTROL PARAMETERS
        p_debug_flag       IN  VARCHAR2 DEFAULT 'N',  -- 'Y' enables debug logging
        p_alert_clob       IN OUT NOCOPY CLOB,        -- Alert compliance (JSON alerts)

        -- OUTPUT PARAMETERS
        p_format_mask_out  OUT VARCHAR2,              -- Detected/used format
        p_confidence       OUT NUMBER,                -- Confidence score (0-100)
        p_converted_date   OUT DATE,                  -- Parsed date (PARSE mode)
        p_has_year         OUT VARCHAR2,              -- 'Y'/'N' - format includes year
        p_is_ambiguous     OUT VARCHAR2,              -- 'Y'/'N' - DD/MM vs MM/DD uncertain
        p_special_values   OUT VARCHAR2,              -- Comma-separated special values
        p_all_formats      OUT CLOB,                  -- JSON array of all matching formats
        p_status           OUT VARCHAR2,              -- 'S'/'E'/'W'
        p_message          OUT VARCHAR2               -- Status message (includes debug log if enabled)
    );

    -- Simple format detection (returns format mask only)
    FUNCTION detect_date_format_simple (
        p_sample_values IN CLOB
    ) RETURN VARCHAR2 DETERMINISTIC;

    -- Safe date parsing (returns NULL on failure)
    FUNCTION parse_date_safe (
        p_value       IN VARCHAR2,
        p_format_mask IN VARCHAR2,
        p_start_date  IN DATE DEFAULT NULL
    ) RETURN DATE DETERMINISTIC;

    -- Backend testing procedure
    PROCEDURE test_date_parser (
        p_test_type    IN  VARCHAR2 DEFAULT 'ALL',  -- 'ALL', 'PREPROCESS', 'DETECT', 'PARSE'
        p_debug_flag   IN  VARCHAR2 DEFAULT 'Y',
        p_result_json  OUT CLOB,
        p_status       OUT VARCHAR2,
        p_message      OUT VARCHAR2
    );

    -- ============================================================================
    -- PROCEDURE: refresh_file_profile_and_collection
    -- ============================================================================
    -- Purpose: Refresh file profile and populate APEX collection for template creation
    -- Used by: P1002 (Templates v2) when skip_rows or sheet_name changes
    -- ============================================================================
    PROCEDURE refresh_file_profile_and_collection (
        p_file_name             IN  VARCHAR2,
        p_skip_rows             IN  NUMBER   DEFAULT 0,
        p_sheet_name            IN  VARCHAR2 DEFAULT NULL,
        p_collection_name       IN  VARCHAR2 DEFAULT 'UR_FILE_DATA_PROFILES',
        p_status                OUT VARCHAR2,
        p_message               OUT VARCHAR2
    );

END ur_utils;
/