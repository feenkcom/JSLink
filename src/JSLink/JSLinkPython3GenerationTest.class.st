Class {
	#name : #JSLinkPython3GenerationTest,
	#superclass : #TestCase,
	#category : #'JSLink-Tests'
}

{ #category : #'as yet unclassified' }
JSLinkPython3GenerationTest >> getPythonCode: aPythonExpression [
	^ self getPythonCodeUsingStream: [ :str | aPythonExpression writeJavaScriptOn: str ]
]

{ #category : #'as yet unclassified' }
JSLinkPython3GenerationTest >> getPythonCodeUsingStream: aBlock [
	| stream |
	stream := String new writeStream.
	aBlock value: stream.
	^ stream contents
]

{ #category : #tests }
JSLinkPython3GenerationTest >> testBinding [
	| binding |
	binding := JSLinkBinding wrap: 32.
	self 
		assert: (self getPythonCode: binding) 
		equals: binding key
]

{ #category : #tests }
JSLinkPython3GenerationTest >> testObserverNotify [
	| obs |
	obs := JSLinkObserver callback: [ 32 ].
	obs command: JSLinkCommand new.
	self 
		assert: (self getPythonCode: (obs pythonNotify: 'foobar')) 
		equals: 'await observer(''' , obs command id , ''',''' , obs id , ''')(''foobar'')'
]
