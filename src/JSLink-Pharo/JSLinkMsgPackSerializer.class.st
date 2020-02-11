Class {
	#name : #JSLinkMsgPackSerializer,
	#superclass : #JSLinkAbstractSerializerWrapper,
	#category : #'JSLink-Pharo-MessageBroker'
}

{ #category : #private }
JSLinkMsgPackSerializer >> deserialize: aByteArray [
	^ MpDecoder decode: aByteArray
]

{ #category : #private }
JSLinkMsgPackSerializer >> serialize: anObject [
	^ MpEncoder encode: anObject
]
