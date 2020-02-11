var BrowserFeature = require('./features/browser/browser_feature');
var RemoteInspector = require('./inspector/remote_inspector');
var InspectionServer = require('./remote/inspection_server');
var notify_response = require('./remote/notify_response');

var safariFeature = BrowserFeature.createFromFile('../export/browser/safari.json');
var chromeFeature = BrowserFeature.createFromFile('../export/browser/chrome.json');
var firefoxFeature = BrowserFeature.createFromFile('../export/browser/firefox.json');

var myArgs = process.argv.slice(2);
var listenPort = parseInt(myArgs[0]);
var responsePort = parseInt(myArgs[1]);

var remoteInspector = new RemoteInspector();
remoteInspector.registerNamedObject(
   safariFeature.getBrowser(), 
   safariFeature.getBrowser().getId(), 
   safariFeature.getBrowser().getName()
);
remoteInspector.registerNamedObject(
   chromeFeature.getBrowser(), 
   chromeFeature.getBrowser().getId(), 
   chromeFeature.getBrowser().getName()
);
remoteInspector.registerNamedObject(
   firefoxFeature.getBrowser(), 
   firefoxFeature.getBrowser().getId(), 
   firefoxFeature.getBrowser().getName()
);

notify_response.set_response_port(responsePort);
var inspectionServer = new InspectionServer(remoteInspector, listenPort, responsePort);
inspectionServer.start();
