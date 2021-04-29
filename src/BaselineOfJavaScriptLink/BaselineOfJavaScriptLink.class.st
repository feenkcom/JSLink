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
				spec repository: 'github://feenkcom/JavaScriptGenerator:v0.5.126/repository' ];
			baseline: 'PharoLink' with: [
				spec repository: 'github://feenkcom/PharoLink:v0.8.41/src' ].
		spec 
			package: 'JSLink' with: [
				spec requires: #('PharoLink' 'JavaScriptGenerator' ). ];
			package: 'JSLink-Pharo' with: [
				spec requires: #('JSLink' ). ];
			package: 'JSLink-Bootstrap' with: [
				spec requires: #('JSLink' ). ]. ].

]
