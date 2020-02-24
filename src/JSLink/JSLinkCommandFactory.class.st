Class {
	#name : #JSLinkCommandFactory,
	#superclass : #LanguageLinkCommandFactory,
	#instVars : [
		'immediate'
	],
	#category : #'JSLink-Execution'
}

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
