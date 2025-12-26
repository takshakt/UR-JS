/**
 * BugReporter - Portable Bug Reporting Widget for Oracle APEX
 * Version 1.0.0
 *
 * A drop-in bug reporting solution that captures diagnostics, screenshots,
 * and submits issues via webhook (n8n compatible).
 */
(function(global) {
  'use strict';

  // ============================================================
  // CDN Dependencies
  // ============================================================
  const CDN_DEPS = {
    html2canvas: {
      url: 'https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js',
      check: () => typeof html2canvas !== 'undefined'
    }
  };

  // ============================================================
  // Embedded CSS Styles
  // ============================================================
  const CSS_STYLES = `
    /* CSS Variables for Theming */
    .bug-reporter {
      --br-bg: #ffffff;
      --br-text: #1a1a2e;
      --br-text-muted: #6b7280;
      --br-border: #e5e7eb;
      --br-input-bg: #f9fafb;
      --br-accent: #4f46e5;
      --br-accent-hover: #4338ca;
      --br-accent-light: rgba(79, 70, 229, 0.1);
      --br-success: #10b981;
      --br-error: #ef4444;
      --br-warning: #f59e0b;
      --br-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);
      --br-radius: 12px;
      --br-radius-sm: 8px;
      --br-transition: 0.2s ease;
    }

    .bug-reporter.dark {
      --br-bg: #121212;
      --br-text: #e4e4e7;
      --br-text-muted: #a1a1aa;
      --br-border: #27272a;
      --br-input-bg: #18181b;
      --br-accent: #6366f1;
      --br-accent-hover: #818cf8;
      --br-accent-light: rgba(99, 102, 241, 0.2);
    }

    /* Floating Button */
    .bug-reporter-btn {
      position: fixed;
      width: 56px;
      height: 56px;
      border-radius: 50%;
      background: var(--br-accent);
      border: none;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 14px rgba(79, 70, 229, 0.4);
      transition: all var(--br-transition);
      z-index: 99998;
    }

    .bug-reporter-btn.bottom-right {
      bottom: 24px;
      right: 24px;
    }

    .bug-reporter-btn.bottom-left {
      bottom: 24px;
      left: 24px;
    }

    .bug-reporter-btn.top-right {
      top: 24px;
      right: 24px;
    }

    .bug-reporter-btn.top-left {
      top: 24px;
      left: 24px;
    }

    .bug-reporter-btn:hover {
      transform: scale(1.1);
      box-shadow: 0 6px 20px rgba(79, 70, 229, 0.5);
    }

    .bug-reporter-btn:active {
      transform: scale(0.95);
    }

    .bug-reporter-btn svg {
      width: 24px;
      height: 24px;
      color: white;
      fill: none;
      stroke: currentColor;
      stroke-width: 2;
    }

    .bug-reporter-btn-text {
      position: absolute;
      right: 100%;
      margin-right: 12px;
      padding: 6px 12px;
      background: var(--br-bg);
      color: var(--br-text);
      border-radius: var(--br-radius-sm);
      font-size: 14px;
      font-weight: 500;
      white-space: nowrap;
      box-shadow: var(--br-shadow);
      opacity: 0;
      pointer-events: none;
      transition: opacity var(--br-transition);
    }

    .bug-reporter-btn:hover .bug-reporter-btn-text {
      opacity: 1;
    }

    /* Modal Overlay */
    .bug-reporter-overlay {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.5);
      backdrop-filter: blur(4px);
      display: none;
      align-items: center;
      justify-content: center;
      z-index: 99999;
      padding: 20px;
    }

    .bug-reporter-overlay.active {
      display: flex;
    }

    /* Modal */
    .bug-reporter-modal {
      background: var(--br-bg);
      border-radius: var(--br-radius);
      box-shadow: var(--br-shadow);
      width: 100%;
      max-width: 560px;
      max-height: 90vh;
      overflow: hidden;
      display: flex;
      flex-direction: column;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
      color: var(--br-text);
      animation: bugReporterSlideIn 0.3s ease;
    }

    @keyframes bugReporterSlideIn {
      from {
        opacity: 0;
        transform: translateY(-20px) scale(0.95);
      }
      to {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
    }

    /* Modal Header */
    .bug-reporter-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 16px 20px;
      border-bottom: 1px solid var(--br-border);
      flex-shrink: 0;
    }

    .bug-reporter-title {
      font-size: 18px;
      font-weight: 600;
      margin: 0;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .bug-reporter-title svg {
      width: 20px;
      height: 20px;
      color: var(--br-accent);
    }

    .bug-reporter-close {
      width: 32px;
      height: 32px;
      border: none;
      background: transparent;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 6px;
      color: var(--br-text-muted);
      transition: all var(--br-transition);
    }

    .bug-reporter-close:hover {
      background: var(--br-input-bg);
      color: var(--br-text);
    }

    .bug-reporter-close svg {
      width: 20px;
      height: 20px;
    }

    /* Modal Body */
    .bug-reporter-body {
      flex: 1;
      overflow-y: auto;
      padding: 20px;
    }

    /* Screenshot Preview */
    .bug-reporter-screenshot {
      margin-bottom: 20px;
      padding: 12px;
      background: var(--br-input-bg);
      border: 1px solid var(--br-border);
      border-radius: var(--br-radius-sm);
    }

    .bug-reporter-screenshot-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 10px;
    }

    .bug-reporter-screenshot-label {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 13px;
      font-weight: 500;
      color: var(--br-success);
    }

    .bug-reporter-screenshot-label svg {
      width: 16px;
      height: 16px;
    }

    .bug-reporter-screenshot-actions {
      display: flex;
      gap: 8px;
    }

    .bug-reporter-screenshot-btn {
      padding: 4px 10px;
      font-size: 12px;
      border: 1px solid var(--br-border);
      background: var(--br-bg);
      color: var(--br-text-muted);
      border-radius: 4px;
      cursor: pointer;
      transition: all var(--br-transition);
    }

    .bug-reporter-screenshot-btn:hover {
      border-color: var(--br-accent);
      color: var(--br-accent);
    }

    .bug-reporter-screenshot-preview {
      width: 100%;
      border-radius: 6px;
      border: 1px solid var(--br-border);
      display: none;
    }

    .bug-reporter-screenshot-preview.visible {
      display: block;
    }

    .bug-reporter-screenshot-preview img {
      width: 100%;
      height: auto;
      display: block;
      border-radius: 5px;
    }

    /* Form Fields */
    .bug-reporter-field {
      margin-bottom: 16px;
    }

    .bug-reporter-label {
      display: block;
      font-size: 14px;
      font-weight: 500;
      margin-bottom: 6px;
      color: var(--br-text);
    }

    .bug-reporter-label .required {
      color: var(--br-error);
      margin-left: 2px;
    }

    .bug-reporter-input,
    .bug-reporter-textarea {
      width: 100%;
      padding: 10px 12px;
      font-size: 14px;
      border: 1px solid var(--br-border);
      border-radius: var(--br-radius-sm);
      background: var(--br-input-bg);
      color: var(--br-text);
      transition: all var(--br-transition);
      box-sizing: border-box;
    }

    .bug-reporter-input:focus,
    .bug-reporter-textarea:focus {
      outline: none;
      border-color: var(--br-accent);
      box-shadow: 0 0 0 3px var(--br-accent-light);
    }

    .bug-reporter-input.error,
    .bug-reporter-textarea.error {
      border-color: var(--br-error);
    }

    .bug-reporter-textarea {
      min-height: 100px;
      resize: vertical;
      font-family: inherit;
    }

    .bug-reporter-error-msg {
      font-size: 12px;
      color: var(--br-error);
      margin-top: 4px;
      display: none;
    }

    .bug-reporter-error-msg.visible {
      display: block;
    }

    /* Radio Groups */
    .bug-reporter-radio-group {
      display: flex;
      gap: 24px;
      margin-bottom: 16px;
    }

    .bug-reporter-radio-section {
      flex: 1;
    }

    .bug-reporter-radio-title {
      font-size: 14px;
      font-weight: 500;
      margin-bottom: 8px;
      color: var(--br-text);
    }

    .bug-reporter-radio-options {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .bug-reporter-radio {
      display: flex;
      align-items: center;
      gap: 8px;
      cursor: pointer;
      font-size: 14px;
      color: var(--br-text);
    }

    .bug-reporter-radio input {
      width: 16px;
      height: 16px;
      accent-color: var(--br-accent);
      cursor: pointer;
    }

    /* File Attachment */
    .bug-reporter-attachments {
      margin-bottom: 16px;
    }

    .bug-reporter-dropzone {
      border: 2px dashed var(--br-border);
      border-radius: var(--br-radius-sm);
      padding: 20px;
      text-align: center;
      cursor: pointer;
      transition: all var(--br-transition);
    }

    .bug-reporter-dropzone:hover,
    .bug-reporter-dropzone.dragover {
      border-color: var(--br-accent);
      background: var(--br-accent-light);
    }

    .bug-reporter-dropzone-icon {
      width: 32px;
      height: 32px;
      margin: 0 auto 8px;
      color: var(--br-text-muted);
    }

    .bug-reporter-dropzone-text {
      font-size: 14px;
      color: var(--br-text-muted);
    }

    .bug-reporter-dropzone-text span {
      color: var(--br-accent);
      font-weight: 500;
    }

    .bug-reporter-dropzone-hint {
      font-size: 12px;
      color: var(--br-text-muted);
      margin-top: 4px;
    }

    .bug-reporter-file-input {
      display: none;
    }

    .bug-reporter-file-list {
      margin-top: 10px;
    }

    .bug-reporter-file-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 8px 12px;
      background: var(--br-input-bg);
      border: 1px solid var(--br-border);
      border-radius: 6px;
      margin-bottom: 6px;
    }

    .bug-reporter-file-info {
      display: flex;
      align-items: center;
      gap: 8px;
      overflow: hidden;
    }

    .bug-reporter-file-info svg {
      width: 16px;
      height: 16px;
      color: var(--br-text-muted);
      flex-shrink: 0;
    }

    .bug-reporter-file-name {
      font-size: 13px;
      color: var(--br-text);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .bug-reporter-file-size {
      font-size: 12px;
      color: var(--br-text-muted);
      flex-shrink: 0;
    }

    .bug-reporter-file-remove {
      width: 24px;
      height: 24px;
      border: none;
      background: transparent;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--br-text-muted);
      border-radius: 4px;
      transition: all var(--br-transition);
      flex-shrink: 0;
    }

    .bug-reporter-file-remove:hover {
      background: rgba(239, 68, 68, 0.1);
      color: var(--br-error);
    }

    .bug-reporter-file-remove svg {
      width: 14px;
      height: 14px;
    }

    /* Diagnostics Summary */
    .bug-reporter-diagnostics {
      padding: 12px;
      background: var(--br-input-bg);
      border: 1px solid var(--br-border);
      border-radius: var(--br-radius-sm);
      margin-bottom: 16px;
    }

    .bug-reporter-diagnostics-title {
      font-size: 13px;
      font-weight: 500;
      color: var(--br-text-muted);
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .bug-reporter-diagnostics-title svg {
      width: 14px;
      height: 14px;
    }

    .bug-reporter-diagnostics-list {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
    }

    .bug-reporter-diagnostics-item {
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 12px;
      color: var(--br-success);
      padding: 4px 8px;
      background: rgba(16, 185, 129, 0.1);
      border-radius: 4px;
    }

    .bug-reporter-diagnostics-item svg {
      width: 12px;
      height: 12px;
    }

    .bug-reporter-diagnostics-item.warning {
      color: var(--br-warning);
      background: rgba(245, 158, 11, 0.1);
    }

    .bug-reporter-diagnostics-item.error {
      color: var(--br-error);
      background: rgba(239, 68, 68, 0.1);
    }

    /* Modal Footer */
    .bug-reporter-footer {
      display: flex;
      justify-content: flex-end;
      gap: 12px;
      padding: 16px 20px;
      border-top: 1px solid var(--br-border);
      flex-shrink: 0;
    }

    .bug-reporter-btn-secondary,
    .bug-reporter-btn-primary {
      padding: 10px 20px;
      font-size: 14px;
      font-weight: 500;
      border-radius: var(--br-radius-sm);
      cursor: pointer;
      transition: all var(--br-transition);
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .bug-reporter-btn-secondary {
      background: transparent;
      border: 1px solid var(--br-border);
      color: var(--br-text);
    }

    .bug-reporter-btn-secondary:hover {
      background: var(--br-input-bg);
    }

    .bug-reporter-btn-primary {
      background: var(--br-accent);
      border: none;
      color: white;
    }

    .bug-reporter-btn-primary:hover {
      background: var(--br-accent-hover);
    }

    .bug-reporter-btn-primary:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }

    .bug-reporter-btn-primary svg {
      width: 16px;
      height: 16px;
    }

    /* Loading Spinner */
    .bug-reporter-spinner {
      width: 16px;
      height: 16px;
      border: 2px solid rgba(255,255,255,0.3);
      border-top-color: white;
      border-radius: 50%;
      animation: bugReporterSpin 0.8s linear infinite;
    }

    @keyframes bugReporterSpin {
      to { transform: rotate(360deg); }
    }

    /* Success State */
    .bug-reporter-success {
      display: none;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 40px 20px;
      text-align: center;
      position: relative;
    }

    .bug-reporter-success.active {
      display: flex;
    }

    .bug-reporter-success-icon {
      width: 64px;
      height: 64px;
      border-radius: 50%;
      background: rgba(16, 185, 129, 0.1);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 16px;
    }

    .bug-reporter-success-icon svg {
      width: 32px;
      height: 32px;
      color: var(--br-success);
    }

    .bug-reporter-success-title {
      font-size: 20px;
      font-weight: 600;
      margin-bottom: 8px;
      color: var(--br-text);
    }

    .bug-reporter-success-message {
      font-size: 14px;
      color: var(--br-text-muted);
      margin-bottom: 4px;
    }

    .bug-reporter-success-id {
      font-size: 12px;
      color: var(--br-text-muted);
      font-family: monospace;
      background: var(--br-input-bg);
      padding: 4px 8px;
      border-radius: 4px;
    }

    .bug-reporter-success-close {
      margin-top: 20px;
      min-width: 120px;
    }

    .bug-reporter-success-x {
      position: absolute;
      top: 12px;
      right: 12px;
      background: none;
      border: none;
      color: var(--br-text-muted);
      cursor: pointer;
      padding: 4px;
      border-radius: 4px;
      transition: all var(--br-transition);
    }

    .bug-reporter-success-x:hover {
      color: var(--br-text);
      background: var(--br-input-bg);
    }

    .bug-reporter-success-x svg {
      width: 20px;
      height: 20px;
    }

    /* Error State */
    .bug-reporter-error-state {
      padding: 12px;
      background: rgba(239, 68, 68, 0.1);
      border: 1px solid var(--br-error);
      border-radius: var(--br-radius-sm);
      margin-bottom: 16px;
      display: none;
    }

    .bug-reporter-error-state.visible {
      display: block;
    }

    .bug-reporter-error-state-text {
      font-size: 14px;
      color: var(--br-error);
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .bug-reporter-error-state-text svg {
      width: 16px;
      height: 16px;
      flex-shrink: 0;
    }

    /* Responsive */
    @media (max-width: 600px) {
      .bug-reporter-modal {
        max-height: 100vh;
        border-radius: 0;
      }

      .bug-reporter-overlay {
        padding: 0;
      }

      .bug-reporter-radio-group {
        flex-direction: column;
        gap: 16px;
      }

      .bug-reporter-btn {
        width: 48px;
        height: 48px;
      }

      .bug-reporter-btn.bottom-right,
      .bug-reporter-btn.bottom-left {
        bottom: 16px;
      }

      .bug-reporter-btn.bottom-right,
      .bug-reporter-btn.top-right {
        right: 16px;
      }

      .bug-reporter-btn.bottom-left,
      .bug-reporter-btn.top-left {
        left: 16px;
      }
    }
  `;

  // ============================================================
  // SVG Icons
  // ============================================================
  const ICONS = {
    bug: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m8 2 1.88 1.88"/><path d="M14.12 3.88 16 2"/><path d="M9 7.13v-1a3.003 3.003 0 1 1 6 0v1"/><path d="M12 20c-3.3 0-6-2.7-6-6v-3a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v3c0 3.3-2.7 6-6 6"/><path d="M12 20v-9"/><path d="M6.53 9C4.6 8.8 3 7.1 3 5"/><path d="M6 13H2"/><path d="M3 21c0-2.1 1.7-3.9 3.8-4"/><path d="M20.97 5c0 2.1-1.6 3.8-3.5 4"/><path d="M22 13h-4"/><path d="M17.2 17c2.1.1 3.8 1.9 3.8 4"/></svg>',
    help: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><path d="M12 17h.01"/></svg>',
    support: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>',
    close: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>',
    camera: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><circle cx="12" cy="13" r="3"/></svg>',
    check: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"/></svg>',
    upload: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" x2="12" y1="3" y2="15"/></svg>',
    file: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/></svg>',
    trash: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>',
    info: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>',
    alertCircle: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>',
    send: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m22 2-7 20-4-9-9-4Z"/><path d="M22 2 11 13"/></svg>',
    checkCircle: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><path d="m9 11 3 3L22 4"/></svg>'
  };

  // ============================================================
  // Utility Functions
  // ============================================================
  function generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      const r = Math.random() * 16 | 0;
      const v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  function formatFileSize(bytes) {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
  }

  function loadScript(url) {
    return new Promise((resolve, reject) => {
      const existing = document.querySelector(`script[src="${url}"]`);
      if (existing) { resolve(); return; }
      const script = document.createElement('script');
      script.src = url;
      script.onload = resolve;
      script.onerror = reject;
      document.head.appendChild(script);
    });
  }

  function debounce(func, wait) {
    let timeout;
    return function(...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), wait);
    };
  }

  // User Agent Parsing
  function parseUserAgent() {
    const ua = navigator.userAgent;
    let browser = 'Unknown';
    let os = 'Unknown';

    // Browser detection
    if (ua.includes('Firefox/')) {
      browser = 'Firefox ' + ua.match(/Firefox\/(\d+)/)?.[1];
    } else if (ua.includes('Edg/')) {
      browser = 'Edge ' + ua.match(/Edg\/(\d+)/)?.[1];
    } else if (ua.includes('Chrome/')) {
      browser = 'Chrome ' + ua.match(/Chrome\/(\d+)/)?.[1];
    } else if (ua.includes('Safari/') && !ua.includes('Chrome')) {
      browser = 'Safari ' + ua.match(/Version\/(\d+)/)?.[1];
    }

    // OS detection
    if (ua.includes('Windows NT 10')) os = 'Windows 10/11';
    else if (ua.includes('Windows NT')) os = 'Windows';
    else if (ua.includes('Mac OS X')) {
      const version = ua.match(/Mac OS X (\d+[._]\d+)/)?.[1]?.replace('_', '.');
      os = 'macOS ' + (version || '');
    }
    else if (ua.includes('Linux')) os = 'Linux';
    else if (ua.includes('Android')) os = 'Android';
    else if (ua.includes('iOS') || ua.includes('iPhone') || ua.includes('iPad')) os = 'iOS';

    return { browser: browser.trim(), os: os.trim() };
  }

  // ============================================================
  // Console Log Interceptor
  // ============================================================
  class ConsoleInterceptor {
    constructor(maxLogs = 50) {
      this.maxLogs = maxLogs;
      this.errors = [];
      this.warnings = [];
      this.originalError = console.error;
      this.originalWarn = console.warn;
      this.installed = false;
    }

    install() {
      if (this.installed) return;

      const self = this;

      console.error = function(...args) {
        self.captureLog('error', args);
        self.originalError.apply(console, args);
      };

      console.warn = function(...args) {
        self.captureLog('warn', args);
        self.originalWarn.apply(console, args);
      };

      // Capture unhandled errors
      window.addEventListener('error', (event) => {
        self.captureLog('error', [event.message], event.error?.stack);
      });

      // Capture unhandled promise rejections
      window.addEventListener('unhandledrejection', (event) => {
        self.captureLog('error', ['Unhandled Promise Rejection:', event.reason]);
      });

      this.installed = true;
    }

    captureLog(type, args, stack = null) {
      const entry = {
        message: args.map(arg => {
          if (typeof arg === 'object') {
            try { return JSON.stringify(arg); }
            catch { return String(arg); }
          }
          return String(arg);
        }).join(' '),
        stack: stack || new Error().stack,
        timestamp: new Date().toISOString()
      };

      const list = type === 'error' ? this.errors : this.warnings;
      list.push(entry);

      // Keep only last N entries
      if (list.length > this.maxLogs) {
        list.shift();
      }
    }

    getLogs() {
      return {
        errors: [...this.errors],
        warnings: [...this.warnings]
      };
    }

    clear() {
      this.errors = [];
      this.warnings = [];
    }
  }

  // ============================================================
  // Main BugReporter Class
  // ============================================================
  class BugReporter {
    constructor(options) {
      this.options = Object.assign({
        // Required
        webhookUrl: '',
        webhookApiKey: '',

        // Appearance
        position: 'bottom-right',
        theme: 'auto',
        buttonIcon: 'bug',
        buttonText: '',
        accentColor: '#4f46e5',
        zIndex: 99999,

        // Data Collection
        enableScreenshot: true,
        enableConsoleLogs: true,
        maxConsoleLogs: 50,
        enableFormCapture: true,
        sensitiveFields: ['password', 'credit_card', 'ssn', 'pin', 'cvv', 'secret', 'token'],

        // Attachments
        maxFileSize: 5 * 1024 * 1024,
        maxFiles: 3,
        allowedFileTypes: ['image/*', 'application/pdf', 'text/*', '.log', '.json', '.txt'],

        // APEX Integration
        apexProcessName: 'AJX_LOG_BUG_REPORT',

        // User Info
        userName: '',
        userEmail: '',
        userRole: '',

        // AI Extension (future)
        enableAIAnalysis: false,
        aiEndpoint: '',
        aiApiKey: '',

        // Callbacks
        onOpen: () => {},
        onSubmit: () => {},
        onSuccess: () => {},
        onError: () => {}
      }, options);

      this.consoleInterceptor = null;
      this.screenshot = null;
      this.attachments = [];
      this.isSubmitting = false;
      this.container = null;

      this.init();
    }

    async init() {
      // Inject styles
      this.injectStyles();

      // Setup console interceptor
      if (this.options.enableConsoleLogs) {
        this.consoleInterceptor = new ConsoleInterceptor(this.options.maxConsoleLogs);
        this.consoleInterceptor.install();
      }

      // Render UI
      this.render();
      this.setupEventListeners();
    }

    injectStyles() {
      if (!document.getElementById('bug-reporter-styles')) {
        const style = document.createElement('style');
        style.id = 'bug-reporter-styles';

        // Apply custom accent color
        let styles = CSS_STYLES;
        if (this.options.accentColor !== '#4f46e5') {
          styles = styles.replace(/#4f46e5/g, this.options.accentColor);
          styles = styles.replace(/#4338ca/g, this.options.accentColor);
        }

        style.textContent = styles;
        document.head.appendChild(style);
      }
    }

    getThemeClass() {
      if (this.options.theme === 'dark') return 'dark';
      if (this.options.theme === 'light') return '';
      // Auto-detect
      return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : '';
    }

    render() {
      // Create container
      this.container = document.createElement('div');
      this.container.className = `bug-reporter ${this.getThemeClass()}`;
      this.container.style.zIndex = this.options.zIndex;

      const buttonIcon = ICONS[this.options.buttonIcon] || ICONS.bug;

      this.container.innerHTML = `
        <!-- Floating Button -->
        <button class="bug-reporter-btn ${this.options.position}" aria-label="Report a bug">
          ${buttonIcon}
          ${this.options.buttonText ? `<span class="bug-reporter-btn-text">${escapeHtml(this.options.buttonText)}</span>` : ''}
        </button>

        <!-- Modal Overlay -->
        <div class="bug-reporter-overlay">
          <div class="bug-reporter-modal" role="dialog" aria-labelledby="bug-reporter-title">
            <!-- Form View -->
            <div class="bug-reporter-form-view">
              <!-- Header -->
              <div class="bug-reporter-header">
                <h2 class="bug-reporter-title" id="bug-reporter-title">
                  ${ICONS.bug}
                  Report an Issue
                </h2>
                <button type="button" class="bug-reporter-close" data-br-action="close-modal" aria-label="Close">
                  ${ICONS.close}
                </button>
              </div>

              <!-- Body -->
              <div class="bug-reporter-body">
                <!-- Error State -->
                <div class="bug-reporter-error-state">
                  <div class="bug-reporter-error-state-text">
                    ${ICONS.alertCircle}
                    <span class="bug-reporter-error-state-message"></span>
                  </div>
                </div>

                <!-- Screenshot -->
                <div class="bug-reporter-screenshot">
                  <div class="bug-reporter-screenshot-header">
                    <span class="bug-reporter-screenshot-label">
                      ${ICONS.check}
                      Screenshot captured
                    </span>
                    <div class="bug-reporter-screenshot-actions">
                      <button class="bug-reporter-screenshot-btn" data-br-action="preview">Preview</button>
                      <button class="bug-reporter-screenshot-btn" data-br-action="retake">Retake</button>
                    </div>
                  </div>
                  <div class="bug-reporter-screenshot-preview">
                    <img src="" alt="Screenshot preview">
                  </div>
                </div>

                <!-- Title -->
                <div class="bug-reporter-field">
                  <label class="bug-reporter-label">
                    Issue Title <span class="required">*</span>
                  </label>
                  <input type="text" class="bug-reporter-input" id="bug-reporter-title-input" placeholder="Brief description of the issue">
                  <div class="bug-reporter-error-msg">Please enter a title</div>
                </div>

                <!-- Description -->
                <div class="bug-reporter-field">
                  <label class="bug-reporter-label">
                    Description <span class="required">*</span>
                  </label>
                  <textarea class="bug-reporter-textarea" id="bug-reporter-description" placeholder="What happened? What were you trying to do?"></textarea>
                  <div class="bug-reporter-error-msg">Please enter a description</div>
                </div>

                <!-- Urgency & Impact -->
                <div class="bug-reporter-radio-group">
                  <div class="bug-reporter-radio-section">
                    <div class="bug-reporter-radio-title">Urgency</div>
                    <div class="bug-reporter-radio-options">
                      <label class="bug-reporter-radio">
                        <input type="radio" name="urgency" value="low" checked> Low
                      </label>
                      <label class="bug-reporter-radio">
                        <input type="radio" name="urgency" value="medium"> Medium
                      </label>
                      <label class="bug-reporter-radio">
                        <input type="radio" name="urgency" value="high"> High
                      </label>
                      <label class="bug-reporter-radio">
                        <input type="radio" name="urgency" value="critical"> Critical
                      </label>
                    </div>
                  </div>
                  <div class="bug-reporter-radio-section">
                    <div class="bug-reporter-radio-title">Impact</div>
                    <div class="bug-reporter-radio-options">
                      <label class="bug-reporter-radio">
                        <input type="radio" name="impact" value="single_user" checked> Just me
                      </label>
                      <label class="bug-reporter-radio">
                        <input type="radio" name="impact" value="team"> My team
                      </label>
                      <label class="bug-reporter-radio">
                        <input type="radio" name="impact" value="multiple_teams"> Multiple teams
                      </label>
                      <label class="bug-reporter-radio">
                        <input type="radio" name="impact" value="organization"> Entire organization
                      </label>
                    </div>
                  </div>
                </div>

                <!-- File Attachments -->
                <div class="bug-reporter-attachments">
                  <label class="bug-reporter-label">Attachments (optional)</label>
                  <div class="bug-reporter-dropzone">
                    <div class="bug-reporter-dropzone-icon">${ICONS.upload}</div>
                    <div class="bug-reporter-dropzone-text">
                      Drag files here or <span>click to browse</span>
                    </div>
                    <div class="bug-reporter-dropzone-hint">Max ${this.options.maxFiles} files, ${formatFileSize(this.options.maxFileSize)} each</div>
                  </div>
                  <input type="file" class="bug-reporter-file-input" multiple accept="${this.options.allowedFileTypes.join(',')}">
                  <div class="bug-reporter-file-list"></div>
                </div>

                <!-- Diagnostics Summary -->
                <div class="bug-reporter-diagnostics">
                  <div class="bug-reporter-diagnostics-title">
                    ${ICONS.info}
                    Diagnostics captured
                  </div>
                  <div class="bug-reporter-diagnostics-list"></div>
                </div>
              </div>

              <!-- Footer -->
              <div class="bug-reporter-footer">
                <button type="button" class="bug-reporter-btn-secondary" data-br-action="cancel">Cancel</button>
                <button type="button" class="bug-reporter-btn-primary" data-br-action="submit">
                  ${ICONS.send}
                  Submit Report
                </button>
              </div>
            </div>

            <!-- Success View -->
            <div class="bug-reporter-success">
              <button type="button" class="bug-reporter-success-x" data-br-action="close-success-x">
                ${ICONS.close}
              </button>
              <div class="bug-reporter-success-icon">
                ${ICONS.checkCircle}
              </div>
              <div class="bug-reporter-success-title">Report Submitted</div>
              <div class="bug-reporter-success-message">Thank you for your feedback!</div>
              <div class="bug-reporter-success-id"></div>
              <button type="button" class="bug-reporter-btn-primary bug-reporter-success-close" data-br-action="close-success">
                Close
              </button>
            </div>
          </div>
        </div>
      `;

      document.body.appendChild(this.container);
    }

    setupEventListeners() {
      const btn = this.container.querySelector('.bug-reporter-btn');
      const overlay = this.container.querySelector('.bug-reporter-overlay');
      const closeBtn = this.container.querySelector('.bug-reporter-close');
      const cancelBtn = this.container.querySelector('[data-br-action="cancel"]');
      const submitBtn = this.container.querySelector('[data-br-action="submit"]');
      const dropzone = this.container.querySelector('.bug-reporter-dropzone');
      const fileInput = this.container.querySelector('.bug-reporter-file-input');
      const screenshotActions = this.container.querySelector('.bug-reporter-screenshot-actions');

      // Open modal
      btn.addEventListener('click', () => this.open());

      // Close modal
      closeBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.close();
      });
      cancelBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.close();
      });

      // Close success view - both X button and Close button
      const successCloseBtn = this.container.querySelector('[data-br-action="close-success"]');
      const successXBtn = this.container.querySelector('[data-br-action="close-success-x"]');

      successCloseBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.close();
      });

      successXBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.close();
      });

      overlay.addEventListener('click', (e) => {
        if (e.target === overlay) {
          e.preventDefault();
          e.stopPropagation();
          this.close();
        }
      });

      // Keyboard
      document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && overlay.classList.contains('active')) {
          this.close();
        }
      });

      // Submit
      submitBtn.addEventListener('click', (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.submit();
      });

      // File handling
      dropzone.addEventListener('click', () => fileInput.click());
      dropzone.addEventListener('dragover', (e) => {
        e.preventDefault();
        dropzone.classList.add('dragover');
      });
      dropzone.addEventListener('dragleave', () => {
        dropzone.classList.remove('dragover');
      });
      dropzone.addEventListener('drop', (e) => {
        e.preventDefault();
        dropzone.classList.remove('dragover');
        this.handleFiles(e.dataTransfer.files);
      });
      fileInput.addEventListener('change', (e) => {
        this.handleFiles(e.target.files);
        fileInput.value = '';
      });

      // Screenshot actions
      screenshotActions.addEventListener('click', (e) => {
        const action = e.target.dataset.brAction;
        if (action === 'preview') this.toggleScreenshotPreview();
        if (action === 'retake') this.captureScreenshot();
      });

      // File list remove buttons (delegated)
      this.container.querySelector('.bug-reporter-file-list').addEventListener('click', (e) => {
        const removeBtn = e.target.closest('.bug-reporter-file-remove');
        if (removeBtn) {
          const index = parseInt(removeBtn.dataset.index);
          this.removeAttachment(index);
        }
      });
    }

    async open() {
      const overlay = this.container.querySelector('.bug-reporter-overlay');
      const formView = this.container.querySelector('.bug-reporter-form-view');
      const successView = this.container.querySelector('.bug-reporter-success');

      // Reset views
      formView.style.display = 'flex';
      formView.style.flexDirection = 'column';
      successView.classList.remove('active');

      // Reset form
      this.resetForm();

      // Show modal
      overlay.classList.add('active');

      // Capture screenshot
      if (this.options.enableScreenshot) {
        await this.captureScreenshot();
      }

      // Update diagnostics
      this.updateDiagnosticsSummary();

      // Callback
      this.options.onOpen();

      // Focus title input
      setTimeout(() => {
        this.container.querySelector('#bug-reporter-title-input').focus();
      }, 100);
    }

    close() {
      const overlay = this.container.querySelector('.bug-reporter-overlay');
      const formView = this.container.querySelector('.bug-reporter-form-view');
      const successView = this.container.querySelector('.bug-reporter-success');

      // Hide modal
      overlay.classList.remove('active');

      // Reset views - hide success, show form
      successView.classList.remove('active');
      formView.style.display = '';

      this.resetForm();
    }

    resetForm() {
      this.container.querySelector('#bug-reporter-title-input').value = '';
      this.container.querySelector('#bug-reporter-description').value = '';
      this.container.querySelector('input[name="urgency"][value="low"]').checked = true;
      this.container.querySelector('input[name="impact"][value="single_user"]').checked = true;
      this.attachments = [];
      this.renderFileList();
      this.hideError();
      this.clearValidationErrors();
    }

    async captureScreenshot() {
      const screenshotSection = this.container.querySelector('.bug-reporter-screenshot');
      const previewContainer = this.container.querySelector('.bug-reporter-screenshot-preview');
      const previewImg = previewContainer.querySelector('img');
      const label = this.container.querySelector('.bug-reporter-screenshot-label');

      // Hide modal temporarily for screenshot
      const overlay = this.container.querySelector('.bug-reporter-overlay');
      overlay.style.display = 'none';

      try {
        // Load html2canvas if needed
        if (!CDN_DEPS.html2canvas.check()) {
          await loadScript(CDN_DEPS.html2canvas.url);
        }

        // Wait a moment for modal to fully hide
        await new Promise(resolve => setTimeout(resolve, 100));

        // Capture
        const canvas = await html2canvas(document.body, {
          logging: false,
          useCORS: true,
          allowTaint: true,
          scale: 1
        });

        this.screenshot = canvas.toDataURL('image/png');
        previewImg.src = this.screenshot;

        label.innerHTML = `${ICONS.check} Screenshot captured`;
        label.style.color = 'var(--br-success)';
        screenshotSection.style.display = 'block';
        previewContainer.classList.remove('visible');

      } catch (error) {
        console.error('Screenshot capture failed:', error);
        label.innerHTML = `${ICONS.alertCircle} Screenshot failed`;
        label.style.color = 'var(--br-warning)';
        this.screenshot = null;
      }

      // Show modal again
      overlay.style.display = 'flex';
    }

    toggleScreenshotPreview() {
      const preview = this.container.querySelector('.bug-reporter-screenshot-preview');
      preview.classList.toggle('visible');
    }

    handleFiles(files) {
      const fileArray = Array.from(files);

      for (const file of fileArray) {
        // Check max files
        if (this.attachments.length >= this.options.maxFiles) {
          this.showError(`Maximum ${this.options.maxFiles} files allowed`);
          break;
        }

        // Check file size
        if (file.size > this.options.maxFileSize) {
          this.showError(`File "${file.name}" exceeds ${formatFileSize(this.options.maxFileSize)} limit`);
          continue;
        }

        // Read file
        const reader = new FileReader();
        reader.onload = (e) => {
          this.attachments.push({
            name: file.name,
            type: file.type,
            size: file.size,
            data: e.target.result.split(',')[1] // base64 without prefix
          });
          this.renderFileList();
        };
        reader.readAsDataURL(file);
      }
    }

    renderFileList() {
      const list = this.container.querySelector('.bug-reporter-file-list');

      if (this.attachments.length === 0) {
        list.innerHTML = '';
        return;
      }

      list.innerHTML = this.attachments.map((file, index) => `
        <div class="bug-reporter-file-item">
          <div class="bug-reporter-file-info">
            ${ICONS.file}
            <span class="bug-reporter-file-name">${escapeHtml(file.name)}</span>
          </div>
          <span class="bug-reporter-file-size">${formatFileSize(file.size)}</span>
          <button class="bug-reporter-file-remove" data-index="${index}" aria-label="Remove file">
            ${ICONS.trash}
          </button>
        </div>
      `).join('');
    }

    removeAttachment(index) {
      this.attachments.splice(index, 1);
      this.renderFileList();
    }

    updateDiagnosticsSummary() {
      const list = this.container.querySelector('.bug-reporter-diagnostics-list');
      const items = [];

      // Console logs
      if (this.options.enableConsoleLogs && this.consoleInterceptor) {
        const logs = this.consoleInterceptor.getLogs();
        const errorCount = logs.errors.length;
        const warnCount = logs.warnings.length;

        if (errorCount > 0 || warnCount > 0) {
          let text = 'Console: ';
          const parts = [];
          if (errorCount > 0) parts.push(`${errorCount} error${errorCount > 1 ? 's' : ''}`);
          if (warnCount > 0) parts.push(`${warnCount} warning${warnCount > 1 ? 's' : ''}`);
          text += parts.join(', ');

          items.push(`<span class="bug-reporter-diagnostics-item ${errorCount > 0 ? 'error' : 'warning'}">${ICONS.check} ${text}</span>`);
        } else {
          items.push(`<span class="bug-reporter-diagnostics-item">${ICONS.check} Console: No errors</span>`);
        }
      }

      // Session info
      if (this.isApexAvailable()) {
        items.push(`<span class="bug-reporter-diagnostics-item">${ICONS.check} APEX session</span>`);
      }

      // Form items
      if (this.options.enableFormCapture) {
        const itemCount = this.getFormItemCount();
        if (itemCount > 0) {
          items.push(`<span class="bug-reporter-diagnostics-item">${ICONS.check} Form values (${itemCount} items)</span>`);
        }
      }

      // Browser info
      const { browser, os } = parseUserAgent();
      items.push(`<span class="bug-reporter-diagnostics-item">${ICONS.check} ${browser} / ${os}</span>`);

      list.innerHTML = items.join('');
    }

    isApexAvailable() {
      return typeof apex !== 'undefined' && apex.env;
    }

    getFormItemCount() {
      if (!this.isApexAvailable()) return 0;
      try {
        const items = document.querySelectorAll('[id^="P"][id*="_"]');
        return items.length;
      } catch {
        return 0;
      }
    }

    gatherDiagnostics() {
      const diagnostics = {
        reporter: {
          userName: this.options.userName || this.getApexUser() || 'Unknown',
          userEmail: this.options.userEmail || '',
          userRole: this.options.userRole || '',
          ipAddress: '' // Will be filled by server/webhook
        },
        apex: this.getApexInfo(),
        console: this.options.enableConsoleLogs && this.consoleInterceptor
          ? this.consoleInterceptor.getLogs()
          : { errors: [], warnings: [] },
        environment: this.getEnvironmentInfo()
      };

      return diagnostics;
    }

    getApexUser() {
      if (!this.isApexAvailable()) return null;
      try {
        return apex.env.APP_USER || null;
      } catch {
        return null;
      }
    }

    getApexInfo() {
      if (!this.isApexAvailable()) {
        return {
          available: false,
          appId: null,
          pageId: null,
          sessionId: null,
          appUser: null,
          debugMode: false,
          pageItems: {},
          errors: []
        };
      }

      try {
        const pageItems = {};

        if (this.options.enableFormCapture) {
          // Get all APEX page items
          document.querySelectorAll('[id^="P"]').forEach(el => {
            if (el.id && el.id.match(/^P\d+_/)) {
              const itemName = el.id;
              // Check if it's a sensitive field
              const isSensitive = this.options.sensitiveFields.some(field =>
                itemName.toLowerCase().includes(field.toLowerCase())
              );

              if (!isSensitive) {
                try {
                  const value = apex.item(itemName).getValue();
                  if (value !== undefined && value !== null && value !== '') {
                    pageItems[itemName] = value;
                  }
                } catch {
                  // Item might not be an APEX item
                }
              } else {
                pageItems[itemName] = '[REDACTED]';
              }
            }
          });
        }

        // Get APEX errors
        let apexErrors = [];
        try {
          if (apex.message && typeof apex.message.getErrors === 'function') {
            apexErrors = apex.message.getErrors() || [];
          }
        } catch {
          // Errors API might not be available
        }

        return {
          available: true,
          appId: apex.env.APP_ID,
          pageId: apex.env.APP_PAGE_ID,
          sessionId: apex.env.APP_SESSION,
          appUser: apex.env.APP_USER,
          debugMode: apex.env.APP_DEBUG === 'YES',
          pageItems,
          errors: apexErrors
        };
      } catch (error) {
        console.warn('Error gathering APEX info:', error);
        return {
          available: true,
          appId: null,
          pageId: null,
          sessionId: null,
          appUser: null,
          debugMode: false,
          pageItems: {},
          errors: []
        };
      }
    }

    getEnvironmentInfo() {
      const { browser, os } = parseUserAgent();

      return {
        browser,
        os,
        screenResolution: `${screen.width}x${screen.height}`,
        viewportSize: `${window.innerWidth}x${window.innerHeight}`,
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        language: navigator.language,
        online: navigator.onLine,
        userAgent: navigator.userAgent,
        url: window.location.href,
        referrer: document.referrer
      };
    }

    validateForm() {
      let isValid = true;
      this.clearValidationErrors();

      const titleInput = this.container.querySelector('#bug-reporter-title-input');
      const descInput = this.container.querySelector('#bug-reporter-description');

      if (!titleInput.value.trim()) {
        titleInput.classList.add('error');
        titleInput.nextElementSibling.classList.add('visible');
        isValid = false;
      }

      if (!descInput.value.trim()) {
        descInput.classList.add('error');
        descInput.nextElementSibling.classList.add('visible');
        isValid = false;
      }

      return isValid;
    }

    clearValidationErrors() {
      this.container.querySelectorAll('.bug-reporter-input, .bug-reporter-textarea').forEach(el => {
        el.classList.remove('error');
      });
      this.container.querySelectorAll('.bug-reporter-error-msg').forEach(el => {
        el.classList.remove('visible');
      });
    }

    showError(message) {
      const errorState = this.container.querySelector('.bug-reporter-error-state');
      const errorMsg = errorState.querySelector('.bug-reporter-error-state-message');
      errorMsg.textContent = message;
      errorState.classList.add('visible');
    }

    hideError() {
      const errorState = this.container.querySelector('.bug-reporter-error-state');
      errorState.classList.remove('visible');
    }

    async submit() {
      if (this.isSubmitting) return;
      if (!this.validateForm()) return;

      this.isSubmitting = true;
      this.hideError();

      const submitBtn = this.container.querySelector('[data-br-action="submit"]');
      const originalContent = submitBtn.innerHTML;
      submitBtn.innerHTML = '<div class="bug-reporter-spinner"></div> Submitting...';
      submitBtn.disabled = true;

      try {
        const reportId = generateUUID();
        const diagnostics = this.gatherDiagnostics();

        const payload = {
          reportId,
          timestamp: new Date().toISOString(),
          title: this.container.querySelector('#bug-reporter-title-input').value.trim(),
          description: this.container.querySelector('#bug-reporter-description').value.trim(),
          urgency: this.container.querySelector('input[name="urgency"]:checked').value,
          impact: this.container.querySelector('input[name="impact"]:checked').value,
          ...diagnostics,
          screenshot: this.screenshot,
          attachments: this.attachments
        };

        // Callback
        this.options.onSubmit(payload);

        // Track submission results
        let apexSuccess = false;
        let webhookSuccess = false;
        let apexError = null;
        let webhookError = null;

        // Submit to APEX (if available)
        if (this.isApexAvailable() && this.options.apexProcessName) {
          try {
            apexSuccess = await this.submitToApex(payload);
          } catch (error) {
            console.warn('APEX submission failed:', error);
            apexError = error;
          }
        }

        // Submit to webhook (if configured)
        if (this.options.webhookUrl && this.options.webhookUrl.trim() !== '') {
          try {
            await this.submitToWebhook(payload);
            webhookSuccess = true;
          } catch (error) {
            console.warn('Webhook submission failed:', error);
            webhookError = error;
          }
        }

        // Check if at least one submission succeeded
        const hasApexConfig = this.isApexAvailable() && this.options.apexProcessName;
        const hasWebhookConfig = this.options.webhookUrl && this.options.webhookUrl.trim() !== '';

        if ((hasApexConfig || hasWebhookConfig) && !apexSuccess && !webhookSuccess) {
          // Both configured submissions failed
          throw new Error(apexError?.message || webhookError?.message || 'Submission failed');
        }

        // Show success
        this.showSuccess(reportId);
        this.options.onSuccess({ reportId, apexSuccess, webhookSuccess });

      } catch (error) {
        console.error('Bug report submission failed:', error);
        this.showError(error.message || 'Failed to submit report. Please try again.');
        this.options.onError(error);
      } finally {
        this.isSubmitting = false;
        submitBtn.innerHTML = originalContent;
        submitBtn.disabled = false;
      }
    }

    async submitToApex(payload) {
      return new Promise((resolve, reject) => {
        // Prepare payload for APEX
        const jsonPayload = { ...payload };

        // Remove large data from JSON payload
        delete jsonPayload.screenshot;
        delete jsonPayload.attachments;

        // For now, skip screenshot in APEX submission (too large for f01)
        // Screenshot will be sent via webhook if configured
        // TODO: Implement chunked upload for screenshots

        apex.server.process(
          this.options.apexProcessName,
          {
            x01: JSON.stringify(jsonPayload)
          },
          {
            dataType: 'json',
            success: (data) => {
              if (data && data.success === false) {
                reject(new Error(data.error || 'APEX process failed'));
              } else {
                resolve(true);
              }
            },
            error: (jqXHR, textStatus, errorThrown) => {
              // Try to get more detailed error
              let errorMsg = errorThrown || textStatus || 'APEX request failed';
              try {
                if (jqXHR.responseText) {
                  const resp = JSON.parse(jqXHR.responseText);
                  if (resp.error) errorMsg = resp.error;
                }
              } catch (e) {
                // Use original error
              }
              reject(new Error(errorMsg));
            }
          }
        );
      });
    }

    async submitToWebhook(payload) {
      const headers = {
        'Content-Type': 'application/json'
      };

      if (this.options.webhookApiKey) {
        headers['X-API-Key'] = this.options.webhookApiKey;
      }

      const response = await fetch(this.options.webhookUrl, {
        method: 'POST',
        headers,
        body: JSON.stringify(payload)
      });

      if (!response.ok) {
        throw new Error(`Webhook request failed: ${response.status}`);
      }

      return response.json().catch(() => ({}));
    }

    showSuccess(reportId) {
      const formView = this.container.querySelector('.bug-reporter-form-view');
      const successView = this.container.querySelector('.bug-reporter-success');
      const reportIdEl = successView.querySelector('.bug-reporter-success-id');

      formView.style.display = 'none';
      successView.classList.add('active');
      reportIdEl.textContent = `Report ID: ${reportId}`;

      // Auto-close after 5 seconds
      setTimeout(() => {
        this.close();
      }, 5000);
    }

    // Public API
    destroy() {
      if (this.container) {
        this.container.remove();
        this.container = null;
      }
    }

    setUserInfo(userName, userEmail, userRole) {
      this.options.userName = userName || this.options.userName;
      this.options.userEmail = userEmail || this.options.userEmail;
      this.options.userRole = userRole || this.options.userRole;
    }
  }

  // ============================================================
  // Public API
  // ============================================================
  global.BugReporter = {
    instance: null,

    init: function(options) {
      if (this.instance) {
        console.warn('BugReporter is already initialized. Call destroy() first to reinitialize.');
        return this.instance;
      }
      this.instance = new BugReporter(options);
      return this.instance;
    },

    destroy: function() {
      if (this.instance) {
        this.instance.destroy();
        this.instance = null;
      }
    },

    open: function() {
      if (this.instance) {
        this.instance.open();
      }
    },

    close: function() {
      if (this.instance) {
        this.instance.close();
      }
    },

    setUserInfo: function(userName, userEmail, userRole) {
      if (this.instance) {
        this.instance.setUserInfo(userName, userEmail, userRole);
      }
    }
  };

})(typeof window !== 'undefined' ? window : this);
