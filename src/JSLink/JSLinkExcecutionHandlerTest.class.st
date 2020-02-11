Class {
	#name : #JSLinkExcecutionHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'execHandler',
		'commandFactory'
	],
	#category : #'JSLink-Tests'
}

{ #category : #initialization }
JSLinkExcecutionHandlerTest >> setUp [
	| app |
	app := JSLinkStubApplication new.
	execHandler := JSLinkExecutionHandler new 
							application: app;
							yourself.
	commandFactory := JSLinkCommandFactory new.
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
