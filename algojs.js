const staticData = {
    operators: ['=', '!=', '>', '<', '>=', '<=', 'Contains', 'Starts with'],
    attributes: ['Occupancy', 'ADR', 'RevPAR', 'Booking Pace', 'Market Share'],
    propertyTypes: ['Hotel', 'Motel', 'Resort', 'Apartment', 'Vacation Rental'],
    functions: ['Average', 'Sum', 'Count', 'Max', 'Min', 'Standard Deviation']
};

let regionCounter = 0;
// conditionCounter is now mainly for unique ID generation, sequence is derived from position
let conditionCounter = 0;

document.addEventListener('DOMContentLoaded', function() {
    addFilterRegion();

    document.getElementById('addRegionBtn').addEventListener('click', function() {
        addFilterRegion();
    });

    document.getElementById('saveAllBtn').addEventListener('click', function() {
        saveAllRegions();
    });

    document.getElementById('toggleAllBtn').addEventListener('click', function() {
        toggleAllRegions();
    });
});


// Function to create a new filter region (MODIFIED)
function addFilterRegion() {
    regionCounter++;
    const regionId = `region-${regionCounter}`;

    const filterContainer = document.getElementById('filterContainer');

    const regionElement = document.createElement('div');
    regionElement.className = 'filter-region';
    regionElement.id = regionId;

    // Set default dates (today and 7 days from today)
    const today = new Date();
    const nextWeek = new Date();
    nextWeek.setDate(today.getDate() + 7);

    const formatDate = (date) => {
        return date.toISOString().split('T')[0];
    };

    regionElement.innerHTML = `
        <div class="region-header">
            <div class="region-title">
                <span class="toggle-icon">▼</span>
                Filter Region ${regionCounter}
            </div>
            <div class="region-controls">
                <div class="btn btn-secondary validate-btn">Validate</div>
                <div class="btn btn-danger delete-region">Delete</div>
            </div>
        </div>

        <div class="region-content">
            <div class="sections-container">
                <div class="section">
                    <div class="section-title">1. Filters</div>

                    <div class="field-container">
                        <input type="checkbox" class="field-checkbox" id="${regionId}-stay-window">
                        <label for="${regionId}-stay-window">Stay Window</label>
                        <div class="field-content hidden">
                            <label>From</label>
                            <input type="date" class="stay-window-from" value="${formatDate(today)}">
                            <label>To</label>
                            <input type="date" class="stay-window-to" value="${formatDate(nextWeek)}">
                        </div>
                    </div>

                    <div class="field-container">
                        <input type="checkbox" class="field-checkbox" id="${regionId}-load-time">
                        <label for="${regionId}-load-time">Lead Time</label>
                        <div class="field-content hidden">
                            <select class="load-time-select">
                                <option value="">Select Type</option>
                                <option value="date_range">Date Range</option>
                                <option value="days">Day(s)</option>
                                <option value="weeks">Week(s)</option>
                                <option value="months">Month(s)</option>
                            </select>
                            <div class="lead-time-inputs"></div>
                        </div>
                    </div>

                    <div class="field-container">
                        <input type="checkbox" class="field-checkbox" id="${regionId}-days-of-week">
                        <label for="${regionId}-days-of-week">Day of Week</label>
                        <div class="field-content hidden">
                            <div class="checkbox-group">
                                <div class="checkbox-item">
                                    <input type="checkbox" id="${regionId}-sun" class="day-checkbox" >
                                    <label for="${regionId}-sun">SUN</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" id="${regionId}-mon" class="day-checkbox" >
                                    <label for="${regionId}-mon">MON</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" id="${regionId}-tue" class="day-checkbox" >
                                    <label for="${regionId}-tue">TUE</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" id="${regionId}-wed" class="day-checkbox" >
                                    <label for="${regionId}-wed">WED</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" id="${regionId}-thu" class="day-checkbox" >
                                    <label for="${regionId}-thu">THU</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" id="${regionId}-fri" class="day-checkbox" >
                                    <label for="${regionId}-fri">FRI</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" id="${regionId}-sat" class="day-checkbox" >
                                    <label for="${regionId}-sat">SAT</label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="field-container">
                        <input type="checkbox" class="field-checkbox" id="${regionId}-minimum-rate">
                        <label for="${regionId}-minimum-rate">Minimum Rate</label>
                        <div class="field-content hidden">
                            <input type="number" value="4" min="0" class="minimum-rate-input">
                        </div>
                    </div>
                </div>

                <div class="section">
                    <div class="section-header">
                        <div class="section-title">2. Conditions & Expressions</div>
                        <div class="btn btn-small" id="${regionId}-add-condition">+ Add Condition</div>
                    </div>

                    <div class="conditions-container" id="${regionId}-conditions-container">
                    </div>
                </div>
            </div>

            <div class="footer">
                <div class="btn btn-secondary save-region">Save Region</div>
            </div>
        </div>
    `;

    filterContainer.appendChild(regionElement);

    // Add event listeners for the region
    setupRegionEventListeners(regionElement, regionId);

    // Add initial condition
    addCondition(regionId);
}
// -------------------------------------------------------------------------
// Function to add a new condition to a region (Unchanged)
function addCondition(regionId) {
    conditionCounter++;
    const conditionId = `condition-${regionId}-${conditionCounter}`;
    const conditionsContainer = document.getElementById(`${regionId}-conditions-container`);

    const conditionElement = document.createElement('div');
    conditionElement.className = 'condition-group';
    conditionElement.id = conditionId;

    conditionElement.innerHTML = `
        <div class="condition-header">
            <div class="condition-title">Condition X</div> <div class="condition-controls">
                <button class="condition-move up" data-direction="up" title="Move Up">▲</button>
                <button class="condition-move down" data-direction="down" title="Move Down">▼</button>
                <button class="condition-remove" data-condition="${conditionId}" title="Remove Condition">×</button>
            </div>
        </div>

        <div class="field-container">
            <input type="checkbox" class="field-checkbox" id="${conditionId}-occupancy-threshold">
            <label for="${conditionId}-occupancy-threshold">Occupancy Threshold %</label>
            <div class="field-content hidden">
                <select class="operator-select occupancy-operator">
                    ${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}
                </select>
                <input type="number" class="value-input occupancy-value" value="80" min="0" max="100">
            </div>
        </div>

        <div class="field-container">
            <input type="checkbox" class="field-checkbox" id="${conditionId}-property-ranking">
            <label for="${conditionId}-property-ranking">Property Ranking (Comp. Set)</label>
            <div class="field-content hidden">
                <select class="property-type-select property-type">
                    <option value="">Select Type</option>
                    ${staticData.propertyTypes.map(type => `<option value="${type}">${type}</option>`).join('')}
                </select>
                <select class="operator-select property-operator">
                    ${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}
                </select>
                <input type="text" class="value-input property-value" placeholder="Value">
            </div>
        </div>

        <div class="field-container">
            <input type="checkbox" class="field-checkbox" id="${conditionId}-event-score">
            <label for="${conditionId}-event-score">Event Score</label>
            <div class="field-content hidden">
                <select class="operator-select event-operator">
                    ${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}
                </select>
                <input type="number" class="value-input event-value" value="0" min="0">
            </div>
        </div>

        <div class="section calculation-section">
            <div class="section-title">3. Expression/Calculation</div>

            <div class="filter-row">
                <div class="filter-group">
                    <label>Attributes</label>
                    <select class="attribute-select">
                        <option value="">Select Attribute</option>
                        ${staticData.attributes.map(attr => `<option value="${attr}">${attr}</option>`).join('')}
                    </select>
                    <select class="operator-select expression-operator">
                        ${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}
                    </select>
                    <select class="function-select">
                        <option value="">Select Function</option>
                        ${staticData.functions.map(func => `<option value="${func}">${func}</option>`).join('')}
                    </select>
                </div>
            </div>

            <div class="expression-container">
                <label class="expression-label">Expression</label>
                <div class="expression-controls">
                    <div class="expression-btn" data-action="clear">Clear</div>
                    <div class="expression-btn" data-action="append-attribute">Add Attribute</div>
                    <div class="expression-btn" data-action="append-operator">Add Operator</div>
                    <div class="expression-btn" data-action="append-function">Add Function</div>
                </div>
                <textarea class="expression-textarea" placeholder="Write your expression here or use the buttons above to add elements"></textarea>
            </div>
        </div>
    `;

    conditionsContainer.appendChild(conditionElement);

    // Set up event listeners for the condition
    setupConditionEventListeners(conditionElement);
    // Update sequence after adding a new condition
    updateConditionSequence(conditionsContainer.closest('.filter-region').id);
}
// -------------------------------------------------------------------------
/**
 * Updates the sequence number displayed in the condition titles and disables
 * move buttons for first/last elements. (Unchanged)
 * @param {string} regionId The ID of the parent filter region.
 */
function updateConditionSequence(regionId) {
    const container = document.getElementById(`${regionId}-conditions-container`);
    if (!container) return;

    const conditions = container.querySelectorAll('.condition-group');
    const total = conditions.length;

    conditions.forEach((condition, index) => {
        const sequence = index + 1;
        const titleElement = condition.querySelector('.condition-title');
        const upBtn = condition.querySelector('.condition-move.up');
        const downBtn = condition.querySelector('.condition-move.down');

        if (titleElement) {
            titleElement.textContent = `Condition ${sequence}`;
        }

        // Disable UP button for the first element
        if (upBtn) {
            upBtn.disabled = sequence === 1;
        }

        // Disable DOWN button for the last element
        if (downBtn) {
            downBtn.disabled = sequence === total;
        }

        // Store sequence on the element for easy data retrieval
        condition.dataset.sequence = sequence;
    });
}

/**
 * Moves a condition up or down in the DOM. (Unchanged)
 * @param {HTMLElement} conditionElement The condition to move.
 * @param {string} direction 'up' or 'down'.
 */
function moveCondition(conditionElement, direction) {
    const parent = conditionElement.parentNode;
    if (!parent) return;

    const conditions = Array.from(parent.querySelectorAll('.condition-group'));
    const currentIndex = conditions.indexOf(conditionElement);

    if (direction === 'up' && currentIndex > 0) {
        parent.insertBefore(conditionElement, conditions[currentIndex - 1]);
    } else if (direction === 'down' && currentIndex < conditions.length - 1) {
        // To move down, insert after the next sibling.
        // We use insertBefore on the element *after* the target position.
        parent.insertBefore(conditionElement, conditions[currentIndex + 2] || null);
    }

    // Re-sequence all conditions in this region after the move
    const regionId = conditionElement.closest('.filter-region').id;
    updateConditionSequence(regionId);
}
// -------------------------------------------------------------------------
// Function to set up event listeners for a single condition (Unchanged)
function setupConditionEventListeners(conditionElement) {
    const regionId = conditionElement.closest('.filter-region').id;

    // Remove button logic
    conditionElement.querySelector('.condition-remove').addEventListener('click', function() {
        conditionElement.remove();
        updateConditionSequence(regionId); // Update sequence after deletion
        updateJsonOutput();
    });

    // Move buttons logic
    conditionElement.querySelectorAll('.condition-move').forEach(button => {
        button.addEventListener('click', function() {
            moveCondition(conditionElement, this.dataset.direction);
        });
    });

    // Show/hide fields based on condition checkbox state
    const checkboxes = conditionElement.querySelectorAll('.field-checkbox');
    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const fieldContainer = this.closest('.field-container');
            const fieldContent = fieldContainer.querySelector('.field-content');

            if (this.checked) {
                fieldContainer.classList.add('enabled');
                fieldContent.classList.remove('hidden');
            } else {
                fieldContainer.classList.remove('enabled');
                fieldContent.classList.add('hidden');
            }
        });
    });

    // Expression area functionality - TARGETING ELEMENTS WITHIN THIS CONDITION
    const calculationSection = conditionElement.querySelector('.calculation-section');
    const expressionTextarea = calculationSection.querySelector('.expression-textarea');
    const attributeSelect = calculationSection.querySelector('.attribute-select');
    const operatorSelect = calculationSection.querySelector('.expression-operator');
    const functionSelect = calculationSection.querySelector('.function-select');

    // Expression control buttons
    const clearBtn = calculationSection.querySelector('.expression-btn[data-action="clear"]');
    const appendAttrBtn = calculationSection.querySelector('.expression-btn[data-action="append-attribute"]');
    const appendOpBtn = calculationSection.querySelector('.expression-btn[data-action="append-operator"]');
    const appendFuncBtn = calculationSection.querySelector('.expression-btn[data-action="append-function"]');

    // Clear expression
    clearBtn.addEventListener('click', function() {
        expressionTextarea.value = '';
        expressionTextarea.focus();
    });

    // Append attribute at cursor position
    appendAttrBtn.addEventListener('click', function() {
        if (attributeSelect.value) {
            insertAtCursor(expressionTextarea, attributeSelect.value);
        }
    });

    // Append operator at cursor position
    appendOpBtn.addEventListener('click', function() {
        if (operatorSelect.value) {
            insertAtCursor(expressionTextarea, ` ${operatorSelect.value} `);
        }
    });

    // Append function at cursor position
    appendFuncBtn.addEventListener('click', function() {
        if (functionSelect.value) {
            insertAtCursor(expressionTextarea, `${functionSelect.value}()`);
            // Move cursor inside parentheses
            const pos = expressionTextarea.selectionStart - 1;
            expressionTextarea.setSelectionRange(pos, pos);
            expressionTextarea.focus();
        }
    });

    // Auto-fill expression when dropdowns change (only if expression is empty)
    const updateExpression = () => {
        const attribute = attributeSelect.value;
        const operator = operatorSelect.value;
        const func = functionSelect.value;

        // Only auto-fill if expression is empty
        if (!expressionTextarea.value.trim()) {
            if (attribute && operator && func) {
                expressionTextarea.value = `${func}(${attribute}) ${operator} value`;
            } else if (attribute && operator) {
                expressionTextarea.value = `${attribute} ${operator} value`;
            } else if (attribute) {
                expressionTextarea.value = `${attribute} = value`;
            }
        }
    };

    attributeSelect.addEventListener('change', updateExpression);
    operatorSelect.addEventListener('change', updateExpression);
    functionSelect.addEventListener('change', updateExpression);
}
// -------------------------------------------------------------------------


// Function to insert text at cursor position in a textarea (Unchanged)
function insertAtCursor(textarea, text) {
    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    const before = textarea.value.substring(0, start);
    const after = textarea.value.substring(end, textarea.value.length);

    textarea.value = before + text + after;
    textarea.selectionStart = textarea.selectionEnd = start + text.length;
    textarea.focus();
}

// Function to set up event listeners for a region (MODIFIED)
function setupRegionEventListeners(regionElement, regionId) {
    // Toggle collapse/expand
    regionElement.querySelector('.region-header').addEventListener('click', function(e) {
        // Don't toggle if clicking on buttons inside the header
        if (e.target.closest('.btn')) return;

        regionElement.classList.toggle('region-collapsed');
    });

    // Delete region
    regionElement.querySelector('.delete-region').addEventListener('click', function() {
        regionElement.remove();
        updateRegionTitles();
        updateJsonOutput();
    });

    // Validate region
    regionElement.querySelector('.validate-btn').addEventListener('click', function() {
        const regionData = getRegionData(regionElement, regionId);
        document.getElementById('jsonOutput').textContent =
            `Validation for ${regionId}:\n` + JSON.stringify(regionData, null, 2);
    });

    // Save region
    regionElement.querySelector('.save-region').addEventListener('click', function() {
        const regionData = getRegionData(regionElement, regionId);
        document.getElementById('jsonOutput').textContent =
            `Saved data for ${regionId}:\n` + JSON.stringify(regionData, null, 2);
    });

    // Add condition button
    regionElement.querySelector(`#${regionId}-add-condition`).addEventListener('click', function() {
        addCondition(regionId);
    });

    // Show/hide fields based on checkbox state in main section
    const mainCheckboxes = regionElement.querySelectorAll('.section:nth-child(1) .field-checkbox');
    mainCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const fieldContainer = this.closest('.field-container');
            const fieldContent = fieldContainer.querySelector('.field-content');

            if (this.checked) {
                fieldContainer.classList.add('enabled');
                if (fieldContent) fieldContent.classList.remove('hidden');
            } else {
                fieldContainer.classList.remove('enabled');
                if (fieldContent) fieldContent.classList.add('hidden');
            }
        });
    });

    // --- NEW LOGIC FOR DYNAMIC LEAD TIME INPUTS ---
    const leadTimeSelect = regionElement.querySelector('.load-time-select');
    if (leadTimeSelect) {
        leadTimeSelect.addEventListener('change', function() {
            const selectedValue = this.value;
            // The container is the next sibling element of the dropdown
            const inputsContainer = this.nextElementSibling;

            // Clear any previous inputs
            inputsContainer.innerHTML = '';

            if (selectedValue === 'date_range') {
                inputsContainer.innerHTML = `
                    <label>From</label>
                    <input type="date" class="lead-time-from">
                    <label>To</label>
                    <input type="date" class="lead-time-to">
                `;
            } else if (['days', 'weeks', 'months'].includes(selectedValue)) {
                // Capitalize the first letter of the selected value for the label
                const label = selectedValue.charAt(0).toUpperCase() + selectedValue.slice(1);
                inputsContainer.innerHTML = `
                    <label for="${regionId}-lead-time-value">Number of ${label}</label>
                    <input type="number" id="${regionId}-lead-time-value" class="lead-time-value" min="1" placeholder="e.g., 7">
                `;
            }
        });
    }
}
// -------------------------------------------------------------------------

/**
 * Function to get data from a region.
 * MODIFIED: To handle dynamic 'Lead Time' inputs and new JSON structure.
 * @param {HTMLElement} regionElement The filter region DOM element.
 * @param {string} regionId The ID of the region.
 * @returns {Object} The region data object.
 */
function getRegionData(regionElement, regionId) {
    const data = {
        id: regionId,
        filters: {},
        conditions: [],
    };

    // --- Get Filters data (MODIFIED HERE) ---
    const filtersSection = regionElement.querySelector('.sections-container .section:nth-child(1)');
    if (filtersSection) {
        // Stay Window
        const stayWindowCheckbox = filtersSection.querySelector(`#${regionId}-stay-window`);
        if (stayWindowCheckbox && stayWindowCheckbox.checked) {
            const fieldContainer = stayWindowCheckbox.closest('.field-container');
            const fromInput = fieldContainer.querySelector('.stay-window-from');
            const toInput = fieldContainer.querySelector('.stay-window-to');

            if (fromInput && toInput) {
                data.filters.stayWindow = {
                    from: fromInput.value,
                    to: toInput.value
                };
            }
        }

        // Load Time
        const loadTimeCheckbox = filtersSection.querySelector(`#${regionId}-load-time`);
        if (loadTimeCheckbox && loadTimeCheckbox.checked) {
            const fieldContainer = loadTimeCheckbox.closest('.field-container');
            const loadTimeSelect = fieldContainer.querySelector('.load-time-select');

            if (loadTimeSelect && loadTimeSelect.value) {
                const type = loadTimeSelect.value;
                const inputsContainer = fieldContainer.querySelector('.lead-time-inputs');

                if (type === 'date_range') {
                    const fromInput = inputsContainer.querySelector('.lead-time-from');
                    const toInput = inputsContainer.querySelector('.lead-time-to');
                    if (fromInput && toInput && fromInput.value && toInput.value) {
                        data.filters.loadTime = {
                            type: type,
                            from: fromInput.value,
                            to: toInput.value
                        };
                    }
                } else if (['days', 'weeks', 'months'].includes(type)) {
                    const valueInput = inputsContainer.querySelector('.lead-time-value');
                    if (valueInput && valueInput.value) {
                        data.filters.loadTime = {
                            type: type,
                            value: valueInput.value
                        };
                    }
                }
            }
        }

        // Days of Week
        const daysCheckbox = filtersSection.querySelector(`#${regionId}-days-of-week`);
        if (daysCheckbox && daysCheckbox.checked) {
            const fieldContainer = daysCheckbox.closest('.field-container');
            const dayCheckboxes = fieldContainer.querySelectorAll('.day-checkbox');

            data.filters.daysOfWeek = [];
            dayCheckboxes.forEach(checkbox => {
                if (checkbox.checked) {
                    const dayName = checkbox.id.split('-').pop();
                    data.filters.daysOfWeek.push(dayName.toUpperCase());
                }
            });
            if (data.filters.daysOfWeek.length === 0) {
                delete data.filters.daysOfWeek;
            }
        }

        // Minimum Rate
        const minRateCheckbox = filtersSection.querySelector(`#${regionId}-minimum-rate`);
        if (minRateCheckbox && minRateCheckbox.checked) {
            const fieldContainer = minRateCheckbox.closest('.field-container');
            const minRateInput = fieldContainer.querySelector('.minimum-rate-input');

            if (minRateInput) {
                data.filters.minimumRate = minRateInput.value;
            }
        }
    }

    // --- Get Conditions and nested Expressions data (Unchanged from your version) ---
    const conditionsSection = regionElement.querySelector('.sections-container .section:nth-child(2)');
    if (conditionsSection) {
        const conditionGroups = conditionsSection.querySelectorAll('.condition-group');

        conditionGroups.forEach((conditionGroup) => {
            const sequence = parseInt(conditionGroup.dataset.sequence, 10);

            const conditionData = {
                id: conditionGroup.id,
                sequence: isNaN(sequence) ? 0 : sequence,
                occupancyThreshold: null,
                propertyRanking: null,
                eventScore: null,
                calculation: {},
                expression: '',
            };

            let isConditionActive = false;

            // 1. Occupancy Threshold
            const occupancyCheckbox = conditionGroup.querySelector('.field-container:nth-child(2) .field-checkbox');
            if (occupancyCheckbox && occupancyCheckbox.checked) {
                const operator = conditionGroup.querySelector('.field-container:nth-child(2) .occupancy-operator');
                const value = conditionGroup.querySelector('.field-container:nth-child(2) .occupancy-value');
                if (operator && value) {
                    conditionData.occupancyThreshold = { operator: operator.value, value: value.value };
                    isConditionActive = true;
                }
            }

            // 2. Property Ranking
            const propertyCheckbox = conditionGroup.querySelector('.field-container:nth-child(3) .field-checkbox');
            if (propertyCheckbox && propertyCheckbox.checked) {
                const type = conditionGroup.querySelector('.field-container:nth-child(3) .property-type');
                const operator = conditionGroup.querySelector('.field-container:nth-child(3) .property-operator');
                const value = conditionGroup.querySelector('.field-container:nth-child(3) .property-value');
                if (type && type.value && operator && value) {
                    conditionData.propertyRanking = { type: type.value, operator: operator.value, value: value.value };
                    isConditionActive = true;
                }
            }

            // 3. Event Score
            const eventCheckbox = conditionGroup.querySelector('.field-container:nth-child(4) .field-checkbox');
            if (eventCheckbox && eventCheckbox.checked) {
                const operator = conditionGroup.querySelector('.field-container:nth-child(4) .event-operator');
                const value = conditionGroup.querySelector('.field-container:nth-child(4) .event-value');
                if (operator && value) {
                    conditionData.eventScore = { operator: operator.value, value: value.value };
                    isConditionActive = true;
                }
            }

            // Clean up conditionData by removing null properties
            if (conditionData.occupancyThreshold === null) delete conditionData.occupancyThreshold;
            if (conditionData.propertyRanking === null) delete conditionData.propertyRanking;
            if (conditionData.eventScore === null) delete conditionData.eventScore;

            // 4. Calculation and 5. Expression
            const calculationSection = conditionGroup.querySelector('.calculation-section');
            if (calculationSection) {
                const attributeSelect = calculationSection.querySelector('.attribute-select');
                const operatorSelect = calculationSection.querySelector('.expression-operator');
                const functionSelect = calculationSection.querySelector('.function-select');
                const expressionTextarea = calculationSection.querySelector('.expression-textarea');

                if (attributeSelect && attributeSelect.value) {
                    conditionData.calculation.attribute = attributeSelect.value;
                    if (operatorSelect) conditionData.calculation.operator = operatorSelect.value;
                    if (functionSelect) conditionData.calculation.function = functionSelect.value;
                    isConditionActive = true;
                } else {
                    delete conditionData.calculation;
                }

                if (expressionTextarea) {
                    conditionData.expression = expressionTextarea.value.trim();
                    if (conditionData.expression) {
                        isConditionActive = true;
                    }
                }
            } else {
                delete conditionData.calculation;
            }

            if (isConditionActive) {
                data.conditions.push(conditionData);
            }
        });
    }

    return data;
}
// -------------------------------------------------------------------------

// Function to save all regions (Unchanged)
function saveAllRegions() {
    const regions = document.querySelectorAll('.filter-region');
    const allData = {
        regions: [],
        timestamp: new Date().toISOString()
    };

    regions.forEach(region => {
        const regionId = region.id;
        const regionData = getRegionData(region, regionId);
        allData.regions.push(regionData);
    });

    document.getElementById('jsonOutput').textContent =
        'All regions data:\n' + JSON.stringify(allData, null, 2);
}

// Function to toggle all regions (Unchanged)
function toggleAllRegions() {
    const regions = document.querySelectorAll('.filter-region');
    const toggleBtn = document.getElementById('toggleAllBtn');
    const allCollapsed = regions[0] && regions[0].classList.contains('region-collapsed');

    regions.forEach(region => {
        if (allCollapsed) {
            region.classList.remove('region-collapsed');
        } else {
            region.classList.add('region-collapsed');
        }
    });

    toggleBtn.textContent = allCollapsed ? 'Collapse All' : 'Expand All';
}

// Function to update region titles after deletion (Unchanged)
function updateRegionTitles() {
    const regions = document.querySelectorAll('.filter-region');
    regions.forEach((region, index) => {
        const titleElement = region.querySelector('.region-title');
        if (titleElement) {
            const toggleIcon = titleElement.querySelector('.toggle-icon');
            // Ensure the icon is preserved before updating text content
            const iconHTML = toggleIcon ? toggleIcon.outerHTML : '<span class="toggle-icon">▼</span>';
            titleElement.innerHTML = `${iconHTML} Filter Region ${index + 1}`;
        }
    });
}


// Placeholder for updateJsonOutput (Unchanged)
function updateJsonOutput() {
    // Optionally update the overall JSON display
    // e.g., document.getElementById('jsonOutput').textContent = '...';
}
