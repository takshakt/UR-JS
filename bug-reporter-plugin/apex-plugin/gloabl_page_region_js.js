BugReporter.init({
  webhookUrl: 'https://n8n.448.global/webhook/3e6238b5-fbbc-4712-bd44-c59d4fd84265',
  webhookApiKey: 'your-api-key',
  apexProcessName: 'AJX_BUG_REPORTER_LOG'
});


 
 const btn = document.querySelector('.bug-reporter-btn');

if (btn) {
  const headerBg =
    getComputedStyle(document.documentElement)
      .getPropertyValue('--ut-header-background-color')
      .trim();

  btn.style.setProperty(
    'background-color',
    headerBg,
    'important'
  );
}
// Below block will be used to disable bug reporter on the Modal Dialogue Pages
// This is a temporary solution but throws error of html2canvas when MD is open and Bug buttton is clicked
if (btn && document.querySelector('.t-Dialog-page')) {
  btn.style.display = 'none';
}