Class {
	#name : #JSLinkPythonHandler,
	#superclass : #JSLinkHandler,
	#instVars : [
		'process'
	],
	#category : #'JSLink-Core'
}

{ #category : #accessing }
JSLinkPythonHandler >> errorMessage [
	^ process errorMessage
]

{ #category : #initialization }
JSLinkPythonHandler >> initializeHandler [
	super initializeHandler.
	process := JSLinkPlatform current process: self application
]

{ #category : #testing }
JSLinkPythonHandler >> isRunning [
	^ process isRunning
]

{ #category : #accessing }
JSLinkPythonHandler >> platform [
	^ JSLinkPlatform current
]

{ #category : #testing }
JSLinkPythonHandler >> start [
	"self platform ensureEnvironmentForApp: self application."
	^ process start
]

{ #category : #testing }
JSLinkPythonHandler >> stop [
	^ process stop
]
