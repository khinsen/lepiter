Class {
	#name : #LesPageResourceVisitor,
	#superclass : #LeResourcesVisitor,
	#traits : 'TLeModelVisitor',
	#classTraits : 'TLeModelVisitor classTrait',
	#instVars : [
		'page'
	],
	#category : #'Lepiter-HTML-Old-Exporter'
}

{ #category : #building }
LesPageResourceVisitor >> compute [
	self page acceptVisitor: self.
	^ self resources
]

{ #category : #accessing }
LesPageResourceVisitor >> page [
	^ page
]

{ #category : #accessing }
LesPageResourceVisitor >> page: anObject [
	page := anObject
]

{ #category : #accessing }
LesPageResourceVisitor >> visitExampleSnippet: aLeSnippet [
	^ self visitContent: aLeSnippet
]

{ #category : #visiting }
LesPageResourceVisitor >> visitPictureSnippet: aLePictureSnippet [
	| fileName fileReference |
	fileName := aLePictureSnippet urlString.

	(fileName beginsWith: 'https://' caseSensitive: false) ifTrue: [ ^ self ].

	fileReference := aLePictureSnippet database monitor localRoot asFileReference
			/ fileName.

	fileReference exists ifFalse: [ ^ self ].

	self
		addResource: (LeLocalAttachmentResource new
				source: aLePictureSnippet;
				name: fileName;
				fileReference: fileReference)
]

{ #category : #visiting }
LesPageResourceVisitor >> visitTextSnippet: aLeTextSnippet [
	| snippetVisitor |
	snippetVisitor := LeTextSnippetResourcesVisitor new
		textSnippet: aLeTextSnippet.
	snippetVisitor compute.
	self addResources: snippetVisitor resources.
	
	^ self visitTextualSnippet: aLeTextSnippet
]

{ #category : #visiting }
LesPageResourceVisitor >> visitTweetReferenceSnippet: aLeTweetReferenceSnippet [
	^ self visitTextualSnippet: aLeTweetReferenceSnippet
]

{ #category : #accessing }
LesPageResourceVisitor >> visitYoutubeReferenceSnippet: aLeSnippet [
	^ self visitContent: aLeSnippet
]