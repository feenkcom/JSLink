Class {
	#name : #JSLinkRegistryFinalizer,
	#superclass : #JSLinkAbstractFinalizer,
	#instVars : [
		'pythonVariable',
		'executionHandler'
	],
	#category : #'JSLink-Execution'
}

{ #category : #accessing }
JSLinkRegistryFinalizer class >> javaScriptVariable: aPythonVariable executionHandler: executionHandler [
	^ self new
		javaScriptVariable: aPythonVariable;
		executionHandler: executionHandler
		yourself
]

{ #category : #accessing }
JSLinkRegistryFinalizer >> executionHandler [
	^ executionHandler
]

{ #category : #accessing }
JSLinkRegistryFinalizer >> executionHandler: anObject [
	executionHandler := anObject
]

{ #category : #finalization }
JSLinkRegistryFinalizer >> finalize [
	| cf |
	executionHandler isRunning ifFalse: 
		[ StringSignal emit: 'JSLink not finalizing: ', pythonVariable name printString.
		^ self ].
	StringSignal emit: 'JSLink finalizing: ', pythonVariable name printString.
	cf := executionHandler newCommandFactory.
	cf << (self removeId: pythonVariable name).
	cf send.
]

{ #category : #accessing }
JSLinkRegistryFinalizer >> javaScriptVariable [
	^ pythonVariable
]

{ #category : #accessing }
JSLinkRegistryFinalizer >> javaScriptVariable: anObject [
	pythonVariable := anObject
]

{ #category : #asserting }
JSLinkRegistryFinalizer >> registryExpression [
	^ #registry callWith: #()
]

{ #category : #asserting }
JSLinkRegistryFinalizer >> removeId: anId [
	^ self registryExpression => #clean callWith: (Array with: anId)
]
