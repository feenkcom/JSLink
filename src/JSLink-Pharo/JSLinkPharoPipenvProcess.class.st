Class {
	#name : #JSLinkPharoPipenvProcess,
	#superclass : #JSLinkAbstractProcess,
	#instVars : [
		'process',
		'environmentVariables'
	],
	#classVars : [
		'PipenvPath'
	],
	#category : #'JSLink-Pharo-Processes'
}

{ #category : #initialization }
JSLinkPharoPipenvProcess class >> pipenvPath [
	^ PipenvPath isEmptyOrNil 
			ifTrue: [ PipenvPath := self resolvePipenvPath ]
			ifFalse: [ PipenvPath ]
]

{ #category : #initialization }
JSLinkPharoPipenvProcess class >> pipenvPath: aString [
	PipenvPath := aString
]

{ #category : #accessing }
JSLinkPharoPipenvProcess class >> platform [
	^ JSLinkPharoPlatform current
]

{ #category : #initialization }
JSLinkPharoPipenvProcess class >> resolvePipenvPath [
	^ (OSSUnixSubprocess new
				command: '/usr/bin/which';
				arguments: (Array with: 'pipenv');
				addAllEnvVariablesFromParentWithoutOverride;
				redirectStdout;
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command :outString | ^ outString trim ]) 
					ifEmpty: [ self signalPipenvNotFound ]
]

{ #category : #initialization }
JSLinkPharoPipenvProcess class >> signalPipenvNotFound [
	"
	PythonBridge use the unix command `which` to find the route of the `pipenv` command. From Pharo
	we could not find the route, therefore you have to set it mannualy.
		
	To find the path of Pipenv in your system run the command `which pipenv` in the terminal.
	To set the path in PythonBridge send the following message:
	
	PBProcessHandler pipEnvPath: '/PATH/TO/PIPENV/BINARY'
	
	"
	Error signal: 'Error: Pipenv command could not be found.'
]

{ #category : #accessing }
JSLinkPharoPipenvProcess >> environmentVariables [
	^ environmentVariables
]

{ #category : #accessing }
JSLinkPharoPipenvProcess >> errorMessage [
	^ process stderrStream contents
]

{ #category : #initialization }
JSLinkPharoPipenvProcess >> initialize [
	super initialize.
	environmentVariables := Dictionary new.
	self setDefaultEnvironmentVariables
]

{ #category : #testing }
JSLinkPharoPipenvProcess >> isRunning [
	^ process
		ifNil: [ false ]
		ifNotNil: [ process isRunning ]
]

{ #category : #private }
JSLinkPharoPipenvProcess >> newProcess [
	| newProcess |
	newProcess := OSSUnixSubprocess new
				command: '/usr/bin/nodejs';
				arguments: self processArguments;
				workingDirectory: (FileLocator imageDirectory / 'js/inspector-app') resolve fullName;
				addAllEnvVariablesFromParentWithoutOverride;
"				redirectStdout;
				redirectStderr;"
				terminateOnShutdown;
				yourself.
	environmentVariables associationsDo: [ :assoc |
		newProcess environmentAt: assoc key put: assoc value ].
	^ newProcess
]

{ #category : #accessing }
JSLinkPharoPipenvProcess >> process [
	^ process
]

{ #category : #private }
JSLinkPharoPipenvProcess >> processArguments [
	| args |
	args := OrderedCollection new.
	args
		add: (FileLocator imageDirectory / 'js/inspector-app/src/app.js') resolve fullName;
		add: self settings pythonSocketAddress port asString;
		add: self settings pharoSocketAddress port asString.
	^ args
]

{ #category : #initialization }
JSLinkPharoPipenvProcess >> setDefaultEnvironmentVariables [
	environmentVariables
		at: 'LC_ALL' put: 'en_US.UTF-8';
		at: 'LANG' put: 'en_US.UTF-8';
		at: 'PIPENV_VENV_IN_PROJECT' put: '1';
		at: 'PIP_DEFAULT_TIMEOUT' put: '100'
]

{ #category : #'start-stop' }
JSLinkPharoPipenvProcess >> start [
	process := self newProcess.
	process run.
]

{ #category : #'start-stop' }
JSLinkPharoPipenvProcess >> stop [
	process ifNil: [ ^ self ].
	[process queryExitStatus ifNil: [ process terminate ]] 
		on: Error 
		do: [ :e | "Do nothing."].
	process closeAndCleanStreams
]
