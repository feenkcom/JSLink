Class {
	#name : #JSLinkJavaScriptHandler,
	#superclass : #JSLinkHandler,
	#instVars : [
		'process'
	],
	#category : #'JSLink-Core'
}

{ #category : #accessing }
JSLinkJavaScriptHandler >> errorMessage [
	^ process errorMessage
]

{ #category : #initialization }
JSLinkJavaScriptHandler >> initializeHandler [
	super initializeHandler.
	process := JSLinkPlatform current process: self application
]

{ #category : #testing }
JSLinkJavaScriptHandler >> isRunning [
	^ process isRunning
]

{ #category : #accessing }
JSLinkJavaScriptHandler >> platform [
	^ JSLinkPlatform current
]

{ #category : #testing }
JSLinkJavaScriptHandler >> start [
	"self platform ensureEnvironmentForApp: self application."
	^ process start
]

{ #category : #testing }
JSLinkJavaScriptHandler >> stop [
	^ process stop
]
