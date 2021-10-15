"
This class contains tests

"
Class {
	#name : #JSLinkMsgPackSocketStreamTest,
	#superclass : #TestCase,
	#category : 'JSLink-Pharo-MessageBroker'
}

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> assertSerialize: anObject [
	self connectStreams: [ :serverStream :clientStream |
		clientStream nextPut: anObject.
		self assert: serverStream next equals: anObject.
		self deny: serverStream atEnd ]
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> connectStreams: aBlock [
	| semaphore clientSocket serverStream clientStream |
	self serverSocket: [ :serverSocket |
		semaphore := Semaphore new.
		[ 	clientSocket := serverSocket waitForAcceptFor: 10.
			semaphore signal. ] forkAt: self serverPriority.
		[	clientStream := JSLinkMsgPackUtils openConnectionToHost: #[ 127 0 0 1 ] port: self port.
			semaphore wait.
			[	serverStream := JSLinkMsgPackUtils primStreamFromSocket: clientSocket.
				aBlock 
					value: (JSLinkMsgPackSocketStream on: serverStream) 
					value: (JSLinkMsgPackSocketStream on: clientStream)
				 ]
			ensure: [ serverStream close ] ]
		ensure: [ clientStream close ]. ]
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> listenBacklogSize [
	"Server socket backlog size (number of pending connection waiting to be accepted)"
	
	^ 32
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> port [
	^ 1332
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> serverPriority [
	^ Processor lowIOPriority
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> serverSocket: aBlock [
	| serverSocket |
	[	serverSocket := self serverSocketOn: self port.
		self assert: serverSocket notNil.
		self assert: serverSocket localPort equals: self port.
		aBlock value: serverSocket]
	ensure: [ 
			serverSocket closeAndDestroy ]
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> serverSocketOn: port [
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

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> socketStreamTimeout [
	^ 30
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> testAssertError [
	self should: [ self connectStreams: [ :serverStream :clientStream | 
			Error signal ] ] raise: Error.
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> testBidirectionality [
	self connectStreams: [ :serverStream :clientStream |
		serverStream nextPut: 'Foo'.
		clientStream nextPut: true.
		self assert: serverStream next equals: true.
		self assert: clientStream next equals: 'Foo' ]
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> testByteArray [
	self assertSerialize: #[ 1 23 54 ]
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> testConnect [
	self connectStreams: [ :serverStream :clientStream | ]
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> testDictionary [
	self assertSerialize: { #foo -> #(#err 4). 4 -> 16} asDictionary
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> testInteger [
	self assertSerialize: 3
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> testLargerString [
	self assertSerialize: 'pb6f6l7aqhz80ksi8i90e5iexer'
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> testLargerStringRaw [
	self assertSerialize: 'pb6f6l7aqhz80ksi8i90e5iexer'
]

{ #category : #private }
JSLinkMsgPackSocketStreamTest >> testString [
	self assertSerialize: 'FooBarZork'
]
