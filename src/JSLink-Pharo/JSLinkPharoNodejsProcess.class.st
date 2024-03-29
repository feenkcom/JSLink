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
JSLinkPharoNodejsProcess class >> nodejsPath: aFileReference [

	NodejsPath := aFileReference
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
	
	proc := GtSubprocessWithInMemoryOutput new
				command: 'which';
				arguments: (Array with: commandName).
	JSLinkPharoPlatform subProcessEnvironmentDictionary keysAndValuesDo: [ :key :value |
		proc environmentAt: key put: value ].
	proc runAndWait.
	(#(0 1) includes: proc exitCode) ifFalse:
		[ self error: 'Unable to request ', commandName asString, ' location' ].
	^ proc stdout trim.

]

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> resolveNpmPath [
	| proc path |

	proc := GtSubprocessWithInMemoryOutput new
				command: 'which';
				arguments: (Array with: 'npm');
				terminateOnShutdown.
	JSLinkPharoPlatform subProcessEnvironmentDictionary keysAndValuesDo: [ :key :value |
		proc environmentAt: key put: value ].
	proc runAndWait.
	(#(0 1) includes: proc exitCode) ifFalse:
		[ self error: 'Unable to determine npm path' ].
	path := proc stdout trim.
	path ifEmpty: [ self signalCommandNotFound: 'npm' ].
	^ path
]

{ #category : #initialization }
JSLinkPharoNodejsProcess class >> serverPath [
	^ NodejsPath 
			ifNil: [ NodejsPath := self resolveNodejsPath ]
			ifNotNil: [ NodejsPath ]
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

{ #category : #accessing }
JSLinkPharoNodejsProcess >> exitCode [

	^ process
		ifNil: [ nil ]
		ifNotNil: [ process exitCode ]
]

{ #category : #accessing }
JSLinkPharoNodejsProcess >> exitStatusInterpreter [

	^ process exitStatusInterpreter
]

{ #category : #testing }
JSLinkPharoNodejsProcess >> hasProcess [
	"Answer a boolean indicating whether the receiver has a process object"

	^ process isNotNil
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
	newProcess := GtSubprocessWithInMemoryOutput new
				command: self serverPath fullName;
				arguments: self processArguments;
				workingDirectory: self workingDirectory resolve fullName;
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
	self settings serverDebugMode ifTrue: 
		[ args add: '--inspect' ].
	args 
		add: (self workingDirectory / 'src/app.js') resolve fullName;
		add: self settings serverSocketAddress port asString;
		add: self settings clientSocketAddress port asString.
	^ args
]

{ #category : #accessing }
JSLinkPharoNodejsProcess >> serverPath [
	| fileReference |

	fileReference := self settings serverExecutable.
	fileReference ifNil: [ fileReference := self class serverPath ].
	^ fileReference.
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
	| cdtDebugger retries |

	retries := 10.
	300 milliSeconds wait.
	[ cdtDebugger := CDTDebuggerServer new endPoints first connect ]
		on: ConnectionTimedOut
		do: [ :ex |
			retries > 0 ifTrue:
				[ retries := retries - 1.
				300 milliSeconds wait.
				ex retry ]
			ifFalse:
				[ ex pass ] ].
	cdtDebugger announcer when: CDTDebuggerPaused do: self debuggerPausedAction.

	serverDebugger := DAPJavaScriptDebugger new cdtDebugger: cdtDebugger.
]

{ #category : #accessing }
JSLinkPharoNodejsProcess >> stderr [
	"Answer the process stderr contents"

	^ process stderr
]

{ #category : #accessing }
JSLinkPharoNodejsProcess >> stdout [ 
	"Answer the process stdout contents"

	^ process stdout
]

{ #category : #'start-stop' }
JSLinkPharoNodejsProcess >> stop [
	process ifNil: [ ^ self ].
	[ 	serverDebugger ifNotNil:
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
