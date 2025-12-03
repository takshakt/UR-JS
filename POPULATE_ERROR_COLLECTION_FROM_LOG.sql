create or replace PROCEDURE POPULATE_ERROR_COLLECTION_FROM_LOG (
    p_interface_log_id IN  UR_INTERFACE_LOGS.ID%TYPE,
    p_collection_name  IN  VARCHAR2,
    p_status           OUT VARCHAR2,
    p_message          OUT VARCHAR2
)
IS
    l_error_json       CLOB;
    l_errors_count     NUMBER := 0;
    l_warnings_count   NUMBER := 0;
    l_total_count      NUMBER := 0;
    l_is_new_format    BOOLEAN := FALSE;
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

    -- Step 6: Determine JSON format and populate the collection
    -- New format: {"errors":[...],"warnings":[...]}
    -- Legacy format: [{row:1,error:"..."},...]

    -- Check if this is the new nested format by looking for "errors" key
    l_errors_count := APEX_JSON.GET_COUNT(p_path => 'errors');
    l_warnings_count := APEX_JSON.GET_COUNT(p_path => 'warnings');

    IF l_errors_count IS NOT NULL OR l_warnings_count IS NOT NULL THEN
        -- New format detected
        l_is_new_format := TRUE;
        l_errors_count := NVL(l_errors_count, 0);
        l_warnings_count := NVL(l_warnings_count, 0);

        -- Process errors array
        -- Collection columns: c001=row, c002=message, c003=line, c004=status, c005=data_issues
        FOR i IN 1..l_errors_count LOOP
            APEX_COLLECTION.ADD_MEMBER(
                p_collection_name => p_collection_name,
                p_c001            => APEX_JSON.GET_VARCHAR2(p_path => 'errors[%d].row', p0 => i),
                p_c002            => APEX_JSON.GET_VARCHAR2(p_path => 'errors[%d].error', p0 => i),
                p_c003            => APEX_JSON.GET_VARCHAR2(p_path => 'errors[%d].line', p0 => i),
                p_c004            => NVL(APEX_JSON.GET_VARCHAR2(p_path => 'errors[%d].status', p0 => i), 'ERROR'),
                p_c005            => APEX_JSON.GET_VARCHAR2(p_path => 'errors[%d].data_issues', p0 => i)
            );
        END LOOP;

        -- Process warnings array
        -- Collection columns: c001=row, c002=details, c003=line, c004=status, c005=null
        FOR i IN 1..l_warnings_count LOOP
            APEX_COLLECTION.ADD_MEMBER(
                p_collection_name => p_collection_name,
                p_c001            => APEX_JSON.GET_VARCHAR2(p_path => 'warnings[%d].row', p0 => i),
                p_c002            => APEX_JSON.GET_VARCHAR2(p_path => 'warnings[%d].details', p0 => i),
                p_c003            => APEX_JSON.GET_VARCHAR2(p_path => 'warnings[%d].line', p0 => i),
                p_c004            => NVL(APEX_JSON.GET_VARCHAR2(p_path => 'warnings[%d].status', p0 => i), 'WARNING'),
                p_c005            => NULL
            );
        END LOOP;

        l_total_count := l_errors_count + l_warnings_count;

    ELSE
        -- Legacy format: simple array at root level
        l_total_count := APEX_JSON.GET_COUNT(p_path => '.');
        l_total_count := NVL(l_total_count, 0);

        FOR i IN 1..l_total_count LOOP
            -- Legacy format: c001=row, c002=error, c004=ERROR (default status)
            APEX_COLLECTION.ADD_MEMBER(
                p_collection_name => p_collection_name,
                p_c001            => APEX_JSON.GET_VARCHAR2(p_path => '[%d].row', p0 => i),
                p_c002            => APEX_JSON.GET_VARCHAR2(p_path => '[%d].error', p0 => i),
                p_c003            => NULL,
                p_c004            => 'ERROR',
                p_c005            => NULL
            );
        END LOOP;

        l_errors_count := l_total_count;
    END IF;

    IF l_total_count > 0 THEN
        p_status  := 'S';
        IF l_is_new_format THEN
            p_message := 'Success: Collection ''' || p_collection_name || ''' populated with '
                         || l_errors_count || ' error(s) and ' || l_warnings_count || ' warning(s).';
        ELSE
            p_message := 'Success: Collection ''' || p_collection_name || ''' has been populated with '
                         || l_total_count || ' error(s).';
        END IF;
    ELSE
        -- No errors or warnings found
        p_status  := 'W';
        p_message := 'Warning: The error log contains no errors or warnings. The collection is empty.';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- A final catch-all for any other unexpected Oracle errors.
        p_status  := 'E';
        p_message := 'An unexpected system error occurred: ' || SQLERRM;
END POPULATE_ERROR_COLLECTION_FROM_LOG;
/