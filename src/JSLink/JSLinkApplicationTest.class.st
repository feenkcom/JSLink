Class {
	#name : #JSLinkApplicationTest,
	#superclass : #JSLinkTestCase,
	#category : #'JSLink-Tests'
}

{ #category : #accessing }
JSLinkApplicationTest class >> resources [
	^ super resources , { JSLinkApplicationTestResource. }
]

{ #category : #running }
JSLinkApplicationTest >> setUp [ 
	"Subclasses of JSLinkApplicationTest require a running server"

	super setUp.
	application := self class appResource current application.
	commandFactory := self class appResource current commandFactory.
]
