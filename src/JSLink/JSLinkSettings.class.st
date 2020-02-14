Class {
	#name : #JSLinkSettings,
	#superclass : #Object,
	#instVars : [
		'pharoSocketAddress',
		'pythonSocketAddress'
	],
	#category : #'JSLink-Platform'
}

{ #category : #'instance creation' }
JSLinkSettings class >> pharoSocketAddress: pharoSocketAddress javaScriptSocketAddress: pythonSocketAddress [
	^ self new
		pharoSocketAddress: pharoSocketAddress;
		javaScriptSocketAddress: pythonSocketAddress;
		yourself
]

{ #category : #accessing }
JSLinkSettings >> javaScriptSocketAddress [
	^ pythonSocketAddress
]

{ #category : #accessing }
JSLinkSettings >> javaScriptSocketAddress: anObject [
	pythonSocketAddress := anObject
]

{ #category : #accessing }
JSLinkSettings >> pharoSocketAddress [
	^ pharoSocketAddress
]

{ #category : #accessing }
JSLinkSettings >> pharoSocketAddress: anObject [
	pharoSocketAddress := anObject
]
