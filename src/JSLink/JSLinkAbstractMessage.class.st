Class {
	#name : #JSLinkAbstractMessage,
	#superclass : #Object,
	#category : #'JSLink-Platform-Messages'
}

{ #category : #testing }
JSLinkAbstractMessage class >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkAbstractMessage class >> type [
	self subclassResponsibility
]

{ #category : #testing }
JSLinkAbstractMessage >> isReverseMessage [
	"Reverse messages corresponds to messages that start on Python to Pharo. In other words
	in reverse direction from normal messages."
	^ self class isReverseMessage
]

{ #category : #accessing }
JSLinkAbstractMessage >> type [
	^ self class type
]
