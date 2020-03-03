Class {
	#name : #LanguageLinkDeserializer,
	#superclass : #LanguageLinkMapper,
	#category : #'JSLink-Serialization'
}

{ #category : #'private protocol' }
LanguageLinkDeserializer class >> deserialize: anObject [
	^ self new
		deserialize: anObject
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> application [
	^ self executionHandler application
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> buildProxyFor: rawObject [
	| proxy |
	proxy :=  JSLinkProxyObject 
					javaScriptClass: (rawObject at: #__jsclass__)
					var: (rawObject at: #__registryid__) asJSGI
					application: self application.
	self executionHandler registerObject: proxy.
	^ proxy
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> deserialize: str [
	^ self privateDeserialize: (serializerWrapper deserialize: str).
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> objectRegistry [
	^ self executionHandler objectRegistry
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> privateDeserialize: rawObj [
	rawObj isCollection ifFalse: [ ^ rawObj ].
	rawObj isDictionary and: [ (rawObj includesKey: #__registryid__) 
		ifTrue: [ ^ self reifyProxyFor: rawObj ] ].
	^ rawObj collect: [ :elem | self privateDeserialize: elem ]
]

{ #category : #'private protocol' }
LanguageLinkDeserializer >> reifyProxyFor: rawObj [
	^ self objectRegistry resolve: (rawObj at: #__registryid__) ifAbsent: [ self buildProxyFor: rawObj ]
]
