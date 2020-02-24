Class {
	#name : #PharoLinkPharoPlatform,
	#superclass : #PharoLinkPlatform,
	#category : #'JSLink-Pharo-Platform'
}

{ #category : #hooks }
PharoLinkPharoPlatform class >> socketMessageBrokerClass [

	"^ JSLinkMsgPackPharoBroker"
	^ JSLinkHttpMessageBroker 
]

{ #category : #private }
PharoLinkPharoPlatform class >> uiManagerClass [
	^ JSLinkPharoUiManager
]

{ #category : #hooks }
PharoLinkPharoPlatform class >> weakRegistryClass [
	^ JSLinkPharoWeakRegistry
]

{ #category : #'private - symlinks' }
PharoLinkPharoPlatform >> createSymlinkFor: originalFile on: targetFile [
	OSSUnixSubprocess new
				command: '/bin/ln';
				arguments: (Array 
									with: '-s' 
									with: originalFile asFileReference fullName 
									with: targetFile asFileReference fullName);
				terminateOnShutdown;
				runAndWaitOnExitDo: [ :command | ^ self ].
]

{ #category : #'as yet unclassified' }
PharoLinkPharoPlatform >> ensureEnvironmentForApp: anApplication [
	" Currently assumes the current environment, so nothing to do"
]

{ #category : #'private - symlinks' }
PharoLinkPharoPlatform >> ensureFolderSymlinkFor: aFolder [
	| symlinkRef |
	symlinkRef := aFolder basename asFileReference.
	symlinkRef exists ifFalse: [ 
		self createSymlinkFor: aFolder on: symlinkRef ]
]

{ #category : #utils }
PharoLinkPharoPlatform >> folderForApplication: application [

	^ FileLocator imageDirectory
]

{ #category : #hooks }
PharoLinkPharoPlatform >> newRandomName [
	^ 'pb' , UUID new asString36
]

{ #category : #private }
PharoLinkPharoPlatform >> signalInstallEnvFailed [
	"The attempt to install all the required packages with npm failed for some reason"

	Error signal: 'npm install failed.'
]
