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
	^ self registryExpression => #hasId jsCallWith: (Array with: anId)
]

{ #category : #running }
JSLinkObjectFinalizationTest >> setUp [
	super setUp.
	debugMode := self application debugMode.
	self application debugMode: false.
]

{ #category : #running }
JSLinkObjectFinalizationTest >> tearDown [
	self application debugMode: debugMode.
	super tearDown
]

{ #category : #tests }
JSLinkObjectFinalizationTest >> testCreateObjectAndGcItBeforeSending [
	"Bug when the object is garbage collected before sending the command to python, this trigger the gc in Python of an object that hasnt yer been created nor registered. Now we fixed this enforcing the message send in the basicCreateObject, though another way is to registering the object to the command with a hard-reference."
	(JSLinkProxyObject new application: self application) basicCreateObjectExpr: 5.5.
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
	self assert: true
]

{ #category : #tests }
JSLinkObjectFinalizationTest >> testGCSimpleObj [
	| obj id |

	obj := (JSLinkProxyObject new application: self application) basicCreateObjectExpr: 5.5.
	id := obj id.
	self cf << obj.
	self assert: self cfSend waitForValue equals: 5.5.
	self assertExpression: (self idInRegistry: id) equals: true.
	self cf reset.
	obj := nil.
	2 timesRepeat: [ Smalltalk garbageCollect ].
	self assertExpression: (self idInRegistry: id) equals: false.
]

{ #category : #tests }
JSLinkObjectFinalizationTest >> testSimpleCreateObjectFromExpr [
	| obj |
	obj := (JSLinkProxyObject new application: self application) basicCreateObjectExpr: 5.5.
	self cf << obj.
	self assert: self cfSend waitForValue equals: 5.5.
	self assertExpression: (self resolveId: obj id) equals: 5.5
]
