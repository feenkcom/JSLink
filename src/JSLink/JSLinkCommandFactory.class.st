Class {
	#name : #JSLinkCommandFactory,
	#superclass : #Object,
	#instVars : [
		'application',
		'bindingsDictionary',
		'observers',
		'transformBlock',
		'command',
		'instructions'
	],
	#category : #'JSLink-Execution'
}

{ #category : #streaming }
JSLinkCommandFactory >> << aPythonStatement [
	instructions add: aPythonStatement
]

{ #category : #bindings }
JSLinkCommandFactory >> addBinding: aBinding [
	bindingsDictionary at: aBinding pythonVariable name put: aBinding object.
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
	| instructionsCopy |
	instructionsCopy := instructions copy.
	instructionsCopy ifEmpty: [ instructionsCopy := OrderedCollection with: nil ].
	instructionsCopy last isJavaScriptValue ifFalse: [ 
		instructionsCopy := instructionsCopy asOrderedCollection.
		instructionsCopy add: nil ].
	instructionsCopy 
		at: instructionsCopy size 
		put: (self setNotifyToInstruction: instructionsCopy last).
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
