Class {
	#name : #JSLinkMapper,
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
JSLinkMapper class >> mappings: mappings executionHandler: handler [
	^ self new
			mappings: mappings;
			executionHandler: handler;
			yourself
]

{ #category : #accessing }
JSLinkMapper >> application [
	^ executionHandler application
]

{ #category : #accessing }
JSLinkMapper >> application: anObject [
	application := anObject
]

{ #category : #accessing }
JSLinkMapper >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
JSLinkMapper >> executionHandler: anObject [

	executionHandler := anObject.
	serializerWrapper := self application settings messageBrokerStrategy serializer
]

{ #category : #accessing }
JSLinkMapper >> mappings [
	^ mappings
]

{ #category : #accessing }
JSLinkMapper >> mappings: anObject [
	mappings := anObject
]

{ #category : #accessing }
JSLinkMapper >> serializerWrapper: anObject [
	serializerWrapper := anObject
]
