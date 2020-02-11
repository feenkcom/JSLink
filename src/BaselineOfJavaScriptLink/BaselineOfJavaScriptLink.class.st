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
				baseline: 'OSSubprocess' 
				with: [ spec repository: 'github://pharo-contributions/OSSubprocess/repository' ].
			spec
				baseline: 'JavaScriptGenerator' 
				with: [ spec repository: 'github://feenkcom/JavaScriptGenerator:akg/repository' ].
			spec baseline: 'NeoJSON' with: [
                spec
                    repository: 'github://svenvc/NeoJSON/repository' ].
			spec baseline: 'MessagePack' with: [
                spec
                    repository: 'github://msgpack/msgpack-smalltalk:v1.3.1/repository' ].
			spec
				package: 'JSLink' with: [ spec requires: #('OSSubprocess' 'JavaScriptGenerator') ];
				package: 'JSLink-Pharo' with: [ spec requires: #('JSLink' 'MessagePack') ];
				package: 'JSLink-Bootstrap' with: [ spec requires: 'JSLink' ].
			 ]
]
