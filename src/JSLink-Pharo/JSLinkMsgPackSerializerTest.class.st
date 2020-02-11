Class {
	#name : #JSLinkMsgPackSerializerTest,
	#superclass : #TestCase,
	#instVars : [
		'serializer'
	],
	#category : #'JSLink-Pharo-MessageBroker'
}

{ #category : #tests }
JSLinkMsgPackSerializerTest >> assertDeserialize: aString equals: anObject [
	self assert: (serializer deserialize: aString) equals: anObject
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> assertSerialize: anObject equals: aString [
	self assert: (serializer serialize: anObject) equals: aString
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> setUp [
	super setUp.
	serializer := JSLinkMsgPackSerializer new
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> testDeserializeArray [
	self assertDeserialize: #[146 33 163 102 111 111] equals: #(33 'foo')
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> testDeserializeByteArray [
	self assertDeserialize: #[196 4 3 44 78 9] equals: #[3 44 78 9]
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> testDeserializeLargeString [
	self assertDeserialize: #[187 112 98 54 102 54 108 55 97 113 104 122 56 48 107 115 105 56 105 57 48 101 53 105 101 120 101 114] equals: 'pb6f6l7aqhz80ksi8i90e5iexer'
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> testDeserializeNestedArray [
	self assertDeserialize: #[146 33 146 163 102 111 111 163 98 97 114] equals: #(33 #('foo' 'bar'))
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> testDeserializeNil [
	self assertDeserialize: #[192] equals: nil
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> testSerializeLargeString [
	self assertSerialize: 'pb6f6l7aqhz80ksi8i90e5iexer' equals: #[218 0 27 112 98 54 102 54 108 55 97 113 104 122 56 48 107 115 105 56 105 57 48 101 53 105 101 120 101 114]
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> testSerializeNestedArrays [
	self assertSerialize: #(33 #('foo' 'bar')) equals: #[146 33 146 163 102 111 111 163 98 97 114]
]

{ #category : #tests }
JSLinkMsgPackSerializerTest >> testSmallInt [
	self assertSerialize: 33 equals: #[ 33 ]
]
