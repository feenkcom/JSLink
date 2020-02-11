Class {
	#name : #JSLinkAsyncMessage,
	#superclass : #JSLinkMessage,
	#category : #'JSLink-Platform-Messages'
}

{ #category : #accessing }
JSLinkAsyncMessage class >> type [
	^ #ASYNC
]

{ #category : #testing }
JSLinkAsyncMessage >> isSync [
	^ false
]
