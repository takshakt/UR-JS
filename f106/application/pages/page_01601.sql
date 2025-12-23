prompt --application/pages/page_01601
begin
--   Manifest
--     PAGE: 01601
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>25186177142438240
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_page.create_page(
 p_id=>1601
,p_name=>'Interface Dashboard'
,p_alias=>'INTERFACE-DASHBOARD'
,p_step_title=>'Interface Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function callProcess(processName) {',
'  return new Promise(function(resolve, reject) {',
'    let hotelId = $v(''P0_HOTEL_ID'');',
'',
'    // Normalize: treat empty string as NULL',
'    if (!hotelId || hotelId.trim() === '''') {',
'      hotelId = null;',
'    }',
'',
'    apex.server.process(',
'      processName,',
'      { x01: hotelId },',
'      { success: resolve, error: reject }',
'    );',
'  });',
'}',
'',
'// ---- Helper: Make Bar Chart ----',
'function makeBar(ctx, labels, dataset) {',
'  return new Chart(ctx, {',
'    type: ''bar'',',
'    data: { ',
'      labels: labels, ',
'      datasets: [ dataset ] ',
'    },',
'    options: { ',
'      responsive: true, ',
'      maintainAspectRatio: false,',
'      plugins: { legend: { position: ''top'' } },',
'      scales: { y: { beginAtZero: true } }',
'    }',
'  });',
'}',
'',
'// ---- Helper: Make Line Chart ----',
'function makeLine(ctx, labels, datasets, optionsExtra) {',
'  return new Chart(ctx, {',
'    type: ''line'',',
'    data: { labels: labels, datasets: datasets },',
'    options: Object.assign({',
'      responsive: true,',
'      maintainAspectRatio: false,',
'      plugins: { legend: { position: ''top'' } },',
'      scales: { y: { beginAtZero: true } }',
'    }, optionsExtra || {})',
'  });',
'}',
'',
'function loadDashboard() {',
'  Promise.all([',
'    callProcess(''GET_CARD_TOTAL''),',
'    callProcess(''GET_CARD_SUCCESS''),',
'    callProcess(''GET_CARD_FAILED''),',
'    callProcess(''GET_CARD_INPROGRESS_1''),',
'    callProcess(''GET_CARD_PENDING''),',
'    callProcess(''GET_CHART_DAILY_STATUS''),',
'    callProcess(''GET_CHART_TOP_TEMPLATES''),',
'    callProcess(''GET_CHART_FAILURE_PERCENTAGE''),',
'    callProcess(''GET_CHART_FREQ''),',
'    callProcess(''GET_CHART_HOTEL_SUCCESS'')',
'  ]).then(function(results) {',
'    try {',
'      // ---- Cards ----',
'      $(''#val-total'').text((results[0] && results[0].value) || 0);',
'      $(''#val-success'').text((results[1] && results[1].value) || 0);',
'      $(''#val-failed'').text((results[2] && results[2].value) || 0);',
'    //--  $(''#val-inprogress'').text((results[3] && results[3].value) || 0);',
'if (results[3]) {',
'  const success = results[3].success || 0;',
'  const total = results[3].value || 0;',
'',
'  // Update separate spans',
'  $(''#val-success-rows'').text(success);',
'  $(''#val-total-rows'').text(total);',
'}',
'',
'      $(''#val-pending'').text(',
'       results[4] && results[4].value !== undefined',
'         ? results[4].value + ''s'' // seconds',
'         : ''0s''',
'    );',
'',
'',
'    // ---- Chart 6: Daily Status ----',
'    (function() {',
'      var payload = results[5] || [];',
'      var labels  = payload.map(r => r.load_date);',
'      var success = payload.map(r => r.successful_count);',
'      var failed  = payload.map(r => r.failed_count);',
'      var ctx = document.getElementById(''chart-daily'').getContext(''2d'');',
'      makeLine(ctx, labels, [',
'        { label: ''Success'', data: success, borderWidth: 2, fill: false, tension: 0.3 },',
'        { label: ''Failed'',  data: failed,  borderWidth: 2, fill: false, tension: 0.3 }',
'      ]);',
'    })();',
'',
'    // ---- Chart 7: Top Templates ----',
'    (function() {',
'      var payload = results[6] || [];',
'      var labels  = payload.map(r => r.template_name);',
'      var totals  = payload.map(r => r.total_records);',
'      var ctx = document.getElementById(''chart-templates'').getContext(''2d'');',
'      makeBar(ctx, labels, { label: ''Records'', data: totals, borderRadius: 6, barPercentage: 0.7 });',
'    })();',
'',
'    // ---- Chart 8: Failure % ----',
'    (function() {',
'      var payload = results[7] || [];',
'      var labels  = payload.map(r => r.template_name);',
'      var pct     = payload.map(r => r.failure_percentage);',
'      var ctx = document.getElementById(''chart-template-fail'').getContext(''2d'');',
'      makeBar(ctx, labels, { label: ''Failure %'', data: pct });',
'    })();',
'',
'// ---- Chart 9: Template Usage Frequency ----',
'(function() {',
'  var payload = results[8] || [];',
'  if (!payload || payload.length === 0) {',
'    console.warn("No data available for Template Usage Frequency chart");',
unistr('    return; // don\2019t try to render'),
'  }',
'',
'  var labels = payload.map(r => r.template_name);',
'  var counts = payload.map(r => r.usage_count);',
'',
'  var ctx = document.getElementById(''chart-usage-frequency'').getContext(''2d'');',
'  new Chart(ctx, {',
'    type: ''pie'',',
'    data: {',
'      labels: labels,',
'      datasets: [{',
'        label: ''Usage Count'',',
'        data: counts,',
'        backgroundColor: [',
'          ''#FF6384'', ''#36A2EB'', ''#FFCE56'', ''#4BC0C0'',',
'          ''#9966FF'', ''#FF9F40'', ''#66FF66'', ''#FF6666'',',
'          ''#6699FF'', ''#FFCC99''',
'        ]',
'      }]',
'    },',
'    options: {',
'      responsive: true,',
'      maintainAspectRatio: false,',
'      plugins: {',
'        legend: { position: ''bottom'' },',
'        title: {',
'          display: true,',
'          text: ''Template Usage Frequency''',
'        }',
'      }',
'    }',
'  });',
'})();',
'',
'    // ---- Chart 10: Hotel Success % ----',
'    (function() {',
'      var payload = results[9] || [];',
'      var labels  = payload.map(r => r.hotel_name);',
'      var pct     = payload.map(r => r.success_percentage);',
'      var ctx = document.getElementById(''chart-hotel-success'').getContext(''2d'');',
'      makeBar(ctx, labels, { label: ''Success %'', data: pct });',
'    })();',
'',
'    } catch(e) {',
'      console.error(''Dashboard render error:'', e);',
'      alert(''Error rendering dashboard: '' + e.message);',
'    }',
'  }).catch(function(err) {',
'    console.error(''AJAX error:'', err);',
'    alert(''Failed to load dashboard data. Check console for details.'');',
'  });',
'}',
'// Load dashboard once when page is ready',
'loadDashboard();',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15037252385055035)
,p_plug_name=>'Full Region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(12885615709327143)
,p_plug_name=>'Main Region'
,p_parent_plug_id=>wwv_flow_imp.id(15037252385055035)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<!-- Dashboard HTML -->',
'<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap">',
'<div id="iface-dashboard" class="iface-dashboard">',
'  <div class="iface-left">',
'    <div class="iface-cards">',
'      <div class="iface-card" id="card-total">',
'        <div class="card-title">Total Runs (24h)</div>',
unistr('        <div class="card-value" id="val-total">\2014</div>'),
'        <div class="card-sub">since yesterday</div>',
'      </div>',
'      <div class="iface-card" id="card-success">',
'        <div class="card-title">Success (24h)</div>',
unistr('        <div class="card-value" id="val-success">\2014</div>'),
'        <div class="card-sub">successful runs</div>',
'      </div>',
'      <div class="iface-card" id="card-failed">',
'        <div class="card-title">Failures (24h)</div>',
unistr('        <div class="card-value" id="val-failed">\2014</div>'),
'        <div class="card-sub">failed runs</div>',
'      </div>',
'<div class="iface-card" id="card-records">',
'  <div class="card-title">Records Processed (24h)</div>',
'',
'  <div class="card-value" id="val-inprogress">',
'    <span id="val-success-rows">0</span> | <span id="val-total-rows">0</span>',
'  </div>',
'',
'  <div class="card-sub">',
'    <span>successful rows</span> | <span>total rows</span>',
'  </div>',
'</div>',
'',
'      <div class="iface-card" id="card-avg">',
'        <div class="card-title">Avg Duration (sec)</div>',
unistr('        <div class="card-value" id="val-pending">\2014</div>'),
'        <div class="card-sub">average run time</div>',
'      </div>',
'      ',
'    </div>',
'',
'    <div class="iface-charts">',
'      <div class="chart-card">',
'        <div class="chart-title">Daily: Success vs Failed (7 days)</div>',
'        <canvas id="chart-daily"></canvas>',
'      </div>',
'',
'      <div class="chart-row">',
'        <div class="chart-card">',
'          <div class="chart-title">Top Templates by Records</div>',
'          <canvas id="chart-templates"></canvas>',
'        </div>',
'        <div class="chart-card">',
'          <div class="chart-title">Template Failures (%)</div>',
'          <canvas id="chart-template-fail"></canvas>',
'        </div>',
'      </div>',
'',
'      <div class="chart-row">',
'        <div class="chart-card">',
'          <div class="chart-title">Top Usage Frequency</div>',
'          <canvas id="chart-usage-frequency"></canvas>',
'        </div>',
'        <div class="chart-card">',
'          <div class="chart-title">Hotel Success % (Top 10)</div>',
'          <canvas id="chart-hotel-success"></canvas>',
'        </div>',
'      </div>',
'    </div>',
'  </div>',
'</div>',
'',
'<style>',
'#iface-dashboard { font-family: ''Inter'', sans-serif; padding: 18px; background:#f4fbff; border-radius:10px; }',
'.iface-cards { display: grid; grid-template-columns: repeat(5, 1fr); gap: 12px; margin-bottom:18px; }',
'.iface-card { background: white; border-radius: 10px; padding: 14px; box-shadow: 0 6px 18px rgba(0,0,0,0.06); text-align:center; }',
'.card-title { font-size: 13px; color:#6c7a89; margin-bottom:6px; }',
'.card-value { font-size: 26px; font-weight:700; color:#0b6b6b; }',
'.card-sub { font-size:12px; color:#99a0a6; margin-top:6px; }',
'',
'.iface-charts .chart-card { background:white; padding:12px; border-radius:10px; box-shadow: 0 6px 18px rgba(0,0,0,0.04); margin-bottom:12px; }',
'.chart-title { font-weight:600; margin-bottom:8px; color:#334e52; }',
'.chart-row { display:flex; gap:12px; }',
'.chart-row > .chart-card { flex:1; }',
'',
'canvas { width:100% !important; height:260px !important; }',
'@media (max-width:1100px) {',
'  .iface-cards { grid-template-columns: repeat(2,1fr); }',
'  .chart-row { flex-direction: column; }',
'}',
'</style>',
'',
'<!-- Chart.js CDN -->',
'<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(14353600952988347)
,p_plug_name=>'IG Region'
,p_parent_plug_id=>wwv_flow_imp.id(15037252385055035)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    UIL.ID,',
'    UIL.HOTEL_ID,',
'    UH.HOTEL_NAME,',
'    UT.NAME AS TEMPLATE_NAME,  ',
'    U.FIRST_NAME || '' '' || U.LAST_NAME AS FULL_NAME,',
'    UIL.LOAD_START_TIME,',
'    UIL.LOAD_END_TIME,',
'    UIL.LOAD_MAPPING,',
'    UIL.LOAD_STATUS,',
'    UIL.RECORDS_PROCESSED,',
'    UIL.RECORDS_SUCCESSFUL,',
'    UIL.RECORDS_FAILED,',
'    UIL.FILE_ID,',
'    UIL.ERROR_JSON',
'FROM UR_INTERFACE_LOGS UIL',
'LEFT JOIN UR_HOTELS UH ON UIL.HOTEL_ID = UH.ID',
'LEFT JOIN UR_TEMPLATES UT ON UIL.TEMPLATE_ID = UT.ID',
'LEFT JOIN UR_USERS U ON UIL.CREATED_BY = U.USER_ID',
'WHERE (',
'       :P0_HOTEL_ID IS NULL',
'       OR TRIM(:P0_HOTEL_ID) = ''''',
'       OR :P0_HOTEL_ID = ''FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF''',
'       OR UIL.HOTEL_ID IN (',
'            SELECT HEXTORAW(TRIM(column_value))',
'            FROM TABLE(apex_string.split(:P0_HOTEL_ID, '',''))',
'            WHERE REGEXP_LIKE(TRIM(column_value), ''^[0-9A-Fa-f]{32}$'')',
'       )',
')',
''))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P0_HOTEL_ID'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14353863484988349)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'ID'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>10
,p_value_alignment=>'LEFT'
,p_link_target=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.::P4_INTERFACE_ID_1,P4_ERROR_JSON_1,P4_HOTEL_NAME_1:&ID.,&ERROR_JSON.,&HOTEL_NAME.'
,p_link_text=>'&P4_INTERFACE_ID.'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(14353969439988350)
,p_name=>'HOTEL_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HOTEL_ID'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>20
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15034097924055003)
,p_name=>'LOAD_START_TIME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOAD_START_TIME'
,p_data_type=>'TIMESTAMP'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Load Start Time'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15034146832055004)
,p_name=>'LOAD_END_TIME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOAD_END_TIME'
,p_data_type=>'TIMESTAMP'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Load End Time'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15034278453055005)
,p_name=>'LOAD_MAPPING'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOAD_MAPPING'
,p_data_type=>'CLOB'
,p_session_state_data_type=>'CLOB'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>160
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15034322304055006)
,p_name=>'LOAD_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LOAD_STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Load Status'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>20
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15034404496055007)
,p_name=>'RECORDS_PROCESSED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECORDS_PROCESSED'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Records Processed'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15034590801055008)
,p_name=>'RECORDS_SUCCESSFUL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECORDS_SUCCESSFUL'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Records Successful'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15034620646055009)
,p_name=>'RECORDS_FAILED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECORDS_FAILED'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Records Failed'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15035278504055015)
,p_name=>'FILE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FILE_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>140
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15035380655055016)
,p_name=>'ERROR_JSON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ERROR_JSON'
,p_data_type=>'CLOB'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Error JSON '
,p_heading_alignment=>'LEFT'
,p_display_sequence=>150
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>false
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15036362601055026)
,p_name=>'HOTEL_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HOTEL_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Hotel Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>100
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15036912750055032)
,p_name=>'TEMPLATE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TEMPLATE_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Template Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>100
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(15037181540055034)
,p_name=>'FULL_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FULL_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'User Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>170
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>201
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(14353777569988348)
,p_internal_uid=>14353777569988348
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>true
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(15039632743057523)
,p_interactive_grid_id=>wwv_flow_imp.id(14353777569988348)
,p_static_id=>'150397'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(15039861424057524)
,p_report_id=>wwv_flow_imp.id(15039632743057523)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(60983563045044)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(15036912750055032)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15040351319057531)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(14353863484988349)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15041239352057536)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(14353969439988350)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15043842824057549)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(15034097924055003)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15044717288057553)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(15034146832055004)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15045684790057558)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(15034278453055005)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15046572840057562)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(15034322304055006)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15047468945057566)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(15034404496055007)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15048363405057570)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(15034590801055008)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15049203908057575)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(15034620646055009)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15051093960057583)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(15035278504055015)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15051916591057587)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(15035380655055016)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15117372912890244)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(15036362601055026)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(15395380856655884)
,p_view_id=>wwv_flow_imp.id(15039861424057524)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(15037181540055034)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15694395767538894)
,p_plug_name=>'Breadcrumb'
,p_title=>'Interface Dashboard'
,p_parent_plug_id=>wwv_flow_imp.id(25697469516364507)
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>20
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(8558440305922134)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(15035580429055018)
,p_name=>'P1601_HOTEL_LIST'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(15037252385055035)
,p_prompt=>'Hotel List'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT NVL(hotel_name, ''Name'') AS display_value,',
'       RAWTOHEX(id)            AS return_value',
'  FROM ur_hotels',
'WHERE nvl(ASSOCIATION_END_DATE,sysdate) >= sysdate',
''))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- FULL DASHBOARD --'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(34125482179226717)
,p_name=>'P1601_ALERT_MESSAGE'
,p_item_sequence=>20
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14716527145561134)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1601_FILE_LOAD'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14717040162561135)
,p_event_id=>wwv_flow_imp.id(14716527145561134)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14717455189561136)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1601_TEMPLATE_LOV'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14717928807561138)
,p_event_id=>wwv_flow_imp.id(14717455189561136)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'BEGIN',
'  -- Insert the template',
'  INSERT INTO UR_TEMPLATES (',
'    KEY,',
'    NAME,',
'    TYPE,',
'    ACTIVE,',
'    DEFINITION,',
'    CREATED_BY,',
'    CREATED_ON,',
'    UPDATED_BY,',
'    UPDATED_ON',
'  ) VALUES (',
'    ''EXP_TEMPLATE_''|| ROUND(',
'    (CAST(SYSTIMESTAMP AT TIME ZONE ''UTC'' AS DATE) - DATE ''1970-01-01'') * 86400',
'  ),',
'    ''Expense Template ''|| ROUND(',
'    (CAST(SYSTIMESTAMP AT TIME ZONE ''UTC'' AS DATE) - DATE ''1970-01-01'') * 86400',
'  ),',
'    ''RMS'',',
'    ''Y'',  -- or hardcode ''ADMIN''',
'    ''[{"name":"EMPLOYEE_NAME","data-type":1,"data-type-len":100,"selector":"Employee Name","is-json":false},{"name":"EXPENSE_ID","data-type":2,"selector":"Expense Id","is-json":false},{"name":"EXP_TYPE","data-type":1,"data-type-len":50,"selector":"Ex'
||'p Type","is-json":false},{"name":"PROJECT_NAME","data-type":1,"data-type-len":100,"selector":"Project Name","is-json":false},{"name":"EXPENSE_PURPOSE","data-type":1,"data-type-len":50,"selector":"Expense Purpose","is-json":false},{"name":"EXPENSE_DAT'
||'E_FROM","data-type":3,"selector":"Expense Date From","format-mask":"DD\"-\"MON\"-\"RR","is-json":false},{"name":"EXPENSE_DATE_TO","data-type":3,"selector":"Expense Date To","format-mask":"DD\"-\"MON\"-\"RR","is-json":false},{"name":"STATUS","data-typ'
||'e":1,"data-type-len":50,"selector":"Status","is-json":false},{"name":"CURRENCY","data-type":1,"data-type-len":50,"selector":"Currency","is-json":false},{"name":"CLAIM_AMOUNT","data-type":2,"selector":"Claim Amount","is-json":false},{"name":"EXPENSE_A'
||'TTACHMENT","data-type":2,"selector":"Expense Attachment","is-json":false},{"name":"EXPENSE_COMMENT","data-type":1,"data-type-len":32767,"selector":"Expense Comment","is-json":false},{"name":"CREATED_BY","data-type":1,"data-type-len":50,"selector":"Cr'
||'eated By","is-json":false},{"name":"CREATION_DATE","data-type":3,"selector":"Creation Date","format-mask":"YYYY\"-\"MM\"-\"DD\" \"HH24\":\"MI\":\"SS","is-json":false},{"name":"LAST_UPDATED_BY","data-type":1,"data-type-len":50,"selector":"Last Updated'
||' By","is-json":false},{"name":"LAST_UPDATE_DATE","data-type":3,"selector":"Last Update Date","format-mask":"YYYY\"-\"MM\"-\"DD\" \"HH24\":\"MI\":\"SS","is-json":false}]'',',
'    ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP,',
'        ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP',
'  );',
'END;',
''))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14718291363561139)
,p_name=>'Page_Load_DA'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14716111223561133)
,p_name=>'Refresh Hotel'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1601_HOTEL_LIST,P0_HOTEL_ID'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15035638920055019)
,p_event_id=>wwv_flow_imp.id(14716111223561133)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(14353600952988347)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15036762514055030)
,p_event_id=>wwv_flow_imp.id(14716111223561133)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15036424300055027)
,p_event_id=>wwv_flow_imp.id(14716111223561133)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(15037252385055035)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14715275519561131)
,p_name=>'New_3'
,p_event_sequence=>90
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'body'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'showAlert'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14715725022561132)
,p_event_id=>wwv_flow_imp.id(14715275519561131)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var title = $v(''P1601_ALERT_TITLE'') || ''Notification'';',
'var message = $v(''P1601_ALERT_MESSAGE'');',
'var icon  = $v(''P1601_ALERT_ICON'') || ''success'';',
'',
'if(message){',
'  Swal.fire({',
'    position: ''top-end'',',
'    icon: icon,',
'    title: title,',
'    text: message,',
'    showConfirmButton: false,',
'    timer: 2500',
'  });',
'  ',
'  $s(''P1601_ALERT_MESSAGE'','''');',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(14718685906561140)
,p_name=>'Changed'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1601_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14719175221561141)
,p_event_id=>wwv_flow_imp.id(14718685906561140)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P1001_ALERT_MESSAGE");  // get the string from hidden page item',
'',
'if (messagesJson) {',
'  try {',
'    // Try parsing the string',
'    var parsed = JSON.parse(messagesJson);',
'',
'    // Check if parsed result is array or object',
'    if (Array.isArray(parsed)) {',
'      // It''s an array - pass as is',
'      showAlertToastr(parsed);',
'    } else if (parsed && typeof parsed === ''object'') {',
'      // Single object - pass it wrapped in array for consistency ',
'      showAlertToastr([parsed]);',
'    } else {',
unistr('      // Parsed to something else (string/number) \2014 just pass original string'),
'      showAlertToastr(messagesJson);',
'    }',
'  } catch (e) {',
unistr('    // Parsing failed \2014 probably plain text, pass as is'),
'    showAlertToastr(messagesJson);',
'  }',
'}'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14714879459561129)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_json CLOB;',
'BEGIN',
'  l_json := UR_utils.get_collection_json(''UR_FILE_DATA_PROFILES'');',
'',
'  INSERT INTO UR_TEMPLATES (',
'    KEY,',
'    NAME,',
'    TYPE,',
'    ACTIVE,',
'    DEFINITION,',
'    CREATED_BY,',
'    CREATED_ON,',
'    UPDATED_BY,',
'    UPDATED_ON',
'  ) VALUES (',
'    UPPER(',
'      SUBSTR(',
'        REGEXP_REPLACE(',
'          REGEXP_REPLACE(',
'            REGEXP_REPLACE(',
'              TRIM(:P1601_TEMPLATE_NAME),',
'              ''^[^A-Za-z0-9]+|[^A-Za-z0-9]+$'', ''''',
'            ),',
'            ''[^A-Za-z0-9]+'', ''_''',
'          ),',
'          ''_+'', ''_''',
'        ),',
'        1, 110',
'      )',
'    ),',
'    :P1601_TEMPLATE_NAME,',
'    :P1601_TEMPLATE_TYPE,',
'    ''Y'',  -- or hardcode ''ADMIN''',
'    l_json,',
'    ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP,',
'    ''3AB2E656C7307FD1E063DD59000A5850'',',
'    SYSTIMESTAMP',
'  );',
'',
'  apex_debug.message(''Debug info: '' || l_json);',
'  ',
'  apex_pwa.send_push_notification (',
'    p_application_id => 103,',
'    p_user_name      => ''VKANT'',',
'    p_title          => ''Template Created Successfully.'',',
'    p_body           => ''Order #123456 will arrive within 3 days.'' );',
'',
'--   :P1601_AI_RESPONSE := ''Insert Successful'';',
'apex_pwa.push_queue;',
'-- RETURN ''SUCCESS'';',
'',
'--   apex.message.showToast(',
'--     pMessage => ''Changes saved'',',
'--     pPosition => ''top-right'',   -- or ''top-left'', ''bottom-right'', ''bottom-left''',
'--     pDuration => 3000,          -- milliseconds; 0 means sticky until closed',
'--     pCloseIcon => true,         -- show a close (x) icon',
'--     pStyle => ''success''         -- values: ''success'', ''warning'', ''error'', ''information''',
'--   );',
'',
'-- apex_application.g_print_success_message := ''Record saved successfully!'';',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    -- :P1601_AI_RESPONSE := ''Insert Failed: '' || SQLERRM;',
'    apex_debug.message(''Insert Failed: '' || SQLERRM);',
'    -- RETURN ''Failed ''||SQLERRM;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Blah blah blah'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Succesfully Done'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>14714879459561129
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14352484123988335)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CARD_TOTAL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_total NUMBER;',
'  l_hotel_id RAW(16);',
'BEGIN',
'  l_hotel_id := apex_application.g_x01;',
'',
'  SELECT COUNT(*)',
'  INTO l_total',
'  FROM UR_INTERFACE_LOGS',
'  WHERE LOAD_START_TIME >= SYSDATE - 1',
'    AND (l_hotel_id IS NULL OR HOTEL_ID = l_hotel_id);',
'',
'  apex_json.open_object;',
'  apex_json.write(''value'', NVL(l_total, 0));',
'  apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>14352484123988335
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14352675320988337)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CARD_SUCCESS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_total NUMBER;',
'  l_hotel_id RAW(16);',
'BEGIN',
'  l_hotel_id := apex_application.g_x01;',
'',
'  SELECT COUNT(*)',
'  INTO l_total',
'  FROM UR_INTERFACE_LOGS',
'  WHERE LOAD_STATUS = ''SUCCESS''',
'    AND LOAD_START_TIME >= SYSDATE - 1',
'    AND (l_hotel_id IS NULL OR HOTEL_ID = l_hotel_id);',
'',
'  apex_json.open_object;',
'  apex_json.write(''value'', NVL(l_total, 0));',
'  apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>14352675320988337
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14352746274988338)
,p_process_sequence=>40
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CARD_FAILED'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_total     NUMBER;',
'  l_hotel_id  RAW(16);',
'BEGIN',
'  l_hotel_id := apex_application.g_x01;',
'',
'  SELECT COUNT(*)',
'    INTO l_total',
'    FROM UR_INTERFACE_LOGS',
'   WHERE LOAD_START_TIME >= SYSDATE - 1',
'     AND (',
'           LOAD_STATUS = ''FAILED''',
'           OR (',
'                LOAD_STATUS = ''IN_PROGRESS''',
'                AND LOAD_START_TIME < SYSDATE - (1/24)  -- older than 1 hour',
'              )',
'         )',
'     AND (l_hotel_id IS NULL OR HOTEL_ID = l_hotel_id);',
'',
'  apex_json.open_object;',
'  apex_json.write(''value'', NVL(l_total, 0));',
'  apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>14352746274988338
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14352818473988339)
,p_process_sequence=>50
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CARD_INPROGRESS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_total NUMBER;',
'  l_hotel_id RAW(16);',
'BEGIN',
'  l_hotel_id := apex_application.g_x01;',
'',
'  SELECT COUNT(*)',
'  INTO l_total',
'  FROM UR_INTERFACE_LOGS',
'  WHERE LOAD_STATUS = ''IN_PROGRESS''',
'    AND LOAD_START_TIME >= SYSDATE - 1',
'    AND (l_hotel_id IS NULL OR HOTEL_ID = l_hotel_id);',
'',
'  apex_json.open_object;',
'  apex_json.write(''value'', NVL(l_total, 0));',
'  apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>14352818473988339
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(17725396030370802)
,p_process_sequence=>60
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CARD_INPROGRESS_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_total       NUMBER := 0;',
'    l_success     NUMBER := 0;',
'    l_hotel_id    RAW(16);',
'BEGIN',
'    l_hotel_id := apex_application.g_x01;',
'',
'    -- Total records processed in last 24h',
'    SELECT NVL(SUM(RECORDS_PROCESSED), 0)',
'      INTO l_total',
'      FROM UR_INTERFACE_LOGS',
'     WHERE LOAD_START_TIME >= SYSDATE - 1',
'       AND (l_hotel_id IS NULL OR HOTEL_ID = l_hotel_id);',
'',
'    -- Successful records processed in last 24h',
'    SELECT NVL(SUM(RECORDS_SUCCESSFUL), 0)',
'      INTO l_success',
'      FROM UR_INTERFACE_LOGS',
'     WHERE LOAD_START_TIME >= SYSDATE - 1',
'       AND (l_hotel_id IS NULL OR HOTEL_ID = l_hotel_id);',
'',
'    apex_json.open_object;',
'    apex_json.write(''value'', l_total);      -- total processed rows',
'    apex_json.write(''success'', l_success);  -- successfully processed rows',
'    apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>17725396030370802
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14352995841988340)
,p_process_sequence=>70
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CARD_PENDING'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_hotel_id RAW(16);',
'    l_avg_seconds NUMBER;',
'BEGIN',
'    -- Get hotel ID passed from JS',
'    l_hotel_id := apex_application.g_x01;',
'',
'    SELECT AVG(',
'             EXTRACT(DAY    FROM (LOAD_END_TIME - LOAD_START_TIME)) * 86400 +',
'             EXTRACT(HOUR   FROM (LOAD_END_TIME - LOAD_START_TIME)) * 3600 +',
'             EXTRACT(MINUTE FROM (LOAD_END_TIME - LOAD_START_TIME)) * 60 +',
'             EXTRACT(SECOND FROM (LOAD_END_TIME - LOAD_START_TIME))',
'           )',
'      INTO l_avg_seconds',
'      FROM UR_INTERFACE_LOGS',
'     WHERE LOAD_END_TIME IS NOT NULL',
'       AND LOAD_START_TIME >= SYSDATE - 1',
'       AND (l_hotel_id IS NULL OR HOTEL_ID = l_hotel_id);',
'',
'    apex_json.open_object;',
'    apex_json.write(''value'', NVL(ROUND(l_avg_seconds, 0), 0)); -- return as number of seconds',
'    apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>14352995841988340
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14353062198988341)
,p_process_sequence=>90
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CHART_DAILY_STATUS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_hotel_id RAW(16);',
'BEGIN',
'    -- Read hotel_id from x01 (passed from JS)',
'    l_hotel_id := apex_application.g_x01;',
'',
'    apex_json.open_array; -- Return as JSON array',
'    FOR rec IN (',
'        SELECT TRUNC(LOAD_START_TIME) AS load_date,',
'               COUNT(CASE WHEN load_status = ''SUCCESS'' THEN 1 END) AS successful_count,',
'               COUNT(CASE WHEN load_status != ''SUCCESS'' AND load_status != ''IN_PROGRESS'' THEN 1 END) AS failed_count',
'        FROM UR_INTERFACE_LOGS',
'        WHERE LOAD_START_TIME >= SYSDATE - 7',
'          AND (l_hotel_id IS NULL OR HOTEL_ID = l_hotel_id)',
'        GROUP BY TRUNC(LOAD_START_TIME)',
'        ORDER BY TRUNC(LOAD_START_TIME)',
'    )',
'    LOOP',
'        apex_json.open_object;',
'        apex_json.write(''load_date'', TO_CHAR(rec.load_date, ''YYYY-MM-DD''));',
'        apex_json.write(''successful_count'', rec.successful_count);',
'        apex_json.write(''failed_count'', rec.failed_count);',
'        apex_json.close_object;',
'    END LOOP;',
'    apex_json.close_array;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>14353062198988341
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14353137314988342)
,p_process_sequence=>100
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CHART_TOP_TEMPLATES'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_hotel_id RAW(16);',
'BEGIN',
'    l_hotel_id := apex_application.g_x01;',
'',
'    apex_json.open_array;',
'    FOR rec IN (',
'        SELECT t.NAME AS template_name,',
'               SUM(l.RECORDS_PROCESSED) AS total_records',
'        FROM UR_INTERFACE_LOGS l',
'        JOIN UR_TEMPLATES t ON l.TEMPLATE_ID = t.ID',
'        WHERE l_hotel_id IS NULL OR l.HOTEL_ID = l_hotel_id',
'        GROUP BY t.NAME',
'        ORDER BY total_records DESC',
'        FETCH FIRST 10 ROWS ONLY',
'    )',
'    LOOP',
'        apex_json.open_object;',
'        apex_json.write(''template_name'', rec.template_name);',
'        apex_json.write(''total_records'', rec.total_records);',
'        apex_json.close_object;',
'    END LOOP;',
'    apex_json.close_array;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>14353137314988342
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14353213320988343)
,p_process_sequence=>110
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CHART_FAILURE_PERCENTAGE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_hotel_id RAW(16);',
'BEGIN',
'    l_hotel_id := apex_application.g_x01;',
'',
'    apex_json.open_array;',
'    FOR rec IN (',
'        SELECT t.NAME AS template_name,',
'               SUM(l.RECORDS_FAILED) AS total_failed,',
'               COUNT(*) AS total_runs,',
'               ROUND((SUM(l.RECORDS_FAILED) / NULLIF(SUM(l.RECORDS_PROCESSED),0)) * 100, 2) AS failure_percentage',
'        FROM UR_INTERFACE_LOGS l',
'        JOIN UR_TEMPLATES t ON l.TEMPLATE_ID = t.ID',
'        WHERE l.RECORDS_PROCESSED > 0',
'          AND (l_hotel_id IS NULL OR l.HOTEL_ID = l_hotel_id)',
'        GROUP BY t.NAME',
'        ORDER BY failure_percentage DESC',
'        FETCH FIRST 10 ROWS ONLY',
'    )',
'    LOOP',
'        apex_json.open_object;',
'        apex_json.write(''template_name'', rec.template_name);',
'        apex_json.write(''total_failed'', rec.total_failed);',
'        apex_json.write(''total_runs'', rec.total_runs);',
'        apex_json.write(''failure_percentage'', rec.failure_percentage);',
'        apex_json.close_object;',
'    END LOOP;',
'    apex_json.close_array;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>14353213320988343
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(15036881172055031)
,p_process_sequence=>120
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CHART_FREQ'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_hotel_id RAW(16);',
'BEGIN',
'    -- Read hotel_id from x01 (passed from JS)',
'    l_hotel_id := apex_application.g_x01;',
'',
'    apex_json.open_array;',
'    FOR rec IN (',
'        SELECT t.NAME AS template_name,',
'               COUNT(l.ID) AS usage_count',
'        FROM UR_INTERFACE_LOGS l',
'        JOIN UR_TEMPLATES t ON l.TEMPLATE_ID = t.ID',
'        WHERE l_hotel_id IS NULL OR l.HOTEL_ID = l_hotel_id',
'        GROUP BY t.NAME',
'        ORDER BY usage_count DESC',
'    )',
'    LOOP',
'        apex_json.open_object;',
'        apex_json.write(''template_name'', rec.template_name);',
'        apex_json.write(''usage_count'', rec.usage_count);',
'        apex_json.close_object;',
'    END LOOP;',
'    apex_json.close_array;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>15036881172055031
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14353435548988345)
,p_process_sequence=>130
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CHART_HOTEL_SUCCESS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_hotel_id RAW(16);',
'BEGIN',
'    l_hotel_id := apex_application.g_x01;',
'',
'    apex_json.open_array;',
'    FOR rec IN (',
'        SELECT h.HOTEL_NAME,',
'               ROUND((SUM(CASE WHEN l.LOAD_STATUS = ''SUCCESS'' THEN 1 ELSE 0 END) / COUNT(l.id)) * 100, 2) AS success_percentage',
'        FROM UR_INTERFACE_LOGS l',
'        JOIN UR_HOTELS h ON l.HOTEL_ID = h.ID',
'        WHERE l_hotel_id IS NULL OR l.HOTEL_ID = l_hotel_id',
'        GROUP BY h.HOTEL_NAME',
'        ORDER BY success_percentage DESC',
'        FETCH FIRST 10 ROWS ONLY',
'    )',
'    LOOP',
'        apex_json.open_object;',
'        apex_json.write(''hotel_name'', rec.hotel_name);',
'        apex_json.write(''success_percentage'', rec.success_percentage);',
'        apex_json.close_object;',
'    END LOOP;',
'    apex_json.close_array;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>14353435548988345
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14353395150988344)
,p_process_sequence=>140
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_CHART_TOP_ERRORS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'BEGIN',
'  apex_json.open_array;',
'  FOR rec IN (',
'    SELECT error_message,',
'           error_count',
'    FROM (',
'      SELECT JSON_VALUE(ERROR_JSON, ''$.error.message'') AS error_message,',
'             COUNT(*) AS error_count',
'      FROM UR_INTERFACE_LOGS',
'      WHERE ERROR_JSON IS NOT NULL',
'      GROUP BY JSON_VALUE(ERROR_JSON, ''$.error.message'')',
'      ORDER BY error_count DESC',
'    )',
'    FETCH FIRST 10 ROWS ONLY',
'  )',
'  LOOP',
'    apex_json.open_object;',
'    apex_json.write(''error_message'', rec.error_message);',
'    apex_json.write(''error_count'', rec.error_count);',
'    apex_json.close_object;',
'  END LOOP;',
'  apex_json.close_array;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>14353395150988344
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14714478600561128)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_profile_clob CLOB;',
'  v_records NUMBER;',
'  v_columns CLOB;',
'',
'  -- Variables for parsing v_columns JSON',
'  CURSOR cur_columns IS',
'    SELECT jt.name, jt.data_type',
'      FROM JSON_TABLE(',
'             v_columns,',
'             ''$[*]''',
'             COLUMNS (',
'               name VARCHAR2(100) PATH ''$.name'',',
'               data_type VARCHAR2(20) PATH ''$."data-type"''',
'             )',
'           ) jt;',
'',
'BEGIN',
'  -- Create or truncate APEX collection before processing',
'  IF apex_collection.collection_exists(''UR_FILE_DATA_PROFILES'') THEN',
'    apex_collection.delete_collection(''UR_FILE_DATA_PROFILES'');',
'  END IF;',
'  ',
'  apex_collection.create_collection(''UR_FILE_DATA_PROFILES'');',
'',
'  FOR r IN (',
'    SELECT ID, APPLICATION_ID, NAME, FILENAME, MIME_TYPE, CREATED_ON, BLOB_CONTENT',
'      FROM APEX_APPLICATION_TEMP_FILES',
'     WHERE NAME = :P1601_FILE_LOAD',
'  ) LOOP',
'    INSERT INTO temp_BLOB (',
'      ID,',
'      APPLICATION_ID,',
'      NAME,',
'      FILENAME,',
'      MIME_TYPE,',
'      CREATED_ON,',
'      BLOB_CONTENT',
'    ) VALUES (',
'      r.ID,',
'      r.APPLICATION_ID,',
'      r.NAME,',
'      r.FILENAME,',
'      r.MIME_TYPE,',
'      r.CREATED_ON,',
'      r.BLOB_CONTENT',
'    );',
'  END LOOP;',
'',
'  FOR rec IN (',
'    SELECT ID, BLOB_CONTENT, filename, name',
'      FROM temp_BLOB',
'     WHERE profile IS NULL -- only parse if profile not yet loaded',
'  ) LOOP',
'    -- Call APEX_DATA_PARSER.GET_FILE_PROFILE on the blob content',
'    SELECT apex_data_parser.discover(',
'             p_content => rec.BLOB_CONTENT,',
'             p_file_name => rec.filename',
'           )',
'      INTO v_profile_clob',
'      FROM dual;',
'',
'    -- Extract "parsed-rows"',
'    SELECT TO_NUMBER(JSON_VALUE(v_profile_clob, ''$."parsed-rows"''))',
'      INTO v_records',
'      FROM dual;',
'',
'    -- Extract filtered columns with mapped data types',
'    SELECT TO_CLOB(',
'             JSON_ARRAYAGG(',
'               JSON_OBJECT(',
'                 ''name'' VALUE jt.name,',
'                 ''data-type'' VALUE CASE jt.data_type',
'                                    WHEN 1 THEN ''TEXT''',
'                                    WHEN 2 THEN ''NUMBER''',
'                                    WHEN 3 THEN ''DATE''',
'                                    ELSE ''TEXT''',
'                                  END',
'               )',
'             )',
'           )',
'      INTO v_columns',
'      FROM JSON_TABLE(v_profile_clob, ''$."columns"[*]''',
'             COLUMNS (',
'               name       VARCHAR2(100) PATH ''$.name'',',
'               data_type  NUMBER       PATH ''$."data-type"''',
'             )',
'          ) jt;',
'',
'    -- Insert each column into APEX collection',
'    FOR col IN cur_columns LOOP',
'      apex_collection.add_member(',
'        p_collection_name => ''UR_FILE_DATA_PROFILES'',',
'        p_c001            => col.name,',
'        p_c002            => col.data_type',
'      );',
'    END LOOP;',
'',
'    -- Update temp_BLOB table',
'    UPDATE temp_BLOB',
'       SET profile = v_profile_clob,',
'           records = v_records,',
'           columns = v_columns',
'     WHERE ID = rec.ID;',
'  END LOOP;',
'',
'  COMMIT;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>14714478600561128
);
wwv_flow_imp.component_end;
end;
/
