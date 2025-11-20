DECLARE
  v_json       CLOB;
  v_ok         VARCHAR2(1);
  v_msg        VARCHAR2(4000);
  v_key        VARCHAR2(4000);
  v_exists     NUMBER;
  v_alerts     CLOB := NULL;
  v_val_status VARCHAR2(1); -- New variable for validation status
  v_def_ok     BOOLEAN;
  v_def_msg    VARCHAR2(4000);
  v_view_ok    BOOLEAN;
  v_view_msg   VARCHAR2(4000);
  -- Separate variables for manage_algo_attributes
  v_algo_ok    BOOLEAN;
  v_algo_msg   VARCHAR2(4000);
BEGIN
  ur_utils.get_collection_json('UR_FILE_DATA_PROFILES', v_json, v_ok, v_msg);

  IF v_ok = 'E' THEN
    ur_utils.add_alert(v_alerts, v_msg, 'error', NULL, NULL, v_alerts);
    :P0_ALERT_MESSAGE := v_alerts;
    RETURN;
  END IF;

  -- Call the new validation procedure
  ur_utils.VALIDATE_TEMPLATE_DEFINITION(
      p_json_clob  => v_json,
      p_alert_clob => v_alerts,
      p_status     => v_val_status
  );

  -- Check the status returned by the procedure
  IF v_val_status = 'E' THEN
    :P0_ALERT_MESSAGE := v_alerts;
    RETURN;
  END IF;

  v_key := ur_utils.Clean_TEXT(:P1001_TEMPLATE_NAME);
  SELECT COUNT(*) INTO v_exists FROM UR_TEMPLATES WHERE KEY = v_key;

  IF v_exists > 0 THEN
    ur_utils.add_alert(v_alerts, 'Template key "' || v_key || '" already exists.', 'warning', NULL, NULL, v_alerts);
    :P0_ALERT_MESSAGE := v_alerts;
    RETURN;
  END IF;

  INSERT INTO UR_TEMPLATES (KEY, NAME, Hotel_ID, TYPE, ACTIVE, DEFINITION)
  VALUES (v_key, :P1001_TEMPLATE_NAME, :P0_HOTEL_ID, :P1001_TEMPLATE_TYPE, 'Y', v_json);
  COMMIT;

  ur_utils.define_db_object(v_key, v_def_ok, v_def_msg);

  IF v_def_ok THEN
    ur_utils.add_alert(v_alerts, v_def_msg, 'success', NULL, NULL, v_alerts);
  ELSE
    ur_utils.add_alert(v_alerts, v_def_msg, 'error', NULL, NULL, v_alerts);
  END IF;

  IF apex_collection.collection_exists('UR_FILE_DATA_PROFILES') THEN
    apex_collection.delete_collection('UR_FILE_DATA_PROFILES');
  END IF;

  ---------------------------------------------------------------------------
  -- RST -> create ranking view first, then attributes
  -- non-RST -> only attributes
  ---------------------------------------------------------------------------
  IF :P1001_TEMPLATE_TYPE = 'RST' THEN

    -- use view vars for create_ranking_view
    ur_utils.create_ranking_view(v_key, v_view_ok, v_view_msg);

    IF v_view_ok THEN
      ur_utils.add_alert(v_alerts, v_view_msg, 'success', NULL, NULL, v_alerts);
      COMMIT;
    ELSE
      ur_utils.add_alert(v_alerts, 'Ranking view failed: ' || v_view_msg, 'warning', NULL, NULL, v_alerts);
      -- stop further processing for RST if view creation failed (matches earlier behaviour)
      :P0_ALERT_MESSAGE := v_alerts;
      RETURN;
    END IF;

    -- after successful view creation, create algo attributes (use algo vars)
    ur_utils.manage_algo_attributes(v_key, 'C', NULL, v_algo_ok, v_algo_msg);
    IF v_algo_ok THEN
      ur_utils.add_alert(v_alerts, v_algo_msg, 'success', NULL, NULL, v_alerts);
    ELSE
      ur_utils.add_alert(v_alerts, v_algo_msg, 'error', NULL, NULL, v_alerts);
    END IF;

  ELSE
    -- Non-RST: directly create algo attributes (use algo vars)
    ur_utils.manage_algo_attributes(v_key, 'C', NULL, v_algo_ok, v_algo_msg);
    IF v_algo_ok THEN
      ur_utils.add_alert(v_alerts, v_algo_msg, 'success', NULL, NULL, v_alerts);
    ELSE
      ur_utils.add_alert(v_alerts, v_algo_msg, 'error', NULL, NULL, v_alerts);
    END IF;
  END IF;

  ---------------------------------------------------------------------------
  -- finalize
  ---------------------------------------------------------------------------
  :P0_ALERT_MESSAGE := v_alerts;
  :P1001_FILE_LOAD := NULL;

EXCEPTION
  WHEN OTHERS THEN
    apex_debug.message('Ex: ' || SQLERRM);
    ur_utils.add_alert(v_alerts, SQLERRM, 'error', NULL, NULL, v_alerts);
    :P0_ALERT_MESSAGE := v_alerts;
    RAISE;
END;
/
