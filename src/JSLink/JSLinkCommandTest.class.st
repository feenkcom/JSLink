Class {
	#name : #JSLinkCommandTest,
	#superclass : #TestCase,
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkCommandTest >> testNewCommandHasEmtptyBindings [
	| command |
	command := JSLinkCommand new.
	self assert: command id isString.
	self assert: command id notEmpty.
	self assert: command bindings equals: #().
]

{ #category : #tests }
JSLinkCommandTest >> testNotValidBindingsKeyNotString [
	| command |
	command := JSLinkCommand new.
	command bindings: { 33 -> 'bar' }.
	self deny: command isValid
]

{ #category : #tests }
JSLinkCommandTest >> testNotValidBindingsNotAssoc [
	| command |
	command := JSLinkCommand new.
	command bindings: { '33' -> 'bar'. 'foo' }.
	self deny: command isValid
]
