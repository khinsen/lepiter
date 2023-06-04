Class {
	#name : #LeExportVisitorExamples,
	#superclass : #Object,
	#traits : 'TLeExportResourceAssertions + TLeExportFileStoreAssertions',
	#classTraits : 'TLeExportResourceAssertions classTrait + TLeExportFileStoreAssertions classTrait',
	#category : #'Lepiter-Export-Examples'
}

{ #category : #'examples - element snippet' }
LeExportVisitorExamples >> elementSnippetWithGlamorousBreadcrumb [
	<gtExample>
	| snippet resources visitor holder fileStore |
	holder := LeExportSnippetExamples new elementSnippetWithGlamorousBreadcrumb.
	snippet := holder snippet.
	visitor := LeExportVisitor new
			context: (LeExportContext new 
				resources: (resources := LeExportResources new);
				fileStore: (fileStore := LeExportMemoryStore new)).

	snippet acceptVisitor: visitor.

	self assertResources: resources size: 1.
	self assertNotReadyResources: resources.
	
	self assertFileStoreIsEmpty: fileStore.

	^ LeExportVisitorHolder new
		visitor: visitor;
		snippet: snippet
]

{ #category : #'examples - element snippet' }
LeExportVisitorExamples >> elementSnippetWithGlamorousBreadcrumb_AssembleResources [
	<gtExample>
	| resources holder context |
	holder := self elementSnippetWithGlamorousBreadcrumb.
	context := holder context.
	resources := holder resources.
	
	context assembler assemble.
	
	self assertReadyResources: resources.
	self assertFileStoreIsNotEmpty: holder fileStore.

	^ holder
]

{ #category : #'examples - element snippet' }
LeExportVisitorExamples >> elementSnippetWithSlideshow [
	<gtExample>
	| specifications snippet context visitor resources allSlides slidesHolder |
	slidesHolder := LeExportSnippetExamples new elementSnippetWithSlideshow.
	snippet := slidesHolder snippet.
	allSlides := slidesHolder allSlides.

	specifications := LeExportSpecificationsExamples new snippetSpecifications.
	resources := LeExportResources new.

	context := LeExportContext new.
	context specifications: specifications.
	context resources: resources.

	visitor := LeExportVisitor new context: context.

	snippet acceptVisitor: visitor.

	self assertResources: resources size: allSlides size.
	self assertNotReadyResources: resources.

	^ LeExportVisitorHolder new
		visitor: visitor;
		snippet: snippet
]

{ #category : #'examples - element snippet' }
LeExportVisitorExamples >> elementSnippetWithSlideshow_PrepareResources [
	<gtExample>
	| resources context holder |
	holder := self elementSnippetWithSlideshow.
	context := holder context.
	resources := context resources.
	
	context assembler assemble.

	self assertReadyResources: resources.

	^ holder
]

{ #category : #'examples - element snippet' }
LeExportVisitorExamples >> elementSnippetWithZeroSlides [
	<gtExample>
	| specifications snippet context visitor resources allSlides slidesHolder |
	slidesHolder := LeExportSnippetExamples new elementSnippetWithZeroSlides.
	snippet := slidesHolder snippet.
	allSlides := slidesHolder allSlides.
	
	self 
		assert: allSlides isEmpty 
		description: [ 'All slides must be empty' ].

	specifications := LeExportSpecificationsExamples new snippetSpecifications.
	resources := LeExportResources new.

	context := LeExportContext new.
	context specifications: specifications.
	context resources: resources.

	visitor := LeExportVisitor new context: context.

	snippet acceptVisitor: visitor.

	self assert: resources asArray size equals: 1.
	self 
		assert: (resources asArray allSatisfy: [ :each | each state isReady not ])
		description: [ 'Resource must NOT be ready.' ].

	^ LeExportVisitorHolder new
		visitor: visitor;
		snippet: snippet
]

{ #category : #'examples - picture snippet' }
LeExportVisitorExamples >> pictureSnippetWithExistingFileReference [
	<gtExample>
	| snippet resources context visitor |
	snippet := LeExportSnippetExamples new pictureSnippetWithExistingFileReference.
	
	visitor := LeExportVisitor new
			context: (context := LeExportContext new
				resources: (resources := LeExportResources new)).
	
	snippet acceptVisitor: visitor.
	
	self assertResources: resources size: 1.
	self assertReadyResources: resources.
	
	^ LeExportVisitorHolder new
		visitor: visitor;
		snippet: snippet
]

{ #category : #'examples - picture snippet' }
LeExportVisitorExamples >> pictureSnippetWithHttps [
	<gtExample>
	| snippet resources context visitor |
	snippet := LeExportSnippetExamples new pictureSnippetWithHttps.
	
	visitor := LeExportVisitor new
			context: (context := LeExportContext new
				resources: (resources := LeExportResources new)).
	
	snippet acceptVisitor: visitor.
	
	self assertResources: resources size: 1.
	self assertReadyResources: resources.

	^ LeExportVisitorHolder new 
		visitor: visitor;
		snippet: snippet
]

{ #category : #'examples - picture snippet' }
LeExportVisitorExamples >> pictureSnippetWithMissingFileReference [
	<gtExample>
	| snippet resources context visitor |
	snippet := LeExportSnippetExamples new pictureSnippetWithMissingFileReference.
	
	visitor := LeExportVisitor new
			context: (context := LeExportContext new
				resources: (resources := LeExportResources new)).
	
	snippet acceptVisitor: visitor.
	
	self assertResources: resources size: 1.
	self assertNotReadyResources: resources.
	self assertFailedResources: resources.
	
	^ LeExportVisitorHolder new 
		visitor: visitor;
		snippet: snippet
]

{ #category : #'examples - picture snippet' }
LeExportVisitorExamples >> pictureSnippetWithMissingFileReference_PrepareResources [
	<gtExample>
	| resources context holder |
	holder := self pictureSnippetWithMissingFileReference.
	context := holder context.
	resources := context resources.
	
	context assembler assemble.

	self assertNotReadyResources: resources.

	^ holder
]

{ #category : #'examples - element snippet' }
LeExportVisitorExamples >> snippetElementWithZeroSlides_PrepareResources [
	<gtExample>
	| resources visitor context |
	visitor := self elementSnippetWithZeroSlides.
	context := visitor context.
	resources := context resources.
	
	context assembler assemble.

	self 
		assert: resources asArray size
		equals: 1.
	self 
		assert: (resources asArray allSatisfy: [ :each | each state isReady ])
		description: [ 'Resource must be ready.' ].
	self 
		assert: resources asArray first state isFailure 
		description: [ 'Resource must have inadequate output (an exception)' ].

	^ visitor
]