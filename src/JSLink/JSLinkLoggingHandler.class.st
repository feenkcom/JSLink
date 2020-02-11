Class {
	#name : #JSLinkLoggingHandler,
	#superclass : #JSLinkHandler,
	#instVars : [
		'logs'
	],
	#category : #'JSLink-Core'
}

{ #category : #accessing }
JSLinkLoggingHandler >> errorLogs [
	^ logs select: #isError
]

{ #category : #initialization }
JSLinkLoggingHandler >> initialize [
	super initialize.
	logs := OrderedCollection new
]

{ #category : #log }
JSLinkLoggingHandler >> log: aLog [
	logs add: aLog
]

{ #category : #accessing }
JSLinkLoggingHandler >> logs [
	^ logs
]
