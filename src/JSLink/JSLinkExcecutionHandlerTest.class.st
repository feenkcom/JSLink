"
This class contains tests

"
Class {
	#name : #JSLinkExcecutionHandlerTest,
	#superclass : #JSLinkTestCase,
	#instVars : [
		'execHandler'
	],
	#category : #'JSLink-Tests'
}

{ #category : #initialization }
JSLinkExcecutionHandlerTest >> setUp [

	super setUp.
	execHandler := self application executionHandler.

]

{ #category : #accessing }
JSLinkExcecutionHandlerTest >> testJSONSerializeEncodeBindings [
	| message |
	commandFactory bindingAt: #foo put: #().
	message := execHandler buildMessageFromCommand: commandFactory buildCommand.
	self assert: (message bindings at: #foo) equals: (execHandler serialize: #()).
	self deny: (message bindings at: #foo) = #()
]

{ #category : #accessing }
JSLinkExcecutionHandlerTest >> testSerializeEncodeBindings [
	| message |
	commandFactory bindingAt: #foo put: #().
	message := execHandler buildMessageFromCommand: commandFactory buildCommand.
	self assert: (message bindings at: #foo) equals: (execHandler serialize: #()).
	self deny: (message bindings at: #foo) = #()
]
