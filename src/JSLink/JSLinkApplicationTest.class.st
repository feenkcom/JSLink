Class {
	#name : #JSLinkApplicationTest,
	#superclass : #JSLinkTestCase,
	#category : #'JSLink-Tests'
}

{ #category : #accessing }
JSLinkApplicationTest class >> appResource [
	^ JSLinkApplicationTestResource
]

{ #category : #initialization }
JSLinkApplicationTest >> applicationClass [
	^ JSLinkApplication
]
