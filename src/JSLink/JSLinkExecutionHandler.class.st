Class {
	#name : #JSLinkExecutionHandler,
	#superclass : #LanguageLinkExecutionHandler,
	#category : #'JSLink-Execution'
}

{ #category : #initialization }
JSLinkExecutionHandler >> initializeHandler [

	commandQueue := LanguageLinkCommandRegistry executionHandler: self.
	mapperFactory := LanguageLinkMapperFactory forExecutionHandler: self.
	promiseRegistry := LanguageLinkPromiseRegistry new.
	weakRegistry := self settings platform weakRegistry.
	objectRegistry := LanguageLinkObjectRegistry new.

	self communicationHandler
		addHandler: [ :msg | self notifyHandler: msg ] forMessageClass: LanguageLinkUpdatePromiseMessage;
		addHandler: [ :msg | self notifyErrorHandler: msg ] forMessageClass: LanguageLinkErrorMessage;
		addHandler: [ :msg | self notifyCallbackHandler: msg ] forMessageClass: LanguageLinkCallbackMessage
]

{ #category : #registry }
JSLinkExecutionHandler >> registryExpression [
	^ #registry jsCallWith: #()
]

{ #category : #registry }
JSLinkExecutionHandler >> removeId: anId [
	^ self registryExpression => #clean jsCallWith: (Array with: anId)
]
