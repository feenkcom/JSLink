"
This class contains tests

"
Class {
	#name : #JSLinkSerializationTest,
	#superclass : #JSLinkApplicationTest,
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkSerializationTest >> testSendAndRetrieveFloat [
	self cf << 2.2.
	self cfSend.
	self assert: promise waitForValue equals: 2.2.
]

{ #category : #tests }
JSLinkSerializationTest >> testSendAndRetrieveInteger [
	self cf << 2.
	self cfSend.
	self assert: promise waitForValue equals: 2.
]

{ #category : #tests }
JSLinkSerializationTest >> testSendAndRetrieveNil [
	self cf << nil.
	self cfSend.
	self assert: promise waitForValue equals: nil
]
