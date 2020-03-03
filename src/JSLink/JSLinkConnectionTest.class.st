Class {
	#name : #JSLinkConnectionTest,
	#superclass : #LanguageLinkTestCase,
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkConnectionTest >> testNotRunning [

	self deny: self application isRunning
]

{ #category : #tests }
JSLinkConnectionTest >> testSimpleExecution [
	self deny: application isRunning.
	application start.
	application send: 
		(application newCommand instructions: 
			(Array with: (JSGBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself))).	
	application stop.
	(Delay forMilliseconds: 150) wait.
	self should: [ application send: 
		(application newCommand instructions: 
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
