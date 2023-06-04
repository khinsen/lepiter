Class {
	#name : #LeExportResourcesAssembler,
	#superclass : #Object,
	#traits : 'TLeExportResourcesAssembler + TLeExportResourceVisitor',
	#classTraits : 'TLeExportResourcesAssembler classTrait + TLeExportResourceVisitor classTrait',
	#instVars : [
		'resources'
	],
	#category : #'Lepiter-Export-Resources - Builders'
}

{ #category : #'api - building' }
LeExportResourcesAssembler >> assemble [
	"Assemble all non-ready resources"

	resources do: [ :each | 
		each state isReady ifFalse: [ 
			each acceptVisitor: self ] ]
]

{ #category : #'gt - extensions' }
LeExportResourcesAssembler >> gtResourcesFor: aView [
	<gtView>
	resources ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Resources';
		priority: 15;
		object: [ resources ];
		view: #gtResourcesFor:
]

{ #category : #accessing }
LeExportResourcesAssembler >> resources: aLeExportResources [
	self
		assert: [ aLeExportResources isNotNil ]
		description: [ 'Resources must be non-nil' ].
	self
		assert: [ resources isNil ]
		description: [ 'Resources must be initialized only once' ].
	
	resources := aLeExportResources
]

{ #category : #visiting }
LeExportResourcesAssembler >> visitExportElementSnippetResource: aResource [
	| aSnippetElement anExporter |
	
	aResource reference exists ifTrue: [
		"Do not compute twice"
		aResource beReadyState.
		^ self
	].
	
	aResource beAssemblingState.
	
	"Prepare element"
	aSnippetElement := aResource element.
	
	"Export"
	anExporter := LeElementToPngExporter new
		element: aSnippetElement;
		fileReference: aResource reference;
		height: aResource height;
		export.
		
	aSnippetElement snippetElement exception ifNotNil: [ :anException | 
		aResource reference exists
			ifFalse: [ aResource beAssemblingException: anException ]
			ifTrue: [ aResource beAssemblingInadequateOutput: anException ].
		^ self ].
		
	aResource reference exists ifTrue: [
		aResource beReadyState.
		^ self
	].
	
	"Export failure"
	aResource beProblemMessage: 'Problem during export'
]

{ #category : #visiting }
LeExportResourcesAssembler >> visitExportSlideResource: aResource [
	| anElement anExporter |
	aResource reference exists ifTrue: [
		"Do not compute twice"
		aResource beReadyState.
		^ self
	].
	
	aResource beAssemblingState.
	
	"Prepare slide element"
	[
		anElement := aResource slide asElement
	] on: Error do: [ :anException | 
		aResource beAssemblingException: anException.
		^ self
	].
	
	"Export"
	anExporter := LeElementToPngExporter new
		element: anElement;
		fileReference: aResource reference;
		height: aResource height;
		export.
	
	aResource reference exists ifTrue: [
		aResource beReadyState.
		^ self
	].
	
	"Export failure"
	aResource beProblemMessage: 'Problem during export'
]