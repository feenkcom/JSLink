const bent = require('bent');
const getJSON = bent('json', 'POST');
const uuidv1 = require('uuid/v1');

const object_registry = require('./object_registry');
const serialize = object_registry.serialize;
const deserialize = object_registry.deserialize;

var response_port = null;


async function send_response(data) {
	let url = 'http://localhost:' + response_port + '/' + data['type'];
    data['__sync'] = uuidv1();

	console.log("send_response() to: " + url + " " + data['__sync']);
	let result = await getJSON(url, data);
	console.log("send_response() returning from: " + data['__sync']);
	console.log(result);
	return result; }




function observer(commandId, observerId) {
	return (obj) => notify_observer(obj, commandId, observerId); }



async function notify(obj, notification_id) {
	let data = {};

	console.log("Notify: " + notification_id);
	console.log(obj);
	data["type"] = "EVAL";
	data["id"] = notification_id;
	data["value"] = serialize(obj);
	return await send_response(data); }



async function notify_observer(obj, command_id, observer_id) {
	let data = {};

	console.log("Notify Observer: " + command_id + " " + observer_id);
	data['type'] = "CALLBACK";
	data['commandId'] = command_id;
	data['observerId'] = observer_id;
	data['value'] = serialize(obj);
	let response = await send_response(data);
	console.log("Notify Observer: response = ");
	console.log(response);
	return deserialize(response.value); }



async function notify_error(err, command) {
	let data = {};

	console.log("Notify Error: " + command.get_command_id());
	console.log(err);
	data['type'] = "ERR";
	data['errMsg'] = err;
	data['trace'] = err.stack;
	data['commandId'] = command.get_command_id();
	return await send_response(data); }



function set_response_port(portNumber) {
	console.log("Response Port = " + portNumber);
	response_port = portNumber; }



exports.observer = observer;
exports.notify = notify;
exports.notify_observer = notify_observer;
exports.notify_error = notify_error;
exports.set_response_port = set_response_port;

