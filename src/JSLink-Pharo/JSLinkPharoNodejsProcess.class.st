Class {
	#name : #JSLinkPharoNodejsProcess,
	#superclass : #LanguageLinkAbstractProcess,
	#instVars : [
		'process',
		'environmentVariables',
		'serverDebugger'
	],
	#classVars : [
		'NodejsPath'
	],
	#category : #'JSLink-Pharo-Processes'
}

{ #category : #'class initialization' }
JSLinkPharoNodejsProcess class >> initialize [ 

	SessionManager default registerUserClassNamed: self name.
]

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> nodejsPath [
	^ NodejsPath 
			ifNil: [ NodejsPath := self resolveNodejsPath ]
			ifNotNil: [ NodejsPath ]
]

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> nodejsPath: aString [
	NodejsPath := aString
]

{ #category : #accessing }
JSLinkPharoNodejsProcess class >> nodejsPathForApplication: aJSApplication [
	"Answer the NodeJS path for the supplied application.
	This currently assumes a single installation per machine"

	NodejsPath ifNotNil: [ ^ NodejsPath ].
	NodejsPath := aJSApplication settings serverExecutable.
	(NodejsPath isNil or: [ NodejsPath exists not ]) ifTrue:
		[ NodejsPath := self resolveNodejsPath ].
	^ NodejsPath.
]

{ #category : #accessing }
JSLinkPharoNodejsProcess class >> npmPathForApplication: aJSApplication [
	"Answer the npm path for the supplied application.
	Assume it is in the same directory as the nodejs executable.  If not, search the PATH."
	| npmPath nodejsPath |

	nodejsPath := self nodejsPathForApplication: aJSApplication.
	nodejsPath ifNotNil: 
		[ npmPath := nodejsPath parent / 'npm'.
		npmPath exists ifTrue: [ ^ npmPath ] ].
	^ self resolveNpmPath.
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
	^ path asFileReference
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

{ #category : #'system startup' }
JSLinkPharoNodejsProcess class >> startUp: resuming [
	"On startup any instances saved during the last session will be invalid (since the processes are terminated on shutdown).  Mark them as stopped."

	resuming ifTrue: 
		[ self allInstancesDo: [ :each | each stop ] ]
]

{ #category : #'start-stop' }
JSLinkPharoNodejsProcess >> debuggerPausedAction [
	"Respond to the debugger state changed notification.
	Signal all promises that the debugger has been paused."

	^ [ self application notifyDebuggerPaused: serverDebugger ]
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
				command: self nodejsPath fullName;
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
JSLinkPharoNodejsProcess >> nodejsPath [
	| fileReference |

	fileReference := self settings serverExecutable.
	fileReference ifNil: [ fileReference := self class nodejsPath ].
	fileReference isExecutable ifFalse: [ self class signalCommandNotFound: fileReference fullName ].
	^ fileReference.
]

{ #category : #accessing }
JSLinkPharoNodejsProcess >> process [
	^ process
]

{ #category : #private }
JSLinkPharoNodejsProcess >> processArguments [
	| args |

	args := OrderedCollection new.
	self settings serverDebugMode ifTrue: 
		[ args add: '--inspect' ].
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
	self settings serverDebugMode ifTrue:
		[ self startServerDebugger ].
]

{ #category : #'start-stop' }
JSLinkPharoNodejsProcess >> startServerDebugger [
	"Start the debugger, tell the server to run and set up inspection on halt"

	"Give the server time to start"
	1 second wait.
	serverDebugger := CDTDebuggerServer new endPoints first connect.
	serverDebugger announcer when: CDTDebuggerPaused do: self debuggerPausedAction.
	"serverDebugger resume."
]

{ #category : #'start-stop' }
JSLinkPharoNodejsProcess >> stop [
	process ifNil: [ ^ self ].
	[ 	self settings serverDebugMode ifTrue:
		[ self stopServerDebugger ].
	process queryExitStatus ifNil: [ process terminate ]] 
		on: Error 
		do: [ :e | "Do nothing."].
	process closeAndCleanStreams.
	process := nil.
]

{ #category : #'start-stop' }
JSLinkPharoNodejsProcess >> stopServerDebugger [
	"Close the debugger and deregister"

	serverDebugger close.
	serverDebugger announcer unsubscribe: self debuggerPausedAction
]
