    var hotelData;
    let hotelTemplates = [];
    let conditionalFormattingRules = {}; 
    let formatterBlockIdCounter = 0; 
    let formatterRuleIdCounter = 0
    let TEMP_FORMATTING_JSON ;
    let algoArray;

    // DOM elements
    const hotelLov = document.getElementById('hotel-lov');
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
    const notification = document.getElementById('notification');

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
                        console.log('Received data:', data);
                        hotelTemplates = data; 
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('AJAX Error:', errorThrown);
                    }
                }
            );
        }
          function loadHotelTemplates(hotelName) {
                apex.server.process(
                    "AJX_GET_HOTEL_TEMPLATES", // Ajax Callback name
                        { x01: hotelName },    // pass hotel name
                    {
                        dataType: "json",
                        success: function(data) {
                            console.log("Hotel templates JSON:", data);
                            hotelData = data;
                             algoArray = Object.entries(data)
                                            .find(([key]) => key.toLowerCase() === 'algo')?.[1] || [];
                                            console.log('algoArray:>>>>>',algoArray);

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
    console.log('hotelId:>>>>>>>>',hotelId);
    apex.server.process(
  "AJX_GET_REPORT_ALL_QUALIFIERS", // Process name
  {x01: hotelId },                             
  {
    dataType: "json",              // Expect JSON
    success: function(pData) {
      console.log("Full response:", pData);
        hotel_qualifiers = pData;
      // Access array
      if (pData && pData.data) {
        pData.data.forEach(function(row) {
          console.log("Name:", row.name, "Temp Name:", row.temp_name);
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
const element = document.getElementById('notification');

// Check if the element was found
if (element) {
  // If the element exists, hide it by setting its display property to 'none'
  element.style.display = 'none';
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
                console.log('AJX_GET_REPORT_HOTEL:>>>',data);
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

function showReportLoading() {
    const reportLov = document.getElementById('report-lov');
    // Clear previous options
    reportLov.innerHTML = '';
    // Add loading option (disabled and selected)
    const loadingOption = document.createElement('option');
    loadingOption.textContent = 'Loading Reports...';
    loadingOption.disabled = true;
    loadingOption.selected = true;
    reportLov.appendChild(loadingOption);

    // Show spinner next to report LOV
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
    // Remove loading option if exists
    if (reportLov.options.length > 0 && reportLov.options[0].text === 'Loading Reports...') {
        reportLov.remove(0);
    }

    // Hide spinner
    const spinner = document.getElementById('report-loading-spinner');
    if (spinner) {
        spinner.style.display = 'none';
    }
}

function getAndPopulateReports() {
    var selectedHotelId = hotelLov.options[hotelLov.selectedIndex].value;
    var reportLov = $('#report-lov');
    reportLov.empty();

    showReportLoading();

    apex.server.process(
        'AJX_GET_REPORT_HOTEL',
        {
            x01: 'REPORT',
            x02: selectedHotelId
        },
        {
            success: function(pData) {
                hideReportLoading();

                // Add the "Create New Report" option first
                console.log('Report:>',pData);
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


    } else {
        $('#New-Report').val(reportLov.options[reportLov.selectedIndex].text);
        console.log('handleReportSelection---->>>',handleReportSelection);
        var selectedReport = reportData.find(item => item.ID === selectedValue);
        selectedFieldValues = selectedReport.DEFINITION.split(',').map(s => s.trim());
        
        if (selectedReport && selectedReport.DEFINITION) {
            console.log('--selectedReport.DEFINITION:>' + selectedReport.DEFINITION);
            populateSelectedColumns(selectedReport.DEFINITION);
            console.log('TEMP_FORMATTING_JSON:>>>>>>>',TEMP_FORMATTING_JSON);
 
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
 
    }
    
    fetchTemplates_all();
    handleTemplateSelection();
    getAllQualifiers();
    // loadAllFormatterBlocks(); // Original call is now redundant/replaced by the call above
}


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
            console.log('Before load template');
            // Show the spinner immediately on hotel selection
            showReportLoading();
            hotelData = loadHotelTemplates(hotelLov.options[hotelLov.selectedIndex].text);
            console.log('After load templ');
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
            console.log('After call templ');
        }

        // Handle template selection
        function handleTemplateSelection() {
            selectedTemplate = 'All'; // templateLov.options[templateLov.selectedIndex].text;
            
            if (selectedHotel && selectedTemplate) {
                const templateFieldsAll = hotelData[selectedHotel.toLowerCase().replace(/\s+/g, '')].templates;
                //console.log('----templateFieldsAll:>', templateFieldsAll);
                const formattedArray = [];

                    for (const templateName in templateFieldsAll) {
                        if (Object.hasOwnProperty.call(templateFieldsAll, templateName)) {
                            const fields = templateFieldsAll[templateName];

                            fields.forEach(field => {
                                const formattedString = `${field} ( ${templateName} )`;
                                formattedArray.push(formattedString);
                            });
                        }
                    }
                  //  formattedArray.push(...algoArray);
                   // console.log('----formattedArray:>',formattedArray);
                const finalString = formattedArray.join(', ');

                const finalArray = finalString.split(', ');
                const templateFields = finalArray ; 
                currentTemplateInfo.textContent = `Current template: ${selectedTemplate.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase())}`;
                const selectedFieldValues = Array.from(selectedColumns.querySelectorAll('.column-checkbox'))
                                    .map(checkbox => checkbox.dataset.value);
                                
                                const availableFields = templateFields.filter(field => 
                                    !selectedFieldValues.includes(field)
                                );
                               //console.log('----availableColumns:>', availableColumns);
                               // console.log('----availableFields:>',availableFields);
                                populateColumns(availableColumns, availableFields);
                                
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
                //console.log('added handleDragStart',item);
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
        }

        // Add all columns to right side
        function addAll() {
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
        }


function buildSQLFromJSON(data) {
  const colsByTable = {};
  const hotelIds = {};
  const colMeta = {};
  getAllQualifiers();
var qualifr_coval ;
  // Group normal columns by table
  data.selectedColumns.forEach(col => {
    if (col.temp_name !== "Strategy_Column") {
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
  const hotelId = data.selectedColumns.find(c => c.hotel_id)?.hotel_id || '';

  const tables = Object.keys(colsByTable);
  const aliases = tables.map((t, i) => "t" + (i + 1) + "_rn");

  // Build CTEs for normal tables
  const ctes = tables.map((table, i) => {
    const cols = colsByTable[table];
    const orderCol = cols[0];
    const alias = aliases[i];
    console.log('cols:>>>>>',cols);
 
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

  // Build SELECT list
  const selectCols = [];

  // Regular tables
  tables.forEach((table, i) => {
    colsByTable[table].forEach(col => {
      const tempName = colMeta[table][col];
      selectCols.push(`${aliases[i]}.${col} AS "${col} - ${tempName}"`);
    });
  });

  // Add all strategy columns
  strategyCols.forEach((sc, i) => {
    const alias = `s${i + 1}_rn`;
    selectCols.push(`${alias}.EVALUATED_PRICE AS "${sc.col_name} - Strategy_Column"`);
  });

  // Build final FROM + JOIN logic
  const allAliases = [...aliases, ...strategyCols.map((_, i) => `s${i + 1}_rn`)];

//   const joinClauses = allAliases.slice(1).map((alias, i) =>
//     `FULL OUTER JOIN ${alias}
//       ON ${allAliases[0]}.hotel_id = ${alias}.hotel_id
//      AND ${allAliases[0]}.pk_col = ${alias}.pk_col`
//   );

const joinClauses = allAliases.slice(1).map((alias, i) => {
  const joinType = alias.startsWith('s') ? ' LEFT ' : 'FULL OUTER';
  
  return `${joinType} JOIN ${alias}
      ON ${allAliases[0]}.hotel_id = ${alias}.hotel_id
     AND ${allAliases[0]}.pk_col = ${alias}.pk_col`;
});

  const finalSelect = `SELECT COALESCE(${allAliases.map(a => a + ".hotel_id").join(", ")}, null) AS hotelid,
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
                            //showSuccessMessage(`Column header updated to: ${newHeader}`);
                           
                            call_dashboard_data(data[0].l_report_id);
                           // handleHotelSelection();
                           
                        
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

            console.log('generateJson triggered');

            const columns = Array.from(
                        selectedColumns.querySelectorAll('.column-checkbox')
                    ).map(item => {
                        const tempName = item.dataset.value.substring(
                            item.dataset.value.indexOf('(') + 1,
                            item.dataset.value.indexOf(')')
                        ).trim();

                        const match = hotelTemplates.find(t => t.temp_name === tempName);

                        return {
                            col_name: item.dataset.value.split('(')[0].trim(),
                            temp_name: tempName,
                            db_object_name: match ? match.db_object_name : null,  
                            alias_name: item.dataset.value.split('(')[0].trim(),
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
            
            // Show notification
            notification.classList.add('show');
            setTimeout(() => {
                notification.classList.remove('show');
            }, 3000);
            
            jsondata_main = jsonData;
            console.log('jsondata_main:>>>>>>>>',jsondata_main);
        
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
                            console.log("AJX_GET_TEMP_COL_DETAILS JSON:", data);
                            
                            const enrichedJSON = enrichTargetWithDataType(data, jsondata_main);
                            jsondata_main = enrichedJSON;
                            console.log('enrichTargetWithDataType-------------===============>>>>>>>>>',enrichedJSON);
                            jsondata_main =  addTextDataType(jsondata_main);
                            const sql = buildSQLFromJSON(enrichedJSON);
                            console.log('sql:>>>>',sql);
          
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
        console.log('Using existing object structure');
        return data;
    }
    
    // If it's a string, try to parse it
    if (typeof data === 'string') {
        try {
            const parsed = JSON.parse(data);
            console.log('Successfully parsed from string');
            return parsed;
        } catch (error) {
            console.error('Failed to parse JSON string:', error);
        }
    }
    
    // Return default structure for all other cases
    console.log('Using default structure');
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
    
    console.log('Dashboard forcefully shown');
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
                console.log('Report data received for tab:', data);
               enrichTargetColumnAliasWithDataType(jsondata_main,data);
                let reportCol;
                let db_ob_name;  
                data.forEach(function(report) {
                    reportCol = report.DEFINITION_JSON; 
                    db_ob_name = report.DB_OBJECT_NAME;
                    alias_name = report.COLUMN_ALIAS;
                    report_expressions = report.EXPRESSIONS_CLOB;
                }); 
                console.log('report_expressions:>>>>', report_expressions);
                console.log('alias_name:>>>>', alias_name); 
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
                filters: parsedExpressions.filters || {}
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
            
            console.log('TEMP_FORMATTING_JSON:', TEMP_FORMATTING_JSON);
            console.log('INITIAL_CONFIG_JSON:', INITIAL_CONFIG_JSON);
             
            conditionalFormattingRules = TEMP_FORMATTING_JSON;
       // loadDashboard (reporttblData);
            loadConditionalFormattingBlocks(); 


                let reportcolalias;
                if (alias_name) {
                try {
                        reportcolalias = JSON.parse(alias_name);
                        console.log("Successfully parsed JSON:", reportcolalias);
                    } catch (error) {
                        console.error('Failed to parse JSON:', error);
                    }
                    } else {
                    console.log("alias_name is null, undefined, or empty. Skipping JSON parsing.");
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
                console.log('jsondata_details:>>>>>>>>>>>>>>>>>>>>>',jsondata_details);
                // Generate columns_list from the JSON data
           const columns_list = reportColObj.selectedColumns.map(item => ({
                                name: `${item.col_name} - ${item.temp_name}`,
                                type: item.data_type
                                    ? item.data_type.toLowerCase() === 'number' ? 'number'
                                    : item.data_type.toLowerCase() === 'date' ? 'date'
                                    : 'string'
                                    : 'string' // ✅ default to 'number' if data_type is null
                            }));
                console.log('Updated reportColObj:>', JSON.stringify(columns_list));
                tableColumns = columns_list;
                console.log('Generated db_ob_name:', db_ob_name);

                apex.server.process(
                    "AJX_GET_REPORT_DATA",
                    { 
                        x01: 'TEMPLATE_REPORT_DATA',
                        x02: JSON.stringify(columns_list) ,
                        x03: db_ob_name
                    },
                    {
                        success: function(pData) {
                            console.log('Table data received for tab:', pData);
                            
                                 
                                // Initialize table for the specific tab
                                reporttblData = pData;
                            // 1. Set the immutable source data
                            pristineReportData = JSON.parse(JSON.stringify(pData.rows));
                    
                                displayReportTable();
                            initializeControls();
                            loadDashboard(pData);

                            populateFormatterColumnLov(); 
                            loadAllFormatterBlocks();
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
    console.log('fullColumnName:>>>>>', fullColumnName);

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
        console.log('tableColumns>>>>>',tableColumns);
    if (typeof tableColumns === 'undefined' || !Array.isArray(tableColumns)) {
        console.warn('tableColumns is not defined or is not an array.');
        return null;
    }
    
    // The key format in tableColumns is "COL_NAME - TEMP_NAME"
    const lookupName = `${colName} - ${tempName}`;

    const columnMetadata = tableColumns.find(col => col.name === lookupName);
    console.log('tableColumns:>>>>>>>>>>>',columnMetadata);
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
    console.log('existingColumn:>>>>>>>',existingColumn);
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
        alert('Please enter a new column header');
        return;
    }
    
    // Assuming 'currentColumn' holds the full column identifier for 'parseColumnName'
    // You may need to use 'currentFullColumnName' if you adopted the variable name from my previous step.
    console.log('currentColumn:>>>>>>',currentColumn);
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
    console.log('columnInfo.col_name:>>>>>>>>>',columnInfo.col_name);
    console.log('columnInfo.col_name:>>>>>>>>>',columnInfo);
    // Find the column in jsondata_details
    const existingColumn = findColwithTemp(columnInfo.col_name, columnInfo.temp_name);
    console.log(':>>>>>>existingColumn>>>>>>>>',existingColumn);
    if (existingColumn) {
        // Update existing column with alias
        existingColumn.alias_name = newHeader;
        
        // NEW CODE: Update the visibility state
        existingColumn.visibility = selectedVisibility; 
        existingColumn.aggregation = selectedAggregation;

        console.log('Updated column alias and visibility:', existingColumn);
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
    console.log('Updated jsondata_details:', jsondata_details);
    
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
                console.log('AJAX Success:', data);
                showSuccessMessage(`Column header updated to: ${newHeader} `);
               //  
                
                hideColumnPopup();
                //loadDashboard(reporttblData);
                 recalculateAllFormulas();
                 applyAggregations(); 
                refreshTable();
                
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
    console.log('col_name::>',col_name);
    console.log('temp_name::>',temp_name);
    console.log('newAlias::>',newAlias);
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
    apex.message.showPageSuccess(message);
}
const CALCULATED_GROUP_NAME = 'Logical Column Group'; 









function displayReportTable() {
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
    
    // Show table and hide no data message
    document.getElementById('reporttblDataTable').style.display = 'table';
    noDataMessage.style.display = 'none';
    
    // Get all unique column names from the data (flattened approach)
    const allColumnKeys = Object.keys(reporttblData.rows[0] || {});
    
    // Create header row with column names
    const columnHeaderRow = document.createElement('tr');
    
    // First column for row numbers
    const rowNumTh = document.createElement('th');
    rowNumTh.textContent = '#';
    columnHeaderRow.appendChild(rowNumTh);
    
    // Create header cells for all columns
    allColumnKeys.forEach(fullColumnName => {
        const th = document.createElement('th');
        
        // Extract base column name (everything before first " - ")
        let baseCol = fullColumnName;
        let template = '';
        
        // Find the first occurrence of " - " to split column name from template
        const firstDashIndex = fullColumnName.indexOf(' - ');
        if (firstDashIndex !== -1) {
            baseCol = fullColumnName.substring(0, firstDashIndex);
            template = fullColumnName.substring(firstDashIndex + 3); // +3 to skip " - "
        }
        
        // For calculated columns (no template), use the full name as base
        if (!template) {
            baseCol = fullColumnName;
            template = CALCULATED_GROUP_NAME;
        }
        
        // Find the existing column configuration
     //   let existingColumn = findColumnInJsonData(baseCol, template);
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
        
        // Apply red color class based on visibility
        console.log('existingColumn:::>>>>>>>',existingColumn); 
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
    
    // Create table rows with data
        reporttblData.rows.forEach((row, index) => {
            const tr = document.createElement('tr');
            
            // Row number cell
            const rowNumberCell = document.createElement('td');
            rowNumberCell.textContent = index + 1;
            rowNumberCell.className = 'data-cell';
            tr.appendChild(rowNumberCell);
            
            // Data cells for all columns
            allColumnKeys.forEach(fullColumnName => {
                const td = document.createElement('td');
                let displayValue = row[fullColumnName];

                // Extract base column name and template for finding column config
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
                // Find the existing column configuration
               // let existingColumn = findColumnInJsonData(baseCol, template);
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

                // Round number fields to 2 decimal places
                if (existingColumn && existingColumn.data_type === 'number' && typeof displayValue === 'number') {
                    displayValue = displayValue.toFixed(2);
                } else if (template === CALCULATED_GROUP_NAME && typeof displayValue === 'number') {
                    displayValue = displayValue.toFixed(2);
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
}




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

let originalReportData = null; // Store original data for clearing filters

let tableColumns ; // Use the explicit object

// Global list to store saved formulas
let savedFormulas = {};
let currentFormulaName = '';
 
function initializeControls() {
    // These elements still exist and are needed:
    const columnSelect = document.getElementById('column-select');
    const columnLOV = document.getElementById('column-lov');
    
    // NOTE: Removed const filterColumn = document.getElementById('filter-column'); 
    
    // Clear previous content
    columnSelect.innerHTML = '';
    // NOTE: Removed filterColumn.innerHTML = ''; (This was the failing line)
    columnLOV.innerHTML = '<option value="">Select Column</option>';
    
    // Use the explicit tableColumns list
    tableColumns.forEach(column => {
        // Create a shorter name for display clarity
        const shortName = column.name.split(' - ')[0].replace(/_/g, ' '); 
        
        // 1. Formula Builder LOV (All Columns)
        const lovOption = document.createElement('option');
        lovOption.value = column.name;
        lovOption.textContent = shortName;
        columnLOV.appendChild(lovOption);

        // 2. Column Operations (Numeric Columns Only)
        if (column.type === 'number') {
            const opOption = document.createElement('option');
            opOption.value = column.name;
            opOption.textContent = shortName;
            columnSelect.appendChild(opOption);
        }

        // NOTE: Removed the logic that populated the old filter dropdown here.
    });
    
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
}

function addToFilter() {
    const column = document.getElementById('filter-column-lov').value;
    const operator = document.getElementById('filter-operator-lov').value;
    const preview = document.getElementById('filter-preview');
    
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
 
function loadConfigFromJSON(configData) {
    if (!configData || !configData.formulas || !configData.filters) {
        console.warn("No valid configuration data provided for loading formulas/filters.");
        return;
    }

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

    // 3. Apply Formulas to the current data set (reporttblData.rows)
    for (const [calcName, formulaObj] of Object.entries(savedFormulas)) {
        // Handle both formats: string (old) and object (new)
        let formulaString;
        
        if (typeof formulaObj === 'string') {
            formulaString = formulaObj;
        } else if (formulaObj && typeof formulaObj.formula === 'string') {
            formulaString = formulaObj.formula;
        } else {
            console.warn(`Invalid formula format for ${calcName}:`, formulaObj);
            continue;
        }
        
        reporttblData.rows.forEach(row => {
            let calculatedFormula = formulaString;
            
            // a. Substitute column names with values
            tableColumns.forEach(col => {
                // Check for column name with and without brackets
                const patterns = [
                    `\\[${escapeRegExp(col.name)}\\]`, // [COLUMN_NAME]
                    escapeRegExp(col.name)             // COLUMN_NAME
                ];
                
                patterns.forEach(pattern => {
                    const regex = new RegExp(pattern, 'g');
                    if (regex.test(calculatedFormula)) {
                        const cellValue = parseFloat(row[col.name]) || 0;
                        calculatedFormula = calculatedFormula.replace(regex, cellValue);
                    }
                });
            });

            // b. Final cleanup (convert 'and', 'or', '=')
            calculatedFormula = calculatedFormula.replace(/\s+and\s+/gi, ' && ');
            calculatedFormula = calculatedFormula.replace(/\s+or\s+/gi, ' || ');
            calculatedFormula = calculatedFormula.replace(/([^=!<>])=([^=])/g, '$1===$2');

            // c. Evaluate and store result
            try {
                let result = eval(`(${calculatedFormula})`);
                row[calcName] = result;
            } catch (error) {
                console.error(`Error applying loaded formula ${calcName}:`, error);
                row[calcName] = NaN;
            }
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
        displayReportTable();
    }
    
    // 5. Refresh UI controls (dropdowns)
    initializeControls(); 
}
 

localStorage.clear();

function applySavedFilter(clearFlag = false) {
    const filterExpression = clearFlag ? '' : document.getElementById('filter-preview').value.trim();
    
    if (!filterExpression) {
        reporttblData.rows = originalReportData;
        displayReportTable();
        return;
    }
    
    const columnMap = tableColumns.reduce((map, col) => {
        map[col.name] = col.type;
        return map;
    }, {});

    const filteredRows = originalReportData.filter(row => {
        let executableFilter = filterExpression;

        // 1. Replace all column names in the filter expression with row values
        for (const colName in columnMap) {
            
            const escapedName = escapeRegExp(`[${colName}]`);
            const regex = new RegExp(escapedName, 'g');
            
            let cellValue = row[colName];

            // 2. CRITICAL FIX: Cast values for safe execution
            // If defined as number, OR if the string content looks like a number, treat it numerically.
            const isNumericString = String(cellValue).match(/^\s*-?\d+(\.\d+)?\s*$/);

            if (columnMap[colName] === 'number' || isNumericString) {
                const numericValue = parseFloat(cellValue);
                if (!isNaN(numericValue) && isFinite(numericValue)) {
                    cellValue = numericValue; // Substitute raw number (e.g., 98)
                } else {
                    cellValue = 0; // Fallback
                }
            } else {
                cellValue = `'${String(cellValue).replace(/'/g, "\\'")}'`;
            }
            
            // Standard replacement
            executableFilter = executableFilter.replace(regex, cellValue);
        }

        // 3. Final cleanup: Convert JS string operators to use the raw, unquoted string
        executableFilter = executableFilter.replace(/'(.*?)'(\.includes|\.startsWith|\.endsWith)\('(.+?)'\)/g, (match, p1, p2, p3) => {
            return `String('${p1}')${p2}('${p3}')`;
        });
        
        // 4. Translate Textual Operators
        // Convert single equals sign (=) used as comparison to triple equals (===)
        executableFilter = executableFilter.replace(/([^=!<>])=([^=])/g, '$1===$2');
        
        // Convert 'and' and 'or' to their JavaScript equivalents (case-insensitive, handling surrounding spaces)
        executableFilter = executableFilter.replace(/\s+and\s+/gi, ' && ');
        executableFilter = executableFilter.replace(/\s+or\s+/gi, ' || ');

        // 5. Evaluate the filter expression
        try {
            return eval(executableFilter);
        } catch (e) {
            console.error('Filter evaluation error:', e, 'Expression:', executableFilter);
            return false; // Fail safe
        }
    });

    // Update global data and refresh the display
    reporttblData.rows = filteredRows;
    displayReportTable();
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

    console.log('savedFilters:>>>>>>>',savedFilters);

    for (const name in savedFilters) {
        if (savedFilters.hasOwnProperty(name)) {
            const item = document.createElement('div');
            item.className = 'formula-item';
            item.innerHTML = `
                <span>${name}</span>
                <div class="formula-item-buttons">
                    <div class="action-btn btn-info" onclick="useFilter('${name}')">Use</div>
                    <div class="action-btn btn-danger" onclick="deleteFilter('${name}')">Delete</div>
                </div>
            `;
            listElement.appendChild(item);
        }
    }
}

function useFilter(name) {
    const filter = savedFilters[name];
    if (filter) {
        document.getElementById('filter-preview').value = filter;
        document.getElementById('filter-name-input').value = name;
        document.getElementById('update-saved-filter').setAttribute('aria-disabled', 'false');
        currentFilterName = name;
    }
}

function deleteFilter(name) {
    if (confirm(`Are you sure you want to delete the filter: ${name}?`)) {
        delete savedFilters[name];
        saveFilters();
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
    clearFilterBuilder();
}

function updateSavedFilter() {
    const name = document.getElementById('filter-name-input').value;
    const filter = document.getElementById('filter-preview').value;
    
    if (!name || !filter || !(name in savedFilters)) {
        alert('Cannot update. Please select an existing filter using the "Use" button first.');
        return;
    }
    
    savedFilters[name] = filter;
    saveFilters();
    currentFilterName = name;
}

function loadSavedFormulas() {
    const savedFormulasList = document.getElementById('saved-formulas-list');
    savedFormulasList.innerHTML = '';
    
    // Load from localStorage if available
    const storedFormulas = localStorage.getItem('savedFormulas');
    if (storedFormulas) {
        savedFormulas = JSON.parse(storedFormulas);
    }
    console.log('savedFormulas:>>>>', savedFormulas);
    
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
        
        const formulaItem = document.createElement('div');
        formulaItem.className = 'formula-item';
        formulaItem.innerHTML = `
            <div>
                <strong>${name}</strong> (${formulaType}): ${formulaDisplay}
            </div>
            <div class="formula-item-buttons">
                <div class="use-formula action-btn btn-info" data-name="${name}" role="button">Use</div>
                <div class="delete-formula action-btn btn-danger" data-name="${name}" role="button">Delete</div>
            </div>
        `;
        savedFormulasList.appendChild(formulaItem);
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
    let formulaString;
    
    // Handle both formats
    if (typeof formulaObj === 'string') {
        formulaString = formulaObj;
    } else if (formulaObj && typeof formulaObj.formula === 'string') {
        formulaString = formulaObj.formula;
    } else {
        alert(`Invalid formula format for "${formulaName}"!`);
        return;
    }
    
    document.getElementById('calc-name').value = formulaName;
    document.getElementById('formula-preview').value = formulaString;
    currentFormulaName = formulaName;
    
    // Enable update button
    const updateBtn = document.getElementById('update-calculation');
    updateBtn.setAttribute('aria-disabled', 'false');
    updateBtn.style.opacity = '1';
    updateBtn.style.cursor = 'pointer';
    
    console.log(`Loaded formula: ${formulaName} = ${formulaString}`);
}
        
        // Delete a saved formula
        function deleteFormula(formulaName) {
            if (confirm(`Are you sure you want to delete the formula "${formulaName}"?`)) {
                delete savedFormulas[formulaName];
                saveFormulas();
                loadSavedFormulas();
                
                // If we're currently editing this formula, clear the form
                if (currentFormulaName === formulaName) {
                    clearFormula();
                }
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
    displayReportTable(); 
}

function clearFilter() {
    document.getElementById('filter-value').value = '';
    
    if (originalReportData) {
        reporttblData.rows = originalReportData;
        
        displayReportTable();
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

function loadDashboard(pData, configData = INITIAL_CONFIG_JSON) { // Added configData parameter
    console.log('Table data received for tab:', pData);
     console.log('INITIAL_CONFIG_JSON:', INITIAL_CONFIG_JSON);
    
    if (!pData || !pData.rows) {
        console.error("No valid data received.");
        return;
    }

  

    // 2. Update Global Data (this will be transformed by aggregations)
    reporttblData.rows = JSON.parse(JSON.stringify(pData.rows)); 
    originalReportData = [...pData.rows]; 
     
    // 3. Load Formulas/Filters from JSON and APPLY them
    if (configData) {
        loadConfigFromJSON(configData);
    }
    
    // 4. Apply any saved aggregations before displaying
    applyAggregations();
    
    // 5. Initialize Control Dropdowns & Setup UI
    initializeControls();
    setupCollapseButtons(); 
 
    displayReportTable();

    

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
    console.log('jsondata_details>>>>>>>>>>>>>>>>>>>>>>',jsondata_details);
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
            const currentFormula = document.getElementById('formula-preview').value;
            if (!currentFormula) {
                alert('Please create a formula first!');
                return;
            }
            
            try {
                // Test the formula with the first row of data
                const testRow = tableData.data[0];
                let testFormula = currentFormula;
                
                // Replace column names with actual values
                tableData.columns.forEach(col => {
                    if (testFormula.includes(col.name)) {
                        // Use a regex to replace whole words only to avoid partial matches within other column names
                        const regex = new RegExp(`\\b${col.name}\\b`, 'g');
                        testFormula = testFormula.replace(regex, testRow[col.name]);
                    }
                });
                
                // Evaluate the formula
                const result = eval(testFormula);
                
                alert(`Formula test result: ${result}\n\nUsing row: ${JSON.stringify(testRow)}`);
            } catch (error) {
                alert('Error testing formula: ' + error.message);
            }
        }

function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}


// ======================================================================
// FORMULA BUILDER FUNCTION (CORRECTED)
// ======================================================================
function addCalculation() { 
    const calcName = document.getElementById('calc-name').value;
    const currentFormula = document.getElementById('formula-preview').value;
    
    if (!calcName) {
        alert('Please enter a calculation name!');
        return;
    }
    
    if (!currentFormula) {
        alert('Please create a formula first!');
        return;
    }
    
    // Prevent duplicate calculation names
    if (tableColumns.find(col => col.name === calcName)) {
        alert('Calculation name already exists as a column or another calculation!');
        return;
    }

    try {
        pristineReportData.forEach(row => {
            let calculatedFormula = currentFormula;
            let result = null;
            let isDateCalculation = false;

            // Loop over all known columns
            tableColumns.forEach(col => {
                const fullColName = col.name;

                if (calculatedFormula.includes(fullColName)) {
                    const escapedName = escapeRegExp(fullColName);
                    const regex = new RegExp(escapedName, 'g');

                    // --- Handle DATE TYPE columns ---
                    if (col.type && col.type.toLowerCase() === 'date') {
                        isDateCalculation = true;
                        const rawValue = row[fullColName];
                        const dateObj = new Date(rawValue);

                        if (isNaN(dateObj)) {
                            console.warn("Invalid date in row:", rawValue);
                            row[calcName] = "-";
                            return;
                        }

                        // Handle "Day" (weekday)
                        if (/day/i.test(calculatedFormula)) {
                            const dayName = dateObj
                                .toLocaleDateString("en-GB", { weekday: "short" })
                                .toUpperCase();
                            result = dayName;
                        }
                        // Handle "+ number" or "- number"
                        else if (/\+/.test(calculatedFormula) || /-/.test(calculatedFormula)) {
                            // Extract +/- and number
                            const match = calculatedFormula.match(/([\+\-])\s*(\d+)/);
                            if (match) {
                                const sign = match[1];
                                const num = parseInt(match[2]);
                                if (sign === "+") dateObj.setDate(dateObj.getDate() + num);
                                else dateObj.setDate(dateObj.getDate() - num);
                            }

                            result = dateObj
                                .toLocaleDateString("en-GB", {
                                    day: "2-digit",
                                    month: "short",
                                    year: "numeric"
                                })
                                .toUpperCase(); // e.g. 10-OCT-2025
                        } 
                        else {
                            result = rawValue;
                        }

                        // Replace the date reference in formula to avoid numeric eval
                        calculatedFormula = calculatedFormula.replace(regex, `"${result}"`);
                    } 
                    // --- Handle NUMBER columns as before ---
                    else if (col.type && col.type.toLowerCase() === 'number') {
                        const cellValue = parseFloat(row[fullColName]) || 0; 
                        calculatedFormula = calculatedFormula.replace(regex, cellValue);
                    }
                }
            });

            // --- Evaluate only numeric formulas ---
            if (!isDateCalculation) {
                result = eval(`(${calculatedFormula})`);
            }

            row[calcName] = result;
        });

        // Update table data and metadata
        reporttblData.rows = JSON.parse(JSON.stringify(pristineReportData));
        originalReportData = [...reporttblData.rows];

        // Add metadata for new calculated column
        const newCalcColumn = { name: calcName, type: 'string' }; // formatted as text
        tableColumns.push(newCalcColumn);

        // Save formula metadata
        const formulaType = currentFormula.match(/DAY/i) ? 'date'
    : tableColumns.some(c => c.type === 'date' && currentFormula.includes(c.name))
        ? 'date'
        : 'number';

savedFormulas[calcName] = {
    formula: currentFormula,
    type: formulaType
};

saveFormulas();

        savedCalculationColumns.push(newCalcColumn);

        // Add to jsondata_details for popup management
        jsondata_details.selectedColumns.push({
            col_name: calcName,
            temp_name: 'calc',
            alias_name: calcName, 
            aggregation: 'none',
            visibility: 'show',
            data_type: 'string'
        });

        // Refresh table
        applyAggregations(); 
        initializeControls(); 
        displayReportTable(); 
        clearFormula();

    } catch (error) {
        alert('Error in formula: ' + error.message + '. Please check your formula syntax.');
        console.error('Formula error:', error);
    }
}

        
        let savedCalculationColumns = []; 


       function recalculateAllFormulas() {
    if (!savedFormulas || Object.keys(savedFormulas).length === 0) return;
    if (!pristineReportData || pristineReportData.length === 0) return;

    console.log("Recalculating all formulas...");

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
    displayReportTable();
}


        // Update calculated column
        function updateCalculation() {
            // Check for disabled state on div
            if (document.getElementById('update-calculation').getAttribute('aria-disabled') === 'true') {
                return;
            }

            const currentFormula = document.getElementById('formula-preview').value;

            if (!currentFormulaName) {
                alert('Please select a formula to update first!');
                return;
            }
            
            if (!currentFormula) {
                alert('Please modify the formula first!');
                return;
            }
            console.log('pristineReportData:>>>>>>',pristineReportData);
            try {
                // Apply formula to all rows
                pristineReportData.forEach(row => {
            let calculatedFormula = currentFormula;
            let result = null;
            let isDateCalculation = false;

            // Loop over all known columns
            tableColumns.forEach(col => {
                const fullColName = col.name;

                if (calculatedFormula.includes(fullColName)) {
                    const escapedName = escapeRegExp(fullColName);
                    const regex = new RegExp(escapedName, 'g');

                    // --- Handle DATE TYPE columns ---
                    if (col.type && col.type.toLowerCase() === 'date') {
                        isDateCalculation = true;
                        const rawValue = row[fullColName];
                        const dateObj = new Date(rawValue);

                        if (isNaN(dateObj)) {
                            console.warn("Invalid date in row:", rawValue);
                            row[calcName] = "-";
                            return;
                        }

                        // Handle "Day" (weekday)
                        if (/day/i.test(calculatedFormula)) {
                            const dayName = dateObj
                                .toLocaleDateString("en-GB", { weekday: "short" })
                                .toUpperCase();
                            result = dayName;
                        }
                        // Handle "+ number" or "- number"
                        else if (/\+/.test(calculatedFormula) || /-/.test(calculatedFormula)) {
                            // Extract +/- and number
                            const match = calculatedFormula.match(/([\+\-])\s*(\d+)/);
                            if (match) {
                                const sign = match[1];
                                const num = parseInt(match[2]);
                                if (sign === "+") dateObj.setDate(dateObj.getDate() + num);
                                else dateObj.setDate(dateObj.getDate() - num);
                            }

                            result = dateObj
                                .toLocaleDateString("en-GB", {
                                    day: "2-digit",
                                    month: "short",
                                    year: "numeric"
                                })
                                .toUpperCase(); // e.g. 10-OCT-2025
                        } 
                        else {
                            result = rawValue;
                        }

                        // Replace the date reference in formula to avoid numeric eval
                        calculatedFormula = calculatedFormula.replace(regex, `"${result}"`);
                    } 
                    // --- Handle NUMBER columns as before ---
                    else if (col.type && col.type.toLowerCase() === 'number') {
                        const cellValue = parseFloat(row[fullColName]) || 0; 
                        calculatedFormula = calculatedFormula.replace(regex, cellValue);
                    }
                }
            });

            // --- Evaluate only numeric formulas ---
            if (!isDateCalculation) {
                result = eval(`(${calculatedFormula})`);
            }

            row[currentFormulaName] = result;
        });
                    // Evaluate the formula
                   // row[currentFormulaName] = eval(currentFormula);
              
                 reporttblData.rows = JSON.parse(JSON.stringify(pristineReportData));
                originalReportData = [...reporttblData.rows];
                // Update the saved formula
                savedFormulas[currentFormulaName] = currentFormula;
                saveFormulas();
                applyAggregations(); 
        initializeControls(); 
        displayReportTable();  
                // Clear inputs
                clearFormula();
                
            } catch (error) {
                alert('Error in formula::::> ' + error.message);
            }
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

    console.log("Column changed:", selectedValue);

    // Try to get column data type from tableColumns or columns_list
    let columnType = null;
    if (typeof tableColumns !== "undefined" && Array.isArray(tableColumns)) {
        const found = tableColumns.find(c => c.name === selectedValue);
        if (found && found.type) {
            columnType = found.type.toLowerCase();
        }
    }

    console.log("Detected column type:", columnType);

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

    console.log("Operator LOV updated:", operators);
});


        // NOTE: Assumes REPORT_COL_OBJ, savedFormulas, and savedFilters are globally available.
function saveAllDataToJSON() {
    // CRITICAL STEP 1: Update the conditional formatting rules from the UI 
    // to ensure the global conditionalFormattingRules object is current.
    saveConditionalFormatting();

    // 2. Collect all relevant configuration data
    const configuration = {
        // Includes the starting column metadata for reference
        columnConfiguration: jsondata_details, 
        columnMetadata: tableColumns, 
        formulas: savedFormulas,
        filters: savedFilters,
        // CRITICAL STEP 3: Include the newly collected conditional formatting rules
        conditionalFormatting: conditionalFormattingRules 
    };

    // 4. Format as a readable JSON string (4 spaces indentation)
    const jsonString = JSON.stringify(configuration, null, 4);

    // 5. Log to console for debugging/easy copy-paste
    console.log(hotelLov.options[hotelLov.selectedIndex].value+"--- EXPORTED CONFIGURATION JSON ---"+$('#New-Report').val());
    console.log(jsonString);

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
                console.log('AJAX Success:', data);
                showSuccessMessage(`Expressions Saved! `);
              
                    
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error('AJAX Error:', errorThrown);
                alert('Error saving column alias. Please try again.');
            }
        }
    ); 

    console.log("-----------------------------------");

    // Optional: Add logic here to display the JSON to the user or initiate a download
    // For example: downloadJSON(jsonString, 'report_configuration.json');
}



function loadConditionalFormattingBlocks() {

     if (typeof conditionalFormattingRules !== 'object' || conditionalFormattingRules === null) {
        conditionalFormattingRules = {}; 
    }
    console.log('conditionalFormattingRules:>>>',conditionalFormattingRules);
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
        addColumnFormatterBlock();
        console.log('conditionalFormattingRules:>>>>>>0');
        return;
    }

    // 2. Iterate through each column that has rules
    for (const columnKey in conditionalFormattingRules) {
        if (conditionalFormattingRules.hasOwnProperty(columnKey)) {
            const rulesArray = conditionalFormattingRules[columnKey];
            console.log('conditionalFormattingRules:>>>>>>>>>',rulesArray);
            console.log('conditionalFormattingRules:>>>>>>>>>',columnKey);
            // 3. For each column, call addColumnFormatterBlock, passing the 
            //    column key and the array of rules to pre-populate it.
            addColumnFormatterBlock(columnKey, rulesArray);
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

 function addColumnFormatterBlock(columnKey = null, rules = []) {
    formatterBlockIdCounter++;
    const blockId = formatterBlockIdCounter;
    const mainContainer = document.getElementById('formatterConfigurationsContainer');
    
    if (!mainContainer) {
        console.error('Main formatter container (#formatterConfigurationsContainer) not found.');
        return;
    }

    const blockDiv = document.createElement('div');
    blockDiv.className = 'formatter-config-block';
    blockDiv.setAttribute('data-block-id', blockId);
    blockDiv.style.cssText = 'border: 1px solid #333; padding: 15px; margin-bottom: 20px; border-radius: 5px; background-color: #1e1e1e;';

    // 1. Set the INNER HTML (creates the nested rules container element)
    blockDiv.innerHTML = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <h3 style="color: #fff; font-size: 16px;">Configuration Block ${blockId}</h3>
            <div class="remove-block-btn popup-button cancel-button" onclick="removeFormatterBlock(${blockId})">Remove Filter</div>
        </div>

        <div class="form-group">
            <label class="form-label" for="formatterColumnLov_${blockId}">Select Column:</label>
            <select id="formatterColumnLov_${blockId}" class="form-input"></select>
        </div>

        <div style="border-top: 1px solid #444; padding-top: 10px; margin-top: 10px;">
            <h4 style="color: #ccc; font-size: 14px; margin-bottom: 10px;">Rules:</h4>
            <div class="formatter-rules-container" id="formatterRulesContainer_${blockId}">
                </div>
            <div id="addFormatterRuleBtn_${blockId}" class="popup-button" data-block-id="${blockId}" style="margin-top: 10px;">+ Add Rule</div>
        </div>
    `;

    // 2. CRITICAL STEP: Append the block to the DOM FIRST.
    mainContainer.appendChild(blockDiv);
    console.log('1');
    // 3. RETRIEVE REFERENCE: Get the direct reference to the rules container now that it's in the DOM.
    const rulesContainerRef = document.getElementById(`formatterRulesContainer_${blockId}`);
    
    // 4. Now, call initialization functions
    populateFormatterColumnLov(blockId, columnKey);
console.log('2');
    if (rules && rules.length > 0) {
        rules.forEach(rule => {
            // PASS THE CONTAINER REFERENCE DIRECTLY
            addFormatterRule(blockId, rule.expression, rule.color, rulesContainerRef); 
            console.log('3');
        });
    } else {
        // PASS THE CONTAINER REFERENCE DIRECTLY
        addFormatterRule(blockId, '', '', rulesContainerRef); 
        console.log('4');
    }
}

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
    const container = containerRef; 
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
    console.log('ruleId',ruleId);
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




let columnFormatterRules = {}; 

function saveConditionalFormatting() {
    // 1. Prepare to clear and rebuild the global rules object
    const newRules = {};
    let totalRulesSaved = 0;
    
    const configBlocks = document.querySelectorAll('#formatterConfigurationsContainer .formatter-config-block');

    configBlocks.forEach(block => {
        const blockId = block.getAttribute('data-block-id');
        const targetColumnKey = document.getElementById(`formatterColumnLov_${blockId}`).value;

        // Skip configurations without a selected column
        if (!targetColumnKey) {
            return; 
        }

        const blockRules = [];
        const ruleElements = block.querySelectorAll('.formatter-rule');

        ruleElements.forEach(element => {
            const ruleIdStr = element.getAttribute('data-rule-id'); 
            const expressionId = `formatterExpression_${blockId}_${ruleIdStr}`; // Unique ID
            const colorId = `formatterColor_${blockId}_${ruleIdStr}`; // Unique ID

            const rawExpressionValue = document.getElementById(expressionId)?.value;
            const color = document.getElementById(colorId)?.value;

            if (rawExpressionValue && color) {
                // Clean up expression (trim, remove semicolon/braces, single line)
                const expression = rawExpressionValue.trim().replace(/[;{}]$/g, '').replace(/[\r\n]/g, ' '); 
                if (expression) {
                    blockRules.push({
                        expression: expression,
                        color: color
                    });
                    totalRulesSaved++;
                }
            }
        });

        // Only save the block if it has at least one valid rule
        if (blockRules.length > 0) {
            newRules[targetColumnKey] = blockRules;
        }
    });

    // 2. Overwrite the global rules object with the new configurations
    conditionalFormattingRules = newRules;
    
    // 3. Complete the process
    console.log('FINAL CONDITIONAL FORMATTING JSON:', conditionalFormattingRules);

    displayReportTable(); 
    showSuccessMessage(`Successfully applied ${totalRulesSaved} rules across ${Object.keys(newRules).length} column(s).`, 'success');
}

function loadAllFormatterBlocks() {
    const container = document.getElementById('formatterConfigurationsContainer');
    if (!container) return;
    
    container.innerHTML = ''; // Clear existing blocks

    // Reset counters to prevent ID collisions if rules are loaded
    formatterBlockIdCounter = 0; 
    formatterRuleIdCounter = 0; 

    // If there are saved rules, create a block for each column
    if (Object.keys(conditionalFormattingRules).length > 0) {
        console.log('conditionalFormattingRules:>>>>>>>>>>>>>>>>>>>>>>>>>>>',conditionalFormattingRules);
        for (const columnKey in conditionalFormattingRules) {
            if (conditionalFormattingRules.hasOwnProperty(columnKey)) {
                addColumnFormatterBlock(columnKey, conditionalFormattingRules[columnKey]);
            }
        }
    }

    // If no rules were loaded, add one empty block by default
    if (formatterBlockIdCounter === 0) {
        addColumnFormatterBlock();
    }
}

function clearAllFormatters() {
    conditionalFormattingRules = {};
    loadAllFormatterBlocks(); // Resets the UI to one empty block
    displayReportTable(); 
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
    displayReportTable(); 
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
    let calculatedExpression = expression;
    
    if (!jsondata_details || !jsondata_details.selectedColumns) {
        return false;
    }

    // 1. Substitution: Replace [ColumnName] with its value (omitted for brevity, assume existing logic)
    jsondata_details.selectedColumns.forEach(col => {
        const fullColName = getColumnDataKey(col); 
        const escapedName = escapeRegExp(fullColName);
        const nameRegex = new RegExp('\\[ *' + escapedName + ' *\\\]', 'g'); 
        
        const cellValue = row[fullColName];
        
        if (nameRegex.test(calculatedExpression)) {
            
            let substitutionValue;
            
            if (col.data_type === 'number' || (col.temp_name === 'calc' && typeof cellValue === 'number')) {
                substitutionValue = parseFloat(cellValue) || 0; 
            } else if (col.data_type === 'date' || col.data_type === 'string') {
                const rawString = cellValue === null || cellValue === undefined ? 'null' : String(cellValue);
                substitutionValue = `'${rawString.replace(/'/g, "\\'")}'`; 
            } else {
                substitutionValue = 0; 
            }

            calculatedExpression = calculatedExpression.replace(nameRegex, substitutionValue);
        }
    });

    calculatedExpression = calculatedExpression.trim();

    // 2. ROBUSTNESS CHECK & PRE-EVALUATION CLEANUP
    if (!calculatedExpression) {
         return false;
    }

 
    calculatedExpression = calculatedExpression.replace(/([^=!><])=([^=])/g, '$1==$2');
    
    // Handle case where '=' is at the start (e.g., '=1' becomes '==1')
    calculatedExpression = calculatedExpression.replace(/^=/g, '==');


    const danglingOperatorRegex = /([=!><+\-*/%]|AND|OR)$/i;
    if (danglingOperatorRegex.test(calculatedExpression)) {
        console.warn('Evaluation skipped: Expression ends with a dangling operator or logical keyword. Expression:', calculatedExpression);
        return false;
    }
    
    // 3. Final Evaluation
    try {
        return new Function('return ' + calculatedExpression)();
    } catch (e) {
        console.warn('Error evaluating formatter expression:', calculatedExpression, 'ReferenceError:', e.message);
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
            document.getElementById('calculate-btn').addEventListener('click', calculateOperation); 
            document.getElementById('add-to-formula').addEventListener('click', addToFormula);
            document.getElementById('add-calculation').addEventListener('click', addCalculation);
            // Must check for disabled state on click for update-calculation
            document.getElementById('update-calculation').addEventListener('click', updateCalculation);
            document.getElementById('clear-formula').addEventListener('click', clearFormula);
            document.getElementById('test-formula').addEventListener('click', testFormula);

            const saveAllButton = document.getElementById('saveAllButton');
                if (saveAllButton) {
                    saveAllButton.addEventListener('click', saveAllDataToJSON);
                }
                

            document.getElementById('add-to-filter').addEventListener('click', addToFilter);
            document.getElementById('apply-saved-filter').addEventListener('click', () => applySavedFilter(false));
            document.getElementById('add-saved-filter').addEventListener('click', addSavedFilter);
            document.getElementById('update-saved-filter').addEventListener('click', updateSavedFilter);
            document.getElementById('clear-filter-builder').addEventListener('click', clearFilterBuilder);


        

  
document.getElementById('addColumnFormatterBtn').addEventListener('click', addColumnFormatterBlock);
document.getElementById('saveAllFormatters').addEventListener('click', saveConditionalFormatting); 
document.getElementById('clearAllFormatters').addEventListener('click', clearAllFormatters);

// 2. Event delegation for dynamically added buttons
const container = document.getElementById('formatterConfigurationsContainer');
if (container) {
    container.addEventListener('click', function(e) {
        
        // --- Handle 'Add Rule' Button click within a block ---
        const addRuleBtn = e.target.closest('[id^="addFormatterRuleBtn_"]');
        if (addRuleBtn) {
            const blockId = addRuleBtn.getAttribute('data-block-id');
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
    console.log('DOM loaded - jsondata_details:', jsondata_details);
    
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
    console.log('Refreshing table...');
    displayReportTable();
}




        // Initialize the application
        init();
