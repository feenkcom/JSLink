Class {
	#name : #JSLinkStubApplication,
	#superclass : #JSLinkApplication,
	#category : #'JSLink-Tests'
}

{ #category : #initialization }
JSLinkStubApplication >> handlers [
	^ Array with: loggingHandler
]

{ #category : #initialization }
JSLinkStubApplication >> initializeHandlers [
	loggingHandler := LanguageLinkLoggingHandler application: self.
]
