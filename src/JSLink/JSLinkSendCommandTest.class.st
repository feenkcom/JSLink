Class {
	#name : #JSLinkSendCommandTest,
	#superclass : #JSLinkApplicationTest,
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkSendCommandTest >> testAddBinding [
	| binding |
	binding := JSLinkBinding wrap: #((2) 3).
	self cf addBinding: binding.
	self cf << binding.
	self assert: self cfSend waitForValue equals: #((2) 3)
]

{ #category : #tests }
JSLinkSendCommandTest >> testAddObserver [
	| observer callbackExecuted promiseSem |
	promiseSem := Semaphore new.
	callbackExecuted := false.
	observer := self cf observerFromCallback: [ :obj | 
		promiseSem wait.
		self assert: obj equals: 33.
		self deny: promise isSignaled.
		callbackExecuted := true ].
	self cf << (observer pythonNotify: 33).
	self cf << 2.
	self cfSend.
	promiseSem signal.
	self assert: promise waitForValue equals: 2.
	self assert: callbackExecuted
]

{ #category : #tests }
JSLinkSendCommandTest >> testCallbackReturnValue [
	| observer callbackExecuted promiseSem |
	promiseSem := Semaphore new.
	callbackExecuted := false.
	observer := self cf observerFromCallback: [ :obj | 
		promiseSem wait.
		self assert: obj equals: 33.
		self deny: promise isSignaled.
		callbackExecuted := true.
		5 ].
	self cf << (observer pythonNotify: 33).
	self cfSend.
	promiseSem signal.
	self assert: promise waitForValue equals: 5.
	self assert: callbackExecuted
]

{ #category : #tests }
JSLinkSendCommandTest >> testInvalidCallbackReturn [
	| observer callbackExecuted promiseSem |
	promiseSem := Semaphore new.
	callbackExecuted := false.
	observer := self cf observerFromCallback: [ :obj | 
		promiseSem wait.
		self assert: obj equals: 33.
		self deny: promise isSignaled.
		callbackExecuted := true.
		self ].
	self cf << (observer pythonNotify: 33).
	self cfSend.
	promiseSem signal.
	self assert: promise waitForValue equals: nil.
	self assert: callbackExecuted
]

{ #category : #tests }
JSLinkSendCommandTest >> testSendAssignAsLastMessage [
	self cf << (#foo asJSGI <- 33) beLetDeclaration.
	self cfSend.
	self assert: promise waitForValue equals: nil
]

{ #category : #tests }
JSLinkSendCommandTest >> testSendImportAsLastMessage [
	self cf << (JSGRequire moduleNamed: 'fs').
	self cfSend.
	self assert: promise waitForValue equals: nil
]
