Class {
	#name : #JSLinkObjectFinalizationTest,
	#superclass : #JSLinkApplicationTest,
	#instVars : [
		'debugMode'
	],
	#category : #'JSLink-Tests'
}

{ #category : #asserting }
JSLinkObjectFinalizationTest >> idInRegistry: anId [
	^ self registryExpression => #hasId callWith: (Array with: anId)
]

{ #category : #initialization }
JSLinkObjectFinalizationTest >> setUp [
	super setUp.
	debugMode := JSLinkApplication debugMode.
	JSLinkApplication debugMode: false.
]

{ #category : #initialization }
JSLinkObjectFinalizationTest >> tearDown [
	JSLinkApplication debugMode: debugMode.
	super tearDown
]

{ #category : #tests }
JSLinkObjectFinalizationTest >> testCreateObjectAndGcItBeforeSending [
	"Bug when the object is garbage collected before sending the command to python, this trigger the gc in Python of an object that hasnt yer been created nor registered. Now we fixed this enforcing the message send in the basicCreateObject, though another way is to registering the object to the command with a hard-reference."
	JSLinkObject new basicCreateObjectExpr: 5.5.
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
	self assert: true
]

{ #category : #tests }
JSLinkObjectFinalizationTest >> testGCSimpleObj [
	| obj id |
	obj := JSLinkObject new basicCreateObjectExpr: 5.5.
	id := obj id.
	self cf << obj.
	self assert: self cfSend waitForValue equals: 5.5.
	self assertExpression: (self idInRegistry: id) equals: true.
	obj := nil.
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
	self assertExpression: (self idInRegistry: id) equals: false.
]

{ #category : #tests }
JSLinkObjectFinalizationTest >> testSimpleCreateObjectFromExpr [
	| obj |
	obj := JSLinkObject new basicCreateObjectExpr: 5.5.
	self cf << obj.
	self assert: self cfSend waitForValue equals: 5.5.
	self assertExpression: (self resolveId: obj id) equals: 5.5
]
