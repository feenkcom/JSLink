"
This class contains tests

"
Class {
	#name : #JSLinkCommandTest,
	#superclass : #TestCase,
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkCommandTest >> testNewCommandHasEmtptyBindings [
	| command application |

	application := JSLinkApplication new.
	application settings: LanguageLinkSettings jsDefaultSettings.
	command := application newCommand.
	self assert: command id isString.
	self assert: command id notEmpty.
	self assert: command bindings isEmpty.
]

{ #category : #tests }
JSLinkCommandTest >> testNotValidBindingsKeyNotString [
	| command |
	command := LanguageLinkCommand new.
	command bindings: { 33 -> 'bar' }.
	self deny: command isValid
]

{ #category : #tests }
JSLinkCommandTest >> testNotValidBindingsNotAssoc [
	| command |
	command := LanguageLinkCommand new.
	command bindings: { '33' -> 'bar'. 'foo' }.
	self deny: command isValid
]
