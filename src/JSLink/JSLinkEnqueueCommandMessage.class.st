Class {
	#name : #JSLinkEnqueueCommandMessage,
	#superclass : #JSLinkAsyncMessage,
	#instVars : [
		'commandId',
		'statements',
		'bindings'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #'as yet unclassified' }
JSLinkEnqueueCommandMessage class >> commandId: commandId statements: statements bindings: bindings [
	^ self new
			commandId: commandId;
			statements: statements;
			bindings: bindings;
			yourself
]

{ #category : #'as yet unclassified' }
JSLinkEnqueueCommandMessage class >> type [
	^ 'ENQUEUE'
]

{ #category : #adding }
JSLinkEnqueueCommandMessage >> addBinding: assoc [
	bindings add: assoc
]

{ #category : #adding }
JSLinkEnqueueCommandMessage >> addBindings: assocs [
	assocs do: [ :assoc | self addBinding: assoc ]
]

{ #category : #accessing }
JSLinkEnqueueCommandMessage >> bindings [
	^ bindings
]

{ #category : #accessing }
JSLinkEnqueueCommandMessage >> bindings: anObject [
	bindings := anObject
]

{ #category : #accessing }
JSLinkEnqueueCommandMessage >> commandId [
	^ commandId
]

{ #category : #accessing }
JSLinkEnqueueCommandMessage >> commandId: anObject [
	commandId := anObject
]

{ #category : #adding }
JSLinkEnqueueCommandMessage >> initialize [
	super initialize.
	bindings := Dictionary new
]

{ #category : #adding }
JSLinkEnqueueCommandMessage >> privateEncode: dict [
	dict at: #commandId put: commandId.
	dict at: #statements put: statements.
	dict at: #bindings put: bindings
]

{ #category : #accessing }
JSLinkEnqueueCommandMessage >> statements [
	^ statements
]

{ #category : #accessing }
JSLinkEnqueueCommandMessage >> statements: anObject [
	statements := anObject
]
