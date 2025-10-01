const staticData = {
    operators: ['=', '!=', '>', '<', '>=', '<='],
    expressionOperators: ['+', '-', '/', '*'],
    attributes: ['Occupancy', 'ADR', 'RevPAR', 'Booking Pace', 'Market Share'],
    propertyTypes: ['Hotel', 'Motel', 'Resort', 'Apartment', 'Vacation Rental'],
    functions: ['Average', 'Sum', 'Count', 'Max', 'Min']
};

let regionCounter = 0;
let conditionCounter = 0;
let autocompleteContainer = null;
let activeAutocompleteIndex = -1;

var savedJsonString = null; 

document.addEventListener('DOMContentLoaded', function() {
    autocompleteContainer = document.createElement('div');
    autocompleteContainer.id = 'expression-autocomplete';
    document.body.appendChild(autocompleteContainer);

    document.addEventListener('click', (e) => {
        if (!e.target.closest('.expression-textarea')) {
            hideAutocomplete();
        }
    });

    // --- INITIAL PAGE LOAD LOGIC ---
    // On page load, get the initial JSON from your APEX page item
    // *** Replace P1_SAVED_CONFIG_JSON with the actual name of your page item ***
    
  //  load_data_expression();
    

 
});



function load_data_expression(){
    
    var algo_list_val = document.getElementById('P1050_ALGO_LIST');
    var version_val = document.getElementById("P1050_VERSION").value;
    let beforeParen = version_val.split("(")[0].trim();

    console.log('algo_list_val:>',algo_list_val.options[ algo_list_val.selectedIndex].value);
    console.log('version_val:>',beforeParen);
    apex.server.process(
                'AJX_MANAGE_ALGO',
                { x01: 'SELECT'
                  ,x02: algo_list_val.options[ algo_list_val.selectedIndex].value
                  ,x03:  beforeParen
                  },
                {
                    success: function(data) { 
                        console.log('data[0].l_payload:>>>>',data[0].l_payload);
                        console.log('algo_list:>>', document.getElementById('P1050_ALGO_LIST').options[ document.getElementById('P1050_ALGO_LIST').selectedIndex].value); 
                           // showSuccessMessage( ` From Package:>  ${ data[0].l_payload } `);  
                           savedJsonString =  data[0].l_payload;
                           
                        
                        let savedData = null;
                        try {
                        if(savedJsonString) {
                            savedData = JSON.parse(savedJsonString);
                        }
                        } catch (e) {
                        console.error("Failed to parse initial JSON data:", e);
                        savedData = null; 
                        }

                        // Load from the parsed data, or create a fresh region if no data exists
                        if (savedData && savedData.regions && savedData.regions.length > 0) {
                        console.log('savedData:>',savedData);
                        loadFromJSON(savedData);

                        } else {
                        addFilterRegion();
                        }
                        // --- END INITIAL PAGE LOAD LOGIC ---

                       // document.getElementById('addRegionBtn').addEventListener('click', addFilterRegion);
                        //document.getElementById('saveAllBtn').addEventListener('click', saveAllRegions);
                      //  document.getElementById('validateAllBtn').addEventListener('click', validateAllRegions);


                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('AJAX Error::>>>'+ errorThrown );
                    }
                }
            );
addFilterRegion();
 document.getElementById('addRegionBtn').addEventListener('click', addFilterRegion);
                        document.getElementById('saveAllBtn').addEventListener('click', saveAllRegions);
                        document.getElementById('validateAllBtn').addEventListener('click', validateAllRegions);

}

function loadFromJSON(savedData) {
    const filterContainer = document.getElementById('filterContainer');
    // Clear any existing regions (like the default one added on page load)
    filterContainer.innerHTML = '';
    
    if (!savedData || !savedData.regions) {
        console.error("Invalid or empty data provided to loadFromJSON.");
        // If there's no saved data, add one default empty region to start.
        addFilterRegion();
        return;
    }

    // Create and populate each region from the saved data
    savedData.regions.forEach(regionData => {
        addFilterRegion(); // Creates a new, empty region
        // Find the region we just created (it will be the last one)
        const newRegionElement = filterContainer.lastElementChild;
        if (newRegionElement) {
            populateRegion(newRegionElement, regionData);
        }
    });

    // After all regions are created and populated, update sequences and move buttons
    updateRegionSequence();
    document.querySelectorAll('.filter-region').forEach(region => {
        updateConditionSequence(region.id);
    });
}

/**
 * Populates a single filter region's UI elements based on its data object.
 * @param {HTMLElement} regionElement The DOM element for the filter region.
 * @param {object} regionData The JSON object for this specific region.
 */
function populateRegion(regionElement, regionData) {
    const regionId = regionElement.id;

    // 1. Set custom name and sequence
    regionElement.dataset.sequence = regionData.sequence;
    const titleDisplay = regionElement.querySelector('.title-display');
    const titleInput = regionElement.querySelector('.title-input');
    if (titleDisplay && titleInput) {
        titleDisplay.textContent = regionData.name;
        titleInput.value = regionData.name;
    }

    // 2. Populate Filters
    if (regionData.filters) {
        for (const [filterKey, filterValue] of Object.entries(regionData.filters)) {
            // Find the checkbox for this filter
            const filterCheckbox = regionElement.querySelector(`[data-validates="${filterKey}"]`);
            if (!filterCheckbox) continue;

            // Check the box and dispatch a change event to show the fields
            filterCheckbox.checked = true;
            filterCheckbox.dispatchEvent(new Event('change'));

            // Populate the specific filter's inputs
            if (filterKey === 'stayWindow') {
                regionElement.querySelector('.stay-window-from').value = filterValue.from;
                regionElement.querySelector('.stay-window-to').value = filterValue.to;
            } else if (filterKey === 'leadTime') {
                const select = regionElement.querySelector('.load-time-select');
                select.value = filterValue.type;
                // Dispatch change event to create the dynamic date/number inputs
                select.dispatchEvent(new Event('change'));
                if (filterValue.type === 'date_range') {
                    regionElement.querySelector('.lead-time-from').value = filterValue.from;
                    regionElement.querySelector('.lead-time-to').value = filterValue.to;
                } else {
                    regionElement.querySelector('.lead-time-value').value = filterValue.value;
                }
            } else if (filterKey === 'daysOfWeek') {
                const dayMap = { 1: 'sun', 2: 'mon', 3: 'tue', 4: 'wed', 5: 'thu', 6: 'fri', 7: 'sat' };
                filterValue.forEach(dayNumber => {
                    const dayCheckbox = regionElement.querySelector(`#${regionId}-${dayMap[dayNumber]}`);
                    if (dayCheckbox) dayCheckbox.checked = true;
                });
            } else if (filterKey === 'minimumRate') {
                regionElement.querySelector('.minimum-rate-input').value = filterValue;
            }
        }
    }

    // 3. Populate Conditions
    const conditionsContainer = regionElement.querySelector('.conditions-container');
    conditionsContainer.innerHTML = ''; // Clear the default empty condition

    if (regionData.conditions && regionData.conditions.length > 0) {
        regionData.conditions.forEach(conditionData => {
            addCondition(regionId);
            const newConditionElement = conditionsContainer.lastElementChild;
            if (newConditionElement) {
                populateCondition(newConditionElement, conditionData);
            }
        });
    }
}

/**
 * Populates a single condition's UI elements based on its data object.
 * @param {HTMLElement} conditionElement The DOM element for the condition group.
 * @param {object} conditionData The JSON object for this specific condition.
 */
function populateCondition(conditionElement, conditionData) {
    // 1. Set custom name and sequence
    conditionElement.dataset.sequence = conditionData.sequence;
    const titleDisplay = conditionElement.querySelector('.title-display');
    const titleInput = conditionElement.querySelector('.title-input');
    if (titleDisplay && titleInput) {
        titleDisplay.textContent = conditionData.name;
        titleInput.value = conditionData.name;
    }

    // 2. Populate condition fields
    for (const [key, data] of Object.entries(conditionData)) {
        const checkbox = conditionElement.querySelector(`[data-validates="${key}"]`);
        if (checkbox) {
            checkbox.checked = true;
            checkbox.dispatchEvent(new Event('change'));
            
            // Populate inputs within the now-visible field
            const fieldContent = checkbox.closest('.field-container').querySelector('.field-content');
            if (key === 'occupancyThreshold' || key === 'eventScore') {
                fieldContent.querySelector('.operator-select').value = data.operator;
                fieldContent.querySelector('.value-input').value = data.value;
            } else if (key === 'propertyRanking') {
                fieldContent.querySelector('.property-type-select').value = data.type;
                fieldContent.querySelector('.operator-select').value = data.operator;
                fieldContent.querySelector('.value-input').value = data.value;
            }
        }
    }

    // 3. Populate Expression
    if (conditionData.expression) {
        conditionElement.querySelector('.expression-textarea').value = conditionData.expression;
    }
}


// --- AUTOCOMPLETE HELPER FUNCTIONS ---
function getCursorXY(textarea) {
    const mirror = document.createElement('div');
    const style = getComputedStyle(textarea);
    const rect = textarea.getBoundingClientRect();
    const properties = [
        'boxSizing', 'width', 'height', 'fontFamily', 'fontSize', 'fontWeight', 'fontStyle',
        'letterSpacing', 'lineHeight', 'textTransform', 'wordSpacing', 'whiteSpace', 'wordWrap',
        'paddingTop', 'paddingRight', 'paddingBottom', 'paddingLeft',
        'borderTopWidth', 'borderRightWidth', 'borderBottomWidth', 'borderLeftWidth'
    ];
    properties.forEach(prop => { mirror.style[prop] = style[prop]; });
    mirror.style.position = 'absolute';
    mirror.style.visibility = 'hidden';
    mirror.style.top = `${textarea.offsetTop}px`;
    mirror.style.left = `${textarea.offsetLeft}px`;
    const cursorPos = textarea.selectionStart;
    mirror.innerHTML = textarea.value.substring(0, cursorPos).replace(/\n/g, '<br>') + '<span id="cursor-span"></span>';
    document.body.appendChild(mirror);
    const span = document.getElementById('cursor-span');
    const coords = {
        top: rect.top + span.offsetTop - textarea.scrollTop + window.scrollY,
        left: rect.left + span.offsetLeft - textarea.scrollLeft + window.scrollX
    };
    document.body.removeChild(mirror);
    return coords;
}

function showAutocomplete(textarea, items, options) {
    if (!autocompleteContainer) return;
    autocompleteContainer.innerHTML = '';
    activeAutocompleteIndex = -1;
    if (items.length === 0) {
        hideAutocomplete();
        return;
    }
    items.forEach((item, index) => {
        const div = document.createElement('div');
        div.className = 'autocomplete-item';
        div.textContent = item;
        div.addEventListener('mouseover', () => setActiveAutocompleteItem(index));
        div.addEventListener('click', () => {
            const startPos = textarea.selectionStart;
            const textBefore = textarea.value.substring(0, startPos - 1);
            const textAfter = textarea.value.substring(startPos);
            let textToInsert = (options.type === 'attribute') ? `#${item}# ` : `${item}() `;
            textarea.value = textBefore + textToInsert + textAfter;
            let newCursorPos = (textBefore + textToInsert).length;
            if (options.type === 'function') newCursorPos -= 2;
            textarea.focus();
            textarea.setSelectionRange(newCursorPos, newCursorPos);
            hideAutocomplete();
        });
        autocompleteContainer.appendChild(div);
    });
    const coords = getCursorXY(textarea);
    autocompleteContainer.style.left = `${coords.left}px`;
    autocompleteContainer.style.top = `${coords.top + 20}px`;
    autocompleteContainer.style.display = 'block';
    setActiveAutocompleteItem(0);
}

function hideAutocomplete() {
    if (autocompleteContainer) {
        autocompleteContainer.style.display = 'none';
        activeAutocompleteIndex = -1;
    }
}

function setActiveAutocompleteItem(index) {
    if (!autocompleteContainer) return;
    const items = autocompleteContainer.querySelectorAll('.autocomplete-item');
    if (index < 0 || index >= items.length) return;
    items.forEach(item => item.classList.remove('autocomplete-active'));
    items[index].classList.add('autocomplete-active');
    items[index].scrollIntoView({ block: 'nearest' });
    activeAutocompleteIndex = index;
}

// --- UI AND EVENT FUNCTIONS ---
function addFilterRegion() {
    const filterContainer = document.getElementById('filterContainer');
    const newIndex = filterContainer.children.length + 1;
    regionCounter++;
    const regionId = `region-${regionCounter}`;
    const defaultName = `Filter Region ${newIndex}`;
    
    const regionElement = document.createElement('div');
    regionElement.className = 'filter-region';
    regionElement.id = regionId;

    const today = new Date();
    const nextWeek = new Date();
    nextWeek.setDate(today.getDate() + 7);
    const formatDate = (date) => date.toISOString().split('T')[0];

    regionElement.innerHTML = `
        <div class="region-header">
            <div class="region-title editable-title">
                 <span class="toggle-icon">▼</span>
                 <span class="region-sequence">${newIndex}.</span>
                 <span class="title-display">${defaultName}</span>
                 <input type="text" class="title-input hidden" value="${defaultName}" />
            </div>
            <div class="region-controls">
                <div class="control-group">
                    <button class="btn btn-small region-move up" data-direction="up" title="Move Region Up">▲</button>
                    <button class="btn btn-small region-move down" data-direction="down" title="Move Region Down">▼</button>
                    <button class="btn btn-small btn-danger delete-region" title="Delete Region">×</button>
                </div>
            </div>
        </div>
        <div class="validation-messages" style="display: none;"></div>
        <div class="region-content">
            <div class="section">
                <div class="section-title"><span>Filters</span></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${regionId}-stay-window" data-validates="stayWindow"><label for="${regionId}-stay-window">Stay Window</label><div class="field-content hidden"><label>From</label> <input type="date" class="stay-window-from" value="${formatDate(today)}"><label>To</label> <input type="date" class="stay-window-to" value="${formatDate(nextWeek)}"></div></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${regionId}-load-time" data-validates="leadTime"><label for="${regionId}-load-time">Lead Time</label><div class="field-content hidden"><select class="load-time-select"><option value="">Select Type</option><option value="date_range">Date Range</option><option value="days">Day(s)</option><option value="weeks">Week(s)</option><option value="months">Month(s)</option></select><div class="lead-time-inputs"></div></div></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${regionId}-days-of-week" data-validates="daysOfWeek"><label for="${regionId}-days-of-week">Day of Week</label><div class="field-content hidden"><div class="checkbox-group">${['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'].map(day => `<div class="checkbox-item"><input type="checkbox" id="${regionId}-${day}" class="day-checkbox"><label for="${regionId}-${day}">${day.toUpperCase()}</label></div>`).join('')}</div></div></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${regionId}-minimum-rate" data-validates="minimumRate"><label for="${regionId}-minimum-rate">Minimum Rate</label><div class="field-content hidden"><input type="number" value="4" min="0" class="minimum-rate-input"></div></div>
            </div>
            <div class="section">
                <div class="section-title">
                    <span>Conditions & Expressions</span>
                    <div class="btn btn-small" id="${regionId}-add-condition">+ Add Condition</div>
                </div>
                <div class="conditions-container" id="${regionId}-conditions-container"></div>
            </div>
        </div>`;

    filterContainer.appendChild(regionElement);
    setupRegionEventListeners(regionElement);
    addCondition(regionId);
    updateRegionSequence();
}

function addCondition(regionId) {
    conditionCounter++;
    const conditionId = `condition-${regionCounter}-${conditionCounter}`;
    const conditionsContainer = document.getElementById(`${regionId}-conditions-container`);
    const defaultName = `Condition ${conditionsContainer.children.length + 1}`;
    const conditionElement = document.createElement('div');
    conditionElement.className = 'condition-group';
    conditionElement.id = conditionId;

    conditionElement.innerHTML = `
        <div class="condition-header">
            <div class="condition-title editable-title">
                <span class="toggle-icon condition-toggle">▼</span>
                <span class="condition-sequence">${conditionsContainer.children.length + 1}.</span>
                <span class="title-display">${defaultName}</span>
                <input type="text" class="title-input hidden" value="${defaultName}" />
            </div>
            <div class="control-group condition-controls">
                <button class="btn btn-small condition-move up" data-direction="up" title="Move Up">▲</button>
                <button class="btn btn-small condition-move down" data-direction="down" title="Move Down">▼</button>
                <button class="btn btn-small btn-danger condition-remove" title="Remove Condition">×</button>
            </div>
        </div>
        <div class="condition-body" style="display: flex; align-items: flex-start; gap: 20px;">
            <div class="condition-fields" style="flex: 3;">
                 <div class="section-title"><span>Conditions</span></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${conditionId}-occupancy-threshold" data-validates="occupancyThreshold"><label for="${conditionId}-occupancy-threshold">Occupancy Threshold %</label><div class="field-content hidden"><select class="operator-select occupancy-operator">${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}</select><input type="number" class="value-input occupancy-value" value="80" min="0" max="100"></div></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${conditionId}-property-ranking" data-validates="propertyRanking"><label for="${conditionId}-property-ranking">Property Ranking (Comp. Set)</label><div class="field-content hidden"><select class="property-type-select property-type"><option value="">Select Type</option>${staticData.propertyTypes.map(type => `<option value="${type}">${type}</option>`).join('')}</select><select class="operator-select property-operator">${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}</select><input type="text" class="value-input property-value" placeholder="Value"></div></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${conditionId}-event-score" data-validates="eventScore"><label for="${conditionId}-event-score">Event Score</label><div class="field-content hidden"><select class="operator-select event-operator">${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}</select><input type="number" class="value-input event-value" value="0" min="0"></div></div>
            </div>
            <div class="condition-expression" style="flex: 2; border-left: 1px solid #444; padding-left: 20px;">
                 <div class="section calculation-section" style="padding: 0; border: none; background: none;">
                    <div class="section-title"><span>Expression</span></div>
                    <div class="filter-row"><div class="filter-group"><select class="attribute-select"><option value="">Select Attribute</option>${staticData.attributes.map(attr => `<option value="${attr}">${attr}</option>`).join('')}</select><select class="operator-select expression-operator"><option value="">Select Operator</option>${staticData.expressionOperators.map(op => `<option value="${op}">${op}</option>`).join('')}</select><select class="function-select"><option value="">Select Function</option>${staticData.functions.map(func => `<option value="${func}">${func}</option>`).join('')}</select></div></div>
                    <div class="expression-container"><textarea class="expression-textarea" placeholder="Type # for attributes or = for functions..."></textarea><div class="textarea-controls"><div class="btn btn-small" data-action="clear">Clear</div><div class="btn btn-small btn-secondary" data-action="validate-expression">Validate</div></div></div>
                </div>
            </div>
        </div>`;

    conditionsContainer.appendChild(conditionElement);
    setupConditionEventListeners(conditionElement);
    updateConditionSequence(regionId);
}

function setupConditionEventListeners(conditionElement) {
    const regionId = conditionElement.closest('.filter-region').id;
    setupEditableTitle(conditionElement.querySelector('.editable-title'), 'condition', conditionElement.closest('.filter-region'));
    
    conditionElement.querySelector('.condition-header').addEventListener('click', (e) => {
        if(e.target.closest('.control-group') || e.target.closest('.editable-title')) return;
        conditionElement.classList.toggle('condition-collapsed');
    });
    
    conditionElement.querySelector('.condition-remove').addEventListener('click', () => {
        if (confirm('Are you sure you want to delete this condition?')) {
            conditionElement.remove();
            updateConditionSequence(regionId);
        }
    });
    conditionElement.querySelectorAll('.condition-move').forEach(button => {
        button.addEventListener('click', () => moveCondition(conditionElement, button.dataset.direction));
    });
    conditionElement.querySelectorAll('.field-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', (e) => {
            const fieldContent = e.target.closest('.field-container').querySelector('.field-content');
            if (fieldContent) fieldContent.classList.toggle('hidden', !e.target.checked);
        });
    });
    const calculationSection = conditionElement.querySelector('.calculation-section');
    if (!calculationSection) return;
    const expressionTextarea = calculationSection.querySelector('.expression-textarea');
    const attributeSelect = calculationSection.querySelector('.attribute-select');
    const operatorSelect = calculationSection.querySelector('.expression-operator');
    const functionSelect = calculationSection.querySelector('.function-select');
    
    calculationSection.querySelector('[data-action="clear"]').addEventListener('click', () => {
        expressionTextarea.value = '';
        expressionTextarea.focus();
    });

    calculationSection.querySelector('[data-action="validate-expression"]').addEventListener('click', () => {
        const {isValid, errors} = validateSingleExpression(expressionTextarea);
        expressionTextarea.classList.remove('valid-expression', 'invalid-expression');
        if(isValid) {
            expressionTextarea.classList.add('valid-expression');
            setTimeout(() => expressionTextarea.classList.remove('valid-expression'), 2000);
        } else {
            expressionTextarea.classList.add('invalid-expression');
            alert(`Expression Error:\n- ${errors.join('\n- ')}`);
        }
    });

    expressionTextarea.addEventListener('input', (e) => {
        const text = e.target.value;
        const cursorPos = e.target.selectionStart;
        const lastChar = text.substring(cursorPos - 1, cursorPos);
        if (lastChar === '#') showAutocomplete(e.target, staticData.attributes, { type: 'attribute' });
        else if (lastChar === '=') showAutocomplete(e.target, staticData.functions, { type: 'function' });
        else hideAutocomplete();
    });
    expressionTextarea.addEventListener('keydown', (e) => {
        if (autocompleteContainer.style.display !== 'block') return;
        const items = autocompleteContainer.querySelectorAll('.autocomplete-item');
        if (!items.length) return;
        switch (e.key) {
            case 'ArrowDown': e.preventDefault(); activeAutocompleteIndex = (activeAutocompleteIndex + 1) % items.length; setActiveAutocompleteItem(activeAutocompleteIndex); break;
            case 'ArrowUp': e.preventDefault(); activeAutocompleteIndex = (activeAutocompleteIndex - 1 + items.length) % items.length; setActiveAutocompleteItem(activeAutocompleteIndex); break;
            case 'Enter': e.preventDefault(); if (activeAutocompleteIndex > -1) items[activeAutocompleteIndex].click(); hideAutocomplete(); break;
            case 'Escape': hideAutocomplete(); break;
        }
    });
    attributeSelect.addEventListener('change', (e) => {
        if (e.target.value) {
            insertAtCursor(expressionTextarea, `#${e.target.value}# `);
            e.target.value = '';
        }
    });
    operatorSelect.addEventListener('change', (e) => {
        if (e.target.value) {
            insertAtCursor(expressionTextarea, ` ${e.target.value} `);
            e.target.value = '';
        }
    });
    functionSelect.addEventListener('change', (e) => {
        if (e.target.value) {
            const funcText = `${e.target.value}() `;
            insertAtCursor(expressionTextarea, funcText);
            const newCursorPos = expressionTextarea.selectionStart - 2;
            expressionTextarea.setSelectionRange(newCursorPos, newCursorPos);
            e.target.value = '';
        }
    });
}

function setupRegionEventListeners(regionElement) {
    const regionId = regionElement.id;
    setupEditableTitle(regionElement.querySelector('.editable-title'), 'region');
    regionElement.querySelector('.region-header').addEventListener('click', e => {
        if (e.target.closest('.control-group') || e.target.closest('.validate-btn') || e.target.closest('.editable-title')) return;
        regionElement.classList.toggle('region-collapsed');
    });
    regionElement.querySelector('.delete-region').addEventListener('click', () => {
        if (confirm('Are you sure you want to delete this entire filter region?')) {
            regionElement.remove();
            updateRegionSequence();
        }
    });
    regionElement.querySelectorAll('.region-move').forEach(button => {
        button.addEventListener('click', () => moveRegion(regionElement, button.dataset.direction));
    });
    regionElement.querySelector(`#${regionId}-add-condition`).addEventListener('click', () => addCondition(regionId));
    
    regionElement.querySelectorAll('.section:first-child .field-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', (e) => {
            const fieldContent = e.target.closest('.field-container').querySelector('.field-content');
            if (fieldContent) fieldContent.classList.toggle('hidden', !e.target.checked);
        });
    });
    const leadTimeSelect = regionElement.querySelector('.load-time-select');
    if (leadTimeSelect) {
        leadTimeSelect.addEventListener('change', (e) => {
            const selectedValue = e.target.value;
            const inputsContainer = e.target.nextElementSibling;
            inputsContainer.innerHTML = '';
            if (selectedValue === 'date_range') {
                inputsContainer.innerHTML = `<label>From</label><input type="date" class="lead-time-from"><label>To</label><input type="date" class="lead-time-to">`;
            } else if (['days', 'weeks', 'months'].includes(selectedValue)) {
                const label = selectedValue.charAt(0).toUpperCase() + selectedValue.slice(1);
                inputsContainer.innerHTML = `<label>Number of ${label}</label><input type="number" class="lead-time-value" min="1">`;
            }
        });
    }
}

// --- UTILITY FUNCTIONS ---
function setupEditableTitle(titleContainer, scope, scopeElement = document) {
    const display = titleContainer.querySelector('.title-display');
    const input = titleContainer.querySelector('.title-input');
    display.addEventListener('click', () => {
        display.classList.add('hidden');
        input.classList.remove('hidden');
        input.focus();
        input.select();
    });
    const saveChanges = () => {
        const newName = input.value.trim();
        const oldName = display.textContent;
        if (newName === '' || newName === oldName) {
            input.value = oldName;
            input.classList.add('hidden');
            display.classList.remove('hidden');
            return;
        }
        let isDuplicate = false;
        const selector = scope === 'region' ? '.filter-region .title-display' : '.condition-group .title-display';
        const elementsToCheck = scope === 'region' ? document.querySelectorAll(selector) : scopeElement.querySelectorAll(selector);
        elementsToCheck.forEach(el => {
            if (el !== display && el.textContent.trim().toLowerCase() === newName.toLowerCase()) {
                isDuplicate = true;
            }
        });
        if (isDuplicate) {
            alert(`Error: The name "${newName}" is already in use. Please choose a unique name.`);
            input.focus();
            input.select();
            return;
        }
        display.textContent = newName;
        input.classList.add('hidden');
        display.classList.remove('hidden');
    };
    input.addEventListener('blur', saveChanges);
    input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            saveChanges();
        } else if (e.key === 'Escape') {
            input.value = display.textContent;
            input.classList.add('hidden');
            display.classList.remove('hidden');
        }
    });
}

function updateRegionSequence() {
    document.querySelectorAll('.filter-region').forEach((region, index) => {
        const sequence = index + 1;
        region.dataset.sequence = sequence;
        region.querySelector('.region-sequence').textContent = `${sequence}. `;
        const display = region.querySelector('.title-display');
        const input = region.querySelector('.title-input');
        if (display.textContent.match(/^Filter Region \d+$/)) {
            const newName = `Filter Region ${sequence}`;
            display.textContent = newName;
            input.value = newName;
        }
        region.querySelector('.region-move.up').disabled = (sequence === 1);
        region.querySelector('.region-move.down').disabled = (sequence === document.querySelectorAll('.filter-region').length);
    });
}

function moveRegion(regionElement, direction) {
    const parent = regionElement.parentNode;
    if (direction === 'up' && regionElement.previousElementSibling) {
        parent.insertBefore(regionElement, regionElement.previousElementSibling);
    } else if (direction === 'down' && regionElement.nextElementSibling) {
        parent.insertBefore(regionElement.nextElementSibling, regionElement);
    }
    updateRegionSequence();
}

function updateConditionSequence(regionId) {
    const container = document.getElementById(`${regionId}-conditions-container`);
    if (!container) return;
    const conditions = container.querySelectorAll('.condition-group');
    conditions.forEach((condition, index) => {
        const sequence = index + 1;
        condition.dataset.sequence = sequence;
        condition.querySelector('.condition-sequence').textContent = `${sequence}. `;
        const display = condition.querySelector('.title-display');
        const input = condition.querySelector('.title-input');
        if (display.textContent.match(/^Condition \d+$/)) {
            const newName = `Condition ${sequence}`;
            display.textContent = newName;
            input.value = newName;
        }
        condition.querySelector('.condition-move.up').disabled = (sequence === 1);
        condition.querySelector('.condition-move.down').disabled = (sequence === conditions.length);
    });
}

function moveCondition(conditionElement, direction) {
    const parent = conditionElement.parentNode;
    if (direction === 'up' && conditionElement.previousElementSibling) {
        parent.insertBefore(conditionElement, conditionElement.previousElementSibling);
    } else if (direction === 'down' && conditionElement.nextElementSibling) {
        parent.insertBefore(conditionElement.nextElementSibling, conditionElement);
    }
    updateConditionSequence(parent.id.replace('-conditions-container', ''));
}

// --- VALIDATION & DATA FUNCTIONS ---
function validateSingleExpression(expressionTextarea) {
    const errors = [];
    const expression = expressionTextarea.value.trim();
    if(expression === '') {
        errors.push('Expression cannot be empty.');
    } else {
        let tempExpression = expression;
        const attributeTokens = tempExpression.match(/#[^#]+#/g) || [];
        for (const token of attributeTokens) {
            if (!staticData.attributes.includes(token.slice(1, -1))) errors.push(`Invalid attribute: "${token}"`);
        }
        tempExpression = tempExpression.replace(/#[^#]+#/g, '1');
        staticData.functions.forEach(func => {
            const funcRegex = new RegExp(`${func}\\([^)]*\\)`, 'gi');
            tempExpression = tempExpression.replace(funcRegex, '1');
        });
        if (staticData.operators.some(op => tempExpression.includes(` ${op} `))) {
             errors.push('Expression must result in a numerical value, not a boolean.');
        }
        const validKeywords = [...staticData.expressionOperators, ...staticData.functions].map(t => t.toLowerCase());
        const remainingTokens = tempExpression.split(/[\s()]+/).filter(Boolean);
        for (const token of remainingTokens) {
            if (!isNaN(parseFloat(token))) continue;
            if (!validKeywords.includes(token.toLowerCase())) {
                errors.push(`Invalid keyword: "${token}"`);
            }
        }
    }
    return { isValid: errors.length === 0, errors };
}

function validateRegion(regionElement) {
    const errors = [];
    const regionId = regionElement.id;
    const regionName = regionElement.querySelector('.title-display').textContent.trim();
    regionElement.classList.remove('invalid-region');
    regionElement.querySelectorAll('.invalid-field').forEach(el => el.classList.remove('invalid-field'));

    const signatures = [];
    const filterContainer = regionElement.querySelector('.section:first-child');
    const checkedFilters = filterContainer.querySelectorAll('.field-checkbox:checked');
    const individualFilterSignatures = [];

    checkedFilters.forEach(checkbox => {
        const fc = checkbox.closest('.field-container');
        const validationType = checkbox.dataset.validates;
        let signaturePart = null;
        if(validationType === 'daysOfWeek') {
            const checkedDays = Array.from(fc.querySelectorAll('.day-checkbox:checked')).map(cb => cb.id.split('-').pop()).sort();
            if (checkedDays.length > 0) signaturePart = `daysOfWeek:${checkedDays.join(',')}`;
            else errors.push(`${regionName}: "Day of Week" is enabled but no days are selected.`);
        } else {
            const inputs = Array.from(fc.querySelectorAll('input:not([type=checkbox]), select'));
            if (inputs.some(i => !i.value)) {
                errors.push(`${regionName}: A value is missing for the "${fc.querySelector('label').textContent.trim()}" filter.`);
            } else {
                signaturePart = `${validationType}:${inputs.map(i => i.value).join(':')}`;
            }
        }
        if (signaturePart) individualFilterSignatures.push(signaturePart);
        else fc.classList.add('invalid-field');
    });

    const leadTimeCheckbox = filterContainer.querySelector(`#${regionId}-load-time`);
    const leadTimeSelect = filterContainer.querySelector('.load-time-select');
    const stayWindowCheckbox = filterContainer.querySelector(`#${regionId}-stay-window`);
    if (leadTimeCheckbox?.checked && leadTimeSelect?.value && leadTimeSelect.value !== 'date_range' && !stayWindowCheckbox?.checked) {
        errors.push(`${regionName}: Stay Window is required when using a relative Lead Time (Days, Weeks, Months).`);
        leadTimeCheckbox.closest('.field-container').classList.add('invalid-field');
        stayWindowCheckbox.closest('.field-container').classList.add('invalid-field');
    }

    if (checkedFilters.length > 0) {
        signatures.push({ signature: individualFilterSignatures.sort().join('|'), element: filterContainer, type: 'filter' });
    } else {
        signatures.push({ signature: 'filters:empty', element: filterContainer, type: 'filter' });
    }
    
    const conditions = regionElement.querySelectorAll('.condition-group');
    conditions.forEach(cond => {
        const condTitle = cond.querySelector('.title-display').textContent.trim();
        const isActive = !!cond.querySelector('.field-checkbox:checked');
        const expression = cond.querySelector('.expression-textarea').value.trim();
        if (!isActive && expression === '') {
            signatures.push({ signature: 'condition:empty', element: cond, type: 'condition' });
            return; 
        }
        if (isActive && expression === '') {
            errors.push(`${condTitle}: Expression cannot be empty when a condition field is checked.`);
            cond.querySelector('.expression-container').classList.add('invalid-field');
        } else if (expression !== '') {
            const { isValid, errors: expErrors } = validateSingleExpression(cond.querySelector('.expression-textarea'));
            if (!isValid) {
                errors.push(`${condTitle} Expression Error: ${expErrors.join(', ')}.`);
                cond.querySelector('.expression-container').classList.add('invalid-field');
            }
        }
        cond.querySelectorAll('.condition-fields .field-checkbox:checked').forEach(checkbox => {
            const fc = checkbox.closest('.field-container');
            let signature = null;
            const inputs = Array.from(fc.querySelectorAll('input:not([type=checkbox]), select'));
            if (inputs.some(i => !i.value)) {
                 errors.push(`${condTitle}: A value for "${fc.querySelector('label').textContent.trim()}" is missing.`);
                 fc.classList.add('invalid-field');
            } else {
                 signature = `${checkbox.dataset.validates}:${inputs.map(i => i.value).join(':')}`;
                 signatures.push({ signature, element: fc, type: 'condition' });
            }
        });
    });
    
    const signatureCounts = signatures.reduce((acc, { signature }) => {
        acc[signature] = (acc[signature] || 0) + 1;
        return acc;
    }, {});
    const duplicateSignatures = Object.keys(signatureCounts).filter(sig => signatureCounts[sig] > 1);
    if (duplicateSignatures.length > 0) {
        errors.push('Duplicate filters or conditions found within this region.');
        signatures.forEach(({ signature, element }) => {
            if (duplicateSignatures.includes(signature)) element.classList.add('invalid-field');
        });
    }

    return { isValid: errors.length === 0, errors: [...new Set(errors)], signatures };
}

function getRegionData(regionElement) {
    const data = {
        id: regionElement.id,
        name: regionElement.querySelector('.title-display').textContent.trim(),
        sequence: parseInt(regionElement.dataset.sequence, 10),
        filters: {},
        conditions: []
    };
    const regionId = regionElement.id;
    const filtersSection = regionElement.querySelector('.section:first-child');
    if (filtersSection) {
        if (filtersSection.querySelector(`#${regionId}-stay-window`)?.checked) data.filters.stayWindow = { from: filtersSection.querySelector('.stay-window-from')?.value, to: filtersSection.querySelector('.stay-window-to')?.value };
        if (filtersSection.querySelector(`#${regionId}-load-time`)?.checked) {
            const leadTimeSelect = filtersSection.querySelector('.load-time-select');
            const type = leadTimeSelect.value;
            if (type === 'date_range') data.filters.leadTime = { type, from: filtersSection.querySelector('.lead-time-from')?.value, to: filtersSection.querySelector('.lead-time-to')?.value };
            else if (type) data.filters.leadTime = { type, value: parseInt(filtersSection.querySelector('.lead-time-value')?.value, 10) };
        }
        if (filtersSection.querySelector(`#${regionId}-days-of-week`)?.checked) {
            const dayMap = { sun: 1, mon: 2, tue: 3, wed: 4, thu: 5, fri: 6, sat: 7 };
            data.filters.daysOfWeek = Array.from(filtersSection.querySelectorAll('.day-checkbox:checked')).map(cb => dayMap[cb.id.split('-').pop()]).sort((a, b) => a - b);
        }
        if (filtersSection.querySelector(`#${regionId}-minimum-rate`)?.checked) data.filters.minimumRate = parseFloat(filtersSection.querySelector('.minimum-rate-input')?.value);
    }
    regionElement.querySelectorAll('.condition-group').forEach(cond => {
        const isActive = !!cond.querySelector('.field-checkbox:checked') || cond.querySelector('.expression-textarea').value.trim() !== '';
        if (!isActive) return;

        const conditionData = {
            id: cond.id,
            name: cond.querySelector('.title-display').textContent.trim(),
            sequence: parseInt(cond.dataset.sequence, 10)
        };
        
        if (cond.querySelector(`#${cond.id}-occupancy-threshold`)?.checked) conditionData.occupancyThreshold = { operator: cond.querySelector('.occupancy-operator').value, value: parseFloat(cond.querySelector('.occupancy-value').value) };
        if (cond.querySelector(`#${cond.id}-property-ranking`)?.checked) {
            const val = cond.querySelector('.property-value').value;
            conditionData.propertyRanking = { type: cond.querySelector('.property-type').value, operator: cond.querySelector('.property-operator').value, value: isNaN(parseInt(val, 10)) ? val : parseInt(val, 10) };
        }
        if (cond.querySelector(`#${cond.id}-event-score`)?.checked) conditionData.eventScore = { operator: cond.querySelector('.event-operator').value, value: parseFloat(cond.querySelector('.event-value').value) };
        
        const expression = cond.querySelector('.expression-textarea').value.trim();
        if (expression) conditionData.expression = expression;
        
        data.conditions.push(conditionData);
    });
    return data;
}

function validateAllRegions() {
    let allValid = true;
    document.querySelectorAll('.filter-region').forEach(region => {
        const { isValid, errors } = validateRegion(region);
        const messageDiv = region.querySelector('.validation-messages');
        messageDiv.style.display = 'none'; // Clear previous messages
        if (!isValid) {
            allValid = false;
            messageDiv.innerHTML = `<ul>${errors.map(e => `<li>${e}</li>`).join('')}</ul>`;
            messageDiv.style.display = 'block';
        }
    });

    if (allValid) {
        alert('All regions are valid!');
    } else {
        alert('Please fix the errors in the highlighted regions.');
    }
    return allValid;
}

function saveAllRegions() {
    const regions = document.querySelectorAll('.filter-region');
    let allValid = true;
   // const allData = { regions: [], timestamp: new Date().toISOString() };
    const allData = { regions: [] };
    const allSignatures = [];

    regions.forEach(region => {
        const { isValid, errors, signatures } = validateRegion(region);
        const messageDiv = region.querySelector('.validation-messages');
        messageDiv.style.display = 'none';
        if (!isValid) {
            allValid = false;
            messageDiv.innerHTML = `<ul>${errors.map(e => `<li>${e}</li>`).join('')}</ul>`;
            messageDiv.style.display = 'block';
        }
        allSignatures.push(...signatures.map(s => ({ ...s, region })));
    });

    const filterSignatures = allSignatures.filter(s => s.type === 'filter');
    const signatureCounts = filterSignatures.reduce((acc, { signature }) => {
        acc[signature] = (acc[signature] || 0) + 1;
        return acc;
    }, {});
    const duplicateSignatures = Object.keys(signatureCounts).filter(sig => signatureCounts[sig] > 1);

    if (duplicateSignatures.length > 0) {
        allValid = false;
        const errorRegions = new Set();
        filterSignatures.forEach(({ signature, element, region }) => {
            if (duplicateSignatures.includes(signature)) {
                region.classList.add('invalid-region');
                errorRegions.add(region);
            }
        });
        errorRegions.forEach(region => {
            const messageDiv = region.querySelector('.validation-messages');
            const newError = '<li>Error: This entire set of filters is a duplicate of another region.</li>';
            if (!messageDiv.innerHTML.includes(newError)) {
                 messageDiv.innerHTML = (messageDiv.innerHTML || '<ul></ul>').slice(0, -5) + newError + '</ul>';
            }
            messageDiv.style.display = 'block';
        });
    }

    if (allValid) {
        regions.forEach(region => allData.regions.push(getRegionData(region)));
        document.getElementById('jsonOutput').textContent = 'All regions data:\n' + JSON.stringify(allData, null, 2);
        const algo_list = document.getElementById('P1050_ALGO_LIST');
        apex.server.process(
                'AJX_MANAGE_ALGO',
                { x01: 'INSERT'
                  ,x02: algo_list.options[algo_list.selectedIndex].value 
                  ,x03: JSON.stringify(allData, null, 2) 
                  },
                {
                    success: function(data) { 
                        console.log('algo_list:>>',algo_list.options[algo_list.selectedIndex].value);
                        console.log('-->>',JSON.stringify(allData, null, 2));
                            showSuccessMessage( ` From Package:>  ${ data[0].l_message } `);  
                        
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('AJAX Error::>>>'+ errorThrown );
                    }
                }
            );

        alert('All regions are valid and have been saved!');
    } else {
        alert('Please fix the errors in the highlighted regions before saving.');
    }
}
function showSuccessMessage(message) {
    apex.message.showPageSuccess(message);
}

function insertAtCursor(textarea, text) {
    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    textarea.value = textarea.value.substring(0, start) + text + textarea.value.substring(end);
    textarea.selectionStart = textarea.selectionEnd = start + text.length;
    textarea.focus();
}
