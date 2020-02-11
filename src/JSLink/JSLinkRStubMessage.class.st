Class {
	#name : #JSLinkRStubMessage,
	#superclass : #JSLinkRSyncMessage,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkRStubMessage class >> answerClass [
	^ JSLinkRStubAnswer
]

{ #category : #accessing }
JSLinkRStubMessage class >> type [
	^ #RSTUB
]

{ #category : #accessing }
JSLinkRStubMessage >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
JSLinkRStubMessage >> ivar2 [
	^ ivar2
]

{ #category : #'as yet unclassified' }
JSLinkRStubMessage >> privateDecode: dict [
	super privateDecode: dict.
	ivar1 := dict at: #ivar1.
	ivar2 := {dict at: #ivar2f} , (dict at: #ivar2r)
]
