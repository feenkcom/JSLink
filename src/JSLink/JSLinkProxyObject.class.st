Class {
	#name : #JSLinkProxyObject,
	#superclass : #JSLinkObject,
	#instVars : [
		'application',
		'javaScriptClass'
	],
	#category : #'JSLink-Core'
}

{ #category : #'instance creation' }
JSLinkProxyObject class >> javaScriptClass: pythonClass var: pyVar application: application [
	^ self new
		javaScriptVariable: pyVar;
		javaScriptClass: pythonClass;
		application: application;
		yourself
]

{ #category : #accessing }
JSLinkProxyObject >> application [
	^ application
]

{ #category : #accessing }
JSLinkProxyObject >> application: anObject [
	application := anObject
]

{ #category : #accessing }
JSLinkProxyObject >> applicationClass [
	^ self application class
]

{ #category : #accessing }
JSLinkProxyObject >> at: anObject [

	^ JSGSubscription new
		target: self;
		insideBrackets: anObject;
		yourself
]

{ #category : #hooks }
JSLinkProxyObject >> createObject [
	self shouldNotImplement
]

{ #category : #accessing }
JSLinkProxyObject >> javaScriptClass [
	^ javaScriptClass
]

{ #category : #accessing }
JSLinkProxyObject >> javaScriptClass: anObject [
	javaScriptClass := anObject
]

{ #category : #accessing }
JSLinkProxyObject >> javaScriptVariable: pyVar [
	javaScriptVariable := pyVar
]

{ #category : #serialization }
JSLinkProxyObject >> neoJsonOn: aWriter [

	{ '__class__' -> javaScriptClass.
	'__registryid__' -> self id. } asDictionary
		neoJsonOn: aWriter
]

{ #category : #'instance creation' }
JSLinkProxyObject >> newCommandFactory [

	^ application newCommandFactory
		addBinding: (PharoLinkBinding key: 'this' wrap: self);
		yourself
]

{ #category : #printing }
JSLinkProxyObject >> printOn: str [
	str 
		<< (javaScriptClass asString first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		<< javaScriptClass asString;
		<< ' (Proxy)'
]
