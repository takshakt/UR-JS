  document.addEventListener('DOMContentLoaded', function() { 
    const jsonString = apex.item("P16_JSON_DATA").getValue();  
    console.log("DEBUG: P16_JSON_DATA value (raw string):", jsonString);

    const cardsContainer = document.getElementById('cardsContainer');

    if (!jsonString || jsonString.trim() === '') {
      cardsContainer.innerHTML = `
        <div class="col-span-full bg-red-800 bg-opacity-30 border border-red-700 text-red-300 px-4 py-3 rounded relative mx-auto max-w-lg" role="alert">
          <strong class="font-bold">Error!</strong>
          <span class="block sm:inline">No JSON data found or it's empty in P16_JSON_DATA.</span>
        </div>
      `;
      console.error("No JSON string found or it's empty in P16_JSON_DATA.");
      return;
    }

    let data;
    try {
      data = JSON.parse(jsonString.trim());
      console.log("DEBUG: Parsed JSON data:", data);
      console.log("DEBUG: Type of parsed data:", typeof data);
      console.log("DEBUG: Length of parsed data array:", data.length);
    } catch (e) {
      cardsContainer.innerHTML = `
        <div class="col-span-full bg-red-800 bg-opacity-30 border border-red-700 text-red-300 px-4 py-3 rounded relative mx-auto max-w-lg" role="alert">
          <strong class="font-bold">Error!</strong>
          <span class="block sm:inline">Failed to parse JSON data. Ensure your PL/SQL generates valid JSON. Details in console.</span>
        </div>
      `;
      console.error("Error parsing JSON:", e);
      return;
    }

    if (!Array.isArray(data) || data.length === 0) {
      cardsContainer.innerHTML = `
        <div class="col-span-full bg-yellow-800 bg-opacity-30 border border-yellow-700 text-yellow-300 px-4 py-3 rounded relative mx-auto max-w-lg" role="alert">
          <strong class="font-bold">Info:</strong>
          <span class="block sm:inline">No data rows found in the JSON to display.</span>
        </div>
      `;
      console.log("DEBUG: No data rows found or data is not an array after parsing.");
      return;
    }

    // If we reach here, data is a valid non-empty array, so clear the loading message now.
    cardsContainer.innerHTML = '';

    // Function to handle editing
    function makeFieldEditable(event, rowData, key, originalElement) {
      event.stopPropagation(); // Prevent card click event if any

      const currentValue = originalElement.textContent;
      const input = document.createElement('input');
      input.type = 'text';
      input.value = currentValue;
      input.classList.add('edit-input'); // Apply Tailwind-like styling

      // Replace the original element with the input
      originalElement.parentNode.replaceChild(input, originalElement);
      input.focus();

      // Function to handle saving/reverting
      function saveChanges() {
        const newValue = input.value.trim();
        const cardId = rowData.ID; // Get the ID of the current card

        // Only proceed if the value has actually changed
        if (newValue === currentValue) {
          revertToSpan();
          return;
        }

        console.log(`DEBUG: Attempting to save Card ID: "${cardId}", Field: "${key}" with new value: "${newValue}"`);

        // Call APEX AJAX Process
        apex.server.process('SAVE_CARD_FIELD', { // Replace 'SAVE_CARD_FIELD' with your actual APEX On-Demand Process name
            x01: cardId,      // Pass the record ID
            x02: key,         // Pass the field name
            x03: newValue     // Pass the new value
        }, {
            success: function(pData) {
                // pData will contain the JSON response from your APEX process
                if (pData.success) {
                    console.log('DEBUG: APEX process successful:', pData.message);
                    rowData[key] = newValue; // Update the in-memory data if save was successful
                    revertToSpan(newValue); // Revert to span with new value
                    apex.message.showPageSuccess('Changes saved successfully!');
                } else {
                    console.error('DEBUG: APEX process error:', pData.message);
                    revertToSpan(currentValue); // Revert to original value on error
                    apex.message.showErrors({
                      type: "error",
                      message: "Failed to save: " + pData.message,
                      duration: 5000
                    });
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error('DEBUG: AJAX call error:', textStatus, errorThrown, jqXHR);
                revertToSpan(currentValue); // Revert to original value on network/server error
                apex.message.showErrors({
                  type: "error",
                  message: "Network error or server issue. Could not save changes.",
                  duration: 5000
                });
            },
            // Set dataType to 'json' if your APEX process returns JSON
            dataType: 'json'
        });

        function revertToSpan(displayValue = currentValue) {
          const newDisplaySpan = document.createElement('span');
          newDisplaySpan.classList.add('text-gray-200', 'text-sm', 'w-2/5', 'break-words', 'editable-value'); /* Adjusted from w-3/5 to w-2/5 */
          newDisplaySpan.textContent = displayValue;
          newDisplaySpan.onclick = (e) => makeFieldEditable(e, rowData, key, newDisplaySpan);
          input.parentNode.replaceChild(newDisplaySpan, input);
        }
      }

      input.addEventListener('blur', saveChanges);
      input.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
          input.blur(); // Trigger blur to save changes
        }
      });
    }

    // --- Create dynamic cards from the JSON data ---
    data.forEach(rowData => {
      const card = document.createElement('div');
      card.classList.add(
        'card-item',
        'bg-gray-800',
        'rounded-xl',
        'p-6',
        'shadow-lg',
        'border',
        'border-gray-700',
        'flex',
        'flex-col'
      );

      // Determine the main title for the card
      const cardTitleText = rowData.HOTEL_NAME || rowData.ID || 'Unnamed Item';
      const titleDiv = document.createElement('h2');
      titleDiv.classList.add('card-title', 'text-xl', 'font-semibold', 'text-white', 'mb-3', 'pb-3');

      // Make the main title editable
      const titleSpan = document.createElement('span');
      titleSpan.classList.add('editable-value');
      titleSpan.textContent = cardTitleText;
      titleSpan.onclick = (e) => {
        const titleKey = rowData.HOTEL_NAME ? 'HOTEL_NAME' : 'ID';
        makeFieldEditable(e, rowData, titleKey, titleSpan);
      };
      titleDiv.appendChild(titleSpan);
      card.appendChild(titleDiv);


      const contentDiv = document.createElement('div');
      contentDiv.classList.add('flex-grow');

      Object.keys(rowData).forEach(key => {
        // Skip the main title key if it was used for the title display
        if (key === 'HOTEL_NAME' && rowData.HOTEL_NAME) return;
        if (key === 'ID' && rowData.HOTEL_NAME) return;
        if (key === 'ID' && !rowData.HOTEL_NAME && cardTitleText === rowData.ID) return;

        const value = rowData[key];
        if (value !== null && value !== undefined && String(value).trim() !== '') {
            const fieldContainer = document.createElement('div');
            fieldContainer.classList.add('flex', 'items-center', 'mb-2');

            const label = document.createElement('span');
            label.classList.add('field-label', 'text-sm', 'font-medium', 'w-3/5'); /* Adjusted from w-2/5 to w-3/5 */
            label.textContent = key.replace(/_/g, ' ') + ':';

            const valueDisplaySpan = document.createElement('span');
            valueDisplaySpan.classList.add('text-gray-200', 'text-sm', 'w-2/5', 'break-words', 'editable-value'); /* Adjusted from w-3/5 to w-2/5 */
            valueDisplaySpan.textContent = value;

            // Add click event listener to make this field editable
            valueDisplaySpan.onclick = (e) => makeFieldEditable(e, rowData, key, valueDisplaySpan);

            fieldContainer.appendChild(label);
            fieldContainer.appendChild(valueDisplaySpan);
            contentDiv.appendChild(fieldContainer);
        }
      });

      card.appendChild(contentDiv);
      cardsContainer.appendChild(card);
    });
    console.log("DEBUG: Cards rendering process completed.");
  });