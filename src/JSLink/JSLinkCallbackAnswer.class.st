Class {
	#name : #JSLinkCallbackAnswer,
	#superclass : #JSLinkRAnswer,
	#instVars : [
		'value'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #encoding }
JSLinkCallbackAnswer >> privateEncode: dict [
	super privateEncode: dict.
	dict at: #value put: value
]

{ #category : #accessing }
JSLinkCallbackAnswer >> value [
	^ value
]

{ #category : #accessing }
JSLinkCallbackAnswer >> value: anObject [
	value := anObject
]
