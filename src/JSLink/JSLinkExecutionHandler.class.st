Class {
	#name : #JSLinkExecutionHandler,
	#superclass : #JSLinkHandler,
	#instVars : [
		'commandQueue',
		'weakRegistry',
		'objectRegistry',
		'promiseRegistry',
		'mapperFactory'
	],
	#category : #'JSLink-Execution'
}

{ #category : #'private protocol' }
JSLinkExecutionHandler >> buildMessageFromCommand: command [
	| message |
	message := JSLinkEnqueueCommandMessage 
					commandId: command id 
					statements: command pythonCode 
					bindings: (command bindings asDictionary collect: [ :obj | self serialize: obj ]).
	message addBinding: #pharoCommandId -> (self serialize: command id).
	^ message
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> communicationHandler [
	^ self application communicationHandler
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> deserialize: anObject [
	^ mapperFactory deserializer deserialize: anObject
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> getObserverAtCommandId: commandId id: observerId [
	^ (commandQueue getCommand: commandId) getObserver: observerId
]

{ #category : #initialization }
JSLinkExecutionHandler >> initialize [
	super initialize.
	commandQueue := JSLinkCommandQueue new.
	mapperFactory := JSLinkMapperFactory forExecutionHandler: self.
	promiseRegistry := JSLinkPromiseRegistry new.
	weakRegistry := JSLinkPlatform current weakRegistry.
	objectRegistry := JSLinkObjectRegistry new
]

{ #category : #initialization }
JSLinkExecutionHandler >> initializeHandler [
	self communicationHandler
		addHandler: [ :msg | self notifyHandler: msg ] forMessageClass: JSLinkUpdatePromiseMessage;
		addHandler: [ :msg | self notifyErrorHandler: msg ] forMessageClass: JSLinkErrorMessage;
		addHandler: [ :msg | self notifyCallbackHandler: msg ] forMessageClass: JSLinkCallbackMessage
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> mapperFactory [
	^ mapperFactory
]

{ #category : #'as yet unclassified' }
JSLinkExecutionHandler >> newCommandFactory [
	^ JSLinkCommandFactory new
		application: self application;
		yourself
]

{ #category : #handlers }
JSLinkExecutionHandler >> notifyCallbackHandler: msg [
	| val serialization |
	val := self 
		signalObserver: (self getObserverAtCommandId: msg commandId id: msg observerId) 
		withValue: (self deserialize: msg value).
	serialization := [ self serialize: val ] on: Error do: [ :err | 
		self application log: err printString.
		self serialize: nil ].
	^ msg createAnswer 
		value: serialization;
		yourself
]

{ #category : #handlers }
JSLinkExecutionHandler >> notifyErrorHandler: errorMsg [
	| error |
	error := JSLinkPythonError new
					application: self application;
					command: (commandQueue getCommand: errorMsg commandId);
					errorMessage: errorMsg errorMessage;
					trace: errorMsg trace;
					yourself.
	self safeTriggerDebugger: error.
	^ errorMsg createAnswer 
			handlingAction: error proceedAction;
			yourself
]

{ #category : #handlers }
JSLinkExecutionHandler >> notifyHandler: updatePromiseMsg [
	self 
		updatePromiseId: updatePromiseMsg promiseId 
		with: (self deserialize: updatePromiseMsg value)
]

{ #category : #initialization }
JSLinkExecutionHandler >> objectRegistry [
	^ objectRegistry
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> primitiveSendCommand: command [
	^ self communicationHandler sendMessage: (self buildMessageFromCommand: command)
]

{ #category : #'as yet unclassified' }
JSLinkExecutionHandler >> registerObject: aPythonObject [
	objectRegistry registerObject: aPythonObject.
	weakRegistry 
		registerObject: aPythonObject 
		finalizer: (JSLinkRegistryFinalizer 
							pythonVariable: aPythonObject pythonVariable 
							executionHandler: self)
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> registerPromiseForCommand: aCommand [
	| promise |
	promise := JSLinkPromise new
					id: aCommand id;
					transformBlock: aCommand transformBlock;
					yourself.
	aCommand promise: promise.
	promiseRegistry addPromise: promise.
	^ promise
]

{ #category : #'as yet unclassified' }
JSLinkExecutionHandler >> safeTriggerDebugger: error [
	| sem |
	sem := Semaphore new.
	[ [ self triggerDebugger: error ] ensure: [ sem signal ] ]
		on: JSLinkPythonError fork: [ :e | JSLinkPlatform current uiManager spawnDebuggerOnException: e ].
	sem wait.
	^ error proceedAction: error defaultProceedAction
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> sendCommand: command [
	| promise |
	self assert: command isValid.
	commandQueue enqueueCommand: command.
	promise := self registerPromiseForCommand: command.
	self primitiveSendCommand: command.
	^ promise
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> serialize: anObject [
	^ mapperFactory serializer serialize: anObject
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> signalObserver: observer withValue: object [
	^ observer pharoNotify: object
]

{ #category : #accessing }
JSLinkExecutionHandler >> stop [
	super stop.
	weakRegistry destroy
]

{ #category : #'as yet unclassified' }
JSLinkExecutionHandler >> triggerDebugger: pythonError [
	"This method is called when an error rised on Python execution."
	"Inspect error to review the Command that caused the error.
	For ignoring error:
		pythonError proceedAction: PBIgnore new
	For aborting:
		pythonError proceedAction: PBDropQueue new
	For replacing the command that caused the error:
		pythonError proceedAction: P3ReplaceCommandAction new newCommand: **Your crafted command**
	To execute your action you just need to 'Proceed' in the debugger."
	pythonError signal.
]

{ #category : #'private protocol' }
JSLinkExecutionHandler >> updatePromiseId: id with: anObject [
	commandQueue finishCommandId: id.
	promiseRegistry removeAndSignalPromiseId: id with: anObject
]
