Class {
	#name : #JSLinkSocketAddress,
	#superclass : #Object,
	#instVars : [
		'ipOrName',
		'port'
	],
	#category : #'JSLink-Platform'
}

{ #category : #'as yet unclassified' }
JSLinkSocketAddress class >> ipOrName: ipOrName port: aPort [
	^ self new
			ipOrName: ipOrName;
			port: aPort;
			yourself
]

{ #category : #accessing }
JSLinkSocketAddress >> ipOrName [
	^ ipOrName
]

{ #category : #accessing }
JSLinkSocketAddress >> ipOrName: anObject [
	ipOrName := anObject
]

{ #category : #accessing }
JSLinkSocketAddress >> port [
	^ port
]

{ #category : #accessing }
JSLinkSocketAddress >> port: anObject [
	port := anObject
]

{ #category : #printing }
JSLinkSocketAddress >> printAddress [
	^ ipOrName , ':' , port asString
]
