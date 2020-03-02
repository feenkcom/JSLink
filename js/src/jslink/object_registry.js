var logger = require('./logger');
const uuidv1 = require('uuid/v1');

var mapper = new Map();

// Only non-primitive values are stored in the registry.
// Integers, Strings, Booleans and Arrays are considered primitive
function is_primitive(obj) {
	let objType = typeof obj;
	return Number.isInteger(obj) || 
		objType == 'string' || 
		objType == 'boolean' || 
		Array.isArray(obj) }


// The mapping function converts instances of a class when returning to the client
function addMapping(key_type, mapping_function) {
	mapper.set(key_type, mapping_function);
	return key_type; }



class Registry {
	constructor() {
		this.idToObjMap = new Map();
		this.objToIdMap = new Map(); }

	hasId(anId) {
		return this.idToObjMap.has(anId); }


	createNewObjId() {
		return uuidv1(); }


	register(obj) {
		if (obj == null || is_primitive(obj)) {
			return 0; }
		if (this.objToIdMap.has(obj)) {
			return this.objToIdMap.get(obj); }
		else {
			return this.prim_register(obj, this.createNewObjId()); } }


	register_with_id(obj, newObjId) {
		if (obj == null || is_primitive(obj)) {
			return new RegisterForbiddenObject(obj); }
		if (this.objToIdMap.has(obj)) {
			let objId = this.objToIdMap.get(obj);
			if (objId == newObjId) {
				return newObjId; }
			else {
				throw new RegisterWithDifferentIdError(obj, newObjId); } }
		else {
			return this.prim_register(obj, newObjId); } }


	resolve(objId) {
		if (this.idToObjMap.has(objId)) {
			return this.idToObjMap.get(objId); }
		else {
			throw new ResolveUnknownObject(objId); } }


	prim_register(obj, newObjId) {
		this.idToObjMap.set(newObjId, obj);
		this.objToIdMap.set(obj, newObjId);
		logger.debug("Registered: " + obj + " -> " + newObjId);
		return newObjId; }


	clean(objId) {
		let obj = this.idToObjMap.get(objId);
		this.idToObjMap.delete(objId);
		this.objToIdMap.delete(obj);
		return null; }
}



class RegistryError extends Error { }

class RegisterWithDifferentIdError extends RegistryError {
	constructor(obj, newId) {
		super("Attempt to register object " + obj + " with id " + newId); } }


class ResolveUnknownObject extends RegistryError {
	constructor(objId) {
		super("Attempt to resolve unknown object with id " + objId); } }


class RegisterForbiddenObject extends RegistryError {
	constructor(obj) {
		super("Attempt to register forbidden object of type " + typeof obj); } }


var the_registry = new Registry();

function registry() {
	return the_registry; }


function json_replacer(key, obj) {
	let mappedObj = obj;
	if (obj != null &
		typeof(obj) == 'object' && 
		mapper.has(obj.constructor.name)) {
			mappedObj = mapper.get(obj.constructor.name)(obj); }
	if (mappedObj == null || 
			typeof mappedObj == 'number' || 
			is_primitive(mappedObj) || 
			mappedObj.__jsLinkImmediate) {
		return mappedObj; }
	else {
		return {
			"__jsclass__": mappedObj.constructor.name,
			"__registryid__": the_registry.register(mappedObj) }; } }


function serialize(obj, immediate) {
	let result;
	if (immediate)
		{ result = JSON.stringify(obj) }
	else
		{ result = JSON.stringify(obj, json_replacer); }
	logger.silly("serialize: " + result);
	return result; }


function deserialize(obj) {
	let result;

	logger.debug("deserialize: " + obj);
	if (obj.__registryid__) {
		result = the_registry.resolve(obj.__registryid__); }
	else {
		result = JSON.parse(obj) }
	logger.debug("result = " + result);
	return result; }


exports.registry = registry;
exports.the_registry = the_registry;
exports.serialize = serialize;
exports.deserialize = deserialize;
exports.addMapping = addMapping;

