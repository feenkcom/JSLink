Class {
	#name : #JSLinkProxyObject,
	#superclass : #JSLinkObject,
	#instVars : [
		'application',
		'javaScriptClass'
	],
	#category : #'JSLink-Core'
}

{ #category : #'instance creation' }
JSLinkProxyObject class >> javaScriptClass: pythonClass var: pyVar application: application [
	^ self new
		javaScriptVariable: pyVar;
		javaScriptClass: pythonClass;
		application: application;
		yourself
]

{ #category : #accessing }
JSLinkProxyObject >> application [
	^ application
]

{ #category : #accessing }
JSLinkProxyObject >> application: anObject [
	application := anObject
]

{ #category : #accessing }
JSLinkProxyObject >> applicationClass [
	^ self application class
]

{ #category : #accessing }
JSLinkProxyObject >> at: anObject [

	^ JSGSubscription new
		target: self;
		insideBrackets: anObject;
		yourself
]

{ #category : #hooks }
JSLinkProxyObject >> createObject [
	self shouldNotImplement
]

{ #category : #'gt inspector' }
JSLinkProxyObject >> declarativeViews [
	"Answer the views for the receiver"
	| viewMethodNames rawViews viewDictionary |

	self viewProxyDo: [ :viewProxy | 
		viewMethodNames := JSLinkCF newCommandFactory
				<< (viewProxy => #getGtViewMethodNames) call;
				sendAndWait.
		rawViews := viewMethodNames collect: [ :viewSelector |
				viewDictionary := JSLinkCF newCommandFactory
					<< ((viewProxy => #getViewDeclaration) callWith: { viewSelector });
					sendAndWait.
				((GtDeclarativeView fromDictionary: viewDictionary)
					accessor: viewProxy;
					methodName: viewSelector;
					yourself) ] ].
	^ rawViews
]

{ #category : #'as yet unclassified' }
JSLinkProxyObject >> evaluateSourceSequence: aString [

	^ self newCommandFactory
		<< aString;
		sendAndWait.

]

{ #category : #'gt inspector' }
JSLinkProxyObject >> getViewProxy [
	"Answer a GtViewedProxy on the receiver"

	^ self application newCommandFactory
		<< (#GtViewedObject asJSGIdentifier <- (#require asJSGIdentifier callWith: { '../gtoolkit/gt' })) beLetDeclaration;
		<< (#viewedObject asJSGIdentifier <- self) beLetDeclaration;
		<< (#GtViewedObject asJSGIdentifier callWith: { #viewedObject asJSGIdentifier }) new;
		sendAndWait.

]

{ #category : #'gt inspector' }
JSLinkProxyObject >> gtLocalViewsFor: aView inContext: aContext [
	| title resultingView |
	title := String streamContents: [ :stream |
				stream
					<< 'Proxy to a(n): ';
					<< (javaScriptClass ifNil: [ '<None>' ]) ].
	resultingView := ((aView composite
		views: (self gtViewsInContext: aContext))
		labelled: title).
	^ resultingView
]

{ #category : #ui }
JSLinkProxyObject >> gtPlaygroundFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Playground' translated;
		priority: 10;
		text: [ '' asRopedText attributesBuilder attribute: (BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler) ];
		styler: application settings parserClass gtStyler;
		actionButtonIcon: BrGlamorousIcons playinspect  
			action: [ :aButton |
				| statements result |
				statements := aButton phlow textViewContent asString.
				result := self evaluateSourceSequence: statements.
				aButton phlow spawnObject: result ].

]

{ #category : #'gt inspector' }
JSLinkProxyObject >> gtProxyFor: aView [
	<gtProxy>

	^(self gtRawFor: aView)
		title: 'Proxy' translated;
		priority: 10000.
]

{ #category : #'gt inspector' }
JSLinkProxyObject >> gtProxyViewsFor: aView [
	<gtView>
	^ aView list
		title: 'Proxy views' translated;
		priority: 10001;
		items: [ 	self declarativeViews ];
		itemFormat: [ :view | view title ];
		send: [ :view | view ]
]

{ #category : #'gt inspector' }
JSLinkProxyObject >> gtSentItemFor: methodName at: selection [ 

	self assert: (PharoLinkRegistry isPrimitive: methodName).
	self assert: (PharoLinkRegistry isPrimitive: selection).

	^ application newCommandFactory
				<< ((self => #sentItem) callWith: { methodName. selection. });
					sendAndWait.
]

{ #category : #'gt inspector' }
JSLinkProxyObject >> gtViewsFor: aView [
	"this is the default entry method for retrieving the wrapper view containing all views"
	^ self gtViewsFor: aView inContext: nil
]

{ #category : #'gt inspector' }
JSLinkProxyObject >> gtViewsFor: aView inContext: aContext [
	"Add the declarative views from the inspectors object to the inspectors views"

	| resultingView inspectorViews |

	resultingView := self gtLocalViewsFor: aView inContext: aContext.
	inspectorViews := resultingView originalView views.

	"Add the explicitly declarative views from the inspected object"
	inspectorViews addAll: (self viewsFor: aView).

	"Re-sort by priority"
	inspectorViews := inspectorViews sorted: [ :a :b | a priority < b priority ].
	resultingView originalView views: inspectorViews.
	^resultingView
]

{ #category : #'gt inspector' }
JSLinkProxyObject >> gtViewsInContext: aContext [
	"This collects all views for the current object.
	For a proxy we just want the Raw view renamed as 'Proxy'"
	| emptyView |

	emptyView := GtPhlowEmptyView new.
	^ OrderedCollection new
		add: (self gtProxyFor: emptyView);
		add: (self gtProxyViewsFor: emptyView);
		add: (self gtPlaygroundFor: emptyView);
		yourself
]

{ #category : #'gt inspector' }
JSLinkProxyObject >> isGtViewedObject [
	"Answer a boolean indicating whether the receiver is a GtViewedProxy"

	^ javaScriptClass = #GtViewedObject
]

{ #category : #accessing }
JSLinkProxyObject >> javaScriptClass [
	^ javaScriptClass
]

{ #category : #accessing }
JSLinkProxyObject >> javaScriptClass: anObject [
	javaScriptClass := anObject
]

{ #category : #accessing }
JSLinkProxyObject >> javaScriptVariable: pyVar [
	javaScriptVariable := pyVar
]

{ #category : #serialization }
JSLinkProxyObject >> neoJsonOn: aWriter [

	{ '__class__' -> javaScriptClass.
	'__registryid__' -> self id. } asDictionary
		neoJsonOn: aWriter
]

{ #category : #'instance creation' }
JSLinkProxyObject >> newCommandFactory [

	^ application newCommandFactory
		addBinding: (PharoLinkBinding key: 'this' wrap: self);
		yourself
]

{ #category : #printing }
JSLinkProxyObject >> printOn: str [
	str 
		<< (javaScriptClass asString first isVowel ifTrue: ['an '] ifFalse: ['a ']);
		<< javaScriptClass asString;
		<< ' (Proxy)'
]

{ #category : #'gt inspector' }
JSLinkProxyObject >> viewProxyDo: aBlock [
	"Evaluate the supplied block ensuring that the receiver is a GtViewedObject"

	| viewProxy |

	viewProxy := javaScriptClass = #GtViewedObject
		ifTrue: [ self ]
		ifFalse: [ self getViewProxy ].
	aBlock value: viewProxy.

]

{ #category : #'gt inspector' }
JSLinkProxyObject >> viewsFor: aView [
	"Should be all views, but just get Raw and Print views for now"

	^ self declarativeViews collect: [ :declarativeView | declarativeView viewFor: aView ].

]
