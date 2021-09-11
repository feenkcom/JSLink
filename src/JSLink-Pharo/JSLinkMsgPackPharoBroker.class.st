Class {
	#name : 'JSLinkMsgPackPharoBroker',
	#superclass : 'PharoLinkAbstractMessageBroker',
	#instVars : [
		'serverSocket',
		'handlerThread',
		'msgStream',
		'syncRegistry'
	],
	#category : 'JSLink-Pharo-MessageBroker'
}

{ #category : 'accessing' }
JSLinkMsgPackPharoBroker class >> javaScriptMethodArg [
	^ 'msgpack'
]

{ #category : 'accessing' }
JSLinkMsgPackPharoBroker class >> serializerClass [
	^ JSLinkMsgPackSerializer
]

{ #category : 'private' }
JSLinkMsgPackPharoBroker >> _primHandle: dict [
	"Remove ifCurtailed: [ ^ self ]"
	^ self primHandle: dict
]

{ #category : 'private' }
JSLinkMsgPackPharoBroker >> handleAnswerMessage: dict [
	| assoc message semaphore |
	assoc := syncRegistry at: (dict at: #__sync).
	message := assoc key.
	semaphore := assoc value.
	syncRegistry at: message syncId put: (message createAnswer decode: dict).
	semaphore signal
]

{ #category : 'initialization' }
JSLinkMsgPackPharoBroker >> initialize [
	super initialize.
	syncRegistry := Dictionary new
]

{ #category : 'testing' }
JSLinkMsgPackPharoBroker >> isRunning [
	^ msgStream notNil and: [ msgStream isConnected ]
]

{ #category : 'private' }
JSLinkMsgPackPharoBroker >> preventTestForkedPDestroyServer [
	| env |
	env := CurrentExecutionEnvironment value.
	(env isKindOf: TestExecutionEnvironment) ifTrue: [ 
		env forkedProcesses
			remove: handlerThread 
			ifAbsent: [  ] ]
]

{ #category : 'private' }
JSLinkMsgPackPharoBroker >> primHandle: dict [
	| msgClass |
	msgClass := self resolveMessageFromType: (dict at: #type).
	msgClass isReverseMessage
		ifTrue: [ | handler |
			handler := self handle: dict reverseMessageClass: msgClass.
			handler shouldAnswer ifTrue: [ self primSendMessage: handler answer encode ] ]
		ifFalse: [ 
			self handleAnswerMessage: dict ]
]

{ #category : 'private' }
JSLinkMsgPackPharoBroker >> primSendMessage: dict [
	msgStream ifNil: [ LanguageLinkCommunicationError signal ].
	msgStream nextPut: dict
]

{ #category : 'private' }
JSLinkMsgPackPharoBroker >> registerSemaphoreForMessage: message [
	| semaphore |
	semaphore := Semaphore new.
	syncRegistry at: message syncId put: message -> semaphore.
	^ semaphore
]

{ #category : 'private' }
JSLinkMsgPackPharoBroker >> retrieveAnswerForSyncId: syncId [
	| msgAnswer |
	msgAnswer := syncRegistry at: syncId.
	syncRegistry removeKey: syncId.
	^ msgAnswer
]

{ #category : 'messaging' }
JSLinkMsgPackPharoBroker >> sendAsyncMessage: msg [
	self primSendMessage: msg encode.
]

{ #category : 'messaging' }
JSLinkMsgPackPharoBroker >> sendSyncMessage: msg [
	| syncSemaphore ansDict |
	syncSemaphore := self registerSemaphoreForMessage: msg. 
	self primSendMessage: msg encode.
	syncSemaphore wait.
	ansDict := self retrieveAnswerForSyncId: msg syncId.
	^ msg createAnswer decode: ansDict
]

{ #category : 'private - utils' }
JSLinkMsgPackPharoBroker >> serverSocketOn: port [
	| socket |
	(socket := Socket newTCP)
		setOption: 'TCP_NODELAY' value: 1;
		setOption: 'SO_SNDBUF' value: JSLinkMsgPackUtils socketBufferSize;
		setOption: 'SO_RCVBUF' value: JSLinkMsgPackUtils socketBufferSize .
	socket listenOn: port backlogSize: JSLinkMsgPackUtils listenBacklogSize.
	socket isValid
		ifFalse: [ self error: 'Cannot create socket on port ', port printString ].
	^ socket
]

{ #category : 'start-stop' }
JSLinkMsgPackPharoBroker >> start [
	serverSocket := self serverSocketOn: self port.
	handlerThread := [	| bindSocket |	
		bindSocket := serverSocket waitForAcceptFor: 10.
		bindSocket ifNil: [ bindSocket := serverSocket waitForAcceptFor: 10 ].
		bindSocket ifNotNil: [ 
			msgStream := JSLinkMsgPackSocketStream on: (SocketStream on: bindSocket).
			[ [ true ] whileTrue: [ 
				self _primHandle: msgStream next ] ] 
					on: Error 
					do: [ :err | JSLinkPlatform current uiManager notify: err printString ] ] 
		] forkAt: Processor lowIOPriority.
	self preventTestForkedPDestroyServer
]

{ #category : 'start-stop' }
JSLinkMsgPackPharoBroker >> stop [
	msgStream ifNotNil: [ msgStream close ].
	serverSocket ifNotNil: [ serverSocket closeAndDestroy ].
	handlerThread ifNotNil: [ handlerThread terminate ].
]
