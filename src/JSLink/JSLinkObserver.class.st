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
	id := JSLinkUtils newP3VariableName
]

{ #category : #testing }
JSLinkObserver >> isJavaScriptValue [
	^ true
]

{ #category : #testing }
JSLinkObserver >> isPythonGenerable [
	^ true
]

{ #category : #'error handling' }
JSLinkObserver >> pharoNotify: anObject [
	^ callback cull: anObject
]

{ #category : #'error handling' }
JSLinkObserver >> pythonNotify [
	^ self pythonNotify: nil
]

{ #category : #'error handling' }
JSLinkObserver >> pythonNotify: anObject [
	^ (self callWith: (Array with: anObject))
		await: true;
		yourself
]

{ #category : #testing }
JSLinkObserver >> writeJavaScriptOn: aStream [
	(#observer asJSGI callWith: (Array 
											with: self command id
											with: self id)) writeJavaScriptOn: aStream
]
