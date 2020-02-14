Class {
	#name : #JSLinkAbstractProcess,
	#superclass : #Object,
	#instVars : [
		'pythonMainFile',
		'debugMode',
		'settings',
		'workingDirectory'
	],
	#category : #'JSLink-Platform'
}

{ #category : #accessing }
JSLinkAbstractProcess class >> application: application [
	^ self 
		settings: application settings 
		application: application
]

{ #category : #accessing }
JSLinkAbstractProcess class >> platform [
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkAbstractProcess class >> settings: settings application: application [
	^ self 
		settings: settings 
		workingDirectory: (JSLinkPlatform current folderForApplication: application)
		debugMode: application class debugMode
]

{ #category : #accessing }
JSLinkAbstractProcess class >> settings: settings workingDirectory: fileRef [
	^ self new
		settings: settings;
		workingDirectory: fileRef;
		yourself
]

{ #category : #accessing }
JSLinkAbstractProcess class >> settings: settings workingDirectory: fileRef debugMode: flag [
	^ self new
		settings: settings;
		workingDirectory: fileRef;
		debugMode: flag;
		yourself
]

{ #category : #hooks }
JSLinkAbstractProcess class >> workingDirectory [
	^ self platform folderForApplication: JSLinkApplication
]

{ #category : #accessing }
JSLinkAbstractProcess >> debugMode [
	^ debugMode
]

{ #category : #accessing }
JSLinkAbstractProcess >> debugMode: anObject [
	debugMode := anObject
]

{ #category : #accessing }
JSLinkAbstractProcess >> errorMessage [
	self subclassResponsibility
]

{ #category : #initialization }
JSLinkAbstractProcess >> initialize [
	super initialize.
	debugMode := false
]

{ #category : #testing }
JSLinkAbstractProcess >> isRunning [
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkAbstractProcess >> javaScriptMainFile [
	^ pythonMainFile ifNil: [ self workingDirectory / 'start_bridge.py' ]
]

{ #category : #accessing }
JSLinkAbstractProcess >> javaScriptMainFile: anObject [
	pythonMainFile := anObject
]

{ #category : #accessing }
JSLinkAbstractProcess >> settings [
	^ settings
]

{ #category : #accessing }
JSLinkAbstractProcess >> settings: anObject [
	settings := anObject
]

{ #category : #'start-stop' }
JSLinkAbstractProcess >> start [
	self subclassResponsibility
]

{ #category : #'start-stop' }
JSLinkAbstractProcess >> stop [
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkAbstractProcess >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
JSLinkAbstractProcess >> workingDirectory: anObject [
	workingDirectory := anObject
]
