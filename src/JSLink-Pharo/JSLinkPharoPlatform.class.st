Class {
	#name : #JSLinkPharoPlatform,
	#superclass : #JSLinkPlatform,
	#classVars : [
		'RuntimeSourceDirectory'
	],
	#category : #'JSLink-Pharo-Platform'
}

{ #category : #accessing }
JSLinkPharoPlatform class >> runtimeSourceDirectory [
	<return: #AbstractFileReference>

	^ RuntimeSourceDirectory
]

{ #category : #accessing }
JSLinkPharoPlatform class >> runtimeSourceDirectory: anAbstractFileReference [
	"Set the directory the contains the runtime files.
	nil = not specified"

	RuntimeSourceDirectory := anAbstractFileReference
]

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
	| srcDir cpCommand proc error |

	srcDir := self runtimeSourceDirectoryFor: application.
	srcDir resolve = appFolder resolve ifTrue: [ ^ self ].

	"Copy the runtime directory"
	cpCommand := String streamContents: [ :stream |
		stream
			<< 'cp -a ';
			<< srcDir fullName;
			<< ' ';
			<< appFolder fullName ].
	proc := GtUnixSubprocess new 
		shellCommand: cpCommand;
		runAndWait.
	proc isSuccess ifFalse:
		[ error := LanguageLinkProcessError new
			messageText: 'Unable to install JSLink runtime';
			application: application;
			process: proc.
		error signal ].

]

{ #category : #hooks }
JSLinkPharoPlatform >> ensureApplicationDirectory: application [
	"If the runtimeFolder doesn't exist, attempt to symlink to the respository directory"
	| appFolder |

	application settings workingDirectory exists ifFalse:
		[ appFolder := application settings workingDirectory.
		appFolder exists ifTrue: [ ^ self ].
		self copyApplicationTo: appFolder application: application ].
	self setExecutableFor: application.

]

{ #category : #private }
JSLinkPharoPlatform >> ensureEnvironmentForApp: anApplication [

	self ensureApplicationDirectory: anApplication.
	self installEnvironmentForApp: anApplication.
]

{ #category : #accessing }
JSLinkPharoPlatform >> folderForApplication [
	"Answer the directory where JSLink runs from"

	^ FileLocator imageDirectory / 'js'
]

{ #category : #utils }
JSLinkPharoPlatform >> forceInstallEnvironmentForApp: application [
	| proc workingDir npm error |

	self assert: (JSLinkPharoNodejsProcess nodejsPathForApplication: application) isNotNil description:
'Unable to find the nodejs command.
Please ensure it is installed and in the default path for the pharo process.'.
	npm := JSLinkPharoNodejsProcess npmPathForApplication: application.
	self assert: npm isNotNil description: 
'Unable to find the npm command.
Please ensure it is installed and in the default path for the pharo process.'.
	workingDir := application settings workingDirectory.
	proc := GtUnixSubprocess new
				workingDirectory: workingDir resolve fullName;
				command: npm fullName;
				arguments: { 'install' };
				terminateOnShutdown.
	self class subProcessEnvironmentDictionary keysAndValuesDo: [ :key :value |
		proc environmentAt: key put: value ].
	proc runAndWait.
	proc isSuccess ifFalse:
		[ error := LanguageLinkProcessError new
			messageText: 'Unable to install npm modules';
			application: application;
			process: proc.
		error signal ].

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
	| proc workingDir npm error |

	npm := JSLinkPharoNodejsProcess npmPathForApplication: application.
	workingDir := application settings workingDirectory.
	proc := GtUnixSubprocess new
				workingDirectory: workingDir resolve fullName;
				command: npm fullName;
				arguments: { 'install'. moduleName. };
				terminateOnShutdown.
	self class subProcessEnvironmentDictionary keysAndValuesDo: [ :key :value |
		proc environmentAt: key put: value ].
	proc runAndWait.
	proc isSuccess ifFalse:
		[ error := LanguageLinkProcessError new
			messageText: 'Unable to install module: ', moduleName asString;
			application: application;
			process: proc.
		error signal ].

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

{ #category : #utils }
JSLinkPharoPlatform >> runtimeSourceDirectoryFor: aJSLinkApplication [
	"Answer the source directory containing the runtime files.
	This is the first of:
	1. RuntimeSourceDirectory (if specified)
	2. The git repository copy.
	3. An existing copy in the image directory"
	| fileReference |

	(RuntimeSourceDirectory isNotNil and: [ RuntimeSourceDirectory exists ]) ifTrue: 
		[ ^ RuntimeSourceDirectory ].
	IceRepository registry 
			detect: [ :each | each includesPackageNamed: aJSLinkApplication class package name ] 
			ifFound: [ :repository | 
					fileReference := repository location / 'js'.
					fileReference exists ifTrue: [ ^ fileReference ] ]
			ifNone: [ ].
	fileReference := self folderForApplication.
	fileReference exists ifTrue: [ ^ fileReference ].
	self error: 'Unable to locate JSLink runtime source'.
]

{ #category : #private }
JSLinkPharoPlatform >> setExecutableFor: application [
	"Copy the PythonBridge runtime environment to the specified folder"
	| chmodCommand proc error appFolderString |

	appFolderString := application settings workingDirectory resolve fullName copyReplaceAll: '"' with: '\"'.
	chmodCommand := String streamContents: [ :stream |
		stream
			<< 'chmod +x "';
			<< appFolderString;
			<< '"/*.sh' ].
	proc := GtUnixSubprocess new 
		shellCommand: chmodCommand;
		runAndWait.
	proc isSuccess ifFalse:
		[ error := LanguageLinkProcessError new
			messageText: 'Unable to set JSLink runtime executable bits';
			application: application;
			process: proc.
		error signal ].

]
