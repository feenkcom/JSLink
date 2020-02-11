Class {
	#name : #JSLinkPythonError,
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
JSLinkPythonError >> application [
	^ application
]

{ #category : #accessing }
JSLinkPythonError >> application: anObject [
	application := anObject
]

{ #category : #accessing }
JSLinkPythonError >> command [
	^ command
]

{ #category : #accessing }
JSLinkPythonError >> command: anObject [
	command := anObject
]

{ #category : #accessing }
JSLinkPythonError >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	^ JSLinkPlatform current uiManager spawnDebuggerOnException: self
]

{ #category : #'as yet unclassified' }
JSLinkPythonError >> defaultProceedAction [
	^ JSLinkDropQueue new
]

{ #category : #accessing }
JSLinkPythonError >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
JSLinkPythonError >> errorMessage: anObject [
	errorMessage := anObject
]

{ #category : #initialization }
JSLinkPythonError >> initialize [
	super initialize.
	proceedAction := self defaultProceedAction
]

{ #category : #accessing }
JSLinkPythonError >> isResumable [
	^ true
]

{ #category : #accessing }
JSLinkPythonError >> messageText [
	^ errorMessage
]

{ #category : #accessing }
JSLinkPythonError >> proceedAction [
	^ proceedAction
]

{ #category : #accessing }
JSLinkPythonError >> proceedAction: anObject [
	proceedAction := anObject
]

{ #category : #tracing }
JSLinkPythonError >> trace [
	^ trace
]

{ #category : #tracing }
JSLinkPythonError >> trace: aTrace [
	trace := aTrace
]
