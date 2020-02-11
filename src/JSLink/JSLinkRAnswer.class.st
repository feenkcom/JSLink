Class {
	#name : #JSLinkRAnswer,
	#superclass : #JSLinkAbstractAnswer,
	#category : #'JSLink-Platform-Messages'
}

{ #category : #encoding }
JSLinkRAnswer >> encode [
	| dict |
	dict := Dictionary new.
	dict at: #type put: self type. 
	self privateEncode: dict.
	^ dict
]

{ #category : #encoding }
JSLinkRAnswer >> privateEncode: dict [
	dict at: #__sync put: self syncId
]

{ #category : #writing }
JSLinkRAnswer >> syncId [
	^ message syncId
]
