Class {
	#name : #JSLinkMsgPackSocketStream,
	#superclass : #Object,
	#instVars : [
		'socketStream',
		'encoder',
		'decoder',
		'decoderSemaphore',
		'encoderSemaphore'
	],
	#category : #'JSLink-Pharo-MessageBroker'
}

{ #category : #'instance creation' }
JSLinkMsgPackSocketStream class >> on: socketStream [
	^ self new
		on: socketStream;
		yourself
]

{ #category : #streaming }
JSLinkMsgPackSocketStream >> atEnd [
	^ decoderSemaphore critical: [ decoder atEnd ]
]

{ #category : #streaming }
JSLinkMsgPackSocketStream >> close [
	| ans |
	ans := socketStream socket ifNotNil: #closeAndDestroy.
	30 timesRepeat: [ encoderSemaphore signal ].
	30 timesRepeat: [ decoderSemaphore signal ].
	^ ans
]

{ #category : #streaming }
JSLinkMsgPackSocketStream >> flush [
	^ socketStream flush
]

{ #category : #initialization }
JSLinkMsgPackSocketStream >> initialize [
	super initialize.
	decoderSemaphore := Semaphore forMutualExclusion.
	encoderSemaphore := Semaphore forMutualExclusion.
]

{ #category : #streaming }
JSLinkMsgPackSocketStream >> isConnected [
	^ socketStream isConnected
]

{ #category : #streaming }
JSLinkMsgPackSocketStream >> isStream [
	^true
]

{ #category : #streaming }
JSLinkMsgPackSocketStream >> next [
	^ decoderSemaphore critical: [ decoder next ]
]

{ #category : #streaming }
JSLinkMsgPackSocketStream >> nextPut: anObject [
	| result |
	result := encoderSemaphore critical: [ 
		encoder nextPut: anObject.
		socketStream flush ].
	^ result
]

{ #category : #'instance creation' }
JSLinkMsgPackSocketStream >> on: aSocketStream [
	socketStream := aSocketStream.
	self setSocketStreamOptions: socketStream.
	encoder := MpEncoder on: socketStream.
	decoder := MpDecoder on: socketStream
]

{ #category : #private }
JSLinkMsgPackSocketStream >> setSocketStreamOptions: stream [
	stream
		binary;
		shouldSignal: true;
		autoFlush: false;
		bufferSize: JSLinkMsgPackUtils socketBufferSize;
		timeout: JSLinkMsgPackUtils socketStreamTimeout
]

{ #category : #private }
JSLinkMsgPackSocketStream >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : #private }
JSLinkMsgPackSocketStream >> socketStreamTimeout [
	^ 30
]
