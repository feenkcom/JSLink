Class {
	#name : #JSLinkProcessTest,
	#superclass : #TestCase,
	#instVars : [
		'process',
		'tmpPythonFile'
	],
	#category : #'JSLink-Platform'
}

{ #category : #testing }
JSLinkProcessTest class >> isAbstract [
	^ self == JSLinkProcessTest
]

{ #category : #running }
JSLinkProcessTest >> defaultSettings [
	^ JSLinkSettings 
		pharoSocketAddress: (JSLinkSocketAddress ipOrName: 'localhost' port: 6538)
		javaScriptSocketAddress: (JSLinkSocketAddress ipOrName: 'localhost' port: 6539)
]

{ #category : #running }
JSLinkProcessTest >> defaultTmpFile [
	self subclassResponsibility
]

{ #category : #hooks }
JSLinkProcessTest >> processClass [
	self subclassResponsibility
]

{ #category : #running }
JSLinkProcessTest >> setUp [
	super setUp.
	process := self processClass
		settings: self defaultSettings
		workingDirectory: self processClass workingDirectory.
	process javaScriptMainFile: self defaultTmpFile
]

{ #category : #running }
JSLinkProcessTest >> tearDown [
	process stop.
	super tearDown
]

{ #category : #running }
JSLinkProcessTest >> testStartStopProcess [
	self deny: process isRunning.
	process start.
	self assert: process isRunning.
	process stop.
	(Delay forMilliseconds: 150) wait.
	self deny: process isRunning
]
