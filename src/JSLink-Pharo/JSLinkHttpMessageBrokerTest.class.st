Class {
	#name : #JSLinkHttpMessageBrokerTest,
	#superclass : #JSLinkMessageBrokerTest,
	#instVars : [
		'stubServer'
	],
	#category : #'JSLink-Pharo-MessageBroker'
}

{ #category : #utils }
JSLinkHttpMessageBrokerTest >> answer: aDictionary [
	^ aDictionary
]

{ #category : #utils }
JSLinkHttpMessageBrokerTest >> buildAndStartStubServer [
	stubServer := ZnServer on: settings serverSocketAddress port.
	stubServer start.
	stubServer onRequestRespond: [ :req | self primHandle: req ]
]

{ #category : #utils }
JSLinkHttpMessageBrokerTest >> decodeAnswer: jsonText [
	^ NeoJSONReader fromString: jsonText
]

{ #category : #utils }
JSLinkHttpMessageBrokerTest >> errorResponse [
	^ ZnResponse serverError: 'ERROR'
]

{ #category : #hooks }
JSLinkHttpMessageBrokerTest >> messageBrokerClass [
	^ LanguageLinkHttpMessageBroker
]

{ #category : #private }
JSLinkHttpMessageBrokerTest >> primHandle: aRequest [
	| answer |
	answer := [
		handlerBlock value: 
			aRequest uri asString allButFirst 
				-> (NeoJSONReader fromString: aRequest contents)
		] on: Error do: [ :e | 
			handlerException := e.
			^ self errorResponse ].
	answer := [ LanguageLinkNeoJsonSerializer new serialize: answer ] on: Error do: [ '{}' ].
	^ ZnResponse ok: (ZnEntity json: answer)
]

{ #category : #hooks }
JSLinkHttpMessageBrokerTest >> sendMessageToBroker: dict [
	self sendMessageToBroker: dict answerEquals: Dictionary new
]

{ #category : #hooks }
JSLinkHttpMessageBrokerTest >> sendMessageToBroker: dict answerBlock: aBlock [
	| ans |
	ans := ZnEasy 
				post: self brokerUri , '/' , (dict at: #type)
				data: (ZnEntity json: (NeoJSONWriter toString: dict)).
	ans status = 200 ifFalse: [ LanguageLinkCommunicationError signal: ans status asString ].
	aBlock value: (self decodeAnswer: ans contents)
]

{ #category : #utils }
JSLinkHttpMessageBrokerTest >> sleepAWhile [
	"With HTTP there is no need to sleep."
]

{ #category : #running }
JSLinkHttpMessageBrokerTest >> stopStubServer [
	stubServer ifNotNil: [ stubServer stop ]
]
