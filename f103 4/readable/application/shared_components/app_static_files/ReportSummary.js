
        // --- DOM Elements (IDs remain the same) ---
        const canvas = document.getElementById('reportCanvas');
        const ctx = canvas.getContext('2d');
        const addReportBtn = document.getElementById('addReportBtn');
        const modal = document.getElementById('reportModal');
        const modalTitle = document.getElementById('modalTitle');
        const cancelBtn = document.getElementById('cancelBtn');
        const saveBtn = document.getElementById('saveBtn');
		const deleteBtn = document.getElementById('deleteBtn'); // <--- NEW
        const reportNameInput = document.getElementById('reportName');
        const reportDataInput = document.getElementById('reportData');

        // --- Canvas & Drawing Configuration ---
        const ROW_HEIGHT = 35; 
        const HEADER_HEIGHT = 45; 
        const TITLE_HEIGHT = 40;
        const PADDING = 15;
        const FONT_SIZE = 14;
        const ROWS_PER_PAGE = 5; 
        const TABLE_SPACING = 10; 

        // --- State Management ---
        let reports = []; 
        let scale = 1.0;
        let pan = { x: 0, y: 0 };
        let lastMouse = { x: 0, y: 0 };
        let isPanning = false;
        let isDraggingTable = false;
        let draggedTableIndex = -1;
        let dragOffset = { x: 0, y: 0 };
        let editingReportIndex = -1; 
        let expressionJson;        
		function deleteReport() {
    if (editingReportIndex !== -1 && confirm(`Are you sure you want to delete report: ${reports[editingReportIndex].name}?`)) {
        reports.splice(editingReportIndex, 1);
        hideModal();
        draw();
        saveReports();
    }
	}
	
        // Sample data to pre-fill the textarea
        const sampleData = {
            "rows": [{"ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON": "105", "HAMPTON": "101", "STAY_DATE": "9/28/2025", "DOUBLETREE_BY_HILTON_YORK": "98", "MOXY_YORK": "105", "NOVOTEL_YORK_CENTRE": "82", "HILTON_YORK": "93", "HAMPTON_BY_HILTON_YORK": "101"}, {"ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON": "1100", "HAMPTON": "203", "STAY_DATE": "9/29/2025", "DOUBLETREE_BY_HILTON_YORK": "223", "MOXY_YORK": "210", "NOVOTEL_YORK_CENTRE": "212", "HILTON_YORK": "215"}, {"ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON": "119", "HAMPTON": "135", "STAY_DATE": "9/27/2025", "DOUBLETREE_BY_HILTON_YORK": "126", "MOXY_YORK": "122", "NOVOTEL_YORK_CENTRE": "141", "HILTON_YORK": "129", "HAMPTON_BY_HILTON_YORK": "135"}, {"ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON": "119", "HAMPTON": "135", "STAY_DATE": "9/24/2025", "DOUBLETREE_BY_HILTON_YORK": "135", "MOXY_YORK": "140", "NOVOTEL_YORK_CENTRE": "147", "HILTON_YORK": "134", "HAMPTON_BY_HILTON_YORK": "135"}, {"ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON": "131", "HAMPTON": "172", "STAY_DATE": "9/26/2025", "DOUBLETREE_BY_HILTON_YORK": "148", "MOXY_YORK": "149", "NOVOTEL_YORK_CENTRE": "150", "HILTON_YORK": "158", "HAMPTON_BY_HILTON_YORK": "172"}, {"ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON": "137", "HAMPTON": "161", "STAY_DATE": "9/23/2025", "DOUBLETREE_BY_HILTON_YORK": "182", "MOXY_YORK": "171", "NOVOTEL_YORK_CENTRE": "175", "HILTON_YORK": "156", "HAMPTON_BY_HILTON_YORK": "161"}, {"ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON": "159", "HAMPTON": "200", "STAY_DATE": "9/22/2025", "DOUBLETREE_BY_HILTON_YORK": "204", "MOXY_YORK": "219", "NOVOTEL_YORK_CENTRE": "224", "HILTON_YORK": "213"}, {"ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON": "89", "HAMPTON": "101", "STAY_DATE": "9/21/2025", "DOUBLETREE_BY_HILTON_YORK": "1111", "MOXY_YORK": "96", "NOVOTEL_YORK_CENTRE": "89", "HILTON_YORK": "95", "HAMPTON_BY_HILTON_YORK": "101"}, {"ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON": "Sold out", "HAMPTON": "172", "STAY_DATE": "9/25/2025", "DOUBLETREE_BY_HILTON_YORK": "Sold out", "MOXY_YORK": "158", "NOVOTEL_YORK_CENTRE": "180", "HILTON_YORK": "147", "HAMPTON_BY_HILTON_YORK": "172"}]
            };


            // --- Aggregate Calculation Function ---
            function calculateAggregates(data, columns) {
                const aggregates = {};
                
                if (!data.rows || data.rows.length === 0) {
                    columns.forEach(col => { aggregates[col.key] = ''; });
                    return aggregates;
                }

                columns.forEach(col => {
                    if (col.key === 'STAY_DATE') {
                        aggregates[col.key] = '';
                        return;
                    }
                    
                    let sum = 0;
                    data.rows.forEach(row => {
                        let value = row[col.key];
                        if (typeof value === 'string') {
                            value = value.replace(/[^0-9.]/g, ''); 
                        }
                        const num = parseFloat(value);
                        if (!isNaN(num) && num !== Infinity) {
                            sum += num;
                        }
                    });
                    
                    aggregates[col.key] = Math.round(sum).toLocaleString();
                });
                return aggregates;
            }

            // --- Core Report Processor (Reusable Logic) ---
            function processReportData(name, data, existingX, existingY, existingPage = 0) {
                console.log('processReportData:>>>expressionJson>>>>>>',expressionJson);
                if (!data.rows || data.rows.length === 0) {
                    return {
                        name,
                        data,
                        x: existingX || 50,
                        y: existingY || 50,
                        width: 200, 
                        height: TITLE_HEIGHT + HEADER_HEIGHT + (2 * ROW_HEIGHT), 
                        currentPage: 0,
                        totalPages: 0,
                        columns: [{ key: 'Error', header: 'No Data', width: 200 }],
                        aggregates: {},
                        expressionJson: expressionJson,
                    };
                }
                
               // const headers = Object.keys(data.rows[0]);
                const headers = [...new Set(data.rows.flatMap(row => Object.keys(row)))];
                
                const aggregates = calculateAggregates(data, headers.map(h => ({ key: h })));

                const maxContentWidths = headers.reduce((acc, header) => {
                    ctx.font = `${FONT_SIZE}px Inter`;
                    let maxWidth = 0;
                    data.rows.forEach(row => {
                        maxWidth = Math.max(maxWidth, ctx.measureText(row[header] || '').width);
                    });
                    
                    const aggregateLabelWidth = ctx.measureText('TOTAL (All Pages)').width;
                    const aggregateValueWidth = ctx.measureText(aggregates[header] || '').width;
                    
                    if (headers[0] === header) {
                        maxWidth = Math.max(maxWidth, aggregateLabelWidth + aggregateValueWidth + PADDING); 
                    } else {
                        maxWidth = Math.max(maxWidth, aggregateValueWidth);
                    }

                    acc[header] = maxWidth;
                    return acc;
                }, {});

                // Column Width Calculation
                const MIN_COL_WIDTH = 100;
                let columns = headers.map(header => {
                    ctx.font = `bold ${FONT_SIZE}px Inter`;
                    const headerText = header.replace(/_/g, ' ');
                    const headerWidth = ctx.measureText(headerText).width;
                    
                    const calculatedWidth = Math.max(
                        MIN_COL_WIDTH,
                        headerWidth,
                        maxContentWidths[header]
                    ) + (PADDING * 4);
                    
                    return {
                        key: header,
                        header: headerText,
                        width: calculatedWidth,
                    };
                });
                console.log('setup columns:>>>>>>>>>>>>>>>>>>>>>__________>',columns);
               columns = columns.map(column => ({
                        ...column,
                        key: column.key.includes(" - ") ? column.key.split(" - ")[0] : column.key
                    }));

                const tableWidth = columns.reduce((acc, col) => acc + col.width, 0);
                const maxVisibleRowsCount = ROWS_PER_PAGE; 
                
                const tableHeight = TITLE_HEIGHT + HEADER_HEIGHT + (maxVisibleRowsCount * ROW_HEIGHT) + (2 * ROW_HEIGHT);
                
                const totalPages = Math.ceil(data.rows.length / ROWS_PER_PAGE);

                const report = {
								name,
								data,
								x: existingX || 50,
								y: existingY || 50,
								width: tableWidth,
								height: tableHeight,
								currentPage: existingPage,
								totalPages,
								columns,
								aggregates,
                                expressionJson: expressionJson,
							};

							// REMOVED: report.prevButton = ... and report.nextButton = ... 
							// The coordinates are now calculated dynamically in mousedown.

							return report;
            }


            // --- Report Management Functions ---

           // Ensure 'pan' is a global object defined elsewhere, e.g., let pan = { x: 0, y: 0 };

function saveReports() {
    const savableReports = reports.map(r => ({
        name: r.name,
        x: Math.round(r.x), 
        y: Math.round(r.y),
        reportId: r.reportId,
        currentPage: r.currentPage,
      //  data: r.data, 
    }));
    
    // NEW: Combine Reports array and Pan state into a single object
    const fullState = {
        reports: savableReports,
        canvasState: {
            panX: Math.round(pan.x),
            panY: Math.round(pan.y),
        }
    };
    
    const savedJson = JSON.stringify(fullState, null, 2);
    
    console.log('--- Saved Report Canvas Data (JSON) ---');
    console.log(savedJson);
    console.log('-----------------------------------------');

    apex.server.process(
        'AJX_MANAGE_REPORT_DASHBOARD', // Your AJAX process name
        {x01: 'INSERT_SUMMARY',
        x02: hotel_id,
        x03: savedJson},
        {
           success: function(pData) {
             console.log('--- Saved Report Canvas Data (JSON) ---');
                // pData is now the array itself, so you can check its length
               //alert('Report has been saved successfully.!' );
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("AJAX Error: " + textStatus + " - " + errorThrown);
            }
        }
    );

    // Return the full state object as a JSON string
    return savedJson;
} 

function call_dashboard_data(selectedHotel_Id){
  
apex.server.process(
            'AJX_MANAGE_REPORT_DASHBOARD', 
            {
                x01: 'SELECT_SUMMARY',
                x02:  selectedHotel_Id
            },
            {
                success: function(pData) {
                    console.log('AJX_MANAGE_REPORT_DASHBOARD call successful!', pData);
                      loadReportsFromResponse(pData);
                            
                           
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error("AJAX Error: " + textStatus + " - " + errorThrown);
                }
            }
        );
}

function loadReportsFromResponse(response) {
  try {
        const parsed = typeof response === "string" ? JSON.parse(response) : response;
        const payload = JSON.parse(parsed[0].l_payload);

        reports.length = 0; // optional: clear old reports
        const reportList = payload.reports || [];
console.log('reportList:>>>>>',reportList);
       reportList.forEach((rep, index) => {
    setTimeout(() => {
        loadReportDataForCanvas(rep.reportId, -1, rep.x, rep.y);
        if (index === reportList.length - 1) {
            // Wait a short moment to ensure draw() is done
            setTimeout(() => fitCanvasToReports(), 500);
        }
    }, index * 400);
});

      
    } catch (err) {
        console.error("Error loading reports from JSON:", err, "response:", response);
    }
}


function fitCanvasToReports() {
    if (!reports || reports.length === 0) return;

    // 1️⃣ Find bounding box that covers all reports
    let minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity;
    reports.forEach(r => {
        minX = Math.min(minX, r.x);
        minY = Math.min(minY, r.y);
        maxX = Math.max(maxX, r.x + (r.width || 300));
        maxY = Math.max(maxY, r.y + (r.height || 200));
    });

    // 2️⃣ Add a little margin around all reports
    const margin = 100;
    minX -= margin;
    minY -= margin;
    maxX += margin;
    maxY += margin;

    // 3️⃣ Compute required scale to fit them all within canvas
    const canvasWidth = canvas.width;
    const canvasHeight = canvas.height;

    const reportsWidth = maxX - minX;
    const reportsHeight = maxY - minY;

    const scaleX = canvasWidth / reportsWidth;
    const scaleY = canvasHeight / reportsHeight;

    // Choose the smaller scale so everything fits
    let newScale = Math.min(scaleX, scaleY);
    newScale = Math.min(1, newScale * 0.6); // don’t zoom in above 1x

    // 4️⃣ Center the reports in the view
    const centerX = (minX + maxX) / 2;
    const centerY = (minY + maxY) / 2;

    pan.x = canvasWidth / 2 - centerX * newScale;
    pan.y = canvasHeight / 2 - centerY * newScale;

    scale = newScale;

    console.log(`Canvas fit: scale=${scale.toFixed(2)}, pan=`, pan);
    draw();
}




const hotelSelect = document.getElementById('hotelSelect');
let hotel_id ;
// Add a listener to trigger report list loading whenever the hotel selection changes
hotelSelect.addEventListener('change', function() {
    const selectedHotelId = this.value;
    hotel_id = selectedHotelId;
    if (selectedHotelId) {
        // Load the Report LOV in the modal
        loadReportLov(selectedHotelId); 
        call_dashboard_data(selectedHotelId);
    } else {
        // If no hotel is selected, reset and disable the report LOV
        $('#reportSelect').prop('disabled', true).html('<option value="">-- Select Hotel First --</option>');
    }
});


function loadReportLov(selectedHotelId) {
    // Assuming jQuery is available based on your reference code snippet
    const reportLov = $('#reportSelect');
    
    // Disable and show 'Loading' message while fetching data
    reportLov.prop('disabled', true).html('<option value="">Loading Reports...</option>');

    if (!selectedHotelId) {
        reportLov.html('<option value="">-- Select Hotel First --</option>');
        return;
    }

    apex.server.process(
        'AJX_GET_REPORT_HOTEL', // Your On-Demand Process Name
        {
            x01: 'REPORT', 
            x02: selectedHotelId
        },
        {
            success: function(pData) {
                // Clear the loading message
                console.log('pData:>>>>',pData);
                reportLov.empty();
                
                // Add the default option
                reportLov.append('<option value="">-- Select Report --</option>');

                if (Array.isArray(pData) && pData.length > 0) {
                    pData.forEach(function(item) {
                        // Use the keys from your AJAX response (ID, REPORT_NAME, DEFINITION)
                        reportLov.append(
                            $('<option>', {
                                value: item.ID,
                                text: item.REPORT_NAME,
                                title: item.DEFINITION // Store definition for a potential tooltip
                            })
                        );
                    });
                } else {
                    reportLov.append('<option value="">No Reports Found</option>');
                }
                
                // Enable the LOV after population
                reportLov.prop('disabled', false); 
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("AJAX call failed to fetch report list:", textStatus, errorThrown);
                reportLov.html('<option value="">Load Failed</option>');
                reportLov.prop('disabled', true);
            },
            dataType: "json"
        }
    );
}


function loadReportDataForCanvas(reportId, updateIndex = -1, posX = 50, posY = 50) {
    console.log('Loading report data for reportId:', reportId, 'updateIndex:', updateIndex);

    apex.server.process(
        "AJX_GET_REPORT_HOTEL",
        { 
            x01: 'REPORT_DETAIL',
            x02: reportId           
        },
        {
            dataType: "json",
            success: function(data) {
                if (!data || data.length === 0) return;

                let reportCol, db_ob_name, col_alias;
                data.forEach(function(report) {
                    reportCol = report.DEFINITION_JSON; 
                    db_ob_name = report.DB_OBJECT_NAME;
                    col_alias = report.COLUMN_ALIAS;
                    expressionJson = report.EXPRESSIONS_CLOB;
                });
                console.log('expressionJson:>>>>>===========>>',expressionJson);
                const reportColObj = JSON.parse(reportCol);

                var columns_list = reportColObj.selectedColumns.map(item => ({
                    name: `${item.col_name} - ${item.temp_name}`,
                    type: item.data_type
                        ? item.data_type.toLowerCase() === 'number' ? 'number'
                        : item.data_type.toLowerCase() === 'date' ? 'date'
                        : 'string'
                        : 'number'
                }));

                apex.server.process(
                    "AJX_GET_REPORT_DATA",
                    { 
                        x01: JSON.stringify(columns_list),
                        x02: col_alias,
                        x03: db_ob_name
                    },
                    {
                        success: function(pData) {
                            console.log('pData:>>>>>>>>',pData);
                                                        const colAliasObj = JSON.parse(col_alias);
                                    const dataForCanvas = { rows: pData.rows };

                                    // ✅ Always use the name the user entered in the modal
                                    const reportName = reportNameInput.value.trim() || colAliasObj.hotel || `Report_${Date.now()}`;

                                    
                                    const newReport = processReportData(reportName, dataForCanvas);

                                    newReport.id = newReport.id || crypto.randomUUID();

                                    if (updateIndex !== -1 && reports[updateIndex]) {
                                        // ✅ Update existing report (keep its position & pagination)
                                        const old = reports[updateIndex];
                                        newReport.id = old.id; // ✅ Preserve the same unique ID
                                        newReport.x = old.x;
                                        newReport.y = old.y;
                                        newReport.reportId = old.reportId;
                                        newReport.currentPage = old.currentPage;

                                        // Replace the single element safely
                                        reports.splice(updateIndex, 1, newReport);
                                        console.log('reports:>>>>>>',reports);
                                        console.log(`Updated existing report: ${reportName}`);
                                    } else {


                                        // ✅ Add new report

                                        if (l_new_create > 0){
                                      //  newReport.x = reports.length > 0 ? reports[reports.length - 1].x + reports[reports.length - 1].width + 20 : 50;
                                     //   newReport.y = 50;
                                        newReport.x = posX;
                                        newReport.y = posY;
                                        newReport.reportId = reportId;
                                        reports.push(newReport);
                                        console.log('reports:>>>>>>',reports);
                                        console.log(`Added new report: ${reportName}`);
                                        }else{

                                            const rect = canvas.getBoundingClientRect();
                                            const centerX = (rect.width / 2 - pan.x) / scale;
                                            const centerY = (rect.height / 2 - pan.y) / scale;

                                            newReport.x = centerX - (newReport.width || 300) / 2;
                                            newReport.y = centerY - (newReport.height || 200) / 2;
                                            newReport.reportId = reportId;

                                            reports.push(newReport);
                                            console.log(`Added new report: ${reportName} at`, newReport.x, newReport.y);
                                            l_new_create = 10;
                                        }
                                    }

                                    hideModal(); // close only after update is done
                                    draw();
                                    saveReports();
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            console.error("Error fetching report data:", textStatus, errorThrown);
                        }
                    }
                );
            },
            error: function(xhr, status, error) {
                console.error("Error fetching report definition:", error);
            }
        }
    );
}


let reportId;
$('#reportSelect').on('change', function() {
     reportId = $(this).val();
    
});



            function loadHotelList() {
                const hotelSelect = document.getElementById('hotelSelect');
                
                if (typeof apex === 'undefined' || !apex.server) {
                    console.error("APEX utilities not available. Cannot fetch hotel list.");
                    hotelSelect.innerHTML = '<option value="">APEX Error</option>';
                    return;
                }

                // Call the APEX On-Demand Process: 'GET_HOTEL_LIST'
                // NOTE: You must create this process in APEX for this code to work.
                apex.server.process(
                    "AJX_GET_REPORT_HOTEL",   // Ajax Callback name
                    { x01: 'HOTEL'           
                    },
                    {
                        dataType: "json",
                        success: function(pData) {
                                // pData is now expected to be the array: [ { "ID": "...", "HOTEL_NAME": "..." }, ... ]

                                // Clear the "Loading Hotels..." option
                                hotelSelect.innerHTML = ''; 
                                
                                const defaultOption = document.createElement('option');
                                defaultOption.value = '';
                                defaultOption.textContent = '--- Select a Hotel ---';
                                hotelSelect.appendChild(defaultOption);

                                // Check if pData is a non-empty array
                                if (Array.isArray(pData) && pData.length > 0) {
                                    pData.forEach(hotel => {
                                        const option = document.createElement('option');
                                        
                                        // Use the correct keys from your JSON structure: ID and HOTEL_NAME
                                        option.value = hotel.ID; 
                                        option.textContent = hotel.HOTEL_NAME;
                                        
                                        hotelSelect.appendChild(option);
                                    });
                                } else {
                                    const noDataOption = document.createElement('option');
                                    noDataOption.value = '';
                                    noDataOption.textContent = 'No hotels found';
                                    hotelSelect.appendChild(noDataOption);
                                }
                            },
                            error: function(jqXHR, textStatus, errorThrown) {
                                console.error("AJAX call failed to fetch hotel list:", textStatus, errorThrown);
                                hotelSelect.innerHTML = '<option value="">Load Failed</option>';
                            },
                            // IMPORTANT: Ensure dataType is set to "json" to automatically parse the response array
                            dataType: "json" 
                        });
                    }
                function loadReports(savedJson) {
                                    reports = []; 
                                    // Reset pan state to default before loading
                                    pan.x = 0;
                                    pan.y = 0;
                                    
                                    let loadedReports = [];
                                    
                                    if (savedJson) {
                                        try {
                                            const fullState = JSON.parse(savedJson);
                                            
                                            // 1. Load Reports Data
                                            if (fullState.reports && Array.isArray(fullState.reports)) {
                                                loadedReports = fullState.reports;
                                            }

                                            // 2. Load Canvas State
                                            if (fullState.canvasState) {
                                                pan.x = fullState.canvasState.panX || 0;
                                                pan.y = fullState.canvasState.panY || 0;
                                            }

                                        } catch (e) {
                                            // console.error("Error loading or parsing saved state:", e); // <--- LINE REMOVED
                                            // Execution continues below if loading failed
                                        }
                                    } else {
                                        // Handle case where loadReports is called with empty data (initial load)
                                        loadedReports = [];
                                    }
                                    
                                    // Process loaded reports or create a default one
                                    if (loadedReports.length > 0) {
                                        loadedReports.forEach(r => {
                                            const newReport = processReportData(r.name, r.data, r.x, r.y, r.currentPage,r.reportId,r.expressionJson);
                                            reports.push(newReport);
                                        });
                                    } else {
                                        const defaultReport = processReportData(`Report 1`, sampleData);
                                        //reports.push(defaultReport);
                                    }
                                    
                                    // Draw the canvas with the restored pan position
                                    draw();
                                }


            // --- Canvas Setup ---
            function resizeCanvas() {
                const dpr = window.devicePixelRatio || 1;
                canvas.width = window.innerWidth * dpr;
                canvas.height = (window.innerHeight - addReportBtn.parentElement.offsetHeight) * dpr;
                canvas.style.width = `${window.innerWidth}px`;
                canvas.style.height = `${window.innerHeight - addReportBtn.parentElement.offsetHeight}px`;
                ctx.scale(dpr, dpr);
                draw();
            }

            function openAddModal() {
                editingReportIndex = -1; 
                modalTitle.textContent = 'Add New Report';
                saveBtn.textContent = 'Add Report';
                //reportDataInput.value = JSON.stringify(sampleData, null, 4);
                reportNameInput.value = `Report ${reports.length + 1}`;
                
                // FIX: Use explicit style enforcement for APEX compatibility
                modal.style.setProperty('display', 'flex', 'important'); 
                
                deleteBtn.classList.add('hidden');
            }
             function escapeRegExp(string) {
        return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    }

            function openEditModal(reportIndex) {
                        // ✅ Ensure we're working with the right report index every time
                        if (reportIndex < 0 || !reports[reportIndex]) {
                            console.warn("Invalid report index:", reportIndex);
                            return;
                        }

                        const report = reports[reportIndex];

                        // ✅ Always reset previous edit context before assigning a new one
                        editingReportIndex = -1;
                        setTimeout(() => {
                            editingReportIndex = reportIndex;
                        }, 0);

                        modalTitle.textContent = `Edit Report: ${report.name}`;
                        saveBtn.textContent = 'Update Report';

                        // ✅ Load the correct report name into input
                        reportNameInput.value = report.name || '';

                        // (optional: populate data field if needed)
                        // reportDataInput.value = JSON.stringify(report.data, null, 4);

                        // ✅ Show modal (APEX-safe)
                        modal.style.setProperty('display', 'flex', 'important');
                        reportId = report.reportId || null; 
                        deleteBtn.classList.remove('hidden');
                    }


            function hideModal() {
                editingReportIndex = -1; 
                // FIX: Use explicit style enforcement to hide the modal
                modal.style.setProperty('display', 'none', 'important');
                
                deleteBtn.classList.add('hidden');
            }


            const saveReportsData = () => {
                // 1. Convert the reports array to a JSON string
                const dataStr = JSON.stringify(reports, null, 4); 
                // null, 4 is for pretty printing (indentation)
                
                // 2. Create a Blob (a file-like object of immutable, raw data)
                const blob = new Blob([dataStr], { type: 'application/json' });
                
                // 3. Create a temporary anchor (<a>) element for the download
                const a = document.createElement('a');
                a.href = URL.createObjectURL(blob);
                a.download = 'report_layout_' + new Date().toISOString().slice(0, 10) + '.json'; // Generate a default file name
                
                // 4. Programmatically click the anchor to start the download
                document.body.appendChild(a);
                a.click();
                
                // 5. Clean up the temporary anchor and URL object
                document.body.removeChild(a);
                URL.revokeObjectURL(a.href);
                editingReportIndex = -1;
                console.log('Reports data saved to file.');
            };

            // Event Listener for the new Save button
            document.getElementById('saveReportsBtn').addEventListener('click', saveReportsData);

            
            // --- Coordinate Transformation ---
            function getCanvasCoords(event) {
                const rect = canvas.getBoundingClientRect();
                // This correctly converts screen coordinates to canvas (scaled/panned) coordinates
                const x = (event.clientX - rect.left - pan.x) / scale;
                const y = (event.clientY - rect.top - pan.y) / scale;
                return { x, y };
            }

            // --- Drawing Functions ---
            function draw() {
                ctx.save();
                ctx.setTransform(window.devicePixelRatio, 0, 0, window.devicePixelRatio, 0, 0);
                ctx.fillStyle = '#111827'; 
                ctx.fillRect(0, 0, canvas.width, canvas.height);

                ctx.translate(pan.x, pan.y);
                ctx.scale(scale, scale);

                reports.forEach(report => drawTable(report));
                
                ctx.restore();
            }

         
       
   function groupAndAggregateRows(report) {
    const rows = report.data.rows;
    if (!rows || !rows.length) return;

    let expressionJsontbl = {};
    if (report.expressionJson) {
        try {
            expressionJsontbl = typeof report.expressionJson === "string"
                ? JSON.parse(report.expressionJson)
                : report.expressionJson;
        } catch (err) {
            console.warn("Invalid expressionJson:", err);
            expressionJsontbl = {};
        }
    }

    const selectedColumns = expressionJsontbl?.columnConfiguration?.selectedColumns || [];

    // 1️⃣ Find date column with week/month/year aggregation
    const dateAggCol = selectedColumns.find(col =>
        col.data_type?.toLowerCase() === "date" &&
        ["week", "month", "year"].includes((col.aggregation || "").toLowerCase())
    );
    if (!dateAggCol) return;

    const dateKey = dateAggCol.alias_name || dateAggCol.col_name;
    const dateAggType = dateAggCol.aggregation.toLowerCase();

    // 2️⃣ Helper to format date by aggregation
    function formatDateByAgg(dateStr) {
        const date = new Date(dateStr);
        if (isNaN(date)) return dateStr;

        switch (dateAggType) {
            case "week": {
                // ISO week calculation
                const tmpDate = new Date(date.valueOf());
                const dayNum = (date.getDay() + 6) % 7; // Monday=0
                tmpDate.setDate(tmpDate.getDate() - dayNum + 3);
                const firstThursday = new Date(tmpDate.getFullYear(), 0, 4);
                const weekNumber = 1 + Math.round(((tmpDate - firstThursday) / 86400000 - 3 + ((firstThursday.getDay() + 6) % 7)) / 7);
                return `${tmpDate.getFullYear()}-W${weekNumber.toString().padStart(2,'0')}`;
            }
            case "month":
                return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2,'0')}`;
            case "year":
                return `${date.getFullYear()}`;
            default:
                return dateStr;
        }
    }

    // 3️⃣ Group rows by formatted date
    const grouped = {};
    rows.forEach(row => {
        const groupKey = formatDateByAgg(row[dateKey]);
        if (!grouped[groupKey]) grouped[groupKey] = [];
        grouped[groupKey].push(row);
    });

    // 4️⃣ Aggregate other columns per group
    const newRows = [];
    Object.keys(grouped).forEach(groupKey => { 
    const groupRows = grouped[groupKey];
    const aggRow = {};
    aggRow[dateKey] = groupKey;

    selectedColumns.forEach(col => {
        const key = col.alias_name || col.col_name;
        if (key === dateKey) return; // skip date column
        const type = (col.data_type || "").toLowerCase();
        const aggType = (col.aggregation || "none").toLowerCase();

        if (type === "text") return; // ignore TEXT columns

        const values = groupRows.map(r => parseFloat(r[key])).filter(v => !isNaN(v));
        if (!values.length) {
            aggRow[key] = null;
            return;
        }

        // --- Handle all aggregation types ---
        switch (aggType) {
            case "avg":
                aggRow[key] = values.reduce((a,b) => a+b, 0) / values.length;
                break;
            case "min":
                aggRow[key] = Math.min(...values);
                break;
            case "max":
                aggRow[key] = Math.max(...values);
                break;
            case "cnt":
                aggRow[key] = values.length;
                break;
            case "none":
            default:
                aggRow[key] = values.reduce((a,b) => a+b, 0); // default sum
        }
    });

    newRows.push(aggRow);
});


    // 5️⃣ Sort rows by date/week/month/year correctly
    newRows.sort((a,b) => {
        if (dateAggType === "week") {
            // convert "YYYY-W##" to a date for comparison
            const [yearA, weekA] = a[dateKey].split('-W').map(Number);
            const [yearB, weekB] = b[dateKey].split('-W').map(Number);
            return yearA !== yearB ? yearA - yearB : weekA - weekB;
        } else if (dateAggType === "month") {
            return new Date(a[dateKey]+'-01') - new Date(b[dateKey]+'-01');
        } else if (dateAggType === "year") {
            return Number(a[dateKey]) - Number(b[dateKey]);
        }
        return 0;
    });

    report.data.rows = newRows; // replace original rows
    
}






       function drawTable(report) {
    let { name, data, x, y, width, height, currentPage, totalPages, columns, aggregates, expressionJson } = report;


 // Parse expressionJson
    let expressionJsontbl = {};
    if (expressionJson) {
        try {
            expressionJsontbl = typeof expressionJson === "string" 
                ? JSON.parse(expressionJson) 
                : expressionJson;
        } catch (err) {
            console.warn("Invalid expressionJson:", err);
            expressionJsontbl = {};
        }
    }

    // Check if there is a DATE column with aggregation
    const selectedColumns = expressionJsontbl?.columnConfiguration?.selectedColumns || [];
    const hasDateAggregation = selectedColumns.some(col => 
        col.data_type?.toUpperCase() === "DATE" && ["week", "month", "year"].includes(col.aggregation)
    );

    if (hasDateAggregation) {
        groupAndAggregateRows(report);
    }


    // --- Load expression JSON ---
      expressionJsontbl = report.expressionJson || expressionJson || {};
    if (typeof expressionJsontbl === "string") {
        try { expressionJsontbl = JSON.parse(expressionJsontbl); }
        catch (err) { console.warn("Invalid expressionJson:", err); expressionJsontbl = {}; }
    }

    // 🟢 Column settings for visibility + aggregation
    const selectedColumnsConfig = expressionJsontbl?.columnConfiguration?.selectedColumns || [];
    const columnVisibilityMap = {};
    const columnAggregationMap = {};
    selectedColumnsConfig.forEach(col => {
        const key = col.alias_name || col.col_name;
        columnVisibilityMap[key] = (col.visibility || "show").toLowerCase();
        columnAggregationMap[key] = (col.aggregation || "none").toLowerCase();
    });

    ctx.strokeStyle = '#4B5563';
    ctx.lineWidth = 1 / scale;

    // Draw table container
    ctx.fillStyle = '#1F2937';
    ctx.fillRect(x, y, width, height);
    ctx.strokeRect(x, y, width, height);

    // --- Draw Title ---
    ctx.fillStyle = '#FFFFFF';
    ctx.font = `bold ${FONT_SIZE * 1.2}px Inter`;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    if (editingReportIndex !== -1 && reports[editingReportIndex] === report) {
        ctx.fillStyle = '#6366F1';
        ctx.fillRect(x, y, width, TITLE_HEIGHT);
        ctx.fillStyle = '#FFFFFF';
    }
    const titleToShow = (editingReportIndex !== -1 && reports[editingReportIndex] === report)
        ? reportNameInput.value.trim() || report.name
        : report.name;
    ctx.fillText(titleToShow, x + width / 2, y + TITLE_HEIGHT / 2);

    ctx.beginPath();
    ctx.moveTo(x, y + TITLE_HEIGHT);
    ctx.lineTo(x + width, y + TITLE_HEIGHT);
    ctx.stroke();

    // --- Draw Header ---
    let headerYtbl = y + TITLE_HEIGHT;
    ctx.fillStyle = '#374151';
    ctx.fillRect(x, headerYtbl, width, HEADER_HEIGHT);
    ctx.font = `bold ${FONT_SIZE}px Inter`;
    ctx.fillStyle = '#FEE2E2';
    const visibleColumns = columns.filter(col => (columnVisibilityMap[col.key] || "show") === "show");

  let currentXtbl = x;
visibleColumns.forEach((col, index) => {
    // --- Header fill for formula columns (optional) ---
    let headerBg = '#374151'; // default header background
    // const isFormula = formulaColumns.includes(col.key);
    // if (isFormula) {
    //     // Example: light blue for formula headers
    //     headerBg = '#2563EB'; 
    // }

    ctx.fillStyle = headerBg;
    ctx.fillRect(currentXtbl, headerYtbl, col.width, HEADER_HEIGHT);

    // --- Header text ---
    ctx.textAlign = 'center';
    ctx.fillStyle = '#FEE2E2';
    ctx.fillText(col.header, currentXtbl + col.width / 2, headerYtbl + HEADER_HEIGHT / 2);

    // --- Column separator ---
    currentXtbl += col.width;
    if (index < visibleColumns.length - 1) {
        ctx.beginPath();
        ctx.moveTo(currentXtbl, headerYtbl);
        ctx.lineTo(currentXtbl, headerYtbl + HEADER_HEIGHT);
        ctx.stroke();
    }
});


    // --- Build alias map ---
    const aliasMap = {};
    const replacementTokens = [];
    selectedColumnsConfig.forEach(col => {
        const alias = col.alias_name || col.col_name;
        const fullToken = col.temp_name ? `${col.col_name} - ${col.temp_name}` : col.col_name;
        aliasMap[col.col_name] = alias;
        aliasMap[fullToken] = alias;
        replacementTokens.push({ token: fullToken, alias });
        replacementTokens.push({ token: col.col_name, alias });
        if (alias !== col.col_name) replacementTokens.push({ token: alias, alias });
    });

    // --- Apply aliases ---
    if (data?.rows) {
        data.rows = data.rows.map(row => {
            const newRow = {};
            Object.keys(row).forEach(key => newRow[aliasMap[key] || key] = row[key]);
            return newRow;
        });
    }

    // --- Formula Columns ---
    const formulas = expressionJsontbl?.formulas || {};
    const formulaColumns = Object.keys(formulas);
    if (formulaColumns.length && Array.isArray(data.rows)) {
        data.rows = data.rows.map(row => {
            const newRow = { ...row };
            formulaColumns.forEach(fcol => {
                let expr = String(formulas[fcol] || "");
                replacementTokens.forEach(tokenObj => {
                    const val = parseFloat(row[tokenObj.alias]);
                    if (!isNaN(val)) expr = expr.replace(new RegExp(`\\b${escapeRegExp(tokenObj.token)}\\b`, "g"), val);
                });
                Object.keys(row).forEach(colKey => {
                    const val = parseFloat(row[colKey]);
                    if (!isNaN(val)) expr = expr.replace(new RegExp(`\\b${escapeRegExp(colKey)}\\b`, "g"), val);
                });
                expr = expr.replace(/\s+/g, " ").trim();
                try { newRow[fcol] = eval(expr); } catch { newRow[fcol] = null; }
            });
            return newRow;
        });
        formulaColumns.forEach(fcol => {
            if (!columns.find(c => c.key === fcol)) {
                columns.push({ key: fcol, header: fcol, width: 120 });
                aliasMap[fcol] = fcol;
            }
        });
    }

    // --- Conditional Formatting ---
    const conditionalRules = expressionJsontbl?.conditionalFormatting || {};
    const formattedCells = {};
    Object.keys(conditionalRules).forEach(exprKey => {
        const rules = conditionalRules[exprKey];
        if (!Array.isArray(rules)) return;
        const aliasColKey = aliasMap[exprKey] || exprKey;
        rules.forEach(rule => {
            const { expression, color } = rule;
            if (!expression) return;
            data.rows.forEach((row, rowIndex) => {
                let exprValue = String(expression);
                const matches = exprValue.match(/\[([^\]]+)\]/g) || [];
                matches.forEach(matchedToken => {
                    const cleanToken = matchedToken.replace(/[\[\]]/g, '');
                    const aliasToken = aliasMap[cleanToken] || cleanToken;
                    const val = parseFloat(row[aliasToken]) || 0;
                    exprValue = exprValue.replaceAll(matchedToken, val);
                });
                try { if (eval(exprValue)) formattedCells[`${rowIndex}:${aliasColKey}`] = color || "#ff0000"; } catch {}
            });
        });
    });

    // --- Compute Aggregates for bottom TOTAL row ---
    const totalAggregates = {};
    visibleColumns.forEach(col => {
        const colValues = data.rows.map(r => parseFloat(r[col.key])).filter(v => !isNaN(v));
        if (!colValues.length) return;
        totalAggregates[col.key] = colValues.reduce((a, b) => a + b, 0); // sum of all numeric columns
    });

    // --- Draw Data Rows ---
    const totalWidth = visibleColumns.reduce((acc, c) => acc + (c.width || 100), 0);
    const tableWidth = Math.max(width, totalWidth);
    const headerY = y + TITLE_HEIGHT;
    const startRow = currentPage * ROWS_PER_PAGE;
    const endRow = Math.min(startRow + ROWS_PER_PAGE, data.rows.length);
    const visibleRows = data.rows.slice(startRow, endRow);

    ctx.font = `${FONT_SIZE}px Inter`;
    visibleRows.forEach((row, rowIndex) => {
    const rowY = headerY + HEADER_HEIGHT + rowIndex * ROW_HEIGHT;
    ctx.fillStyle = rowIndex % 2 === 0 ? "#1F2937" : "#374151";
    ctx.fillRect(x, rowY, tableWidth, ROW_HEIGHT);

    let cellX = x;
    visibleColumns.forEach(col => {
        const key = col.key;
        let cellValue = row[key] ?? ""; // Use already-aggregated value from groupAndAggregateRows
        const absoluteRowIndex = startRow + rowIndex;
        const textColor = formattedCells[`${absoluteRowIndex}:${key}`] || "#D1D5DB";
        ctx.fillStyle = textColor;
        ctx.textAlign = "right";
        ctx.fillText(String(cellValue), cellX + col.width - PADDING, rowY + ROW_HEIGHT / 2);
        cellX += col.width;

        ctx.beginPath();
        ctx.moveTo(cellX, rowY);
        ctx.lineTo(cellX, rowY + ROW_HEIGHT);
        ctx.stroke();
    });
});

    // --- Bottom TOTAL Row ---
    let aggregateRowY = headerY + HEADER_HEIGHT + visibleRows.length * ROW_HEIGHT;
    ctx.fillStyle = '#4F46E5';
    ctx.fillRect(x, aggregateRowY, tableWidth, ROW_HEIGHT);
    ctx.font = `bold ${FONT_SIZE}px Inter`;
    ctx.fillStyle = '#FFFFFF';

    let aggCellX = x;
    visibleColumns.forEach((col, colIndex) => {
        const cellValue = totalAggregates[col.key] ?? '';
        if (colIndex === 0) {
            ctx.textAlign = 'left';
            ctx.fillText('TOTAL (All Pages)', aggCellX + PADDING, aggregateRowY + ROW_HEIGHT / 2);
            ctx.textAlign = 'right';
            ctx.fillText(cellValue, aggCellX + col.width - PADDING, aggregateRowY + ROW_HEIGHT / 2);
        } else {
            ctx.textAlign = 'right';
            ctx.fillText(String(cellValue), aggCellX + col.width - PADDING, aggregateRowY + ROW_HEIGHT / 2);
        }
        aggCellX += col.width;
        if (colIndex < visibleColumns.length - 1) {
            ctx.beginPath();
            ctx.moveTo(aggCellX, aggregateRowY);
            ctx.lineTo(aggCellX, aggregateRowY + ROW_HEIGHT);
            ctx.stroke();
        }
    });

    // --- Pagination ---
    const paginationRowY = aggregateRowY + ROW_HEIGHT;
    ctx.fillStyle = '#4B5563';
    ctx.fillRect(x, paginationRowY, tableWidth, ROW_HEIGHT);
    if (totalPages > 1) {
       ctx.textAlign = 'center';
            ctx.fillStyle = '#FFFFFF';
            ctx.font = `${FONT_SIZE}px Inter`;
            const pageText = `Page ${currentPage + 1} of ${totalPages}`;
            ctx.fillText(pageText, x + tableWidth / 2, paginationRowY + ROW_HEIGHT / 2);

            const prevButtonX = x + PADDING;
            const nextButtonX = x + width - PADDING - 30;

            ctx.fillStyle = currentPage > 0 ? '#6B7280' : '#374151';
            ctx.fillRect(prevButtonX, paginationRowY, 30, ROW_HEIGHT);
            ctx.fillStyle = '#FFFFFF';
            ctx.fillText('<', prevButtonX + 15, paginationRowY + ROW_HEIGHT / 2);

            ctx.fillStyle = currentPage < totalPages - 1 ? '#6B7280' : '#374151';
            ctx.fillRect(x + tableWidth - PADDING - 30 + 15, paginationRowY, 30, ROW_HEIGHT);
            ctx.fillStyle = '#FFFFFF';
            ctx.fillText('>', nextButtonX + 15, paginationRowY + ROW_HEIGHT / 2);
    }
}








            
            
            loadHotelList();
            
            // --- Event Handlers (Using DIVs) ---
            addReportBtn.addEventListener('click', openAddModal);
            cancelBtn.addEventListener('click', hideModal);
			deleteBtn.addEventListener('click', deleteReport);

            modal.addEventListener('click', (e) => {
                if(e.target === modal) hideModal();
            });



let l_new_create = 10;
            saveBtn.addEventListener('click', () => {
                            l_new_create = -1;
						const name = reportNameInput.value.trim();
						const dataStr = reportDataInput.value.trim();
                        console.log('dataStr:>>>>>',dataStr);
                           if (reportId) {
                                loadReportDataForCanvas(reportId, editingReportIndex);
                            } else {
                                alert('Report ID not found. Please select a valid report.');
                            }
                     

						// --- NEW VALIDATION LOGIC FOR UNIQUE NAME ---
						const isDuplicate = reports.some((report, index) => {
							// If we are in EDIT mode, we skip the report currently being edited
							// as it's allowed to keep its own name.
							if (editingReportIndex !== -1 && index === editingReportIndex) {
								return false; 
							}
							// Check for a case-insensitive match against other reports
							return report.name.trim().toLowerCase() === name.toLowerCase();
						});

						if (isDuplicate) {
							alert(`A report named "${name}" already exists. Please choose a unique name.`);
							// Optional: Highlight the input field for better UX
							reportNameInput.focus();
							reportNameInput.classList.add('border-red-500', 'ring-red-500');
							setTimeout(() => {
								reportNameInput.classList.remove('border-red-500', 'ring-red-500');
							}, 3000);
							return;
						}
						hideModal(); 
					});

            canvas.addEventListener('wheel', (e) => {
                e.preventDefault();
                const rect = canvas.getBoundingClientRect();
                const mouseX = e.clientX - rect.left;
                const mouseY = e.clientY - rect.top;

                const zoomFactor = 1.1;
                const oldScale = scale;

                if (e.deltaY < 0) { 
                    scale *= zoomFactor;
                } else { 
                    scale /= zoomFactor;
                }
                
                scale = Math.max(0.1, Math.min(scale, 5)); 

                pan.x = mouseX - (mouseX - pan.x) * (scale / oldScale);
                pan.y = mouseY - (mouseY - pan.y) * (scale / oldScale);
                
                draw();
            });

            canvas.addEventListener('mousedown', (e) => {
                const pos = getCanvasCoords(e);
                lastMouse = { x: e.clientX, y: e.clientY };
                
                // 1. Check for TITLE click (Edit Report)

                    const clickedReport = reports.find(r => {
                        return (
                            pos.x >= r.x &&
                            pos.x <= r.x + r.width &&
                            pos.y >= r.y &&
                            pos.y <= r.y + TITLE_HEIGHT
                        );
                    });

                    if (clickedReport) {
                        const index = reports.findIndex(r => r.id === clickedReport.id);
                        console.log("Clicked header for:", clickedReport.name, "at index:", index);
                        openEditModal(index);
                        return;
                    }


                // 2. Check for pagination clicks (FIXED LOGIC)
                for (const report of reports) {
                    if (report.totalPages > 1) {
                        
                        // Calculate the current visual extent of the table data/footer
                        const startRow = report.currentPage * ROWS_PER_PAGE;
                        const visibleRowsLength = Math.min(ROWS_PER_PAGE, report.data.rows.length - startRow);

                        // Total height above the pagination row: Title + Header + Visible Rows + Aggregate Row
                        const contentHeightAbovePagination = TITLE_HEIGHT + HEADER_HEIGHT + (visibleRowsLength * ROW_HEIGHT) + ROW_HEIGHT;
                        
                        const paginationY = report.y + contentHeightAbovePagination;

                        // Calculate button rectangles in canvas coordinates
                        const prevBtnRect = { x: report.x + PADDING, y: paginationY, width: 30, height: ROW_HEIGHT };
                        const nextBtnRect = { x: report.x + report.width - PADDING - 30, y: paginationY, width: 30, height: ROW_HEIGHT };

                        // Check Prev Button
                        if (pos.x >= prevBtnRect.x && pos.x <= prevBtnRect.x + prevBtnRect.width && pos.y >= prevBtnRect.y && pos.y <= prevBtnRect.y + prevBtnRect.height) {
                            if (report.currentPage > 0) {
                                report.currentPage--;
                                draw();
                                return; 
                            }
                        }
                        // Check Next Button
                        if (pos.x >= nextBtnRect.x && pos.x <= nextBtnRect.x + nextBtnRect.width && pos.y >= nextBtnRect.y && pos.y <= nextBtnRect.y + nextBtnRect.height) {
                           if (report.currentPage < report.totalPages - 1) {
                                report.currentPage++;
                                draw();
                                return;
                            }
                        }
                    }
                }
                
                // 3. Check if dragging a table
                draggedTableIndex = reports.findIndex(r => pos.x >= r.x && pos.x <= r.x + r.width && pos.y >= r.y && pos.y <= r.y + r.height);
                if (draggedTableIndex !== -1) {
                    isDraggingTable = true;
                    dragOffset.x = pos.x - reports[draggedTableIndex].x;
                    dragOffset.y = pos.y - reports[draggedTableIndex].y;
                    return;
                }

                // If not doing anything else, start panning
                isPanning = true;
            });

            canvas.addEventListener('mousemove', (e) => {
                if (isPanning) {
                    const dx = e.clientX - lastMouse.x;
                    const dy = e.clientY - lastMouse.y;
                    pan.x += dx;
                    pan.y += dy;
                    lastMouse = { x: e.clientX, y: e.clientY };
                    draw();
                } else if (isDraggingTable) {
                    const pos = getCanvasCoords(e);
                    reports[draggedTableIndex].x = pos.x - dragOffset.x;
                    reports[draggedTableIndex].y = pos.y - dragOffset.y;
                    draw();
                }
            });

            canvas.addEventListener('mouseup', () => {
                isPanning = false;
                if (isDraggingTable) {
                    saveReports(); 
                    isDraggingTable = false;
                    draggedTableIndex = -1;
                }
            });

            canvas.addEventListener('mouseleave', () => {
                isPanning = false;
                isDraggingTable = false;
                draggedTableIndex = -1;
            });

            // --- Initial Load ---
            window.addEventListener('resize', resizeCanvas);
            
            // ** PAGELOAD METHOD **
            // const savedData = [
            //     {
            //         "name": "Initial Load Report",
            //         "x": 50,
            //         "y": 50,
            //         "currentPage": 0,
            //         "data": sampleData
            //     }
            // ];
            
           // loadReports(savedData); // Load reports on page load
            resizeCanvas();