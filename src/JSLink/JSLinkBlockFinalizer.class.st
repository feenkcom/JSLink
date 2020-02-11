Class {
	#name : #JSLinkBlockFinalizer,
	#superclass : #JSLinkAbstractFinalizer,
	#instVars : [
		'block'
	],
	#category : #'JSLink-Platform'
}

{ #category : #accessing }
JSLinkBlockFinalizer class >> block: aBlock [
	^ self new
		block: aBlock;
		yourself
]

{ #category : #accessing }
JSLinkBlockFinalizer >> block [
	^ block
]

{ #category : #accessing }
JSLinkBlockFinalizer >> block: anObject [
	block := anObject
]

{ #category : #finalization }
JSLinkBlockFinalizer >> finalize [
	^ block value
]
