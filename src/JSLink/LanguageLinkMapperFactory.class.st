Class {
	#name : #LanguageLinkMapperFactory,
	#superclass : #Object,
	#instVars : [
		'executionHandler',
		'serializationMappings',
		'deserializationMappings',
		'serializerClass',
		'deserializerClass'
	],
	#category : #'JSLink-Serialization'
}

{ #category : #'as yet unclassified' }
LanguageLinkMapperFactory class >> forExecutionHandler: handler [
	^ self new
		executionHandler: handler;
		yourself
]

{ #category : #initialization }
LanguageLinkMapperFactory >> deserializer [
	^ deserializerClass
				mappings: serializationMappings
				executionHandler: executionHandler
]

{ #category : #accessing }
LanguageLinkMapperFactory >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
LanguageLinkMapperFactory >> executionHandler: anObject [

	executionHandler := anObject.
	serializerClass := self settings serializerClass.
	deserializerClass := self settings deserializerClass.
]

{ #category : #initialization }
LanguageLinkMapperFactory >> initialize [
	super initialize.
	serializationMappings := OrderedCollection new.
	deserializationMappings := OrderedCollection new 
]

{ #category : #initialization }
LanguageLinkMapperFactory >> serializer [
	^ serializerClass 
				mappings: serializationMappings
				executionHandler: executionHandler
]

{ #category : #accessing }
LanguageLinkMapperFactory >> settings [ 

	^ executionHandler settings
]
