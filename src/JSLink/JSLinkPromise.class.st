Class {
	#name : #JSLinkPromise,
	#superclass : #Object,
	#instVars : [
		'id',
		'semaphore',
		'transformBlock',
		'value'
	],
	#category : #'JSLink-Execution'
}

{ #category : #accessing }
JSLinkPromise class >> id: id [
	^ self new
			id: id;
			yourself
]

{ #category : #accessing }
JSLinkPromise >> id [
	^ id
]

{ #category : #accessing }
JSLinkPromise >> id: anObject [
	id := anObject
]

{ #category : #initialization }
JSLinkPromise >> initialize [
	super initialize.
	semaphore := Semaphore new.
	value := nil.
	transformBlock := #yourself
]

{ #category : #signalling }
JSLinkPromise >> isSignaled [
	^ semaphore isSignaled
]

{ #category : #signalling }
JSLinkPromise >> signalAll [
	1 to: semaphore size + 20 do: [ :s | semaphore signal ]
]

{ #category : #signalling }
JSLinkPromise >> signalWithValue: anObject [
	value := transformBlock value: anObject.
	self signalAll.
]

{ #category : #accessing }
JSLinkPromise >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
JSLinkPromise >> transformBlock: anObject [
	transformBlock := anObject
]

{ #category : #signalling }
JSLinkPromise >> value [
	^ value
]

{ #category : #signalling }
JSLinkPromise >> waitForValue [

	self isSignaled ifFalse: [ semaphore wait ].
	(value isKindOf: Exception) ifTrue:
		[ value copy signal ].
	^ self value
]
