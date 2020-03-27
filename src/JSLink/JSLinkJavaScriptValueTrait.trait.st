Trait {
	#name : #JSLinkJavaScriptValueTrait,
	#traits : 'JSGAttributeAccess',
	#category : #'JSLink-JSGenerator'
}

{ #category : #'attribute access' }
JSLinkJavaScriptValueTrait >> attributeNamed: aString [
	"Returns an instance of P3GAttributeAccess to access the attribute with aString as name."
	^ JSGAttributeReference target: self attributeIdentifier: aString asJSGIdentifier
]

{ #category : #testing }
JSLinkJavaScriptValueTrait >> isLanguageLinkValue [
	^ true
]
