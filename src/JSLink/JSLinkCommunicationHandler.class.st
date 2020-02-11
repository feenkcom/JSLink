Class {
	#name : #JSLinkCommunicationHandler,
	#superclass : #JSLinkHandler,
	#instVars : [
		'messageBroker'
	],
	#category : #'JSLink-Core'
}

{ #category : #adding }
JSLinkCommunicationHandler >> addHandler: aBlock forMessageClass: messageClass [
	^ messageBroker addCallback: aBlock messageClass: messageClass
]

{ #category : #initialization }
JSLinkCommunicationHandler >> initializeHandler [
	super initializeHandler.
	messageBroker := JSLinkPlatform current messageBroker: self application settings
]

{ #category : #testing }
JSLinkCommunicationHandler >> isPythonReady [
	| semaphore ans |
	semaphore := Semaphore new.
	[ ans := [self sendMessage: JSLinkIsAliveMessage new.
				true ] 
					on: JSLinkCommunicationError 
					do: [ :e | false ].
	semaphore signal ] forkAt: Processor lowIOPriority.
	semaphore waitTimeoutMSecs: 100.
	^ ans notNil and: ans
]

{ #category : #adding }
JSLinkCommunicationHandler >> sendMessage: aMessage [
	^ messageBroker sendMessage: aMessage
]

{ #category : #accessing }
JSLinkCommunicationHandler >> start [
	^ messageBroker start
]

{ #category : #accessing }
JSLinkCommunicationHandler >> stop [
	^ messageBroker stop
]
