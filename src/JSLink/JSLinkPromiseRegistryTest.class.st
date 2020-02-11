Class {
	#name : #JSLinkPromiseRegistryTest,
	#superclass : #TestCase,
	#instVars : [
		'registry'
	],
	#category : #'JSLink-Tests'
}

{ #category : #initialization }
JSLinkPromiseRegistryTest >> setUp [
	registry := JSLinkPromiseRegistry new
]

{ #category : #initialization }
JSLinkPromiseRegistryTest >> testAddPromise [
	registry addPromise: (JSLinkPromise id: '123').
	self assert: registry promiseTable size equals: 1.
	self assert: registry promiseTable anyOne id equals: '123'
]

{ #category : #initialization }
JSLinkPromiseRegistryTest >> testRemovePromiseId [
	registry addPromise: (JSLinkPromise id: '123').
	registry removePromiseId: '123'.
	self assert: registry promiseTable size equals: 0
]

{ #category : #initialization }
JSLinkPromiseRegistryTest >> testSignalPromise [
	| semaphore flag promise |
	semaphore := Semaphore new.
	flag := false.
	promise := (JSLinkPromise id: '123').
	registry addPromise: promise.
	[ 	
		self assert: promise waitForValue equals: #foo.
		flag := true.
		semaphore signal. ] fork.
	registry signalPromiseId: '123' with: #foo.
	semaphore wait.
	self assert: flag
]

{ #category : #initialization }
JSLinkPromiseRegistryTest >> testSignalPromiseWithTransformBlock [
	| semaphore flag promise |
	semaphore := Semaphore new.
	flag := false.
	promise := (JSLinkPromise id: '123')
						transformBlock: [ :obj | 55 ].
	registry addPromise: promise.
	[ 	
		self assert: promise waitForValue equals: 55.
		flag := true.
		semaphore signal. ] fork.
	registry signalPromiseId: '123' with: #foo.
	semaphore wait.
	self assert: flag
]
