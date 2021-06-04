"
This class contains tests

"
Class {
	#name : #JSLinkDeserializeTest,
	#superclass : #JSLinkTestCase,
	#instVars : [
		'mapper'
	],
	#category : #'JSLink-Tests'
}

{ #category : #running }
JSLinkDeserializeTest >> deserialize: anObject [
	^ self deserializer deserialize: anObject
]

{ #category : #running }
JSLinkDeserializeTest >> deserializer [
	^ mapper deserializer
			serializerWrapper: self application settings messageBrokerStrategy serializer;
			yourself
]

{ #category : #running }
JSLinkDeserializeTest >> setUp [

	super setUp.
	mapper := LanguageLinkMapperFactory forExecutionHandler: self application executionHandler
]

{ #category : #running }
JSLinkDeserializeTest >> stubExecutionHandler [
	^ JSLinkExecutionHandler new
			application: self application;
			yourself
]

{ #category : #tests }
JSLinkDeserializeTest >> testDeserializeArray [
	self assert: (self deserialize: '[33,"foo"]') equals: #(33 'foo')
]

{ #category : #tests }
JSLinkDeserializeTest >> testDeserializeNull [
	self assert: (self deserialize: 'null') equals: nil
]

{ #category : #tests }
JSLinkDeserializeTest >> testDeserializeProxy [
	| proxy |
	proxy := self deserialize: '{"__jsclass__":"MyClass","__registryid__":"abcde12345"}'.
	self assert: proxy javaScriptClass equals: #MyClass.
	self assert: proxy application equals: self deserializer application.
	self assert: proxy javaScriptVariable equals: 'abcde12345' asJSGI
]

{ #category : #tests }
JSLinkDeserializeTest >> testDeserializeProxyInArray [
	| proxy arr |
	arr := self deserialize: '[{"__jsclass__":"MyClass","__registryid__":"abcde12345"}]'.
	self assert: arr size equals: 1.
	proxy := arr first.
	self assert: proxy javaScriptClass equals: #MyClass.
	self assert: proxy application equals: self deserializer application.
	self assert: proxy javaScriptVariable equals: 'abcde12345' asJSGI
]
