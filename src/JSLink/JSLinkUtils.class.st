Class {
	#name : #JSLinkUtils,
	#superclass : #Object,
	#category : #'JSLink-Core'
}

{ #category : #'instance creation' }
JSLinkUtils class >> newP3Variable [
	^ self newP3VariableName asJSGI
]

{ #category : #'instance creation' }
JSLinkUtils class >> newP3VariableName [
	^ JSLinkPlatform current newRandomName
]
