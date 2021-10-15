Class {
	#name : #JSLinkMsgPackSerializer,
	#superclass : #LanguageLinkAbstractSerializerWrapper,
	#category : 'JSLink-Pharo-MessageBroker'
}

{ #category : #private }
JSLinkMsgPackSerializer >> deserialize: aByteArray [
	^ MpDecoder decode: aByteArray
]

{ #category : #private }
JSLinkMsgPackSerializer >> serialize: anObject [
	^ MpEncoder encode: anObject
]
