Trait {
	#name : #JSLinkJavaScriptValueTrait,
	#category : #'JSLink-JSGenerator'
}

{ #category : #'attribute access' }
JSLinkJavaScriptValueTrait >> => aString [
	"Shortcut for #attributeNamed:."
	^ self attributeNamed: aString
]

{ #category : #'attribute access' }
JSLinkJavaScriptValueTrait >> attributeNamed: aString [
	"Returns an instance of P3GAttributeAccess to access the attribute with aString as name."
	^ JSGAttributeReference target: self attributeIdentifier: aString asJSGIdentifier
]

{ #category : #testing }
JSLinkJavaScriptValueTrait >> isLanguageLinkValue [
	^ true
]
