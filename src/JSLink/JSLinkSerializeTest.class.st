Class {
	#name : #JSLinkSerializeTest,
	#superclass : #TestCase,
	#instVars : [
		'mapper'
	],
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkSerializeTest >> serializer [
	^ mapper serializer
			serializerWrapper: JSLinkPlatform current class httpMessageBrokerClass serializer;
			yourself
]

{ #category : #tests }
JSLinkSerializeTest >> setUp [
	super setUp.
	mapper := JSLinkMapperFactory forExecutionHandler: self
]

{ #category : #tests }
JSLinkSerializeTest >> testSerializeArray [
	self assert: (self serializer serialize: #(33 'foo')) equals: '[33,"foo"]'
]

{ #category : #tests }
JSLinkSerializeTest >> testSerializeNil [
	self assert: (self serializer serialize: nil) equals: 'null'
]
