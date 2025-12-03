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