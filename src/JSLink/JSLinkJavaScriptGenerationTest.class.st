Class {
	#name : #JSLinkJavaScriptGenerationTest,
	#superclass : #JSLinkTestCase,
	#category : #'JSLink-Tests'
}

{ #category : #private }
JSLinkJavaScriptGenerationTest >> getJavaScriptCode: aPythonExpression [
	^ self getJavaScriptCodeUsingStream: [ :str | aPythonExpression writeLinkLanguageOn: str ]
]

{ #category : #private }
JSLinkJavaScriptGenerationTest >> getJavaScriptCodeUsingStream: aBlock [
	| stream |
	stream := String new writeStream.
	aBlock value: stream.
	^ stream contents
]

{ #category : #tests }
JSLinkJavaScriptGenerationTest >> testBinding [
	| binding |
	binding := JSLinkBinding wrap: 32.
	self 
		assert: (self getJavaScriptCode: binding) 
		equals: binding key
]

{ #category : #tests }
JSLinkJavaScriptGenerationTest >> testObserverNotify [
	| obs |
	obs := JSLinkObserver callback: [ 32 ].
	obs command: self application newCommand.
	self 
		assert: (self getJavaScriptCode: (obs javaScriptNotify: 'foobar')) 
		equals: 'await observer(''' , obs command id , ''',''' , obs id , ''')(''foobar'')'
]
