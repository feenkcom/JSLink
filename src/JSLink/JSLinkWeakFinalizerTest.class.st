Class {
	#name : #JSLinkWeakFinalizerTest,
	#superclass : #TestCase,
	#instVars : [
		'weakRegistry',
		'assertCounter'
	],
	#category : #'JSLink-Platform'
}

{ #category : #testing }
JSLinkWeakFinalizerTest class >> isAbstract [
	^ self == JSLinkWeakFinalizerTest
]

{ #category : #running }
JSLinkWeakFinalizerTest >> assertCount: anInteger [
	self assert: assertCounter equals: anInteger
]

{ #category : #running }
JSLinkWeakFinalizerTest >> countFinalizer [
	^ JSLinkBlockFinalizer block: [ assertCounter := assertCounter + 1 ]
]

{ #category : #running }
JSLinkWeakFinalizerTest >> setUp [
	super setUp.
	weakRegistry := self weakRegistryClass new.
	assertCounter := 0
]

{ #category : #running }
JSLinkWeakFinalizerTest >> tearDown [
	weakRegistry destroy.
	super tearDown
]

{ #category : #running }
JSLinkWeakFinalizerTest >> testBlockFinalizer [
	self assertCount: 0.
	self countFinalizer finalize.
	self assertCount: 1
]

{ #category : #running }
JSLinkWeakFinalizerTest >> testDestroy [
	| obj |
	obj := Object new.
	weakRegistry registerObject: obj finalizer: self countFinalizer.
	weakRegistry destroy.
	obj := nil.
	self triggerGC.
	self assertCount: 0
]

{ #category : #running }
JSLinkWeakFinalizerTest >> testGcMultObjects [
	| obj1 obj2 obj3 |
	obj1 := Object new.
	obj2 := Object new.
	obj3 := Object new.
	weakRegistry registerObject: obj1 finalizer: self countFinalizer.
	weakRegistry registerObject: obj2 finalizer: self countFinalizer.
	obj1 := nil.
	self triggerGC.
	self assertCount: 1.
	weakRegistry registerObject: obj3 finalizer: self countFinalizer.
	self triggerGC.
	self assertCount: 1.
	obj2 := nil.
	obj3 := nil.
	self triggerGC.
	self assertCount: 3
]

{ #category : #running }
JSLinkWeakFinalizerTest >> testGcObject [
	| obj |
	obj := Object new.
	weakRegistry registerObject: obj finalizer: self countFinalizer.
	obj := nil.
	self triggerGC.
	self assertCount: 1
]

{ #category : #running }
JSLinkWeakFinalizerTest >> testNotGcObject [
	| obj |
	obj := Object new.
	weakRegistry registerObject: obj finalizer: self countFinalizer.
	self triggerGC.
	self assertCount: 0
]

{ #category : #running }
JSLinkWeakFinalizerTest >> triggerGC [
	self subclassResponsibility
]

{ #category : #running }
JSLinkWeakFinalizerTest >> weakRegistryClass [
	self subclassResponsibility
]
