Class {
	#name : #LanguageLinkMapper,
	#superclass : #Object,
	#instVars : [
		'mappings',
		'serializerWrapper',
		'executionHandler',
		'application'
	],
	#category : #'JSLink-Serialization'
}

{ #category : #'as yet unclassified' }
LanguageLinkMapper class >> mappings: mappings executionHandler: handler [
	^ self new
			mappings: mappings;
			executionHandler: handler;
			yourself
]

{ #category : #accessing }
LanguageLinkMapper >> application [
	^ executionHandler application
]

{ #category : #accessing }
LanguageLinkMapper >> application: anObject [
	application := anObject
]

{ #category : #accessing }
LanguageLinkMapper >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
LanguageLinkMapper >> executionHandler: anObject [

	executionHandler := anObject.
	serializerWrapper := self application settings messageBrokerStrategy serializer
]

{ #category : #accessing }
LanguageLinkMapper >> mappings [
	^ mappings
]

{ #category : #accessing }
LanguageLinkMapper >> mappings: anObject [
	mappings := anObject
]

{ #category : #accessing }
LanguageLinkMapper >> serializerWrapper: anObject [
	serializerWrapper := anObject
]
