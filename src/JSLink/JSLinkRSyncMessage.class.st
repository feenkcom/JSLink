Class {
	#name : #JSLinkRSyncMessage,
	#superclass : #JSLinkRMessage,
	#instVars : [
		'syncId'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkRSyncMessage class >> answerClass [
	^ JSLinkRAnswer
]

{ #category : #accessing }
JSLinkRSyncMessage class >> type [
	^ #RSYNC
]

{ #category : #accessing }
JSLinkRSyncMessage >> answerClass [
	^ self class answerClass
]

{ #category : #accessing }
JSLinkRSyncMessage >> createAnswer [
	^ self answerClass answerFor: self
]

{ #category : #testing }
JSLinkRSyncMessage >> isSync [
	^ true
]

{ #category : #'as yet unclassified' }
JSLinkRSyncMessage >> privateDecode: dict [
	super privateDecode: dict.
	syncId := dict at: #__sync
]

{ #category : #accessing }
JSLinkRSyncMessage >> syncId [
	^ syncId
]
