prompt --application/pages/page_01040
begin
--   Manifest
--     PAGE: 01040
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
 p_id=>1040
,p_name=>'Hotel'
,p_alias=>'HOTEL1'
,p_step_title=>'Hotel'
,p_autocomplete_on_off=>'OFF'
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--#APP_FILES#Interactive report#MIN#.css',
'/* Tweak IR Icon View to resemble the mock */',
'.t-IRR-iconView .t-IRR-icon { display: none; }',
'',
'.t-IRR-iconView .t-IRR-title {',
'  font-size: 2rem; font-weight: 600; margin: .25rem 0 .5rem;',
'}',
'',
'.t-IRR-iconView .card-group {',
'  font-size: 1rem; color: #666; margin-bottom: .25rem;',
'}',
'',
'.t-IRR-iconView .card-stars {',
'  font-size: 1.25rem; letter-spacing: .25rem; margin: .25rem 0;',
'}',
'',
'.t-IRR-iconView .card-address,',
'.t-IRR-iconView .card-contact {',
'  color: #666; margin: .25rem 0;',
'}',
'',
'.t-IRR-iconView .card-actions { margin-top: .5rem; }',
'.t-IRR-iconView .card-actions .t-Button { margin-right: .5rem; }',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Target the Image region specifically */',
'#IMAGE, .t-Region[aria-label="Image"] {',
'  float: right;                 /* stay on the right */',
'  width: 300px !important;      /* fixed width, adjust as needed */',
'  max-width: 300px;',
'  position: relative;           /* prevent overlay expansion */',
'  z-index: 1;                   /* sit below navigation */',
'}',
'',
'#IMAGE img {',
'  display: block;',
'  max-width: 100%;',
'  height: auto;',
'  object-fit: contain;',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(23082007851622088)
,p_plug_name=>'Main Region'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>8
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(12545740906179931)
,p_plug_name=>'hotel'
,p_parent_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>90
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_html              CLOB;',
'    l_id                ur_hotels.id%TYPE;',
'    l_group             ur_hotels.group_id%TYPE;',
'    l_group_name        ur_hotel_groups.group_name%TYPE;',
'    l_hotel_name        ur_hotels.hotel_name%TYPE;',
'    l_star              ur_hotels.star_rating%TYPE;',
'    l_addr              ur_hotels.address_id%TYPE;',
'    l_addr_text         CLOB;',
'    l_contact_from_h    ur_hotels.contact_id%TYPE;',
'    l_contact           ur_contacts.id%TYPE;',
'    l_contact_name      VARCHAR2(4000);',
'    l_contact_position  VARCHAR2(4000);',
'    l_contact_email     VARCHAR2(4000);',
'    l_contact_phone     VARCHAR2(4000);',
'    l_img_url           VARCHAR2(4000);',
'    l_map_link          VARCHAR2(4000);',
'BEGIN',
'    -- 0. If no hotel chosen',
'    IF :P1040_HOTEL_LIST IS NULL THEN',
unistr('        l_html := ''<div class="p-4 text-gray-600">\2139\FE0F Please select a hotel first.</div>'';'),
'        RETURN l_html;',
'    END IF;',
'',
'    -- 1. Hotel basic info',
'    BEGIN',
'        SELECT h.id,',
'               h.hotel_name,',
'               h.group_id,',
'               hg.group_name,',
'               h.star_rating,',
'               h.address_id,',
'               REPLACE(',
'                 a.street_address || CHR(10) ||',
'                 a.city || '', '' || a.county || ',
'                 a.country || '' - '' || a.post_code,',
'                 CHR(10), ''<br>''',
'               ) AS address_text,',
'               a.street_address || '', '' || a.city || '', '' || a.county || '', '' || a.country || '' '' || a.post_code AS full_address,',
'               h.contact_id',
'          INTO l_id,',
'               l_hotel_name,',
'               l_group,',
'               l_group_name,',
'               l_star,',
'               l_addr,',
'               l_addr_text,',
'               l_map_link,',
'               l_contact_from_h',
'          FROM ur_hotels h',
'               JOIN ur_hotel_groups hg ON hg.id = h.group_id',
'               LEFT JOIN ur_addresses a ON a.id = h.address_id',
'         WHERE h.id = :P1040_HOTEL_LIST;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
unistr('            l_html := ''<div class="p-4 text-red-600">\26A0\FE0F No hotel found for ID: ''||:P1040_HOTEL_LIST||''</div>'';'),
'            RETURN l_html;',
'    END;',
'',
'    -- 2. Map link',
'    l_map_link := ''https://www.google.com/maps/search/?api=1&query='' || REPLACE(l_map_link,'' '',''+'');',
'',
'    -- 3. Primary contact',
'    BEGIN',
'        IF l_contact_from_h IS NOT NULL THEN',
'            SELECT id, contact_name, NVL(position_title,''''), NVL(email,''''), NVL(phone_number,'''')',
'              INTO l_contact, l_contact_name, l_contact_position, l_contact_email, l_contact_phone',
'              FROM ur_contacts',
'             WHERE id = l_contact_from_h;',
'        ELSE',
'            SELECT id, contact_name, NVL(position_title,''''), NVL(email,''''), NVL(phone_number,'''')',
'              INTO l_contact, l_contact_name, l_contact_position, l_contact_email, l_contact_phone',
'              FROM ur_contacts',
'             WHERE hotel_id = l_id AND primary = ''Y'';',
'        END IF;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            l_contact := NULL;',
'            l_contact_name := NULL;',
'            l_contact_position := NULL;',
'            l_contact_email := NULL;',
'            l_contact_phone := NULL;',
'    END;',
'',
'    -- 4. Hotel image',
'    l_img_url := apex_application.g_image_prefix || ''360-3608307_placeholder-hotel-house.png'';',
'',
'    -- 5. Build Tailwind HTML',
'    l_html := ',
'''<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">',
'<div id="hotel_card_container" class="px-6">',
'  <div id="hotel_card" role="region" aria-label="Hotel card">',
'    <div class="hotel-grid">',
'      <!-- Left column: text content -->',
'      <div class="hotel-content">',
'        <div id="groupName" data-apex="P1040_GROUP_NAME" contenteditable="false" class="mb-4 text-gray-800">'' ',
'        || apex_escape.html(l_group_name) || ''</div>',
'',
'        <div id="hotelName" data-apex="P1040_HOTEL_NAME" contenteditable="false" class="text-3xl font-semibold mb-4 text-gray-900">'' ',
'        || apex_escape.html(l_hotel_name) || ''</div>',
'',
'        <!-- Stars -->',
'        <div class="mb-4" aria-label="Hotel rating">',
'          <div id="stars" class="flex items-center space-x-2" role="radiogroup">'';',
'    FOR i IN 1..5 LOOP',
'        IF l_star >= i THEN',
'            l_html := l_html || ''<button class="hotel-star" data-value="''||i||''" type="button" aria-label="''||i||'' star"><svg viewBox="0 0 20 20" fill="currentColor"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.95 4.146.018c.958.004 1.355'
||' 1.226.584 1.818l-3.36 2.455 1.287 3.95c.3.922-.756 1.687-1.541 1.124L10 13.012l-3.353 2.333c-.785.563-1.841-.203-1.541-1.124l1.287-3.95-3.36-2.455c-.77-.592-.374-1.814.584-1.818l4.146-.018 1.286-3.95z"/></svg></button>'';',
'        ELSE',
'            l_html := l_html || ''<button class="hotel-star" data-value="''||i||''" type="button" aria-label="''||i||'' star"><svg viewBox="0 0 20 20" fill="currentColor" style="color:#d1d5db"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.95 4.'
||'146.018c.958.004 1.355 1.226.584 1.818l-3.36 2.455 1.287 3.95c.3.922-.756 1.687-1.541 1.124L10 13.012l-3.353 2.333c-.785.563-1.841-.203-1.541-1.124l1.287-3.95-3.36-2.455c-.77-.592-.374-1.814.584-1.818l4.146-.018 1.286-3.95z"/></svg></button>'';',
'        END IF;',
'    END LOOP;',
'    l_html := l_html || ''</div></div>',
'',
'        <!-- Address -->',
'        <div id="address" data-apex="P1040_ADDRESS" contenteditable="false" class="text-gray-700 mb-4">''',
'        || l_addr_text || ''</div>',
'',
'        <!-- Contact -->',
'        <div><a id="contact" data-apex="P1040_CONTACT_NO" contenteditable="false" href="tel:''',
'        || REPLACE(l_contact_phone,'' '','''') || ''" class="text-blue-600 underline mb-6 inline-block">''',
'        || l_contact_phone || ''</a></div>',
'',
'        <!-- Save / Cancel buttons -->',
'        <div class="flex items-center space-x-3 mt-4">',
'          <button id="hotel_save" type="button" class="hotel-btn px-4 py-2 rounded bg-gray-800 text-white">Save</button>',
'          <button id="hotel_cancel" type="button" class="hotel-btn px-4 py-2 rounded border border-gray-300 text-gray-700 hidden">Cancel</button>',
'        </div>',
'      </div>',
'',
'      <!-- Right column: image -->',
'      <div class="hotel-image-box">',
'        <img id="hotel_image" src="'' || l_img_url || ''" alt="Hotel Image"/>',
'      </div>',
'    </div>',
'  </div>',
'</div>'';',
'',
'    RETURN l_html;',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P1040_HOTEL_LIST'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(22984397377562810)
,p_plug_name=>'Image '
,p_region_name=>'hotel_image_region'
,p_parent_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>110
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<img src="#APP_FILES#360-3608307_placeholder-hotel-house.png" ',
'alt="Hotel Image" style="max-width: 100%; max-height: 500%; object-fit: contain;" />',
'',
''))
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(23083526855622103)
,p_plug_name=>'hotel'
,p_parent_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">',
'',
'<style>',
'  /* Force the card to look consistent even inside a dark APEX theme */',
'  #hotel_card_container { width: 100%; }',
'  #hotel_card {',
'    width: 100% !important;',
'    background: #ffffff !important;         /* solid white card */',
'    color: #111827 !important;              /* dark text */',
'    border-radius: .5rem;',
'    box-shadow: 0 8px 24px rgba(15, 23, 42, 0.12);',
'    padding: 2rem;',
'  }',
'',
'  /* Ensure inner editable elements use dark text */',
'  #hotel_card [contenteditable="true"],',
'  #hotel_card [contenteditable="false"] {',
'    color: #111827 !important;',
'  }',
'',
'/* Full-width two-column layout inside the card */',
'.hotel-grid {',
'  display: grid;',
'  grid-template-columns: minmax(0, 1fr) 360px; /* content + image column */',
'  grid-template-areas: "content image";        /* desktop layout */',
'  gap: 2rem;',
'  align-items: stretch;',
'}',
'',
'/* assign each child to an area */',
'.hotel-content {',
'  grid-area: content;',
'}',
'.hotel-image-box {',
'  grid-area: image;',
'}',
'',
'/* small responsive adjustments */',
'@media (max-width: 900px) {',
'  .hotel-grid {',
'    grid-template-columns: 1fr;',
'    grid-template-areas:',
'      "image"',
'      "content";   /* image above, then content */',
'  }',
'',
'  .hotel-image-box {',
'    height: auto;  ',
'    margin-bottom: 1.5rem; /* spacing below image */',
'  }',
'',
'  .hotel-image-box img {',
'    max-height: 200px;',
'    width: 100%;',
'    height: auto;  ',
'    object-fit: contain;',
'  }',
'}',
'',
'',
'  /* Image box */',
'  .hotel-image-box {',
'    background: #f8fafc;',
'    border-radius: .5rem;',
'    padding: 1rem;',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    height: 100%;',
'  }',
'  .hotel-image-box img { max-height: 280px; width: 100%; object-fit: contain; }',
'',
'  /* Star size and pointer */',
'  .hotel-star svg { width: 32px; height: 32px; }',
'',
'  /* Buttons */',
'  .hotel-btn { cursor: pointer; }',
'  /* small responsive adjustments */',
'  @media (max-width: 900px) {',
'    .hotel-grid { grid-template-columns: 1fr; }',
'    .hotel-image-box img { max-height: 200px; }',
'  }',
'</style>',
'',
'<div id="hotel_card_container" class="px-6">',
'  <div id="hotel_card" role="region" aria-label="Hotel card">',
'    <div class="hotel-grid">',
'      <!-- Left column: text content -->',
'      <div class="hotel-content">',
'       ',
'        <div id="groupName" data-apex="P1040_GROUP_NAME" contenteditable="false" class="mb-4 text-gray-800">Premium Group</div>',
'',
'        <div id="hotelName" data-apex="P1040_HOTEL_NAME" contenteditable="false" class="text-3xl font-semibold mb-4 text-gray-900">Hotel Name</div>',
'',
'        <!-- Stars -->',
'        <div class="mb-4" aria-label="Hotel rating">',
'          <div id="stars" class="flex items-center space-x-2" role="radiogroup">',
'            <button class="hotel-star" data-value="1" type="button" aria-label="1 star"><svg viewBox="0 0 20 20" fill="currentColor"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.95 4.146.018c.958.004 1.355 1.226.584 1.818l-3.36 2.455 1.28'
||'7 3.95c.3.922-.756 1.687-1.541 1.124L10 13.012l-3.353 2.333c-.785.563-1.841-.203-1.541-1.124l1.287-3.95-3.36-2.455c-.77-.592-.374-1.814.584-1.818l4.146-.018 1.286-3.95z"/></svg></button>',
'            <button class="hotel-star" data-value="2" type="button" aria-label="1 star"><svg viewBox="0 0 20 20" fill="currentColor"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.95 4.146.018c.958.004 1.355 1.226.584 1.818l-3.36 2.455 1.28'
||'7 3.95c.3.922-.756 1.687-1.541 1.124L10 13.012l-3.353 2.333c-.785.563-1.841-.203-1.541-1.124l1.287-3.95-3.36-2.455c-.77-.592-.374-1.814.584-1.818l4.146-.018 1.286-3.95z"/></svg></button>',
'            <button class="hotel-star" data-value="3" type="button" aria-label="1 star"><svg viewBox="0 0 20 20" fill="currentColor"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.95 4.146.018c.958.004 1.355 1.226.584 1.818l-3.36 2.455 1.28'
||'7 3.95c.3.922-.756 1.687-1.541 1.124L10 13.012l-3.353 2.333c-.785.563-1.841-.203-1.541-1.124l1.287-3.95-3.36-2.455c-.77-.592-.374-1.814.584-1.818l4.146-.018 1.286-3.95z"/></svg></button>',
'            <button class="hotel-star" data-value="4" type="button" aria-label="1 star"><svg viewBox="0 0 20 20" fill="currentColor"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.95 4.146.018c.958.004 1.355 1.226.584 1.818l-3.36 2.455 1.28'
||'7 3.95c.3.922-.756 1.687-1.541 1.124L10 13.012l-3.353 2.333c-.785.563-1.841-.203-1.541-1.124l1.287-3.95-3.36-2.455c-.77-.592-.374-1.814.584-1.818l4.146-.018 1.286-3.95z"/></svg></button>',
'            <button class="hotel-star" data-value="5" type="button" aria-label="1 star"><svg viewBox="0 0 20 20" fill="currentColor"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.95 4.146.018c.958.004 1.355 1.226.584 1.818l-3.36 2.455 1.28'
||'7 3.95c.3.922-.756 1.687-1.541 1.124L10 13.012l-3.353 2.333c-.785.563-1.841-.203-1.541-1.124l1.287-3.95-3.36-2.455c-.77-.592-.374-1.814.584-1.818l4.146-.018 1.286-3.95z"/></svg></button>',
'          </div>',
'        </div>',
'',
'        ',
'        <div id="address" data-apex="P1040_ADDRESS" contenteditable="false" class="text-gray-700 mb-4">221B Baker Street, London</div>',
'',
'        ',
'        <div><a id="contact" data-apex="P1040_CONTACT_NO" contenteditable="false" href="#" class="text-blue-600 underline mb-6 inline-block">+44 1234 567 890</a></div>',
'',
'        <div class="flex items-center space-x-3 mt-4">',
'          <button id="hotel_save" type="button" class="hotel-btn px-4 py-2 rounded bg-gray-800 text-white">Save</button>',
'          <button id="hotel_cancel" type="button" class="hotel-btn px-4 py-2 rounded border border-gray-300 text-gray-700 hidden">Cancel</button>',
'        </div>',
'      </div>',
'',
'      <!-- Right column: image -->',
'      <div>',
'        <div class="hotel-image-box">',
'          <img id="hotel_image" src="#APP_FILES#360-3608307_placeholder-hotel-house.png" alt="Hotel Image"/>',
'        </div>',
'      </div>',
'    </div>',
'  </div>',
'</div>',
'',
'<script>',
'(function(){',
'  // APEX item names - change if your page items are named differently',
'  const items = {',
'    id: ''P1040_HOTEL_ID'',',
'    name: ''P1040_HOTEL_NAME'',',
'    group: ''P1040_GROUP_NAME'',',
'    stars: ''P1040_STARS'',',
'    address: ''P1040_ADDRESS'',',
'    contact: ''P1040_CONTACT_NO''',
'  };',
'',
'  // small helpers (apex.item API preferred)',
'  function getItem(n){',
'    try { return apex.item(n).getValue(); } catch(e){',
'      var el = document.getElementsByName(n)[0]; return el ? el.value : '''';',
'    }',
'  }',
'  function setItem(n,v){',
'    try { apex.item(n).setValue(v); } catch(e){',
'      var el = document.getElementsByName(n)[0]; if(el) el.value = v;',
'    }',
'  }',
'',
'  // elements',
'  const elName = document.getElementById(''hotelName'');',
'  const elGroup = document.getElementById(''groupName'');',
'  const elAddress = document.getElementById(''address'');',
'  const elContact = document.getElementById(''contact'');',
'  const starBtns = Array.from(document.querySelectorAll(''.hotel-star''));',
'  const btnSave = document.getElementById(''hotel_save'');',
'  const btnCancel = document.getElementById(''hotel_cancel'');',
'',
'  let editing = false;',
'  let rating = parseInt(getItem(items.stars) || 0,10) || 0;',
'',
'  function renderStars(n){',
'    rating = Number(n) || 0;',
'    starBtns.forEach(btn=>{',
'      const v = Number(btn.dataset.value);',
'      const svg = btn.querySelector(''svg'');',
'      if(v <= rating){',
'        svg.style.color = ''#facc15''; // yellow',
'      } else {',
'        svg.style.color = ''#d1d5db''; // gray',
'      }',
'    });',
'  }',
'',
'  starBtns.forEach(btn=>{',
'    btn.addEventListener(''click'', ()=> {',
'      if(!editing) return;',
'      renderStars(btn.dataset.value);',
'    });',
'    btn.addEventListener(''mouseover'', ()=> {',
'      if(!editing) return;',
'      const v = Number(btn.dataset.value);',
'      starBtns.forEach(b=>{',
'        b.querySelector(''svg'').style.color = (Number(b.dataset.value) <= v) ? ''#facc15'' : ''#d1d5db'';',
'      });',
'    });',
'    btn.addEventListener(''mouseout'', ()=> {',
'      if(!editing) return;',
'      renderStars(rating);',
'    });',
'  });',
'',
'  // load current values from page items',
'  function loadValues(){',
'    const n = getItem(items.name); if(n) elName.textContent = n;',
'    const g = getItem(items.group); if(g) elGroup.textContent = g;',
'    const a = getItem(items.address); if(a) elAddress.textContent = a;',
'    const c = getItem(items.contact); if(c){ elContact.textContent = c; elContact.href = ''tel:'' + c.replace(/\s+/g,''''); }',
'    const s = Number(getItem(items.stars)) || 0; renderStars(s);',
'  }',
'',
'  function setEdit(on){',
'    editing = !!on;',
'    [elName,elGroup,elAddress,elContact].forEach(el=>{',
'      el.contentEditable = editing ? ''true'' : ''false'';',
'      el.style.color = ''#111827'';',
'    });',
'    btnCancel.classList.toggle(''hidden'', !editing);',
'    btnSave.textContent = editing ? ''Save'' : ''Edit'';',
'    if(editing) { elName.focus(); placeCaretAtEnd(elName); }',
'  }',
'',
'  function placeCaretAtEnd(el){',
'    el.focus();',
'    if(window.getSelection && document.createRange){',
'      const r = document.createRange(); r.selectNodeContents(el); r.collapse(false);',
'      const s = window.getSelection(); s.removeAllRanges(); s.addRange(r);',
'    }',
'  }',
'',
'  // Save: push values into APEX page items then call the on-demand process',
'  function doSave(){',
'    setItem(items.name, elName.textContent.trim());',
'    setItem(items.group, elGroup.textContent.trim());',
'    setItem(items.address, elAddress.textContent.trim());',
'    setItem(items.contact, elContact.textContent.trim());',
'    setItem(items.stars, String(rating));',
'',
'    apex.server.process(''SAVE_HOTEL'', {',
'      pageItems: ''#P1040_HOTEL_ID,#P1040_HOTEL_NAME,#P1040_STARS,#P1040_ADDRESS,#P1040_CONTACT_NO''',
'    }, {',
'      dataType: ''json'',',
'      success: function(res){',
'        if(res && res.status === ''OK''){',
'          apex.message.showPageSuccess(''Saved successfully.'');',
'        } else {',
'          apex.message.showErrors([{type:''error'',location:''page'',message: res && res.message || ''Save failed''}]);',
'        }',
'      },',
'      error: function(xhr,err){ apex.message.showErrors([{type:''error'',location:''page'',message:''AJAX error: ''+err}]); }',
'    });',
'  }',
'',
'  // Button wiring',
'  btnSave.addEventListener(''click'', function(ev){',
'    ev.preventDefault();',
'    if(!editing) { setEdit(true); btnSave.textContent = ''Save''; }',
'    else { setEdit(false); doSave(); }',
'  });',
'  btnCancel.addEventListener(''click'', function(ev){',
'    ev.preventDefault(); loadValues(); setEdit(false);',
'  });',
'',
'  // init',
'  loadValues();',
'  setEdit(false);',
'})();',
'</script>',
''))
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(11662451201499048)
,p_button_sequence=>100
,p_button_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_button_name=>'New'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'New'
,p_button_redirect_url=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.::P7_HOTEL_ID:3B9B847282589D45E063DD59000A6D5F'
,p_grid_new_row=>'N'
,p_grid_new_column=>'N'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23083709531622116)
,p_name=>'P1040_GROUP_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23083779039622117)
,p_name=>'P1040_HOTEL_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23083856254622118)
,p_name=>'P1040_STARS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23084116807622120)
,p_name=>'P1040_ADDRESS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23084221259622121)
,p_name=>'P1040_CONTACT_NO'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23084268738622122)
,p_name=>'P1040_HOTEL_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(23082007851622088)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23089486872622162)
,p_name=>'P1040_HOTEL_LIST'
,p_item_sequence=>10
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(23394219862229445)
,p_name=>'P1040_NEW'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(22984397377562810)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11740803165730459)
,p_name=>'On page load'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11741399981730461)
,p_event_id=>wwv_flow_imp.id(11740803165730459)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_name=>'Hide main region'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(23082007851622088)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11741751587730462)
,p_name=>'Change Hotel'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1040_HOTEL_LIST'
,p_condition_element=>'P1040_HOTEL_LIST'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11742281019730464)
,p_event_id=>wwv_flow_imp.id(11741751587730462)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(23082007851622088)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11742765546730465)
,p_event_id=>wwv_flow_imp.id(11741751587730462)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(23082007851622088)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11738045518730449)
,p_name=>'New'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1040_NEW'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11738587401730451)
,p_event_id=>wwv_flow_imp.id(11738045518730449)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1040_NEW_1'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_util.get_blob_file_src("P1040_NEW")',
''))
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11738939465730452)
,p_name=>'DA - Hotel list change'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1040_HOTEL_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11739498462730454)
,p_event_id=>wwv_flow_imp.id(11738939465730452)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1040_HOTEL_ID,P1040_CONTACT_NO,P1040_ADDRESS,P1040_STARS,P1040_HOTEL_NAME,P1040_GROUP_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT RAWTOHEX(id) AS ID,',
'       GROUP_ID,',
'       HOTEL_NAME,',
'       STAR_RATING,',
'       ADDRESS_ID,',
'       CONTACT_ID',
'FROM   UR_HOTELS',
'WHERE  ID = RAWTOHEX(:P1040_HOTEL_LIST)',
''))
,p_attribute_07=>'P1040_HOTEL_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11740454458730458)
,p_event_id=>wwv_flow_imp.id(11738939465730452)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P1040_HOTEL_ID,P1040_GROUP_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ID',
'GROUP_ID,',
'       HOTEL_NAME,',
'       STAR_RATING,',
'       ADDRESS_ID,',
'       CONTACT_ID',
' FROM UR_HOTELS',
'WHERE ID= :P1040_HOTEL_LIST'))
,p_attribute_07=>'P1040_HOTEL_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11739918351730457)
,p_event_id=>wwv_flow_imp.id(11738939465730452)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(23082007851622088)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11737206750730445)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'New'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
' IF :P1040_HOTEL_LIST IS NOT NULL THEN',
'    BEGIN',
'      SELECT ID,',
'             GROUP_ID,',
'             HOTEL_NAME,',
'             STAR_RATING,',
'             ADDRESS_ID,',
'             CONTACT_ID',
'      INTO   :P1040_HOTEL_ID,',
'             :P1040_GROUP_NAME,',
'             :P1040_HOTEL_NAME,',
'             :P1040_STARS,',
'             :P1040_ADDRESS,',
'             :P1040_CONTACT_NO',
'      FROM   UR_HOTELS',
'      WHERE  ID = :P1040_HOTEL_LIST;',
'    EXCEPTION',
'      WHEN NO_DATA_FOUND THEN',
'        NULL;',
'    END;',
'  END IF;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>11737206750730445
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11737636760730447)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_CARD'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_payload   CLOB;',
'  l_status    VARCHAR2(10);',
'  l_message   CLOB;',
'BEGIN',
'  -- Fetch full JSON safely into CLOB',
'  l_payload := apex_application.g_x01;',
'',
'  IF l_payload IS NULL THEN',
'    htp.p(''{"status":"E","message":"Missing payload"}'');',
'    RETURN;',
'  END IF;',
'',
'  pkg_generic_crud.proc_crud_json(',
'    p_mode    => ''U'',',
'    p_table   => ''UR_HOTELS'',',
'    p_payload => l_payload,',
'    p_debug   => ''Y'',',
'    p_status  => l_status,',
'    p_message => l_message',
'  );',
'',
'  htp.p(',
'    ''{"status":"'' || REPLACE(l_status, ''"'', ''\"'') ||',
'    ''", "message":"'' || apex_escape.json(l_message) || ''"}''',
'  );',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    htp.p(''{"status":"E","message":"'' || apex_escape.json(SQLERRM) || ''"}'');',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>11737636760730447
);
wwv_flow_imp.component_end;
end;
/
