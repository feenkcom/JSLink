Class {
	#name : #JSLinkRMessageTest,
	#superclass : #TestCase,
	#category : #'JSLink-Platform-Messages'
}

{ #category : #tests }
JSLinkRMessageTest >> stubDict [
	^ {#type -> #RSTUB .
		#ivar1 -> #foo .
		#ivar2f -> 3 .
		#ivar2r -> #(#bar) .
		#__sync -> 'ab45d3'
		} asDictionary
]

{ #category : #tests }
JSLinkRMessageTest >> testDecodeRMessage [
	| msg |
	msg := JSLinkRMessage decodeFrom: { #type -> #RMSG } asDictionary.
	self assert: msg class equals: JSLinkRMessage.
	self assert: msg type equals: #RMSG
]

{ #category : #tests }
JSLinkRMessageTest >> testDecodeRStubMessage [
	| msg |
	msg := JSLinkRStubMessage decodeFrom: self stubDict.
	self assert: msg ivar1 equals: #foo.
	self assert: msg ivar2 equals: #(3 #bar).
	self assert: msg syncId equals: 'ab45d3'
]

{ #category : #tests }
JSLinkRMessageTest >> testEncodeRAnswer [
	| msg ans |
	msg := JSLinkRSyncMessage decodeFrom: { #type -> #RSYNC . #__sync -> 'abcde1234' } asDictionary.
	ans := msg createAnswer.
	self assert: ans syncId equals: 'abcde1234'.
	self assert: ans encode equals: { #type -> #RSYNC . #__sync -> 'abcde1234' } asDictionary
]

{ #category : #tests }
JSLinkRMessageTest >> testEncodeRStubAnswer [
	| msg ans |
	msg := JSLinkRStubMessage decodeFrom: self stubDict.
	ans := msg createAnswer.
	ans ivar1: #foo.
	ans ivar2: #(3 #bar).
	self assert: ans encode equals: self stubDict
]
