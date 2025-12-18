  // ====================================================================
        // MOCKED DATABASE RESPONSE
        // ====================================================================
        const MOCKED_DATABASE_RESPONSE = [ ];

        // ====================================================================
        // GLOBAL STATE
        // ====================================================================
        let configRows = 2;
        let configCols = 5;
        let tableData = new Array(100).fill(null);
        let currentModalIndex = -1;

        // DOM Elements
        const mainGrid = document.getElementById('mainGrid');
        const dataModal = document.getElementById('dataModal');
        const jsonInput = document.getElementById('jsonInput');
        const messageBox = document.getElementById('messageBox');
        const tableNameInput = document.getElementById('tableNameInput');
        const inputRows = document.getElementById('inputRows');
        const inputCols = document.getElementById('inputCols');
        
        // Buttons (Now Divs)
        const updateGridBtn = document.getElementById('updateGridBtn');
        const saveGlobalLayoutBtn = document.getElementById('saveGlobalLayoutBtn');
        const addSampleDataBtn = document.getElementById('addSampleData');
        const fillAllCellsBtn = document.getElementById('fillAllCells');
        const closeModalBtn = document.getElementById('closeModalBtn');
        const processJsonBtn = document.getElementById('processJsonBtn');
        const deleteTableBtn = document.getElementById('deleteTableBtn');
        const saveTableBtn = document.getElementById('saveTableBtn');

        const refreshBtn = document.getElementById('refreshBtn');

        // Theme Logic
          const themeToggle = document.getElementById('themeToggle');
    const sunIcon = document.getElementById('sunIcon');
    const moonIcon = document.getElementById('moonIcon');

    function toggleTheme() {        
        document.documentElement.classList.toggle('dark');

        const isDark = document.documentElement.classList.contains('dark');

        if (isDark) {
            sunIcon.classList.add('hidden');
            moonIcon.classList.remove('hidden');
        } else {
            sunIcon.classList.remove('hidden');
            moonIcon.classList.add('hidden');
        }
        
    }


    // Function to hide empty cards
function hideEmptyCards() {
    const allCards = document.querySelectorAll('.table-cardsData');
    console.log('hideEmptyCards:>>>>>>',allCards);
    allCards.forEach(card => {
        // Check if the card has the "Add" button (which indicates empty card)
        const hasAddButton = card.querySelector('.add-table-btn');
        
        if (hasAddButton) {
            // This is an empty card - hide it
            card.style.display = 'none';
        } else {
            // This card has data - ensure it's visible
            card.style.display = 'flex'; // or 'block' depending on your layout
        }
    });
    document.querySelectorAll('.adminheader').forEach(el => el.style.display = 'none');

}

// Function to show all cards (if you need a toggle)
function showAllCards() {
    const allCards = document.querySelectorAll('.table-cardsData');
    allCards.forEach(card => {
        card.style.display = 'flex'; // or 'block'
    });
    document.querySelectorAll('.adminheader').forEach(el => el.style.display = 'flex');
}
 
document.getElementById('toggleEmptyCardsBtn').addEventListener('click', toggleEmptyCards);

let emptyCardsHidden = false;

function toggleEmptyCards() {
    const allCards = document.querySelectorAll('.table-cardsData');
    
    if (emptyCardsHidden) {
        showAllCards();
        emptyCardsHidden = false;
    } else {
        hideEmptyCards();
        emptyCardsHidden = true;
    }
}



    themeToggle.addEventListener('click', toggleTheme);

        function showMessage(text, type = 'success') {
            let bgColor = type === 'success' ? 'bg-green-500' : (type === 'error' ? 'bg-red-500' : 'bg-yellow-500');
            messageBox.textContent = text;
            messageBox.className = `fixed bottom-4 right-4 p-3 rounded-lg shadow-xl text-white font-medium ${bgColor} transition-opacity duration-300`;
            messageBox.classList.remove('hidden');
            setTimeout(() => { messageBox.classList.add('opacity-0'); setTimeout(() => { messageBox.classList.add('hidden', 'opacity-0'); }, 300); }, 3000);
        }

        function getCardWidthClass(columnCount) {
            if (!columnCount || columnCount < 2) return 'card-min';
            if (columnCount === 2) return 'card-2-col';
            if (columnCount === 3) return 'card-3-col';
            if (columnCount === 4) return 'card-4-col';
            if (columnCount === 5) return 'card-5-col';
            if (columnCount === 6) return 'card-6-col';
            if (columnCount === 7) return 'card-7-col';
            if (columnCount === 8) return 'card-8-col';
            return 'card-large';
        }

        // ====================================================================
        // PAGE LOAD LOGIC
        // ====================================================================
 

function call_dashboard_data(selectedHotel_Id){
  
apex.server.process(
            'AJX_MANAGE_REPORT_DASHBOARD', 
            {
                x01: 'SELECT_SUMMARY',
                x02:  selectedHotel_Id
            },
            {
                success: function(pData) {
                    try{
                    console.log('AJX_MANAGE_REPORT_DASHBOARD call successful!', pData);
                    const payloadString = pData[0].l_payload;
                    // Parse the inner JSON string
                    const payloadData = JSON.parse(payloadString);
                    console.log("Parsed payload:", payloadData);
                     tableData = new Array(100).fill(null);
                         updateGridDimensions();
                    payloadData.forEach(item => {
                        
                        if (item.reportvalue) {
                        console.log('item.position:>>>>>>>>>',item.position); 
                           loadReportDataForCanvas(item.reportvalue ,item.position,item.reportName);
                           //saveGlobalLayout();
                        } 
                        
                    });   
                  
                    }
                    catch{
                        tableData = new Array(100).fill(null);
                         updateGridDimensions();
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    tableData = new Array(100).fill(null);
                     updateGridDimensions();
                    console.error("AJAX Error: " + textStatus + " - " + errorThrown);
                   
                }
            }
        );
}

let tabledata_val =[];
 
 
 function applyAliasToTableDataArray(tableDataArray) {

    tableDataArray.forEach((tableData, idx) => {

        // Skip if element is null or not an object
        if (!tableData || typeof tableData !== "object") {
            //console.warn(`Skipping index ${idx}: not valid tableData`, tableData);
            return;
        }

        const exp = tableData.expressionJson;
        if (!exp || !exp.columnConfiguration || !exp.columnConfiguration.selectedColumns) {
           // console.warn(`Skipping index ${idx}: missing expressionJson`, tableData);
            return;
        }

        const selectedCols = exp.columnConfiguration.selectedColumns;

        // Build alias map "RN6 - Taj Test 1" → "RN6"
        const aliasMap = {};
        selectedCols.forEach(col => {
            const fullName = `${col.col_name} - ${col.temp_name}`;
            aliasMap[fullName] = col.alias_name;
        });

       // console.log(`aliasMap for index ${idx}:`, aliasMap);

        // Validate rows structure
        if (!tableData.rows || !tableData.rows.rows || !Array.isArray(tableData.rows.rows)) {
            console.warn(`Skipping index ${idx}: invalid rows structure`, tableData);
            return;
        }

        // Replace keys inside the rows
        tableData.rows.rows = tableData.rows.rows.map(row => {
            const newRow = {};

            Object.keys(row).forEach(key => {
                const newKey = aliasMap[key] || key;
                newRow[newKey] = row[key];
            });

            return newRow;
        });

    }); // end forEach
}



function loadReportDataForCanvas(reportId, position_temp, reportName_temp) {
    console.log('Loading report data for reportId:', reportId);

    apex.server.process(
        "AJX_GET_REPORT_HOTEL",
        { 
            x01: 'REPORT_DETAIL',
            x02: reportId           
        },
        {
            dataType: "json",
            success: function(data) {
               // console.log('data:>>>>>>>>>>>>>>>',data);
                if (!data || data.length === 0) return;

                let reportCol, db_ob_name, col_alias;
                 let expressionJson;
                data.forEach(function(report) {
                    reportCol = report.DEFINITION_JSON; 
                    db_ob_name = report.DB_OBJECT_NAME;
                    col_alias = report.COLUMN_ALIAS;
                    expressionJson = report.EXPRESSIONS_CLOB;
                });
                
                const reportColObj = JSON.parse(reportCol);
                let aliasList  = [];
                
                var columns_list = reportColObj.selectedColumns.map(item => ({
                    name: `${item.col_name} - ${item.temp_name}`,
                    col_name: `${item.col_name}`,
                    type: item.data_type
                        ? item.data_type.toLowerCase() === 'number' ? 'number'
                        : item.data_type.toLowerCase() === 'date' ? 'date'
                        : 'string'
                        : 'number'
                }));
                
              columns_list.forEach(function(col) {
                    aliasList.push({
                        key: col.col_name,    // Using col_name for key
                        name: col.col_name    // Using same col_name for name
                    });
                });
                 
                  

                apex.server.process(
                    "AJX_GET_REPORT_DATA",
                    { 
                        x01: JSON.stringify(columns_list),
                        x02: col_alias,
                        x03: db_ob_name
                    },
                    {
                        success: function(pData) {
                            //console.log('pData:>>>>>>>>>',pData);
                           
                                                        const colAliasObj = JSON.parse(col_alias);
                                    const dataForCanvas = { rows: pData.rows };
                            tabledata_val.push({
                                position: position_temp,
                                reportName: reportName_temp,
                                columnConfig: aliasList
                            });
                             tableData[position_temp] = {
                                                title: reportName_temp,
                                                reportvalue: reportId,
                                                columns: aliasList,
                                                rows: pData,
                                                expressionJson: JSON.parse(expressionJson)
                                            };

                               // console.log('before renderGrid:>>>>tableData :> ',tableData);
                                
                               applyAliasToTableDataArray(tableData);

                           // console.log("after alias replace >>>", tableData);

                                renderGrid(expressionJson,position_temp); 
                              
                                    // ✅ Always use the name the user entered in the modal
                                    // const reportName = reportNameInput.value.trim() || colAliasObj.hotel || `Report_${Date.now()}`;

                                    
                                    // const newReport = processReportData(reportName, dataForCanvas);

                                    // newReport.id = newReport.id || crypto.randomUUID();

                                    // if (updateIndex !== -1 && reports[updateIndex]) {
                                    //     // ✅ Update existing report (keep its position & pagination)
                                    //     const old = reports[updateIndex];
                                    //     newReport.id = old.id; // ✅ Preserve the same unique ID
                                    //     newReport.x = old.x;
                                    //     newReport.y = old.y;
                                    //     newReport.reportId = old.reportId;
                                    //     newReport.currentPage = old.currentPage;

                                    //     // Replace the single element safely
                                    //     reports.splice(updateIndex, 1, newReport);
                                    //     console.log('reports:>>>>>>',reports);
                                    //     console.log(`Updated existing report: ${reportName}`);
                                    // } else {


                                    //     // ✅ Add new report

                                    //     if (l_new_create > 0){
                                    //   //  newReport.x = reports.length > 0 ? reports[reports.length - 1].x + reports[reports.length - 1].width + 20 : 50;
                                    //  //   newReport.y = 50;
                                    //     newReport.x = posX;
                                    //     newReport.y = posY;
                                    //     newReport.reportId = reportId;
                                    //     reports.push(newReport);
                                    //     console.log('reports:>>>>>>',reports);
                                    //     console.log(`Added new report: ${reportName}`);
                                    //     }else{

                                    //         const rect = canvas.getBoundingClientRect();
                                    //         const centerX = (rect.width / 2 - pan.x) / scale;
                                    //         const centerY = (rect.height / 2 - pan.y) / scale;

                                    //         newReport.x = centerX - (newReport.width || 300) / 2;
                                    //         newReport.y = centerY - (newReport.height || 200) / 2;
                                    //         newReport.reportId = reportId;

                                    //         reports.push(newReport);
                                    //         console.log(`Added new report: ${reportName} at`, newReport.x, newReport.y);
                                    //         l_new_create = 10;
                                    //     }
                                    // }

                                    // hideModal(); // close only after update is done
                                    // draw();
                                    // saveReports();
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



        function initDashboardWithConfig() {
            console.log("Initializing Dashboard with Mock Config...");
            call_dashboard_data (document.getElementById('P0_HOTEL_ID').value);
            let maxPos = 0;
            // MOCKED_DATABASE_RESPONSE.forEach(item => {
            //     if (item.position > maxPos) maxPos = item.position;
            // });

            // if (maxPos >= (configRows * configCols)) {
            //     configRows = Math.ceil((maxPos + 1) / configCols);
            //     inputRows.value = configRows;
            //     console.log(`Expanded grid to ${configRows} rows to fit content.`);
            // }

            // MOCKED_DATABASE_RESPONSE.forEach(config => {
            //     let dummyRow = {};
            //     config.columnConfig.forEach(col => {
            //         dummyRow[col.key] = "Sample Data";
            //     });

            //     tableData[config.position] = {
            //         title: config.reportName,
            //         columns: config.columnConfig,
            //         rows: [dummyRow] 
            //     };
            // });

          //  renderGrid();
            showMessage("Dashboard loaded from Saved Configuration", "success");
        }

        // ====================================================================
        // RENDER LOGIC
        // ====================================================================

        function updateGridDimensions() {
            const r = parseInt(inputRows.value);
            const c = parseInt(inputCols.value);
            if(r > 0 && c > 0) { configRows = r; configCols = c; renderGrid(); showMessage(`Grid updated to ${configRows}x${configCols}`, 'success'); }
        }

        function renderGrid() {
            mainGrid.innerHTML = '';
            for (let r = 0; r < configRows; r++) {
                const rowDiv = document.createElement('div');
                rowDiv.className = 'dashboard-row';
                for (let c = 0; c < configCols; c++) {
                    const index = (r * configCols) + c;
                   
                    if (index >= tableData.length) tableData.push(null);
                    const data = tableData[index];
                     
                    const card = createCard(index, data);
                    
                    rowDiv.appendChild(card);
                    
                }
                mainGrid.appendChild(rowDiv);
            }
            initDragAndDrop();
            saveGlobalLayout();
            if(userType === 'P'){ 
                  showAllCards();   
                  const toggleEmptyCardsBtn = document.getElementById('toggleEmptyCardsBtn'); 
                    toggleEmptyCardsBtn.style.display = 'inline-flex';
            }
            else{
                hideEmptyCards(); 
                const toggleEmptyCardsBtn = document.getElementById('toggleEmptyCardsBtn'); 
             toggleEmptyCardsBtn.style.display = 'none';
            }

            
        }

       
   
function replaceDayNameFunction(expr) {
    if (!expr || typeof expr !== "string") return expr;

    return expr.replace(/Day\s*\(\s*([^)]+?)\s*\)/gi,
        "(['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][ new Date($1).getDay() ])"
    );
}



function getDateFromISOWeek(wStr) {
    if (!wStr || typeof wStr !== 'string') return null;
    const match = wStr.match(/(\d{4})-W(\d{2})/i);
    if (!match) return null;

    const year = parseInt(match[1], 10);
    const week = parseInt(match[2], 10);
    
    const date = new Date(year, 0, 4);
    let day = date.getDay(); 
    day = (day === 0) ? 7 : day; 

    date.setDate(date.getDate() - (day - 1));
    date.setDate(date.getDate() + (week - 1) * 7);

    return date;
}


function createCard(index, data) {
   // console.log('data:>>>>', data);
    let expressionJson = data?.expressionJson;
    const card = document.createElement('div');

    // Helper functions for date manipulation
    function parseDate(dateStr) {
        const months = {
            'JAN': 0, 'FEB': 1, 'MAR': 2, 'APR': 3, 'MAY': 4, 'JUN': 5,
            'JUL': 6, 'AUG': 7, 'SEP': 8, 'OCT': 9, 'NOV': 10, 'DEC': 11
        };
        
        const parts = dateStr.split('-');
        if (parts.length === 3) {
            const day = parseInt(parts[0], 10);
            const month = months[parts[1].toUpperCase()];
            const year = parseInt(parts[2], 10);
            return new Date(year, month, day);
        }
        return null;
    }

    function formatDate(date) {
        const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 
                       'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
        const day = date.getDate().toString().padStart(2, '0');
        const month = months[date.getMonth()];
        const year = date.getFullYear();
        return `${day}-${month}-${year}`;
    }

    function addDays(dateStr, days) {
        const date = parseDate(dateStr);
        if (!date) return dateStr;
        date.setDate(date.getDate() + days);
        return formatDate(date);
    }

    // Store original data for lookup
    const originalData = data?.rows?.rows || [];

    // Helper function to find value in originalData by PK_COL and column name
    function findValueInOriginalData(pkColDate, columnName) {
        // Clean the column name - remove any {n} suffix
        const cleanColumnName = columnName.replace(/\{\d+\}$/, '');
        
        // Look for the row in originalData
        const foundRow = originalData.find(row => row.PK_COL === pkColDate || row.SDATE === pkColDate);
        if (foundRow) {
            return foundRow[cleanColumnName] || null;
        }
        return null;
    }

    // 1. Initialize Data
    let rowsArray = data?.rows?.rows ? JSON.parse(JSON.stringify(data.rows.rows)) : (data?.rows || []);
    let columns = data ? JSON.parse(JSON.stringify(data.columns)) : [];

    // Initialize Expression JSON
    if (typeof expressionJson === "string") {
        try {
            expressionJson = JSON.parse(expressionJson);
        } catch (err) {
            console.warn("Invalid expressionJson", err);
            expressionJson = {};
        }
    }
    expressionJson = expressionJson || {};
    //console.log('createCard data:>>>>>>>>>>>', data);
    
    // 2. Map "Col Names" and "Long Names" to "Alias"
    const nameToAliasMap = {};
    const selectedColumns = expressionJson?.columnConfiguration?.selectedColumns || [];

    selectedColumns.forEach(col => {
        const longName = `${col.col_name} - ${col.temp_name}`;
        nameToAliasMap[longName] = col.alias_name;
        nameToAliasMap[col.col_name] = col.alias_name;
    });

    // 3. Create dataTypeMap and aggregationMap from selectedColumns
    const dataTypeMap = {};
    const aggregationMap = {};
    const visibilityMap = {};
    const tempNameMap = {}; // Track temp_name for each column

    // Build maps
    selectedColumns.forEach(col => {
        dataTypeMap[col.alias_name] = col.data_type;
        aggregationMap[col.alias_name] = col.aggregation;

        // Default visibility: show
        visibilityMap[col.alias_name] = col.visibility ?? 'show';

        tempNameMap[col.alias_name] = col.temp_name;
    });

    // Filter columns (hide only when explicitly hidden)
    columns = columns.filter(col => {
        const dbName = col.name || col.key;
        const alias = nameToAliasMap[dbName] || dbName;
        return visibilityMap[alias] !== 'hide';
    });

    // ==========================================================================================
    // 4. Process Formulas (FIRST - before grouping)
    // ==========================================================================================
    const formulas = expressionJson?.formulas || {};
    const formulaKeys = Object.keys(formulas);

    if (formulaKeys.length > 0) {
        // Sort tokens by length (longest first) to avoid partial replacements
        const tokensToReplace = Object.keys(nameToAliasMap).sort((a, b) => b.length - a.length);

        // Add Formula Columns to Header if missing
        formulaKeys.forEach(fColKey => {
            const exists = columns.some(c => c.name === fColKey || c.key === fColKey);
            if (!exists) {
                const config = selectedColumns.find(sc => sc.alias_name === fColKey || sc.col_name === fColKey);
                const isVisible = config ? config.visibility === 'show' : true;
                if (isVisible) {
                    columns.push({
                        key: fColKey,
                        name: fColKey,
                        type: formulas[fColKey]?.type || 'number'
                    });
                    // Add to our maps for formula columns
                    dataTypeMap[fColKey] = formulas[fColKey]?.type || 'number';
                    aggregationMap[fColKey] = 'sum'; // Default to sum
                    visibilityMap[fColKey] = 'show';
                    tempNameMap[fColKey] = 'calc'; // Mark as formula column
                }
            }
        });

        // Calculate formulas on the original data
        rowsArray.forEach(row => {
            formulaKeys.forEach(fColKey => {
                const formulaObj = formulas[fColKey];
                
                // Get Formula & Filter Strings
                let expr = typeof formulaObj === 'object' ? formulaObj.formula : formulaObj;
                let filterExpr = typeof formulaObj === 'object' ? formulaObj.filter : null;

                if (!expr) return;

                // ---------------------------------------------------------
                // STEP A: EVALUATE FILTER (on the original row)
                // ---------------------------------------------------------
                let filterPassed = true; // Default to true if no filter exists

                if (filterExpr) {
                    // --- Pattern 1: DAY_OF_WEEK Filter ---
                    const dayOfWeekMatch = filterExpr.match(/\[(.*?)\]\s*DAY_OF_WEEK\s*\((.*?)\)/i);
                    
                    // --- Pattern 2a: DATE_RANGE Filter ---
                    const dateRangeMatch = filterExpr.match(/\[(.*?)\]\s*DATE_RANGE\s*\((.*?)\)/i);

                    // --- Pattern 2b: BETWEEN Filter ---
                    const betweenMatch = filterExpr.match(/\[(.*?)\]\s*between\s*(.*?)\s*and\s*(.*?)$/i);

                    if (dayOfWeekMatch) {
                        const colLongName = dayOfWeekMatch[1].trim();
                        const allowedDaysStr = dayOfWeekMatch[2];
                        const dayMap = { 'sun': 0, 'mon': 1, 'tue': 2, 'wed': 3, 'thu': 4, 'fri': 5, 'sat': 6 };
                        const allowedIndices = allowedDaysStr.split(',')
                            .map(d => dayMap[d.trim().toLowerCase().substring(0, 3)])
                            .filter(d => d !== undefined);

                        const alias = nameToAliasMap[colLongName] || colLongName;
                        const dateVal = row[alias];

                        if (!dateVal) {
                            filterPassed = false;
                        } else {
                            const d = new Date(dateVal);
                            if (isNaN(d.getTime())) {
                                filterPassed = false; 
                            } else {
                                const currentDayIndex = d.getDay(); // 0-6
                                filterPassed = allowedIndices.includes(currentDayIndex);
                            }
                        }
                    } 
                    else if (dateRangeMatch || betweenMatch) {
                        let colLongName, startStr, endStr;

                        if (dateRangeMatch) {
                            colLongName = dateRangeMatch[1].trim();
                            const rangeStr = dateRangeMatch[2]; 
                            [startStr, endStr] = rangeStr.split(',').map(s => s.trim());
                        } else if (betweenMatch) {
                            colLongName = betweenMatch[1].trim();
                            startStr = betweenMatch[2].trim();
                            endStr = betweenMatch[3].trim();
                        }
                        
                        const alias = nameToAliasMap[colLongName] || colLongName;
                        const dateVal = row[alias];

                        if (!dateVal || !startStr || !endStr) {
                            filterPassed = false;
                        } else {
                            const d = new Date(dateVal);
                            const start = new Date(startStr);
                            const end = new Date(endStr);
                            
                            start.setHours(0, 0, 0, 0);
                            end.setHours(23, 59, 59, 999); 

                            if (isNaN(d.getTime()) || isNaN(start.getTime()) || isNaN(end.getTime())) {
                                filterPassed = false;
                            } else {
                                filterPassed = d.getTime() >= start.getTime() && d.getTime() <= end.getTime();
                            }
                        }
                    }
                    else {
                        let evalFilterExpr = filterExpr;
                        
                        tokensToReplace.forEach(token => {
                            if (evalFilterExpr.includes(token)) {
                                const alias = nameToAliasMap[token];
                                let val = row[alias];

                                if (val === undefined || val === null || val === ''){

                                 val = 'Calculation Issue'; return;
                                 }

                                else if (typeof val === 'string') {
                                    const num = parseFloat(val.replace(/,/g, ''));
                                    val = isNaN(num) ? 'Calculation Issue' : num;
                                }
                                evalFilterExpr = evalFilterExpr.split(token).join(val);
                            }
                        });

                        try {
                            if(!evalFilterExpr.includes("DAY_OF_WEEK") && !evalFilterExpr.includes("DATE_RANGE") && !evalFilterExpr.includes("between")) {
                                filterPassed = eval(evalFilterExpr);
                            } else {
                                filterPassed = false; 
                            }
                        } catch (err) {
                            console.warn("Numeric Filter Eval Error:", err.message, "Expression:", evalFilterExpr);
                            filterPassed = false;
                        }
                    }
                }
                
                // If Filter Failed -> Set NULL and STOP processing this formula
                if (!filterPassed) {
                    row[fColKey] = null;
                    return; 
                }

                // ---------------------------------------------------------
                // STEP B: CALCULATE FORMULA (Only if Filter Passed)
                // ---------------------------------------------------------
                
                // Replace tokens in the calculation expression
                 expr = typeof formulaObj === 'object' ? formulaObj.formula : formulaObj;

                // NEW: First remove template suffixes (like "- MCL LoS1") from the expression
                // This must be done BEFORE handling {1} functionality
                if (expressionJson?.columnConfiguration?.selectedColumns) {
                    expressionJson.columnConfiguration.selectedColumns.forEach(col => {
                        if (col.temp_name) {
                            // Target the full suffix string and the optional following operator.
                            const suffixPattern = new RegExp(`\\s*-\\s*${col.temp_name}\\s*(\\+|\\-|\\*|\\/)?`, 'gi');
                            
                            // Replace the entire pattern with just the operator (or nothing).
                            expr = expr.replace(suffixPattern, (match, operator) => {
                                return operator || '';
                            });
                        }
                    });
                }
                
                // CRITICAL CLEANUP: Ensure spaces are normalized
                expr = expr.replace(/\s+/g, ' ').trim();

                //console.log('After template removal expr:', expr);

                // ---------------------------------------------------------
                // FIX: Convert ORIGINAL COLUMN NAMES → ALIAS NAMES
                // BEFORE {1} logic runs
                // ---------------------------------------------------------
                if (expressionJson?.columnConfiguration?.selectedColumns) {
                    expressionJson.columnConfiguration.selectedColumns.forEach(col => {
                        const original = col.col_name;         // e.g. "MOXY_YORK"
                        const alias = col.alias_name;         // e.g. "MX_YK"

                        // Replace plain usage of original name
                        const regex1 = new RegExp(`\\b${original}\\b`, "g");

                        // Replace bracketed usage [MOXY_YORK]
                        const regex2 = new RegExp(`\\[${original}\\]`, "g");

                        expr = expr.replace(regex1, alias);
                        expr = expr.replace(regex2, alias);

                        // Also fix ORIGINAL{1} → ALIAS{1}
                        expr = expr.replace(new RegExp(`\\b${original}\\{`, "g"), `${alias}{`);
                    });
                }



                // Now handle {n} functionality for offset column references (supports both positive and negative offsets)
                // Find column references with {n} pattern (now should be just column names like "MOXY_YORK{1}" or "MOXY_YORK{-1}")
                const offsetColumnRegex = /(\[?[A-Za-z_][A-Za-z0-9_% ]*[A-Za-z0-9_%]\]?)\{(-?\d+)\}/g;
                let match;

                // Create a map to store offset column replacements
                const offsetReplacements = {};
                let hasOffsetError = false;

                while ((match = offsetColumnRegex.exec(expr)) !== null) {
                    const fullMatch = match[0];
                    const columnRef = match[1].replace(/[\[\]]/g, ''); // Remove brackets if present
                    const offset = parseInt(match[2], 10);

                    // Get current row's PK_COL date
                    const currentDate = row.PK_COL;

                    if (currentDate) {
                        // Calculate target date by adding offset
                        const targetDate = addDays(currentDate, offset);

                        // Find the value in originalData
                        const offsetValue = findValueInOriginalData(targetDate, columnRef);

                        if (offsetValue !== null) {
                            // Store the replacement value
                            offsetReplacements[fullMatch] = offsetValue;
                        } else {
                            // If not found, use null
                            offsetReplacements[fullMatch] = null;
                        }
                    } else {
                        offsetReplacements[fullMatch] = null;
                    }
                }

                // Replace all offset column references with their values
                Object.entries(offsetReplacements).forEach(([pattern, value]) => {
                    // Handle the value based on its type
                    let replacementValue;

                    if (value === null || value === undefined || value === '') {
                        // For missing values, use 0 for numeric operations instead of breaking entire formula
                        hasOffsetError = true;
                        replacementValue = 0;
                    } else if (!isNaN(value) && value !== null) {
                        // Convert numeric strings to actual numbers
                        replacementValue = parseFloat(value);
                    } else {
                        // For non-numeric values, use them as-is with quotes
                        replacementValue = `"${value}"`;
                    }

                    // Replace the pattern in the expression
                    expr = expr.replace(pattern, replacementValue);
                });

                // If all offset lookups failed, mark as Calculation Issue
                if (hasOffsetError && Object.keys(offsetReplacements).length > 0 &&
                    Object.values(offsetReplacements).every(v => v === null || v === undefined || v === '')) {
                    expr = 'Calculation Issue';
                }

               // console.log('After {1} replacement expr:', expr);

                // Now replace remaining column references (without {n})
                // Find all column references (should now only be alias names like 'MOXY_YORK')
                const columnMatches = expr.match(/\[(.*?)\]/g) || [];
                const simpleColumnMatches = expr.match(/\b[A-Z_][A-Z0-9_]*\b/gi) || [];

                const allColumnNames = [
                    ...columnMatches.map(match => match.replace(/[\[\]]/g, '')),
                    ...simpleColumnMatches.filter(word => !['AND', 'OR', 'NOT', 'Day', 'Date', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'].includes(word))
                ];
                const uniqueColumnNames = [...new Set(allColumnNames)];

                // Track if date arithmetic is involved
                let hasDateArithmetic = false;
                const formulaHasArithmetic = /[\+\-]/.test(expr);

                // Helper to parse date string to Date object
                function parseDateStr(dateStr) {
                    const months = { JAN:0,FEB:1,MAR:2,APR:3,MAY:4,JUN:5,JUL:6,AUG:7,SEP:8,OCT:9,NOV:10,DEC:11 };
                    const parts = dateStr.split('-');
                    if (parts.length === 3) return new Date(parseInt(parts[2],10), months[parts[1].toUpperCase()], parseInt(parts[0],10));
                    return null;
                }

                // Helper to format Date to DD-MON-YYYY
                function formatDateStr(date) {
                    const months = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
                    return `${date.getDate().toString().padStart(2,'0')}-${months[date.getMonth()]}-${date.getFullYear()}`;
                }

                // Safe replacements for numeric values
                uniqueColumnNames.forEach(col => {
                    // 'col' is the ALIAS (e.g., 'MOXY_YORK'), which is the row key.
                    let value = row[col]; // Direct lookup by alias/row key

                    if (dataTypeMap[col] === 'date' && value != null && value !== '') {
                        // Check if date column is used with arithmetic
                        if (formulaHasArithmetic) {
                            const dateObj = parseDateStr(value);
                            if (dateObj) {
                                value = dateObj.getTime();
                                hasDateArithmetic = true;
                            } else {
                                value = `"${value}"`;
                            }
                        } else {
                            value = `"${value}"`; // keep quotes for JS eval
                        }
                    } else if (!isNaN(value) && value !== '' && value !== null) {
                        value = parseFloat(value);
                    } else {
                        value = `"${value}"`; // fallback as string
                    }

                    // Replace both bracketed and unbracketed versions
                    expr = expr.replace(new RegExp(`\\[${col}\\]`, 'g'), value);
                    expr = expr.replace(new RegExp(`\\b${col}\\b`, 'g'), value);
                });

                // If date arithmetic is involved, convert day offsets to milliseconds
                if (hasDateArithmetic) {
                    expr = expr.replace(/(\d{10,})\s*([\+\-])\s*(\d+)(?!\d)/g, (match, timestamp, op, days) => {
                        const dayValue = parseInt(days, 10);
                        if (dayValue >= 1 && dayValue <= 365) {
                            return `${timestamp} ${op} (${dayValue} * 86400000)`;
                        }
                        return match;
                    });
                }

                //console.log('Final expr before eval:', expr);

                expr = replaceDayNameFunction(expr);

                try {
                    let result = eval(expr);

                    // If date arithmetic was involved, convert timestamp back to formatted date
                    if (hasDateArithmetic && typeof result === 'number' && result > 1e10) {
                        const d = new Date(result);
                        if (!isNaN(d.getTime())) {
                            result = formatDateStr(d);
                        }
                    }

                    // NAN CHECK: Force NaN to null
                    if (typeof result === 'number' && isNaN(result)) {
                        row[fColKey] = 'Calculation Issue';
                    } else {
                        // Round decimals
                        if (typeof result === 'number' && !Number.isInteger(result)) {
                            result = parseFloat(result.toFixed(2));
                        }
                        row[fColKey] = result;
                    }

                } catch (err) {
                    //console.error(`Error evaluating formula ${fColKey}: ${err.message}`);
                    row[fColKey] = 'Calculation Issue';
                }
            });
        });
    }

    // ==========================================================================================
    // 5. Process Filters (after formulas, before grouping)
    // ==========================================================================================
    const filters = expressionJson?.filters || {};
    const filterKeys = Object.keys(filters);

    
if (filterKeys.length > 0) {
    rowsArray = rowsArray.filter(row => {
        return filterKeys.every(filterKey => {
            let expr = filters[filterKey];
            if (!expr) return true;

            // --- 1. PREPARE FILTER EXPRESSION (UNCHANGED, but assuming user filters will use YYYY-W## or MM/DD/YYYY) ---
            expr = expr.replace(/'(\d{1,2}\/\d{1,2}\/\d{4})'/g, "new Date('$1')");
            expr = expr.replace(/'(\d{4}-W\d{2})'/gi, "getDateFromISOWeek('$1')");
            expr = expr.replace(/'(\d{1,2}\/\d{1,2}\/\d{4})'/g, (_, d) => {
            const date = new Date(d);
                    return !isNaN(date.getTime()) ? date.getTime() : 0;
                });

                // ISO Week YYYY-W## → timestamp
                expr = expr.replace(/'(\d{4}-W\d{2})'/gi, (_, w) => {
                    const date = getDateFromISOWeek(w);
                    return !isNaN(date.getTime()) ? date.getTime() : 0;
                });

                // DD-MON-YYYY → timestamp
                expr = expr.replace(/'(\d{1,2})-([A-Za-z]{3})-(\d{4})'/g, (_, dd, mon, yyyy) => {
                    const date = new Date(`${dd}-${mon}-${yyyy}`);
                    return !isNaN(date.getTime()) ? date.getTime() : 0;
                });
            // -------------------------------------------------------------------------------------------------------

            const matches = expr.match(/\[(.*?)\]/g) || [];

            matches.forEach(tokenWithBrackets => {
                const tokenLongName = tokenWithBrackets.replace(/[\[\]]/g, '');
                const tokenAlias = nameToAliasMap[tokenLongName] || tokenLongName;

                let val = row[tokenAlias];

                let substitutionValue;

                if (val === undefined || val === null) {
                    substitutionValue = 0;
                } else if (typeof val === 'string') {
                    const valStr = val.trim();

                    const dateObj = new Date(valStr);
                    if (!isNaN(dateObj.getTime())) {
                        substitutionValue = dateObj.getTime(); // ✅ timestamp
                    } else {
                        // fallback to numeric parsing
                        substitutionValue = parseFloat(valStr.replace(/,/g, '')) || 0;
                    }
                } else if (val instanceof Date) {
                    substitutionValue = val.getTime();
                } else if (typeof val === 'number') {
                    substitutionValue = val;
                } else {
                    substitutionValue = 0;
                }

                expr = expr.replace(tokenWithBrackets, substitutionValue);
            });


            try {
                return eval(expr);
            } catch (err) {
                console.warn(`Filter error: ${filterKey}`, err);
                return true;
            }
        });
    });
}

    // ==========================================================================================
    // 6. GROUP BY LOGIC (now after formulas and filters, before totals)
    // ==========================================================================================
    let groupedData = rowsArray;
    let groupByColumn = null;
    let groupByAlias = null;

    // Find the date column with aggregation (week, month, monthly, year, yearly, etc.)
    selectedColumns.forEach(col => {
        if (col.data_type?.toUpperCase() === 'DATE' && col.aggregation && col.aggregation !== 'none') {
            groupByColumn = col;
            groupByAlias = col.alias_name || col.col_name;
        }
    });

    // If we have a group by column, perform grouping
    if (groupByColumn && groupByAlias) {
        const groups = {};

        rowsArray.forEach(row => {
            const dateValue = row[groupByAlias];
            if (!dateValue) return;

            let groupKey;
            const date = new Date(dateValue);

            switch (groupByColumn.aggregation) {
            case 'week': {
                    const year = date.getFullYear();
                    
                    // 1. Get the first day of the year
                    const firstDayOfYear = new Date(year, 0, 1);
                    
                    // 2. Calculate the days between 'date' and 'Jan 1st'
                    // We add the first day's day-of-week to align the grid to Sunday
                    const pastDaysOfYear = (date - firstDayOfYear) / 86400000;
                    
                    // 3. Calculate week number: (Days passed + starting day offset) / 7
                    // This ensures every Sunday starts a new week count
                    const weekNumber = Math.floor((pastDaysOfYear + firstDayOfYear.getDay()) / 7) + 1;
                    
                    groupKey = `${year}-W${weekNumber.toString().padStart(2, '0')}`;
                    break;
                }
                case 'month':
               case 'monthly':
                    // Format: 'January-25' (Month name followed by last 2 digits of year)
                    const monthNames = [
                        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                    ];
                    const monthName = monthNames[date.getMonth()];
                    const shortYear = date.getFullYear().toString().slice(-2); // Get last 2 digits of year
                    groupKey = `${monthName}-${shortYear}`;
                    break;
                case 'year':
                case 'yearly':
                    // Format: '2025'
                    groupKey = date.getFullYear().toString();
                    break;
                case 'quarter':
                    // Format: '2025-Q1'
                    const quarter = Math.floor(date.getMonth() / 3) + 1;
                    groupKey = `${date.getFullYear()}-Q${quarter}`;
                    break;
                default:
                    groupKey = dateValue; // Use original date value
            }

            if (!groups[groupKey]) {
                groups[groupKey] = [];
            }
            groups[groupKey].push(row);
        });

        // Aggregate each group
        groupedData = Object.keys(groups).map(groupKey => {
            const groupRows = groups[groupKey];
            const aggregatedRow = {
                [groupByAlias]: groupKey
            }; // Set the grouped date value

            // For each column, apply aggregation based on data type and aggregation setting
            selectedColumns.forEach(col => {
    const alias = col.alias_name || col.col_name;

    if (alias === groupByAlias) return;
    if (col.visibility !== 'show') return;

    const dataType = col.data_type?.toUpperCase();
    const hasExplicitAggregation = col.aggregation && col.aggregation !== 'none';
    let aggregation = hasExplicitAggregation ? col.aggregation.toLowerCase() : null;

    if (dataType === 'NUMBER') {
        // NUMBER columns: Auto-sum if no explicit aggregation
        if (!aggregation) aggregation = 'sum';

        const values = groupRows.map(row => {
            let value = row[alias];
            if (value === undefined || value === null || value === '') return 0;

            if (typeof value === 'string') {
                // Ignore non-numeric characters
                value = parseFloat(value.replace(/[^0-9.-]/g, '')) || 0;
            }
            return typeof value === 'number' ? value : 0;
        }).filter(val => !isNaN(val));

        // Apply aggregation function
        switch (aggregation) {
            case 'sum':
                aggregatedRow[alias] = values.reduce((sum, val) => sum + val, 0);
                break;
            case 'avg':
                aggregatedRow[alias] = values.length > 0 ? values.reduce((sum, val) => sum + val, 0) / values.length : 0;
                break;
            case 'min':
                aggregatedRow[alias] = values.length > 0 ? Math.min(...values) : 0;
                break;
            case 'max':
                aggregatedRow[alias] = values.length > 0 ? Math.max(...values) : 0;
                break;
            case 'count':
            case 'cnt':
                aggregatedRow[alias] = values.length;
                break;
            default:
                // Fallback to sum if aggregation is unrecognized
                aggregatedRow[alias] = values.reduce((sum, val) => sum + val, 0);
        }

        if (typeof aggregatedRow[alias] === 'number' && !Number.isInteger(aggregatedRow[alias])) {
            aggregatedRow[alias] = parseFloat(aggregatedRow[alias].toFixed(2));
        }
    } else if (dataType === 'DATE') {
        // DATE columns: Show "Calculation Issue" unless explicit aggregation is set
        if (hasExplicitAggregation) {
            aggregatedRow[alias] = groupRows[0]?.[alias] || '';
        } else {
            aggregatedRow[alias] = 'Calculation Issue';
        }
    } else {
        // TEXT/STRING columns: Show "Calculation Issue" when grouping
        aggregatedRow[alias] = 'Calculation Issue';
    }
});

            return aggregatedRow;
        });

        // Sort grouped data by the group key (chronological order)
        groupedData.sort((a, b) => {
            return a[groupByAlias].localeCompare(b[groupByAlias]);
        });
    }

    // ==========================================================================================
    // 7. Calculate Column Totals - USING dataTypeMap to skip DATE columns
    // ==========================================================================================
    const columnTotals = {};
    const columnIsNumeric = {};

    columns.forEach(col => {
        const dbName = col.name || col.key;
        const alias = nameToAliasMap[dbName] || dbName;

        // Skip DATE columns using dataTypeMap
        if (dataTypeMap[alias]?.toUpperCase() === 'DATE') {
            columnTotals[alias] = null;
            columnIsNumeric[alias] = false;
            return; // Skip this column entirely
        }

        let total = 0;
        let hasNumericValues = false;
        let numericCount = 0;

        groupedData.forEach(row => {
            let value = row[alias] !== undefined ? row[alias] : (row[col.key] || null);

            // Skip null, undefined, empty strings, and non-numeric values
            if (value === null || value === undefined || value === '') {
                return;
            }

            // Convert to number if possible
            if (typeof value === 'string') {
                // Remove commas and try to parse
                const cleanValue = value.toString().replace(/,/g, '');
                const numericValue = parseFloat(cleanValue);

                if (!isNaN(numericValue) && isFinite(numericValue)) {
                    total += numericValue;
                    hasNumericValues = true;
                    numericCount++;
                }
            } else if (typeof value === 'number' && !isNaN(value) && isFinite(value)) {
                total += value;
                hasNumericValues = true;
                numericCount++;
            }
        });

        // Only set total if we found numeric values
        if (hasNumericValues && numericCount > 0) {
            // Format total to 2 decimal places if needed
            columnTotals[alias] = total % 1 === 0 ? total : parseFloat(total.toFixed(2));
            columnIsNumeric[alias] = true;
        } else {
            columnTotals[alias] = null;
            columnIsNumeric[alias] = false;
        }
    });

    // ==========================================================================================
    // 8. Process Conditional Formatting (on the final grouped data)
    // ==========================================================================================
    const conditionalRules = expressionJson?.conditionalFormatting || {};
const cellStyles = {};

Object.keys(conditionalRules).forEach(targetLongName => {
    const rules = conditionalRules[targetLongName];
    if (!Array.isArray(rules)) return;

    const targetAlias = nameToAliasMap[targetLongName] || targetLongName;

    rules.forEach(rule => {
        const { expression, color } = rule;
        if (!expression) return;

        groupedData.forEach((row, rowIndex) => {
            let exprToEval = String(expression);
            const matches = exprToEval.match(/\[(.*?)\]/g) || [];

            matches.forEach(tokenWithBrackets => {
                const tokenLongName = tokenWithBrackets.replace(/[\[\]]/g, '');
                const tokenAlias = nameToAliasMap[tokenLongName] || tokenLongName;
                let val = row[tokenAlias];

                let substitutionValue;

                if (val === undefined || val === null) {
                    substitutionValue = 0;
                } else if (typeof val === 'string') {
                    const valStr = val.trim();

                    // DD-MON-YYYY
                    if (/^\d{1,2}-[A-Za-z]{3}-\d{4}$/.test(valStr)) {
                        const d = new Date(valStr);
                        substitutionValue = !isNaN(d.getTime()) ? d.getTime() : 0;
                    }
                    // MM/DD/YYYY
                    else if (/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(valStr)) {
                        const d = new Date(valStr);
                        substitutionValue = !isNaN(d.getTime()) ? d.getTime() : 0;
                    }
                    // YYYY-W## (ISO Week)
                    else if (/^\d{4}-W\d{2}$/i.test(valStr)) {
                        const d = getDateFromISOWeek(valStr);
                        substitutionValue = !isNaN(d.getTime()) ? d.getTime() : 0;
                    }
                    // Numeric fallback
                    else {
                        substitutionValue = parseFloat(valStr.replace(/,/g, '')) || 0;
                    }
                } else if (val instanceof Date) {
                    substitutionValue = val.getTime();
                } else if (typeof val === 'number') {
                    substitutionValue = val;
                } else {
                    substitutionValue = 0;
                }

                exprToEval = exprToEval.replace(tokenWithBrackets, substitutionValue);
            });

            // --- Also convert date literals inside the rule itself ---
            exprToEval = exprToEval
                // DD-MON-YYYY
                .replace(/'(\d{1,2}-[A-Za-z]{3}-\d{4})'/g, (_, d) => {
                    const date = new Date(d);
                    return !isNaN(date.getTime()) ? date.getTime() : 0;
                })
                // MM/DD/YYYY
                .replace(/'(\d{1,2}\/\d{1,2}\/\d{4})'/g, (_, d) => {
                    const date = new Date(d);
                    return !isNaN(date.getTime()) ? date.getTime() : 0;
                })
                // ISO Week
                .replace(/'(\d{4}-W\d{2})'/gi, (_, w) => {
                    const date = getDateFromISOWeek(w);
                    return !isNaN(date.getTime()) ? date.getTime() : 0;
                });

            try {
                if (eval(exprToEval)) {
                    cellStyles[`${rowIndex}:${targetAlias}`] = `background-color: ${color}; color: #ffffff; font-weight: bold;`;
                }
            } catch (err) {
                console.warn('Conditional formatting eval error:', err, exprToEval);
            }
        });
    });
});


    // ==========================================================================================
    // 9. HTML Generation with Sticky Footer
    // ==========================================================================================
    const columnCount = columns.length;
    const widthClass = getCardWidthClass(columnCount);

    if (userType === 'P') {
        card.classList.add('table-cardsData', 'p-4', 'rounded-xl', 'flex', 'flex-col', 'transition-all', 'duration-300', 'hover:shadow-lg', 'draggable', 'relative', widthClass);
        card.setAttribute('data-index', index);
        card.setAttribute('draggable', true);
    } else {
        card.classList.add('table-cardsData', 'p-4', 'rounded-xl', 'flex', 'flex-col', 'transition-all', 'duration-300', 'hover:shadow-lg', 'relative', widthClass);
        card.setAttribute('data-index', index);
        card.setAttribute('draggable', false);
    }

    columns = reorderVisibleColumns(columns, expressionJson);
    // console.log('reorderVisibleColumns :>>> columns', columns); 
    // console.log('reorderVisibleColumns :>>> data', data);
    // console.log('reorderVisibleColumns :>>> groupedData', groupedData);

    // Sort grouped data by year, then by month (January to December)
    groupedData.sort((a, b) => {
        const aKey = a[groupByAlias];
        const bKey = b[groupByAlias];
        
        // Handle undefined/null keys
        if (!aKey && !bKey) return 0;
        if (!aKey) return -1;
        if (!bKey) return 1;
        
        const monthNames = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        
        const parseMonthYear = (str) => {
            // Ensure it's a string
            str = String(str);
            
            const parts = str.split('-');
            if (parts.length !== 2) return { year: 0, month: -1 };
            
            const monthName = parts[0];
            const shortYear = parts[1];
            
            // Find month index (0-11)
            const monthIndex = monthNames.findIndex(name => name === monthName);
            
            // Convert short year to full year
            let fullYear = parseInt(shortYear, 10);
            if (!isNaN(fullYear) && fullYear < 100) {
                // Simple logic: assume 20xx for years 00-99
                // You can adjust this based on your data range
                const currentYear = new Date().getFullYear();
                const currentCentury = Math.floor(currentYear / 100) * 100;
                fullYear += currentCentury;
                
                // If year is far in the future, adjust to previous century
                if (fullYear > currentYear + 10) {
                    fullYear -= 100;
                }
            }
            
            return { 
                year: isNaN(fullYear) ? 0 : fullYear, 
                month: monthIndex === -1 ? -1 : monthIndex 
            };
        };
        
        const aDate = parseMonthYear(aKey);
        const bDate = parseMonthYear(bKey);
        
        // First compare by year
        if (aDate.year !== bDate.year) {
            return aDate.year - bDate.year;
        }
        
        // If same year, compare by month
        return aDate.month - bDate.month;
    });

    if (data) {
        const displayTitle = data.title || `Table ${index + 1}`;
        card.classList.remove('justify-center', 'items-center');

        card.innerHTML = `
            <div class="card-content h-full flex flex-col">
                <div class="flex justify-between items-center mb-2">
                    <h3 class="text-lg font-bold truncate text-blue-600 dark:text-blue-400" title="${displayTitle}">${displayTitle}</h3>
                </div>
                <div class="flex-grow overflow-hidden flex flex-col">
                    <div class="table-container flex-grow overflow-auto custom-scrollbar"> 
                        <table class="preview-table text-xs text-left border-collapse w-full">
                            <thead class="sticky top-0 bg-gray-100 dark:bg-gray-700 z-10">
                                <tr>
                                    ${columns.map(col => `
                                        <th class="font-medium border-b dark:border-gray-600 px-4 py-2 whitespace-nowrap">
                                            ${nameToAliasMap[col.name || col.key] ? nameToAliasMap[col.name || col.key] : col.name}
                                        </th>
                                    `).join('')}
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-200 dark:divide-gray-700">
                                ${groupedData.map((row, rowIndex) => `
                                    <tr class="hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors">
                                        ${columns.map(col => {
                                            const dbName = col.name || col.key;
                                            const alias = nameToAliasMap[dbName] || dbName;
                                            
                                            // MODIFIED LINE: If value is null, return empty string (''), otherwise return value or '-'
                                            let cellValue = row[alias] !== undefined ? row[alias] : (row[col.key] || '-');
                                            if (cellValue === null) cellValue = '';
                                            const style = cellStyles[`${rowIndex}:${alias}`] || '';
                                            return `<td class="px-4 py-2 whitespace-nowrap" style="${style}">${cellValue}</td>`;
                                            }).join('')}
                                    </tr>
                                `).join('')}
                            </tbody>
                            <tfoot class="sticky bottom-0 bg-gray-100 dark:bg-gray-700 z-10">
                                <tr>
                                    ${columns.map(col => {
                                        const dbName = col.name || col.key;
                                        const alias = nameToAliasMap[dbName] || dbName;
                                        const total = columnTotals[alias];
                                        const isNumeric = columnIsNumeric[alias];
                                        
                                        // Only show total for numeric columns that have values
                                        if (isNumeric && total !== null) {
                                            return `
                                                <th class="font-medium border-t dark:border-gray-600 px-4 py-2 whitespace-nowrap text-right">
                                                    ${total}
                                                </th>
                                            `;
                                        } else {
                                            return `
                                                <th class="font-medium border-t dark:border-gray-600 px-4 py-2 whitespace-nowrap">
                                                    </th>
                                            `;
                                        }
                                    }).join('')}
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
                <div class="flex justify-between mt-2 items-center">
                <span class="text-xs text-gray-500 dark:text-gray-400">
                    ${groupedData.length} rows 
                    ${groupByColumn ? `(Grouped by ${groupByColumn.aggregation})` : ''}
                </span>

                ${ userType === 'P' 
                    ? `<div class="edit-table-btn cursor-pointer select-none inline-flex text-xs bg-blue-500 text-white py-1 px-2 rounded hover:bg-blue-600 items-center justify-center" data-index="${index}" role="button">Edit</div>`
                    : `` 
                }
            </div>
            </div>`;
    } else {
        card.innerHTML = `
            <div class="w-full h-full flex flex-col justify-center items-center text-center">
                <h3 class="text-xl font-semibold mb-4 text-gray-500 dark:text-gray-400">Cell ${index + 1}</h3>
                <div class="add-table-btn cursor-pointer select-none inline-flex bg-indigo-500 text-white font-bold py-3 px-6 rounded-full shadow-lg hover:bg-indigo-600 transition duration-150 transform hover:scale-105 items-center justify-center" data-index="${index}" role="button">Add</div>
            </div>`;
    }
    return card;
}

function reorderVisibleColumns(visibleColumns, expressionJson) {
    
    if (typeof expressionJson === "string") {
        try {
            expressionJson = JSON.parse(expressionJson);
        } catch (e) {
            console.warn("expressionJson string could not be parsed. Using original.", e);
        }
    }

    const positions = expressionJson?.columnposition;
 
    if (!Array.isArray(positions)) {
        console.warn("No columnposition array found. Skipping reorder.");
        return visibleColumns;
    }
    console.log('positions after positions');
    // Build map: baseColumnName → position
    const posMap = {};
    positions.forEach(p => {
        if (p.baseColumnName != null && typeof p.position === "number") {
            posMap[p.baseColumnName] = p.position;
        }
    });

    // Detect key property
    const keyProp = visibleColumns.length > 0
        ? visibleColumns[0].originalName != null
            ? "originalName"
            : "key"
        : "key";

    // Sort using the map
    return [...visibleColumns].sort((a, b) => {
        const posA = posMap[a[keyProp]];
        const posB = posMap[b[keyProp]];

        if (posA == null && posB == null) return 0;
        if (posA == null) return 1;
        if (posB == null) return -1;

        return posA - posB;
    });
}


     
        // ====================================================================
        // MODAL & EVENT LOGIC
        // ====================================================================

        function openModal(index) {
            currentModalIndex = index;
            dataModal.classList.add('active');
            document.body.style.overflow = 'hidden';
            const data = tableData[index];
            //console.log('data:>>>>',data);
            if (data) {
                jsonInput.value = JSON.stringify('[{"id":  , "name": " " }]');
                tableNameInput.value = data.title || `Table ${index + 1}`;
                document.getElementById('reportSelect').value = data.reportvalue;
                processJson(true);
            } else {
                jsonInput.value = '';
                tableNameInput.value = `Table ${index + 1}`;
                document.getElementById('dynamicTableContainer').classList.add('hidden');
                document.getElementById('jsonInputSection').classList.remove('hidden');
            }
        }

        function closeModal() {
            dataModal.classList.remove('active');
            document.body.style.overflow = 'auto';
            currentModalIndex = -1;
            const innerTableContainer = document.querySelector('.inner-table-container');
            if (innerTableContainer) innerTableContainer.innerHTML = '';
        }

        function processJson(isInitial = false) {
           
            const jsonText = JSON.stringify('[{"id":  , "name": " " }]');;
            if (!jsonText) { showMessage("Please paste valid JSON data.", 'error'); document.getElementById('dynamicTableContainer').classList.add('hidden'); return; }
           try {
    const parsedJson = Empty || [];
    
    // Handle empty array case
    if (!Array.isArray(parsedJson) || parsedJson.length === 0) {
        // Use default empty structure instead of showing error
        const columns = [{ key: 'id', name: 'Id' }]; // Default column
        const emptyRows = []; // Empty rows array
        
        const existingData = tableData[currentModalIndex];
        if (isInitial && existingData) {
            // Preserve existing columns if available
            dataModal.tempData = { 
                title: tableNameInput.value, 
                columns: existingData.columns || columns, 
                rows: emptyRows 
            };
            renderDynamicTable(existingData.columns || columns, emptyRows);
        } else {
            dataModal.tempData = { 
                title: tableNameInput.value, 
                columns: columns, 
                rows: emptyRows 
            };
            renderDynamicTable(columns, emptyRows);
            saveGlobalLayout();
        }
        
        document.getElementById('dynamicTableContainer').classList.remove('hidden');
        document.getElementById('jsonInputSection').classList.add('hidden');
        return;
    }
    
    // Process non-empty JSON
    const columnKeys = Object.keys(parsedJson[0]);
    const columns = columnKeys.map(key => ({ 
        key: key, 
        name: key.charAt(0).toUpperCase() + key.slice(1) 
    }));
    
    const existingData = tableData[currentModalIndex];
    if (isInitial && existingData) {
        columns.forEach(col => {
            const existingCol = existingData.columns.find(eCol => eCol.key === col.key);
            if (existingCol) col.name = existingCol.name;
        });
    }
    
    dataModal.tempData = { 
        title: tableNameInput.value, 
        columns: columns, 
        rows: parsedJson 
    };
    renderDynamicTable(columns, parsedJson);
    document.getElementById('dynamicTableContainer').classList.remove('hidden');
    document.getElementById('jsonInputSection').classList.add('hidden');
    saveTable();
    
} catch (e) { 
    // Fallback to empty structure on any error
    const columns = [{ key: 'id', name: 'Id' }];
    const emptyRows = [];
    
    dataModal.tempData = { 
        title: tableNameInput.value, 
        columns: columns, 
        rows: emptyRows 
    };
    renderDynamicTable(columns, emptyRows);
    document.getElementById('dynamicTableContainer').classList.remove('hidden');
    document.getElementById('jsonInputSection').classList.add('hidden');
    
    console.warn("Invalid JSON format, using empty default:", e);

     if(!isInitial){
                saveTable();   
            } 

   // saveTable();
}
        }

        function renderDynamicTable(columns, rows) {
            const innerTableContainer = document.querySelector('.inner-table-container');
            innerTableContainer.innerHTML = '';
            const table = document.createElement('table');
            table.classList.add('divide-y', 'divide-gray-200', 'dark:divide-gray-600', 'w-full');
            const thead = table.createTHead();
            thead.classList.add('bg-gray-100', 'dark:bg-gray-700');
            let headerRow = thead.insertRow();
            columns.forEach((col, colIndex) => {
                const th = document.createElement('th');
                th.className = 'px-6 py-3 text-left text-xs font-medium uppercase tracking-wider cursor-pointer hover:bg-gray-200 dark:hover:bg-gray-600 transition-colors whitespace-nowrap';
                th.innerHTML = `<span data-key="${col.key}">${col.name}</span>`;
                th.addEventListener('click', () => renameColumnHeader(th, colIndex));
                headerRow.appendChild(th);
            });
            const tbody = table.createTBody();
            tbody.classList.add('bg-white', 'dark:bg-gray-800', 'divide-y', 'divide-gray-200', 'dark:divide-gray-700');
            rows.forEach((row) => {
                let bodyRow = tbody.insertRow();
                columns.forEach(col => {
                    const td = document.createElement('td');
                    td.className = 'px-6 py-4 whitespace-nowrap text-sm';
                    td.textContent = row[col.key] !== undefined ? row[col.key] : '';
                    bodyRow.appendChild(td);
                });
            });
            innerTableContainer.appendChild(table);
        }
        
        function renameColumnHeader(thElement, colIndex) {
            const currentNameSpan = thElement.querySelector('span');
            const currentName = currentNameSpan.textContent;
            const input = document.createElement('input');
            input.type = 'text'; input.value = currentName;
            input.className = 'w-full bg-transparent border-b border-blue-500 focus:outline-none text-xs dark:text-white';
            thElement.innerHTML = ''; thElement.appendChild(input); input.focus();
            const finalizeRename = (newName) => {
                if (newName && newName.trim() !== currentName) dataModal.tempData.columns[colIndex].name = newName.trim();
                thElement.innerHTML = `<span data-key="${dataModal.tempData.columns[colIndex].key}">${dataModal.tempData.columns[colIndex].name}</span>`;
                thElement.addEventListener('click', () => renameColumnHeader(thElement, colIndex));
            };
            input.addEventListener('blur', () => finalizeRename(input.value));
            input.addEventListener('keypress', (e) => { if (e.key === 'Enter') input.blur(); });
        }

        // ====================================================================
        // BUTTON ACTIONS
        // ====================================================================

        function saveTable() {

          //  if (currentModalIndex === -1 || !dataModal.tempData) return;
            dataModal.tempData.title = document.getElementById('tableNameInput').value || `Table ${currentModalIndex + 1}`;
            dataModal.tempData.reportvalue= document.getElementById('reportSelect').value;
            tableData[currentModalIndex] = dataModal.tempData;
            showMessage(`Table saved successfully!`, 'success');
            console.log('saveTable:>>>>>>>>>>>',currentModalIndex);
           // renderGrid(); 
            loadReportDataForCanvas(document.getElementById('reportSelect').value, currentModalIndex, tableNameInput.value);
            closeModal();
            saveGlobalLayout(); 
        }

        function deleteTable() {
            if (currentModalIndex === -1) return;
            tableData[currentModalIndex] = null;
            showMessage(`Table deleted.`, 'info');
            renderGrid(); closeModal();
        }

       

        function addSampleTable() {
            let emptyIndex = -1;
            const maxLimit = configRows * configCols;
            for(let i = 0; i < maxLimit; i++) { if(!tableData[i]) { emptyIndex = i; break; } }
            if (emptyIndex === -1) { showMessage("No empty cells.", 'error'); return; }
            tableData[emptyIndex] = {
                title: "New Sample Table",
                columns: [{ key: 'id', name: 'ID' }, { key: 'prod', name: 'Product' }],
                rows: [{ id: 101, prod: 'Widget A' }]
            };
            renderGrid();
        }

        function fillAllCellsWithSampleData() {
            let filled = 0;
            for (let i = 0; i < (configRows * configCols); i++) {
                if (!tableData[i]) {
                    tableData[i] = { title: `Auto-Filled ${i+1}`, columns: [{ key: 'id', name: 'ID' }], rows: [{ id: 1 }] };
                    filled++;
                }
            }
            renderGrid();
        }

        function initDragAndDrop() {
            const containers = document.querySelectorAll('.draggable');
            let draggedIndex = null;
            containers.forEach(container => {
                container.addEventListener('dragstart', (e) => { draggedIndex = parseInt(container.getAttribute('data-index')); e.dataTransfer.effectAllowed = 'move'; setTimeout(() => container.classList.add('opacity-40'), 0); });
                container.addEventListener('dragover', (e) => { e.preventDefault(); if (draggedIndex !== parseInt(container.getAttribute('data-index'))) container.classList.add('drag-over'); });
                container.addEventListener('dragleave', () => container.classList.remove('drag-over'));
                container.addEventListener('drop', (e) => {
                    e.preventDefault(); container.classList.remove('drag-over');
                    const targetIndex = parseInt(container.getAttribute('data-index'));
                    if (draggedIndex !== null && draggedIndex !== targetIndex) {
                        const temp = tableData[draggedIndex]; tableData[draggedIndex] = tableData[targetIndex]; tableData[targetIndex] = temp; renderGrid();
                    }
                });
                container.addEventListener('dragend', () => { containers.forEach(c => c.classList.remove('opacity-40', 'drag-over')); draggedIndex = null; });
            });
        }

 
const loginUsername = $v("P0_USERNAME");  
let userType ;
console.log('loginUsername:>>>>',loginUsername);
const ajaxProcessName = 'AJX_GET_USR_TYPE';
const dataToSend = {
     
    x01: loginUsername 
};

apex.server.process(ajaxProcessName, dataToSend, {
    // Success handler: The 'pData' argument contains the output from APEX_UTIL.PRN
    success: function(pData) {
         
            // pData now holds the 'type' value from the database
            userType = pData.type;
            console.log('User Type successfully retrieved:', userType);
            
        
    },
    // Error handler for network or other communication errors
    error: function(jqXHR, textStatus, errorThrown) {
        console.error('AJAX Network Error:', textStatus, errorThrown);
        alert('Communication error during AJAX call.');
    },
    // Optional: Show a loading indicator
    loadingIndicator: 'body'
});



const hotelSelect = document.getElementById('P0_HOTEL_ID');
let hotel_id ; 
// Add a listener to trigger report list loading whenever the hotel selection changes
hotelSelect.addEventListener('change', function() {
    initDashboardWithConfig();
            load_report();

    //window.location.reload(true);
});

function load_report(){ 
    const selectedHotelId = document.getElementById('P0_HOTEL_ID').value;
    hotel_id = selectedHotelId;
    if (selectedHotelId) {
        // Load the Report LOV in the modal
        loadReportLov(selectedHotelId); 
       // call_dashboard_data(selectedHotelId);
    } else {
        // If no hotel is selected, reset and disable the report LOV
        $('#reportSelect').prop('disabled', true).html('<option value="">-- Select Hotel First --</option>');
    }

}


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
                //console.log('pData:>>>>',pData);
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
 
 function saveGlobalLayout() {
            const layoutExport = [];
            const maxCells = configRows * configCols;
            let hotel_id = document.getElementById('P0_HOTEL_ID').value;
            for (let i = 0; i < maxCells; i++) {
                const data = tableData[i];
                if (data) {
                    layoutExport.push({
                        position: i,
                        reportName: data.title || `Table ${i+1}`,
                        reportvalue: data.reportvalue
                        //columnConfig: data.columns
                    });
                }
            }
            const jsonString = JSON.stringify(layoutExport, null, 2);
            // console.log("--- Layout Export (No Data) ---");
            // console.log(jsonString);
            apex.server.process(
                    'AJX_MANAGE_REPORT_DASHBOARD', // Your AJAX process name
                    {x01: 'INSERT_SUMMARY',
                    x02: hotel_id,
                    x03: jsonString},
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
           // alert("Layout JSON generated! Check the Browser Console (F12).");
        }

function saveReports() {
    const savableReports = reports.map(r => ({
        name: r.name ,
        reportId: r.reportId,
        currentPage: r.currentPage,
      //  data: r.data, 
    }));
    
    // NEW: Combine Reports array and Pan state into a single object
    const fullState = {
        reports: savableReports 
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
 
 function refreshview(){

     initDashboardWithConfig();
            load_report();
 }


        // ====================================================================
        // INIT
        // ====================================================================

        window.onload = () => {
            if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) { isDarkMode = true; toggleTheme(); }
            closeModalBtn.addEventListener('click', closeModal);
            processJsonBtn.addEventListener('click', () => processJson());
            //processJsonBtn.addEventListener('click',   saveTable);
            deleteTableBtn.addEventListener('click', deleteTable);
            saveTableBtn.addEventListener('click', saveTable);
            addSampleDataBtn.addEventListener('click', addSampleTable);
            fillAllCellsBtn.addEventListener('click', fillAllCellsWithSampleData);
            updateGridBtn.addEventListener('click', updateGridDimensions);
            refreshBtn.addEventListener('click', refreshview);
            saveGlobalLayoutBtn.addEventListener('click', saveGlobalLayout);
            document.addEventListener('click', (e) => {
                if (e.target.classList.contains('add-table-btn') || e.target.classList.contains('edit-table-btn')) {  
                    console.log('edit click');
                    openModal(parseInt(e.target.getAttribute('data-index'))); 
                     }
            });
            dataModal.addEventListener('click', (e) => { if (e.target === dataModal) closeModal(); });

            initDashboardWithConfig();
            load_report();
            
            const element = document.getElementById('jsonInput'); 
            element.style.display = 'none';
            const addSampleData = document.getElementById('addSampleData'); 
            addSampleData.style.display = 'none';
            const fillAllCells = document.getElementById('fillAllCells'); 
            fillAllCells.style.display = 'none';
            // const toggleEmptyCardsBtn = document.getElementById('toggleEmptyCardsBtn'); 
            // toggleEmptyCardsBtn.style.display = 'none';
            const saveGlobalLayoutBtnrndr = document.getElementById('saveGlobalLayoutBtn'); 
            saveGlobalLayoutBtnrndr.style.display = 'none';
            const elements = document.getElementsByClassName('inner-table-container');
                 for (let i = 0; i < elements.length; i++) {
                elements[i].style.display = 'none'; 
                }
           
            document.getElementById('reportSelect').addEventListener('change', function () {
                const selectedText = this.options[this.selectedIndex].text;  // view text
                document.getElementById('tableNameInput').value = selectedText; // set textbox
            });

        };