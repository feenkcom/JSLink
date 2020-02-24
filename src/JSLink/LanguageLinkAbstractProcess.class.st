Class {
	#name : #LanguageLinkAbstractProcess,
	#superclass : #Object,
	#instVars : [
		'settings',
		'workingDirectory'
	],
	#category : #'JSLink-Platform'
}

{ #category : #accessing }
LanguageLinkAbstractProcess class >> application: application [
	^ self new
		settings: application settings;
		workingDirectory: (application settings platform folderForApplication: application);
		yourself
]

{ #category : #accessing }
LanguageLinkAbstractProcess class >> platform [
	self subclassResponsibility
]

{ #category : #accessing }
LanguageLinkAbstractProcess class >> settings: settings application: application [
	^ self 
		settings: settings 
		workingDirectory: (JSLinkPlatform current folderForApplication: application)
		debugMode: application class debugMode
]

{ #category : #accessing }
LanguageLinkAbstractProcess class >> settings: settings workingDirectory: fileRef [
	^ self new
		settings: settings;
		workingDirectory: fileRef;
		yourself
]

{ #category : #accessing }
LanguageLinkAbstractProcess class >> settings: settings workingDirectory: fileRef debugMode: flag [
	^ self new
		settings: settings;
		workingDirectory: fileRef;
		debugMode: flag;
		yourself
]

{ #category : #hooks }
LanguageLinkAbstractProcess class >> workingDirectory [
	^ self platform folderForApplication: JSLinkApplication
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> debugMode [

	^ settings debugMode
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> debugMode: anObject [
	debugMode := anObject
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> errorMessage [
	self subclassResponsibility
]

{ #category : #initialization }
LanguageLinkAbstractProcess >> initialize [
	super initialize.
	debugMode := false
]

{ #category : #testing }
LanguageLinkAbstractProcess >> isRunning [
	self subclassResponsibility
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> javaScriptMainFile [
	^ pythonMainFile ifNil: [ self workingDirectory / 'start_bridge.py' ]
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> javaScriptMainFile: anObject [
	pythonMainFile := anObject
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> settings [
	^ settings
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> settings: anObject [
	settings := anObject
]

{ #category : #'start-stop' }
LanguageLinkAbstractProcess >> start [
	self subclassResponsibility
]

{ #category : #'start-stop' }
LanguageLinkAbstractProcess >> stop [
	self subclassResponsibility
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> workingDirectory [
	^ workingDirectory
]

{ #category : #accessing }
LanguageLinkAbstractProcess >> workingDirectory: anObject [
	workingDirectory := anObject
]
