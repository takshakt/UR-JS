# Knowledge Base Widget - Oracle APEX Implementation Guide

**Version:** 4.0
**Last Updated:** 26 December 2025
**Designed & Implemented By:** Vishnu Kant (Project EIDOS)

---

## Table of Contents

1. [Overview](#1-overview)
2. [Features](#2-features)
3. [Quick Start](#3-quick-start)
4. [Installation in Oracle APEX](#4-installation-in-oracle-apex)
5. [Configuration Parameters](#5-configuration-parameters)
6. [JavaScript API Reference](#6-javascript-api-reference)
7. [Markdown Content Guidelines](#7-markdown-content-guidelines)
8. [Theming and Customization](#8-theming-and-customization)
9. [Security Considerations](#9-security-considerations)
10. [Troubleshooting](#10-troubleshooting)
11. [Appendix A: Architecture Flow](#appendix-a-architecture-flow)
12. [Appendix B: Function Reference](#appendix-b-function-reference)
13. [Appendix C: CSS Variables](#appendix-c-css-variables)
14. [Appendix D: Future Enhancement Ideas](#appendix-d-future-enhancement-ideas)

---

## 1. Overview

The Knowledge Base (KB) Widget is a portable, self-contained JavaScript component that renders markdown documentation with a modern, responsive interface. It's designed specifically for Oracle APEX applications but can be used in any web application.

### Key Characteristics

- **Self-contained**: Single JS file with embedded CSS and auto-loaded CDN dependencies
- **Zero server-side dependencies**: Works entirely client-side
- **Responsive design**: Mobile-friendly with collapsible sidebar
- **Accessibility compliant**: WCAG 2.1 AA compliant with zoom, TTS, and high contrast modes
- **PDF export**: Professional PDF generation with cover pages and watermarks

---

## 2. Features

### Core Features

| Feature | Description |
|---------|-------------|
| Markdown Rendering | Full GFM (GitHub Flavored Markdown) support with syntax highlighting |
| Sidebar Navigation | Hierarchical document and section navigation |
| Inline Search | Live fuzzy search with dropdown results and content highlighting |
| PDF Export | Export individual sections or entire documents with branding |
| Breadcrumb Navigation | Visual path indicator with clickable navigation |
| Prev/Next Navigation | Sequential navigation through document sections |

### Accessibility Features

| Feature | Description |
|---------|-------------|
| Text Zoom | Adjustable font size (A-/A+) persisted in localStorage |
| Text-to-Speech | OpenAI TTS or browser-native speech synthesis |
| High Contrast | Enhanced contrast mode for visual accessibility |
| Theme Toggle | Auto/Light/Dark theme switching |
| Keyboard Navigation | Full keyboard support for search and navigation |

### Media Support

| Media Type | Support |
|------------|---------|
| YouTube | Auto-embedded player from URLs |
| Vimeo | Auto-embedded player from URLs |
| PeerTube | Support for videos.448.global and similar |
| Direct Video | MP4, WebM, OGG, MOV files |
| Images | JPG, PNG, GIF, WebP, SVG, BMP |
| External Links | Preview cards with domain display |

### Enhanced User Experience Features

| Feature | Description |
|---------|-------------|
| Copy Code Button | One-click copy for code blocks with visual feedback |
| Reading Time Estimate | Automatic reading time calculation for each section |
| Scroll-to-Top Button | Floating button appears after scrolling down |
| Image Lightbox | Click images to view in fullscreen overlay |
| Keyboard Shortcuts Help | Press `?` to view all available keyboard shortcuts |
| Search Highlighting | Search terms are highlighted in content when navigating from search results |

---

## 3. Quick Start

### Minimal Implementation

```html
<!-- Container -->
<div id="kb-container"></div>

<!-- Widget Script -->
<script src="https://your-server.com/kb-widget.js"></script>

<!-- Initialize -->
<script>
KnowledgeBase.init({
    container: '#kb-container',
    documents: [
        {
            id: 'guide',
            title: 'User Guide',
            url: '/docs/user-guide.md'
        }
    ]
});
</script>
```

---

## 4. Installation in Oracle APEX

### Step 1: Upload the Widget File

1. Navigate to **Shared Components** > **Static Application Files**
2. Click **Create File**
3. Upload `kb-widget.js`
4. Note the reference path: `#APP_FILES#kb-widget.js`

### Step 2: Upload Markdown Documents

1. Navigate to **Shared Components** > **Static Application Files**
2. Upload your markdown files (e.g., `user-guide.md`, `admin-guide.md`)
3. Note the reference paths

### Step 3: Create the APEX Page

1. Create a new **Blank Page**
2. Add a **Static Content** region
3. Set the region source to:

```html
<div id="kb-container" style="height: calc(100vh - 200px);"></div>
```

### Step 4: Add Page JavaScript

In **Page Properties** > **JavaScript** > **Execute when Page Loads**:

```javascript
KnowledgeBase.init({
    container: '#kb-container',

    // Documents
    documents: [
        {
            id: 'user-guide',
            title: 'User Guide',
            url: '&APP_FILES.user-guide.md'
        },
        {
            id: 'admin-guide',
            title: 'Administrator Guide',
            url: '&APP_FILES.admin-guide.md'
        }
    ],

    // Branding
    pageTitle: 'Help Center',
    pageSubtitle: 'Documentation and User Guides',
    organizationName: 'Your Company',
    applicationName: 'Your Application',

    // Features
    enableSearch: true,
    enablePdfExport: true,
    enableAccessibility: true,

    // Theme
    theme: 'auto'
});
```

### Step 5: Include the Widget Script

In **Page Properties** > **JavaScript** > **File URLs**:

```
#APP_FILES#kb-widget.js
```

### Step 6: Optional - Dynamic User Info for PDF

To include user information in PDF exports, add a **Before Header** process:

```sql
BEGIN
    :P_USER_NAME := APEX_UTIL.GET_FIRST_NAME || ' ' || APEX_UTIL.GET_LAST_NAME;
    :P_USER_EMAIL := APEX_UTIL.GET_EMAIL;
END;
```

Then update the JavaScript initialization:

```javascript
KnowledgeBase.init({
    // ... other options ...
    pdfUserName: '&P_USER_NAME.',
    pdfUserEmail: '&P_USER_EMAIL.'
});
```

---

## 5. Configuration Parameters

### Container and Documents

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `container` | String | `'#kb-container'` | CSS selector for the container element |
| `documents` | Array | `[]` | Array of document objects (see below) |
| `defaultDocument` | String | `null` | ID of document to show on load |
| `sidebarTitle` | String | `'KB Documents'` | Title shown in sidebar header |

#### Document Object Structure

```javascript
{
    id: 'unique-id',        // Required: Unique identifier
    title: 'Document Title', // Required: Display title
    url: '/path/to/file.md' // Required: URL to markdown file
}
```

### Page Header Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `pageTitle` | String | `''` | Main title in header. If empty, uses `{organizationName} - Knowledge Base` |
| `pageSubtitle` | String | `''` | Subtitle shown below main title |

### Theme Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `theme` | String | `'auto'` | Theme mode: `'auto'`, `'light'`, or `'dark'` |

### Feature Toggles

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enableSearch` | Boolean | `true` | Enable/disable search functionality |
| `enablePdfExport` | Boolean | `true` | Enable/disable PDF export buttons |
| `enableAccessibility` | Boolean | `true` | Show/hide accessibility toolbar |

### PDF Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `organizationName` | String | `'Organization'` | Company name on PDF cover |
| `applicationName` | String | `'Knowledge Base'` | Application name on PDF cover |
| `pdfAuthor` | String | `'System Generated'` | PDF metadata author field |
| `pdfConfidentialMessage` | String | `'HIGHLY CONFIDENTIAL...'` | Watermark message on PDF pages |
| `pdfUserName` | String | `''` | User name for PDF download tracking |
| `pdfUserEmail` | String | `''` | User email for PDF download tracking |

### Accessibility / TTS Configuration

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `ttsApiKey` | String | `''` | OpenAI API key for natural TTS. **See Security section** |
| `ttsVoice` | String | `'alloy'` | OpenAI voice: `alloy`, `echo`, `fable`, `onyx`, `nova`, `shimmer` |
| `ttsModel` | String | `'tts-1'` | OpenAI model: `tts-1` (faster) or `tts-1-hd` (higher quality) |

---

## 6. JavaScript API Reference

### Initialization

```javascript
// Initialize the widget
const kb = KnowledgeBase.init(options);

// The widget is also available globally after init
// window.KnowledgeBase.instance
```

### Public Methods

After initialization, the instance exposes several methods. Access via the returned instance or `window.KnowledgeBase.instance`:

#### Navigation Methods

```javascript
// Show the home page (document list)
kb.showHome();

// Select a specific document
kb.selectDocument('document-id');

// Select a specific section within a document
kb.selectSection('document-id', 'section-id');

// Navigate to previous/next section
kb.navigateSection('prev');
kb.navigateSection('next');
```

#### Search Methods

```javascript
// Perform inline search (populates dropdown and highlights in content)
kb.performInlineSearch('search query');

// Clear search input, dropdown, and highlights
kb.clearInlineSearch();

// Highlight search terms in current content
kb.highlightSearchTerms('query');

// Clear search highlights from content
kb.clearSearchHighlights();

// Focus the search input programmatically
document.querySelector('.ur-kb-inline-search-input').focus();
```

#### Export Methods

```javascript
// Export current section as PDF
kb.exportPDF();

// Export specific section as PDF
kb.exportSectionPDF('section-id');
```

#### Accessibility Methods

```javascript
// Adjust zoom level (-1 to decrease, +1 to increase)
kb.adjustZoom(1);   // Zoom in
kb.adjustZoom(-1);  // Zoom out

// Toggle high contrast mode
kb.toggleHighContrast();

// Cycle through themes (auto -> light -> dark -> auto)
kb.cycleTheme();

// Toggle text-to-speech
kb.toggleTTS();

// Stop TTS playback
kb.stopTTS();
```

#### Sidebar Methods

```javascript
// Toggle sidebar visibility
kb.toggleSidebar();

// Explicitly collapse or expand
kb.toggleSidebar(true);  // Collapse
kb.toggleSidebar(false); // Expand
```

### Event Integration Examples

#### Open KB to Specific Section from Button

```javascript
// APEX Dynamic Action - Execute JavaScript Code
KnowledgeBase.instance.selectSection('user-guide', 'getting-started');
```

#### Search from External Input

```javascript
// Link external search box to KB inline search
document.getElementById('external-search').addEventListener('keyup', function(e) {
    const kb = KnowledgeBase.instance;
    const searchInput = kb.container.querySelector('.ur-kb-inline-search-input');
    searchInput.value = this.value;
    kb.performInlineSearch(this.value);
    if (this.value.length >= 2) {
        kb.highlightSearchTerms(this.value);
    }
});
```

#### Listen for Section Changes

```javascript
// The widget doesn't emit events, but you can poll or wrap methods
const originalSelect = KnowledgeBase.instance.selectSection.bind(KnowledgeBase.instance);
KnowledgeBase.instance.selectSection = function(docId, sectionId) {
    originalSelect(docId, sectionId);
    console.log('Section changed:', docId, sectionId);
    // Custom analytics, etc.
};
```

---

## 7. Markdown Content Guidelines

### Document Structure

Documents should use hierarchical headers for proper navigation:

```markdown
# Document Title (Level 1 - Document root)

## Section 1 (Level 2 - Main sections)

### Subsection 1.1 (Level 3 - Subsections)

#### Detail 1.1.1 (Level 4 - Details)

## Section 2

### Subsection 2.1
```

### Supported Markdown Features

| Feature | Syntax | Notes |
|---------|--------|-------|
| Headers | `# ## ### ####` | Up to 6 levels |
| Bold | `**text**` | |
| Italic | `*text*` | |
| Links | `[text](url)` | External links open in new tab |
| Images | `![alt](url)` | Auto-wrapped in container |
| Code inline | `` `code` `` | Syntax highlighted |
| Code blocks | ` ```language ` | With language hint |
| Tables | GFM tables | Full support |
| Lists | `- item` or `1. item` | Nested supported |
| Blockquotes | `> quote` | |
| Horizontal rules | `---` | |

### Embedding Media

#### YouTube Videos

```markdown
<!-- As link (standalone on its own line) -->
https://www.youtube.com/watch?v=VIDEO_ID

<!-- As image syntax (also works) -->
![Video](https://www.youtube.com/watch?v=VIDEO_ID)
```

#### Vimeo Videos

```markdown
https://vimeo.com/VIDEO_ID
```

#### Direct Video Files

```markdown
https://example.com/video.mp4
```

#### Images

```markdown
![Alt text](https://example.com/image.jpg)

<!-- Google Images links are also supported -->
https://www.google.com/imgres?imgurl=...
```

### Table of Contents

The widget auto-generates navigation from headers. You can also create manual TOC:

```markdown
## Table of Contents

1. [Section One](#section-one)
2. [Section Two](#section-two)
3. [Section Three](#section-three)

## Section One
Content...

## Section Two
Content...
```

---

## 8. Theming and Customization

### Theme Modes

| Mode | Description |
|------|-------------|
| `auto` | Follows system preference via `prefers-color-scheme` |
| `light` | Forces light theme |
| `dark` | Forces dark theme |

### CSS Variable Overrides

You can override CSS variables to customize colors:

```css
/* Add to your APEX page CSS or theme */
.ur-kb {
    --kb-accent: #your-brand-color;
    --kb-accent-hover: #your-brand-color-dark;
    --kb-sidebar-active: #your-highlight-color;
}

.ur-kb.dark {
    --kb-accent: #your-brand-color-light;
}
```

### Container Sizing

The widget fills its container. Control size via container styles:

```html
<!-- Fixed height -->
<div id="kb-container" style="height: 600px;"></div>

<!-- Viewport-based (recommended) -->
<div id="kb-container" style="height: calc(100vh - 200px);"></div>

<!-- Full page -->
<div id="kb-container" style="height: 100vh;"></div>
```

### Hiding Elements

```css
/* Hide PDF export buttons */
.ur-kb-pdf-btn { display: none !important; }

/* Hide accessibility toolbar */
.ur-kb-a11y-toolbar { display: none !important; }

/* Hide inline search */
.ur-kb-inline-search { display: none !important; }
```

---

## 9. Security Considerations

### Risk Assessment

| Risk | Severity | Description |
|------|----------|-------------|
| API Key Exposure | **HIGH** | OpenAI API key visible in browser |
| Source Code Access | LOW | JavaScript is client-side (normal) |
| Document Content | MEDIUM | All markdown content accessible |
| XSS via Markdown | LOW | Content is escaped by marked.js |

### API Key Exposure (CRITICAL)

**Problem:** If you use `ttsApiKey`, the OpenAI API key is exposed:

1. Visible in browser DevTools console: `KnowledgeBase.instance.options.ttsApiKey`
2. Visible in Network tab when TTS requests are made
3. Can be extracted and misused for unauthorized API calls

**Mitigation Options:**

#### Option 1: Don't Use OpenAI TTS (Safest)

Leave `ttsApiKey` empty. The widget falls back to browser's native speech synthesis:

```javascript
KnowledgeBase.init({
    // ttsApiKey: '',  // Don't set this - uses browser TTS
    enableAccessibility: true
});
```

#### Option 2: Server-Side Proxy (Recommended if TTS needed)

Create an APEX REST endpoint that proxies to OpenAI:

```sql
-- Create REST Handler in APEX
-- POST /api/tts
DECLARE
    l_response CLOB;
BEGIN
    -- Call OpenAI from server (API key stored securely)
    apex_web_service.set_request_headers(
        p_name_01  => 'Authorization',
        p_value_01 => 'Bearer ' || get_secure_api_key(), -- From secure storage
        p_name_02  => 'Content-Type',
        p_value_02 => 'application/json'
    );

    l_response := apex_web_service.make_rest_request(
        p_url         => 'https://api.openai.com/v1/audio/speech',
        p_http_method => 'POST',
        p_body        => :body
    );

    -- Return audio to client
    :response := l_response;
END;
```

Then modify widget initialization to use your proxy (requires widget modification).

#### Option 3: Restricted API Key (Accept Risk)

1. Create a dedicated OpenAI API key
2. Set strict spending limits ($5-10/month)
3. Monitor usage in OpenAI dashboard
4. Accept that key may be abused

### Document Content Protection

All markdown content is loaded client-side and can be:
- Viewed in DevTools Network tab
- Copied from the rendered page
- Extracted via JavaScript console

**If content is sensitive:**
- Implement server-side access controls
- Don't put truly confidential info in KB
- Consider PDF-only distribution for sensitive docs

### Preventing Code Inspection

You **cannot** prevent determined users from viewing client-side code. However, you can:
- Minify/obfuscate the JS file (limited protection)
- Implement server-side authentication for document access
- Use APEX authorization schemes to control page access

---

## 10. Troubleshooting

### Common Issues

#### Widget Not Loading

**Symptoms:** Container is empty or shows loading indefinitely

**Solutions:**
1. Check browser console for errors
2. Verify `kb-widget.js` path is correct
3. Ensure container element exists before init
4. Check CORS if documents are on different domain

#### Documents Not Found (404)

**Symptoms:** "Failed to load document" error

**Solutions:**
1. Verify markdown file URLs are correct
2. Check file permissions in APEX Static Files
3. Use browser Network tab to see actual request URL
4. Ensure `.md` extension is included

#### Styling Issues

**Symptoms:** Widget looks broken or unstyled

**Solutions:**
1. Check for CSS conflicts with APEX theme
2. Ensure container has defined height
3. Try adding `!important` to custom overrides
4. Check if another library is overriding styles

#### Search Not Working

**Symptoms:** Search returns no results or crashes

**Solutions:**
1. Ensure documents loaded successfully first
2. Check console for Fuse.js errors
3. Verify content has searchable text (not just images)
4. Minimum 2 characters required to trigger search
5. Check that inline search dropdown is visible (CSS not hiding it)

#### PDF Export Fails

**Symptoms:** PDF button does nothing or errors

**Solutions:**
1. Check console for html2pdf errors
2. Ensure content doesn't have CORS images
3. Try with smaller content first
4. Check if popup blockers are interfering

#### TTS Not Working

**Symptoms:** Speaker button does nothing

**Solutions:**
1. If using OpenAI: Check API key and network
2. If using browser TTS: Check `window.speechSynthesis` support
3. Some browsers require user interaction first
4. Mobile Safari has limited TTS support

### Debug Mode

Add this to see internal state:

```javascript
// After init
console.log('KB Instance:', KnowledgeBase.instance);
console.log('Options:', KnowledgeBase.instance.options);
console.log('Documents:', KnowledgeBase.instance.documents);
console.log('Current Doc:', KnowledgeBase.instance.currentDoc);
console.log('Current Section:', KnowledgeBase.instance.currentSection);
```

---

## Appendix A: Architecture Flow

### Initialization Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    KnowledgeBase.init(options)                   │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    1. constructor(options)                       │
│    - Merge default options with provided options                 │
│    - Initialize state variables                                  │
│    - Load accessibility preferences from localStorage            │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                         2. init()                                │
│    - Get container element                                       │
│    - Show loading indicator                                      │
│    - Call injectStyles()                                         │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                   3. loadDependencies()                          │
│    - Load marked.js (markdown parser)                            │
│    - Load Fuse.js (fuzzy search)                                 │
│    - Load highlight.js (code syntax)                             │
│    - Load html2pdf.js (PDF generation)                           │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                  4. fetchAllDocuments()                          │
│    - Fetch each markdown file via URL                            │
│    - Parse content and extract headers                           │
│    - Build document objects with sections                        │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                  5. processDocuments()                           │
│    - Parse headers from content                                  │
│    - Build hierarchical section structure                        │
│    - Generate section IDs                                        │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                  6. buildFlatSections()                          │
│    - Create flat array of all sections                           │
│    - Used for prev/next navigation                               │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                  7. buildSearchIndex()                           │
│    - Index all documents and sections                            │
│    - Initialize Fuse.js with content                             │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      8. render()                                 │
│    - Build main HTML structure                                   │
│    - Inject into container                                       │
│    - Apply theme class                                           │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                 9. setupEventListeners()                         │
│    - Bind click handlers (delegation)                            │
│    - Bind keyboard shortcuts                                     │
│    - Bind scroll handlers                                        │
│    - Set up system theme listener                                │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│              10. showHome() or selectDocument()                  │
│    - Display home page with document cards                       │
│    - OR navigate to default document if specified                │
└─────────────────────────────────────────────────────────────────┘
```

### User Interaction Flow

```
┌──────────────────────────────────────────────────────────────────┐
│                      User Actions                                 │
└──────────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────┐     ┌─────────────────┐    ┌─────────────────┐
│ Click       │     │ Inline Search   │    │ Export PDF      │
│ Navigation  │     │ (Cmd+K)         │    │                 │
└─────────────┘     └─────────────────┘    └─────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────┐     ┌─────────────────┐    ┌─────────────────┐
│selectSection│     │performInline    │    │ exportPDF()     │
│    ()       │     │Search() + live  │    │ generatePDF()   │
│             │     │highlighting     │    │                 │
└─────────────┘     └─────────────────┘    └─────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────┐     ┌─────────────────┐    ┌─────────────────┐
│renderSection│     │ Dropdown shows  │    │ html2pdf        │
│Content()    │     │ results + terms │    │ renders to      │
│             │     │ highlighted     │    │ downloadable    │
└─────────────┘     └─────────────────┘    └─────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────┐     ┌─────────────────┐    ┌─────────────────┐
│Update:      │     │ User clicks     │    │ Browser         │
│- Breadcrumb │     │ result →        │    │ downloads       │
│- Sidebar    │     │ selectSection() │    │ PDF file        │
│- Footer nav │     │                 │    │                 │
└─────────────┘     └─────────────────┘    └─────────────────┘
```

### Component Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                         .ur-kb (Main Container)                  │
├─────────────────────────────────────────────────────────────────┤
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                  .ur-kb-page-header                        │  │
│  │  - Page title and subtitle                                 │  │
│  └───────────────────────────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                  .ur-kb-toolbar                            │  │
│  │  - Home button                                             │  │
│  │  - Inline search (.ur-kb-inline-search)                    │  │
│  │    - Search input with dropdown results                    │  │
│  │    - Live content highlighting as you type                 │  │
│  │  - Accessibility toolbar (A-, A+, TTS, Contrast, Theme)    │  │
│  └───────────────────────────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    .ur-kb-body                              ││
│  │  ┌──────────────┐  ┌────────────────────────────────────┐  ││
│  │  │.ur-kb-sidebar│  │         .ur-kb-main                │  ││
│  │  │              │  │  ┌──────────────────────────────┐  │  ││
│  │  │ - Sidebar    │  │  │    .ur-kb-breadcrumb         │  │  ││
│  │  │   title      │  │  └──────────────────────────────┘  │  ││
│  │  │ - Document   │  │  ┌──────────────────────────────┐  │  ││
│  │  │   list       │  │  │    .ur-kb-search-indicator   │  │  ││
│  │  │ - Section    │  │  │    (shows search term/nav)   │  │  ││
│  │  │   tree       │  │  └──────────────────────────────┘  │  ││
│  │  │              │  │  ┌──────────────────────────────┐  │  ││
│  │  │              │  │  │    .ur-kb-content            │  │  ││
│  │  │              │  │  │    (markdown rendered here)  │  │  ││
│  │  │              │  │  │                              │  │  ││
│  │  │              │  │  └──────────────────────────────┘  │  ││
│  │  │              │  │  ┌──────────────────────────────┐  │  ││
│  │  │              │  │  │    .ur-kb-footer             │  │  ││
│  │  │              │  │  │    (prev/next navigation)    │  │  ││
│  │  │              │  │  └──────────────────────────────┘  │  ││
│  │  └──────────────┘  └────────────────────────────────────┘  ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

---

## Appendix B: Function Reference

### Core Lifecycle Functions

| Function | Line | Description |
|----------|------|-------------|
| `constructor(options)` | 1440 | Initializes instance with merged options and default state |
| `async init()` | 1492 | Main initialization: loads deps, fetches docs, renders UI |
| `injectStyles()` | 1538 | Injects embedded CSS into document head |
| `showLoading()` | 1547 | Displays loading spinner in container |
| `async loadDependencies()` | 1558 | Dynamically loads CDN dependencies (marked, fuse, hljs, html2pdf) |

### Document Processing Functions

| Function | Line | Description |
|----------|------|-------------|
| `processDocuments()` | 1571 | Processes raw documents, parses headers, builds structure |
| `async fetchAllDocuments()` | 1584 | Fetches all markdown files via HTTP |
| `parseHeaders(content)` | 1600 | Extracts headers from markdown, builds hierarchical tree |
| `buildFlatSections()` | 1626 | Creates flat array of all sections for sequential navigation |
| `buildSearchIndex()` | 1648 | Builds Fuse.js search index from all content |

### Rendering Functions

| Function | Line | Description |
|----------|------|-------------|
| `render()` | 1696 | Renders main widget HTML structure |
| `renderDocumentList()` | 1756 | Renders home page with document cards |
| `renderSidebarSections(sections, docId)` | 1770 | Renders hierarchical sidebar navigation |
| `renderInlineSearch()` | 2104 | Renders inline search input with dropdown in toolbar |
| `renderDocumentContent(doc)` | 2320 | Renders full document content (all sections) |
| `renderSectionContent(doc, section)` | 2371 | Renders single section content |
| `renderMarkdownWithHeaders(content)` | 2417 | Renders markdown preserving headers for navigation |
| `renderMarkdownContent(content)` | 2457 | Core markdown rendering with custom renderers |

### Navigation Functions

| Function | Line | Description |
|----------|------|-------------|
| `showHome()` | 2101 | Displays home page with document list |
| `selectDocument(docId)` | 2139 | Selects and displays a document |
| `selectSection(docId, sectionId)` | 2166 | Navigates to specific section |
| `navigateSection(direction)` | 2306 | Moves to prev/next section |
| `findSectionByHash(doc, hash)` | 2341 | Finds section matching URL hash |
| `updateBreadcrumb(items)` | 2231 | Updates breadcrumb navigation display |
| `updateFooter(docId, sectionId)` | 2271 | Updates prev/next footer navigation |

### Search Functions

| Function | Line | Description |
|----------|------|-------------|
| `performInlineSearch(query)` | 3420 | Executes fuzzy search and populates dropdown results |
| `clearInlineSearch()` | 3479 | Clears search input, dropdown, and highlights |
| `navigateSearchResults(direction)` | 3492 | Keyboard navigation through search results |
| `selectSearchResult(resultEl)` | 3507 | Handles search result selection and navigation |
| `highlightSearchTerms(query)` | 3116 | Highlights search terms in rendered content |
| `clearSearchHighlights()` | 3200 | Removes all search term highlights |
| `navigateHighlights(direction)` | 3250 | Navigate between highlighted search terms |

### PDF Export Functions

| Function | Line | Description |
|----------|------|-------------|
| `async exportPDF()` | 2687 | Exports current section as PDF |
| `async exportSectionPDF(sectionId)` | 2724 | Exports specific section as PDF |
| `async generatePDF(content, title)` | 2927 | Core PDF generation with html2pdf |

### Accessibility Functions

| Function | Line | Description |
|----------|------|-------------|
| `adjustZoom(direction)` | 3087 | Adjusts font size (+1/-1), saves to localStorage |
| `toggleHighContrast()` | 3116 | Toggles high contrast mode |
| `getEffectiveTheme()` | 3129 | Returns actual theme considering 'auto' mode |
| `getThemeIcon()` | 3137 | Returns SVG icon for current theme |
| `cycleTheme()` | 3146 | Cycles through auto/light/dark themes |
| `toggleTTS()` | 3167 | Toggles text-to-speech on/off |
| `stopTTS()` | 3191 | Stops any active TTS playback |
| `async speakWithOpenAI(text, ttsBtn)` | 3215 | Uses OpenAI API for TTS |
| `speakWithBrowser(text, ttsBtn)` | 3277 | Uses Web Speech API for TTS |
| `getReadableText(element)` | 3316 | Extracts clean text for TTS from HTML |

### Utility Functions

| Function | Line | Description |
|----------|------|-------------|
| `setupEventListeners()` | 1808 | Binds all event handlers using delegation |
| `updateScrollIndicator()` | 2041 | Updates reading progress indicator |
| `hideScrollIndicator()` | 2093 | Hides the scroll progress indicator |
| `toggleSidebar(collapsed)` | 2580 | Toggles sidebar visibility |
| `extractSectionContent(content, section, skipHeader)` | 2400 | Extracts markdown content for a section |
| `async fetchLinkTitle(linkId, url)` | 2547 | Fetches page title for link preview cards |

### Enhanced UX Functions

| Function | Line | Description |
|----------|------|-------------|
| `copyCode(btn)` | 3036 | Copies code block content to clipboard with visual feedback |
| `updateScrollTopButton()` | 3052 | Shows/hides scroll-to-top button based on scroll position |
| `scrollToTop()` | 3060 | Smooth scrolls content area to top |
| `openLightbox(src)` | 3066 | Opens image in fullscreen lightbox overlay |
| `closeLightbox()` | 3076 | Closes the image lightbox |
| `openShortcutsModal()` | 3081 | Opens keyboard shortcuts help modal |
| `closeShortcutsModal()` | 3086 | Closes the keyboard shortcuts modal |
| `calculateReadingTime(text)` | 3092 | Calculates estimated reading time (200 wpm average) |
| `addCopyButtons()` | 3100 | Adds copy buttons to all code blocks in content |
| `highlightSearchTerms(query)` | 3116 | Highlights search terms in rendered content |
| `removeSearchHighlights()` | 3139 | Removes all search term highlights from content |

---

## Appendix C: CSS Variables

### Light Theme (Default)

```css
.ur-kb {
    --kb-bg: #ffffff;              /* Main background */
    --kb-text: #1a1a2e;            /* Primary text color */
    --kb-text-muted: #6b7280;      /* Secondary text color */
    --kb-border: #e5e7eb;          /* Border color */
    --kb-sidebar-bg: #f9fafb;      /* Sidebar background */
    --kb-sidebar-hover: #f3f4f6;   /* Sidebar item hover */
    --kb-sidebar-active: #e0e7ff;  /* Active sidebar item bg */
    --kb-sidebar-active-text: #4338ca; /* Active sidebar text */
    --kb-accent: #4f46e5;          /* Primary accent (buttons, links) */
    --kb-accent-hover: #4338ca;    /* Accent hover state */
    --kb-code-bg: #f3f4f6;         /* Code block background */
    --kb-code-text: #1a1a2e;       /* Code text color */
    --kb-link: #4f46e5;            /* Link color */
    --kb-search-bg: rgba(0,0,0,0.5); /* Search modal overlay */
    --kb-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
    --kb-radius: 8px;              /* Border radius */
    --kb-transition: 0.2s ease;    /* Animation timing */
}
```

### Dark Theme

```css
.ur-kb.dark {
    --kb-bg: #0d0d0d;              /* True black background */
    --kb-text: #e5e5e5;            /* Light text */
    --kb-text-muted: #a0a0a0;      /* Muted text */
    --kb-border: #333333;          /* Dark borders */
    --kb-sidebar-bg: #141414;      /* Dark sidebar */
    --kb-sidebar-hover: #1f1f1f;   /* Sidebar hover */
    --kb-sidebar-active: #2563eb;  /* Active item (blue) */
    --kb-sidebar-active-text: #ffffff; /* Active text (white) */
    --kb-accent: #3b82f6;          /* Blue accent */
    --kb-accent-hover: #60a5fa;    /* Lighter blue hover */
    --kb-code-bg: #1a1a1a;         /* Dark code blocks */
    --kb-code-text: #e5e5e5;       /* Light code text */
    --kb-link: #60a5fa;            /* Light blue links */
}
```

### High Contrast Mode

```css
.ur-kb.high-contrast {
    --kb-bg: #000000;
    --kb-text: #ffffff;
    --kb-border: #ffffff;
    --kb-accent: #ffff00;
    --kb-link: #00ffff;
}
```

---

## Appendix D: Future Enhancement Ideas

This section outlines potential features for future versions of the KB Widget to make it more feature-rich and modern.

> **Note:** Features marked with ✅ have been implemented in v4.0 (December 2025).

### Content & Navigation Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Bookmarks/Favorites** | Allow users to bookmark sections for quick access, stored in localStorage | High |
| **Reading Progress Tracking** | Track which sections user has read, show completion percentage | High |
| **Recent History** | Show recently visited sections for quick navigation | Medium |
| **Related Content Suggestions** | AI-powered or tag-based "Related Articles" at the end of sections | Medium |
| **Floating Table of Contents** | Sticky mini-TOC for current section showing subsections | Medium |
| **Anchor Link Copying** | Click-to-copy deep links to specific sections | Low |
| **Multi-language Support (i18n)** | Translate UI elements, support multiple document languages | High |
| **Document Versioning** | Show version history, compare changes between versions | Low |

### Search & Discovery Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Advanced Search Filters** | Filter by document, date, tags, content type | Medium |
| ✅ **Search Highlighting** | Highlight search terms in content after navigation | High |
| **Search History** | Remember recent searches | Low |
| **Tag/Category System** | Organize documents with tags, filterable sidebar | Medium |
| **AI-Powered Search** | Semantic search using embeddings (OpenAI/local) | Low |
| **Search Analytics** | Track popular searches to improve content | Low |

### Media & Content Type Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| ✅ **Image Lightbox** | Click to expand images in modal with zoom/pan | High |
| **Image Gallery** | Support for image galleries/carousels | Medium |
| **Audio Player** | Embed audio files with custom player | Low |
| **Mermaid.js Diagrams** | Support for flowcharts, ERDs, sequence diagrams | High |
| **Code Playground** | Executable code blocks (JS, SQL with mock data) | Low |
| ✅ **Copy Code Button** | One-click copy for code blocks | High |
| **Math/LaTeX Support** | Render mathematical equations (KaTeX/MathJax) | Medium |
| **Embedded Forms** | Simple feedback forms within documentation | Low |
| **File Attachments** | Download links for associated files (ZIP, PDF, etc.) | Medium |

### Collaboration & Feedback Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Comments/Annotations** | User comments on sections (requires backend) | Medium |
| **Feedback Widget** | "Was this helpful?" with thumbs up/down | High |
| **Report Issue Button** | Quick bug/typo reporting for content | Medium |
| **Share Button** | Share section via email, Teams, Slack, etc. | Medium |
| **Print-Friendly View** | Optimized print stylesheet | Low |
| **Suggest Edit** | Link to edit source (if using Git-based docs) | Low |

### Accessibility & UX Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Reading Mode** | Distraction-free mode hiding sidebar | Medium |
| **Focus Mode** | Highlight current paragraph while reading | Low |
| **Dyslexia-Friendly Font** | OpenDyslexic font option | Medium |
| ✅ **Reading Time Estimate** | Show "5 min read" for each section | High |
| ✅ **Scroll-to-Top Button** | Floating button for long content | High |
| ✅ **Keyboard Shortcuts Help** | Modal showing all keyboard shortcuts | Medium |
| **Custom Font Selection** | Let users choose preferred font | Low |
| **Line Spacing Control** | Adjust line height for readability | Low |
| **TTS Queue** | Queue multiple sections for continuous reading | Low |

### Offline & Performance Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Offline Mode (PWA)** | Service worker for offline access | Medium |
| **Content Caching** | Cache documents in IndexedDB | Medium |
| **Lazy Loading** | Load documents on-demand, not all at init | High |
| **Preloading** | Preload likely-next sections | Low |
| **Compression** | Gzip/Brotli compressed document delivery | Low |

### Analytics & Admin Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Usage Analytics** | Track page views, time spent, popular sections | Medium |
| **Heatmaps** | Visual representation of most-read areas | Low |
| **Admin Dashboard** | View analytics, manage documents | Low |
| **Content Freshness** | Show "Last updated X days ago" warnings | Medium |
| **Broken Link Checker** | Detect and report broken internal/external links | Medium |

### Integration & Export Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **API Endpoint** | REST API for programmatic access to content | Medium |
| **Webhook Support** | Notify external systems on document updates | Low |
| **Export to Word** | DOCX export in addition to PDF | Medium |
| **Export to ePub** | eBook format export | Low |
| **Embed Widget** | Embeddable widget for external sites | Low |
| **Slack/Teams Bot** | Search KB from chat platforms | Low |
| **APEX Integration Hooks** | Fire APEX dynamic actions on KB events | High |

### Security & Access Control Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **Document-Level Permissions** | Show/hide docs based on user role | High |
| **Section-Level Permissions** | Restrict specific sections | Medium |
| **Watermark on Screen** | Dynamic watermark showing user info | Medium |
| **Copy Protection** | Disable text selection (optional) | Low |
| **Session Timeout** | Auto-logout for sensitive content | Low |
| **Audit Logging** | Log who accessed what and when | Medium |

### AI-Powered Enhancements

| Feature | Description | Priority |
|---------|-------------|----------|
| **AI Chat Assistant** | Ask questions about documentation | High |
| **Auto-Summarization** | AI-generated summaries for long sections | Medium |
| **Smart Suggestions** | "You might also want to read..." | Medium |
| **Content Translation** | On-the-fly translation using AI | Medium |
| **Voice Commands** | Navigate using voice ("Go to section 3") | Low |
| **Auto-Generate FAQ** | AI extracts common questions from content | Low |

### Implementation Roadmap Recommendations

#### Quick Wins (Easy to implement, high value) - ✅ All Implemented in v4.0
1. ✅ Copy Code Button
2. ✅ Reading Time Estimate
3. ✅ Scroll-to-Top Button
4. ✅ Image Lightbox
5. ✅ Keyboard Shortcuts Help Modal
6. ✅ Search Highlighting

#### High Impact (More effort but valuable)
1. Mermaid.js Diagrams
2. Bookmarks/Favorites
3. Reading Progress Tracking
4. Feedback Widget ("Was this helpful?")
5. Document-Level Permissions
6. APEX Integration Hooks

#### Advanced (Requires backend/infrastructure)
1. AI Chat Assistant
2. Comments/Annotations
3. Usage Analytics
4. Offline Mode (PWA)
5. Multi-language Support

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 4.0 | Dec 2025 | Added accessibility features, OpenAI TTS, theme toggle |
| 3.0 | Nov 2025 | Added PDF export with cover pages, watermarks |
| 2.0 | Oct 2025 | Added search, sidebar navigation |
| 1.0 | Sep 2025 | Initial release |

---

## Credits

**Designed & Implemented By:** Vishnu Kant
**Project:** EIDOS (Enterprise Delivery & Engineering)
**Organization:** Project EIDOS

---

*This documentation is maintained alongside the KB Widget source code.*
*© 2025 Project EIDOS - All Rights Reserved*
