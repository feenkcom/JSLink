Class {
	#name : #JSLinkApplicationTestResource,
	#superclass : #TestResource,
	#instVars : [
		'application',
		'commandFactory'
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

{ #category : #accessing }
JSLinkApplicationTestResource >> commandFactory [
	^ commandFactory
]

{ #category : #initialization }
JSLinkApplicationTestResource >> setUp [
	super setUp.
	application := JSLinkApplication new initializeWith: LanguageLinkSettings jsDefaultSettings.
	application start.
	commandFactory := application newCommandFactory.

]

{ #category : #initialization }
JSLinkApplicationTestResource >> tearDown [
	application stop.
	super tearDown.
]
