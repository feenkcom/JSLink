Class {
	#name : #JSLinkObserver,
	#superclass : #Object,
	#traits : 'JSGCallable',
	#classTraits : 'JSGCallable classTrait',
	#instVars : [
		'id',
		'callback',
		'command'
	],
	#category : #'JSLink-Execution'
}

{ #category : #accessing }
JSLinkObserver class >> callback: aBlock [
	^ self new
		callback: aBlock;
		yourself
]

{ #category : #call }
JSLinkObserver >> callWith: anArrayOrADictionary [
	^ anArrayOrADictionary jsgCallArgumentsOf: self
]

{ #category : #call }
JSLinkObserver >> callWith: anArray with: aDictionary [
	^ JSGCall target: self positionalArguments: anArray keywordArguments: aDictionary
]

{ #category : #accessing }
JSLinkObserver >> callback [
	^ callback
]

{ #category : #accessing }
JSLinkObserver >> callback: anObject [
	callback := anObject
]

{ #category : #accessing }
JSLinkObserver >> command [
	^ command
]

{ #category : #accessing }
JSLinkObserver >> command: anObject [
	command := anObject
]

{ #category : #accessing }
JSLinkObserver >> id [
	^ id
]

{ #category : #initialization }
JSLinkObserver >> initialize [
	super initialize.
	id := JSLinkUtils newVariableName
]

{ #category : #testing }
JSLinkObserver >> isJavaScriptGenerable [
	^ true
]

{ #category : #testing }
JSLinkObserver >> isLanguageLinkValue [
	^ true
]

{ #category : #'error handling' }
JSLinkObserver >> javaScriptNotify [
	^ self javaScriptNotify: nil
]

{ #category : #'error handling' }
JSLinkObserver >> javaScriptNotify: anObject [
	^ (self callWith: (Array with: anObject))
		await: true;
		yourself
]

{ #category : #'error handling' }
JSLinkObserver >> pharoNotify: anObject [
	^ callback cull: anObject
]

{ #category : #testing }
JSLinkObserver >> writeLinkLanguageOn: aStream [
	(#observer asJSGI callWith: (Array 
											with: self command id
											with: self id)) writeLinkLanguageOn: aStream
]
