"
This class contains tests

"
Class {
	#name : #JSLinkJavaScriptObjectTest,
	#superclass : #JSLinkApplicationTest,
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkJavaScriptObjectTest >> stubJavaScriptObjectExpression [

	^ #registry asJSGI  jsCallWith: #()
]

{ #category : #tests }
JSLinkJavaScriptObjectTest >> testProxyIdentity [
	| obj |

	self cf << self stubJavaScriptObjectExpression.
	obj := self cfSend waitForValue.
	self assert: obj class equals: JSLinkProxyObject.
	self assertInstanceClass: obj name: 'Registry'.
	self cf << (self resolveId: obj id).
	self assert: self cfSend waitForValue equals: obj.

	"Manually remove the item from the registry as the GC may not have kicked in before the next test is run."
	self cf << (self application executionHandler removeId: obj id).
	self cfSend.

]

{ #category : #tests }
JSLinkJavaScriptObjectTest >> testSimpleObjectIdentity [
	| obj |
	obj := (JSLinkProxyObject new application: self application) 
				basicCreateObjectExpr: self stubJavaScriptObjectExpression.
	self cf << obj.
	self assert: self cfSend waitForValue equals: obj.
	self assertExpression: (self resolveId: obj id) equals: obj.

	"Manually remove the item from the registry as the GC may not have kicked in before the next test is run."
	self cf << (self application executionHandler removeId: obj id).
	self cfSend.

]

{ #category : #tests }
JSLinkJavaScriptObjectTest >> testSimpleProxy [
	| obj |
	self cf << self stubJavaScriptObjectExpression.
	obj := self cfSend waitForValue.
	self assert: obj class equals: JSLinkProxyObject.
	self assertInstanceClass: obj name: 'Registry'.
	self assertExpression: (obj => #hasId jsCallWith: #(0)) equals: false.

	"Manually remove the item from the registry as the GC may not have kicked in before the next test is run."
	self cf << (self application executionHandler removeId: obj id).
	self cfSend.

]
