Class {
	#name : #JSLinkMessageHandlerTest,
	#superclass : #TestCase,
	#category : #'JSLink-Platform'
}

{ #category : #tests }
JSLinkMessageHandlerTest >> testAsyncMessage [
	| flag msg handler |
	flag := false.
	msg := LanguageLinkAsyncMessage new.
	handler := JSLinkMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true ].
	self deny: flag.
	handler handleMessage.
	self deny: handler shouldAnswer.
	self assert: flag.
	self should: [ handler answer ] raise: Error
]

{ #category : #tests }
JSLinkMessageHandlerTest >> testRAsyncMessage [
	| flag msg handler |
	flag := false.
	msg := LanguageLinkRAsyncMessage new.
	handler := JSLinkMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true ].
	self deny: flag.
	handler handleMessage.
	self deny: handler shouldAnswer.
	self assert: flag.
	self should: [ handler answer ] raise: Error
]

{ #category : #tests }
JSLinkMessageHandlerTest >> testRSyncMessage [
	| flag msg handler ans |
	flag := false.
	ans := nil.
	msg := LanguageLinkRSyncMessage new.
	handler := JSLinkMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true.
							ans := msg createAnswer ].
	self deny: flag.
	handler handleMessage.
	self assert: handler shouldAnswer.
	self assert: flag.
	self assert: handler answer equals: ans
]

{ #category : #tests }
JSLinkMessageHandlerTest >> testSyncMessage [
	| flag msg handler ans |
	flag := false.
	ans := nil.
	msg := LanguageLinkSyncMessage new.
	handler := JSLinkMessageHandler 
						forMessage: msg 
						callback: [ :aMsg |
							self assert: msg equals: aMsg.
							flag := true.
							ans := msg createAnswer ].
	self deny: flag.
	handler handleMessage.
	self assert: handler shouldAnswer.
	self assert: flag.
	self assert: handler answer equals: ans
]
