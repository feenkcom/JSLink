Class {
	#name : #JSLinkTestCase,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'commandFactory',
		'promise'
	],
	#category : #'JSLink-Tests'
}

{ #category : #initialization }
JSLinkTestCase >> app [
	^ self application
]

{ #category : #initialization }
JSLinkTestCase >> application [
	^ application
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
	^ commandFactory
]

{ #category : #'instance creation' }
JSLinkTestCase >> newCommand [ 

	^ self application newCommand.
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
	application := JSLinkApplication newWith: LanguageLinkSettings jsDefaultSettings.
	commandFactory := application newCommandFactory.
	self cf reset.
]
