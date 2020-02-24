Class {
	#name : #LanguageLinkManualProcess,
	#superclass : #LanguageLinkAbstractProcess,
	#category : #'JSLink-Pharo-Processes'
}

{ #category : #accessing }
LanguageLinkManualProcess class >> workingDirectory [
	^ FileLocator workingDirectory
]

{ #category : #accessing }
LanguageLinkManualProcess >> errorMessage [

	^ '<see manually run process>'
]

{ #category : #'start-stop' }
LanguageLinkManualProcess >> isRunning [
	"true - the server is controlled externally and assumed to be running"

	^ true
]

{ #category : #'start-stop' }
LanguageLinkManualProcess >> start [
	"Do nothing - the server is controlled externally and assumed to be running"
]

{ #category : #'start-stop' }
LanguageLinkManualProcess >> stop [
	"Do nothing - the server is controlled externally and assumed to be running"
]
