Class {
	#name : #JSLinkApplication,
	#superclass : #LanguageLinkApplication,
	#category : #'JSLink-Global'
}

{ #category : #accessing }
JSLinkApplication class >> baseApplication [
	^ JSLinkApplication
]

{ #category : #accessing }
JSLinkApplication class >> defaultSettings [

	^ LanguageLinkSettings jsDefaultSettings
]

{ #category : #'start-stop' }
JSLinkApplication class >> do: aBlockClosure [ 
	| retVal |
	self isRunning ifTrue: [ ^ aBlockClosure value ].
	[
		self start.
		retVal := aBlockClosure cull: self uniqueInstance.
		self uniqueInstance commandFactory << nil.
		self uniqueInstance commandFactory send waitForValue. ] ensure: [ self stop ].
	^ retVal
]

{ #category : #testing }
JSLinkApplication class >> isRunning [
	^ uniqueInstance notNil and: [ uniqueInstance isRunning ]
]

{ #category : #testing }
JSLinkApplication class >> module [
	^ self uniqueInstance module
]

{ #category : #'pipenv setup' }
JSLinkApplication class >> platform [
	^ JSLinkPlatform current
]

{ #category : #'python hooks file' }
JSLinkApplication class >> repositoryFileReference [
	^ self platform folderForApplication
]

{ #category : #instructions }
JSLinkApplication class >> resetUniqueInstance [
	uniqueInstance ifNotNil: [ 
		[ uniqueInstance stop ] 
			on: Error 
			do: [ JSLinkPlatform current uiManager inform: 'Error on reseting unique instance.' ]. ].
	uniqueInstance := nil
]

{ #category : #instructions }
JSLinkApplication class >> send: obj [
	self assert: self isRunning.
	^ self uniqueInstance send: obj
]

{ #category : #'start-stop' }
JSLinkApplication class >> start [

	^ self startWith: LanguageLinkSettings jsDefaultSettings.
]

{ #category : #'start-stop' }
JSLinkApplication class >> stop [
	uniqueInstance ifNotNil: [ 
		uniqueInstance stop. ].
	uniqueInstance := nil
]

{ #category : #testing }
JSLinkApplication class >> test [ 
	self assert: (self do: [ :app |
		app commandFactory << (JSGBinaryOperator new
                     left: 1;
                     right: 2;
                     operator: $+;
                     yourself).
		app commandFactory send waitForValue
	  ]) = 3
]

{ #category : #utils }
JSLinkApplication >> addMapping: jsType to: mapFunction [
	self newCommandFactory 
		send: (#addMapping callWith: { jsType. mapFunction. })
]

{ #category : #initialization }
JSLinkApplication >> initializeHandlers [
	loggingHandler := LanguageLinkLoggingHandler application: self.
	communicationHandler := LanguageLinkCommunicationHandler application: self.
	processHandler := LanguageLinkServerHandler application: self.
	executionHandler := JSLinkExecutionHandler application: self
]

{ #category : #utils }
JSLinkApplication >> installModule: moduleName [ 
	"Install the requested node.js module using npm"

	^ self settings platform installModule: moduleName in: self.
]

{ #category : #initialization }
JSLinkApplication >> platformClass [

	^ JSLinkPlatform
]
