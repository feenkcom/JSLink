Class {
	#name : #JSLinkRAsyncMessage,
	#superclass : #JSLinkRMessage,
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkRAsyncMessage class >> type [
	^ #RASYNC
]

{ #category : #testing }
JSLinkRAsyncMessage >> isSync [
	^ false
]
