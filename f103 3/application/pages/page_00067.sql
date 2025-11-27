prompt --application/pages/page_00067
begin
--   Manifest
--     PAGE: 00067
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.10'
,p_default_workspace_id=>7945143549875994
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'WKSP_DEV'
);
wwv_flow_imp_page.create_page(
 p_id=>67
,p_name=>'Report Summary'
,p_alias=>'REPORT-SUMMARY'
,p_step_title=>'Report Summary'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APP_FILES#ReportSummary#MIN#.js',
'https://cdn.tailwindcss.com',
''))
,p_css_file_urls=>'https://cdn.tailwindcss.com'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  /* Custom styles for the application */',
'        body {',
'            font-family: ''Inter'', sans-serif;',
'            overscroll-behavior: none; /* Prevents pull-to-refresh on mobile */',
'            width: 100%;',
'        }',
'        canvas {',
'            display: block;',
'            touch-action: none; /* Disables default touch actions like pinch-zoom */',
'        }',
'        .modal {',
'            display: none; /* Hidden by default */',
'            position: fixed;',
'            z-index: 1000;',
'            left: 0;',
'            top: 0;',
'            width: 100%;',
'            height: 100%;',
'            overflow: auto;',
'            background-color: rgba(0,0,0,0.6);',
'            align-items: center;',
'            justify-content: center;',
'        } ',
' ',
' .t-Body-content, ',
'.t-Body-main {',
'    max-width: none !important; /* Removes max width limit */',
'    padding-left: 0 !important;',
'    padding-right: 0 !important;',
'}',
'',
'/* 2. Target the Universal Theme region container */',
'/* This removes any default padding/margin from the region''s direct parent */',
'.t-Region {',
'    padding: 0 !important;',
'    margin: 0 !important;',
'}',
'',
'/* 3. Target the main grid container */',
'/* Ensures the internal grid that holds your region is also 100% */',
'.t-PageBody--content,',
'.container {',
'    max-width: 100% !important;',
'}',
'',
'/* 4. Ensure your custom region fills the space */',
'.bg-gray-900.w-full {',
'    width: 100% !important;',
'    margin: 0 !important;',
'    padding: 0 !important;',
'}',
'',
'/* -------------------------------------------------------------------------- */',
'',
'/* Enforce full-screen overlay for the modal backdrop */',
'.modal {',
'    /* The core fixes for APEX positioning/display conflicts */',
'    position: fixed !important;',
'    z-index: 1000 !important;',
'    left: 0 !important;',
'    top: 0 !important;',
'    width: 100% !important;',
'    height: 100% !important;',
'    overflow: auto !important;',
'    ',
'    /* Ensure the backdrop is centered and dark */',
'    background-color: rgba(0,0,0,0.6) !important;',
'    align-items: center !important; ',
'    justify-content: center !important;',
'    ',
'    /* Ensure initial hidden state is strong enough */',
'    display: none !important;',
'}',
'',
'/* Ensure the modal content container''s Tailwind styles hold */',
'.modal-content {',
'    width: 100% !important;',
'    max-width: 1000px !important;',
'    /* Enforce Tailwind colors/borders against APEX defaults */',
'    background-color: #1F2937 !important; /* bg-gray-800 equivalent */',
'    border: 1px solid #374151 !important;  /* border-gray-700 equivalent */',
'    border-radius: 0.5rem !important;     /* rounded-lg equivalent */',
'}',
'',
'/* Ensure the main canvas fills the available height (if needed) */',
'#reportCanvas {',
'    /* Adjust ''64px'' if your header/control bar is a different height */',
'    height: calc(100vh - 64px) !important;',
'}',
'',
'/* -------------------------------------------------------------------------- */',
'/* Button DIV Style Fixes */',
'/* -------------------------------------------------------------------------- */',
'',
'/* This helps ensure the Tailwind spacing and background on your button DIVs are applied correctly */',
'.bg-blue-600, .bg-red-600, .bg-gray-600 {',
'    /* Enforce padding and text color */',
'    padding-top: 0.5rem !important; ',
'    padding-bottom: 0.5rem !important;',
'    padding-left: 1rem !important;',
'    padding-right: 1rem !important;',
'    color: #fff !important;',
'    font-weight: 700 !important; /* bold */',
'    cursor: pointer !important;',
'}',
'',
'',
'',
'',
'#saveReportsBtn {',
'    display: none !important;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(18398038107878608)
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(18398938950879401)
,p_plug_name=>'pageloadRN'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="bg-gray-900 text-white overflow-hidden">',
' ',
'',
'    <div class="p-4 bg-gray-800 flex justify-between items-center z-10">',
'    ',
'    <div class="flex **flex-col** **space-y-2**"> ',
'        <h1 class="text-xl font-bold">Hotel:</h1>',
'        ',
'        <div class="flex items-center" id="hotelLovContainer">',
'            <label for="hotelSelect" class="text-sm font-medium text-gray-300 mr-2"></label>',
'            <select ',
'                id="hotelSelect" ',
'                class="bg-gray-700 border border-gray-600 rounded-md p-1 text-white focus:outline-none focus:ring-2 focus:ring-blue-500 w-64 cursor-pointer"',
'            >',
'                <option value="">Loading Hotels...</option>',
'            </select>',
'        </div>',
'    </div>',
'        <div class="flex items-center">',
'        </div>',
'        <div ',
'            id="addReportBtn" ',
'            class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg shadow-md transition-transform transform hover:scale-105 cursor-pointer select-none"',
'            role="button"',
'            tabindex="0">',
'            Add Report',
'        </div>',
'',
'         <button id="saveReportsBtn" class="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded transition duration-150 ease-in-out mr-2">',
'                Save',
'            </button>',
'    </div>',
'',
'    <canvas id="reportCanvas"></canvas>',
'',
'    <div id="reportModal" class="modal **apx-no-border apx-no-shadow**">',
'        <div class="modal-content bg-gray-800 rounded-lg p-6 shadow-2xl border border-gray-700">',
'            ',
'            <h2 id="modalTitle" class="text-2xl font-bold mb-4">Add New Report</h2>',
'            <div class="mb-4">',
'                <label for="reportSelect" class="block text-sm font-medium text-gray-300 mb-1">Select Existing Report</label>',
'                <select ',
'                    id="reportSelect" ',
'                    class="w-full bg-gray-700 border border-gray-600 rounded-md p-2 text-white focus:outline-none focus:ring-2 focus:ring-blue-500"',
'                    disabled >',
'                    <option value="">-- Select Hotel First --</option>',
'                </select>',
'            </div>',
'',
'            <div class="mb-4">',
'                <label for="reportName" class="block text-sm font-medium text-gray-300 mb-1">Report Title</label>',
'                <input type="text" id="reportName" class="w-full bg-gray-700 border border-gray-600 rounded-md p-2 text-white focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="e.g., Hotel Pricing Analysis">',
'            </div>',
'            <div class="mb-6">',
'                <label for="reportData" class="block text-sm font-medium text-gray-300 mb-1">Report Data (JSON format)</label>',
'                <textarea id="reportData" rows="10" class="w-full bg-gray-700 border border-gray-600 rounded-md p-2 text-white font-mono text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="Paste your JSON data here..."></textare'
||'a>',
'            </div>',
'            <div class="flex justify-between items-center">',
'			<div',
'				id="deleteBtn"',
'				class="bg-red-600 hover:bg-red-700 text-white font-bold py-2 px-4 rounded-lg transition-colors cursor-pointer select-none hidden"',
'				role="button"',
'				tabindex="0" >',
'				Delete Report',
'			</div>',
'			<div class="flex justify-end space-x-4 ml-auto">',
'				<div',
'					id="cancelBtn"',
'					class="bg-gray-600 hover:bg-gray-700 text-white font-bold py-2 px-4 rounded-lg transition-colors cursor-pointer select-none"',
'					role="button"',
'					tabindex="0" >',
'					Cancel',
'				</div>',
'				<div',
'					id="saveBtn"',
'					class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-lg transition-colors cursor-pointer select-none"',
'					role="button"',
'					tabindex="0" >',
'					Save Report',
'				</div>',
'			</div>',
'		</div>',
'        </div>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp.component_end;
end;
/
