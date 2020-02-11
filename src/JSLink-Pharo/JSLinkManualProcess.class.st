Class {
	#name : #JSLinkManualProcess,
	#superclass : #JSLinkAbstractProcess,
	#category : #'JSLink-Pharo-Processes'
}

{ #category : #accessing }
JSLinkManualProcess class >> workingDirectory [
	^ FileLocator workingDirectory
]
