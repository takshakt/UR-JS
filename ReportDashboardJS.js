// Tab management variables
let currentTabId = null;
let tabCounter = 0;
let tabData = {};
let parsedTabsData = {};
let formula_filterJSON_global;
let isHotelLovLoading = false;
let currentlyEditingTabId = null;


//--- Varun test code --------
function syncHotelFromGlobal() {
    console.log('[RunReports] Syncing hotel from global LOV...');

    let globalLov = document.getElementById('P0_HOTEL_ID');
    let pageLov = document.getElementById('static-lov-hotel');

    if (!globalLov || !pageLov) {
        console.warn('Hotel LOV not found.');
        return;
    }

    let selectedOption = globalLov.options[globalLov.selectedIndex];
    pageLov.value = selectedOption.value; // set LOV VALUE

    // If you want text also stored:
    pageLov.setAttribute('data-text', selectedOption.text);

    console.log('[RunReports] Set hotel to:', selectedOption.text, selectedOption.value);
}
//--- end -----

function populateHotelLov() { 
    if (isHotelLovLoading) {
        console.log("Already loading, skipping...");
        return;
    }
    isHotelLovLoading = true;

    apex.server.process(
        'AJX_GET_REPORT_HOTEL', 
        {x01: 'HOTEL'},
        {
           success: function(pData) {
                var selectList = $('#static-lov-hotel');
                selectList.empty();
                selectList.append('<option value="">Select Hotel</option>');

                if (Array.isArray(pData)) {
                    $.each(pData, function(index, item) {
                        var option = $('<option></option>')
                            .attr('value', item.ID)
                            .text(item.HOTEL_NAME);
                        selectList.append(option);
                    });
                }

                // -------- AUTO SELECT HOTEL FROM GLOBAL LOV --------
                var globalHotelId = $('#P0_HOTEL_ID').val();
                if (globalHotelId) {
                    console.log('[AUTO-SET HOTEL] Using global hotel:', globalHotelId);

                    if (selectList.find("option[value='" + globalHotelId + "']").length) {
                        selectList.val(globalHotelId);
                        console.log('[AUTO-SET HOTEL] Matched in LOV, triggering change...');
                        selectList.trigger('change');   // Load reports + dashboard
                    } else {
                        console.warn('[AUTO-SET HOTEL] Global hotel not found in LOV');
                    }
                } else {
                    console.log('[AUTO-SET HOTEL] No global hotel found.');
                }

                isHotelLovLoading = false;
           },
           error: function() {
               isHotelLovLoading = false;
           }
        }
    );
}



// ----------------- PAGE LOAD -----------------
document.addEventListener("DOMContentLoaded", function() {
    console.log("Page loaded → populateHotelLov()");
    populateHotelLov();   // This will also auto-select and trigger .change()
});



// ----------------- HOTEL CHANGE -----------------
$('#static-lov-hotel').on('change', function() {

    var selectedHotelId = $(this).val();
    console.log('-----Hotellov change call:>>> ' + selectedHotelId);

    if (selectedHotelId) {
        apex.server.process(
            'AJX_GET_REPORT_HOTEL', 
            {
                x01: 'REPORT',
                x02: selectedHotelId
            },
            {
                success: function(pData) {
                    console.log('AJAX call successful!', pData);

                    var selectList = $('#static-lov-report');
                    selectList.empty();
                    selectList.append('<option value="">Select Report</option>');

                    if (Array.isArray(pData)) {
                        $.each(pData, function(index, item) {
                            console.log('Inside LOV:> ', item.REPORT_NAME);
                            var option = $('<option></option>')
                                .attr('value', item.ID)
                                .text(item.REPORT_NAME);
                            selectList.append(option);
                        });
                    }

                    // Auto load dashboard after report LOV loads
                    call_dashboard_data(selectedHotelId);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error("AJAX Error: " + textStatus + " - " + errorThrown);
                }
            }
        );
    }

    else {
        var selectList = $('#static-lov-report');
        selectList.empty();
        selectList.append('<option value="">Select Report</option>');
        reportID = null;
        clearAllTabs();
    }
});


function call_dashboard_data(selectedHotel_Id){
    clearAllTabs();

    apex.server.process(
        'AJX_MANAGE_REPORT_DASHBOARD', 
        {
            x01: 'SELECT',
            x02: selectedHotel_Id
        },
        {
            success: function(pData) {
                console.log('AJX_MANAGE_REPORT_DASHBOARD call successful!', pData);

                // parse payload safely
                let tabsData;
                try {
                    tabsData = JSON.parse(pData[0].l_payload);
                } catch (err) {
                    console.error('Failed to parse tabs payload:', err, pData);
                    return;
                }

                console.log('Parsed tabs data (raw):', tabsData);

                // store globally so other handlers (drop, save) can access it
                parsedTabsData = tabsData;

                // Ensure tabs array exists
                if (!parsedTabsData.tabs) parsedTabsData.tabs = [];

                // Sort tabs by saved position (if present) so UI renders in stored order
                parsedTabsData.tabs.sort((a, b) => (a.position || 0) - (b.position || 0));
                console.log('Parsed tabs data (sorted):', parsedTabsData);

                /* 
                 * Use your existing functions that create DOM tabs + content.
                 * You said renderTabs doesn't exist — use recreateTabsFromJSON which you have.
                 */
                recreateTabsFromJSON(parsedTabsData);

                // repopulate LOVs / other UI
                populateReportLOVFromTabsData(parsedTabsData);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("AJAX Error: " + textStatus + " - " + errorThrown);
            }
        }
    );
}


// Function to clear all existing tabs
function clearAllTabs() {
    console.log('Clearing all tabs...');
    
    // Remove all tab headers except the add-tab-div
    const tabsHeader = document.getElementById('tabs-header');
    if (tabsHeader) {
        const tabs = tabsHeader.querySelectorAll('.tab');
        tabs.forEach(tab => tab.remove());
    }
    
    // Remove all tab contents
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(tabContent => tabContent.remove());
    
    // Reset tab data
    tabData = {};
    tabCounter = 0;
    currentTabId = null;
}


function recreateTabsFromJSON(jsonData) {
    console.log('Recreating tabs from JSON:', jsonData);
    
    if (!jsonData) {
        console.error('Invalid JSON data for tab recreation');
        return;
    }
    
    if (jsonData.report_id) {
        reportID = jsonData.report_id;
    }
    
    if (jsonData.tabs && Array.isArray(jsonData.tabs)) {
        // Create tabs from JSON tabs array
        jsonData.tabs.forEach((tabInfo, index) => {
            createTabFromData(tabInfo, index, jsonData);
           
        });
    } else {
        // If no tabs array, create a single tab from the main JSON
        console.log('No tabs array found, creating single tab from main data');
        createTabFromData(jsonData, Date.now(), jsonData);
    }
    
    // Activate the first tab if any exist
    const firstTabId = Object.keys(tabData)[0];
    if (firstTabId) {
        switchTab(firstTabId);
    }
    
    console.log('Tab recreation completed. Total tabs:', Object.keys(tabData).length);
}

function createTabFromData(tabInfo, index, mainJsonData) {
    const tabNumber = index + 1;
    tabCounter = Math.max(tabCounter, tabNumber);

    const tabId = tabInfo.tab_id || `Report${tabNumber}`;
    const tabName = tabInfo.tab_name || `Report ${tabNumber}`;
    const tabReportId = tabInfo.report_id || mainJsonData.report_id;
    const tabHotelId = tabInfo.hotel_id || mainJsonData.hotel_id;

    // 🟢 FIXED: define tabPosition BEFORE using it
    const tabPosition = tabInfo.position || tabNumber;

    console.log('Creating tab:', tabId, tabName, tabReportId, '→ position:', tabPosition);

    // --- Create tab header ---
    const tabsHeader = document.getElementById('tabs-header');
    const addTabDiv = document.getElementById('add-tab-div');

    const newTab = document.createElement('div');
    newTab.className = 'tab';
    newTab.setAttribute('data-tab', tabId);

    // 🟢 Make tab draggable for reordering
    newTab.setAttribute('draggable', 'true');
    // 🟢 Store position in DOM dataset for debugging
    newTab.dataset.position = tabPosition;

    newTab.innerHTML = `${tabName} <span class="tab-close" data-tab="${tabId}">×</span>`;

    tabsHeader.insertBefore(newTab, addTabDiv);

    // --- Create tab content ---
    const container = document.querySelector('.container');
    const newTabContent = document.createElement('div');
    newTabContent.className = 'tab-content';
    newTabContent.id = tabId;
    newTabContent.innerHTML = generateTabContent();
    container.appendChild(newTabContent);

    // --- Initialize tab data ---
    tabData[tabId] = {
        tableData: null,
        savedFormulas: {},
        currentFormulaName: '',
        displayName: tabName,
        reportId: tabReportId,
        hotelId: tabHotelId,
        position: tabPosition,          // 🟢 Save in memory
        originalData: tabInfo
    };

    // --- Load data if reportId exists ---
   // if (tabReportId) {
       // loadReportDataForTab(tabId, tabReportId);
   // }

    // --- Setup tab events ---
    setupTabEventListeners(tabId);
}



function populateReportLOVFromTabsData(tabsData) {
    console.log('Populating report LOV from tabs data:', tabsData);
    
    const selectList = $('#static-lov-report');
    selectList.empty();
    selectList.append('<option value="">Select Report</option>');
    
    if (tabsData && tabsData.report_id) {
        // Set the report ID from the tabs data
        reportID = tabsData.report_id;
        
        // We need to get the report name - you might need to modify this
        // based on what data you have available
        apex.server.process(
            'AJX_GET_REPORT_HOTEL',
            {
                x01: 'REPORT',
                x02: tabsData.hotel_id
            },
            {
                success: function(reportData) {
                    if (Array.isArray(reportData)) {
                        reportData.forEach(function(item) {
                            if (item.ID === tabsData.report_id) {
                                const option = $('<option></option>')
                                    .attr('value', item.ID)
                                    .text(item.REPORT_NAME)
                                    .prop('selected', true);
                                selectList.append(option);
                            }
                        });
                    }
                }
            }
        );
    }
}

// Regular report LOV population (fallback)
function populateReportLOVRegular(pData) {
    var selectList = $('#static-lov-report');
    selectList.empty();
    selectList.append('<option value="">Select Report</option>');
    
    $.each(pData, function(index, item) {
        var option = $('<option></option>')
            .attr('value', item.ID)
            .text(item.REPORT_NAME);
        selectList.append(option);
    });
}


// ------ varun test code
document.addEventListener("DOMContentLoaded", function () {
    // console.log('[RunReports] DOM Ready → syncing hotel and loading reports');

    // syncHotelFromGlobal();

    // populateHotelLov();

    // // Trigger report + dashboard load automatically
    // setTimeout(() => {
    //     $('#static-lov-hotel').trigger('change');
    // }, 300);

    // When GLOBAL LOV changes
    document.addEventListener('change', function (e) {
        if (e.target.id === 'P0_HOTEL_ID') {
            console.log('[RunReports] Global LOV changed → updating');
            syncHotelFromGlobal();

            setTimeout(() => {
                $('#static-lov-hotel').trigger('change');
            }, 300);
        }
    });
});


// ---end


var reportID;
// Listen for the 'change' event on the report LOV
$('#static-lov-report').on('change', function() {
    // Get the value (ID) of the selected option
    var selectedReportId = $(this).val();
reportID = $(this).val();
    // Log the ID to the browser's console
    console.log("Selected Report ID:", selectedReportId);
});


    // Setup tab functionality
    function setupTabs() {
                console.log('Setting up tabs...');
                
                // Add new tab div (not button)
                const addTabDiv = document.getElementById('add-tab-div');
                if (addTabDiv) {
                    addTabDiv.addEventListener('click', showNewTabModal);
                    
                    // Prevent any default behavior that might cause page refresh
                    addTabDiv.addEventListener('mousedown', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                    });
                    
                    addTabDiv.addEventListener('click', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                    });
                }
            

            let clickTimer = null;
            const tabsHeader = document.getElementById('tabs-header');

                if (tabsHeader) {

                    tabsHeader.addEventListener('click', function (e) {
                        e.preventDefault();
                        e.stopPropagation();

                        if (clickTimer !== null) {
                            // Detected a double-click → clear single click
                            clearTimeout(clickTimer);
                            clickTimer = null;
                            handleDoubleClick(e);
                        } else {
                            // Wait a bit to confirm if double-click will occur
                            clickTimer = setTimeout(() => {
                                handleSingleClick(e);
                                clickTimer = null;
                            }, 250); // adjust delay if needed
                        }
                    });

                    // ✅ SINGLE CLICK HANDLER
                    function handleSingleClick(e) {
                        console.log('Tab header single-clicked:', e.target);

                        // Handle tab click
                        if (e.target.classList.contains('tab')) {
                            const tabId = e.target.getAttribute('data-tab');
                            if (tabId) switchTab(tabId);
                        }
                        // Handle tab close click
                        else if (e.target.classList.contains('tab-close')) {
                            const tabId = e.target.getAttribute('data-tab');
                            if (tabId) closeTab(tabId);
                        }
                        // Handle click on tab text (child element)
                        else if (e.target.parentElement?.classList.contains('tab')) {
                            const tabId = e.target.parentElement.getAttribute('data-tab');
                            if (tabId) switchTab(tabId);
                        }
                    }

                    // ✅ DOUBLE CLICK HANDLER
                    function handleDoubleClick(e) {
                        const tabEl = e.target.closest('.tab');
                        if (!tabEl || tabEl.id === 'add-tab-div') return;

                        const tabId = tabEl.dataset.tab;
                        const selectedTab = parsedTabsData.tabs.find(t => t.tab_id === tabId);

                        if (!selectedTab) {
                            console.error("❌ Tab data missing for:", tabId);
                            return;
                        }

                        console.log("🟢 Double-click update:", selectedTab);
                        console.log("🟢 Double-click update Report ID:", selectedTab.report_id);

                        // ✅ SAVE selected tab data globally so LOV can access it later
                       
                        window.UPDATE_TAB_DATA = selectedTab;
                        // ✅ Open existing modal
                        showNewTabModal();

                        // ✅ Pre-fill modal fields immediately
                        document.getElementById("tab-name-input").value = selectedTab.tab_name || "";
                        setTimeout(() => {
                            $('#popup-report-lov').val(selectedTab.report_id).trigger('change');
                            console.log("✅ Set report ID after delay:", selectedTab.report_id);
                        }, 200);
                         window.UPDATE_TAB_DATA = selectedTab;
                    }

                }




    // --- Drag and Drop for Tab Reordering (fixed '+ New Report' at end) ---
    const tabsHeaderEl = document.getElementById('tabs-header');
    if (tabsHeaderEl) {
        let draggedTab = null;
        const addTabDiv = document.getElementById('add-tab-div'); // + New Report tab

        // Make all tabs draggable except "+ New Report"
        function makeTabsDraggable() {
            tabsHeaderEl.querySelectorAll('.tab').forEach(tab => {
                if (tab.id === 'add-tab-div' || tab === addTabDiv) {
                    tab.removeAttribute('draggable');
                } else {
                    tab.setAttribute('draggable', 'true');
                }
            });
        }
        makeTabsDraggable();

        // Observe for new tabs being added dynamically
        const observer = new MutationObserver(makeTabsDraggable);
        observer.observe(tabsHeaderEl, { childList: true });

        tabsHeaderEl.addEventListener('dragstart', (e) => {
            const target = e.target.closest('.tab');
            if (!target || target === addTabDiv) return; // don't drag +New Report
            draggedTab = target;
            target.classList.add('dragging');
            e.dataTransfer.effectAllowed = 'move';
            e.dataTransfer.setData('text/plain', target.dataset.tab);
        });

        tabsHeaderEl.addEventListener('dragover', (e) => {
            e.preventDefault();
            const afterElement = getDragAfterElement(tabsHeaderEl, e.clientX);
            const dragging = document.querySelector('.dragging');
            if (!dragging) return;

            // Don't allow dropping after +New Report
            if (afterElement == null || afterElement === addTabDiv) {
                tabsHeaderEl.insertBefore(dragging, addTabDiv);
            } else {
                tabsHeaderEl.insertBefore(dragging, afterElement);
            }
        });

        tabsHeaderEl.addEventListener('drop', (e) => {
    e.preventDefault();
    if (draggedTab) {
        draggedTab.classList.remove('dragging');
        draggedTab = null;
    }

    // 🟢 Get updated tab order
    const newOrder = [];
    document.querySelectorAll('#tabs-header .tab').forEach((tab, index) => {
        // Skip the +New Report tab
        if (tab.id !== 'add-tab-div') {
            newOrder.push({
                tab_id: tab.dataset.tab,
                position: index + 1
            });
        }
    });

    console.log('🟢 New tab order:', newOrder);

    // 🟢 Update your existing parsedTabsData JSON with the new positions
    parsedTabsData.tabs.forEach(tab => {
        const match = newOrder.find(o => o.tab_id === tab.tab_id);
        if (match) {
            tab.position = match.position;
        }
    });

    // 🟢 Log the final JSON before saving
    console.log('💾 Updated parsedTabsData:', parsedTabsData);

    const hotelIdToUse = parsedTabsData.hotel_id || $('#static-lov-hotel').val();

apex.server.process(
  'AJX_MANAGE_REPORT_DASHBOARD',
  {
    x01: 'INSERT',
    x02: hotelIdToUse,
    x03: JSON.stringify(parsedTabsData)
  },
  {
    success: function(pData) {
      console.log('✅ Tab order saved successfully for hotel:', hotelIdToUse);
      console.log('Server response:', pData);
    },
    error: function(jqXHR, textStatus, errorThrown) {
      console.error('❌ Error saving tab order:', textStatus, errorThrown);
    }
  }
);

});


        tabsHeaderEl.addEventListener('dragend', (e) => {
            if (e.target.classList.contains('tab')) {
                e.target.classList.remove('dragging');
                console.log('tabsHeaderEl323232:>>>>',tabsHeaderEl);
            }
        });

        console.log('tabsHeaderEl:>>>>',tabsHeaderEl);

        // Utility: find nearest element for insertion
        function getDragAfterElement(container, x) {
            const draggableElements = [...container.querySelectorAll('.tab:not(.dragging):not(#add-tab-div)')];
            return draggableElements.reduce((closest, child) => {
                const box = child.getBoundingClientRect();
                const offset = x - box.left - box.width / 2;
                if (offset < 0 && offset > closest.offset) {
                    return { offset: offset, element: child };
                } else {
                    return closest;
                }
            }, { offset: Number.NEGATIVE_INFINITY }).element;
        }

        function saveTabOrder() {
    // Get current order of tab IDs
    const orderedTabs = [...tabsHeaderEl.querySelectorAll('.tab')]
        .filter(tab => tab !== addTabDiv)
        .map((tab, index) => ({
            tab_id: tab.dataset.tab,
            position: index + 1
        }));

    console.log('Saving tab order:', orderedTabs);

    // Get the existing definition JSON (already stored client-side)
    let currentDef = JSON.parse(localStorage.getItem('parsedTabsData') || '{}');

    if (currentDef.tabs && currentDef.tabs.length > 0) {
        currentDef.tabs.forEach(t => {
            const found = orderedTabs.find(o => o.tab_id === t.tab_id);
            if (found) t.position = found.position;
        });

        // Optional: sort JSON array by position
        currentDef.tabs.sort((a, b) => a.position - b.position);
    }

    // Update localStorage for faster reloads
    localStorage.setItem('parsedTabsData', JSON.stringify(currentDef));

    // 🔵 Send updated DEFINITION back to APEX (same process)
    apex.server.process(
        'AJX_MANAGE_REPORT_DASHBOARD',
        {
            x01: 'INSERT', // same branch as used for saving
            x02: currentDef.hotel_id,
            x03: JSON.stringify(currentDef)
        },
        {
            success: function(pData) {
                console.log('Tab order updated successfully on server.');
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("AJAX Error while saving order: " + textStatus + " - " + errorThrown);
            }
        }
    );
}

}



    // Modal event listeners
    setupModalEventListeners();
}

function setupModalEventListeners() {
    // Close modal when clicking X
    document.querySelector('.close-modal').addEventListener('click', hideNewTabModal);
    
    // Close modal when clicking cancel
    document.getElementById('cancel-new-tab').addEventListener('click', hideNewTabModal);
    
document.getElementById('save-new-tab').addEventListener('click', function(e) {

    e.preventDefault();
    e.stopPropagation();

    const tabName = document.getElementById('tab-name-input').value.trim();
    const selectedReportId = document.getElementById('popup-report-lov').value;
    const selectedHotelId = document.getElementById('static-lov-hotel').value;

    if (!tabName) return alert('Please enter a tab name!');
    if (!selectedReportId) return alert('Please select a report!');
    if (!selectedHotelId) return alert('Please select a hotel!');

    // ✅ UPDATE MODE (double-clicked tab)
    if (window.UPDATE_TAB_DATA) {

        const tabObj = window.UPDATE_TAB_DATA;

        console.log("🟡 Updating tab:", tabObj);

        // Update values inside parsedTabsData
       // tabObj.tab_name = tabName;
       // tabObj.report_id = selectedReportId;
       if (tabData[tabObj.tab_id]) {
            tabData[tabObj.tab_id].displayName = tabName;
            tabData[tabObj.tab_id].reportId = selectedReportId;
        }


        // Update UI tab text
        const tabEl = document.querySelector(`.tab[data-tab="${tabObj.tab_id}"]`);
        if (tabEl) {
            tabEl.childNodes[0].textContent = tabName + " ";
        }
        
        
             parsedTabsData = { ...parsedTabsData };

            // Loop through tabs and update only the matching one
            parsedTabsData.tabs = parsedTabsData.tabs.map(tab => {
            if (tab.tab_id === window.UPDATE_TAB_DATA.tab_id) {
                return {
                ...tab,
                tab_name: tabName,
                report_id: selectedReportId
                };
            }
            return tab;
            });



    console.log('parsedTabsData:>>>>>>>>>',parsedTabsData);
        // Save JSON back to DB
        apex.server.process(
            'AJX_MANAGE_REPORT_DASHBOARD',
            { x01: 'INSERT', x02: selectedHotelId, x03: JSON.stringify(parsedTabsData) },
            {
                success: function() { console.log("✅ Updated tab saved."); },
                error: function(err) { console.error("❌ Update failed:", err); }
            }
        );

        
        hideNewTabModal();
        loadReportDataForTab(window.UPDATE_TAB_DATA.tab_id, selectedReportId);
        window.UPDATE_TAB_DATA = null;
        return false;
    }
    else{
        // ✅ CREATE MODE (new report)
        const tabsData = JSON.stringify(generateTabsJSON(selectedHotelId, selectedReportId, tabName));
      //  const tabsData = JSON.stringify(parsedTabsData);

        apex.server.process(
            'AJX_MANAGE_REPORT_DASHBOARD',
            { x01: 'INSERT', x02: selectedHotelId, x03: tabsData },
            { success: function(){

                // Create the new tab in UI
            addNewTab(null, tabName, selectedReportId);
        
            }, error: function(e){console.error(e);} }
        );

        

        hideNewTabModal();
        return false;
    }
});

    
    // Close modal when clicking outside
    document.getElementById('newTabModal').addEventListener('click', function(e) {
        if (e.target === this) {
            hideNewTabModal();
        }
    });
}

function generateTabsJSON(hotelId, reportId, newTabName) {
    const tabsJSON = {
        hotel_id: hotelId,
        report_id: reportId,
        tabs: []
    };

    // ✅ Use parsedTabsData.tabs instead of tabData
    if (parsedTabsData.tabs && Array.isArray(parsedTabsData.tabs)) {
        parsedTabsData.tabs.forEach(tab => {
            tabsJSON.tabs.push({
                tab_id: tab.tab_id,
                tab_name: tab.tab_name,
                report_id: tab.report_id,
                hotel_id: hotelId,
                position: tab.position
            });
        });
    }

    // ✅ Add the new tab ONLY in create mode
    tabsJSON.tabs.push({
        tab_id: `Report${Date.now() + 1}`,
        tab_name: newTabName,
        report_id: reportId,
        hotel_id: hotelId,
        position: tabsJSON.tabs.length + 1,
        is_new: true
    });

    return tabsJSON;
}


function generateTabsJSON_delete(hotelId, reportId) {
    const tabsJSON = {
        hotel_id: hotelId,
        report_id: reportId,
        tabs: []
    };
    
    // Add all existing tabs
    Object.keys(tabData).forEach(tabId => {
        const tab = tabData[tabId];
        tabsJSON.tabs.push({
            tab_id: tabId,
            tab_name: tab.displayName || tabId,
            report_id: tab.reportId || reportId,
            hotel_id: hotelId
        });
    });
    
   
    
    return tabsJSON;
}

function populatePopupReportLov() {
    const popupLov = document.getElementById('popup-report-lov');
    const selectedHotelId = document.getElementById('static-lov-hotel').value;
    
    if (!selectedHotelId) {
        popupLov.innerHTML = '<option value="">Please select a hotel first</option>';
        return;
    }
    
    // Show loading state
    popupLov.innerHTML = '<option value="">Loading reports...</option>';
    
    // Fetch reports for the selected hotel
    apex.server.process(
        'AJX_GET_REPORT_HOTEL', 
        {
            x01: 'REPORT',
            x02: selectedHotelId
        },
        {
            success: function(pData) {
                console.log('Reports fetched for popup LOV:', pData);
                
                // Clear existing options
                popupLov.innerHTML = '<option value="">Select Report</option>';
                
                if (Array.isArray(pData)) {
                    pData.forEach(function(item) {
                        const option = document.createElement('option');
                        option.value = item.ID;
                        option.textContent = item.REPORT_NAME;
                        popupLov.appendChild(option);
                    });
                    
                    // If there's a current reportID, select it
                    /*if (reportID) {
                        popupLov.value = reportID;*/
                        // ✅ If we are updating an existing tab
if (window.UPDATE_TAB_DATA && window.UPDATE_TAB_DATA.report_id) {
    popupLov.value = window.UPDATE_TAB_DATA.report_id;


                    }
                } else {
                    popupLov.innerHTML = '<option value="">No reports available</option>';
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("Error fetching reports for popup LOV:", textStatus, errorThrown);
                popupLov.innerHTML = '<option value="">Error loading reports</option>';
            }
        }
    );
}

// New function to populate popup LOV with all reports
function populatePopupReportLovWithAllReports() {
    const popupLov = document.getElementById('popup-report-lov');
    const selectedHotelId = document.getElementById('static-lov-hotel').value;
    
    if (!selectedHotelId) {
        alert('Please select a hotel first!');
        return;
    }
    
    // Fetch reports for the selected hotel
    apex.server.process(
        'AJX_GET_REPORT_HOTEL', 
        {
            x01: 'REPORT',
            x02: selectedHotelId
        },
        {
            success: function(pData) {
                console.log('Reports fetched for popup LOV:', pData);
                
                // Clear existing options
                popupLov.innerHTML = '<option value="">Select Report</option>';
                
                if (Array.isArray(pData)) {
                    pData.forEach(function(item) {
                        const option = document.createElement('option');
                        option.value = item.ID;
                        option.textContent = item.REPORT_NAME;
                        popupLov.appendChild(option);
                    });
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("Error fetching reports for popup LOV:", textStatus, errorThrown);
            }
        }
    );
}


function showNewTabModal() {

    // ✅ VERY IMPORTANT: Reset update mode when opening modal normally
    window.UPDATE_TAB_DATA = null;

    const selectedHotelId = document.getElementById('static-lov-hotel').value;

    if (!selectedHotelId) {
        alert('Please select a hotel first!');
        return;
    }

    // Populate the popup report LOV
    populatePopupReportLov();

    // Set default tab name
    document.getElementById('tab-name-input').value = `Report ${Date.now() + 1}`;

    // Show modal
    document.getElementById('newTabModal').style.display = 'flex';
}


function hideNewTabModal() {
    document.getElementById('newTabModal').style.display = 'none';
}


// Add new tab with modal
function addNewTab(e, tabName = null, selectedReportId = null) {
    if (reportID != null || selectedReportId != null) {
        if (e) {
            e.preventDefault();
            e.stopPropagation();
        }

        tabCounter++;
        const newTabId = `Report${Date.now()}`;
        const displayName = tabName || `Report ${Date.now()}`;
        const reportIdToUse = selectedReportId || reportID;
        const hotelIdToUse = parsedTabsData.hotel_id || $('#static-lov-hotel').val();

        console.log('Adding new tab:', newTabId, displayName, reportIdToUse);

        // 🟢 Create DOM element
        const tabsHeader = document.getElementById('tabs-header');
        const addTabDiv = document.getElementById('add-tab-div');
        const newTab = document.createElement('div');
        newTab.className = 'tab';
        newTab.setAttribute('data-tab', newTabId);
        newTab.setAttribute('draggable', 'true'); // draggable
        newTab.innerHTML = `${displayName} <span class="tab-close" data-tab="${newTabId}">×</span>`;
        tabsHeader.insertBefore(newTab, addTabDiv);

        // 🟢 Create tab content
        const container = document.querySelector('.container');
        const newTabContent = document.createElement('div');
        newTabContent.className = 'tab-content';
        newTabContent.id = newTabId;
        newTabContent.innerHTML = generateTabContent();
        container.appendChild(newTabContent);

        // 🟢 Initialize data
        const newTabObj = {
            tab_id: newTabId,
            tab_name: displayName,
            report_id: reportIdToUse,
            hotel_id: hotelIdToUse,
            position: parsedTabsData.tabs ? parsedTabsData.tabs.length + 1 : 1,
            is_new: true
        };

        // 🟢 Add it to parsedTabsData JSON
        if (!parsedTabsData.tabs) parsedTabsData.tabs = [];
        parsedTabsData.tabs.push(newTabObj);

        console.log('  Added new tab to parsedTabsData:', newTabObj);
        console.log('  Full tabsData now:', parsedTabsData);

        // 🟢 Immediately save to DB
        apex.server.process(
            'AJX_MANAGE_REPORT_DASHBOARD',
            {
                x01: 'INSERT',
                x02: hotelIdToUse,
                x03: JSON.stringify(parsedTabsData)
            },
            {
                success: function (pData) {
                    console.log(' New tab saved successfully:', pData);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    console.error('  Error saving new tab:', textStatus, errorThrown);
                }
            }
        );

        //   Continue existing setup
        tabData[newTabId] = {
            tableData: null,
            savedFormulas: {},
            currentFormulaName: '',
            displayName: displayName,
            reportId: reportIdToUse
        };

        switchTab(newTabId);
        loadReportDataForTab(newTabId, reportIdToUse);
        setupTabEventListeners(newTabId);

        if (selectedReportId) {
            $('#static-lov-report').val('');
            reportID = null;
        }

        setTimeout(hidePanels, 100);

        return false;
    } else {
        alert('Please select a report first!');
        return false;
    }
}


let col_alias;
let expressionJson; 
// New function to load report data for specific tab
function loadReportDataForTab(tabId, reportId) {
    console.log('Loading report data for tab:', tabId, 'with report ID:', reportId);
    
    apex.server.process(
        "AJX_GET_REPORT_HOTEL",
        { 
            x01: 'REPORT_DETAIL',
            x02: reportId           
        },
        {
            dataType: "json",
            success: function(data) {
             //   console.log('Report data received for tab:', tabId, data); 
                let reportCol;
                let db_ob_name;
                data.forEach(function(report) {
                    reportCol = report.DEFINITION_JSON; 
                    db_ob_name = report.DB_OBJECT_NAME
                    col_alias = report.COLUMN_ALIAS;
                    expressionJson = report.EXPRESSIONS_CLOB;
                });
                //console.log('expressionJson:>>>>',expressionJson);
                const reportColObj = JSON.parse(reportCol);

                // Generate columns_list from the JSON data
              /*  var  columns_list = reportColObj.selectedColumns.map(item => ({
                    name: `${item.col_name} - ${item.temp_name}`,
                    type: item.data_type.toLowerCase() === 'number' ? 'number' : 'string'
                }));
*/

//console.log('reportColObj:>>>>>>>',reportColObj);
var columns_list = reportColObj.selectedColumns.map(item => ({
                                name: `${item.col_name} - ${item.temp_name}`,
                                type: item.data_type
                                    ? item.data_type.toLowerCase() === 'number' ? 'number'
                                    : item.data_type.toLowerCase() === 'date' ? 'date'
                                    : 'string'
                                    : 'number' // ✅ default to 'number' if data_type is null
                            }));

                console.log('Generated db_ob_name:', db_ob_name);
                console.log('columns_list:>>>',JSON.stringify(columns_list) );
                console.log('col_alias:>>',col_alias);

                apex.server.process(
                    "AJX_GET_REPORT_DATA",
                    { x01: JSON.stringify(columns_list) ,
                      x02: col_alias,
                      x03: db_ob_name
                    },
                    {
                        success: function(pData) {
                            console.log('Table data received for tab:', tabId, pData);
                            
                            // Store data in the specific tab
                            var colAliasObj = JSON.parse(col_alias);
                            console.log('colAliasObj---->',colAliasObj);
                            columns_list = colAliasObj.selectedColumns.map(item => ({
                                name: item.alias_name, // take the latest alias value
                              //  type: item.data_type.toLowerCase() === 'number' ? 'number' : 'string'
                              type: ''
                            }));


                            if (tabData[tabId]) {
                                tabData[tabId].tableData = {
                                    columns: columns_list,   // now matches alias_name
                                    data: pData.rows         // keys from PL/SQL also match alias_name
                                };

                                console.log('Final columns:', columns_list);
                                console.log('First row of data:', pData.rows[0]);
                                
                                // Initialize table for the specific tab
                                initializeTable(tabId,expressionJson);
                            }
                        },
                        error: function(jqXHR, textStatus, errorThrown) {
                            console.error("Error fetching table data for tab " + tabId + ":", textStatus, errorThrown);
                        }
                    }
                );
            },
            error: function(xhr, status, error) {
                console.error("Error fetching report details for tab " + tabId + ":", error);
            }
        }
    );
}

function hidePanels() {
    const panelsContainer = document.querySelector('.panels-container');
    if (panelsContainer) {
        panelsContainer.style.display = 'none';
    }
    
    // Alternative: Hide individual panels
    const controlPanels = document.querySelectorAll('.control-panel');
    controlPanels.forEach(panel => {
        panel.style.display = 'none';
    });
}

// Call this function when DOM is ready and when new tabs are created
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, initializing...');
    setupTabs();
    hidePanels(); // Add this line
});


function generateTabContent() {
    return `
        <div class="panels-container hidden"> <!-- Add hidden class -->
            <div class="panels-row">
                <div class="control-panel hidden"> <!-- Add hidden class -->
                    <h2>
                        Column Operations
                        <div class="fake-btn collapse-btn">−</div>
                    </h2>
                    <div class="form-group">
                        <label>Select Column:</label>
                        <select class="column-select"></select>
                    </div>
                    <div class="form-group">
                        <label>Select Operation:</label>
                        <select class="operation">
                            <option value="sum">Sum</option>
                            <option value="average">Average</option>
                            <option value="min">Minimum</option>
                            <option value="max">Maximum</option>
                            <option value="count">Count</option>
                        </select>
                    </div>
                    <div class="fake-btn calculate-btn">Calculate</div>
                </div>
                
                <div class="control-panel hidden"> <!-- Add hidden class -->
                    <h2>
                        Summary Results
                        <div class="fake-btn collapse-btn">−</div>
                    </h2>
                    <div class="summary-results"></div>
                </div>
                
                <div class="control-panel hidden"> <!-- Add hidden class -->
                    <h2>
                        Filter Data
                        <div class="fake-btn collapse-btn">−</div>
                    </h2>
                    <div class="form-group">
                        <label>Select Column:</label>
                        <select class="filter-column"></select>
                    </div>
                    <div class="form-group">
                        <label>Operator:</label>
                        <select class="filter-operator">
                            <option value="equals">Equals</option>
                            <option value="greater">Greater Than</option>
                            <option value="less">Less Than</option>
                            <option value="contains">Contains</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Value:</label>
                        <input type="text" class="filter-value" placeholder="Enter value to filter">
                    </div>
                    <div class="fake-btn apply-filter">Apply Filter</div>
                    <div class="fake-btn fake-btn-danger clear-filter">Clear Filter</div>
                </div>
            </div>
        </div>
        
        <div class="download-section">
                <div class="fake-btn export-excel-btn">Download</div>
            </div>
        <div class="table-container">
            
            <table class="data-table">
                <thead>
                    <tr class="table-header"></tr>
                </thead>
                <tbody class="table-body"></tbody>
            </table>
        </div>
    `;
}


// ======================
//   DOWNLOAD BUTTON WITH DROPDOWN
// ======================

document.addEventListener('click', function (e) {
    // If "Download" clicked
    if (e.target.classList.contains('export-excel-btn')) {
        const existingMenu = document.querySelector('.download-dropdown');
        if (existingMenu) existingMenu.remove(); // close if open

        const dropdown = document.createElement('div');
        dropdown.classList.add('download-dropdown');
        dropdown.innerHTML = `
            <div class="dropdown-option" data-type="excel">📘 Excel</div>
            <div class="dropdown-option" data-type="csv">📄 CSV</div>
            <div class="dropdown-option" data-type="pdf">📕 PDF</div>
        `;
        dropdown.style.position = 'absolute';
        dropdown.style.top = `${e.clientY + 5}px`;
        dropdown.style.left = `${e.clientX - 40}px`;
        dropdown.style.background = '#fff';
        dropdown.style.border = '1px solid #ccc';
        dropdown.style.borderRadius = '6px';
        dropdown.style.boxShadow = '0 2px 6px rgba(0,0,0,0.2)';
        dropdown.style.zIndex = '9999';
        dropdown.style.cursor = 'pointer';

        document.body.appendChild(dropdown);

        // Remove when clicking outside
        document.addEventListener('click', function removeDropdown(ev) {
            if (!dropdown.contains(ev.target) && !ev.target.classList.contains('export-excel-btn')) {
                dropdown.remove();
                document.removeEventListener('click', removeDropdown);
            }
        });

        // Handle selection
        dropdown.addEventListener('click', function (ev) {
            const exportType = ev.target.dataset.type;
            if (!exportType) return;

            if (!currentTabId || !tabData[currentTabId]) {
                alert('No active report tab to export.');
                return;
            }

            console.log('🟢 Selected export type:', exportType);
            switch (exportType) {
                case 'excel':
    exportToExcelWithFormatting(currentTabId, formula_filterJSON_global);
    break;

                case 'csv':
        exportToCSV(currentTabId);
        break;

    case 'pdf':
        //exportToPDF(currentTabId);
        exportToPDFWithFormatting(currentTabId, formula_filterJSON_global);
        break;

            }
            dropdown.remove(); // close after selection
        });
    }
});


// 🔹 CSV Export
function exportToCSV(tabId) {
    const tableObj = tabData[tabId]?.tableData;
    if (!tableObj || !tableObj.data || tableObj.data.length === 0) {
        alert("No data available for export.");
        return;
    }

    // ✅ Extract actual row keys from the first row
    const headers = Object.keys(tableObj.data[0]);

    const rows = tableObj.data.map(row =>
        headers.map(h => `"${row[h] ?? ''}"`).join(',')
    );

    const csvContent = [headers.join(','), ...rows].join("\n");

    const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);

    const link = document.createElement("a");
    link.href = url;
    link.download = `${tabData[tabId].displayName || "Report"}.csv`;
    link.click();

    URL.revokeObjectURL(url);
}




// 🔹 Excel Export (requires SheetJS)
function exportToExcel(tabId) {
    const data = tabData[tabId]?.tableData;
    if (!data || !data.length) {
        alert('No data available for export.');
        return;
    }

    if (typeof XLSX === 'undefined') {
        alert('Excel export requires SheetJS (XLSX library).');
        console.error('Missing XLSX library');
        return;
    }

    const worksheet = XLSX.utils.json_to_sheet(data);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Report');

    // Example color styling for key columns
    const colorCols = ['STATUS', 'RISK', 'HEALTH'];
    const range = XLSX.utils.decode_range(worksheet['!ref']);
    for (let R = range.s.r + 1; R <= range.e.r; ++R) {
        for (let C = range.s.c; C <= range.e.c; ++C) {
            const cellRef = XLSX.utils.encode_cell({ r: R, c: C });
            const header = Object.keys(data[0])[C];
            if (colorCols.includes(header)) {
                worksheet[cellRef].s = {
                    fill: { fgColor: { rgb: 'FFF0B3' } }, // light yellow
                };
            }
        }
    }

    XLSX.writeFile(workbook, `${tabId}.xlsx`);
    console.log('✅ Excel exported successfully:', tabId);
}

// 🔹 PDF Export (requires jsPDF + autotable)
function exportToPDF(tabId) {
    const tableObj = tabData[tabId]?.tableData;

    if (!tableObj || !tableObj.data || tableObj.data.length === 0) {
        alert("No data available for export.");
        return;
    }

    // ✅ Extract real headers from row object
    const headers = Object.keys(tableObj.data[0]);
    const body = tableObj.data.map(row =>
        headers.map(h => row[h] ?? '')
    );

    // ✅ ✅ Correct way to use jsPDF UMD inside APEX
    const { jsPDF } = window.jspdf;

    if (!jsPDF) {
        alert("PDF library not loaded.");
        return;
    }

    const doc = new jsPDF("l", "pt");

    doc.text(tabData[tabId].displayName || "Report", 40, 30);

    doc.autoTable({
        startY: 50,
        head: [headers],
        body: body,
        theme: "grid",
        styles: { fontSize: 8 },
        headStyles: { fillColor: [41, 128, 185] }
    });

    doc.save(`${tabData[tabId].displayName || "Report"}.pdf`);
}







// Switch between tabs
function switchTab(tabId) {
    console.log('Switching to tab:', tabId);
    
    // Hide all tab contents
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Remove active class from all tabs
    document.querySelectorAll('.tab').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Show selected tab content
    const tabContent = document.getElementById(tabId);
    if (tabContent) {
        tabContent.classList.add('active');
        console.log('Tab content activated:', tabId);
    } else {
        console.error('Tab content not found:', tabId);
    }
    
    // Activate selected tab
    const tabElement = document.querySelector(`.tab[data-tab="${tabId}"]`);
    if (tabElement) {
        tabElement.classList.add('active');
        console.log('Tab header activated:', tabId);
    } else {
        console.error('Tab element not found:', tabId);
    }
    
    currentTabId = tabId;
    console.log('tabId:>>'+tabId);
    console.log('tabData[tabId].reportId:>>'+tabData[tabId].reportId);
    // If tab doesn't have data yet but should have, load it
   // if (tabData[tabId] && !tabData[tabId].tableData && tabData[tabId].reportId) {
        console.log('Loading data for existing tab:', tabId);
        loadReportDataForTab(tabId, tabData[tabId].reportId);
 //   }
}

// Close a tab
function closeTab(tabId) {
    if (Object.keys(tabData).length <= 1) {
        alert('You must have at least one tab open!');
        return;
    }

    const tabElement = document.querySelector(`.tab[data-tab="${tabId}"]`);
    let tabName = '';

    if (tabElement) {
        tabName = tabElement.textContent.replace('×', '').trim();
    }
    console.log('🗑️ Attempting to close tab:', tabName, tabId);

    if (confirm(`Are you sure you want to close "${tabName}"? All unsaved data will be lost.`)) {
        // --- Remove from DOM ---
        const tabContent = document.getElementById(tabId);
        if (tabElement) tabElement.remove();
        if (tabContent) tabContent.remove();

        // --- Remove from tabData memory ---
        delete tabData[tabId];

        // --- Update parsedTabsData ---
        if (parsedTabsData && parsedTabsData.tabs) {
            // Remove this tab from the saved array
            parsedTabsData.tabs = parsedTabsData.tabs.filter(t => t.tab_id !== tabId);

            // Recalculate sequential positions
            parsedTabsData.tabs.forEach((t, i) => t.position = i + 1);

            console.log('🧾 Updated parsedTabsData after delete:', parsedTabsData);

            // --- Save updated JSON to DB ---
            const hotelIdToUse = parsedTabsData.hotel_id || $('#static-lov-hotel').val();
            apex.server.process(
                'AJX_MANAGE_REPORT_DASHBOARD',
                {
                    x01: 'INSERT',
                    x02: hotelIdToUse,
                    x03: JSON.stringify(parsedTabsData)
                },
                {
                    success: function (pData) {
                        console.log('Tabs updated successfully after delete:', pData);
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.error('Error saving tabs after delete:', textStatus, errorThrown);
                    }
                }
            );
        }

        // --- Switch to next available tab ---
        const remainingTabs = Object.keys(tabData);
        if (remainingTabs.length > 0) {
            switchTab(remainingTabs[0]);
        } else {
            currentTabId = null;
            console.log('ℹ No tabs left open.');
        }
    }
}

function setupTabEventListeners(tabId) {
    const tabElement = document.getElementById(tabId);
    if (!tabElement) {
        console.error('Tab element not found:', tabId);
        return;
    }
    
    console.log('Setting up event listeners for tab:', tabId);
    
    setTimeout(() => {
        const calculateBtn = tabElement.querySelector('.calculate-btn');
        const applyFilter = tabElement.querySelector('.apply-filter');
        const clearFilter = tabElement.querySelector('.clear-filter');
        
        if (calculateBtn) calculateBtn.addEventListener('click', function() { calculateOperation(tabId); });
        if (applyFilter) applyFilter.addEventListener('click', function() { applyFilterFunc(tabId); });
        if (clearFilter) clearFilter.addEventListener('click', function() { clearFilterFunc(tabId); });

     //   const exportExcelBtn = tabElement.querySelector('.export-excel-btn');
    //if (exportExcelBtn) exportExcelBtn.addEventListener('click', function() { 
       // exportToExcel(tabId);
      //  exportToExcelWithFormatting(tabId, formula_filterJSON_global); 
       
        // });
        
        setupCollapseButtonsForTab(tabElement);
    }, 100);
 

}
 

function exportToExcel(tabId = currentTabId) {
    if (!tabId) return;

    const tabElement = document.getElementById(tabId);
    const table = tabElement.querySelector('.data-table');
    if (!table) {
        console.error('Table not found for export.');
        return;
    }

    let csv = [];
    const rows = table.querySelectorAll('tr');

    for (const row of rows) {
        let rowData = [];
        const cols = row.querySelectorAll('th, td');
        
        for (const col of cols) {
            // Get the text content, and wrap it in double quotes if it contains a comma
            let text = col.textContent.replace(/"/g, '""');
            if (text.includes(',')) {
                text = `"${text}"`;
            }
            rowData.push(text);
        }
        csv.push(rowData.join(','));
    }

    const csvFile = csv.join('\n');
    const blob = new Blob([csvFile], { type: 'text/csv;charset=utf-8;' });

    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = 'report_data.csv';
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

// Helper function to setup collapse buttons for a specific tab
function setupCollapseButtonsForTab(tabElement) {
    if (!tabElement) return;
    
    tabElement.querySelectorAll('.collapse-btn').forEach(button => {
        const panel = button.closest('.control-panel');
        
        // Correctly set initial button state based on the 'collapsed' class
        if (panel.classList.contains('collapsed')) {
            button.textContent = '+';
        } else {
            button.textContent = '−';
        }
        
        button.addEventListener('click', function() {
            // Toggle the 'collapsed' class on the parent panel
            panel.classList.toggle('collapsed');
            
            // Now, toggle the button text
            this.textContent = (this.textContent === '−') ? '+' : '−';
        });
    });
}
function optimizeTableForColumns(tableElement, columnCount) {
    if (columnCount > 25) {
        tableElement.classList.add('compact-table');
    } else {
        tableElement.classList.remove('compact-table');
    }
}

// Populate table with data for a specific tab
function populateTable(tabId = currentTabId) {
    if (!tabId) return;
    
    const tab = tabData[tabId];
    if (!tab || !tab.tableData) return;
    
    const tabElement = document.getElementById(tabId);
    if (!tabElement) return;
    
    const tableBody = tabElement.querySelector('.table-body');
    if (!tableBody) return;
    
    tableBody.innerHTML = '';
    
    tab.tableData.data.forEach(row => {
        const tr = document.createElement('tr');
        
        tab.tableData.columns.forEach(column => {
            const td = document.createElement('td');
            // Format numbers to two decimal places
            if (column.type === 'number') {
                td.textContent = typeof row[column.name] === 'number' ? 
                    row[column.name].toFixed(2) : row[column.name];
            } else {
                td.textContent = row[column.name];
            }
            tr.appendChild(td);
        });
        
        tableBody.appendChild(tr);
    });
}

// Calculate operation on column for a specific tab
function calculateOperation(tabId = currentTabId) {
    if (!tabId) return;
    
    const tab = tabData[tabId];
    if (!tab.tableData) return;
    
    const tabElement = document.getElementById(tabId);
    const column = tabElement.querySelector('.column-select').value;
    const operation = tabElement.querySelector('.operation').value;
    
    if (!column) {
        alert('Please select a column first!');
        return;
    }
    
    let result;
    const values = tab.tableData.data
        .map(row => parseFloat(row[column]))
        .filter(val => !isNaN(val));
    
    if (values.length === 0) {
        alert('No numeric data found in the selected column!');
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
    
    const summaryResults = tabElement.querySelector('.summary-results');
    const summaryItem = document.createElement('div');
    summaryItem.className = 'summary-item';
    summaryItem.innerHTML = `<strong>${operation.toUpperCase()}</strong> of <strong>${column}</strong>: ${Number(result).toFixed(2)}`;
    summaryResults.appendChild(summaryItem);
}

// Apply filter to table for a specific tab (renamed to avoid conflict)
function applyFilterFunc(tabId = currentTabId) {
    if (!tabId) return;
    
    const tab = tabData[tabId];
    if (!tab.tableData) return;
    
    const tabElement = document.getElementById(tabId);
    const column = tabElement.querySelector('.filter-column').value;
    const operator = tabElement.querySelector('.filter-operator').value;
    const value = tabElement.querySelector('.filter-value').value;
    
    if (!column || !value) {
        alert('Please select a column and enter a value!');
        return;
    }
    
    const filteredData = tab.tableData.data.filter(row => {
        const cellValue = row[column];
        
        // Handle different data types appropriately
        if (tab.tableData.columns.find(col => col.name === column).type === 'number') {
            const numValue = parseFloat(value);
            const numCellValue = parseFloat(cellValue);
            switch(operator) {
                case 'equals': return numCellValue === numValue;
                case 'greater': return numCellValue > numValue;
                case 'less': return numCellValue < numValue;
                default: return true;
            }
        } else {
            switch(operator) {
                case 'equals': return cellValue.toString() === value;
                case 'contains': return cellValue.toString().toLowerCase().includes(value.toLowerCase());
                default: return true;
            }
        }
    });
    
    // Create a temporary filtered dataset for display
    const tempTableData = {
        columns: tab.tableData.columns,
        data: filteredData
    };
    
    // Display filtered data
    displayFilteredData(tempTableData, tabId);
}

// Display filtered data
function displayFilteredData(filteredData, tabId = currentTabId) {
    if (!tabId) return;
    
    const tabElement = document.getElementById(tabId);
    const tableBody = tabElement.querySelector('.table-body');
    tableBody.innerHTML = '';
    
    filteredData.data.forEach(row => {
        const tr = document.createElement('tr');
        
        filteredData.columns.forEach(column => {
            const td = document.createElement('td');
            if (column.type === 'number') {
                td.textContent = typeof row[column.name] === 'number' ? 
                    row[column.name].toFixed(2) : row[column.name];
            } else {
                td.textContent = row[column.name];
            }
            tr.appendChild(td);
        });
        
        tableBody.appendChild(tr);
    });
}

// Clear filter and show all data for a specific tab (renamed to avoid conflict)
function clearFilterFunc(tabId = currentTabId) {
    if (!tabId) return;
    
    const tab = tabData[tabId];
    if (!tab.tableData) return;
    
    const tabElement = document.getElementById(tabId);
    tabElement.querySelector('.filter-value').value = '';
    populateTable(tabId);
}








function initializeTable(tabId = currentTabId, expressionJson = null) {
     if (!tabId) return;
    console.log('tabData[tabId]:>>>>>>>>>>>',tabData[tabId]);
    const tab = tabData[tabId];
    if (!tab || !tab.tableData || !tab.tableData.columns) {
        console.error('No table data available for tab:', tabId);
        return;
    }
    
    const tabElement = document.getElementById(tabId);
    if (!tabElement) {
        console.error('Tab element not found:', tabId);
        return;
    }
    
    const tableHeader = tabElement.querySelector('.table-header');
    const columnSelect = tabElement.querySelector('.column-select');
    const filterColumn = tabElement.querySelector('.filter-column');
    
    if (!tableHeader || !columnSelect || !filterColumn) {
        console.error('One or more table elements not found in tab:', tabId);
        return;
    }
    
    console.log('Initializing table for tab:', tab.tableData);
    
    // Use the expressionJson parameter
    let formula_filterJSON = {};
    
    if (expressionJson) {
        try {
            // If it's a string, parse it; if it's already an object, use it directly
            formula_filterJSON = typeof expressionJson === 'string' ? JSON.parse(expressionJson) : expressionJson;
            console.log('Loaded configuration from expressionJson:', formula_filterJSON);
        } catch (error) {
            console.error('Error parsing expressionJson:', error);
            formula_filterJSON = {};
        }
    } else {
        console.log('No expressionJson provided, using empty configuration');
        formula_filterJSON = {};
    }
    
    tableHeader.innerHTML = '';
    columnSelect.innerHTML = '';
    filterColumn.innerHTML = '';
    
    // Create mappings between col_name and alias_name
    const columnMappings = {};
    const aliasToOriginalMap = {};
    
    let visibleColumnsFromConfig = [];
    
    if (formula_filterJSON.columnConfiguration && formula_filterJSON.columnConfiguration.selectedColumns && formula_filterJSON.columnConfiguration.selectedColumns.length > 0) {
        // We have configuration with selectedColumns
        formula_filterJSON.columnConfiguration.selectedColumns.forEach(col => {
            columnMappings[col.col_name] = col.alias_name || col.col_name;
            aliasToOriginalMap[col.alias_name || col.col_name] = col.col_name;
        });
        
        visibleColumnsFromConfig = formula_filterJSON.columnConfiguration.selectedColumns
            .filter(col => col.visibility !== 'hide')
            .map(col => ({
                originalName: col.col_name,
                displayName: col.alias_name || col.col_name,
                dataType: col.data_type
            }));
            
        // Add formula columns to the visible columns list
        if (formula_filterJSON.formulas) {
            Object.keys(formula_filterJSON.formulas).forEach(formulaName => {
                visibleColumnsFromConfig.push({
                    originalName: formulaName,
                    displayName: formulaName,
                    dataType: 'number',
                    isFormula: true
                });
            });
        }
    } else {
        // No configuration - create columns from table data
        if (tab.tableData.data && tab.tableData.data.length > 0) {
    // Get all unique column names from ALL rows
    const allColumnNames = new Set();
    tab.tableData.data.forEach(row => {
        Object.keys(row).forEach(colName => {
            if (colName && colName.trim() !== '') {
                allColumnNames.add(colName);
            }
        });
    });

    visibleColumnsFromConfig = Array.from(allColumnNames).map(colName => ({
        originalName: colName,
        displayName: colName,
        dataType: 'string' // Default type
    }));
     
}
    }

    const uniqueColumnsMap = visibleColumnsFromConfig.reduce((map, column) => {
    const name = column.originalName;
    const isFormula = column.isFormula === true;
 
    if (map.has(name)) {
        const existingColumn = map.get(name); 
        if (isFormula && existingColumn.isFormula !== true) {
            map.set(name, column);
        } 

    } else { 
        map.set(name, column);
    }
    
    return map;
}, new Map());

// Convert the Map values back to an array
 visibleColumnsFromConfig = Array.from(uniqueColumnsMap.values());

visibleColumnsFromConfig = reorderVisibleColumns(visibleColumnsFromConfig, expressionJson);
 
visibleColumnsFromConfig.forEach(column => {
    const th = document.createElement('th');
    th.textContent = column.displayName;
    th.setAttribute('data-column-name', column.originalName);
     
      
    if (column.isFormula) {
        th.classList.add('formula-column');
        if (formula_filterJSON.formulas && formula_filterJSON.formulas[column.originalName]) {
            th.title = `Formula: ${formula_filterJSON.formulas[column.originalName]}`;
        }
    }
    tableHeader.appendChild(th);
    
    // Add to dropdowns - only add numeric columns to calculation dropdown
    if (column.dataType === 'number' || column.isFormula) {
        const option = document.createElement('option');
        option.value = column.originalName;
        option.textContent = column.displayName;
        if (column.isFormula) {
            option.classList.add('formula-option');
        }
        columnSelect.appendChild(option); 
    }
    
    // Add all columns to filter dropdown
    const filterOption = document.createElement('option');
    filterOption.value = column.originalName;
    filterOption.textContent = column.displayName;
    if (column.isFormula) {
        filterOption.classList.add('formula-option');
    }
    filterColumn.appendChild(filterOption); 
});

 
visibleColumnsFromConfig.forEach((col, index) => {
 });
 
    // Process and populate table data
    formula_filterJSON_global =  formula_filterJSON;
    
    tab.tableData = groupAndAggregateTableData(tab.tableData, formula_filterJSON, aliasToOriginalMap);
    console.log('tab.formula_filterJSON :>>>>',formula_filterJSON);
    processAndPopulateTable(tabId, tab.tableData, formula_filterJSON, visibleColumnsFromConfig, aliasToOriginalMap);
console.log('processAndPopulateTable   tab.tableData:>>>>',tab.tableData);
    
    const tableElement = tabElement.querySelector('table');
    const columnCount = visibleColumnsFromConfig.length;
    optimizeTableForColumns(tableElement, columnCount);
     

    setTimeout(() => {
        makeColumnsResizable(tabId);
    }, 100);
}

function groupAndAggregateTableData(tableData, formula_filterJSON, aliasMap = {}) {

    if (!tableData?.data?.length) return tableData;

    const rows = tableData.data;
    const selectedColumns = formula_filterJSON?.columnConfiguration?.selectedColumns || [];

    // 1️⃣ Find date column with week/month/year aggregation
    const dateAggCol = selectedColumns.find(col =>
        col.data_type?.toLowerCase() === "date" &&
        ["week", "month", "year"].includes((col.aggregation || "").toLowerCase())
    );

    const dateKey = dateAggCol ? (dateAggCol.alias_name) : null;
    const dateAggType = dateAggCol ? dateAggCol.aggregation.toLowerCase() : null;

    // Helper to format date by aggregation
    function formatDateByAgg(dateStr) {
        const date = new Date(dateStr);
        if (isNaN(date)) return dateStr;
        switch (dateAggType) {
            case "week": {
                const firstDayOfYear = new Date(date.getFullYear(), 0, 1);
                const pastDaysOfYear = (date - firstDayOfYear) / 86400000;
                const weekNumber = Math.ceil((pastDaysOfYear + firstDayOfYear.getDay() + 1) / 7);
                return `${date.getFullYear()}-W${weekNumber.toString().padStart(2,'0')}`;
            }
            case "month":
                return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2,'0')}`;
            case "year":
                return `${date.getFullYear()}`;
            default:
                return dateStr;
        }
    }

    // 2️⃣ Group rows only if aggregation type exists; otherwise keep all rows individually
    const grouped = {};
    if (dateKey && dateAggType) {
        // Group by formatted date
        rows.forEach(row => {
            const groupKey = formatDateByAgg(row[dateKey]);
            if (!grouped[groupKey]) grouped[groupKey] = [];
            grouped[groupKey].push(row);
        });
    } else {
        // No grouping: each row is its own group
        rows.forEach((row, idx) => grouped[idx] = [row]);
    }

    // 3️⃣ Aggregate other columns
   const newRows = [];
Object.keys(grouped).forEach(groupKey => {
    const groupRows = grouped[groupKey];

    // If no aggregation on date, leave rows unchanged
    if (!dateKey || !dateAggType) {
        newRows.push(...groupRows);
        return;
    }

    const aggRow = {};
    aggRow[dateKey] = groupKey;
 console.log('groupRows:>>>>>>>>>>>>',groupRows);
    selectedColumns.forEach(col => {
        const key = col.alias_name ;
        if (key === dateKey) return;
        const type = (col.data_type || "").toLowerCase();
        const aggType = (col.aggregation || "none").toLowerCase();

        if (type === "text") return;

        const values = groupRows.map(r => parseFloat(r[key])).filter(v => !isNaN(v));
        if (!values.length) {
            aggRow[key] = null;
            return;
        }
        
        switch (aggType) {
            case "avg": aggRow[key] = values.reduce((a,b)=>a+b,0)/values.length; break;
            case "min": aggRow[key] = Math.min(...values); break;
            case "max": aggRow[key] = Math.max(...values); break;
            case "cnt": aggRow[key] = values.length; break;
            default: aggRow[key] = values.reduce((a,b)=>a+b,0); // sum
        }
    });

    newRows.push(aggRow);
    console.log('aggRow:>>>>>>>>>>>>',aggRow);
});

    // Optional: sort by dateKey if aggregation exists
    if (dateKey && dateAggType) {
        newRows.sort((a,b) => a[dateKey] > b[dateKey] ? 1 : -1);
    }

    // Replace tableData rows with aggregated rows
    tableData.data = newRows;
    return tableData;
}



function makeColumnsResizable(tabId) {
    const tabElement = document.getElementById(tabId);
    if (!tabElement) return;
    
    const table = tabElement.querySelector('table');
    const headers = tabElement.querySelectorAll('th');
    const tableContainer = tabElement.querySelector('.table-container');
    
    if (!table || headers.length === 0) return;
    
    // Remove any existing resize handles
    const existingHandles = tabElement.querySelectorAll('.resize-handle');
    existingHandles.forEach(handle => handle.remove());
    
    // Add resize handles to each header (except the last one)
    headers.forEach((header, index) => {
        if (index < headers.length - 1) { // Don't add resize handle to last column
            const resizeHandle = document.createElement('div');
            resizeHandle.className = 'resize-handle';
            header.appendChild(resizeHandle);
            
            // Make header position relative if not already
           // header.style.position = 'relative';
            
            setupResize(resizeHandle, header, table, tableContainer);
        }
    });
    
}

function setupResize(resizeHandle, header, table, tableContainer) {
    let startX, startWidth, isResizing = false;
    
    resizeHandle.addEventListener('mousedown', function(e) {
        isResizing = true;
        startX = e.clientX;
        startWidth = parseInt(getComputedStyle(header).width, 10);
        
        // Add active class and prevent text selection
        resizeHandle.classList.add('active');
        tableContainer.style.userSelect = 'none';
        tableContainer.style.cursor = 'col-resize';
        
        // Add resizing class to header for visual feedback
        header.classList.add('resizing');
        
        e.preventDefault();
        e.stopPropagation();
    });
    
    document.addEventListener('mousemove', function(e) {
        if (!isResizing) return;
        
        const width = startWidth + (e.clientX - startX);
        
        // Set minimum width
        if (width > 50) {
            header.style.width = width + 'px';
            header.style.minWidth = width + 'px';
            header.style.maxWidth = width + 'px';
            
            // Update the corresponding cells in the same column
            const columnIndex = Array.from(header.parentElement.children).indexOf(header);
            const rows = table.querySelectorAll('tr');
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('th, td');
                if (cells[columnIndex]) {
                    cells[columnIndex].style.width = width + 'px';
                    cells[columnIndex].style.minWidth = width + 'px';
                    cells[columnIndex].style.maxWidth = width + 'px';
                }
            });
        }
    });
    
    document.addEventListener('mouseup', function() {
        if (isResizing) {
            isResizing = false;
            resizeHandle.classList.remove('active');
            tableContainer.style.userSelect = '';
            tableContainer.style.cursor = '';
            header.classList.remove('resizing');
        }
    });
    
    // Also handle touch events for mobile
    resizeHandle.addEventListener('touchstart', function(e) {
        isResizing = true;
        startX = e.touches[0].clientX;
        startWidth = parseInt(getComputedStyle(header).width, 10);
        
        resizeHandle.classList.add('active');
        tableContainer.style.userSelect = 'none';
        tableContainer.style.cursor = 'col-resize';
        header.classList.add('resizing');
        
        e.preventDefault();
    });
    
    document.addEventListener('touchmove', function(e) {
        if (!isResizing) return;
        
        const width = startWidth + (e.touches[0].clientX - startX);
        
        if (width > 50) {
            header.style.width = width + 'px';
            header.style.minWidth = width + 'px';
            header.style.maxWidth = width + 'px';
            
            const columnIndex = Array.from(header.parentElement.children).indexOf(header);
            const rows = table.querySelectorAll('tr');
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('th, td');
                if (cells[columnIndex]) {
                    cells[columnIndex].style.width = width + 'px';
                    cells[columnIndex].style.minWidth = width + 'px';
                    cells[columnIndex].style.maxWidth = width + 'px';
                }
            });
        }
    });
    
    document.addEventListener('touchend', function() {
        if (isResizing) {
            isResizing = false;
            resizeHandle.classList.remove('active');
            tableContainer.style.userSelect = '';
            tableContainer.style.cursor = '';
            header.classList.remove('resizing');
        }
    });
}

function processAndPopulateTable(tabId, tableData, config, visibleColumns, aliasToOriginalMap) {
    const tabElement = document.getElementById(tabId);
    if (!tabElement) return;
    
    const tableBody = tabElement.querySelector('.table-body');
    if (!tableBody) return;
    
    tableBody.innerHTML = '';
    
    let processedData = JSON.parse(JSON.stringify(tableData.data)); // Deep copy
    
    // console.log('Original data:', processedData);
    // console.log('Config:', config);
    // console.log('Visible columns:', visibleColumns);
    
    // If no configuration or empty selectedColumns, use the table data as-is
    if (!config || !config.columnConfiguration || !config.columnConfiguration.selectedColumns || config.columnConfiguration.selectedColumns.length === 0) {
            console.log('No configuration found, using table data as-is');
            
            // Create visible columns from ALL unique column names in ALL rows
            const allColumnNames = new Set();
            processedData.forEach(row => {
                Object.keys(row).forEach(colName => {
                    if (colName && colName.trim() !== '') {
                        allColumnNames.add(colName);
                    }
                });
            });
            
            const dataColumns = Array.from(allColumnNames).map(colName => ({
                originalName: colName,
                displayName: colName,
                dataType: 'string' // Default type
            }));
            
            console.log('Auto-detected columns from all data:', dataColumns);
            
            // Populate table directly with original data
            populateTableDataDirect(tableBody, processedData, dataColumns, {}, {});
            return;
        }
    
    console.log('processedData:>>>>>>>>>>>',processedData);
    //console.log('visibleColumns:>>>>>>>>>>>',visibleColumns);
    // Step 1: Normalize data - create a version with original column names for processing


        const cleanRowKeys = (row) => {
        const cleanedRow = {};
        for (const key in row) {
            if (Object.prototype.hasOwnProperty.call(row, key)) {
                // Find the index of the first hyphen
                const hyphenIndex = key.indexOf('-');
                
                // Extract the part of the key before the hyphen, trimming any trailing space.
                // If no hyphen is found, use the original key.
                const newKey = hyphenIndex !== -1 
                    ? key.substring(0, hyphenIndex).trim() 
                    : key;
                    
                    cleanedRow[newKey] = row[key];
                }
            }
            return cleanedRow;
        };

const cleanedData = processedData.map(cleanRowKeys);
cleanedDatamain = cleanedData;
console.log('cleanedData:>>>>',cleanedData);
// Step 2: Normalize data using the now-clean keys
// const normalizedData = cleanedData.map(row => {
//     const normalizedRow = {};
//     visibleColumns.forEach(col => {
//         if (!col.isFormula) {
//             // 💡 RESOLUTION: Look up the value using the clean 'originalName'
//             // or 'displayName' (since they are identical in your sample).
//             const lookupKey = col.displayName; 

//             // Safely retrieve the value from the cleaned row
//             const value = row[lookupKey] !== undefined ? row[lookupKey] : '';
            
//             // Map the value back to the 'originalName'
//             normalizedRow[col.displayName] = value;
//         }
//     });
//     return normalizedRow;
// });

const normalizedData = cleanedData.map(row => {
    const normalizedRow = {};

    // Keep PK_COL for formula calculations
    normalizedRow.PK_COL = row.PK_COL;

    visibleColumns.forEach(col => {
        if (!col.isFormula) {
            const lookupKey = col.displayName; 
            const value = row[lookupKey] !== undefined ? row[lookupKey] : '';
            normalizedRow[col.displayName] = value;
        }
    });

    return normalizedRow;
});
    
    console.log('normalizedData data:', normalizedData);
    
    // Step 2: Apply filters
    let filteredData = normalizedData;
    if (config.filters && Object.keys(config.filters).length > 0) {
        filteredData = applyFilters(normalizedData, config.filters, config);
        console.log('Data after filtering:', filteredData);
    }
    
    // Step 3: Apply formulas - pass the config parameter
    let dataWithFormulas = filteredData;
    if (config.formulas && Object.keys(config.formulas).length > 0) {
        dataWithFormulas = applyFormulas(filteredData, config.formulas, aliasToOriginalMap, config); 
        console.log('Data after formulas:', dataWithFormulas);
    }
    
    // Step 4: Convert back to display names for rendering
    //console.log('dataWithFormulas:>>>>>>>>>>>>>>>',dataWithFormulas);
    const displayData = dataWithFormulas.map(row => {
        const displayRow = {};
        visibleColumns.forEach(col => {
            if (col.isFormula) {
                // For formula columns, use the calculated value
                displayRow[col.displayName] = row[col.displayName] !== undefined ? row[col.displayName] : '';
            } else {
                // For regular columns, use the original value
                displayRow[col.displayName] = row[col.displayName];
            }
        });
        return displayRow;
    });
    //console.log('displayData:>>>>>>>>>>>>>>>',displayData);
  
    visibleColumns = reorderVisibleColumns(visibleColumns, expressionJson);
 
    // Step 5: Populate table
    populateTableData(tableBody, displayData, visibleColumns, config.conditionalFormatting, aliasToOriginalMap, config);
}


let cleanedDatamain;

function reorderVisibleColumns(visibleColumns, expressionJson) {
     expressionJson = JSON.parse(expressionJson);
    const positions = expressionJson?.columnposition;
   
    if (!Array.isArray(positions)) {
        console.warn("No columnposition array found. Skipping reorder.");
        return visibleColumns;
    }

    // Build a map: baseColumnName → position
    const posMap = {};
    positions.forEach(p => {
        if (p.baseColumnName != null && typeof p.position === "number") {
            posMap[p.baseColumnName] = p.position;
        }
    });

    // Sort using the map, and keep items without position at the end
    const reordered = [...visibleColumns].sort((a, b) => {
        const posA = posMap[a.originalName];
        const posB = posMap[b.originalName];

        // If both don't exist, keep original order
        if (posA == null && posB == null) return 0;

        // Only A missing → A goes after B
        if (posA == null) return 1;

        // Only B missing → B goes after A
        if (posB == null) return -1;

        return posA - posB;
    });

    return reordered;
}




function populateTableDataDirect(tableBody, data, visibleColumns, conditionalFormatting, aliasToOriginalMap) {
    if (data.length === 0) {
        showNoDataMessage(tableBody, visibleColumns.length);
        return;
    }

    const fragment = document.createDocumentFragment();

    data.forEach((row) => {
        const tr = document.createElement('tr');
        visibleColumns.forEach(column => {
            const td = document.createElement('td');
            const value = row[column.displayName] !== undefined ? row[column.displayName] : '';
            td.textContent = value;
            td.setAttribute('data-column', column.originalName);
            tr.appendChild(td);
        });
        fragment.appendChild(tr);
    });

    tableBody.innerHTML = ''; // clear old rows once
    tableBody.appendChild(fragment); // append all at once

    console.log(`Populated ${data.length} rows in table`);
}


function showNoDataMessage(tableBody, columnCount) {
    const tr = document.createElement('tr');
    const td = document.createElement('td');
    td.colSpan = columnCount || 1;
    td.textContent = 'No data available';
    td.style.textAlign = 'center';
    td.style.padding = '20px';
    tr.appendChild(td);
    tableBody.appendChild(tr);
}


function applyFilters(data, filters, config) {
    const filterConditions = Object.values(filters);
    if (filterConditions.length === 0) return data;

    // Build templateSuffixMap (same as before) and aliasToOriginalMap (like your other function)
    const templateSuffixMap = {};
    const aliasToOriginalMap = {}; // alias -> original
    if (config.columnConfiguration && config.columnConfiguration.selectedColumns) {
        config.columnConfiguration.selectedColumns.forEach(col => {
            if (col.temp_name) {
                templateSuffixMap[col.col_name] = ` - ${col.temp_name}`;
                if (col.alias_name) {
                    templateSuffixMap[col.alias_name] = ` - ${col.temp_name}`;
                }
            }
            if (col.alias_name) {
                aliasToOriginalMap[col.alias_name] = col.col_name;
            }
        });
    }

    return data.filter(row => {
        return filterConditions.every(filterCondition => {
            try {
                let condition = filterCondition;

                // Find all [something] occurrences
                const columnMatches = condition.match(/\[(.*?)\]/g);

                if (columnMatches) {
                    columnMatches.forEach(match => {
                        const colNameInCondition = match.replace(/[\[\]]/g, '');

                        // Robustly strip any " - ..." suffix by taking the leftmost part before " - "
                        // This handles "MY_OTB - My Hotel - Strat C" => "MY_OTB"
                        let actualColumnName = colNameInCondition.split(' - ')[0].trim();

                        // Also try to remove any known templateSuffix (fallback)
                        Object.keys(templateSuffixMap).forEach(colKey => {
                            const suffix = templateSuffixMap[colKey];
                            if (actualColumnName.endsWith(suffix)) {
                                actualColumnName = actualColumnName.replace(suffix, '').trim();
                            }
                        });

                        // Map alias -> original if present
                        const originalColName = aliasToOriginalMap[actualColumnName] || actualColumnName;

                        // Find a column name that exists in the row: prefer display/alias then original
                        // (here display/alias means keys in aliasToOriginalMap)
                        const displayColName = Object.keys(aliasToOriginalMap).find(alias => aliasToOriginalMap[alias] === originalColName) || originalColName;

                        // Read the value from row using both candidates
                        let value = row[displayColName];
                        if (value === undefined) value = row[originalColName];

                        // Normalize the value for use inside the condition string
                        if (value === null || value === undefined || value === "") {
                            value = "null";  // keeps logic correct
                        } else if (!isNaN(value)) {
                            value = parseFloat(value);
                        } else if (value === "Sold out") {
                            value = 0;
                        } else {
                            value = `"${value.replace(/"/g, '\\"')}"`;
                        }

                        // Replace the [..] token with the normalized value
                        condition = condition.replace(match, value);
                    });
                }

                // Remove any remaining template suffix fragments like " - something" that might remain
                // but avoid removing " - 50" (numbers) or comparison operators; limit to characters until ']' or whitespace or comparison chars
                // Simpler safe cleanup: remove " - <words>" sequences (non-greedy)
                condition = condition.replace(/\s-\s[^>\]<]+/g, '');

                // Evaluate
                return !!eval(condition);
            } catch (error) {
                // If something fails for a particular filter, don't exclude the row
                return true;
            }
        });
    });
}



function applyConditionalFormattingToCell(td, row, column, conditionalFormatting, aliasToOriginalMap, config) {
    if (!conditionalFormatting) return;
    
    
    // Create template suffix map
    const templateSuffixMap = {};
    if (config.columnConfiguration && config.columnConfiguration.selectedColumns) {
        config.columnConfiguration.selectedColumns.forEach(col => {
            if (col.temp_name) {
                templateSuffixMap[col.col_name] = ` - ${col.temp_name}`;
                if (col.alias_name) {
                    templateSuffixMap[col.alias_name] = ` - ${col.temp_name}`;
                }
            }
        });
    }
    
    // Check if this column has conditional formatting rules
    let columnRules = conditionalFormatting[column.originalName] || conditionalFormatting[column.displayName];
    
    // If not found, try removing template suffixes
    if (!columnRules) {
        Object.keys(conditionalFormatting).forEach(key => {
            let cleanKey = key;
            Object.values(templateSuffixMap).forEach(suffix => {
                cleanKey = cleanKey.replace(suffix, '');
            });
            if (cleanKey === column.originalName || cleanKey === column.displayName) {
                columnRules = conditionalFormatting[key];
            }
        });
    }
    
    //console.log('columnRules:>>>',columnRules);

    if (!columnRules) return;
    
    columnRules.forEach(rule => {
        try {
            let expression = rule.expression;
            const columnMatches = expression.match(/\[(.*?)\]/g);
            
            if (columnMatches) {
                columnMatches.forEach(match => {
                    const colNameInRule = match.replace(/[\[\]]/g, '');
                    
                    // Handle dynamic template suffixes
                    let actualColumnName = colNameInRule;
                    Object.keys(templateSuffixMap).forEach(colKey => {
                        const suffix = templateSuffixMap[colKey];
                        if (colNameInRule.endsWith(suffix)) {
                            actualColumnName = colNameInRule.replace(suffix, '');
                        }
                    });
                    
                    // Convert the column name in rule to the display name for lookup
                    const originalColName = aliasToOriginalMap[actualColumnName] || actualColumnName;
                    const displayColName = Object.keys(aliasToOriginalMap).find(alias => aliasToOriginalMap[alias] === originalColName) || originalColName;
                    
                    let value = row[displayColName] || row[originalColName];
                    
                    // Convert to number if possible
                    if (!isNaN(value) && value !== '' && value !== null && value !== 'Sold out') {
                        value = parseFloat(value);
                    } else {
                        value = 0;
                    }
                    
                    expression = expression.replace(match, value);
                });
            }
            
            // Remove any remaining template suffixes
            Object.values(templateSuffixMap).forEach(suffix => {
                expression = expression.replace(new RegExp(suffix, 'g'), '');
            });
            //console.log('expression:>>>>',expression);
            // Evaluate the condition
            if (eval(expression)) {
                td.style.backgroundColor = rule.color;
                td.style.color = '#ffffff';
                td.style.fontWeight = 'bold';
            }
        } catch (error) {
            console.error('Error applying conditional formatting:', error);
        }
    });
}



/**
 * Evaluates a numeric or date function/column reference for a given row.
 * Handles template suffix removal and value substitution.
 * * NOTE: This is a new helper function required for filter evaluation.
 * You should place this outside the main functions or define it globally.
 */

function evaluateExpression(expression, row, aliasToOriginalMap, config) {

    let currentExpression = expression;

    // 4. Find all column references (e.g., from "[MOXY] > 150" get 'MOXY')
    // Get all bracketed and unbracketed column names
    const columnMatches = currentExpression.match(/\[(.*?)\]/g) || [];
    const simpleColumnMatches = currentExpression.match(/\b[A-Z_][A-Z0-9_]*\b/gi) || [];

    const allColumnNames = [
        ...columnMatches.map(match => match.replace(/[\[\]]/g, '')), // Strip brackets here
        ...simpleColumnMatches.filter(word => !['AND', 'OR', 'NOT', 'Day', 'Date', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'].includes(word))
    ];
    // This gives us: ['MOXY']
    const uniqueColumnNames = [...new Set(allColumnNames)];


    // 5. Safe replacements for numeric values
    uniqueColumnNames.forEach(col => {
        // 'col' is the ALIAS (e.g., 'MOXY'), which is the row key.
        let value = row[col]; // Direct lookup: row['MOXY'] -> "159"

        // Safely parse the value
        if (!isNaN(value) && value !== '' && value !== null && value !== undefined) {
            value = parseFloat(value);
        } else {
            value = 0; // The issue is here if it defaults to 0
        }
        
        // Convert value to string for replacement, essential for expressions like "159 > 150"
        const replacementValue = String(value);

 
        currentExpression = currentExpression.replace(new RegExp(`\\[${col}\\]`, 'g'), replacementValue);
        
         currentExpression = currentExpression.replace(new RegExp(`\\b${col}\\b`, 'g'), replacementValue);
    });

    // 6. Evaluate (The expression should be "159 > 150")
    try {
        // Run final evaluation. The comparison logic should now work.
        const result = eval(currentExpression);
        return result;
    } catch (e) {
        console.error("Evaluation Error in expression:", currentExpression, e);
        return null; 
    }
}

/**
 * Evaluates a filter string for a given row.
 * Returns true if the row passes the filter, false otherwise.
 * * NOTE: This is a new helper function required for filter evaluation.
 * You should place this outside the main functions or define it globally.
 */

/**
 * Evaluates a filter string for a given row.
 * Returns true if the row passes the filter, false otherwise.
 */

function evaluateFilter(filter, row, aliasToOriginalMap, config) {
    if (!filter) return true; // No filter means it passes

    // Assuming getDayNameFromDate and date parsing helpers are available and working (as they are for for6/7/8)

    // --- 1. Handling DAY_OF_WEEK Date Filters ---
    const dayOfWeekMatch = filter.match(/\[(.*?)\]\s*DAY_OF_WEEK\s*\((.*?)\)/i);
    if (dayOfWeekMatch) {
        const fullColumn = dayOfWeekMatch[1].trim();
        // ... (rest of DAY_OF_WEEK logic remains unchanged and is assumed correct) ...
        const daysString = dayOfWeekMatch[2];
        const allowedDays = daysString.split(',').map(d => d.trim().toUpperCase());
        
        // Find the original column name without the template suffix for the date value
        const colMatch = fullColumn.match(/(.*)\s*-\s*(.*)/);
        const colName = colMatch ? colMatch[1].trim() : fullColumn;
        const originalColName = aliasToOriginalMap[colName] || colName;
        const dateString = row[originalColName];
        
        if (!dateString) return false;

        const shortDayName = getDayNameFromDate(dateString).toUpperCase();
        
        if (shortDayName === 'UNKNOWN' || shortDayName === 'INVALID DATE' || shortDayName === 'ERROR') {
            return false;
        }

        return allowedDays.includes(shortDayName);
    }
    
    // --- 2. Handling DATE_RANGE / BETWEEN Date Filters ---
    // ... (rest of DATE_RANGE/BETWEEN logic remains unchanged and is assumed correct) ...
    const dateRangeMatch = filter.match(/\[(.*?)\]\s*DATE_RANGE\s*\((.*?)\)/i);
    const betweenMatch = filter.match(/\[(.*?)\]\s*between\s*(.*?)\s*and\s*(.*?)$/i);

    if (dateRangeMatch || betweenMatch) {
        let fullColumn, startStr, endStr;

        if (dateRangeMatch) {
            fullColumn = dateRangeMatch[1].trim();
            const rangeStr = dateRangeMatch[2]; 
            [startStr, endStr] = rangeStr.split(',').map(s => s.trim());
        } else if (betweenMatch) {
            fullColumn = betweenMatch[1].trim();
            startStr = betweenMatch[2].trim();
            endStr = betweenMatch[3].trim();
        }

        if (!startStr || !endStr) return false;

        const colMatch = fullColumn.match(/(.*)\s*-\s*(.*)/);
        const colName = colMatch ? colMatch[1].trim() : fullColumn;
        const originalColName = aliasToOriginalMap[colName] || colName;
        const dateString = row[originalColName];

        if (!dateString) return false;

        const date = new Date(dateString);
        const start = new Date(startStr);
        const end = new Date(endStr);
        
        start.setHours(0, 0, 0, 0);
        end.setHours(23, 59, 59, 999); 

        if (isNaN(date.getTime()) || isNaN(start.getTime()) || isNaN(end.getTime())) {
            return false;
        }

        return date.getTime() >= start.getTime() && date.getTime() <= end.getTime();
    }


    // --- 3. Handling Standard Numeric/Boolean Filters (Fallback using eval) ---
    else {
         // Since this is not a custom date filter, we prepare the filter string
        // by stripping template suffixes before calling evaluateExpression.

        if (filter.match(/DAY_OF_WEEK|DATE_RANGE|between/i)) {
            return false;
        }

        // FIX: STRIPPING LOGIC FOR NUMERIC FILTER (Addresses for5 failure)
        let cleanedFilter = filter; 
        
        if (config.columnConfiguration?.selectedColumns) {
            config.columnConfiguration.selectedColumns.forEach(col => {
                if (col.temp_name) {
                    // Target the full suffix string including surrounding spaces
                    const fullSuffixPattern = new RegExp(`\\s*-\\s*${col.temp_name}`, 'gi');
                    
                    cleanedFilter = cleanedFilter.replace(fullSuffixPattern, '');
                }
            });
        }
        
        // CRITICAL CLEANUP: Ensure spaces are normalized (e.g., "[MOXY] > 150")
        cleanedFilter = cleanedFilter.replace(/\s+/g, ' ').trim();
         // evaluateExpression handles replacing columns with numbers and running eval().
        // It should receive a clean expression like "[MOXY] > 150"
        const result = evaluateExpression(cleanedFilter, row, aliasToOriginalMap, config);
         if (result === null) {
            return false;
        }

        return !!result; // Coerce result to boolean
    }
}



function applyFormulas(data, formulas, aliasToOriginalMap, config) {

    console.log('data:>>>>',data);
    console.log('formulas:>>>>',formulas);
    console.log('aliasToOriginalMap:>>>>',aliasToOriginalMap);
    console.log('config:>>>>',config);

    const formulaEntries = Object.entries(formulas);

    if (formulaEntries.length === 0) return data;


    // --- NEW STEP 1: RENAME FORMULA DB COLUMNS TO ALIASES ---
    const dbToAliasMap = {};
    if (config.columnConfiguration && config.columnConfiguration.selectedColumns) {
        config.columnConfiguration.selectedColumns.forEach(col => {
            // Only map if col_name and alias_name are different.
            if (col.col_name !== col.alias_name) {
                dbToAliasMap[col.col_name] = col.alias_name;
            }
        });
    }

    // Process all formulas to replace 'col_name' with 'alias_name'
    const processedFormulas = {};
    for (const [formulaName, formulaObj] of formulaEntries) {
        // Handle both string and object formats
        let expression = typeof formulaObj === 'object' ? formulaObj.formula : formulaObj;
        
        // FIX for TypeError: Ensure filter is a string (formulaObj.filter || '')
        let filter = typeof formulaObj === 'object' ? (formulaObj.filter || '') : ''; 
        
        let formulaType = typeof formulaObj === 'object' ? formulaObj.type : 'number';

        // 1. Rename column names (e.g., MOXY_YORK -> MOXY) in both formula and filter
        for (const [dbName, aliasName] of Object.entries(dbToAliasMap)) {
            
            // FIX: Match bracketed or unbracketed column names
            const dbNameRegex = new RegExp(`(\\[|\\b)${dbName}(\\]|\\b)`, 'g');
            
            // Replacement function preserves the surrounding bracket/boundary.
            const replacementFn = (match, prefix, suffix) => {
                return prefix + aliasName + suffix;
            };

            expression = expression.replace(dbNameRegex, replacementFn);
            filter = filter.replace(dbNameRegex, replacementFn);
        }

        // Store the newly renamed formula object
        processedFormulas[formulaName] = { 
            formula: expression, 
            filter: filter, 
            type: formulaType 
        };
    }
   // console.log('processedFormulas:>>>',processedFormulas);
    // Formula processing will now use processedFormulas instead of 'formulas'
    const finalFormulaEntries = Object.entries(processedFormulas);
    // --- END NEW STEP 1 ---


    // Create a map of column data types 
    const columnDataTypes = {};
    if (config.columnConfiguration && config.columnConfiguration.selectedColumns) {
        config.columnConfiguration.selectedColumns.forEach(col => {
            columnDataTypes[col.alias_name || col.col_name] = col.data_type;
        });
    }

    // Helper function to parse date string (DD-MMM-YYYY) to Date object
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

    // Helper function to format date as DD-MMM-YYYY
    function formatDate(date) {
        const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 
                       'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
        const day = date.getDate().toString().padStart(2, '0');
        const month = months[date.getMonth()];
        const year = date.getFullYear();
        return `${day}-${month}-${year}`;
    }

    // Helper function to add days to a date
    function addDays(dateStr, days) {
        const date = parseDate(dateStr);
        if (!date) return dateStr;
        date.setDate(date.getDate() + days);
        return formatDate(date);
    }

    // Helper function to find value in cleanedDatamain by PK_COL and column name
    function findValueInCleanedData(pkColDate, columnName) {
        // Clean the column name - remove any {n} suffix
        const cleanColumnName = columnName.replace(/\{\d+\}$/, '');
        
        // Look for the row in cleanedDatamain
        const foundRow = cleanedDatamain.find(row => row.PK_COL === pkColDate);
        if (foundRow) {
            return foundRow[cleanColumnName] || null;
        }
        return null;
    }


    finalFormulaEntries.forEach(([formulaName, formulaObj]) => { // Use finalFormulaEntries

        let expression = formulaObj.formula;
        let filter = formulaObj.filter;
        let formulaType = formulaObj.type;

        data.forEach(row => {
            try {
                // -------------------------
                // 2. APPLY FILTER LOGIC
                // -------------------------
                // Assumes evaluateFilter is working with the now-aliased names
                if (filter && !evaluateFilter(filter, row, aliasToOriginalMap, config)) {
                    // Filter failed, set result to null and skip calculation
                    row[formulaName] = null;
                    return;
                }

                // If filter passes (or no filter exists), proceed with calculation
                let currentExpression = expression;

                // -------------------------
                // 3. REMOVE TEMPLATE SUFFIXES (Must happen AFTER renaming, BEFORE evaluation)
                // -------------------------
                if (config.columnConfiguration?.selectedColumns) {
                    config.columnConfiguration.selectedColumns.forEach(col => {
                        if (col.temp_name) {
                            // Target the full suffix string and the optional following operator.
                            const suffixPattern = new RegExp(`\\s*-\\s*${col.temp_name}\\s*(\\+|\\-|\\*|\\/)?`, 'gi');
                            
                            // Replace the entire pattern with just the operator (or nothing).
                            currentExpression = currentExpression.replace(suffixPattern, (match, operator) => {
                                return operator || '';
                            });
                        }
                    });
                }
                
                // CRITICAL CLEANUP: Ensure spaces are normalized
                currentExpression = currentExpression.replace(/\s+/g, ' ').trim();

                // console.log('currentExpression:>>>',currentExpression);
                // -------------------------
                // NEW: Handle {1} functionality for offset column references
                // -------------------------
                // Find column references with {n} pattern

                const regex = /(\[?[A-Za-z0-9_% ]+?\]?)\{(\d+)\}/g;

             //   const offsetColumnRegex = /(\[?\b[A-Z_][A-Z0-9_]*\b\]?)\{(\d+)\}/gi;

                const offsetColumnRegex =  /(\[?[A-Za-z_][A-Za-z0-9_% ]*[A-Za-z0-9_%]\]?){(\d+)}/g;
                let match;

                // Create a map to store offset column replacements
                const offsetReplacements = {};
                
                while ((match = offsetColumnRegex.exec(currentExpression)) !== null) {
                    const fullMatch = match[0];
                    const columnRef = match[1].replace(/[\[\]]/g, ''); // Remove brackets if present
                    const offset = parseInt(match[2]);
                    //console.log('match:>>>',match);
                    // Get current row's PK_COL date
                    const currentDate = row.PK_COL;
                    
                    if (currentDate) {
                        // Calculate target date by adding offset
                        const targetDate = addDays(currentDate, offset);
                        
                        // Find the value in cleanedDatamain
                        const offsetValue = findValueInCleanedData(targetDate, columnRef);
                        
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
                        // For missing values, use 0 for numeric operations
                        replacementValue = 'Calculation Issue';
                        currentExpression = replacementValue;
                        return;
                    } else if (!isNaN(value) && value !== null) {
                        // Convert numeric strings to actual numbers
                        replacementValue = parseFloat(value);
                    } else {
                        // For non-numeric values, use them as-is with quotes
                        replacementValue = `"${value}"`;
                    }
                    
                    // Replace the pattern in the expression
                    currentExpression = currentExpression.replace(pattern, replacementValue);
                });

                // 4. Find all remaining column references (should now only be alias names like 'MOXY')
                const columnMatches = currentExpression.match(/\[(.*?)\]/g) || [];
                const simpleColumnMatches = currentExpression.match(/\b[A-Z_][A-Z0-9_]*\b/gi) || [];

                const allColumnNames = [
                    ...columnMatches.map(match => match.replace(/[\[\]]/g, '')),
                    ...simpleColumnMatches.filter(word => !['AND', 'OR', 'NOT', 'Day', 'Date', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'].includes(word))
                ];
                const uniqueColumnNames = [...new Set(allColumnNames)];

                // -------------------------
                // 5. Safe replacements for numeric values
                // -------------------------
                uniqueColumnNames.forEach(col => {
                    // 'col' is the ALIAS (e.g., 'MOXY'), which is the row key.
                    
                    let value = row[col]; // Direct lookup by alias/row key

                    if (columnDataTypes[col] === 'date' && value != null && value !== '') {
                        value = `"${value}"`; // keep quotes for JS eval
                    } else if (!isNaN(value) && value !== '' && value !== null) {
                        value = parseFloat(value);
                    } else {
                        value = `"${value}"`; // fallback as string
                    }
                    const sanitizedCol = col.replace(/%/g, ''); 
                    // Replace both bracketed and unbracketed versions
                    currentExpression = currentExpression.replace(new RegExp(`\\[${sanitizedCol}\\]`, 'g'), value);
                    currentExpression = currentExpression.replace(new RegExp(`\\b${sanitizedCol}\\b`, 'g'), value);
                   
                });

                // 6. Evaluate
                
                //console.log('Last currentExpression:>>>>>>>>>>>>>>>',currentExpression);
                currentExpression = replaceDayNameFunction(currentExpression);

                const result = eval(currentExpression);
                if (typeof result === 'number' && isNaN(result)) {
                    row[formulaName] = 'Calculation Issue';
                } else {
                    row[formulaName] = result;
                }

            } catch (error) {
                //console.error(`Error processing formula ${formulaName}: ${error.message}`);
                row[formulaName] = 'Calculation Issue';
            }
        });

    });

    return data;
}


function replaceDayNameFunction(expr) {
    if (!expr || typeof expr !== "string") return expr;

    return expr.replace(/Day\s*\(\s*([^)]+?)\s*\)/gi,
    "(['Sun','Mon','Tue','Wed','Thu','Fri','Sat'][ new Date($1).getDay() ])"
);

}


function evaluateDateFunctions(expression, row, aliasToOriginalMap, columnDataTypes) {
 
    // Handle Day() function with space: "Day (STAY_DATE)"
    if (expression.includes('Day') && expression.includes('(')) {
        // Match both "Day(STAY_DATE)" and "Day (STAY_DATE)" patterns
        const dayMatches = expression.match(/Day\s*\(\s*([^)]+)\s*\)/gi);
        if (dayMatches) {
            dayMatches.forEach(match => {
                
                // Extract the inner content (column name)
                const innerContent = match.replace(/Day\s*\(\s*/i, '').replace(/\s*\)\s*/, '');
                
                // Remove any brackets from the inner content
                let columnName = innerContent.replace(/[\[\]]/g, '').trim();
                
                
                // Check if this is a date column
                const dataType = columnDataTypes[columnName];
                
                if (dataType && dataType.toLowerCase() === 'date') {
                    const originalColName = aliasToOriginalMap[columnName] || columnName;
                    const dateValue = row[originalColName];
                    
                    
                    if (dateValue) {
                        const dayName = getDayNameFromDate(dateValue);
                        expression = expression.replace(match, `"${dayName}"`);
                    } else {
                        expression = expression.replace(match, '"Unknown"');
                    }
                } else {
                    expression = expression.replace(match, '"NotADate"');
                }
            });
        }
    }
    
    //console.log('Expression after date function processing:', expression);
    return expression;
}

function getDayNameFromDate(dateString) {
    if (!dateString) return 'Unknown';
    
    try {
        
        // Handle different date formats
        let date;
        
        // Try MM/DD/YYYY format (like "9/28/2025")
        if (dateString.includes('/')) {
            const parts = dateString.split('/');
            if (parts.length === 3) {
                const month = parseInt(parts[0]) - 1; // Months are 0-indexed in JavaScript
                const day = parseInt(parts[1]);
                const year = parseInt(parts[2]);
                date = new Date(year, month, day);
            }
        }
        // Try YYYY-MM-DD format
        else if (dateString.includes('-')) {
            date = new Date(dateString);
        }
        // Try other common formats
        else {
            date = new Date(dateString);
        }
        
        if (isNaN(date.getTime())) {
            return 'Invalid Date';
        }
        
        const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        const shortDayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        
        const dayIndex = date.getDay();
        const dayName = shortDayNames[dayIndex];
        
        
        return dayName;
        
    } catch (error) {
        return 'Error';
    }
}

function evaluateDateExpression(expression) {
    try {
        // For date expressions that result in strings (like day names), just return the evaluated string
        if (expression.includes('"')) {
            // This is a string result, evaluate and return
            return eval(expression);
        } else {
            // For other date calculations, use eval
            return eval(expression);
        }
    } catch (error) {
        console.error('Error evaluating date expression:', expression, error);
        return 'Error';
    }
}

function isDateColumn(columnName, config) {
    if (config.columnConfiguration && config.columnConfiguration.selectedColumns) {
        const columnConfig = config.columnConfiguration.selectedColumns.find(
            col => col.col_name === columnName || col.alias_name === columnName
        );
        return columnConfig && columnConfig.data_type === 'date';
    }
    return false;
}


function populateTableHeader(tableHead, visibleColumns) {
    tableHead.innerHTML = "";

    const tr = document.createElement('tr');

    visibleColumns.forEach(column => {
        const th = document.createElement('th');
        th.textContent = column.displayName;
        tr.appendChild(th);
    });

    tableHead.appendChild(tr);
}


function populateTableData(tableBody, data, visibleColumns, conditionalFormatting, aliasToOriginalMap, config) {
    if (data.length === 0) {
        console.log('No data to display after processing');
       //  populateTableHeader(tableBody, visibleColumns);
        return;
    }
   console.log('data:>>>',data);
  //  populateTableHeader(tableBody, visibleColumns);

    data.forEach((row, rowIndex) => {
        const tr = document.createElement('tr');
        
        visibleColumns.forEach(column => {
            const td = document.createElement('td');
            const value = row[column.displayName] !== undefined ? row[column.displayName] : '';
            
            // Format formula values to 2 decimal places if they're numbers
            if (column.isFormula && value !== null && !isNaN(value) && value !== '') {
                td.textContent = parseFloat(value).toFixed(2);
            } else {
                // Optional: Ensure null/undefined shows as empty string, not "null" text
                td.textContent = (value === null || value === undefined || (typeof value === 'number' && isNaN(value))) ? '' : value;
            }
                        
            td.setAttribute('data-column', column.originalName);
            
            if (column.isFormula) {
                td.classList.add('formula-cell');
            }
            
            // Apply conditional formatting - pass the config parameter
            applyConditionalFormattingToCell(td, row, column, conditionalFormatting, aliasToOriginalMap, config);
            
            tr.appendChild(td);
        });
        
        tableBody.appendChild(tr);
    });
    
    console.log(`  Populated ${data.length} rows in table.... `);
}


function optimizeTableForColumns(tableElement, columnCount) {
    if (columnCount > 25) {
        tableElement.classList.add('compact-table');
    } else {
        tableElement.classList.remove('compact-table');
    }
}

function updateExistingTab(tabName, reportId, hotelId) {
    const tabObj = window.UPDATE_TAB_DATA;
    if (!tabObj) return;

    console.log("🟡 Updating tab:", tabObj);

    // ✅ Update JSON object
    tabObj.tab_name = tabName;
    tabObj.report_id = reportId;

    // ✅ Update tab text in UI
    const tabEl = document.querySelector(`.tab[data-tab="${tabObj.tab_id}"]`);
    if (tabEl) {
        tabEl.childNodes[0].textContent = tabName + " ";
    }

    console.log("🟢 Updated full JSON before save:", parsedTabsData);

    // ✅ Save back to database (same MERGE process)
    apex.server.process(
        'AJX_MANAGE_REPORT_DASHBOARD',
        {
            x01: 'INSERT', // MERGE handles update
            x02: hotelId,
            x03: JSON.stringify(parsedTabsData)
        },
        {
            success: function(pData) {
                console.log("✅ Tab updated in DB:", pData);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error("❌ Error updating tab:", textStatus, errorThrown);
            }
        }
    );

    // ✅ Clear update mode
    window.UPDATE_TAB_DATA = null;
}

// Code for hiding the select hotel lov ----
document.addEventListener("DOMContentLoaded", function () {
    document.getElementById("static-lov-hotel").style.display = "none";
});



