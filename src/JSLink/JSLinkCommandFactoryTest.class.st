Class {
	#name : #JSLinkCommandFactoryTest,
	#superclass : #TestCase,
	#instVars : [
		'factory'
	],
	#category : #'JSLink-Tests'
}

{ #category : #initialization }
JSLinkCommandFactoryTest >> setUp [
	| application |

	application := JSLinkApplication new.
	application settings: LanguageLinkSettings jsDefaultSettings.
	factory := application newCommandFactory.
]

{ #category : #tests }
JSLinkCommandFactoryTest >> testBuildEmptyCommand [
	| command |
	command := factory buildCommand.
	self assert: command instructions size equals: 1.
	self assert: command instructions first class equals: JSGCall.
	self assert: command instructions first target name equals: 'notify'.
	self assert: command instructions first positionalArguments first equals: nil.
	self assert: command bindings isEmpty
]

{ #category : #tests }
JSLinkCommandFactoryTest >> testBuildFullCommand [
	| command instructions |
	factory << (JSGString string: 'foo').
	factory bindingAt: #myVar put: 3.
	command := factory buildCommand.
	instructions := command instructions.
	self assert: command instructions first positionalArguments first string equals: 'foo'.
	self assert: (command bindingsDictionary at: #myVar) equals: 3
]

{ #category : #tests }
JSLinkCommandFactoryTest >> testBuildSimpleCommand [
	| command instructions |
	factory << (JSGString string: 'foo').
	command := factory buildCommand.
	instructions := command instructions.
	self assert: command instructions first positionalArguments first string equals: 'foo'.
]

{ #category : #tests }
JSLinkCommandFactoryTest >> testBuildWithObservers [
	| command |
	factory observerFromCallback: [ 32 ].
	command := factory buildCommand.
	self assert: command observers first callback value equals: 32.
]
