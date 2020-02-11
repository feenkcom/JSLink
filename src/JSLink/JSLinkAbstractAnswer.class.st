Class {
	#name : #JSLinkAbstractAnswer,
	#superclass : #Object,
	#instVars : [
		'message'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #'instance creation' }
JSLinkAbstractAnswer class >> answerFor: aMessage [
	^ self new
		message: aMessage;
		yourself
]

{ #category : #accessing }
JSLinkAbstractAnswer >> message [
	^ message
]

{ #category : #accessing }
JSLinkAbstractAnswer >> message: anObject [
	message := anObject
]

{ #category : #accessing }
JSLinkAbstractAnswer >> type [
	^ message type
]
