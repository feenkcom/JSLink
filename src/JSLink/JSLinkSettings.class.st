Class {
	#name : #JSLinkSettings,
	#superclass : #Object,
	#instVars : [
		'pharoSocketAddress',
		'pythonSocketAddress'
	],
	#category : #'JSLink-Platform'
}

{ #category : #'as yet unclassified' }
JSLinkSettings class >> pharoSocketAddress: pharoSocketAddress pythonSocketAddress: pythonSocketAddress [
	^ self new
		pharoSocketAddress: pharoSocketAddress;
		pythonSocketAddress: pythonSocketAddress;
		yourself
]

{ #category : #accessing }
JSLinkSettings >> pharoSocketAddress [
	^ pharoSocketAddress
]

{ #category : #accessing }
JSLinkSettings >> pharoSocketAddress: anObject [
	pharoSocketAddress := anObject
]

{ #category : #accessing }
JSLinkSettings >> pythonSocketAddress [
	^ pythonSocketAddress
]

{ #category : #accessing }
JSLinkSettings >> pythonSocketAddress: anObject [
	pythonSocketAddress := anObject
]
