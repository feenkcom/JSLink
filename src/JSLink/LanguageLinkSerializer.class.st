Class {
	#name : #LanguageLinkSerializer,
	#superclass : #LanguageLinkMapper,
	#category : #'JSLink-Serialization'
}

{ #category : #private }
LanguageLinkSerializer class >> deserialize: anObject [
	^ JSLinkDeserializer deserialize: anObject
]

{ #category : #private }
LanguageLinkSerializer class >> deserialize: anObject forApplication: application [
	^ JSLinkDeserializer deserialize: anObject forApplication: application
]

{ #category : #private }
LanguageLinkSerializer class >> serialize: anObject [
	^ self new
		serialize: anObject
]

{ #category : #api }
LanguageLinkSerializer >> serialize: anObject [
	^ serializerWrapper serialize: anObject
]
