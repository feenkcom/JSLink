Class {
	#name : #JSLinkJsonSerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'serializer'
	],
	#category : #'JSLink-Platform'
}

{ #category : #testing }
JSLinkJsonSerializerTest class >> isAbstract [
	^ self == JSLinkJsonSerializerTest
]

{ #category : #asserting }
JSLinkJsonSerializerTest >> assertDeserialize: aString equals: anObject [
	self assert: (serializer deserialize: aString) equals: anObject
]

{ #category : #asserting }
JSLinkJsonSerializerTest >> assertSerialize: anObject equals: aString [
	self assert: (serializer serialize: anObject) equals: aString
]

{ #category : #running }
JSLinkJsonSerializerTest >> jsonSerializerClass [
	self subclassResponsibility
]

{ #category : #running }
JSLinkJsonSerializerTest >> setUp [
	super setUp.
	serializer := self jsonSerializerClass new
]

{ #category : #tests }
JSLinkJsonSerializerTest >> testDeserializeArray [
	self assertDeserialize: '[33,"foo"]' equals: #(33 'foo')
]

{ #category : #tests }
JSLinkJsonSerializerTest >> testDeserializeNestedArrays [
	self assertDeserialize: '[33,["foo","bar"]]' equals: #(33 #('foo' 'bar'))
]

{ #category : #tests }
JSLinkJsonSerializerTest >> testDeserializeNil [
	self assertDeserialize: 'null' equals: nil
]

{ #category : #tests }
JSLinkJsonSerializerTest >> testSerializeArray [
	self assertSerialize: #(33 'foo') equals: '[33,"foo"]'
]

{ #category : #tests }
JSLinkJsonSerializerTest >> testSerializeNestedArrays [
	self assertSerialize: #(33 #('foo' 'bar')) equals: '[33,["foo","bar"]]'
]

{ #category : #tests }
JSLinkJsonSerializerTest >> testSerializeNil [
	self assertSerialize: nil equals: 'null'
]
