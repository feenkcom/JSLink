Class {
	#name : #JSLinkPharoNodejsProcess,
	#superclass : #JSLinkAbstractProcess,
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
	| proc |
	
	proc := OSSUnixSubprocess new
				command: 'which';
				arguments: (Array with: 'nodejs');
				redirectStdout;
				terminateOnShutdown.
	JSLinkPharoPlatform subProcessEnvironmentDictionary keysAndValuesDo: [ :key :value |
		proc environmentAt: key put: value ].
	(proc 	runAndWaitOnExitDo: [ :command :outString | ^ outString trim ]) 
		ifEmpty: [ self signalCommandNotFound: 'nodejs' ]
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

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> signalCommandNotFound: commandString [
	"JSLink use the unix command `which` to find the full path of the supplied command. From Pharo
	we could not find the path, therefore you have to set it mannualy.
		
	To find the path of a command in your system run the command `which <command>` in the terminal.
	To set the path in PythonBridge send the following message:
	
	JSLinkPharoNodejsProcess nodeJSPath: '/path/to/nodejs'.
	JSLinkPharoNodejsProcess npmPath: '/path/to/npm'."

	Error signal: 'Error: ', commandString, ' command could not be found.'
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
				command: 'nodejs';
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
		add: self settings javaScriptSocketAddress port asString;
		add: self settings pharoSocketAddress port asString.
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
