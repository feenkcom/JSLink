Class {
	#name : #JSLinkErrorMessage,
	#superclass : #JSLinkRSyncMessage,
	#instVars : [
		'commandId',
		'errorMessage',
		'trace'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkErrorMessage class >> answerClass [
	^ JSLinkErrorAnswer
]

{ #category : #accessing }
JSLinkErrorMessage class >> type [
	^ #ERR
]

{ #category : #accessing }
JSLinkErrorMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
JSLinkErrorMessage >> commandId: anObject [
	commandId := anObject
]

{ #category : #accessing }
JSLinkErrorMessage >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
JSLinkErrorMessage >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #'as yet unclassified' }
JSLinkErrorMessage >> privateDecode: dict [
	super privateDecode: dict.
	commandId := dict at: #commandId.
	errorMessage := dict at: #errMsg.
	trace := dict at: #trace
]

{ #category : #accessing }
JSLinkErrorMessage >> trace [
	^ trace
]

{ #category : #accessing }
JSLinkErrorMessage >> trace: anObject [
	trace := anObject
]
