# Multi-Schedule Formula Implementation Plan (UPDATED)

## Executive Summary

**Goal**: Add support for multiple formula schedules with filters (WHERE clauses) to allow different calculations based on date ranges and conditions. Sequential evaluation should stop on first match per stay_date.

**Approach**: Adapt the proven filter-region architecture from algojs.js to create a schedule-based formula system. REUSE existing `parseDateRange()`, `parseDayOfWeek()`, and shift pattern logic from current implementation.

**Critical Files**:
- `/home/coder/ur-js/DynamicReportJS.js` (primary modifications - Lines 5189-5398)
- `/home/coder/ur-js/f103/readable/application/shared_components/app_static_files/ReportDashboardJS.js` (table view evaluation)
- `/home/coder/ur-js/f103/readable/application/shared_components/app_static_files/gridReportSummary.js` (card view evaluation)
- Reference: `/home/coder/ur-js/algojs.js` (UI patterns - Lines 748-1948)

## Key Findings from Analysis

### 1. Existing Advanced Features (MUST PRESERVE)
The current formula system already has sophisticated features that MUST be leveraged:

✅ **Shift Patterns** (Lines 4000-4112):
- Syntax: `column{N}` where N is day offset
- Example: `#REVENUE{1}#` = tomorrow's revenue
- Uses `PK_COL` for date-based lookups
- **Impact**: Multi-schedule formulas MUST support this syntax

✅ **Date Functions** (Lines 5220-5252):
- `DATE_RANGE('from','to')` - already exists!
- `DAY_OF_WEEK(1,2,3)` - already exists!
- **Impact**: We can REUSE these for schedule filters instead of reimplementing

✅ **Filter Evaluation** (Lines 5280-5296):
- Conditional formula execution based on filter
- Column reference replacement (#COLNAME#)
- **Impact**: Multi-schedule can use same evaluation logic

### 2. Multi-File Evaluation (CRITICAL DISCOVERY)
Formulas are evaluated in **THREE separate files**:
1. DynamicReportJS.js - Definition and primary evaluation
2. ReportDashboardJS.js - Table view rendering
3. gridReportSummary.js - Card/grid view rendering

**Impact**: All three files MUST be updated or multi-schedule won't work in all views.

### 3. Backward Compatibility Strategy
Current structure:
```javascript
savedFormulas = {
  "FormulaName": {
    formula: "...",
    filter: "...",
    type: "number"
  }
}
```

New structure (backward compatible):
```javascript
savedFormulas = {
  "FormulaName": {
    // OLD format (preserved)
    formula: "...",
    filter: "...",
    type: "number",

    // NEW format (additive)
    isMultiSchedule: true,  // Flag for new format
    schedules: [...]        // Only if isMultiSchedule=true
  }
}
```

### 4. Recommended Implementation Strategy

**Phase 1**: Core evaluation logic in DynamicReportJS.js
- Add `buildFilterStringFromSchedule()` helper (converts UI to DATE_RANGE/DAY_OF_WEEK expressions)
- Add `evaluateScheduleFilter()` helper (REUSES existing parseDateRange/parseDayOfWeek)
- Modify `addCalculation()` to check for `isMultiSchedule` flag
- If multi-schedule: iterate schedules, evaluate filters sequentially, use first match
- If single: use existing code unchanged (backward compatible)

**Phase 2**: Replicate to ReportDashboardJS.js and gridReportSummary.js
- Duplicate multi-schedule logic (faster than refactoring for MVP)
- Ensure consistent behavior across all three views

**Phase 3**: UI (dialog, schedule management)
- Copy algojs.js patterns (collapsible regions, move/copy/delete)
- Filter UI converts to DATE_RANGE/DAY_OF_WEEK expressions
- Save to `savedFormulas` with `isMultiSchedule: true`

**Phase 4**: Testing and validation
- Test in all three views (definition, table, card)
- Verify backward compatibility with existing single formulas
- Validate shift patterns work in multi-schedule formulas

---

## CRITICAL QUESTIONS TO CLARIFY

Before implementation, these design decisions need user confirmation:

### 1. **Sequential Evaluation Behavior**
If multiple schedules have overlapping date ranges:
- **Option A**: First matching schedule wins (stop on first match) ← **ASSUMED**
- Option B: Most specific/restrictive schedule wins
- Option C: Allow overlaps with validation warnings

### 2. **Filter Scope**
- **Option A**: Shared filters (global WHERE, then schedule formulas)
- **Option B**: Per-schedule filters (each independent) ← **ASSUMED (matches algojs pattern)**
- Option C: Both global + per-schedule

### 3. **Backward Compatibility**
- **Option A**: Support OLD single formulas ← **ASSUMED FOR MVP**
- Option B: NEW format only (break old data)

### 4. **UI Integration**
- Option A: Replace current dialog with multi-schedule UI
- **Option B**: Keep single + add "Advanced Multi-Schedule" ← **ASSUMED**
- Option C: Always multi-schedule (single = 1 schedule)

### 5. **Validation Strategy**
- Option A: Block save on overlaps (strict)
- **Option B**: Warn but allow save ← **ASSUMED FOR MVP TIMELINE**
- Option C: Auto-merge conflicts

**Note**: Proceeding with ASSUMED options to meet today's MVP deadline. These can be adjusted if different behavior is needed.

---

## Current Architecture Analysis (UPDATED - Based on Actual Files)

### Current Single Formula System

**Data Structure** (Line 3802 in DynamicReportJS.js):
```javascript
savedFormulas = {
  "FormulaName": {
    formula: "column1 + column2",
    filter: "column3 > 100",  // Single WHERE clause
    type: "number"
  }
}
```

**CRITICAL: Advanced Formula Features Already Exist**:
1. **Shift Patterns** (Lines 4000-4112): Support for `column{N}` syntax to reference date offsets
   - Example: `column{1}` references the next day's value
   - Uses `shiftPattern` regex: `/\b([a-zA-Z_][a-zA-Z0-9_]*)\{(-?\d+)\}/g`
   - Looks up values by `PK_COL` (formatted as DD-MMM-YYYY)

2. **Date Functions**:
   - `DAY_OF_WEEK()` expression (Lines 5236-5252)
   - `DATE_RANGE()` expression (Lines 5220-5235)
   - Already have `parseDateRange()` and `parseDayOfWeek()` utility functions

3. **Filter Evaluation** (Lines 5280-5296):
   - Conditional execution: formula only runs if filter condition is true
   - Filter uses existing column values from row

**Key Functions**:
- `addCalculation()` (Lines 5189-5398): Creates calculated column with:
  - Column reference replacement (#COLNAME# → row values)
  - Shift pattern processing for date offsets
  - Filter condition evaluation before formula execution
  - Result type coercion (number/boolean/string)
  - Applies to `pristineReportData` array

- `recalculateAllFormulas()` (Lines 5304-5375): Reapplies all formulas when data changes

- `saveAllDataToJSON()` (Lines 5796-5887): Persists via AJAX to backend
  - Endpoint: `apex.server.process('SAVE_REPORT_TO_JSON')`
  - Must maintain object structure for `formulas`

**Backend Contract** (Lines 5847-5854):
```javascript
{
  columnConfiguration: {...},
  formulas: {},  // Must remain object, not array
  filters: {},
  conditionalFormatting: {},
  columnposition: []
}
```

### Formula Evaluation Pipeline Across Files

**1. DynamicReportJS.js** (Definition & Primary Evaluation):
- Formulas defined and stored in `savedFormulas` object
- Main evaluation in `addCalculation()` function
- Processes shift patterns, column references, and filters
- Applies directly to `pristineReportData`

**2. ReportDashboardJS.js** (Table Display Evaluation):
- `processAndPopulateTable()` (Lines 2253-2378): Main pipeline
  1. Normalize data with `aliasToOriginalMap` (convert display names → internal names)
  2. Apply filters via `applyFilters()`
  3. **Apply formulas** (formula evaluation happens here for table view)
  4. Convert back to display names
- Uses similar pattern to DynamicReportJS but works with table-specific data
- Handles column name cleanup: `colNameInCondition.split(' - ')[0].trim()`

**3. gridReportSummary.js** (Card/Grid Display):
- Similar evaluation pattern for card-based views
- Uses date formatting and aggregation
- Applies formulas to summary data

### Proven Pattern from algojs.js

**Filter Region Architecture** (Lines 748-808):
- Hierarchical: Regions → Conditions → Expressions
- Collapsible sections with drag/drop sequencing
- Signature-based duplicate detection
- Copy-via-data pattern (serialize → modify → populate)

**Sequential Evaluation** (Lines 1104-1149):
- DOM order = execution order
- Auto-renumbering on structural changes
- Move up/down controls with boundary states

**Validation** (Lines 1293-1426):
- Field-level validation
- Within-region duplicate check
- Cross-region duplicate check
- Composite signature generation

---

## Proposed Solution Architecture

### New Data Structure

**Backward-Compatible Format**:
```javascript
savedFormulas = {
  "FormulaName": {
    // Legacy single formula (unchanged for old reports)
    formula: "column1 + column2",
    filter: "column3 > 100",
    type: "number",

    // NEW: Multi-schedule support
    isMultiSchedule: true,  // Flag to distinguish format
    schedules: [
      {
        id: "schedule-1",
        name: "Weekend Peak",
        sequence: 1,
        filters: {
          dateRange: { from: "2025-06-01", to: "2025-08-31" },
          daysOfWeek: [6, 7],  // Saturday, Sunday
          leadTimeRange: { min: 0, max: 7 }
        },
        formula: "#BASE_RATE# * 1.5",
        type: "number"
      },
      {
        id: "schedule-2",
        name: "Weekday Standard",
        sequence: 2,
        filters: {
          dateRange: { from: "2025-01-01", to: "2025-12-31" },
          daysOfWeek: [1, 2, 3, 4, 5]
        },
        formula: "#BASE_RATE# * 1.2",
        type: "number"
      }
    ]
  }
}
```

**Migration Strategy**:
- Check for `isMultiSchedule` flag on load
- If false/missing: Use legacy single formula logic (no changes)
- If true: Use new schedule evaluation logic
- Old reports work unchanged

### Core Evaluation Algorithm (UPDATED)

**Key Insight**: Leverage existing `parseDateRange()` and `parseDayOfWeek()` functions instead of reimplementing.

**Integration Point**: Modify `addCalculation()` function (Lines 5189-5398) to support multi-schedule evaluation.

**New Function**: `evaluateMultiScheduleFormula(formulaConfig, row, calcName)`

```javascript
function evaluateMultiScheduleFormula(formulaConfig, row, calcName) {
  // If legacy format, fall back to existing behavior
  if (!formulaConfig.isMultiSchedule || !formulaConfig.schedules) {
    // Use existing single-formula logic (lines 5200-5398)
    return evaluateLegacySingleFormula(formulaConfig, row, calcName);
  }

  // Sequential evaluation: first match wins
  for (const schedule of formulaConfig.schedules) {
    // Convert schedule filters to filter string format
    const filterString = buildFilterStringFromSchedule(schedule);

    // Reuse existing filter evaluation logic
    if (evaluateScheduleFilter(filterString, row)) {
      // Reuse existing formula evaluation logic (lines 5200-5298)
      return evaluateFormulaWithExistingLogic(schedule.formula, row, calcName, schedule.type);
    }
  }

  // No matching schedule
  return null;
}

function buildFilterStringFromSchedule(schedule) {
  const filters = [];

  // Date range: Convert to DATE_RANGE() expression (existing function!)
  if (schedule.filters?.dateRange) {
    filters.push(`DATE_RANGE('${schedule.filters.dateRange.from}','${schedule.filters.dateRange.to}')`);
  }

  // Day of week: Convert to DAY_OF_WEEK() expression (existing function!)
  if (schedule.filters?.daysOfWeek?.length > 0) {
    const dayStr = schedule.filters.daysOfWeek.join(',');
    filters.push(`DAY_OF_WEEK(${dayStr})`);
  }

  // Lead time: Custom filter (NEW - simple implementation)
  if (schedule.filters?.leadTimeRange) {
    filters.push(`LEAD_TIME >= ${schedule.filters.leadTimeRange.min} && LEAD_TIME <= ${schedule.filters.leadTimeRange.max}`);
  }

  // Custom filter text (if user enters raw filter)
  if (schedule.filters?.customFilter) {
    filters.push(schedule.filters.customFilter);
  }

  // Combine with AND
  return filters.length > 0 ? filters.join(' && ') : '';
}

function evaluateScheduleFilter(filterString, row) {
  if (!filterString) return true; // No filter = always match

  // REUSE existing filter evaluation logic from addCalculation (lines 5280-5296)
  // This already handles DATE_RANGE(), DAY_OF_WEEK(), and custom expressions

  let processedFilter = filterString;

  // Replace column references with row values
  for (const [colName, value] of Object.entries(row)) {
    const regex = new RegExp(`#${colName}#`, 'g');
    processedFilter = processedFilter.replace(regex,
      typeof value === 'string' ? `'${value}'` : value
    );
  }

  // Evaluate using existing parseDateRange and parseDayOfWeek
  try {
    // DATE_RANGE check (existing function at lines 5220-5235)
    if (processedFilter.includes('DATE_RANGE')) {
      const dateRangeResult = parseDateRange(processedFilter, row);
      if (dateRangeResult !== null) return dateRangeResult;
    }

    // DAY_OF_WEEK check (existing function at lines 5236-5252)
    if (processedFilter.includes('DAY_OF_WEEK')) {
      const dayOfWeekResult = parseDayOfWeek(processedFilter, row);
      if (dayOfWeekResult !== null) return dayOfWeekResult;
    }

    // Fallback to eval for other expressions
    return eval(processedFilter);
  } catch (e) {
    console.error('Schedule filter evaluation error:', e);
    return false;
  }
}
```

**Why This Approach**:
1. ✅ Reuses existing `parseDateRange()` and `parseDayOfWeek()` functions
2. ✅ Leverages existing shift pattern support (`column{N}`)
3. ✅ Maintains existing filter evaluation logic
4. ✅ Minimal code duplication
5. ✅ Backward compatible with single formulas

### UI Components

**New Multi-Schedule Dialog**:
```html
<div id="multi-schedule-formula-dialog" class="modal-overlay">
  <div class="modal-content">
    <div class="modal-header">
      <h3>Multi-Schedule Formula: <span id="formula-name-display"></span></h3>
      <button class="modal-close-btn">×</button>
    </div>

    <div class="modal-body">
      <!-- Schedule List Container -->
      <div id="schedule-container">
        <!-- Dynamically added schedule blocks -->
      </div>

      <button id="add-schedule-btn" class="btn btn-primary">+ Add Schedule</button>
    </div>

    <div class="modal-footer">
      <button id="save-multi-schedule" class="btn btn-success">Save All Schedules</button>
      <button id="cancel-multi-schedule" class="btn btn-secondary">Cancel</button>
    </div>
  </div>
</div>
```

**Individual Schedule Block** (pattern from algojs):
```html
<div class="schedule-block" id="schedule-${id}">
  <div class="schedule-header">
    <span class="toggle-icon">▼</span>
    <span class="schedule-sequence">1.</span>
    <span class="title-display">Schedule 1</span>
    <input type="text" class="title-input hidden" value="Schedule 1" />

    <div class="schedule-controls">
      <button class="btn-icon copy-schedule">📋</button>
      <button class="btn-icon move-up">▲</button>
      <button class="btn-icon move-down">▼</button>
      <button class="btn-icon delete-schedule">×</button>
    </div>
  </div>

  <div class="schedule-content">
    <!-- Filters Section -->
    <div class="section">
      <div class="section-title">Filters (WHERE Clause)</div>

      <div class="field-container">
        <input type="checkbox" id="${id}-date-range" class="field-checkbox">
        <label>Date Range</label>
        <div class="field-content hidden">
          <input type="date" class="date-from">
          <input type="date" class="date-to">
        </div>
      </div>

      <div class="field-container">
        <input type="checkbox" id="${id}-days-of-week" class="field-checkbox">
        <label>Days of Week</label>
        <div class="field-content hidden">
          <div class="checkbox-group">
            <label><input type="checkbox" value="0"> Sun</label>
            <label><input type="checkbox" value="1"> Mon</label>
            <!-- ... other days ... -->
          </div>
        </div>
      </div>

      <div class="field-container">
        <input type="checkbox" id="${id}-lead-time" class="field-checkbox">
        <label>Lead Time Range</label>
        <div class="field-content hidden">
          Min: <input type="number" class="lead-time-min">
          Max: <input type="number" class="lead-time-max">
        </div>
      </div>
    </div>

    <!-- Formula Section -->
    <div class="section">
      <div class="section-title">Formula Expression</div>
      <textarea class="formula-textarea" placeholder="e.g., #BASE_RATE# * 1.2"></textarea>
      <button class="btn btn-small validate-formula">Validate</button>
    </div>
  </div>

  <div class="validation-messages hidden"></div>
</div>
```

---

## Implementation Plan

### Phase 1: Core Infrastructure (1-2 hours)

**File**: `DynamicReportJS.js`

#### 1.1 Add Multi-Schedule Dialog HTML
- **Location**: After line 729 (after existing formula dialog)
- **Action**: Insert multi-schedule dialog structure
- **Code**:
```javascript
// Multi-Schedule Formula Dialog (NEW)
const multiScheduleDialogHTML = `
  <div id="multi-schedule-formula-dialog" class="modal-overlay" style="display: none;">
    <!-- Full dialog structure from UI Components section above -->
  </div>
`;
document.body.insertAdjacentHTML('beforeend', multiScheduleDialogHTML);
```

#### 1.2 Update savedFormulas Structure
- **Location**: Line 3802 (global variables)
- **Action**: Add migration flag tracking
- **Code**:
```javascript
let savedFormulas = {};
let currentFormulaName = '';
let scheduleCounter = 0;  // NEW: Track schedule IDs
```

#### 1.3 Add Schedule Management Functions
- **Location**: After line 4512 (after saveFormulas())
- **Action**: Create schedule CRUD functions
- **Functions**:
  - `addSchedule(formulaName)` - Create new schedule block
  - `copySchedule(scheduleElement)` - Duplicate schedule
  - `deleteSchedule(scheduleId)` - Remove schedule
  - `moveSchedule(scheduleElement, direction)` - Reorder
  - `updateScheduleSequence(formulaName)` - Renumber schedules
  - `getScheduleData(scheduleElement)` - Serialize to JSON
  - `populateSchedule(scheduleElement, scheduleData)` - Load from JSON

### Phase 2: Evaluation Logic (UPDATED - 1 hour)

**File**: `DynamicReportJS.js`

#### 2.1 Add Helper Functions
- **Location**: After line 5188 (before addCalculation function)
- **Action**: Add multi-schedule evaluation helpers that REUSE existing logic
- **Code**:

```javascript
/**
 * Build filter string from schedule filters (converts UI to expression format)
 */
function buildFilterStringFromSchedule(schedule) {
  const filters = [];

  // Date range: Convert to DATE_RANGE() expression (REUSES existing parseDateRange)
  if (schedule.filters?.dateRange) {
    filters.push(`DATE_RANGE('${schedule.filters.dateRange.from}','${schedule.filters.dateRange.to}')`);
  }

  // Day of week: Convert to DAY_OF_WEEK() expression (REUSES existing parseDayOfWeek)
  if (schedule.filters?.daysOfWeek?.length > 0) {
    const dayStr = schedule.filters.daysOfWeek.join(',');
    filters.push(`DAY_OF_WEEK(${dayStr})`);
  }

  // Lead time: Custom filter (NEW feature)
  if (schedule.filters?.leadTimeRange) {
    filters.push(`LEAD_TIME >= ${schedule.filters.leadTimeRange.min} && LEAD_TIME <= ${schedule.filters.leadTimeRange.max}`);
  }

  // Custom filter text (if user enters advanced filter)
  if (schedule.filters?.customFilter) {
    filters.push(schedule.filters.customFilter);
  }

  return filters.length > 0 ? filters.join(' && ') : '';
}

/**
 * Evaluate schedule filter (REUSES existing parseDateRange/parseDayOfWeek)
 */
function evaluateScheduleFilter(filterString, row) {
  if (!filterString) return true;

  let processedFilter = filterString;

  // Replace column references (same logic as addCalculation lines 5254-5267)
  for (const [colName, value] of Object.entries(row)) {
    const regex = new RegExp(`#${colName}#`, 'g');
    processedFilter = processedFilter.replace(regex,
      typeof value === 'string' ? `'${value}'` : value
    );
  }

  try {
    // REUSE existing DATE_RANGE logic (lines 5220-5235)
    if (processedFilter.includes('DATE_RANGE')) {
      const dateRangeResult = parseDateRange(processedFilter, row);
      if (dateRangeResult !== null) return dateRangeResult;
    }

    // REUSE existing DAY_OF_WEEK logic (lines 5236-5252)
    if (processedFilter.includes('DAY_OF_WEEK')) {
      const dayOfWeekResult = parseDayOfWeek(processedFilter, row);
      if (dayOfWeekResult !== null) return dayOfWeekResult;
    }

    // Fallback to eval for other expressions
    return eval(processedFilter);
  } catch (e) {
    console.error('Schedule filter evaluation error:', e);
    return false;
  }
}
```

#### 2.2 Modify addCalculation() Function
- **Location**: Line 5189 (start of addCalculation function)
- **Action**: Add multi-schedule support at the beginning of the main loop
- **Change**:

```javascript
// FIND (around lines 5270-5298):
pristineReportData.forEach((row) => {
  let currentFormula = formulaToParse;

  // ... existing column reference replacement ...

  // Existing filter check (lines 5280-5296)
  if (currentFilter && currentFilter.trim() !== '') {
    // ... existing filter logic ...
  }

  // ... formula evaluation ...
});

// REPLACE WITH:
pristineReportData.forEach((row) => {
  // NEW: Multi-schedule support
  if (savedFormulas[calcName]?.isMultiSchedule && savedFormulas[calcName]?.schedules) {
    const schedules = savedFormulas[calcName].schedules;

    // Sequential evaluation: first match wins
    for (const schedule of schedules) {
      const filterString = buildFilterStringFromSchedule(schedule);

      if (evaluateScheduleFilter(filterString, row)) {
        // Found matching schedule - use its formula
        let scheduleFormula = schedule.formula;

        // Apply existing formula processing (shift patterns, column refs)
        // REUSE lines 5200-5267 logic
        scheduleFormula = scheduleFormula.replace(shiftPattern, (match, colName, shiftVal) => {
          // ... existing shift pattern logic ...
        });

        for (const [colName, value] of Object.entries(row)) {
          const regex = new RegExp(`#${colName}#`, 'g');
          scheduleFormula = scheduleFormula.replace(regex,
            typeof value === 'string' ? `'${value}'` : value
          );
        }

        // Evaluate and assign
        try {
          let result = eval(scheduleFormula);
          row[calcName] = schedule.type === 'number' ? parseFloat(result) : result;
        } catch (e) {
          console.error('Schedule formula error:', e);
          row[calcName] = 'Calculation Issue';
        }

        // First match wins - stop evaluating
        return;
      }
    }

    // No schedule matched - leave empty
    row[calcName] = null;
    return;
  }

  // LEGACY: Single formula logic (existing code unchanged)
  let currentFormula = formulaToParse;

  // ... rest of existing code (lines 5200-5398) ...
});
```

**Key Changes**:
1. Check if formula is multi-schedule at start of loop
2. If yes: iterate schedules, evaluate filters using EXISTING functions
3. If match: use schedule's formula with EXISTING shift pattern/column logic
4. If no: fall through to EXISTING single-formula code (no changes)
5. Backward compatible: old formulas work exactly as before

### Phase 3: UI Integration (2 hours)

**File**: `DynamicReportJS.js`

#### 3.1 Add Entry Point Button
- **Location**: After line 4487 (in saved formulas list rendering)
- **Action**: Add "Advanced" button for multi-schedule mode
- **Code**:
```javascript
function renderSavedFormula(name, displayString) {
  // ... existing rendering ...

  // NEW: Add multi-schedule button
  const advancedBtn = document.createElement('button');
  advancedBtn.className = 'btn btn-small btn-secondary multi-schedule-btn';
  advancedBtn.textContent = 'Advanced';
  advancedBtn.setAttribute('data-name', name);
  actionsCell.appendChild(advancedBtn);

  row.appendChild(actionsCell);
}

// Event listener (add after line 4418)
document.addEventListener('click', (e) => {
  if (e.target.classList.contains('multi-schedule-btn')) {
    const formulaName = e.target.getAttribute('data-name');
    openMultiScheduleDialog(formulaName);
  }
});
```

#### 3.2 Multi-Schedule Dialog Management
- **Location**: After line 4904 (after clearFormula)
- **Action**: Add dialog open/close functions
- **Functions**:
```javascript
function openMultiScheduleDialog(formulaName) {
  currentFormulaName = formulaName;
  const dialog = document.getElementById('multi-schedule-formula-dialog');
  const nameDisplay = dialog.querySelector('#formula-name-display');

  nameDisplay.textContent = formulaName;

  // Load existing schedules or create first empty one
  const formulaConfig = savedFormulas[formulaName];
  const container = dialog.querySelector('#schedule-container');
  container.innerHTML = '';

  if (formulaConfig?.isMultiSchedule && formulaConfig.schedules) {
    formulaConfig.schedules.forEach(scheduleData => {
      addSchedule(formulaName);
      const scheduleElement = container.lastElementChild;
      populateSchedule(scheduleElement, scheduleData);
    });
  } else {
    // First time: create one empty schedule
    addSchedule(formulaName);
  }

  dialog.style.display = 'flex';
}

function closeMultiScheduleDialog() {
  const dialog = document.getElementById('multi-schedule-formula-dialog');
  dialog.style.display = 'none';
  currentFormulaName = '';
}
```

#### 3.3 Schedule CRUD Functions
- **Location**: After closeMultiScheduleDialog
- **Action**: Implement schedule management (adapted from algojs)
- **Functions**:
```javascript
function addSchedule(formulaName) {
  scheduleCounter++;
  const scheduleId = `schedule-${scheduleCounter}`;
  const container = document.getElementById('schedule-container');
  const sequence = container.children.length + 1;

  const scheduleHTML = `
    <div class="schedule-block" id="${scheduleId}" data-sequence="${sequence}">
      <!-- Full schedule block HTML from UI Components section -->
    </div>
  `;

  container.insertAdjacentHTML('beforeend', scheduleHTML);
  const scheduleElement = container.lastElementChild;
  setupScheduleEventListeners(scheduleElement);
  updateScheduleSequence();
}

function setupScheduleEventListeners(scheduleElement) {
  // Copy pattern from algojs.js setupRegionEventListeners
  // - Editable title
  // - Copy/move/delete buttons
  // - Collapsible toggle
  // - Filter checkboxes
  // - Validate button
}

function copySchedule(originalElement) {
  // Pattern from algojs copyFilterRegion (lines 1165-1187)
  const scheduleData = getScheduleData(originalElement);
  scheduleData.name += ` - copy ${generateTimestamp()}`;
  scheduleData.id = null;

  addSchedule(currentFormulaName);
  const newElement = document.getElementById('schedule-container').lastElementChild;
  originalElement.after(newElement);
  populateSchedule(newElement, scheduleData);
  updateScheduleSequence();
}

function deleteSchedule(scheduleId) {
  if (!confirm('Delete this schedule?')) return;
  document.getElementById(scheduleId).remove();
  updateScheduleSequence();
}

function moveSchedule(scheduleElement, direction) {
  // Pattern from algojs moveRegion (lines 1121-1129)
  const parent = scheduleElement.parentNode;
  if (direction === 'up' && scheduleElement.previousElementSibling) {
    parent.insertBefore(scheduleElement, scheduleElement.previousElementSibling);
  } else if (direction === 'down' && scheduleElement.nextElementSibling) {
    parent.insertBefore(scheduleElement.nextElementSibling, scheduleElement);
  }
  updateScheduleSequence();
}

function updateScheduleSequence() {
  // Pattern from algojs updateRegionSequence (lines 1104-1119)
  document.querySelectorAll('.schedule-block').forEach((el, index) => {
    const sequence = index + 1;
    el.dataset.sequence = sequence;
    el.querySelector('.schedule-sequence').textContent = `${sequence}.`;

    // Update move button states
    el.querySelector('.move-up').disabled = (sequence === 1);
    const total = document.querySelectorAll('.schedule-block').length;
    el.querySelector('.move-down').disabled = (sequence === total);
  });
}

function getScheduleData(scheduleElement) {
  const data = {
    id: scheduleElement.id,
    name: scheduleElement.querySelector('.title-display').textContent.trim(),
    sequence: parseInt(scheduleElement.dataset.sequence, 10),
    filters: {},
    formula: scheduleElement.querySelector('.formula-textarea').value.trim(),
    type: 'number' // Could be dynamic based on UI
  };

  // Date range
  if (scheduleElement.querySelector('[id$="-date-range"]')?.checked) {
    data.filters.dateRange = {
      from: scheduleElement.querySelector('.date-from').value,
      to: scheduleElement.querySelector('.date-to').value
    };
  }

  // Days of week
  if (scheduleElement.querySelector('[id$="-days-of-week"]')?.checked) {
    const checkedDays = Array.from(
      scheduleElement.querySelectorAll('.checkbox-group input:checked')
    ).map(cb => parseInt(cb.value, 10));
    data.filters.daysOfWeek = checkedDays;
  }

  // Lead time range
  if (scheduleElement.querySelector('[id$="-lead-time"]')?.checked) {
    data.filters.leadTimeRange = {
      min: parseInt(scheduleElement.querySelector('.lead-time-min').value, 10),
      max: parseInt(scheduleElement.querySelector('.lead-time-max').value, 10)
    };
  }

  return data;
}

function populateSchedule(scheduleElement, scheduleData) {
  // Set title
  scheduleElement.querySelector('.title-display').textContent = scheduleData.name;
  scheduleElement.querySelector('.title-input').value = scheduleData.name;
  scheduleElement.dataset.sequence = scheduleData.sequence;

  // Set formula
  scheduleElement.querySelector('.formula-textarea').value = scheduleData.formula || '';

  // Populate filters
  if (scheduleData.filters?.dateRange) {
    const checkbox = scheduleElement.querySelector('[id$="-date-range"]');
    checkbox.checked = true;
    checkbox.dispatchEvent(new Event('change'));
    scheduleElement.querySelector('.date-from').value = scheduleData.filters.dateRange.from;
    scheduleElement.querySelector('.date-to').value = scheduleData.filters.dateRange.to;
  }

  if (scheduleData.filters?.daysOfWeek) {
    const checkbox = scheduleElement.querySelector('[id$="-days-of-week"]');
    checkbox.checked = true;
    checkbox.dispatchEvent(new Event('change'));
    scheduleData.filters.daysOfWeek.forEach(day => {
      const dayCheckbox = scheduleElement.querySelector(`.checkbox-group input[value="${day}"]`);
      if (dayCheckbox) dayCheckbox.checked = true;
    });
  }

  if (scheduleData.filters?.leadTimeRange) {
    const checkbox = scheduleElement.querySelector('[id$="-lead-time"]');
    checkbox.checked = true;
    checkbox.dispatchEvent(new Event('change'));
    scheduleElement.querySelector('.lead-time-min').value = scheduleData.filters.leadTimeRange.min;
    scheduleElement.querySelector('.lead-time-max').value = scheduleData.filters.leadTimeRange.max;
  }
}

function generateTimestamp() {
  const d = new Date();
  const pad = (n) => n.toString().padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
}
```

### Phase 4: Save & Validation (1 hour)

**File**: `DynamicReportJS.js`

#### 4.1 Save Multi-Schedule Configuration
- **Location**: After populateSchedule function
- **Action**: Convert schedules to savedFormulas format
- **Code**:
```javascript
function saveMultiSchedule() {
  const dialog = document.getElementById('multi-schedule-formula-dialog');
  const formulaName = currentFormulaName;

  if (!formulaName) {
    alert('No formula selected');
    return;
  }

  // Collect all schedule data
  const schedules = [];
  document.querySelectorAll('.schedule-block').forEach(el => {
    schedules.push(getScheduleData(el));
  });

  // Validate
  const { isValid, errors } = validateSchedules(schedules);
  if (!isValid) {
    alert('Validation errors:\n' + errors.join('\n'));
    return;
  }

  // Update savedFormulas
  savedFormulas[formulaName] = {
    isMultiSchedule: true,
    schedules: schedules,
    type: 'number' // Could be dynamic
  };

  // Save to localStorage
  saveFormulas();

  // Save to backend
  saveAllDataToJSON();
  handleSave();

  // Recalculate with new schedules
  recalculateAllFormulas();
  displayReportTable('saveMultiSchedule');

  // Close dialog
  closeMultiScheduleDialog();

  alert('Multi-schedule formula saved successfully!');
}

// Event listener (add to DOMContentLoaded or after dialog creation)
document.getElementById('save-multi-schedule').addEventListener('click', saveMultiSchedule);
document.getElementById('cancel-multi-schedule').addEventListener('click', closeMultiScheduleDialog);
```

#### 4.2 Validation Function
- **Location**: After saveMultiSchedule
- **Action**: Validate schedules for overlaps and errors
- **Code**:
```javascript
function validateSchedules(schedules) {
  const errors = [];

  // Check each schedule
  schedules.forEach((schedule, index) => {
    const num = index + 1;

    // Check formula exists
    if (!schedule.formula || schedule.formula.trim() === '') {
      errors.push(`Schedule ${num}: Formula cannot be empty`);
    }

    // Check at least one filter
    const hasFilters = schedule.filters &&
      (schedule.filters.dateRange ||
       schedule.filters.daysOfWeek?.length > 0 ||
       schedule.filters.leadTimeRange);

    if (!hasFilters) {
      errors.push(`Schedule ${num}: At least one filter must be set`);
    }

    // Validate date range
    if (schedule.filters?.dateRange) {
      const from = new Date(schedule.filters.dateRange.from);
      const to = new Date(schedule.filters.dateRange.to);
      if (from > to) {
        errors.push(`Schedule ${num}: 'From' date must be before 'To' date`);
      }
    }

    // Validate lead time range
    if (schedule.filters?.leadTimeRange) {
      if (schedule.filters.leadTimeRange.min > schedule.filters.leadTimeRange.max) {
        errors.push(`Schedule ${num}: Min lead time must be <= Max lead time`);
      }
    }
  });

  // OPTIONAL: Check for overlaps (warning only for MVP)
  const overlaps = detectOverlaps(schedules);
  if (overlaps.length > 0) {
    // For MVP: warn but don't block
    console.warn('Schedule overlaps detected:', overlaps);
    // errors.push(`Warning: Schedules ${overlaps.join(', ')} have overlapping conditions`);
  }

  return {
    isValid: errors.length === 0,
    errors: errors
  };
}

function detectOverlaps(schedules) {
  // Simple date range overlap check
  const overlaps = [];

  for (let i = 0; i < schedules.length - 1; i++) {
    for (let j = i + 1; j < schedules.length; j++) {
      const s1 = schedules[i];
      const s2 = schedules[j];

      if (s1.filters?.dateRange && s2.filters?.dateRange) {
        const from1 = new Date(s1.filters.dateRange.from);
        const to1 = new Date(s1.filters.dateRange.to);
        const from2 = new Date(s2.filters.dateRange.from);
        const to2 = new Date(s2.filters.dateRange.to);

        // Check if ranges overlap
        if (from1 <= to2 && from2 <= to1) {
          overlaps.push(`${i + 1} and ${j + 1}`);
        }
      }
    }
  }

  return overlaps;
}
```

### Phase 5: Backward Compatibility (30 minutes)

**File**: `DynamicReportJS.js`

#### 5.1 Update loadConfigFromJSON
- **Location**: Lines 3930-3969 (loadConfigFromJSON function)
- **Action**: Handle both old and new formats
- **Change**:
```javascript
function loadConfigFromJSON(config) {
  // ... existing code ...

  if (config.formulas) {
    savedFormulas = {};

    for (const [name, formulaData] of Object.entries(config.formulas)) {
      // Check if multi-schedule format
      if (formulaData.isMultiSchedule && formulaData.schedules) {
        // NEW: Multi-schedule format
        savedFormulas[name] = {
          isMultiSchedule: true,
          schedules: formulaData.schedules,
          type: formulaData.type || 'number'
        };
      } else {
        // LEGACY: Single formula format
        savedFormulas[name] = {
          formula: formulaData.formula || formulaData,
          filter: formulaData.filter || '',
          type: formulaData.type || 'number'
        };
      }
    }

    loadSavedFormulas();
  }
}
```

#### 5.2 Update Saved Formulas Display
- **Location**: Lines 4470-4487 (renderSavedFormula)
- **Action**: Show badge for multi-schedule formulas
- **Change**:
```javascript
function renderSavedFormula(name, displayString) {
  const row = document.createElement('tr');
  row.setAttribute('data-formula-name', name);

  const nameCell = row.insertCell();

  // NEW: Add badge for multi-schedule formulas
  const formulaConfig = savedFormulas[name];
  if (formulaConfig?.isMultiSchedule) {
    nameCell.innerHTML = `${name} <span class="badge badge-info">Multi-Schedule (${formulaConfig.schedules.length})</span>`;
  } else {
    nameCell.textContent = name;
  }

  // ... rest of existing code ...
}
```

### Phase 6: CSS Styling (30 minutes)

**File**: `DynamicReportJS.js` or separate CSS file

#### 6.1 Add Multi-Schedule Styles
- **Location**: Inline styles or external CSS
- **Action**: Style dialog and schedule blocks (adapt from algojs.js styles)
- **Code**:
```css
/* Multi-Schedule Dialog */
#multi-schedule-formula-dialog .modal-content {
  max-width: 1200px;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
}

/* Schedule Block */
.schedule-block {
  border: 1px solid #444;
  border-radius: 4px;
  margin-bottom: 15px;
  background: #2a2a2a;
}

.schedule-block.collapsed .schedule-content {
  display: none;
}

.schedule-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  background: #333;
  cursor: pointer;
  user-select: none;
}

.schedule-header:hover {
  background: #3a3a3a;
}

.schedule-sequence {
  font-weight: bold;
  color: #4a9eff;
  margin-right: 8px;
}

.toggle-icon {
  margin-right: 8px;
  transition: transform 0.2s;
}

.schedule-block.collapsed .toggle-icon {
  transform: rotate(-90deg);
}

.schedule-controls {
  display: flex;
  gap: 5px;
}

.btn-icon {
  background: transparent;
  border: 1px solid #555;
  color: #ccc;
  padding: 4px 8px;
  cursor: pointer;
  border-radius: 3px;
  font-size: 14px;
}

.btn-icon:hover {
  background: #444;
  border-color: #666;
}

.btn-icon:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Schedule Content */
.schedule-content {
  padding: 15px;
}

.section {
  margin-bottom: 20px;
  padding: 15px;
  background: #1e1e1e;
  border-radius: 4px;
}

.section-title {
  font-weight: bold;
  color: #4a9eff;
  margin-bottom: 10px;
  font-size: 14px;
  text-transform: uppercase;
}

.field-container {
  margin-bottom: 12px;
  display: flex;
  align-items: flex-start;
  gap: 10px;
}

.field-checkbox {
  margin-top: 3px;
}

.field-content {
  margin-left: 25px;
  margin-top: 8px;
  display: flex;
  gap: 10px;
  align-items: center;
}

.field-content.hidden {
  display: none;
}

.checkbox-group {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
}

.formula-textarea {
  width: 100%;
  min-height: 80px;
  padding: 8px;
  background: #1a1a1a;
  border: 1px solid #444;
  color: #ccc;
  font-family: 'Courier New', monospace;
  font-size: 13px;
  border-radius: 3px;
}

.formula-textarea:focus {
  outline: none;
  border-color: #4a9eff;
}

/* Validation Messages */
.validation-messages {
  background: #4a1c1c;
  border: 1px solid #a33;
  border-radius: 4px;
  padding: 10px;
  margin: 10px 15px;
}

.validation-messages ul {
  margin: 0;
  padding-left: 20px;
}

.validation-messages li {
  color: #faa;
  margin-bottom: 5px;
}

/* Badge */
.badge {
  display: inline-block;
  padding: 2px 8px;
  font-size: 11px;
  font-weight: bold;
  border-radius: 3px;
  margin-left: 8px;
}

.badge-info {
  background: #17a2b8;
  color: white;
}

/* Editable Title */
.title-input {
  background: #1a1a1a;
  border: 1px solid #4a9eff;
  color: #ccc;
  padding: 2px 5px;
  font-size: 14px;
  border-radius: 3px;
}

.title-display {
  cursor: pointer;
}

.title-display:hover {
  text-decoration: underline;
}

.hidden {
  display: none;
}
```

---

## Testing Strategy

### Manual Testing Checklist

1. **Backward Compatibility**:
   - [ ] Load old report with single formula → should work unchanged
   - [ ] Edit old formula → should not break
   - [ ] Save old formula → should maintain legacy format

2. **Multi-Schedule Creation**:
   - [ ] Click "Advanced" button on existing formula
   - [ ] Add first schedule with date range filter
   - [ ] Add second schedule with days-of-week filter
   - [ ] Save and verify both schedules persist

3. **Sequential Evaluation**:
   - [ ] Create 2 overlapping schedules (e.g., Jan 1-31, Jan 15-Feb 15)
   - [ ] Verify first matching schedule wins for overlapping dates
   - [ ] Verify distinct dates use correct schedule

4. **Filter Combinations**:
   - [ ] Schedule with date range only
   - [ ] Schedule with days of week only
   - [ ] Schedule with date range + days of week
   - [ ] Schedule with all filters (date + days + lead time)

5. **UI Interactions**:
   - [ ] Copy schedule → should duplicate with timestamp
   - [ ] Move schedule up/down → should resequence correctly
   - [ ] Delete schedule → should remove and resequence
   - [ ] Rename schedule → should prevent duplicates
   - [ ] Collapse/expand schedule → should toggle content

6. **Validation**:
   - [ ] Empty formula → should show error
   - [ ] No filters → should show error
   - [ ] Invalid date range (from > to) → should show error
   - [ ] Overlapping schedules → should warn (not block for MVP)

7. **Data Persistence**:
   - [ ] Save multi-schedule → localStorage updated
   - [ ] Save multi-schedule → backend AJAX called
   - [ ] Reload report → schedules load correctly
   - [ ] Recalculate formulas → values update correctly

---

## Rollback Plan

If critical issues arise during MVP deployment:

### Emergency Rollback
1. **Disable multi-schedule UI**: Hide "Advanced" button with CSS
2. **Force legacy mode**: Set `isMultiSchedule = false` for all formulas
3. **Use existing single formula flow**: No code changes needed

### Graceful Degradation
- If backend rejects new format, catch error and show user message
- If evaluation fails, fall back to legacy formula
- If UI breaks, hide multi-schedule dialog and log error

---

## Timeline Estimate

| Phase | Task | Time | Priority |
|-------|------|------|----------|
| 1 | Core Infrastructure | 1-2 hours | CRITICAL |
| 2 | Evaluation Logic | 1 hour | CRITICAL |
| 3 | UI Integration | 2 hours | CRITICAL |
| 4 | Save & Validation | 1 hour | CRITICAL |
| 5 | Backward Compatibility | 30 min | HIGH |
| 6 | CSS Styling | 30 min | MEDIUM |
| **TOTAL** | | **6 hours** | |

**Testing**: Add 2 hours for manual testing
**Buffer**: Add 2 hours for unexpected issues

**Total MVP Estimate**: 10 hours

---

## CRITICAL: Cross-File Formula Evaluation

**IMPORTANT**: Formulas are evaluated in THREE places, not just DynamicReportJS.js!

### Files That Need Multi-Schedule Support

1. **DynamicReportJS.js** (Lines 5189-5398):
   - Primary formula definition and evaluation
   - Main `addCalculation()` function
   - ✅ MUST be updated with multi-schedule logic

2. **ReportDashboardJS.js** (Lines 2253-2378):
   - Table display formula evaluation
   - `processAndPopulateTable()` calls formula application
   - ⚠️ MUST also support multi-schedule or formulas won't work in table view
   - **Action**: Need to identify where formulas are applied and add similar multi-schedule check

3. **gridReportSummary.js**:
   - Card/grid display formula evaluation
   - ⚠️ MUST also support multi-schedule or formulas won't work in card view
   - **Action**: Need to identify where formulas are applied and add similar multi-schedule check

### Strategy for Cross-File Consistency

**Option 1: Extract to Shared Function** (RECOMMENDED)
- Create `evaluateFormulaForRow(formulaConfig, row, calcName)` function
- Place in DynamicReportJS.js or separate shared file
- Call from all three files
- ✅ Single source of truth
- ✅ Consistent behavior across views
- ✅ Easier to maintain

**Option 2: Duplicate Logic** (FASTER for MVP)
- Copy multi-schedule evaluation logic to all three files
- ⚠️ Risk of inconsistencies
- ⚠️ Harder to maintain
- ✅ Faster to implement
- ✅ Less refactoring risk

**Recommendation for MVP**: Use Option 2 (duplicate) to meet today's deadline, then refactor to Option 1 post-MVP.

### Implementation Checklist

- [ ] Update `addCalculation()` in DynamicReportJS.js
- [ ] Find and update formula evaluation in ReportDashboardJS.js
- [ ] Find and update formula evaluation in gridReportSummary.js
- [ ] Test multi-schedule in all three views (definition, table, card)
- [ ] Verify backward compatibility in all three views

---

## Known Limitations (MVP)

1. **No visual timeline**: Schedules shown as list, not calendar
2. **Warning-only overlap detection**: Doesn't block conflicting schedules
3. **No formula preview**: Can't test calculation before save
4. **Limited filter types**: Only date, days, lead time (no custom filters)
5. **No bulk operations**: Must configure schedules one by one
6. **No template system**: Can't save schedule patterns for reuse

These can be addressed in post-MVP iterations.

---

## Success Criteria

✅ **Must Have (MVP)**:
1. Create multi-schedule formulas with filters
2. Sequential evaluation (first match wins)
3. Backward compatibility with old single formulas
4. Save/load from localStorage and backend
5. Basic validation (empty checks, date range validation)

🎯 **Nice to Have (Post-MVP)**:
1. Visual overlap warnings in UI
2. Formula preview/test functionality
3. Schedule templates
4. Bulk schedule operations
5. Advanced filter combinations
6. Timeline/calendar view

---

## Questions Resolved (with Assumptions)

1. **Sequential Evaluation**: First match wins ✓
2. **Filter Scope**: Per-schedule filters ✓
3. **Backward Compatibility**: Support old format ✓
4. **UI Integration**: Keep single + add advanced ✓
5. **Validation**: Warn but allow save ✓

**Note**: User can request changes to these assumptions if different behavior is needed.

---

## Quick Implementation Summary for MVP

### What Changes:
1. **DynamicReportJS.js** (Lines ~5189-5398):
   - Add 2 helper functions: `buildFilterStringFromSchedule()`, `evaluateScheduleFilter()`
   - Modify `addCalculation()`: Add multi-schedule check at start of row loop
   - No changes to existing single-formula code (backward compatible)

2. **ReportDashboardJS.js** (Lines ~2253-2378):
   - Duplicate multi-schedule logic from DynamicReportJS
   - Add same helper functions
   - Modify where formulas are applied in table rendering

3. **gridReportSummary.js**:
   - Duplicate multi-schedule logic from DynamicReportJS
   - Add same helper functions
   - Modify where formulas are applied in card rendering

4. **UI (New Multi-Schedule Dialog)**:
   - Add dialog HTML (after line 729 in DynamicReportJS)
   - Add schedule management functions (adapted from algojs.js)
   - Add "Advanced" button to formula list
   - Add CSS styles

### What Stays the Same:
- ✅ Existing single formulas work unchanged
- ✅ Shift patterns (`column{N}`) work in all schedules
- ✅ DATE_RANGE() and DAY_OF_WEEK() functions reused
- ✅ Backend data structure (formulas remain an object)
- ✅ localStorage persistence mechanism
- ✅ All existing formula features preserved

### Testing Priority:
1. Verify single formulas still work (backward compatibility)
2. Create multi-schedule formula in DynamicReportJS
3. Test display in table view (ReportDashboardJS)
4. Test display in card view (gridReportSummary)
5. Verify shift patterns work in multi-schedule
6. Test sequential evaluation (first match wins)

### Risk Mitigation:
- Keep single-formula code path completely unchanged
- Use `isMultiSchedule` flag for safe detection
- Add error handling around eval() calls
- Test in all three views before deploying
