Class {
	#name : #JSLinkDeserializer,
	#superclass : #JSLinkMapper,
	#category : #'JSLink-Serialization'
}

{ #category : #'private protocol' }
JSLinkDeserializer class >> deserialize: anObject [
	^ self new
		deserialize: anObject
]

{ #category : #'private protocol' }
JSLinkDeserializer >> application [
	^ self executionHandler application
]

{ #category : #'private protocol' }
JSLinkDeserializer >> buildProxyFor: rawObject [
	| proxy |
	proxy :=  JSLinkProxyObject 
					pythonClass: (rawObject at: #__pyclass__)
					pythonVar: (rawObject at: #__pyid__) asJSGI
					application: self application.
	self executionHandler registerObject: proxy.
	^ proxy
]

{ #category : #'private protocol' }
JSLinkDeserializer >> deserialize: str [
	^ self privateDeserialize: (serializerWrapper deserialize: str).
]

{ #category : #'private protocol' }
JSLinkDeserializer >> objectRegistry [
	^ self executionHandler objectRegistry
]

{ #category : #'private protocol' }
JSLinkDeserializer >> privateDeserialize: rawObj [
	rawObj isCollection ifFalse: [ ^ rawObj ].
	rawObj isDictionary and: [ (rawObj includesKey: #__pyid__) 
		ifTrue: [ ^ self reifyProxyFor: rawObj ] ].
	^ rawObj collect: [ :elem | self privateDeserialize: elem ]
]

{ #category : #'private protocol' }
JSLinkDeserializer >> reifyProxyFor: rawObj [
	^ self objectRegistry resolve: (rawObj at: #__pyid__) ifAbsent: [ self buildProxyFor: rawObj ]
]
