Class {
	#name : #JSLinkBinding,
	#superclass : #LanguageLinkBinding,
	#category : #'JSLink-Execution'
}

{ #category : #testing }
JSLinkBinding >> isJavaScriptGenerable [
	^ true
]

{ #category : #'instance creation' }
JSLinkBinding >> javaScriptVariable [
	^ key asJSGI
]

{ #category : #testing }
JSLinkBinding >> writeLinkLanguageOn: aStream [
	self javaScriptVariable writeLinkLanguageOn: aStream
]
