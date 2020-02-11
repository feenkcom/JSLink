Class {
	#name : #JSLinkRMessage,
	#superclass : #JSLinkAbstractMessage,
	#category : #'JSLink-Platform-Messages'
}

{ #category : #actions }
JSLinkRMessage class >> decodeFrom: aDict [
	^ self new
		privateDecode: aDict;
		yourself
]

{ #category : #testing }
JSLinkRMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ true
]

{ #category : #accessing }
JSLinkRMessage class >> type [
	^ #RMSG
]

{ #category : #'as yet unclassified' }
JSLinkRMessage >> privateDecode: aDict [
]
