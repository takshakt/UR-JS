/**
 * URKnowledgeBase - Portable Markdown Knowledge Base Widget
 * Version 2.0 - With collapsible headers, section PDF export, and improved navigation
 */
(function(global) {
  'use strict';

  // ============================================================
  // CDN Dependencies
  // ============================================================
  const CDN_DEPS = {
    marked: {
      url: 'https://cdn.jsdelivr.net/npm/marked@12.0.0/lib/marked.umd.min.js',
      check: () => typeof marked !== 'undefined'
    },
    fuse: {
      url: 'https://cdn.jsdelivr.net/npm/fuse.js@7.0.0/dist/fuse.min.js',
      check: () => typeof Fuse !== 'undefined'
    },
    hljs: {
      url: 'https://cdn.jsdelivr.net/npm/highlight.js@11.9.0/lib/highlight.min.js',
      check: () => typeof hljs !== 'undefined',
      css: 'https://cdn.jsdelivr.net/npm/highlight.js@11.9.0/styles/github.min.css'
    },
    html2pdf: {
      url: 'https://cdn.jsdelivr.net/npm/html2pdf.js@0.10.1/dist/html2pdf.bundle.min.js',
      check: () => typeof html2pdf !== 'undefined'
    }
  };

  // ============================================================
  // Embedded CSS Styles
  // ============================================================
  const CSS_STYLES = `
    /* CSS Variables for Theming */
    .ur-kb {
      --kb-bg: #ffffff;
      --kb-text: #1a1a2e;
      --kb-text-muted: #6b7280;
      --kb-border: #e5e7eb;
      --kb-sidebar-bg: #f9fafb;
      --kb-sidebar-hover: #f3f4f6;
      --kb-sidebar-active: #e0e7ff;
      --kb-sidebar-active-text: #4338ca;
      --kb-accent: #4f46e5;
      --kb-accent-hover: #4338ca;
      --kb-code-bg: #f3f4f6;
      --kb-link: #4f46e5;
      --kb-search-bg: rgba(0,0,0,0.5);
      --kb-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
      --kb-radius: 8px;
      --kb-transition: 0.2s ease;
    }

    .ur-kb.dark {
      --kb-bg: #1a1a2e;
      --kb-text: #f3f4f6;
      --kb-text-muted: #9ca3af;
      --kb-border: #374151;
      --kb-sidebar-bg: #111827;
      --kb-sidebar-hover: #1f2937;
      --kb-sidebar-active: #312e81;
      --kb-sidebar-active-text: #a5b4fc;
      --kb-accent: #6366f1;
      --kb-accent-hover: #818cf8;
      --kb-code-bg: #1f2937;
      --kb-link: #818cf8;
    }

    /* Main Container */
    .ur-kb {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
      font-size: 16px;
      line-height: 1.6;
      color: var(--kb-text);
      background: var(--kb-bg);
      display: flex;
      flex-direction: column;
      height: 100%;
      min-height: 500px;
      border-radius: var(--kb-radius);
      overflow: hidden;
      box-shadow: var(--kb-shadow);
    }

    /* Search Header */
    .ur-kb-header {
      padding: 16px 20px;
      border-bottom: 1px solid var(--kb-border);
      background: var(--kb-bg);
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .ur-kb-home-btn {
      padding: 8px 12px;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 6px;
      color: var(--kb-text);
      font-size: 14px;
      font-weight: 500;
      transition: all var(--kb-transition);
    }

    .ur-kb-home-btn:hover {
      background: var(--kb-sidebar-hover);
      border-color: var(--kb-accent);
    }

    .ur-kb-home-btn svg {
      width: 16px;
      height: 16px;
    }

    .ur-kb-search-trigger {
      flex: 1;
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 10px 16px;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      cursor: pointer;
      transition: all var(--kb-transition);
    }

    .ur-kb-search-trigger:hover {
      border-color: var(--kb-accent);
      box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .ur-kb-search-trigger svg {
      width: 18px;
      height: 18px;
      color: var(--kb-text-muted);
    }

    .ur-kb-search-trigger span {
      flex: 1;
      color: var(--kb-text-muted);
      text-align: left;
    }

    .ur-kb-search-trigger kbd {
      font-family: inherit;
      font-size: 12px;
      padding: 2px 6px;
      background: var(--kb-bg);
      border: 1px solid var(--kb-border);
      border-radius: 4px;
      color: var(--kb-text-muted);
    }

    .ur-kb-menu-toggle {
      display: none;
      padding: 8px;
      background: none;
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      cursor: pointer;
      color: var(--kb-text);
    }

    .ur-kb-sidebar-expand-btn {
      padding: 8px;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      cursor: pointer;
      color: var(--kb-text);
      display: none;
    }

    .ur-kb-sidebar-expand-btn.visible {
      display: flex;
    }

    /* Main Layout */
    .ur-kb-body {
      display: flex;
      flex: 1;
      overflow: hidden;
      position: relative;
    }

    /* Sidebar */
    .ur-kb-sidebar {
      width: 300px;
      min-width: 300px;
      background: var(--kb-sidebar-bg);
      border-right: 1px solid var(--kb-border);
      display: flex;
      flex-direction: column;
      overflow: hidden;
      transition: all 0.3s ease;
    }

    .ur-kb-sidebar.collapsed {
      width: 0;
      min-width: 0;
      border-right: none;
      overflow: hidden;
    }

    .ur-kb-sidebar-header {
      padding: 16px 20px;
      border-bottom: 1px solid var(--kb-border);
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-weight: 600;
      font-size: 14px;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--kb-text-muted);
      white-space: nowrap;
    }

    .ur-kb-sidebar-toggle {
      padding: 4px 8px;
      background: none;
      border: 1px solid var(--kb-border);
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
      color: var(--kb-text-muted);
      transition: all var(--kb-transition);
    }

    .ur-kb-sidebar-toggle:hover {
      background: var(--kb-sidebar-hover);
      color: var(--kb-text);
    }

    .ur-kb-sidebar-content {
      flex: 1;
      overflow-y: auto;
      padding: 12px 0;
    }

    /* Document List */
    .ur-kb-doc {
      margin-bottom: 4px;
    }

    .ur-kb-doc-header {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 10px 20px;
      cursor: pointer;
      transition: all var(--kb-transition);
      font-weight: 500;
      color: var(--kb-text);
      white-space: nowrap;
    }

    .ur-kb-doc-header:hover {
      background: var(--kb-sidebar-hover);
    }

    .ur-kb-doc-header.active {
      background: var(--kb-sidebar-active);
      color: var(--kb-sidebar-active-text);
    }

    .ur-kb-doc-toggle {
      width: 16px;
      height: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: transform var(--kb-transition);
      flex-shrink: 0;
    }

    .ur-kb-doc-toggle.expanded {
      transform: rotate(90deg);
    }

    .ur-kb-doc-toggle svg {
      width: 12px;
      height: 12px;
    }

    /* Section List */
    .ur-kb-sections {
      display: none;
      padding-left: 20px;
    }

    .ur-kb-sections.expanded {
      display: block;
    }

    .ur-kb-section {
      position: relative;
    }

    .ur-kb-section-item {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 8px 20px 8px 16px;
      cursor: pointer;
      font-size: 14px;
      color: var(--kb-text-muted);
      border-left: 2px solid var(--kb-border);
      transition: all var(--kb-transition);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .ur-kb-section-item:hover {
      color: var(--kb-text);
      background: var(--kb-sidebar-hover);
    }

    .ur-kb-section-item.active {
      color: var(--kb-sidebar-active-text);
      border-left-color: var(--kb-accent);
      background: var(--kb-sidebar-active);
    }

    .ur-kb-section-toggle {
      width: 14px;
      height: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: transform var(--kb-transition);
      flex-shrink: 0;
    }

    .ur-kb-section-toggle.expanded {
      transform: rotate(90deg);
    }

    .ur-kb-section-toggle svg {
      width: 10px;
      height: 10px;
    }

    .ur-kb-section-children {
      display: none;
    }

    .ur-kb-section-children.expanded {
      display: block;
    }

    .ur-kb-section-children .ur-kb-section-item {
      padding-left: 32px;
      font-size: 13px;
    }

    .ur-kb-section-children .ur-kb-section-children .ur-kb-section-item {
      padding-left: 48px;
    }

    /* Content Area */
    .ur-kb-content {
      flex: 1;
      overflow-y: auto;
      padding: 24px 32px;
      background: var(--kb-bg);
    }

    .ur-kb-content-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 2px solid var(--kb-border);
    }

    .ur-kb-content-title {
      font-size: 28px;
      font-weight: 700;
      color: var(--kb-text);
      margin: 0;
    }

    .ur-kb-pdf-btn {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      background: var(--kb-accent);
      color: white;
      border: none;
      border-radius: var(--kb-radius);
      cursor: pointer;
      font-size: 14px;
      font-weight: 500;
      transition: all var(--kb-transition);
      flex-shrink: 0;
    }

    .ur-kb-pdf-btn:hover {
      background: var(--kb-accent-hover);
    }

    .ur-kb-pdf-btn:disabled {
      opacity: 0.6;
      cursor: not-allowed;
    }

    .ur-kb-pdf-btn svg {
      width: 16px;
      height: 16px;
    }

    .ur-kb-pdf-btn-small {
      padding: 4px 8px;
      font-size: 12px;
      background: var(--kb-sidebar-bg);
      color: var(--kb-text-muted);
      border: 1px solid var(--kb-border);
    }

    .ur-kb-pdf-btn-small:hover {
      background: var(--kb-accent);
      color: white;
      border-color: var(--kb-accent);
    }

    /* Home View - Document Cards */
    .ur-kb-home {
      padding: 20px;
    }

    .ur-kb-home-title {
      font-size: 24px;
      font-weight: 700;
      margin-bottom: 8px;
      color: var(--kb-text);
    }

    .ur-kb-home-subtitle {
      color: var(--kb-text-muted);
      margin-bottom: 24px;
    }

    .ur-kb-doc-cards {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 16px;
    }

    .ur-kb-doc-card {
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      padding: 20px;
      cursor: pointer;
      transition: all var(--kb-transition);
    }

    .ur-kb-doc-card:hover {
      border-color: var(--kb-accent);
      box-shadow: 0 4px 12px rgba(79, 70, 229, 0.15);
      transform: translateY(-2px);
    }

    .ur-kb-doc-card-title {
      font-size: 18px;
      font-weight: 600;
      color: var(--kb-text);
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .ur-kb-doc-card-title svg {
      width: 20px;
      height: 20px;
      color: var(--kb-accent);
    }

    .ur-kb-doc-card-sections {
      font-size: 14px;
      color: var(--kb-text-muted);
    }

    /* TOC (Table of Contents) */
    .ur-kb-toc {
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      padding: 20px 24px;
      margin-bottom: 24px;
    }

    .ur-kb-toc-title {
      font-size: 14px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--kb-text-muted);
      margin-bottom: 16px;
    }

    .ur-kb-toc-list {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .ur-kb-toc-item {
      margin-bottom: 4px;
    }

    .ur-kb-toc-link {
      display: block;
      color: var(--kb-link);
      text-decoration: none;
      font-size: 15px;
      padding: 8px 12px;
      border-radius: var(--kb-radius);
      transition: all var(--kb-transition);
      cursor: pointer;
    }

    .ur-kb-toc-link:hover {
      background: var(--kb-sidebar-hover);
      color: var(--kb-accent-hover);
    }

    /* Collapsible Section in Content */
    .ur-kb-collapsible-section {
      margin: 1em 0;
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      overflow: hidden;
    }

    .ur-kb-section-header {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 12px 16px;
      background: var(--kb-sidebar-bg);
      cursor: pointer;
      user-select: none;
      transition: background var(--kb-transition);
    }

    .ur-kb-section-header:hover {
      background: var(--kb-sidebar-hover);
    }

    .ur-kb-section-header-toggle {
      width: 20px;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: transform var(--kb-transition);
      flex-shrink: 0;
    }

    .ur-kb-section-header-toggle.expanded {
      transform: rotate(90deg);
    }

    .ur-kb-section-header-toggle svg {
      width: 14px;
      height: 14px;
    }

    .ur-kb-section-header-text {
      flex: 1;
      font-weight: 600;
      color: var(--kb-text);
    }

    .ur-kb-section-header h1,
    .ur-kb-section-header h2,
    .ur-kb-section-header h3,
    .ur-kb-section-header h4,
    .ur-kb-section-header h5,
    .ur-kb-section-header h6 {
      margin: 0;
      font-size: inherit;
      font-weight: inherit;
    }

    .ur-kb-section-header-actions {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .ur-kb-section-body {
      display: none;
      padding: 16px;
      border-top: 1px solid var(--kb-border);
    }

    .ur-kb-section-body.expanded {
      display: block;
    }

    .ur-kb-section-body > *:first-child {
      margin-top: 0;
    }

    .ur-kb-section-body > *:last-child {
      margin-bottom: 0;
    }

    /* Nested collapsible sections */
    .ur-kb-section-body .ur-kb-collapsible-section {
      margin-left: 0;
    }

    /* Markdown Content (for non-header content) */
    .ur-kb-markdown p {
      margin-bottom: 1em;
    }

    .ur-kb-markdown a {
      color: var(--kb-link);
      text-decoration: none;
    }

    .ur-kb-markdown a:hover {
      text-decoration: underline;
    }

    .ur-kb-markdown code {
      background: var(--kb-code-bg);
      padding: 2px 6px;
      border-radius: 4px;
      font-family: 'SF Mono', Consolas, monospace;
      font-size: 0.9em;
    }

    .ur-kb-markdown pre {
      background: var(--kb-code-bg);
      padding: 16px;
      border-radius: var(--kb-radius);
      overflow-x: auto;
      margin: 1em 0;
    }

    .ur-kb-markdown pre code {
      background: none;
      padding: 0;
    }

    .ur-kb-markdown ul, .ur-kb-markdown ol {
      margin: 1em 0;
      padding-left: 2em;
    }

    .ur-kb-markdown li {
      margin-bottom: 0.5em;
    }

    .ur-kb-markdown blockquote {
      margin: 1em 0;
      padding: 12px 20px;
      border-left: 4px solid var(--kb-accent);
      background: var(--kb-sidebar-bg);
      border-radius: 0 var(--kb-radius) var(--kb-radius) 0;
    }

    .ur-kb-markdown blockquote p:last-child {
      margin-bottom: 0;
    }

    .ur-kb-markdown table {
      width: 100%;
      border-collapse: collapse;
      margin: 1em 0;
    }

    .ur-kb-markdown th, .ur-kb-markdown td {
      padding: 10px 12px;
      border: 1px solid var(--kb-border);
      text-align: left;
    }

    .ur-kb-markdown th {
      background: var(--kb-sidebar-bg);
      font-weight: 600;
    }

    .ur-kb-markdown hr {
      border: none;
      border-top: 1px solid var(--kb-border);
      margin: 2em 0;
    }

    /* Media Container (16:9) */
    .ur-kb-media-container {
      position: relative;
      width: 100%;
      padding-top: 56.25%;
      margin: 1em 0;
      background: var(--kb-code-bg);
      border-radius: var(--kb-radius);
      overflow: hidden;
    }

    .ur-kb-media-container img,
    .ur-kb-media-container iframe,
    .ur-kb-media-container video {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      object-fit: contain;
      border: none;
    }

    /* Search Modal */
    .ur-kb-search-modal {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: var(--kb-search-bg);
      display: none;
      align-items: flex-start;
      justify-content: center;
      padding-top: 10vh;
      z-index: 10000;
      backdrop-filter: blur(4px);
    }

    .ur-kb-search-modal.active {
      display: flex;
    }

    .ur-kb-search-dialog {
      width: 100%;
      max-width: 640px;
      max-height: 70vh;
      background: var(--kb-bg);
      border-radius: var(--kb-radius);
      box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25);
      overflow: hidden;
      display: flex;
      flex-direction: column;
    }

    .ur-kb-search-input-wrap {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 16px 20px;
      border-bottom: 1px solid var(--kb-border);
    }

    .ur-kb-search-input-wrap svg {
      width: 20px;
      height: 20px;
      color: var(--kb-text-muted);
    }

    .ur-kb-search-input {
      flex: 1;
      border: none;
      background: none;
      font-size: 16px;
      color: var(--kb-text);
      outline: none;
    }

    .ur-kb-search-input::placeholder {
      color: var(--kb-text-muted);
    }

    .ur-kb-search-close {
      padding: 4px 8px;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: 4px;
      font-size: 12px;
      color: var(--kb-text-muted);
      cursor: pointer;
    }

    .ur-kb-search-results {
      flex: 1;
      overflow-y: auto;
      padding: 8px;
    }

    .ur-kb-search-result {
      padding: 12px 16px;
      border-radius: var(--kb-radius);
      cursor: pointer;
      transition: background var(--kb-transition);
    }

    .ur-kb-search-result:hover,
    .ur-kb-search-result.selected {
      background: var(--kb-sidebar-hover);
    }

    .ur-kb-search-result-title {
      display: flex;
      align-items: center;
      gap: 8px;
      font-weight: 500;
      color: var(--kb-text);
      margin-bottom: 4px;
    }

    .ur-kb-search-result-title svg {
      width: 16px;
      height: 16px;
      color: var(--kb-text-muted);
    }

    .ur-kb-search-result-path {
      font-size: 12px;
      color: var(--kb-text-muted);
    }

    .ur-kb-search-result-preview {
      font-size: 14px;
      color: var(--kb-text-muted);
      margin-top: 6px;
      line-height: 1.4;
    }

    .ur-kb-search-result-preview mark {
      background: rgba(79, 70, 229, 0.2);
      color: var(--kb-accent);
      padding: 0 2px;
      border-radius: 2px;
    }

    .ur-kb-search-footer {
      padding: 12px 16px;
      border-top: 1px solid var(--kb-border);
      display: flex;
      gap: 16px;
      font-size: 12px;
      color: var(--kb-text-muted);
    }

    .ur-kb-search-footer kbd {
      padding: 2px 6px;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: 4px;
      font-family: inherit;
    }

    .ur-kb-no-results {
      padding: 40px 20px;
      text-align: center;
      color: var(--kb-text-muted);
    }

    /* Loading State */
    .ur-kb-loading {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 60px 20px;
      color: var(--kb-text-muted);
    }

    .ur-kb-spinner {
      width: 40px;
      height: 40px;
      border: 3px solid var(--kb-border);
      border-top-color: var(--kb-accent);
      border-radius: 50%;
      animation: ur-kb-spin 0.8s linear infinite;
      margin-bottom: 16px;
    }

    @keyframes ur-kb-spin {
      to { transform: rotate(360deg); }
    }

    /* Responsive */
    @media (max-width: 768px) {
      .ur-kb-sidebar {
        position: fixed;
        left: 0;
        top: 0;
        bottom: 0;
        z-index: 100;
        transform: translateX(-100%);
        transition: transform 0.3s ease;
      }

      .ur-kb-sidebar.mobile-open {
        transform: translateX(0);
      }

      .ur-kb-menu-toggle {
        display: flex;
      }

      .ur-kb-sidebar-toggle {
        display: none;
      }

      .ur-kb-content {
        padding: 16px;
      }

      .ur-kb-content-title {
        font-size: 22px;
      }

      .ur-kb-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0,0,0,0.5);
        z-index: 99;
        display: none;
      }

      .ur-kb-overlay.active {
        display: block;
      }

      .ur-kb-doc-cards {
        grid-template-columns: 1fr;
      }
    }

    /* Print styles for PDF */
    @media print {
      .ur-kb-section-header-actions,
      .ur-kb-section-header-toggle {
        display: none !important;
      }
      .ur-kb-section-body {
        display: block !important;
      }
      .ur-kb-collapsible-section {
        border: none !important;
        page-break-inside: avoid;
      }
    }
  `;

  // ============================================================
  // SVG Icons
  // ============================================================
  const ICONS = {
    search: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.3-4.3"></path></svg>',
    menu: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="4" x2="20" y1="12" y2="12"></line><line x1="4" x2="20" y1="6" y2="6"></line><line x1="4" x2="20" y1="18" y2="18"></line></svg>',
    chevronRight: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"></path></svg>',
    download: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" x2="12" y1="15" y2="3"></line></svg>',
    document: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>',
    home: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>',
    sidebar: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="3" rx="2" ry="2"></rect><line x1="9" x2="9" y1="3" y2="21"></line></svg>'
  };

  // ============================================================
  // Utility Functions
  // ============================================================
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

  function loadCSS(url) {
    if (document.querySelector(`link[href="${url}"]`)) return;
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = url;
    document.head.appendChild(link);
  }

  function generateTitle(url) {
    const filename = url.split('/').pop().replace(/\.md$/i, '');
    return filename
      .split(/[-_]/)
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
  }

  function slugify(text) {
    return text
      .toLowerCase()
      .replace(/[^\w\s-]/g, '')
      .replace(/\s+/g, '-')
      .replace(/--+/g, '-')
      .trim();
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  function debounce(func, wait) {
    let timeout;
    return function(...args) {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), wait);
    };
  }

  // ============================================================
  // Main URKnowledgeBase Class
  // ============================================================
  class URKnowledgeBase {
    constructor(options) {
      this.options = Object.assign({
        container: '#kb-container',
        documents: [],
        sidebarTitle: 'KB Documents',
        theme: 'auto',
        enableSearch: true,
        enablePdfExport: true,
        defaultDocument: null
      }, options);

      this.container = null;
      this.documents = [];
      this.currentDoc = null;
      this.currentSection = null;
      this.searchIndex = null;
      this.fuse = null;
      this.sidebarCollapsed = false;
      this.mobileMenuOpen = false;
      this.viewMode = 'home'; // 'home', 'document', 'section'

      this.init();
    }

    async init() {
      this.container = typeof this.options.container === 'string'
        ? document.querySelector(this.options.container)
        : this.options.container;

      if (!this.container) {
        console.error('URKnowledgeBase: Container not found');
        return;
      }

      this.injectStyles();
      this.showLoading();
      await this.loadDependencies();
      this.processDocuments();
      await this.fetchAllDocuments();
      this.buildSearchIndex();
      this.render();
      this.setupEventListeners();

      // Show home view by default
      this.showHome();
    }

    injectStyles() {
      if (!document.getElementById('ur-kb-styles')) {
        const style = document.createElement('style');
        style.id = 'ur-kb-styles';
        style.textContent = CSS_STYLES;
        document.head.appendChild(style);
      }
    }

    showLoading() {
      this.container.innerHTML = `
        <div class="ur-kb">
          <div class="ur-kb-loading">
            <div class="ur-kb-spinner"></div>
            <div>Loading documentation...</div>
          </div>
        </div>
      `;
    }

    async loadDependencies() {
      for (const [name, dep] of Object.entries(CDN_DEPS)) {
        if (!dep.check()) {
          try {
            await loadScript(dep.url);
            if (dep.css) loadCSS(dep.css);
          } catch (e) {
            console.error(`Failed to load ${name}:`, e);
          }
        }
      }
    }

    processDocuments() {
      this.documents = this.options.documents.map((doc, index) => ({
        id: doc.id || `doc-${index}`,
        url: doc.url,
        title: doc.title || generateTitle(doc.url),
        content: null,
        sections: [],
        loaded: false
      }));
    }

    async fetchAllDocuments() {
      await Promise.all(this.documents.map(async (doc) => {
        try {
          const response = await fetch(doc.url);
          if (!response.ok) throw new Error(`HTTP ${response.status}`);
          doc.content = await response.text();
          doc.sections = this.parseHeaders(doc.content);
          doc.loaded = true;
        } catch (e) {
          console.error(`Failed to fetch ${doc.url}:`, e);
          doc.content = `# Error\n\nFailed to load document: ${doc.url}`;
          doc.loaded = false;
        }
      }));
    }

    parseHeaders(content) {
      const lines = content.split('\n');
      const headers = [];
      const stack = [{ level: 0, children: headers }];

      lines.forEach((line, lineIndex) => {
        const match = line.match(/^(#{1,6})\s+(.+)$/);
        if (match) {
          const level = match[1].length;
          const text = match[2].trim();
          const id = slugify(text) + '-' + lineIndex;

          const header = { level, text, id, line: lineIndex, children: [] };

          while (stack.length > 1 && stack[stack.length - 1].level >= level) {
            stack.pop();
          }

          stack[stack.length - 1].children.push(header);
          stack.push(header);
        }
      });

      return headers;
    }

    buildSearchIndex() {
      const searchData = [];

      this.documents.forEach(doc => {
        if (!doc.loaded) return;

        searchData.push({
          type: 'document',
          docId: doc.id,
          title: doc.title,
          content: doc.content.substring(0, 500),
          path: doc.title
        });

        const indexSections = (sections, path = '') => {
          sections.forEach(section => {
            const sectionPath = path ? `${path} > ${section.text}` : section.text;
            const contentStart = doc.content.indexOf(`${'#'.repeat(section.level)} ${section.text}`);
            let contentEnd = doc.content.length;
            const nextHeaderMatch = doc.content.substring(contentStart + 1).match(/\n#{1,6}\s/);
            if (nextHeaderMatch) contentEnd = contentStart + 1 + nextHeaderMatch.index;
            const sectionContent = doc.content.substring(contentStart, contentEnd);

            searchData.push({
              type: 'section',
              docId: doc.id,
              sectionId: section.id,
              title: section.text,
              content: sectionContent.substring(0, 300),
              path: `${doc.title} > ${sectionPath}`
            });

            if (section.children.length > 0) indexSections(section.children, sectionPath);
          });
        };

        indexSections(doc.sections);
      });

      this.searchIndex = searchData;
      this.fuse = new Fuse(searchData, {
        keys: ['title', 'content'],
        includeMatches: true,
        threshold: 0.3,
        minMatchCharLength: 2
      });
    }

    render() {
      const themeClass = this.options.theme === 'dark' ? 'dark' : '';

      this.container.innerHTML = `
        <div class="ur-kb ${themeClass}">
          <div class="ur-kb-header">
            <button class="ur-kb-menu-toggle" aria-label="Toggle menu">${ICONS.menu}</button>
            <button class="ur-kb-home-btn" aria-label="Home">${ICONS.home}<span>Home</span></button>
            <div class="ur-kb-search-trigger" role="button" tabindex="0">
              ${ICONS.search}
              <span>Search all documents...</span>
              <kbd>⌘K</kbd>
            </div>
            <button class="ur-kb-sidebar-expand-btn" aria-label="Show sidebar">${ICONS.sidebar}</button>
          </div>
          <div class="ur-kb-body">
            <div class="ur-kb-overlay"></div>
            <aside class="ur-kb-sidebar">
              <div class="ur-kb-sidebar-header">
                <span>${escapeHtml(this.options.sidebarTitle)}</span>
                <button class="ur-kb-sidebar-toggle" aria-label="Collapse sidebar">«</button>
              </div>
              <nav class="ur-kb-sidebar-content">
                ${this.renderDocumentList()}
              </nav>
            </aside>
            <main class="ur-kb-content"></main>
          </div>
          ${this.renderSearchModal()}
        </div>
      `;

      const savedState = localStorage.getItem('ur-kb-sidebar');
      if (savedState === 'collapsed') {
        this.toggleSidebar(true);
      }
    }

    renderDocumentList() {
      return this.documents.map(doc => `
        <div class="ur-kb-doc" data-doc-id="${doc.id}">
          <div class="ur-kb-doc-header">
            <span class="ur-kb-doc-toggle">${ICONS.chevronRight}</span>
            <span class="ur-kb-doc-title">${escapeHtml(doc.title)}</span>
          </div>
          <div class="ur-kb-sections">
            ${this.renderSidebarSections(doc.sections, doc.id)}
          </div>
        </div>
      `).join('');
    }

    renderSidebarSections(sections, docId) {
      if (!sections || sections.length === 0) return '';

      return sections.map(section => `
        <div class="ur-kb-section" data-section-id="${section.id}">
          <div class="ur-kb-section-item" data-doc-id="${docId}" data-section-id="${section.id}">
            ${section.children.length > 0 ? `<span class="ur-kb-section-toggle">${ICONS.chevronRight}</span>` : '<span style="width:14px"></span>'}
            <span>${escapeHtml(section.text)}</span>
          </div>
          ${section.children.length > 0 ? `
            <div class="ur-kb-section-children">
              ${this.renderSidebarSections(section.children, docId)}
            </div>
          ` : ''}
        </div>
      `).join('');
    }

    renderSearchModal() {
      return `
        <div class="ur-kb-search-modal">
          <div class="ur-kb-search-dialog">
            <div class="ur-kb-search-input-wrap">
              ${ICONS.search}
              <input type="text" class="ur-kb-search-input" placeholder="Search documentation...">
              <button class="ur-kb-search-close">ESC</button>
            </div>
            <div class="ur-kb-search-results"></div>
            <div class="ur-kb-search-footer">
              <span><kbd>↑↓</kbd> Navigate</span>
              <span><kbd>↵</kbd> Open</span>
              <span><kbd>ESC</kbd> Close</span>
            </div>
          </div>
        </div>
      `;
    }

    setupEventListeners() {
      const kb = this.container.querySelector('.ur-kb');

      kb.addEventListener('click', (e) => {
        // Home button
        if (e.target.closest('.ur-kb-home-btn')) {
          this.showHome();
          return;
        }

        // Document card click
        const docCard = e.target.closest('.ur-kb-doc-card');
        if (docCard) {
          this.selectDocument(docCard.dataset.docId);
          return;
        }

        // Document header in sidebar
        const docHeader = e.target.closest('.ur-kb-doc-header');
        if (docHeader) {
          const docEl = docHeader.closest('.ur-kb-doc');
          const docId = docEl.dataset.docId;
          this.selectDocument(docId);
          return;
        }

        // Section toggle in sidebar
        const sectionToggle = e.target.closest('.ur-kb-section-toggle');
        if (sectionToggle) {
          e.stopPropagation();
          const sectionEl = sectionToggle.closest('.ur-kb-section');
          const children = sectionEl.querySelector('.ur-kb-section-children');
          if (children) {
            children.classList.toggle('expanded');
            sectionToggle.classList.toggle('expanded');
          }
          return;
        }

        // Section item in sidebar
        const sectionItem = e.target.closest('.ur-kb-section-item');
        if (sectionItem) {
          const docId = sectionItem.dataset.docId;
          const sectionId = sectionItem.dataset.sectionId;
          this.selectSection(docId, sectionId);
          return;
        }

        // TOC link click
        const tocLink = e.target.closest('.ur-kb-toc-link');
        if (tocLink) {
          e.preventDefault();
          const sectionId = tocLink.dataset.sectionId;
          const docId = tocLink.dataset.docId;
          if (docId && sectionId) {
            this.selectSection(docId, sectionId);
          }
          return;
        }

        // Collapsible section header toggle
        const sectionHeaderToggle = e.target.closest('.ur-kb-section-header-toggle');
        if (sectionHeaderToggle) {
          const collapsible = sectionHeaderToggle.closest('.ur-kb-collapsible-section');
          const body = collapsible.querySelector(':scope > .ur-kb-section-body');
          body.classList.toggle('expanded');
          sectionHeaderToggle.classList.toggle('expanded');
          return;
        }

        // Collapsible section header (not toggle, not PDF)
        const sectionHeader = e.target.closest('.ur-kb-section-header');
        if (sectionHeader && !e.target.closest('.ur-kb-pdf-btn-small') && !e.target.closest('.ur-kb-section-header-toggle')) {
          const collapsible = sectionHeader.closest('.ur-kb-collapsible-section');
          const body = collapsible.querySelector(':scope > .ur-kb-section-body');
          const toggle = sectionHeader.querySelector('.ur-kb-section-header-toggle');
          body.classList.toggle('expanded');
          if (toggle) toggle.classList.toggle('expanded');
          return;
        }

        // Section PDF button
        const sectionPdfBtn = e.target.closest('.ur-kb-pdf-btn-small');
        if (sectionPdfBtn) {
          e.stopPropagation();
          const sectionEl = sectionPdfBtn.closest('.ur-kb-collapsible-section');
          this.exportSectionPDF(sectionEl);
          return;
        }

        // Main PDF button
        if (e.target.closest('.ur-kb-pdf-btn:not(.ur-kb-pdf-btn-small)')) {
          this.exportPDF();
          return;
        }

        // Sidebar toggle
        if (e.target.closest('.ur-kb-sidebar-toggle')) {
          this.toggleSidebar();
          return;
        }

        // Sidebar expand button
        if (e.target.closest('.ur-kb-sidebar-expand-btn')) {
          this.toggleSidebar(false);
          return;
        }

        // Mobile menu toggle
        if (e.target.closest('.ur-kb-menu-toggle')) {
          this.toggleMobileMenu();
          return;
        }

        // Overlay click
        if (e.target.closest('.ur-kb-overlay')) {
          this.toggleMobileMenu(false);
          return;
        }

        // Search trigger
        if (e.target.closest('.ur-kb-search-trigger')) {
          this.openSearch();
          return;
        }

        // Search close
        if (e.target.closest('.ur-kb-search-close')) {
          this.closeSearch();
          return;
        }

        // Search modal background
        if (e.target.classList.contains('ur-kb-search-modal')) {
          this.closeSearch();
          return;
        }

        // Search result click
        const searchResult = e.target.closest('.ur-kb-search-result');
        if (searchResult) {
          this.selectSearchResult(searchResult);
          return;
        }
      });

      // Search input
      const searchInput = kb.querySelector('.ur-kb-search-input');
      searchInput.addEventListener('input', debounce((e) => {
        this.performSearch(e.target.value);
      }, 200));

      // Keyboard shortcuts
      document.addEventListener('keydown', (e) => {
        if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
          e.preventDefault();
          this.openSearch();
          return;
        }

        if (e.key === 'Escape') {
          this.closeSearch();
          return;
        }

        if (kb.querySelector('.ur-kb-search-modal.active')) {
          if (e.key === 'ArrowDown') {
            e.preventDefault();
            this.navigateSearchResults(1);
          } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            this.navigateSearchResults(-1);
          } else if (e.key === 'Enter') {
            e.preventDefault();
            const selected = kb.querySelector('.ur-kb-search-result.selected');
            if (selected) this.selectSearchResult(selected);
          }
        }
      });
    }

    showHome() {
      this.viewMode = 'home';
      this.currentDoc = null;
      this.currentSection = null;

      // Clear sidebar active states
      const sidebar = this.container.querySelector('.ur-kb-sidebar-content');
      sidebar.querySelectorAll('.ur-kb-doc-header').forEach(el => el.classList.remove('active'));
      sidebar.querySelectorAll('.ur-kb-sections').forEach(el => el.classList.remove('expanded'));
      sidebar.querySelectorAll('.ur-kb-doc-toggle').forEach(el => el.classList.remove('expanded'));
      sidebar.querySelectorAll('.ur-kb-section-item').forEach(el => el.classList.remove('active'));

      const content = this.container.querySelector('.ur-kb-content');
      content.innerHTML = `
        <div class="ur-kb-home">
          <h1 class="ur-kb-home-title">${escapeHtml(this.options.sidebarTitle)}</h1>
          <p class="ur-kb-home-subtitle">Select a document to get started</p>
          <div class="ur-kb-doc-cards">
            ${this.documents.map(doc => `
              <div class="ur-kb-doc-card" data-doc-id="${doc.id}">
                <div class="ur-kb-doc-card-title">
                  ${ICONS.document}
                  ${escapeHtml(doc.title)}
                </div>
                <div class="ur-kb-doc-card-sections">
                  ${doc.sections.length} section${doc.sections.length !== 1 ? 's' : ''}
                </div>
              </div>
            `).join('')}
          </div>
        </div>
      `;

      this.toggleMobileMenu(false);
    }

    selectDocument(docId) {
      const doc = this.documents.find(d => d.id === docId);
      if (!doc) return;

      this.viewMode = 'document';
      this.currentDoc = doc;
      this.currentSection = null;

      // Update sidebar
      const sidebar = this.container.querySelector('.ur-kb-sidebar-content');
      sidebar.querySelectorAll('.ur-kb-doc-header').forEach(el => el.classList.remove('active'));
      sidebar.querySelectorAll('.ur-kb-sections').forEach(el => el.classList.remove('expanded'));
      sidebar.querySelectorAll('.ur-kb-doc-toggle').forEach(el => el.classList.remove('expanded'));
      sidebar.querySelectorAll('.ur-kb-section-item').forEach(el => el.classList.remove('active'));

      const docEl = sidebar.querySelector(`.ur-kb-doc[data-doc-id="${docId}"]`);
      if (docEl) {
        docEl.querySelector('.ur-kb-doc-header').classList.add('active');
        docEl.querySelector('.ur-kb-sections').classList.add('expanded');
        docEl.querySelector('.ur-kb-doc-toggle').classList.add('expanded');
      }

      this.renderDocumentOverview(doc);
      this.toggleMobileMenu(false);
    }

    selectSection(docId, sectionId) {
      const doc = this.documents.find(d => d.id === docId);
      if (!doc) return;

      const findSection = (sections) => {
        for (const section of sections) {
          if (section.id === sectionId) return section;
          if (section.children.length > 0) {
            const found = findSection(section.children);
            if (found) return found;
          }
        }
        return null;
      };

      const section = findSection(doc.sections);
      if (!section) return;

      this.viewMode = 'section';
      this.currentDoc = doc;
      this.currentSection = section;

      // Update sidebar
      const sidebar = this.container.querySelector('.ur-kb-sidebar-content');
      sidebar.querySelectorAll('.ur-kb-doc-header').forEach(el => el.classList.remove('active'));
      sidebar.querySelectorAll('.ur-kb-section-item').forEach(el => el.classList.remove('active'));

      const docEl = sidebar.querySelector(`.ur-kb-doc[data-doc-id="${docId}"]`);
      if (docEl) {
        docEl.querySelector('.ur-kb-doc-header').classList.add('active');
        docEl.querySelector('.ur-kb-sections').classList.add('expanded');
        docEl.querySelector('.ur-kb-doc-toggle').classList.add('expanded');
      }

      const sectionEl = sidebar.querySelector(`.ur-kb-section[data-section-id="${sectionId}"]`);
      if (sectionEl) {
        const item = sectionEl.querySelector(':scope > .ur-kb-section-item');
        if (item) item.classList.add('active');
        const children = sectionEl.querySelector(':scope > .ur-kb-section-children');
        if (children) {
          children.classList.add('expanded');
          const toggle = sectionEl.querySelector(':scope > .ur-kb-section-item .ur-kb-section-toggle');
          if (toggle) toggle.classList.add('expanded');
        }
      }

      this.renderSectionContent(doc, section);
      this.toggleMobileMenu(false);
    }

    renderDocumentOverview(doc) {
      const content = this.container.querySelector('.ur-kb-content');

      const tocItems = doc.sections.map(section => `
        <li class="ur-kb-toc-item">
          <a class="ur-kb-toc-link" data-doc-id="${doc.id}" data-section-id="${section.id}">
            ${escapeHtml(section.text)}
          </a>
        </li>
      `).join('');

      content.innerHTML = `
        <div class="ur-kb-content-header">
          <h1 class="ur-kb-content-title">${escapeHtml(doc.title)}</h1>
          ${this.options.enablePdfExport ? `
            <button class="ur-kb-pdf-btn" title="Download entire document as PDF">
              ${ICONS.download}
              <span>PDF</span>
            </button>
          ` : ''}
        </div>
        <div class="ur-kb-toc">
          <div class="ur-kb-toc-title">Table of Contents</div>
          <ul class="ur-kb-toc-list">
            ${tocItems}
          </ul>
        </div>
      `;
    }

    renderSectionContent(doc, section) {
      const content = this.container.querySelector('.ur-kb-content');
      const sectionContent = this.extractSectionContent(doc.content, section);
      const html = this.renderMarkdownWithCollapsibleHeaders(sectionContent);

      content.innerHTML = `
        <div class="ur-kb-content-header">
          <h1 class="ur-kb-content-title">${escapeHtml(doc.title)}</h1>
          ${this.options.enablePdfExport ? `
            <button class="ur-kb-pdf-btn" title="Download entire document as PDF">
              ${ICONS.download}
              <span>PDF</span>
            </button>
          ` : ''}
        </div>
        <div class="ur-kb-markdown" id="ur-kb-print-content">
          ${html}
        </div>
      `;

      // Apply syntax highlighting
      content.querySelectorAll('pre code').forEach(block => {
        if (typeof hljs !== 'undefined') hljs.highlightElement(block);
      });

      // Expand first level by default
      const firstSection = content.querySelector('.ur-kb-collapsible-section');
      if (firstSection) {
        const body = firstSection.querySelector(':scope > .ur-kb-section-body');
        const toggle = firstSection.querySelector(':scope > .ur-kb-section-header .ur-kb-section-header-toggle');
        if (body) body.classList.add('expanded');
        if (toggle) toggle.classList.add('expanded');
      }
    }

    extractSectionContent(content, section) {
      const lines = content.split('\n');
      const startLine = section.line;
      let endLine = lines.length;

      for (let i = startLine + 1; i < lines.length; i++) {
        const match = lines[i].match(/^(#{1,6})\s/);
        if (match && match[1].length <= section.level) {
          endLine = i;
          break;
        }
      }

      return lines.slice(startLine, endLine).join('\n');
    }

    renderMarkdownWithCollapsibleHeaders(content) {
      if (typeof marked === 'undefined') {
        return `<pre>${escapeHtml(content)}</pre>`;
      }

      // Parse the markdown into sections
      const lines = content.split('\n');
      const sections = [];
      let currentContent = [];

      lines.forEach((line, index) => {
        const match = line.match(/^(#{1,6})\s+(.+)$/);
        if (match) {
          if (currentContent.length > 0) {
            sections.push({ type: 'content', content: currentContent.join('\n') });
            currentContent = [];
          }
          sections.push({
            type: 'header',
            level: match[1].length,
            text: match[2].trim(),
            id: slugify(match[2].trim()) + '-' + index
          });
        } else {
          currentContent.push(line);
        }
      });

      if (currentContent.length > 0) {
        sections.push({ type: 'content', content: currentContent.join('\n') });
      }

      // Build collapsible structure
      const buildCollapsible = (sections, startIndex = 0) => {
        let html = '';
        let i = startIndex;

        while (i < sections.length) {
          const section = sections[i];

          if (section.type === 'content') {
            html += this.renderMarkdownContent(section.content);
            i++;
          } else if (section.type === 'header') {
            // Find all content and sub-headers until next header of same or higher level
            let bodyContent = '';
            let j = i + 1;

            while (j < sections.length) {
              if (sections[j].type === 'header' && sections[j].level <= section.level) {
                break;
              }
              if (sections[j].type === 'content') {
                bodyContent += this.renderMarkdownContent(sections[j].content);
              } else if (sections[j].type === 'header') {
                // Recursively build nested collapsible
                const nestedResult = buildCollapsible(sections, j);
                bodyContent += nestedResult.html;
                j = nestedResult.endIndex;
                continue;
              }
              j++;
            }

            const headerTag = `h${section.level}`;
            html += `
              <div class="ur-kb-collapsible-section" data-section-id="${section.id}">
                <div class="ur-kb-section-header">
                  <span class="ur-kb-section-header-toggle">${ICONS.chevronRight}</span>
                  <div class="ur-kb-section-header-text">
                    <${headerTag}>${escapeHtml(section.text)}</${headerTag}>
                  </div>
                  <div class="ur-kb-section-header-actions">
                    ${this.options.enablePdfExport ? `
                      <button class="ur-kb-pdf-btn ur-kb-pdf-btn-small" title="Download this section as PDF">
                        ${ICONS.download}
                      </button>
                    ` : ''}
                  </div>
                </div>
                <div class="ur-kb-section-body">
                  ${bodyContent}
                </div>
              </div>
            `;

            i = j;
          }
        }

        return { html, endIndex: i };
      };

      const result = buildCollapsible(sections);
      return result.html;
    }

    renderMarkdownContent(content) {
      if (!content.trim()) return '';

      marked.setOptions({
        gfm: true,
        breaks: true
      });

      const renderer = new marked.Renderer();

      renderer.image = (href, title, text) => {
        const youtubeMatch = href.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([\w-]+)/);
        if (youtubeMatch) {
          return `<div class="ur-kb-media-container"><iframe src="https://www.youtube.com/embed/${youtubeMatch[1]}" allowfullscreen></iframe></div>`;
        }
        if (/\.(mp4|webm|ogg)$/i.test(href)) {
          return `<div class="ur-kb-media-container"><video controls><source src="${escapeHtml(href)}" type="video/${href.split('.').pop()}"></video></div>`;
        }
        return `<div class="ur-kb-media-container"><img src="${escapeHtml(href)}" alt="${escapeHtml(text)}" title="${escapeHtml(title || '')}"></div>`;
      };

      renderer.link = (href, title, text) => {
        const isExternal = href.startsWith('http://') || href.startsWith('https://');
        const target = isExternal ? ' target="_blank" rel="noopener noreferrer"' : '';
        return `<a href="${escapeHtml(href)}" title="${escapeHtml(title || '')}"${target}>${text}</a>`;
      };

      // Don't render headers in content - they're handled separately
      renderer.heading = () => '';

      return marked.parse(content, { renderer });
    }

    toggleSidebar(collapsed) {
      const sidebar = this.container.querySelector('.ur-kb-sidebar');
      const toggle = this.container.querySelector('.ur-kb-sidebar-toggle');
      const expandBtn = this.container.querySelector('.ur-kb-sidebar-expand-btn');

      if (collapsed === undefined) {
        this.sidebarCollapsed = !this.sidebarCollapsed;
      } else {
        this.sidebarCollapsed = collapsed;
      }

      sidebar.classList.toggle('collapsed', this.sidebarCollapsed);
      toggle.textContent = this.sidebarCollapsed ? '»' : '«';
      expandBtn.classList.toggle('visible', this.sidebarCollapsed);

      localStorage.setItem('ur-kb-sidebar', this.sidebarCollapsed ? 'collapsed' : 'expanded');
    }

    toggleMobileMenu(open) {
      const sidebar = this.container.querySelector('.ur-kb-sidebar');
      const overlay = this.container.querySelector('.ur-kb-overlay');

      if (open === undefined) {
        this.mobileMenuOpen = !this.mobileMenuOpen;
      } else {
        this.mobileMenuOpen = open;
      }

      sidebar.classList.toggle('mobile-open', this.mobileMenuOpen);
      overlay.classList.toggle('active', this.mobileMenuOpen);
    }

    openSearch() {
      const modal = this.container.querySelector('.ur-kb-search-modal');
      const input = modal.querySelector('.ur-kb-search-input');
      modal.classList.add('active');
      input.focus();
      input.select();
    }

    closeSearch() {
      const modal = this.container.querySelector('.ur-kb-search-modal');
      modal.classList.remove('active');
      modal.querySelector('.ur-kb-search-input').value = '';
      modal.querySelector('.ur-kb-search-results').innerHTML = '';
    }

    performSearch(query) {
      const resultsContainer = this.container.querySelector('.ur-kb-search-results');

      if (!query || query.length < 2) {
        resultsContainer.innerHTML = '';
        return;
      }

      const results = this.fuse.search(query, { limit: 10 });

      if (results.length === 0) {
        resultsContainer.innerHTML = `<div class="ur-kb-no-results">No results found for "${escapeHtml(query)}"</div>`;
        return;
      }

      resultsContainer.innerHTML = results.map((result, index) => {
        const item = result.item;
        let preview = item.content.substring(0, 150);
        if (result.matches) {
          result.matches.forEach(match => {
            if (match.key === 'content') {
              const regex = new RegExp(`(${escapeHtml(query)})`, 'gi');
              preview = preview.replace(regex, '<mark>$1</mark>');
            }
          });
        }

        return `
          <div class="ur-kb-search-result ${index === 0 ? 'selected' : ''}"
               data-doc-id="${item.docId}"
               data-section-id="${item.sectionId || ''}">
            <div class="ur-kb-search-result-title">
              ${ICONS.document}
              <span>${escapeHtml(item.title)}</span>
            </div>
            <div class="ur-kb-search-result-path">${escapeHtml(item.path)}</div>
            <div class="ur-kb-search-result-preview">${preview}...</div>
          </div>
        `;
      }).join('');
    }

    navigateSearchResults(direction) {
      const results = this.container.querySelectorAll('.ur-kb-search-result');
      if (results.length === 0) return;

      const currentIndex = Array.from(results).findIndex(r => r.classList.contains('selected'));
      let newIndex = currentIndex + direction;

      if (newIndex < 0) newIndex = results.length - 1;
      if (newIndex >= results.length) newIndex = 0;

      results.forEach((r, i) => r.classList.toggle('selected', i === newIndex));
      results[newIndex].scrollIntoView({ block: 'nearest' });
    }

    selectSearchResult(resultEl) {
      const docId = resultEl.dataset.docId;
      const sectionId = resultEl.dataset.sectionId;

      this.closeSearch();

      if (sectionId) {
        this.selectSection(docId, sectionId);
      } else {
        this.selectDocument(docId);
      }
    }

    async exportPDF() {
      if (typeof html2pdf === 'undefined') {
        alert('PDF export is not available');
        return;
      }

      if (!this.currentDoc) return;

      const btn = this.container.querySelector('.ur-kb-pdf-btn:not(.ur-kb-pdf-btn-small)');
      if (!btn) return;

      const originalText = btn.innerHTML;
      btn.innerHTML = `${ICONS.download}<span>Exporting...</span>`;
      btn.disabled = true;

      try {
        let content;
        let title;

        if (this.currentSection) {
          content = this.extractSectionContent(this.currentDoc.content, this.currentSection);
          title = `${this.currentDoc.title} - ${this.currentSection.text}`;
        } else {
          content = this.currentDoc.content;
          title = this.currentDoc.title;
        }

        await this.generatePDF(content, title);
      } catch (e) {
        console.error('PDF export failed:', e);
        alert('Failed to export PDF');
      } finally {
        btn.innerHTML = originalText;
        btn.disabled = false;
      }
    }

    async exportSectionPDF(sectionEl) {
      if (typeof html2pdf === 'undefined') {
        alert('PDF export is not available');
        return;
      }

      const btn = sectionEl.querySelector('.ur-kb-pdf-btn-small');
      if (!btn) return;

      const originalHtml = btn.innerHTML;
      btn.innerHTML = '...';
      btn.disabled = true;

      try {
        // Get the header text
        const headerEl = sectionEl.querySelector('.ur-kb-section-header-text');
        const title = headerEl ? headerEl.textContent.trim() : 'Section';

        // Clone the section and expand all nested sections
        const clone = sectionEl.cloneNode(true);
        clone.querySelectorAll('.ur-kb-section-body').forEach(b => b.classList.add('expanded'));
        clone.querySelectorAll('.ur-kb-section-header-actions').forEach(a => a.remove());
        clone.querySelectorAll('.ur-kb-section-header-toggle').forEach(t => t.remove());

        const tempDiv = document.createElement('div');
        tempDiv.className = 'ur-kb-markdown';
        tempDiv.style.cssText = 'padding: 20px; font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: #1a1a2e;';
        tempDiv.innerHTML = `<h1 style="margin-bottom: 20px; border-bottom: 2px solid #e5e7eb; padding-bottom: 10px;">${escapeHtml(title)}</h1>`;
        tempDiv.appendChild(clone);

        document.body.appendChild(tempDiv);

        const opt = {
          margin: [10, 10],
          filename: `${title}.pdf`,
          image: { type: 'jpeg', quality: 0.98 },
          html2canvas: { scale: 2, useCORS: true },
          jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
        };

        await html2pdf().set(opt).from(tempDiv).save();
        document.body.removeChild(tempDiv);
      } catch (e) {
        console.error('PDF export failed:', e);
        alert('Failed to export PDF');
      } finally {
        btn.innerHTML = originalHtml;
        btn.disabled = false;
      }
    }

    async generatePDF(content, title) {
      // Render markdown to HTML
      marked.setOptions({ gfm: true, breaks: true });

      const renderer = new marked.Renderer();
      renderer.image = (href, _title, text) => {
        return `<div style="text-align:center;margin:1em 0;"><img src="${escapeHtml(href)}" alt="${escapeHtml(text)}" style="max-width:100%;"></div>`;
      };

      const html = marked.parse(content, { renderer });

      const tempDiv = document.createElement('div');
      tempDiv.className = 'ur-kb-markdown';
      tempDiv.style.cssText = 'padding: 20px; font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: #1a1a2e; max-width: 800px;';
      tempDiv.innerHTML = html;

      // Style tables for PDF
      tempDiv.querySelectorAll('table').forEach(table => {
        table.style.cssText = 'width: 100%; border-collapse: collapse; margin: 1em 0;';
      });
      tempDiv.querySelectorAll('th, td').forEach(cell => {
        cell.style.cssText = 'padding: 8px 12px; border: 1px solid #e5e7eb; text-align: left;';
      });
      tempDiv.querySelectorAll('th').forEach(th => {
        th.style.background = '#f9fafb';
      });
      tempDiv.querySelectorAll('pre').forEach(pre => {
        pre.style.cssText = 'background: #f3f4f6; padding: 12px; border-radius: 6px; overflow-x: auto; font-size: 13px;';
      });
      tempDiv.querySelectorAll('code').forEach(code => {
        if (!code.parentElement.matches('pre')) {
          code.style.cssText = 'background: #f3f4f6; padding: 2px 6px; border-radius: 4px; font-size: 0.9em;';
        }
      });
      tempDiv.querySelectorAll('blockquote').forEach(bq => {
        bq.style.cssText = 'margin: 1em 0; padding: 12px 20px; border-left: 4px solid #4f46e5; background: #f9fafb;';
      });
      tempDiv.querySelectorAll('h1, h2, h3, h4, h5, h6').forEach(h => {
        h.style.cssText = 'margin-top: 1.5em; margin-bottom: 0.5em; color: #1a1a2e;';
      });
      tempDiv.querySelectorAll('h1').forEach(h => {
        h.style.cssText += 'border-bottom: 2px solid #e5e7eb; padding-bottom: 0.3em;';
      });
      tempDiv.querySelectorAll('h2').forEach(h => {
        h.style.cssText += 'border-bottom: 1px solid #e5e7eb; padding-bottom: 0.3em;';
      });

      document.body.appendChild(tempDiv);

      const opt = {
        margin: [10, 10],
        filename: `${title}.pdf`,
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2, useCORS: true },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
      };

      await html2pdf().set(opt).from(tempDiv).save();
      document.body.removeChild(tempDiv);
    }
  }

  // ============================================================
  // Public API
  // ============================================================
  global.URKnowledgeBase = {
    init: function(options) {
      return new URKnowledgeBase(options);
    }
  };

})(typeof window !== 'undefined' ? window : this);
