Class {
	#name : #JSLinkPlatform,
	#superclass : #Object,
	#instVars : [
		'msgBrokerStrategy',
		'processStrategy'
	],
	#classVars : [
		'Current'
	],
	#category : #'JSLink-Platform'
}

{ #category : #accessing }
JSLinkPlatform class >> current [
	^ Current ifNil: [ Current := self getConcretePlatform new ]
]

{ #category : #accessing }
JSLinkPlatform class >> current: aPlatform [
	Current := aPlatform
]

{ #category : #utils }
JSLinkPlatform class >> getConcretePlatform [
	^ (self allSubclasses reject: #isAbstract) 
			inject: nil 
			into: [ :candidate :next |
							candidate 
								ifNil: [ next ]
								ifNotNil: [ 
									candidate priority > next priority
										ifTrue: [ candidate ]
										ifFalse: [ next ] ] ] 
]

{ #category : #hooks }
JSLinkPlatform class >> globalJavaScriptProcessClass [
	self subclassResponsibility
]

{ #category : #hooks }
JSLinkPlatform class >> httpMessageBrokerClass [
	self subclassResponsibility
]

{ #category : #testing }
JSLinkPlatform class >> isAbstract [
	^ self name = 'PBPlatform' asSymbol
]

{ #category : #hooks }
JSLinkPlatform class >> manualProcessClass [
	self subclassResponsibility
]

{ #category : #hooks }
JSLinkPlatform class >> pipenvProcessClass [
	self subclassResponsibility
]

{ #category : #accessing }
JSLinkPlatform class >> platform [
	^ self current
]

{ #category : #private }
JSLinkPlatform class >> priority [
	^ -547835385
]

{ #category : #hooks }
JSLinkPlatform class >> socketMessageBrokerClass [
	self subclassResponsibility
]

{ #category : #hooks }
JSLinkPlatform class >> uiManagerClass [
	self subclassResponsibility
]

{ #category : #hooks }
JSLinkPlatform class >> weakRegistryClass [
	self subclassResponsibility
]

{ #category : #'message broker strategy' }
JSLinkPlatform >> defaultMessageBrokerClass [
	^ self class httpMessageBrokerClass
]

{ #category : #utils }
JSLinkPlatform >> defaultSettings [
	^ JSLinkSettings 
		pharoSocketAddress: (JSLinkSocketAddress ipOrName: 'localhost' port: (7000 + 99 atRandom))
		javaScriptSocketAddress: (JSLinkSocketAddress ipOrName: 'localhost' port: (6900 + 99 atRandom))
]

{ #category : #hooks }
JSLinkPlatform >> ensureEnvironmentForApp: anApplication [
	self subclassResponsibility
]

{ #category : #hooks }
JSLinkPlatform >> folderForApplication: application [
	self subclassResponsibility
]

{ #category : #'module creation' }
JSLinkPlatform >> messageBroker: settings [
	^ self messageBrokerStrategy settings: settings
]

{ #category : #'message broker strategy' }
JSLinkPlatform >> messageBrokerStrategy [
	^ msgBrokerStrategy ifNil: [ ^ self defaultMessageBrokerClass ]
]

{ #category : #'message broker strategy' }
JSLinkPlatform >> messageBrokerStrategy: msgBrokerCls [
	msgBrokerStrategy := msgBrokerCls
]

{ #category : #utils }
JSLinkPlatform >> newRandomName [
	self subclassResponsibility
]

{ #category : #'module creation' }
JSLinkPlatform >> process: application [
	^ self processStrategy application: application
]

{ #category : #'process strategy' }
JSLinkPlatform >> processStrategy [
	^ processStrategy ifNil: [ ^ self class pipenvProcessClass ]
]

{ #category : #'process strategy' }
JSLinkPlatform >> processStrategy: processCls [
	processStrategy := processCls
]

{ #category : #'accessing modules' }
JSLinkPlatform >> serializer [
	^ self messageBrokerStrategy serializer
]

{ #category : #'message broker strategy' }
JSLinkPlatform >> setHttpMessageBroker [
	self messageBrokerStrategy: self class httpMessageBrokerClass
]

{ #category : #'process strategy' }
JSLinkPlatform >> setPipenvProcess [
	self processStrategy: self class pipenvProcessClass
]

{ #category : #'message broker strategy' }
JSLinkPlatform >> setSocketMessageBroker [
	self messageBrokerStrategy: self class socketMessageBrokerClass
]

{ #category : #'module creation' }
JSLinkPlatform >> uiManager [
	^ self class uiManagerClass new
]

{ #category : #'module creation' }
JSLinkPlatform >> weakRegistry [
	^ self class weakRegistryClass new
]
