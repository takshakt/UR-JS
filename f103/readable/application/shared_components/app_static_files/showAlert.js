function showAlert(input) {
    // Common Toast configuration
    const Toast = Swal.mixin({
        toast: true,
        position: "top-end",
        timerProgressBar: true,
        didOpen: (toast) => {
            toast.onmouseenter = Swal.stopTimer;
            toast.onmouseleave = Swal.resumeTimer;
        }
    });

    // Helper to show a single toast
    function fireToast({ message, title = '', icon = 'success', timer = 2500 }) {
        const showConfirmation = (icon === 'error' || icon === 'warning');
        Toast.update({
            showConfirmButton: showConfirmation,
            timer: timer
        });
        Toast.fire({
            icon: icon,
            title: title || message,  // If title empty, show message as title
            text: title ? message : '' // If title exists, put message in text
        });
    }

    // Determine if input is array or single object/string
    if (Array.isArray(input)) {
        input.forEach(item => {
            // Normalize in case item is a string
            if (typeof item === 'string') {
                fireToast({ message: item });
            } else {
                // item should be an object with at least `message`
                fireToast(item);
            }
        });
    } else if (typeof input === 'string') {
        // Single message string
        fireToast({ message: input });
    } else if (input && typeof input === 'object' && input.message) {
        // Single object with message parameter
        fireToast(input);
    } else {
        console.warn('Invalid input to showAlert, expected message string or array of message objects.');
    }
}


function showAlertToastr(input) {
        // Base Toastr default options (can be overridden per toast)
    const baseToastrOptions = {
        "debug": false,
        "newestOnTop": true,
        "progressBar": true,
        "positionClass": "toast-top-right",
        "preventDuplicates": false,
        "onclick": null,
        "showDuration": "1000",
        "hideDuration": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "fadeIn",
        "hideMethod": "fadeOut"
    };

    // Helper to normalize icon input
    function normalizeIcon(rawIcon) {
        if (rawIcon === true) return 'success';
        if (rawIcon === false) return 'error';

        if (typeof rawIcon === 'string') {
            const iconMap = {
                's': 'success',
                'w': 'warning',
                'e': 'error',
                'i': 'info'
            };
            const lowerIcon = rawIcon.toLowerCase();
            return iconMap[lowerIcon] || lowerIcon;
        }

        return 'success'; // default
    }

    function fireToast({ message, title = '', icon = 'success', timeOut = 10000 }) {
        if (!message) return;

        // Normalize the icon value before usage
        const normIcon = normalizeIcon(icon);

        // Customize options depending on icon
        const isSticky = (normIcon === 'error' || normIcon === 'warning');

        const options = Object.assign({}, baseToastrOptions, {
            closeButton: isSticky,       // show close button if error/warning
            timeOut: isSticky ? 0 : timeOut,
            extendedTimeOut: isSticky ? 0 : 1000
        });

        toastr.options = options;

        const toastFunc = toastr[normIcon] || toastr.success;
        toastFunc(message, title);
    }

    if (Array.isArray(input)) {
        input.forEach(function(item, index) {
            setTimeout(() => {
                if (typeof item === 'string') {
                    fireToast({ message: item });
                } else if (item && typeof item === 'object' && item.message) {
                    fireToast(item);
                }
            }, index * 100);
        });
    } else if (typeof input === 'string') {
        fireToast({ message: input });
    } else if (input && typeof input === 'object' && input.message) {
        fireToast(input);
    } else {
        console.warn('Invalid input to showAlert, expected message string or array of message objects.');
    }
}