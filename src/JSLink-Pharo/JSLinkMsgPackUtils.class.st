Class {
	#name : 'JSLinkMsgPackUtils',
	#superclass : 'Object',
	#category : 'JSLink-Pharo-MessageBroker'
}

{ #category : 'constants' }
JSLinkMsgPackUtils class >> listenBacklogSize [
	"Server socket backlog size (number of pending connection waiting to be accepted)"
	
	^ 32
]

{ #category : 'socket creation' }
JSLinkMsgPackUtils class >> openConnectionToHost: address port: port [
	| stream |
	stream := SocketStream openConnectionToHost: address port: port.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : 'socket creation' }
JSLinkMsgPackUtils class >> primStreamFromSocket: aSocket [
	| stream |
	stream := SocketStream on: aSocket.
	self setReferenceSocketStreamOptions: stream.
	^ stream
]

{ #category : 'private' }
JSLinkMsgPackUtils class >> setReferenceSocketStreamOptions: stream [
	stream
		binary;
		shouldSignal: true;
		autoFlush: true;
		bufferSize: JSLinkMsgPackUtils socketBufferSize;
		timeout: JSLinkMsgPackUtils socketStreamTimeout
]

{ #category : 'constants' }
JSLinkMsgPackUtils class >> socketBufferSize [
	"Size in bytes for Sockets and SocketStream IO buffers"

	^ 4096
]

{ #category : 'constants' }
JSLinkMsgPackUtils class >> socketStreamTimeout [
	"Slightly less than a year. In other words, this socket doesn't timeout"
	^ 30000000
]
