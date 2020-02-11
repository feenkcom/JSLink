Class {
	#name : #JSLinkUiManager,
	#superclass : #Object,
	#category : #'JSLink-Platform'
}

{ #category : #hooks }
JSLinkUiManager >> notify: aString [
	self subclassResponsibility
]

{ #category : #hooks }
JSLinkUiManager >> spawnDebuggerOnException: anException [
	self subclassResponsibility
]
