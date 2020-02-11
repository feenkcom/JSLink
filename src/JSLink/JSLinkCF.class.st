Class {
	#name : #JSLinkCF,
	#superclass : #Object,
	#classInstVars : [
		'current'
	],
	#category : #'JSLink-Global'
}

{ #category : #'as yet unclassified' }
JSLinkCF class >> << aPythonStatement [
	^ self current << aPythonStatement
]

{ #category : #'as yet unclassified' }
JSLinkCF class >> addBinding: aBinding [
	^ self current addBinding: aBinding
]

{ #category : #'as yet unclassified' }
JSLinkCF class >> addObserver: anObserver [
	^ self current addObserver: anObserver
]

{ #category : #'as yet unclassified' }
JSLinkCF class >> append: aPythonStatement [
	^ self current append: aPythonStatement
]

{ #category : #initialization }
JSLinkCF class >> application [
	^ self applicationClass uniqueInstance
]

{ #category : #initialization }
JSLinkCF class >> applicationClass [
	^ JSLinkApplication
]

{ #category : #'as yet unclassified' }
JSLinkCF class >> bindingAt: varName put: anObject [
	^ self current bindingAt: varName put: anObject
]

{ #category : #'as yet unclassified' }
JSLinkCF class >> bindingWrap: anObject [
	^ self current bindingWrap: anObject
]

{ #category : #'as yet unclassified' }
JSLinkCF class >> buildCommand [
	| command |
	command := self current buildCommand.
	self reset.
	^ command
]

{ #category : #accessing }
JSLinkCF class >> current [
	^ current
]

{ #category : #accessing }
JSLinkCF class >> current: cf [
	current := cf
]

{ #category : #'reflective operations' }
JSLinkCF class >> doesNotUnderstand: aMessage [
	^ aMessage sendTo: self current
]

{ #category : #'instance creation' }
JSLinkCF class >> newCommandFactory [
	^ self application newCommandFactory
]

{ #category : #'as yet unclassified' }
JSLinkCF class >> observerFromCallback: aBlock [
	^ self current observerFromCallback: aBlock
]

{ #category : #accessing }
JSLinkCF class >> reset [
	current := self newCommandFactory
]

{ #category : #'old api' }
JSLinkCF class >> send [
	^ self application send: self buildCommand
]

{ #category : #'old api' }
JSLinkCF class >> send: aPythonStatement [
	self << aPythonStatement.
	^ self send
]

{ #category : #'old api' }
JSLinkCF class >> sendAndWait [
	^ self send waitForValue
]

{ #category : #'old api' }
JSLinkCF class >> sendAndWait: aPythonStatement [
	^ (self send: aPythonStatement) waitForValue
]

{ #category : #'as yet unclassified' }
JSLinkCF class >> transformBlock: aBlock [
	^ self current transformBlock: aBlock
]
