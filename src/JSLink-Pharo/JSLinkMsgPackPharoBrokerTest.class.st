"
JSLink currently only supports the HTTP message broker.

The MsgPack broker tests are disabled by making this a subclass of Object, instead of JSLinkMessageBrokerTest.

This should be moved back under JSLinkMessageBrokerTest when support for MsgPack is added.

"
Class {
	#name : 'JSLinkMsgPackPharoBrokerTest',
	#superclass : 'Object',
	#instVars : [
		'stubStream',
		'stubThread'
	],
	#category : 'JSLink-Pharo-MessageBroker'
}

{ #category : 'utils' }
JSLinkMsgPackPharoBrokerTest >> answer [
	"MsgPack socket broker does not answer empty messages."
]

{ #category : 'utils' }
JSLinkMsgPackPharoBrokerTest >> answer: dict [
	self primSendMessageToBroker: dict
]

{ #category : 'utils' }
JSLinkMsgPackPharoBrokerTest >> assertCommunicationError: aBlock [
	"Message pack does not raise CommunicationError on exceptions at the other side"
]

{ #category : 'running' }
JSLinkMsgPackPharoBrokerTest >> buildAndStartStubServer [
	stubStream := JSLinkMsgPackUtils openConnectionToHost: #[ 127 0 0 1 ] port: broker port.
	stubStream := JSLinkMsgPackSocketStream on: stubStream.
	stubThread := [	
		[ true ] whileTrue: [ 
			self stubPrimHandle: stubStream next ] ] forkAt: Processor lowIOPriority.
	
]

{ #category : 'utils' }
JSLinkMsgPackPharoBrokerTest >> errorResponse [
	^ ZnResponse serverError: 'ERROR'
]

{ #category : 'hooks' }
JSLinkMsgPackPharoBrokerTest >> messageBrokerClass [
	^ JSLinkMsgPackPharoBroker
]

{ #category : 'private' }
JSLinkMsgPackPharoBrokerTest >> primSendMessageToBroker: dict [
	stubStream nextPut: dict
]

{ #category : 'hooks' }
JSLinkMsgPackPharoBrokerTest >> sendMessageToBroker: dict [
	self sendMessageToBroker: dict answerBlock: [ :ans | self assert: false ]
]

{ #category : 'hooks' }
JSLinkMsgPackPharoBrokerTest >> sendMessageToBroker: dict answerBlock: aBlock [
	self setHandler: aBlock.
	self primSendMessageToBroker: dict.
	self sleepAWhile.
]

{ #category : 'utils' }
JSLinkMsgPackPharoBrokerTest >> sleepAWhile [
	(Delay forMilliseconds: 150) wait.
]

{ #category : 'running' }
JSLinkMsgPackPharoBrokerTest >> stopStubServer [
	stubThread ifNotNil: [ stubThread terminate ].
	stubStream ifNotNil: [ stubStream close ]
]

{ #category : 'private' }
JSLinkMsgPackPharoBrokerTest >> stubPrimHandle: msgDict [
	handlerBlock value: (msgDict at: #type) -> msgDict
]
