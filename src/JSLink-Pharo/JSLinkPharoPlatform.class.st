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
	
	self folderForApplication exists ifFalse:
		[ self ensureFolderSymlinkFor: self jsRepositoryFolder ].

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
	workingDir := self folderForApplication.
	proc := OSSUnixSubprocess new
				workingDirectory: workingDir resolve fullName;
				command: npm;
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
	folder := self folderForApplication.
	(folder / 'node_modules') exists ifFalse: [ 
		self forceInstallEnvironmentForApp: application ]
]

{ #category : #utils }
JSLinkPharoPlatform >> installModule: moduleName in: application [
	"Install the requested node.js module using npm"
	| proc workingDir npm |

	npm := JSLinkPharoNodejsProcess resolveNpmPath.
	self assert: npm isEmptyOrNil not description: 
'Unable to find the npm command.
Please ensure it is installed and in the default path for the pharo process.'.
	workingDir := self folderForApplication.
	proc := OSSUnixSubprocess new
				workingDirectory: workingDir resolve fullName;
				command: npm;
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

{ #category : #private }
JSLinkPharoPlatform >> signalInstallEnvFailed [
	"The attempt to install all the required packages with npm failed for some reason"

	Error signal: 'npm install failed.'
]
