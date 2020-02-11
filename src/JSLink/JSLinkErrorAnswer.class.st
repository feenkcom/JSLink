Class {
	#name : #JSLinkErrorAnswer,
	#superclass : #JSLinkRAnswer,
	#instVars : [
		'handlingAction'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkErrorAnswer >> handlingAction [
	^ handlingAction
]

{ #category : #accessing }
JSLinkErrorAnswer >> handlingAction: anObject [
	handlingAction := anObject
]

{ #category : #encoding }
JSLinkErrorAnswer >> privateEncode: dict [
	super privateEncode: dict.
	dict at: #action put: handlingAction encodeAsDictionary
]
