Class {
	#name : #JSLinkApplicationTestResource,
	#superclass : #TestResource,
	#instVars : [
		'application'
	],
	#category : #'JSLink-Tests'
}

{ #category : #initialization }
JSLinkApplicationTestResource >> app [
	^ self application
]

{ #category : #initialization }
JSLinkApplicationTestResource >> application [
	^ application
]

{ #category : #initialization }
JSLinkApplicationTestResource >> applicationClass [
	^ JSLinkApplication
]

{ #category : #initialization }
JSLinkApplicationTestResource >> setUp [
	super setUp.
	self applicationClass stop.
	self applicationClass start.
	application := self applicationClass uniqueInstance
]

{ #category : #initialization }
JSLinkApplicationTestResource >> tearDown [
	self applicationClass stop.
	super tearDown.
]
