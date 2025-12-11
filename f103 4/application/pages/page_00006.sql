prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_name=>'Hotel'
,p_alias=>'HOTEL'
,p_step_title=>'Hotel'
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
'  // helper: populate a single select element with LOV options from GET_LOV',
'function loadLovInto(selectEl, lovType, currentVal){',
'    if(!selectEl) return;',
'    console.log("DEBUG: loadLovInto called for type =", lovType, "currentVal =", currentVal);',
'',
'    selectEl.disabled = true;',
'',
'    // prepopulate if dataset has prepop',
'    if(selectEl.dataset && selectEl.dataset.prepopId){',
'        console.log("DEBUG: prepopulating select with", selectEl.dataset.prepopId);',
'        selectEl.innerHTML = '''';',
'        var o = document.createElement(''option'');',
'        o.value = selectEl.dataset.prepopId || '''';',
'        o.text = selectEl.dataset.prepopName || '''';',
'        selectEl.appendChild(o);',
'        try { selectEl.value = currentVal || ''''; } catch(e){ console.warn(e); }',
'        selectEl.disabled = false;',
'        selectEl.dispatchEvent(new Event(''change''));',
'        return;',
'    }',
'',
'    selectEl.innerHTML = ''<option>Loading...</option>'';',
'',
'    apex.server.process(''GET_LOV'', { x01: lovType }, {',
'        dataType: ''json'',',
'        success: function(data){',
'            console.log("DEBUG: GET_LOV returned", data);',
'            selectEl.innerHTML = '''';',
'            data.forEach(function(opt){',
'                var o = document.createElement(''option'');',
'                o.value = opt.r === null ? '''' : String(opt.r);',
'                o.text = opt.d === null ? '''' : opt.d;',
'                if(opt.e) o.dataset.email = opt.e;',
'                if(opt.p) o.dataset.phone = opt.p;',
'                selectEl.appendChild(o);',
'            });',
'            try { selectEl.value = currentVal || ''''; } catch(e){ console.warn(e); }',
'            selectEl.disabled = false;',
'            selectEl.dispatchEvent(new Event(''change''));',
'        },',
'        error: function(jqXHR, textStatus, errorThrown){',
'            console.error("DEBUG: GET_LOV error", textStatus, errorThrown);',
'            selectEl.innerHTML = ''<option value="">- Error loading -</option>'';',
'            selectEl.disabled = false;',
'        }',
'    });',
'',
'    // default server call',
'    selectEl.innerHTML = ''<option>Loading...</option>'';',
'    apex.server.process(''GET_LOV'', { x01: lovType }, {',
'      dataType: ''json'',',
'      success: function(data){',
'        selectEl.innerHTML = '''';',
'        data.forEach(function(opt){',
'          var o = document.createElement(''option'');',
'          o.value = opt.r === null ? '''' : String(opt.r);',
'          o.text = opt.d === null ? '''' : opt.d;',
'          if(opt.e) o.dataset.email = opt.e;',
'          if(opt.p) o.dataset.phone = opt.p;',
'          selectEl.appendChild(o);',
'        });',
'        try { selectEl.value = currentVal || ''''; } catch(e){ }',
'        selectEl.disabled = false;',
'        selectEl.dispatchEvent(new Event(''change''));',
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
'      valueInput.value = value;',
'',
'      // edit stars',
'      container.querySelectorAll(".star-btn .star").forEach((starEl, idx)=>{',
'        if(idx < value){',
'          starEl.classList.add("text-yellow-400"); starEl.classList.remove("text-gray-300");',
'        } else {',
'          starEl.classList.add("text-gray-300"); starEl.classList.remove("text-yellow-400");',
'        }',
'      });',
'',
'      // view stars',
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
'      return;',
'    }',
'',
'    if(!actionBtn) return;',
'    var card = actionBtn.closest(''.hotel-card'');',
'    if(!card) return;',
'',
'    // ===== EDIT =====',
'if(actionBtn.classList.contains(''js-edit'')){',
'  card.querySelectorAll(''.view-mode'').forEach(el=>el.style.display=''none'');',
'  card.querySelectorAll(''.edit-mode'').forEach(el=>el.style.display=''inline-block'');',
'',
'  var groupField = card.querySelector(''[data-col="GROUP_ID"] .group-lov'');',
'  if(groupField)',
'    loadLovInto(groupField, ''group'', card.querySelector(''[data-col="GROUP_ID"]'').dataset.value || '''');',
'',
'  var addrField = card.querySelector(''[data-col="ADDRESS_ID"] .addr-lov'');',
'  if(addrField){',
'    var hotelId = card.dataset.hotelId || '''';',
'    console.log("DEBUG: address LOV for hotelId = " + hotelId);',
'    loadLovInto(',
'      addrField,',
unistr('      ''addr:'' + hotelId,   // \D83D\DD11 pass hotel id with addr'),
'      card.querySelector(''[data-col="ADDRESS_ID"]'').dataset.value || ''''',
'    );',
'  }',
'',
'  var contactField = card.querySelector(''[data-col="CONTACT_ID"] .contact-lov'');',
'  if(contactField){',
'    var hotelId = card.dataset.hotelId || '''';',
'    console.log("DEBUG: contact LOV for hotelId = " + hotelId);',
'    loadLovInto(',
'      contactField,',
'      ''contact:'' + hotelId,',
'      card.querySelector(''[data-col="CONTACT_ID"]'').dataset.value || ''''',
'    );',
'  }',
'',
'  var starField = card.querySelector(''[data-col="STAR_RATING"]'');',
'  if(starField){',
'    var value = parseInt(starField.dataset.value) || 0;',
'    var valueInput = starField.querySelector(''.star-value'');',
'    if(valueInput) valueInput.value = value;',
'    starField.querySelectorAll(''.star-btn .star'').forEach((starEl, idx)=>{',
'      if(idx < value){',
'        starEl.classList.add(''text-yellow-400''); starEl.classList.remove(''text-gray-300'');',
'      } else {',
'        starEl.classList.add(''text-gray-300''); starEl.classList.remove(''text-yellow-400'');',
'      }',
'    });',
'  }',
'',
'  card.querySelectorAll(''.js-edit'').forEach(b=>b.style.display=''none'');',
'  card.querySelectorAll(''.js-save,.js-cancel'').forEach(b=>b.style.display=''inline-block'');',
'  return;',
'}',
'',
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
'    if(actionBtn.classList.contains(''js-save'')){',
'      var id = card.dataset.id;',
'      if(!id){',
'        apex.message.showErrors([{ type:''error'', location:''page'', message:''Missing record ID'', unsafe:false }]);',
'        return;',
'      }',
'      var payload = { ID: id };',
'      var changed = false;',
'',
'      card.querySelectorAll(''.field'').forEach(function(field){',
'        var col = (field.dataset.col || '''').toUpperCase();',
'        if(!col) return;',
'        var orig = field.dataset.value !== undefined ? String(field.dataset.value) : '''';',
'',
'        var sel = field.querySelector(''select.edit-mode'');',
'        var input = field.querySelector(''input.edit-mode'');',
'        var starInput = field.querySelector(''.star-value'');',
'',
'        if(sel){',
'          var val = sel.value === '''' ? null : sel.value;',
'          if(String(val) !== String(orig)){ payload[col]=val; changed=true; }',
'        } ',
'        else if(starInput){',
'          var val = starInput.value;',
'          if(String(val) !== String(orig)){ payload[col]=val; changed=true; }',
'        }',
'        else if(input){',
'          var val = input.value;',
'          if(String(val) !== String(orig)){ payload[col]=val; changed=true; }',
'        }',
'      });',
'',
'      if(!changed){',
'        card.querySelectorAll(''.edit-mode'').forEach(el=>el.style.display=''none'');',
'        card.querySelectorAll(''.view-mode'').forEach(el=>el.style.display='''');',
'        card.querySelectorAll(''.js-edit'').forEach(b=>b.style.display=''inline-block'');',
'        card.querySelectorAll(''.js-save,.js-cancel'').forEach(b=>b.style.display=''none'');',
'        return;',
'      }',
'',
'        console.log("DEBUG SAVE payload:", payload);',
'',
'      // AJAX SAVE',
'      apex.server.process(''SAVE_CARD'', { x01: JSON.stringify(payload) }, {',
'        dataType:''json'',',
'        success: function(res){',
'          if(!res){ ',
'            apex.message.showErrors([{type:''error'', location:''page'', message:''Empty server response'', unsafe:false}]); ',
'            return; ',
'          }',
'          Swal.fire({',
'            icon: res.alert_icon || ''info'',',
'            title: res.alert_title || ''Notice'',',
'            text: res.alert_message || res.message || '''',',
'            timer: res.alert_timer || 3000,',
'            timerProgressBar:true,',
'            toast:true,',
'            position:''top-end'',',
'            showConfirmButton:false',
'          });',
'          if(res.status && String(res.status).toUpperCase()===''S''){',
'            apex.region("hotel_card_region").refresh();',
'          } else {',
'            apex.message.showErrors([{type:''error'', location:''page'', message: res.message || ''Save failed'', unsafe:false}]);',
'          }',
'        },',
'        error:function(jqXHR,textStatus,errorThrown){',
'          apex.message.showErrors([{type:''error'', location:''page'', message:errorThrown||''Server error'', unsafe:false}]);',
'        }',
'      });',
'    }',
'  });',
'',
' ',
'// ================== CHANGE HANDLER ==================',
'  document.addEventListener("change", function(e){',
'    var sel = e.target;',
' // --- GROUP LOV Add New ---',
'    if(sel.classList.contains(''group-lov'') && sel.value === ''ADD_NEW''){',
unistr('      var hotelId = $v("P6_HOTEL_ID");   // \2705 page item'),
'      sel.value = ''''; // reset LOV',
'   apex.navigation.dialog("f?p=103:10:&SESSION.:::10:P10_ID:123", {',
'  title: "Hotel Group",',
'  height: "auto",',
'  width: "720",',
'  modal: true',
'});',
'',
'',
'    }',
'      if(sel.classList.contains(''addr-lov'') && sel.value === ''ADD_NEW''){',
unistr('      var hotelId = apex.item(''P6_HOTEL_LIST'').getValue();//$v("P6_HOTEL_LIST");   // \2705 page item'),
unistr('     var card = sel.closest(''.hotel-card'');   // \2705 capture card here'),
'     sel.value = ''''; // reset LOV',
'  apex.navigation.dialog(//"f?p=103:7:&SESSION.:::7:P7_ID:123", ',
'               //  "f?p=103:7:&APP_SESSION.::NO::",',
'               "f?p=103:7:&SESSION.:::7:P7_HOTEL_ID:&P6_HOTEL_LIST.", ',
'      {',
'  title: "Hotel Address",',
'  height: "auto",',
' //width: "720",',
'  modal: true,',
'            close: function() {',
'                if(card){',
'                    var addrField = card.querySelector(''[data-col="ADDRESS_ID"] .addr-lov'');',
'                    if(addrField){',
'                        // Reload the LOV dynamically in edit mode',
'                        loadLovInto(addrField,',
'              "addr:" + hotelId,',
'              addrField.value || '''');',
'                    }',
'                }}',
'      ',
'});',
'    }',
'    ',
'    if(sel.classList.contains(''contact-lov'') && sel.value === ''ADD_NEW''){',
'  var card = sel.closest(''.hotel-card'');   // capture the card',
unistr('  var hotelId = card.dataset.hotelId;       // \2705 use the card''s hotel ID'),
'  sel.value = ''''; // reset LOV',
'',
'  apex.navigation.dialog(',
'    "f?p=103:12:&SESSION.:::12:P12_HOTEL_ID:&P6_HOTEL_LIST.", // keep same format if you want',
'    {',
'      title: "Hotel Contact",',
'      height: "auto",',
'      modal: true,',
'      close: function() {',
'        if(card){',
'          var contactField = card.querySelector(''[data-col="CONTACT_ID"] .contact-lov'');',
'          if(contactField){',
'            // Reload the LOV dynamically in edit mode',
'            loadLovInto(contactField, "contact:" + hotelId, contactField.value || '''');',
'          }',
'        }',
'      }',
'    }',
'  );',
'}',
'',
'',
' /*if(sel.classList.contains(''contact-lov'') && sel.value === ''ADD_NEW''){',
' var hotelId = apex.item(''P6_HOTEL_LIST'').getValue();',
unistr('   var card = sel.closest(''.hotel-card'');   // \2705 capture card here'),
'  sel.value = ''''; // reset LOV',
'  ',
'  apex.navigation.dialog(',
'   // "f?p=103:12:&APP_SESSION.:::12:P12_HOTEL_ID:" + hotelId, ',
'"f?p=103:12:&SESSION.:::12:P12_HOTEL_ID:&P6_HOTEL_LIST.", ',
'    {',
'      title: "Hotel Contact",',
'      height: "auto",',
'      //width: "720",',
'      modal: true,',
'            close: function() {',
'                if(card){',
'                    var contactField = card.querySelector(''[data-col="CONTACT_ID"] .contact-lov'');',
'                    if(contactField){',
'                        // Reload the LOV dynamically in edit mode',
'                        loadLovInto(contactField,',
'              "contact:" + hotelId,',
'              contactField.value || '''');',
'    }',
'                }}',
'      ',
'});',
'    }*/',
'    ',
'    ',
'',
'',
'/*if(sel.classList.contains(''addr-lov'') && sel.value === ''ADD_NEW''){',
'  var hotelId = $v("P6_HOTEL_ID");',
'  sel.value = ''''; // reset LOV',
'  apex.navigation.dialog(',
'    "f?p=103:7:" + $v("pInstance") + ":::7:P7_HOTEL_ID:" + hotelId,',
'    {',
'      title: "Hotel Address",',
'      height: "auto",',
'      modal: true',
'    }',
'  );',
'}',
'',
'if(sel.classList.contains(''contact-lov'') && sel.value === ''ADD_NEW''){',
unistr('  var hotelId = $v("P6_HOTEL_LIST");   // \2705 page item'),
'  sel.value = ''''; // reset LOV',
'  ',
'  apex.navigation.dialog(',
'    "f?p=103:12:&APP_SESSION.:::12:P12_HOTEL_ID:" + hotelId, ',
'    {',
'      title: "Hotel Contact",',
'      height: "auto",',
'      //width: "720",',
'      modal: true',
'    }',
'  );',
'}',
'*/',
'',
'',
'    // --- CONTACT LOV: show email/phone ---',
'    if(sel.classList.contains(''contact-lov'')){',
'      var field = sel.closest(''.field'');',
'      if(!field) return;',
'      var selected = sel.selectedOptions && sel.selectedOptions[0];',
'      var email = selected?.dataset?.email || '''';',
'      var phone = selected?.dataset?.phone || '''';',
'',
'      var editDetails = field.querySelector(''.edit-mode.contact-details'');',
'      if(editDetails){',
'        var emailSpan = editDetails.querySelector(''#contact-email'');',
'        var phoneSpan = editDetails.querySelector(''#contact-phone'');',
'        if(emailSpan) emailSpan.textContent = email;',
'        if(phoneSpan) phoneSpan.textContent = phone;',
'      }',
'    }',
'  });',
'',
'})(); // end IIFE',
'',
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
'    width: 30rem;',
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
'    max-height: 40rem;',
'    object-fit: contain;',
'}',
'',
'/* ----------------------- Hotel Name ----------------------- */',
'.hotel-card .hotel-name-input,',
'.hotel-card .field[data-col="HOTEL_NAME"] .view-mode {',
'    font-family: ''Inter'', ''Segoe UI'', ''Arial'', sans-serif;',
'    font-weight: 700;            /* bold */',
'    font-size: 2.15rem;          /* big but safe */',
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
'    font-size: 0.8rem;',
'    color: #4b5563;  /* medium gray */',
'}',
'',
'/* ----------------------- Stars ----------------------- */',
'.stars-view .star,',
'.stars-edit .star-btn .star {',
'    font-family: ''Segoe UI Symbol'', ''Arial'', sans-serif;',
'    font-size: 1.75rem;           /* large stars */',
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
 p_id=>wwv_flow_imp.id(10536985584842340)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(8558440305922134)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11352429461891719)
,p_plug_name=>'Main Region'
,p_region_name=>'HOTEL_CARD_REGION'
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
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11353948465891734)
,p_plug_name=>'hotel_card_region'
,p_region_name=>'hotel_card_region'
,p_parent_plug_id=>wwv_flow_imp.id(11352429461891719)
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
'<div class="hotel-card" data-id="&P6_HOTEL_LIST.">',
'  <div class="muted">Group Name</div>',
'  <h1 class="hotel-name" data-col="GROUP_NAME" data-type="text">&P6_GROUP_NAME.</h1>',
'',
'  <div class="muted">Hotel Name</div>',
'  <div class="value" data-col="HOTEL_NAME" data-type="text">&P6_HOTEL_NAME.</div>',
'',
'  <div class="muted">Rating</div>',
'  <div class="value" data-col="STARS" data-type="number">&P6_STARS.</div>',
'',
'  <div class="muted">Address (Google Map Link)</div>',
'  <div class="value">',
'    <a target="_blank" href="https://maps.google.com/?q=&P6_ADDRESS.">',
'      <span data-col="ADDRESS" data-type="text">&P6_ADDRESS.</span>',
'    </a>',
'  </div>',
'',
'  <div class="muted">Contact (Call Link)</div>',
'  <div class="value">',
'    <a href="tel:&P6_CONTACT_NO."><span data-col="CONTACT_NO" data-type="text">&P6_CONTACT_NO.</span></a>',
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
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11675079225603114)
,p_plug_name=>'HOTEL_LIST'
,p_region_name=>'hotel_card_region'
,p_parent_plug_id=>wwv_flow_imp.id(11352429461891719)
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
'    IF :P6_HOTEL_LIST IS NULL THEN',
unistr('        l_html := ''<div class="p-4 text-gray-600">\2139\FE0F Please select a hotel first.</div>'';'),
'        RETURN l_html;',
'    END IF;',
'',
'    -- 1. Hotel basic info (safe)',
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
'         WHERE h.id = :P6_HOTEL_LIST;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
unistr('            l_html := ''<div class="p-4 text-red-600">\26A0\FE0F No hotel found for ID: ''||:P6_HOTEL_LIST||''</div>'';'),
'            RETURN l_html;',
'    END;',
'',
'    -- 2. Map link',
'    l_map_link := ''https://www.google.com/maps/search/?api=1&query='' ||',
'                  REPLACE(l_map_link,'' '',''+'');',
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
'             WHERE hotel_id = l_id',
'               AND primary = ''Y'';',
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
'    -- 4. Static hotel placeholder image (default)',
'    l_img_url := :APP_FILES||''hotel.jpeg'';',
'',
'    -- 5. Build HTML output',
'    l_html :=',
'''<div class="hotel-card flex bg-white rounded-lg shadow-lg p-6 justify-between" ',
'     data-id="''||RAWTOHEX(l_id)||''"',
'     data-hotel-id="''||RAWTOHEX(l_id)||''">',
'',
'  <!-- Left Side: Hotel Details -->',
'  <div class="flex-1 flex flex-col space-y-4 pr-6">',
'',
'    <!-- Group -->',
'    <div class="field" data-col="GROUP_ID" data-value="''||NVL(TO_CHAR(l_group),'''')||''">',
'      <div class="text-sm text-gray-500 mb-1">Group Name</div>',
'      <span class="view-mode text-gray-800">''||apex_escape.html(l_group_name)||''</span>',
'      <select class="edit-mode group-lov border rounded p-1" style="display:none;"></select>',
'    </div>',
'',
'    <!-- Hotel Name -->',
'    <div class="field" data-col="HOTEL_NAME">',
'      <div class="text-sm text-gray-500 mb-1">Hotel Name</div>',
'      <span class="view-mode text-gray-800">''||apex_escape.html(l_hotel_name)||''</span>',
'      <input class="edit-mode border rounded p-1" type="text" value="''||apex_escape.html(l_hotel_name)||''" style="display:none;" />',
'    </div>',
'',
'    <!-- Star Rating -->',
'    <div class="field" data-col="STAR_RATING" data-value="''||NVL(TO_CHAR(l_star),''0'')||''">',
'      <div class="text-sm text-gray-500 mb-1">Rating</div>',
'      <div class="view-mode stars-view flex space-x-1">'';',
'        FOR i IN 1..5 LOOP',
'            IF l_star >= i THEN',
unistr('                l_html := l_html || ''<span class="star filled text-yellow-400">\2605</span>'';'),
'            ELSE',
unistr('                l_html := l_html || ''<span class="star empty text-gray-300">\2606</span>'';'),
'            END IF;',
'        END LOOP;',
'    l_html := l_html || ''</div>',
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
'    <div class="field" data-col="ADDRESS_ID" data-value="''||NVL(RAWTOHEX(l_addr),'''')||''">',
'      <div class="text-sm text-gray-500 mb-1">Address</div>',
'      <a class="view-mode text-gray-800" target="_blank" href="''||l_map_link||''">''||l_addr_text||''</a>',
'      <select class="edit-mode addr-lov border rounded p-1" style="display:none;"',
'        data-hotel="''||RAWTOHEX(l_id)||''"',
'        data-selected="''||NVL(RAWTOHEX(l_addr),'''')||''"></select>',
'    </div>',
'',
'    <!-- Contact -->',
'    <div class="field" data-col="CONTACT_ID" data-value="''||NVL(RAWTOHEX(l_contact),'''')||''">',
'      <div class="text-sm text-gray-500 mb-1">Primary Contact</div>',
'      <div class="view-mode text-gray-800">',
'        <div><strong>''||apex_escape.html(l_contact_name)||''</strong> (''||apex_escape.html(l_contact_position)||'')</div>'';',
'        IF l_contact_email IS NOT NULL THEN',
'            l_html := l_html || ''<div><i class="fa fa-envelope"></i> <a href="mailto:''||apex_escape.html(l_contact_email)||''">''||apex_escape.html(l_contact_email)||''</a></div>'';',
'        END IF;',
'        IF l_contact_phone IS NOT NULL THEN',
'            l_html := l_html || ''<div><i class="fa fa-phone"></i> <a href="tel:''||apex_escape.html(l_contact_phone)||''">''||apex_escape.html(l_contact_phone)||''</a></div>'';',
'        END IF;',
'    l_html := l_html || ''</div>',
'      <select class="edit-mode contact-lov border rounded p-1" style="display:none;"',
'        data-hotel="''||RAWTOHEX(l_id)||''"',
'        data-selected="''||NVL(RAWTOHEX(l_contact),'''')||''"></select>',
'    </div>',
'',
'    <!-- Actions -->',
'    <div class="actions flex gap-2 mt-2">',
'      <button type="button" class="t-Button js-edit bg-gray-800 text-white rounded px-4 py-2">Edit</button>',
'      <button type="button" class="t-Button js-save bg-blue-600 text-white rounded px-4 py-2 hidden">Save</button>',
'      <button type="button" class="t-Button js-cancel bg-gray-400 text-white rounded px-4 py-2 hidden">Cancel</button>',
'      <span class="status-msg ml-2 text-sm text-green-600" aria-live="polite"></span>',
'    </div>',
'',
'  </div> <!-- End Left Details -->',
'',
'     <!-- Right Side: Large Full Column Image -->',
'  <div class="hotel-image-box">',
'    <img src="''||:APP_FILES||''hotel.jpeg" />',
'  </div>',
'',
'',
'',
'</div>'';',
'',
'    RETURN l_html;',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P6_HOTEL_LIST'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(12545842713179932)
,p_plug_name=>'HOTEL_LIST'
,p_parent_plug_id=>wwv_flow_imp.id(11352429461891719)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>100
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
'    l_map_link          VARCHAR2(4000);',
'BEGIN',
'    -- 0. If no hotel chosen',
'    IF :P6_HOTEL_LIST IS NULL THEN',
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
'         WHERE h.id = :P6_HOTEL_LIST;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
unistr('            l_html := ''<div class="p-4 text-red-600">\26A0\FE0F No hotel found for ID: ''||:P6_HOTEL_LIST||''</div>'';'),
'            RETURN l_html;',
'    END;',
'',
'    -- 2. Map link',
'    l_map_link := ''https://www.google.com/maps/search/?api=1&query='' ||',
'                  REPLACE(l_map_link,'' '',''+'');',
'',
'    -- 3. Contact lookup',
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
'             WHERE hotel_id = l_id',
'               AND primary = ''Y'';',
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
'    -- 4. Build HTML card',
'    l_html := ',
'''<div class="hotel-card grid grid-cols-2 gap-6 bg-white rounded-lg shadow-lg p-6" ',
'     data-id="''||RAWTOHEX(l_id)||''" ',
'     data-hotel-id="''||RAWTOHEX(l_id)||''">',
'',
'  <!-- Left column: Hotel details -->',
'  <div class="flex flex-col space-y-4">',
'',
'    <!-- Group -->',
'    <div class="field" data-col="GROUP_ID" data-value="''||NVL(TO_CHAR(l_group),'''')||''">',
'      <div class="text-sm text-gray-500 mb-1">Group Name</div>',
'      <span class="view-mode text-gray-800">''||apex_escape.html(l_group_name)||''</span>',
'    </div>',
'',
'    <!-- Hotel Name -->',
'    <div class="field" data-col="HOTEL_NAME">',
'      <div class="text-sm text-gray-500 mb-1">Hotel Name</div>',
'      <span class="view-mode text-gray-800 font-semibold">''||apex_escape.html(l_hotel_name)||''</span>',
'    </div>',
'',
'    <!-- Star Rating -->',
'    <div class="field" data-col="STAR_RATING" data-value="''||NVL(TO_CHAR(l_star),''0'')||''">',
'      <label class="text-sm text-gray-500 block mb-1">Rating</label>',
'      <div class="flex space-x-1">'';',
'        FOR i IN 1..5 LOOP',
'            IF l_star >= i THEN',
unistr('                l_html := l_html || ''<span class="text-yellow-400">\2605</span>'';'),
'            ELSE',
unistr('                l_html := l_html || ''<span class="text-gray-300">\2606</span>'';'),
'            END IF;',
'        END LOOP;',
'    l_html := l_html || ''</div>',
'    </div>',
'',
'    <!-- Address -->',
'    <div class="field" data-col="ADDRESS_ID" data-value="''||NVL(RAWTOHEX(l_addr),'''')||''">',
'      <div class="text-sm text-gray-500 mb-1">Address</div>',
'      <a class="text-gray-800" target="_blank" href="''||l_map_link||''">''||l_addr_text||''</a>',
'    </div>',
'',
'    <!-- Contact -->',
'    <div class="field" data-col="CONTACT_ID" data-value="''||NVL(RAWTOHEX(l_contact),'''')||''">',
'      <div class="text-sm text-gray-500 mb-1">Primary Contact</div>',
'      <div class="text-gray-800">',
'        <div><strong>''||apex_escape.html(l_contact_name)||''</strong> (''||apex_escape.html(l_contact_position)||'')</div>'';',
'          IF l_contact_email IS NOT NULL THEN',
'            l_html := l_html || ''<div><i class="fa fa-envelope"></i> <a href="mailto:''||apex_escape.html(l_contact_email)||''">''||apex_escape.html(l_contact_email)||''</a></div>'';',
'          END IF;',
'          IF l_contact_phone IS NOT NULL THEN',
'            l_html := l_html || ''<div><i class="fa fa-phone"></i> <a href="tel:''||apex_escape.html(l_contact_phone)||''">''||apex_escape.html(l_contact_phone)||''</a></div>'';',
'          END IF;',
'    l_html := l_html || ''</div>',
'    </div>',
'',
'    <!-- Actions -->',
'    <div class="actions flex gap-2">',
'      <button type="button" class="t-Button js-edit bg-gray-800 text-white rounded px-4 py-2">Edit</button>',
'      <button type="button" class="t-Button js-save bg-blue-600 text-white rounded px-4 py-2 hidden">Save</button>',
'      <button type="button" class="t-Button js-cancel bg-gray-400 text-white rounded px-4 py-2 hidden">Cancel</button>',
'    </div>',
'',
'  </div>',
'',
'  <!-- Right column: Placeholder image -->',
'  <div class="flex justify-center items-center">',
'    <img src="https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg"',
'         alt="Hotel Placeholder"',
'         class="rounded-lg object-cover w-full h-full max-w-full max-h-full" />',
'  </div>',
'',
'</div>'';',
'',
'    RETURN l_html;',
'END;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P6_HOTEL_LIST'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11352597006891720)
,p_name=>'P6_HOTEL_LIST'
,p_item_sequence=>20
,p_prompt=>'Hotel'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'  nvl(Hotel_NAME,''Name'') as Name,',
'ID as ID',
'FROM',
'',
'UR_HOTELS',
'WHERE nvl(ASSOCIATION_END_DATE,sysdate) >= sysdate',
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
 p_id=>wwv_flow_imp.id(11353179860891726)
,p_name=>'P6_GROUP_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(11352429461891719)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11353249368891727)
,p_name=>'P6_HOTEL_NAME'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(11352429461891719)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11353326583891728)
,p_name=>'P6_STARS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(11352429461891719)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11353587136891730)
,p_name=>'P6_ADDRESS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(11352429461891719)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11353691588891731)
,p_name=>'P6_CONTACT_NO'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(11352429461891719)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11353739067891732)
,p_name=>'P6_HOTEL_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(11352429461891719)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11675422222603118)
,p_name=>'P6_ALERT_MESSAGE'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11675538137603119)
,p_name=>'P6_ALERT_TITLE'
,p_item_sequence=>60
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11675633447603120)
,p_name=>'P6_ALERT_ICON'
,p_item_sequence=>70
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(11675813510603122)
,p_name=>'P6_ALERT_TIMER'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11352634372891721)
,p_name=>'On page load'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11352779287891722)
,p_event_id=>wwv_flow_imp.id(11352634372891721)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_name=>'Hide main region'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(11352429461891719)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11352886523891723)
,p_name=>'Change Hotel'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_HOTEL_LIST'
,p_condition_element=>'P6_HOTEL_LIST'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11352984864891724)
,p_event_id=>wwv_flow_imp.id(11352886523891723)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(11352429461891719)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11353065662891725)
,p_event_id=>wwv_flow_imp.id(11352886523891723)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(11352429461891719)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11255122587832444)
,p_name=>'New'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_NEW'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11255285752832445)
,p_event_id=>wwv_flow_imp.id(11255122587832444)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_NEW_1'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex_util.get_blob_file_src("P6_NEW")',
''))
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11674453556603108)
,p_name=>'DA - Hotel list change'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P6_HOTEL_LIST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11674515145603109)
,p_event_id=>wwv_flow_imp.id(11674453556603108)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P6_HOTEL_ID,P6_CONTACT_NO,P6_ADDRESS,P6_STARS,P6_HOTEL_NAME,P6_GROUP_NAME'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT RAWTOHEX(id) AS ID,',
'       GROUP_ID,',
'       HOTEL_NAME,',
'       STAR_RATING,',
'       ADDRESS_ID,',
'       CONTACT_ID',
'FROM   UR_HOTELS',
'WHERE  ID = RAWTOHEX(:P6_HOTEL_LIST)',
''))
,p_attribute_07=>'P6_HOTEL_LIST'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11674731011603111)
,p_event_id=>wwv_flow_imp.id(11674453556603108)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(11675079225603114)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(11661752500499041)
,p_name=>'New_1'
,p_event_sequence=>50
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(11675079225603114)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_required_patch=>wwv_flow_imp.id(8557885664922129)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11662272196499046)
,p_event_id=>wwv_flow_imp.id(11661752500499041)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Show popup when user clicks "+ Define new address"',
'document.addEventListener("click", function(e) {',
'  if (e.target.classList.contains("define-new-addr")) {',
'    document.getElementById("new-address-modal").classList.remove("hidden");',
'  }',
'});',
'',
'// Cancel button hides popup',
'//document.getElementById("cancel-new-address").addEventListener("click", function() {',
'//  document.getElementById("new-address-modal").classList.add("hidden");',
'//  document.getElementById("new-address-input").value = "";',
'//});',
'//'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11661819026499042)
,p_event_id=>wwv_flow_imp.id(11661752500499041)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  l_new_address_id RAW(16);',
'  l_hotel_raw      RAW(16);',
'BEGIN',
'  -- If P6_HOTEL_ID is stored as hex string on the page: convert it:',
'  l_hotel_raw := HEXTORAW(:P6_HOTEL_ID);  -- if :P6_HOTEL_ID is hex text',
'  -- Or if P6_HOTEL_ID already stored as RAW in session state, use it directly:',
'  -- l_hotel_raw := :P6_HOTEL_ID;',
'',
'  l_new_address_id := PKG_ADDRESS_CREATE.add_address_from_json(',
'    p_hotel_id   => l_hotel_raw,',
'    p_json       => :P6_ADDRESS_JSON,    -- JSON payload from client (omit HOTEL_ID key)',
'    p_created_by => HEXTORAW(:APP_USER_GUID)   -- or NULL / whatever you track',
'  );',
'',
'  -- Do NOT set :P6_HOTEL_ID or modify it here. If you want to display the new address id on page,',
'END;',
''))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(11675760703603121)
,p_event_id=>wwv_flow_imp.id(11661752500499041)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'ser'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'showAlert(',
'    $v("P6_ALERT_TITLE"),',
'    $v("P6_ALERT_MESSAGE"),',
'    $v("P6_ALERT_ICON")',
'   // $v("P6_ALERT_TIMER")',
');'))
,p_server_condition_type=>'NEVER'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11353894653891733)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Before Header'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
' IF :P6_HOTEL_LIST IS NOT NULL THEN',
'    BEGIN',
'      SELECT ID,',
'             GROUP_ID,',
'             HOTEL_NAME,',
'             STAR_RATING,',
'             ADDRESS_ID,',
'             CONTACT_ID',
'      INTO   :P6_HOTEL_ID,',
'             :P6_GROUP_NAME,',
'             :P6_HOTEL_NAME,',
'             :P6_STARS,',
'             :P6_ADDRESS,',
'             :P6_CONTACT_NO',
'      FROM   UR_HOTELS',
'      WHERE  ID = :P6_HOTEL_LIST;',
'    EXCEPTION',
'      WHEN NO_DATA_FOUND THEN',
'        NULL;',
'    END;',
'  END IF;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>11353894653891733
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11354013037891735)
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
'  l_hotel_id   ur_hotels.id%TYPE;',
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
'-- After generic CRUD',
'IF l_contact_id IS NOT NULL THEN',
'    BEGIN',
'        UPDATE ur_hotels',
'           SET contact_id = l_contact_id_raw',
'         WHERE id = hextoraw(replace(apex_json.get_varchar2(''$.ID''),''-'',''''));',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            l_message := ''Contact update failed: '' || SQLERRM;',
'    END;',
'END IF;',
'',
'',
'  -- parse payload to fetch IDs we just saved',
'  BEGIN',
'    apex_json.parse(l_payload);',
'    /*l_group_id   := apex_json.get_varchar2(''$.GROUP_ID'');',
'    l_addr_id    := apex_json.get_varchar2(''$.ADDRESS_ID'');',
'    l_contact_id := apex_json.get_varchar2(''$.CONTACT_ID'');*/',
'    apex_json.parse(l_payload);',
'    dbms_output.put_line(''Payload: '' || l_payload);',
'',
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
'      SELECT contact_name INTO l_contact_name FROM ur_contacts WHERE id = l_contact_id_raw;',
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
,p_internal_uid=>11354013037891735
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11662131715499045)
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
,p_internal_uid=>11662131715499045
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(11675174250603115)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_LOV'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_type     VARCHAR2(100);',
'    l_hotel_id VARCHAR2(4000);',
'BEGIN',
'    -- Assign inside BEGIN (not in DECLARE)',
'    l_type := apex_application.g_x01;',
'',
'    -- HTTP headers for JSON',
'    owa_util.mime_header(''application/json'', FALSE);',
'    owa_util.http_header_close;',
'',
'    -- Always begin with a JSON array',
'    apex_json.open_array;',
'',
'    -- Default "None" option',
'    apex_json.open_object;',
'    --apex_json.write(''r'', NULL, p_write_null => TRUE);',
'    apex_json.write(''d'', ''- None -'');',
'    apex_json.close_object;',
'',
'    -- Group LOV',
'    IF l_type = ''group'' THEN',
'        FOR rec IN (',
'            SELECT id, group_name',
'              FROM ur_hotel_groups',
'          ORDER BY group_name',
'        ) LOOP',
'            apex_json.open_object;',
'            apex_json.write(''r'', TO_CHAR(rec.id));',
'            apex_json.write(''d'', NVL(rec.group_name, ''''));',
'            apex_json.close_object;',
'        END LOOP;',
'        -- Extra option: Add New',
'    apex_json.open_object;',
'    apex_json.write(''r'', ''ADD_NEW''); -- special marker',
'    apex_json.write(''d'', ''+ Add New Group'');',
'    apex_json.close_object;',
'',
'    -- Address LOV',
'    ELSIF l_type LIKE ''addr:%'' THEN',
'  l_hotel_id := SUBSTR(l_type, INSTR(l_type, '':'')+1);',
'',
' FOR rec IN (',
'    SELECT id,',
'           street_address || '', '' || city || '', '' || country AS display_value',
'      FROM ur_addresses',
'     WHERE hotel_id = HEXTORAW(l_hotel_id)  -- filter by hotel_id column',
'     ORDER BY street_address',
') LOOP',
'    apex_json.open_object;',
'    apex_json.write(''r'', RAWTOHEX(rec.id));',
'    apex_json.write(''d'', rec.display_value);',
'    apex_json.close_object;',
'END LOOP;',
'        -- Extra option: Add New',
'    apex_json.open_object;',
'    apex_json.write(''r'', ''ADD_NEW''); -- special marker',
'    apex_json.write(''d'', ''+ Add New Address'');',
'    apex_json.close_object;',
'',
'',
'',
'',
'    -- Contact LOV',
'    ELSIF l_type LIKE ''contact:%'' THEN',
'        -- Extract hotel_id after the colon',
'        l_hotel_id := SUBSTR(l_type, INSTR(l_type, '':'')+1);',
'',
'        FOR rec IN (',
'            SELECT c.id AS contact_id,',
'                   c.contact_name || '' ('' || NVL(c.position_title, ''Unknown'') || '')'' AS contact_display,',
'                   c.email,',
'                   c.phone_number',
'              FROM ur_contacts c',
'             WHERE c.hotel_id = HEXTORAW(l_hotel_id)',
'        ) LOOP',
'            apex_json.open_object;',
'            ',
'           apex_json.write(''r'', RAWTOHEX(rec.contact_id));',
'            apex_json.write(''d'', rec.contact_display);',
'            apex_json.write(''e'', rec.email);',
'            apex_json.write(''p'', rec.phone_number);',
'            apex_json.close_object;',
'        END LOOP;',
'        -- Extra option: Add New',
'    apex_json.open_object;',
'    apex_json.write(''r'', ''ADD_NEW''); -- special marker',
'    apex_json.write(''d'', ''+ Add New Contact'');',
'    apex_json.close_object;',
'    END IF;',
'',
'    -- Close JSON array',
'    apex_json.close_array;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- Clear any open structures',
'        apex_json.close_all;',
'',
'        -- Always return a valid JSON array with one object',
'        apex_json.open_array;',
'          apex_json.open_object;',
'          --apex_json.write(''r'', NULL, p_write_null => TRUE);',
'          apex_json.write(''d'', ''- Error loading -'');',
'          apex_json.write(''err'', SQLERRM);',
'          apex_json.close_object;',
'        apex_json.close_array;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>11675174250603115
);
wwv_flow_imp.component_end;
end;
/
