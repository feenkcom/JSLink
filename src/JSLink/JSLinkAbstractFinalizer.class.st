Class {
	#name : #JSLinkAbstractFinalizer,
	#superclass : #Object,
	#category : #'JSLink-Platform'
}

{ #category : #finalization }
JSLinkAbstractFinalizer >> finalize [
	self subclassResponsibility
]
