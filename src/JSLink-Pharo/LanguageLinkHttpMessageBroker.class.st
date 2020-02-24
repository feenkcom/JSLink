Class {
	#name : #LanguageLinkHttpMessageBroker,
	#superclass : #JSLinkAbstractMessageBroker,
	#instVars : [
		'server'
	],
	#category : #'JSLink-Pharo-MessageBroker'
}

{ #category : #accessing }
LanguageLinkHttpMessageBroker class >> javaScriptMethodArg [
	^ 'http'
]

{ #category : #accessing }
LanguageLinkHttpMessageBroker class >> serializerClass [
	^ JSLinkNeoJsonSerializer
]

{ #category : #private }
LanguageLinkHttpMessageBroker >> handleRMessage: dict [
	| msgClass |
	msgClass := self resolveMessageFromType: (dict at: #type).
	StringSignal emit: 'msgClass = ', msgClass name asString.
	^ self handle: dict reverseMessageClass: msgClass
]

{ #category : #private }
LanguageLinkHttpMessageBroker >> invalidMethod [
	^ (ZnResponse statusLine: ZnStatusLine badRequest)
		entity: (ZnEntity text: 'Bad method');
		yourself
]

{ #category : #private }
LanguageLinkHttpMessageBroker >> invalidType [
	^ (ZnResponse statusLine: ZnStatusLine notFound)
		entity: (ZnEntity text: 'Invalid type');
		yourself
]

{ #category : #testing }
LanguageLinkHttpMessageBroker >> isRunning [
	^ server notNil
]

{ #category : #private }
LanguageLinkHttpMessageBroker >> preventTestForkedPDestroyServer [
	| env |
	env := CurrentExecutionEnvironment value.
	(env isKindOf: TestExecutionEnvironment) ifTrue: [ 
		env forkedProcesses
			remove: server process 
			ifAbsent: [  ] ]
]

{ #category : #private }
LanguageLinkHttpMessageBroker >> primSendMessage: dict [
	| ans |

	ans := [ ZnClient new
					beOneShot;
					url: self javaScriptUri , '/' , (dict at: #type);
					entity: (ZnEntity json: (self serializer serialize: dict));
					post; 
					response.
			] on: Error do: [ :err | LanguageLinkCommunicationError signal: 'Request fail' ].
	ans status = 200 ifFalse: [ LanguageLinkCommunicationError signal: 'Request fail' ].
	^ self serializer deserialize: ans contents
]

{ #category : #private }
LanguageLinkHttpMessageBroker >> prim_handle: req [
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
			do: [ :e | StringSignal emit: 'Error: ', e printString. self halt.
				debugMode
							ifTrue: [ e pass ]
							ifFalse: [ ZnResponse serverError: e printString  ] ] ]
		ifFalse: [ 
			self invalidMethod ]
]

{ #category : #messaging }
LanguageLinkHttpMessageBroker >> sendAsyncMessage: msg [
	self primSendMessage: msg encode.
]

{ #category : #messaging }
LanguageLinkHttpMessageBroker >> sendSyncMessage: msg [
	| ansDict |
	ansDict := self primSendMessage: msg encode.
	^ msg createAnswer decode: ansDict
]

{ #category : #accessing }
LanguageLinkHttpMessageBroker >> setDebugMode [
	super setDebugMode.
	server ifNotNil: [ server debugMode: true ]
]

{ #category : #'start-stop' }
LanguageLinkHttpMessageBroker >> start [
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
LanguageLinkHttpMessageBroker >> stop [
	server ifNotNil: [ server stop ]
]
