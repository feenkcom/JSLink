Class {
	#name : #JSLinkStubAnswer,
	#superclass : #JSLinkAnswer,
	#instVars : [
		'ivar1',
		'ivar2'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #converting }
JSLinkStubAnswer >> decode: dict [
	ivar1 := dict at: #ivar1.
	ivar2 := { dict at: #ivar2f } , (dict at: #ivar2r)
]

{ #category : #accessing }
JSLinkStubAnswer >> ivar1 [
	^ ivar1
]

{ #category : #accessing }
JSLinkStubAnswer >> ivar2 [
	^ ivar2
]
