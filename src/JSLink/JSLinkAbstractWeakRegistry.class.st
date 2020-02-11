Class {
	#name : #JSLinkAbstractWeakRegistry,
	#superclass : #Object,
	#category : #'JSLink-Platform'
}

{ #category : #'as yet unclassified' }
JSLinkAbstractWeakRegistry >> destroy [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
JSLinkAbstractWeakRegistry >> registerObject: anObject finalizer: finalizer [
	self subclassResponsibility
]
