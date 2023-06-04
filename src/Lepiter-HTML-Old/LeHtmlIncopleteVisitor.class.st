Class {
	#name : #LeHtmlIncopleteVisitor,
	#superclass : #LeHtmlVisitorOld,
	#category : #'Lepiter-HTML-Old-! New - Examples'
}

{ #category : #visiting }
LeHtmlIncopleteVisitor >> visitElementSnippet: aLeElementSnippet [
	"It overrides the method with the purpose to test use cases when unsupported snippets are supposed to be exported"

	^ self visitSnippet: aLeElementSnippet
]