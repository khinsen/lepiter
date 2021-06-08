"
LeEvaluatedSnippetElement provides the common elements required to evaluate and display the results of strings (typically code snippets).

"
Class {
	#name : #LeEvaluatedSnippetElement,
	#superclass : #LeTextualSnippetElement,
	#instVars : [
		'spawnDestinationLook',
		'editorElement',
		'coderContentModel',
		'coderToolbar',
		'arrowElement',
		'previewContainer'
	],
	#category : #'Lepiter-UI-Snippet-! Views'
}

{ #category : #testing }
LeEvaluatedSnippetElement class >> isAbstract [
	^ self = LeEvaluatedSnippetElement
]

{ #category : #'private - accessing' }
LeEvaluatedSnippetElement >> arrowElement [
	^ arrowElement
]

{ #category : #actions }
LeEvaluatedSnippetElement >> clearPreview [
	self arrowElement visibility: BlVisibility gone.
	self previewContainer 
		visibility: BlVisibility gone;
		removeChildNamed: #previewElement.
]

{ #category : #'private - accessing' }
LeEvaluatedSnippetElement >> coder [
	<return: #GtPharoSourceCoder>

	^ self snippetViewModel coderViewModel coder
]

{ #category : #'private - accessing' }
LeEvaluatedSnippetElement >> coderViewModel [
	<return: #GtSourceCoderViewModel>

	^ self snippetViewModel coderViewModel
]

{ #category : #accessing }
LeEvaluatedSnippetElement >> editor [
	<return: #BrTextEditor>

	^ editorElement editor
]

{ #category : #initialization }
LeEvaluatedSnippetElement >> initialize [
	super initialize.
	
	coderContentModel := GtSourceCoderContentModel new.
	self addViewModel: coderContentModel
]

{ #category : #initialization }
LeEvaluatedSnippetElement >> initializeCoderToolbar [
	coderToolbar := GtCoderActionsElement new.
	spawnDestinationLook := GtSourceCoderSpawnDestinationAptitude new.
	coderToolbar addAptitude: spawnDestinationLook.
]

{ #category : #initialization }
LeEvaluatedSnippetElement >> initializeSpawnDownElements [
	arrowElement := self newArrowElement.
	previewContainer := self newPreviewContainer
]

{ #category : #'instance creation' }
LeEvaluatedSnippetElement >> newArrowElement [
	"Instantiate and return a new element playing a role of a down arrow."
	<return: #BlElement>

	^ BlElement new
		size: 24@16;
		visibility: BlVisibility gone; 
		geometry: (BlPolygon vertices: { 0@0 . 24@0 . 12@16 } );
		margin: (BlInsets top: 13 right: 5 bottom: 0 left: 0);
		background: Color veryVeryLightGray;
		constraintsDo: [ :c |
			"Let's put arrow in the middle of its cell"
			c linear horizontal alignCenter.
			c linear vertical alignCenter ].
]

{ #category : #'instance creation' }
LeEvaluatedSnippetElement >> newPreviewContainer [
	| previewContainer |
	previewContainer := BlElement new.
	^ previewContainer
		layout: BlLinearLayout vertical;
		addAptitude: BrShadowAptitude new;
		visibility: BlVisibility gone; 
		padding: (BlInsets  bottom: 5);
		margin: (BlInsets top: 5 bottom: 5);
		background: Color white;
		addChild: (BrResizer new
			target: previewContainer;
			beBottom;
			aptitude: BrGlamorousResizerAptitude;
			constraintsDo: [ :c | 
				c ignoreByLayout.
				c ignored horizontal weight: 0.5 ]);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical exact: self previewHeight ]
]

{ #category : #'instance creation' }
LeEvaluatedSnippetElement >> newPreviewElementFor: anObject [
	<return: #BlElement>
	| aView |
	aView := GtPhlowView empty on: anObject perform: #gtViewsFor:.
	^ aView asElementDo: [ :anElement | anElement ]
]

{ #category : #'api - snippet view model' }
LeEvaluatedSnippetElement >> onSnippetViewModelChanged [
	arrowElement hasParent
		ifFalse: [ self addChild: arrowElement ].
	previewContainer hasParent
		ifFalse: [ self addChild: previewContainer ].

	self updateCoderUIModel.
	self clearPreview.

	"we should assign the coder UI model *before* the focus state"
	super onSnippetViewModelChanged.

]

{ #category : #'api - snippet view model' }
LeEvaluatedSnippetElement >> onSnippetViewModelFocused: aBoolean [
	"Override me to either request or lose focus depending on the boolean"

	aBoolean
		ifTrue: [ editorElement requestFocus ]
		ifFalse: [ editorElement loseFocus ]
]

{ #category : #'private - accessing' }
LeEvaluatedSnippetElement >> previewContainer [
	^ previewContainer
]

{ #category : #accessing }
LeEvaluatedSnippetElement >> previewHeight [
	^ 300
]

{ #category : #'api - view' }
LeEvaluatedSnippetElement >> snippetContent [
	"Return an element that represents a content of the snippet.
	The embedder is responsible for placing #snippetContent in the right place within snippet element depending on the
	View Model properties and derived look"
	<return: #BlElement>

	^ editorElement
]

{ #category : #'api - view' }
LeEvaluatedSnippetElement >> snippetToolbar [
	"Return an element that represents a toolbar of the snippet. A toolbar usually appears below the snippet content.
	The embedder is responsible for placing #snippetToolbar in the right place within snippet element depending on the
	View Model properties and derived look.
	If returned #snippetToolbar is nil, no toolbar will be added"
	<return: #BlElement or: nil>

	^ coderToolbar
]

{ #category : #actions }
LeEvaluatedSnippetElement >> spawnBelowPreviewElement: anElement [
	| arrowElement previewContainer |

	arrowElement := self arrowElement.
	previewContainer := self previewContainer.
	previewContainer removeChildNamed: #previewElement.
	
	arrowElement visibility: BlVisibility visible.
	previewContainer visibility: BlVisibility visible.
	
	previewContainer addChild: anElement as: #previewElement
]

{ #category : #actions }
LeEvaluatedSnippetElement >> spawnBelowTool: aTool [
	| aPreviewElement |
	
	aPreviewElement := aTool asElement.
	aPreviewElement dispatchEvent: GtPhlowToolDetailWish beNormalLevel.
	
	self spawnBelowPreviewElement: aPreviewElement
]

{ #category : #'private - updating' }
LeEvaluatedSnippetElement >> updateCoderUIModel [
	coderContentModel sourceCoder: self snippetViewModel coderViewModel.
	editorElement textualCoderViewModel: self snippetViewModel coderViewModel.
	spawnDestinationLook onCoderChanged: self snippetViewModel coderViewModel
]