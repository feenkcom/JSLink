Class {
	#name : #JSLinkCommandQueue,
	#superclass : #Object,
	#instVars : [
		'currentIndex',
		'innerCollection',
		'executionHandler'
	],
	#category : #'JSLink-Execution'
}

{ #category : #accessing }
JSLinkCommandQueue class >> executionHandler: aHandler [
	^ self new
			executionHandler: aHandler;
			yourself
]

{ #category : #accessing }
JSLinkCommandQueue >> cleanIndex: anIndex [
	self debugMode ifTrue: [ ^ self ].
	currentIndex := currentIndex - 1.
	innerCollection removeAt: anIndex
]

{ #category : #accessing }
JSLinkCommandQueue >> completedCommands [
	^ innerCollection first: currentIndex
]

{ #category : #accessing }
JSLinkCommandQueue >> currentCommand [
	self isFinished ifTrue: [ ^ nil ].
	^ innerCollection at: currentIndex
]

{ #category : #accessing }
JSLinkCommandQueue >> debugMode [
	^ executionHandler debugMode
]

{ #category : #accessing }
JSLinkCommandQueue >> enqueueCommand: aCommand [
	innerCollection add: aCommand
]

{ #category : #accessing }
JSLinkCommandQueue >> excecutionHandler [
	^ executionHandler
]

{ #category : #accessing }
JSLinkCommandQueue >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
JSLinkCommandQueue >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #accessing }
JSLinkCommandQueue >> finishCommand: aCommand [
	^ self finishCommandId: aCommand id
]

{ #category : #accessing }
JSLinkCommandQueue >> finishCommandId: id [
	| commandIndex |
	self currentCommand
		ifNotNil: [ :command | 
			command id = id
				ifTrue: [ self cleanIndex: currentIndex.
					currentIndex := currentIndex + 1.
					^ true ] ].
	commandIndex := innerCollection
		detectIndex: [ :command | command id = id ].
	commandIndex > currentIndex
		ifTrue: [ currentIndex := commandIndex + 1.
			self
				trace:
					(LanguageLinkErrorLog
						message: 'Out of sync command queue. Pharo is delayed.') ]
		ifFalse: [ self
				trace:
					(LanguageLinkErrorLog
						message: 'Out of sync command queue. Python is delayed.') ].
	self cleanIndex: commandIndex.
	^ false
]

{ #category : #accessing }
JSLinkCommandQueue >> getCommand: aCommandId [
	^ innerCollection detect: [ :command | command id = aCommandId ]
]

{ #category : #initialization }
JSLinkCommandQueue >> initialize [
	super initialize.
	innerCollection := OrderedCollection new.
	currentIndex := 1
]

{ #category : #accessing }
JSLinkCommandQueue >> isFinished [
	^ innerCollection size < currentIndex
]

{ #category : #accessing }
JSLinkCommandQueue >> list [
	^ innerCollection
]

{ #category : #accessing }
JSLinkCommandQueue >> nextCommand [
	| nextCommandIndex |
	nextCommandIndex := currentIndex + 1.
	innerCollection size < nextCommandIndex ifTrue: [ ^ nil ].
	^ innerCollection at: nextCommandIndex
]

{ #category : #accessing }
JSLinkCommandQueue >> queue [
	^ self waitingCommands
]

{ #category : #accessing }
JSLinkCommandQueue >> waitingCommands [
	^ innerCollection allButFirst: currentIndex
]
