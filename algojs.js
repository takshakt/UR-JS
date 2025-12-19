const staticData = {
    operators: ['=', '!=', '>', '<', '>=', '<='],
    expressionOperators: ['+', '-', '/', '*'],
    functions: ['Average', 'Sum', 'Count', 'Max', 'Min']
};

let dynamicData = {
    attributes: [],
    propertyTypes: [],
    occupancyAttributes: []
};

let attributeMetadata = {
    templates: [],
    qualifiers: [],
    parsed: []
};

let regionCounter = 0;
let conditionCounter = 0;
let lovRequestCounter = 0;
let autocompleteContainer = null;
let activeAutocompleteIndex = -1;

let attributeModal = null;
let modalFilterState = {
    selectedTemplates: [],
    selectedQualifiers: [],
    searchText: ''
};

// Race condition protection for load_data_expression
let currentLoadRequest = null;      // Track current AJAX request for cancellation
let loadDebounceTimer = null;       // Debounce timer ID
let lastLoadedAlgoVersion = null;   // Track last successfully loaded algo+version
const LOAD_DEBOUNCE_MS = 200;       // Wait 200ms before making request

document.addEventListener('DOMContentLoaded', function() {
    autocompleteContainer = document.createElement('div');
    autocompleteContainer.id = 'expression-autocomplete';
    document.body.appendChild(autocompleteContainer);

    // Create attribute selection modal
    createAttributeModal();

    document.addEventListener('click', (e) => {
        if (!e.target.closest('.expression-textarea')) {
            hideAutocomplete();
        }
    });

    document.getElementById('addRegionBtn').addEventListener('click', addFilterRegion);
    document.getElementById('saveAllBtn').addEventListener('click', saveAllRegions);
    document.getElementById('validateAllBtn').addEventListener('click', validateAllRegions);
});

// --- APEX DATA LOADING FUNCTIONS ---
function load_data_expression() {
    const algoListVal = apex.item("P1050_ALGO_LIST").getValue();
    const versionVal = apex.item("P1050_VERSION").getValue();
    const hotelId = apex.item("P1050_HOTEL_LIST").getValue();

    console.log('load_data_expression called - Algo:', algoListVal, 'Version:', versionVal, 'Hotel:', hotelId);

    // Clear any pending debounced call
    if (loadDebounceTimer) {
        console.log('Clearing pending debounce timer');
        clearTimeout(loadDebounceTimer);
        loadDebounceTimer = null;
    }

    // Early exit for empty algo - no need to debounce
    if (!algoListVal) {
        loadFromJSON(null);
        return;
    }

    // Early exit if version is not yet selected (cascade still in progress)
    if (!versionVal) {
        console.log('Version not yet selected, waiting for cascade to complete');
        return;
    }

    // Skip if this exact algo+version is already loaded
    const currentKey = `${algoListVal}:${versionVal}`;
    if (lastLoadedAlgoVersion === currentKey) {
        console.log('Already loaded this algo+version, skipping duplicate request');
        return;
    }

    // Debounce: Wait for APEX cascading events to settle
    loadDebounceTimer = setTimeout(() => {
        executeLoadRequest(algoListVal, versionVal, hotelId);
    }, LOAD_DEBOUNCE_MS);
}

function executeLoadRequest(capturedAlgo, capturedVersion, capturedHotelId) {
    // Re-validate: Check if values changed during debounce period
    const currentAlgo = apex.item("P1050_ALGO_LIST").getValue();
    const currentVersion = apex.item("P1050_VERSION").getValue();
    const currentHotel = apex.item("P1050_HOTEL_LIST").getValue();

    if (currentAlgo !== capturedAlgo || currentVersion !== capturedVersion) {
        console.warn('RACE CONDITION DETECTED: Parameters changed during debounce.',
            'Captured:', capturedAlgo, capturedVersion,
            'Current:', currentAlgo, currentVersion);

        // CRITICAL FIX: Instead of just returning, re-trigger with current values
        // This ensures the final stable state gets loaded
        if (currentAlgo && currentVersion) {
            const currentKey = `${currentAlgo}:${currentVersion}`;
            if (lastLoadedAlgoVersion !== currentKey) {
                console.log('Re-scheduling load for current values:', currentAlgo, currentVersion);
                // Clear any existing timer first
                if (loadDebounceTimer) {
                    clearTimeout(loadDebounceTimer);
                }
                // Schedule new request with current values
                loadDebounceTimer = setTimeout(() => {
                    executeLoadRequest(currentAlgo, currentVersion, currentHotel);
                }, LOAD_DEBOUNCE_MS);
            } else {
                console.log('Current algo+version already loaded, no re-schedule needed');
            }
        }
        return;
    }

    // Abort any in-flight request
    if (currentLoadRequest && typeof currentLoadRequest.abort === 'function') {
        console.log('Aborting previous in-flight request');
        try {
            currentLoadRequest.abort();
        } catch (e) {
            console.warn('Failed to abort previous request:', e);
        }
        currentLoadRequest = null;
    }

    console.log('Executing load request - Algo:', capturedAlgo, 'Version:', capturedVersion);

    var lSpinner$ = apex.util.showSpinner();

    currentLoadRequest = apex.server.process(
        'AJX_MANAGE_ALGO',
        { x01: 'SELECT', x02: capturedAlgo, x03: capturedVersion },
        {
            success: function(data) {
                currentLoadRequest = null; // Clear request reference
                console.log('AJX_MANAGE_ALGO response:', data);

                // CRITICAL: Stale response check
                const nowAlgo = apex.item("P1050_ALGO_LIST").getValue();
                const nowVersion = apex.item("P1050_VERSION").getValue();

                if (nowAlgo !== capturedAlgo || nowVersion !== capturedVersion) {
                    console.warn('STALE RESPONSE IGNORED: UI has moved on.',
                        'Response for:', capturedAlgo, capturedVersion,
                        'Current UI:', nowAlgo, nowVersion);
                    lSpinner$.remove();
                    return;
                }

                // Check if server returned an error response
                if (data.success === false) {
                    console.error('Server error:', data.message);
                    apex.message.alert(data.message || "Failed to load configuration.");

                    // Reset dynamicData to prevent state pollution from failed loads
                    dynamicData = {
                        attributes: [],
                        propertyTypes: [],
                        occupancyAttributes: [],
                        leadTimeAttributes: []
                    };

                    loadFromJSON(null);
                    lSpinner$.remove();
                    return;
                }

                const savedJsonString = data && data.data && data.data[0] ? data.data[0].l_payload : null;
                let savedData = null;
                if (savedJsonString && savedJsonString.trim() !== '') {
                    try {
                        savedData = JSON.parse(savedJsonString);
                    } catch (e) {
                        console.error("Failed to parse JSON data:", e);
                        apex.message.alert("The selected configuration is invalid.");
                        lSpinner$.remove();
                        return;
                    }
                }

                // CRITICAL FIX: Ensure attributes are loaded BEFORE parsing expressions
                // This prevents race condition where strategies in expressions can't be resolved
                if (capturedHotelId && (!dynamicData.attributes || dynamicData.attributes.length === 0)) {
                    console.warn('dynamicData.attributes not loaded yet - fetching before loadFromJSON');

                    fetchAndApplyLovData(capturedHotelId).then(() => {
                        // Final stale check before loading
                        const finalAlgo = apex.item("P1050_ALGO_LIST").getValue();
                        if (finalAlgo !== capturedAlgo) {
                            console.warn('Selection changed during attribute fetch, aborting load');
                            lSpinner$.remove();
                            return;
                        }
                        console.log('Attributes loaded, now loading JSON with', dynamicData.attributes.length, 'attributes');
                        lastLoadedAlgoVersion = `${capturedAlgo}:${capturedVersion}`;
                        loadFromJSON(savedData);
                        lSpinner$.remove();
                    }).catch((error) => {
                        console.error('Failed to fetch attributes:', error);
                        apex.message.alert("Failed to load attribute data. Expression conversion may not work correctly.");
                        loadFromJSON(savedData);
                        lSpinner$.remove();
                    });
                } else {
                    console.log('dynamicData.attributes already loaded (', dynamicData.attributes ? dynamicData.attributes.length : 0, 'attributes), proceeding with loadFromJSON');
                    lastLoadedAlgoVersion = `${capturedAlgo}:${capturedVersion}`;
                    loadFromJSON(savedData);
                    lSpinner$.remove();
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                currentLoadRequest = null;

                // Ignore aborted requests (not an error)
                if (textStatus === 'abort') {
                    console.log('Request was aborted (expected during rapid selection changes)');
                    lSpinner$.remove();
                    return;
                }

                console.error('AJAX Error loading strategy:', errorThrown);
                apex.message.alert("An error occurred while fetching the configuration.");
                lSpinner$.remove();
            }
        }
    );
}

function fetchAndApplyLovData(hotelId) {
    // --- DIAGNOSTIC TRACE ---
    console.warn('fetchAndApplyLovData() was called. See trace below.');
    console.trace();
    // --- END TRACE ---

    // Reset loaded state when hotel changes (forces reload of strategy data)
    lastLoadedAlgoVersion = null;

    return new Promise((resolve, reject) => {
        if (!hotelId) {
            dynamicData = { attributes: [], propertyTypes: [], occupancyAttributes: [], leadTimeAttributes: [] };
            updateAllDropdowns();
            return resolve();
        }

        const spinner = apex.widget.waitPopup();

        apex.server.process('GET_LOV_DATA', { x01: hotelId }, {
            success: function(data) {
                spinner.remove();
                try {
                    const parsedData = (typeof data === 'string') ? JSON.parse(data) : data;
                    if (parsedData.error) {
                        console.error("Error from GET_LOV_DATA:", parsedData.error);
                        return reject(parsedData.error);
                    }
                    dynamicData = parsedData;

                    // Parse attribute metadata for templates and qualifiers
                    if (dynamicData.attributes && dynamicData.attributes.length > 0) {
                        attributeMetadata = parseAttributeMetadata(dynamicData.attributes);
                    }

                    updateAllDropdowns();
                    resolve();
                } catch (e) {
                    console.error("Failed to parse LoV data:", e);
                    reject(e);
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                spinner.remove();
                console.error("Failed to fetch LoV data:", textStatus, errorThrown);
                reject(errorThrown);
            },
            dataType: "json"
        });
    });
}

function updateAllDropdowns() {
    // --- DIAGNOSTIC TRACE ---
    console.warn('updateAllDropdowns() was called. See trace below. Check if dynamicData is empty.');
    // Log a copy of the data to see its state at this exact moment
    console.log('Current dynamicData:', JSON.parse(JSON.stringify(dynamicData)));
    console.trace();
    // --- END TRACE ---

    const populateSelect = (selectElement, dataArray, prompt) => {
        if (!selectElement) {
            console.error('populateSelect was called with a non-existent element.');
            return;
        }
        console.log('Inside populateSelect1 - %s',selectElement)

        const currentValue = selectElement.value;
        let valueExists = false;
        selectElement.innerHTML = '';
        const promptOption = document.createElement('option');
        promptOption.value = '';
        promptOption.textContent = prompt;
        selectElement.appendChild(promptOption);

        if (!dataArray || !Array.isArray(dataArray)) {
            return;
        }
        console.log('Inside populateSelect - %s',selectElement)
        dataArray.forEach(item => {
            const option = document.createElement('option');
            // option.value = item;
            // option.textContent = item;
            option.value = item.id;
            option.textContent = item.name;
            selectElement.appendChild(option);

            if (item.id === currentValue) {
                valueExists = true;
            }
        });

        if (valueExists) {
            selectElement.value = currentValue;
        }
    };

    // Note: .attribute-select dropdowns are intentionally left empty
    // They trigger the modal dialog instead of showing options directly

    document.querySelectorAll('.property-type-select').forEach(el => {
        populateSelect(el, dynamicData.propertyTypes, 'Choose Comp. Set');
    });

    // Handle property ranking availability - disable when no property types available
    if (dynamicData.propertyTypes && dynamicData.propertyTypes.length > 0) {
        document.querySelectorAll('[id$="-property-ranking"]').forEach(checkbox => {
            const fieldContainer = checkbox.closest('.field-container');
            if (!fieldContainer) return;

            // Enable checkbox and remove disabled styling
            checkbox.disabled = false;
            fieldContainer.classList.remove('disabled-field');

            // Remove "Unavailable" badge from label
            const label = fieldContainer.querySelector('label[for="' + checkbox.id + '"]');
            if (label) {
                const badge = label.querySelector('.unavailable-badge');
                if (badge) badge.remove();
            }
        });
    } else {
        // Disable and uncheck all property ranking checkboxes when propertyTypes is empty
        document.querySelectorAll('[id$="-property-ranking"]').forEach(checkbox => {
            if (checkbox.checked) {
                console.warn('Disabling property ranking condition - not available for selected hotel');
            }
            checkbox.checked = false;
            checkbox.disabled = true;

            const fieldContainer = checkbox.closest('.field-container');
            if (fieldContainer) {
                fieldContainer.classList.add('disabled-field');
            }

            // Add "Unavailable" badge if not present
            const label = fieldContainer ? fieldContainer.querySelector('label[for="' + checkbox.id + '"]') : null;
            if (label) {
                const existingBadge = label.querySelector('.unavailable-badge');
                if (!existingBadge) {
                    const badge = document.createElement('span');
                    badge.className = 'unavailable-badge';
                    badge.textContent = 'Unavailable';
                    label.appendChild(badge);
                }
            }
        });
    }

    // Handle occupancy attribute - inject/update content and manage availability state
    if (dynamicData.occupancyAttributes && dynamicData.occupancyAttributes.length > 0) {
        const occupancyAttr = dynamicData.occupancyAttributes[0];

        document.querySelectorAll('[id$="-occupancy-threshold"]').forEach(checkbox => {
            const fieldContainer = checkbox.closest('.field-container');
            if (!fieldContainer) return;

            // Enable checkbox and remove disabled styling
            checkbox.disabled = false;
            fieldContainer.classList.remove('disabled-field');

            // Remove "Unavailable" badge from label
            const label = fieldContainer.querySelector('label[for="' + checkbox.id + '"]');
            if (label) {
                const badge = label.querySelector('.unavailable-badge');
                if (badge) badge.remove();
            }

            // Inject or update field-content
            const fieldContent = fieldContainer.querySelector('.field-content');
            if (!fieldContent) return;

            const hasContent = fieldContent.querySelector('.occupancy-attribute-id');

            if (!hasContent) {
                // INJECT: Empty field-content (legacy conditions created before data loaded)
                fieldContent.innerHTML = generateOccupancyFieldContent(true);
            } else {
                // UPDATE: Existing structure with new values
                const attrIdInput = fieldContent.querySelector('.occupancy-attribute-id');

                if (attrIdInput) attrIdInput.value = occupancyAttr.id;
            }
        });
    } else {
        // Disable and uncheck all occupancy checkboxes when array is empty
        document.querySelectorAll('[id$="-occupancy-threshold"]').forEach(checkbox => {
            if (checkbox.checked) {
                console.warn('Disabling occupancy threshold condition - not available for selected hotel');
            }
            checkbox.checked = false;
            checkbox.disabled = true;

            const fieldContainer = checkbox.closest('.field-container');
            if (fieldContainer) {
                fieldContainer.classList.add('disabled-field');
            }

            // Add "Unavailable" badge if not present
            const label = fieldContainer ? fieldContainer.querySelector('label[for="' + checkbox.id + '"]') : null;
            if (label) {
                const existingBadge = label.querySelector('.unavailable-badge');
                if (!existingBadge) {
                    const badge = document.createElement('span');
                    badge.className = 'unavailable-badge';
                    badge.textContent = 'Unavailable';
                    label.appendChild(badge);
                }
            }
        });
    }

    // Handle price override attribute - inject/update content and manage availability state
    const priceOverrideAttr = getPriceOverrideAttribute();
    if (priceOverrideAttr) {
        document.querySelectorAll('[id$="-price-override"]').forEach(checkbox => {
            const fieldContainer = checkbox.closest('.field-container');
            if (!fieldContainer) return;

            // Enable checkbox and remove disabled styling
            checkbox.disabled = false;
            fieldContainer.classList.remove('disabled-field');

            // Remove "Unavailable" badge from label
            const label = fieldContainer.querySelector('label[for="' + checkbox.id + '"]');
            if (label) {
                const badge = label.querySelector('.unavailable-badge');
                if (badge) badge.remove();
            }

            // Inject or update field-content
            const fieldContent = fieldContainer.querySelector('.field-content');
            if (!fieldContent) return;

            const hasContent = fieldContent.querySelector('.price-override-attribute-id');

            if (!hasContent) {
                // INJECT: Empty field-content (legacy regions created before data loaded)
                fieldContent.innerHTML = generatePriceOverrideFieldContent(true);
            } else {
                // UPDATE: Set the hardcoded attribute ID
                const hiddenInput = fieldContent.querySelector('.price-override-attribute-id');

                if (hiddenInput) {
                    hiddenInput.value = priceOverrideAttr.id;
                }
            }
        });
    } else {
        // Disable all price override checkboxes when array is empty
        document.querySelectorAll('[id$="-price-override"]').forEach(checkbox => {
            if (checkbox.checked) {
                console.warn('Disabling price override - not available for selected hotel');
            }
            checkbox.checked = false;
            checkbox.disabled = true;

            const fieldContainer = checkbox.closest('.field-container');
            if (fieldContainer) {
                fieldContainer.classList.add('disabled-field');
            }

            // Add "Unavailable" badge if not present
            const label = fieldContainer ? fieldContainer.querySelector('label[for="' + checkbox.id + '"]') : null;
            if (label) {
                const existingBadge = label.querySelector('.unavailable-badge');
                if (!existingBadge) {
                    const badge = document.createElement('span');
                    badge.className = 'unavailable-badge';
                    badge.textContent = 'Unavailable';
                    label.appendChild(badge);
                }
            }
        });
    }

}

/**
 * Generates HTML content for occupancy threshold field-content div.
 * Used both for initial creation and dynamic injection.
 * @param {boolean} hasData - Whether occupancy data is available
 * @returns {string} HTML string for field-content
 */
function generateOccupancyFieldContent(hasData = false) {
    if (!hasData) {
        return `
            <input type="hidden" class="occupancy-attribute-id" value="">
            <select class="operator-select occupancy-operator">
                ${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}
            </select>
            <input type="number" class="value-input occupancy-value" value="80" min="0" max="100">
        `;
    }

    const occupancyAttr = dynamicData.occupancyAttributes[0];
    return `
        <input type="hidden" class="occupancy-attribute-id" value="${occupancyAttr.id}">
        <select class="operator-select occupancy-operator">
            ${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}
        </select>
        <input type="number" class="value-input occupancy-value" value="80" min="0" max="100">
    `;
}

/**
 * Gets the PRICE_OVERRIDE_PUBLIC attribute if it exists
 * @returns {Object|null} The price override attribute or null if not found
 */
function getPriceOverrideAttribute() {
    if (!dynamicData.attributes || dynamicData.attributes.length === 0) {
        return null;
    }

    return dynamicData.attributes.find(attr => {
        // Parse qualifier from name format: "Name (Template||Qualifier)"
        const match = attr.name.match(/\((.+?)\|\|(.+?)\)$/);
        if (match) {
            const qualifier = match[2].trim();
            return qualifier === 'PRICE_OVERRIDE_PUBLIC';
        }
        return false;
    });
}

/**
 * Generates HTML content for price override field-content div.
 * Hardcoded to use PRICE_OVERRIDE_PUBLIC qualifier - no user selection needed.
 * @param {boolean} hasData - Whether price override attribute is available
 * @returns {string} HTML string for field-content
 */
function generatePriceOverrideFieldContent(hasData = false) {
    const priceOverrideAttr = getPriceOverrideAttribute();

    if (!hasData || !priceOverrideAttr) {
        return `<input type="hidden" class="price-override-attribute-id" value="">`;
    }

    return `<input type="hidden" class="price-override-attribute-id" value="${priceOverrideAttr.id}">`;
}

/**
 * Parses attribute names to extract Templates and Qualifiers.
 * Expected format: "Attribute Name (Template||Qualifier)"
 * @param {Array} attributes - Array of attribute objects with {id, name}
 * @returns {Object} Object with templates, qualifiers, and parsed attributes
 */
function parseAttributeMetadata(attributes) {
    const templates = new Set();
    const qualifiers = new Set();
    const parsed = [];

    // Regex to match: "Attribute Name (Template||Qualifier)"
    const regex = /^(.+?)\s*\((.+?)\|\|(.+?)\)$/;

    attributes.forEach(attr => {
        const match = attr.name.match(regex);
        if (match) {
            const [, attributeName, template, qualifier] = match;
            templates.add(template.trim());
            qualifiers.add(qualifier.trim());
            parsed.push({
                ...attr,
                attributeName: attributeName.trim(),
                template: template.trim(),
                qualifier: qualifier.trim()
            });
        } else {
            // If format doesn't match, add to "Uncategorized"
            parsed.push({
                ...attr,
                attributeName: attr.name,
                template: 'Uncategorized',
                qualifier: 'Uncategorized'
            });
            templates.add('Uncategorized');
            qualifiers.add('Uncategorized');
        }
    });

    return {
        templates: Array.from(templates).sort(),
        qualifiers: Array.from(qualifiers).sort(),
        parsed: parsed
    };
}

/**
 * Gets the competitor count for a given template ID by counting bottom rank rate attributes.
 * We count "COMP SET R{N} RATE" pattern (excludes "TOP" variants) to get the actual competitor count.
 * @param {string} templateId - The template ID to look up
 * @returns {number} The number of competitors (0 if not found)
 */
function getCompCountForTemplate(templateId) {
    if (!dynamicData.propertyTypes) return 0;

    // Find the template name from propertyTypes
    const template = dynamicData.propertyTypes.find(pt => pt.id === templateId);
    if (!template) return 0;

    // Count bottom rank rate attributes: "COMP SET BOTTOM R{N} RATE"
    // This gives us the actual number of competitors
    const bottomRankPattern = /^COMP SET BOTTOM R\d+ RATE$/;
    let count = 0;

    if (attributeMetadata.parsed) {
        attributeMetadata.parsed.forEach(attr => {
            if (attr.template === template.name && bottomRankPattern.test(attr.attributeName)) {
                count++;
            }
        });
    }

    return count || 99; // Default to 99 if we can't determine
}

/**
 * Filters attributes based on search text, selected templates, and selected qualifiers.
 * @param {string} searchText - Case-insensitive search text
 * @param {Array} selectedTemplates - Array of selected template names (empty = all)
 * @param {Array} selectedQualifiers - Array of selected qualifier names (empty = all)
 * @returns {Object} Object with filtered attributes and total count
 */
function filterAttributes(searchText, selectedTemplates, selectedQualifiers) {
    const search = searchText.toLowerCase().trim();
    let filtered = attributeMetadata.parsed;

    // Apply template filter
    if (selectedTemplates.length > 0) {
        filtered = filtered.filter(attr => selectedTemplates.includes(attr.template));
    }

    // Apply qualifier filter
    if (selectedQualifiers.length > 0) {
        filtered = filtered.filter(attr => selectedQualifiers.includes(attr.qualifier));
    }

    // Apply search text filter
    if (search) {
        filtered = filtered.filter(attr => attr.name.toLowerCase().includes(search));
    }

    // Sort alphabetically by name
    filtered.sort((a, b) => a.name.localeCompare(b.name));

    return {
        attributes: filtered,
        totalCount: filtered.length
    };
}

/**
 * Creates the attribute selection modal dialog.
 * This modal appears when clicking the attribute dropdown.
 */
function createAttributeModal() {
    // Create modal overlay
    const modalOverlay = document.createElement('div');
    modalOverlay.id = 'attribute-modal-overlay';
    modalOverlay.className = 'modal-overlay';

    // Create modal content
    const modalContent = document.createElement('div');
    modalContent.className = 'modal-content';

    // Create modal header
    const modalHeader = document.createElement('div');
    modalHeader.className = 'modal-header';
    modalHeader.innerHTML = `
        <h3>Select Attribute</h3>
        <button type="button" class="modal-close-btn">&times;</button>
    `;

    // Create modal body (will contain the searchable component)
    const modalBody = document.createElement('div');
    modalBody.className = 'modal-body';
    modalBody.id = 'attribute-modal-body';

    // Assemble modal
    modalContent.appendChild(modalHeader);
    modalContent.appendChild(modalBody);
    modalOverlay.appendChild(modalContent);
    document.body.appendChild(modalOverlay);

    // Store reference
    attributeModal = {
        overlay: modalOverlay,
        body: modalBody,
        onSelectCallback: null
    };

    // Close button handler
    modalHeader.querySelector('.modal-close-btn').addEventListener('click', closeAttributeModal);

    // Close on overlay click
    modalOverlay.addEventListener('click', (e) => {
        if (e.target === modalOverlay) {
            closeAttributeModal();
        }
    });

    // Close on Escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && modalOverlay.style.display === 'flex') {
            closeAttributeModal();
        }
    });
}

/**
 * Opens the attribute selection modal with searchable interface.
 * @param {Function} onSelect - Callback function when an attribute is selected
 */
function openAttributeModal(onSelect) {
    if (!attributeModal || attributeMetadata.parsed.length === 0) return;

    // Store the callback
    attributeModal.onSelectCallback = onSelect;

    // Clear and rebuild the modal body with searchable component
    attributeModal.body.innerHTML = '';
    buildModalSearchableComponent(attributeModal.body, (id, name) => {
        // Call the callback
        if (attributeModal.onSelectCallback) {
            attributeModal.onSelectCallback(id, name);
        }
        // Close modal
        closeAttributeModal();
    });

    // Show modal
    attributeModal.overlay.style.display = 'flex';

    // Focus search input
    setTimeout(() => {
        const searchInput = attributeModal.body.querySelector('.attribute-search-input');
        if (searchInput) searchInput.focus();
    }, 100);
}

/**
 * Closes the attribute selection modal and saves filter state.
 */
function closeAttributeModal() {
    if (attributeModal) {
        // Save current filter state before closing (will be captured by the component)
        attributeModal.overlay.style.display = 'none';
        attributeModal.onSelectCallback = null;
    }
}

/**
 * Builds the searchable attribute component inside the modal.
 * @param {HTMLElement} container - The container element to insert the component into
 * @param {Function} onSelect - Callback function when an attribute is selected
 */
function buildModalSearchableComponent(container, onSelect) {
    // Restore filter state from session
    let selectedTemplates = [...modalFilterState.selectedTemplates];
    let selectedQualifiers = [...modalFilterState.selectedQualifiers];
    let searchText = modalFilterState.searchText;
    let searchTimeout = null;

    // Function to save state to session
    const saveFilterState = () => {
        modalFilterState.selectedTemplates = [...selectedTemplates];
        modalFilterState.selectedQualifiers = [...selectedQualifiers];
        modalFilterState.searchText = searchText;
    };

    // Create the main wrapper
    const wrapper = document.createElement('div');
    wrapper.className = 'searchable-attribute-container';

    // Create search input
    const searchInput = document.createElement('input');
    searchInput.type = 'text';
    searchInput.className = 'attribute-search-input';
    searchInput.placeholder = 'Search attributes...';
    searchInput.value = searchText; // Restore saved search text

    // Create filter chips container
    const filtersContainer = document.createElement('div');
    filtersContainer.className = 'attribute-filters';

    // Create results container
    const resultsContainer = document.createElement('div');
    resultsContainer.className = 'attribute-results';

    // Create results count label
    const resultsCount = document.createElement('div');
    resultsCount.className = 'results-count';

    // Assemble the component
    wrapper.appendChild(searchInput);
    wrapper.appendChild(filtersContainer);
    wrapper.appendChild(resultsCount);
    wrapper.appendChild(resultsContainer);
    container.appendChild(wrapper);

    // Function to create filter chips
    function createFilterChips() {
        filtersContainer.innerHTML = '';

        // Only show filters if there's more than one option
        const showTemplateFilters = attributeMetadata.templates.length > 1;
        const showQualifierFilters = attributeMetadata.qualifiers.length > 1;

        if (showTemplateFilters) {
            const templateRow = document.createElement('div');
            templateRow.className = 'filter-row';
            templateRow.innerHTML = '<span class="filter-label">Templates:</span>';

            attributeMetadata.templates.forEach(template => {
                const chip = document.createElement('button');
                chip.type = 'button';
                chip.className = 'filter-chip';
                chip.textContent = template;
                chip.dataset.template = template;

                if (selectedTemplates.includes(template)) {
                    chip.classList.add('active');
                }

                chip.addEventListener('click', () => {
                    if (selectedTemplates.includes(template)) {
                        selectedTemplates = selectedTemplates.filter(t => t !== template);
                        chip.classList.remove('active');
                    } else {
                        selectedTemplates.push(template);
                        chip.classList.add('active');
                    }
                    saveFilterState(); // Save to session
                    updateResults();
                });

                templateRow.appendChild(chip);
            });

            filtersContainer.appendChild(templateRow);
        }

        if (showQualifierFilters) {
            const qualifierRow = document.createElement('div');
            qualifierRow.className = 'filter-row';
            qualifierRow.innerHTML = '<span class="filter-label">Qualifiers:</span>';

            attributeMetadata.qualifiers.forEach(qualifier => {
                const chip = document.createElement('button');
                chip.type = 'button';
                chip.className = 'filter-chip';
                chip.textContent = qualifier;
                chip.dataset.qualifier = qualifier;

                if (selectedQualifiers.includes(qualifier)) {
                    chip.classList.add('active');
                }

                chip.addEventListener('click', () => {
                    if (selectedQualifiers.includes(qualifier)) {
                        selectedQualifiers = selectedQualifiers.filter(q => q !== qualifier);
                        chip.classList.remove('active');
                    } else {
                        selectedQualifiers.push(qualifier);
                        chip.classList.add('active');
                    }
                    saveFilterState(); // Save to session
                    updateResults();
                });

                qualifierRow.appendChild(chip);
            });

            filtersContainer.appendChild(qualifierRow);
        }
    }

    // Function to highlight search text in a string
    function highlightText(text, search) {
        if (!search || search.trim() === '') {
            return text;
        }

        // Escape special regex characters in search text
        const escapedSearch = search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        const regex = new RegExp(`(${escapedSearch})`, 'gi');

        // Replace matched text with highlighted version
        return text.replace(regex, '<mark class="search-highlight">$1</mark>');
    }

    // Function to update results
    function updateResults() {
        const { attributes, totalCount } = filterAttributes(searchText, selectedTemplates, selectedQualifiers);

        resultsContainer.innerHTML = '';

        if (attributes.length === 0) {
            resultsContainer.innerHTML = '<div class="no-results">No attributes found</div>';
            resultsCount.textContent = '';
            return;
        }

        attributes.forEach(attr => {
            const item = document.createElement('div');
            item.className = 'attribute-result-item';

            // Apply highlighting to the attribute name
            const highlightedName = highlightText(attr.name, searchText);
            item.innerHTML = highlightedName;

            item.title = attr.name; // Tooltip for long names
            item.dataset.id = attr.id;
            item.dataset.name = attr.name;

            item.addEventListener('click', () => {
                if (onSelect) {
                    onSelect(attr.id, attr.name);
                }
            });

            resultsContainer.appendChild(item);
        });

        // Update count
        resultsCount.textContent = `Showing ${attributes.length} of ${totalCount} attributes`;
    }

    // Search input handler with debounce
    searchInput.addEventListener('input', (e) => {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => {
            searchText = e.target.value;
            saveFilterState(); // Save to session
            updateResults();
        }, 300);
    });

    // Initialize
    createFilterChips();
    updateResults();

    // Return API for external control
    return {
        refresh: () => {
            createFilterChips();
            updateResults();
        },
        reset: () => {
            searchText = '';
            selectedTemplates = [];
            selectedQualifiers = [];
            searchInput.value = '';
            createFilterChips();
            updateResults();
        }
    };
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
        // div.textContent = item;
        div.textContent = (options.type === 'attribute') ? item.name : item;
        div.addEventListener('mouseover', () => setActiveAutocompleteItem(index));
        div.addEventListener('click', () => {
            const startPos = textarea.selectionStart;
            const textBefore = textarea.value.substring(0, startPos - 1);
            const textAfter = textarea.value.substring(startPos);

            // let textToInsert = (options.type === 'attribute') ? `#${item}# ` : `${item}() `;
            const itemName = (options.type === 'attribute') ? item.name : item;
            let textToInsert = (options.type === 'attribute') ? `#${itemName}# ` : `${itemName}() `;
            
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
            <div class="region-controls ">
                <div class="algo-icon-controls"> 
                    <button type="button" class="algo-icon-btn copy-region" title="Duplicate Region">
                        <svg xmlns="http://www.w.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
                            <path d="M0 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v2h2a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-2H2a2 2 0 0 1-2-2V2zm5 10v2a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V6a1 1 0 0 0-1-1h-2v5a2 2 0 0 1-2 2H5zm-4-3v2a1 1 0 0 0 1 1h2V9a2 2 0 0 1 2-2h5V2a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v7z"/>
                        </svg>
                    </button>
                    <button type="button" class="algo-icon-btn region-move up" data-direction="up" title="Move Region Up">▲</button>
                    <button type="button" class="algo-icon-btn region-move down" data-direction="down" title="Move Region Down">▼</button>
                    <button type="button" class="algo-icon-btn btn-danger delete-region" title="Remove Region">×</button>
                </div>
            </div>
        </div>
        <div class="validation-messages" style="display: none;"></div>
        <div class="region-content">
            <div class="section">
                <div class="section-title"><span>Filters</span></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${regionId}-stay-window" data-validates="stayWindow"><label for="${regionId}-stay-window">Stay Window</label><div class="field-content hidden"><label>From</label> <input type="date" class="stay-window-from" value="${formatDate(today)}"><label>To</label> <input type="date" class="stay-window-to" value="${formatDate(nextWeek)}"></div></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${regionId}-load-time" data-validates="leadTime"><label for="${regionId}-load-time">Lead Time</label><div class="field-content hidden">
                        <select class="load-time-select"><option value="">Select Type</option><option value="date_range">Date Range</option><option value="days">Day(s)</option><option value="weeks">Week(s)</option><option value="months">Month(s)</option></select><div class="lead-time-inputs" style="margin-left: 10px; display: inline-flex; align-items: center; gap: 8px;"></div><div class="lead-time-exclude-container" style="margin-left: 15px; display: inline-flex; align-items: center; gap: 5px;"><label for="${regionId}-lead-time-exclude">Exclusive</label><input type="checkbox" class="lead-time-exclude-checkbox" id="${regionId}-lead-time-exclude"></div></div></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${regionId}-days-of-week" data-validates="daysOfWeek"><label for="${regionId}-days-of-week">Day of Week</label><div class="field-content hidden"><div class="checkbox-group">${['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'].map(day => `<div class="checkbox-item"><input type="checkbox" id="${regionId}-${day}" class="day-checkbox"><label for="${regionId}-${day}">${day.toUpperCase()}</label></div>`).join('')}</div></div></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${regionId}-minimum-rate" data-validates="minimumRate"><label for="${regionId}-minimum-rate">Minimum Rate</label><div class="field-content hidden"><input type="number" value="75" min="0" class="minimum-rate-input"></div></div>
                <div class="field-container ${!getPriceOverrideAttribute() ? 'disabled-field' : ''}">
                    <input type="checkbox" class="field-checkbox" id="${regionId}-price-override" data-validates="priceOverride" ${!getPriceOverrideAttribute() ? 'disabled' : ''}>
                    <label for="${regionId}-price-override">Price Override ${!getPriceOverrideAttribute() ? '<span class="unavailable-badge">Unavailable</span>' : ''}</label>
                    <div class="field-content hidden">${generatePriceOverrideFieldContent(!!getPriceOverrideAttribute())}</div>
                </div>
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
    console.log('Inside addCondition, attributes count:', (dynamicData.attributes || []).length);
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
            <div class="algo-icon-controls condition-controls">
                <button type="button" class="algo-icon-btn copy-condition" title="Duplicate Condition">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
                         <path d="M0 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v2h2a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-2H2a2 2 0 0 1-2-2V2zm5 10v2a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V6a1 1 0 0 0-1-1h-2v5a2 2 0 0 1-2 2H5zm-4-3v2a1 1 0 0 0 1 1h2V9a2 2 0 0 1 2-2h5V2a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v7z"/>
                    </svg>
                </button>
                <button type="button" class="algo-icon-btn condition-move up" data-direction="up" title="Move Condition Up">▲</button>
                <button type="button" class="algo-icon-btn condition-move down" data-direction="down" title="Move Condition Down">▼</button>
                <button type="button" class="algo-icon-btn btn-danger condition-remove" title="Remove Condition">×</button>
            </div>
        </div>
        <div class="condition-body" style="display: flex; align-items: flex-start; gap: 20px;">
            <div class="condition-fields" style="flex: 3;">
                <div class="section-title"><span>Conditions</span></div>
                <div class="field-container ${!dynamicData.occupancyAttributes || dynamicData.occupancyAttributes.length === 0 ? 'disabled-field' : ''}">
                    <input type="checkbox" class="field-checkbox" id="${conditionId}-occupancy-threshold" data-validates="occupancyThreshold" ${!dynamicData.occupancyAttributes || dynamicData.occupancyAttributes.length === 0 ? 'disabled' : ''}>
                    <label for="${conditionId}-occupancy-threshold">
                        Occupancy Threshold %
                        ${!dynamicData.occupancyAttributes || dynamicData.occupancyAttributes.length === 0 ? '<span class="unavailable-badge">Unavailable</span>' : ''}
                    </label>
                    <div class="field-content hidden">
                        ${generateOccupancyFieldContent(dynamicData.occupancyAttributes && dynamicData.occupancyAttributes.length > 0)}
                    </div>
                </div>
                <div class="field-container${dynamicData.propertyTypes && dynamicData.propertyTypes.length > 0 ? '' : ' disabled-field'}"><input type="checkbox" class="field-checkbox" id="${conditionId}-property-ranking" data-validates="propertyRanking"${dynamicData.propertyTypes && dynamicData.propertyTypes.length > 0 ? '' : ' disabled'}><label for="${conditionId}-property-ranking">Own Property Rank${dynamicData.propertyTypes && dynamicData.propertyTypes.length > 0 ? '' : '<span class="unavailable-badge">Unavailable</span>'}</label><div class="field-content hidden"><select class="property-type-select property-type"><option value="">Choose Comp. Set</option>${(dynamicData.propertyTypes || []).map(type => `<option value="${type.id}">${type.name}</option>`).join('')}</select><select class="operator-select property-operator">${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}</select><input type="number" class="value-input property-value" value="1" min="1" style="width: 60px;"><label class="rank-direction-toggle"><span class="toggle-label-left">Bottom</span><input type="checkbox" class="rank-direction-switch"><span class="toggle-slider"></span><span class="toggle-label-right">Top</span></label></div></div>
                <div class="field-container"><input type="checkbox" class="field-checkbox" id="${conditionId}-event-score" data-validates="eventScore"><label for="${conditionId}-event-score">Event Score</label><div class="field-content hidden"><select class="operator-select event-operator">${staticData.operators.map(op => `<option value="${op}">${op}</option>`).join('')}</select><input type="number" class="value-input event-value" value="0" min="-3" max="3" style="width: 60px;"></div></div>
            </div>
            <div class="condition-expression" style="flex: 2; border-left: 1px solid #444; padding-left: 20px;">
                <div class="section calculation-section" style="padding: 0; border: none; background: none;">
                    <div class="section-title"><span>Expression</span></div>
                    <div class="filter-row"><div class="filter-group"><select class="function-select"><option value="">Select Function</option>${staticData.functions.map(func => `<option value="${func}">${func}</option>`).join('')}</select><select class="attribute-select"><option value="">Select Attribute</option></select><select class="operator-select expression-operator"><option value="">Select Operator</option>${staticData.expressionOperators.map(op => `<option value="${op}">${op}</option>`).join('')}</select></div></div>
                    <div class="expression-container"><textarea class="expression-textarea" placeholder="Type # for attributes, = for functions, or ~ for plain text..."></textarea><div class="textarea-controls"><div class="btn btn-small" data-action="clear">Clear</div><div class="btn btn-small btn-secondary" data-action="validate-expression">Validate</div></div></div>
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
    
    conditionElement.querySelector('.copy-condition').addEventListener('click', () => {
        copyCondition(conditionElement);
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

    // Update property-value max when comp set selection changes
    const propertyTypeSelect = conditionElement.querySelector('.property-type-select');
    if (propertyTypeSelect) {
        propertyTypeSelect.addEventListener('change', (e) => {
            const templateId = e.target.value;
            const propertyValueInput = conditionElement.querySelector('.property-value');
            if (propertyValueInput) {
                const compCount = getCompCountForTemplate(templateId);
                propertyValueInput.max = compCount;
                // If current value exceeds new max, adjust it
                if (parseInt(propertyValueInput.value) > compCount) {
                    propertyValueInput.value = compCount;
                }
            }
        });
    }

    const calculationSection = conditionElement.querySelector('.calculation-section');
    if (!calculationSection) return;
    const expressionTextarea = calculationSection.querySelector('.expression-textarea');
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

        // Handle ~ trigger for plain text mode
        // Only trigger if user is typing (inputType is insertText) and the last char is ~
        // AND we're not already inside a plain text block (check for opening ~ before cursor)
        if (lastChar === '~' && e.inputType === 'insertText' && e.data === '~') {
            // Check if there's already an opening ~ before the cursor (excluding the one just typed)
            const textBeforeCursor = text.substring(0, cursorPos - 1);
            const hasOpeningTilde = textBeforeCursor.includes('~');

            // Only auto-expand if there's no opening ~ before (meaning this is the first ~)
            if (!hasOpeningTilde) {
                const beforeTilde = text.substring(0, cursorPos - 1);
                const afterTilde = text.substring(cursorPos);
                e.target.value = beforeTilde + '~Add your text here~' + afterTilde;
                const newPos = cursorPos; // Position at the start of "Add your text here"
                e.target.setSelectionRange(newPos, newPos + 18); // Select "Add your text here"
                return;
            }
        }

        if (lastChar === '#') showAutocomplete(e.target, dynamicData.attributes, { type: 'attribute' });
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

    // Attribute selection handler - opens modal dialog
    const attributeSelect = calculationSection.querySelector('.attribute-select');
    if (attributeSelect) {
        // Use mousedown to intercept BEFORE browser shows native dropdown
        attributeSelect.addEventListener('mousedown', (e) => {
            e.preventDefault(); // Prevent native dropdown from opening
            e.stopPropagation();

            openAttributeModal((_id, name) => {
                // Insert attribute into expression textarea
                insertAtCursor(expressionTextarea, `#${name}# `);
            });
        });

        // Also handle click for keyboard navigation (Enter/Space on focused select)
        attributeSelect.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
        });

        // Prevent focus from showing dropdown
        attributeSelect.addEventListener('focus', (e) => {
            e.target.blur();
        });
    }

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

    regionElement.querySelector('.copy-region').addEventListener('click', () => {
        copyFilterRegion(regionElement);
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
                inputsContainer.innerHTML = `<label>From</label> <input type="date" class="lead-time-from"> <label>To</label> <input type="date" class="lead-time-to">`;
            } else if (['days', 'weeks', 'months'].includes(selectedValue)) {
                const label = selectedValue.charAt(0).toUpperCase() + selectedValue.slice(1);
                inputsContainer.innerHTML = `<label>Number of ${label}</label> <input type="number" class="lead-time-value" min="1" style="width: 80px;">`;
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

/**
 * Creates a duplicate of a filter region below the original.
 * @param {HTMLElement} originalRegionElement - The filter region to copy.
 */
function copyFilterRegion(originalRegionElement) {
    // 1. Get the data from the original region
    const regionData = getRegionData(originalRegionElement);

    // 2. Modify the data for the new copy
    regionData.name += ` - copy ${generateTimestamp()}`;
    
    // 3. Important: Clear old IDs to prevent duplicates in the DOM
    regionData.id = null; 
    regionData.conditions.forEach(c => c.id = null);

    // 4. Create a new empty region and insert it after the original
    addFilterRegion();
    const newRegionElement = document.getElementById('filterContainer').lastElementChild;
    originalRegionElement.after(newRegionElement);

    // 5. Populate the new region with the copied data
    populateRegion(newRegionElement, regionData);
    
    // 6. Update sequence numbers for all regions
    updateRegionSequence();
    updateConditionSequence(newRegionElement.id); // Also update conditions within the new region
}

/**
 * Creates a duplicate of a condition below the original.
 * @param {HTMLElement} originalConditionElement - The condition element to copy.
 */
function copyCondition(originalConditionElement) {
    const regionId = originalConditionElement.closest('.filter-region').id;

    // 1. Get data from the single original condition
    const conditionData = getConditionData(originalConditionElement);
    if (!conditionData) {
        alert("Cannot copy an empty condition.");
        return;
    }

    // 2. Modify the data
    conditionData.name += ` - copy ${generateTimestamp()}`;
    conditionData.id = null; // Clear old ID

    // 3. Create a new empty condition and insert it after the original
    addCondition(regionId);
    const newConditionElement = document.getElementById(`${regionId}-conditions-container`).lastElementChild;
    originalConditionElement.after(newConditionElement);

    // 4. Populate the new condition with the copied data
    populateCondition(newConditionElement, conditionData);

    // 5. Update sequence numbers for conditions within this region
    updateConditionSequence(regionId);
}

// --- VALIDATION & DATA FUNCTIONS ---
function validateSingleExpression(expressionTextarea) {
    const errors = [];
    const expression = expressionTextarea.value.trim();

    if (expression === '') {
        errors.push('Expression cannot be empty.');
        return { isValid: errors.length === 0, errors };
    }

    // Check if this is plain text mode
    if (expression.startsWith('~') && !expression.startsWith('~~')) {
        // Plain text validation
        if (!expression.endsWith('~') || expression.endsWith('~~')) {
            errors.push('Plain text must be wrapped as ~text~');
        } else {
            const plainText = expression.slice(1, -1); // Extract text between ~

            // Check length limit
            if (plainText.length > 50) {
                errors.push('Plain text cannot exceed 50 characters');
            }

            // Check for mixed content (no attributes or functions allowed)
            if (plainText.includes('#')) {
                errors.push('Cannot mix plain text with expressions. Use either ~text~ or expression format');
            }
            if (staticData.functions.some(func => plainText.includes(func + '('))) {
                errors.push('Cannot mix plain text with expressions. Use either ~text~ or expression format');
            }
        }
        return { isValid: errors.length === 0, errors };
    }

    // Expression mode validation - check for any ~ presence (but allow ~~ which won't match the pattern above)
    if (expression.includes('~') && !(expression.startsWith('~~') || expression.includes('~~'))) {
        errors.push('Cannot mix expressions with plain text. Use either ~text~ or expression format');
        return { isValid: errors.length === 0, errors };
    }

    // Existing expression validation logic
    const validAttributeNames = dynamicData.attributes.map(attr => attr.name);
    let tempExpression = expression;
    const attributeTokens = tempExpression.match(/#[^#]+#/g) || [];

    for (const token of attributeTokens) {
        const attributeName = token.slice(1, -1);
        if (!validAttributeNames.includes(attributeName)) {
            errors.push(`Invalid attribute: "${token}"`);
        }
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

    // Validate Price Override
    const priceOverrideCheckbox = filterContainer.querySelector(`#${regionId}-price-override`);
    if (priceOverrideCheckbox?.checked && !priceOverrideCheckbox.disabled) {
        const priceOverrideAttrId = filterContainer.querySelector('.price-override-attribute-id')?.value;

        if (!priceOverrideAttrId) {
            errors.push(`${regionName}: Price Override is enabled but no attribute is available.`);
            priceOverrideCheckbox.closest('.field-container').classList.add('invalid-field');
        } else {
            const signaturePart = `priceOverride:${priceOverrideAttrId}`;
            individualFilterSignatures.push(signaturePart);
        }
    }

    if (checkedFilters.length > 0) {
        signatures.push({ signature: individualFilterSignatures.sort().join('|'), element: filterContainer, type: 'filter' });
    } else {
        signatures.push({ signature: 'filters:empty', element: filterContainer, type: 'filter' });
    }

    // New logic: Create composite signatures per full condition set
    const conditions = regionElement.querySelectorAll('.condition-group');
    const compositeConditionSignatures = [];

    conditions.forEach(cond => {
        const condTitle = cond.querySelector('.title-display').textContent.trim();
        const isActive = !!cond.querySelector('.field-checkbox:checked');
        const expression = cond.querySelector('.expression-textarea').value.trim();

        // Collect all part signatures of this condition
        const condSignatures = [];

        if (!isActive && expression === '') {
            condSignatures.push('condition:empty');
        } else {
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
                // Skip validation if checkbox is disabled (e.g., occupancy not available)
                if (checkbox.disabled) {
                    return;
                }

                const fc = checkbox.closest('.field-container');
                const validationType = checkbox.dataset.validates;
                let signature = null;
                const inputs = Array.from(fc.querySelectorAll('input:not([type=checkbox]):not([type=hidden]), select'));

                // Special handling for occupancy threshold - check hidden input
                if (validationType === 'occupancyThreshold') {
                    const hiddenInput = fc.querySelector('.occupancy-attribute-id');
                    if (!hiddenInput || !hiddenInput.value) {
                        errors.push(`${condTitle}: CALCULATED_OCCUPANCY attribute not found for this hotel. Please contact administrator.`);
                        fc.classList.add('invalid-field');
                        return;
                    }
                }

                if (inputs.some(i => !i.value)) {
                    errors.push(`${condTitle}: A value for "${fc.querySelector('label').textContent.trim()}" is missing.`);
                    fc.classList.add('invalid-field');
                } else {
                    signature = `${validationType}:${inputs.map(i => i.value).join(':')}`;
                    // Include rank direction toggle in signature for propertyRanking
                    if (validationType === 'propertyRanking') {
                        const rankDirectionSwitch = fc.querySelector('.rank-direction-switch');
                        const rankDirection = rankDirectionSwitch && rankDirectionSwitch.checked ? 'top' : 'bottom';
                        signature += `:${rankDirection}`;
                    }
                    condSignatures.push(signature);
                }
            });
        }

        // Combine all part signatures of condition into one composite signature
        const compositeSig = condSignatures.length > 0 ? condSignatures.sort().join('|') : 'condition:empty';
        compositeConditionSignatures.push({ signature: compositeSig, element: cond });
    });

    // Now check for duplicate composite signatures (whole condition sets duplicates)
    const compositeCounts = compositeConditionSignatures.reduce((acc, { signature }) => {
        acc[signature] = (acc[signature] || 0) + 1;
        return acc;
    }, {});

    const duplicateCompositeSignatures = Object.keys(compositeCounts).filter(sig => compositeCounts[sig] > 1);

    if (duplicateCompositeSignatures.length > 0) {
        errors.push('Duplicate entire condition sets found within this region.');
        compositeConditionSignatures.forEach(({ signature, element }) => {
            if (duplicateCompositeSignatures.includes(signature)) element.classList.add('invalid-field');
        });
    }

    // Also add all composite condition signatures to the main signatures for any other logic
    compositeConditionSignatures.forEach(({ signature, element }) => {
        signatures.push({ signature, element, type: 'condition' });
    });

    // Previous single condition logic (removed) to avoid partial flagging of independent condition parts

    // Previous total signature duplicate check for individual signatures removed to just rely on filter and new composite condition checks

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
            const excludeCheckbox = filtersSection.querySelector('.lead-time-exclude-checkbox');
            const type = leadTimeSelect.value;

            const leadTimeData = {
                type: type,
                exclude: excludeCheckbox?.checked || false
            };

            if (type === 'date_range') {
                data.filters.leadTime = {
                    ...leadTimeData,
                    from: filtersSection.querySelector('.lead-time-from')?.value,
                    to: filtersSection.querySelector('.lead-time-to')?.value
                };
            } else if (type) {
                data.filters.leadTime = {
                    ...leadTimeData,
                    value: parseInt(filtersSection.querySelector('.lead-time-value')?.value, 10)
                };
            }
        }
        if (filtersSection.querySelector(`#${regionId}-days-of-week`)?.checked) {
            const dayMap = { sun: 1, mon: 2, tue: 3, wed: 4, thu: 5, fri: 6, sat: 7 };
            data.filters.daysOfWeek = Array.from(filtersSection.querySelectorAll('.day-checkbox:checked')).map(cb => dayMap[cb.id.split('-').pop()]).sort((a, b) => a - b);
        }
        if (filtersSection.querySelector(`#${regionId}-minimum-rate`)?.checked) data.filters.minimumRate = parseFloat(filtersSection.querySelector('.minimum-rate-input')?.value);
        if (filtersSection.querySelector(`#${regionId}-price-override`)?.checked) {
            const priceOverrideAttrId = filtersSection.querySelector('.price-override-attribute-id')?.value;
            if (priceOverrideAttrId) {
                data.filters.priceOverride = {
                    attribute: `#${priceOverrideAttrId}#`
                };
            }
        }
    }
    regionElement.querySelectorAll('.condition-group').forEach(cond => {
        const isActive = !!cond.querySelector('.field-checkbox:checked') || cond.querySelector('.expression-textarea').value.trim() !== '';
        if (!isActive) return;

        const conditionData = {
            id: cond.id,
            name: cond.querySelector('.title-display').textContent.trim(),
            sequence: parseInt(cond.dataset.sequence, 10)
        };
        
        const occupancyCheckbox = cond.querySelector(`#${cond.id}-occupancy-threshold`);
        if (occupancyCheckbox?.checked && !occupancyCheckbox.disabled) {
            const occupancyAttrId = cond.querySelector('.occupancy-attribute-id')?.value;

            if (!occupancyAttrId) {
                console.warn('No CALCULATED_OCCUPANCY attribute found for this hotel');
                // Skip this condition if attribute is not available
            } else {
                conditionData.occupancyThreshold = {
                    attribute: `#${occupancyAttrId}#`,
                    operator: cond.querySelector('.occupancy-operator').value,
                    value: parseFloat(cond.querySelector('.occupancy-value').value)
                };
            }
        }
        if (cond.querySelector(`#${cond.id}-property-ranking`)?.checked) {
            const val = cond.querySelector('.property-value').value;
            const rankDirection = cond.querySelector('.rank-direction-switch')?.checked ? 'top' : 'bottom';
            conditionData.propertyRanking = {
                // type: cond.querySelector('.property-type').value,
                type: `#${cond.querySelector('.property-type').value}#`,
                operator: cond.querySelector('.property-operator').value,
                value: isNaN(parseInt(val, 10)) ? val : parseInt(val, 10),
                rankDirection: rankDirection
            };
        }
        if (cond.querySelector(`#${cond.id}-event-score`)?.checked) conditionData.eventScore = { operator: cond.querySelector('.event-operator').value, value: parseFloat(cond.querySelector('.event-value').value) };
        
        const expression = cond.querySelector('.expression-textarea').value.trim();
        // if (expression) conditionData.expression = expression;
        
        if (expression) {
        // --- THIS IS THE CHANGE ---
        // Convert the user-friendly expression (with names) to a storable expression (with IDs)
        conditionData.expression = convertExpressionNamesToIds(expression);
        }

        data.conditions.push(conditionData);
    });
    return data;
}

function validateAllRegions() {
    let allValid = true;
    const allSignatures = [];

    document.querySelectorAll('.filter-region').forEach(region => {
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

    // New composite validation across filter regions
    const filterSignatures = allSignatures.filter(s => s.type === 'filter');
    const signatureCounts = filterSignatures.reduce((acc, { signature }) => {
        acc[signature] = (acc[signature] || 0) + 1;
        return acc;
    }, {});
    const duplicateSignatures = Object.keys(signatureCounts).filter(sig => signatureCounts[sig] > 1);

    if (duplicateSignatures.length > 0) {
        allValid = false;
        const errorRegions = new Set();
        filterSignatures.forEach(({ signature, region }) => {
            if (duplicateSignatures.includes(signature)) {
                region.classList.add('invalid-region');
                errorRegions.add(region);
            }
        });
        errorRegions.forEach(region => {
            const messageDiv = region.querySelector('.validation-messages');
            const newError = '<li>Error: This set of filters is a duplicate of another region.</li>';
            if (!messageDiv.innerHTML.includes(newError)) {
                if (messageDiv.innerHTML.trim() === '') {
                    messageDiv.innerHTML = '<ul>' + newError + '</ul>';
                } else if (!messageDiv.innerHTML.trim().endsWith('</ul>')) {
                    messageDiv.innerHTML += newError;
                } else {
                    messageDiv.innerHTML = messageDiv.innerHTML.slice(0, -5) + newError + '</ul>';
                }
            }
            messageDiv.style.display = 'block';
        });
    }

    if (allValid) {
        alert('All regions are valid!');
    } else {
        alert('Please fix the errors in the highlighted regions.');
    }
    return allValid;
}

function saveAllRegions() {
    // --- Step 1: Validation (Unchanged) ---
    const regions = document.querySelectorAll('.filter-region');
    let allValid = true;
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

    // ... (The rest of your validation logic for duplicates remains here) ...

    // New logic for detecting duplicate filter regions across all regions
    const filterSignatures = allSignatures.filter(s => s.type === 'filter');

    // Count occurrences of each filter signature
    const signatureCounts = {};
    filterSignatures.forEach(({ signature }) => {
        signatureCounts[signature] = (signatureCounts[signature] || 0) + 1;
    });

    // Identify duplicate filter signatures
    const duplicateSignatures = Object.keys(signatureCounts).filter(sig => signatureCounts[sig] > 1);

    if (duplicateSignatures.length > 0) {
        allValid = false;
        const errorRegions = new Set();

        // Mark all regions with duplicate filters as invalid
        filterSignatures.forEach(({ signature, region }) => {
            if (duplicateSignatures.includes(signature)) {
                region.classList.add('invalid-region');
                errorRegions.add(region);
            }
        });

        // Display a duplicate filter set error for each affected region
        errorRegions.forEach(region => {
            const messageDiv = region.querySelector('.validation-messages');
            const newError = '<li>Error: This set of filters is a duplicate of another region.</li>';

            if (!messageDiv.innerHTML.includes(newError)) {
                if (messageDiv.innerHTML.trim() === '') {
                    messageDiv.innerHTML = '<ul>' + newError + '</ul>';
                } else if (!messageDiv.innerHTML.trim().endsWith('</ul>')) {
                    messageDiv.innerHTML += newError;
                } else {
                    messageDiv.innerHTML = messageDiv.innerHTML.slice(0, -5) + newError + '</ul>';
                }
            }
            messageDiv.style.display = 'block';
        });
    }


    // --- Step 2: AJAX Call ---
    if (allValid) {
        regions.forEach(region => allData.regions.push(getRegionData(region)));
        const jsonPayloadString = JSON.stringify(allData, null, 2);
        
        const algoListValue = apex.item("P1050_ALGO_LIST").getValue();
        const algoName = apex.item("P1050_NAME").getValue();
        const algoDesc = apex.item("P1050_DESCRIPTION").getValue();
        const hotelId = apex.item("P1050_HOTEL_LIST").getValue(); // NEW: Get the hotel ID

        let mode = '';
        let ajaxPayload = {};

        // Use the safer check for the "Create New" case
        if (algoListValue === '00' || !algoListValue) {
            mode = 'I';
            if (!algoName) {
                alert('Please provide a name for the new strategy.');
                return;
            }
            if (!hotelId) { // Safety check for hotel ID
                alert('A valid hotel must be selected to create a new strategy.');
                return;
            }
            ajaxPayload = { 
                x01: mode, 
                x03: algoName, 
                x04: algoDesc,
                x05: hotelId // ADDED: Pass the hotel ID as parameter x05
            };
        } else {
            mode = 'U';
            ajaxPayload = { 
                x01: mode, 
                x02: algoListValue 
            };
        }
        
        // Split the large JSON string into an array (for older APEX compatibility)
        const chunks = jsonPayloadString.match(/[\s\S]{1,4000}/g) || [];
        ajaxPayload.f01 = chunks; 

        var spinner = apex.util.showSpinner();
        
        apex.server.process(
            'SAVE_ALGORITHM_DATA',
            ajaxPayload,
            {
                success: function(pData) {
                    if (pData.success) {
                        apex.message.showPageSuccess(pData.message);

                        if (ajaxPayload.x01 === 'I') {
                            // --- THIS IS THE CORRECTED LOGIC ---
                            
                            // Get the jQuery selector for the item
                            const algoList$ = apex.jQuery("#P1050_ALGO_LIST");
                            
                            // 1. Set up a ONE-TIME listener to run code AFTER the refresh is complete.
                            algoList$.one('apexafterrefresh', function() {
                                if (pData.newAlgoId) {
                                    // 3. Now that the list is refreshed, set its value.
                                    // The final 'true' suppresses another change event to prevent loops.
                                    apex.item("P1050_ALGO_LIST").setValue(pData.newAlgoId);

                                }
                            });
                            
                            // // 2. Trigger the refresh. The listener above will catch the completion.
                            apex.item("P1050_ALGO_LIST").refresh();

                        } else { // This means the mode was 'U'
                            apex.item("P1050_VERSION").refresh();
                        }
                        
                    } else {
                        console.error("Server-side save error:", pData.message);
                        apex.message.alert("Save failed: " + pData.message);
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error("AJAX call failed:", errorThrown);
                    apex.message.alert("A critical error occurred while trying to save.");
                },
                dataType: "json"
            }
        ).always(() => {
            spinner.remove();
        });

    } else {
        alert('Please fix the errors in the highlighted regions before saving.');
    }
}



function insertAtCursor(textarea, text) {
    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    textarea.value = textarea.value.substring(0, start) + text + textarea.value.substring(end);
    textarea.selectionStart = textarea.selectionEnd = start + text.length;
    textarea.focus();
}

// --- LOADER FUNCTIONS ---
function loadFromJSON(savedData) {
    // --- DIAGNOSTIC TRACE ---
    console.warn('loadFromJSON() was called. See trace below.');
    console.trace();
    // --- END TRACE ---

    const filterContainer = document.getElementById('filterContainer');
    filterContainer.innerHTML = '';
    
    if (!savedData || !savedData.regions || savedData.regions.length === 0) {
        addFilterRegion();
        return;
    }

    savedData.regions.forEach(regionData => {
        addFilterRegion();
        const newRegionElement = filterContainer.lastElementChild;
        if (newRegionElement) {
            populateRegion(newRegionElement, regionData);
        }
    });

    updateRegionSequence();
    document.querySelectorAll('.filter-region').forEach(region => {
        updateConditionSequence(region.id);
    });
}

function populateRegion(regionElement, regionData) {
    const regionId = regionElement.id;

    regionElement.dataset.sequence = regionData.sequence;
    const titleDisplay = regionElement.querySelector('.title-display');
    const titleInput = regionElement.querySelector('.title-input');
    if (titleDisplay && titleInput) {
        titleDisplay.textContent = regionData.name;
        titleInput.value = regionData.name;
    }

    if (regionData.filters) {
        for (const [filterKey, filterValue] of Object.entries(regionData.filters)) {
            const filterCheckbox = regionElement.querySelector(`[data-validates="${filterKey}"]`);
            if (!filterCheckbox) continue;
            filterCheckbox.checked = true;
            filterCheckbox.dispatchEvent(new Event('change'));

            if (filterKey === 'stayWindow') {
                regionElement.querySelector('.stay-window-from').value = filterValue.from;
                regionElement.querySelector('.stay-window-to').value = filterValue.to;
            } else if (filterKey === 'leadTime') {
                // Set exclude checkbox (backward compatible - default to false if not present)
                const excludeCheckbox = regionElement.querySelector('.lead-time-exclude-checkbox');
                if (excludeCheckbox) {
                    excludeCheckbox.checked = filterValue.exclude || false;
                }

                const select = regionElement.querySelector('.load-time-select');
                select.value = filterValue.type;
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
            } else if (filterKey === 'priceOverride') {
                const priceOverrideAttrId = filterValue.attribute.replace(/#/g, '');
                const fieldContent = regionElement.querySelector(`#${regionId}-price-override`).closest('.field-container').querySelector('.field-content');

                if (fieldContent) {
                    const hiddenInput = fieldContent.querySelector('.price-override-attribute-id');

                    if (hiddenInput) {
                        hiddenInput.value = priceOverrideAttrId;
                    }
                }
            }
        }
    }

    const conditionsContainer = regionElement.querySelector('.conditions-container');
    conditionsContainer.innerHTML = '';

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

function populateCondition(conditionElement, conditionData) {
    conditionElement.dataset.sequence = conditionData.sequence;
    const titleDisplay = conditionElement.querySelector('.title-display');
    const titleInput = conditionElement.querySelector('.title-input');
    if (titleDisplay && titleInput) {
        titleDisplay.textContent = conditionData.name;
        titleInput.value = conditionData.name;
    }

    for (const [key, data] of Object.entries(conditionData)) {
        const checkbox = conditionElement.querySelector(`[data-validates="${key}"]`);
        if (checkbox) {
            checkbox.checked = true;
            checkbox.dispatchEvent(new Event('change'));
            
            const fieldContent = checkbox.closest('.field-container').querySelector('.field-content');
            if (key === 'occupancyThreshold') {
                // Check if occupancy is available (empty array means unavailable)
                if (!dynamicData.occupancyAttributes || dynamicData.occupancyAttributes.length === 0) {
                    console.warn('Cannot load occupancy threshold - CALCULATED_OCCUPANCY not available for this hotel');
                    // Uncheck the checkbox since condition cannot be active
                    checkbox.checked = false;
                    checkbox.disabled = true;
                    return; // Skip loading this condition
                }

                // Ensure field-content has structure before loading values
                if (fieldContent && !fieldContent.querySelector('.occupancy-attribute-id')) {
                    console.warn('Occupancy field structure missing - injecting now');
                    fieldContent.innerHTML = generateOccupancyFieldContent(true);
                }

                // Validate that saved attribute matches current CALCULATED_OCCUPANCY
                const savedAttrId = data.attribute.replace(/#/g, '');
                const currentAttrId = fieldContent.querySelector('.occupancy-attribute-id')?.value;

                if (savedAttrId !== currentAttrId) {
                    console.warn(`Saved occupancy attribute (${savedAttrId}) differs from current CALCULATED_OCCUPANCY (${currentAttrId}). Using current attribute.`);
                    // Auto-update to use current attribute (will be saved on next save)
                }

                // Set operator and value (only if inputs exist - they won't if unavailable)
                const operatorSelect = fieldContent.querySelector('.operator-select');
                const valueInput = fieldContent.querySelector('.value-input');

                if (operatorSelect) operatorSelect.value = data.operator;
                if (valueInput) valueInput.value = data.value;
            } else if (key === 'eventScore') {
                fieldContent.querySelector('.operator-select').value = data.operator;
                fieldContent.querySelector('.value-input').value = data.value;
            } else if (key === 'propertyRanking') {
                // fieldContent.querySelector('.property-type-select').value = data.type;
                const propertyTypeSelect = fieldContent.querySelector('.property-type-select');
                const propertyValueInput = fieldContent.querySelector('.value-input');
                if (propertyTypeSelect && data.type) {
                    const templateId = data.type.replace(/#/g, '');
                    propertyTypeSelect.value = templateId;
                    // Set max based on comp count for this template
                    if (propertyValueInput) {
                        const compCount = getCompCountForTemplate(templateId);
                        propertyValueInput.max = compCount;
                    }
                }
                const rankDirectionSwitch = fieldContent.querySelector('.rank-direction-switch');
                if (rankDirectionSwitch) {
                    rankDirectionSwitch.checked = (data.rankDirection === 'top');
                }
                fieldContent.querySelector('.operator-select').value = data.operator;
                propertyValueInput.value = data.value;
            }
        }
    }

    // if (conditionData.expression) {
    //     conditionElement.querySelector('.expression-textarea').value = conditionData.expression;
    // }
    if (conditionData.expression) {
        // --- THIS IS THE CHANGE ---
        // Convert the stored expression (with IDs) back to a user-friendly expression (with names)
        const displayExpression = convertExpressionIdsToNames(conditionData.expression);
        conditionElement.querySelector('.expression-textarea').value = displayExpression;
    }
}

/**
 * Converts an expression string with attribute names to one with attribute IDs.
 * e.g., "#Comp Set Rate# + 10" becomes "#ATTR_101# + 10"
 * @param {string} expression - The expression string with names.
 * @returns {string} The expression string with IDs.
 */
function convertExpressionNamesToIds(expression) {
    if (!expression || !dynamicData.attributes) return expression;

    // Skip conversion for plain text
    if (expression.startsWith('~') && expression.endsWith('~') && !expression.startsWith('~~')) {
        return expression;
    }

    // Create a quick lookup map of Name -> ID
    const nameToIdMap = new Map(dynamicData.attributes.map(attr => [attr.name, attr.id]));

    return expression.replace(/#([^#]+)#/g, (match, attributeName) => {
        const foundId = nameToIdMap.get(attributeName);
        return foundId ? `#${foundId}#` : match; // If not found, leave it as is
    });
}

/**
 * Converts an expression string with attribute IDs to one with attribute names.
 * e.g., "#ATTR_101# + 10" becomes "#Comp Set Rate# + 10"
 * e.g., "#STRAT_123# + 10" becomes "#Strategy Name (Strategy||Strategy)# + 10"
 * @param {string} expression - The expression string with IDs.
 * @returns {string} The expression string with names.
 */
function convertExpressionIdsToNames(expression) {
    if (!expression) return expression;

    // Skip conversion for plain text
    if (expression.startsWith('~') && expression.endsWith('~') && !expression.startsWith('~~')) {
        return expression;
    }

    // If dynamicData.attributes is not loaded yet, return as-is with warning
    if (!dynamicData.attributes || dynamicData.attributes.length === 0) {
        console.warn('convertExpressionIdsToNames: dynamicData.attributes not loaded yet, returning expression as-is:', expression);
        return expression;
    }

    // Create a quick lookup map of ID -> Name
    const idToNameMap = new Map(dynamicData.attributes.map(attr => [attr.id, attr.name]));

    // Debug logging for strategy references
    const hasStrategyRef = expression.includes('STRAT_');
    if (hasStrategyRef) {
        console.log('Converting expression with strategy reference:', expression);
        console.log('Available attribute IDs:', Array.from(idToNameMap.keys()));
    }

    const result = expression.replace(/#([^#]+)#/g, (match, attributeId) => {
        const foundName = idToNameMap.get(attributeId);

        if (!foundName) {
            console.warn(`convertExpressionIdsToNames: Could not find name for ID "${attributeId}" in dynamicData.attributes`);
            console.warn('Available IDs:', Array.from(idToNameMap.keys()).join(', '));
            return match; // Leave as-is if not found
        }

        return `#${foundName}#`;
    });

    if (hasStrategyRef) {
        console.log('Conversion result:', result);
    }

    return result;
}


/**
 * Generates a formatted timestamp string for copied items.
 * @returns {string} Formatted timestamp e.g., "2025-10-14 17:59"
 */
function generateTimestamp() {
    const d = new Date();
    const pad = (n) => n.toString().padStart(2, '0');
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}


/**
 * Gets the data object for a single condition element.
 * This is an adaptation of the logic within getRegionData.
 * @param {HTMLElement} cond - The condition-group element.
 * @returns {object} The data object for the condition.
 */
function getConditionData(cond) {
    const isActive = !!cond.querySelector('.field-checkbox:checked') || cond.querySelector('.expression-textarea').value.trim() !== '';
    if (!isActive) return null;

    const conditionData = {
        id: cond.id,
        name: cond.querySelector('.title-display').textContent.trim(),
        sequence: parseInt(cond.dataset.sequence, 10)
    };
        
    const occupancyCheckbox = cond.querySelector(`#${cond.id}-occupancy-threshold`);
    if (occupancyCheckbox?.checked && !occupancyCheckbox.disabled) {
        const occupancyAttrId = cond.querySelector('.occupancy-attribute-id')?.value;

        if (!occupancyAttrId) {
            console.warn('No CALCULATED_OCCUPANCY attribute found for this hotel');
            // Skip this condition if attribute is not available
        } else {
            conditionData.occupancyThreshold = {
                attribute: `#${occupancyAttrId}#`,
                operator: cond.querySelector('.occupancy-operator').value,
                value: parseFloat(cond.querySelector('.occupancy-value').value)
            };
        }
    }
    if (cond.querySelector(`#${cond.id}-property-ranking`)?.checked) {
        const val = cond.querySelector('.property-value').value;
        const rankDirection = cond.querySelector('.rank-direction-switch')?.checked ? 'top' : 'bottom';
        conditionData.propertyRanking = {
            type: `#${cond.querySelector('.property-type').value}#`,
            operator: cond.querySelector('.property-operator').value,
            value: isNaN(parseInt(val, 10)) ? val : parseInt(val, 10),
            rankDirection: rankDirection
        };
    }
    if (cond.querySelector(`#${cond.id}-event-score`)?.checked) {
        conditionData.eventScore = { 
            operator: cond.querySelector('.event-operator').value, 
            value: parseFloat(cond.querySelector('.event-value').value) 
        };
    }
        
    const expression = cond.querySelector('.expression-textarea').value.trim();
    if (expression) {
        conditionData.expression = convertExpressionNamesToIds(expression);
    }

    return conditionData;
}

// ============================================================================
// CSS Styles for Occupancy Disabled State
// ============================================================================
(function injectOccupancyStyles() {
    const styleId = 'occupancy-disabled-styles';

    // Check if styles already exist
    if (document.getElementById(styleId)) {
        return;
    }

    const style = document.createElement('style');
    style.id = styleId;
    style.textContent = `
        /* Disabled field container styling */
        .field-container.disabled-field {
            opacity: 0.6;
            pointer-events: none;
        }

        .field-container.disabled-field label {
            color: #999;
            cursor: not-allowed;
        }

        /* Unavailable badge styling */
        .unavailable-badge {
            display: inline-block;
            margin-left: 0.5rem;
            padding: 0.15rem 0.5rem;
            background: #ffc107;
            color: #000;
            font-size: 0.75em;
            font-weight: bold;
            border-radius: 3px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Unavailable message styling */
        .unavailable-message {
            padding: 0.75rem;
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 4px;
            color: #856404;
            line-height: 1.4;
        }

        .unavailable-message strong {
            display: block;
            margin-bottom: 0.5rem;
            font-size: 1em;
        }

        .unavailable-message p {
            margin: 0;
            font-size: 0.9em;
        }

        /* Occupancy info text styling */
        .occupancy-info {
            display: block;
            font-size: 0.85em;
            color: #666;
            margin-top: 0.5rem;
            font-style: italic;
        }

        /* Rank direction toggle switch styling */
        .rank-direction-toggle {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            cursor: pointer;
            margin-left: 10px;
            vertical-align: middle;
        }

        .rank-direction-toggle .toggle-label-left,
        .rank-direction-toggle .toggle-label-right {
            font-size: 0.85em;
            color: #888;
            transition: color 0.2s;
            display: inline-block;
            width: 42px;
            text-align: center;
        }

        .rank-direction-toggle .toggle-slider {
            position: relative;
            width: 36px;
            height: 18px;
            background: #aaa;
            border-radius: 18px;
            transition: background 0.2s;
        }

        .rank-direction-toggle .toggle-slider::before {
            content: '';
            position: absolute;
            top: 2px;
            left: 2px;
            width: 14px;
            height: 14px;
            background: white;
            border-radius: 50%;
            transition: transform 0.2s;
        }

        .rank-direction-toggle .rank-direction-switch {
            display: none;
        }

        .rank-direction-toggle .rank-direction-switch:checked + .toggle-slider {
            background: #ffc107;
        }

        .rank-direction-toggle .rank-direction-switch:checked + .toggle-slider::before {
            transform: translateX(18px);
        }

        /* When checked (Top selected): gray out Bottom, highlight Top */
        .rank-direction-toggle:has(.rank-direction-switch:checked) .toggle-label-left {
            color: #666;
            font-weight: normal;
        }

        .rank-direction-toggle:has(.rank-direction-switch:checked) .toggle-label-right {
            color: #ffc107;
            font-weight: bold;
        }

        /* When unchecked (Bottom selected): gray out Top, highlight Bottom */
        .rank-direction-toggle:has(.rank-direction-switch:not(:checked)) .toggle-label-right {
            color: #666;
            font-weight: normal;
        }

        .rank-direction-toggle:has(.rank-direction-switch:not(:checked)) .toggle-label-left {
            color: #ccc;
            font-weight: bold;
        }
    `;

    document.head.appendChild(style);
})();