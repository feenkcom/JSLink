Class {
	#name : #JSLinkBridgeBootstrap,
	#superclass : #Object,
	#instVars : [
		'bridgeName',
		'prefix',
		'packageName'
	],
	#category : #'JSLink-Bootstrap-PythonBridge-Bootstrap'
}

{ #category : #'as yet unclassified' }
JSLinkBridgeBootstrap class >> createBridge: bridgeName prefix: prefix packageNamed: packageName [
	^ self new
		bridgeName: bridgeName;
		prefix: prefix;
		packageName: packageName;
		create
]

{ #category : #accessing }
JSLinkBridgeBootstrap >> applicationClass [
	^ Smalltalk at: self applicationName
]

{ #category : #names }
JSLinkBridgeBootstrap >> applicationName [
	^ bridgeName asSymbol
]

{ #category : #accessing }
JSLinkBridgeBootstrap >> bridgeName: anObject [
	bridgeName := anObject
]

{ #category : #names }
JSLinkBridgeBootstrap >> commandFactoryName [
	^ prefix , 'CF'
]

{ #category : #create }
JSLinkBridgeBootstrap >> create [
	self createClasses.
	self createRepository.
	self createFiles.
]

{ #category : #creation }
JSLinkBridgeBootstrap >> createApplication [
	| cls |
	cls := ((JSLinkApplication << self applicationName)
		slots: {};
		package: packageName) install.
	cls compile: 
'commandFactory
	^ ' , self commandFactoryName.
	cls compile:
'postInitialization
	"Insert here all statements related to the imports required by the bridge."
	'
]

{ #category : #creation }
JSLinkBridgeBootstrap >> createCF [
	| cls |
	cls := ((JSLinkCF << self commandFactoryName)
		slots: {};
		package: packageName) install.
	cls class compile: 
'applicationClass
	^ ' , self applicationName
]

{ #category : #create }
JSLinkBridgeBootstrap >> createClasses [
	self createApplication.
	self createCF.
	self createObject.
	self createTestCase.
	self createTestResource.
]

{ #category : #create }
JSLinkBridgeBootstrap >> createFiles [
	| folder |
	folder := self applicationClass repositoryFileReference.
	JSLinkApplication repositoryFileReference / 'start_bridge.py' copyTo: folder / 'start_bridge.py'.
	JSLinkApplication repositoryFileReference / 'Pipfile' copyTo: folder / 'Pipfile'.
	JSLinkApplication repositoryFileReference / 'install_env.sh' copyTo: folder / 'install_env.sh'.
]

{ #category : #creation }
JSLinkBridgeBootstrap >> createObject [
	| cls |
	cls := ((JSLinkObject << self objectName)
		slots: {};
		package: packageName) install.
	cls compile: 
'applicationClass
	^ ' , self applicationName
]

{ #category : #create }
JSLinkBridgeBootstrap >> createRepository [
	| repo |
	repo:= IceRepositoryCreator new 
				subdirectory: 'src';
				location: self packageName asFileReference;
				createNewRepositoryNamed: self packageName.
	repo register.
	repo workingCopy addPackageNamed: self packageName
]

{ #category : #creation }
JSLinkBridgeBootstrap >> createTestCase [
	| cls |
	cls := ((JSLinkTestCase << self testCaseName)
		slots: {};
		package: packageName) install.
	cls compile: 
'applicationClass
	^ ' , self applicationName.
	cls class compile: 
'appResource
	^ ' , self testResourceName
]

{ #category : #creation }
JSLinkBridgeBootstrap >> createTestResource [
	| cls |
	cls := ((JSLinkApplicationTestResource << self testResourceName)
		slots: {};
		package: packageName) install.
	cls compile: 
'applicationClass
	^ ' , self applicationName
]

{ #category : #names }
JSLinkBridgeBootstrap >> objectName [
	^ prefix , 'Object'
]

{ #category : #names }
JSLinkBridgeBootstrap >> packageName [
	^ packageName
]

{ #category : #accessing }
JSLinkBridgeBootstrap >> packageName: anObject [
	packageName := anObject
]

{ #category : #accessing }
JSLinkBridgeBootstrap >> prefix: anObject [
	prefix := anObject
]

{ #category : #names }
JSLinkBridgeBootstrap >> testCaseName [
	^ prefix , 'TestCase'
]

{ #category : #names }
JSLinkBridgeBootstrap >> testResourceName [
	^ prefix , 'TestResource'
]
