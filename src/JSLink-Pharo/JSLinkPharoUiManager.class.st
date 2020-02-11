Class {
	#name : #JSLinkPharoUiManager,
	#superclass : #JSLinkUiManager,
	#category : #'JSLink-Pharo-Platform'
}

{ #category : #'as yet unclassified' }
JSLinkPharoUiManager >> notify: aString [
	Transcript show: aString asString.
]

{ #category : #hooks }
JSLinkPharoUiManager >> spawnDebuggerOnException: anException [
	^ UnhandledError signalForException: anException
]
