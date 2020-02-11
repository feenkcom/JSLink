Class {
	#name : #JSLinkPythonObjectTest,
	#superclass : #JSLinkApplicationTest,
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkPythonObjectTest >> setUp [

	super setUp.
	"self cf << (#PythonBridge asP3GI => #object_registry) import"
]

{ #category : #tests }
JSLinkPythonObjectTest >> stubPythonObjectExpression [

	^ #registry asJSGI callWith: #()
]

{ #category : #tests }
JSLinkPythonObjectTest >> testProxyIdentity [
	| obj |
	self cf << self stubPythonObjectExpression.
	obj := self cfSend waitForValue.
	self assert: obj class equals: JSLinkProxyObject.
	self assertInstanceClass: obj name: 'Registry'.
	self cf << (self resolveId: obj id).
	self assert: self cfSend waitForValue equals: obj
]

{ #category : #tests }
JSLinkPythonObjectTest >> testSimpleObjectIdentity [
	| obj |
	obj := JSLinkObject new basicCreateObjectExpr: self stubPythonObjectExpression.
	self cf << obj.
	self assert: self cfSend waitForValue equals: obj.
	self assertExpression: (self resolveId: obj id) equals: obj
]

{ #category : #tests }
JSLinkPythonObjectTest >> testSimpleProxy [
	| obj |
	self cf << self stubPythonObjectExpression.
	obj := self cfSend waitForValue.
	self assert: obj class equals: JSLinkProxyObject.
	self assertInstanceClass: obj name: 'Registry'.
	self assertExpression: (obj => #hasId callWith: #(0)) equals: false
]
