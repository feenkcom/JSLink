Class {
	#name : #JSLinkObject,
	#superclass : #Object,
	#traits : 'JSGAttributeAccess + JSGCallable',
	#classTraits : 'JSGAttributeAccess classTrait + JSGCallable classTrait',
	#instVars : [
		'javaScriptVariable'
	],
	#category : #'JSLink-Core'
}

{ #category : #'instance creation' }
JSLinkObject class >> fromJavaScriptReference: pythonVar [
	^ super new
			javaScriptVariable: pythonVar;
			yourself.
]

{ #category : #'instance creation' }
JSLinkObject class >> fromProxy: aProxy [
	| obj |
	obj := self new.
	obj javaScriptVariable: aProxy javaScriptVariable.
	self assert: obj javaScriptClass asString = aProxy javaScriptVariable.
	^ obj
]

{ #category : #'instance creation' }
JSLinkObject class >> newJavaScriptVar [

	^ LanguageLinkUtils newVariableName asJSGI 
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
			(self javaScriptConstructor 
				callWith: posArgs 
				with: nameArgs asDictionary)
]

{ #category : #'as yet unclassified' }
JSLinkObject >> basicCreateObjectExpr: anExpression [
	| varName cf |
	self isCreated ifTrue: [ ^ self ].
	varName := self newJavaScriptVar.
	javaScriptVariable := varName.
	cf := self application newCommandFactory.
	cf << (
		self registerIdJSExpression: anExpression).
	self registerObject.
	cf send.
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
	^ javaScriptVariable name
]

{ #category : #'as yet unclassified' }
JSLinkObject >> isCreated [
	^ javaScriptVariable notNil
]

{ #category : #p3generator }
JSLinkObject >> isJavaScriptGenerable [
	^ true
]

{ #category : #testing }
JSLinkObject >> isLanguageLinkValue [
	^ true
]

{ #category : #'as yet unclassified' }
JSLinkObject >> javaScriptClass [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
JSLinkObject >> javaScriptClassName [
	^ self javaScriptClass attributeIdentifier name
]

{ #category : #'as yet unclassified' }
JSLinkObject >> javaScriptConstructor [
	^ self javaScriptClass
]

{ #category : #'as yet unclassified' }
JSLinkObject >> javaScriptRegistryExpression [
	^ #registry jsCallWith: #()
]

{ #category : #accessing }
JSLinkObject >> javaScriptVariable [
	^ javaScriptVariable
]

{ #category : #accessing }
JSLinkObject >> module [
	^ self applicationClass module
]

{ #category : #'instance creation' }
JSLinkObject >> newJavaScriptVar [
	^ self class newJavaScriptVar
]

{ #category : #'as yet unclassified' }
JSLinkObject >> registerIdJSExpression: objExpr [
	^ self javaScriptRegistryExpression => #register_with_id jsCallWith: (Array with: objExpr with: self id)
]

{ #category : #'as yet unclassified' }
JSLinkObject >> registerObject [
	self application registerObject: self
]

{ #category : #'as yet unclassified' }
JSLinkObject >> resolveIdJSExpression [
	^ self javaScriptRegistryExpression => #resolve jsCallWith: (Array with: self id)
]

{ #category : #'as yet unclassified' }
JSLinkObject >> writeJavaScriptOn: aStream [
	self assert: self isCreated.
	self resolveIdJSExpression writeJavaScriptOn: aStream
]
