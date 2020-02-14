Class {
	#name : #JSLinkPharoPlatform,
	#superclass : #JSLinkPlatform,
	#category : #'JSLink-Pharo-Platform'
}

{ #category : #hooks }
JSLinkPharoPlatform class >> httpMessageBrokerClass [
	^ JSLinkHttpMessageBroker
]

{ #category : #hooks }
JSLinkPharoPlatform class >> pipenvProcessClass [
	^ JSLinkPharoNodejsProcess
]

{ #category : #accessing }
JSLinkPharoPlatform class >> priority [
	^ 10
]

{ #category : #hooks }
JSLinkPharoPlatform class >> socketMessageBrokerClass [

	"^ JSLinkMsgPackPharoBroker"
	^ JSLinkHttpMessageBroker 
]

{ #category : #private }
JSLinkPharoPlatform class >> uiManagerClass [
	^ JSLinkPharoUiManager
]

{ #category : #hooks }
JSLinkPharoPlatform class >> weakRegistryClass [
	^ JSLinkPharoWeakRegistry
]

{ #category : #'private - symlinks' }
JSLinkPharoPlatform >> createSymlinkFor: originalFile on: targetFile [
	OSSUnixSubprocess new
				command: '/bin/ln';
				arguments: (Array 
									with: '-s' 
									with: originalFile asFileReference fullName 
									with: targetFile asFileReference fullName);
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command | ^ self ].
]

{ #category : #'message broker strategy' }
JSLinkPharoPlatform >> defaultMessageBrokerClass [
	^ self class socketMessageBrokerClass
]

{ #category : #hooks }
JSLinkPharoPlatform >> ensureApplicationSymlinks: application [
	| appFolder |
	appFolder := self folderForApplication: application.
	self ensureFolderSymlinkFor: appFolder.
	self ensurePBridge: (self folderForApplication: application class baseApplication) symlinkIn: appFolder
]

{ #category : #'as yet unclassified' }
JSLinkPharoPlatform >> ensureEnvironmentForApp: anApplication [
	self ensureApplicationSymlinks: anApplication.
	self installEnvironmentForApp: anApplication.
]

{ #category : #'private - symlinks' }
JSLinkPharoPlatform >> ensureFolderSymlinkFor: aFolder [
	| symlinkRef |
	symlinkRef := aFolder basename asFileReference.
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: aFolder on: symlinkRef ]
]

{ #category : #'private - symlinks' }
JSLinkPharoPlatform >> ensurePBridge: pbridgeFolder symlinkIn: aFolder [
	| symlinkRef |
	symlinkRef := aFolder / 'PythonBridge'.
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: pbridgeFolder on: symlinkRef ].
]

{ #category : #utils }
JSLinkPharoPlatform >> folderForApplication: application [
	^ (IceRepository registry 
			detect: [ :each | each includesPackageNamed: application class package name ] 
			ifNone: [ 
				self inform: 'Please add a clone of this project to Iceberg to access to the resources'.
				"For travis!"
				^ '.' asFileReference ]) location
]

{ #category : #utils }
JSLinkPharoPlatform >> forceInstallEnvironmentForApp: application [
	| proc |
	self assert: JSLinkPharoNodejsProcess pipenvPath isEmptyOrNil not description: 'pipenv is apparently not accessible at a standard location. Please, have a look at the Troubleshooting section of https://objectprofile.github.io/PythonBridge/pages/pharo-installation'.
	proc := OSSUnixSubprocess new
				command: '/bin/bash';
				addAllEnvVariablesFromParentWithoutOverride;
				arguments: (Array 
					with: ((self folderForApplication: application) / 'install_env.sh') fullName);
				terminateOnShutdown;
				runAndWait.
	(proc exitStatus = 0 or: [ proc exitStatus < -1000 or: [ proc exitStatus > SmallInteger maxVal ] ]) ifFalse: [ 
		self signalPipenvCreateEnvFailed ]
]

{ #category : #utils }
JSLinkPharoPlatform >> installEnvironmentForApp: application [
	| folder |
	folder := self folderForApplication: application.
	(folder / '.venv') exists ifFalse: [ 
		self forceInstallEnvironmentForApp: application ]
]

{ #category : #hooks }
JSLinkPharoPlatform >> newRandomName [
	^ 'pb' , UUID new asString36
]

{ #category : #private }
JSLinkPharoPlatform >> signalPipenvCreateEnvFailed [
	"
	Python bridge attempt of creating Pipenv environment failed. To attempt to generate the Pipenv
	environment manually go the project git folder. It may be the PythonBridge, KerasBridge or your
	Bridge, because each of them has a different Pipfile and Pipenv environment.
	
	To remove the current Pipenv environment run in the folder the command: `pipenv --rm`
	To manually create the Pipenv environment run in the folder the command: `bash install_env.sh`
	"
	Error signal: 'Attempt for creating Pipenv environment failed.'
]
