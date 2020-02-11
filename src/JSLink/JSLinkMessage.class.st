Class {
	#name : #JSLinkMessage,
	#superclass : #JSLinkAbstractMessage,
	#category : #'JSLink-Platform-Messages'
}

{ #category : #testing }
JSLinkMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ false
]

{ #category : #accessing }
JSLinkMessage class >> type [
	^ #MSG
]

{ #category : #encoding }
JSLinkMessage >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type. 
	self privateEncode: dict.
	^ dict
]

{ #category : #testing }
JSLinkMessage >> isSync [
	self subclassResponsibility
]

{ #category : #encoding }
JSLinkMessage >> privateEncode: dict [
]
