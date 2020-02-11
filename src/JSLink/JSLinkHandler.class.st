Class {
	#name : #JSLinkHandler,
	#superclass : #Object,
	#instVars : [
		'application'
	],
	#category : #'JSLink-Core'
}

{ #category : #'as yet unclassified' }
JSLinkHandler class >> application: anApplication [
	^ self new
		application: anApplication;
		initializeHandler;
		yourself
]

{ #category : #accessing }
JSLinkHandler >> application [
	^ application
]

{ #category : #accessing }
JSLinkHandler >> application: anObject [
	application := anObject
]

{ #category : #initialization }
JSLinkHandler >> initializeHandler [
]

{ #category : #testing }
JSLinkHandler >> isRunning [
	^ true
]

{ #category : #accessing }
JSLinkHandler >> start [
]

{ #category : #accessing }
JSLinkHandler >> stop [
]
