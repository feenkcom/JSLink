Class {
	#name : #PharoLinkPharoProcess,
	#superclass : #LanguageLinkAbstractProcess,
	#instVars : [
		'process',
		'environmentVariables'
	],
	#classVars : [
		'NodejsPath',
		'PipenvPath'
	],
	#category : #'JSLink-Pharo-Processes'
}

{ #category : #accessing }
PharoLinkPharoProcess class >> platform [
	^ JSLinkPharoPlatform current
]

{ #category : #private }
PharoLinkPharoProcess class >> resolveServerExecutable [
	"Use the same executable as the receiver"

	^ FileLocator vmBinary resolve
]

{ #category : #accessing }
PharoLinkPharoProcess >> environmentVariables [
	"Answer the environment variables for the receiver.
	If the receiver's VM is being used, pass the environment varibales unchanged.
	If another executable is being used, remove the receiver's vm directory from LD_LIBRARY_PATH"

	^ environmentVariables ifNil: 
		[ environmentVariables := self settings serverExecutable = FileLocator vmBinary resolve
			ifTrue: [ Smalltalk os environment asDictionary ]
			ifFalse: [ self settings platform class subProcessEnvironmentDictionary ] ]
]

{ #category : #accessing }
PharoLinkPharoProcess >> errorMessage [
	^ process stderrStream contents
]

{ #category : #testing }
PharoLinkPharoProcess >> isRunning [
	^ process
		ifNil: [ false ]
		ifNotNil: [ process isRunning ]
]

{ #category : #private }
PharoLinkPharoProcess >> newProcess [
	| newProcess |
	newProcess := OSSUnixSubprocess new
				command: self settings serverExecutable fullName;
				arguments: self processArguments;
				workingDirectory: self workingDirectory resolve fullName;
"				redirectStdout;
				redirectStderr;"
				terminateOnShutdown;
				yourself.
	self environmentVariables associationsDo: [ :assoc |
		newProcess environmentAt: assoc key put: assoc value ].
	^ newProcess
]

{ #category : #accessing }
PharoLinkPharoProcess >> process [
	^ process
]

{ #category : #private }
PharoLinkPharoProcess >> processArguments [
	| args |

	args := OrderedCollection new.
	args 
		add: self settings serverImage fullName;
		add: 'clap';
		add: 'pharoLinkServer'.
	self debugMode ifTrue: [ args add: '--log' ].
	args
		add: self settings serverSocketAddress port asString;
		add: self settings clientSocketAddress port asString.
	^ args
]

{ #category : #'start-stop' }
PharoLinkPharoProcess >> start [

	self assert: process isNil.
	process := self newProcess.
	process run.
]

{ #category : #'start-stop' }
PharoLinkPharoProcess >> stop [
	process ifNil: [ ^ self ].
	[process queryExitStatus ifNil: [ process terminate ]] 
		on: Error 
		do: [ :e | "Do nothing."].
	process closeAndCleanStreams
]
