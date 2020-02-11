Class {
	#name : #JSLinkStubMessage,
	#superclass : #JSLinkSyncMessage,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkStubMessage class >> answerClass [
	^ JSLinkStubAnswer
]

{ #category : #accessing }
JSLinkStubMessage class >> type [
	^ #STUB
]

{ #category : #accessing }
JSLinkStubMessage >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
JSLinkStubMessage >> ivar1: anObject [
	ivar1 := anObject
]

{ #category : #accessing }
JSLinkStubMessage >> ivar2 [
	^ ivar2
]

{ #category : #accessing }
JSLinkStubMessage >> ivar2: anObject [
	ivar2 := anObject
]

{ #category : #encode }
JSLinkStubMessage >> privateEncode: aDict [
	super privateEncode: aDict.
	aDict at: #ivar1 put: ivar1.
	aDict at: #ivar2f put: ivar2 first.
	aDict at: #ivar2r put: ivar2 allButFirst.
]
