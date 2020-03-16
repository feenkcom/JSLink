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
