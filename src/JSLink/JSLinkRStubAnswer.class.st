Class {
	#name : #JSLinkRStubAnswer,
	#superclass : #JSLinkRAnswer,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkRStubAnswer >> ivar1: anObject [
	ivar1 := anObject
]

{ #category : #accessing }
JSLinkRStubAnswer >> ivar2: anObject [
	ivar2 := anObject
]

{ #category : #encoding }
JSLinkRStubAnswer >> privateEncode: dict [
	super privateEncode: dict.
	dict at: #ivar1 put: ivar1.
	dict at: #ivar2f put: ivar2 first.
	dict at: #ivar2r put: ivar2 allButFirst.
]
