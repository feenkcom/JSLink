Class {
	#name : #JSLinkMessageHandler,
	#superclass : #Object,
	#instVars : [
		'message',
		'callback'
	],
	#category : #'JSLink-Platform'
}

{ #category : #'as yet unclassified' }
JSLinkMessageHandler class >> forMessage: msg callback: block [
	^ (self handlerClassForMessage: msg) new
		message: msg;
		callback: block;
		yourself
]

{ #category : #'as yet unclassified' }
JSLinkMessageHandler class >> handlerClassForMessage: msg [
	^ msg isSync
		ifTrue: [ JSLinkSyncMessageHandler ]
		ifFalse: [ JSLinkAsyncMessageHandler ]
]

{ #category : #accessing }
JSLinkMessageHandler >> callback [
	^ callback
]

{ #category : #accessing }
JSLinkMessageHandler >> callback: anObject [
	callback := anObject
]

{ #category : #accessing }
JSLinkMessageHandler >> handleMessage [
	callback value: message
]

{ #category : #accessing }
JSLinkMessageHandler >> message [
	^ message
]

{ #category : #accessing }
JSLinkMessageHandler >> message: anObject [
	message := anObject
]

{ #category : #asserting }
JSLinkMessageHandler >> shouldAnswer [
	^ false
]
