"
This class contains tests

"
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
	^ LanguageLinkSettings jsDefaultSettings

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
	| application |

	super setUp.
	application := JSLinkApplication newWith: self defaultSettings.
	process := self processClass application: application.

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
