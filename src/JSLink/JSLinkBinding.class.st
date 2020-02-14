Class {
	#name : #JSLinkBinding,
	#superclass : #Object,
	#instVars : [
		'object',
		'key'
	],
	#category : #'JSLink-Execution'
}

{ #category : #'instance creation' }
JSLinkBinding class >> key: aKey wrap: anObject [
	^ self new
		key: aKey;
		object: anObject;
		yourself
]

{ #category : #'instance creation' }
JSLinkBinding class >> wrap: anObject [
	^ self new
		object: anObject;
		yourself
]

{ #category : #initialization }
JSLinkBinding >> initialize [
	super initialize.
	key := JSLinkUtils newP3VariableName
]

{ #category : #testing }
JSLinkBinding >> isJavaScriptGenerable [
	^ true
]

{ #category : #testing }
JSLinkBinding >> isJavaScriptValue [
	^ true
]

{ #category : #'instance creation' }
JSLinkBinding >> javaScriptVariable [
	^ key asJSGI
]

{ #category : #accessing }
JSLinkBinding >> key [
	^ key
]

{ #category : #accessing }
JSLinkBinding >> key: anObject [
	key := anObject
]

{ #category : #accessing }
JSLinkBinding >> object [
	^ object
]

{ #category : #accessing }
JSLinkBinding >> object: anObject [
	object := anObject
]

{ #category : #testing }
JSLinkBinding >> writeJavaScriptOn: aStream [
	self javaScriptVariable writeJavaScriptOn: aStream
]
