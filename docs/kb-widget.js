/**
 * KnowledgeBase - Portable Markdown Knowledge Base Widget
 * Version 4.0 - With left sidebar navigation, prev/next, breadcrumbs, and enhanced PDF
 *
 * Designed & Implemented By: Vishnu Kant (Project EIDOS)
 * © 2025 Project EIDOS - All Rights Reserved
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
      --kb-border: #d1d5db;
      --kb-sidebar-bg: #f4f5f7;
      --kb-sidebar-hover: #e5e7eb;
      --kb-sidebar-active: #e0e7ff;
      --kb-sidebar-active-text: #4338ca;
      --kb-accent: #4f46e5;
      --kb-accent-hover: #4338ca;
      --kb-code-bg: #f3f4f6;
      --kb-code-text: #1a1a2e;
      --kb-link: #4f46e5;
      --kb-search-bg: rgba(0,0,0,0.5);
      --kb-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
      --kb-radius: 8px;
      --kb-transition: 0.2s ease;
    }

    .ur-kb.dark {
      --kb-bg: #0d0d0d;
      --kb-text: #e5e5e5;
      --kb-text-muted: #9ca3af;
      --kb-border: #404040;
      --kb-sidebar-bg: #1a1a1a;
      --kb-sidebar-hover: #262626;
      --kb-sidebar-active: #2563eb;
      --kb-sidebar-active-text: #ffffff;
      --kb-accent: #3b82f6;
      --kb-accent-hover: #60a5fa;
      --kb-code-bg: #1a1a1a;
      --kb-code-text: #e5e5e5;
      --kb-link: #60a5fa;
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
      border-bottom: none;
      flex-shrink: 0;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 24px;
      flex-wrap: wrap;
    }

    .ur-kb-page-header-left {
      display: flex;
      flex-direction: column;
      gap: 4px;
      min-width: 0;
    }

    .ur-kb-page-header-right {
      display: flex;
      align-items: center;
      gap: 12px;
      flex-shrink: 0;
    }

    .ur-kb-page-title {
      font-size: 32px;
      font-weight: 700;
      margin: 0 0 4px 0;
      letter-spacing: 0.3px;
      color: var(--kb-text);
      cursor: pointer;
      transition: color 0.2s ease;
      user-select: none;
    }

    .ur-kb-page-title:hover {
      color: var(--kb-accent);
    }

    .ur-kb-page-title:focus-visible {
      outline: 2px solid var(--kb-accent);
      outline-offset: 2px;
      border-radius: 4px;
    }

    .ur-kb-page-subtitle {
      font-size: 14px;
      color: var(--kb-text-muted);
      margin: 0;
      font-weight: 400;
    }

    /* Inline Search */
    .ur-kb-inline-search {
      position: relative;
      max-width: 500px;
      min-width: 300px;
    }

    .ur-kb-inline-search-input-wrap {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 8px 16px;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      transition: all var(--kb-transition);
    }

    .ur-kb-inline-search-input-wrap:focus-within {
      border-color: var(--kb-accent);
      box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    }

    .ur-kb-inline-search-input-wrap svg {
      width: 18px;
      height: 18px;
      color: var(--kb-text-muted);
      flex-shrink: 0;
    }

    .ur-kb-inline-search-input {
      flex: 1;
      border: none;
      background: transparent;
      color: var(--kb-text);
      font-size: 14px;
      outline: none;
      min-width: 0;
    }

    .ur-kb-inline-search-input::placeholder {
      color: var(--kb-text-muted);
    }

    .ur-kb-search-shortcut {
      font-family: inherit;
      font-size: 12px;
      padding: 2px 6px;
      background: var(--kb-bg);
      border: 1px solid var(--kb-border);
      border-radius: 4px;
      color: var(--kb-text-muted);
      flex-shrink: 0;
    }

    .ur-kb-inline-search-input:not(:placeholder-shown) ~ .ur-kb-search-shortcut {
      display: none;
    }

    .ur-kb-inline-search-clear {
      background: none;
      border: none;
      padding: 4px;
      cursor: pointer;
      color: var(--kb-text-muted);
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 4px;
      transition: all 0.2s ease;
    }

    .ur-kb-inline-search-clear:hover {
      background: var(--kb-sidebar-hover);
      color: var(--kb-text);
    }

    .ur-kb-inline-search-clear svg {
      width: 14px;
      height: 14px;
    }

    /* Search Dropdown */
    .ur-kb-inline-search-dropdown {
      position: absolute;
      top: 100%;
      left: 0;
      right: 0;
      margin-top: 4px;
      background: var(--kb-bg);
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      box-shadow: var(--kb-shadow), 0 10px 40px rgba(0,0,0,0.15);
      max-height: 400px;
      overflow-y: auto;
      z-index: 1000;
      display: none;
    }

    .ur-kb-inline-search-dropdown.active {
      display: block;
    }

    .ur-kb-inline-search-dropdown:empty {
      display: none !important;
    }

    .ur-kb-search-result {
      padding: 12px 16px;
      cursor: pointer;
      border-bottom: 1px solid var(--kb-border);
      transition: background 0.15s ease;
    }

    .ur-kb-search-result:last-child {
      border-bottom: none;
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
      color: var(--kb-accent);
      flex-shrink: 0;
    }

    .ur-kb-search-result-path {
      font-size: 12px;
      color: var(--kb-text-muted);
      margin-bottom: 4px;
    }

    .ur-kb-search-result-preview {
      font-size: 13px;
      color: var(--kb-text-muted);
      line-height: 1.4;
    }

    .ur-kb-search-result-preview mark {
      background: #fef08a;
      color: inherit;
      padding: 0 2px;
      border-radius: 2px;
    }

    .ur-kb.dark .ur-kb-search-result-preview mark {
      background: #854d0e;
      color: #fef9c3;
    }

    .ur-kb-no-results {
      padding: 24px 16px;
      text-align: center;
      color: var(--kb-text-muted);
    }

    .ur-kb-search-hint {
      padding: 8px 16px;
      font-size: 12px;
      color: var(--kb-text-muted);
      background: var(--kb-sidebar-bg);
      border-top: 1px solid var(--kb-border);
      display: flex;
      gap: 16px;
    }

    .ur-kb-search-hint kbd {
      background: var(--kb-bg);
      padding: 1px 4px;
      border-radius: 3px;
      border: 1px solid var(--kb-border);
      font-size: 11px;
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
      border-right: none;
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
      border-bottom: none;
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
      background: transparent;
    }

    .ur-kb-doc-header.active {
      background: transparent;
      color: var(--kb-text);
      font-weight: 700;
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
      font-weight: 400;
    }

    .ur-kb-section-item:hover {
      color: var(--kb-text);
      background: transparent;
    }

    .ur-kb-section-item.active {
      color: var(--kb-text);
      border-left-color: var(--kb-accent);
      background: transparent;
      font-weight: 700;
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
      background: var(--kb-bg);
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
      border-bottom: none;
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

    .ur-kb-content-meta {
      display: flex;
      align-items: center;
      gap: 12px;
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
      padding: 24px 32px;
      background: transparent;
      border-top: none;
      flex-shrink: 0;
    }

    .ur-kb-nav-btn {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 12px 20px;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      cursor: pointer;
      transition: all var(--kb-transition);
      max-width: 45%;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .ur-kb-nav-btn:hover {
      background: var(--kb-sidebar-hover);
      border-color: var(--kb-accent);
      transform: translateY(-1px);
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .ur-kb-nav-btn.disabled {
      opacity: 0.4;
      cursor: not-allowed;
      pointer-events: none;
    }

    .ur-kb-nav-btn svg {
      width: 18px;
      height: 18px;
      color: var(--kb-accent);
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
      font-weight: 600;
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
      color: var(--kb-code-text);
      padding: 2px 6px;
      border-radius: 4px;
      font-family: 'SF Mono', Consolas, monospace;
      font-size: 0.9em;
    }

    .ur-kb-markdown pre {
      background: var(--kb-code-bg);
      color: var(--kb-code-text);
      padding: 16px;
      border-radius: var(--kb-radius);
      overflow-x: auto;
      margin: 1em 0;
      border: 1px solid var(--kb-border);
      position: relative;
    }

    .ur-kb-markdown pre code {
      background: none;
      padding: 0;
      color: inherit;
    }

    /* Copy Code Button */
    .ur-kb-code-wrapper {
      position: relative;
    }

    .ur-kb-copy-btn {
      position: absolute;
      top: 8px;
      right: 8px;
      padding: 4px 8px;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: 4px;
      color: var(--kb-text-muted);
      font-size: 12px;
      cursor: pointer;
      opacity: 0;
      transition: opacity 0.2s ease, background 0.2s ease;
      display: flex;
      align-items: center;
      gap: 4px;
      z-index: 5;
    }

    .ur-kb-code-wrapper:hover .ur-kb-copy-btn {
      opacity: 1;
    }

    .ur-kb-copy-btn:hover {
      background: var(--kb-sidebar-hover);
      color: var(--kb-text);
    }

    .ur-kb-copy-btn.copied {
      background: #10b981;
      color: white;
      border-color: #10b981;
    }

    .ur-kb-copy-btn svg {
      width: 14px;
      height: 14px;
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

    /* Video Container (16:9 aspect ratio) */
    .ur-kb-video-container {
      position: relative;
      width: 100%;
      padding-top: 56.25%;
      margin: 1em 0;
      background: var(--kb-code-bg);
      border-radius: var(--kb-radius);
      overflow: hidden;
    }

    .ur-kb-video-container iframe,
    .ur-kb-video-container video {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      object-fit: contain;
      border: none;
    }

    /* Image Container (natural dimensions, max-width constrained) */
    .ur-kb-image-container {
      display: inline-block;
      margin: 1em 0;
      padding: 8px;
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      background: var(--kb-bg);
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .ur-kb-image-container:hover {
      transform: scale(1.02);
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }

    .ur-kb-image-container img {
      display: block;
      max-width: 100%;
      height: auto;
      border-radius: calc(var(--kb-radius) - 4px);
    }

    /* Image Lightbox */
    .ur-kb-lightbox {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.9);
      z-index: 10000;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      visibility: hidden;
      transition: opacity 0.3s ease, visibility 0.3s ease;
    }

    .ur-kb-lightbox.active {
      opacity: 1;
      visibility: visible;
    }

    .ur-kb-lightbox img {
      max-width: 90vw;
      max-height: 90vh;
      object-fit: contain;
      border-radius: var(--kb-radius);
      box-shadow: 0 8px 32px rgba(0,0,0,0.5);
    }

    .ur-kb-lightbox-close {
      position: absolute;
      top: 20px;
      right: 20px;
      width: 40px;
      height: 40px;
      background: rgba(255,255,255,0.1);
      border: none;
      border-radius: 50%;
      color: white;
      font-size: 24px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: background 0.2s ease;
    }

    .ur-kb-lightbox-close:hover {
      background: rgba(255,255,255,0.2);
    }

    /* Scroll to Top Button */
    .ur-kb-scroll-top {
      position: absolute;
      bottom: 80px;
      right: 20px;
      width: 40px;
      height: 40px;
      background: var(--kb-accent);
      color: white;
      border: none;
      border-radius: 50%;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      visibility: hidden;
      transition: opacity 0.3s ease, visibility 0.3s ease, transform 0.2s ease;
      z-index: 100;
      box-shadow: 0 2px 8px rgba(0,0,0,0.2);
    }

    .ur-kb-scroll-top.visible {
      opacity: 1;
      visibility: visible;
    }

    .ur-kb-scroll-top:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.3);
    }

    .ur-kb-scroll-top svg {
      width: 20px;
      height: 20px;
    }

    /* Reading Time Badge */
    .ur-kb-reading-time {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      font-size: 13px;
      color: var(--kb-text-muted);
      margin-left: 12px;
    }

    .ur-kb-reading-time svg {
      width: 14px;
      height: 14px;
    }

    /* Search Highlighting */
    .ur-kb-search-highlight {
      background: #fef08a;
      color: #1a1a2e;
      padding: 1px 2px;
      border-radius: 2px;
    }

    .ur-kb.dark .ur-kb-search-highlight {
      background: #854d0e;
      color: #fef9c3;
    }

    .ur-kb-search-highlight.current {
      background: #f97316;
      color: white;
      outline: 2px solid #f97316;
      outline-offset: 1px;
    }

    .ur-kb.dark .ur-kb-search-highlight.current {
      background: #ea580c;
      color: white;
      outline-color: #ea580c;
    }

    /* Search Indicator Bar */
    .ur-kb-search-indicator {
      position: sticky;
      top: 0;
      left: 0;
      right: 0;
      background: var(--kb-sidebar-bg);
      border-bottom: 1px solid var(--kb-border);
      padding: 8px 16px;
      display: none;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      z-index: 50;
      font-size: 13px;
    }

    .ur-kb-search-indicator.active {
      display: flex;
    }

    .ur-kb-search-indicator-info {
      display: flex;
      align-items: center;
      gap: 8px;
      color: var(--kb-text);
    }

    .ur-kb-search-indicator-info svg {
      width: 16px;
      height: 16px;
      color: var(--kb-text-muted);
    }

    .ur-kb-search-indicator-term {
      background: #fef08a;
      color: #1a1a2e;
      padding: 2px 8px;
      border-radius: 4px;
      font-weight: 500;
    }

    .ur-kb.dark .ur-kb-search-indicator-term {
      background: #854d0e;
      color: #fef9c3;
    }

    .ur-kb-search-indicator-count {
      color: var(--kb-text-muted);
    }

    .ur-kb-search-indicator-actions {
      display: flex;
      align-items: center;
      gap: 4px;
    }

    .ur-kb-search-indicator-nav {
      padding: 4px 8px;
      background: transparent;
      border: 1px solid var(--kb-border);
      border-radius: 4px;
      color: var(--kb-text);
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 4px;
      font-size: 12px;
      transition: background 0.2s ease;
    }

    .ur-kb-search-indicator-nav:hover {
      background: var(--kb-sidebar-hover);
    }

    .ur-kb-search-indicator-nav svg {
      width: 14px;
      height: 14px;
    }

    .ur-kb-search-indicator-clear {
      padding: 4px 8px;
      background: transparent;
      border: 1px solid var(--kb-border);
      border-radius: 4px;
      color: var(--kb-text-muted);
      cursor: pointer;
      font-size: 12px;
      transition: background 0.2s ease, color 0.2s ease;
    }

    .ur-kb-search-indicator-clear:hover {
      background: #ef4444;
      border-color: #ef4444;
      color: white;
    }

    /* Keyboard Shortcuts Modal */
    .ur-kb-shortcuts-modal {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: var(--kb-search-bg);
      z-index: 10001;
      display: flex;
      align-items: center;
      justify-content: center;
      opacity: 0;
      visibility: hidden;
      transition: opacity 0.2s ease, visibility 0.2s ease;
    }

    .ur-kb-shortcuts-modal.active {
      opacity: 1;
      visibility: visible;
    }

    .ur-kb-shortcuts-content {
      background: var(--kb-bg);
      border-radius: var(--kb-radius);
      padding: 24px;
      max-width: 500px;
      width: 90%;
      max-height: 80vh;
      overflow-y: auto;
      box-shadow: 0 8px 32px rgba(0,0,0,0.3);
    }

    .ur-kb-shortcuts-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      padding-bottom: 12px;
      border-bottom: 1px solid var(--kb-border);
    }

    .ur-kb-shortcuts-header h3 {
      margin: 0;
      font-size: 18px;
      color: var(--kb-text);
    }

    .ur-kb-shortcuts-close {
      background: none;
      border: none;
      color: var(--kb-text-muted);
      cursor: pointer;
      padding: 4px;
    }

    .ur-kb-shortcuts-close:hover {
      color: var(--kb-text);
    }

    .ur-kb-shortcut-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 8px 0;
      border-bottom: 1px solid var(--kb-border);
    }

    .ur-kb-shortcut-row:last-child {
      border-bottom: none;
    }

    .ur-kb-shortcut-desc {
      color: var(--kb-text);
      font-size: 14px;
    }

    .ur-kb-shortcut-keys {
      display: flex;
      gap: 4px;
    }

    .ur-kb-shortcut-keys kbd {
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: 4px;
      padding: 4px 8px;
      font-family: inherit;
      font-size: 12px;
      color: var(--kb-text);
      box-shadow: 0 1px 2px rgba(0,0,0,0.1);
    }

    /* Legacy media container for backwards compatibility */
    .ur-kb-media-container {
      position: relative;
      width: 100%;
      padding-top: 56.25%;
      margin: 1em 0;
      background: var(--kb-code-bg);
      border-radius: var(--kb-radius);
      overflow: hidden;
    }

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

    .ur-kb-media-container img {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      object-fit: contain;
      border: none;
    }

    /* Link Preview Card */
    .ur-kb-link-preview {
      display: flex;
      flex-direction: column;
      border: 1px solid var(--kb-border);
      border-radius: var(--kb-radius);
      margin: 1em 0;
      padding: 12px 16px;
      background: var(--kb-bg);
      text-decoration: none;
      color: inherit;
      transition: all var(--kb-transition);
    }

    .ur-kb-link-preview:hover {
      border-color: var(--kb-accent);
      background: var(--kb-code-bg);
    }

    .ur-kb-link-preview-title {
      font-weight: 600;
      font-size: 14px;
      color: var(--kb-accent);
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .ur-kb-link-preview-title svg {
      width: 14px;
      height: 14px;
      flex-shrink: 0;
    }

    .ur-kb-link-preview-url {
      display: block;
      font-size: 12px;
      color: var(--kb-text-muted);
      margin-top: 4px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
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

      .ur-kb-a11y-toolbar {
        flex-wrap: wrap;
      }

      .ur-kb-page-header {
        flex-direction: column;
        align-items: stretch;
        gap: 12px;
      }

      .ur-kb-page-header-left {
        width: 100%;
      }

      .ur-kb-page-header-right {
        width: 100%;
        justify-content: space-between;
      }

      .ur-kb-inline-search {
        flex: 1;
        min-width: 0;
      }
    }

    /* Accessibility Toolbar */
    .ur-kb-a11y-toolbar {
      display: flex;
      align-items: center;
      gap: 4px;
      margin-left: 8px;
      padding-left: 12px;
      border-left: 1px solid var(--kb-border);
    }

    .ur-kb-a11y-btn {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 32px;
      height: 32px;
      padding: 0;
      background: var(--kb-sidebar-bg);
      border: 1px solid var(--kb-border);
      border-radius: 6px;
      cursor: pointer;
      color: var(--kb-text-muted);
      font-size: 14px;
      font-weight: 600;
      transition: all var(--kb-transition);
    }

    .ur-kb-a11y-btn:hover {
      background: var(--kb-sidebar-hover);
      border-color: var(--kb-accent);
      color: var(--kb-text);
    }

    .ur-kb-a11y-btn.active {
      background: var(--kb-accent);
      border-color: var(--kb-accent);
      color: white;
    }

    .ur-kb-a11y-btn svg {
      width: 16px;
      height: 16px;
    }

    .ur-kb-a11y-btn.speaking {
      background: var(--kb-accent);
      border-color: var(--kb-accent);
      color: white;
      animation: ur-kb-pulse 1.5s ease-in-out infinite;
    }

    @keyframes ur-kb-pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.6; }
    }

    /* Text Zoom Classes */
    .ur-kb.zoom-90 { font-size: 14.4px; }
    .ur-kb.zoom-100 { font-size: 16px; }
    .ur-kb.zoom-110 { font-size: 17.6px; }
    .ur-kb.zoom-125 { font-size: 20px; }
    .ur-kb.zoom-150 { font-size: 24px; }

    /* High Contrast Mode */
    .ur-kb.high-contrast {
      --kb-bg: #000000;
      --kb-text: #ffffff;
      --kb-text-muted: #cccccc;
      --kb-border: #ffffff;
      --kb-sidebar-bg: #000000;
      --kb-sidebar-hover: #333333;
      --kb-sidebar-active: #0055ff;
      --kb-sidebar-active-text: #ffffff;
      --kb-accent: #ffff00;
      --kb-accent-hover: #ffff66;
      --kb-code-bg: #1a1a1a;
      --kb-link: #00ffff;
    }

    .ur-kb.high-contrast .ur-kb-a11y-btn {
      border-width: 2px;
    }

    .ur-kb.high-contrast a {
      text-decoration: underline;
    }

    /* TTS Selection Highlight */
    .ur-kb-tts-highlight {
      background: rgba(79, 70, 229, 0.3);
      border-radius: 2px;
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
    arrowUp: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m18 15-6-6-6 6"/></svg>',
    externalLink: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>',
    speaker: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon><path d="M15.54 8.46a5 5 0 0 1 0 7.07"></path><path d="M19.07 4.93a10 10 0 0 1 0 14.14"></path></svg>',
    speakerOff: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon><line x1="22" y1="9" x2="16" y2="15"></line><line x1="16" y1="9" x2="22" y2="15"></line></svg>',
    contrast: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><path d="M12 2a10 10 0 0 1 0 20z" fill="currentColor"></path></svg>',
    sun: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>',
    moon: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>',
    monitor: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg>',
    copy: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="14" height="14" x="8" y="8" rx="2" ry="2"></rect><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path></svg>',
    check: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>',
    clock: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>',
    keyboard: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="20" height="16" x="2" y="4" rx="2" ry="2"></rect><path d="M6 8h.001"></path><path d="M10 8h.001"></path><path d="M14 8h.001"></path><path d="M18 8h.001"></path><path d="M8 12h.001"></path><path d="M12 12h.001"></path><path d="M16 12h.001"></path><path d="M7 16h10"></path></svg>',
    close: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>'
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

  function decodeHtml(text) {
    const div = document.createElement('div');
    div.innerHTML = text;
    return div.textContent;
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
        pdfUserEmail: '',
        // Accessibility Configuration
        enableAccessibility: true,    // Show accessibility toolbar (zoom, TTS, contrast)
        ttsApiKey: '',                 // OpenAI API key for natural TTS (falls back to browser TTS if empty)
        ttsVoice: 'alloy',             // OpenAI voice: alloy, echo, fable, onyx, nova, shimmer
        ttsModel: 'tts-1'              // OpenAI model: tts-1 (faster) or tts-1-hd (higher quality)
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

      // Accessibility state
      this.zoomLevel = parseInt(localStorage.getItem('ur-kb-zoom') || '100', 10);
      this.highContrast = localStorage.getItem('ur-kb-contrast') === 'true';
      this.ttsActive = false;
      this.speechSynthesis = window.speechSynthesis || null;
      this.currentUtterance = null;
      this.ttsAudio = null;  // For OpenAI TTS audio playback

      // Theme state: 'light', 'dark', or 'auto'
      // Check localStorage first, then fall back to config option
      this.currentTheme = localStorage.getItem('ur-kb-theme') || this.options.theme || 'auto';

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

      // Preload TTS voices (some browsers load them asynchronously)
      if (this.speechSynthesis) {
        this.speechSynthesis.getVoices();
        if (typeof this.speechSynthesis.onvoiceschanged !== 'undefined') {
          this.speechSynthesis.onvoiceschanged = () => {
            this.speechSynthesis.getVoices();
          };
        }
      }

      // Listen for system theme changes (for auto mode)
      if (window.matchMedia) {
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
          if (this.currentTheme === 'auto') {
            const kb = this.container.querySelector('.ur-kb');
            if (kb) {
              kb.classList.toggle('dark', e.matches);
            }
          }
        });
      }

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
      await Promise.all(this.documents.map(async (doc, docIndex) => {
        try {
          const response = await fetch(doc.url);
          if (!response.ok) throw new Error(`HTTP ${response.status}`);
          doc.content = await response.text();
          doc.sections = this.parseHeaders(doc.content);
          doc.loaded = true;

          // Check if user provided a custom title
          const originalDoc = this.options.documents[docIndex];
          const hasCustomTitle = originalDoc && originalDoc.title;

          // Always remove the first H1 from sections to avoid duplication
          if (doc.sections.length > 0) {
            const firstH1 = doc.sections.find(s => s.level === 1);
            if (firstH1) {
              // If no custom title was provided, use the first H1 as the document title
              if (!hasCustomTitle) {
                doc.title = firstH1.text;
              }
              // Remove the first H1 but keep its children at the root level
              const firstH1Index = doc.sections.findIndex(s => s.id === firstH1.id);
              if (firstH1Index !== -1) {
                // Replace the first H1 with its children
                doc.sections.splice(firstH1Index, 1, ...firstH1.children);
              }
            }
          }
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
          const text = decodeHtml(match[2].trim());
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
          content: doc.content,
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
              content: sectionContent,
              path: `${doc.title} > ${sectionPath}`
            });

            if (section.children.length > 0) indexSections(section.children, sectionPath);
          });
        };

        indexSections(doc.sections);
      });

      this.searchIndex = searchData;
      this.fuse = new Fuse(searchData, {
        keys: [
          { name: 'title', weight: 2 },
          { name: 'content', weight: 1 }
        ],
        includeMatches: true,
        threshold: 0.2,
        minMatchCharLength: 2,
        ignoreLocation: true,
        findAllMatches: true
      });
    }

    render() {
      const themeClass = this.getEffectiveTheme() === 'dark' ? 'dark' : '';
      const zoomClass = `zoom-${this.zoomLevel}`;
      const contrastClass = this.highContrast ? 'high-contrast' : '';

      // Generate page title - default to "{orgName} - Knowledge Base" if not provided
      const pageTitle = this.options.pageTitle || `${this.options.organizationName} - Knowledge Base`;
      const pageSubtitle = this.options.pageSubtitle || '';

      this.container.innerHTML = `
        <div class="ur-kb ${themeClass} ${zoomClass} ${contrastClass}">
          <div class="ur-kb-page-header">
            <div class="ur-kb-page-header-left">
              <h1 class="ur-kb-page-title" role="button" tabindex="0" aria-label="Home">${escapeHtml(pageTitle)}</h1>
              ${pageSubtitle ? `<p class="ur-kb-page-subtitle">${escapeHtml(pageSubtitle)}</p>` : ''}
            </div>
            <div class="ur-kb-page-header-right">
              <div class="ur-kb-inline-search">
                <div class="ur-kb-inline-search-input-wrap">
                  ${ICONS.search}
                  <input type="text" class="ur-kb-inline-search-input" placeholder="Search all documents..." autocomplete="off">
                  <kbd class="ur-kb-search-shortcut">⌘K</kbd>
                  <button type="button" class="ur-kb-inline-search-clear" style="display:none">${ICONS.close}</button>
                </div>
                <div class="ur-kb-inline-search-dropdown"></div>
              </div>
              ${this.options.enableAccessibility ? `
              <div class="ur-kb-a11y-toolbar">
                <button type="button" class="ur-kb-a11y-btn ur-kb-zoom-out" aria-label="Decrease text size" title="Decrease text size">A-</button>
                <button type="button" class="ur-kb-a11y-btn ur-kb-zoom-in" aria-label="Increase text size" title="Increase text size">A+</button>
                <button type="button" class="ur-kb-a11y-btn ur-kb-tts-btn" aria-label="Read aloud" title="Read aloud">${ICONS.speaker}</button>
                <button type="button" class="ur-kb-a11y-btn ur-kb-contrast-btn${this.highContrast ? ' active' : ''}" aria-label="Toggle high contrast" title="Toggle high contrast">${ICONS.contrast}</button>
                <button type="button" class="ur-kb-a11y-btn ur-kb-theme-btn" aria-label="Toggle theme" title="Theme: ${this.currentTheme}">${this.getThemeIcon()}</button>
              </div>
              ` : ''}
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
              <button class="ur-kb-scroll-top" type="button" aria-label="Scroll to top" title="Scroll to top">${ICONS.arrowUp}</button>
            </div>
            <div class="ur-kb-overlay"></div>
          </div>
          ${this.renderLightbox()}
          ${this.renderShortcutsModal()}
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


    renderLightbox() {
      return `
        <div class="ur-kb-lightbox">
          <button class="ur-kb-lightbox-close" type="button" aria-label="Close">${ICONS.close}</button>
          <img src="" alt="Enlarged image">
        </div>
      `;
    }

    renderShortcutsModal() {
      return `
        <div class="ur-kb-shortcuts-modal">
          <div class="ur-kb-shortcuts-content">
            <div class="ur-kb-shortcuts-header">
              <h3>${ICONS.keyboard} Keyboard Shortcuts</h3>
              <button class="ur-kb-shortcuts-close" type="button" aria-label="Close">${ICONS.close}</button>
            </div>
            <div class="ur-kb-shortcuts-body">
              <div class="ur-kb-shortcut-row">
                <span class="ur-kb-shortcut-desc">Open search</span>
                <span class="ur-kb-shortcut-keys"><kbd>⌘</kbd><kbd>K</kbd></span>
              </div>
              <div class="ur-kb-shortcut-row">
                <span class="ur-kb-shortcut-desc">Close modal / Go back</span>
                <span class="ur-kb-shortcut-keys"><kbd>ESC</kbd></span>
              </div>
              <div class="ur-kb-shortcut-row">
                <span class="ur-kb-shortcut-desc">Navigate search results</span>
                <span class="ur-kb-shortcut-keys"><kbd>↑</kbd><kbd>↓</kbd></span>
              </div>
              <div class="ur-kb-shortcut-row">
                <span class="ur-kb-shortcut-desc">Select search result</span>
                <span class="ur-kb-shortcut-keys"><kbd>Enter</kbd></span>
              </div>
              <div class="ur-kb-shortcut-row">
                <span class="ur-kb-shortcut-desc">Go to previous section</span>
                <span class="ur-kb-shortcut-keys"><kbd>←</kbd></span>
              </div>
              <div class="ur-kb-shortcut-row">
                <span class="ur-kb-shortcut-desc">Go to next section</span>
                <span class="ur-kb-shortcut-keys"><kbd>→</kbd></span>
              </div>
              <div class="ur-kb-shortcut-row">
                <span class="ur-kb-shortcut-desc">Go to home</span>
                <span class="ur-kb-shortcut-keys"><kbd>H</kbd></span>
              </div>
              <div class="ur-kb-shortcut-row">
                <span class="ur-kb-shortcut-desc">Show keyboard shortcuts</span>
                <span class="ur-kb-shortcut-keys"><kbd>?</kbd></span>
              </div>
            </div>
          </div>
        </div>
      `;
    }

    setupEventListeners() {
      const kb = this.container.querySelector('.ur-kb');

      kb.addEventListener('click', (e) => {
        // Page title click (acts as home button)
        if (e.target.closest('.ur-kb-page-title')) {
          this.showHome();
          return;
        }

        // Document card click
        const docCard = e.target.closest('.ur-kb-doc-card');
        if (docCard) {
          this.selectDocument(docCard.dataset.docId);
          return;
        }

        // Document toggle arrow in sidebar (just expand/collapse, don't select)
        const docToggle = e.target.closest('.ur-kb-doc-toggle');
        if (docToggle) {
          e.stopPropagation();
          const docEl = docToggle.closest('.ur-kb-doc');
          const sections = docEl.querySelector('.ur-kb-sections');
          docToggle.classList.toggle('expanded');
          sections.classList.toggle('expanded');
          return;
        }

        // Document header in sidebar (select the document)
        const docHeader = e.target.closest('.ur-kb-doc-header');
        if (docHeader) {
          const docEl = docHeader.closest('.ur-kb-doc');
          const docId = docEl.dataset.docId;

          // Select the document (this will also expand if needed)
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

        // Inline search clear button
        if (e.target.closest('.ur-kb-inline-search-clear')) {
          e.preventDefault();
          this.clearInlineSearch();
          return;
        }

        // Inline search result click
        const searchResult = e.target.closest('.ur-kb-search-result');
        if (searchResult) {
          e.preventDefault();
          e.stopPropagation();
          this.selectSearchResult(searchResult);
          return;
        }

        // Accessibility: Zoom Out (A-)
        if (e.target.closest('.ur-kb-zoom-out')) {
          e.preventDefault();
          this.adjustZoom(-1);
          return;
        }

        // Accessibility: Zoom In (A+)
        if (e.target.closest('.ur-kb-zoom-in')) {
          e.preventDefault();
          this.adjustZoom(1);
          return;
        }

        // Accessibility: Text-to-Speech
        if (e.target.closest('.ur-kb-tts-btn')) {
          e.preventDefault();
          this.toggleTTS();
          return;
        }

        // Accessibility: High Contrast
        if (e.target.closest('.ur-kb-contrast-btn')) {
          e.preventDefault();
          this.toggleHighContrast();
          return;
        }

        // Accessibility: Theme Toggle
        if (e.target.closest('.ur-kb-theme-btn')) {
          e.preventDefault();
          this.cycleTheme();
          return;
        }

        // Copy Code Button
        const copyBtn = e.target.closest('.ur-kb-copy-btn');
        if (copyBtn) {
          e.preventDefault();
          this.copyCode(copyBtn);
          return;
        }

        // Scroll to Top Button
        if (e.target.closest('.ur-kb-scroll-top')) {
          e.preventDefault();
          this.scrollToTop();
          return;
        }

        // Search Indicator - Navigate highlights
        const highlightNavBtn = e.target.closest('.ur-kb-search-indicator-nav');
        if (highlightNavBtn) {
          e.preventDefault();
          const direction = parseInt(highlightNavBtn.dataset.direction, 10);
          this.navigateHighlights(direction);
          return;
        }

        // Search Indicator - Clear highlights
        if (e.target.closest('.ur-kb-search-indicator-clear')) {
          e.preventDefault();
          this.clearSearchHighlights();
          return;
        }

        // Image Lightbox - Open
        const imageContainer = e.target.closest('.ur-kb-image-container');
        if (imageContainer) {
          const img = imageContainer.querySelector('img');
          if (img) {
            this.openLightbox(img.src);
          }
          return;
        }

        // Lightbox - Close
        if (e.target.closest('.ur-kb-lightbox-close') || e.target.classList.contains('ur-kb-lightbox')) {
          this.closeLightbox();
          return;
        }

        // Keyboard Shortcuts Modal - Close
        if (e.target.closest('.ur-kb-shortcuts-close') || e.target.classList.contains('ur-kb-shortcuts-modal')) {
          this.closeShortcutsModal();
          return;
        }

        // Prev/Next navigation
        const navBtn = e.target.closest('.ur-kb-nav-btn');
        if (navBtn && !navBtn.classList.contains('disabled')) {
          const direction = navBtn.classList.contains('ur-kb-nav-prev') ? 'prev' : 'next';
          this.navigateSection(direction);
          return;
        }

        // Internal anchor links (TOC links) - using event delegation
        const anchorLink = e.target.closest('a[href^="#"]');
        if (anchorLink && this.currentDoc) {
          e.preventDefault();
          const hash = anchorLink.getAttribute('href').substring(1); // Remove the #
          const matchingSection = this.findSectionByHash(this.currentDoc, hash);

          if (matchingSection) {
            this.selectSection(this.currentDoc.id, matchingSection.id);
          } else {
            // If no exact match, try to scroll to element with that ID
            const content = this.container.querySelector('.ur-kb-content');
            const targetEl = content.querySelector(`#${CSS.escape(hash)}`);
            if (targetEl) {
              targetEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
          }
          return;
        }
      });

      // Inline search input
      const inlineSearchInput = kb.querySelector('.ur-kb-inline-search-input');
      const searchDropdown = kb.querySelector('.ur-kb-inline-search-dropdown');
      const clearBtn = kb.querySelector('.ur-kb-inline-search-clear');

      inlineSearchInput.addEventListener('input', debounce((e) => {
        const query = e.target.value.trim();
        this.performInlineSearch(query);

        // Show/hide clear button
        clearBtn.style.display = query ? 'flex' : 'none';

        // Live highlight in current document
        if (query.length >= 2) {
          this.highlightSearchTerms(query);
        } else {
          this.clearSearchHighlights();
        }
      }, 150));

      // Focus inline search input
      inlineSearchInput.addEventListener('focus', () => {
        const query = inlineSearchInput.value.trim();
        if (query.length >= 2) {
          this.performInlineSearch(query);
        }
      });

      // Close dropdown on outside click
      document.addEventListener('click', (e) => {
        if (!e.target.closest('.ur-kb-inline-search')) {
          searchDropdown.classList.remove('active');
        }
      });

      // Keyboard navigation in search
      inlineSearchInput.addEventListener('keydown', (e) => {
        const dropdown = kb.querySelector('.ur-kb-inline-search-dropdown');
        const isDropdownActive = dropdown.classList.contains('active');

        if (e.key === 'Escape') {
          e.preventDefault();
          if (isDropdownActive) {
            dropdown.classList.remove('active');
          } else if (inlineSearchInput.value) {
            this.clearInlineSearch();
          }
          inlineSearchInput.blur();
          return;
        }

        if (isDropdownActive) {
          if (e.key === 'ArrowDown') {
            e.preventDefault();
            this.navigateSearchResults(1);
          } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            this.navigateSearchResults(-1);
          } else if (e.key === 'Enter') {
            e.preventDefault();
            const selected = dropdown.querySelector('.ur-kb-search-result.selected');
            if (selected) this.selectSearchResult(selected);
          }
        }
      });

      // Keyboard support for page title (Enter/Space to go home)
      const pageTitle = kb.querySelector('.ur-kb-page-title');
      if (pageTitle) {
        pageTitle.addEventListener('keydown', (e) => {
          if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            this.showHome();
          }
        });
      }

      // Keyboard shortcuts
      document.addEventListener('keydown', (e) => {
        // Don't trigger shortcuts when typing in input fields
        const isTyping = e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA';

        if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
          e.preventDefault();
          inlineSearchInput.focus();
          inlineSearchInput.select();
          return;
        }

        if (e.key === 'Escape' && !isTyping) {
          // Close modals in order of priority
          if (kb.querySelector('.ur-kb-lightbox.active')) {
            this.closeLightbox();
          } else if (kb.querySelector('.ur-kb-shortcuts-modal.active')) {
            this.closeShortcutsModal();
          } else if (kb.querySelector('.ur-kb-search-indicator.active')) {
            this.clearSearchHighlights();
          }
          return;
        }

        // Global shortcuts (when not typing)
        if (!isTyping) {
          // ? - Show keyboard shortcuts
          if (e.key === '?' || (e.shiftKey && e.key === '/')) {
            e.preventDefault();
            this.openShortcutsModal();
            return;
          }

          // H - Go home
          if (e.key === 'h' || e.key === 'H') {
            e.preventDefault();
            this.showHome();
            return;
          }

          // Arrow keys - Navigate sections
          if (e.key === 'ArrowLeft' && this.currentSection) {
            e.preventDefault();
            this.navigateSection('prev');
            return;
          }

          if (e.key === 'ArrowRight' && this.currentSection) {
            e.preventDefault();
            this.navigateSection('next');
            return;
          }
        }
      });

      // Scroll listener for section indicator and scroll-to-top button
      const content = kb.querySelector('.ur-kb-content');
      content.addEventListener('scroll', debounce(() => {
        this.updateScrollIndicator();
        this.updateScrollTopButton();
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

      const html = [];

      // Add all items (document name and sections)
      items.forEach((item, index) => {
        // Add separator before each item except the first
        if (index > 0) {
          html.push(`<span class="ur-kb-breadcrumb-sep">/</span>`);
        }
        const currentClass = item.isCurrent ? ' current' : '';
        html.push(`<span class="ur-kb-breadcrumb-item${currentClass}" data-doc-id="${item.docId || ''}" data-section-id="${item.sectionId || ''}">${escapeHtml(item.label)}</span>`);
      });

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
      const readingTime = this.calculateReadingTime(doc.content);

      content.innerHTML = `
        <div class="ur-kb-content-header">
          <h1 class="ur-kb-content-title">${escapeHtml(doc.title)}</h1>
          <div class="ur-kb-content-meta">
            <span class="ur-kb-reading-time" title="Estimated reading time">
              ${ICONS.clock}
              <span>${readingTime}</span>
            </span>
          </div>
        </div>
        <div class="ur-kb-markdown">
          ${html}
        </div>
      `;

      content.querySelectorAll('pre code').forEach(block => {
        if (typeof hljs !== 'undefined') hljs.highlightElement(block);
      });

      // Add copy buttons to code blocks
      this.addCopyButtons();

      // Scroll to top (anchor link clicks handled via event delegation in setupEventListeners)
      content.scrollTop = 0;
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
      const readingTime = this.calculateReadingTime(sectionContent);

      content.innerHTML = `
        <div class="ur-kb-content-header">
          <h1 class="ur-kb-content-title">${escapeHtml(section.text)}</h1>
          <div class="ur-kb-content-meta">
            <span class="ur-kb-reading-time" title="Estimated reading time">
              ${ICONS.clock}
              <span>${readingTime}</span>
            </span>
            ${this.options.enablePdfExport ? `
              <button class="ur-kb-pdf-btn" title="Download this section as PDF">
                ${ICONS.download}
                <span>PDF</span>
              </button>
            ` : ''}
          </div>
        </div>
        <div class="ur-kb-markdown" id="ur-kb-print-content">
          ${html}
        </div>
      `;

      content.querySelectorAll('pre code').forEach(block => {
        if (typeof hljs !== 'undefined') hljs.highlightElement(block);
      });

      // Add copy buttons to code blocks
      this.addCopyButtons();

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
          return `<div class="ur-kb-video-container"><iframe src="https://www.youtube.com/embed/${youtubeMatch[1]}" allowfullscreen></iframe></div>`;
        }
        if (/\.(mp4|webm|ogg)$/i.test(href)) {
          return `<div class="ur-kb-video-container"><video controls><source src="${escapeHtml(href)}" type="video/${href.split('.').pop()}"></video></div>`;
        }
        return `<div class="ur-kb-image-container"><img src="${escapeHtml(href)}" alt="${escapeHtml(text)}" title="${escapeHtml(title || '')}"></div>`;
      };

      renderer.link = (href, title, text) => {
        const isExternal = href.startsWith('http://') || href.startsWith('https://');

        // Check if this is a standalone link (text is the URL or very similar)
        // This indicates the user wants rich preview, not inline link
        const isStandalone = text === href ||
                            text.replace(/^https?:\/\//, '') === href.replace(/^https?:\/\//, '') ||
                            href.includes(text.replace(/^https?:\/\//, '').replace(/\/$/, ''));

        if (isExternal && isStandalone) {
          // YouTube video - embed player
          const youtubeMatch = href.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([\w-]+)/);
          if (youtubeMatch) {
            return `<div class="ur-kb-video-container"><iframe src="https://www.youtube.com/embed/${youtubeMatch[1]}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>`;
          }

          // Vimeo video - embed player
          const vimeoMatch = href.match(/vimeo\.com\/(\d+)/);
          if (vimeoMatch) {
            return `<div class="ur-kb-video-container"><iframe src="https://player.vimeo.com/video/${vimeoMatch[1]}" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe></div>`;
          }

          // videos.448.global video platform - embed player
          const globalVideoMatch = href.match(/videos\.448\.global\/w\/([\w-]+)/);
          if (globalVideoMatch) {
            return `<div class="ur-kb-video-container"><iframe src="https://videos.448.global/videos/embed/${globalVideoMatch[1]}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>`;
          }

          // Direct video file
          if (/\.(mp4|webm|ogg|mov)(\?.*)?$/i.test(href)) {
            const ext = href.match(/\.(mp4|webm|ogg|mov)/i)[1];
            return `<div class="ur-kb-video-container"><video controls><source src="${escapeHtml(href)}" type="video/${ext.toLowerCase()}">Your browser does not support the video tag.</video></div>`;
          }

          // Direct image URL (including Google Images)
          if (/\.(jpg|jpeg|png|gif|webp|svg|bmp)(\?.*)?$/i.test(href) ||
              href.includes('imgurl=') ||
              href.includes('/imgres?')) {
            // Extract actual image URL from Google Images link
            let imageUrl = href;
            const imgUrlMatch = href.match(/imgurl=([^&]+)/);
            if (imgUrlMatch) {
              imageUrl = decodeURIComponent(imgUrlMatch[1]);
            }
            return `<div class="ur-kb-image-container"><img src="${escapeHtml(imageUrl)}" alt="Image" loading="lazy"></div>`;
          }

          // Regular website link - show as preview card with async title fetch
          const domain = new URL(href).hostname.replace('www.', '');
          const linkId = 'link-' + Math.random().toString(36).slice(2, 11);
          const linkIcon = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path><polyline points="15 3 21 3 21 9"></polyline><line x1="10" y1="14" x2="21" y2="3"></line></svg>';

          // Queue async title fetch
          setTimeout(() => this.fetchLinkTitle(linkId, href), 0);

          return `<a href="${escapeHtml(href)}" target="_blank" rel="noopener noreferrer" class="ur-kb-link-preview" id="${linkId}"><span class="ur-kb-link-preview-title">${linkIcon}<span class="ur-kb-link-title-text">${escapeHtml(title || domain)}</span></span><span class="ur-kb-link-preview-url">${escapeHtml(href)}</span></a>`;
        }

        // Inline link within text - render as normal link
        const target = isExternal ? ' target="_blank" rel="noopener noreferrer"' : '';
        return `<a href="${escapeHtml(href)}" title="${escapeHtml(title || '')}"${target}>${text}</a>`;
      };

      // Skip headers - they're rendered separately
      renderer.heading = () => '';

      return marked.parse(content, { renderer });
    }

    async fetchLinkTitle(linkId, url) {
      try {
        // Use a CORS proxy or direct fetch (may fail due to CORS)
        const proxyUrl = `https://api.allorigins.win/raw?url=${encodeURIComponent(url)}`;
        const response = await fetch(proxyUrl, {
          signal: AbortSignal.timeout(5000) // 5 second timeout
        });

        if (!response.ok) return;

        const html = await response.text();

        // Extract title from HTML
        const titleMatch = html.match(/<title[^>]*>([^<]+)<\/title>/i);
        if (titleMatch && titleMatch[1]) {
          // Decode HTML entities using textarea trick
          const textarea = document.createElement('textarea');
          textarea.innerHTML = titleMatch[1].trim();
          const title = textarea.value;

          const linkEl = document.getElementById(linkId);
          if (linkEl) {
            const titleSpan = linkEl.querySelector('.ur-kb-link-title-text');
            if (titleSpan && title) {
              titleSpan.textContent = title;
            }
          }
        }
      } catch (e) {
        // Silently fail - keep showing domain name
      }
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

    // ============================================================
    // Quick Win Features
    // ============================================================

    // Copy Code Button
    copyCode(btn) {
      const wrapper = btn.closest('.ur-kb-code-wrapper');
      const code = wrapper.querySelector('code');
      const text = code.textContent;

      navigator.clipboard.writeText(text).then(() => {
        btn.classList.add('copied');
        btn.innerHTML = `${ICONS.check}<span>Copied!</span>`;

        setTimeout(() => {
          btn.classList.remove('copied');
          btn.innerHTML = `${ICONS.copy}<span>Copy</span>`;
        }, 2000);
      }).catch(err => {
        console.error('Failed to copy:', err);
      });
    }

    // Scroll to Top
    updateScrollTopButton() {
      const content = this.container.querySelector('.ur-kb-content');
      const scrollTopBtn = this.container.querySelector('.ur-kb-scroll-top');

      if (scrollTopBtn) {
        const shouldShow = content.scrollTop > 300;
        scrollTopBtn.classList.toggle('visible', shouldShow);
      }
    }

    scrollToTop() {
      const content = this.container.querySelector('.ur-kb-content');
      content.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // Image Lightbox
    openLightbox(src) {
      const lightbox = this.container.querySelector('.ur-kb-lightbox');
      const img = lightbox.querySelector('img');
      img.src = src;
      lightbox.classList.add('active');
      document.body.style.overflow = 'hidden';
    }

    closeLightbox() {
      const lightbox = this.container.querySelector('.ur-kb-lightbox');
      lightbox.classList.remove('active');
      document.body.style.overflow = '';
    }

    // Keyboard Shortcuts Modal
    openShortcutsModal() {
      const modal = this.container.querySelector('.ur-kb-shortcuts-modal');
      modal.classList.add('active');
    }

    closeShortcutsModal() {
      const modal = this.container.querySelector('.ur-kb-shortcuts-modal');
      modal.classList.remove('active');
    }

    // Reading Time Calculator
    calculateReadingTime(text) {
      const wordsPerMinute = 200;
      const words = text.trim().split(/\s+/).length;
      const minutes = Math.ceil(words / wordsPerMinute);
      return minutes < 1 ? '< 1 min read' : `${minutes} min read`;
    }

    // Add copy buttons to code blocks after rendering
    addCopyButtons() {
      const codeBlocks = this.container.querySelectorAll('.ur-kb-markdown pre');
      codeBlocks.forEach(pre => {
        // Skip if already wrapped
        if (pre.parentElement.classList.contains('ur-kb-code-wrapper')) return;

        const wrapper = document.createElement('div');
        wrapper.className = 'ur-kb-code-wrapper';
        pre.parentNode.insertBefore(wrapper, pre);
        wrapper.appendChild(pre);

        const btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'ur-kb-copy-btn';
        btn.innerHTML = `${ICONS.copy}<span>Copy</span>`;
        btn.setAttribute('aria-label', 'Copy code');
        wrapper.appendChild(btn);
      });
    }

    // Highlight search terms in content
    highlightSearchTerms(query) {
      if (!query || query.length < 2) return;

      const content = this.container.querySelector('.ur-kb-markdown');
      if (!content) return;

      // Remove existing highlights
      this.removeSearchHighlights();

      // Store current search query
      this.currentSearchQuery = query;
      this.currentHighlightIndex = 0;

      // Create regex for search terms
      const terms = query.split(/\s+/).filter(t => t.length >= 2);
      if (terms.length === 0) return;

      const regex = new RegExp(`(${terms.map(t => t.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('|')})`, 'gi');

      // Walk through text nodes and highlight matches
      const walker = document.createTreeWalker(content, NodeFilter.SHOW_TEXT, null, false);
      const textNodes = [];
      while (walker.nextNode()) {
        if (walker.currentNode.textContent.match(regex)) {
          textNodes.push(walker.currentNode);
        }
      }

      textNodes.forEach(node => {
        const span = document.createElement('span');
        span.innerHTML = node.textContent.replace(regex, '<mark class="ur-kb-search-highlight">$1</mark>');
        node.parentNode.replaceChild(span, node);
      });

      // Show search indicator bar
      this.showSearchIndicator(query);
    }

    showSearchIndicator(query) {
      const highlights = this.container.querySelectorAll('.ur-kb-search-highlight');
      const count = highlights.length;

      if (count === 0) {
        this.hideSearchIndicator();
        return;
      }

      let indicator = this.container.querySelector('.ur-kb-search-indicator');

      // Create indicator if it doesn't exist
      if (!indicator) {
        indicator = document.createElement('div');
        indicator.className = 'ur-kb-search-indicator';
        const contentArea = this.container.querySelector('.ur-kb-content');
        contentArea.insertBefore(indicator, contentArea.firstChild);
      }

      indicator.innerHTML = `
        <div class="ur-kb-search-indicator-info">
          ${ICONS.search}
          <span>Showing results for</span>
          <span class="ur-kb-search-indicator-term">${escapeHtml(query)}</span>
          <span class="ur-kb-search-indicator-count">(${count} match${count !== 1 ? 'es' : ''})</span>
        </div>
        <div class="ur-kb-search-indicator-actions">
          <button class="ur-kb-search-indicator-nav" data-direction="-1" title="Previous match">
            ${ICONS.chevronLeft}
            <span>Prev</span>
          </button>
          <button class="ur-kb-search-indicator-nav" data-direction="1" title="Next match">
            <span>Next</span>
            ${ICONS.chevronRight}
          </button>
          <button class="ur-kb-search-indicator-clear" title="Clear highlights">
            Clear
          </button>
        </div>
      `;

      indicator.classList.add('active');

      // Scroll to first highlight
      if (highlights.length > 0) {
        this.scrollToHighlight(0);
      }
    }

    hideSearchIndicator() {
      const indicator = this.container.querySelector('.ur-kb-search-indicator');
      if (indicator) {
        indicator.classList.remove('active');
      }
      this.currentSearchQuery = null;
      this.currentHighlightIndex = 0;
    }

    scrollToHighlight(index) {
      const highlights = this.container.querySelectorAll('.ur-kb-search-highlight');
      if (highlights.length === 0) return;

      // Wrap around
      if (index < 0) index = highlights.length - 1;
      if (index >= highlights.length) index = 0;

      this.currentHighlightIndex = index;

      // Remove current highlight styling from all
      highlights.forEach(h => h.classList.remove('current'));

      // Add current highlight styling
      const current = highlights[index];
      current.classList.add('current');

      // Scroll into view
      current.scrollIntoView({ behavior: 'smooth', block: 'center' });

      // Update counter in indicator
      const countEl = this.container.querySelector('.ur-kb-search-indicator-count');
      if (countEl) {
        countEl.textContent = `(${index + 1} of ${highlights.length})`;
      }
    }

    navigateHighlights(direction) {
      const newIndex = this.currentHighlightIndex + direction;
      this.scrollToHighlight(newIndex);
    }

    clearSearchHighlights() {
      this.removeSearchHighlights();
      this.hideSearchIndicator();
    }

    removeSearchHighlights() {
      const highlights = this.container.querySelectorAll('.ur-kb-search-highlight');
      highlights.forEach(mark => {
        const parent = mark.parentNode;
        parent.replaceChild(document.createTextNode(mark.textContent), mark);
        parent.normalize();
      });
    }

    // Inline Search Methods
    performInlineSearch(query) {
      const dropdown = this.container.querySelector('.ur-kb-inline-search-dropdown');

      if (!query || query.length < 2) {
        dropdown.innerHTML = '';
        dropdown.classList.remove('active');
        return;
      }

      const results = this.fuse.search(query, { limit: 8 });

      if (results.length === 0) {
        dropdown.innerHTML = `
          <div class="ur-kb-no-results">No results found for "${escapeHtml(query)}"</div>
        `;
        dropdown.classList.add('active');
        return;
      }

      dropdown.innerHTML = results.map((result, index) => {
        const item = result.item;
        let preview = item.content.substring(0, 120);
        const regex = new RegExp(`(${query.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')})`, 'gi');
        preview = escapeHtml(preview).replace(regex, '<mark>$1</mark>');

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

      dropdown.innerHTML += `
        <div class="ur-kb-search-hint">
          <span><kbd>↑↓</kbd> Navigate</span>
          <span><kbd>↵</kbd> Open</span>
          <span><kbd>ESC</kbd> Close</span>
        </div>
      `;

      dropdown.classList.add('active');
    }

    clearInlineSearch() {
      const input = this.container.querySelector('.ur-kb-inline-search-input');
      const dropdown = this.container.querySelector('.ur-kb-inline-search-dropdown');
      const clearBtn = this.container.querySelector('.ur-kb-inline-search-clear');

      input.value = '';
      dropdown.innerHTML = '';
      dropdown.classList.remove('active');
      clearBtn.style.display = 'none';

      this.clearSearchHighlights();
    }

    navigateSearchResults(direction) {
      const dropdown = this.container.querySelector('.ur-kb-inline-search-dropdown');
      const results = dropdown.querySelectorAll('.ur-kb-search-result');
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

      // Capture search query before closing dropdown
      const searchInput = this.container.querySelector('.ur-kb-inline-search-input');
      const searchQuery = searchInput?.value?.trim() || '';

      // Close dropdown but keep the search term in the input
      const dropdown = this.container.querySelector('.ur-kb-inline-search-dropdown');
      dropdown.classList.remove('active');

      if (sectionId) {
        this.selectSection(docId, sectionId);
      } else {
        this.selectDocument(docId);
      }

      // Highlight search terms after content renders
      if (searchQuery) {
        setTimeout(() => this.highlightSearchTerms(searchQuery), 100);
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

    // ============================================================
    // Accessibility Methods
    // ============================================================

    adjustZoom(direction) {
      const zoomLevels = [90, 100, 110, 125, 150];
      const currentIndex = zoomLevels.indexOf(this.zoomLevel);
      let newIndex;

      if (direction > 0) {
        // Zoom in
        newIndex = Math.min(currentIndex + 1, zoomLevels.length - 1);
      } else {
        // Zoom out
        newIndex = Math.max(currentIndex - 1, 0);
      }

      const newZoom = zoomLevels[newIndex];
      if (newZoom === this.zoomLevel) return;

      const kb = this.container.querySelector('.ur-kb');

      // Remove old zoom class
      kb.classList.remove(`zoom-${this.zoomLevel}`);

      // Apply new zoom
      this.zoomLevel = newZoom;
      kb.classList.add(`zoom-${this.zoomLevel}`);

      // Persist to localStorage
      localStorage.setItem('ur-kb-zoom', this.zoomLevel.toString());
    }

    toggleHighContrast() {
      const kb = this.container.querySelector('.ur-kb');
      const contrastBtn = this.container.querySelector('.ur-kb-contrast-btn');

      this.highContrast = !this.highContrast;

      kb.classList.toggle('high-contrast', this.highContrast);
      contrastBtn.classList.toggle('active', this.highContrast);

      // Persist to localStorage
      localStorage.setItem('ur-kb-contrast', this.highContrast.toString());
    }

    getEffectiveTheme() {
      if (this.currentTheme === 'auto') {
        // Check system preference
        return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
      }
      return this.currentTheme;
    }

    getThemeIcon() {
      switch (this.currentTheme) {
        case 'light': return ICONS.sun;
        case 'dark': return ICONS.moon;
        case 'auto': return ICONS.monitor;
        default: return ICONS.monitor;
      }
    }

    cycleTheme() {
      const kb = this.container.querySelector('.ur-kb');
      const themeBtn = this.container.querySelector('.ur-kb-theme-btn');

      // Cycle: auto -> light -> dark -> auto
      const themes = ['auto', 'light', 'dark'];
      const currentIndex = themes.indexOf(this.currentTheme);
      this.currentTheme = themes[(currentIndex + 1) % themes.length];

      // Apply theme
      const effectiveTheme = this.getEffectiveTheme();
      kb.classList.toggle('dark', effectiveTheme === 'dark');

      // Update button
      themeBtn.innerHTML = this.getThemeIcon();
      themeBtn.setAttribute('title', `Theme: ${this.currentTheme}`);

      // Persist to localStorage
      localStorage.setItem('ur-kb-theme', this.currentTheme);
    }

    toggleTTS() {
      const ttsBtn = this.container.querySelector('.ur-kb-tts-btn');

      if (this.ttsActive) {
        // Stop speaking
        this.stopTTS();
      } else {
        // Start speaking
        const content = this.container.querySelector('.ur-kb-content');
        if (!content) return;

        // Get text content from the main content area
        const textContent = this.getReadableText(content);
        if (!textContent) return;

        // Use OpenAI TTS if API key is provided, otherwise fall back to browser TTS
        if (this.options.ttsApiKey) {
          this.speakWithOpenAI(textContent, ttsBtn);
        } else {
          this.speakWithBrowser(textContent, ttsBtn);
        }
      }
    }

    stopTTS() {
      const ttsBtn = this.container.querySelector('.ur-kb-tts-btn');

      // Stop OpenAI TTS audio
      if (this.ttsAudio) {
        this.ttsAudio.pause();
        this.ttsAudio.currentTime = 0;
        this.ttsAudio = null;
      }

      // Stop browser TTS
      if (this.speechSynthesis) {
        this.speechSynthesis.cancel();
      }

      this.ttsActive = false;
      if (ttsBtn) {
        ttsBtn.classList.remove('speaking');
        ttsBtn.innerHTML = ICONS.speaker;
        ttsBtn.setAttribute('title', 'Read aloud');
        ttsBtn.setAttribute('aria-label', 'Read aloud');
      }
    }

    async speakWithOpenAI(text, ttsBtn) {
      // Limit text length for API (OpenAI has a 4096 character limit per request)
      const maxLength = 4000;
      const truncatedText = text.length > maxLength ? text.substring(0, maxLength) + '...' : text;

      try {
        // Show loading state
        this.ttsActive = true;
        ttsBtn.classList.add('speaking');
        ttsBtn.innerHTML = ICONS.speakerOff;
        ttsBtn.setAttribute('title', 'Stop reading');
        ttsBtn.setAttribute('aria-label', 'Stop reading');

        const response = await fetch('https://api.openai.com/v1/audio/speech', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${this.options.ttsApiKey}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            model: this.options.ttsModel,
            input: truncatedText,
            voice: this.options.ttsVoice,
            response_format: 'mp3'
          })
        });

        if (!response.ok) {
          const error = await response.json().catch(() => ({}));
          console.warn('OpenAI TTS failed, falling back to browser TTS:', error);
          this.stopTTS();
          this.speakWithBrowser(text, ttsBtn);
          return;
        }

        // Create audio from response
        const audioBlob = await response.blob();
        const audioUrl = URL.createObjectURL(audioBlob);

        this.ttsAudio = new Audio(audioUrl);

        this.ttsAudio.onended = () => {
          URL.revokeObjectURL(audioUrl);
          this.stopTTS();
        };

        this.ttsAudio.onerror = () => {
          URL.revokeObjectURL(audioUrl);
          console.warn('Audio playback failed, falling back to browser TTS');
          this.stopTTS();
          this.speakWithBrowser(text, ttsBtn);
        };

        await this.ttsAudio.play();

      } catch (error) {
        console.warn('OpenAI TTS error, falling back to browser TTS:', error);
        this.stopTTS();
        this.speakWithBrowser(text, ttsBtn);
      }
    }

    speakWithBrowser(text, ttsBtn) {
      if (!this.speechSynthesis) {
        console.warn('Text-to-Speech is not supported in this browser');
        return;
      }

      // Create utterance
      this.currentUtterance = new SpeechSynthesisUtterance(text);

      // Try to get a natural sounding voice
      const voices = this.speechSynthesis.getVoices();
      const preferredVoice = voices.find(v =>
        v.lang.startsWith('en') && (v.name.includes('Natural') || v.name.includes('Premium') || v.name.includes('Enhanced'))
      ) || voices.find(v => v.lang.startsWith('en') && v.localService)
        || voices.find(v => v.lang.startsWith('en'));

      if (preferredVoice) {
        this.currentUtterance.voice = preferredVoice;
      }

      this.currentUtterance.rate = 0.9; // Slightly slower for clarity
      this.currentUtterance.pitch = 1;

      this.currentUtterance.onend = () => {
        this.stopTTS();
      };

      this.currentUtterance.onerror = () => {
        this.stopTTS();
      };

      this.speechSynthesis.speak(this.currentUtterance);
      this.ttsActive = true;
      ttsBtn.classList.add('speaking');
      ttsBtn.innerHTML = ICONS.speakerOff;
      ttsBtn.setAttribute('title', 'Stop reading');
      ttsBtn.setAttribute('aria-label', 'Stop reading');
    }

    getReadableText(element) {
      // Clone the element to avoid modifying the original
      const clone = element.cloneNode(true);

      // Remove elements that shouldn't be read
      const removeSelectors = [
        'script', 'style', 'nav', 'button', '.ur-kb-pdf-btn',
        '.ur-kb-section-pdf-btn', 'code', 'pre'
      ];
      removeSelectors.forEach(sel => {
        clone.querySelectorAll(sel).forEach(el => el.remove());
      });

      // Get text content
      let text = clone.textContent || '';

      // Clean up whitespace
      text = text.replace(/\s+/g, ' ').trim();

      return text;
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
