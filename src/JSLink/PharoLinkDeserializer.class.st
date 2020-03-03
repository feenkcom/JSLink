Class {
	#name : #PharoLinkDeserializer,
	#superclass : #LanguageLinkDeserializer,
	#category : #'JSLink-Serialization'
}

{ #category : #'private protocol' }
PharoLinkDeserializer class >> deserialize: anObject [
	^ self new
		deserialize: anObject
]

{ #category : #'private protocol' }
PharoLinkDeserializer >> buildProxyFor: rawObject [
	| proxy |
	proxy :=  LanguageLinkProxyObject new
					remoteClass: (rawObject at: #__class__);
					name: (rawObject at: #__registryid__);
					application: self application.
	self executionHandler registerObject: proxy.
	^ proxy
]
