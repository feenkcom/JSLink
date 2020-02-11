Class {
	#name : #JSLinkReplaceCommand,
	#superclass : #JSLinkErrorHandlingAction,
	#instVars : [
		'newCommand'
	],
	#category : #'JSLink-ErrorHandling'
}

{ #category : #'as yet unclassified' }
JSLinkReplaceCommand >> actionSymbol [
	^ #'REPLACE_COMMAND'
]

{ #category : #'as yet unclassified' }
JSLinkReplaceCommand >> encodeAsDictionary [
	| response |
	response := super encodeAsDictionary.
	response at: #command put: newCommand encodeAsDictionary.
	^ response
]

{ #category : #accessing }
JSLinkReplaceCommand >> newCommand [
	^ newCommand
]

{ #category : #accessing }
JSLinkReplaceCommand >> newCommand: anObject [
	newCommand := anObject
]
