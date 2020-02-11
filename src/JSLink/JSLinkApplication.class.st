Class {
	#name : #JSLinkApplication,
	#superclass : #Object,
	#instVars : [
		'communicationHandler',
		'processHandler',
		'loggingHandler',
		'executionHandler',
		'settings'
	],
	#classVars : [
		'DebugMode'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'JSLink-Global'
}

{ #category : #accessing }
JSLinkApplication class >> baseApplication [
	^ JSLinkApplication
]

{ #category : #debug }
JSLinkApplication class >> debugMode [
	^ DebugMode ifNil: [ false ]
]

{ #category : #debug }
JSLinkApplication class >> debugMode: bool [
	^ DebugMode := bool
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
	^ self platform folderForApplication: self
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
	self isRunning ifTrue: [ Error signal: 'Keras already running.' ].
	self stop.
	uniqueInstance := self new.
	uniqueInstance commandFactory reset.
	uniqueInstance start
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

{ #category : #instructions }
JSLinkApplication class >> uniqueInstance [
	^ uniqueInstance
]

{ #category : #accessing }
JSLinkApplication class >> uniqueInstance: anObject [
	uniqueInstance := anObject
]

{ #category : #utils }
JSLinkApplication >> addMapping: jsType to: mapFunction [
	self commandFactory 
		send: (#addMapping callWith: { jsType. mapFunction. })
]

{ #category : #accessing }
JSLinkApplication >> commandFactory [
	^ JSLinkCF
]

{ #category : #accessing }
JSLinkApplication >> communicationHandler [
	^ communicationHandler
]

{ #category : #accessing }
JSLinkApplication >> errorMessage [
	"Fetch the error message from the stderr stream, from the processhander"
	^ processHandler errorMessage
]

{ #category : #accessing }
JSLinkApplication >> executionHandler [
	^ executionHandler
]

{ #category : #handlers }
JSLinkApplication >> handlers [
	^ Array
		with: loggingHandler
		with: communicationHandler
		with: processHandler
		with: executionHandler
]

{ #category : #initialization }
JSLinkApplication >> initialize [
	super initialize.
	settings := JSLinkPlatform current defaultSettings.
	self initializeHandlers.
]

{ #category : #initialization }
JSLinkApplication >> initializeHandlers [
	loggingHandler := JSLinkLoggingHandler application: self.
	communicationHandler := JSLinkCommunicationHandler application: self.
	processHandler := JSLinkPythonHandler application: self.
	executionHandler := JSLinkExecutionHandler application: self
]

{ #category : #testing }
JSLinkApplication >> isPythonReady [
	"Ensures python webserver is ready for receiving commands"
	^ self communicationHandler isPythonReady
]

{ #category : #testing }
JSLinkApplication >> isRunning [
	^ self handlers allSatisfy: #isRunning
]

{ #category : #logging }
JSLinkApplication >> log: aLog [
	self loggingHandler log: aLog
]

{ #category : #accessing }
JSLinkApplication >> loggingHandler [
	^ loggingHandler
]

{ #category : #accessing }
JSLinkApplication >> module [
	self subclassResponsibility
]

{ #category : #'instance creation' }
JSLinkApplication >> newCommandFactory [
	^ self executionHandler newCommandFactory
]

{ #category : #accessing }
JSLinkApplication >> postInitialization [
	
]

{ #category : #accessing }
JSLinkApplication >> processHandler [
	^ processHandler
]

{ #category : #'as yet unclassified' }
JSLinkApplication >> registerObject: aPythonObject [
	self executionHandler registerObject: aPythonObject
]

{ #category : #instructions }
JSLinkApplication >> send: aCommand [
	self isRunning ifFalse: [ Error signal: 'Bridge not running.' ].
	^ executionHandler sendCommand: aCommand
]

{ #category : #accessing }
JSLinkApplication >> settings [
	^ settings
]

{ #category : #accessing }
JSLinkApplication >> settings: anObject [
	settings := anObject
]

{ #category : #accessing }
JSLinkApplication >> start [
	self handlers do: #start.
	self commandFactory reset.
	self waitInitialization.
	self postInitialization.
	self commandFactory send.
]

{ #category : #'as yet unclassified' }
JSLinkApplication >> stop [
	self handlers select: #notNil thenDo: #stop
]

{ #category : #'as yet unclassified' }
JSLinkApplication >> waitInitialization [
	"Timeout of 10 seconds and try every 0.5 seconds"
	1 to: 10 by: 0.5 do: [ :t |
		self isPythonReady 
				ifTrue: [ ^ self ]
				ifFalse: [ (Delay forMilliseconds: 500) wait ] ].
	Error signal: 'Python application initialization failed! You should try to manually install the Pipenv environment. Have a look at the section "Manually creating Pipenv environment" in https://objectprofile.github.io/PythonBridge/pages/pharo-installation'.
	"
	Print the result of executing the following line:
	
	self errorMessage
	"
]
