Class {
	#name : #JSLinkPharoNodejsProcess,
	#superclass : #LanguageLinkAbstractProcess,
	#instVars : [
		'process',
		'environmentVariables'
	],
	#classVars : [
		'NodejsPath'
	],
	#category : #'JSLink-Pharo-Processes'
}

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> nodejsPath [
	^ NodejsPath isEmptyOrNil 
			ifTrue: [ NodejsPath := self resolveNodejsPath ]
			ifFalse: [ NodejsPath ]
]

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> nodejsPath: aString [
	NodejsPath := aString
]

{ #category : #accessing }
JSLinkPharoNodejsProcess class >> platform [
	^ JSLinkPharoPlatform current
]

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> resolveNodejsPath [
	| path |

	path := self resolveNodejsPath: 'nodejs'.
	path ifEmpty: [ path := self resolveNodejsPath: 'node' ].
	path ifEmpty: [ self signalCommandNotFound: 'nodejs/node' ].
	^path
]

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> resolveNodejsPath: commandName [
	| proc |
	
	proc := OSSUnixSubprocess new
				command: 'which';
				arguments: (Array with: commandName);
				redirectStdout;
				terminateOnShutdown.
	JSLinkPharoPlatform subProcessEnvironmentDictionary keysAndValuesDo: [ :key :value |
		proc environmentAt: key put: value ].
	proc runAndWaitOnExitDo: [ :command :outString | ^ outString trim ]

]

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> resolveNpmPath [
	| proc |

	proc := OSSUnixSubprocess new
				command: 'which';
				arguments: (Array with: 'npm');
				addAllEnvVariablesFromParentWithoutOverride;
				redirectStdout;
				terminateOnShutdown.
	JSLinkPharoPlatform subProcessEnvironmentDictionary keysAndValuesDo: [ :key :value |
		proc environmentAt: key put: value ].
	(proc 	runAndWaitOnExitDo: [ :command :outString | ^ outString trim ]) 
		ifEmpty: [ self signalCommandNotFound: 'npm' ]
]

{ #category : #accessing }
JSLinkPharoNodejsProcess >> environmentVariables [
	^ environmentVariables
]

{ #category : #accessing }
JSLinkPharoNodejsProcess >> errorMessage [
	^ process stderrStream contents
]

{ #category : #initialization }
JSLinkPharoNodejsProcess >> initialize [
	super initialize.
	environmentVariables := Dictionary new.
	self setDefaultEnvironmentVariables
]

{ #category : #testing }
JSLinkPharoNodejsProcess >> isRunning [
	^ process
		ifNil: [ false ]
		ifNotNil: [ process isRunning ]
]

{ #category : #private }
JSLinkPharoNodejsProcess >> newProcess [
	| newProcess |
	newProcess := OSSUnixSubprocess new
				command: self class nodejsPath;
				arguments: self processArguments;
				workingDirectory: self workingDirectory resolve fullName;
"				redirectStdout;
				redirectStderr;"
				terminateOnShutdown;
				yourself.
	environmentVariables associationsDo: [ :assoc |
		newProcess environmentAt: assoc key put: assoc value ].
	^ newProcess
]

{ #category : #accessing }
JSLinkPharoNodejsProcess >> process [
	^ process
]

{ #category : #private }
JSLinkPharoNodejsProcess >> processArguments [
	| args |

	args := OrderedCollection new.
	args
		add: (self workingDirectory / 'src/app.js') resolve fullName;
		add: self settings serverSocketAddress port asString;
		add: self settings clientSocketAddress port asString.
	^ args
]

{ #category : #initialization }
JSLinkPharoNodejsProcess >> setDefaultEnvironmentVariables [

	environmentVariables := JSLinkPharoPlatform subProcessEnvironmentDictionary.
]

{ #category : #'start-stop' }
JSLinkPharoNodejsProcess >> start [
	process := self newProcess.
	process run.
]

{ #category : #'start-stop' }
JSLinkPharoNodejsProcess >> stop [
	process ifNil: [ ^ self ].
	[process queryExitStatus ifNil: [ process terminate ]] 
		on: Error 
		do: [ :e | "Do nothing."].
	process closeAndCleanStreams
]
