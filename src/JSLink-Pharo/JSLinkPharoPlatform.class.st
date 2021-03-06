Class {
	#name : #JSLinkPharoPlatform,
	#superclass : #JSLinkPlatform,
	#category : #'JSLink-Pharo-Platform'
}

{ #category : #hooks }
JSLinkPharoPlatform class >> socketMessageBrokerClass [

	"^ JSLinkMsgPackPharoBroker"
	^ LanguageLinkHttpMessageBroker 
]

{ #category : #private }
JSLinkPharoPlatform class >> uiManagerClass [
	^ LanguageLinkPharoUiManager
]

{ #category : #hooks }
JSLinkPharoPlatform class >> weakRegistryClass [
	^ LanguageLinkPharoWeakRegistry
]

{ #category : #copying }
JSLinkPharoPlatform >> copyApplicationTo: appFolder application: application [
	"Copy the PythonBridge runtime environment to the specified folder"
	| srcDir cpCommand proc |

	srcDir := self jsRepositoryFolder.
	(srcDir exists and: [ srcDir ~= appFolder ]) ifFalse: 
		[ srcDir := self folderForApplication ].
	srcDir exists ifFalse: 
		[ self error: 'Unable to locate JSLink runtime files' ].
	"Copy the runtime directory"
	cpCommand := String streamContents: [ :stream |
		stream
			<< 'cp -a ';
			<< srcDir fullName;
			<< ' ';
			<< appFolder fullName ].
	proc := OSSUnixSubprocess new 
		shellCommand: cpCommand;
		runAndWait.
	proc isSuccess ifFalse:
		[ self error: 'Unable to install JSLink runtime' ].

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

{ #category : #hooks }
JSLinkPharoPlatform >> ensureApplicationDirectory: application [
	"If the runtimeFolder doesn't exist, attempt to symlink to the respository directory"

	application settings workingDirectory exists ifFalse:
		[ self ensureApplicationDirectoryFor: application ].

]

{ #category : #'as yet unclassified' }
JSLinkPharoPlatform >> ensureApplicationDirectoryFor: application [
	| appFolder |

	appFolder := application settings workingDirectory.
	appFolder exists ifTrue: [ ^ self ].
	appFolder ensureCreateDirectory.
	self copyApplicationTo: appFolder application: application.

]

{ #category : #private }
JSLinkPharoPlatform >> ensureEnvironmentForApp: anApplication [

	self ensureApplicationDirectory: anApplication.
	self installEnvironmentForApp: anApplication.
]

{ #category : #'private - symlinks' }
JSLinkPharoPlatform >> ensureFolderSymlinkFor: aFolder [
	| symlinkRef |
	symlinkRef := aFolder basename asFileReference.
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: aFolder on: symlinkRef ]
]

{ #category : #accessing }
JSLinkPharoPlatform >> folderForApplication [
	"Answer the directory where JSLink runs from"

	^ FileLocator imageDirectory / 'js'
]

{ #category : #utils }
JSLinkPharoPlatform >> forceInstallEnvironmentForApp: application [
	| proc workingDir npm |

	self assert: (JSLinkPharoNodejsProcess nodejsPathForApplication: application) isNotNil description:
'Unable to find the nodejs command.
Please ensure it is installed and in the default path for the pharo process.'.
	npm := JSLinkPharoNodejsProcess npmPathForApplication: application.
	self assert: npm isNotNil description: 
'Unable to find the npm command.
Please ensure it is installed and in the default path for the pharo process.'.
	workingDir := application settings workingDirectory.
	proc := OSSUnixSubprocess new
				workingDirectory: workingDir resolve fullName;
				command: npm fullName;
				arguments: { 'install' };
				terminateOnShutdown.
	self class subProcessEnvironmentDictionary keysAndValuesDo: [ :key :value |
		proc environmentAt: key put: value ].
	proc runAndWait.
	proc isSuccess ifFalse: [ 
		self signalInstallEnvFailed ]
]

{ #category : #utils }
JSLinkPharoPlatform >> installEnvironmentForApp: application [
	| folder |
	folder := application settings workingDirectory.
	(folder / 'node_modules') exists ifFalse: [ 
		self forceInstallEnvironmentForApp: application ]
]

{ #category : #utils }
JSLinkPharoPlatform >> installModule: moduleName in: application [
	"Install the requested node.js module using npm"
	| proc workingDir npm |

	npm := JSLinkPharoNodejsProcess npmPathForApplication: application.
	workingDir := application settings workingDirectory.
	proc := OSSUnixSubprocess new
				workingDirectory: workingDir resolve fullName;
				command: npm fullName;
				arguments: { 'install'. moduleName. };
				terminateOnShutdown.
	self class subProcessEnvironmentDictionary keysAndValuesDo: [ :key :value |
		proc environmentAt: key put: value ].
	proc runAndWait.
	proc isSuccess ifFalse: [ 
		self signalInstallEnvFailed ]
]

{ #category : #utils }
JSLinkPharoPlatform >> jsRepositoryFolder [
	"Answer the js directory where the JSLink repository is typically cloned"

	^ (IceRepository registry 
			detect: [ :each | each includesPackageNamed: self class package name ] 
			ifNone: [ 
				self inform: 'Please add a clone of this project to Iceberg to access to the resources'.
				"For travis!"
				^ '.' asFileReference ]) location / 'js'
]

{ #category : #hooks }
JSLinkPharoPlatform >> newRandomName [
	^ 'js' , UUID new asString36
]

{ #category : #accessing }
JSLinkPharoPlatform >> runtimeFolderForApplication: application [
	"Answer the directory where the PythonBridge runtime files are located"

	^ application settings workingDirectory ifNil:
		[ self folderForApplication ]
]

{ #category : #private }
JSLinkPharoPlatform >> signalInstallEnvFailed [
	"The attempt to install all the required packages with npm failed for some reason"

	Error signal: 'npm install failed.'
]
