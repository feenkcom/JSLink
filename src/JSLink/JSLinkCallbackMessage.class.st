Class {
	#name : #JSLinkCallbackMessage,
	#superclass : #JSLinkRSyncMessage,
	#instVars : [
		'commandId',
		'observerId',
		'value'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkCallbackMessage class >> answerClass [
	^ JSLinkCallbackAnswer
]

{ #category : #accessing }
JSLinkCallbackMessage class >> type [
	^ #CALLBACK
]

{ #category : #accessing }
JSLinkCallbackMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
JSLinkCallbackMessage >> observerId [
	^ observerId
]

{ #category : #'as yet unclassified' }
JSLinkCallbackMessage >> privateDecode: dict [
	super privateDecode: dict.
	commandId := dict at: #commandId.
	observerId := dict at: #observerId.
	value := dict at: #value
]

{ #category : #accessing }
JSLinkCallbackMessage >> value [
	^ value
]
