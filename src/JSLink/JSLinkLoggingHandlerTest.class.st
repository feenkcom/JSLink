"
This class contains tests

"
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
	logger := LanguageLinkLoggingHandler new
]

{ #category : #tests }
JSLinkLoggingHandlerTest >> testAddLog [
	logger log: (LanguageLinkLog message: 'Foo').
	self assert: logger logs first message equals: 'Foo'
]

{ #category : #tests }
JSLinkLoggingHandlerTest >> testErrorLog [
	logger log: (LanguageLinkLog message: 'Foo').
	self assert: logger errorLogs isEmpty.
	logger log: (LanguageLinkErrorLog message: 'Bar').
	self assert: logger errorLogs first message equals: 'Bar'.
]
