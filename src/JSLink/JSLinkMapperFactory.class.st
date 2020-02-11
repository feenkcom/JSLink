Class {
	#name : #JSLinkMapperFactory,
	#superclass : #Object,
	#instVars : [
		'executionHandler',
		'serializationMappings',
		'deserializationMappings'
	],
	#category : #'JSLink-Serialization'
}

{ #category : #'as yet unclassified' }
JSLinkMapperFactory class >> forExecutionHandler: handler [
	^ self new
		executionHandler: handler;
		yourself
]

{ #category : #initialization }
JSLinkMapperFactory >> deserializer [
	^ self deserializerClass
				mappings: serializationMappings
				executionHandler: executionHandler
]

{ #category : #initialization }
JSLinkMapperFactory >> deserializerClass [
	^ JSLinkDeserializer
]

{ #category : #accessing }
JSLinkMapperFactory >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
JSLinkMapperFactory >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #initialization }
JSLinkMapperFactory >> initialize [
	super initialize.
	serializationMappings := OrderedCollection new.
	deserializationMappings := OrderedCollection new 
]

{ #category : #initialization }
JSLinkMapperFactory >> serializer [
	^ self serializerClass 
				mappings: serializationMappings
				executionHandler: executionHandler
]

{ #category : #initialization }
JSLinkMapperFactory >> serializerClass [
	^ JSLinkSerializer
]
