Class {
	#name : #JSLinkPromiseRegistry,
	#superclass : #Object,
	#instVars : [
		'promiseTable',
		'semaphore'
	],
	#category : #'JSLink-Execution'
}

{ #category : #adding }
JSLinkPromiseRegistry >> addPromise: aPromise [
	semaphore critical: [ promiseTable at: aPromise id put: aPromise ]
]

{ #category : #initialization }
JSLinkPromiseRegistry >> initialize [
	super initialize.
	promiseTable := Dictionary new.
	semaphore := Semaphore forMutualExclusion
]

{ #category : #'private - testing' }
JSLinkPromiseRegistry >> promiseTable [
	^ promiseTable
]

{ #category : #adding }
JSLinkPromiseRegistry >> removeAndSignalPromiseId: id with: anObject [
	self signalPromiseId: id with: anObject.
	self removePromiseId: id
]

{ #category : #adding }
JSLinkPromiseRegistry >> removePromiseId: id [
	semaphore critical: [ promiseTable removeKey: id ]
]

{ #category : #adding }
JSLinkPromiseRegistry >> signalPromiseId: id with: anObject [
	| promise |
	semaphore critical: [ 
		promise := promiseTable at: id ].
	promise signalWithValue: anObject.
]
