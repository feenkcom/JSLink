"
This class contains tests

"
Class {
	#name : #JSLinkPharoProcessTest,
	#superclass : #JSLinkProcessTest,
	#category : #'JSLink-Pharo-Processes'
}

{ #category : #utils }
JSLinkPharoProcessTest >> createTmpJavaScriptFile [
	| file |
	file := FileLocator workingDirectory / 'tmp.js'.
	file writeStream close.
	^ file
]

{ #category : #utils }
JSLinkPharoProcessTest >> defaultTmpFile [
	^ 'tmp.py' asFileReference
]

{ #category : #utils }
JSLinkPharoProcessTest >> destroyTmpFile: aFile [
	aFile deleteIfAbsent: [  ]
]

{ #category : #hooks }
JSLinkPharoProcessTest >> processClass [
	^ JSLinkPharoNodejsProcess
]
