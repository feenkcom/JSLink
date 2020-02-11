Class {
	#name : #JSLinkLog,
	#superclass : #Object,
	#instVars : [
		'message'
	],
	#category : #'JSLink-Logs'
}

{ #category : #accessing }
JSLinkLog class >> message: aString [
	^ self new
		message: aString;
		yourself
]

{ #category : #testing }
JSLinkLog >> isError [
	^ false
]

{ #category : #accessing }
JSLinkLog >> message [
	^ message
]

{ #category : #accessing }
JSLinkLog >> message: anObject [
	message := anObject
]

{ #category : #printing }
JSLinkLog >> printOn: str [
	message
		ifNil: [ super printOn: str ]
		ifNotNil: [
			str 
				<< self class name; 
				<< ': ';
				<< message;
				cr ]
]
