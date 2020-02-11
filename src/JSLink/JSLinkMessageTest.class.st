Class {
	#name : #JSLinkMessageTest,
	#superclass : #TestCase,
	#category : #'JSLink-Platform-Messages'
}

{ #category : #tests }
JSLinkMessageTest >> stubMessage [
	^ JSLinkStubMessage new
		ivar1: #foo;
		ivar2: #(3 #bar);
		yourself
]

{ #category : #tests }
JSLinkMessageTest >> testDecodeAnswer [
	| msg dict ans |
	msg := self stubMessage.
	dict := {
		(#type -> #STUB).
		(#ivar1 -> #foo).
		(#ivar2f -> 3).
		(#ivar2r -> #(#zork)).
		(#__sync -> msg syncId)} asDictionary.
	ans := msg createAnswer decode: dict.
	self assert: ans ivar1 equals: #foo.
	self assert: ans ivar2 equals: #(3 #zork).
]

{ #category : #tests }
JSLinkMessageTest >> testDecodeBaseMessage [
	self 
		assert: (JSLinkSyncMessage new createAnswer decode: { #type -> #MSG } asDictionary) class
		equals: JSLinkAnswer
]

{ #category : #tests }
JSLinkMessageTest >> testEncodeBaseMessage [
	self 
		assert: JSLinkMessage new encode 
		equals: { #type -> #MSG } asDictionary
]

{ #category : #tests }
JSLinkMessageTest >> testEncodeMessage [
	| msg dict |
	msg := self stubMessage.
	dict := {
		(#type -> #STUB).
		(#ivar1 -> #foo).
		(#ivar2f -> 3).
		(#ivar2r -> #(#bar)).
		(#__sync -> msg syncId)} asDictionary.
	self assert: msg encode equals: dict
]

{ #category : #tests }
JSLinkMessageTest >> testNoDuplicatedTypes [
	| messageClasses |
	messageClasses := JSLinkAbstractMessage allSubclasses.
	self assert: (messageClasses collect: #type) asSet size equals: messageClasses size
]
