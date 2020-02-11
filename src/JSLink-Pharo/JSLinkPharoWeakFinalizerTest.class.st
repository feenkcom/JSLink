Class {
	#name : #JSLinkPharoWeakFinalizerTest,
	#superclass : #JSLinkWeakFinalizerTest,
	#category : #'JSLink-Pharo-Platform'
}

{ #category : #running }
JSLinkPharoWeakFinalizerTest >> triggerGC [
	Smalltalk garbageCollect.
	(Delay forMilliseconds: 100) wait.
	Smalltalk garbageCollect.
]

{ #category : #running }
JSLinkPharoWeakFinalizerTest >> weakRegistryClass [
	^ JSLinkPharoWeakRegistry
]
