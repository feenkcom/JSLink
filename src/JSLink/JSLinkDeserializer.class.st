Class {
	#name : #JSLinkDeserializer,
	#superclass : #LanguageLinkDeserializer,
	#category : #'JSLink-Serialization'
}

{ #category : #'private protocol' }
JSLinkDeserializer class >> deserialize: anObject [
	^ self new
		deserialize: anObject
]

{ #category : #'private protocol' }
JSLinkDeserializer >> buildProxyFor: rawObject [
	| proxy |
	proxy :=  JSLinkProxyObject 
					javaScriptClass: (rawObject at: #__jsclass__)
					var: (rawObject at: #__registryid__) asJSGI
					application: self application.
	self executionHandler registerObject: proxy.
	^ proxy
]
