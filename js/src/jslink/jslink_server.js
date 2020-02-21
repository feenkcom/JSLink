var logger = require('./logger');
var express = require('express');
var EvalCommand = require('./eval_command');

var globals = {};


/**
 * I define an API for accessing views for objects based on objects ids.
 * 
 * I forward all requests for building views to a @link{RemoteInspector}.
 * The remote inspector is the one that knows how to determine which objects
 * is associated with an id and perform the request.
 */
class JSLinkServer {
    constructor(remoteInspector, listenPortNumber, responsePortNumber) {
        this.remoteInspector = remoteInspector;
        this.app = express();
        this.app.use(express.json());
		this.listenPort = listenPortNumber;
		this.responsePort = responsePortNumber;
        this._initializeRoutes();
    }
    
    _initializeRoutes() {     
        this.app.post('/IS_ALIVE', (req, res) => {
			logger.debug('IS_ALIVE');
            res.json({});
        });

        this.app.post('/ENQUEUE', (req, res) => {
            res.json(this.handleEnqueue(req));
        });
    }

    start() {
        var runningServer = this.app.listen(this.listenPort, function () {
            var host = runningServer.address().address
            var port = runningServer.address().port
            
            logger.info("Inspection service listening at http://%s:%s", host, port)
        });
        return runningServer;
    }

    handleEnqueue(request) {
		// Python version queues and dequeues.
		// We're just executing immediately for now.
		this.logRequest(request, null);
		let cmd = new EvalCommand(request.body.commandId, request.body.statements, request.body.bindings);
		cmd.execute(globals);
        return {};
    }

    logRequest(req, res) {
        logger.debug('Received request: ' + req.get('host')+req.originalUrl);
		logger.debug('Body:');
		logger.debug(req.body);
    }
}

module.exports = JSLinkServer;
