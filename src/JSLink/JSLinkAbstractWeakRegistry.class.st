Class {
	#name : #JSLinkAbstractWeakRegistry,
	#superclass : #Object,
	#category : #'JSLink-Platform'
}

{ #category : #registration }
JSLinkAbstractWeakRegistry >> destroy [
	self subclassResponsibility
]

{ #category : #registration }
JSLinkAbstractWeakRegistry >> registerObject: anObject finalizer: finalizer [
	self subclassResponsibility
]
