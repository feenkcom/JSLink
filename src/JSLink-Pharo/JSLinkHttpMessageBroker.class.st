Class {
	#name : #JSLinkHttpMessageBroker,
	#superclass : #JSLinkAbstractMessageBroker,
	#instVars : [
		'server'
	],
	#category : #'JSLink-Pharo-MessageBroker'
}

{ #category : #accessing }
JSLinkHttpMessageBroker class >> pythonMethodArg [
	^ 'http'
]

{ #category : #accessing }
JSLinkHttpMessageBroker class >> serializerClass [
	^ JSLinkNeoJsonSerializer
]

{ #category : #private }
JSLinkHttpMessageBroker >> handleRMessage: dict [
	| msgClass |
	msgClass := self resolveMessageFromType: (dict at: #type).
	StringSignal emit: 'msgClass = ', msgClass name asString.
	^ self handle: dict reverseMessageClass: msgClass
]

{ #category : #private }
JSLinkHttpMessageBroker >> invalidMethod [
	^ (ZnResponse statusLine: ZnStatusLine badRequest)
		entity: (ZnEntity text: 'Bad method');
		yourself
]

{ #category : #private }
JSLinkHttpMessageBroker >> invalidType [
	^ (ZnResponse statusLine: ZnStatusLine notFound)
		entity: (ZnEntity text: 'Invalid type');
		yourself
]

{ #category : #testing }
JSLinkHttpMessageBroker >> isRunning [
	^ server notNil
]

{ #category : #private }
JSLinkHttpMessageBroker >> preventTestForkedPDestroyServer [
	| env |
	env := CurrentExecutionEnvironment value.
	(env isKindOf: TestExecutionEnvironment) ifTrue: [ 
		env forkedProcesses
			remove: server process 
			ifAbsent: [  ] ]
]

{ #category : #private }
JSLinkHttpMessageBroker >> primSendMessage: dict [
	| ans |

	ans := [ ZnClient new
					beOneShot;
					url: self pythonUri , '/' , (dict at: #type);
					entity: (ZnEntity json: (self serializer serialize: dict));
					post; 
					response.
			] on: Error do: [ :err | JSLinkCommunicationError signal: 'Request fail' ].
	ans status = 200 ifFalse: [ JSLinkCommunicationError signal: 'Request fail' ].
	^ self serializer deserialize: ans contents
]

{ #category : #private }
JSLinkHttpMessageBroker >> prim_handle: req [
	"Because of the nature of HTTP, answers of sync messages are not received through this method, but as 	the answers of HTTP requests. This channel is only for RMessages."

	StringSignal emit: 'prim_handle:'.
	^ req method = #POST 
		ifTrue: [ | dict ansDict handler |
			[
				StringSignal emit: req relativeUrl asString.
				"req relativeUrl asString = '/CALLBACK' ifTrue: [ self halt ]."
				dict := self serializer deserialize: req contents.
				StringSignal emit: dict printString.
				handler := self handleRMessage: dict.
				"(DateAndTime now -> { dict. handler. }) inspect."
				ansDict := handler shouldAnswer
								ifTrue: [ handler answer encode ]
								ifFalse: [ Dictionary new ].
				StringSignal emit: 'response: ', ansDict printString.
				^ ZnResponse ok: (ZnEntity json: (self serializer serialize: ansDict)) ] 
			on: Error 
			do: [ :e | StringSignal emit: 'Error: ', e printString.
				debugMode
							ifTrue: [ e pass ]
							ifFalse: [ ZnResponse serverError: e printString  ] ] ]
		ifFalse: [ 
			self invalidMethod ]
]

{ #category : #messaging }
JSLinkHttpMessageBroker >> sendAsyncMessage: msg [
	self primSendMessage: msg encode.
]

{ #category : #messaging }
JSLinkHttpMessageBroker >> sendSyncMessage: msg [
	| ansDict |
	ansDict := self primSendMessage: msg encode.
	^ msg createAnswer decode: ansDict
]

{ #category : #accessing }
JSLinkHttpMessageBroker >> setDebugMode [
	super setDebugMode.
	server ifNotNil: [ server debugMode: true ]
]

{ #category : #'start-stop' }
JSLinkHttpMessageBroker >> start [
	server := ZnServer on: self port.
	server debugMode: debugMode.
	server start.
	self preventTestForkedPDestroyServer.
	self
		assert: server isRunning & server isListening
		description:
			('Failed to start server on port {1}. Is there one already?' format: {server port}).
	server onRequestRespond: [ :req | self prim_handle: req ]
]

{ #category : #'start-stop' }
JSLinkHttpMessageBroker >> stop [
	server ifNotNil: [ server stop ]
]
