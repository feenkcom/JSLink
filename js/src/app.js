var InspectionServer = require('./jslink/jslink_server');
var notify_response = require('./jslink/notify_response');

var myArgs = process.argv.slice(2);
var listenPort = parseInt(myArgs[0]);
var responsePort = parseInt(myArgs[1]);

notify_response.set_response_port(responsePort);
var inspectionServer = new InspectionServer(null, listenPort, responsePort);
inspectionServer.start();
