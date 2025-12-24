/**
 * KnowledgeBase - Portable Markdown Knowledge Base Widget
 * Version 4.0 - With left sidebar navigation, prev/next, breadcrumbs, and enhanced PDF
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
      url: 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js',
      check: () => typeof hljs !== 'undefined',
      css: 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css'
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
      max-height: 100%;
      border-radius: var(--kb-radius);
      overflow: hidden;
      box-shadow: var(--kb-shadow);
      position: relative;
    }

    /* Default container height - can be overridden by parent styles */
    #kb-container, [id*="kb-container"] {
      height: calc(100vh - 200px);
      min-height: 400px;
      max-height: calc(100vh - 200px);
      overflow: hidden;
    }

    /* Page Header - Title Banner */
    .ur-kb-page-header {
      padding: 20px 24px;
      background: var(--kb-sidebar-bg);
      border-bottom: 1px solid var(--kb-border);
      flex-shrink: 0;
    }

    .ur-kb-page-title {
      font-size: 22px;
      font-weight: 700;
      margin: 0 0 4px 0;
      letter-spacing: 0.3px;
      color: var(--kb-text);
    }

    .ur-kb-page-subtitle {
      font-size: 13px;
      color: var(--kb-text-muted);
      margin: 0;
      font-weight: 400;
    }

    /* Search Header */
    .ur-kb-header {
      padding: 12px 20px;
      border-bottom: 1px solid var(--kb-border);
      background: var(--kb-bg);
      display: flex;
      align-items: center;
      gap: 12px;
      flex-shrink: 0;
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


    /* Main Layout */
    .ur-kb-body {
      display: flex;
      flex: 1;
      overflow: hidden;
      position: relative;
      min-height: 0;
    }

    /* Sidebar - Left Navigation */
    .ur-kb-sidebar {
      width: 280px;
      min-width: 280px;
      background: var(--kb-sidebar-bg);
      border-right: 1px solid var(--kb-border);
      display: flex;
      flex-direction: column;
      overflow: hidden;
      transition: all 0.3s ease;
      position: relative;
      flex-shrink: 0;
    }

    .ur-kb-sidebar.collapsed {
      width: 0;
      min-width: 0;
      border-right: none;
      overflow: hidden;
    }

    .ur-kb-sidebar-header {
      padding: 12px 16px;
      border-bottom: 1px solid var(--kb-border);
      display: flex;
      align-items: center;
      font-weight: 600;
      font-size: 13px;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: var(--kb-text-muted);
      white-space: nowrap;
      flex-shrink: 0;
    }

    /* Sidebar toggle button - hidden, using expand button instead */
    .ur-kb-sidebar-toggle {
      display: none;
    }

    .ur-kb-sidebar-content {
      flex: 1;
      overflow-y: auto;
      overflow-x: auto;
      padding: 8px 0;
      min-height: 0;
    }

    /* Custom scrollbar styles for better visibility */
    .ur-kb-sidebar-content::-webkit-scrollbar {
      width: 8px;
      height: 8px;
    }

    .ur-kb-sidebar-content::-webkit-scrollbar-track {
      background: var(--kb-sidebar-bg);
      border-radius: 4px;
    }

    .ur-kb-sidebar-content::-webkit-scrollbar-thumb {
      background: var(--kb-border);
      border-radius: 4px;
      border: 2px solid var(--kb-sidebar-bg);
    }

    .ur-kb-sidebar-content::-webkit-scrollbar-thumb:hover {
      background: var(--kb-text-muted);
    }

    /* Firefox scrollbar */
    .ur-kb-sidebar-content {
      scrollbar-width: thin;
      scrollbar-color: var(--kb-border) var(--kb-sidebar-bg);
    }

    /* Content area scrollbar */
    .ur-kb-content::-webkit-scrollbar {
      width: 8px;
      height: 8px;
    }

    .ur-kb-content::-webkit-scrollbar-track {
      background: var(--kb-bg);
      border-radius: 4px;
    }

    .ur-kb-content::-webkit-scrollbar-thumb {
      background: var(--kb-border);
      border-radius: 4px;
      border: 2px solid var(--kb-bg);
    }

    .ur-kb-content::-webkit-scrollbar-thumb:hover {
      background: var(--kb-text-muted);
    }

    .ur-kb-content {
      scrollbar-width: thin;
      scrollbar-color: var(--kb-border) var(--kb-bg);
    }

    /* Document List in Sidebar */
    .ur-kb-doc {
      margin-bottom: 2px;
    }

    .ur-kb-doc-header {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 10px 16px;
      cursor: pointer;
      transition: all var(--kb-transition);
      font-weight: 600;
      font-size: 14px;
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

    /* Section List in Sidebar */
    .ur-kb-sections {
      display: none;
      padding-left: 12px;
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
      padding: 8px 16px;
      cursor: pointer;
      font-size: 13px;
      color: var(--kb-text-muted);
      border-left: 2px solid transparent;
      transition: all var(--kb-transition);
      white-space: nowrap;
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
      padding-left: 28px;
    }

    .ur-kb-section-children .ur-kb-section-children .ur-kb-section-item {
      padding-left: 40px;
    }

    .ur-kb-section-children .ur-kb-section-children .ur-kb-section-children .ur-kb-section-item {
      padding-left: 52px;
    }

    /* Content Area */
    .ur-kb-main {
      flex: 1;
      display: flex;
      flex-direction: column;
      overflow: hidden;
      position: relative;
      min-height: 0;
    }

    .ur-kb-content {
      flex: 1;
      overflow-y: auto;
      overflow-x: hidden;
      padding: 24px 32px;
      background: var(--kb-bg);
      min-height: 0;
    }

    /* Breadcrumb Navigation */
    .ur-kb-breadcrumb {
      display: flex;
      align-items: center;
      flex-wrap: wrap;
      gap: 6px 8px;
      padding: 12px 32px;
      background: var(--kb-sidebar-bg);
      border-bottom: 1px solid var(--kb-border);
      font-size: 13px;
      flex-shrink: 0;
      line-height: 1.6;
    }

    .ur-kb-breadcrumb-item {
      color: var(--kb-link);
      cursor: pointer;
      transition: color var(--kb-transition);
      white-space: nowrap;
    }

    .ur-kb-breadcrumb-item:hover {
      color: var(--kb-accent-hover);
      text-decoration: underline;
    }

    .ur-kb-breadcrumb-item.current {
      color: var(--kb-text);
      cursor: default;
      font-weight: 500;
    }

    .ur-kb-breadcrumb-item.current:hover {
      text-decoration: none;
    }

    .ur-kb-breadcrumb-sep {
      color: var(--kb-text-muted);
    }

    /* Scroll-aware section indicator - stacked hierarchy */
    .ur-kb-scroll-indicator {
      display: none;
      flex-direction: column;
      padding: 8px 32px;
      background: var(--kb-sidebar-bg);
      border-bottom: 1px solid var(--kb-border);
      font-size: 12px;
      color: var(--kb-text-muted);
      flex-shrink: 0;
      gap: 2px;
    }

    .ur-kb-scroll-indicator.visible {
      display: flex;
    }

    .ur-kb-scroll-indicator-item {
      display: flex;
      align-items: center;
      gap: 6px;
      color: var(--kb-text);
      font-weight: 500;
    }

    .ur-kb-scroll-indicator-item:not(:first-child) {
      padding-left: 16px;
      color: var(--kb-text-muted);
      font-weight: 400;
    }

    .ur-kb-scroll-indicator-item:not(:first-child)::before {
      content: '└';
      color: var(--kb-border);
      margin-right: 4px;
    }

    .ur-kb-scroll-indicator-item:last-child {
      color: var(--kb-accent);
      font-weight: 500;
    }

    .ur-kb-scroll-indicator-icon {
      color: var(--kb-accent);
      flex-shrink: 0;
    }

    .ur-kb-scroll-indicator-icon svg {
      width: 12px;
      height: 12px;
    }

    /* Content Header - Clean, No Frame */
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

    /* Section Header - Clean, No Frame */
    .ur-kb-section-title {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin: 1.5em 0 0.5em 0;
    }

    .ur-kb-section-title h1,
    .ur-kb-section-title h2,
    .ur-kb-section-title h3,
    .ur-kb-section-title h4,
    .ur-kb-section-title h5,
    .ur-kb-section-title h6 {
      margin: 0;
      color: var(--kb-text);
    }

    .ur-kb-section-title h1 { font-size: 24px; }
    .ur-kb-section-title h2 { font-size: 20px; }
    .ur-kb-section-title h3 { font-size: 18px; }
    .ur-kb-section-title h4 { font-size: 16px; }
    .ur-kb-section-title h5 { font-size: 15px; }
    .ur-kb-section-title h6 { font-size: 14px; }

    .ur-kb-section-pdf-btn {
      padding: 4px 8px;
      font-size: 11px;
      background: transparent;
      color: var(--kb-text-muted);
      border: none;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      transition: all var(--kb-transition);
      opacity: 0.6;
    }

    .ur-kb-section-pdf-btn:hover {
      color: var(--kb-accent);
      opacity: 1;
    }

    .ur-kb-section-pdf-btn svg {
      width: 14px;
      height: 14px;
    }

    /* Footer Navigation - Prev/Next */
    .ur-kb-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16px 32px;
      background: var(--kb-sidebar-bg);
      border-top: 1px solid var(--kb-border);
      flex-shrink: 0;
    }

    .ur-kb-nav-btn {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 10px 16px;
      background: var(--kb-bg);
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      cursor: pointer;
      transition: all var(--kb-transition);
      max-width: 45%;
    }

    .ur-kb-nav-btn:hover {
      border-color: var(--kb-accent);
      background: var(--kb-sidebar-hover);
    }

    .ur-kb-nav-btn.disabled {
      opacity: 0.4;
      cursor: not-allowed;
      pointer-events: none;
    }

    .ur-kb-nav-btn svg {
      width: 16px;
      height: 16px;
      color: var(--kb-text-muted);
      flex-shrink: 0;
    }

    .ur-kb-nav-btn-content {
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }

    .ur-kb-nav-btn-label {
      font-size: 11px;
      color: var(--kb-text-muted);
      text-transform: uppercase;
      letter-spacing: 0.05em;
    }

    .ur-kb-nav-btn-title {
      font-size: 14px;
      font-weight: 500;
      color: var(--kb-text);
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .ur-kb-nav-prev .ur-kb-nav-btn-content {
      text-align: left;
    }

    .ur-kb-nav-next .ur-kb-nav-btn-content {
      text-align: right;
    }

    /* Home View */
    .ur-kb-home {
      padding: 20px 0;
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

    /* Markdown Content */
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

    .ur-kb-markdown h1,
    .ur-kb-markdown h2,
    .ur-kb-markdown h3,
    .ur-kb-markdown h4,
    .ur-kb-markdown h5,
    .ur-kb-markdown h6 {
      margin-top: 1.5em;
      margin-bottom: 0.5em;
      color: var(--kb-text);
    }

    .ur-kb-markdown h1 { font-size: 24px; }
    .ur-kb-markdown h2 { font-size: 20px; }
    .ur-kb-markdown h3 { font-size: 18px; }
    .ur-kb-markdown h4 { font-size: 16px; }

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

    /* Sidebar Toggle Button - positioned at sidebar edge */
    .ur-kb-sidebar-expand {
      position: absolute;
      left: 280px;
      top: 50%;
      transform: translateY(-50%);
      width: 20px;
      height: 40px;
      padding: 0;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-left: none;
      border-radius: 0 6px 6px 0;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: var(--kb-text-muted);
      z-index: 101;
      transition: left 0.3s ease, background 0.2s ease;
    }

    .ur-kb-sidebar-expand:hover {
      background: var(--kb-sidebar-hover);
      color: var(--kb-text);
    }

    .ur-kb-sidebar.collapsed ~ .ur-kb-sidebar-expand,
    .ur-kb-sidebar-expand.collapsed {
      left: 0;
    }

    .ur-kb-sidebar-expand svg {
      width: 12px;
      height: 12px;
      transition: transform 0.3s ease;
    }

    .ur-kb-sidebar.collapsed ~ .ur-kb-sidebar-expand svg,
    .ur-kb-sidebar-expand.collapsed svg {
      transform: rotate(180deg);
    }

    /* Responsive */
    @media (max-width: 768px) {
      .ur-kb-sidebar {
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        z-index: 100;
        width: 260px;
        min-width: 260px;
      }

      .ur-kb-sidebar.collapsed {
        width: 0;
        min-width: 0;
      }

      .ur-kb-sidebar-expand {
        left: 260px;
      }

      .ur-kb-sidebar.collapsed ~ .ur-kb-sidebar-expand,
      .ur-kb-sidebar-expand.collapsed {
        left: 0;
      }

      .ur-kb-content {
        padding: 16px;
      }

      .ur-kb-breadcrumb {
        padding: 12px 16px;
      }

      .ur-kb-footer {
        padding: 12px 16px;
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
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.3s ease;
      }

      .ur-kb-overlay.active {
        opacity: 1;
        pointer-events: auto;
      }

      .ur-kb-doc-cards {
        grid-template-columns: 1fr;
      }

      .ur-kb-nav-btn {
        max-width: 48%;
        padding: 8px 12px;
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
    chevronLeft: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m15 18-6-6 6-6"></path></svg>',
    download: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" x2="12" y1="15" y2="3"></line></svg>',
    document: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>',
    home: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path><polyline points="9 22 9 12 15 12 15 22"></polyline></svg>',
    arrowUp: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m18 15-6-6-6 6"/></svg>'
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
  // Main KnowledgeBase Class
  // ============================================================
  class KnowledgeBase {
    constructor(options) {
      this.options = Object.assign({
        container: '#kb-container',
        documents: [],
        sidebarTitle: 'KB Documents',
        theme: 'auto',
        enableSearch: true,
        enablePdfExport: true,
        defaultDocument: null,
        // Page Header Configuration
        pageTitle: '',           // If empty, defaults to "{organizationName} - Knowledge Base"
        pageSubtitle: '',        // If empty, no subtitle shown
        // PDF Configuration
        organizationName: 'Organization',
        applicationName: 'Knowledge Base',
        pdfAuthor: 'System Generated',
        pdfConfidentialMessage: 'HIGHLY CONFIDENTIAL - All Rights Reserved',
        // User info for PDF download tracking (can be set dynamically)
        pdfUserName: '',
        pdfUserEmail: ''
      }, options);

      this.container = null;
      this.documents = [];
      this.currentDoc = null;
      this.currentSection = null;
      this.searchIndex = null;
      this.fuse = null;
      this.sidebarCollapsed = false;
      this.mobileMenuOpen = false;
      this.flatSections = []; // Flat list of all sections for prev/next navigation

      this.init();
    }

    async init() {
      this.container = typeof this.options.container === 'string'
        ? document.querySelector(this.options.container)
        : this.options.container;

      if (!this.container) {
        console.error('KnowledgeBase: Container not found');
        return;
      }

      this.injectStyles();
      this.showLoading();
      await this.loadDependencies();
      this.processDocuments();
      await this.fetchAllDocuments();
      this.buildFlatSections();
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
        author: doc.author || this.options.pdfAuthor,
        lastUpdated: doc.lastUpdated || null,
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

    buildFlatSections() {
      this.flatSections = [];

      const flatten = (sections, docId, parentPath = []) => {
        sections.forEach(section => {
          const path = [...parentPath, section];
          this.flatSections.push({
            docId,
            section,
            path
          });
          if (section.children.length > 0) {
            flatten(section.children, docId, path);
          }
        });
      };

      this.documents.forEach(doc => {
        flatten(doc.sections, doc.id);
      });
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

      // Generate page title - default to "{orgName} - Knowledge Base" if not provided
      const pageTitle = this.options.pageTitle || `${this.options.organizationName} - Knowledge Base`;
      const pageSubtitle = this.options.pageSubtitle || '';

      this.container.innerHTML = `
        <div class="ur-kb ${themeClass}">
          <div class="ur-kb-page-header">
            <h1 class="ur-kb-page-title">${escapeHtml(pageTitle)}</h1>
            ${pageSubtitle ? `<p class="ur-kb-page-subtitle">${escapeHtml(pageSubtitle)}</p>` : ''}
          </div>
          <div class="ur-kb-header">
            <button class="ur-kb-home-btn" aria-label="Home">${ICONS.home}<span>Home</span></button>
            <div class="ur-kb-search-trigger" role="button" tabindex="0">
              ${ICONS.search}
              <span>Search all documents...</span>
              <kbd>⌘K</kbd>
            </div>
          </div>
          <div class="ur-kb-body">
            <aside class="ur-kb-sidebar">
              <div class="ur-kb-sidebar-header">
                <span>${escapeHtml(this.options.sidebarTitle)}</span>
              </div>
              <nav class="ur-kb-sidebar-content">
                ${this.renderDocumentList()}
              </nav>
            </aside>
            <button class="ur-kb-sidebar-expand" type="button" aria-label="Toggle sidebar">${ICONS.chevronLeft}</button>
            <div class="ur-kb-main">
              <div class="ur-kb-breadcrumb"></div>
              <div class="ur-kb-scroll-indicator"></div>
              <main class="ur-kb-content"></main>
              <div class="ur-kb-footer"></div>
            </div>
            <div class="ur-kb-overlay"></div>
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
          const toggle = docEl.querySelector('.ur-kb-doc-toggle');
          const sections = docEl.querySelector('.ur-kb-sections');

          // Toggle expand/collapse
          toggle.classList.toggle('expanded');
          sections.classList.toggle('expanded');

          // Select the document
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

        // Breadcrumb navigation
        const breadcrumbItem = e.target.closest('.ur-kb-breadcrumb-item');
        if (breadcrumbItem && !breadcrumbItem.classList.contains('current')) {
          const docId = breadcrumbItem.dataset.docId;
          const sectionId = breadcrumbItem.dataset.sectionId;
          if (sectionId) {
            this.selectSection(docId, sectionId);
          } else if (docId) {
            this.selectDocument(docId);
          } else {
            this.showHome();
          }
          return;
        }

        // Section PDF button
        const sectionPdfBtn = e.target.closest('.ur-kb-section-pdf-btn');
        if (sectionPdfBtn) {
          const sectionId = sectionPdfBtn.dataset.sectionId;
          this.exportSectionPDF(sectionId);
          return;
        }

        // Main PDF button
        if (e.target.closest('.ur-kb-pdf-btn:not(.ur-kb-section-pdf-btn)')) {
          this.exportPDF();
          return;
        }

        // Sidebar toggle button (expand/collapse)
        if (e.target.closest('.ur-kb-sidebar-expand')) {
          e.preventDefault();
          this.toggleSidebar();
          return;
        }

        // Overlay click - close sidebar on mobile
        if (e.target.closest('.ur-kb-overlay')) {
          this.toggleSidebar(true);
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

        // Prev/Next navigation
        const navBtn = e.target.closest('.ur-kb-nav-btn');
        if (navBtn && !navBtn.classList.contains('disabled')) {
          const direction = navBtn.classList.contains('ur-kb-nav-prev') ? 'prev' : 'next';
          this.navigateSection(direction);
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

      // Scroll listener for section indicator
      const content = kb.querySelector('.ur-kb-content');
      content.addEventListener('scroll', debounce(() => {
        this.updateScrollIndicator();
      }, 50));
    }

    updateScrollIndicator() {
      const indicator = this.container.querySelector('.ur-kb-scroll-indicator');
      const content = this.container.querySelector('.ur-kb-content');

      // Find all section headers in content
      const headers = content.querySelectorAll('.ur-kb-section-title h1, .ur-kb-section-title h2, .ur-kb-section-title h3, .ur-kb-section-title h4, .ur-kb-section-title h5, .ur-kb-section-title h6');

      if (headers.length === 0) {
        indicator.classList.remove('visible');
        return;
      }

      // Find all headers that are above the viewport (scrolled past)
      const scrollTop = content.scrollTop;
      const offset = 100; // Offset from top to consider "in view"
      const contentRect = content.getBoundingClientRect();

      // Build hierarchy of current headers by level
      const currentHierarchy = {}; // level -> header text

      for (const header of headers) {
        const rect = header.getBoundingClientRect();
        const relativeTop = rect.top - contentRect.top;

        if (relativeTop <= offset) {
          // This header is at or above the scroll position
          const level = parseInt(header.tagName.charAt(1));
          currentHierarchy[level] = header.textContent;

          // Clear any lower levels when we pass a higher level header
          for (let l = level + 1; l <= 6; l++) {
            delete currentHierarchy[l];
          }
        } else {
          break;
        }
      }

      // Build the stacked indicator HTML
      const levels = Object.keys(currentHierarchy).map(Number).sort((a, b) => a - b);

      if (levels.length > 0 && scrollTop > 50) {
        indicator.classList.add('visible');
        indicator.innerHTML = levels.map(level => {
          return `<div class="ur-kb-scroll-indicator-item">${escapeHtml(currentHierarchy[level])}</div>`;
        }).join('');
      } else {
        indicator.classList.remove('visible');
        indicator.innerHTML = '';
      }
    }

    hideScrollIndicator() {
      const indicator = this.container.querySelector('.ur-kb-scroll-indicator');
      if (indicator) {
        indicator.classList.remove('visible');
        indicator.innerHTML = '';
      }
    }

    showHome() {
      this.currentDoc = null;
      this.currentSection = null;

      // Clear sidebar active states
      const sidebar = this.container.querySelector('.ur-kb-sidebar-content');
      sidebar.querySelectorAll('.ur-kb-doc-header').forEach(el => el.classList.remove('active'));
      sidebar.querySelectorAll('.ur-kb-section-item').forEach(el => el.classList.remove('active'));

      // Update breadcrumb and hide scroll indicator
      this.updateBreadcrumb([]);
      this.hideScrollIndicator();

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

      // Hide footer on home
      this.updateFooter(null, null);
    }

    selectDocument(docId) {
      const doc = this.documents.find(d => d.id === docId);
      if (!doc) return;

      this.currentDoc = doc;
      this.currentSection = null;

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

      // Update breadcrumb
      this.updateBreadcrumb([{ label: doc.title, docId: doc.id }]);

      // Show full document content (all sections)
      this.renderDocumentContent(doc);
      this.updateFooter(null, null); // Hide prev/next on document overview
    }

    selectSection(docId, sectionId) {
      const doc = this.documents.find(d => d.id === docId);
      if (!doc) return;

      const findSection = (sections, path = []) => {
        for (const section of sections) {
          if (section.id === sectionId) return { section, path: [...path, section] };
          if (section.children.length > 0) {
            const found = findSection(section.children, [...path, section]);
            if (found) return found;
          }
        }
        return null;
      };

      const result = findSection(doc.sections);
      if (!result) return;

      const { section, path } = result;
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

        // Expand parent sections
        let parent = sectionEl.parentElement;
        while (parent && parent.classList.contains('ur-kb-section-children')) {
          parent.classList.add('expanded');
          const toggle = parent.previousElementSibling?.querySelector('.ur-kb-section-toggle');
          if (toggle) toggle.classList.add('expanded');
          parent = parent.parentElement?.parentElement;
        }
      }

      // Update breadcrumb
      const breadcrumbItems = [{ label: doc.title, docId: doc.id }];
      path.forEach((s, i) => {
        breadcrumbItems.push({
          label: s.text,
          docId: doc.id,
          sectionId: s.id,
          isCurrent: i === path.length - 1
        });
      });
      this.updateBreadcrumb(breadcrumbItems);

      this.renderSectionContent(doc, section);
      this.updateFooter(docId, sectionId);
    }

    updateBreadcrumb(items) {
      const breadcrumb = this.container.querySelector('.ur-kb-breadcrumb');

      if (items.length === 0) {
        breadcrumb.style.display = 'none';
        return;
      }

      breadcrumb.style.display = 'flex';

      const html = [
        `<span class="ur-kb-breadcrumb-item" data-doc-id="">${ICONS.home}</span>`
      ];

      // Skip the first item (document name) - start from section headers only
      const sectionItems = items.slice(1);

      sectionItems.forEach((item, index) => {
        // Add separator before each item (no separator before first section item)
        if (index > 0) {
          html.push(`<span class="ur-kb-breadcrumb-sep">/</span>`);
        } else {
          // First separator after Home
          html.push(`<span class="ur-kb-breadcrumb-sep">/</span>`);
        }
        const currentClass = item.isCurrent ? ' current' : '';
        html.push(`<span class="ur-kb-breadcrumb-item${currentClass}" data-doc-id="${item.docId || ''}" data-section-id="${item.sectionId || ''}">${escapeHtml(item.label)}</span>`);
      });

      // If no section items (only document selected), show document name
      if (sectionItems.length === 0 && items.length > 0) {
        html.push(`<span class="ur-kb-breadcrumb-sep">/</span>`);
        const item = items[0];
        const currentClass = item.isCurrent ? ' current' : '';
        html.push(`<span class="ur-kb-breadcrumb-item${currentClass}" data-doc-id="${item.docId || ''}" data-section-id="${item.sectionId || ''}">${escapeHtml(item.label)}</span>`);
      }

      breadcrumb.innerHTML = html.join('');
    }

    updateFooter(docId, sectionId) {
      const footer = this.container.querySelector('.ur-kb-footer');

      if (!docId || !sectionId) {
        footer.style.display = 'none';
        return;
      }

      footer.style.display = 'flex';

      const currentIndex = this.flatSections.findIndex(
        s => s.docId === docId && s.section.id === sectionId
      );

      const prev = currentIndex > 0 ? this.flatSections[currentIndex - 1] : null;
      const next = currentIndex < this.flatSections.length - 1 ? this.flatSections[currentIndex + 1] : null;

      footer.innerHTML = `
        <button class="ur-kb-nav-btn ur-kb-nav-prev ${prev ? '' : 'disabled'}">
          ${ICONS.chevronLeft}
          <div class="ur-kb-nav-btn-content">
            <span class="ur-kb-nav-btn-label">Previous</span>
            <span class="ur-kb-nav-btn-title">${prev ? escapeHtml(prev.section.text) : ''}</span>
          </div>
        </button>
        <button class="ur-kb-nav-btn ur-kb-nav-next ${next ? '' : 'disabled'}">
          <div class="ur-kb-nav-btn-content">
            <span class="ur-kb-nav-btn-label">Next</span>
            <span class="ur-kb-nav-btn-title">${next ? escapeHtml(next.section.text) : ''}</span>
          </div>
          ${ICONS.chevronRight}
        </button>
      `;
    }

    navigateSection(direction) {
      if (!this.currentDoc || !this.currentSection) return;

      const currentIndex = this.flatSections.findIndex(
        s => s.docId === this.currentDoc.id && s.section.id === this.currentSection.id
      );

      const newIndex = direction === 'prev' ? currentIndex - 1 : currentIndex + 1;
      if (newIndex < 0 || newIndex >= this.flatSections.length) return;

      const target = this.flatSections[newIndex];
      this.selectSection(target.docId, target.section.id);
    }

    renderDocumentContent(doc) {
      const content = this.container.querySelector('.ur-kb-content');
      const html = this.renderMarkdownWithHeaders(doc.content);

      content.innerHTML = `
        <div class="ur-kb-content-header">
          <h1 class="ur-kb-content-title">${escapeHtml(doc.title)}</h1>
        </div>
        <div class="ur-kb-markdown">
          ${html}
        </div>
      `;

      content.querySelectorAll('pre code').forEach(block => {
        if (typeof hljs !== 'undefined') hljs.highlightElement(block);
      });

      // Add click handlers for internal anchor links (TOC links)
      this.setupInternalLinkHandlers(doc);

      // Scroll to top
      content.scrollTop = 0;
    }

    setupInternalLinkHandlers(doc) {
      const content = this.container.querySelector('.ur-kb-content');

      content.querySelectorAll('a[href^="#"]').forEach(link => {
        link.addEventListener('click', (e) => {
          e.preventDefault();
          const hash = link.getAttribute('href').substring(1); // Remove the #

          // Find matching section by trying to match the hash with section IDs or text
          const matchingSection = this.findSectionByHash(doc, hash);

          if (matchingSection) {
            this.selectSection(doc.id, matchingSection.id);
          } else {
            // If no exact match, try to scroll to element with that ID
            const targetEl = content.querySelector(`#${CSS.escape(hash)}`);
            if (targetEl) {
              targetEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
          }
        });
      });
    }

    findSectionByHash(doc, hash) {
      // Normalize the hash for comparison
      const normalizedHash = hash.toLowerCase().replace(/[^\w-]/g, '');

      const searchSections = (sections) => {
        for (const section of sections) {
          // Try matching by slugified text
          const sectionSlug = slugify(section.text).toLowerCase();
          if (sectionSlug === normalizedHash || sectionSlug.includes(normalizedHash) || normalizedHash.includes(sectionSlug)) {
            return section;
          }

          // Also try matching section ID (which includes line number)
          const sectionIdBase = section.id.split('-').slice(0, -1).join('-');
          if (sectionIdBase === normalizedHash) {
            return section;
          }

          // Recursively search children
          if (section.children.length > 0) {
            const found = searchSections(section.children);
            if (found) return found;
          }
        }
        return null;
      };

      return searchSections(doc.sections);
    }

    renderSectionContent(doc, section) {
      const content = this.container.querySelector('.ur-kb-content');
      // Skip the main section header since it's shown in the content-header
      const sectionContent = this.extractSectionContent(doc.content, section, true);
      const html = this.renderMarkdownWithHeaders(sectionContent);

      content.innerHTML = `
        <div class="ur-kb-content-header">
          <h1 class="ur-kb-content-title">${escapeHtml(section.text)}</h1>
          ${this.options.enablePdfExport ? `
            <button class="ur-kb-pdf-btn" title="Download this section as PDF">
              ${ICONS.download}
              <span>PDF</span>
            </button>
          ` : ''}
        </div>
        <div class="ur-kb-markdown" id="ur-kb-print-content">
          ${html}
        </div>
      `;

      content.querySelectorAll('pre code').forEach(block => {
        if (typeof hljs !== 'undefined') hljs.highlightElement(block);
      });

      // Scroll to top
      content.scrollTop = 0;
    }

    extractSectionContent(content, section, skipHeader = false) {
      const lines = content.split('\n');
      // Skip the header line if requested (since it's shown in content-header)
      const startLine = skipHeader ? section.line + 1 : section.line;
      let endLine = lines.length;

      for (let i = section.line + 1; i < lines.length; i++) {
        const match = lines[i].match(/^(#{1,6})\s/);
        if (match && match[1].length <= section.level) {
          endLine = i;
          break;
        }
      }

      return lines.slice(startLine, endLine).join('\n');
    }

    renderMarkdownWithHeaders(content) {
      if (typeof marked === 'undefined') {
        return `<pre>${escapeHtml(content)}</pre>`;
      }

      const lines = content.split('\n');
      let html = '';
      let currentContent = [];

      const flushContent = () => {
        if (currentContent.length > 0) {
          html += this.renderMarkdownContent(currentContent.join('\n'));
          currentContent = [];
        }
      };

      lines.forEach((line, index) => {
        const match = line.match(/^(#{1,6})\s+(.+)$/);
        if (match) {
          flushContent();
          const level = match[1].length;
          const text = match[2].trim();
          const id = slugify(text) + '-' + index;
          const headerTag = `h${level}`;

          // No PDF buttons on subsection headers - main PDF button is in content-header
          html += `
            <div class="ur-kb-section-title">
              <${headerTag} id="${id}">${escapeHtml(text)}</${headerTag}>
            </div>
          `;
        } else {
          currentContent.push(line);
        }
      });

      flushContent();
      return html;
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

      // Skip headers - they're rendered separately
      renderer.heading = () => '';

      return marked.parse(content, { renderer });
    }

    toggleSidebar(collapsed) {
      const sidebar = this.container.querySelector('.ur-kb-sidebar');
      const expandBtn = this.container.querySelector('.ur-kb-sidebar-expand');
      const overlay = this.container.querySelector('.ur-kb-overlay');

      if (collapsed === undefined) {
        this.sidebarCollapsed = !this.sidebarCollapsed;
      } else {
        this.sidebarCollapsed = collapsed;
      }

      sidebar.classList.toggle('collapsed', this.sidebarCollapsed);
      expandBtn.classList.toggle('collapsed', this.sidebarCollapsed);

      // Show/hide overlay on mobile when sidebar is open
      if (overlay) {
        overlay.classList.toggle('active', !this.sidebarCollapsed);
      }

      localStorage.setItem('ur-kb-sidebar', this.sidebarCollapsed ? 'collapsed' : 'expanded');
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

      const btn = this.container.querySelector('.ur-kb-pdf-btn:not(.ur-kb-section-pdf-btn)');
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

    async exportSectionPDF(sectionId) {
      if (typeof html2pdf === 'undefined') {
        alert('PDF export is not available');
        return;
      }

      if (!this.currentDoc || !this.currentSection) return;

      const btn = this.container.querySelector(`.ur-kb-section-pdf-btn[data-section-id="${sectionId}"]`);
      if (!btn) return;

      const originalHtml = btn.innerHTML;
      btn.innerHTML = '...';
      btn.disabled = true;

      try {
        // Find the section content from the header element
        const headerEl = btn.closest('.ur-kb-section-title');
        const headingEl = headerEl?.querySelector('h1, h2, h3, h4, h5, h6');
        const title = headingEl ? headingEl.textContent.trim() : 'Section';

        // Get all content after this header until next header of same or higher level
        const contentEl = this.container.querySelector('.ur-kb-markdown');
        const allElements = Array.from(contentEl.children);
        const headerIndex = allElements.indexOf(headerEl);

        if (headerIndex === -1) {
          throw new Error('Header not found');
        }

        // Get the level of current header
        const currentLevel = parseInt(headingEl.tagName.charAt(1));

        // Collect all content until next header of same or higher level
        let sectionContent = [];
        for (let i = headerIndex; i < allElements.length; i++) {
          const el = allElements[i];
          if (i > headerIndex && el.classList.contains('ur-kb-section-title')) {
            const h = el.querySelector('h1, h2, h3, h4, h5, h6');
            if (h) {
              const level = parseInt(h.tagName.charAt(1));
              if (level <= currentLevel) break;
            }
          }
          sectionContent.push(el.cloneNode(true));
        }

        // Use document-specific metadata if available, otherwise fall back to global options
        const docAuthor = this.currentDoc?.author || this.options.pdfAuthor;
        const docLastUpdated = this.currentDoc?.lastUpdated || new Date().toLocaleDateString('en-US', {
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        });

        // Create temp container with cover page
        const tempDiv = document.createElement('div');
        tempDiv.style.cssText = 'font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: #1a1a2e; max-width: 800px;';

        // Get download timestamp
        const downloadTime = new Date().toLocaleString('en-US', {
          year: 'numeric', month: 'long', day: 'numeric',
          hour: '2-digit', minute: '2-digit', second: '2-digit'
        });
        const userName = this.options.pdfUserName || 'Anonymous User';
        const userEmail = this.options.pdfUserEmail || '';

        // Cover Page - centered content with larger title (no absolute positioning for better PDF rendering)
        const coverPage = document.createElement('div');
        coverPage.style.cssText = 'page-break-after: always; text-align: center; padding: 40px;';
        coverPage.innerHTML = `
          <div style="padding-top: 80px; padding-bottom: 60px;">
            <div style="font-size: 20px; color: #6b7280; text-transform: uppercase; letter-spacing: 4px; margin-bottom: 16px; font-weight: 600;">${escapeHtml(this.options.organizationName)}</div>
            <div style="font-size: 16px; color: #9ca3af; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 40px;">${escapeHtml(this.options.applicationName)}</div>
            <h1 style="font-size: 48px; color: #1a1a2e; margin: 0 0 24px 0; line-height: 1.2; font-weight: 700;">${escapeHtml(this.currentDoc.title)}</h1>
            <div style="font-size: 32px; color: #4f46e5; margin-bottom: 50px; font-weight: 500;">${escapeHtml(title)}</div>
            <div style="width: 100px; height: 4px; background: #4f46e5; margin: 0 auto;"></div>
          </div>
          <div style="margin-top: 80px; text-align: center;">
            <div style="font-size: 14px; color: #374151; margin-bottom: 8px;"><strong>Last Updated:</strong> ${escapeHtml(docLastUpdated)}</div>
            <div style="font-size: 14px; color: #374151; margin-bottom: 8px;"><strong>Created By:</strong> ${escapeHtml(docAuthor)}</div>
            <div style="font-size: 14px; color: #374151; margin-bottom: 20px;"><strong>Organization:</strong> ${escapeHtml(this.options.organizationName)}</div>
            <div style="font-size: 14px; color: #374151; margin-bottom: 8px;"><strong>Downloaded By:</strong> ${escapeHtml(userName)}${userEmail ? ` (${escapeHtml(userEmail)})` : ''}</div>
            <div style="font-size: 14px; color: #374151; margin-bottom: 24px;"><strong>Downloaded On:</strong> ${escapeHtml(downloadTime)}</div>
            <div style="font-size: 12px; color: #9ca3af; border-top: 1px solid #e5e7eb; padding-top: 16px; margin-top: 30px;">${escapeHtml(this.options.pdfConfidentialMessage)}<br>&copy; ${new Date().getFullYear()} ${escapeHtml(this.options.organizationName)}</div>
          </div>
        `;
        tempDiv.appendChild(coverPage);

        // Content container
        const contentContainer = document.createElement('div');
        contentContainer.style.cssText = 'padding: 20px;';

        sectionContent.forEach(el => {
          // Remove PDF buttons from clone
          el.querySelectorAll('.ur-kb-section-pdf-btn').forEach(b => b.remove());
          contentContainer.appendChild(el);
        });

        tempDiv.appendChild(contentContainer);

        // Style for PDF with page-break handling
        tempDiv.querySelectorAll('.ur-kb-section-title').forEach(st => {
          st.style.cssText = 'margin: 1.5em 0 1em 0; padding-bottom: 8px; border-bottom: 1px solid #e5e7eb; page-break-after: avoid;';
        });
        tempDiv.querySelectorAll('h1, h2, h3, h4, h5, h6').forEach(h => {
          h.style.cssText = 'margin: 0; color: #1a1a2e; page-break-after: avoid;';
        });
        tempDiv.querySelectorAll('table').forEach(table => {
          table.style.cssText = 'width: 100%; border-collapse: collapse; margin: 1em 0;';
        });
        tempDiv.querySelectorAll('thead').forEach(thead => {
          thead.style.cssText = 'display: table-header-group;';
        });
        tempDiv.querySelectorAll('tr').forEach(tr => {
          tr.style.cssText = 'page-break-inside: avoid;';
        });
        tempDiv.querySelectorAll('th, td').forEach(cell => {
          cell.style.cssText = 'padding: 8px 12px; border: 1px solid #e5e7eb; text-align: left;';
        });
        tempDiv.querySelectorAll('th').forEach(th => {
          th.style.background = '#f9fafb';
        });
        tempDiv.querySelectorAll('pre').forEach(pre => {
          pre.style.cssText = 'background: #f3f4f6; padding: 12px; border-radius: 6px; overflow-x: auto; font-size: 13px; page-break-inside: avoid;';
        });
        tempDiv.querySelectorAll('code').forEach(code => {
          if (!code.parentElement.matches('pre')) {
            code.style.cssText = 'background: #f3f4f6; padding: 2px 6px; border-radius: 4px; font-size: 0.9em;';
          }
        });
        tempDiv.querySelectorAll('blockquote').forEach(bq => {
          bq.style.cssText = 'margin: 1em 0; padding: 12px 20px; border-left: 4px solid #4f46e5; background: #f9fafb; page-break-inside: avoid;';
        });
        // Prevent orphaned list items
        tempDiv.querySelectorAll('li').forEach(li => {
          li.style.cssText = 'page-break-inside: avoid;';
        });
        // Prevent orphaned paragraphs
        tempDiv.querySelectorAll('p').forEach(p => {
          p.style.cssText = (p.style.cssText || '') + 'orphans: 3; widows: 3;';
        });
        // Keep images from breaking
        tempDiv.querySelectorAll('img').forEach(img => {
          img.style.cssText = (img.style.cssText || '') + 'page-break-inside: avoid; max-width: 100%;';
        });

        document.body.appendChild(tempDiv);

        const opt = {
          margin: [15, 15, 25, 15], // top, right, bottom (extra for footer), left
          filename: `${this.currentDoc.title} - ${title}.pdf`,
          image: { type: 'jpeg', quality: 0.98 },
          html2canvas: { scale: 2, useCORS: true, logging: false },
          jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
          pagebreak: { mode: ['avoid-all', 'css', 'legacy'] }
        };

        // Generate PDF with footer
        const pdfInstance = html2pdf().set(opt).from(tempDiv);

        await pdfInstance.toPdf().get('pdf').then((pdf) => {
          const totalPages = pdf.internal.getNumberOfPages();
          const pageWidth = pdf.internal.pageSize.getWidth();
          const pageHeight = pdf.internal.pageSize.getHeight();

          for (let i = 1; i <= totalPages; i++) {
            pdf.setPage(i);

            // Skip footer on cover page
            if (i === 1) continue;

            // Footer line
            pdf.setDrawColor(229, 231, 235);
            pdf.line(15, pageHeight - 18, pageWidth - 15, pageHeight - 18);

            // Footer text - left side (confidential)
            pdf.setFontSize(8);
            pdf.setTextColor(156, 163, 175);
            pdf.text(this.options.pdfConfidentialMessage, 15, pageHeight - 12);

            // Footer text - center (company)
            const companyText = `© ${new Date().getFullYear()} ${this.options.organizationName}`;
            const companyWidth = pdf.getStringUnitWidth(companyText) * 8 / pdf.internal.scaleFactor;
            pdf.text(companyText, (pageWidth - companyWidth) / 2, pageHeight - 12);

            // Footer text - right side (page numbers)
            const pageText = `Page ${i - 1} of ${totalPages - 1}`;
            const pageTextWidth = pdf.getStringUnitWidth(pageText) * 8 / pdf.internal.scaleFactor;
            pdf.text(pageText, pageWidth - 15 - pageTextWidth, pageHeight - 12);
          }
        }).save();

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
      marked.setOptions({ gfm: true, breaks: true });

      const renderer = new marked.Renderer();
      renderer.image = (href, _title, text) => {
        return `<div style="text-align:center;margin:1em 0;"><img src="${escapeHtml(href)}" alt="${escapeHtml(text)}" style="max-width:100%;"></div>`;
      };

      const html = marked.parse(content, { renderer });

      // Use document-specific metadata if available, otherwise fall back to global options
      const docAuthor = this.currentDoc?.author || this.options.pdfAuthor;
      const docLastUpdated = this.currentDoc?.lastUpdated || new Date().toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });

      const tempDiv = document.createElement('div');
      tempDiv.style.cssText = 'font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: #1a1a2e; max-width: 800px;';

      // Get download timestamp
      const downloadTime = new Date().toLocaleString('en-US', {
        year: 'numeric', month: 'long', day: 'numeric',
        hour: '2-digit', minute: '2-digit', second: '2-digit'
      });
      const userName = this.options.pdfUserName || 'Anonymous User';
      const userEmail = this.options.pdfUserEmail || '';

      // Cover Page - centered content with larger title (no absolute positioning - causes issues with html2pdf)
      const coverPage = `
        <div style="page-break-after: always; text-align: center; padding: 40px;">
          <div style="padding-top: 80px; padding-bottom: 60px;">
            <div style="font-size: 20px; color: #6b7280; text-transform: uppercase; letter-spacing: 4px; margin-bottom: 16px; font-weight: 600;">${escapeHtml(this.options.organizationName)}</div>
            <div style="font-size: 16px; color: #9ca3af; text-transform: uppercase; letter-spacing: 2px; margin-bottom: 40px;">${escapeHtml(this.options.applicationName)}</div>
            <h1 style="font-size: 48px; color: #1a1a2e; margin: 0 0 50px 0; line-height: 1.2; font-weight: 700;">${escapeHtml(title)}</h1>
            <div style="width: 100px; height: 4px; background: #4f46e5; margin: 0 auto;"></div>
          </div>
          <div style="margin-top: 80px; text-align: center;">
            <div style="font-size: 14px; color: #374151; margin-bottom: 8px;"><strong>Last Updated:</strong> ${escapeHtml(docLastUpdated)}</div>
            <div style="font-size: 14px; color: #374151; margin-bottom: 8px;"><strong>Created By:</strong> ${escapeHtml(docAuthor)}</div>
            <div style="font-size: 14px; color: #374151; margin-bottom: 20px;"><strong>Organization:</strong> ${escapeHtml(this.options.organizationName)}</div>
            <div style="font-size: 14px; color: #374151; margin-bottom: 8px;"><strong>Downloaded By:</strong> ${escapeHtml(userName)}${userEmail ? ` (${escapeHtml(userEmail)})` : ''}</div>
            <div style="font-size: 14px; color: #374151; margin-bottom: 24px;"><strong>Downloaded On:</strong> ${escapeHtml(downloadTime)}</div>
            <div style="font-size: 12px; color: #9ca3af; border-top: 1px solid #e5e7eb; padding-top: 16px; margin-top: 30px;">${escapeHtml(this.options.pdfConfidentialMessage)}<br>&copy; ${new Date().getFullYear()} ${escapeHtml(this.options.organizationName)}</div>
          </div>
        </div>
      `;

      // Content with page-break styles
      const contentHtml = `
        <div style="padding: 20px;">
          ${html}
        </div>
      `;

      tempDiv.innerHTML = coverPage + contentHtml;

      // Style for PDF with page-break handling
      tempDiv.querySelectorAll('table').forEach(table => {
        table.style.cssText = 'width: 100%; border-collapse: collapse; margin: 1em 0;';
      });
      tempDiv.querySelectorAll('thead').forEach(thead => {
        thead.style.cssText = 'display: table-header-group;';
      });
      tempDiv.querySelectorAll('tr').forEach(tr => {
        tr.style.cssText = 'page-break-inside: avoid;';
      });
      tempDiv.querySelectorAll('th, td').forEach(cell => {
        cell.style.cssText = 'padding: 8px 12px; border: 1px solid #e5e7eb; text-align: left;';
      });
      tempDiv.querySelectorAll('th').forEach(th => {
        th.style.background = '#f9fafb';
      });
      tempDiv.querySelectorAll('pre').forEach(pre => {
        pre.style.cssText = 'background: #f3f4f6; padding: 12px; border-radius: 6px; overflow-x: auto; font-size: 13px; page-break-inside: avoid;';
      });
      tempDiv.querySelectorAll('code').forEach(code => {
        if (!code.parentElement.matches('pre')) {
          code.style.cssText = 'background: #f3f4f6; padding: 2px 6px; border-radius: 4px; font-size: 0.9em;';
        }
      });
      tempDiv.querySelectorAll('blockquote').forEach(bq => {
        bq.style.cssText = 'margin: 1em 0; padding: 12px 20px; border-left: 4px solid #4f46e5; background: #f9fafb; page-break-inside: avoid;';
      });
      tempDiv.querySelectorAll('h1, h2, h3, h4, h5, h6').forEach(h => {
        h.style.cssText = 'margin-top: 1.5em; margin-bottom: 0.5em; color: #1a1a2e; page-break-after: avoid;';
      });
      tempDiv.querySelectorAll('h1').forEach(h => {
        h.style.cssText += 'border-bottom: 2px solid #e5e7eb; padding-bottom: 0.3em;';
      });
      tempDiv.querySelectorAll('h2').forEach(h => {
        h.style.cssText += 'border-bottom: 1px solid #e5e7eb; padding-bottom: 0.3em;';
      });
      // Prevent orphaned list items
      tempDiv.querySelectorAll('li').forEach(li => {
        li.style.cssText = 'page-break-inside: avoid;';
      });
      // Prevent orphaned paragraphs
      tempDiv.querySelectorAll('p').forEach(p => {
        p.style.cssText = (p.style.cssText || '') + 'orphans: 3; widows: 3;';
      });
      // Keep images from breaking
      tempDiv.querySelectorAll('img').forEach(img => {
        img.style.cssText = (img.style.cssText || '') + 'page-break-inside: avoid; max-width: 100%;';
      });

      document.body.appendChild(tempDiv);

      const opt = {
        margin: [15, 15, 25, 15], // top, right, bottom (extra for footer), left
        filename: `${title}.pdf`,
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2, useCORS: true, logging: false },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
        pagebreak: { mode: ['avoid-all', 'css', 'legacy'] }
      };

      // Generate PDF with footer
      const pdfInstance = html2pdf().set(opt).from(tempDiv);

      await pdfInstance.toPdf().get('pdf').then((pdf) => {
        const totalPages = pdf.internal.getNumberOfPages();
        const pageWidth = pdf.internal.pageSize.getWidth();
        const pageHeight = pdf.internal.pageSize.getHeight();

        for (let i = 1; i <= totalPages; i++) {
          pdf.setPage(i);

          // Skip footer on cover page
          if (i === 1) continue;

          // Footer line
          pdf.setDrawColor(229, 231, 235);
          pdf.line(15, pageHeight - 18, pageWidth - 15, pageHeight - 18);

          // Footer text - left side (confidential)
          pdf.setFontSize(8);
          pdf.setTextColor(156, 163, 175);
          pdf.text(this.options.pdfConfidentialMessage, 15, pageHeight - 12);

          // Footer text - center (company)
          const companyText = `© ${new Date().getFullYear()} ${this.options.organizationName}`;
          const companyWidth = pdf.getStringUnitWidth(companyText) * 8 / pdf.internal.scaleFactor;
          pdf.text(companyText, (pageWidth - companyWidth) / 2, pageHeight - 12);

          // Footer text - right side (page numbers)
          const pageText = `Page ${i - 1} of ${totalPages - 1}`;
          const pageTextWidth = pdf.getStringUnitWidth(pageText) * 8 / pdf.internal.scaleFactor;
          pdf.text(pageText, pageWidth - 15 - pageTextWidth, pageHeight - 12);
        }
      }).save();

      document.body.removeChild(tempDiv);
    }
  }

  // ============================================================
  // Public API
  // ============================================================
  global.KnowledgeBase = {
    init: function(options) {
      return new KnowledgeBase(options);
    }
  };

  // Backward compatibility alias
  global.URKnowledgeBase = global.KnowledgeBase;

})(typeof window !== 'undefined' ? window : this);
