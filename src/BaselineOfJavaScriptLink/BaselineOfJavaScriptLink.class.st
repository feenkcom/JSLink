Class {
	#name : #BaselineOfJavaScriptLink,
	#superclass : #BaselineOf,
	#category : #BaselineOfJavaScriptLink
}

{ #category : #baseline }
BaselineOfJavaScriptLink >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'JavaScriptGenerator' with: [
				spec repository: 'github://feenkcom/JavaScriptGenerator:v0.5.129/repository' ].
		spec
			baseline: 'PharoLink' with: [
				spec repository: 'github://feenkcom/PharoLink:v0.8.109/src' ].

		spec package: 'JSLink' with: [
			spec requires: #('PharoLink' 'JavaScriptGenerator') ].
		spec package: 'JSLink-Pharo' with: [
			spec requires: #('JSLink') ].
		spec package: 'JSLink-Bootstrap' with: [
			spec requires: #('JSLink') ].
	]
]
