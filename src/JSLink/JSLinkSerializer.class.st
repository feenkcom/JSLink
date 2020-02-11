Class {
	#name : #JSLinkSerializer,
	#superclass : #JSLinkMapper,
	#category : #'JSLink-Serialization'
}

{ #category : #private }
JSLinkSerializer class >> deserialize: anObject [
	^ JSLinkDeserializer deserialize: anObject
]

{ #category : #private }
JSLinkSerializer class >> deserialize: anObject forApplication: application [
	^ JSLinkDeserializer deserialize: anObject forApplication: application
]

{ #category : #private }
JSLinkSerializer class >> serialize: anObject [
	^ self new
		serialize: anObject
]

{ #category : #api }
JSLinkSerializer >> serialize: anObject [
	^ serializerWrapper serialize: anObject
]
