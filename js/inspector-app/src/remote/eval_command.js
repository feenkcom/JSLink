var notify_response = require('./notify_response');
var observer = notify_response.observer;
var notify = notify_response.notify;
var notify_observer = notify_response.notify_observer;
var notify_error = notify_response.notify_error;

var object_registry = require('./object_registry');
var registry = object_registry.registry;
var the_registry = object_registry.the_registry;
var addMapping = object_registry.addMapping;


/*
 * EvalCommand executes de-serialised commands received from the client
 */

class EvalCommand {
	constructor(id, statementsString, bindingsDictionary) {
		this.statements = statementsString;
		this.bindings = bindingsDictionary;
		this.command_id = id; }

	execute(envDictionary) {
		// Python porting convenience:
		var None = null;

		try {
			let boundStatements = "{\n";
			boundStatements = boundStatements + "async function doIt() {\n";
			for (const [key, value] of Object.entries(envDictionary)) {
				boundStatements = boundStatements + "let " + key + "=" + value + ";\n"; }
			for (const [key, value] of Object.entries(this.bindings)) {
				boundStatements = boundStatements + "let " + key + "=" + value + ";\n"; }
			boundStatements = boundStatements + this.statements;
			boundStatements = boundStatements + "}\n\n";
			boundStatements = boundStatements + "doIt();\n}\n";
			console.log('EvalCommand executing: ' + boundStatements);
			eval(boundStatements); }
		catch(err) {
			console.log(err);
			notify_error(err, this); } }

	get_command_id() {
		return this.command_id; }

}


module.exports = EvalCommand;

