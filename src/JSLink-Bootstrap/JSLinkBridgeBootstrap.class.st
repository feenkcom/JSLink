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

{ #category : #'create classes' }
JSLinkBridgeBootstrap >> createApplication [
	| cls |
	cls := JSLinkApplication subclass: self applicationName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
	cls compile: 
'commandFactory
	^ ' , self commandFactoryName.
	cls compile:
'postInitialization
	"Insert here all statements related to the imports required by the bridge."
	'
]

{ #category : #'create classes' }
JSLinkBridgeBootstrap >> createCF [
	| cls |
	cls := JSLinkCF subclass: self commandFactoryName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
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

{ #category : #'create classes' }
JSLinkBridgeBootstrap >> createObject [
	| cls |
	cls := JSLinkObject subclass: self objectName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
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

{ #category : #'create classes' }
JSLinkBridgeBootstrap >> createTestCase [
	| cls |
	cls := LanguageLinkTestCase subclass: self testCaseName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
	cls compile: 
'applicationClass
	^ ' , self applicationName.
	cls class compile: 
'appResource
	^ ' , self testResourceName
]

{ #category : #'create classes' }
JSLinkBridgeBootstrap >> createTestResource [
	| cls |
	cls := JSLinkApplicationTestResource subclass: self testResourceName
				instanceVariableNames: ''
				classVariableNames: ''
				package: packageName.
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
