    var hotelData;
    let hotelTemplates = [];
    let conditionalFormattingRules = {}; 
    let formatterBlockIdCounter = 0; 
    let formatterRuleIdCounter = 0
    let TEMP_FORMATTING_JSON ;
    let algoArray;

    // DOM elements
    const hotelLov = document.getElementById('hotel-lov');
// Hide the entire Select Hotel group (label + dropdown)
const hotelGroup = hotelLov.closest('.selector-group');
if (hotelGroup) {
  hotelGroup.style.display = 'none';
  //notification
} 

    const templateLov = document.getElementById('template-lov');
    const reportLov = document.getElementById('report-lov');
    templateLov.style.display = 'none'; 
    const availableColumns = document.getElementById('available-columns');
    const selectedColumns = document.getElementById('selected-columns');

    const jsonOutput = document.getElementById('json-output');
    const leftSearch = document.getElementById('left-search');
    const rightSearch = document.getElementById('right-search');
    const availableCount = document.getElementById('available-count');
    const selectedCount = document.getElementById('selected-count');
  

    const currentTemplateInfo = document.getElementById('current-template-info');


    const addBtn = document.getElementById('add-btn');
    const addAllBtn = document.getElementById('add-all-btn');
    const removeBtn = document.getElementById('remove-btn');
    const removeAllBtn = document.getElementById('remove-all-btn');
    const generateJsonBtn = document.getElementById('generateJson');
    const resetBtn = document.getElementById('resetSelection');
    const sortAvailableAsc = document.getElementById('sort-available-asc');
    const sortAvailableDesc = document.getElementById('sort-available-desc');
    const sortSelectedAsc = document.getElementById('sort-selected-asc');
    const sortSelectedDesc = document.getElementById('sort-selected-desc');

    // Current state
    let selectedHotel = '';
    let selectedTemplate = '';
    let draggedItems = [];
    let selectedFieldsHistory = {}; // To track which fields came from which template

 



        function fetchTemplates_all() {
            var hotelId = hotelLov.options[hotelLov.selectedIndex].text;

            apex.server.process(
                'AJX_GET_HOTEL_TEMP_ALL',
                { x01: hotelId },
                {
                    success: function(data) {
                        // console.log('Received data:', data);
                        hotelTemplates = data; 
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('AJAX Error:', errorThrown);
                    }
                }
            );
        }
        

 function loadHotelTemplates(hotelName) {
            console.time("AJAX_Execution_Time:>loadHotelTemplates");
                apex.server.process(
                    "AJX_GET_HOTEL_TEMPLATES", // Ajax Callback name
                        { x01: hotelName },    // pass hotel name
                    {
                        dataType: "json",
                        success: function(data) {
                            // console.log("Hotel templates JSON:", data);
                            console.timeEnd("AJAX_Execution_Time:>loadHotelTemplates");
                            hotelData = data;
                            console.log('hotelData:>>>>>>>>>>>',hotelData);
                             algoArray = Object.entries(data)
                                            .find(([key]) => key.toLowerCase() === 'algo')?.[1] || [];
                                            // console.log('algoArray:>>>>>',algoArray);

                            // Example: pick first hotel key
                            const hotelKey = Object.keys(data)[0];
                            const hotel = data[hotelKey];

                        // Clear LOV
                        const templateLov = document.getElementById("template-lov");
                        templateLov.innerHTML = '<option value="">-- Select Template --</option>';

                        // Loop templates
                        Object.keys(hotel.templates).forEach(function(templateName) {
                            const option = document.createElement("option");
                            option.value = templateName;
                    option.textContent = templateName.replace(/_/g, ' ');
                    templateLov.appendChild(option);
                });

                selectedHotel = hotelLov.options[hotelLov.selectedIndex].text;
              selectedHotel =   selectedHotel.toLowerCase().replace(/\s+/g, '');
            templateLov.disabled = !selectedHotel;
            
            if (selectedHotel) {
                // Clear previous template options
                templateLov.innerHTML = '<option value="">-- Select Template --</option>'; 
                // Add templates for selected hotel
                const hotelKey = selectedHotel.toLowerCase().replace(/\s+/g, '');
                const templates = Object.keys(hotelData[hotelKey].templates);
                templates.forEach(template => {
                    const option = document.createElement('option');
                    option.value = template;
                    option.textContent = template.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
                    templateLov.appendChild(option);
                });
                
                // Clear available columns but preserve selected columns
                availableColumns.innerHTML = '';
                currentTemplateInfo.textContent = 'Current template: None';
            } else {
                // Reset template LOV
                templateLov.innerHTML = '<option value="">-- Select Hotel First --</option>';
                templateLov.disabled = true;
                
                // Clear available columns but preserve selected columns
                availableColumns.innerHTML = '';
                currentTemplateInfo.textContent = 'Current template: None';
            }
            
            // Update button states
            updateButtonStates();
            // Update counts
            updateCounts();
            // Hide JSON output
            jsonOutput.style.display = 'none';
            
            getAndPopulateReports();
            
            },
            error: function(xhr, status, error) {
                console.error("Error fetching hotel templates:", error);
            }
        }
    );
}


let hotel_qualifiers ;
function getAllQualifiers() {
    var hotelId =  hotelLov.options[hotelLov.selectedIndex].value;
    // console.log('hotelId:>>>>>>>>',hotelId);
    apex.server.process(
  "AJX_GET_REPORT_ALL_QUALIFIERS", // Process name
  {x01: hotelId },                             
  {
    dataType: "json",              // Expect JSON
    success: function(pData) {
      // console.log("Full response:", pData);
        hotel_qualifiers = pData;
      // Access array
      if (pData && pData.data) {
        pData.data.forEach(function(row) {
          // console.log("Name:", row.name, "Temp Name:", row.temp_name);
        });
      }
    },
    error: function(jqXHR, textStatus, errorThrown) {
      console.error("AJAX Error:", textStatus, errorThrown);
    }
  }
);
}

      

        // Initialize the page
        function init() {
            // Event listeners
            hotelLov.addEventListener('change', handleHotelSelection);
            templateLov.addEventListener('change', handleTemplateSelection);
            reportLov.addEventListener('change', handleReportSelection);
            addBtn.addEventListener('click', addSelected);
            addAllBtn.addEventListener('click', addAll);
            removeBtn.addEventListener('click', removeSelected);
            removeAllBtn.addEventListener('click', removeAll);
            generateJsonBtn.addEventListener('click', generateJson);
            resetBtn.addEventListener('click', resetSelection);
            leftSearch.addEventListener('input', filterColumns);
            rightSearch.addEventListener('input', filterColumns);
            
            // Sorting event listeners
            sortAvailableAsc.addEventListener('click', () => sortColumns(availableColumns, true));
            sortAvailableDesc.addEventListener('click', () => sortColumns(availableColumns, false));
            sortSelectedAsc.addEventListener('click', () => sortColumns(selectedColumns, true));
            sortSelectedDesc.addEventListener('click', () => sortColumns(selectedColumns, false));
             


            callHotel();
            // Set up drag and drop events with the new handlers
            setupDragAndDrop();
            
            // Initialize counts
            updateCounts();
        }



function loadSavedFormatters() {
    const savedFormulasListBody = document.getElementById('saved-formatters-list');
    
    // Clear the table body first
    savedFormulasListBody.innerHTML = '';
    
    // 1. Load data (Assuming it's stored in a global variable or fetched from storage)
    // NOTE: You'll need to update your localStorage keys to match your current data structure
    
    // Example: Load from localStorage under a specific key if needed
    const storedRules = localStorage.getItem('conditionalFormattingRules'); 
    if (storedRules) {
        try {
            conditionalFormattingRules = JSON.parse(storedRules);
        } catch (e) {
            console.error("Failed to parse conditional formatting rules from storage:", e);
            return;
        }
    }
    

    // 2. Iterate through the saved rules (keys are the Target Columns)
    for (const targetColumnKey in conditionalFormattingRules) {
        if (!conditionalFormattingRules.hasOwnProperty(targetColumnKey)) continue;

        const rulesArray = conditionalFormattingRules[targetColumnKey];

        if (rulesArray && rulesArray.length > 0) {
            
            // 3. Concatenate all rule expressions for display
            // We use HTML to embed the color and expression for better viewing
            const rulesDisplayHTML = rulesArray.map(rule => {
                const colorDot = `<span style="display:inline-block; width:10px; height:10px; border-radius:50%; background-color:${rule.color}; margin-right:5px; border: 1px solid #aaa;"></span>`;
                return `<div>${colorDot}${rule.expression}</div>`;
            }).join(''); // Use an empty string or <br> to separate rules

            // 4. Create the new table row
            const row = savedFormulasListBody.insertRow();
            row.setAttribute('data-column-key', targetColumnKey);

            // Cell 1: Column
            row.insertCell().textContent = targetColumnKey; // Assuming key is the column name

            // Cell 2: Format Type (Placeholder for now)
           // row.insertCell().textContent = "Conditional Color"; 

            // Cell 3: Rules / Conditions (Insert the concatenated HTML)
            row.insertCell().innerHTML = rulesDisplayHTML; 

            // Cell 4: Actions (Update/Edit Button)
            const actionsCell = row.insertCell();
            actionsCell.innerHTML = `<div class="action-btn btn-secondary update-formatter" data-column="${targetColumnKey}">Update</div>`;
            
            // Cell 5: Delete
            const deleteCell = row.insertCell();
            deleteCell.innerHTML = `<div class="action-btn btn-danger delete-formatter" data-column="${targetColumnKey}">Delete</div>`;
        }
    }

    // 5. Attach event listeners for the new buttons
    attachFormatterEventListeners();
}

// NOTE: Assuming conditionalFormattingRules is accessible globally
// NOTE: You will need a helper function to clear the rules list and reset the rule counter
let ruleCount = 1; // Global counter defined previously

/**
 * Prepares the formatter dialog for editing an existing rule set.
 * @param {string} columnKey The key of the column rules to load (e.g., 'STAYDATE').
 */
function loadFormatterForEdit(columnKey) {
    // --- Step 1: Initialize the Dialog ---
    // Ensure you have a clearFormatter function that resets everything, including the rule counter and the rules list container!
    clearFormatter(); 
    
    // Show the dialog box
    document.getElementById("formatter-dialog").style.display = "flex";
    
    // Populate the source column selector (using your existing function)
    populateFormatterColumnLov_temp('column-select_ftr');
    
    // --- Step 2: Set the Source Column ---
    document.getElementById('column-select_ftr').value = columnKey;
    
    // --- Step 3: Load Rules and Rebuild UI ---
    const rulesArray = conditionalFormattingRules[columnKey];
    const rulesListContainer = document.getElementById('rules-list');
    
    if (!rulesArray || rulesArray.length === 0) {
        // Should not happen, but safe check
        console.warn(`No rules found for column: ${columnKey}`);
        return;
    }
    
    // Get the template rule section (the one we clone from)
    const $initialRuleTemplate = $('.rule-section').first().clone();
    
    // Clear the initial rule section content before rebuilding
    rulesListContainer.innerHTML = '';
    ruleCount = 0; // Reset counter for re-indexing
    
    // Iterate over each saved rule configuration
    rulesArray.forEach((rule, index) => {
        ruleCount = index + 1; // Rule number (1, 2, 3...)

        // Clone the template structure
        const $newRule = $initialRuleTemplate.clone();

        // A. Update metadata and label
        $newRule.attr('data-rule-id', ruleCount);
        $newRule.find('.rule-label').text('Create Rule ' + ruleCount);
        $newRule.find('.delete-rule-btn').attr('data-rule-id', ruleCount);

        // B. Update element IDs and values
        $newRule.find('*').each(function() {
            const currentId = $(this).attr('id');
            if (currentId) {
                // Remove the old index (if any) and append the new index
                let baseId = currentId.replace(/-\d+$/, '');
                
                const newId = baseId + '-' + ruleCount;
                $(this).attr('id', newId);
            }
        });
        
        // C. Populate values specific to this rule
        
        // Set the Expression/Textarea value
        $('#formatter-rules-' + ruleCount, $newRule).val(rule.expression);
        
        // Set the Color Picker value
        $('#formatter-color-' + ruleCount, $newRule).val(rule.color);
        
        // D. Append the newly created rule to the dialog
        rulesListContainer.appendChild($newRule[0]);
    });
    
    // Reset the ruleCount to the correct value for adding new rules later
    ruleCount = rulesArray.length;
}

 
function deleteFormatter(columnKey) {
    // 1. Confirmation before deletion
    if (!confirm(`Are you sure you want to delete ALL formatting rules for the column: ${columnKey}?`)) {
        return;
    }

    // 2. Delete the entry from the global object
    if (conditionalFormattingRules.hasOwnProperty(columnKey)) {
        delete conditionalFormattingRules[columnKey];
        
        // console.log(`Successfully deleted rules for column: ${columnKey}`);
        
        // 3. Update localStorage to persist the change
        try {
            localStorage.setItem('conditionalFormattingRules', JSON.stringify(conditionalFormattingRules));
            showSuccessMessage(`Rules for ${columnKey} deleted successfully.`, 'success');
        } catch (e) {
            console.error("Error saving updated rules to localStorage:", e);
        }

         
        saveAllDataToJSON();
        handleSave();
        
        displayReportTable('deleteFormatter');
        loadSavedFormatters();

    } else {
        console.warn(`Attempted to delete non-existent rules for column: ${columnKey}`);
    }
}

function attachFormatterEventListeners() {
    // Empty function for now, as requested
    document.querySelectorAll('.update-formatter').forEach(btn => {
        btn.addEventListener('click', function() {
            const columnKey = this.getAttribute('data-column');
            // console.log(`Edit clicked for column: ${columnKey}`);
            
            //  Call the main loading function for editing
            loadFormatterForEdit(columnKey); 
            populateFormatterColumnLov_temp('rule_set_column');
        });
    });;

    // Empty function for now, as requested
    document.querySelectorAll('.delete-formatter').forEach(btn => {
        btn.addEventListener('click', function() {
            const columnKey = this.getAttribute('data-column');
            // console.log(`Delete clicked for column: ${columnKey}`);
            deleteFormatter(columnKey);
        });
    });
}


function callHotel() {
    const hotelLov = document.getElementById("hotel-lov"); 
    hotelLov.innerHTML = '<option value="">-- Select Hotel --</option>';

    // Call APEX Ajax process
    apex.server.process(
        "AJX_GET_REPORT_HOTEL",   // Ajax Callback name
        { x01: 'HOTEL',
         x02: hotelLov.options[hotelLov.selectedIndex].value           
        },
        {
            dataType: "json",
            success: function(data) {
                // console.log('AJX_GET_REPORT_HOTEL:>>>',data);
                // Loop over hotel JSON and add options
                data.forEach(function(hotel) {
                    const option = document.createElement("option");
                    option.value = hotel.ID;
                    option.textContent = hotel.HOTEL_NAME;
                    hotelLov.appendChild(option);
                    
                });
            },
            error: function(xhr, status, error) {
                console.error("Error fetching hotels:", error);
            }
        }
    );
}

var reportData = [];

// detect when no hotel is selected
function getSelectedHotelId() {
    const hotelLov = document.getElementById("hotel-lov");
    if (!hotelLov) return null;

    let value = hotelLov.value;
    if (!value || value === "" || value === "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF") {
        return null; // Show-all-data OR empty → treat as no hotel
    }
    return value;
}


function showReportLoading() {
    const reportLov = document.getElementById('report-lov');

    // If no hotel is selected, show friendly message instead of spinner
    if (!getSelectedHotelId()) {
        reportLov.innerHTML = '';
        const opt = document.createElement('option');
        opt.textContent = 'Select a hotel...';
        opt.disabled = true;
        opt.selected = true;
        reportLov.appendChild(opt);

        // Hide spinner if exists
        const spinner = document.getElementById('report-loading-spinner');
        if (spinner) spinner.style.display = 'none';
        return;
    }

    // Normal loading flow
    reportLov.innerHTML = '';
    const loadingOption = document.createElement('option');
    loadingOption.textContent = 'Loading Reports...';
    loadingOption.disabled = true;
    loadingOption.selected = true;
    reportLov.appendChild(loadingOption);

    let spinner = document.getElementById('report-loading-spinner');
    if (!spinner) {
        spinner = document.createElement('div');
        spinner.id = 'report-loading-spinner';
        spinner.className = 'spinner';
        reportLov.parentNode.insertBefore(spinner, reportLov.nextSibling);
    }
    spinner.style.display = 'inline-block';
}


function hideReportLoading() {
    const reportLov = document.getElementById('report-lov');

    // If no hotel selected → do NOT hide anything (message already shown)
    if (!getSelectedHotelId()) return;

    if (reportLov.options.length > 0 && reportLov.options[0].text === 'Loading Reports...') {
        reportLov.remove(0);
    }

    const spinner = document.getElementById('report-loading-spinner');
    if (spinner) spinner.style.display = 'none';
}


// VARUN TEST CODE - start
// ===========================
function setLovValueAndText(selectId, value, text) {
  const select = document.getElementById(selectId);
  let option = Array.from(select.options).find(opt => opt.value === value);
  
  if (!option) {
    option = new Option(text, value, true, true); 
    select.add(option);
  } else {
    option.selected = true;
  }
}

function handleHotelSelection_onload() {
    // console.log('Before load template');

    showReportLoading(); 

    let hotelLov_onload = document.getElementById('P0_HOTEL_ID'); 
    let selectedValue = hotelLov_onload.value;
    let selectedText  = hotelLov_onload.options[hotelLov_onload.selectedIndex].text;

    setLovValueAndText("hotel-lov", selectedValue, selectedText);

    //  FIX: Avoid loading templates for Show all data
    if (selectedValue !== 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF') {
        hotelData = loadHotelTemplates(selectedText);
    } else {
        // console.log("Show all data selected → skipping template load");
        hotelData = { templates: [] }; // Safe default
    }

            $('#New-Report').val('');
            availableColumns.innerHTML = '';
            selectedColumns.innerHTML = '';
            leftSearch.value = '';
            rightSearch.value = '';
            jsonOutput.style.display = 'none';
            selectedFieldsHistory = {};
            currentTemplateInfo.textContent = 'Current template: None';
            
            updateCounts();
            updateButtonStates();
            // console.log('After call templ');
            
        }


function populateReportsFromGlobalHotel() {
   handleHotelSelection_onload();
 
}
// ===========================
// END VARUN TEST CODE


function getAndPopulateReports() {
    var selectedHotelId = hotelLov.options[hotelLov.selectedIndex].value;
    var reportLov = $('#report-lov');
    reportLov.empty();

    showReportLoading();
console.time("AJAX_Execution_Time");
    apex.server.process(
        'AJX_GET_REPORT_HOTEL',
        {
            x01: 'REPORT',
            x02: selectedHotelId
        },
        {
            success: function(pData) {
                console.timeEnd("AJAX_Execution_Time");
                hideReportLoading();

                // Add the "Create New Report" option first
                // console.log('Report:>',pData);
                reportData = pData;
                reportLov.append('<option value="">-- Select Report --</option>');

                if (Array.isArray(pData) && pData.length > 0) {
                    pData.forEach(function(item) {
                        reportLov.append(
                            $('<option>', {
                                value: item.ID,
                                text: item.REPORT_NAME,
                                title: item.DEFINITION
                            })
                        );
                    });
                } else {
                    reportLov.append('<option value="">No Reports Found</option>');
                }

                reportLov.append('<option value="-1">-- Create New Report --</option>');

                // Initial check to hide the text field
                $('#New-Report').hide();
            },
            error: function(pData) {
                hideReportLoading();
                console.error("AJAX call failed: ", pData);
            }
        }
    );
}



   function handleReportSelection() {
    var selectedValue = $('#report-lov').val();
    var newReportInput = $('#New-Report');

    if (selectedValue === '-1') {
        newReportInput.show();
        $('#New-Report').val('');
        availableColumns.innerHTML = '';
        selectedColumns.innerHTML = '';
        leftSearch.value = '';
        rightSearch.value = '';
        jsonOutput.style.display = 'none';
        selectedFieldsHistory = {};
        currentTemplateInfo.textContent = 'Current template: None';
        
        // Reset global data structures for a new report
        savedFormulas = {}; 
        savedFilters = {}; 
        conditionalFormattingRules = {}; 

        updateCounts();
        updateButtonStates();
        
        // Load one empty block for a new report
        loadConditionalFormattingBlocks();  
        const dashboard = document.querySelector('.data-dashboard-wrapper');
        if (dashboard) {
            dashboard.style.display = 'none';
        }
        


    } else {
        $('#New-Report').val(reportLov.options[reportLov.selectedIndex].text);
        // console.log('handleReportSelection---->>>',handleReportSelection);
        var selectedReport = reportData.find(item => item.ID === selectedValue);
        selectedFieldValues = selectedReport.DEFINITION.split(',').map(s => s.trim());
        
        if (selectedReport && selectedReport.DEFINITION) {
            // console.log('--selectedReport.DEFINITION:>' + selectedReport.DEFINITION);
            populateSelectedColumns(selectedReport.DEFINITION);
            // console.log('TEMP_FORMATTING_JSON:>>>>>>>',TEMP_FORMATTING_JSON);
 
            conditionalFormattingRules = TEMP_FORMATTING_JSON; 
            // -------------------------------------------------

        } else {
            $('#selected-columns').empty();
        }
        
        newReportInput.hide();

        // -------------------------------------------------
        // Call the specific loader function
        loadConditionalFormattingBlocks(); 
        // -------------------------------------------------

        // AUTOMATICALLY LOAD EXISTING REPORT DATA AND FILTERS
        if (selectedReport && selectedReport.ID) {
            selectedreport_var = selectedReport.ID
            call_dashboard_data(selectedReport.ID); // load report data
        }
 
    }
    
    fetchTemplates_all();
    handleTemplateSelection();
    getAllQualifiers();
    // loadAllFormatterBlocks(); // Original call is now redundant/replaced by the call above
   
  

 
}

let selectedreport_var;
document.addEventListener("click", function(e) {

    
  // 1️⃣ Add New Formula
  if (e.target && e.target.id === "open-formula-dialog") {
    const dialog = document.getElementById("formula-dialog");
    clearFormula();
    dialog.style.display = "flex";
    const addButton = document.getElementById('add-calculation');
    if (addButton) {
        addButton.style.display = 'inline-block'; 
    }  

  }

  // 2️⃣ Close Dialog
  if (e.target && e.target.id === "close-dialog") {
    const dialog = document.getElementById("formula-dialog");
    dialog.style.display = "none";
  }

  // 3️⃣ Use (Edit/Update) Existing Formula
  if (e.target && e.target.classList.contains("use-formula-btn")) {
    const dialog = document.getElementById("formula-dialog");
    const formulaId = e.target.getAttribute("data-id"); // optional if you store IDs
    dialog.style.display = "flex";

    // Optional: prefill the dialog fields if you have the formula data available
    const formula = window.savedFormulas?.find(f => f.id === formulaId);
    if (formula) {
      document.getElementById("calc-name").value = formula.name;
      document.getElementById("formula-preview").value = formula.expression;
      document.getElementById("formulafilter-preview").value = formula.filter;
    }
  }
});

// varun test code start --------------------
document.addEventListener("DOMContentLoaded", function () {
    // Initial population on page load
    populateReportsFromGlobalHotel();

// React when global hotel LOV changes
$("#P0_HOTEL_ID").on("change", function () {
    populateReportsFromGlobalHotel();
});

});

// end -----------

document.addEventListener("click", function(e) {

  // 1️⃣ Open Filter Dialog
  if (e.target && e.target.id === "open-filter-dialog") {
    const dialog = document.getElementById("filter-dialog");
    clearFilterBuilder(); // optional function to reset inputs
    dialog.style.display = "flex"; 
     const addButton = document.getElementById('apply-saved-filter');
                if (addButton) {
                    addButton.style.display = 'inline-block';
                 } 
      const saveButton = document.getElementById('add-saved-filter'); 
		saveButton.style.display = 'none'; 
		addButton.style.display = "flex";  
         const dialogupdate = document.getElementById("update-saved-filter"); 
        dialogupdate.style.display = "none";         

  }

  // 2️⃣ Close Filter Dialog
  if (e.target && e.target.id === "close-filter-dialog") {
    const dialog = document.getElementById("filter-dialog");
    dialog.style.display = "none";
  }

  // 3️⃣ Edit / Use Existing Filter
  if (e.target && e.target.classList.contains("use-filter-btn")) {
    const dialog = document.getElementById("filter-dialog");
    const filterId = e.target.getAttribute("data-id"); // optional if stored
    dialog.style.display = "flex";

    // Optional: prefill the filter fields if data is available
    const filter = window.savedFilters?.find(f => f.id === filterId);
    if (filter) {
      document.getElementById("filter-name-input").value = filter.name;
      document.getElementById("filter-preview").value = filter.expression;
    }
  }

//   if (e.target && e.target.id === "open-filter-dialog") {
//   const dialog = document.getElementById("filter-dialog");
//   clearFilterBuilder();
//   dialog.style.display = "flex";
// }

// Close Filter Dialog
if (e.target && e.target.id === "close-filter-dialog") {
  document.getElementById("filter-dialog").style.display = "none";
}

// Use/Update existing filter
if (e.target && e.target.classList.contains("use-filter-btn")) {
  const dialog = document.getElementById("filter-dialog");
  const name = e.target.getAttribute("data-name");
  const savedFilter = window.savedFilters?.[name];
  if (savedFilter) {
    document.getElementById("filter-name-input").value = name;
    document.getElementById("filter-preview").value = savedFilter.expression || "";
  }
  dialog.style.display = "flex";
}

// Delete filter
if (e.target && e.target.classList.contains("delete-filter-btn")) {
  const name = e.target.getAttribute("data-name");
  if (confirm(`Delete filter "${name}"?`)) {
    delete savedFilters[name];
    localStorage.setItem("savedFilters", JSON.stringify(savedFilters));
    document.getElementById("saved-filters-list").innerHTML = "";
    for (const key in savedFilters) {
      renderSavedFilter(key, savedFilters[key].expression);
    }
  }
}
});



 var selectedFieldValues ;
 
function populateSelectedColumns(definitionString) {
    var selectedColumnsContainer = document.getElementById('selected-columns');
    
    // Split the comma-separated string into an array of column names
    var columns = definitionString.split(',');
    
    // Clear any existing content
    selectedColumnsContainer.innerHTML = '';

    columns.forEach(function(columnName, index) {
        var trimmedColumnName = columnName.trim();
        
        // Create column item div
        var columnItem = document.createElement('div');
        columnItem.className = 'column-item';
        columnItem.draggable = true;

        // Create checkbox
        var checkboxId = 'available-columns-' + trimmedColumnName.replace(/[^a-zA-Z0-9-]/g, '') + '-' + index;
        var checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.className = 'column-checkbox';
        checkbox.id = checkboxId;
        checkbox.dataset.value = trimmedColumnName;
        checkbox.checked = false;

        // Create label
        var label = document.createElement('label');
        label.htmlFor = checkboxId;
        label.textContent = trimmedColumnName;

        // Create drag icon
        var dragIcon = document.createElement('div');
        dragIcon.className = 'drag-icon';
        dragIcon.innerHTML = '≡';

        // Append elements
        columnItem.appendChild(checkbox);
        columnItem.appendChild(label);
        columnItem.appendChild(dragIcon);

        // Add drag events
        columnItem.addEventListener('dragstart', handleDragStart);
        columnItem.addEventListener('dragend', handleDragEnd);

        // Append to container
        selectedColumnsContainer.appendChild(columnItem);
    });
}


        // Handle hotel selection
        function handleHotelSelection() {
            // console.log('Before load template');
            // Show the spinner immediately on hotel selection
            showReportLoading();
            hotelData = loadHotelTemplates(hotelLov.options[hotelLov.selectedIndex].text);
            // console.log('After load templ');
            $('#New-Report').val('');
            availableColumns.innerHTML = '';
            selectedColumns.innerHTML = '';
            leftSearch.value = '';
            rightSearch.value = '';
            jsonOutput.style.display = 'none';
            selectedFieldsHistory = {};
            currentTemplateInfo.textContent = 'Current template: None';
            
            updateCounts();
            updateButtonStates();
            // console.log('After call templ');
        }

        // Handle template selection
        function handleTemplateSelection() {
            selectedTemplate = 'All'; // templateLov.options[templateLov.selectedIndex].text;
            
            if (selectedHotel && selectedTemplate) {

                const hotelKey = selectedHotel.toLowerCase().replace(/\s+/g, '');
                const hotelObject = hotelData[hotelKey];
                console.log('----Full hotel object:>', hotelObject);
                const templateFieldsAll = hotelObject.templates;

               // const templateFieldsAll = hotelData[selectedHotel.toLowerCase().replace(/\s+/g, '')].templates;
                 console.log('----templateFieldsAll:>', templateFieldsAll);
                const formattedArray = [];

                   for (const templateName in templateFieldsAll) {
                        if (Object.hasOwnProperty.call(templateFieldsAll, templateName)) {
                            const fields = templateFieldsAll[templateName];

                            // Handle Global_Attributes specially - they are objects with {id, name}
                            if (templateName === 'Global_Attributes') {
                                fields.forEach(attr => {
                                    formattedArray.push(`${attr.name} ( Global_Attributes )`);
                                });
                                continue;
                            }

                            fields.forEach(field => {
                                const formattedString = `${field} ( ${templateName} )`;
                                formattedArray.push(formattedString);
                            });
                        }
                    }

                  //  formattedArray.push(...algoArray);
                   // // console.log('----formattedArray:>',formattedArray);
                const finalString = formattedArray.join(', ');

                const finalArray = finalString.split(', ');
                const templateFields = finalArray ; 
                currentTemplateInfo.textContent = `Current template: ${selectedTemplate.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}`;
                const selectedFieldValues = Array.from(selectedColumns.querySelectorAll('.column-checkbox'))
                                    .map(checkbox => checkbox.dataset.value);
                                
                                const availableFields = templateFields.filter(field => 
                                    !selectedFieldValues.includes(field)
                                );
                         //     console.log('----availableColumns:>', availableColumns);
                       //     console.log('----availableFields:>',availableFields);
                                populateColumns(availableColumns, availableFields);
                                populateColumns(selectedColumns, selectedFieldValues);
                                
                                addAllBtn.disabled = availableFields.length === 0;
            } else {
                availableColumns.innerHTML = '';
                currentTemplateInfo.textContent = 'Current template: None';
                
                addAllBtn.disabled = true;
            }
            
            updateButtonStates();
            updateCounts();
            jsonOutput.style.display = 'none';
        }

        // Populate columns in a container
        function populateColumns(container, columns) {
            container.innerHTML = '';
            
            columns.forEach((column, index) => {
                const item = document.createElement('div');
                item.className = 'column-item';
                item.draggable = true;
                
                // Create the checkbox
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.className = 'column-checkbox';
                checkbox.id = `${container.id}-${column.replace(/\s/g, '-')}-${index}`;
                checkbox.dataset.value = column;

                // Create the label
                const label = document.createElement('label');
                label.htmlFor = checkbox.id;
                label.textContent = column;

                // Add change event listener for the checkbox
                checkbox.addEventListener('change', updateButtonStates);
                
                item.appendChild(checkbox);
                item.appendChild(label);
                
                // Add drag icon
                const dragIcon = document.createElement('div');
                dragIcon.className = 'drag-icon';
                dragIcon.innerHTML = '≡';
                item.appendChild(dragIcon);
                
                // Add drag events
                //// console.log('added handleDragStart',item);
                item.addEventListener('dragstart', handleDragStart);
                item.addEventListener('dragend', handleDragEnd);
                
                container.appendChild(item);
            });
        }

        // Set up drag and drop events for containers
        function setupDragAndDrop() {
            // Available columns container events
            availableColumns.addEventListener('dragover', handleDragOver);
            availableColumns.addEventListener('dragenter', handleDragEnter);
            availableColumns.addEventListener('dragleave', handleDragLeave);
            availableColumns.addEventListener('drop', handleDrop);
            
            // Selected columns container events
            selectedColumns.addEventListener('dragover', handleDragOver);
            selectedColumns.addEventListener('dragenter', handleDragEnter);
            selectedColumns.addEventListener('dragleave', handleDragLeave);
            selectedColumns.addEventListener('drop', handleDrop);
        }

       

        // Drag end handler
        function handleDragEnd() {
            // Remove dragging class from all items
            document.querySelectorAll('.column-item.dragging').forEach(item => {
                item.classList.remove('dragging');
            });
            
            draggedItems = [];
            
            // Remove drag-over class from all containers
            document.querySelectorAll('.column-list').forEach(container => {
                container.classList.remove('drag-over');
            });
        }
let draggedItem = null;

 // Drag start handler - modified for multi-select
		
        function handleDragStart(e) {
            const item = this;
            const container = item.parentNode;
            const selectedCheckboxes = container.querySelectorAll('.column-checkbox:checked'); 
            if (selectedCheckboxes.length > 1) {
                // Multi-select drag
                draggedItems = Array.from(selectedCheckboxes).map(checkbox => 
                    checkbox.closest('.column-item')
                );
                // Add dragging class to all selected items
                draggedItems.forEach(draggedItem => {
                    draggedItem.classList.add('dragging');
                });
                 // Store data for all dragged items
				draggedItems.forEach(el => el.classList.add('dragging'));
                e.dataTransfer.setData('text/plain', 'multiple');
                e.dataTransfer.effectAllowed = 'move';
            } else {
					draggedItems = Array.from(selectedCheckboxes).map(checkbox => 
                    checkbox.closest('.column-item')
					);
                
					// Add dragging class to all selected items
					draggedItems.forEach(draggedItem => {
						draggedItem.classList.add('dragging');
					});
					// Single item drag
					draggedItems = [item]; 
					item.classList.add('dragging');
					e.dataTransfer.setData('text/plain', item.querySelector('.column-checkbox').dataset.value);
					
            }
			draggedItem = item;
			e.dataTransfer.setData('text/plain', 'dragged');
			e.dataTransfer.setData('text/plain', 'multiple');
			e.dataTransfer.effectAllowed = 'move';
        }


        // Drag over handler, now includes logic to highlight drop position
function handleDragOver(e) {
    e.preventDefault();
    const dropTarget = e.target.closest('.column-item');
    const container = e.target.closest('.column-list');

    // Only proceed if dragging an item and over a container
    if (!draggedItem || !container) {
        return;
    }

    const containerId = container.id;
    const isWithinSameContainer = (containerId === draggedItem.parentNode.id);

    // If dragging within the same container, handle sorting logic
    if (isWithinSameContainer) {
        const afterElement = getDragAfterElement(container, e.clientY);
        if (afterElement == null) {
            container.appendChild(draggedItem);
			 
        } else {
            container.insertBefore(draggedItem, afterElement);
        }
    } else {
        // Existing logic for moving between containers
        e.dataTransfer.dropEffect = 'move';
    } 
}

        // Drag enter handler
        function handleDragEnter(e) {
            e.preventDefault();
            this.classList.add('drag-over');
        }

        // Drag leave handler
        function handleDragLeave() {
            this.classList.remove('drag-over');
        }

		// Function to determine where to drop the element for sorting
		function getDragAfterElement(container, y) {
			const draggableElements = [...container.querySelectorAll('.column-item:not(.dragging)')];

			return draggableElements.reduce((closest, child) => {
				const box = child.getBoundingClientRect();
				const offset = y - box.top - box.height / 2;
				if (offset < 0 && offset > closest.offset) {
					return { offset: offset, element: child };
				} else {
					return closest;
				}
			}, { offset: Number.NEGATIVE_INFINITY }).element;
		}


        // Drop handler - modified for multi-select
        function handleDrop(e) {
			e.preventDefault();
			this.classList.remove('drag-over');
		if (draggedItems.length > 0) {
                const isTargetAvailable = this === availableColumns;
                const isTargetSelected = this === selectedColumns;
                const isSourceAvailable = draggedItems[0].parentNode === availableColumns;
                const isSourceSelected = draggedItems[0].parentNode === selectedColumns;
                
                // Only allow moving from available to selected or vice versa
                if ((isSourceAvailable && isTargetSelected) || 
                    (isSourceSelected && isTargetAvailable)) {
                    // Move all dragged items
                    draggedItems.forEach(item => {
                        // Uncheck the item before moving it
                        const checkbox = item.querySelector('.column-checkbox');
                        if(checkbox) checkbox.checked = false;
                        // Append the item to the new container
                        this.appendChild(item);
						// Track which template this field came from
                if (selectedTemplate) {
                    selectedFieldsHistory[checkbox.dataset.value] = {
                        hotel: selectedHotel,
                        template: selectedTemplate
                    };
                }
                    });
               
					if (selectedHotel && selectedTemplate) {
                handleTemplateSelection();
            }  
                    updateCounts();
                    updateButtonStates();
                }
            }
			
			const targetContainer = this;
			  const sourceContainer = draggedItems[0].parentNode;

			// Check if the drop is in the same container (for sorting)
			if (targetContainer === sourceContainer) {
				// The sorting has already been handled by the dragover event
				// No need to do anything here except cleanup
			} else {
				// Original logic for moving items between containers
				const isTargetAvailable = targetContainer === availableColumns;
				const isTargetSelected = targetContainer === selectedColumns;
				const isSourceAvailable = sourceContainer === availableColumns;
				const isSourceSelected = sourceContainer === selectedColumns;
				if ((isSourceAvailable && isTargetSelected) || (isSourceSelected && isTargetAvailable)) {
					// Uncheck the item before moving it
					const checkbox = draggedItem.querySelector('.column-checkbox');
					if(checkbox) checkbox.checked = false;
					
					// Append the item to the new container
					targetContainer.appendChild(draggedItem);
                if (selectedTemplate) {
                    selectedFieldsHistory[checkbox.dataset.value] = {
                        hotel: selectedHotel,
                        template: selectedTemplate
                    };
                }
				}
			}
			if (selectedHotel && selectedTemplate) {
                handleTemplateSelection();
            }
			draggedItem.classList.remove('dragging');
			draggedItem = null;
			
			updateCounts();
            updateButtonStates();
            let leftSearchElement = document.getElementById('left-search');
            let mockEvent = {
            target: {
                            value: leftSearchElement ? leftSearchElement.value : '',// The search term you want to use
                            id: 'left-search'      // The specific ID to trigger isLeftSearch = true
                        }
                    };

        // 3. Call the function with the mock event
        filterColumns(mockEvent); 

          leftSearchElement = document.getElementById('right-search');
             mockEvent = {
            target: {
                            value: leftSearchElement ? leftSearchElement.value : '',// The search term you want to use
                            id: 'right-search'      // The specific ID to trigger isLeftSearch = true
                        }
                    };

        // 3. Call the function with the mock event
        filterColumns(mockEvent); 

			
		}
        // Update button states based on selection
        function updateButtonStates() {
            const availableSelected = availableColumns.querySelectorAll('.column-checkbox:checked');
            const selectedSelected = selectedColumns.querySelectorAll('.column-checkbox:checked');
            
            addBtn.disabled = availableSelected.length === 0;
            removeBtn.disabled = selectedSelected.length === 0;
            removeAllBtn.disabled = selectedColumns.children.length === 0;
            
            // Generate JSON button is enabled if there are selected columns
            generateJsonBtn.disabled = selectedColumns.children.length === 0;
        }

        // Update the count of available and selected items
        function updateCounts() {
            availableCount.textContent = availableColumns.children.length;
            selectedCount.textContent = selectedColumns.children.length;
        }

        // Add selected columns to right side
        function addSelected() {
            const selected = availableColumns.querySelectorAll('.column-checkbox:checked');
            
            selected.forEach(checkbox => {
                const item = checkbox.closest('.column-item');
                // Uncheck the item
                checkbox.checked = false;
                selectedColumns.appendChild(item);
                
                // Track which template this field came from
                if (selectedTemplate) {
                    selectedFieldsHistory[checkbox.dataset.value] = {
                        hotel: selectedHotel,
                        template: selectedTemplate
                    };
                }
            });
            
            // Refresh available columns to remove the added items
            if (selectedHotel && selectedTemplate) {
                handleTemplateSelection();
            }
            
            updateButtonStates();
            updateCounts();
            leftSearch.value = '';
        }

        // Add all columns to right side .column-checkbox:checked
        function addAll() {
            availableColumns.querySelectorAll('.column-item').forEach(div => {
            if (div.style.display.trim() !== 'none') {
                const checkbox = div.querySelector('.column-checkbox');
                if (checkbox) {
                checkbox.checked = true; // sets it as checked
                }
            }
            });

            // update the availableColumns variable with modified HTML
           // availableColumns.innerHTML = doc.body.innerHTML;
            //// console.log('availableColumns:>addAll:>>>',availableColumns);
            leftSearch.value = '';
            addSelected();

/*
            const allItems = availableColumns.querySelectorAll('.column-item');
            
            allItems.forEach(item => {
                // Uncheck the item
                const checkbox = item.querySelector('.column-checkbox');
                if(checkbox) checkbox.checked = false;
                selectedColumns.appendChild(item);
                
                // Track which template this field came from
                if (selectedTemplate) {
                    selectedFieldsHistory[checkbox.dataset.value] = {
                        hotel: selectedHotel,
                        template: selectedTemplate
                    };
                }
            });
            
            // Clear available columns since we added all
            availableColumns.innerHTML = '';
            
            updateCounts();
            updateButtonStates();
            */
        }

        // Remove selected columns from right side
        function removeSelected() {
            const selected = selectedColumns.querySelectorAll('.column-checkbox:checked');
            
            selected.forEach(checkbox => {
                const item = checkbox.closest('.column-item');
                // Uncheck the item
                checkbox.checked = false;
                
                // Remove from history
                delete selectedFieldsHistory[checkbox.dataset.value];
                
                // If the current template is the one this field came from, add it back to available
                const fieldOrigin = selectedFieldsHistory[checkbox.dataset.value];
                if (fieldOrigin && 
                    fieldOrigin.hotel === selectedHotel && 
                    fieldOrigin.template === selectedTemplate) {
                    availableColumns.appendChild(item);
                } else {
                    // Otherwise, just remove it from selected
                    item.remove();
                }
            });
            
            updateButtonStates();
            updateCounts();
            
            // Refresh available columns if we have a template selected
            if (selectedHotel && selectedTemplate) {
                handleTemplateSelection();
            }
        }

        // Remove all columns from right side
        function removeAll() {

             selectedColumns.querySelectorAll('.column-item').forEach(div => {
            if (div.style.display.trim() !== 'none') {
                const checkbox = div.querySelector('.column-checkbox');
                if (checkbox) {
                checkbox.checked = true; // sets it as checked
                }
            }
            });

            // update the availableColumns variable with modified HTML
           // availableColumns.innerHTML = doc.body.innerHTML;
            //// console.log('availableColumns:>addAll:>>>',availableColumns);
            
            removeSelected();
            rightSearch.value = '';
            /*
            const allItems = selectedColumns.querySelectorAll('.column-item');
            
            allItems.forEach(item => {
                // Uncheck the item
                const checkbox = item.querySelector('.column-checkbox');
                if(checkbox) checkbox.checked = false;
                
                // Remove from history
                delete selectedFieldsHistory[checkbox.dataset.value];
                
                // If the current template is the one this field came from, add it back to available
                const fieldOrigin = selectedFieldsHistory[checkbox.dataset.value];
                if (fieldOrigin && 
                    fieldOrigin.hotel === selectedHotel && 
                    fieldOrigin.template === selectedTemplate) {
                    availableColumns.appendChild(item);
                }
            });
            
            // Clear selected columns
            selectedColumns.innerHTML = '';
            
            updateButtonStates();
            updateCounts();
            
            // Refresh available columns if we have a template selected
            if (selectedHotel && selectedTemplate) {
                handleTemplateSelection();
            }
            */
        }


function buildSQLFromJSON(data) {
  const colsByTable = {};
  const hotelIds = {};
  const colMeta = {};
  getAllQualifiers();
var qualifr_coval ;
  // Group normal columns by table
  data.selectedColumns.forEach(col => {
    if (col.temp_name !== "Strategy_Column" && col.temp_name !== "Price_Override" && col.temp_name !== "Hotel_Occupancy" &&
        col.temp_name !== "Global_Attributes") {
      if (!colsByTable[col.db_object_name]) {
        colsByTable[col.db_object_name] = [];
        hotelIds[col.db_object_name] = col.hotel_id;
      }
      colsByTable[col.db_object_name].push(col.col_name);

      if (!colMeta[col.db_object_name]) {
        colMeta[col.db_object_name] = {};
      }
      colMeta[col.db_object_name][col.col_name] = col.temp_name;
    }
  });

  // Collect ALL strategy columns
  const strategyCols = data.selectedColumns.filter(c => c.temp_name === "Strategy_Column");
  const price_or_cols = data.selectedColumns.filter(c => c.temp_name === "Price_Override");
  const hotelOccupancyCols = data.selectedColumns.filter(c => c.temp_name === "Hotel_Occupancy");
  const globalAttrCols = data.selectedColumns.filter(c => c.temp_name === "Global_Attributes");
  const hotelId = data.selectedColumns.find(c => c.hotel_id)?.hotel_id || '';
console.log('globalAttrCols:>>>>>>>>>>>>>',globalAttrCols);
  const tables = Object.keys(colsByTable);
  const aliases = tables.map((t, i) => "t" + (i + 1) + "_rn");

  // Build CTEs for normal tables
  const ctes = tables.map((table, i) => {
    const cols = colsByTable[table];
    const orderCol = cols[0];
    const alias = aliases[i];
    // console.log('cols:>>>>>',cols);
 
    var qualifr_col = hotel_qualifiers.data.find(item => item.temp_name === table);
     qualifr_coval = qualifr_col.name
    //hotel_id, ${[...cols, ...(cols.includes("STAY_DATE") ? [] : ["STAY_DATE"])].join(", ")},
    return `${alias} AS (
  SELECT hotel_id, ${[
        ...cols,
         `${qualifr_coval} as pk_col` 
      ].join(", ")},
         ROW_NUMBER() OVER (PARTITION BY hotel_id ORDER BY ${orderCol}) rn
  FROM ${table}
  WHERE hotel_id = '${hotelIds[table]}'
)`;
  });

  // Build one CTE per strategy column
  strategyCols.forEach((sc, i) => {
    const alias = `s${i + 1}_rn`;
    ctes.push(`${alias} AS (
  SELECT 
      t.STAY_DATE as pk_col,
      t.EVALUATED_PRICE,
      a.name,
      a.hotel_id AS hotel_id,
      ROW_NUMBER() OVER (PARTITION BY a.id ORDER BY STAY_DATE) rn
  FROM (
      SELECT id, name,hotel_id
      FROM ur_algos
      WHERE hotel_id = '${hotelId}'
      ORDER BY id DESC
  ) a,
  TABLE(
      ALGO_EVALUATOR_PKG.EVALUATE(a.id, NULL)
  ) t
  WHERE a.name LIKE '${sc.col_name}'
)`);
  });


    price_or_cols.forEach((sc, i) => {
    const alias = `por${i + 1}_rn`;
    ctes.push(`${alias} AS (
 select STAY_DATE as pk_col, PRICE,hotel_id,
 ROW_NUMBER() OVER (PARTITION BY id ORDER BY STAY_DATE) rn
 from UR_HOTEL_PRICE_OVERRIDE
  where hotel_id = '${hotelId}'
  and status = 'A'
  and upper(type) = upper('${sc.col_name}')
  )`);
  });

  // Build CTE for Hotel_Occupancy (single hotel-level value)
  hotelOccupancyCols.forEach((hc, i) => {
    const alias = `occ${i + 1}_rn`;
    ctes.push(`${alias} AS (
  SELECT ID as hotel_id, CAPACITY,
         1 as rn
  FROM UR_HOTELS
  WHERE ID = '${hotelId}'
)`);
  });

    // Build CTE for each Global_Attribute (uses attribute_id to fetch calculated values)
  globalAttrCols.forEach((gc, i) => {
    const alias = `ga${i + 1}_rn`;
    ctes.push(`${alias} AS (
  SELECT
      '${hotelId}' as hotel_id,
      t.STAY_DATE as pk_col,
      t.attribute_value,
      ROW_NUMBER() OVER (ORDER BY t.STAY_DATE) as rn
  FROM TABLE(
      ur_utils.GET_ATTRIBUTE_VALUE(
          p_attribute_id => '${gc.attribute_id}',
          p_hotel_id => '${hotelId}',
          p_stay_date => NULL
      )
  ) t
)`);
  });

  // Build SELECT list
  const selectCols = [];

  // Regular tables
  tables.forEach((table, i) => {
    colsByTable[table].forEach(col => {
      const tempName = colMeta[table][col];
      const isNumberType = data.selectedColumns.some(
        selCol => selCol.col_name === col && selCol.temp_name === tempName && selCol.data_type && selCol.data_type.toLowerCase() === 'number'
      );
      if (isNumberType) {
        selectCols.push(`ROUND(${aliases[i]}.${col}, 2) AS "${col} - ${tempName}"`);
      } else {
        selectCols.push(`${aliases[i]}.${col} AS "${col} - ${tempName}"`);
      }
    });
  });

  // Add all strategy columns
  strategyCols.forEach((sc, i) => {
    const alias = `s${i + 1}_rn`;
    selectCols.push(`${alias}.EVALUATED_PRICE AS "${sc.col_name} - Strategy_Column"`);
  });
  

  price_or_cols.forEach((sc, i) => {
    const alias = `por${i + 1}_rn`;
    selectCols.push(`${alias}.PRICE AS "${sc.col_name} - Price_Override"`);
  });

  // Add Hotel_Occupancy columns (single value per hotel)
  hotelOccupancyCols.forEach((hc, i) => {
    const alias = `occ${i + 1}_rn`;
    selectCols.push(`${alias}.CAPACITY AS "${hc.col_name} - Hotel_Occupancy"`);
  });

  // Add Global_Attributes columns
  globalAttrCols.forEach((gc, i) => {
    const alias = `ga${i + 1}_rn`;
    selectCols.push(`${alias}.attribute_value AS "${gc.col_name} - Global_Attributes"`);
  });

  // Build final FROM + JOIN logic
//  const allAliases = [...aliases, ...strategyCols.map((_, i) => `s${i + 1}_rn`)];

 //  const allAliases = [...aliases, ...strategyCols.map((_, i) => `s${i + 1}_rn`), ...price_or_cols.map((_, i) => `por${i + 1}_rn`), ...hotelOccupancyCols.map((_, i) => `occ${i + 1}_rn`)];
 const allAliases = [
       ...aliases,
      // ...strategyCols.map((_, i) => `s${i + 1}_rn`),
     //  ...price_or_cols.map((_, i) => `por${i + 1}_rn`),
     //  ...hotelOccupancyCols.map((_, i) => `occ${i + 1}_rn`),
       ...globalAttrCols.map((_, i) => `ga${i + 1}_rn`)
   ];

    const selectallAliases = [
       ...aliases
      // ...strategyCols.map((_, i) => `s${i + 1}_rn`),
     //  ...price_or_cols.map((_, i) => `por${i + 1}_rn`),
     //  ...hotelOccupancyCols.map((_, i) => `occ${i + 1}_rn`),
     // ...globalAttrCols.map((_, i) => `ga${i + 1}_rn`)
   ];
//   const joinClauses = allAliases.slice(1).map((alias, i) =>
//     `FULL OUTER JOIN ${alias}
//       ON ${allAliases[0]}.hotel_id = ${alias}.hotel_id
//      AND ${allAliases[0]}.pk_col = ${alias}.pk_col`
//   );

// const joinClauses = allAliases.slice(1).map((alias, i) => {
//   // Use LEFT JOIN for strategy columns and hotel occupancy (optional data)
//   const joinType = (alias.startsWith('s') || alias.startsWith('occ')|| alias.startsWith('por')) ? ' LEFT ' : 'FULL OUTER';

//   // Hotel_Occupancy has no pk_col (single value per hotel), join only on hotel_id
//   if (alias.startsWith('occ')) {
//     return `${joinType} JOIN ${alias}
//       ON ${allAliases[0]}.hotel_id = ${alias}.hotel_id`;
//   }

//   return `${joinType} JOIN ${alias}
//       ON ${allAliases[0]}.hotel_id = ${alias}.hotel_id
//      AND ${allAliases[0]}.pk_col = ${alias}.pk_col`;
// });


const joinClauses = allAliases.slice(1).map((alias, i) => {
  // Use LEFT JOIN for strategy columns, hotel occupancy, price override, and global attributes (optional data)
  const joinType = (alias.startsWith('ga')) ? ' LEFT ' : 'FULL OUTER';
 

  // All other tables including Global_Attributes have pk_col (STAY_DATE), join on both hotel_id and pk_col
  return `${joinType} JOIN ${alias}
      ON ${allAliases[0]}.hotel_id = ${alias}.hotel_id
     AND ${allAliases[0]}.pk_col = ${alias}.pk_col`;
});

  const finalSelect = `SELECT COALESCE(${selectallAliases.map(a => a + ".hotel_id").join(", ")}, null) AS hotelid,
  COALESCE(${allAliases.map(a => a + ".pk_col").join(", ")}, null) AS pk_col,
       ${selectCols.join(",\n       ")}
FROM ${allAliases[0]}
${joinClauses.join("\n")}
ORDER BY COALESCE(${allAliases.map(a => a + ".rn").join(", ")}, 0)`;

  const sql = `WITH ${ctes.join(",\n")}\n${finalSelect}`;

   console.log("✅ FINAL SQL:\n", sql);
  return sql;
}




function create_report(sqldata) { 
                const newReportInput = document.getElementById('New-Report');
                const reportName = newReportInput.value.trim();
                if (!reportName) {
                    alert('Please enter a name for the new report before saving.');
                    newReportInput.focus();
                    return;
                }

                // Validate report name: only letters and numbers (no spaces, no special characters, no underscores)
                const validNameRegex = /^[A-Za-z0-9]+$/;
                if (!validNameRegex.test(reportName)) {
                    alert('Invalid report name. Only alphabets and numbers are allowed, no spaces, no underscores, and no special characters.');
                    newReportInput.focus();
                    return;
                }

                const selectedcols = Array.from(
            document.querySelectorAll("#selected-columns .column-checkbox")
            );
        const mainValues = selectedcols.map(el => el.dataset.value);


             console.log('JSON.stringify(jsondata_main):>',JSON.stringify(jsondata_main));
             console.log('sqldata:>'+sqldata);
             console.log('hotelLov.options[hotelLov.selectedIndex].value:>'+hotelLov.options[hotelLov.selectedIndex].value);
             console.log('$(#New-Report).val():>'+$('#New-Report').val());
            jsondata_details =  JSON.parse((JSON.stringify(jsondata_main)));
            apex.server.process(
                'AJX_MANAGE_REPORT_VIEW',
                { x01: sqldata
                  ,x02: mainValues.join(",") 
                  ,x03: hotelLov.options[hotelLov.selectedIndex].value
                  ,x04: $('#New-Report').val()
                  ,x05: JSON.stringify(jsondata_main)
                  },
                {
                    success: function(data) {
                            showSuccessMessage(`View ${ data[0].l_message } saved successfully`);
                             console.log('data:>>>>',data);
                            //showSuccessMessage(`Column header updated to: ${newHeader}`);

                            // Save expressions/configuration after report is created
                            saveAllDataToJSON();

                            call_dashboard_data(data[0].l_report_id);
                           // handleHotelSelection();
                        //    const reportLov = document.getElementById('report-lov');

                        //     const newOption = document.createElement('option');

                        //     newOption.value = data[0].l_report_id;
                        //     newOption.text = document.getElementById('New-Report').value; // Use pure JS to get value
                        //     newOption.title = mainValues.join(",");

                        //     reportLov.appendChild(newOption);

                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('AJAX Error::>>>'+ errorThrown );
                    }
                }
            );
        } 
        var jsondata_main;
        var jsondata_details;
function generateJson() {  

            // console.log('generateJson triggered');

            const columns = Array.from(
				selectedColumns.querySelectorAll('.column-checkbox')
			).map(item => {
				const rawName = item.dataset.value.split('(')[0].trim();
				const tempName = item.dataset.value.substring(
					item.dataset.value.indexOf('(') + 1,
					item.dataset.value.indexOf(')')
				).trim();

				const match = hotelTemplates.find(t => t.temp_name === tempName);

				// Find if this column already exists in report_expressions.columnConfiguration.selectedColumns
				let existing = null;
				if (
					report_expressions &&
					report_expressions.columnConfiguration &&
					Array.isArray(report_expressions.columnConfiguration.selectedColumns)
				) {
					existing = report_expressions.columnConfiguration.selectedColumns.find(sc => 
						sc.col_name === rawName && sc.temp_name === tempName
					);
				}

				if (tempName === 'Global_Attributes') {
                    // Extract the attribute name from the formatted string
                    const attrName = item.dataset.value.split('(')[0].trim(); 
                    // Find the attribute ID from hotelData.templates.Global_Attributes
                    const hotelKey = selectedHotel.toLowerCase().replace(/\s+/g, '');
                    const globalAttrs = hotelData[hotelKey].templates.Global_Attributes || [];
                    const attrMatch = globalAttrs.find(a => a.name === attrName);

                    return {
                        col_name: attrName,
                        temp_name: 'Global_Attributes',
                        db_object_name: 'UR_ALGO_ATTRIBUTES',
                        alias_name: attrName,
                        attribute_id: attrMatch ? attrMatch.id : null,
                        hotel_id: hotelLov.options[hotelLov.selectedIndex].value,
                    };
                }

				// If existing config found, return its values
				if (existing) {
					return {
						col_name: existing.col_name,
						temp_name: existing.temp_name,
						db_object_name: existing.db_object_name,
						alias_name: existing.alias_name,
						hotel_id: existing.hotel_id,
					};
				}

				// Otherwise fall back to default logic
				return {
					col_name: rawName,
					temp_name: tempName,
					db_object_name: match ? match.db_object_name : null,
					alias_name: rawName,
					hotel_id: match ? match.hotel_id : null,
				};
			});
            
            if (columns.length === 0) {
                alert("Please select at least one column first!");
                return;
            }
            
            const jsonData = {
                hotel: hotelData[selectedHotel].name,
                template: selectedTemplate,
                selectedColumns: columns
            };
            
           // jsonOutput.textContent = JSON.stringify(jsonData, null, 2);
           // jsonOutput.style.display = 'block';
            
          
            
            jsondata_main = jsonData;
            // console.log('jsondata_main:>>>>>>>>',jsondata_main);
        
            loadTempColDetails();
            
          //  saveAllDataToJSON();
        
        }

        // Filter columns based on search input
        function filterColumns(e) {
            const searchTerm = e.target.value.toLowerCase();
            const isLeftSearch = e.target.id === 'left-search';
            const container = isLeftSearch ? availableColumns : selectedColumns;
            
            Array.from(container.children).forEach(item => {
                const text = item.querySelector('label').textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
            // console.log('container:>>>>>',container);
        }
        
        // Sort columns in a container
        function sortColumns(container, ascending = true) {
            const items = Array.from(container.children);
            
            items.sort((a, b) => {
                const textA = a.querySelector('label').textContent.toLowerCase();
                const textB = b.querySelector('label').textContent.toLowerCase();
                
                if (textA < textB) {
                    return ascending ? -1 : 1;
                }
                if (textA > textB) {
                    return ascending ? 1 : -1;
                }
                return 0;
            });
    
            // Clear the container
            container.innerHTML = '';
            
            // Re-append items in the new sorted order
            items.forEach(item => container.appendChild(item));
        }

        // Reset the selection
        function resetSelection() {
            hotelLov.selectedIndex = 0;
            
            templateLov.innerHTML = '<option value="">-- Select Hotel First --</option>';
            templateLov.disabled = true;
            availableColumns.innerHTML = '';
            selectedColumns.innerHTML = '';
            leftSearch.value = '';
            rightSearch.value = '';
            jsonOutput.style.display = 'none';
            selectedFieldsHistory = {};
            currentTemplateInfo.textContent = 'Current template: None';
           
            // Update counts and button states
            updateCounts();
            updateButtonStates();
             apex.server.process(
                'AJX_MANAGE_REPORT_VIEW',
                { x01: 'DELETE'
                  ,x02: $('#report-lov').val() 
                  },
                {
                    success: function(data) { 
                            alert("Report deleted successfully!");
                        
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('AJAX Error:'+ errorThrown );
                    }
                }
            );
            const reportLov = document.getElementById("report-lov"); 
            reportLov.innerHTML = '<option value="">-- Select Hotel --</option>';
            const dashboard = document.querySelector('.data-dashboard-wrapper');
            if (dashboard) {
                dashboard.style.display = 'none';
            }


        }

        function addTextDataType(enrichTargetWithDataType) {
    // Create a deep copy to avoid mutating the original object
    const result = JSON.parse(JSON.stringify(enrichTargetWithDataType));
    
    // Iterate through selectedColumns and add data_type: "TEXT" where data_type is null
    result.selectedColumns.forEach(column => {
        if (column.data_type === null) {
            column.data_type = "NUMBER";
        }
    });
    
    return result;
}

         function loadTempColDetails() {

                apex.server.process(
                    "AJX_GET_TEMP_COL_DETAILS", // Ajax Callback name
                        { x01: hotelLov.options[hotelLov.selectedIndex].text },    // pass hotel name
                    {
                        dataType: "json",
                        success: function(data) {
                            // console.log("AJX_GET_TEMP_COL_DETAILS JSON:", data);

                            const enrichedJSON = enrichTargetWithDataType(data, jsondata_main);
                            jsondata_main = enrichedJSON;
                            // console.log('enrichTargetWithDataType-------------===============>>>>>>>>>',enrichedJSON);
                            jsondata_main =  addTextDataType(jsondata_main);
                            const sql = buildSQLFromJSON(enrichedJSON);
                            // console.log('sql:>>>>',sql);

                            // create_report() is async - saveAllDataToJSON is now called inside its success callback
                            create_report(sql);
                        },
                        error: function(xhr, status, error) {
                            console.error("Error fetching hotel templates:", error);
                        }
                    }
                );
            }

            // function enrichTargetWithDataType(JSON_Source, JSONTarget) {
            //     // Build lookup map: template -> column -> data_type
            //     const templateColumnType = {};
            //     const hotelKey = Object.keys(JSON_Source)[0]; // get hotel key dynamically
            //     const templates = JSON_Source[hotelKey].templates;

            //     for (const [templateName, columns] of Object.entries(templates)) {
            //         templateColumnType[templateName] = {};
            //         columns.forEach(col => {
            //             const [col_name, data_type] = col.split('#');
            //             templateColumnType[templateName][col_name] = data_type;
            //         });
            //     }

            //     // Add data_type to each selected column
            //     JSONTarget.selectedColumns.forEach(colInfo => {
            //         const template = colInfo.temp_name;
            //         const colName = colInfo.col_name;
            //         colInfo.data_type = templateColumnType[template]?.[colName] || null;
            //     });

            //     return JSONTarget;
            // }

            function enrichTargetWithDataType(JSON_Source, JSONTarget) {
    // Build lookup map: template -> column -> data_type
    const templateColumnType = {};
    const hotelKey = Object.keys(JSON_Source)[0]; // get hotel key dynamically
    const templates = JSON_Source[hotelKey].templates;

    // Build dictionary of template → column → data_type
    for (const [templateName, columns] of Object.entries(templates)) {
        templateColumnType[templateName] = {};
        columns.forEach(col => {
            const [col_name, data_type] = col.split('#').filter(Boolean);
            templateColumnType[templateName][col_name] = data_type;
        });
    }

    // Enrich selectedColumns with data_type
    JSONTarget.selectedColumns.forEach(colInfo => {
        const template = colInfo.temp_name;
        const colName = colInfo.col_name;

        // Hotel_Occupancy is always NUMBER type (room capacity count)
        if (template === 'Hotel_Occupancy') {
            colInfo.data_type = 'NUMBER';
            return;
        }

        // Find the right data_type for this template/column combo
        const dataType =
            templateColumnType[template]?.[colName] ??
            null;

        colInfo.data_type = dataType;
    });

    return JSONTarget;
}


function safeParseReportExpressions(data) {
    // If it's already a valid object with expected structure, return it
    if (data && typeof data === 'object' && data.columnConfiguration) {
        // console.log('Using existing object structure');
        return data;
    }
    
    // If it's a string, try to parse it
    if (typeof data === 'string') {
        try {
            const parsed = JSON.parse(data);
            // console.log('Successfully parsed from string');
            return parsed;
        } catch (error) {
            console.error('Failed to parse JSON string:', error);
        }
    }
    
    // Return default structure for all other cases
    // console.log('Using default structure');
    return {
        "columnConfiguration": {
            "hotel": "Hotel",
            "template": "All",
            "selectedColumns": []
        },
        "columnMetadata": [],
        "formulas": {},
        "filters": {},
        "conditionalFormatting": {}
    };
}

function forceShowDashboard() {
    const dashboard = document.querySelector('.data-dashboard-wrapper');
    const button = document.getElementById('toggleDashboardBtn');
    
    // Forcefully set to visible
    dashboard.style.display = 'block'; // or 'flex' depending on your layout
    
    // Update button text
    if (button) {
        button.textContent = 'Hide Dashboard';
    }
    
    // console.log('Dashboard forcefully shown');
}

function enrichTargetColumnAliasWithDataType(source, targetData) {
    // Build a quick lookup: alias_name -> data_type
    const sourceTypeMap = {};
    source.selectedColumns.forEach(col => {
        sourceTypeMap[col.alias_name] = col.data_type;
    });

    // Iterate over each target object
    targetData.forEach(target => {
        if (!target.COLUMN_ALIAS) return;

        // Parse COLUMN_ALIAS JSON
        let aliasObj;
        try {
            aliasObj = JSON.parse(target.COLUMN_ALIAS);
        } catch (e) {
            console.warn("Invalid COLUMN_ALIAS JSON in target:", target.ID);
            return;
        }

        // Enrich each selectedColumn with data_type (if found in source)
        aliasObj.selectedColumns.forEach(col => {
            const matchType = sourceTypeMap[col.alias_name] || sourceTypeMap[col.col_name] || null;
            if (matchType) col.data_type = matchType;
        });

        // Replace the COLUMN_ALIAS JSON string with updated one
        target.COLUMN_ALIAS = JSON.stringify(aliasObj);
    });

    return targetData;
}



let col_alias;
let report_expressions;
let formattor_json;
let formula_filter_json;

function call_dashboard_data(selectedReport_Id){

    apex.server.process(
        "AJX_GET_REPORT_HOTEL",
        { 
            x01: 'REPORT_DETAIL',
            x02: selectedReport_Id           
        },
        {
            dataType: "json",
            success: function(data) {
                // console.log('Report data received for tab:', data);
   if (!jsondata_main || !jsondata_main.selectedColumns) {
       console.warn('jsondata_main is not ready or lacks selectedColumns, skipping enrichment');
   } else {
       enrichTargetColumnAliasWithDataType(jsondata_main,data);
   }
                let reportCol;
                let db_ob_name;  
                data.forEach(function(report) {
                    reportCol = report.DEFINITION_JSON; 
                    db_ob_name = report.DB_OBJECT_NAME;
                    alias_name = report.COLUMN_ALIAS;
                    report_expressions = report.EXPRESSIONS_CLOB;
                }); 
                // console.log('report_expressions:>>>>', report_expressions);
                // console.log('alias_name:>>>>', alias_name); 
              let   parsedExpressions = safeParseReportExpressions(report_expressions);
            // Parse the report_expressions string into JSON
            try {
                 
                parsedExpressions = parsedExpressions;

                 console.log('Parsed expressions:', parsedExpressions);

                } catch (error) {
                    
                    console.error('Error parsing report_expressions:', error);
                    return;
                }

            // Assign TEMP_FORMATTING_JSON from conditionalFormatting
             TEMP_FORMATTING_JSON = parsedExpressions.conditionalFormatting || {};
            
            // Build INITIAL_CONFIG_JSON from parsed expressions
             INITIAL_CONFIG_JSON = {
                columnMetadata: parsedExpressions.columnMetadata || [],
                formulas: parsedExpressions.formulas || {},
                filters: parsedExpressions.filters || {},
                conditionalFormatting: parsedExpressions.conditionalFormatting || {},
                columnposition: parsedExpressions.columnposition || {}
            };

            savedFormulas = {};
            savedFilters = {};
            localStorage.removeItem('savedFilters');
            localStorage.removeItem('savedFormulas');  
            document.getElementById('filter-preview').value = '';
            document.getElementById('filter-name-input').value = '';
            loadSavedFilters();
            localStorage.clear(); 
            forceShowDashboard();
            
            // console.log('TEMP_FORMATTING_JSON:', TEMP_FORMATTING_JSON);
            // console.log('INITIAL_CONFIG_JSON:', INITIAL_CONFIG_JSON);
             
            conditionalFormattingRules = TEMP_FORMATTING_JSON;
       // loadDashboard (reporttblData);
            loadConditionalFormattingBlocks(); 


                let reportcolalias;
                if (alias_name) {
                try {
                        reportcolalias = JSON.parse(alias_name);
                        // console.log("Successfully parsed JSON:", reportcolalias);
                    } catch (error) {
                        console.error('Failed to parse JSON:', error);
                    }
                    } else {
                    // console.log("alias_name is null, undefined, or empty. Skipping JSON parsing.");
                    }

                const reportColObj = JSON.parse(reportCol);
               

                reportcolalias.selectedColumns.forEach(aliasColumn => {
                    // Find the corresponding object in reportColObj.selectedColumns
                    const reportColumn = reportColObj.selectedColumns.find(obj =>
                        obj.col_name === aliasColumn.col_name &&
                        obj.hotel_id === aliasColumn.hotel_id &&
                        obj.temp_name === aliasColumn.temp_name
                    );

                // If a matching object is found, update its alias_name
                        if (reportColumn) {
                            reportColumn.alias_name = aliasColumn.alias_name;
                        }
                    });

                reportcolalias.selectedColumns.forEach(aliasColumn => {
                // Find the corresponding object in reportColObj.selectedColumns
                        const reportColumn = reportColObj.selectedColumns.find(obj => obj.col_name === aliasColumn.col_name && obj.hotel_id === aliasColumn.hotel_id && obj.temp_name === aliasColumn.temp_name );
                     // If a matching object is found, update its properties
                        if (reportColumn) {
                                     reportColumn.alias_name = aliasColumn.alias_name;

                                // 1. Load VISIBILITY state
                                 reportColumn.visibility = aliasColumn.visibility || 'show';
                            
                            // 2. Load AGGREGATION state (NEW LINE)
                            reportColumn.aggregation = aliasColumn.aggregation || 'none';

                            // 3. Load DATA_TYPE state (essential for showColumnPopup)
                            reportColumn.data_type = aliasColumn.data_type;
                         }
                    });

                jsondata_details = reportColObj;
                loadSavedFormatters();
                // console.log('jsondata_details:>>>>>>>>>>>>>>>>>>>>>',jsondata_details);
                // Generate columns_list from the JSON data
           const columns_list = reportColObj.selectedColumns.map(item => ({
                                name: `${item.col_name} - ${item.temp_name}`,
                                type: item.data_type
                                    ? item.data_type.toLowerCase() === 'number' ? 'number'
                                    : item.data_type.toLowerCase() === 'date' ? 'date'
                                    : 'string'
                                    : 'string' // ✅ default to 'number' if data_type is null
                            }));
                
                tableColumns = columns_list;
                 console.log('Generated db_ob_name:', db_ob_name);
                  console.log('Updated reportColObj:>><><><><><>', JSON.stringify(columns_list));
//console.time("AJAX_Execution_Time:>TEMPLATE_REPORT_DATA");
             
                          
                apex.server.process(
                    "AJX_GET_REPORT_DATA",
                    { 
                        x01: 'TEMPLATE_REPORT_DATA',
                        x02: JSON.stringify(columns_list) ,
                        x03: db_ob_name
                    },
                    {
                        success: function(pData) {
                            // console.log('Table data received for tab:::>>>>>>', pData);
                            //  console.timeEnd("AJAX_Execution_Time:>TEMPLATE_REPORT_DATA");
                            
                                 
                                // Initialize table for the specific tab
                                reporttblData = pData;
                            // 1. Set the immutable source data
                            pristineReportData = JSON.parse(JSON.stringify(pData.rows));
                    
                                displayReportTable('call_dashboard_data');
                            initializeControls();
                            loadDashboard(pData);

                            populateFormatterColumnLov(); 
                            loadSavedFormatters();
                           // handleReportSelection();
                           // saveAllDataToJSON();
                             
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            console.error("Error fetching table data for tab "  + ":", textStatus, errorThrown);
                        }
                    }
                );
            },
            error: function(xhr, status, error) {
                console.error("Error fetching report details for tab "  + ":", error);
            }
        }
    );

}

function toggleDashboardVisibility() {
    const dashboard = document.querySelector('.data-dashboard-wrapper');
    const button = document.getElementById('toggleDashboardBtn'); // Assuming you have a button with this ID

    if (dashboard.style.display === 'none' || dashboard.style.display === '') {
        dashboard.style.display = 'block'; // Or 'flex', depending on its layout
        if (button) {
            button.textContent = 'Hide Dashboard';
        }
    } else {
        dashboard.style.display = 'none';
        if (button) {
            button.textContent = 'Show Dashboard';
        }
    }
}

let reporttblData ;
let currentColumn = '';

// Function to get column groups
function getColumnGroups() {
    const groups = new Set();
    
    // Use the potentially filtered/modified data from reporttblData
    if (!reporttblData.rows || reporttblData.rows.length === 0) {
        return [];
    }
    
    const firstRow = reporttblData.rows[0];
    
    for (const key in firstRow) {
        if (firstRow.hasOwnProperty(key)) {
            const parts = key.split(' - ');
            
            if (parts.length > 1) {
                // Standard grouped column: BASE_COL - GROUP
                groups.add(parts[1]);
            } else {
                // Calculated column: calcName (no hyphen)
                groups.add(CALCULATED_GROUP_NAME);
            }
        }
    }
    
    // Convert to Array. To ensure the calculation group is always last, we manually sort/position it.
    const groupArray = Array.from(groups).filter(g => g !== CALCULATED_GROUP_NAME);
    
    if (groups.has(CALCULATED_GROUP_NAME)) {
        groupArray.push(CALCULATED_GROUP_NAME);
    }

    return groupArray;
}

// Function to extract column names without group names
function getBaseColumnNames() {
    const baseColumns = new Set();
    
    if (!reporttblData.rows || reporttblData.rows.length === 0) {
        return [];
    }

    const firstRow = reporttblData.rows[0];

    for (const key in firstRow) {
        if (firstRow.hasOwnProperty(key)) {
            const parts = key.split(' - ');
            
            if (parts.length > 1) {
                // Standard grouped column: use BASE_COL
                baseColumns.add(parts[0]);
            } else {
                // Calculated column: use the full key (calcName)
                baseColumns.add(key);
            }
        }
    }
    
    return Array.from(baseColumns);
}

// Function to parse column name into col_name and temp_name
function parseColumnName(fullColumnName) {
    // console.log('fullColumnName:>>>>>', fullColumnName);

        const index = fullColumnName.indexOf(' - ');
        let col_name = fullColumnName;
        let temp_name = '';

        if (index !== -1) {
        col_name = fullColumnName.substring(0, index).trim();
        temp_name = fullColumnName.substring(index + 3).trim(); // +3 to skip ' - '
        }

        return {
        col_name,
        temp_name
        };
}

/**
 * Looks up the data type (e.g., 'number', 'string') from the global tableColumns array.
 */
function findDataTypeFromTableColumns(colName, tempName) {
        // console.log('tableColumns>>>>>',tableColumns);
    if (typeof tableColumns === 'undefined' || !Array.isArray(tableColumns)) {
        console.warn('tableColumns is not defined or is not an array.');
        return null;
    }
    
    // The key format in tableColumns is "COL_NAME - TEMP_NAME"
    const lookupName = `${colName} - ${tempName}`;

    const columnMetadata = tableColumns.find(col => col.name === lookupName);
    // console.log('tableColumns:>>>>>>>>>>>',columnMetadata);
    if (columnMetadata && columnMetadata.type) {
        // Convert to lowercase to be safe
        return columnMetadata.type.toLowerCase(); 
    }
    
    return null; 
}

function getColumnDataKey(column) {
    if (column.temp_name === 'calc') {
        return column.col_name; // Formula column: simple name (e.g., 'NetProfit')
    }
    return `${column.col_name} - ${column.temp_name}`; // Base column: composite key
}


// Function to show popup
function showColumnPopup(columnName) {
    currentColumn = columnName;
    document.getElementById('originalHeader').value = columnName;
    

    const columnInfo = parseColumnName(columnName);
    // This now works for formula columns thanks to the update above
    
   // const existingColumn = findColumnInJsonData(columnInfo.col_name, columnInfo.temp_name);
    const existingColumn = findColwithTemp(columnInfo.col_name, columnInfo.temp_name);
    // console.log('existingColumn:>>>>>>>',existingColumn);
    const aggregationGroup = document.getElementById('aggregation-group');
    const numericSelect = document.getElementById('numericAggregation');
    const dateSelect = document.getElementById('dateAggregation');
    
    if (!numericSelect || !dateSelect || !aggregationGroup) {
         console.error("ERROR: Missing Aggregation LOV elements in popup HTML.");
         document.getElementById('columnPopup').style.display = 'flex';
         return; 
    }
    
    numericSelect.style.display = 'none';
    dateSelect.style.display = 'none';
    aggregationGroup.style.display = 'none';
    let columnDataType = null; 
    let currentAlias = columnInfo.col_name;

    if (existingColumn) {
        columnDataType = existingColumn.data_type;
        currentAlias = existingColumn.alias_name || existingColumn.col_alias || columnInfo.col_name;
    }
 
   // if (!columnDataType || columnDataType.trim() === '' || columnDataType.trim().toUpperCase() !== 'NUMBER') {

        const fallbackType = findDataTypeFromTableColumns(columnInfo.col_name, columnInfo.temp_name);
        if (fallbackType) {
            columnDataType = fallbackType;
            if (existingColumn) {
                 existingColumn.data_type = columnDataType;
            }
        }
   // }
    
    // CRITICAL FIX LOGIC: This ensures formula columns show the LOV
    if (existingColumn && existingColumn.temp_name === 'calc') {
        columnDataType = 'number'; 
    }

    document.getElementById('newHeader').value = currentAlias;
   
    
     const currentVisibility = existingColumn ? existingColumn.visibility : 'show';
    if (currentVisibility === 'hide') {
        // If the stored value is 'hide', check the 'Hide' radio button
        visibilityHide.checked = true;
        visibilityShow.checked = false;
    } else {
        // Otherwise (if 'show' or null), check the 'Show' radio button
        visibilityShow.checked = true;
        visibilityHide.checked = false;
    }


    if (columnDataType === 'number') {
        aggregationGroup.style.display = 'flex'; 
        numericSelect.style.display = 'block'; 
        numericSelect.value = existingColumn ? existingColumn.aggregation || 'none' : 'none';
    } else if (columnDataType === 'date') {
        aggregationGroup.style.display = 'flex';
        dateSelect.style.display = 'block';
        dateSelect.value = existingColumn ? existingColumn.aggregation || 'none' : 'none';
    } else {
        aggregationGroup.style.display = 'none';
        if (existingColumn) existingColumn.aggregation = 'none';
    }
    
    document.getElementById('columnPopup').style.display = 'flex';
    setTimeout(() => {
        document.getElementById('newHeader').focus();
        document.getElementById('newHeader').select();
    }, 100);
}

// Function to find column in jsondata_details with null checks
function findColumnInJsonData(baseCol, template) {

    if (!jsondata_details || !jsondata_details.selectedColumns) {
        return null;
    }
    // For calculated columns
    if (template === CALCULATED_GROUP_NAME) {
        return jsondata_details.selectedColumns.find(col => 
            col.col_name === baseCol && col.temp_name === CALCULATED_GROUP_NAME
        );
    }
    
    // For regular columns - extract the essential template part
    // Assuming template format is like "CHG - Crowborough Arms - BETA"
    // and we want to match against just "CHG" or similar
    const templateParts = template.split(' - ');
    const essentialTemplate = templateParts[0]; // Take the first part as the essential template
    return jsondata_details.selectedColumns.find(col => 
        col.col_name === baseCol && col.temp_name === essentialTemplate
    );
}

function findColwithTemp(baseCol, template) {

    if (!jsondata_details || !jsondata_details.selectedColumns) {
        return null;
    }
    // For calculated columns
    if (template === CALCULATED_GROUP_NAME) {
        return jsondata_details.selectedColumns.find(col => 
            col.col_name === baseCol && col.temp_name === CALCULATED_GROUP_NAME
        );
    }
     
    return jsondata_details.selectedColumns.find(col => 
        col.col_name === baseCol && col.temp_name === template
    );
}



// Function to hide popup
function hideColumnPopup() {
    document.getElementById('columnPopup').style.display = 'none';
    currentColumn = '';
} 
// Function to handle save action
function handleSave() {
    const newHeader = document.getElementById('newHeader').value.trim();
    
    // NEW CODE: Get the selected visibility state (show or hide)
    const selectedVisibility = document.querySelector('input[name="columnVisibility"]:checked').value;
    let selectedAggregation = 'none';
    const numericSelect = document.getElementById('numericAggregation');
    const dateSelect = document.getElementById('dateAggregation');
    
   if (!numericSelect || !dateSelect) {
         console.error("ERROR: Cannot find aggregation LOV elements in handleSave.");
         // Will proceed with selectedAggregation = 'none'
    } else if (numericSelect.style.display === 'block') {
        // If numeric select is visible, use its value
        selectedAggregation = numericSelect.value;
    } else if (dateSelect.style.display === 'block') {
        // If date select is visible, use its value
        selectedAggregation = dateSelect.value;
    }

    if (newHeader === '') {
      //  alert('Please enter a new column header');
        return;
    }
    
    // Assuming 'currentColumn' holds the full column identifier for 'parseColumnName'
      const columnInfo = parseColumnName(currentColumn);
    
    // Ensure jsondata_details exists and has selectedColumns
    if (typeof jsondata_details === 'undefined') {
        console.error('jsondata_details is undefined. Cannot save.');
        alert('Error: Data structure not available.');
        return;
    }
    
    if (!jsondata_details.selectedColumns) {
        jsondata_details.selectedColumns = [];
    }
 
    // Find the column in jsondata_details
    const existingColumn = findColwithTemp(columnInfo.col_name, columnInfo.temp_name);
     if (existingColumn) {
        // Update existing column with alias
        existingColumn.alias_name = newHeader;
        
        // NEW CODE: Update the visibility state
        existingColumn.visibility = selectedVisibility; 
        existingColumn.aggregation = selectedAggregation;

        // console.log('Updated column alias and visibility:', existingColumn);
    } else {
        // Add new column entry with alias and visibility
        jsondata_details.selectedColumns.push({
            col_name: columnInfo.col_name,
            temp_name: columnInfo.temp_name,
            alias_name: newHeader, 
            aggregation: selectedAggregation,
            // NEW CODE: Add visibility property
            visibility: selectedVisibility,
            
            db_object_name: '', 
            hotel_id: '', 
            data_type: '' 
        });
         console.log('Added new column with alias and visibility:', jsondata_details.selectedColumns[jsondata_details.selectedColumns.length - 1]);
    }
    
    // Log the updated JSON for verification
    // console.log('Updated jsondata_details:', jsondata_details);
    
    // Update the table header display - IMPORTANT: This function must now handle the red color logic
    updateTableHeaderDisplay(columnInfo.col_name, columnInfo.temp_name, newHeader, selectedVisibility);
     
      //  hideColumnPopup();
    // Close the popup

    
    // Call AJAX process to save to database
    apex.server.process(
        'AJX_MANAGE_REPORT_VIEW',
        { 
            x01: 'UPDATE_ALIAS',
            x02: hotelLov.options[hotelLov.selectedIndex].value,
            x03: $('#New-Report').val(),
            x04: JSON.stringify(jsondata_details) // jsondata_details now includes the 'visibility' property
        },
        {
            success: function(data) { 
                // console.log('AJAX Success:', data);
                showSuccessMessage(`Column header updated to: ${newHeader} `);
               //  
                 call_dashboard_data(selectedreport_var);
                 hideColumnPopup();
                // //loadDashboard(reporttblData);
                //  recalculateAllFormulas();
                //  applyAggregations(); 
                // refreshTable();
                // updateCalculation();
                // loadSavedFormatters();
                
                saveAllDataToJSON(); 
    
              //  displayReportTable('handleSave');
               // refreshTable(); 
                   
                    
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error('AJAX Error:', errorThrown);
                alert('Error saving column alias. Please try again.');
            }
        }
    ); 
}


/**
 * Helper function to get the grouping key for a date value.
 * @param {string} dateString - The raw date string value (e.g., '2025-03-15').
 * @param {string} format - 'week', 'month', or 'year'.
 * @returns {string} The grouping key (e.g., '2025-W10', '2025-03', '2025').
 */
function getGroupKey(dateString, format) {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    if (isNaN(date)) return 'Invalid Date';

    const year = date.getFullYear();

    if (format === 'year') {
        return year.toString();
    }
    
    if (format === 'month') {
        // Month is 0-indexed (0-11), so add 1 and pad with zero
        const month = String(date.getMonth() + 1).padStart(2, '0');
        return `${year}-${month}`;
    }

    if (format === 'week') {
        // Simple week of year calculation (adequate for basic grouping)
        const startOfYear = new Date(year, 0, 1);
        const diff = date - startOfYear;
        const oneWeek = 1000 * 60 * 60 * 24 * 7;
        const weekNum = Math.ceil((diff / oneWeek)); 
        return `${year}-W${String(weekNum).padStart(2, '0')}`;
    }

    return dateString;
}

/**
 * Applies numeric aggregations (sum, avg, min, max, count) across the entire column.
 * This is the behavior when NO date grouping is active. (Previous logic extracted).
 */
function applySimpleAggregations() {
    // Start with a fresh copy of the original data
    const transformedRows = JSON.parse(JSON.stringify(pristineReportData));

    // Find columns that need aggregation
    const columnsToAggregate = jsondata_details.selectedColumns.filter(
        col => col.data_type === 'number' && col.aggregation && col.aggregation !== 'none'
    );

    columnsToAggregate.forEach(column => {
        const fullColumnName = `${column.col_name} - ${column.temp_name}`;
        
        // Extract all numeric values for this column from the pristine data
        const values = pristineReportData
            .map(row => parseFloat(row[fullColumnName]))
            .filter(val => !isNaN(val));

        if (values.length === 0) return;

        let result;
        switch (column.aggregation) {
            case 'sum':
                result = values.reduce((acc, val) => acc + val, 0);
                break;
            case 'average':
                result = values.reduce((acc, val) => acc + val, 0) / values.length;
                break;
            case 'min':
                result = Math.min(...values);
                break;
            case 'max':
                result = Math.max(...values);
                break;
            case 'count':
                result = values.length;
                break;
            default:
                return;
        }

        // Update the value for this column in every row of our working dataset
        transformedRows.forEach(row => {
            row[fullColumnName] = result;
        });
    });

    // Update the global data objects with the transformed data
    reporttblData.rows = transformedRows;
    originalReportData = [...transformedRows];
}

// Function to update the table header display
function updateTableHeaderDisplay(col_name, temp_name, newAlias) {
    // console.log('col_name::>',col_name);
    // console.log('temp_name::>',temp_name);
    // console.log('newAlias::>',newAlias);
    const fullColumnName = `${col_name} - ${temp_name}`;
    const headers = document.querySelectorAll('#tableHeader th[data-full-name]');
    
    headers.forEach(header => {
        if (header.getAttribute('data-full-name') === fullColumnName) {
            header.textContent = newAlias;
            header.title = `Click to edit: ${fullColumnName} (Alias: ${newAlias})`;
        }
    });
}

// Function to show success message
function showSuccessMessage(message) { 
    // Show the success message
    apex.message.showPageSuccess(message);

    // Hide the message after 3 seconds (3000 milliseconds)
      setTimeout(function() {
        // The success message container has class 't-Alert--success'
        $('.t-Alert--success').fadeOut('slow', function() {
            $(this).remove(); // Remove it from DOM after fading
        });
    }, 2000);
}



const CALCULATED_GROUP_NAME = 'calc'; 




// ====== POSITION MANAGEMENT FUNCTIONS ======



// ====== DRAG AND DROP FUNCTIONS ======

let draggedColumn = null;

function enableColumnDragAndDrop() {
    const tableHeader = document.getElementById('tableHeader');
    const thElements = tableHeader.querySelectorAll('th:not(:first-child)'); // Exclude row number column
    
    thElements.forEach(th => {
        th.setAttribute('draggable', 'true');
        
        th.addEventListener('dragstart', handleDragStartcol);
        th.addEventListener('dragend', handleDragEndcol);
        th.addEventListener('dragover', handleDragOvercol);
        th.addEventListener('dragenter', handleDragEntercol);
        th.addEventListener('dragleave', handleDragLeavecol);
        th.addEventListener('drop', handleDropcol);
    });
}

function handleDragStartcol(e) {
    draggedColumn = this;
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/html', this.outerHTML);
    this.classList.add('dragging');
    
    // Store the original index
    const headers = Array.from(document.querySelectorAll('#tableHeader th:not(:first-child)'));
    this._dragIndex = headers.indexOf(this);
}

function handleDragEndcol(e) {
    const thElements = document.querySelectorAll('#tableHeader th:not(:first-child)');
    thElements.forEach(th => {
        th.classList.remove('dragging', 'drag-over');
    });
    draggedColumn = null;
}

function handleDragOvercol(e) {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
    return false;
}

function handleDragEntercol(e) {
    this.classList.add('drag-over');
}

function handleDragLeavecol(e) {
    this.classList.remove('drag-over');
}

function handleDropcol(e) {
    e.preventDefault();
    e.stopPropagation();
    
    if (draggedColumn !== this && draggedColumn) {
        const tableHeader = document.getElementById('tableHeader');
        const tableBody = document.getElementById('tableBody');
        
        // Get all header cells (excluding row number)
        const headers = Array.from(tableHeader.querySelectorAll('th:not(:first-child)'));
        const draggedIndex = draggedColumn._dragIndex;
        const targetIndex = headers.indexOf(this);
        
        // console.log(`Moving column from index ${draggedIndex} to ${targetIndex}`);
        
        if (draggedIndex !== targetIndex) {
            // Reorder headers in DOM
            if (draggedIndex < targetIndex) {
                this.parentNode.insertBefore(draggedColumn, this.nextSibling);
            } else {
                this.parentNode.insertBefore(draggedColumn, this);
            }
            
            // Reorder table body columns
            reorderTableBodyColumns(draggedIndex, targetIndex);
            
            // Update positions in the column configuration
            updateColumnPositionsAfterDrag();
            
            // Reorder the data columns in reporttblData
            reorderDataColumns();
            
            // Update the table display
            updateTableAfterReorder();
        }
    }
    
    this.classList.remove('drag-over');
    return false;
}

function reorderTableBodyColumns(fromIndex, toIndex) {
    const tableBody = document.getElementById('tableBody');
    const rows = tableBody.querySelectorAll('tr');
    
    rows.forEach(row => {
        const cells = Array.from(row.querySelectorAll('td:not(:first-child)'));
        
        if (cells.length > Math.max(fromIndex, toIndex)) {
            const cellToMove = cells[fromIndex];
            
            if (fromIndex < toIndex) {
                // Moving right
                if (toIndex + 1 < cells.length) {
                    row.insertBefore(cellToMove, cells[toIndex + 1]);
                } else {
                    // Moving to the end
                    row.appendChild(cellToMove);
                }
            } else {
                // Moving left
                row.insertBefore(cellToMove, cells[toIndex]);
            }
        }
    });
}

function updateColumnPositionsAfterDrag() {
    // Get current header order
    const tableHeader = document.getElementById('tableHeader');
    const headers = Array.from(tableHeader.querySelectorAll('th:not(:first-child)'));
    
    // Ensure columnposition array exists
    if (!report_expressions.columnposition) {
        report_expressions.columnposition = [];
    }
    
    // Clear existing positions
    report_expressions.columnposition = [];
    
    // Update positions based on new order
    headers.forEach((header, index) => {
        const fullColumnName = header.getAttribute('data-full-name');
        const baseColumnName = header.getAttribute('data-original-name');
        const templateName = header.getAttribute('data-template-name');
        
        if (!fullColumnName) {
            console.warn('Header missing data-full-name attribute', header);
            return;
        }
        
        report_expressions.columnposition.push({
            fullColumnName: fullColumnName,
            baseColumnName: baseColumnName,
            templateName: templateName,
            position: index
        });
    });
    
    // console.log('Updated column positions in columnposition:', report_expressions.columnposition);
}

function reorderDataColumns() {
    if (!reporttblData.rows || reporttblData.rows.length === 0) return;
    
    // Get ordered column keys from current header order
    const tableHeader = document.getElementById('tableHeader');
    const headers = Array.from(tableHeader.querySelectorAll('th:not(:first-child)'));
    const orderedKeys = headers.map(header => header.getAttribute('data-full-name'));
    
    // console.log('Reordering data columns to:', orderedKeys);
    
    // Reorder all rows in the data
    reporttblData.rows = reporttblData.rows.map(row => {
        const newRow = {};
        orderedKeys.forEach(key => {
            newRow[key] = row[key];
        });
        return newRow;
    });
}

function updateTableAfterReorder() {
    // Update any dependent functionality
    addHeaderClickListeners();
    loadConditionalFormattingBlocks();
    
    // Save the updated column order
    saveColumnOrderToDatabase();
    
    // console.log('Table reorder completed');
}

// ====== POSITION MANAGEMENT FUNCTIONS ======

// Add this function to parse report_expressions if it's a string
function getParsedReportExpressions() {
    if (typeof report_expressions === 'string') {
        try {
            return JSON.parse(report_expressions);
        } catch (e) {
            console.error('Error parsing report_expressions:', e);
            // Return a default structure if parsing fails
            return {
                columnConfiguration: {
                    hotel: "My Hotel",
                    template: "All",
                    selectedColumns: [],
                    columnOrder: []
                },
                columnMetadata: [],
                formulas: {},
                filters: {},
                conditionalFormatting: {}
            };
        }
    }
    return report_expressions;
}

function initializeColumnPositions() {
    // Parse and ensure the structure exists
    report_expressions = getParsedReportExpressions();
    
    // Check if we already have positions in columnposition
    if (report_expressions.columnposition && report_expressions.columnposition.length > 0) {
        // console.log('Column positions already exist in columnposition, skipping initialization');
        return; // Don't overwrite existing positions
    }
    
    // If not, check if we have positions in columnConfiguration.columnOrder
    if (report_expressions.columnConfiguration && 
        report_expressions.columnConfiguration.columnOrder && 
        report_expressions.columnConfiguration.columnOrder.length > 0) {
        // console.log('Column positions exist in columnConfiguration.columnOrder, moving to columnposition');
        // Move the positions to columnposition for consistency
        report_expressions.columnposition = report_expressions.columnConfiguration.columnOrder;
        return;
    }
    
    // Only initialize if we don't have positions anywhere
    const allColumnKeys = Object.keys(reporttblData.rows[0] || {});
    
    // Initialize positions in columnposition array
    report_expressions.columnposition = allColumnKeys.map((fullColumnName, index) => {
        let baseCol = fullColumnName;
        let template = '';
        
        const firstDashIndex = fullColumnName.indexOf(' - ');
        if (firstDashIndex !== -1) {
            baseCol = fullColumnName.substring(0, firstDashIndex);
            template = fullColumnName.substring(firstDashIndex + 3);
        }
        
        if (!template) {
            baseCol = fullColumnName;
            template = CALCULATED_GROUP_NAME;
        }
        
        return {
            fullColumnName: fullColumnName,
            baseColumnName: baseCol,
            templateName: template,
            position: index
        };
    });
    
    // console.log('Initialized column positions in columnposition:', report_expressions.columnposition);
}


function getOrderedColumns() {
    // Ensure report_expressions is parsed
    report_expressions = getParsedReportExpressions();
    
    // console.log('Looking for column positions in:', report_expressions);
    
    // Check if we have saved column positions in columnposition array
    let savedColumnOrder = [];
    if (report_expressions.columnposition && report_expressions.columnposition.length > 0) {
        // console.log('Found column positions in columnposition array');
        savedColumnOrder = report_expressions.columnposition;
    } 
    // Also check in columnConfiguration.columnOrder for backward compatibility
    else if (report_expressions.columnConfiguration && 
             report_expressions.columnConfiguration.columnOrder && 
             report_expressions.columnConfiguration.columnOrder.length > 0) {
        // console.log('Found column positions in columnConfiguration.columnOrder');
        savedColumnOrder = report_expressions.columnConfiguration.columnOrder;
    }
    
    // If no saved positions found, use default order
    if (savedColumnOrder.length === 0) {
        // console.log('No column order found, using default order');
        const allColumnKeys = Object.keys(reporttblData.rows[0] || {});
        return allColumnKeys.map((fullColumnName, index) => {
            let baseCol = fullColumnName;
            let template = '';
            
            const firstDashIndex = fullColumnName.indexOf(' - ');
            if (firstDashIndex !== -1) {
                baseCol = fullColumnName.substring(0, firstDashIndex);
                template = fullColumnName.substring(firstDashIndex + 3);
            }
            
            if (!template) {
                baseCol = fullColumnName;
                template = CALCULATED_GROUP_NAME;
            }
            
            return {
                fullColumnName: fullColumnName,
                baseColumnName: baseCol,
                templateName: template,
                position: index
            };
        });
    }
    
    // We have saved positions - use them!
    const allColumnKeys = Object.keys(reporttblData.rows[0] || {});
    
    // console.log('Using saved column order:', savedColumnOrder);
    // console.log('All available columns:', allColumnKeys);
    
    // Create a map of saved positions for quick lookup
    const savedPositionMap = new Map();
    savedColumnOrder.forEach(col => {
        savedPositionMap.set(col.fullColumnName, col);
    });
    
    // Separate columns into two groups:
    // 1. Columns with saved positions
    // 2. New columns without saved positions (added at the end)
    const columnsWithPositions = [];
    const columnsWithoutPositions = [];
    
    allColumnKeys.forEach(fullColumnName => {
        let baseCol = fullColumnName;
        let template = '';
        
        const firstDashIndex = fullColumnName.indexOf(' - ');
        if (firstDashIndex !== -1) {
            baseCol = fullColumnName.substring(0, firstDashIndex);
            template = fullColumnName.substring(firstDashIndex + 3);
        }
        
        if (!template) {
            baseCol = fullColumnName;
            template = CALCULATED_GROUP_NAME;
        }
        
        const columnInfo = {
            fullColumnName: fullColumnName,
            baseColumnName: baseCol,
            templateName: template
        };
        
        // Check if this column has a saved position
        const savedColumn = savedPositionMap.get(fullColumnName);
        if (savedColumn) {
            // Use the saved position
            columnInfo.position = savedColumn.position;
            columnsWithPositions.push(columnInfo);
        } else {
            // New column - will be added at the end
            columnsWithoutPositions.push(columnInfo);
        }
    });
    
    // Sort columns with saved positions by their position
    columnsWithPositions.sort((a, b) => a.position - b.position);
    
    // Add new columns at the end with sequential positions
    let nextPosition = columnsWithPositions.length > 0 
        ? Math.max(...columnsWithPositions.map(col => col.position)) + 1 
        : 0;
    
    columnsWithoutPositions.forEach(columnInfo => {
        columnInfo.position = nextPosition++;
        columnsWithPositions.push(columnInfo);
    });
    
    // console.log('Final ordered columns:', columnsWithPositions);
    return columnsWithPositions;
}


function saveColumnOrderToDatabase() {
    // console.log('Column order updated:', report_expressions.columnposition);
    saveAllDataToJSON();
  
}

// ====== MODIFIED DISPLAY REPORT TABLE ======
function displayReportTable(callfrom) {
 //console.log('displayReportTable reporttblData:>>>', callfrom, reporttblData);
    const tableHeader = document.getElementById('tableHeader');
    const tableBody = document.getElementById('tableBody');
    const noDataMessage = document.getElementById('noDataMessage');
    
    // Clear existing content
    tableHeader.innerHTML = '';
    tableBody.innerHTML = '';
    
    if (!reporttblData.rows || reporttblData.rows.length === 0) {
        document.getElementById('reporttblDataTable').style.display = 'none';
        noDataMessage.style.display = 'block';
        return;
    }

    // Initialize/update column positions (but don't overwrite existing ones)
    initializeColumnPositions();
    
    // Show table and hide no data message
    document.getElementById('reporttblDataTable').style.display = 'table';
    noDataMessage.style.display = 'none';
    
    // Get ordered columns based on position - THIS IS THE KEY FUNCTION
    const orderedColumns = getOrderedColumns();
    // console.log('Final columns order to display:', orderedColumns);
    
    // Create header row with column names
    const columnHeaderRow = document.createElement('tr');
    
    // First column for row numbers
    const rowNumTh = document.createElement('th');
    rowNumTh.textContent = '#';
    columnHeaderRow.appendChild(rowNumTh);
    
    // Create header cells in position order
    orderedColumns.forEach(columnInfo => {
        const fullColumnName = columnInfo.fullColumnName;
        const th = document.createElement('th');
        
        const baseCol = columnInfo.baseColumnName;
        const template = columnInfo.templateName;
        
        // Find the existing column configuration
        let existingColumn = findColwithTemp(baseCol, template);
        
        let displayName = baseCol;
        
        if (existingColumn && existingColumn.alias_name) {
            displayName = existingColumn.alias_name;
        } else {
            displayName = baseCol;
        }
        
        th.textContent = displayName;
        th.setAttribute('data-full-name', fullColumnName);
        th.setAttribute('data-original-name', baseCol);
        th.setAttribute('data-template-name', template);
        th.setAttribute('data-position', columnInfo.position);
        
        // Apply red color class based on visibility
        const isHidden = existingColumn && existingColumn.visibility === 'hide';
        if (isHidden) {
            th.classList.add('hide-prompt');
            th.title = `Click to edit: ${fullColumnName} (Hidden Prompt)`;
        } else {
            th.title = `Click to edit: ${fullColumnName}${displayName !== baseCol ? ` (Alias: ${displayName})` : ''}`;
        }

        columnHeaderRow.appendChild(th);
    });
    
    tableHeader.appendChild(columnHeaderRow);
    
    // Create table rows with data in position order
    reporttblData.rows.forEach((row, index) => {
        const tr = document.createElement('tr');
        
        // Row number cell
        const rowNumberCell = document.createElement('td');
        rowNumberCell.textContent = index + 1;
        rowNumberCell.className = 'data-cell';
        tr.appendChild(rowNumberCell);
        
        // Data cells in position order
        orderedColumns.forEach(columnInfo => {
            const fullColumnName = columnInfo.fullColumnName;
            const td = document.createElement('td');
            let displayValue = row[fullColumnName];

            const baseCol = columnInfo.baseColumnName;
            const template = columnInfo.templateName;
            
            // Find the existing column configuration
            let existingColumn = findColwithTemp(baseCol, template);
            
            // Format dates
            if (existingColumn && existingColumn.data_type === 'date' && displayValue) {
                displayValue = formatDate(displayValue);
            }

            // Apply conditional formatting
            const rules = conditionalFormattingRules[fullColumnName];
             
            if (rules && rules.length > 0) {
                for (const rule of rules) {
                    if (evaluateFormatterRule(rule.expression, row)) {
                        td.style.backgroundColor = rule.color;
                        td.classList.add('conditional-format');
                        break;
                    }
                }
            }

            // Round number fields only based on existingColumn data_type or calculated columns
            if (existingColumn && existingColumn.data_type === 'number') {
                const num = typeof displayValue === 'number' ? displayValue : parseFloat(displayValue);
                if (!isNaN(num) && isFinite(num)) {
                    displayValue = num.toFixed(2);
                }
            } else if (template === CALCULATED_GROUP_NAME) {
                const num = typeof displayValue === 'number' ? displayValue : parseFloat(displayValue);
                if (!isNaN(num) && isFinite(num)) {
                    displayValue = num.toFixed(2);
                }
            } else if (displayValue === null || displayValue === undefined || displayValue === '') {
                displayValue = '-';
            }
            
            td.textContent = displayValue;
            td.className = 'data-cell';
            tr.appendChild(td);
        });
        
        tableBody.appendChild(tr);
    });
    
    // Add click event listeners to column headers
    addHeaderClickListeners(); 
    loadConditionalFormattingBlocks();
    
    // Enable drag and drop after table is created
    enableColumnDragAndDrop();
    pristineReportData = JSON.parse(JSON.stringify(reporttblData.rows));
}
// ====== CSS STYLES ======

const dragDropStyles = `
    th[draggable="true"] {
        cursor: grab;
        user-select: none;
        -webkit-user-drag: element;
    }
    
    th[draggable="true"]:active {
        cursor: grabbing;
    }
    
    th.dragging {
        opacity: 0.5;
        background-color: #f0f0f0;
    }
    
    th.drag-over {
        border: 2px dashed #007bff;
        background-color: #e3f2fd;
    }
    
    th[draggable="true"]:hover {
        background-color: #252627;
    }
`;

// Inject the styles
const styleSheet = document.createElement('style');
styleSheet.textContent = dragDropStyles;
document.head.appendChild(styleSheet);

   













function formatDate(dateString) {
    if (!dateString) return '';
    try {
        // Add T00:00:00 to the string to ensure correct parsing and prevent timezone shift issues
        const date = new Date(dateString.includes('T') ? dateString : dateString + 'T00:00:00'); 
        
        if (isNaN(date.getTime())) return dateString;
        
        const day = String(date.getDate()).padStart(2, '0');
        const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        const month = monthNames[date.getMonth()];
        const year = date.getFullYear();
        
        return `${day}/${month}/${year}`; // dd/Mon/yyyy
        
    } catch (e) {
        console.error('Error formatting date:', dateString, e);
        return dateString;
    }
}

function populateColumnLOV(targetSelectId, columns, includeOnlyNumeric = false) {
    const selectElement = document.getElementById(targetSelectId);
    
    if (!selectElement) {
        console.error(`Element with ID "${targetSelectId}" not found`);
        return;
    }
    
    // Clear existing options
    selectElement.innerHTML = '<option value="">Select Column</option>';
    
    // Filter columns if needed
    const filteredColumns = includeOnlyNumeric 
        ? columns.filter(column => column.type === 'number')
        : columns;
    
    // Populate options
    filteredColumns.forEach(column => {
        // Create a shorter name for display clarity
        const shortName = column.name.split(' - ')[0].replace(/_/g, ' ');
        
        const option = document.createElement('option');
        option.value = column.name;
        option.textContent = shortName;
        selectElement.appendChild(option);
    });
}




// Add change event to operator-lovfilter
const operatorLovFilter = document.getElementById('operator-lovfilter');

if (operatorLovFilter) {
    operatorLovFilter.addEventListener('change', function() {
        const selectedValue = this.value;
        
        // Remove any existing dynamic elements
        const existingRange = document.getElementById('range-container');
        const existingDays = document.getElementById('days-container');
        if (existingRange) existingRange.remove();
        if (existingDays) existingDays.remove();
        
        // Handle different operators
        if (selectedValue === 'Range') {
            // Create container with forced new line
            const rangeContainer = document.createElement('div');
           rangeContainer.id = 'range-container';
            rangeContainer.style.cssText = `
                margin-top: 10px;
                width: 100%;
                background-color: rgb(37 37 37);
                color: white;
                padding: 10px;
                border-radius: 2px;
                display: flex;
                gap: 10px;       /* space between From/To */
                align-items: flex-start;
            `;
                        
            // From field
            const fromDiv = document.createElement('div');
            fromDiv.style.cssText = `
    display: flex;
    flex-direction: column;
`;
            
            const fromLabel = document.createElement('label');
            //fromLabel.textContent = 'From: ';
            // fromLabel.style.cssText = `
            //     margin-right: 2px;
            //     color: #e2e8f0;
            //     font-weight: 500;
            // `;
            
            const fromInput = document.createElement('input');
            fromInput.type = 'date';
            fromInput.id = 'range-from';
            fromInput.style.cssText = `
                padding: 2px 5px;
                display: block;
                clear: both;
                margin-top: 1px;
                width: 100px;
                background-color: rgb(37 37 37);
                color: white;
                border: 1px solid #718096;
                border-radius: 4px;
            `;
            
          //  fromDiv.appendChild(fromLabel);
           // fromDiv.appendChild(document.createElement('br'));
            fromDiv.appendChild(fromInput);
            
            // To field
            const toDiv = document.createElement('div');
            toDiv.style.cssText = `
    display: flex;
    flex-direction: column;
`;
            
            const toLabel = document.createElement('label');
            toLabel.textContent = ' - ';
            // toLabel.style.cssText = `
            //     margin-right: 2px;
            //     color: #e2e8f0;
            //     font-weight: 500;
            // `;
            
            const toInput = document.createElement('input');
           // toInput.textContent = ' - ';
            toInput.type = 'date';
            toInput.id = 'range-to';
            toInput.style.cssText = `
                padding: 2px 5px;
                display: block;
                clear: both;
                margin-top: 1px;
                width: 100px;
                background-color: rgb(37 37 37);
                color: white;
                border: 1px solid #718096;
                border-radius: 4px;
            `;
            
          // toDiv.appendChild(toLabel);
          //  toDiv.appendChild(document.createElement('br'));
            toDiv.appendChild(toInput);
            
            // Append elements
            rangeContainer.appendChild(fromDiv);
            rangeContainer.appendChild(toDiv);
            
            // Add after operator dropdown with forced break
            const br = document.createElement('br');
            br.style.cssText = 'clear: both; display: block;';
            
            const parent = operatorLovFilter.parentNode;
            parent.insertBefore(br, operatorLovFilter.nextSibling);
            parent.insertBefore(rangeContainer, br.nextSibling);
            
        } else if (selectedValue === 'Day_Of_Week') {
            // Create days container with forced new line
            const daysContainer = document.createElement('div');
            daysContainer.id = 'days-container';
            daysContainer.style.cssText = `
                margin-top: 10px;
                clear: both;
                display: block;
                width: 100%;
                float: left;
                background-color: rgb(37 37 37);
                color: white;
                padding: 15px;
                border-radius: 6px;
                min-width: 180px;
            `;
            
            const daysLabel = document.createElement('div');
            daysLabel.textContent = 'Select Days:';
            daysLabel.style.cssText = `
                margin-bottom: 10px;
                font-weight: bold;
                color: #e2e8f0;
                font-size: 14px;
            `;
            
            // Create container for checkbox dropdown
            const dropdownContainer = document.createElement('div');
            dropdownContainer.style.cssText = `
                position: relative;
                display: inline-block;
                width: 100%;
            `;
            
            // Create a button to trigger dropdown
            const dropdownButton = document.createElement('button');
            dropdownButton.type = 'button';
            dropdownButton.id = 'days-dropdown-button';
            dropdownButton.textContent = 'Select Days';
            dropdownButton.style.cssText = `
                padding: 10px 15px;
                width: 100%;
                text-align: left;
                background-color: rgb(37 37 37);
                color: white;
                border: 1px solid #718096;
                border-radius: 4px;
                cursor: pointer;
                display: block;
                clear: both;
                font-size: 14px;
                position: relative;
            `;
            
            // Add dropdown arrow
            const arrowSpan = document.createElement('span');
            arrowSpan.textContent = '▼';
            arrowSpan.style.cssText = `
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 12px;
                color: #cbd5e0;
            `;
            dropdownButton.appendChild(arrowSpan);
            
            // Create dropdown content (hidden by default)
            const dropdownContent = document.createElement('div');
            dropdownContent.id = 'days-dropdown-content';
            dropdownContent.style.cssText = `
                display: none;
                position: absolute;
                background-color: rgb(37 37 37);
                width: 100%;
                border: 1px solid #718096;
                border-radius: 4px;
                padding: 15px;
                z-index: 1000;
                box-shadow: 0 4px 12px rgba(0,0,0,0.3);
                margin-top: 5px;
            `;
            
            // Days options as checkboxes
            const days = [
                { value: 'Mon', text: 'Monday' },
                { value: 'Tue', text: 'Tuesday' },
                { value: 'Wed', text: 'Wednesday' },
                { value: 'Thu', text: 'Thursday' },
                { value: 'Fri', text: 'Friday' },
                { value: 'Sat', text: 'Saturday' },
                { value: 'Sun', text: 'Sunday' }
            ];
            
            days.forEach(day => {
                const checkboxDiv = document.createElement('div');
                checkboxDiv.style.cssText = `
                    margin-bottom: 8px;
                    display: flex;
                    align-items: center;
                    padding: 5px;
                    border-radius: 3px;
                    transition: background-color 0.2s;
                `;
                checkboxDiv.addEventListener('mouseover', () => {
                    checkboxDiv.style.backgroundColor = '#4a5568';
                });
                checkboxDiv.addEventListener('mouseout', () => {
                    checkboxDiv.style.backgroundColor = 'transparent';
                });
                
                const checkbox = document.createElement('input');
                checkbox.type = 'checkbox';
                checkbox.id = `day-${day.value}`;
                checkbox.name = 'days';
                checkbox.value = day.value;
                checkbox.className = 'day-checkbox';
                checkbox.style.cssText = `
                    margin-right: 10px;
                    width: 16px;
                    height: 16px;
                    cursor: pointer;
                    accent-color: #4299e1;
                `;
                
                // Close dropdown on checkbox click
                checkbox.addEventListener('click', () => {
    updateButtonText();   // update text only
});
                
                const label = document.createElement('label');
                label.htmlFor = `day-${day.value}`;
                label.textContent = day.text;
                label.style.cssText = `
                    cursor: pointer;
                    color: #e2e8f0;
                    font-size: 14px;
                    flex-grow: 1;
                `;
                
                checkboxDiv.appendChild(checkbox);
                checkboxDiv.appendChild(label);
                dropdownContent.appendChild(checkboxDiv);
            });
            
            // Add select all/none buttons
            const buttonDiv = document.createElement('div');
            buttonDiv.style.cssText = `
                margin-top: 15px;
                display: flex;
                gap: 10px;
                border-top: 1px solid #4a5568;
                padding-top: 15px;
            `;
            
            const selectAllBtn = document.createElement('button');
            selectAllBtn.type = 'button';
            selectAllBtn.textContent = 'All';
            selectAllBtn.style.cssText = `
                padding: 6px 12px;
                font-size: 13px;
                background: #38a169;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                flex: 1;
                transition: background-color 0.2s;
            `;
            selectAllBtn.onmouseover = () => selectAllBtn.style.backgroundColor = '#2f855a';
            selectAllBtn.onmouseout = () => selectAllBtn.style.backgroundColor = '#38a169';
            selectAllBtn.onclick = () => {
                dropdownContent.querySelectorAll('.day-checkbox').forEach(cb => cb.checked = true);
                dropdownContent.style.display = 'none';
                updateButtonText();
            };
            
            const selectNoneBtn = document.createElement('button');
            selectNoneBtn.type = 'button';
            selectNoneBtn.textContent = 'None';
            selectNoneBtn.style.cssText = `
                padding: 6px 12px;
                font-size: 13px;
                background: #e53e3e;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                flex: 1;
                transition: background-color 0.2s;
            `;
            selectNoneBtn.onmouseover = () => selectNoneBtn.style.backgroundColor = '#c53030';
            selectNoneBtn.onmouseout = () => selectNoneBtn.style.backgroundColor = '#e53e3e';
            selectNoneBtn.onclick = () => {
                dropdownContent.querySelectorAll('.day-checkbox').forEach(cb => cb.checked = false);
                dropdownContent.style.display = 'none';
                updateButtonText();
            };
            
            buttonDiv.appendChild(selectAllBtn);
            buttonDiv.appendChild(selectNoneBtn);
            dropdownContent.appendChild(buttonDiv);
            
            // Function to update button text based on selection
            function updateButtonText() {
                const selected = Array.from(dropdownContent.querySelectorAll('.day-checkbox:checked'))
                    .map(cb => cb.value);
                
                if (selected.length === 0) {
                    dropdownButton.textContent = 'Select Days';
                } else if (selected.length === 7) {
                    dropdownButton.textContent = 'All Days';
                } else {
                    const dayNames = selected.map(day => {
                        const dayMap = {
                            'Mon': 'Mon', 'Tue': 'Tue', 'Wed': 'Wed', 
                            'Thu': 'Thu', 'Fri': 'Fri', 'Sat': 'Sat', 'Sun': 'Sun'
                        };
                        return dayMap[day];
                    });
                    dropdownButton.textContent = dayNames.join(', ');
                }
                
                // Re-add arrow after updating text
                dropdownButton.appendChild(arrowSpan);
            }
            
            // Toggle dropdown visibility
            dropdownButton.addEventListener('click', (e) => {
                e.stopPropagation();
                dropdownContent.style.display = 
                    dropdownContent.style.display === 'block' ? 'none' : 'block';
            });
            
            // Close dropdown when clicking outside anywhere
            function closeDropdown() {
                dropdownContent.style.display = 'none';
            }
            
            // Don't close when clicking inside dropdown
            dropdownContent.addEventListener('click', (e) => {
                e.stopPropagation();
            });
            
            // Add global click listener to close dropdown
            document.addEventListener('click', closeDropdown);
            
            // Clean up listener when element is removed
            daysContainer.addEventListener('DOMNodeRemoved', () => {
                document.removeEventListener('click', closeDropdown);
            });
            
            // Assemble dropdown
            dropdownContainer.appendChild(dropdownButton);
            dropdownContainer.appendChild(dropdownContent);
            
            // Append elements
            //daysContainer.appendChild(daysLabel);
            daysContainer.appendChild(dropdownContainer);
            
            // Add after operator dropdown with forced break
            const br = document.createElement('br');
            br.style.cssText = 'clear: both; display: block;';
            
            const parent = operatorLovFilter.parentNode;
            parent.insertBefore(br, operatorLovFilter.nextSibling);
            parent.insertBefore(daysContainer, br.nextSibling);
            
        } 
        // For "All" - do nothing, just remove any existing elements
    });
    
    // Initialize if there's already a value
    if (operatorLovFilter.value) {
        operatorLovFilter.dispatchEvent(new Event('change'));
    }
}
let selectedDays = [];
// Helper function to get selected days
function getSelectedDays() {
    selectedDays = [];
    document.querySelectorAll('.day-checkbox:checked').forEach(checkbox => {
        selectedDays.push(checkbox.value);
    });
    return selectedDays;
}









let originalReportData = null; // Store original data for clearing filters

let tableColumns ; // Use the explicit object

// Global list to store saved formulas
let savedFormulas = {};
let currentFormulaName = '';
 
function initializeControls() {

    populateColumnLOV('column-lov', tableColumns, false);

 
    populateColumnLOV('column-lovfilter', tableColumns, false);
    
    // Load saved formulas (kept here for control initialization)
    // NOTE: Ensure loadSavedFormulas() is defined elsewhere.
    loadSavedFormulas();

    // ===============================================================
    // NEW FILTER BUILDER LOGIC (This section is now clean and correct)
    // ===============================================================
    const filterColumnLOV = document.getElementById('filter-column-lov');
    
    if (!filterColumnLOV) {
        console.error("Filter column LOV element not found. Check HTML ID.");
        return;
    }
    
    // Clear previous content
    filterColumnLOV.innerHTML = '<option value="">Select Column</option>';
    
    // Populate the new filter builder column select
    tableColumns.forEach(column => {
        const shortName = column.name.split(' - ')[0].replace(/_/g, ' '); 
        
        const filterOption = document.createElement('option');
        // Use the full column name, enclosed in brackets, which the builder expects
        filterOption.value = `[${column.name}]`; 
        filterOption.textContent = shortName;
        filterColumnLOV.appendChild(filterOption);
    });
    
    // Load saved filters (New function)
    // NOTE: Ensure loadSavedFilters() is defined elsewhere.
    loadSavedFilters(); 


        loadSavedFormatters();
    
}


function addToFilter() {
    const column = document.getElementById('filter-column-lov').value;
    const operator = document.getElementById('filter-operator-lov').value;
    const preview = document.getElementById('filter-preview');
    console.log('addToFilter',column);
    // The column LOV already adds brackets []
    if (column) {
        // Replace placeholder VALUE if operator is for string functions
        let component = operator.includes('VALUE') ? operator.replace('VALUE', '') : operator;
        preview.value += ` ${column}${component} `; 
    } else {
        // Allows user to select logical operators (&&, ||)
        preview.value += ` ${operator} `; 
    }
}

function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
 

 function replaceDateRangeExpressions(expression, row) {
    if (!expression) return expression;
    
    // --- Pattern 1: [Column] between Start and End ---
    // Match: [column name or alias] between [date] and [date]
    // Capture Groups: 1=Column, 2=Start Date, 3=End Date
    let betweenPattern = /\[(.*?)\]\s*between\s*(.*?)\s*and\s*(.*?)$/i;

    // --- Pattern 2: [Column] DATE_RANGE (Start, End) ---
    // Match: [column name or alias] DATE_RANGE (date, date)
    let rangePattern = /\[(.*?)\]\s*DATE_RANGE\s*\((.*?)\)/i;
    
    let translatedExpression = expression;

    // A. Handle 'between' pattern
    translatedExpression = translatedExpression.replace(betweenPattern, (match, fullColumn, startStr, endStr) => {
        // Remove spaces and quotes from dates for safer use in JS string
        const cleanStart = startStr.trim().replace(/['"]/g, '');
        const cleanEnd = endStr.trim().replace(/['"]/g, '');
        const columnRef = `[${fullColumn.trim()}]`;

        // The date value for 'fullColumn' will be substituted later by replaceColumnOccurrences.
        // We must translate the dates into milliseconds for comparison, but keep the column reference.
        // NOTE: We wrap the columnRef in new Date() and getTime() for date evaluation.
        // This is complex because we need to parse the dates now, but substitute the column value later.
        
        // This translation assumes that replaceColumnOccurrences will substitute columnRef with a string date.
        
        // To safely handle date comparison in eval(), we must convert the date strings to a consistent format (like YYYY-MM-DD)
        // AND convert them to milliseconds within the evaluated string.
        
        // Let's assume the column substitution (STEP 1) provides the correct row date as a quoted string, e.g., "2025-10-06".
        
        // Correct JS structure for: [DATE] >= StartDate && [DATE] <= EndDate
        // We need to use new Date() and getTime() on all parts.
        
        // The column reference [X] will be replaced with a quoted string "YYYY-MM-DD" by STEP 1.
        // We cannot use row[] here, so we must rely on the substituted value.
        
        // --- This is the key translation step ---
        // (new Date([DATE_VALUE]).getTime()) >= (new Date('Start Date').getTime()) && (new Date([DATE_VALUE]).getTime()) <= (new Date('End Date').getTime())
        
        return `((new Date(${columnRef}).getTime()) >= (new Date('${cleanStart}').getTime()) && (new Date(${columnRef}).getTime()) <= (new Date('${cleanEnd}').setHours(23, 59, 59, 999)))`;
    });
    
    // B. Handle 'DATE_RANGE' pattern (Similar translation)
    translatedExpression = translatedExpression.replace(rangePattern, (match, fullColumn, rangeStr) => {
        const [startStr, endStr] = rangeStr.split(',').map(s => s.trim().replace(/['"]/g, ''));
        const columnRef = `[${fullColumn.trim()}]`;

        if (!startStr || !endStr) return 'false';
        
        return `((new Date(${columnRef}).getTime()) >= (new Date('${startStr}').getTime()) && (new Date(${columnRef}).getTime()) <= (new Date('${endStr}').setHours(23, 59, 59, 999)))`;
    });

    return translatedExpression;
}

function loadConfigFromJSON(configData) {
    if (!configData || !configData.formulas || !configData.filters) {
        console.warn("No valid configuration data provided for loading formulas/filters.");
        return;
    }
    console.log('loadConfigFromJSON call:>>>');
    // 1. Load Formulas and Filters into global memory
    Object.assign(savedFormulas, configData.formulas);
    Object.assign(savedFilters, configData.filters);
    
    // --- CRITICAL FIX START: Persist and Refresh UI Lists ---
    if (typeof saveFormulas === 'function') {
        saveFormulas();
    } else {
        console.warn("saveFormulas function not found. Formula list will not update.");
    }
    
    if (typeof saveFilters === 'function') {
        saveFilters();
    } else {
        console.warn("saveFilters function not found. Filter list will not update.");
    }
    // --- CRITICAL FIX END ---
    
    // 2. Update global column list (to include calculated columns)
    if (configData.columnMetadata) {
        configData.columnMetadata.forEach(meta => {
            if (!tableColumns.some(col => col.name === meta.name)) {
                tableColumns.push(meta);
            }
        });
    }
    console.log('savedFormulas:>>>',savedFormulas);
    // 3. Apply Formulas to the current data set (reporttblData.rows)
    for (const [calcName, formulaObj] of Object.entries(savedFormulas)) {
    // Handle both formats: string (old) and object (new)
    let formulaString = "";
    let filterString = "";

    if (typeof formulaObj === 'string') {
        formulaString = formulaObj;
    } else if (formulaObj && typeof formulaObj.formula === 'string') {
        formulaString = formulaObj.formula;
        filterString = formulaObj.filter || "";
    } else {
        console.warn(`Invalid formula format for ${calcName}:`, formulaObj);
        continue;
    }

    reporttblData.rows.forEach(row => {
        let calculatedFormula = formulaString;
        let conditionalExpression = filterString;
        let isBooleanCalculation = false;

        // --- 0. Replace DAY_OF_WEEK expressions first ---
       calculatedFormula = replaceDayOfWeekExpressions(calculatedFormula, row);
    conditionalExpression = replaceDayOfWeekExpressions(conditionalExpression, row);
    
    // --- NEW STEP: Replace BETWEEN / DATE_RANGE expressions ---
    conditionalExpression = replaceDateRangeExpressions(conditionalExpression, row);
    // calculatedFormula usually won't have date range filter syntax, so we skip it.
// Fix Day() function
calculatedFormula = replaceDayFunction(calculatedFormula);
conditionalExpression = replaceDayFunction(conditionalExpression);

        // --- 1. Replace column references ---
        tableColumns.forEach(col => {
            const fullColName = col.name;
            const colType = col.type ? col.type.toLowerCase() : 'number';
            let rowValue = row[fullColName];

            // Trim strings
            if (typeof rowValue === 'string') rowValue = rowValue.trim();

            // Default empty/null to 0 for numeric operations
            if (rowValue === null || rowValue === "") rowValue = 0;

            calculatedFormula = replaceColumnOccurrences(calculatedFormula, fullColName, colType, rowValue, 'formula');
            conditionalExpression = replaceColumnOccurrences(conditionalExpression, fullColName, colType, rowValue, 'filter');

         
        });

        // --- 2. Normalize filter logical operators and spaces ---
        if (conditionalExpression) {
            conditionalExpression = conditionalExpression
                .replace(/\bAND\b/gi, '&&')
                .replace(/\bOR\b/gi, '||')
                .replace(/\s+/g, ' ')
                .trim();
        }

    calculatedFormula = replaceDayFunction(calculatedFormula);
            conditionalExpression = replaceDayFunction(conditionalExpression);

        // --- 3. Evaluate filter condition ---
        let conditionMet = true;
        if (conditionalExpression) {
            const trimmed = conditionalExpression.trim().toLowerCase();
            if (trimmed === 'true') conditionMet = true;
            else if (trimmed === 'false') conditionMet = false;
            else {
                try {
                    conditionMet = new Function(`return (${conditionalExpression});`)();
                } catch (error) {
                    console.error(`Error evaluating filter condition for ${calcName}:`, conditionalExpression, error);
                    conditionMet = false;
                }
            }
        }

        // --- 4. Evaluate the formula if filter passes ---
        let result = null;
        if (isBooleanCalculation) {
            result = (String(calculatedFormula).trim().toLowerCase() === 'true');
        } else if (conditionMet) {
            try {
                result = new Function(`return (${calculatedFormula});`)();
            } catch (error) {
                console.error(`Error applying formula for ${calcName}:`, calculatedFormula, error);
                result = null;
            }
        } else {
            result = null; // filter failed
        }

        // --- 5. Assign result to row ---
        row[calcName] = result;
    });
}


    // 4. Apply the first available filter
    const firstFilterName = Object.keys(savedFilters)[0];
    if (firstFilterName) {
        const filterExpression = savedFilters[firstFilterName];
        
        // Temporarily set the builder's preview so applySavedFilter can read it
      //  document.getElementById('filter-preview').value = filterExpression;
      //  document.getElementById('filter-name-input').value = firstFilterName;

        // Apply the filter using the robust function
        applySavedFilter(false); 
    } else {
        // No filter to apply, just refresh table to show calculated columns
        displayReportTable('loadConfigFromJSON');
    }
    
    // 5. Refresh UI controls (dropdowns)
    initializeControls(); 
}
 

localStorage.clear();

 

// Converts date literals (e.g., '1/1/2025' - 10) into milliseconds
function replaceDateLiterals(expr) {
    return expr.replace(/(['"])(\d{1,2}\/\d{1,2}\/\d{2,4})\1\s*([+-])?\s*(\d+)?/g, (match, quote, dateStr, op, days) => {
        const d = new Date(dateStr);
        if (isNaN(d.getTime())) {
            console.warn('Invalid date literal in expression:', dateStr);
            return 0;
        }

        let ms = d.getTime();
        if (op && days) {
            ms += (op === '+' ? 1 : -1) * parseInt(days, 10) * 24 * 60 * 60 * 1000;
        }

        return ms;
    });
}

function checkDateComparison(executableFilter, dateColumns) {
    for (const col of dateColumns) {
        // Regex to find the numeric timestamp of a date column in comparisons
        const regex = new RegExp(`\\b${col}\\b\\s*(<=|>=|<|>)\\s*([0-9]+)`, 'g');
        let match;
        while ((match = regex.exec(executableFilter)) !== null) {
            const rightValue = parseFloat(match[2]);
            // If the right side is suspiciously "small" (< 10^10), treat as invalid
            if (rightValue < 1e10) {
                throw new Error(`Invalid comparison: Date column "${col}" compared to a non-date value "${match[2]}"`);
            }
        }
    }
}

function validateDateComparisons(filterExpression, columnMap) {
    for (const colName in columnMap) {
        if (columnMap[colName] !== 'date') continue;

        // Ensure we match the column name format used in the filter (e.g., [DateColumn])
        const escapedName = escapeRegExp(`[${colName}]`);
        // Regex looks for [ColumnName] followed by an operator and then any non-space/non-closing-paren value
        const regex = new RegExp(`${escapedName}\\s*(<=|>=|<|>)\\s*([^\\s)]+)`, 'g');

        let match;
        while ((match = regex.exec(filterExpression)) !== null) {
            const operator = match[1];
            const rightSide = match[2].trim();

            const numericValue = parseFloat(rightSide);
            
            // A realistic date timestamp (ms since epoch) is always a very large number (>= 1e10).
            // Any numeric value smaller than that (like 15) is invalid for a date comparison.
            if (!isNaN(numericValue) && numericValue < 1e10) {
                // If it's a small number, throw an error
                throw new Error(
                    `Invalid comparison for date column "${colName}": cannot compare to non-date value "${rightSide}" with operator "${operator}"`
                );
            } 
        }
    }
}



function applySavedFilter(clearFlag = false) {
    return new Promise((resolve, reject) => {
        const filterExpression = clearFlag ? '' : document.getElementById('filter-preview').value.trim();

        if (!filterExpression) {
            reporttblData.rows = originalReportData;
            displayReportTable('applySavedFilter');
            resolve(); // no error, promise resolves
            return;
        }

        const columnMap = tableColumns.reduce((map, col) => {
            map[col.name] = col.type;
            return map;
        }, {});

        let validatedFilterTemplate;
        try {
            validatedFilterTemplate = replaceDateLiterals(filterExpression);
            validateDateComparisons(validatedFilterTemplate, columnMap);
        } catch (e) {
            console.error('Filter validation error:', e.message);
            reject(new Error(`Validation error: ${e.message}`)); // reject promise
            return;
        }

        let filterErrorOccurred = false;
        const filteredRows = originalReportData.filter(row => {
            let executableFilter = validatedFilterTemplate;

            for (const colName in columnMap) {
                const escapedName = escapeRegExp(`[${colName}]`);
                const regex = new RegExp(escapedName, 'g');
                let cellValue = row[colName];

                if (columnMap[colName] === 'number') {
                    const numericValue = parseFloat(cellValue);
                    cellValue = !isNaN(numericValue) ? numericValue : 0;
                } else if (columnMap[colName] === 'date') {
                    const dateObj = new Date(cellValue);
                    cellValue = !isNaN(dateObj.getTime()) ? dateObj.getTime() : 0;
                } else {
                    cellValue = `'${String(cellValue).replace(/'/g, "\\'")}'`;
                }

                executableFilter = executableFilter.replace(regex, cellValue);
            }

            try {
                return eval(executableFilter);
            } catch (e) {
                console.error('Filter evaluation error:', e, 'Expression:', executableFilter);
                filterErrorOccurred = true;
                return false;
            }
        });

        if (filterErrorOccurred) {
            reporttblData.rows = originalReportData;
            displayReportTable('filterErrorOccurred');
            reject(new Error('Error evaluating filter expression')); // reject promise
            return;
        }

        reporttblData.rows = filteredRows;
      
        const dialogUpdate = document.getElementById("update-saved-filter"); 
            // Get the computed style of the element
            const computedStyle = window.getComputedStyle(dialogUpdate); 
            // Check if the 'display' property is NOT 'none'
            if (computedStyle.display == 'none') {
                // The element is visible (or at least not display: none)
                addSavedFilter();
            }
     
        //displayReportTable();
        resolve(); // success
         const dialog = document.getElementById("filter-dialog");
         dialog.style.display = "none";
    });
}


function clearFilterBuilder() {
    document.getElementById('filter-preview').value = '';
    document.getElementById('filter-name-input').value = '';
    // Clear status and disable update button
    document.getElementById('update-saved-filter').setAttribute('aria-disabled', 'true');
    currentFilterName = '';
    // Call the apply function with clear flag to reset the table
    applySavedFilter(true); 
}

function saveFilters() {
    localStorage.setItem('savedFilters', JSON.stringify(savedFilters));
    loadSavedFilters();
}

function loadSavedFilters() {
    const listElement = document.getElementById('saved-filters-list');
    listElement.innerHTML = '';
    
    const saved = localStorage.getItem('savedFilters');
    if (saved) {
        savedFilters = JSON.parse(saved);
    } else {
        savedFilters = {};
    }

    // console.log('savedFilters:>>>>>>>',savedFilters); 
     for (const [name, formulaObj] of Object.entries(savedFilters)) { 
    
            renderSavedFilter(name,formulaObj);
    }

}

function renderSavedFilter(name, filterExpression) {
  const savedFiltersList = document.getElementById('saved-filters-list');

  const row = document.createElement('tr');
  row.className = 'filter-item';
  row.innerHTML = `
    <td><strong>${name}</strong></td>
    <td>${filterExpression}</td>
    <td>
      <div class="action-btn btn-secondary" onclick="useFilter('${name}')">Update</div>
    </td>
    <td>
       <div class="action-btn btn-danger" onclick="deleteFilter('${name}')">Delete</div>
    </td>
  `;

  savedFiltersList.appendChild(row);
}

function useFilter(name) { 
    const filter = savedFilters[name]; 
    if (filter) {
        document.getElementById('filter-preview').value = filter;
        document.getElementById('filter-name-input').value = name;
        document.getElementById('update-saved-filter').setAttribute('aria-disabled', 'false');
        currentFilterName = name;
                const dialog = document.getElementById("filter-dialog"); 
        dialog.style.display = "flex";
        const dialogupdate = document.getElementById("update-saved-filter"); 
        dialogupdate.style.display = "flex";

                const addButton = document.getElementById('add-saved-filter'); 
                    addButton.style.display = 'none';
                    const dialogSave = document.getElementById("apply-saved-filter");
                    dialogSave.style.display = "none";
                    // console.log('addButton:>>>>>',addButton);
               

            }
          
        }

function deleteFilter(name) {
    if (confirm(`Are you sure you want to delete the filter: ${name}?`)) {
        delete savedFilters[name];
        saveFilters();
        saveAllDataToJSON();
    handleSave();
    
    displayReportTable('deleteFilter');
        if (currentFilterName === name) {
             clearFilterBuilder(); 
        }
    }
}

function addSavedFilter() {
    
    const name = document.getElementById('filter-name-input').value;
    const filter = document.getElementById('filter-preview').value;
    
    if (name in savedFilters) {
        alert(`Filter name "${name}" already exists. Use "Update Saved Filter" instead.`);
        return;
    }
    if (!name || !filter) {
        alert('Please enter both a name and a filter expression.');
        return;
    }
    
    savedFilters[name] = filter;
    saveFilters();
  //  clearFilterBuilder();
    

    saveAllDataToJSON();
    handleSave();
    
    

    displayReportTable('addSavedFilter');
    loadSavedFormatters();

   // applySavedFilter();
}

// Make updateSavedFilter async
async function updateSavedFilter() {
    try {
        await applySavedFilter(); // will stop here if promise rejects
    } catch (err) {
        // console.log('Filter application failed:', err.message);
        return; // execution stops here
    }

    const name = document.getElementById('filter-name-input').value;
    const filter = document.getElementById('filter-preview').value;

    if (!name || !filter || !(name in savedFilters)) {
        alert('Cannot update. Please select an existing filter using the "Use" button first.');
        return;
    }

    savedFilters[name] = filter;
    saveFilters();
    currentFilterName = name;

    saveAllDataToJSON();
    handleSave();
    
    displayReportTable('updateSavedFilter');
    loadSavedFormatters();
}



function loadSavedFormulas() {
    const savedFormulasList = document.getElementById('saved-formulas-list');
    savedFormulasList.innerHTML = '';
    
    // Load from localStorage if available
    const storedFormulas = localStorage.getItem('savedFormulas');
    if (storedFormulas) {
        savedFormulas = JSON.parse(storedFormulas);
    }
    // console.log('savedFormulas:>>>>', savedFormulas);
    
    // Display saved formulas
    for (const [name, formulaObj] of Object.entries(savedFormulas)) {
        // Handle both formats: string (old) and object (new)
        let formulaDisplay, formulaType;
        
        if (typeof formulaObj === 'string') {
            formulaDisplay = formulaObj;
            formulaType = 'number'; // Default type for old format
        } else if (formulaObj && typeof formulaObj.formula === 'string') {
            formulaDisplay = formulaObj.formula;
            formulaType = formulaObj.type || 'number';
        } else {
            console.warn(`Invalid formula format for ${name}:`, formulaObj);
            continue;
        }
        

renderSavedFormula(name, "", formulaDisplay);
    }
    
    // Add event listeners to formula buttons (now divs)
    document.querySelectorAll('.use-formula').forEach(div => {
        div.addEventListener('click', function() {
            const formulaName = this.getAttribute('data-name');
            useFormula(formulaName);
        });
    });
    
    document.querySelectorAll('.delete-formula').forEach(div => {
        div.addEventListener('click', function() {
            const formulaName = this.getAttribute('data-name');
            deleteFormula(formulaName);
        });
    });
}
        
        // Use a saved formula
       function useFormula(formulaName) {
            if (!savedFormulas[formulaName]) {
                alert(`Formula "${formulaName}" not found!`);
                return;
            }
            
            const formulaObj = savedFormulas[formulaName];
        let formulaString = '';
let formfilter = '';

if (typeof formulaObj === 'string') {
    formulaString = formulaObj;
    // formfilter remains empty for string format, adjust if needed
} else if (formulaObj && typeof formulaObj.formula === 'string') {
    // This block handles the object format (which your example formulaObj uses)
    formulaString = formulaObj.formula;  
    formfilter = formulaObj.filter !== undefined ? formulaObj.filter : '';
    
} else if (formulaObj ) {
 
    formfilter = formulaObj.filter;
} else {
    alert(`Invalid formula format for "${formulaName}"!`);
    return;
}
 
document.getElementById('calc-name').value = formulaName;
document.getElementById('formula-preview').value = formulaString;
document.getElementById('formulafilter-preview').value = formfilter; // This will now have the correct value
currentFormulaName = formulaName;
    
    // Enable update button
    const updateBtn = document.getElementById('update-calculation');
    updateBtn.setAttribute('aria-disabled', 'false');
    updateBtn.style.opacity = '1';
    updateBtn.style.cursor = 'pointer';
    
    // console.log(`Loaded formula: ${formulaName} = ${formulaString}`);

    const dialog = document.getElementById("formula-dialog");
    dialog.style.display = "flex";
    const addButton = document.getElementById('add-calculation');
    if (addButton) {
        addButton.style.display = 'none';
    }  

}

     function renderSavedFormula(name, formulaType, formulaDisplay) {
            const savedFormulasList = document.getElementById('saved-formulas-list');

            const row = document.createElement('tr');
            row.className = 'formula-item';
            row.innerHTML = `
                <td><strong>${name}</strong></td>
                <td>${formulaDisplay}</td>
                <td>
                <div class="action-btn btn-secondary use-formula" data-name="${name}" role="button">Update</div> 
                </td>
                <td>
                <div class="action-btn btn-danger delete-formula" data-name="${name}" role="button">Delete</div>
                </td>
            `;

            savedFormulasList.appendChild(row);
            }

        // Delete a saved formula
        function deleteFormula(formulaName) {
            if (confirm(`Are you sure you want to delete the formula "${formulaName}"?`)) {
                delete savedFormulas[formulaName];
                saveFormulas();
                loadSavedFormulas();

                saveAllDataToJSON();
                handleSave(); 
                
                
                // If we're currently editing this formula, clear the form
                if (currentFormulaName === formulaName) {
                    clearFormula();
                }
                //displayReportTable();
                generateJson();
            }
        }
        
        // Save formulas to localStorage
        function saveFormulas() {
            localStorage.setItem('savedFormulas', JSON.stringify(savedFormulas));
        }

// Calculate operation on column
 function calculateOperation() {
    const column = document.getElementById('column-select').value;
    const operation = document.getElementById('operation').value;
    
    if (!column) {
        alert('Please select a column first!');
        return;
    }
    
    let result;
    
    // Filter out rows and parse values as numbers
    const values = reporttblData.rows
        .map(row => parseFloat(row[column])) // CRUCIAL: Parse string values to floats
        .filter(val => !isNaN(val));
    
    if (values.length === 0) {
        alert(`No numeric data found for column: ${column.split(' - ')[0]}`);
        return;
    }
    
    switch(operation) {
        case 'sum':
            result = values.reduce((acc, val) => acc + val, 0);
            break;
        case 'average':
            result = values.reduce((acc, val) => acc + val, 0) / values.length;
            break;
        case 'min':
            result = Math.min(...values);
            break;
        case 'max':
            result = Math.max(...values);
            break;
        case 'count':
            result = values.length;
            break;
    }
    
    // Display result
    const summaryResults = document.getElementById('summary-results');
    const summaryItem = document.createElement('div');
    summaryItem.className = 'summary-item';
    summaryItem.innerHTML = `<strong>${operation.toUpperCase()}</strong> of <strong>${column.split(' - ')[0].replace(/_/g, ' ')}</strong>: ${typeof result === 'number' ? result.toFixed(2) : result}`;
    summaryResults.appendChild(summaryItem);
}

function applyFilter() {
    const column = document.getElementById('filter-column').value;
    const operator = document.getElementById('filter-operator').value;
    const value = document.getElementById('filter-value').value;
    
    if (!column || !value) {
        alert('Please select a column and enter a value!');
        return;
    }
    
    const columnMeta = tableColumns.find(col => col.name === column);
    
    const filteredRows = originalReportData.filter(row => { // Filter on original data
        let cellValue = row[column];
        
        if (!cellValue) return false;
        
        // Handle different data types appropriately
        if (columnMeta.type === 'number') {
            const numValue = parseFloat(value);
            cellValue = parseFloat(cellValue); // Parse cell value to number
            if (isNaN(cellValue)) return false;

            switch(operator) {
                case 'equals': return cellValue === numValue;
                case 'greater': return cellValue > numValue;
                case 'less': return cellValue < numValue;
                default: return true;
            }
        } else {
            // String and Date comparison (simple string comparison for dates here)
            const targetValue = value.toString().toLowerCase();
            cellValue = cellValue.toString().toLowerCase();
            
            switch(operator) {
                case 'equals': return cellValue === targetValue;
                case 'contains': return cellValue.includes(targetValue);
                default: return true;
            }
        }
    });

    reporttblData.rows = filteredRows;
    
    // !!! CRITICAL: You must ensure this function exists and refreshes your main table !!!
    displayReportTable('applyFilter'); 
}

function clearFilter() {
    document.getElementById('filter-value').value = '';
    
    if (originalReportData) {
        reporttblData.rows = originalReportData;
        
        displayReportTable('clearFilter');
    }
}

let INITIAL_CONFIG_JSON = {
    "columnMetadata": [
        { "name": "ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON - York_temp14", "type": "string" },
        { "name": "HAMPTON_BY_HILTON_YORK - York_temp14", "type": "number" },
        { "name": "STAY_DATE - York_temp14", "type": "date" },
        { "name": "DOUBLETREE_BY_HILTON_YORK - York_temp14", "type": "string" },
        { "name": "MOXY_YORK - York_temp14", "type": "number" },
        { "name": "NOVOTEL_YORK_CENTRE - York_temp14", "type": "number" },
        { "name": "f1", "type": "number" } // Calculated column must be here
    ],
    "formulas": {
        "formula1": "[HAMPTON_BY_HILTON_YORK - York_temp14]"
    },
    "filters": {
        "f1": " [ELMBANK_YORK_TAPESTRY_COLLECTION_BY_HILTON - York_temp14]> 105"
    }
};

let pristineReportData = [];  

function roundNumber(value) {
    if (typeof value === 'number') {
        return Math.round(value * 100) / 100;
    }
    if (typeof value === 'string' && !isNaN(parseFloat(value))) {
        return Math.round(parseFloat(value) * 100) / 100;
    }
    return value;
}

function roundAllNumbersInRows(rows) {
    rows.forEach(row => {
        for (const key in row) {
            if (row.hasOwnProperty(key)) {
                row[key] = roundNumber(row[key]);
            }
        }
    });
}

function loadDashboard(pData, configData = INITIAL_CONFIG_JSON) { // Added configData parameter
    // console.log('Table data received for tab:', pData);
      console.log('INITIAL_CONFIG_JSON:', INITIAL_CONFIG_JSON);
    
    if (!pData || !pData.rows) {
        console.error("No valid data received.");
        return;
    }


    // Round numeric values in dataset
    roundAllNumbersInRows(pData.rows);

    // 2. Update Global Data (this will be transformed by aggregations)
    reporttblData.rows = JSON.parse(JSON.stringify(pData.rows)); 
    originalReportData = [...pData.rows]; 
     
  
    
    // 4. Apply any saved aggregations before displaying
    applyAggregations();
    
    // 5. Initialize Control Dropdowns & Setup UI
    
    setupCollapseButtons(); 
 
    displayReportTable('loadDashboard');
    initializeControls();
  // 3. Load Formulas/Filters from JSON and APPLY them
  console.log('configData:>>>>',configData);
    console.log('jsondata_details:>>>>',report_expressions);
    console.log('report_expressions:>>>>',report_expressions);
    if (configData) {
        loadConfigFromJSON(configData);
    }
    console.log('after loadconfig reporttblData:>',reporttblData);

 }

function applyDefaultBehavior() {
    // 1. DATA REVERSION: Start with a fresh copy of the raw row data
    let transformedRows = JSON.parse(JSON.stringify(pristineReportData));
    // 2. AGGREGATION APPLICATION
    jsondata_details.selectedColumns.forEach(column => {
        // --- FIX: Use helper function to get the correct data key ---
        const fullColumnName = getColumnDataKey(column); 
        // Skip if not a number OR if aggregation is set to 'none'
        if (column.data_type.toLowerCase() !== 'number' || column.aggregation === 'none' || !column.aggregation) {
            return;
        }
        
        const selectedAgg = column.aggregation;

        // --- Logic to calculate Sum/Avg/Min/Max/Count for a single column ---
        
        // Calculation is always based on the immutable PRISTINE data
        const values = pristineReportData 
            .map(row => parseFloat(row[fullColumnName])) // Now uses the correct key!
            .filter(val => !isNaN(val));

        if (values.length === 0) return;

        let result;
        switch (selectedAgg) {
            case 'sum':
                result = values.reduce((acc, val) => acc + val, 0);
                break;
            case 'average':
                result = values.reduce((acc, val) => acc + val, 0) / values.length;
                break;
            case 'min':
                result = Math.min(...values);
                break;
            case 'max':
                result = Math.max(...values);
                break;
            case 'count':
                result = values.length;
                break;
            default:
                return;
        }

        // Apply the calculated result to every row in the working data
        transformedRows.forEach(row => {
            row[fullColumnName] = result;
        });
    });
    
    // Update global data objects
    reporttblData.rows = transformedRows;
    originalReportData = [...transformedRows];
}


function applyAggregations() {
    // console.log('jsondata_details>>>>>>>>>>>>>>>>>>>>>>',jsondata_details);
    const groupDateColumn = jsondata_details.selectedColumns.find(
        col => col.data_type === 'date' && ['week', 'month', 'year'].includes(col.aggregation)
    );

    if (!groupDateColumn) {
        return applyDefaultBehavior();
    }

    const groupDateKey = `${groupDateColumn.col_name} - ${groupDateColumn.temp_name}`;
    const groupingFormat = groupDateColumn.aggregation;
    const groupedData = {};
    
    const tempJsondataDetails = JSON.parse(JSON.stringify(jsondata_details));

    // 3. APPLY VISIBILITY AND AGGREGATION RULES FOR GROUPING
    tempJsondataDetails.selectedColumns.forEach(col => {
        const fullKey = getColumnDataKey(col); // Use helper here too!
        
        if (col.data_type === 'string') {
            col.visibility = 'hide';
            col.aggregation = 'none';
        } else if (col.data_type === 'number') {
            if (col.aggregation === 'none' || !col.aggregation) {
                col.aggregation = 'sum';
            }
            col.visibility = 'show';
        } else if (col.data_type === 'date' && fullKey !== groupDateKey) {
            col.visibility = 'hide';
            col.aggregation = 'none';
        } else if (fullKey === groupDateKey) {
            col.visibility = 'show';
        }
    });
    jsondata_details = tempJsondataDetails;


    // 4. Perform the Grouping and Accumulation
    pristineReportData.forEach(row => {
        const groupKey = getGroupKey(row[groupDateKey], groupingFormat);
        
        if (!groupedData[groupKey]) {
            groupedData[groupKey] = {};
            groupedData[groupKey][groupDateKey] = groupKey;
            
            jsondata_details.selectedColumns.forEach(col => { 
                const fullKey = getColumnDataKey(col); // Use helper here too!
                if (col.data_type === 'number') {
                    groupedData[groupKey][fullKey] = {
                        sum: 0,
                        count: 0,
                        min: Infinity,
                        max: -Infinity,
                        finalValue: 0
                    };
                }
            });
        }
        
        // Accumulate numeric values based on their aggregation type
        jsondata_details.selectedColumns.forEach(col => {
            const fullKey = getColumnDataKey(col); // Use helper here too!
            if (col.data_type === 'number') {
                const val = parseFloat(row[fullKey]);
                if (!isNaN(val)) {
                    const groupItem = groupedData[groupKey][fullKey];
                    groupItem.sum += val;
                    groupItem.count++;
                    groupItem.min = Math.min(groupItem.min, val);
                    groupItem.max = Math.max(groupItem.max, val);
                }
            }
        });
    });

    // 5. Calculate Final Aggregated Values
    const finalTransformedRows = Object.values(groupedData).map(groupedRow => {
        const finalRow = {};
        finalRow[groupDateKey] = groupedRow[groupDateKey];

        jsondata_details.selectedColumns.forEach(col => {
            const fullKey = getColumnDataKey(col); // Use helper here too!
            if (col.data_type === 'number') {
                const aggData = groupedRow[fullKey];
                let finalValue = null;

                switch (col.aggregation) {
                    case 'sum':
                        finalValue = aggData.sum;
                        break;
                    case 'average':
                        finalValue = aggData.count > 0 ? aggData.sum / aggData.count : 0;
                        break;
                    case 'min':
                        finalValue = aggData.min === Infinity ? 0 : aggData.min;
                        break;
                    case 'max':
                        finalValue = aggData.max === -Infinity ? 0 : aggData.max;
                        break;
                    case 'count':
                        finalValue = aggData.count;
                        break;
                }
                finalRow[fullKey] = finalValue;
            } else if (col.data_type !== 'date') {
                finalRow[fullKey] = groupedRow[fullKey]; 
            }
        });
        return finalRow;
    });

    // 6. Update the global data
    reporttblData.rows = finalTransformedRows;
    originalReportData = [...finalTransformedRows];
}


    // Add to formula
    function addToFormula() {
        const column = document.getElementById('column-lov').value;
        const operator = document.getElementById('operator-lov').value;
        
        const formulaPreview = document.getElementById('formula-preview');
        
        if (column) {
            formulaPreview.value += `${column}`;
        }
        
        if (operator) {
            formulaPreview.value += `${operator}`;
        }

        // Optional: Add a space between elements if the input doesn't end with one
        if (column && operator) {
            formulaPreview.value = formulaPreview.value.trim() + ` `;
        }
    }
        
        // Clear formula
        function clearFormula() {
            document.getElementById('formula-preview').value = '';
            document.getElementById('calc-name').value = '';
            currentFormulaName = '';
            // Update disabled status for the div using aria-disabled attribute
            const updateBtn = document.getElementById('update-calculation');
            updateBtn.setAttribute('aria-disabled', 'true');
            updateBtn.style.opacity = '0.5'; // Visually show disabled state
            updateBtn.style.cursor = 'not-allowed'; // Change cursor
        }
        
        // Test formula
       function testFormula() {
    const currentFormula = document.getElementById('formula-preview').value.trim(); // formula only
    const currentFilter = (document.getElementById('filter-preview') && document.getElementById('filter-preview').value.trim()) || ''; // filter

    if (!currentFormula) {
        alert('Please create a formula first!');
        return;
    }

    try {
        let testResults = []; // store results per row

        pristineReportData.forEach(row => {
            let calculatedFormula = currentFormula;
            let conditionalExpression = currentFilter;
            let result = null;
            let isBooleanCalculation = false;

            // --- 0. Replace DAY_OF_WEEK expressions first ---
            calculatedFormula = replaceDayOfWeekExpressions(calculatedFormula, row);
            conditionalExpression = replaceDayOfWeekExpressions(conditionalExpression, row);
// Fix Day() function
calculatedFormula = replaceDayFunction(calculatedFormula);
conditionalExpression = replaceDayFunction(conditionalExpression);

            // --- 1. Replace all column references ---
            tableColumns.forEach(col => {
                const fullColName = col.name;
                const colType = col.type ? col.type.toLowerCase() : 'number';
                const rowValue = row[fullColName];

                // Replace in formula
                calculatedFormula = replaceColumnOccurrences(calculatedFormula, fullColName, colType, rowValue, 'formula');
                // Replace in filter/conditionalExpression
                conditionalExpression = replaceColumnOccurrences(conditionalExpression, fullColName, colType, rowValue, 'filter');
            });

            // --- 2. Normalize logical operators in filter ---
            if (conditionalExpression) {
                conditionalExpression = conditionalExpression
                    .replace(/\bAND\b/gi, '&&')
                    .replace(/\bOR\b/gi, '||')
                    .replace(/\s+/g, ' ')
                    .trim();
            }

            // --- 3. Evaluate filter condition ---
            let conditionMet = true;
            if (conditionalExpression) {
                const trimmed = conditionalExpression.trim().toLowerCase();
                if (trimmed === 'true') conditionMet = true;
                else if (trimmed === 'false') conditionMet = false;
                else {
                    conditionMet = new Function(`return (${conditionalExpression});`)();
                }
            }

            // --- 4. Evaluate the formula if filter passes ---
            if (isBooleanCalculation) {
                result = (String(calculatedFormula).trim().toLowerCase() === 'true');
            } else if (conditionMet) {
                try {
                    result = new Function(`return (${calculatedFormula});`)();
                } catch (e) {
                    console.error('Error evaluating formula:', calculatedFormula, e);
                    result = null;
                }
            } else {
                result = null;
            }

            // Save result for display
            testResults.push(result);
        });

        showSuccessMessage(`Formula test results per row:\n${testResults.join('\n')}`);

    } catch (error) {
        alert('Error in formula: ' + (error.message || error) + '. Please check your formula syntax.');
        console.error('Formula error:', error);
    }
}




function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
// ======================================================================
// HELPER FUNCTIONS (Place these outside the main addCalculation function)
// ======================================================================

// ---------------------- Helper utilities ----------------------

function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// Parse M/D/YYYY or MM/DD/YYYY to YYYY-MM-DD (returns null if not matched)
function parseMMDDYYYY(dateString) {
   // console.log('dateString:>>>>',dateString);
    try{
    const match = dateString.match(/^(\d{1,2})[/\-](\d{1,2})[/\-](\d{4})$/);
    if (match) {
        const month = match[1].padStart(2, '0');
        const day = match[2].padStart(2, '0');
        const year = match[3];
        return `${year}-${month}-${day}`;
    }
    return null;
    }
    catch(e){
         return null;
    }
}

// If formula contains "between ... and ..." for a date column, return "true"/"false" or null
function parseDateRange(formulaSegment, row) {
    const rangeMatch = formulaSegment.match(/(\[.*?\]|\b[\w\s\-]+\b)\s+between\s+([^\s]+)\s+and\s+([^\s]+)/i);
    if (!rangeMatch) return null;

    let colRef = rangeMatch[1].replace(/[\[\]]/g, '').trim();
    let startDateStr = rangeMatch[2];
    let endDateStr = rangeMatch[3];

    // Accept user MM/DD/YYYY or YYYY-MM-DD; normalize if possible
    const standardizedStart = parseMMDDYYYY(startDateStr) || startDateStr;
    const standardizedEnd = parseMMDDYYYY(endDateStr) || endDateStr;

    const rawValue = row[colRef];
    const colDateStr = parseMMDDYYYY(rawValue) || rawValue;

    const colValue = new Date(colDateStr);
    const startDate = new Date(standardizedStart);
    const endDate = new Date(standardizedEnd);

    if (isNaN(colValue) || isNaN(startDate) || isNaN(endDate)) {
        console.warn("Invalid date format in range calculation for", colRef, rawValue);
        return "false";
    }

    return (colValue.getTime() >= startDate.getTime() && colValue.getTime() <= endDate.getTime()) ? "true" : "false";
}

// Parse DAY_OF_WEEK([col]) In (Mon,Tue) - returns "true"/"false" or null
// Parse [DateCol] DAY_OF_WEEK (Mon,Tue)
function parseDayOfWeek(formulaSegment, row) {

    const regex = /(\[.*?\]|\b[\w\s\-]+\b)\s+DAY_OF_WEEK\s*\(\s*(.*?)\s*\)/i;
    const match = formulaSegment.match(regex);
    if (!match) return null;

    let colRef = match[1].replace(/[\[\]]/g, '').trim();
    let daysStr = match[2];

    const days = daysStr.split(",").map(d => d.trim().toUpperCase());

    const rawDate = row[colRef];
    const jsDate = new Date(rawDate);

    if (isNaN(jsDate)) return "false";

    const dow = jsDate.toLocaleDateString("en-GB", { weekday: "short" }).toUpperCase();

    return days.includes(dow) ? "true" : "false";
}


// Safely quote/escape a string for insertion into an expression
function jsStringLiteral(s) {
    if (s === null || s === undefined) return '""';
    return '"' + String(s).replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"';
}

// Replace all occurrences (bracketed and plain) of a column name in a text snippet.
// - text: string to replace inside
// - fullColName: column name from tableColumns (could have spaces etc.)
// - colType: 'date'|'string'|'number'
// - rowValue: raw value from row for this column
// - context: "formula" or "filter" (affects how date values are substituted)
function replaceColumnOccurrences(text, fullColName, colType, rowValue, context) {
    const escapedName = escapeRegExp(fullColName);
    const bracketedRegex = new RegExp('\\[\\s*' + escapedName + '\\s*\\]', 'gi');
    const plainRegex = new RegExp('\\b' + escapedName + '\\b', 'gi');

    let substitution;

    if (colType === 'date') {
        // For date, if context is filter and the text contains comparison operators, convert to getTime()
        // Otherwise keep an ISO date string for direct usage.
        const needsTimestamp = /[<>!=]=?|between|\bDAY_OF_WEEK\b/i.test(text) || context === 'formula' && /[\+\-*/]/.test(text);
        if (needsTimestamp) {
            // Use numeric timestamp for comparisons/arithmetic
            const dateStr = parseMMDDYYYY(rowValue) || rowValue;
            substitution = `(${isNaN(new Date(dateStr)) ? 'NaN' : 'new Date("' + dateStr + '").getTime()'})`;
        } else {
            substitution = jsStringLiteral(rowValue);
        }
    } else if (colType === 'string') {
        substitution = jsStringLiteral(rowValue || '');
    } else { // number (default)
        const num = parseFloat(rowValue);
        substitution = isNaN(num) ? 0 : num;
    }

    return text.replace(bracketedRegex, substitution).replace(plainRegex, substitution);
}

function replaceDayOfWeekExpressions(expr, row) {
    // Regex: match any [Col] DAY_OF_WEEK (Mon,Tue) anywhere in the expression
    const regex = /(\[.*?\]|\b[\w\s\-]+\b)\s+DAY_OF_WEEK\s*\(\s*(.*?)\s*\)/gi;

    return expr.replace(regex, (match, colRef, daysStr) => {
        colRef = colRef.replace(/[\[\]]/g, '').trim();
        const days = daysStr.split(",").map(d => d.trim().toUpperCase());

        const rawDate = row[colRef];
        const jsDate = new Date(rawDate);

        if (isNaN(jsDate)) return "false";

        const dow = jsDate.toLocaleDateString("en-GB", { weekday: "short" }).toUpperCase();
        return days.includes(dow) ? "true" : "false";
    });
}

// ---------------------- Main function ----------------------
function addCalculation() { 

    const calcName = document.getElementById('calc-name').value.trim();
    const currentFormula = document.getElementById('formula-preview').value.trim(); // formula only
    const currentFilter = (document.getElementById('formulafilter-preview') && document.getElementById('formulafilter-preview').value.trim()) || ''; // filter only (WHERE condition)

    if (!calcName || !currentFormula) {
        alert('Please enter a calculation name and create a formula!');
        return;
    }

    if (tableColumns.find(col => col.name === calcName)) {
        alert('Calculation name already exists as a column or another calculation!');
        return;
    }

    try {
        let ctype = 'number';
        // Work on a deep copy? We'll mutate pristineReportData rows directly like before
        pristineReportData.forEach(row => {
            let calculatedFormula = currentFormula;   // text to replace col references and evaluate
            let conditionalExpression = currentFilter; // text to replace col refs and evaluate to boolean
            let result = null;
            let isBooleanCalculation = false;

            // --- Handle complex date functions that may transform the formula into "true"/"false" ---
            // If formula itself contains date range or day_of_week, evaluate those first (they return "true"/"false")
            let dateRangeResult = parseDateRange(calculatedFormula, row);
            let dayOfWeekResult = parseDayOfWeek(calculatedFormula, row);

            if (dayOfWeekResult !== null) {
                calculatedFormula = dayOfWeekResult;
                isBooleanCalculation = true;
                ctype = "boolean";
            }

            if (dateRangeResult !== null) {
                calculatedFormula = dateRangeResult; // "true" or "false"
                isBooleanCalculation = true;
                ctype = 'boolean';
            } else if (dayOfWeekResult !== null) {
                calculatedFormula = dayOfWeekResult;
                isBooleanCalculation = true;
                ctype = 'boolean';
            }

            // If filter contains those date functions, evaluate them into "true"/"false" first
            let filterDateRange = conditionalExpression ? parseDateRange(conditionalExpression, row) : null;
            let filterDayOfWeek = conditionalExpression ? parseDayOfWeek(conditionalExpression, row) : null;
            if (filterDateRange !== null) {
                // Replace the whole filter with the evaluated boolean string so it can be used directly
                conditionalExpression = filterDateRange;
            } else if (filterDayOfWeek !== null) {
                conditionalExpression = filterDayOfWeek;
            }

            // Replace Day(...) occurrences (important) BEFORE column replacements and evaluation
            calculatedFormula = replaceDayFunction(calculatedFormula);
            conditionalExpression = replaceDayFunction(conditionalExpression);

            // If you also have a replaceDayOfWeekExpressions helper, keep using it
            calculatedFormula = replaceDayOfWeekExpressions(calculatedFormula, row);
            conditionalExpression = replaceDayOfWeekExpressions(conditionalExpression, row);

                        // Fix Day() function
            calculatedFormula = replaceDayFunction(calculatedFormula);
            conditionalExpression = replaceDayFunction(conditionalExpression);


            // --- Replace all column occurrences in both calculation formula and condition ---
            tableColumns.forEach(col => {
                const fullColName = col.name;
                const colType = col.type ? col.type.toLowerCase() : 'number';
                const rowValue = row[fullColName];

                // Replace in formula
                if (calculatedFormula && (new RegExp('\\b' + escapeRegExp(fullColName) + '\\b', 'i').test(calculatedFormula) ||
                    new RegExp('\\[\\s*' + escapeRegExp(fullColName) + '\\s*\\]', 'i').test(calculatedFormula))) {
                    calculatedFormula = replaceColumnOccurrences(calculatedFormula, fullColName, colType, rowValue, 'formula');

                    // Set ctype based on first non-boolean column type encountered
                    if (!isBooleanCalculation) {
                        if (colType === 'string') ctype = 'string';
                        else if (colType === 'date') ctype = 'string';
                        else ctype = 'number';
                    }
                }

                // Replace in conditionalExpression (filter)
                if (conditionalExpression && (new RegExp('\\b' + escapeRegExp(fullColName) + '\\b', 'i').test(conditionalExpression) ||
                    new RegExp('\\[\\s*' + escapeRegExp(fullColName) + '\\s*\\]', 'i').test(conditionalExpression))) {
                    conditionalExpression = replaceColumnOccurrences(conditionalExpression, fullColName, colType, rowValue, 'filter');
                }
            });

            // --- Evaluate the condition (if provided) ---
            let conditionMet = true;
            if (conditionalExpression) {
                try {
                    // When conditionalExpression is a literal "true"/"false" from date helpers, handle directly
                    const trimmed = conditionalExpression.trim().toLowerCase();
                    if (trimmed === 'true' || trimmed === '"true"' || trimmed === "'true'") {
                        conditionMet = true;
                    } else if (trimmed === 'false' || trimmed === '"false"' || trimmed === "'false'") {
                        conditionMet = false;
                    } else {
                        // Evaluate JavaScript expression (after replacements)
                        conditionMet = new Function(`return (${conditionalExpression});`)();
                    }
                } catch (e) {
                    console.error('Error evaluating filter condition:', conditionalExpression, e);
                    conditionMet = false;
                }
            }

            // --- Final evaluation of the formula ---
            if (isBooleanCalculation) {
                // calculatedFormula should now be "true" or "false"
                result = (String(calculatedFormula).trim().toLowerCase() === "true");
            } else if (conditionMet) {
                try {
                    // Evaluate numeric/string expressions
                    result = new Function(`return (${calculatedFormula});`)();
                } catch (e) {
                    console.error('Error evaluating calculated formula:', calculatedFormula, e);
                    result = null;
                }
            } else {
                result = null;
            }

            // Set result and coerce type for the column
            if (ctype === 'number' && result !== null && result !== undefined) {
                const numeric = parseFloat(result);
                row[calcName] = isNaN(numeric) ? null : numeric;
            } else if (ctype === 'boolean') {
                row[calcName] = Boolean(result);
            } else { // string or fallback
                row[calcName] = result === null || result === undefined ? null : String(result);
            }
        });

        // --- Add metadata column if not present ---
        const newCalcColumn = { name: calcName, type: ctype };
        if (!tableColumns.find(col => col.name === calcName)) {
            tableColumns.push(newCalcColumn);
            report_expressions.columnMetadata.push(newCalcColumn);
            savedCalculationColumns.push(newCalcColumn);

            jsondata_details.selectedColumns.push({
                col_name: calcName, temp_name: 'calc', alias_name: calcName,
                aggregation: 'none', visibility: 'show', data_type: ctype
            });
        }

        savedFormulas[calcName] = { formula: currentFormula, filter: currentFilter, type: ctype };
        saveFormulas();

        reporttblData.rows = JSON.parse(JSON.stringify(pristineReportData));
        originalReportData = [...reporttblData.rows];

        applyAggregations();
        initializeControls();
        clearFormula();

    } catch (error) {
        alert('Error in formula: ' + (error && error.message ? error.message : error) + '. Please check your formula syntax.');
        console.error('Formula error:', error);
    }

    saveAllDataToJSON();
    handleSave();
    displayReportTable('addCalculation');
}


function replaceDayFunction(expr) {
    if (!expr || typeof expr !== "string") return expr;

    // For numeric day of month:
  //  return expr.replace(/Day\s*\(\s*([^)]+?)\s*\)/gi, '(new Date($1).getDate())');

    // If you want weekday names instead, use:
     return expr.replace(/Day\s*\(\s*([^)]+?)\s*\)/gi,
          "(['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][ new Date($1).getDay() ])");
}


        let savedCalculationColumns = []; 


       function recalculateAllFormulas() {
    if (!savedFormulas || Object.keys(savedFormulas).length === 0) return;
    if (!pristineReportData || pristineReportData.length === 0) return;

     console.log("Recalculating all formulas...",pristineReportData);
        pristineReportData = reporttblData.rows;
    pristineReportData.forEach(row => {
        for (const [calcName, meta] of Object.entries(savedFormulas)) {
            const formula = typeof meta === 'object' ? meta.formula : meta;
            const type = typeof meta === 'object' ? meta.type : 'number';
            let result = null;

            try {
                let workingFormula = formula;

                // Loop through all known columns
                tableColumns.forEach(col => {
                    const fullColName = col.name;
                    if (workingFormula.includes(fullColName)) {
                        const escaped = escapeRegExp(fullColName);
                        const regex = new RegExp(escaped, "g");

                        if (col.type === "date" || type === "date") {
                            const rawValue = row[fullColName];
                            const dateObj = new Date(rawValue);

                            if (isNaN(dateObj)) return;

                            if (/day/i.test(workingFormula)) {
                                const dayName = dateObj.toLocaleDateString("en-GB", { weekday: "short" }).toUpperCase();
                                result = dayName;
                            } else if (/\+/.test(workingFormula) || /-/.test(workingFormula)) {
                                const match = workingFormula.match(/([\+\-])\s*(\d+)/);
                                if (match) {
                                    const sign = match[1];
                                    const num = parseInt(match[2]);
                                    if (sign === "+") dateObj.setDate(dateObj.getDate() + num);
                                    else dateObj.setDate(dateObj.getDate() - num);
                                }
                                result = dateObj.toLocaleDateString("en-GB", {
                                    day: "2-digit",
                                    month: "short",
                                    year: "numeric"
                                }).toUpperCase();
                            } else {
                                result = rawValue;
                            }

                            workingFormula = workingFormula.replace(regex, `"${result}"`);
                        } else {
                            const val = parseFloat(row[fullColName]) || 0;
                            workingFormula = workingFormula.replace(regex, val);
                        }
                    }
                });

                if (result === null && type !== 'date') {
                    result = eval(`(${workingFormula})`);
                }

                row[calcName] = result;
            } catch (err) {
                console.error("Formula error:", err);
                row[calcName] = "ERR";
            }
        }
    });

    // Update report data
    reporttblData.rows = JSON.parse(JSON.stringify(pristineReportData));
    displayReportTable('recalculateAllFormulas');
}


       function updateCalculation() {
    // Prevent action if disabled
    if (document.getElementById('update-calculation').getAttribute('aria-disabled') === 'true') {
        return;
    }

    const currentFormula = document.getElementById('formula-preview').value.trim();
    const currentFilter  = (document.getElementById('formulafilter-preview') && document.getElementById('formulafilter-preview').value.trim()) || '';

    if (!currentFormulaName) {
        alert('Please select a formula to update first!');
        return;
    }

    if (!currentFormula) {
        alert('Please modify the formula first!');
        return;
    }

    try {
        // Apply formula to all rows
        pristineReportData.forEach(row => {
            let calculatedFormula = currentFormula;
            let conditionalExpression = currentFilter;
            let result = null;
            let isBooleanCalculation = false;
            let ctype = 'number';

            // --- Handle complex date functions in formula
            let dateRangeResult = parseDateRange(calculatedFormula, row);
            let dayOfWeekResult = parseDayOfWeek(calculatedFormula, row);
            if (dateRangeResult !== null) {
                calculatedFormula = dateRangeResult;
                isBooleanCalculation = true;
                ctype = 'boolean';
            } else if (dayOfWeekResult !== null) {
                calculatedFormula = dayOfWeekResult;
                isBooleanCalculation = true;
                ctype = 'boolean';
            }

            // --- Handle complex date functions in filter
            let filterDateRange = conditionalExpression ? parseDateRange(conditionalExpression, row) : null;
            let filterDayOfWeek = conditionalExpression ? parseDayOfWeek(conditionalExpression, row) : null;
            if (filterDateRange !== null) {
                conditionalExpression = filterDateRange;
            } else if (filterDayOfWeek !== null) {
                conditionalExpression = filterDayOfWeek;
            }

calculatedFormula = replaceDayOfWeekExpressions(calculatedFormula, row);
conditionalExpression = replaceDayOfWeekExpressions(conditionalExpression, row);

// Fix Day() function
calculatedFormula = replaceDayFunction(calculatedFormula);
conditionalExpression = replaceDayFunction(conditionalExpression);


            // --- Replace column references in formula & filter ---
            tableColumns.forEach(col => {
                const fullColName = col.name;
                const colType = col.type ? col.type.toLowerCase() : 'number';
                const rowValue = row[fullColName];

                if (calculatedFormula && (new RegExp('\\b' + escapeRegExp(fullColName) + '\\b', 'i').test(calculatedFormula) ||
                    new RegExp('\\[\\s*' + escapeRegExp(fullColName) + '\\s*\\]', 'i').test(calculatedFormula))) {
                    calculatedFormula = replaceColumnOccurrences(calculatedFormula, fullColName, colType, rowValue, 'formula');

                    if (!isBooleanCalculation) {
                        if (colType === 'string') ctype = 'string';
                        else if (colType === 'date') ctype = 'string';
                        else ctype = 'number';
                    }
                }

                if (conditionalExpression && (new RegExp('\\b' + escapeRegExp(fullColName) + '\\b', 'i').test(conditionalExpression) ||
                    new RegExp('\\[\\s*' + escapeRegExp(fullColName) + '\\s*\\]', 'i').test(conditionalExpression))) {
                    conditionalExpression = replaceColumnOccurrences(conditionalExpression, fullColName, colType, rowValue, 'filter');
                }
            });

 

            // --- Evaluate filter condition ---
            let conditionMet = true;
            if (conditionalExpression) {
                try {
                    const trimmed = conditionalExpression.trim().toLowerCase();
                    if (trimmed === 'true' || trimmed === '"true"' || trimmed === "'true'") conditionMet = true;
                    else if (trimmed === 'false' || trimmed === '"false"' || trimmed === "'false'") conditionMet = false;
                    else conditionMet = new Function(`return (${conditionalExpression});`)();
                } catch (e) {
                    console.error('Error evaluating filter condition:', conditionalExpression, e);
                    conditionMet = false;
                }
            }

            // --- Final formula evaluation ---
            if (isBooleanCalculation) {
                result = (String(calculatedFormula).trim().toLowerCase() === "true");
            } else if (conditionMet) {
                try {
                    result = new Function(`return (${calculatedFormula});`)();
                } catch (e) {
                    console.error('Error evaluating formula:', calculatedFormula, e);
                    result = null;
                }
            } else {
                result = null;
            }

            // --- Coerce type ---
            if (ctype === 'number' && result !== null && result !== undefined) {
                const numeric = parseFloat(result);
                row[currentFormulaName] = isNaN(numeric) ? null : numeric;
            } else if (ctype === 'boolean') {
                row[currentFormulaName] = Boolean(result);
            } else {
                row[currentFormulaName] = result === null || result === undefined ? null : String(result);
            }
        });

        // --- Save updated formula + filter ---
        const formulaType = currentFormulaName.match(/DAY/i) ? 'date'
            : tableColumns.some(c => c.type === 'date' && currentFormula.includes(c.name))
                ? 'date'
                : 'number';

        savedFormulas[currentFormulaName] = {
            formula: currentFormula,
            filter: currentFilter,
            type: formulaType
        };
        saveFormulas();

        reporttblData.rows = JSON.parse(JSON.stringify(pristineReportData));
        originalReportData = [...reporttblData.rows];

        applyAggregations();
        initializeControls();
        displayReportTable('updateCalculation');
        clearFormula();

    } catch (error) {
        alert('Error in formula: ' + (error && error.message ? error.message : error));
        console.error(error);
    }

    // Close dialog
    const dialog = document.getElementById("formula-dialog");
    if (dialog) dialog.style.display = "none";

    saveAllDataToJSON();
    handleSave();
    displayReportTable('updateCalculation');
}
        
        
        
        
    
       
        
        // Collapse/expand panels
        function setupCollapseButtons() {
            document.querySelectorAll('.collapse-btn').forEach(div => { // Change from button to div
                div.addEventListener('click', function() {
                    const panel = this.closest('.control-panel');
                    //const content = panel.querySelectorAll('> *:not(h2)');
                    const content = panel.querySelectorAll(':scope > *:not(h2)');
                    const isCollapsed = this.textContent === '+';
                    
                    content.forEach(el => {
                        el.style.display = isCollapsed ? 'block' : 'none';
                    });
                    
                    this.textContent = isCollapsed ? '−' : '+';
                    this.setAttribute('aria-expanded', isCollapsed ? 'true' : 'false'); // Update ARIA attribute
                });
            });
        }
        

        // --- Dynamic Operator LOV based on column type ---
$(document).on("change", "#column-lov", function () {
    const selectedValue = $(this).val();
    if (!selectedValue) return;

    // console.log("Column changed:", selectedValue);

    // Try to get column data type from tableColumns or columns_list
    let columnType = null;
    if (typeof tableColumns !== "undefined" && Array.isArray(tableColumns)) {
        const found = tableColumns.find(c => c.name === selectedValue);
        if (found && found.type) {
            columnType = found.type.toLowerCase();
        }
    }

    // console.log("Detected column type:", columnType);

    const operatorLov = document.getElementById("operator-lov");

    // Default operator list
    let operators = [
        { value: "+", label: "+ (Add)" },
        { value: "-", label: "- (Subtract)" },
        { value: "*", label: "* (Multiply)" },
        { value: "/", label: "/ (Divide)" },
        { value: "(", label: "(Open Paren)" },
        { value: ")", label: ") (Close Paren)" }
    ];

    // If Date type → show only +, -, Day
    if (columnType === "date") {
        operators = [
            { value: "+", label: "+ (Add)" },
            { value: "-", label: "- (Subtract)" },
            { value: "Day", label: "Day (Interval)" }
        ];
    }

    // Rebuild operator LOV dynamically
    operatorLov.innerHTML = "";
    const defaultOpt = document.createElement("option");
    defaultOpt.value = "";
    defaultOpt.textContent = "Select Operator";
    operatorLov.appendChild(defaultOpt);

    operators.forEach(op => {
        const opt = document.createElement("option");
        opt.value = op.value;
        opt.textContent = op.label;
        operatorLov.appendChild(opt);
    });

    // console.log("Operator LOV updated:", operators);
});


  // --- Dynamic Operator LOV based on column type ---
$(document).on("change", "#column-lovfilter", function () {
    const selectedValue = $(this).val();
    if (!selectedValue) return;

    // console.log("Column changed:", selectedValue);

    // Try to get column data type from tableColumns or columns_list
    let columnType = null;
    if (typeof tableColumns !== "undefined" && Array.isArray(tableColumns)) {
        const found = tableColumns.find(c => c.name === selectedValue);
        if (found && found.type) {
            columnType = found.type.toLowerCase();
        }
    }

    // console.log("Detected column type:", columnType);

    const operatorLov = document.getElementById("operator-lovfilter");

    // Default operator list
    let operators = [
   { value: "===", label: "Equals (=)" },
    { value: "!==", label: "Not Equals (!=)" },
    { value: ">", label: "Greater Than (>)" },
    { value: "<", label: "Less Than (<)" },
    { value: ">=", label: "Greater Than or Equal (>=)" },
    { value: "<=", label: "Less Than or Equal (<=)" },
    { value: "&&", label: "AND (&&)" },
    { value: "||", label: "OR (||)" } 
    ];

    // If Date type → show only +, -, Day
    if (columnType === "date") {
        operators = [
         //   { value: "All", label: "All" },
            { value: "Range", label: "Range" },
            { value: "Day_Of_Week", label: "Day Of Week" }
        ];
    }

    // Rebuild operator LOV dynamically
    operatorLov.innerHTML = "";
    const defaultOpt = document.createElement("option");
    defaultOpt.value = "";
    defaultOpt.textContent = "Select Operator";
    operatorLov.appendChild(defaultOpt);

    operators.forEach(op => {
        const opt = document.createElement("option");
        opt.value = op.value;
        opt.textContent = op.label;
        operatorLov.appendChild(opt);
    });

    // console.log("Operator LOV updated:", operators);
});

function filteraddToFormula() {
        const column = document.getElementById('column-lovfilter').value;
        const operator = document.getElementById('operator-lovfilter').value;
        
        const formulaPreview = document.getElementById('formulafilter-preview');

            if (column && formulaPreview) {
                // Check if the current value is an empty string ("")
                if (formulaPreview.value === "") { 
                    // ➡️ Field is empty: Add only the column name
                    formulaPreview.value += ` [${column}] `;
                } else {
                    // ➡️ Field already has content: Add ' and ' before the new column
                    formulaPreview.value += ` [${column}] `;
                }
            }
        
        if (operator) {
            if (operator === 'Range'){
                formulaPreview.value += ` between ${document.getElementById('range-from').value} and ${document.getElementById('range-to').value} ` ;
            }
            else if(operator === 'Day_Of_Week'){
                    selectedDays = getSelectedDays() ;
                    formulaPreview.value += ` DAY_OF_WEEK  ( ${selectedDays} )`;
            }else if(operator === 'All'){
                    selectedDays = getSelectedDays() ;
                    formulaPreview.value += ` = All `;
            }else{
                    formulaPreview.value += ` ${operator} `;
            }
        }

        // Optional: Add a space between elements if the input doesn't end with one
        if (column && operator) {
            formulaPreview.value = formulaPreview.value.trim() + ` `;
        }
    }


     // --- Dynamic Operator LOV based on column type ---
$(document).on("change", "#filter-column-lov", function () {
    let selectedValue = $(this).val();
    if (!selectedValue) return;
selectedValue = selectedValue.replace(/^\[(.*?)\]$/, '$1');
    // console.log("Column changed:", selectedValue);

    // Try to get column data type from tableColumns or columns_list
    let columnType = null;
    if (typeof tableColumns !== "undefined" && Array.isArray(tableColumns)) {
        const found = tableColumns.find(c => c.name === selectedValue);
        if (found && found.type) {
            columnType = found.type.toLowerCase();
        }
    }

    // console.log("Detected column type:", columnType);

    const operatorLov = document.getElementById("filter-operator-lov");

    // Default operator list
    let operators = [ 
    { value: "===", label: "Equals (=)" },
    { value: "!==", label: "Not Equals (!=)" },
    { value: ">", label: "Greater Than (>)" },
    { value: "<", label: "Less Than (<)" },
    { value: ">=", label: "Greater Than or Equal (>=)" },
    { value: "<=", label: "Less Than or Equal (<=)" },
    { value: "&&", label: "AND (&&)" },
    { value: "||", label: "OR (||)" },
    { value: ".includes('VALUE')", label: "Contains (String)" },
    { value: ".startsWith('VALUE')", label: "Starts With" },
    { value: ".endsWith('VALUE')", label: "Ends With" },

    // Arithmetic and Parenthesis Operators (from your existing list)
    { value: "+", label: "+ (Add)" },
    { value: "-", label: "- (Subtract)" },
    { value: "*", label: "* (Multiply)" },
    { value: "/", label: "/ (Divide)" },
    { value: "(", label: "(Open Paren)" },
    { value: ")", label: ") (Close Paren)" }
    ];

    const today = new Date();
  const yyyy = today.getFullYear();
  const mm = String(today.getMonth() + 1).padStart(2, '0');
  const dd = String(today.getDate()).padStart(2, '0');
  const todayStr = `'${mm}/${dd}/${yyyy}'`;

    // If Date type → show only +, -, Day
    if (columnType === "date") {
        operators = [ 
    { value: "===", label: "Equals (=)" },
    { value: "!==", label: "Not Equals (!=)" },
    { value: ">", label: "Greater Than (>)" },
    { value: "<", label: "Less Than (<)" },
    { value: ">=", label: "Greater Than or Equal (>=)" },
    { value: "<=", label: "Less Than or Equal (<=)" },
    { value: "&&", label: "AND (&&)" }, 
    { value: "+", label: "+ (Add)" },
    { value: "-", label: "- (Subtract)" }, 
    { value: "(", label: "(Open Paren)" },
    { value: ")", label: ") (Close Paren)" },
    { value: todayStr, label: "SYSDATE" }
        ];
    }
 

    // Rebuild operator LOV dynamically
    operatorLov.innerHTML = "";
    const defaultOpt = document.createElement("option");
    defaultOpt.value = "";
    defaultOpt.textContent = "Select Operator";
    operatorLov.appendChild(defaultOpt);

    operators.forEach(op => {
        const opt = document.createElement("option");
        opt.value = op.value;
        opt.textContent = op.label;
        operatorLov.appendChild(opt);
    });

    // console.log("Operator LOV updated:", operators);
});


 function saveAllDataToJSON() { 
    
// console.log('savedFormulas:>>>>>>',savedFormulas);

if (tableColumns && Array.isArray(tableColumns)) { 

    const selectedColumnsSet = new Set(
        (jsondata_details?.selectedColumns || []).map(c => c.col_name)
    );

    const filteredColumnMetadata = tableColumns.filter(column => {
        if (!column || !column.name) return false;

        const isCalcColumn = column.name.endsWith(' - calc');
        const formulaKeys = Object.keys(savedFormulas || {}); // savedFormulas should be defined

        if (isCalcColumn) {
            // Keep only if formula exists
            const baseName = column.name.replace(' - calc', '');
            return formulaKeys.includes(baseName);
        } else {
            // Keep only if column exists in selectedColumns of jsondata_details
            const baseName = column.name.split(' - ')[0]; // Remove suffix like '- MCL LoS1'
            return selectedColumnsSet.has(baseName);
        }
    });

    tableColumns = filteredColumnMetadata;

} else {
    // If tableColumns was null/undefined
    tableColumns = [];
}


// Ensure tableColumns is an array before using it in the configuration
const finalTableColumns = Array.isArray(tableColumns) ? tableColumns : []; 


// First, check if report_expressions exists
if (!report_expressions) {
    report_expressions = {
        columnposition: []
    };
} else if (!report_expressions.columnposition) {
    report_expressions.columnposition = [];
}

//console.log('report_expressions.columnposition:>>>>>', report_expressions?.columnposition);


const configuration = {
    columnConfiguration: jsondata_details,
    columnMetadata: finalTableColumns, 
    formulas: savedFormulas,
    filters: savedFilters,
    conditionalFormatting: conditionalFormattingRules,
    columnposition: report_expressions.columnposition
};

     const jsonString = JSON.stringify(configuration, null, 4);

     // console.log(hotelLov.options[hotelLov.selectedIndex].value+"--- EXPORTED CONFIGURATION JSON ---"+$('#New-Report').val());
    // console.log(jsonString);

 apex.server.process(
        'AJX_MANAGE_REPORT_VIEW',
        { 
            x01: 'UPDATE_EXPRESSION',
            x02: hotelLov.options[hotelLov.selectedIndex].value,
            x03: $('#New-Report').val(),
            x04: jsonString 
        },
        {
            success: function(data) { 
                // console.log('AJAX Success:', data);
                showSuccessMessage(`Expressions Saved! `);
              
                    
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error('AJAX Error:', errorThrown);
                alert('Error saving column alias. Please try again.');
            }
        }
    ); 

    // console.log("-----------------------------------");

    // Optional: Add logic here to display the JSON to the user or initiate a download
    // For example: downloadJSON(jsonString, 'report_configuration.json');
}





function loadConditionalFormattingBlocks() {

     if (typeof conditionalFormattingRules !== 'object' || conditionalFormattingRules === null) {
        conditionalFormattingRules = {}; 
    }
    // console.log('conditionalFormattingRules:>>>',conditionalFormattingRules);
    const container = document.getElementById('formatterConfigurationsContainer');
    // 1. Clear the existing UI blocks before redrawing
    if (container) {
        container.innerHTML = '';
    }
    
    // Reset counters to prevent ID collisions
    formatterBlockIdCounter = 0;
    formatterRuleIdCounter = 0;

    // Check if there are rules to load
    if (Object.keys(conditionalFormattingRules).length === 0) {
        // If no rules exist, add one default empty block for the user to start
        loadSavedFormatters();
        return;
    }

    // 2. Iterate through each column that has rules
    for (const columnKey in conditionalFormattingRules) {
        if (conditionalFormattingRules.hasOwnProperty(columnKey)) {
            const rulesArray = conditionalFormattingRules[columnKey];
           // // console.log('conditionalFormattingRules:>>>>>>>>>',rulesArray);
           // // console.log('conditionalFormattingRules:>>>>>>>>>',columnKey);
            // 3. For each column, call addColumnFormatterBlock, passing the 
            //    column key and the array of rules to pre-populate it.
            loadSavedFormatters();
        }
    }
}


let currentFullColumnName = null; // Stores the name of the column currently being edited

function findColumnInfo(fullColumnName) {
    if (!jsondata_details || !jsondata_details.selectedColumns) {
        return null;
    }
    // The fullColumnName is derived from "col_name ( temp_name )"
    const parts = fullColumnName.match(/(.*) \( (.*) \)/);
    if (!parts || parts.length < 3) return null;

    const colName = parts[1].trim();
    const tempName = parts[2].trim();

    return jsondata_details.selectedColumns.find(col => 
        col.col_name === colName && col.temp_name === tempName
    );
}

// Function to hide the popup
function hideColumnPopup() {
    document.getElementById('columnPopup').style.display = 'none';
    currentFullColumnName = null;
}

let currentRuleId = 1;



/**
 * Removes an entire column configuration block.
 */
function removeFormatterBlock(blockId) {
    const block = document.querySelector(`.formatter-config-block[data-block-id="${blockId}"]`);
    if (block) {
        block.remove();
        showSuccessMessage('Column filter configuration removed from UI. Click "Apply All Formats" to remove from report.', 'info');
    }
}


window.savedFormatters = JSON.parse(localStorage.getItem("savedFormatters")) || {};








document.addEventListener("DOMContentLoaded", function () {
  const rulesTextarea = document.getElementById("formatter-rules");
  const columnSelect = document.getElementById("formatter-column-lov");
  const operatorSelect = document.getElementById("formatter-operator-lov");

//   // 🟢 Add selected column to rule textarea
//   document.getElementById("add-column-rule").addEventListener("click", function () {
//     const column = columnSelect.value;
//     if (column) {
//       insertTextAtCursor(rulesTextarea, column);
//     } else {
//       alert("Please select a column first.");
//     }
//   });

  // 🟢 Add selected operator to rule textarea
$(document).ready(function() {
    // Initial rule count (set to 1 because one rule is already in the HTML)
    let ruleCount = 1;

    // Get the template structure to clone
    const $initialRule = $('#rules-list .rule-section').first().clone();

    // Attach click handler to the "Add Rule" button
    $('#add-new-rule').on('click', function() {
        // 1. Increment the rule counter
        ruleCount++;
        
        // 2. Clone the initial structure
        const $newRule = $initialRule.clone();

        // 3. Update the data-rule-id attribute on the new rule container
        $newRule.attr('data-rule-id', ruleCount);

        // 4. Update the label text (e.g., "Create Rule 2")
        $newRule.find('.rule-label').text('Create Rule ' + ruleCount);

        // 5. Update all IDs within the new rule to be unique
        $newRule.find('*').each(function() {
            const currentId = $(this).attr('id');
            if (currentId) {
                // Find and replace the rule number at the end of the ID
                // (e.g., 'formatter-column-lov-1' becomes 'formatter-column-lov-2')
                const newId = currentId.replace(/-\d+$/, '-' + ruleCount);
                $(this).attr('id', newId);
            }
        });
        
        // 6. Clear the textarea content in the cloned rule
        $newRule.find('textarea').val('');

        // 7. Append the new rule to the rules list
        $('#rules-list').append($newRule);
        
        // OPTIONAL: Scroll to the new rule
        $('#rules-list').scrollTop($('#rules-list')[0].scrollHeight);
        populateFormatterColumnLov_temp('rule_set_column');
    });



    $('#rules-list').on('click', '.action-btn.btn-primary', function() {
        // Find the parent rule section (e.g., <div class="rule-section" data-rule-id="2">)
        const $ruleSection = $(this).closest('.rule-section');
        
        // Get the rule number from the data attribute
        const ruleNumber = $ruleSection.data('rule-id');

        // 1. Get the current values using the unique IDs created earlier
        const $columnSelect = $('#formatter-column-lov-' + ruleNumber);
        const $operatorSelect = $('#formatter-operator-lov-' + ruleNumber);
        const $rulesTextarea = $('#formatter-rules-' + ruleNumber);
        
        const columnValue = $columnSelect.val();
        const operatorValue = $operatorSelect.val();
        
        // 2. Insert the column and operator into the correct textarea
        if (columnValue) {
            insertTextAtCursor($rulesTextarea[0], "["+columnValue+"]");
        }
        
        if (operatorValue) {
            insertTextAtCursor($rulesTextarea[0], " " + operatorValue + " ");
        }

        // Add a placeholder/separator for the next element (Value Input)
        if (columnValue || operatorValue) {
            insertTextAtCursor($rulesTextarea[0], " [Value] "); 
        }

        // Optional: Reset the select boxes after adding the condition
        $columnSelect.val('');
        $operatorSelect.val('');
    });


    $('#rules-list').on('click', '.delete-rule-btn', function() {
        // 1. Find the parent rule section to delete
        const $ruleSectionToDelete = $(this).closest('.rule-section');
        const deletedRuleId = $ruleSectionToDelete.data('rule-id');

        // Check if there's only one rule left (prevent deleting the last one, unless allowed)
        if ($('#rules-list .rule-section').length === 1) {
             alert("You must have at least one rule.");
             return;
        }

        // 2. Remove the rule from the DOM
        $ruleSectionToDelete.remove();
        
        // 3. Decrement the global counter
        ruleCount--;

        // 4. Renumber the remaining rules
        $('#rules-list .rule-section').each(function(index) {
            const newRuleNumber = index + 1;
            const $currentRule = $(this);
            const oldRuleNumber = $currentRule.data('rule-id');

            // a. Update the rule section data attribute
            $currentRule.attr('data-rule-id', newRuleNumber);
            
            // b. Update the visible label text
            $currentRule.find('.rule-label').text('Create Rule ' + newRuleNumber);
            
            // c. Update the Delete button data attribute
            $currentRule.find('.delete-rule-btn').attr('data-rule-id', newRuleNumber);

            // d. Update all element IDs within the rule (CRITICAL)
            $currentRule.find('*').each(function() {
                const currentId = $(this).attr('id');
                if (currentId) {
                    // Replaces the old rule number suffix (e.g., -3) with the new one (e.g., -2)
                    const newId = currentId.replace(new RegExp('-' + oldRuleNumber + '$'), '-' + newRuleNumber);
                    $(this).attr('id', newId);
                }
            });
        });
    });

});



  /**
   * 🧩 Helper function:
   * Inserts text at the cursor position in a textarea (or appends at the end)
   */
  function insertTextAtCursor(textarea, text) {
    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    const before = textarea.value.substring(0, start);
    const after = textarea.value.substring(end);
    textarea.value = before + text + after;
    textarea.focus();
    textarea.selectionStart = textarea.selectionEnd = start + text.length;
  }
});



// === EVENT HANDLER (delegated) ===
document.addEventListener("click", function (e) {
  // 1️⃣ Open formatter dialog
  if (e.target && e.target.id === "addColumnFormatterBtn") {
    clearFormatter();
    document.getElementById("formatter-dialog").style.display = "flex";
    // console.log('addColumnFormatterBtn:>>>>Call');
    populateFormatterColumnLov_temp('rule_set_column');
    populateFormatterColumnLov_temp('column-select_ftr');
   
  }

  // 2️⃣ Close dialog
  if (e.target && e.target.id === "close-formatter-dialog") {
    document.getElementById("formatter-dialog").style.display = "none";
  }

  // 3️⃣ Save new format
  if (e.target && e.target.id === "save-formatter") {
   saveConditionalFormatting();
  }

  // 4️⃣ Update existing format
  if (e.target && e.target.classList.contains("use-formatter-btn")) {
    const col = e.target.getAttribute("data-col");
    const data = window.savedFormatters[col];
    if (data) {
      document.getElementById("formatter-column").value = col;
      document.getElementById("formatter-type").value = data.type;
      document.getElementById("formatter-rules").value = data.rules;
    }
    document.getElementById("formatter-dialog").style.display = "flex";
  }

  // 5️⃣ Delete formatter
  if (e.target && e.target.classList.contains("delete-formatter-btn")) {
    const col = e.target.getAttribute("data-col");
    if (confirm(`Remove format for column "${col}"?`)) {
      delete window.savedFormatters[col];
      localStorage.setItem("savedFormatters", JSON.stringify(savedFormatters));
      renderAllFormatters();
    }
  }

  // 6️⃣ Apply all formats
  if (e.target && e.target.id === "saveAllFormatters") {
    alert("All formatters applied!");
    // Here you can trigger your column rendering logic in APEX or JS
  }

  // 7️⃣ Clear all
  if (e.target && e.target.id === "clearAllFormatters") {
    if (confirm("Clear all column formats?")) {
      window.savedFormatters = {};
      localStorage.removeItem("savedFormatters");
      renderAllFormatters();
    }
  }

  // 8️⃣ Add to Condition (append rule to textarea)
  if (e.target && e.target.id === "add-to-condition") {
    const ruleField = document.getElementById("formatter-rules");
    const condition = "value > 100 ? 'High' : 'Low'";
    ruleField.value = ruleField.value
      ? `${ruleField.value}\n${condition}`
      : condition;
  }

  // 9️⃣ Clear fields
  if (e.target && e.target.id === "clear-formatter") {
    clearFormatter();
  }
});


function clearFormatter() {
 // document.getElementById("formatter-column").selectedIndex = 0;
//  document.getElementById("formatter-type").selectedIndex = 0;
//  document.getElementById("formatter-rules").value = "";
null;
}

function populateFormatterColumnLov_temp(classname) {
    // console.log('populateFormatterColumnLov:>>>>>>>>');
    
    // Get all elements with the specified class name
    const lovElements = document.getElementsByClassName(classname);
    
    // Convert HTMLCollection to Array and loop through each element
    Array.from(lovElements).forEach(lov => {
        // Clear existing content
        lov.innerHTML = '';
        
        // Add default option
        lov.appendChild(new Option('-- Select Column --', '', true, null));
        
        // Populate with column options
        if (jsondata_details && jsondata_details.selectedColumns) {
            jsondata_details.selectedColumns.forEach(col => {
              //  // console.log('populateFormatterColumnLov:>>>>>>>>col>', col);
                const fullKey = getColumnDataKey(col);
                const alias = col.alias_name || col.col_name;
                const option = new Option(alias, fullKey, false, fullKey);
                lov.appendChild(option);
            });
        }
    });

    // Handle operator LOV (if needed for each element or just once)
    const operatorLov = document.getElementById('formatter-operator-lov');
    if (operatorLov) {
        operatorLov.innerHTML = '';
        const operators = ['', '>', '>=', '<', '<=', '==', '!='];
        operators.forEach(op => {
            operatorLov.appendChild(new Option(op, op));
        });
    }
}



/**
 * Adds a new rule field to a specific configuration block.
 * NOTE: The IDs now depend on both blockId and ruleId.
 */
function addFormatterRule(blockId, expression = '', color = '#ff0000') {
    formatterRuleIdCounter++;
    const ruleId = formatterRuleIdCounter;
    
    // 1. Find the parent configuration block using the data-block-id attribute
    const configBlock = document.querySelector('.formatter-config-block[data-block-id="' + blockId + '"]');

    if (!configBlock) {
        // This is a serious error, meaning the block was removed or never added properly
        console.error(`FATAL ERROR: Could not find parent configuration block for ID: ${blockId}`);
        return;
    }
    
    // 2. Find the rules container *inside* the parent block using its unique ID
    const containerId = 'formatterRulesContainer_' + blockId;
    const container = configBlock.querySelector('#' + containerId);
    
    if (!container) {
        // This means the innerHTML creation failed in addColumnFormatterBlock, 
        // but it's now scoped to the correct parent block.
        console.error(`ERROR: Rule container not found inside block ${blockId}. Attempted ID: ${containerId}`);
        return; 
    }

    const ruleDiv = document.createElement('div');
    ruleDiv.className = 'formatter-rule';
    ruleDiv.setAttribute('data-rule-id', ruleId);
    
    // Ensure all nested IDs are correct here
    ruleDiv.innerHTML = `
        <div style="display: flex; align-items: flex-start; margin-bottom: 8px; border: 1px dashed #444; padding: 10px; border-radius: 4px;">
            <div style="flex-grow: 1;">
                <textarea id="formatterExpression_${blockId}_${ruleId}" class="form-input formula-preview" 
                    placeholder="Enter condition (e.g., [SALES - T1] > 1000)" style="margin-bottom: 5px;">${expression}</textarea>
                
                <div class="formula-actions" style="margin-bottom: 5px; display: flex; gap: 5px; flex-wrap: wrap;">
                    <select id="formatterRuleColumnLov_${blockId}_${ruleId}" class="form-input column-select" style="flex: 1 1 30%;"></select>
                    <select id="formatterRuleOperator_${blockId}_${ruleId}" class="form-input operator-select" style="flex: 1 1 15%;"></select>
                    <input type="text" id="formatterRuleValue_${blockId}_${ruleId}" class="form-input value-input" placeholder="Value / Column Name" style="flex: 1 1 20%;">
                    <div class="add-to-expression-btn popup-button" data-block-id="${blockId}" data-rule-id="${ruleId}" style="flex: 1 1 20%;">Add to Condition</div>
                </div>
                
                <div class="color-picker-group">
                    <label for="formatterColor_${blockId}_${ruleId}">Color:</label>
                    <input type="color" id="formatterColor_${blockId}_${ruleId}" value="${color}">
                </div>
            </div>
            <div class="remove-rule-btn popup-button cancel-button" onclick="removeFormatterRule(${blockId}, ${ruleId})" style="margin-left: 10px; padding: 5px;">-</div>
        </div>
    `;
    
    // Line that previously failed, but is now guaranteed to have a valid container reference
    container.appendChild(ruleDiv);
    
    // Populate the helper LOVs for the new rule
    populateFormatterRuleLovs(blockId + '_' + ruleId); 
}

/**
 * Removes a single rule field from a block.
 */
function removeFormatterRule(blockId, ruleId) {
    const rule = document.querySelector(`#formatterRulesContainer_${blockId} .formatter-rule[data-rule-id="${ruleId}"]`);
    if (rule) {
        rule.remove();
    }
}

function populateFormatterColumnLov(blockId, selectedKey = null) {
    // CRITICAL: Targets the specific LOV element for the current block
    const lov = document.getElementById(`formatterColumnLov_${blockId}`); 
    if (!lov) return;

    lov.innerHTML = '';
    lov.appendChild(new Option('-- Select Column --', '', true, selectedKey === null)); // Default option

    if (jsondata_details && jsondata_details.selectedColumns) {
        jsondata_details.selectedColumns.forEach(col => {
            const fullKey = getColumnDataKey(col); 
            const alias = col.alias_name || col.col_name;
            const option = new Option(alias, fullKey, false, fullKey === selectedKey);
            lov.appendChild(option);
        });
    }
}

function addFormatterRule(blockId, expression = '', color = '#ff0000', containerRef) {
    formatterRuleIdCounter++;
    const ruleId = formatterRuleIdCounter;
    
    // 1. Validate Container Reference
    const container =   document.getElementById(`formatterRulesContainer_${blockId}`);; 
    if (!container) {
        console.error(`FATAL ERROR: Rule container reference not provided for block ID: ${blockId}`);
        return; 
    }
    
    // 2. CRITICAL COLOR FIX: Ensure color is a valid hex string for HTML input
    const safeColor = (color && color.match(/^#([0-9A-F]{3}){1,2}$/i)) ? color : '#ff0000';

    const ruleDiv = document.createElement('div');
    ruleDiv.className = 'formatter-rule';
    ruleDiv.setAttribute('data-rule-id', ruleId);
    
    // Use the safeColor variable in the innerHTML
    ruleDiv.innerHTML = `
        <div style="display: flex; align-items: flex-start; margin-bottom: 8px; border: 1px dashed #444; padding: 10px; border-radius: 4px;">
            <div style="flex-grow: 1;">
                <textarea id="formatterExpression_${blockId}_${ruleId}" class="form-input formula-preview" 
                    placeholder="Enter condition (e.g., [SALES - T1] > 1000)" style="margin-bottom: 5px;">${expression}</textarea>
                
                <div class="formula-actions" style="margin-bottom: 5px; display: flex; gap: 5px; flex-wrap: wrap;">
                    <select id="formatterRuleColumnLov_${blockId}_${ruleId}" class="form-input column-select" style="flex: 1 1 30%;"></select>
                    <select id="formatterRuleOperator_${blockId}_${ruleId}" class="form-input operator-select" style="flex: 1 1 15%;"></select>
                    <input type="text" id="formatterRuleValue_${blockId}_${ruleId}" class="form-input value-input" placeholder="Value / Column Name" style="flex: 1 1 20%;">
                    <div class="add-to-expression-btn popup-button" data-block-id="${blockId}" data-rule-id="${ruleId}" style="flex: 1 1 20%;">Add to Condition</div>
                </div>
                
                <div class="color-picker-group">
                    <label for="formatterColor_${blockId}_${ruleId}">Color:</label>
                    <input type="color" id="formatterColor_${blockId}_${ruleId}" value="${safeColor}">
                </div>
            </div>
            <div class="remove-rule-btn popup-button cancel-button" onclick="removeFormatterRule(${blockId}, ${ruleId})" style="margin-left: 10px; padding: 5px;">-</div>
        </div>
    `;
    
    // This line is now safe because 'container' is a direct reference
    container.appendChild(ruleDiv);
    
    // Populate the helper LOVs for the new rule
    populateFormatterRuleLovs(blockId + '_' + ruleId); 
}






function removeFormatterRule(ruleId) {
    const ruleElement = document.querySelector(`.formatter-rule[data-rule-id="${ruleId}"]`);
    if (ruleElement) {
        ruleElement.remove();
    }
}


function populateFormatterRuleLovs(ruleId) {
    const columnLov = document.getElementById(`formatterRuleColumnLov_${ruleId}`);
    const operatorLov = document.getElementById(`formatterRuleOperator_${ruleId}`);
    // console.log('ruleId',ruleId);
    columnLov.innerHTML = '';
    columnLov.appendChild(new Option('-- Select Column --', ''));

    if (jsondata_details && jsondata_details.selectedColumns) {
        jsondata_details.selectedColumns.forEach(col => {
            const fullKey = getColumnDataKey(col); 
            const alias = col.alias_name || col.col_name;
            columnLov.appendChild(new Option(alias, fullKey));
        });
    }
    
    // Simple Numeric/Date comparison operators for formatting
    operatorLov.innerHTML = '';
    const operators = ['>', '>=', '<', '<=', '==', '!='];
    operators.forEach(op => {
        operatorLov.appendChild(new Option(op, op));
    });
}


function buildFormatterExpression(blockId, ruleId) {
    // CRITICAL: Check for missing arguments
    if (!blockId || !ruleId) {
        console.error("buildFormatterExpression called without required blockId or ruleId.");
        return; 
    }
    
    // Lookup elements using the new composite IDs
    const colLov = document.getElementById(`formatterRuleColumnLov_${blockId}_${ruleId}`);
    const operatorLov = document.getElementById(`formatterRuleOperator_${blockId}_${ruleId}`);
    const valueInput = document.getElementById(`formatterRuleValue_${blockId}_${ruleId}`);
    const expressionArea = document.getElementById(`formatterExpression_${blockId}_${ruleId}`);

    // Safety check for lookup
    if (!colLov || !operatorLov || !valueInput || !expressionArea) {
         console.error(`Could not find all required elements for block:${blockId}, rule:${ruleId}`);
         return;
    }

    const column = colLov.value;
    const operator = operatorLov.value;
    let value = valueInput.value;

    // Check for empty inputs (fix for previous UX warning)
    if (!column || !operator || !value) {
        return; 
    }

    let formulaPart = '';
    
    // Logic to construct the formula part
    if (value.startsWith('[') && value.endsWith(']')) {
        // Value is another column name
        formulaPart = `[${column}] ${operator} ${value}`;
    } else if (isNaN(parseFloat(value))) {
        // Value is a string (must be quoted)
        // Ensure quotes are escaped if they exist in the string
        const safeValue = value.replace(/'/g, "\\'"); 
        formulaPart = `[${column}] ${operator} '${safeValue}'`;
    } else {
        // Value is numeric
        formulaPart = `[${column}] ${operator} ${value}`;
    }

    let currentExpression = expressionArea.value.trim();

    if (currentExpression) {
        // Append with AND
        currentExpression += ' AND ' + formulaPart;
    } else {
        // Start the expression
        currentExpression = formulaPart;
    }

    expressionArea.value = currentExpression;
}




 

 
 

function saveConditionalFormatting() {
    // --- Step 0: Rules are already in the global variable (conditionalFormattingRules) ---
    // No need to load from storage.

    let totalRulesSaved = 0;
    
    // 1. Identify the single Target Column Key from the top selector
    const targetColumnKey = document.getElementById('column-select_ftr').value;

    if (!targetColumnKey) {
        alert("Please select a Source Column before saving.");
        return;
    }

    // Array to hold the NEW/UPDATED rules for this specific target column
    const updatedBlockRules = [];
    
    // 2. Loop through all dynamically created rule sections to collect new data
    const ruleElements = document.querySelectorAll('#rules-list .rule-section');

    ruleElements.forEach(element => {
        const ruleId = element.getAttribute('data-rule-id');
        const expressionId = `formatter-rules-${ruleId}`;
        const colorId = `formatter-color-${ruleId}`;

        const rawExpressionValue = document.getElementById(expressionId)?.value;
        const color = document.getElementById(colorId)?.value;

        if (rawExpressionValue && color) {
            const expression = rawExpressionValue.trim()
                                                 .replace(/[;{}]$/g, '')
                                                 .replace(/[\r\n]/g, ' ');

            if (expression) {
                updatedBlockRules.push({
                    expression: expression,
                    color: color
                });
                totalRulesSaved++;
            }
        }
    });

    // --- Step 3: Update the Global Object ---
    if (updatedBlockRules.length > 0) {
        // OVERWRITE the rules for the specific column key being saved/edited
        // This is the key line: we update the global variable directly.
        conditionalFormattingRules[targetColumnKey] = updatedBlockRules;
    } else {
        // If the user clears all rules for an existing column, delete the key entirely
        if (conditionalFormattingRules.hasOwnProperty(targetColumnKey)) {
            delete conditionalFormattingRules[targetColumnKey];
        }
    }
    
    // --- Step 4: Save the Complete Object and Finish ---
    
    // No localStorage saving. The data remains in the global JS variable.
    
    // console.log('FINAL CONDITIONAL FORMATTING JSON:', conditionalFormattingRules);

    // Call your final actions
    // You should ensure the dialog is hidden here.
    document.getElementById("formatter-dialog").style.display = "none";
 
    showSuccessMessage(`Successfully applied ${totalRulesSaved} rules to ${targetColumnKey}.`, 'success');
    saveAllDataToJSON();
    handleSave();
    
    displayReportTable('saveConditionalFormatting');
    loadSavedFormatters();
}



function clearAllFormatters() {
    conditionalFormattingRules = {};
    loadSavedFormatters(); // Resets the UI to one empty block
    displayReportTable('clearAllFormatters'); 
    showSuccessMessage('All conditional formatting rules cleared globally.', 'warning');
}
 

function clearConditionalFormatting() {
    const targetColumnLov = document.getElementById('formatterColumnLov');
    const selectedOptions = Array.from(targetColumnLov.selectedOptions);
    const targetColumnKeys = selectedOptions.map(option => option.value);

    // Fallback: If nothing is selected, clear ALL rules globally
    if (targetColumnKeys.length === 0) {
        if (Object.keys(conditionalFormattingRules).length > 0) {
            conditionalFormattingRules = {}; // Clear all rules
            showSuccessMessage('All conditional formatting rules cleared.', 'warning');
        } else {
            showSuccessMessage('No rules to clear.', 'info');
        }
    } else {
        // Clear rules for only the selected columns
        let clearedCount = 0;
        targetColumnKeys.forEach(key => {
            if (conditionalFormattingRules.hasOwnProperty(key)) {
                delete conditionalFormattingRules[key];
                clearedCount++;
            }
        });
        showSuccessMessage(`Formatting rules cleared for ${clearedCount} selected column(s).`, 'warning');
    }
    
    // Refresh the UI (clear rule inputs) and the table
    document.getElementById('formatterRulesContainer').innerHTML = ''; 
    displayReportTable('clearConditionalFormatting'); 
}



function loadFormatterRules(columnKey) {
    const container = document.getElementById('formatterRulesContainer');
    container.innerHTML = ''; // Clear existing rules
    currentRuleId = 0; // Reset rule counter
    
    const rules = conditionalFormattingRules[columnKey] || [];
    
    if (rules.length > 0) {
        rules.forEach(rule => {
            addFormatterRule(rule.expression, rule.color);
        });
    } else {
        addFormatterRule(); // Add a default empty rule
    }
}



// Helper to evaluate the formatting rule expression (similar to formula evaluation)
function evaluateFormatterRule(expression, row) {
// // console.log('evaluateFormatterRule expression:>',expression);
// // console.log('evaluateFormatterRule row:>',row);
    if (!expression || typeof expression !== 'string' || !row) {
        console.warn('evaluateFormatterRule: invalid parameters');
        // // console.log('evaluateFormatterRule 1');
        return false;
    }

    let calculatedExpression = expression;

    // 🔹 STEP 1: Replace [ColumnName] placeholders with actual values
    const placeholderRegex = /\[([^\]]+)\]/g;
    calculatedExpression = calculatedExpression.replace(placeholderRegex, (match, colName) => {
        const trimmedColName = colName.trim();
        let cellValue = row[trimmedColName];

        // Handle null/undefined/empty as 0 for numeric, '' for string
        if (
                cellValue === undefined ||
                cellValue === null ||
                (typeof cellValue === 'string' && cellValue.trim() === '')
            ) {
                const numericContext = /[\+\-\*\/%<>]=?|\d/.test(expression);
                 return numericContext ? 0 : "''";
            }


        // Try to parse numbers
        if (!isNaN(cellValue) && cellValue !== '') {
             return parseFloat(cellValue);
        }

        // Otherwise treat as string/date
        const strVal = String(cellValue).replace(/'/g, "\\'");
         return `'${strVal}'`;
    });

    calculatedExpression = calculatedExpression.trim();

    if (!calculatedExpression) {
        console.warn('evaluateFormatterRule: Empty expression after substitution');
         return false;
    }

    // 🔹 STEP 2: Replace single = with == (for logical checks)
    calculatedExpression = calculatedExpression.replace(/([^=!><])=([^=])/g, '$1==$2');
    calculatedExpression = calculatedExpression.replace(/^=/g, '==');

    // 🔹 STEP 3: Prevent evaluating broken expressions
    const danglingOperatorRegex = /([=!><+\-*/%]|AND|OR)$/i;
    if (danglingOperatorRegex.test(calculatedExpression)) {
         console.warn('Evaluation skipped: dangling operator ->', calculatedExpression);
        return false;
    }

    // 🔹 STEP 4: Evaluate safely
    try {
        const result = new Function('return ' + calculatedExpression)();
         return result;
    } catch (e) {
         console.warn('Error evaluating expression:', calculatedExpression, 'Error:', e.message);
        return false;
    }
}



        let savedFilters = {};
let currentFilterName = '';

        // Initialize event listeners
        document.addEventListener('DOMContentLoaded', function() {
       //     initializeTable();
            setupCollapseButtons();
            
            // Event listeners for the new div elements
           // document.getElementById('calculate-btn').addEventListener('click', calculateOperation); 
            document.getElementById('add-to-formula').addEventListener('click', addToFormula);
            document.getElementById('add-to-formulafilter').addEventListener('click', filteraddToFormula);
            
            document.getElementById('add-calculation').addEventListener('click', addCalculation);
            // Must check for disabled state on click for update-calculation
            document.getElementById('update-calculation').addEventListener('click', updateCalculation);
            document.getElementById('clear-formula').addEventListener('click', clearFormula);
            document.getElementById('test-formula').addEventListener('click', testFormula);

            // const saveAllButton = document.getElementById('saveAllButton');
            //     if (saveAllButton) {
            //         saveAllButton.addEventListener('click', saveAllDataToJSON);
            //     }
                

            document.getElementById('add-to-filter').addEventListener('click', addToFilter);
            document.getElementById('apply-saved-filter').addEventListener('click', () => applySavedFilter(false));
            document.getElementById('add-saved-filter').addEventListener('click', addSavedFilter);
            document.getElementById('update-saved-filter').addEventListener('click', updateSavedFilter);
            document.getElementById('clear-filter-builder').addEventListener('click', clearFilterBuilder);


        

  

 
// 2. Event delegation for dynamically added buttons
const container = document.getElementById('formatterConfigurationsContainer');
if (container) {
    container.addEventListener('click', function(e) {
        
        // --- Handle 'Add Rule' Button click within a block ---
        const addRuleBtn = e.target.closest('[id^="addFormatterRuleBtn_"]');
        if (addRuleBtn) {
            const blockId = addRuleBtn.getAttribute('data-block-id');
            // console.log('blockId:>>>>>',blockId);
            if (blockId) {
                addFormatterRule(blockId);
                return; 
            }
        }
        
        // --- Handle 'Add to Condition' Button click inside a rule ---
        const targetDiv = e.target.closest('.add-to-expression-btn');
        if (targetDiv) {
            const blockId = targetDiv.getAttribute('data-block-id');
            const ruleId = targetDiv.getAttribute('data-rule-id');
            if (blockId && ruleId) {
                // Pass both IDs to the expression builder
                buildFormatterExpression(blockId, ruleId);
            }
        }
    });
}






const dashboard = document.querySelector('.data-dashboard-wrapper');
    if (dashboard) {
        dashboard.style.display = 'none';
    }

    // Attach the click event to your new button
    const toggleBtn = document.getElementById('toggleDashboardBtn');
    if (toggleBtn) {
        toggleBtn.addEventListener('click', toggleDashboardVisibility);
    }
    
            // Initial setup for the update button's visual state (disabled)
            clearFormula(); 
        });


// Function to add click listeners to column headers
function addHeaderClickListeners() {
    const headers = document.querySelectorAll('#tableHeader th:not(.table-group-header)');
    
    headers.forEach(header => {
        if (header.cellIndex > 0) { // Skip the first header (row number)
            header.addEventListener('click', function() {
                const fullColumnName = this.getAttribute('data-full-name');
                if (fullColumnName) {
                    showColumnPopup(fullColumnName);
                }
            });
        }
    });
}

// Initialize when page loads
document.addEventListener('DOMContentLoaded', function() {
    // Additional debug info
    // console.log('DOM loaded - jsondata_details:', jsondata_details);
    
    // Uncomment this line to display the table when needed
    // displayReportTable();
    
    // Add event listeners for popup buttons
    document.getElementById('savePopup').addEventListener('click', handleSave);
    document.getElementById('cancelPopup').addEventListener('click', hideColumnPopup);
    
    // Close popup when clicking outside
    document.getElementById('columnPopup').addEventListener('click', function(e) {
        if (e.target === this) {
            hideColumnPopup();
        }
    });
    
    // Close popup with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            hideColumnPopup();
        }
    });
    
    // Allow Enter key to save in new header input
    document.getElementById('newHeader').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            handleSave();
        }
    });
});

function refreshTable() {
    // console.log('Refreshing table...');
    displayReportTable('refreshTable');
}




        // Initialize the application
        init();
