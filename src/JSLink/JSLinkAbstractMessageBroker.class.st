Class {
	#name : #JSLinkAbstractMessageBroker,
	#superclass : #Object,
	#instVars : [
		'debugMode',
		'messageCallbacks',
		'settings'
	],
	#category : #'JSLink-Platform'
}

{ #category : #accessing }
JSLinkAbstractMessageBroker class >> pythonMethodArg [
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkAbstractMessageBroker class >> serializer [
	^ self serializerClass new
]

{ #category : #accessing }
JSLinkAbstractMessageBroker class >> serializerClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
JSLinkAbstractMessageBroker class >> settings: settings [
	^ self new
		settings: settings;
		yourself
]

{ #category : #messaging }
JSLinkAbstractMessageBroker >> addCallback: aBlock messageClass: messageClass [
	messageCallbacks at: messageClass put: aBlock
]

{ #category : #private }
JSLinkAbstractMessageBroker >> handle: dict reverseMessageClass: msgClass [
	| handler |
	(messageCallbacks includesKey: msgClass) ifFalse: [ JSLinkCommunicationError signal ].
	handler := JSLinkMessageHandler 
						forMessage: (msgClass decodeFrom: dict) 
						callback: (messageCallbacks at: msgClass).
	handler handleMessage.
	^ handler
]

{ #category : #initialization }
JSLinkAbstractMessageBroker >> initialize [
	super initialize.
	messageCallbacks := Dictionary new.
	debugMode := false
]

{ #category : #testing }
JSLinkAbstractMessageBroker >> isRunning [
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkAbstractMessageBroker >> port [
	^ settings pharoSocketAddress port
]

{ #category : #accessing }
JSLinkAbstractMessageBroker >> pythonUri [
	^ 'http://' , settings pythonSocketAddress printAddress
]

{ #category : #private }
JSLinkAbstractMessageBroker >> resolveMessageFromType: aType [
	^ JSLinkAbstractMessage allSubclasses 
			detect: [ :cls | cls type = aType ] 
			ifNone: [ Error signal: 'Message ' , aType , ' not understood.' ].
]

{ #category : #messaging }
JSLinkAbstractMessageBroker >> sendAsyncMessage: aMessage [
	self subclassResponsibility
]

{ #category : #messaging }
JSLinkAbstractMessageBroker >> sendMessage: aMessage [
	^ aMessage isSync
		ifTrue: [ self sendSyncMessage: aMessage ]
		ifFalse: [ self sendAsyncMessage: aMessage ]
]

{ #category : #messaging }
JSLinkAbstractMessageBroker >> sendSyncMessage: aMessage [
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkAbstractMessageBroker >> serializer [
	^ self class serializer
]

{ #category : #accessing }
JSLinkAbstractMessageBroker >> setDebugMode [
	debugMode := true.
]

{ #category : #accessing }
JSLinkAbstractMessageBroker >> settings [
	^ settings
]

{ #category : #accessing }
JSLinkAbstractMessageBroker >> settings: anObject [
	settings := anObject
]

{ #category : #'start-stop' }
JSLinkAbstractMessageBroker >> start [
	self subclassResponsibility
]

{ #category : #'start-stop' }
JSLinkAbstractMessageBroker >> stop [
	self subclassResponsibility
]
