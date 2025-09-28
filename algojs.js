const staticData = {
    operators: ['=', '!=', '>', '<', '>=', '<=', 'Contains', 'Starts with'],
    attributes: ['Occupancy', 'ADR', 'RevPAR', 'Booking Pace', 'Market Share'],
    propertyTypes: ['Hotel', 'Motel', 'Resort', 'Apartment', 'Vacation Rental'],
    functions: ['Average', 'Sum', 'Count', 'Max', 'Min', 'Standard Deviation']
};

let regionCounter = 0;
let conditionCounter = 0;

document.addEventListener('DOMContentLoaded', function() {
    addFilterRegion();

    document.getElementById('addRegionBtn').addEventListener('click', addFilterRegion);
    document.getElementById('saveAllBtn').addEventListener('click', saveAllRegions);
    document.getElementById('toggleAllBtn').addEventListener('click', toggleAllRegions);
});


// Function to create a new filter region
function addFilterRegion() {
    regionCounter++;
    const regionId = `region-${regionCounter}`;
    const filterContainer = document.getElementById('filterContainer');
    const regionElement = document.createElement('div');
    regionElement.className = 'filter-region';
    regionElement.id = regionId;

    const today = new Date();
    const nextWeek = new Date();
    nextWeek.setDate(today.getDate() + 7);
    const formatDate = (date) => date.toISOString().split('T')[0];

    regionElement.innerHTML = `
        <div class="region-header">
            <div class="region-title"><span class="toggle-icon">▼</span> Filter Region ${regionCounter}</div>
            <div class="region-controls">
                <div class="btn btn-secondary validate-btn">Validate</div>
                <div class="btn btn-danger delete-region">Delete</div>
            </div>
        </div>
        <div class="validation-messages" style="display: none; color: #d9534f; background-color: #fbecec; border: 1px solid; border-radius: 4px; padding: 10px; margin: 0 10px 10px 10px;"></div>
        <div class="region-content">
            <div class="section">
                <div class="section-title">1. Filters</div>
                <div class="field-container">
                    <input type="checkbox" class="field-checkbox" id="${regionId}-stay-window" data-validates="stayWindow">
                    <label for="${regionId}-stay-window">Stay Window</label>
                    <div class="field-content hidden">
                        <label>From</label> <input type="date" class="stay-window-from" value="${formatDate(today)}">
                        <label>To</label> <input type="date" class="stay-window-to" value="${formatDate(nextWeek)}">
                    </div>
                </div>
                <div class="field-container">
                    <input type="checkbox" class="field-checkbox" id="${regionId}-load-time" data-validates="leadTime">
                    <label for="${regionId}-load-time">Lead Time</label>
                    <div class="field-content hidden">
                        <select class="load-time-select">
                            <option value="">Select Type</option><option value="date_range">Date Range</option><option value="days">Day(s)</option><option value="weeks">Week(s)</option><option value="months">Month(s)</option>
                        </select>
                        <div class="lead-time-inputs"></div>
                    </div>
                </div>
                <div class="field-container">
                    <input type="checkbox" class="field-checkbox" id="${regionId}-days-of-week">
                    <label for="${regionId}-days-of-week">Day of Week</label>
                    <div class="field-content hidden">
                        <div class="checkbox-group">
                            ${['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'].map(day => `
                            <div class="checkbox-item">
                                <input type="checkbox" id="${regionId}-${day}" class="day-checkbox"><label for="${regionId}-${day}">${day.toUpperCase()}</label>
                            </div>`).join('')}
                        </div>
                    </div>
                </div>
                <div class="field-container">
                    <input type="checkbox" class="field-checkbox" id="${regionId}-minimum-rate" data-validates="minimumRate">
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
                <div class="conditions-container" id="${regionId}-conditions-container"></div>
            </div>
            <div class="footer">
                <div class="btn btn-secondary save-region">Save Region</div>
            </div>
        </div>`;

    filterContainer.appendChild(regionElement);
    setupRegionEventListeners(regionElement, regionId);
    addCondition(regionId);
}

// Function to add a new condition to a region
function addCondition(regionId) {
    conditionCounter++;
    const conditionId = `condition-${regionId}-${conditionCounter}`;
    const conditionsContainer = document.getElementById(`${regionId}-conditions-container`);
    const conditionElement = document.createElement('div');
    conditionElement.className = 'condition-group';
    conditionElement.id = conditionId;

    conditionElement.innerHTML = `
        <div class="condition-header">
            <div class="condition-title">Condition X</div>
            <div class="condition-controls">
                <button class="condition-move up" data-direction="up" title="Move Up">▲</button>
                <button class="condition-move down" data-direction="down" title="Move Down">▼</button>
                <button class="condition-remove" title="Remove Condition">×</button>
            </div>
        </div>
        <div class="condition-body" style="display: flex; align-items: flex-start; gap: 20px;">
            <div class="condition-fields" style="flex: 1;">
                <div class="field-container">
                    <input type="checkbox" class="field-checkbox" id="${conditionId}-occupancy-threshold" data-validates="occupancyThreshold">
                    <label for="${conditionId}-occupancy-threshold">Occupancy Threshold %</label>
                    <div class="field-content hidden">
                        <select class="operator-select occupancy-operator">${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}</select>
                        <input type="number" class="value-input occupancy-value" value="80" min="0" max="100">
                    </div>
                </div>
                <div class="field-container">
                    <input type="checkbox" class="field-checkbox" id="${conditionId}-property-ranking" data-validates="propertyRanking">
                    <label for="${conditionId}-property-ranking">Property Ranking (Comp. Set)</label>
                    <div class="field-content hidden">
                        <select class="property-type-select property-type"><option value="">Select Type</option>${staticData.propertyTypes.map(type => `<option value="${type}">${type}</option>`).join('')}</select>
                        <select class="operator-select property-operator">${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}</select>
                        <input type="text" class="value-input property-value" placeholder="Value">
                    </div>
                </div>
                <div class="field-container">
                    <input type="checkbox" class="field-checkbox" id="${conditionId}-event-score" data-validates="eventScore">
                    <label for="${conditionId}-event-score">Event Score</label>
                    <div class="field-content hidden">
                        <select class="operator-select event-operator">${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}</select>
                        <input type="number" class="value-input event-value" value="0" min="0">
                    </div>
                </div>
            </div>
            <div class="condition-expression" style="flex: 1.5;">
                 <div class="section calculation-section">
                    <div class="section-title">3. Expression/Calculation</div>
                    <div class="filter-row">
                        <div class="filter-group">
                            <select class="attribute-select"><option value="">Select Attribute</option>${staticData.attributes.map(attr => `<option value="${attr}">${attr}</option>`).join('')}</select>
                            <select class="operator-select expression-operator"><option value="">Select Operator</option>${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}</select>
                            <select class="function-select"><option value="">Select Function</option>${staticData.functions.map(func => `<option value="${func}">${func}</option>`).join('')}</select>
                        </div>
                    </div>
                    <div class="expression-container">
                        <label class="expression-label">Expression</label>
                        <textarea class="expression-textarea" placeholder="Build your expression..."></textarea>
                        <div class="textarea-controls">
                            <div class="expression-btn" data-action="clear" style="display: inline-block; width: auto;">Clear</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>`;

    conditionsContainer.appendChild(conditionElement);
    setupConditionEventListeners(conditionElement);
    updateConditionSequence(conditionsContainer.closest('.filter-region').id);
}

// Function to set up event listeners for a single condition (MODIFIED)
function setupConditionEventListeners(conditionElement) {
    const regionId = conditionElement.closest('.filter-region').id;

    conditionElement.querySelector('.condition-remove').addEventListener('click', () => {
        conditionElement.remove();
        updateConditionSequence(regionId);
    });

    conditionElement.querySelectorAll('.condition-move').forEach(button => {
        button.addEventListener('click', (e) => moveCondition(conditionElement, e.target.dataset.direction));
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

    attributeSelect.addEventListener('change', (e) => {
        if (e.target.value) {
            // Add # delimiters around the attribute
            insertAtCursor(expressionTextarea, `#${e.target.value}#`);
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
            const funcText = `${e.target.value}()`;
            insertAtCursor(expressionTextarea, funcText);
            const newCursorPos = expressionTextarea.selectionStart - 1;
            expressionTextarea.setSelectionRange(newCursorPos, newCursorPos);
            e.target.value = '';
        }
    });
}

// Function to set up event listeners for a region
function setupRegionEventListeners(regionElement, regionId) {
    regionElement.querySelector('.region-header').addEventListener('click', e => {
        if (e.target.closest('.btn')) return;
        regionElement.classList.toggle('region-collapsed');
    });

    regionElement.querySelector('.delete-region').addEventListener('click', () => {
        regionElement.remove();
        updateRegionTitles();
    });

    regionElement.querySelector(`#${regionId}-add-condition`).addEventListener('click', () => addCondition(regionId));

    regionElement.querySelector('.validate-btn').addEventListener('click', () => {
        const { isValid, errors } = validateRegion(regionElement);
        const messageDiv = regionElement.querySelector('.validation-messages');
        if (isValid) {
            messageDiv.style.display = 'none';
            alert('Validation successful!');
        } else {
            messageDiv.innerHTML = `<ul>${errors.map(e => `<li>${e}</li>`).join('')}</ul>`;
            messageDiv.style.display = 'block';
        }
    });

    regionElement.querySelector('.save-region').addEventListener('click', () => {
        const { isValid, errors } = validateRegion(regionElement);
        const messageDiv = regionElement.querySelector('.validation-messages');
        if (isValid) {
            messageDiv.style.display = 'none';
            const regionData = getRegionData(regionElement, regionId);
            document.getElementById('jsonOutput').textContent = `Saved data for ${regionId}:\n` + JSON.stringify(regionData, null, 2);
            alert('Region saved successfully!');
        } else {
            messageDiv.innerHTML = `<ul>${errors.map(e => `<li>${e}</li>`).join('')}</ul>`;
            messageDiv.style.display = 'block';
        }
    });

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

// --- VALIDATION FUNCTION (MODIFIED) ---
function validateRegion(regionElement) {
    const errors = [];
    const regionName = regionElement.querySelector('.region-title').textContent.trim();

    regionElement.classList.remove('invalid-region');
    regionElement.querySelectorAll('.invalid-field').forEach(el => el.classList.remove('invalid-field'));

    regionElement.querySelectorAll('.section:first-child .field-container').forEach(fc => {
        const checkbox = fc.querySelector('.field-checkbox');
        if (!checkbox || !checkbox.checked) return;
        const validationType = checkbox.dataset.validates;
        if (validationType === 'stayWindow' && (!fc.querySelector('.stay-window-from')?.value || !fc.querySelector('.stay-window-to')?.value)) {
            errors.push(`${regionName}: "Stay Window" is enabled but dates are missing.`);
            fc.classList.add('invalid-field');
        } else if (validationType === 'leadTime') {
            const select = fc.querySelector('.load-time-select');
            if (!select.value) {
                errors.push(`${regionName}: "Lead Time" is enabled but no type is selected.`);
                fc.classList.add('invalid-field');
            } else if (select.value === 'date_range' && (!fc.querySelector('.lead-time-from')?.value || !fc.querySelector('.lead-time-to')?.value)) {
                errors.push(`${regionName}: "Lead Time" date range is missing values.`);
                fc.classList.add('invalid-field');
            } else if (['days', 'weeks', 'months'].includes(select.value) && !fc.querySelector('.lead-time-value')?.value) {
                errors.push(`${regionName}: "Lead Time" number of ${select.value} is missing.`);
                fc.classList.add('invalid-field');
            }
        } else if (validationType === 'minimumRate' && !fc.querySelector('.minimum-rate-input')?.value) {
            errors.push(`${regionName}: "Minimum Rate" is enabled but the rate is missing.`);
            fc.classList.add('invalid-field');
        }
    });

    const conditions = regionElement.querySelectorAll('.condition-group');
    let hasConditionWithoutExpression = false;
    conditions.forEach(cond => {
        const condTitle = cond.querySelector('.condition-title').textContent.trim();
        cond.querySelectorAll('.condition-fields .field-container').forEach(fc => {
            const checkbox = fc.querySelector('.field-checkbox');
            if (!checkbox || !checkbox.checked) return;
            const validationType = checkbox.dataset.validates;
            if (validationType === 'occupancyThreshold' && !fc.querySelector('.occupancy-value')?.value) {
                errors.push(`${condTitle}: "Occupancy Threshold" is enabled but value is missing.`);
                fc.classList.add('invalid-field');
            } else if (validationType === 'propertyRanking' && (!fc.querySelector('.property-type')?.value || !fc.querySelector('.property-value')?.value)) {
                errors.push(`${condTitle}: "Property Ranking" is enabled but type or value is missing.`);
                fc.classList.add('invalid-field');
            } else if (validationType === 'eventScore' && !fc.querySelector('.event-value')?.value) {
                errors.push(`${condTitle}: "Event Score" is enabled but value is missing.`);
                fc.classList.add('invalid-field');
            }
        });

        const expressionTextarea = cond.querySelector('.expression-textarea');
        const expression = expressionTextarea.value.trim();
        if (expression === '') {
            hasConditionWithoutExpression = true;
        } else {
            let tempExpression = expression;
            const errorsForThisExpression = [];
            const attributeTokens = tempExpression.match(/#[^#]+#/g) || [];
            for (const token of attributeTokens) {
                const attributeName = token.slice(1, -1);
                if (!staticData.attributes.includes(attributeName)) {
                    errorsForThisExpression.push(`Invalid attribute: "${token}"`);
                }
            }
            tempExpression = tempExpression.replace(/#[^#]+#/g, ' ');
            const validNonAttrTokens = [...staticData.operators, ...staticData.functions].map(t => t.toLowerCase());
            const remainingTokens = tempExpression.split(/[\s()]+/).filter(Boolean);
            for (const token of remainingTokens) {
                if (!isNaN(parseFloat(token))) continue;
                if (!validNonAttrTokens.includes(token.toLowerCase())) {
                    errorsForThisExpression.push(`Invalid keyword: "${token}"`);
                }
            }
            if (errorsForThisExpression.length > 0) {
                errors.push(`${condTitle} Expression Error: ${errorsForThisExpression.join(', ')}.`);
                expressionTextarea.closest('.expression-container').classList.add('invalid-field');
            }
        }
    });

    if (conditions.length > 0 && hasConditionWithoutExpression) {
        errors.push(`${regionName}: A condition is present but its expression is empty.`);
        regionElement.classList.add('invalid-region');
    }

    return { isValid: errors.length === 0, errors };
}


// --- UTILITY AND DATA GATHERING FUNCTIONS ---
function getRegionData(regionElement, regionId) {
    const data = { id: regionId, filters: {}, conditions: [] };
    const filtersSection = regionElement.querySelector('.section:first-child');
    if (filtersSection) {
        if (filtersSection.querySelector(`#${regionId}-stay-window`)?.checked) {
            data.filters.stayWindow = { from: filtersSection.querySelector('.stay-window-from')?.value, to: filtersSection.querySelector('.stay-window-to')?.value };
        }
        if (filtersSection.querySelector(`#${regionId}-load-time`)?.checked) {
            const leadTimeSelect = filtersSection.querySelector('.load-time-select');
            const type = leadTimeSelect.value;
            if (type === 'date_range') {
                data.filters.leadTime = { type, from: filtersSection.querySelector('.lead-time-from')?.value, to: filtersSection.querySelector('.lead-time-to')?.value };
            } else if (type) {
                data.filters.leadTime = { type, value: parseInt(filtersSection.querySelector('.lead-time-value')?.value, 10) };
            }
        }
        if (filtersSection.querySelector(`#${regionId}-days-of-week`)?.checked) {
            const dayMap = { sun: 1, mon: 2, tue: 3, wed: 4, thu: 5, fri: 6, sat: 7 };
            data.filters.daysOfWeek = Array.from(filtersSection.querySelectorAll('.day-checkbox:checked')).map(cb => dayMap[cb.id.split('-').pop()]).sort((a, b) => a - b);
        }
        if (filtersSection.querySelector(`#${regionId}-minimum-rate`)?.checked) {
            data.filters.minimumRate = parseFloat(filtersSection.querySelector('.minimum-rate-input')?.value);
        }
    }
    regionElement.querySelectorAll('.condition-group').forEach(cond => {
        const conditionData = { id: cond.id, sequence: parseInt(cond.dataset.sequence, 10) };
        let isActive = false;
        if (cond.querySelector(`#${cond.id}-occupancy-threshold`)?.checked) {
            conditionData.occupancyThreshold = { operator: cond.querySelector('.occupancy-operator').value, value: parseFloat(cond.querySelector('.occupancy-value').value) };
            isActive = true;
        }
        if (cond.querySelector(`#${cond.id}-property-ranking`)?.checked) {
            const val = cond.querySelector('.property-value').value;
            conditionData.propertyRanking = { type: cond.querySelector('.property-type').value, operator: cond.querySelector('.property-operator').value, value: isNaN(parseInt(val, 10)) ? val : parseInt(val, 10) };
            isActive = true;
        }
        if (cond.querySelector(`#${cond.id}-event-score`)?.checked) {
            conditionData.eventScore = { operator: cond.querySelector('.event-operator').value, value: parseFloat(cond.querySelector('.event-value').value) };
            isActive = true;
        }
        const expression = cond.querySelector('.expression-textarea').value.trim();
        if (expression) {
            conditionData.expression = expression;
            isActive = true;
        }
        if (isActive) data.conditions.push(conditionData);
    });
    return data;
}

function saveAllRegions() {
    const regions = document.querySelectorAll('.filter-region');
    let allValid = true;
    const allData = { regions: [], timestamp: new Date().toISOString() };

    regions.forEach(region => {
        const { isValid, errors } = validateRegion(region);
        const messageDiv = region.querySelector('.validation-messages');
        if (!isValid) {
            allValid = false;
            messageDiv.innerHTML = `<ul>${errors.map(e => `<li>${e}</li>`).join('')}</ul>`;
            messageDiv.style.display = 'block';
        } else {
            messageDiv.style.display = 'none';
            allData.regions.push(getRegionData(region, region.id));
        }
    });

    if (allValid) {
        document.getElementById('jsonOutput').textContent = 'All regions data:\n' + JSON.stringify(allData, null, 2);
        alert('All regions are valid and have been saved!');
    } else {
        alert('Please fix the errors in the highlighted regions before saving.');
    }
}

function updateRegionTitles() {
    document.querySelectorAll('.filter-region').forEach((region, index) => {
        const titleElement = region.querySelector('.region-title');
        if (titleElement) {
            const iconHTML = titleElement.querySelector('.toggle-icon')?.outerHTML || '';
            titleElement.innerHTML = `${iconHTML} Filter Region ${index + 1}`;
        }
    });
}

function updateConditionSequence(regionId) {
    const container = document.getElementById(`${regionId}-conditions-container`);
    if (!container) return;
    const conditions = container.querySelectorAll('.condition-group');
    conditions.forEach((condition, index) => {
        const sequence = index + 1;
        condition.querySelector('.condition-title').textContent = `Condition ${sequence}`;
        condition.dataset.sequence = sequence;
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

function insertAtCursor(textarea, text) {
    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    textarea.value = textarea.value.substring(0, start) + text + textarea.value.substring(end);
    textarea.selectionStart = textarea.selectionEnd = start + text.length;
    textarea.focus();
}

function toggleAllRegions() {
    const regions = document.querySelectorAll('.filter-region');
    const isAnyExpanded = Array.from(regions).some(r => !r.classList.contains('region-collapsed'));
    regions.forEach(region => region.classList.toggle('region-collapsed', isAnyExpanded));
    document.getElementById('toggleAllBtn').textContent = isAnyExpanded ? 'Expand All' : 'Collapse All';
}
