Class {
	#name : #BaselineOfJavaScriptLink,
	#superclass : #BaselineOf,
	#category : #BaselineOfJavaScriptLink
}

{ #category : #baselines }
BaselineOfJavaScriptLink >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [			
			spec
				baseline: 'JavaScriptGenerator' 
				with: [ spec repository: 'github://feenkcom/JavaScriptGenerator/repository' ].
			spec 
				baseline: 'PharoLink'
				with: [ spec repository: 'github://feenkcom/PharoLink/src' ].
			spec
				package: 'JSLink' with: [ spec requires: #('PharoLink' 'JavaScriptGenerator') ];
				package: 'JSLink-Pharo' with: [ spec requires: #('JSLink') ];
				package: 'JSLink-Bootstrap' with: [ spec requires: #('JSLink') ].
			 ]
]
