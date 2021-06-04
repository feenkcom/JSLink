"
This class contains tests

"
Class {
	#name : #JSLinkSerializeTest,
	#superclass : #JSLinkTestCase,
	#instVars : [
		'mapper'
	],
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkSerializeTest >> serializer [
	^ mapper serializer
			serializerWrapper: self application settings messageBrokerStrategy serializer;
			yourself
]

{ #category : #tests }
JSLinkSerializeTest >> setUp [
	super setUp.
	mapper := LanguageLinkMapperFactory forExecutionHandler: self application executionHandler
]

{ #category : #tests }
JSLinkSerializeTest >> testSerializeArray [
	self assert: (self serializer serialize: #(33 'foo')) equals: '[33,"foo"]'
]

{ #category : #tests }
JSLinkSerializeTest >> testSerializeNil [
	self assert: (self serializer serialize: nil) equals: 'null'
]
