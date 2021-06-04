"
This class contains tests

"
Class {
	#name : #JSLinkSimpleApplicationTest,
	#superclass : #JSLinkApplicationTest,
	#category : #'JSLink-Tests'
}

{ #category : #tests }
JSLinkSimpleApplicationTest >> testDoubleRetrieveValue [
	| promise |
	self cf << (JSGBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself).
	promise := self cf send.
	self assert: promise waitForValue equals: 3.
	self cf << (JSGBinaryOperator new
						left: 3;
						right: 4;
						operator: $*;
						yourself).
	promise := self cf send.
	self assert: promise waitForValue equals: 12
]

{ #category : #tests }
JSLinkSimpleApplicationTest >> testSimpleLambda [
	self cf << ((JSGLambda 
						argument: #a asJSGI
						expression: #a asJSGI + 1) jsCallWith: #( 2 )).
	self assert: self cf send waitForValue equals: 3
]

{ #category : #tests }
JSLinkSimpleApplicationTest >> testSimpleMapping [
	| obj type |

	self cf << (#TestClass asJSGI <- #'./dummy' require) beVarDeclaration.
	"self cf << (JSGExpression new expression: 'new TestClass()')."
	self cf << #TestClass jsCall new.
	obj := self cf sendAndWait.
	type := self cf sendAndWait: (obj => #constructor => #name).
	self application addMapping: type to: (JSGLambda 
														argument: #x asJSGI 
														expression: 'mapped to this').
	self assert: (self cf sendAndWait: obj) equals: 'mapped to this'
]

{ #category : #tests }
JSLinkSimpleApplicationTest >> testSimpleRetrieveSameValue [
	| promise |
	self cf << (JSGBinaryOperator new
						left: 1;
						right: 2;
						operator: $+;
						yourself).
	promise := self cf send.
	self assert: promise waitForValue equals: 3
]

{ #category : #tests }
JSLinkSimpleApplicationTest >> testSimpleRetrieveSameValue2 [
	| promise |
	self cf << (JSGBinaryOperator new
						left: 3;
						right: 4;
						operator: $*;
						yourself).
	promise := self cf send.
	self assert: promise waitForValue equals: 12
]
