Class {
	#name : #JSLinkUtils,
	#superclass : #Object,
	#category : #'JSLink-Core'
}

{ #category : #'instance creation' }
JSLinkUtils class >> newVariable [
	^ self newVariableName asJSGI
]

{ #category : #'instance creation' }
JSLinkUtils class >> newVariableName [
	^ 'js' , UUID new asString36
]
