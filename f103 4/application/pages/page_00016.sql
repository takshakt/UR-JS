prompt --application/pages/page_00016
begin
--   Manifest
--     PAGE: 00016
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
 p_id=>16
,p_name=>'test'
,p_alias=>'TEST'
,p_step_title=>'test'
,p_autocomplete_on_off=>'OFF'
,p_html_page_header=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">',
''))
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'https://cdn.tailwindcss.com',
'#APP_FILES#dynamictbl#MIN#.js'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  body {',
'    font-family: ''Inter'', sans-serif;',
'    background-color: #1a202c; /* Dark background similar to the image */',
'    color: #cbd5e0; /* Light text for contrast */',
'  }',
'  /* Custom styles for subtle animations and effects */',
'  .card-item {',
'    transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;',
'  }',
'  .card-item:hover {',
'    transform: translateY(-5px) scale(1.01);',
'    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.4);',
'  }',
'  .card-title {',
'    position: relative;',
'    padding-bottom: 0.75rem; /* pb-3 */',
'    margin-bottom: 0.75rem; /* mb-3 */',
'  }',
'  .card-title::after {',
'    content: '''';',
'    position: absolute;',
'    left: 0;',
'    bottom: 0;',
'    width: 100%;',
'    height: 1px;',
'    background-color: rgba(255, 255, 255, 0.1); /* Subtle divider */',
'  }',
'  .field-label {',
'    color: #a0aec0; /* Lighter gray for labels */',
'  }',
'  .editable-value {',
'    cursor: pointer;',
'    padding: 2px 4px; /* Give it some padding for better clickability */',
'    border-radius: 4px;',
'    transition: background-color 0.1s ease;',
'  }',
'  .editable-value:hover {',
'    background-color: rgba(255, 255, 255, 0.1); /* Subtle hover effect */',
'  }',
'  .edit-input {',
'    background-color: #3f4254; /* Darker input background */',
'    color: #cbd5e0;',
'    border: 1px solid #4a5568; /* Subtle border */',
'    border-radius: 4px;',
'    padding: 2px 4px;',
'    width: 100%;',
'    box-sizing: border-box; /* Include padding and border in element''s total width */',
'    font-size: 0.875rem; /* text-sm */',
'  }'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'17'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(9903136254138610)
,p_plug_name=>'Dynamic Table'
,p_title=>'Dynamic Table'
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--accent15:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="container mx-auto p-4 sm:p-6 lg:p-8">',
'  <div class="bg-gray-900 shadow-2xl rounded-xl p-6 sm:p-8 lg:p-10 mb-8 border border-gray-700">',
'    <div id="cardsContainer" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">',
'      <p class="col-span-full text-center text-gray-400 my-8">Loading data cards...</p>',
'    </div>',
'  </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(11390779760988876)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(8558440305922134)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(9903016943138609)
,p_name=>'P16_JSON_DATA'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(9903335312138612)
,p_name=>'New'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(9903442562138613)
,p_event_id=>wwv_flow_imp.id(9903335312138612)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_name=>'Render Dynamic Table'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'null;',
'/**     console.error(''test Call JS'');',
'    const jsonString = document.getElementById("P16_JSON_DATA").value;',
'    console.log("DEBUG: P16_JSON_DATA value (raw string):", jsonString);',
'    const cardsContainer = document.getElementById(''cardsContainer'');',
'    if (!jsonString || jsonString.trim() === '''') { ',
'      cardsContainer.innerHTML = `',
'        ',
'      `;',
'      console.error("No JSON string found or it''s empty in P16_JSON_DATA.");',
'      return;',
'    }',
'    let data;',
'    try {',
'      data = JSON.parse(jsonString.trim()); ',
'      console.log("DEBUG: Parsed JSON data:", data);',
'      console.log("DEBUG: Type of parsed data:", typeof data); ',
'      console.log("DEBUG: Length of parsed data array:", data.length);',
'    } catch (e) {',
'      cardsContainer.innerHTML = `',
'        <div class="col-span-full bg-red-800 bg-opacity-30 border border-red-700 text-red-300 px-4 py-3 rounded relative mx-auto max-w-lg" role="alert">',
'          <strong class="font-bold">Error!</strong>',
'          <span class="block sm:inline">Failed to parse JSON data. Ensure your PL/SQL generates valid JSON. Details in console.</span>',
'        </div>',
'      `;',
'      console.error("Error parsing JSON:", e);',
'      return;',
'    }',
'    if (!Array.isArray(data) || data.length === 0) {',
'      cardsContainer.innerHTML = `',
'        <div class="col-span-full bg-yellow-800 bg-opacity-30 border border-yellow-700 text-yellow-300 px-4 py-3 rounded relative mx-auto max-w-lg" role="alert">',
'          <strong class="font-bold">Info:</strong>',
'          <span class="block sm:inline">No data rows found in the JSON to display.</span>',
'        </div>',
'      `;',
'      console.log("DEBUG: No data rows found or data is not an array after parsing.");',
'      return;',
'    }',
'    cardsContainer.innerHTML = '''';',
'    data.forEach(rowData => {',
'      const card = document.createElement(''div'');',
'      card.classList.add(',
'        ''card-item'',',
'        ''bg-gray-800'',',
'        ''rounded-xl'',',
'        ''p-6'',',
'        ''shadow-lg'',',
'        ''border'',',
'        ''border-gray-700'',',
'        ''flex'',',
'        ''flex-col''',
'      );',
'      const cardTitleText = rowData.HOTEL_NAME || rowData.ID || ''Unnamed Item'';',
'      const titleDiv = document.createElement(''h2'');',
'      titleDiv.classList.add(''card-title'', ''text-xl'', ''font-semibold'', ''text-white'', ''mb-3'', ''pb-3'');',
'      titleDiv.textContent = cardTitleText;',
'      card.appendChild(titleDiv);',
'      const contentDiv = document.createElement(''div'');',
'      contentDiv.classList.add(''flex-grow'');',
'      Object.keys(rowData).forEach(key => {',
'        if (key === ''HOTEL_NAME'' && rowData.HOTEL_NAME) return;',
'        if (key === ''ID'' && rowData.HOTEL_NAME) return; ',
'        if (key === ''ID'' && !rowData.HOTEL_NAME && cardTitleText === rowData.ID) return; ',
'        const value = rowData[key];',
'        if (value !== null && value !== undefined && String(value).trim() !== '''') {',
'            const fieldContainer = document.createElement(''div'');',
'            fieldContainer.classList.add(''flex'', ''items-center'', ''mb-2'');',
'',
'            const label = document.createElement(''span'');',
'            label.classList.add(''field-label'', ''text-sm'', ''font-medium'', ''w-2/5'');',
'            label.textContent = key.replace(/_/g, '' '') + '':''; // Clean up key for display',
'            const valueSpan = document.createElement(''span'');',
'            valueSpan.classList.add(''text-gray-200'', ''text-sm'', ''w-3/5'', ''break-words'');',
'            valueSpan.textContent = value; // Use the value directly',
'            fieldContainer.appendChild(label);',
'            fieldContainer.appendChild(valueSpan);',
'            contentDiv.appendChild(fieldContainer);',
'        }',
'      });',
'      card.appendChild(contentDiv);',
'      cardsContainer.appendChild(card);',
'    });',
'    console.log("DEBUG: Cards rendering process completed.");',
'  */'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(9903259549138611)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Fetch Data and Generate JSON'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_json_string CLOB;',
'BEGIN',
'    -- Using APEX_JSON for simpler JSON generation',
'    APEX_JSON.initialize_clob_output;',
'',
'    APEX_JSON.OPEN_ARRAY; -- Start of the JSON array',
'',
'    FOR rec IN (SELECT ',
'    ID,',
'    HOTEL_NAME,',
'    STAR_RATING,',
'    ADDRESS_ID,',
'    CONTACT_ID,',
'    GROUP_ID,',
'    CURRENCY_CODE,',
'    TO_CHAR(OPENING_DATE, ''DD-MON-YYYY'') AS OPENING_DATE,',
'    TO_CHAR(ASSOCIATION_START_DATE, ''DD-MON-YYYY'') AS ASSOCIATION_START_DATE,',
'    TO_CHAR(ASSOCIATION_END_DATE, ''DD-MON-YYYY'') AS ASSOCIATION_END_DATE,',
'    CREATED_BY,',
'    CREATED_ON,',
'    UPDATED_BY,',
'    UPDATED_ON',
'FROM UR_HOTELS) LOOP',
'        APEX_JSON.OPEN_OBJECT; -- Start of a JSON object for each row',
'		',
'        APEX_JSON.WRITE(''ID'', rec.ID);',
'        APEX_JSON.WRITE(''HOTEL_NAME'', rec.HOTEL_NAME);',
'        APEX_JSON.WRITE(''STAR_RATING'', nvl(rec.STAR_RATING,0));',
'        APEX_JSON.WRITE(''CURRENCY_CODE'', nvl(rec.CURRENCY_CODE,''NULL''));',
'        APEX_JSON.WRITE(''OPENING_DATE'', nvl(rec.OPENING_DATE,''NULL''));',
'        APEX_JSON.WRITE(''ASSOCIATION_START_DATE'',nvl( rec.ASSOCIATION_START_DATE,''NULL''));',
'        APEX_JSON.WRITE(''ASSOCIATION_END_DATE'', nvl(rec.ASSOCIATION_END_DATE,''NULL'')); ',
'		',
'		',
'        APEX_JSON.CLOSE_OBJECT; -- End of the JSON object',
'    END LOOP;',
'',
'    APEX_JSON.CLOSE_ARRAY; -- End of the JSON array',
'',
'    -- Get the generated JSON string',
'    l_json_string := APEX_JSON.get_clob_output;',
'',
'    -- Assign the JSON string to the hidden page item',
'    :P16_JSON_DATA := l_json_string;',
'',
'    APEX_JSON.free_output; -- Free resources',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        -- Handle errors appropriately, e.g., log them or set an error message',
'        APEX_DEBUG.ERROR(''Error generating JSON: %s'', SQLERRM);',
'        :P16_JSON_DATA := ''[]''; -- Return an empty array on error',
'        APEX_JSON.free_output;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>9903259549138611
);
wwv_flow_imp.component_end;
end;
/
