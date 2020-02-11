Class {
	#name : #JSLinkSyncMessage,
	#superclass : #JSLinkMessage,
	#instVars : [
		'syncId'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkSyncMessage class >> answerClass [
	^ JSLinkAnswer
]

{ #category : #accessing }
JSLinkSyncMessage class >> type [
	^ #SYNC
]

{ #category : #accessing }
JSLinkSyncMessage >> answerClass [
	^ self class answerClass
]

{ #category : #accessing }
JSLinkSyncMessage >> createAnswer [
	^ self answerClass answerFor: self
]

{ #category : #initialization }
JSLinkSyncMessage >> initialize [
	super initialize.
	syncId := JSLinkPlatform current newRandomName
]

{ #category : #testing }
JSLinkSyncMessage >> isSync [
	^ true
]

{ #category : #writing }
JSLinkSyncMessage >> privateEncode: aDict [
	super privateEncode: aDict.
	aDict at: #__sync put: self syncId
]

{ #category : #writing }
JSLinkSyncMessage >> syncId [
	^ syncId
]
