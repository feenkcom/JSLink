Class {
	#name : #JSLinkObject,
	#superclass : #Object,
	#traits : 'JSGAttributeAccess + JSGCallable',
	#classTraits : 'JSGAttributeAccess classTrait + JSGCallable classTrait',
	#instVars : [
		'pythonVariable'
	],
	#category : #'JSLink-Core'
}

{ #category : #'instance creation' }
JSLinkObject class >> fromProxy: aProxy [
	| obj |
	obj := self new.
	obj pythonVariable: aProxy pythonVariable.
	self assert: obj pythonClass asString = aProxy pythonVariable.
	^ obj
]

{ #category : #'instance creation' }
JSLinkObject class >> fromPythonReference: pythonVar [
	^ super new
			pythonVariable: pythonVar;
			yourself.
]

{ #category : #'instance creation' }
JSLinkObject class >> newPythonVar [
	^ JSLinkPlatform current newRandomName asJSGIdentifier
]

{ #category : #initialization }
JSLinkObject >> application [
	^ self applicationClass uniqueInstance
]

{ #category : #initialization }
JSLinkObject >> applicationClass [
	self class == JSLinkObject ifTrue: [ ^ JSLinkApplication ].
	self subclassResponsibility
]

{ #category : #'attribute access' }
JSLinkObject >> attributeNamed: aString [
	"Returns an instance of P3GAttributeAccess to access the attribute with aString as name."
	^ JSGAttributeReference target: self attributeIdentifier: aString asJSGIdentifier
]

{ #category : #'as yet unclassified' }
JSLinkObject >> basicCreateObject [
	self basicCreateObjectArgs: #()
]

{ #category : #'as yet unclassified' }
JSLinkObject >> basicCreateObjectArgs: posArgs [
	self basicCreateObjectArgs: posArgs nameArgs: Dictionary new
]

{ #category : #'as yet unclassified' }
JSLinkObject >> basicCreateObjectArgs: posArgs nameArgs: nameArgs [
	^ self basicCreateObjectExpr: 
			(self pythonConstructor 
				callWith: posArgs 
				with: nameArgs asDictionary)
]

{ #category : #'as yet unclassified' }
JSLinkObject >> basicCreateObjectExpr: anExpression [
	| varName |
	self isCreated ifTrue: [ ^ self ].
	varName := self newPythonVar.
	pythonVariable := varName.
	self application commandFactory << (
		self registerIdPyExpression: anExpression).
	self registerObject.
	self application commandFactory send.
]

{ #category : #call }
JSLinkObject >> callWith: anArrayOrADictionary [
	^ anArrayOrADictionary jsgCallArgumentsOf: self
]

{ #category : #call }
JSLinkObject >> callWith: anArray with: aDictionary [
	^ JSGCall target: self positionalArguments: anArray keywordArguments: aDictionary
]

{ #category : #'as yet unclassified' }
JSLinkObject >> createObject [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
JSLinkObject >> ensureCreateObject [
	self isCreated ifFalse: [ self createObject ]
]

{ #category : #accessing }
JSLinkObject >> id [
	^ pythonVariable name
]

{ #category : #'as yet unclassified' }
JSLinkObject >> isCreated [
	^ pythonVariable notNil
]

{ #category : #p3generator }
JSLinkObject >> isJavaScriptValue [
	^ true
]

{ #category : #p3generator }
JSLinkObject >> isPythonGenerable [
	^ true
]

{ #category : #accessing }
JSLinkObject >> module [
	^ self applicationClass module
]

{ #category : #'instance creation' }
JSLinkObject >> newPythonVar [
	^ self class newPythonVar
]

{ #category : #'as yet unclassified' }
JSLinkObject >> pythonClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
JSLinkObject >> pythonClassName [
	^ self pythonClass attributeIdentifier name
]

{ #category : #'as yet unclassified' }
JSLinkObject >> pythonConstructor [
	^ self pythonClass
]

{ #category : #'as yet unclassified' }
JSLinkObject >> pythonRegistryExpression [
	^ #registry callWith: #()
]

{ #category : #accessing }
JSLinkObject >> pythonVariable [
	^ pythonVariable
]

{ #category : #'as yet unclassified' }
JSLinkObject >> registerIdPyExpression: objExpr [
	^ self pythonRegistryExpression => #register_with_id callWith: (Array with: objExpr with: self id)
]

{ #category : #'as yet unclassified' }
JSLinkObject >> registerObject [
	self application registerObject: self
]

{ #category : #'as yet unclassified' }
JSLinkObject >> resolveIdPyExpression [
	^ self pythonRegistryExpression => #resolve callWith: (Array with: self id)
]

{ #category : #'as yet unclassified' }
JSLinkObject >> writeJavaScriptOn: aStream [
	self assert: self isCreated.
	self resolveIdPyExpression writeJavaScriptOn: aStream
]
