Class {
	#name : #JSLinkTestCase,
	#superclass : #TestCase,
	#instVars : [
		'commandFactory',
		'promise'
	],
	#category : #'JSLink-Tests'
}

{ #category : #accessing }
JSLinkTestCase class >> appResource [
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkTestCase class >> resources [
	^ super resources , (Array with: self appResource)
]

{ #category : #initialization }
JSLinkTestCase >> app [
	^ self application
]

{ #category : #initialization }
JSLinkTestCase >> application [
	^ self applicationClass uniqueInstance
]

{ #category : #initialization }
JSLinkTestCase >> applicationClass [
	self subclassResponsibility 
]

{ #category : #asserting }
JSLinkTestCase >> assertClass: cls name: aName [
	self cf << (cls => #__name__).
	self assert: self cf send waitForValue equals: aName
]

{ #category : #asserting }
JSLinkTestCase >> assertExpression: expr equals: aBlockOrValue [
	self cf << expr.
	self assert: self cf send waitForValue equals: aBlockOrValue value
]

{ #category : #asserting }
JSLinkTestCase >> assertInstanceClass: obj name: aName [

	self cf << (obj => #constructor => #name).
	"self cf << ((#type asP3GI callWith: (Array with: obj)) => #__name__)."
	self assert: self cf send waitForValue equals: aName
]

{ #category : #initialization }
JSLinkTestCase >> cf [
	^ self commandFactory
]

{ #category : #initialization }
JSLinkTestCase >> cfSend [
	^ promise := self cf send
]

{ #category : #initialization }
JSLinkTestCase >> commandFactory [
	^ self application commandFactory
]

{ #category : #asserting }
JSLinkTestCase >> registryExpression [
	^ #registry callWith: #()
]

{ #category : #asserting }
JSLinkTestCase >> resolveId: anId [
	^ self registryExpression => #resolve callWith: (Array with: anId)
]

{ #category : #running }
JSLinkTestCase >> setUp [
	super setUp.
	self cf reset
]
