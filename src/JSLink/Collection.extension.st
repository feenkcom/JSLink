Extension { #name : #Collection }

{ #category : #'*JSLink' }
Collection >> ensureDo: aBlock [
	self do: [ :el | aBlock valueUninterruptably ]
]
