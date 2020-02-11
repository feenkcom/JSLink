Class {
	#name : #JSLinkUpdatePromiseMessage,
	#superclass : #JSLinkRAsyncMessage,
	#instVars : [
		'promiseId',
		'value'
	],
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkUpdatePromiseMessage class >> type [
	^ #EVAL
]

{ #category : #'as yet unclassified' }
JSLinkUpdatePromiseMessage >> privateDecode: dict [
	super privateDecode: dict.
	promiseId := dict at: #id.
	value := dict at: #value
]

{ #category : #accessing }
JSLinkUpdatePromiseMessage >> promiseId [
	^ promiseId
]

{ #category : #accessing }
JSLinkUpdatePromiseMessage >> value [
	^ value
]
