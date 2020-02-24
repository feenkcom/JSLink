Class {
	#name : #JSLinkCommandQueueTest,
	#superclass : #JSLinkTestCase,
	#instVars : [
		'queue'
	],
	#category : #'JSLink-Tests'
}

{ #category : #initialization }
JSLinkCommandQueueTest >> setUp [
	| execHandler |

	super setUp.
	execHandler := LanguageLinkExecutionHandler basicNew 
							application: self application;
							yourself.
	queue := JSLinkCommandQueue executionHandler: execHandler
]

{ #category : #tests }
JSLinkCommandQueueTest >> testCleaningCommand [
	| cc1 cc2 |
	cc1 := LanguageLinkCommand new.
	cc2 := LanguageLinkCommand new.
	queue enqueueCommand: cc1.
	queue enqueueCommand: cc2.
	self assert: (queue finishCommand: cc1).
	self assert: queue list size equals: 1.
	self assert: (queue finishCommand: cc2).
	self assert: queue isFinished
]

{ #category : #tests }
JSLinkCommandQueueTest >> testEmptyQueue [
	self assert: queue list isEmpty.
	self assert: queue isFinished.
	self assert: queue currentCommand isNil
]

{ #category : #tests }
JSLinkCommandQueueTest >> testEnqueue [
	| c |
	c := LanguageLinkCommand new.
	queue enqueueCommand: c.
	self assert: queue list size equals: 1.
	self assert: queue currentCommand equals: c.
	
]

{ #category : #tests }
JSLinkCommandQueueTest >> testFinishCommand [
	| cc |
	cc := LanguageLinkCommand new.
	queue enqueueCommand: cc.
	self assert: (queue finishCommand: cc).
	self assert: queue isFinished
]

{ #category : #tests }
JSLinkCommandQueueTest >> testFinishCommand2 [
	| cc |
	cc := LanguageLinkCommand new.
	queue enqueueCommand: cc.
	queue enqueueCommand: LanguageLinkCommand new.
	self assert: (queue finishCommand: cc).
	self deny: queue isFinished
]

{ #category : #tests }
JSLinkCommandQueueTest >> testFinishNotFoundCommand [
	self 
		should: [ queue finishCommandId: 'aa' ]
		raise: Error
]

{ #category : #tests }
JSLinkCommandQueueTest >> testFinishOutOfSync1Command [
	| cc1 cc2 |
	cc1 := self newCommand.
	cc2 := self newCommand.
	queue enqueueCommand: cc1.
	queue enqueueCommand: cc2.
	self deny: (queue finishCommand: cc2).
	self assert: queue isFinished
]

{ #category : #tests }
JSLinkCommandQueueTest >> testFinishOutOfSync2Command [
	| cc1 cc2 |
	cc1 := self newCommand.
	cc2 := self newCommand.
	queue enqueueCommand: cc1.
	queue enqueueCommand: cc2.
	self deny: (queue finishCommand: cc2).
	self deny: (queue finishCommand: cc1).
	self assert: queue isFinished
]

{ #category : #tests }
JSLinkCommandQueueTest >> testNotFoundCommand [
	queue enqueueCommand: LanguageLinkCommand new.
	self 
		should: [ queue finishCommandId: 'aa' ]
		raise: Error
]
