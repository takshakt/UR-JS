prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_page.create_page(
 p_id=>2
,p_name=>'Hotel TEST'
,p_alias=>'HOTEL-TEST'
,p_step_title=>'Hotel TEST'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function(){',
'  // helper: render stars',
'  function renderStarsVal(n){',
'    n = Number(n) || 0;',
'    if(n < 0) n = 0;',
'    if(n > 5) n = 5;',
unistr('    return ''\2605''.repeat(n) + ''\2606''.repeat(5-n);'),
'  }',
'',
'  // populate a single select element with LOV options from GET_LOV',
'  function loadLovInto(selectEl, lovType, currentVal){',
'    if(!selectEl) return;',
'    selectEl.disabled = true;',
'    selectEl.innerHTML = ''<option>Loading...</option>'';',
'',
'    apex.server.process(''GET_LOV'', { x01: lovType }, {',
'      dataType: ''json'',',
'      success: function(data){',
'        selectEl.innerHTML = '''';',
'        data.forEach(function(opt){',
'          var o = document.createElement(''option'');',
'          o.value = opt.r === null ? '''' : String(opt.r);',
'          o.text = opt.d === null ? '''' : opt.d;',
'          selectEl.appendChild(o);',
'        });',
'        try { selectEl.value = currentVal || ''''; } catch(e){ }',
'        selectEl.disabled = false;',
'      },',
'      error: function(){',
'        selectEl.innerHTML = ''<option value="">- Error loading -</option>'';',
'        selectEl.disabled = false;',
'      }',
'    });',
'  }',
'',
'  // main delegated click handler',
'  document.addEventListener("click", function(e){',
'    var starBtn = e.target.closest(".star-btn");',
'    var actionBtn = e.target.closest(".js-edit, .js-save, .js-cancel");',
'',
'    // ===== STAR CLICK =====',
'    if(starBtn){',
'      var container = starBtn.closest(".stars-edit");',
'      if(!container) return;',
'      var valueInput = container.querySelector(".star-value");',
'      var value = parseInt(starBtn.dataset.value) || 0;',
'',
'      valueInput.value = value;',
'',
'      // Update edit mode stars',
'      container.querySelectorAll(".star-btn .star").forEach((starEl, idx)=>{',
'        if(idx < value){',
'          starEl.classList.add("text-yellow-400"); starEl.classList.remove("text-gray-300");',
'        } else {',
'          starEl.classList.add("text-gray-300"); starEl.classList.remove("text-yellow-400");',
'        }',
'      });',
'',
'      // Update view mode stars',
'      var viewMode = container.closest(".field").querySelector(".stars-view");',
'      if(viewMode){',
'        viewMode.dataset.rating = value;',
'        viewMode.querySelectorAll(".star").forEach((starEl, idx)=>{',
'          if(idx < value){',
'            starEl.classList.add("text-yellow-400"); starEl.classList.remove("text-gray-300");',
'          } else {',
'            starEl.classList.add("text-gray-300"); starEl.classList.remove("text-yellow-400");',
'          }',
'        });',
'      }',
'      return; // stop here for star click',
'    }',
'',
'    if(!actionBtn) return;',
'',
'    var card = actionBtn.closest(''.hotel-card'');',
'    if(!card) return;',
'',
'    // ===== EDIT =====',
'    if(actionBtn.classList.contains(''js-edit'')){',
'      card.querySelectorAll(''.view-mode'').forEach(el=>el.style.display=''none'');',
'      card.querySelectorAll(''.edit-mode'').forEach(el=>el.style.display=''inline-block'');',
'',
'      // populate LOVs',
'      var groupField = card.querySelector(''[data-col="GROUP_ID"] .group-lov'');',
'      if(groupField) loadLovInto(groupField, ''group'', card.querySelector(''[data-col="GROUP_ID"]'').dataset.value || '''');',
'      var addrField = card.querySelector(''[data-col="ADDRESS_ID"] .addr-lov'');',
'      if(addrField) loadLovInto(addrField, ''addr'', card.querySelector(''[data-col="ADDRESS_ID"]'').dataset.value || '''');',
'      var contactField = card.querySelector(''[data-col="CONTACT_ID"] .contact-lov'');',
'      if(contactField) loadLovInto(contactField, ''contact'', card.querySelector(''[data-col="CONTACT_ID"]'').dataset.value || '''');',
'',
'// Initialize STAR_RATING edit stars',
'var starField = card.querySelector(''[data-col="STAR_RATING"]'');',
'if(starField){',
'  var value = parseInt(starField.dataset.value) || 0;',
'  var valueInput = starField.querySelector(''.star-value'');',
'  if(valueInput) valueInput.value = value;',
'',
'  // Update stars visually',
'  starField.querySelectorAll(''.star-btn .star'').forEach((starEl, idx)=>{',
'    if(idx < value){',
'      starEl.classList.add(''text-yellow-400''); starEl.classList.remove(''text-gray-300'');',
'    } else {',
'      starEl.classList.add(''text-gray-300''); starEl.classList.remove(''text-yellow-400'');',
'    }',
'  });',
'}',
'',
'',
'',
'      card.querySelectorAll(''.js-edit'').forEach(b=>b.style.display=''none'');',
'      card.querySelectorAll(''.js-save,.js-cancel'').forEach(b=>b.style.display=''inline-block'');',
'      return;',
'    }',
'',
'    // ===== CANCEL =====',
'    if(actionBtn.classList.contains(''js-cancel'')){',
'      card.querySelectorAll(''.edit-mode'').forEach(el=>el.style.display=''none'');',
'      card.querySelectorAll(''.view-mode'').forEach(el=>el.style.display='''');',
'      card.querySelectorAll(''.js-edit'').forEach(b=>b.style.display=''inline-block'');',
'      card.querySelectorAll(''.js-save,.js-cancel'').forEach(b=>b.style.display=''none'');',
'      var s = card.querySelector(''.status-msg''); if(s) s.textContent = '''';',
'      return;',
'    }',
'',
'    // ===== SAVE =====',
'if(actionBtn.classList.contains(''js-save'')){',
'  var id = card.dataset.id;',
'  if(!id){',
'    apex.message.showErrors([{ type:''error'', location:''page'', message:''Missing record ID'', unsafe:false }]);',
'    return;',
'  }',
'',
'  var payload = { ID: id };',
'  var changed = false;',
'',
'  card.querySelectorAll(''.field'').forEach(function(field){',
'    var col = (field.dataset.col || '''').toUpperCase();',
'    if(!col) return;',
'',
'    var orig = field.dataset.value !== undefined ? String(field.dataset.value) : '''';',
'',
'    var sel = field.querySelector(''select.edit-mode'');',
'    var input = field.querySelector(''input.edit-mode'');',
'    var starInput = field.querySelector(''.star-value''); // NEW: hidden star input',
'',
'    if(sel){',
'      var val = sel.value === '''' ? null : sel.value;',
'      if(String(val) !== String(orig)){ payload[col]=val; changed=true; }',
'    } ',
'    else if(starInput){   // NEW: check for star-value',
'      var val = starInput.value;',
'      if(String(val) !== String(orig)){ payload[col] = val; changed = true; }',
'    }',
'    else if(input){',
'      var val = input.value;',
'      if(String(val) !== String(orig)){ payload[col]=val; changed=true; }',
'    }',
'  });',
'',
'  if(!changed){',
'    card.querySelectorAll(''.edit-mode'').forEach(el=>el.style.display=''none'');',
'    card.querySelectorAll(''.view-mode'').forEach(el=>el.style.display='''');',
'    card.querySelectorAll(''.js-edit'').forEach(b=>b.style.display=''inline-block'');',
'    card.querySelectorAll(''.js-save,.js-cancel'').forEach(b=>b.style.display=''none'');',
'    return;',
'  }',
'',
'  // AJAX SAVE',
'  apex.server.process(''SAVE_CARD'', { x01: JSON.stringify(payload) }, {',
'    dataType:''json'',',
'    success: function(res){',
'      if(!res){ apex.message.showErrors([{type:''error'', location:''page'', message:''Empty server response'', unsafe:false}]); return; }',
'',
'      // Show toast',
'      Swal.fire({',
'        icon: res.alert_icon || ''info'',',
'        title: res.alert_title || ''Notice'',',
'        text: res.alert_message || res.message || '''',',
'        timer: res.alert_timer || 3000,',
'        timerProgressBar:true,',
'        toast:true,',
'        position:''top-end'',',
'        showConfirmButton:false',
'      });',
'',
'      if(res.status && String(res.status).toUpperCase()===''S''){',
'        apex.region("hotel_card_region").refresh();',
'      } else {',
'        apex.message.showErrors([{type:''error'', location:''page'', message: res.message || ''Save failed'', unsafe:false}]);',
'      }',
'    },',
'    error:function(jqXHR,textStatus,errorThrown){',
'      apex.message.showErrors([{type:''error'', location:''page'', message:errorThrown||''Server error'', unsafe:false}]);',
'    }',
'  });',
'}',
'',
'  });',
'})();',
''))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--#APP_FILES#Interactive report#MIN#.css',
'',
'https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css',
'',
'https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css',
'',
'',
'',
'',
'',
'',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Tailwind CDN */',
'@import url("https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css");',
'',
'/* ----------------------- Hotel Card Layout ----------------------- */',
'#hotel_card_container { width: 100%; }',
'',
'.hotel-card {',
'    display: flex;',
'    flex-wrap: nowrap;           /* prevent image pushing down */',
'    gap: 2rem;',
'    background: #ffffff !important;',
'    color: #111827 !important;',
'    border-radius: 0.5rem;',
'    box-shadow: 0 8px 24px rgba(15, 23, 42, 0.12);',
'    padding: 2rem;',
'    align-items: flex-start;     /* align text and image properly */',
'}',
'',
'.hotel-card .flex-1 {',
'    min-width: 0;                /* allows text to shrink */',
'    flex: 1 1 auto;              /* grow/shrink as needed */',
'}',
'',
'.hotel-card .hotel-content { min-width: 0; } /* allow text wrap */',
'',
'/* ----------------------- Image Box ----------------------- */',
'.hotel-card .hotel-image-box {',
'    flex-shrink: 0;',
'    width: 20rem;',
'    background: #f8fafc;',
'    border-radius: 0.5rem;',
'    padding: 1rem;',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'}',
'',
'.hotel-card .hotel-image-box img {',
'    max-width: 100%;',
'    max-height: 20rem;',
'    object-fit: contain;',
'}',
'',
'/* ----------------------- Hotel Name ----------------------- */',
'.hotel-card .hotel-name-input,',
'.hotel-card .field[data-col="HOTEL_NAME"] .view-mode {',
'    font-family: ''Inter'', ''Segoe UI'', ''Arial'', sans-serif;',
'    font-weight: 700;            /* bold */',
'    font-size: 2.25rem;          /* big but safe */',
'    line-height: 1.2;',
'    white-space: normal;          /* allow wrapping */',
'    word-break: break-word;',
'    color: #111827;',
'    max-width: 100%;',
'    margin-bottom: 0.25rem;',
'}',
'',
'/* ----------------------- Group Name ----------------------- */',
'.hotel-card .field[data-col="GROUP_ID"] .view-mode {',
'    font-family: ''Inter'', sans-serif;',
'    font-weight: 500;',
'    font-size: 1.25rem;',
'    color: #374151; /* darker gray */',
'}',
'',
'/* ----------------------- Address & Contact ----------------------- */',
'.hotel-card .field[data-col="ADDRESS_ID"] .view-mode,',
'.hotel-card .field[data-col="CONTACT_ID"] .view-mode {',
'    font-family: ''Inter'', sans-serif;',
'    font-size: 1rem;',
'    color: #4b5563;  /* medium gray */',
'}',
'',
'/* ----------------------- Stars ----------------------- */',
'.stars-view .star,',
'.stars-edit .star-btn .star {',
'    font-family: ''Segoe UI Symbol'', ''Arial'', sans-serif;',
'    font-size: 2rem;           /* large stars */',
'    line-height: 1;',
'    transition: color 0.2s ease-in-out;',
'}',
'',
'/* Hover effect for edit stars */',
'.stars-edit .star-btn:hover .star {',
'    color: #facc15; /* bright yellow */',
'}',
'',
'/* ----------------------- Edit Mode & Field Labels ----------------------- */',
'.hotel-card .field label,',
'.hotel-card .field .text-sm {',
'    display: none; /* hide in view mode */',
'}',
'.hotel-card.editing .field label,',
'.hotel-card.editing .field .text-sm {',
'    display: block;',
'    color: #6b7280;',
'    font-size: 0.85rem;',
'    margin-bottom: 0.25rem;',
'}',
'',
'/* Inputs & selects in edit mode */',
'.hotel-card .edit-mode {',
'    background-color: #ffffff !important;',
'    color: #111827 !important;',
'    font-family: ''Inter'', sans-serif;',
'}',
'',
'/* ----------------------- View Mode ----------------------- */',
'.hotel-card .view-mode {',
'    display: block;',
'    color: #111827;',
'}',
'',
'/* ----------------------- Actions ----------------------- */',
'.hotel-card .actions button {',
'    cursor: pointer;',
'}',
'',
'/* ----------------------- Responsive ----------------------- */',
'@media (max-width: 900px) {',
'    .hotel-card { flex-direction: column; }',
'    .hotel-card .hotel-image-box img { max-height: 200px; }',
'}',
'',
'/* ----------------------- Optional fine tuning ----------------------- */',
'.hotel-card .field .view-mode,',
'.hotel-card .field label {',
'    font-family: ''Inter'', ''Segoe UI'', ''Arial'', sans-serif;',
'    font-size: 0.875rem; /* small labels */',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(23521356890676856)
,p_plug_name=>'Main Region'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_grid_column_span=>8
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<!-- Popup Modal for New Address -->',
'<div id="new-address-modal" ',
'     class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">',
'',
'  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-6 w-96">',
'    <!-- Header -->',
'    <h2 class="text-xl font-semibold text-gray-900 dark:text-gray-100 mb-4">',
'      Define New Address',
'    </h2>',
'',
'    <!-- Address Input -->',
'    <input type="text" id="new-address-input" ',
'           placeholder="Enter new address"',
'           class="w-full border rounded px-3 py-2 mb-4 focus:ring focus:ring-blue-400" />',
'',
'    <!-- Buttons -->',
'    <div class="flex justify-end space-x-2">',
'      <button id="cancel-new-address" ',
'              class="px-4 py-2 rounded bg-gray-300 hover:bg-gray-400 text-gray-800">',
'        Cancel',
'      </button>',
'      <button id="save-new-address" ',
'              class="px-4 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white">',
'        Save',
'      </button>',
'    </div>',
'  </div>',
'',
'</div>',
''))
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(23522875894676871)
,p_plug_name=>'hotel_card_region'
,p_region_name=>'hotel_card_region'
,p_parent_plug_id=>wwv_flow_imp.id(23521356890676856)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_plug_grid_column_span=>7
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<style>',
unistr('/* minimal styling \2014 tweak to match screenshot */'),
'.hotel-card { max-width:700px; padding:20px; border-radius:10px; background:#fff; box-shadow:0 6px 18px rgba(0,0,0,0.08); }',
'.hotel-card .muted { color:#6b7280; font-size:0.9rem; }',
'.hotel-card .hotel-name { font-size:2rem; margin:6px 0; color:#111827; }',
'.hotel-card .stars { color:#111; margin-bottom:8px; }',
'.hotel-card .label { color:#6b7280; font-size:0.85rem; }',
'.hotel-card .value { color:#111827; font-size:0.95rem; }',
'.actions { margin-top:12px; }',
'.hidden { display:none !important; }',
'.inline-editor { width:100%; box-sizing:border-box; padding:6px; font-size:0.95rem; }',
'.status-msg { margin-left:10px; font-size:0.9rem; color: #6b7280; }',
'</style>',
'',
'<div class="hotel-card" data-id="&P2_HOTEL_LIST.">',
'  <div class="muted">Group Name</div>',
'  <h1 class="hotel-name" data-col="GROUP_NAME" data-type="text">&P2_GROUP_NAME.</h1>',
'',
'  <div class="muted">Hotel Name</div>',
'  <div class="value" data-col="HOTEL_NAME" data-type="text">&P2_HOTEL_NAME.</div>',
'',
'  <div class="muted">Rating</div>',
'  <div class="value" data-col="STARS" data-type="number">&P2_STARS.</div>',
'',
'  <div class="muted">Address (Google Map Link)</div>',
'  <div class="value">',
'    <a target="_blank" href="https://maps.google.com/?q=&P2_ADDRESS.">',
'      <span data-col="ADDRESS" data-type="text">&P2_ADDRESS.</span>',
'    </a>',
'  </div>',
'',
'  <div class="muted">Contact (Call Link)</div>',
'  <div class="value">',
'    <a href="tel:&P2_CONTACT_NO."><span data-col="CONTACT_NO" data-type="text">&P2_CONTACT_NO.</span></a>',
'  </div>',
'',
'  <div class="actions">',
'    <button type="button" id="btnEdit" class="t-Button">Edit</button>',
'    <button type="button" id="btnSave" class="t-Button" style="display:none">Save</button>',
'    <button type="button" id="btnCancel" class="t-Button" style="display:none">Cancel</button>',
'    <span class="status-msg" aria-live="polite"></span>',
'  </div>',
'</div>',
'',
''))
,p_plug_display_condition_type=>'NEVER'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(23844006654388251)
,p_plug_name=>'HOTEL_LIST'
,p_region_name=>'hotel_card_region'
,p_parent_plug_id=>wwv_flow_imp.id(23521356890676856)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>90
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html         CLOB;',
'    l_id           ur_hotels.id%TYPE;',
'    l_group        ur_hotels.group_id%TYPE;',
'    l_group_name   ur_hotel_groups.group_name%TYPE;',
'    l_hotel_name   ur_hotels.hotel_name%TYPE;',
'    l_star         ur_hotels.star_rating%TYPE;',
'    l_addr         ur_hotels.address_id%TYPE;',
'    l_addr_text    ur_addresses.county%TYPE;',
'    l_contact      ur_hotels.contact_id%TYPE;',
'    l_contact_name ur_contacts.contact_name%TYPE;',
'    l_img_url      VARCHAR2(4000);',
'BEGIN',
'    BEGIN',
'        SELECT h.id,',
'               h.group_id,',
'               g.group_name,',
'               h.hotel_name,',
'               h.star_rating,',
'               h.address_id,',
'               a.county,',
'               h.contact_id,',
'               c.contact_name',
'          INTO l_id, l_group, l_group_name,',
'               l_hotel_name, l_star,',
'               l_addr, l_addr_text,',
'               l_contact, l_contact_name',
'          FROM ur_hotels h',
'          LEFT JOIN ur_hotel_groups g ON g.id = h.group_id',
'          LEFT JOIN ur_addresses a ON a.id = h.address_id',
'          LEFT JOIN ur_contacts c ON c.id = h.contact_id',
'         WHERE h.id = :P2_HOTEL_LIST;',
'',
'        -- Correct image URL',
'        l_img_url := apex_application.g_image_prefix ',
'                     || ''applications/'' || v(''APP_ID'') ',
'                     || ''/static/360-3608307_placeholder-hotel-house.png'';',
'',
'        l_html := ',
'''<div class="hotel-card flex bg-white rounded-lg shadow-lg p-6" data-id="''||RAWTOHEX(l_id)||''">',
'  <div class="flex-1">',
'',
'    <!-- Group -->',
'    <div class="mb-4 field" data-col="GROUP_ID" data-value="''||NVL(TO_CHAR(l_group),'''')||''">',
'      <div class="text-sm text-gray-500 mb-1">Group Name</div>',
'      <span class="view-mode text-gray-800">''||apex_escape.html(l_group_name)||''</span>',
'      <select class="edit-mode group-lov border rounded p-1" style="display:none;"></select>',
'    </div>',
'',
'    <!-- Hotel Name -->',
'    <div class="mb-4 field" data-col="HOTEL_NAME" data-value="''||apex_escape.html(l_hotel_name)||''">',
'      <label class="field-label text-sm text-gray-500 block mb-1">Hotel Name</label>',
'      <span class="view-mode text-gray-900">''||apex_escape.html(l_hotel_name)||''</span>',
'      <input type="text" class="edit-mode border rounded p-1 w-full" ',
'             value="''||apex_escape.html(l_hotel_name)||''" style="display:none;">',
'    </div>',
'',
'    <!-- Star Rating -->',
'    <div class="mb-4 field" data-col="STAR_RATING" data-value="''||NVL(TO_CHAR(l_star),''0'')||''">',
'      <label class="text-sm text-gray-500 block mb-1">Rating</label>',
'      <div class="view-mode stars-view flex space-x-1" data-rating="''||NVL(TO_CHAR(l_star),''0'')||''">'';',
'        FOR i IN 1..5 LOOP',
'          IF l_star >= i THEN',
unistr('            l_html := l_html || ''<span class="star filled text-yellow-400">\2605</span>'';'),
'          ELSE',
unistr('            l_html := l_html || ''<span class="star empty text-gray-300">\2606</span>'';'),
'          END IF;',
'        END LOOP;',
'        l_html := l_html || ''</div>',
'      <div class="edit-mode stars-edit flex space-x-1" style="display:none;">',
'        <input type="hidden" class="star-value" value="''||NVL(TO_CHAR(l_star),''0'')||''">',
unistr('        <button type="button" class="star-btn" data-value="1"><span class="star text-gray-300">\2605</span></button>'),
unistr('        <button type="button" class="star-btn" data-value="2"><span class="star text-gray-300">\2605</span></button>'),
unistr('        <button type="button" class="star-btn" data-value="3"><span class="star text-gray-300">\2605</span></button>'),
unistr('        <button type="button" class="star-btn" data-value="4"><span class="star text-gray-300">\2605</span></button>'),
unistr('        <button type="button" class="star-btn" data-value="5"><span class="star text-gray-300">\2605</span></button>'),
'      </div>',
'    </div>',
'',
'    <!-- Address -->',
'    <div class="mb-4 field" data-col="ADDRESS_ID" data-value="''||NVL(TO_CHAR(l_addr),'''')||''">',
'      <label class="text-sm text-gray-500 block mb-1">Address</label>',
'      <a class="view-mode text-gray-700" target="_blank" ',
'         href="https://maps.google.com/?q=''||APEX_UTIL.URL_ENCODE(NVL(l_addr_text,''''))||''">''||apex_escape.html(NVL(l_addr_text,''''))||''</a>',
'      <select class="edit-mode addr-lov border rounded p-1" style="display:none;"></select>',
'    </div>',
'',
'    <!-- Contact -->',
'    <div class="mb-6 field" data-col="CONTACT_ID" data-value="''||NVL(TO_CHAR(l_contact),'''')||''">',
'      <label class="text-sm text-gray-500 block mb-1">Contact</label>',
'      <a class="view-mode text-blue-600" ',
'         href="tel:''||REGEXP_REPLACE(NVL(l_contact_name,''''),''[[:space:]]'','''')||''">''||apex_escape.html(NVL(l_contact_name,''''))||''</a>',
'      <select class="edit-mode contact-lov border rounded p-1" style="display:none;"></select>',
'    </div>',
'',
'    <!-- Actions -->',
'    <div class="actions flex gap-2">',
'      <button type="button" class="t-Button js-edit bg-gray-800 text-white rounded px-4 py-2">Edit</button>',
'      <button type="button" class="t-Button js-save bg-blue-600 text-white rounded px-4 py-2 hidden">Save</button>',
'      <button type="button" class="t-Button js-cancel bg-gray-400 text-white rounded px-4 py-2 hidden">Cancel</button>',
'      <span class="status-msg ml-2 text-sm text-green-600" aria-live="polite"></span>',
'    </div>',
'  </div>',
'',
'  <!-- Image -->',
'  <div class="hotel-image-box ml-6 flex-shrink-0">',
'    <img src="''||l_img_url||''" alt="Hotel Image" class="w-48 h-48 object-contain bg-gray-50 rounded">',
'  </div>',
'</div>'';',
'',
'    EXCEPTION WHEN NO_DATA_FOUND THEN',
'        l_html := ''<div class="hotel-card">No hotel found</div>'';',
'    END;',
'',
'    RETURN l_html;',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P2_HOTEL_LIST'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23523124411676872)
,p_name=>'P2_GROUP_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(23521356890676856)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23523193919676873)
,p_name=>'P2_HOTEL_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(23521356890676856)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23523271134676874)
,p_name=>'P2_STARS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(23521356890676856)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23523531687676876)
,p_name=>'P2_ADDRESS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(23521356890676856)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23523636139676877)
,p_name=>'P2_CONTACT_NO'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(23521356890676856)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23523683618676878)
,p_name=>'P2_HOTEL_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(23521356890676856)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23525979212676882)
,p_name=>'P2_HOTEL_LIST'
,p_item_sequence=>20
,p_prompt=>'Hotel'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'  nvl(Hotel_NAME,''Name'') as Name,',
'ID as ID',
'FROM',
'UR_HOTELS',
'',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23848804428388280)
,p_name=>'P2_ALERT_MESSAGE'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23848920343388281)
,p_name=>'P2_ALERT_TITLE'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23849015653388282)
,p_name=>'P2_ALERT_ICON'
,p_item_sequence=>70
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23849195716388284)
,p_name=>'P2_ALERT_TIMER'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12180793159785187)
,p_name=>'On page load'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12181221020785188)
,p_event_id=>wwv_flow_imp.id(12180793159785187)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_name=>'Hide main region'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(23521356890676856)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12181630294785189)
,p_name=>'Change Hotel'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_HOTEL_LIST'
,p_condition_element=>'P2_HOTEL_LIST'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12182172277785191)
,p_event_id=>wwv_flow_imp.id(12181630294785189)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(23521356890676856)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12182611166785192)
,p_event_id=>wwv_flow_imp.id(12181630294785189)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(23521356890676856)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12176554960785174)
,p_name=>'New'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_NEW'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12177081988785175)
,p_event_id=>wwv_flow_imp.id(12176554960785174)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_NEW_1'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_util.get_blob_file_src("P2_NEW")',
''))
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12179387089785182)
,p_name=>'DA - Hotel list change'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P2_HOTEL_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12179850391785183)
,p_event_id=>wwv_flow_imp.id(12179387089785182)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P2_HOTEL_ID,P2_CONTACT_NO,P2_ADDRESS,P2_STARS,P2_HOTEL_NAME,P2_GROUP_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT RAWTOHEX(id) AS ID,',
'       GROUP_ID,',
'       HOTEL_NAME,',
'       STAR_RATING,',
'       ADDRESS_ID,',
'       CONTACT_ID',
'FROM   UR_HOTELS',
'WHERE  ID = RAWTOHEX(:P2_HOTEL_LIST)',
''))
,p_attribute_07=>'P2_HOTEL_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12180361248785185)
,p_event_id=>wwv_flow_imp.id(12179387089785182)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(23844006654388251)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12183353749821504)
,p_name=>'PREPARE_URL'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12183491257821505)
,p_event_id=>wwv_flow_imp.id(12183353749821504)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'PREPARE_URL'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function(){',
'  var pageMap = {',
'    ''group-lov''  : 23, ',
'    ''hotel-lov''  : 23, ',
'    ''addr-lov''   : 7,  ',
'    ''contact-lov'': 12 ',
'  };',
'',
'  var lastSelect = null, lastPrev = null;',
'',
'  function addDefineOption($sel){',
'    if ($sel.find(''option[value="DEFINE_NEW"]'').length === 0){',
'      $sel.prepend($(''<option>'', { value: ''DEFINE_NEW'', text: ''-- Define new --'' }) );',
'    }',
'  }',
'',
'  // helper to open dialog; will prepare checksum either client-side or via on-demand process',
'  function openDialogSafely(page, urlSuffix, onSuccess, onError){',
'    var url = ''f?p='' + $v(''pFlowId'') + '':'' + page + '':'' + $v(''pInstance'') + '':::NO:::'' + (urlSuffix || '''');',
'',
'    // prefer client-side prepareURL if available',
'    if (window.apex && apex.util && typeof apex.util.prepareURL === ''function''){',
'      try {',
'        var safe = apex.util.prepareURL(url);',
'        onSuccess(safe);',
'        return;',
'      } catch (e){',
'        console.warn(''apex.util.prepareURL threw:'', e);',
'      }',
'    }',
'',
'    // fallback: call your On-Demand PL/SQL process PREPARE_URL',
'    apex.server.process(''PREPARE_URL'',',
'      { x01: url },',
'      {',
'        dataType: ''text'',',
'        success: function(result){',
'          onSuccess(result);',
'        },',
'        error: function(jqXHR, textStatus, errorThrown){',
'          console.error(''PREPARE_URL failed:'', textStatus, errorThrown);',
'          if (onError) onError();',
'        }',
'      }',
'    );',
'  }',
'',
'  apex.jQuery(function($){',
'    // initialize existing selects',
'    Object.keys(pageMap).forEach(function(cls){',
'      $(''.'' + cls).each(function(){',
'        addDefineOption($(this));',
'      });',
'    });',
'',
'    // remember previous value when focus',
'    $(document).on(''focus'', ''select.group-lov, select.hotel-lov, select.addr-lov, select.contact-lov'', function(){',
'      $(this).data(''prev'', $(this).val());',
'    });',
'',
'    // change handler',
'    $(document).on(''change'', ''select.group-lov, select.hotel-lov, select.addr-lov, select.contact-lov'', function(){',
'      var $sel = $(this), val = $sel.val();',
'      if (val === ''DEFINE_NEW''){',
'        lastSelect = $sel; lastPrev = $sel.data(''prev'') || '''';',
'',
'        var cls = $sel.attr(''class'').split(/\s+/).filter(function(c){',
'          return pageMap.hasOwnProperty(c);',
'        })[0];',
'',
'        var page = pageMap[cls];',
'        if (!page){',
'          console.warn(''No dialog page configured for:'', cls);',
'          return;',
'        }',
'',
'        var suffix = '''';',
'',
'        openDialogSafely(page, suffix, function(preparedUrl){',
'          apex.navigation.dialog(preparedUrl, {',
'            title: ''Define New'',',
'            width: 900,',
'            height: 600,',
'            modal: true',
'          });',
'        }, function(){',
'          lastSelect.val(lastPrev).trigger(''change'');',
'          lastSelect = null; lastPrev = null;',
'        });',
'',
'      } else {',
'        $sel.data(''prev'', val);',
'      }',
'    });',
'',
'    // handle dialog close',
'    $(document).on(''apexafterclosedialog'', function(event, data){',
'      if (!lastSelect) return;',
'',
'      if (data && data.NEW_ID){',
'        if ( lastSelect.find(''option[value="'' + data.NEW_ID + ''"]'').length === 0 ){',
'          lastSelect.append( $(''<option>'', { value: data.NEW_ID, text: data.NEW_LABEL }) );',
'        }',
'        lastSelect.val(data.NEW_ID).trigger(''change'');',
'      } else {',
'        lastSelect.val(lastPrev).trigger(''change'');',
'      }',
'',
'      lastSelect = null; lastPrev = null;',
'    });',
'',
'  });',
'})();',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(12183734258821508)
,p_name=>'New_1'
,p_event_sequence=>60
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(23844006654388251)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(12183842610821509)
,p_event_id=>wwv_flow_imp.id(12183734258821508)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function(){',
'  // === EDIT THIS: map CSS class -> dialog page id ===',
'  var pageMap = {',
'    ''group-lov''  : 23, // put your Group dialog page id here',
'    ''hotel-lov''  : 23, // put your Hotel dialog page id here (if any)',
'    ''addr-lov''   : 7,  // Address dialog page id',
'    ''contact-lov'': 12  // Contact dialog page id',
'  };',
'  // ==================================================',
'',
'  var lastSelect = null, lastPrev = null;',
'',
'  function addDefineOption($sel){',
'    if ($sel.find(''option[value="DEFINE_NEW"]'').length === 0){',
'      $sel.prepend($(''<option>'', { value: ''DEFINE_NEW'', text: ''-- Define new --'' }) );',
'    }',
'  }',
'',
'  $(function(){',
'    // initialize existing selects',
'    Object.keys(pageMap).forEach(function(cls){',
'      $(''.'' + cls).each(function(){',
'        addDefineOption($(this));',
'      });',
'    });',
'',
'    // remember previous value when focus (so we can restore if user cancels)',
'    $(document).on(''focus'', ''select.group-lov, select.hotel-lov, select.addr-lov, select.contact-lov'', function(){',
'      $(this).data(''prev'', $(this).val());',
'    });',
'',
'    // delegate change handler',
'    $(document).on(''change'', ''select.group-lov, select.hotel-lov, select.addr-lov, select.contact-lov'', function(){',
'      var $sel = $(this);',
'      var val = $sel.val();',
'',
'      if (val === ''DEFINE_NEW''){',
'        // store who opened the dialog and previous value',
'        lastSelect = $sel;',
'        lastPrev   = $sel.data(''prev'') || '''';',
'',
'        // determine class used to lookup page id',
'        var cls = $sel.attr(''class'').split(/\s+/).filter(function(c){',
'          return pageMap.hasOwnProperty(c);',
'        })[0];',
'',
'        var page = pageMap[cls];',
'        if (!page){',
'          console.warn(''No dialog page configured for:'', cls);',
'          return;',
'        }',
'',
'        // build f?p URL (add any &Pxx_TARGET=... params if you want)',
'        var url = ''f?p='' + $v(''pFlowId'') + '':'' + page + '':'' + $v(''pInstance'') + '':::NO:::'';',
'        apex.navigation.dialog(url, {',
'          title: ''Define new'',',
'          width: 900,',
'          height: 600,',
'          modal: true',
'        });',
'',
'      } else {',
'        // normal selection: store as prev',
'        $sel.data(''prev'', val);',
'      }',
'    });',
'',
'    // handle dialog closed event (apexafterclosedialog)',
'    // signature: (event, data) where data is whatever the dialog returned',
'    $(document).on(''apexafterclosedialog'', function(event, data){',
'      if (!lastSelect) return;',
'',
'      if (data && data.NEW_ID){',
'        // add the returned option if not present, select it',
'        if ( lastSelect.find(''option[value="'' + data.NEW_ID + ''"]'').length === 0 ){',
'          lastSelect.append( $(''<option>'', { value: data.NEW_ID, text: data.NEW_LABEL }) );',
'        }',
'        lastSelect.val(data.NEW_ID).trigger(''change'');',
'      } else {',
'        // user cancelled or dialog returned nothing -> restore previous value',
'        lastSelect.val(lastPrev).trigger(''change'');',
'      }',
'',
'      lastSelect = null;',
'      lastPrev   = null;',
'    });',
'',
'  }); // dom ready',
'})();',
''))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12174998693785169)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Before Header'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
' IF :P2_HOTEL_LIST IS NOT NULL THEN',
'    BEGIN',
'      SELECT ID,',
'             GROUP_ID,',
'             HOTEL_NAME,',
'             STAR_RATING,',
'             ADDRESS_ID,',
'             CONTACT_ID',
'      INTO   :P2_HOTEL_ID,',
'             :P2_GROUP_NAME,',
'             :P2_HOTEL_NAME,',
'             :P2_STARS,',
'             :P2_ADDRESS,',
'             :P2_CONTACT_NO',
'      FROM   UR_HOTELS',
'      WHERE  ID = :P2_HOTEL_LIST;',
'    EXCEPTION',
'      WHEN NO_DATA_FOUND THEN',
'        NULL;',
'    END;',
'  END IF;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>12174998693785169
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12175366899785170)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_CARD'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_payload    CLOB := apex_application.g_x01; -- JSON payload from JS',
'  l_status     VARCHAR2(10);',
'  l_message    CLOB;',
'  l_group_id   VARCHAR2(4000);',
'  l_addr_id    VARCHAR2(4000);',
'  l_contact_id VARCHAR2(4000);',
'  l_group_name VARCHAR2(4000);',
'  l_addr_text  VARCHAR2(4000);',
'  l_contact_name VARCHAR2(4000);',
'  l_group_id_raw raw(16);',
'  l_contact_id_raw raw(16);',
'  l_addr_id_raw raw(16);',
'   l_icon   VARCHAR2(50);',
'  l_title  VARCHAR2(200);',
'BEGIN',
'  owa_util.mime_header(''application/json'', FALSE);',
'  owa_util.http_header_close;',
'',
'  IF l_payload IS NULL THEN',
'    apex_json.open_object;',
'      apex_json.write(''status'', ''E'');',
'      apex_json.write(''message'', ''Missing payload'');',
'    apex_json.close_object;',
'    RETURN;',
'  END IF;',
'',
'  -- call generic CRUD package (Update)',
'  pkg_generic_crud.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_HOTELS'',',
'    p_payload => l_payload,',
'    p_debug   => ''N'',',
'    p_status  => l_status,',
'    p_message => l_message,',
'    p_icon    => l_icon,',
'    p_title   => l_title',
'  );',
'',
'',
'  -- parse payload to fetch IDs we just saved',
'  BEGIN',
'    apex_json.parse(l_payload);',
'    /*l_group_id   := apex_json.get_varchar2(''$.GROUP_ID'');',
'    l_addr_id    := apex_json.get_varchar2(''$.ADDRESS_ID'');',
'    l_contact_id := apex_json.get_varchar2(''$.CONTACT_ID'');*/',
'    apex_json.parse(l_payload);',
'',
'l_group_id   := apex_json.get_varchar2(''$.GROUP_ID'');',
'l_addr_id    := apex_json.get_varchar2(''$.ADDRESS_ID'');',
'l_contact_id := apex_json.get_varchar2(''$.CONTACT_ID'');',
'',
'l_group_id_raw   := hextoraw(replace(l_group_id,''-'',''''));',
'l_addr_id_raw    := hextoraw(replace(l_addr_id,''-'',''''));',
'l_contact_id_raw := hextoraw(replace(l_contact_id,''-'',''''));',
'',
'  EXCEPTION WHEN OTHERS THEN',
'    NULL;',
'  END;',
'',
'  -- look up display values',
'  IF l_group_id IS NOT NULL THEN',
'    BEGIN',
'      SELECT group_name INTO l_group_name FROM ur_hotel_groups WHERE id = l_group_id;',
'    EXCEPTION WHEN NO_DATA_FOUND THEN l_group_name := NULL; END;',
'  END IF;',
'',
'  IF l_addr_id IS NOT NULL THEN',
'    BEGIN',
'      SELECT county INTO l_addr_text FROM ur_addresses WHERE id = l_addr_id;',
'    EXCEPTION WHEN NO_DATA_FOUND THEN l_addr_text := NULL; END;',
'  END IF;',
'',
'  IF l_contact_id IS NOT NULL THEN',
'    BEGIN',
'      SELECT contact_name INTO l_contact_name FROM ur_contacts WHERE id = l_contact_id;',
'    EXCEPTION WHEN NO_DATA_FOUND THEN l_contact_name := NULL; END;',
'  END IF;',
'',
'  -- return JSON safely',
'  apex_json.open_object;',
'    apex_json.write(''status'', NVL(l_status,''E''));',
'   -- apex_json.write(''message'', NVL(l_message,''''));',
'    apex_json.write(''alert_icon'', NVL(l_icon,''info''));',
'    apex_json.write(''alert_title'', nvl(l_title,''Notice''));',
'    apex_json.write(''alert_message'', NVL(l_message,''''));',
unistr('    apex_json.write(''alert_timer'', 3000); -- \23F2\FE0F e.g. 3 sec, can also come from package'),
'    apex_json.open_object(''display_values'');',
'      apex_json.write(''GROUP_NAME'', NVL(l_group_name,''''));',
'      apex_json.write(''ADDRESS'', NVL(l_addr_text,''''));',
'      apex_json.write(''CONTACT'', NVL(l_contact_name,''''));',
'    apex_json.close_object;',
'    ',
'  apex_json.close_object;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    apex_json.open_object;',
'      apex_json.write(''status'', ''E'');',
'      apex_json.write(''message'', SQLERRM);',
'      apex_json.write(''alert_icon'', ''error'');',
'      apex_json.write(''alert_title'', ''Unexpected Error'');',
'      apex_json.write(''alert_message'', SQLERRM);',
'    apex_json.close_object;',
'END;',
'',
'',
''))
,p_process_clob_language=>'PLSQL'
,p_process_success_message=>'sss'
,p_internal_uid=>12175366899785170
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12175714305785171)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_hotel_id VARCHAR2(100) := apex_application.g_x01;',
'    l_address  VARCHAR2(4000) := apex_application.g_x02;',
'    l_new_id   NUMBER;',
'BEGIN',
'    INSERT INTO ur_addresses (hotel_id, address)',
'    VALUES (l_hotel_id, l_address)',
'    RETURNING id INTO l_new_id;',
'',
'    apex_json.open_object;',
'    apex_json.write(''new_id'', l_new_id);',
'    apex_json.write(''address'', l_address);',
'    apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_internal_uid=>12175714305785171
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(12176138170785172)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_LOV'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_type VARCHAR2(30) := apex_application.g_x01;',
'BEGIN',
'  owa_util.mime_header(''application/json'', FALSE);',
'  owa_util.http_header_close;',
'',
'  apex_json.open_array;',
'',
'  IF l_type = ''group'' THEN',
'    -- first option = none',
'    apex_json.open_object;',
'    apex_json.write(''r'', TO_CHAR(NULL));',
'    apex_json.write(''d'', ''- None -'');',
'    apex_json.close_object;',
'',
'    FOR rec IN (SELECT id, group_name FROM ur_hotel_groups ORDER BY group_name) LOOP',
'      apex_json.open_object;',
unistr('      apex_json.write(''r'', TO_CHAR(rec.id));          -- \2705 cast to VARCHAR2'),
unistr('      apex_json.write(''d'', NVL(rec.group_name, ''''));  -- \2705 ensure VARCHAR2'),
'      apex_json.close_object;',
'    END LOOP;',
'',
'  ELSIF l_type = ''addr'' THEN',
'    apex_json.open_object;',
'    apex_json.write(''r'', TO_CHAR(NULL));',
'    apex_json.write(''d'', ''- None -'');',
'    apex_json.close_object;',
'',
'    FOR rec IN (SELECT id, county FROM ur_addresses ORDER BY county) LOOP',
'      apex_json.open_object;',
unistr('      apex_json.write(''r'', TO_CHAR(rec.id));          -- \2705 cast'),
'      apex_json.write(''d'', NVL(rec.county, ''''));',
'      apex_json.close_object;',
'    END LOOP;',
'',
'  ELSIF l_type = ''contact'' THEN',
'    apex_json.open_object;',
'    apex_json.write(''r'', TO_CHAR(NULL));',
'    apex_json.write(''d'', ''- None -'');',
'    apex_json.close_object;',
'',
'    FOR rec IN (SELECT id, contact_name FROM ur_contacts ORDER BY contact_name) LOOP',
'      apex_json.open_object;',
unistr('      apex_json.write(''r'', TO_CHAR(rec.id));              -- \2705 cast'),
'      apex_json.write(''d'', NVL(rec.contact_name, ''''));',
'      apex_json.close_object;',
'    END LOOP;',
'  END IF;',
'',
'  apex_json.close_array;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>12176138170785172
);
wwv_flow_imp.component_end;
end;
/
