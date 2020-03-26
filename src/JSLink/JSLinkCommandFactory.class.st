Class {
	#name : #JSLinkCommandFactory,
	#superclass : #LanguageLinkCommandFactory,
	#instVars : [
		'immediate'
	],
	#category : #'JSLink-Execution'
}

{ #category : #streaming }
JSLinkCommandFactory >> << anObject [
	| statements |

	anObject isString ifFalse: [ ^ super << anObject ].

	statements := (($; split: anObject) collect: [ :string | string trimBoth ])
							reject: [ :string | string isEmpty ].
	statements do: [ :statement |
		super << (LLGExpression new expression: statement) ].
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

{ #category : #initialization }
JSLinkCommandFactory >> reset [

	super reset.
	immediate := false.

]

{ #category : #initialization }
JSLinkCommandFactory >> setNotifyToInstruction: aLLInstruction [
	| method |

	method := immediate
		ifTrue: [ 'notify_immediate' ]
		ifFalse: [ 'notify' ].
	^ method asJSGIdentifier 
			callWith: (Array with: aLLInstruction with: command id)
]
