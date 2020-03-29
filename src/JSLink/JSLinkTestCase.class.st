Class {
	#name : #JSLinkTestCase,
	#superclass : #LanguageLinkTestCase,
	#category : #'JSLink-Tests'
}

{ #category : #running }
JSLinkTestCase >> setUp [
	super setUp.
	application := JSLinkApplication newWith: LanguageLinkSettings jsDefaultSettings.
	commandFactory := application newCommandFactory.
	self cf reset.
]
