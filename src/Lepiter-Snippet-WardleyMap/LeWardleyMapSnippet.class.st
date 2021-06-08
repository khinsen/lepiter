Class {
	#name : #LeWardleyMapSnippet,
	#superclass : #LeSnippet,
	#traits : 'TLeSnippetWithHeight',
	#classTraits : 'TLeSnippetWithHeight classTrait',
	#instVars : [
		'wardleyMap'
	],
	#category : #'Lepiter-Snippet-WardleyMap-Snippet'
}

{ #category : #'api - accessing menu' }
LeWardleyMapSnippet class >> contextMenuItemSpefication [
	<leSnippetSpecification>
	^ LeContextMenuItemSpecification new
		snippetClass: self;
		title: 'Wardley Map'
]

{ #category : #factory }
LeWardleyMapSnippet class >> empty [
	^ self new
]

{ #category : #'lepiter-store' }
LeWardleyMapSnippet class >> leJsonV3AttributeMapping [

	^ super leJsonV3AttributeMapping
		add: (#wardleyMapDictionary -> #wardleyMapDictionary);
		"accessor in the snippet -> key in the json"
		add: (#height -> #snippetHeight);
		yourself
]

{ #category : #'lepiter-store' }
LeWardleyMapSnippet class >> leJsonV3Name [

	^ 'wardleyMap'
]

{ #category : #'lepiter-store' }
LeWardleyMapSnippet class >> leJsonV4AttributeMapping [

	^ super leJsonV4AttributeMapping
		add: (#wardleyMapDictionary -> #wardleyMapDictionary);
		"accessor in the snippet -> key in the json"
		add: (#height -> #snippetHeight);
		yourself
]

{ #category : #'lepiter-store' }
LeWardleyMapSnippet class >> leJsonV4Name [

	^ 'wardleyMap'
]

{ #category : #accessing }
LeWardleyMapSnippet >> asSnippetViewModel [
	<return: #LeSnippetViewModel>
	^ LeWardleyMapSnippetViewModel new snippetModel: self
]

{ #category : #'api - accessing' }
LeWardleyMapSnippet >> contentAsString [
	"Return a content, e.g., title or string"
	<return: #String>

	^ 'wardley map'
]

{ #category : #'api - links' }
LeWardleyMapSnippet >> createLinkFromNode: aWardleyMapNodeModel toPageNamed: aPageName [
	| anOriginReference aTargetReference |

	self
		linkForNode: aWardleyMapNodeModel
		ifFound: [ :aLink | self database removeExplicitLinks: { aLink } ].

	anOriginReference := (LeWardleyMapNodeReference forSnippetUid: self uid)
		nodeUUID: aWardleyMapNodeModel id.
	
	"today it only works if there is a page"
	aTargetReference := LeLinkPageUidReference
		forPageUid: (self database pageNamed: aPageName) uid.
		
	self database addExplicitLink: (LeAttachedLink new 
		originReference: anOriginReference;
		targetReference: aTargetReference)
]

{ #category : #initialization }
LeWardleyMapSnippet >> initialize [
	super initialize.

	height := 300.
	wardleyMap := GtWardleyMapModel new
]

{ #category : #'api - links' }
LeWardleyMapSnippet >> linkForNode: aWardleyMapNodeModel ifFound: aFoundBlock [
	| theLinks |
	
	theLinks := self database linksWithOriginReferenceMatching: ((LeWardleyMapNodeReference forSnippetUid: self uid)
		nodeUUID: aWardleyMapNodeModel id).
	theLinks ifEmpty: [ ^ self ].
	
	self
		assert: [ theLinks size = 1 ]
		description: [ 'Only one link is allowed' ].
		
	aFoundBlock value: theLinks first
]

{ #category : #'private - hooks' }
LeWardleyMapSnippet >> onRemovedFromDatabase: aDatabase [
	super onRemovedFromDatabase: aDatabase.
	
	self wardleyMap nodes do: [ :eachWardleyNodeModel |
		self
			linkForNode: eachWardleyNodeModel
			ifFound: [ :aLink | self database removeExplicitLinks: { aLink } ]. ]
]

{ #category : #'private - event handling' }
LeWardleyMapSnippet >> onWardleyMapChanged: anAnnouncement [
	"I am sent when wardley map changes, this triggers auto-save of the wardley map snippet"

	self announceContentChanged
]

{ #category : #accessing }
LeWardleyMapSnippet >> wardleyMap [
	^ wardleyMap
]

{ #category : #accessing }
LeWardleyMapSnippet >> wardleyMap: aNewWardleyMap [
	wardleyMap
		ifNotNil: [ :aPreviousWardleyMap | aPreviousWardleyMap unsubscribe: self ].
	wardleyMap := aNewWardleyMap.
	wardleyMap weak
		when: GtWardleyMapAnnouncement
		send: #onWardleyMapChanged:
		to: self
]

{ #category : #'private - export / import' }
LeWardleyMapSnippet >> wardleyMapDictionary [
	^ wardleyMap accept: LeWardleyMapExporter new
]

{ #category : #'private - export / import' }
LeWardleyMapSnippet >> wardleyMapDictionary: aDictionary [
	self wardleyMap: (LeWardleyMapImporter new importWardleyMapFrom: aDictionary)
]