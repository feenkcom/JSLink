Class {
	#name : #JSLinkAbstractSerializerWrapper,
	#superclass : #Object,
	#category : #'JSLink-Platform'
}

{ #category : #private }
JSLinkAbstractSerializerWrapper >> deserialize: aString [
	self subclassResponsibility
]

{ #category : #private }
JSLinkAbstractSerializerWrapper >> serialize: anObject [
	self subclassResponsibility
]
