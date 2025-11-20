DECLARE
  v_json CLOB; v_sanitized_json CLOB; v_alerts CLOB := NULL;
  v_ok VARCHAR2(1); v_msg VARCHAR2(4000); v_key VARCHAR2(4000);
  v_val_status VARCHAR2(1); v_san_status VARCHAR2(1); v_san_msg VARCHAR2(4000);
  v_exists NUMBER; v_def_ok BOOLEAN; v_def_msg VARCHAR2(4000);
  v_view_ok BOOLEAN; v_view_msg VARCHAR2(4000);
  v_algo_ok BOOLEAN; v_algo_msg VARCHAR2(4000);
BEGIN
  ur_utils.get_collection_json('UR_FILE_DATA_PROFILES', v_json, v_ok, v_msg);
  IF v_ok = 'E' THEN
    ur_utils.add_alert(v_alerts, v_msg, 'error', NULL, NULL, v_alerts);
    :P0_ALERT_MESSAGE := v_alerts; RETURN;
  END IF;

  ur_utils.VALIDATE_TEMPLATE_DEFINITION(v_json, v_alerts, v_val_status);
  IF v_val_status = 'E' THEN :P0_ALERT_MESSAGE := v_alerts; RETURN; END IF;

  ur_utils.sanitize_template_definition(v_json, 'COL', v_sanitized_json, v_san_status, v_san_msg);
  IF v_san_status = 'E' THEN
    ur_utils.add_alert(v_alerts, v_san_msg, 'error', NULL, NULL, v_alerts);
    :P0_ALERT_MESSAGE := v_alerts; RETURN;
  ELSIF v_san_status IN ('S','W') AND INSTR(v_san_msg, 'Sanitized 0') = 0 THEN
    ur_utils.add_alert(v_alerts, v_san_msg, 'success', NULL, NULL, v_alerts);
  END IF;

  v_key := ur_utils.Clean_TEXT(:P1001_TEMPLATE_NAME);
  SELECT COUNT(*) INTO v_exists FROM UR_TEMPLATES WHERE KEY = v_key;
  IF v_exists > 0 THEN
    ur_utils.add_alert(v_alerts, 'Template key "' || v_key || '" already exists.', 'warning', NULL, NULL, v_alerts);
    :P0_ALERT_MESSAGE := v_alerts; RETURN;
  END IF;

  INSERT INTO UR_TEMPLATES (KEY, NAME, Hotel_ID, TYPE, ACTIVE, DEFINITION)
  VALUES (v_key, :P1001_TEMPLATE_NAME, :P0_HOTEL_ID, :P1001_TEMPLATE_TYPE, 'Y', v_sanitized_json);
  COMMIT;

  ur_utils.define_db_object(v_key, v_def_ok, v_def_msg);
  ur_utils.add_alert(v_alerts, v_def_msg, CASE WHEN v_def_ok THEN 'success' ELSE 'error' END, NULL, NULL, v_alerts);

  IF apex_collection.collection_exists('UR_FILE_DATA_PROFILES') THEN
    apex_collection.delete_collection('UR_FILE_DATA_PROFILES');
  END IF;

  IF :P1001_TEMPLATE_TYPE = 'RST' THEN
    ur_utils.create_ranking_view(v_key, v_view_ok, v_view_msg);
    IF v_view_ok THEN
      ur_utils.add_alert(v_alerts, v_view_msg, 'success', NULL, NULL, v_alerts);
      COMMIT;
    ELSE
      ur_utils.add_alert(v_alerts, 'Ranking view failed: ' || v_view_msg, 'warning', NULL, NULL, v_alerts);
      :P0_ALERT_MESSAGE := v_alerts; RETURN;
    END IF;
  END IF;

  ur_utils.manage_algo_attributes(v_key, 'C', NULL, v_algo_ok, v_algo_msg);
  ur_utils.add_alert(v_alerts, v_algo_msg, CASE WHEN v_algo_ok THEN 'success' ELSE 'error' END, NULL, NULL, v_alerts);

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
