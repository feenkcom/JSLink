Class {
	#name : #JSLinkSyncMessageHandler,
	#superclass : #JSLinkMessageHandler,
	#instVars : [
		'answer'
	],
	#category : #'JSLink-Platform'
}

{ #category : #accessing }
JSLinkSyncMessageHandler >> answer [
	^ answer
]

{ #category : #accessing }
JSLinkSyncMessageHandler >> handleMessage [
	answer := callback value: message.
	self assert: answer class = message answerClass.
]

{ #category : #asserting }
JSLinkSyncMessageHandler >> shouldAnswer [
	^ true
]
