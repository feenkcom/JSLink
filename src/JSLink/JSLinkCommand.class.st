Class {
	#name : #JSLinkCommand,
	#superclass : #Object,
	#instVars : [
		'id',
		'instructions',
		'bindings',
		'observers',
		'promise',
		'transformBlock'
	],
	#category : #'JSLink-Execution'
}

{ #category : #accessing }
JSLinkCommand >> bindings [
	^ bindings
]

{ #category : #accessing }
JSLinkCommand >> bindings: bindingCol [
	bindings := bindingCol
]

{ #category : #accessing }
JSLinkCommand >> bindingsDictionary [
	^ self bindings asDictionary
]

{ #category : #accessing }
JSLinkCommand >> getObserver: observerId [
	^ observers detect: [ :obs | obs id = observerId ]
]

{ #category : #accessing }
JSLinkCommand >> id [
	^ id
]

{ #category : #accessing }
JSLinkCommand >> id: anObject [
	id := anObject
]

{ #category : #initialization }
JSLinkCommand >> initialize [
	super initialize.
	id := JSLinkPlatform current newRandomName.
	bindings := #().
	observers := #().
	instructions := OrderedCollection new.
	transformBlock := #yourself
]

{ #category : #accessing }
JSLinkCommand >> instructions [
	^ instructions
]

{ #category : #accessing }
JSLinkCommand >> instructions: anObject [
	instructions := anObject
]

{ #category : #testing }
JSLinkCommand >> isValid [
	^ [ self id isString and: [ 
			(self bindings allSatisfy: [ :assoc | assoc key isString ]) and: [ 
				self observers allSatisfy: [ :obs | obs callback isBlock ] ] ] ] on: Error do: [ false ]
]

{ #category : #accessing }
JSLinkCommand >> observers [
	^ observers
]

{ #category : #accessing }
JSLinkCommand >> observers: anObject [
	observers := anObject
]

{ #category : #printing }
JSLinkCommand >> printOn: aStream [

	super printOn: aStream.
	aStream
		<< '(';
		print: id;
		<< ')'
]

{ #category : #accessing }
JSLinkCommand >> promise [
	^ promise
]

{ #category : #accessing }
JSLinkCommand >> promise: anObject [
	promise := anObject
]

{ #category : #'as yet unclassified' }
JSLinkCommand >> pythonCode [
	| py3CodeStream |
	py3CodeStream := String new writeStream.
	self instructions do: [ :instr | 
			"If making a call, it should be await"
			instr class = JSGCall ifTrue:
				[ py3CodeStream << 'await ' ].
			instr writeJavaScriptOn: py3CodeStream.
			py3CodeStream 
				<< ';';
				<< String lf ].
	^ py3CodeStream contents
]

{ #category : #accessing }
JSLinkCommand >> transformBlock [
	^ transformBlock
]

{ #category : #accessing }
JSLinkCommand >> transformBlock: anObject [
	transformBlock := anObject
]
