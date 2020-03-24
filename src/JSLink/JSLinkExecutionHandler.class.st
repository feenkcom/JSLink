Class {
	#name : #JSLinkExecutionHandler,
	#superclass : #LanguageLinkExecutionHandler,
	#category : #'JSLink-Execution'
}

{ #category : #initialization }
JSLinkExecutionHandler >> initializeHandler [

	commandQueue := LanguageLinkCommandQueue executionHandler: self.
	mapperFactory := LanguageLinkMapperFactory forExecutionHandler: self.
	promiseRegistry := LanguageLinkPromiseRegistry new.
	weakRegistry := self settings platform weakRegistry.
	objectRegistry := JSLinkObjectRegistry new.

	self communicationHandler
		addHandler: [ :msg | self notifyHandler: msg ] forMessageClass: LanguageLinkUpdatePromiseMessage;
		addHandler: [ :msg | self notifyErrorHandler: msg ] forMessageClass: LanguageLinkErrorMessage;
		addHandler: [ :msg | self notifyCallbackHandler: msg ] forMessageClass: LanguageLinkCallbackMessage
]

{ #category : #registry }
JSLinkExecutionHandler >> registryExpression [
	^ #registry callWith: #()
]

{ #category : #registry }
JSLinkExecutionHandler >> removeId: anId [
	^ self registryExpression => #clean callWith: (Array with: anId)
]
