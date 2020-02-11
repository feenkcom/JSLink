Class {
	#name : #JSLinkIsAliveMessage,
	#superclass : #JSLinkSyncMessage,
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkIsAliveMessage class >> answerClass [
	^ JSLinkAnswer
]

{ #category : #accessing }
JSLinkIsAliveMessage class >> type [
	^ #IS_ALIVE
]
