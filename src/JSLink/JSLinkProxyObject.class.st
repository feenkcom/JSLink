Class {
	#name : #JSLinkProxyObject,
	#superclass : #JSLinkObject,
	#instVars : [
		'pythonClass',
		'application'
	],
	#category : #'JSLink-Core'
}

{ #category : #'as yet unclassified' }
JSLinkProxyObject class >> pythonClass: pythonClass pythonVar: pyVar application: application [
	^ self new
		pythonVariable: pyVar;
		pythonClass: pythonClass;
		application: application;
		yourself
]

{ #category : #accessing }
JSLinkProxyObject >> application [
	^ application
]

{ #category : #accessing }
JSLinkProxyObject >> application: anObject [
	application := anObject
]

{ #category : #accessing }
JSLinkProxyObject >> applicationClass [
	^ self application class
]

{ #category : #hooks }
JSLinkProxyObject >> createObject [
	self shouldNotImplement
]

{ #category : #printing }
JSLinkProxyObject >> printOn: str [
	str 
		<< (pythonClass asString first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		<< pythonClass asString;
		<< ' (Proxy)'
]

{ #category : #accessing }
JSLinkProxyObject >> pythonClass [
	^ pythonClass
]

{ #category : #accessing }
JSLinkProxyObject >> pythonClass: anObject [
	pythonClass := anObject
]

{ #category : #accessing }
JSLinkProxyObject >> pythonVariable: pyVar [
	pythonVariable := pyVar
]
