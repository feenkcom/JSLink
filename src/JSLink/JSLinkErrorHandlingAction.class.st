Class {
	#name : #JSLinkErrorHandlingAction,
	#superclass : #Object,
	#category : #'JSLink-ErrorHandling'
}

{ #category : #'as yet unclassified' }
JSLinkErrorHandlingAction >> actionSymbol [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
JSLinkErrorHandlingAction >> encodeAsDictionary [
	^ { #action -> self actionSymbol } asDictionary
]
