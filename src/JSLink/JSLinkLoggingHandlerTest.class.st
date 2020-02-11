Class {
	#name : #JSLinkLoggingHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'logger'
	],
	#category : #'JSLink-Tests'
}

{ #category : #'as yet unclassified' }
JSLinkLoggingHandlerTest >> logs [
	^ logger logs
]

{ #category : #initialization }
JSLinkLoggingHandlerTest >> setUp [
	logger := JSLinkLoggingHandler new
]

{ #category : #tests }
JSLinkLoggingHandlerTest >> testAddLog [
	logger log: (JSLinkLog message: 'Foo').
	self assert: logger logs first message equals: 'Foo'
]

{ #category : #tests }
JSLinkLoggingHandlerTest >> testErrorLog [
	logger log: (JSLinkLog message: 'Foo').
	self assert: logger errorLogs isEmpty.
	logger log: (JSLinkErrorLog message: 'Bar').
	self assert: logger errorLogs first message equals: 'Bar'.
]
