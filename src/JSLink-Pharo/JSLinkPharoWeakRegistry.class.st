Class {
	#name : #JSLinkPharoWeakRegistry,
	#superclass : #JSLinkAbstractWeakRegistry,
	#instVars : [
		'weakRegistry'
	],
	#category : #'JSLink-Pharo-Platform'
}

{ #category : #'as yet unclassified' }
JSLinkPharoWeakRegistry >> destroy [
	weakRegistry removeAll
]

{ #category : #initialization }
JSLinkPharoWeakRegistry >> initialize [
	super initialize.
	weakRegistry := WeakRegistry new.
]

{ #category : #'as yet unclassified' }
JSLinkPharoWeakRegistry >> registerObject: anObject finalizer: finalizer [
	weakRegistry 
		add: anObject
		executor: finalizer
]
