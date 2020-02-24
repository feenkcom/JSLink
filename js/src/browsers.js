var BrowserFeature = require('./features/browser/browser_feature');

var safariFeature = BrowserFeature.createFromFile('./export/browser/safari.json');
var chromeFeature = BrowserFeature.createFromFile('./export/browser/chrome.json');
var firefoxFeature = BrowserFeature.createFromFile('./export/browser/firefox.json');

exports.chromeFeature = chromeFeature;
exports.safariFeature = safariFeature;
exports.firefoxFeature = firefoxFeature;

