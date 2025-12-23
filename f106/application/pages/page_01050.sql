prompt --application/pages/page_01050
begin
--   Manifest
--     PAGE: 01050
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
 p_id=>1050
,p_name=>'Algorithms'
,p_alias=>'ALGORITHMS'
,p_step_title=>'Strategies'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#APP_FILES#AlgoPGJS#MIN#.js'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*var exprCaretPos = null;',
'var exprWasClicked = false;  // track if user ever clicked',
'',
'function setupCaretTracking(itemName){',
'  var el = document.getElementById(itemName);',
'  if (!el) return;',
'',
'  function savePos(){',
'    exprCaretPos = { start: el.selectionStart, end: el.selectionEnd };',
'    exprWasClicked = true; // user interacted manually',
'  }',
'',
'  el.addEventListener("keyup", savePos);',
'  el.addEventListener("click", savePos);',
'  el.addEventListener("focus", savePos);',
'}',
'',
'function insertAtCursorOrEnd(itemName, text){',
'  var el = document.getElementById(itemName);',
'  if (!el) return;',
'',
'  var oldVal = $v(itemName) || "";',
'  var start, end;',
'',
'  if (exprWasClicked && exprCaretPos && typeof exprCaretPos.start === "number") {',
'    // insert where user clicked',
'    start = exprCaretPos.start;',
'    end   = exprCaretPos.end;',
'  } else {',
unistr('    // default \2192 append at end'),
'    start = end = oldVal.length;',
'  }',
'',
'  var prefix = (start > 0 && oldVal[start-1] !== " ") ? " " : "";',
'  var suffix = (end < oldVal.length && oldVal[end] !== " ") ? " " : " ";',
'',
'  var newVal = oldVal.substring(0, start) + prefix + text + suffix + oldVal.substring(end);',
'  $s(itemName, newVal);',
'',
'  // restore caret',
'  setTimeout(function(){',
'    var pos = start + (prefix + text + suffix).length;',
'    exprCaretPos = { start: pos, end: pos };',
'    el.selectionStart = el.selectionEnd = pos;',
'  },0);',
'}',
'',
'// run once',
'setupCaretTracking("P1050_EXPRESSION");*/',
'var exprCaretPos = null;',
'',
'function trackExpressionCaret(itemName) {',
'  var el = document.getElementById(itemName);',
'  if (!el) return;',
'',
'  function savePos() {',
'    exprCaretPos = {',
'      start: el.selectionStart || 0,',
'      end:   el.selectionEnd   || 0',
'    };',
'  }',
'',
'  ["click","keyup","mouseup","focus","blur"].forEach(function(ev){',
'    el.addEventListener(ev, savePos);',
'  });',
'}',
'',
'trackExpressionCaret("P1050_EXPRESSION");',
'function insertAtSavedPos(itemName, text) {',
'  var el = document.getElementById(itemName);',
'  if (!el) return;',
'',
'  var oldVal = $v(itemName) || "";',
'  var start = (exprCaretPos && typeof exprCaretPos.start === "number") ',
'                ? exprCaretPos.start ',
'                : oldVal.length;',
'  var end   = (exprCaretPos && typeof exprCaretPos.end === "number") ',
'                ? exprCaretPos.end ',
'                : oldVal.length;',
'',
'  // Ensure clean spacing around insert',
'  var prefix = (start > 0 && !/\s/.test(oldVal[start-1])) ? " " : "";',
'  var suffix = (end < oldVal.length && !/\s/.test(oldVal[end])) ? " " : "";',
'',
'  var newVal = oldVal.substring(0, start) + prefix + text + suffix + oldVal.substring(end);',
'  $s(itemName, newVal);',
'',
'  // Restore caret just after inserted text',
'  setTimeout(function(){',
'    var pos = start + (prefix + text + suffix).length;',
'    exprCaretPos = { start: pos, end: pos };',
'    el.focus();',
'    el.selectionStart = el.selectionEnd = pos;',
'  }, 0);',
'}',
'',
'',
'',
'',
'// Execute when Page Loads',
'(function () {',
'  try {',
'    // Find all inputs with the id',
'    const inputs = Array.from(document.querySelectorAll(''input#P1050_NAME''));',
'    if (inputs.length > 1) {',
'      const keeper = inputs[0]; // keep the first one',
'      // Remove duplicates (their closest form container if exists, else the node itself)',
'      inputs.slice(1).forEach(inp => {',
'        const fieldContainer = inp.closest(''.t-Form-fieldContainer'') || inp.closest(''.t-Form-inputContainer'') || inp.closest(''.t-Region-body'') || inp.parentElement;',
'        if (fieldContainer) fieldContainer.remove();',
'        else inp.remove();',
'      });',
'    }',
'',
'    // Ensure the survived input and its parent containers can expand',
'    const input = document.querySelector(''input#P1050_NAME'');',
'    if (input) {',
'      // Stretch the input (helps flex containers)',
'      Object.assign(input.style, {',
'        width: ''100%'',',
'        maxWidth: ''700px'',',
'        boxSizing: ''border-box'',',
'        display: ''block'',',
'        minWidth: ''0'',',
'        flex: ''1''',
'      });',
'',
'      // Stretch wrapper containers if present',
'      const containers = [',
'        input.closest(''.t-Form-itemWrapper''),',
'        input.closest(''.t-Form-inputContainer''),',
'        input.closest(''.t-Form-fieldContainer''),',
'        input.closest(''.col''),',
'        input.closest(''.row'')',
'      ];',
'      containers.forEach(c => {',
'        if (c) {',
'          c.style.width = ''100%'';',
'          c.style.maxWidth = ''100%'';',
'          c.style.boxSizing = ''border-box'';',
'        }',
'      });',
'    }',
'  } catch (e) {',
'    // fail silently but log for debugging',
'    // eslint-disable-next-line no-console',
'    console.error(''Cleanup P1050_NAME duplicates failed'', e);',
'  }',
'})();',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'* {',
'    box-sizing: border-box;',
'    font-family: ''Segoe UI'', Tahoma, Geneva, Verdana, sans-serif;',
'}',
'body {',
'    background-color: #121212;',
'    color: #e0e0e0;',
'}',
'.hidden { display: none !important; }',
'',
'/* Main Page Layout */',
'.header {',
'    display: flex;',
'    justify-content: space-between;',
'    align-items: center;',
'    margin-bottom: 20px;',
'    padding-bottom: 10px;',
'    border-bottom: 1px solid #333;',
'}',
'h1 { margin: 0; color: #d4d4e0; }',
'',
'/* Page Footer for global buttons */',
'.page-footer {',
'    display: flex;',
'    justify-content: flex-end;',
'    gap: 10px;',
'    padding-top: 20px;',
'    margin-top: 20px;',
'    border-top: 1px solid #333;',
'}',
'',
'/* Buttons */',
'.btn {',
'    background-color: #ffffff;',
'    color: #121212;',
'    border: none;',
'    padding: 10px 15px;',
'    border-radius: 4px;',
'    cursor: pointer;',
'    font-weight: bold;',
'    display: inline-flex;',
'    align-items: center;',
'    gap: 5px;',
'    transition: background-color 0.3s;',
'}',
'.btn:hover { background-color: #3965ea; }',
'.btn-secondary { background-color: #ffffff; color: #121212; }',
'.btn-secondary:hover { background-color: #4343f6; }',
'.btn-danger { background-color: #cf6679; color: #121212; }',
'.btn-danger:hover { background-color: #b95568; }',
'.btn-small { padding: 5px 10px; font-size: 0.9rem; }',
'button.btn:disabled { opacity: 0.5; cursor: not-allowed; }',
'',
'/* Filter Region */',
'.filter-region {',
'    background-color: #1e1e1e;',
'    border-radius: 8px;',
'    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);',
'    margin-bottom: 20px;',
'    overflow: hidden;',
'    border: 1px solid #333;',
'}',
'.region-header {',
'    background-color: #2d2d2d;',
'    color: #e0e0e0;',
'    padding: 12px 15px;',
'    display: flex;',
'    justify-content: space-between;',
'    align-items: center;',
'    cursor: pointer;',
'}',
'.region-title { font-weight: bold; font-size: 1.1rem; display: flex; align-items: center; gap: 8px; }',
'.toggle-icon { transition: transform 0.3s; }',
'.region-collapsed > .region-header .toggle-icon { transform: rotate(-90deg); }',
'.region-content { ',
'    padding: 15px; ',
'    overflow: hidden;',
'    max-height: 2000px; /* Set a large max-height for the animation */',
'    transition: max-height 0.4s ease-in-out, padding 0.4s ease-in-out; ',
'}',
'.region-collapsed .region-content { max-height: 0; padding-top: 0; padding-bottom: 0; }',
'',
'/* Controls (Move/Delete Buttons) */',
'.region-controls, .condition-controls { display: flex; align-items: center; gap: 10px; }',
'.control-group { display: flex; }',
'.control-group .btn { border-radius: 0; margin-left: -1px; }',
'.control-group .btn:first-child { border-top-left-radius: 4px; border-bottom-left-radius: 4px; margin-left: 0; }',
'.control-group .btn:last-child { border-top-right-radius: 4px; border-bottom-right-radius: 4px; }',
'',
'/* Sections */',
'.section { margin-bottom: 20px; }',
'.section-title {',
'    font-weight: bold;',
'    margin-bottom: 15px;',
'    color: #ffffff;',
'    display: flex;',
'    align-items: center;',
'    justify-content: space-between;',
'    gap: 5px;',
'    font-size: 1.1rem;',
'    border-bottom: 1px solid #444;',
'    padding-bottom: 8px;',
'}',
'',
'/* Fields and Inputs */',
'.field-container { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; flex-wrap: wrap; }',
'.field-content { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; flex: 1; }',
'.field-content.hidden { display: none; }',
'select, input[type="text"], input[type="number"], input[type="date"], textarea {',
'    padding: 8px 10px;',
'    border: 1px solid #444;',
'    border-radius: 4px;',
'    background-color: #2a2a2a;',
'    color: #e0e0e0;',
'    transition: border-color 0.3s;',
'}',
'.checkbox-group { display: flex; flex-wrap: wrap; gap: 15px; }',
'.checkbox-item { display: flex; align-items: center; gap: 5px; }',
'',
'/* Condition Group */',
'.condition-group { border: 1px solid #444; border-radius: 6px; padding: 15px; margin-bottom: 15px; background-color: #2a2a2a; }',
'.condition-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; cursor: pointer; }',
'.condition-title { font-weight: bold; color: #e6b5b5; display: flex; align-items: center; gap: 8px; }',
'.condition-body { overflow: hidden; max-height: 1000px; transition: max-height 0.4s ease-in-out; }',
'.condition-collapsed .condition-body { max-height: 0; padding-top: 0 !important; }',
'.condition-collapsed > .condition-header { margin-bottom: 0; }',
'.condition-collapsed > .condition-header .toggle-icon { transform: rotate(-90deg); }',
'',
'/* Editable Titles */',
'.editable-title .title-input { font-size: inherit; font-weight: inherit; color: inherit; border: 1px solid #bb86fc; }',
'',
'/* Expression Area */',
'.expression-container { margin-top: 15px; }',
'textarea.expression-textarea { width: 100%; min-height: 100px; resize: vertical; font-family: monospace; }',
'.textarea-controls { margin-top: 10px; display: flex; justify-content: space-between; align-items: center; }',
'',
'/* Validation Styles */',
'.invalid-region { border: 2px solid #d9534f !important; border-radius: 8px; }',
'.invalid-field { border: 1px solid #d9534f !important; border-radius: 4px; }',
'textarea.valid-expression { border-color: #28a745 !important; }',
'textarea.invalid-expression { border-color: #d9534f !important; }',
'',
'/* Autocomplete */',
'#expression-autocomplete { position: absolute; border: 1px solid #444; background-color: #2d2d2d; border-radius: 4px; z-index: 1000; max-height: 200px; overflow-y: auto; width: auto; min-width: 150px; }',
'.autocomplete-item { padding: 8px 12px; color: #e0e0e0; cursor: pointer; white-space: nowrap; }',
'.autocomplete-active { background-color: #3965ea; }',
'',
'/* --- ISOLATED STYLES FOR ALGORITHM ICON BUTTONS --- */',
'',
'/* The new container for our icon buttons */',
'.algo-icon-controls {',
'    display: inline-flex;',
'    align-items: center;',
'    gap: 5px; /* Sets the space between buttons */',
'}',
'',
'/* The new, dedicated class for each icon button */',
'.algo-icon-controls .algo-icon-btn {',
'    /* Sizing & Layout */',
'    width: 28px;',
'    height: 28px;',
'    padding: 0;',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    ',
'    /* Aesthetics & Feel */',
'    line-height: 1;',
'    border-radius: 4px;',
'    border: 1px solid #666; /* A subtle border */',
'    background-color: #383838;',
'    color: #dadada;',
'    cursor: pointer;',
'    transition: background-color 0.2s ease, border-color 0.2s ease;',
'}',
'',
'/* Hover effect for better feedback */',
'.algo-icon-controls .algo-icon-btn:hover {',
'    background-color: #4f4f4f;',
'    border-color: #888;',
'}',
'',
'/* Red hover effect specifically for the delete button */',
'.algo-icon-controls .algo-icon-btn.btn-danger:hover {',
'    background-color: #c83c3c;',
'    color: #fff;',
'    border-color: #c83c3c;',
'}',
'',
'/* Control the size of the SVG icon */',
'.algo-icon-controls .algo-icon-btn svg {',
'    width: 16px;',
'    height: 16px;',
'}',
'',
'/* Balance the size of the text-based icons */',
'.algo-icon-controls .region-move,',
'.algo-icon-controls .condition-move,',
'.algo-icon-controls .delete-region,',
'.algo-icon-controls .condition-remove {',
'    font-size: 18px;',
'}',
'',
'/* --- MODAL OVERLAY AND DIALOG --- */',
'',
'/* Modal overlay */',
'.modal-overlay {',
'    display: none; /* Hidden by default */',
'    position: fixed;',
'    top: 0;',
'    left: 0;',
'    width: 100%;',
'    height: 100%;',
'    background-color: rgba(0, 0, 0, 0.7);',
'    z-index: 2000;',
'    justify-content: center;',
'    align-items: center;',
'}',
'',
'/* Modal content box */',
'.modal-content {',
'    background-color: #1e1e1e;',
'    border: 2px solid #444;',
'    border-radius: 8px;',
'    width: 90%;',
'    max-width: 700px;',
'    max-height: 85vh;',
'    display: flex;',
'    flex-direction: column;',
'    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6);',
'}',
'',
'/* Modal header */',
'.modal-header {',
'    display: flex;',
'    justify-content: space-between;',
'    align-items: center;',
'    padding: 15px 20px;',
'    border-bottom: 1px solid #444;',
'    background-color: #2d2d2d;',
'}',
'',
'.modal-header h3 {',
'    margin: 0;',
'    color: #e0e0e0;',
'    font-size: 1.2rem;',
'}',
'',
'.modal-close-btn {',
'    background: none;',
'    border: none;',
'    color: #e0e0e0;',
'    font-size: 2rem;',
'    line-height: 1;',
'    cursor: pointer;',
'    padding: 0;',
'    width: 32px;',
'    height: 32px;',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    border-radius: 4px;',
'    transition: background-color 0.2s;',
'}',
'',
'.modal-close-btn:hover {',
'    background-color: #444;',
'}',
'',
'/* Modal body */',
'.modal-body {',
'    padding: 20px;',
'    overflow-y: auto;',
'    flex: 1;',
'}',
'',
'/* --- SEARCHABLE ATTRIBUTE SELECT COMPONENT --- */',
'',
'/* Main container (adjusted for modal) */',
'.searchable-attribute-container {',
'    display: flex;',
'    flex-direction: column;',
'    gap: 12px;',
'    width: 100%;',
'}',
'',
'/* Search input */',
'.attribute-search-input {',
'    width: 100%;',
'    padding: 10px 14px;',
'    border: 1px solid #555;',
'    border-radius: 4px;',
'    background-color: #2a2a2a;',
'    color: #e0e0e0;',
'    font-size: 1rem;',
'    transition: border-color 0.3s;',
'}',
'',
'.attribute-search-input:focus {',
'    outline: none;',
'    border-color: #3965ea;',
'}',
'',
'.attribute-search-input::placeholder {',
'    color: #888;',
'}',
'',
'/* Filter chips container */',
'.attribute-filters {',
'    display: flex;',
'    flex-direction: column;',
'    gap: 8px;',
'}',
'',
'.filter-row {',
'    display: flex;',
'    align-items: center;',
'    gap: 8px;',
'    flex-wrap: wrap;',
'}',
'',
'.filter-label {',
'    font-size: 0.85rem;',
'    color: #b0b0b0;',
'    font-weight: bold;',
'    min-width: 80px;',
'}',
'',
'/* Filter chips */',
'.filter-chip {',
'    padding: 4px 12px;',
'    border: 1px solid #555;',
'    border-radius: 16px;',
'    background-color: #383838;',
'    color: #d0d0d0;',
'    font-size: 0.85rem;',
'    cursor: pointer;',
'    transition: all 0.2s ease;',
'    white-space: nowrap;',
'}',
'',
'.filter-chip:hover {',
'    background-color: #4a4a4a;',
'    border-color: #666;',
'}',
'',
'.filter-chip.active {',
'    background-color: #3965ea;',
'    color: #ffffff;',
'    border-color: #3965ea;',
'    font-weight: bold;',
'}',
'',
'/* Results count */',
'.results-count {',
'    font-size: 0.8rem;',
'    color: #888;',
'    padding: 4px 0;',
'    text-align: right;',
'}',
'',
'/* Results container */',
'.attribute-results {',
'    max-height: 400px;',
'    overflow-y: auto;',
'    border: 1px solid #444;',
'    border-radius: 4px;',
'    background-color: #2a2a2a;',
'}',
'',
'/* Scrollbar styling for results */',
'.attribute-results::-webkit-scrollbar {',
'    width: 8px;',
'}',
'',
'.attribute-results::-webkit-scrollbar-track {',
'    background: #2a2a2a;',
'    border-radius: 4px;',
'}',
'',
'.attribute-results::-webkit-scrollbar-thumb {',
'    background: #555;',
'    border-radius: 4px;',
'}',
'',
'.attribute-results::-webkit-scrollbar-thumb:hover {',
'    background: #666;',
'}',
'',
'/* Individual result item */',
'.attribute-result-item {',
'    padding: 10px 12px;',
'    color: #e0e0e0;',
'    cursor: pointer;',
'    border-bottom: 1px solid #333;',
'    transition: background-color 0.2s ease;',
'    white-space: nowrap;',
'    overflow: hidden;',
'    text-overflow: ellipsis;',
'}',
'',
'.attribute-result-item:last-child {',
'    border-bottom: none;',
'}',
'',
'.attribute-result-item:hover {',
'    background-color: #3965ea;',
'    color: #ffffff;',
'}',
'',
'/* No results message */',
'.no-results {',
'    padding: 20px;',
'    text-align: center;',
'    color: #888;',
'    font-style: italic;',
'}',
'',
'/* Search text highlighting */',
'.search-highlight {',
'    background-color: #ffd700;',
'    color: #121212;',
'    font-weight: bold;',
'    padding: 1px 2px;',
'    border-radius: 2px;',
'}',
'',
'/* Keep highlight visible on hover */',
'.attribute-result-item:hover .search-highlight {',
'    background-color: #ffed4e;',
'    color: #000000;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11676271632603126)
,p_plug_name=>'Main Region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9903805002138617)
,p_plug_name=>'Expression Builder JS'
,p_parent_plug_id=>wwv_flow_imp.id(11676271632603126)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="container">',
'    <!-- <div class="header">',
'        <h1>SQL Expression Builder</h1>',
'        <div class="btn" id="addRegionBtn">',
'            <span>+</span> Add',
'        </div>',
'    </div> -->',
'    <div class="btn" id="addRegionBtn">',
'        <span>+</span> Add',
'    </div>',
'    <div id="filterContainer"></div>',
'    ',
'    <div class="json-output" id="jsonOutput"></div>',
'',
'    <div class="page-footer">',
'        <div id="validateAllBtn" class="btn btn-secondary">Validate</div>',
'        <div id="saveAllBtn" class="btn">Save</div>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11676380894603127)
,p_plug_name=>'Algorithm'
,p_parent_plug_id=>wwv_flow_imp.id(11676271632603126)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11676629408603130)
,p_plug_name=>'ALGO DEFNITION'
,p_title=>'ALGO DEFNITION'
,p_parent_plug_id=>wwv_flow_imp.id(11676380894603127)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11677573094603139)
,p_plug_name=>'DEFINITION'
,p_parent_plug_id=>wwv_flow_imp.id(11676629408603130)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>3
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11677686826603140)
,p_plug_name=>'VERSION'
,p_parent_plug_id=>wwv_flow_imp.id(11676629408603130)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
,p_plug_display_column=>5
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11676446925603128)
,p_plug_name=>'ALGO EXPRESSION MAIN'
,p_parent_plug_id=>wwv_flow_imp.id(11676271632603126)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11677026949603134)
,p_plug_name=>'ATTRIBUTES'
,p_parent_plug_id=>wwv_flow_imp.id(11676446925603128)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11677172657603135)
,p_plug_name=>'EXPRESSIONS'
,p_title=>'Expression'
,p_parent_plug_id=>wwv_flow_imp.id(11676446925603128)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11677249325603136)
,p_plug_name=>'CONTROLS'
,p_parent_plug_id=>wwv_flow_imp.id(11676446925603128)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--hideHeader js-addHiddenHeadingRoleDesc:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(12884553663327132)
,p_plug_name=>'Calculation'
,p_title=>'3. Calculation'
,p_parent_plug_id=>wwv_flow_imp.id(11676446925603128)
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13903657768313901)
,p_plug_name=>'Filters'
,p_title=>'1. Filters'
,p_parent_plug_id=>wwv_flow_imp.id(11676446925603128)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>6
,p_plug_display_column=>1
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13903710227313902)
,p_plug_name=>'Stay Window'
,p_parent_plug_id=>wwv_flow_imp.id(13903657768313901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13903954637313904)
,p_plug_name=>'Lead Time'
,p_parent_plug_id=>wwv_flow_imp.id(13903657768313901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13904021256313905)
,p_plug_name=>'DoW'
,p_parent_plug_id=>wwv_flow_imp.id(13903657768313901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13904138739313906)
,p_plug_name=>'Min Rate'
,p_parent_plug_id=>wwv_flow_imp.id(13903657768313901)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(13907713668313942)
,p_plug_name=>'Conditions'
,p_title=>'2. Conditions'
,p_parent_plug_id=>wwv_flow_imp.id(11676446925603128)
,p_region_template_options=>'#DEFAULT#:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>6
,p_plug_display_column=>7
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(15696178439549835)
,p_plug_name=>'Breadcrumb'
,p_title=>'Algorithms'
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(9642405095450628)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(11677686826603140)
,p_button_name=>'Strategy_Data'
,p_button_static_id=>'strategyData'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--gapTop'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Test Strategy'
,p_button_redirect_url=>'f?p=&APP_ID.:26:&SESSION.::&DEBUG.:::'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(18156679423285632)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(11677686826603140)
,p_button_name=>'Duplicate_Strategy'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--gapTop'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Duplicate Strategy'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(12543349538179907)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(11677026949603134)
,p_button_name=>'P1050_BTN_ADD_VALUE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Add Value'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11678142393603145)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(12884553663327132)
,p_button_name=>'Clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Clear'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11678496244603148)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(11677249325603136)
,p_button_name=>'Delete'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--danger'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
,p_confirm_message=>'This will delete the Algo along with its versions, are you sure?'
,p_confirm_style=>'warning'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11678311034603147)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(11677249325603136)
,p_button_name=>'Validate'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--primary'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Validate'
,p_button_position=>'CREATE'
,p_button_execute_validations=>'N'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11678270842603146)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(11677249325603136)
,p_button_name=>'Save'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--success'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10425466471683922)
,p_name=>'P1050_DEBUG_OUT'
,p_item_sequence=>50
,p_prompt=>'Debug Out'
,p_source=>'P0_HOTEL_ID'
,p_source_type=>'ITEM'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(10425588743683923)
,p_name=>'P1050_EXPRESSION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(12884553663327132)
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11676587772603129)
,p_name=>'P1050_ALGO_LIST'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11676380894603127)
,p_item_default=>'00'
,p_prompt=>'Strategies List'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name as D, ID as R',
'from UR_ALGOS',
'where hotel_id = :P1050_HOTEL_LIST',
'union all',
'select ''-- Define New --'' AS D, hextoraw(''0'') as R',
'from DUAL'))
,p_lov_cascade_parent_items=>'P1050_HOTEL_LIST'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11676739885603131)
,p_name=>'P1050_VERSION'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11677686826603140)
,p_use_cache_before_default=>'NO'
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select current_version_id',
'from ur_algos',
'where id = :P1050_ALGO_LIST;'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Version'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select version || '' ('' || updated_on || '')'' as d, id as r ',
'from ur_algo_versions',
'where algo_id = :P1050_ALGO_LIST',
'order by id desc'))
,p_lov_cascade_parent_items=>'P1050_ALGO_LIST'
,p_ajax_items_to_submit=>'P1050_ALGO_LIST,P1050_VERSION'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11677397519603137)
,p_name=>'P1050_DESCRIPTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(11677573094603139)
,p_prompt=>'Description'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11677406857603138)
,p_name=>'P1050_NAME'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11677573094603139)
,p_use_cache_before_default=>'NO'
,p_placeholder=>'Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11677866080603142)
,p_name=>'P1050_ATTRIBUTES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(12884553663327132)
,p_prompt=>'Attributes'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select name || '' ('' || key || '')'' as D, key as R',
'from UR_ALGO_ATTRIBUTES',
'where 1 = 1',
'and hotel_id = :P0_HOTEL_ID'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P0_HOTEL_ID'
,p_ajax_items_to_submit=>'P0_HOTEL_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11677952350603143)
,p_name=>'P1050_OPERATORS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(12884553663327132)
,p_prompt=>'Operators'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'UR EXPRESSION OPERATORS'
,p_lov=>'.'||wwv_flow_imp.id(12487682573470467)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11678038604603144)
,p_name=>'P1050_FUNCTIONS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(12884553663327132)
,p_prompt=>'Functions'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'UR EXPRESSION FUNCTIONS'
,p_lov=>'.'||wwv_flow_imp.id(12494151488529142)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12467267944198922)
,p_name=>'P1050_HOTEL_LIST'
,p_is_required=>true
,p_item_sequence=>30
,p_use_cache_before_default=>'NO'
,p_prompt=>'Hotel'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'  nvl(Hotel_NAME,''Name'') as Name,',
'ID as ID',
'FROM',
'UR_HOTELS',
'WHERE nvl(ASSOCIATION_END_DATE,sysdate) >= sysdate',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12881926860327106)
,p_name=>'P1050_STAY_WINDOW_FROM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(11677026949603134)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Stay Window From'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>9
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12882214341327109)
,p_name=>'P1050_STAY_WINDOW_TO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(11677026949603134)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Stay Window To'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>11
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12882418522327111)
,p_name=>'P1050_DAY_OF_WEEK'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(11677026949603134)
,p_prompt=>'Day Of Week'
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC:Sunday;0,Monday;1,Tuesday;2,Wednesday;3,Thursday;4,Friday;5,Saturday;6'
,p_colspan=>6
,p_grid_column=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '7')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12882521250327112)
,p_name=>'P1050_LEAD_TIME_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11677026949603134)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Lead Time Type'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR LEAD TIME TYPES'
,p_lov=>'.'||wwv_flow_imp.id(12968322337095291)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'Y',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12882605897327113)
,p_name=>'P1050_LEAD_TIME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11677026949603134)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Lead Time'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12882794333327114)
,p_name=>'P1050_LEAD_TIME_FROM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11677026949603134)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Lead Time From'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12882801846327115)
,p_name=>'P1050_LEAD_TIME_TO'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11677026949603134)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Lead Time To'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>7
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12883707364327124)
,p_name=>'P1050_EVENT_SCORE_CHECK'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_prompt=>'Event Score'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12883845233327125)
,p_name=>'P1050_EVENT_SCORE_OPERATORS'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Operators'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR ALGO CONDITIONS OPERATORS'
,p_lov=>'.'||wwv_flow_imp.id(14015089005891584)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>7
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12883941342327126)
,p_name=>'P1050_EVENT_SCORE_VALUE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_prompt=>'Value'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR EVENT SCORE'
,p_lov=>'.'||wwv_flow_imp.id(14574086177037113)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>9
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12884059453327127)
,p_name=>'P1050_RANKING_COMP_SET_CHECK'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_prompt=>'Property Ranking (Comp. Set)'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12884192231327128)
,p_name=>'P1050_RANKING_COMP_SET_OPERATORS'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Operators'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR ALGO CONDITIONS OPERATORS'
,p_lov=>'.'||wwv_flow_imp.id(14015089005891584)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>7
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12884285370327129)
,p_name=>'P1050_RANKING_COMP_SET_VALUE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Value'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'WITH comp_count AS (',
'    -- 1. Use JSON_TABLE to count the matching ''COMP_PROPERTY'' qualifiers',
'    SELECT',
'        COUNT(jt.qualifier_value) + 1 AS PROPERTY_COUNT -- *** ADDING +1 HERE ***',
'    FROM',
'        UR_TEMPLATES t,',
'        JSON_TABLE(',
'            t.DEFINITION,',
'            ''$[*]''',
'            COLUMNS (',
'                qualifier_value VARCHAR2(100) PATH ''$.qualifier''',
'            )',
'        ) jt',
'    WHERE',
'        t.ID = :P1050_RANKING_COMP_SET_TYPE -- Replace with your desired ID or remove WHERE clause',
'        AND jt.qualifier_value = ''COMP_PROPERTY'' -- Filter only the COMP_PROPERTY rows',
'),',
'number_sequence (n, max_n) AS (',
'    -- 2. Recursive CTE to generate numbers from 1 up to the (Count + 1)',
'    -- Anchor member: Start the sequence at 1',
'    SELECT',
'        1 AS n,',
'        cc.PROPERTY_COUNT AS max_n',
'    FROM',
'        comp_count cc',
'    WHERE',
'        cc.PROPERTY_COUNT > 0',
'    UNION ALL',
'    -- Recursive member: Increment the number until it reaches (Count + 1)',
'    SELECT',
'        n + 1,',
'        max_n',
'    FROM',
'        number_sequence',
'    WHERE',
'        n < max_n',
')',
'-- 3. Final selection of the generated number sequence',
'SELECT',
'    n AS SEQUENCE_NUMBER',
'FROM',
'    number_sequence',
'ORDER BY',
'    SEQUENCE_NUMBER;'))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P1050_RANKING_COMP_SET_TYPE'
,p_ajax_items_to_submit=>'P1050_RANKING_COMP_SET_TYPE'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>9
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12884363989327130)
,p_name=>'P1050_RANKING_COMP_SET_TYPE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Type'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select NAME as D, ID as R',
'from UR_TEMPLATES',
'where 1 = 1',
'and HOTEL_ID = :P0_HOTEL_ID',
'and TYPE = ''RST'''))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P0_HOTEL_ID'
,p_ajax_items_to_submit=>'P0_HOTEL_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_column=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(12884443175327131)
,p_name=>'P1050_OCC_THRESHOD_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Attribute'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select NAME || '' ('' || (select name from UR_TEMPLATES where id = template_id and active = ''N'') || '')''',
'from UR_ALGO_ATTRIBUTES',
'where 1 = 1',
'and HOTEL_ID = :P0_HOTEL_ID',
'and upper(ATTRIBUTE_QUALIFIER) = ''OCCUPANCY'''))
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P0_HOTEL_ID'
,p_ajax_items_to_submit=>'P0_HOTEL_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_grid_column=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13904368926313908)
,p_name=>'P1050_STAY_WINDOW_CHECK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13903710227313902)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Stay Window'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13904468593313909)
,p_name=>'P1050_STAY_W_FROM'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13903710227313902)
,p_prompt=>'From'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13904586128313910)
,p_name=>'P1050_STAY_W_TO'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13903710227313902)
,p_prompt=>'To'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13904689353313911)
,p_name=>'P1050_LEAD_TIME_CHECK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13903954637313904)
,p_prompt=>'Lead Time'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13904767414313912)
,p_name=>'P1050_LEAD_T_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13903954637313904)
,p_prompt=>'Type'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR LEAD TIME TYPES'
,p_lov=>'.'||wwv_flow_imp.id(12968322337095291)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13904861683313913)
,p_name=>'P1050_LEAD_T_FROM'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(13903954637313904)
,p_prompt=>'From'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>6
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13904927024313914)
,p_name=>'P1050_LEAD_T_TO'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(13903954637313904)
,p_prompt=>'To'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>8
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13905036984313915)
,p_name=>'P1050_DOW_CHECK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13904021256313905)
,p_prompt=>'Day of Week'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13905196165313916)
,p_name=>'P1050_DOW_DAYS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13904021256313905)
,p_display_as=>'NATIVE_CHECKBOX'
,p_lov=>'STATIC2:SUN;1,MON;2,TUE;3,WED;4,THU;5,FRI;6,SAT;7'
,p_begin_on_new_line=>'N'
,p_grid_column=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '7')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>':'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13905260765313917)
,p_name=>'P1050_MIN_RATE_CHECK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13904138739313906)
,p_prompt=>'Minimum Rate'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13905360532313918)
,p_name=>'P1050_MIN_RATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(13904138739313906)
,p_prompt=>unistr('\00A3')
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>1
,p_grid_column=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13906745201313932)
,p_name=>'P1050_LEAD_T_TIME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13903954637313904)
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>1
,p_grid_column=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13907821358313943)
,p_name=>'P1050_OCC_THRESHOLD_CHECK'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_prompt=>'Occupancy Threshold %'
,p_display_as=>'NATIVE_SINGLE_CHECKBOX'
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--large'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13907920602313944)
,p_name=>'P1050_OCC_THR_OPERATORS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Operators'
,p_display_as=>'NATIVE_POPUP_LOV'
,p_named_lov=>'UR ALGO CONDITIONS OPERATORS'
,p_lov=>'.'||wwv_flow_imp.id(14015089005891584)||'.'
,p_lov_display_null=>'YES'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>7
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'case_sensitive', 'N',
  'display_as', 'POPUP',
  'fetch_on_search', 'N',
  'initial_fetch', 'FIRST_ROWSET',
  'manual_entry', 'N',
  'match_type', 'CONTAINS',
  'min_chars', '0')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(13908050690313945)
,p_name=>'P1050_OCC_THRESHOLD_VALUE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(13907713668313942)
,p_prompt=>'Value'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_grid_column=>9
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '100',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(31872891025853919)
,p_name=>'P1050_ALERT_MESSAGE'
,p_item_sequence=>20
,p_use_cache_before_default=>'NO'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12463934040188343)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_FILE_LOAD'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12464487029188344)
,p_event_id=>wwv_flow_imp.id(12463934040188343)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12464898115188345)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_TEMPLATE_LOV'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12465394111188347)
,p_event_id=>wwv_flow_imp.id(12464898115188345)
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
 p_id=>wwv_flow_imp.id(12465711591188348)
,p_name=>'Page_Load_DA'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17818788825450204)
,p_event_id=>wwv_flow_imp.id(12465711591188348)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_ALGO_LIST'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12463585561188342)
,p_name=>'Change_Hotel'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_HOTEL_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10425330707683921)
,p_event_id=>wwv_flow_imp.id(12463585561188342)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P0_HOTEL_ID'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(14723098467617504)
,p_event_id=>wwv_flow_imp.id(12463585561188342)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Call our function, passing the value of the changed hotel LoV',
'fetchAndApplyLovData(this.triggeringElement.value);',
'',
'// load_data_expression();',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12462683776188339)
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
 p_id=>wwv_flow_imp.id(12463195593188341)
,p_event_id=>wwv_flow_imp.id(12462683776188339)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var title = $v(''P1050_ALERT_TITLE'') || ''Notification'';',
'var message = $v(''P1050_ALERT_MESSAGE'');',
'var icon  = $v(''P1050_ALERT_ICON'') || ''success'';',
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
'  $s(''P1050_ALERT_MESSAGE'','''');',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12466146845188349)
,p_name=>'Changed'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_ALERT_MESSAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12466693546188351)
,p_event_id=>wwv_flow_imp.id(12466146845188349)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var messagesJson = $v("P1050_ALERT_MESSAGE");  // get the string from hidden page item',
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
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10425681259683924)
,p_name=>'Algo Change'
,p_event_sequence=>110
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_ALGO_LIST'
,p_condition_element=>'P1050_ALGO_LIST'
,p_triggering_condition_type=>'NOT_EQUALS'
,p_triggering_expression=>'00'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10425727080683925)
,p_event_id=>wwv_flow_imp.id(10425681259683924)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_name=>'Set Name'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'select name from ur_algos where id = :P1050_ALGO_LIST '
,p_attribute_07=>'P1050_ALGO_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10425835619683926)
,p_event_id=>wwv_flow_imp.id(10425681259683924)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_name=>'Set Algo Description'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_DESCRIPTION'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'select description from ur_algos where id = :P1050_ALGO_LIST '
,p_attribute_07=>'P1050_ALGO_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12542937994179903)
,p_event_id=>wwv_flow_imp.id(10425681259683924)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_name=>'set latest version'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_VERSION'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT version || '' ('' || updated_on || '')'' ',
'FROM UR_ALGO_VERSIONS',
'WHERE algo_id = :P1050_ALGO_LIST',
'order by id desc',
'FETCH FIRST 1 ROW ONLY'))
,p_attribute_07=>'P1050_ALGO_LIST'
,p_attribute_08=>'N'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12543026482179904)
,p_event_id=>wwv_flow_imp.id(10425681259683924)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_name=>'set expression based on version'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_EXPRESSION'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select expression',
'from ur_algo_versions',
'where id = :P1050_VERSION'))
,p_attribute_07=>'P1050_VERSION'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9642556355450629)
,p_event_id=>wwv_flow_imp.id(10425681259683924)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_ALGO_LIST'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>'select :P1050_ALGO_LIST from Dual'
,p_attribute_08=>'Y'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11818471751390448)
,p_name=>'Algo Change - Define New'
,p_event_sequence=>120
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_ALGO_LIST'
,p_condition_element=>'P1050_ALGO_LIST'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'00'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(17818690536450203)
,p_event_id=>wwv_flow_imp.id(11818471751390448)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Find the main container for all filter regions',
'const filterContainer = document.getElementById(''filterContainer'');',
'',
'// If the container exists, clear it completely',
'if (filterContainer) {',
'    filterContainer.innerHTML = '''';',
'}',
'',
'// Add one new, empty filter region to start fresh',
'addFilterRegion();',
'',
'// Optional but recommended: Clear the name and description fields',
'apex.item("P1050_NAME").setValue('''');',
'apex.item("P1050_DESCRIPTION").setValue('''');',
'apex.item("P1050_VERSION").setValue('''');'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10426107550683929)
,p_name=>'Change Version'
,p_event_sequence=>130
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_VERSION'
,p_condition_element=>'P1050_VERSION'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10426276160683930)
,p_event_id=>wwv_flow_imp.id(10426107550683929)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_name=>'Set Expression'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_EXPRESSION'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select expression',
'from ur_algo_versions',
'where id = :P1050_VERSION'))
,p_attribute_07=>'P1050_VERSION'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(15570493939443201)
,p_event_id=>wwv_flow_imp.id(10426107550683929)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_ALGO_LIST,P1050_VERSION'
,p_attribute_01=>'load_data_expression();'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(19881185625504303)
,p_event_id=>wwv_flow_imp.id(10426107550683929)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_ALGO_LIST'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'apex.item("P1050_ALGO_LIST").getValue()'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(19881249725504304)
,p_event_id=>wwv_flow_imp.id(10426107550683929)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_VERSION'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'apex.item("P1050_VERSION").getValue()'
,p_attribute_09=>'Y'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(19881331022504305)
,p_event_id=>wwv_flow_imp.id(10426107550683929)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10426373210683931)
,p_name=>'Loose Focus'
,p_event_sequence=>140
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_NAME'
,p_condition_element=>'P1050_ALGO_LIST'
,p_triggering_condition_type=>'NOT_EQUALS'
,p_triggering_expression=>'00'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'focusout'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10426419300683932)
,p_event_id=>wwv_flow_imp.id(10426373210683931)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(10);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'BEGIN',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_ALGOS'',',
'    p_payload => ''{"ID":"''|| :P1050_ALGO_LIST || ''","NAME":"'' || :P1050_NAME || ''"}'',',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'--   DBMS_OUTPUT.put_line(''Status: '' || l_status);',
'--   DBMS_OUTPUT.put_line(''Message (metadata JSON): '' || l_message);',
'',
'',
'',
'  :P1050_ALERT_MESSAGE :=  ''[{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P1050_ALGO_LIST,P1050_NAME'
,p_attribute_03=>'P1050_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10426697974683934)
,p_event_id=>wwv_flow_imp.id(10426373210683931)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'Y'
,p_name=>'Disable Save Btn'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'BUTTON'
,p_affected_button_id=>wwv_flow_imp.id(11678270842603146)
,p_client_condition_type=>'NULL'
,p_client_condition_element=>'P1050_NAME'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10426564902683933)
,p_event_id=>wwv_flow_imp.id(10426373210683931)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_ALGO_LIST'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12543111814179905)
,p_name=>'Btn Click'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11678270842603146)
,p_condition_element=>'P1050_NAME'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12543211388179906)
,p_event_id=>wwv_flow_imp.id(12543111814179905)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status   VARCHAR2(10);',
'  l_message  CLOB;',
'  l_icon     VARCHAR2(50);',
'  l_title    VARCHAR2(100);',
'  l_new_id   VARCHAR2(64) := NULL; -- HEX string for RAW',
'  l_payload  CLOB;',
'  l_json_clob CLOB := NULL;',
'BEGIN',
'  -- 1. Insert into UR_ALGOS',
'    -- UR_UTILS.add_alert(l_json_clob,''Algo ID: '' || :P1050_ALGO_LIST || '' Epr: '' || :P1050_EXPRESSION , ''E'' , null, null, l_json_clob);',
'  IF :P1050_ALGO_LIST = ''00''',
'  THEN',
'  ',
'      Graph_SQL.proc_crud_json(',
'        p_mode    => ''C'',',
'        p_table   => ''UR_ALGOS'',',
'        p_payload => ''{"NAME":"''|| :P1050_NAME || ''","HOTEL_ID":"'' || :P0_HOTEL_ID || ''","DESCRIPTION":"''|| :P1050_DESCRIPTION ||''"}'',',
'        p_debug   => ''N'',',
'        p_status  => l_status,',
'        p_message => l_message,',
'        p_icon    => l_icon,',
'        p_title   => l_title',
'      );',
'',
'    --   :P1050_ALERT_MESSAGE :=  ''{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}''; ',
'      UR_UTILS.add_alert(l_json_clob,l_message , l_status , null, null, l_json_clob);',
'',
'      if upper(l_status) = ''S''',
'      THEN',
'        -- Extract HEX ID from returned message',
'          l_new_id := REGEXP_SUBSTR(',
'                        l_message,',
'                        ''New ID *=([0-9A-F]{32})'',',
'                        1, 1, NULL, 1',
'                      );',
'',
'          IF :P1050_EXPRESSION IS NOT NULL and l_new_id is not null ',
'          THEN',
'            l_payload := ''{"ALGO_ID":"'' || l_new_id || ''","EXPRESSION":"'' || :P1050_EXPRESSION || ''"}'';',
'                --l_payload := ''{"ALGO_ID":"'' || l_new_id || ''","EXPRESSION":"'' || :P1050_EXPRESSION || ''","VERSION":"'' || :P1050_VERSION || ''"}'';',
'',
'            Graph_SQL.proc_crud_json(',
'              p_mode    => ''C'',',
'              p_table   => ''UR_ALGO_VERSIONS'',',
'              p_payload => l_payload,',
'              p_debug   => ''N'',',
'              p_status  => l_status,',
'              p_message => l_message,',
'              p_icon    => l_icon,',
'              p_title   => l_title',
'            );',
'',
'            -- :P1050_ALERT_MESSAGE :=  ''['' || :P1050_ALERT_MESSAGE || '',{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]''; ',
'            UR_UTILS.add_alert(l_json_clob,l_message , l_status , null, null, l_json_clob);',
'',
'          ELSif l_new_id is null THEN',
'',
'            -- :P1050_ALERT_MESSAGE :=   ''['' || :P1050_ALERT_MESSAGE || '', {"message":"Issue with Algo creation, please check with IT Team", "icon":false}]''; ',
'            UR_UTILS.add_alert(l_json_clob,l_message , l_status , null, null, l_json_clob);',
'          END IF;',
'      END IF;',
'',
'   ELSE ',
'   ',
'      IF :P1050_EXPRESSION IS NOT NULL and rawtohex(:P1050_ALGO_LIST) is not null ',
'          THEN',
'            l_payload := ''{"ALGO_ID":"'' || :P1050_ALGO_LIST || ''","EXPRESSION":"'' || :P1050_EXPRESSION || ''"}'';',
'            --l_payload := ''{"ALGO_ID":"'' || l_new_id || ''","EXPRESSION":"'' || :P1050_EXPRESSION || ''","VERSION":"'' || :P1050_VERSION || ''"}'';',
'            Graph_SQL.proc_crud_json(',
'              p_mode    => ''C'',',
'              p_table   => ''UR_ALGO_VERSIONS'',',
'              p_payload => l_payload,',
'              p_debug   => ''N'',',
'              p_status  => l_status,',
'              p_message => l_message,',
'              p_icon    => l_icon,',
'              p_title   => l_title',
'            );',
'',
'             -- DBMS_OUTPUT.put_line(''Inserted Algo Version with Expression='' || :P1050_EXPRESSION);',
'            -- :P1050_ALERT_MESSAGE :=  ''['' || :P1050_ALERT_MESSAGE || '',{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}]''; ',
'            UR_UTILS.add_alert(l_json_clob,l_message , l_status , null, null, l_json_clob);',
'          ELSE ',
'',
'            -- :P1050_ALERT_MESSAGE :=  ''['' || :P1050_ALERT_MESSAGE || '', {"message":"Issue with Algo creation, please check with IT Team", "icon":false}]'';',
'            UR_UTILS.add_alert(l_json_clob,l_message , l_status , null, null, l_json_clob);',
'       END IF;',
'',
'   END IF;',
'   :P0_ALERT_MESSAGE := l_json_clob;',
'END;',
''))
,p_attribute_02=>'P1050_NAME,P1050_EXPRESSION,P1050_ALGO_LIST,P1050_DESCRIPTION'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10427001032683938)
,p_event_id=>wwv_flow_imp.id(12543111814179905)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_ALGO_LIST'
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10426887783683936)
,p_name=>'Loose Focus Description'
,p_event_sequence=>160
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_DESCRIPTION'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'focusout'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10426947902683937)
,p_event_id=>wwv_flow_imp.id(10426887783683936)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_status  VARCHAR2(10);',
'  l_message CLOB;',
'  l_icon    VARCHAR2(50);',
'  l_title   VARCHAR2(100);',
'BEGIN',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_ALGOS'',',
'    p_payload => ''{"ID":"''|| :P1050_ALGO_LIST || ''","DESCRIPTION":"'' || :P1050_DESCRIPTION || ''"}'',',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'--   DBMS_OUTPUT.put_line(''Status: '' || l_status);',
'--   DBMS_OUTPUT.put_line(''Message (metadata JSON): '' || l_message);',
'',
'',
'',
'  :P1050_ALERT_MESSAGE :=  ''{ "message":"'' || l_message || ''", "icon":"'' || l_status || ''"}'';  -- l_json;',
'',
'--   :P1001_ALERT_MESSAGE := ''This is default success message'';',
'',
'END;',
''))
,p_attribute_02=>'P1050_ALGO_LIST,P1050_DESCRIPTION'
,p_attribute_03=>'P1050_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'NOT_EQUALS'
,p_client_condition_element=>'P1050_ALGO_LIST'
,p_client_condition_expression=>'00'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10427117962683939)
,p_name=>'Validation Btn Clicked'
,p_event_sequence=>170
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11678311034603147)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10427283372683940)
,p_event_id=>wwv_flow_imp.id(10427117962683939)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_status VARCHAR2(1);',
'  v_message VARCHAR2(4000);',
'  v_expr VARCHAR2(4000);',
'  v_hotel_id VARCHAR2(32) := :P0_HOTEL_ID;',
'  l_json_clob clob := null;',
'BEGIN',
' -- v_expr := :P1050_EXPRESSION;',
'v_expr := REPLACE(:P1050_EXPRESSION, ''\_'', ''_'');',
'  UR_UTILS.validate_expression(v_expr, ''V'', v_hotel_id, v_status, v_message);',
'',
'  UR_UTILS.add_alert(l_json_clob,v_message , v_status , null, null, l_json_clob);',
'',
'  :P0_ALERT_MESSAGE := l_json_clob;',
'',
'END;',
''))
,p_attribute_02=>'P0_HOTEL_ID,P1050_EXPRESSION'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10427749012683945)
,p_name=>'Btn Clicked'
,p_event_sequence=>180
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11678142393603145)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10427894639683946)
,p_event_id=>wwv_flow_imp.id(10427749012683945)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_EXPRESSION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(10427928401683947)
,p_name=>'Btn Clicked Delete'
,p_event_sequence=>190
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(11678496244603148)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(10428164755683949)
,p_event_id=>wwv_flow_imp.id(10427928401683947)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>'Button Definition Missing'
,p_attribute_02=>'Button Definition Missing'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12543491477179908)
,p_name=>'Append Column'
,p_event_sequence=>200
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_ATTRIBUTES'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12543565629179909)
,p_event_id=>wwv_flow_imp.id(12543491477179908)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*(function(){',
'  var col = $v("P1050_ATTRIBUTES");',
'  if(!col) return;',
'',
'  var exp = $v("P1050_EXPRESSION") || "";',
'  var newExp = exp ? (exp + " " + col) : col;',
'  $s("P1050_EXPRESSION", newExp);',
'',
'  // clear the select so user can choose again if needed',
'  $s("P1050_ATTRIBUTES", "");',
'})();*/',
'',
'(function(){',
'  var col = $v("P1050_ATTRIBUTES");',
'  if(!col) return;',
'  insertAtSavedPos("P1050_EXPRESSION", col);',
'  $s("P1050_ATTRIBUTES", "");',
'})();',
'',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12543667889179910)
,p_name=>'Append Operator'
,p_event_sequence=>210
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_OPERATORS'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12543750835179911)
,p_event_id=>wwv_flow_imp.id(12543667889179910)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*(function(){',
'  var op = $v("P1050_OPERATORS");',
'  if(!op) return;',
'',
'  var exp = $v("P1050_EXPRESSION") || "";',
'',
'  // helper: last non-empty token',
'  function lastToken(s){',
'    if(!s) return "";',
'    var arr = s.trim().split(/\s+/);',
'    for(var i=arr.length-1;i>=0;i--){',
'      if(arr[i] !== "") return arr[i];',
'    }',
'    return "";',
'  }',
'',
'  // operator set for validation (keywords and comparison ops)',
'  var ops = [''AND'',''OR'',''NOT'',''='',''!='',''<>'',''>'',''<'',''>='',''<='',''LIKE'',''IN'',''BETWEEN''];',
'',
'  function isOperator(tok){',
'    if(!tok) return false;',
'    // strip trailing commas/parens',
'    tok = tok.replace(/,$/,"").toUpperCase();',
'    return ops.indexOf(tok) !== -1;',
'  }',
'',
'  var last = lastToken(exp);',
'  if(isOperator(last) && isOperator(op)){',
'    apex.message.alert("Invalid: cannot add two operators in a row.");',
'    $s("P1050_OPERATORS",""); // reset selection',
'    return;',
'  }',
'',
'  var newExp = exp ? (exp + " " + op) : op;',
'  $s("P1050_EXPRESSION", newExp);',
'  $s("P1050_OPERATORS",""); // reset selection',
'})();',
'*/',
'(function(){',
'  var op = $v("P1050_OPERATORS");',
'  if(!op) return;',
'',
'  var exp = $v("P1050_EXPRESSION") || "";',
'  var lastToken = exp.trim().split(/\s+/).pop() || "";',
'  var operators = ["AND","OR","NOT","=","!=","<>",">","<",">=","<=","LIKE","IN","+","-","*","/"];',
'',
'  if (operators.includes(lastToken) && operators.includes(op)) {',
'    apex.message.alert("Two operators in a row are not allowed.");',
'    $s("P1050_OPERATORS", "");',
'    return;',
'  }',
'',
'  insertAtSavedPos("P1050_EXPRESSION", op);',
'  $s("P1050_OPERATORS", "");',
'})();',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12882910530327116)
,p_name=>'Fixed Lead Time'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_LEAD_TIME_TYPE'
,p_condition_element=>'P1050_LEAD_TIME_TYPE'
,p_triggering_condition_type=>'NOT_EQUALS'
,p_triggering_expression=>'F'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12883052847327117)
,p_event_id=>wwv_flow_imp.id(12882910530327116)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_TIME_TYPE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12883112647327118)
,p_event_id=>wwv_flow_imp.id(12882910530327116)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_TIME_FROM,P1050_LEAD_TIME_TO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12883264228327119)
,p_event_id=>wwv_flow_imp.id(12882910530327116)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_TIME_FROM,P1050_LEAD_TIME_TO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12883382200327120)
,p_event_id=>wwv_flow_imp.id(12882910530327116)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_TIME'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(13905483070313919)
,p_name=>'Change Stay Window'
,p_event_sequence=>230
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_STAY_WINDOW_CHECK'
,p_condition_element=>'P1050_STAY_WINDOW_CHECK'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13905521335313920)
,p_event_id=>wwv_flow_imp.id(13905483070313919)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    json clob := NULL;',
'begin',
'    UR_UTILS.ADD_ALERT(JSON, :P1050_STAY_WINDOW_CHECK,''S'',NULL,NULL,JSON);',
'    :P0_ALERT_MESSAGE := json;',
'end;'))
,p_attribute_02=>'P1050_STAY_WINDOW_CHECK'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13905887898313923)
,p_event_id=>wwv_flow_imp.id(13905483070313919)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_STAY_W_FROM,P1050_STAY_W_TO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13905746283313922)
,p_event_id=>wwv_flow_imp.id(13905483070313919)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_STAY_W_TO,P1050_STAY_W_FROM'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(13905909550313924)
,p_name=>'Change Lead Time'
,p_event_sequence=>240
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_LEAD_TIME_CHECK'
,p_condition_element=>'P1050_LEAD_TIME_CHECK'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13906091028313925)
,p_event_id=>wwv_flow_imp.id(13905909550313924)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_T_TYPE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13906467168313929)
,p_event_id=>wwv_flow_imp.id(13905909550313924)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_T_FROM,P1050_LEAD_T_TYPE,P1050_LEAD_T_TO,P1050_LEAD_T_TIME'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(13906171192313926)
,p_name=>'Change Lead Time Type'
,p_event_sequence=>250
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_LEAD_T_TYPE'
,p_condition_element=>'P1050_LEAD_T_TYPE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'F'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13906213069313927)
,p_event_id=>wwv_flow_imp.id(13906171192313926)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_T_FROM,P1050_LEAD_T_TO'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13906325630313928)
,p_event_id=>wwv_flow_imp.id(13906171192313926)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_T_TO,P1050_LEAD_T_FROM'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13906580635313930)
,p_event_id=>wwv_flow_imp.id(13906171192313926)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_T_TIME'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13906691669313931)
,p_event_id=>wwv_flow_imp.id(13906171192313926)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_LEAD_T_TIME'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(13906965295313934)
,p_name=>'Change DoW'
,p_event_sequence=>260
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_DOW_CHECK'
,p_condition_element=>'P1050_DOW_CHECK'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13907029943313935)
,p_event_id=>wwv_flow_imp.id(13906965295313934)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_DOW_DAYS'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13907189274313936)
,p_event_id=>wwv_flow_imp.id(13906965295313934)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_DOW_DAYS'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(13907442097313939)
,p_name=>'Changed Min Rate'
,p_event_sequence=>270
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1050_MIN_RATE_CHECK'
,p_condition_element=>'P1050_MIN_RATE_CHECK'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'Y'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13907588108313940)
,p_event_id=>wwv_flow_imp.id(13907442097313939)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_MIN_RATE'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(13907635208313941)
,p_event_id=>wwv_flow_imp.id(13907442097313939)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1050_MIN_RATE'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(18156988420285635)
,p_name=>'Click'
,p_event_sequence=>280
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(18156679423285632)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(18157097997285636)
,p_event_id=>wwv_flow_imp.id(18156988420285635)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  -- Original variables',
'  l_status    VARCHAR2(10);',
'  l_message   CLOB;',
'  l_icon      VARCHAR2(50);',
'  l_title     VARCHAR2(100);',
'  l_new_id    VARCHAR2(64) := NULL; -- HEX string for RAW',
'  l_payload   CLOB;',
'  l_json_clob CLOB := NULL;',
'  l_hotel_id  VARCHAR2(64) := NULL;',
'',
'  -- Variables for duplication logic',
'  l_timestamp_str   VARCHAR2(50);',
'  l_source_expression CLOB;',
'  l_new_name        VARCHAR2(4000);',
'  l_new_desc        VARCHAR2(4000);',
'BEGIN',
'UR_UTILS.add_alert(l_json_clob, ''HOTEL_ID:''|| :P1050_HOTEL_LIST || '' ALGO ID:'' || :P1050_ALGO_LIST || '' Version ID:'' || :P1050_VERSION, ''E'', null, null, l_json_clob);',
'  -- 1. Check for required page items to perform a duplication',
'  IF :P1050_ALGO_LIST IS NULL OR :P1050_ALGO_LIST = ''00'' THEN',
'     UR_UTILS.add_alert(l_json_clob, ''Please select an existing strategy to duplicate.'', ''E'', null, null, l_json_clob);',
'     :P0_ALERT_MESSAGE := l_json_clob;',
'     RETURN;',
'  END IF;',
'  ',
'  IF :P1050_VERSION IS NULL THEN',
'     UR_UTILS.add_alert(l_json_clob, ''Please select a version to copy the expression from.'', ''E'', null, null, l_json_clob);',
'     :P0_ALERT_MESSAGE := l_json_clob;',
'     RETURN;',
'  END IF;',
'',
'  BEGIN',
'    SELECT EXPRESSION',
'    INTO   l_source_expression',
'    FROM   UR_ALGO_VERSIONS',
'    WHERE  ID = :P1050_VERSION; ',
'    select hotel_id',
'    into l_hotel_id',
'    from UR_ALGOS',
'    where id = :P1050_ALGO_LIST;',
'  EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'      UR_UTILS.add_alert(l_json_clob, ''Could not find the selected source version to copy.'', ''E'', null, null, l_json_clob);',
'      :P0_ALERT_MESSAGE := l_json_clob;',
'      RETURN;',
'    WHEN OTHERS THEN',
'      UR_UTILS.add_alert(l_json_clob, ''Error fetching source expression: '' || SQLERRM, ''E'', null, null, l_json_clob);',
'      :P0_ALERT_MESSAGE := l_json_clob;',
'      RETURN;',
'  END;',
'',
'  -- 3. Define the new name and description with a timestamp',
'  l_timestamp_str := '' - Copied '' || TO_CHAR(SYSTIMESTAMP, ''YYYY-MM-DD HH24:MI:SS'');',
'  l_new_name := :P1050_NAME || l_timestamp_str;',
'  if :P1050_DESCRIPTION is not null',
'  then',
'    l_new_desc := :P1050_DESCRIPTION || l_timestamp_str;',
'  else',
'    l_new_desc := NULL;',
'  END IF;',
'',
'  l_payload := ''{"NAME":"''|| l_new_name ||''",',
'                "HOTEL_ID":"''|| :P0_HOTEL_ID ||''",',
'                "DESCRIPTION":"''|| l_new_desc ||''"}'';',
'  UR_UTILS.add_alert(l_json_clob, ''l_Payload:''|| l_payload, ''E'', null, null, l_json_clob);',
'  ',
'  Graph_SQL.proc_crud_json(',
'    p_mode    => ''C'',',
'    p_table   => ''UR_ALGOS'',',
'    p_payload => l_payload,',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'  ',
'  UR_UTILS.add_alert(l_json_clob, l_message, l_status, null, null, l_json_clob);',
'',
' ',
'  IF upper(l_status) = ''S'' THEN',
'',
'    l_new_id := REGEXP_SUBSTR(',
'                  l_message,',
'                  ''New ID *=([0-9A-F]{32})'',',
'                  1, 1, NULL, 1',
'                );',
'',
'    IF l_new_id IS NOT NULL THEN',
'      -- 6. Create the new Algo Version record in UR_ALGO_VERSIONS',
'',
'      l_payload := ''{"ALGO_ID":"''|| l_new_id ||''", ',
'                "EXPRESSION":"''|| l_source_expression ||''"}'';',
'        UR_UTILS.add_alert(l_json_clob, ''l_Payload:''|| l_payload, ''E'', null, null, l_json_clob);',
'      Graph_SQL.proc_crud_json(',
'        p_mode    => ''C'',',
'        p_table   => ''UR_ALGO_VERSIONS'',',
'        p_payload => l_payload,',
'        p_debug   => ''N'',',
'        p_status  => l_status,',
'        p_message => l_message,',
'        p_icon    => l_icon,',
'        p_title   => l_title',
'      );',
'      ',
'      UR_UTILS.add_alert(l_json_clob, l_message, l_status, null, null, l_json_clob);',
'',
'    ELSE',
'      -- This means Algo creation said ''S'' but we couldn''t parse the new ID',
'      UR_UTILS.add_alert(l_json_clob, ''Algo copy created, but failed to extract new ID. Version was not copied.'', ''E'', null, null, l_json_clob);',
'    END IF;',
'  ',
'  END IF; -- End of Algo creation success check',
'',
'  :P0_ALERT_MESSAGE := l_json_clob;',
'',
'END;'))
,p_attribute_02=>'P1050_VERSION,P1050_ALGO_LIST,P1050_NAME,P1050_DESCRIPTION,P1050_HOTEL_LIST'
,p_attribute_03=>'P0_ALERT_MESSAGE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12462262366188338)
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
'              TRIM(:P1050_TEMPLATE_NAME),',
'              ''^[^A-Za-z0-9]+|[^A-Za-z0-9]+$'', ''''',
'            ),',
'            ''[^A-Za-z0-9]+'', ''_''',
'          ),',
'          ''_+'', ''_''',
'        ),',
'        1, 110',
'      )',
'    ),',
'    :P1050_TEMPLATE_NAME,',
'    :P1050_TEMPLATE_TYPE,',
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
'--   :P1050_AI_RESPONSE := ''Insert Successful'';',
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
'    -- :P1050_AI_RESPONSE := ''Insert Failed: '' || SQLERRM;',
'    apex_debug.message(''Insert Failed: '' || SQLERRM);',
'    -- RETURN ''Failed ''||SQLERRM;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Blah blah blah'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Succesfully Done'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>12462262366188338
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(14722934911617503)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_LOV_DATA'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_hotel_id VARCHAR2(255) := apex_application.g_x01;',
'    l_current_algo_id VARCHAR2(255) := apex_util.get_session_state(''P1050_ALGO_LIST'');',
'BEGIN',
'    INSERT INTO debug_log(message) VALUES(''--- GET_LOV_DATA for hotel_id: '' || l_hotel_id || '', current_algo_id: '' || l_current_algo_id);',
'',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object; -- Start the main JSON object',
'',
'    -- Fetch Attributes as {id, name} pairs (includes regular attributes AND strategies)',
'    apex_json.open_array(''attributes'');',
'',
'    -- Regular attributes',
'    FOR rec IN (',
'        -- MODIFICATION: Select the ID from the attributes table',
'        SELECT',
'            a.id,',
'            a.name || '' ('' || (SELECT name FROM ur_templates WHERE id = a.template_id) || ''||'' || a.ATTRIBUTE_QUALIFIER || '')'' AS name',
'        FROM',
'            ur_algo_attributes a, ur_templates t',
'        WHERE',
'            a.hotel_id = l_hotel_id',
'            and a.template_id = t.id',
'            and t.active = ''Y''',
'        ORDER BY',
'            name',
'    ) LOOP',
'        -- MODIFICATION: Write an object instead of a string for each record',
'        apex_json.open_object;',
'        apex_json.write(''id'', rec.id);',
'        apex_json.write(''name'', rec.name);',
'        apex_json.close_object;',
'    END LOOP;',
'',
'        -- Global attributes',
'    FOR rec IN (',
'        -- MODIFICATION: Select the ID from the attributes table',
'        SELECT',
'            a.id,',
'            a.name || '' (Global Attributes'' || ''||'' || a.ATTRIBUTE_QUALIFIER || '')'' AS name',
'        FROM',
'            ur_algo_attributes a',
'        WHERE',
'            a.hotel_id = l_hotel_id',
'            -- and a.template_id = null',
'            and a.attribute_qualifier like ''PRICE_OVERRIDE%''',
'            and a.type = ''C''',
'        ORDER BY',
'            name',
'    ) LOOP',
'        -- MODIFICATION: Write an object instead of a string for each record',
'        apex_json.open_object;',
'        apex_json.write(''id'', rec.id);',
'        apex_json.write(''name'', rec.name);',
'        apex_json.close_object;',
'    END LOOP;',
'',
'    -- Strategies (appended to same array - Strategy template, empty qualifier)',
'    FOR rec IN (',
'        SELECT',
'            a.id,',
'            a.name || '' (Strategy||Strategy)'' AS name',
'        FROM',
'            ur_algos a',
'        WHERE',
'            a.hotel_id = l_hotel_id',
'            AND a.id != NVL(l_current_algo_id, ''-1'')  -- Exclude current strategy',
'            -- AND v.is_active = ''Y''                      -- Active versions only',
'        ORDER BY',
'            a.name',
'    ) LOOP',
'        apex_json.open_object;',
'        apex_json.write(''id'', ''STRAT_'' || rec.id);  -- Prefix for backend identification',
'        apex_json.write(''name'', rec.name);',
'        apex_json.close_object;',
'    END LOOP;',
'',
'    apex_json.close_array;',
'',
'    -- Fetch Property Types as {id, name} pairs',
'    apex_json.open_array(''propertyTypes'');',
'    FOR rec IN (',
'        -- MODIFICATION: Select the ID from the templates table',
'        SELECT',
'            id,',
'            name',
'        FROM',
'            ur_templates',
'        WHERE',
'            hotel_id = l_hotel_id',
'            AND type = ''RST''',
'            and active = ''Y''',
'        ORDER BY',
'            name',
'    ) LOOP',
'        -- MODIFICATION: Write an object instead of a string',
'        apex_json.open_object;',
'        apex_json.write(''id'', rec.id);',
'        apex_json.write(''name'', rec.name);',
'        apex_json.close_object;',
'    END LOOP;',
'    apex_json.close_array;',
'',
'    -- Fetch Occupancy Attribute (CALCULATED_OCCUPANCY only)',
'    apex_json.open_array(''occupancyAttributes'');',
'    FOR rec IN (',
'        SELECT',
'            a.id,',
'            a.name',
'        FROM',
'            ur_algo_attributes a',
'        WHERE',
'            a.hotel_id = l_hotel_id',
'            AND a.attribute_qualifier = ''CALCULATED_OCCUPANCY''',
'            AND a.type = ''C''',
'    ) LOOP',
'        apex_json.open_object;',
'        apex_json.write(''id'', rec.id);',
'        apex_json.write(''name'', rec.name);',
'        apex_json.close_object;',
'    END LOOP;',
'    apex_json.close_array;',
'',
'       -- Fetch Lead Time Attributes as {id, name} pairs',
'    apex_json.open_array(''leadTimeAttributes'');',
'    FOR rec IN (',
'        -- MODIFICATION: Select the ID from the attributes table',
'        SELECT',
'            a.id,',
'            a.name || '' ('' || t.name || '')'' AS name',
'        FROM',
'            ur_algo_attributes a,',
'            ur_templates t',
'        WHERE',
'            a.template_id = t.id',
'            AND a.hotel_id = l_hotel_id',
'            AND a.attribute_qualifier = ''BOOKING_DATE''',
'        ORDER BY',
'            name',
'    ) LOOP',
'        -- MODIFICATION: Write an object instead of a string',
'        apex_json.open_object;',
'        apex_json.write(''id'', rec.id);',
'        apex_json.write(''name'', rec.name);',
'        apex_json.close_object;',
'    END LOOP;',
'    apex_json.close_array;',
'    ',
'    apex_json.close_object; -- Close the main JSON object',
'',
'    -- Set the response header and print the generated JSON',
'    owa_util.mime_header(''application/json'', TRUE);',
'    htp.p(apex_json.get_clob_output);',
'    ',
'    -- Free the resources used by the writer',
'    apex_json.free_output;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- Always free resources, even if an error occurs',
'        apex_json.free_output; ',
'        owa_util.mime_header(''application/json'', TRUE);',
'        htp.p(''{"error":"Could not fetch LoV data. SQLERRM: '' || apex_escape.js_literal(sqlerrm) || ''"}'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>14722934911617503
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(16205839859926305)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_ALGORITHM_DATA'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    -- Read the standard parameters',
'    l_mode         VARCHAR2(1)      := apex_application.g_x01;',
'    l_algo_id_str  VARCHAR2(255)    := apex_application.g_x02;',
'    l_algo_name    VARCHAR2(255)    := apex_application.g_x03;',
'    l_algo_desc    VARCHAR2(4000)   := apex_application.g_x04;',
'    l_hotel_id_str VARCHAR2(255)    := apex_application.g_x05;',
'',
'    -- Declare variables for processing',
'    l_json_payload CLOB;',
'    l_new_algo_id  ur_algos.id%TYPE; -- This is RAW(16)',
'    l_new_algo_version_id ur_algos.id%TYPE;',
'BEGIN',
'    -- Rebuild the CLOB from the f01 array (This logic is correct and remains)',
'    dbms_lob.createtemporary(lob_loc => l_json_payload, cache => TRUE);',
'    FOR i IN 1..apex_application.g_f01.count LOOP',
'        dbms_lob.append(dest_lob => l_json_payload, src_lob => apex_application.g_f01(i));',
'    END LOOP;',
'',
'    -- Initialize JSON output',
'    apex_json.open_object;',
'',
'    -- CASE 1: Create a new Algorithm (Mode ''I'')',
'    IF l_mode = ''I'' THEN',
'        INSERT INTO ur_algos (name, description, hotel_id)',
'        VALUES (l_algo_name, l_algo_desc, HEXTORAW(l_hotel_id_str))',
'        RETURNING id INTO l_new_algo_id;',
'',
'        INSERT INTO ur_algo_versions (algo_id, expression)',
'        VALUES (l_new_algo_id, l_json_payload)',
'        RETURNING ID INTO l_new_algo_version_id;',
'',
'        apex_json.write(''success'', true);',
'        apex_json.write(''message'', ''New strategy and version created successfully!'');',
'        apex_json.write(''newAlgoId'', RAWTOHEX(l_new_algo_id));',
'        -- apex_json.write(''newAlgoName'', l_algo_name);',
'        -- apex_json.write(''newAlgoDescription'', l_algo_desc);',
'        -- apex_json.write(''newAlgoVersion'', RAWTOHEX(l_new_algo_version_id));',
'',
'    -- CASE 2: Create a new Version for an existing Algorithm (Mode ''U'')',
'    ELSIF l_mode = ''U'' THEN',
'        INSERT INTO ur_algo_versions (algo_id, expression)',
'        VALUES (HEXTORAW(l_algo_id_str), l_json_payload);',
'',
'        apex_json.write(''success'', true);',
'        apex_json.write(''message'', ''New version saved successfully!'');',
'        apex_json.write(''newAlgoId'', l_algo_id_str);',
'    ',
'    ELSE',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', ''Invalid operation mode specified.'');',
'    END IF;',
'',
'    apex_json.close_object;',
'    ',
'    -- Free the temporary LOB',
'    dbms_lob.freetemporary(lob_loc => l_json_payload);',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- Ensure LOB is freed even on error',
'        IF dbms_lob.istemporary(l_json_payload) = 1 THEN',
'            dbms_lob.freetemporary(lob_loc => l_json_payload);',
'        END IF;',
'',
'        -- APEX automatically handles freeing JSON output on error.',
'        -- We just need to construct the error response.',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', ''Database error: '' || apex_escape.html(SQLERRM));',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>16205839859926305
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12461841137188336)
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
'     WHERE NAME = :P1050_FILE_LOAD',
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
,p_internal_uid=>12461841137188336
);
wwv_flow_imp.component_end;
end;
/
