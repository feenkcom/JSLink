Class {
	#name : #JSLinkCommandFactory,
	#superclass : #Object,
	#instVars : [
		'application',
		'bindingsDictionary',
		'observers',
		'transformBlock',
		'command',
		'instructions',
		'immediate'
	],
	#category : #'JSLink-Execution'
}

{ #category : #streaming }
JSLinkCommandFactory >> << aJavaScriptStatement [
	instructions add: aJavaScriptStatement
]

{ #category : #bindings }
JSLinkCommandFactory >> addBinding: aBinding [
	bindingsDictionary at: aBinding javaScriptVariable name put: aBinding object.
	^ aBinding
]

{ #category : #observers }
JSLinkCommandFactory >> addObserver: anObserver [
	observers add: anObserver.
	^ anObserver
]

{ #category : #streaming }
JSLinkCommandFactory >> append: aPythonStatement [
	instructions add: aPythonStatement
]

{ #category : #accessing }
JSLinkCommandFactory >> application [
	^ application
]

{ #category : #accessing }
JSLinkCommandFactory >> application: anObject [
	application := anObject
]

{ #category : #configuration }
JSLinkCommandFactory >> beImmediate [
	"Set the receiver so that the object is returned, instead of a proxy"

	immediate := true.
]

{ #category : #bindings }
JSLinkCommandFactory >> bindingAt: varName put: anObject [
	bindingsDictionary at: varName put: anObject.
	^ JSLinkBinding key: varName wrap: anObject
]

{ #category : #bindings }
JSLinkCommandFactory >> bindingWrap: anObject [
	^ self addBinding: (JSLinkBinding wrap: anObject)
]

{ #category : #send }
JSLinkCommandFactory >> buildCommand [
	| finishedCommand |
	finishedCommand := command
								instructions: self instructionsWithNotifyAtEnd;
								bindings: bindingsDictionary associations;
								observers: observers;
								transformBlock: transformBlock;
								yourself.
	self initialize.
	^ finishedCommand
]

{ #category : #accessing }
JSLinkCommandFactory >> decorateTransform: aBlock [
	| previousBlock |
	previousBlock := transformBlock.
	^ transformBlock := [ :obj | aBlock value: (previousBlock value: obj) ]
]

{ #category : #initialization }
JSLinkCommandFactory >> initialize [
	super initialize.
	self reset
]

{ #category : #accessing }
JSLinkCommandFactory >> instructionsWithNotifyAtEnd [
	| instructionsCopy notifyInstruction |
	instructionsCopy := instructions copy.
	instructionsCopy ifEmpty: [ instructionsCopy := OrderedCollection with: nil ].
	instructionsCopy last isJavaScriptValue ifFalse: [ 
		instructionsCopy := instructionsCopy asOrderedCollection.
		instructionsCopy add: nil ].
	notifyInstruction := immediate 
		ifTrue: [ self setNotifyImmediateToInstruction: instructionsCopy last ]
		ifFalse: [ self setNotifyToInstruction: instructionsCopy last ].
	instructionsCopy 
		at: instructionsCopy size 
		put: notifyInstruction.
	^ instructionsCopy
]

{ #category : #observers }
JSLinkCommandFactory >> observerFromCallback: aBlock [
	| observer |
	observer := (JSLinkObserver callback: aBlock)
						command: command;
						yourself.
	^ self addObserver: observer
]

{ #category : #initialization }
JSLinkCommandFactory >> reset [
	instructions := OrderedCollection new.
	bindingsDictionary := Dictionary new.
	observers := OrderedCollection new.
	command := JSLinkCommand new.
	immediate := false.
	transformBlock := #yourself
]

{ #category : #send }
JSLinkCommandFactory >> send [
	^ self sendCommand
]

{ #category : #send }
JSLinkCommandFactory >> sendAndWait [
	^ self sendCommand waitForValue
]

{ #category : #send }
JSLinkCommandFactory >> sendCommand [
	^ self application send: self buildCommand
]

{ #category : #initialization }
JSLinkCommandFactory >> setNotifyImmediateToInstruction: aJSgInstruction [
	^ 'notify_immediate' asJSGIdentifier 
			callWith: (Array with: aJSgInstruction with: command id)
]

{ #category : #initialization }
JSLinkCommandFactory >> setNotifyToInstruction: aP3gInstruction [
	^ 'notify' asJSGIdentifier 
			callWith: (Array with: aP3gInstruction with: command id)
]

{ #category : #accessing }
JSLinkCommandFactory >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
JSLinkCommandFactory >> transformBlock: anObject [
	transformBlock := anObject
]
