Class {
	#name : #JSLinkJavaScriptError,
	#superclass : #Notification,
	#instVars : [
		'command',
		'errorMessage',
		'application',
		'proceedAction',
		'trace'
	],
	#category : #'JSLink-ErrorHandling'
}

{ #category : #accessing }
JSLinkJavaScriptError >> application [
	^ application
]

{ #category : #accessing }
JSLinkJavaScriptError >> application: anObject [
	application := anObject
]

{ #category : #accessing }
JSLinkJavaScriptError >> command [
	^ command
]

{ #category : #accessing }
JSLinkJavaScriptError >> command: anObject [
	command := anObject
]

{ #category : #accessing }
JSLinkJavaScriptError >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	^ JSLinkPlatform current uiManager spawnDebuggerOnException: self
]

{ #category : #'as yet unclassified' }
JSLinkJavaScriptError >> defaultProceedAction [
	^ JSLinkDropQueue new
]

{ #category : #accessing }
JSLinkJavaScriptError >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
JSLinkJavaScriptError >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #initialization }
JSLinkJavaScriptError >> initialize [
	super initialize.
	proceedAction := self defaultProceedAction
]

{ #category : #accessing }
JSLinkJavaScriptError >> isResumable [
	^ true
]

{ #category : #accessing }
JSLinkJavaScriptError >> messageText [
	^ errorMessage
]

{ #category : #accessing }
JSLinkJavaScriptError >> proceedAction [
	^ proceedAction
]

{ #category : #accessing }
JSLinkJavaScriptError >> proceedAction: anObject [
	proceedAction := anObject
]

{ #category : #tracing }
JSLinkJavaScriptError >> trace [
	^ trace
]

{ #category : #tracing }
JSLinkJavaScriptError >> trace: aTrace [
	trace := aTrace
]
