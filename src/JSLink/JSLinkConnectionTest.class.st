Class {
	#name : #JSLinkConnectionTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'oldApplication',
		'oldApp',
		'oldCF'
	],
	#category : #'JSLink-Tests'
}

{ #category : #running }
JSLinkConnectionTest >> setUp [
	oldApp := JSLinkApplication uniqueInstance.
	oldCF := JSLinkCF current.
	JSLinkCF current: nil.
	application := JSLinkApplication new.
	JSLinkApplication uniqueInstance: application
]

{ #category : #running }
JSLinkConnectionTest >> tearDown [
	application stop.
	JSLinkApplication uniqueInstance: oldApp.
	JSLinkCF current: oldCF
]

{ #category : #tests }
JSLinkConnectionTest >> testNotRunning [
	self deny: application isRunning
]

{ #category : #tests }
JSLinkConnectionTest >> testSimpleExecution [
	self deny: application isRunning.
	application start.
	application send: 
		(JSLinkCommand new instructions: 
			(Array with: (JSGBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))).	
	application stop.
	(Delay forMilliseconds: 150) wait.
	self should: [ application send: 
		(JSLinkCommand new instructions: 
			(Array with: (JSGBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))) ] raise: Error.
]

{ #category : #tests }
JSLinkConnectionTest >> testStartStopProcess [
	self deny: application isRunning.
	application start.
	self assert: application processHandler isRunning.
	application stop.
	(Delay forMilliseconds: 150) wait.
	self deny: application isRunning.
	self deny: application processHandler isRunning
]
