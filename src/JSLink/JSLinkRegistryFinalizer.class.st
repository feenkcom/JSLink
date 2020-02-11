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
JSLinkRegistryFinalizer class >> pythonVariable: aPythonVariable executionHandler: executionHandler [
	^ self new
		pythonVariable: aPythonVariable;
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
	executionHandler isRunning ifFalse: [ ^ self ].
	cf := executionHandler newCommandFactory.
	cf << (self removeId: pythonVariable name).
	cf send.
]

{ #category : #accessing }
JSLinkRegistryFinalizer >> pythonVariable [
	^ pythonVariable
]

{ #category : #accessing }
JSLinkRegistryFinalizer >> pythonVariable: anObject [
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
