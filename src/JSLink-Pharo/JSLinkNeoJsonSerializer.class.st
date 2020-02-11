Class {
	#name : #JSLinkNeoJsonSerializer,
	#superclass : #JSLinkAbstractSerializerWrapper,
	#category : #'JSLink-Pharo-MessageBroker'
}

{ #category : #private }
JSLinkNeoJsonSerializer >> deserialize: aString [
	^ NeoJSONReader fromString: aString
]

{ #category : #private }
JSLinkNeoJsonSerializer >> serialize: anObject [
	^ NeoJSONWriter toString: anObject
]
