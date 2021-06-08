"
A LePage is a collection of snippets, that can mostly be considered analogous to a printed page.


 
## Internal Representation and Key Implementation Points.

### Instance Variables
	latestEditTime:		<LeTime>
	type:					<LePageType>
	uid:					<UUID>


### Implementation Points

- While the UID of the page is generated at instance creation, databases are free to change it if a conflict is found when adding the page to the database.  While in a database the UID may not be changed.
- The UID is used by LeLocalStore to generate the file name.

"
Class {
	#name : #LePage,
	#superclass : #LeContent,
	#instVars : [
		'type',
		'latestEditTime',
		'uid'
	],
	#category : #'Lepiter-Core-Model'
}

{ #category : #factory }
LePage class >> builder [
	^ LePageBuilder new
]

{ #category : #'instance creation' }
LePage class >> dailyNoteFor: aDate [

	^ self new initializeDailyNote: aDate
]

{ #category : #factory }
LePage class >> empty [
	"Return a page or empty title"
	^ self named: ''
]

{ #category : #'instance creation' }
LePage class >> named: aTitleString [

	^ self new initializeTitle: aTitleString
]

{ #category : #'instance creation' }
LePage class >> pharoClassName: aSymbol [

	^ self new initializePharoClassName: aSymbol
]

{ #category : #'instance creation' }
LePage class >> pharoCommentClassName: aSymbol [

	^ self new initializePharoCommentClassName: aSymbol
]

{ #category : #'instance creation' }
LePage class >> unnamedPage [

	^ self new initializeUnnamedPage
]

{ #category : #'instance creation' }
LePage class >> unnamedPageWithDefaultTitle: aString [
	| newPage |
	newPage := self new initializeUnnamedPage.
	newPage type defaultTitle: aString.
	^ newPage
]

{ #category : #visiting }
LePage >> acceptVisitor: aVisitor [

	^ aVisitor visitPage: self
]

{ #category : #'api - links' }
LePage >> addAllIncomingUnlinked: aCollection [
	"Add all the incoming unlinked references to the receiver"

	aCollection ifEmpty: [ ^ self ].
	(self optionAt: self incomingUnlinkedOptionName ifAbsentPut: [ OrderedCollection new ])
		addAll: aCollection
]

{ #category : #'api - links' }
LePage >> addExplicitLinkTo: aTargetReference [
	self assert: [ self database notNil ].
	self 
		assert: [ self database isDatabase ] 
		description: 'Explicit links shoud be attached this way only if the 
page is associated to a database. If not the link will be lost.'.
	
	self database addExplicitLink: (LeAttachedLink new
		originReference: (LeLinkPageUidReference forPage: self);
		targetReference: aTargetReference).
]

{ #category : #'api - converting' }
LePage >> asRemoteLink [
	"Answer the string representing a remote link to the receiver"

	^ String streamContents: [ :stream |
		stream
			<< '{{gtPage:';
			<< self title;
			<< '|db=';
			<< self database uuidString;
			<< '}}' ]
]

{ #category : #'private - asserting' }
LePage >> assertTitle: aString [
	self 
		assert: [ aString isNotNil ] 
		description: [ 'Title must be non-nil' ].
	self 
		assert: [ (self database
			pageNamed: aString
			ifAbsent: [ nil ]) isNil ]
		description: [ 'Title must not exist in a database: ', aString ].
]

{ #category : #private }
LePage >> assignNewUID [
	"Assign the receiver a new UID"

	uid := UUID new.
]

{ #category : #'private - accessing' }
LePage >> basicUid [ 

	^ uid
]

{ #category : #'private - accessing' }
LePage >> basicUid: aUUID [
	"Set the receiver's UID.
	Only for testing purposes."

	uid := aUUID
]

{ #category : #'api - testing' }
LePage >> canMoveToAnotherDatabase [
	(self outgoingExplicitLinks anySatisfy: [ :aLink | aLink isAttachedLink ])
		ifTrue: [ ^ false ].
	(self incomingLinks anySatisfy: [ :aLink | aLink isAttachedLink ])
		ifTrue: [ ^ false ].
	
	self allChildrenBreadthFirstDo: [ :aSnippet | 
		(aSnippet isTextSnippet not and: [ 
			aSnippet isCodeSnippet not ])
				ifTrue: [ ^ false ].
			(aSnippet incomingLinks anySatisfy: [ :aLink | aLink isAttachedLink ])
				ifTrue: [ ^ false ].
			(aSnippet outgoingExplicitLinks anySatisfy: [ :aLink | aLink isAttachedLink ])
				ifTrue: [ ^ false ] ].
	^ true
]

{ #category : #'api - testing' }
LePage >> canMoveToDatabase: aNewDatabase [
	(aNewDatabase hasPageNamed: self title) ifTrue: [ ^ false ].
	(aNewDatabase hasPageUID: self uid) ifTrue: [ ^ false ].
	
	self allChildrenBreadthFirstDo: [ :aSnippet | 
		(aNewDatabase hasBlockUID: aSnippet uid) 
			ifTrue: [ ^ false ] ].
	
	^ true
]

{ #category : #'api - accessing' }
LePage >> contentAsString [
	^ self title
]

{ #category : #accessing }
LePage >> databaseKey [
	"Answer the value used to index a page of the receiver's type in the database."

	^ type databaseKey
]

{ #category : #'api - accessing' }
LePage >> editOrCreateTime [
	<return: #LeTime>
	
	self
		deprecated: 'Use #latestEditTime instead'
		transformWith: '`@receiver editOrCreateTime' -> '`@receiver latestEditTime'.

	^ self latestEditTime
]

{ #category : #'api - editing' }
LePage >> ensureOneBlock [
	"Ensure the receiver has at least one LeSnippet child.
	Typically used so the user has somewhere to start inserting text."
	
	self hasChildren ifTrue: [ ^self ].
	self snippetBuilder empty; add.
]

{ #category : #'gt-extensions' }
LePage >> gtSpotterActDefaultFrom: aSpotterElement [
	| pageTool toolElement |

	pageTool := self asLepiterPagePhlowTool.
	toolElement := pageTool asElementDo: [ :e | e ].
	(GtPager 
		openWrappedOn: toolElement 
		title: self tabLabel 
		from: aSpotterElement) maximized
]

{ #category : #'api - unlinked' }
LePage >> hasIncomingUnlinked [
	"Answer a boolean indicating whether the receiver has incoming unlinked references"

	^ self
		optionAt: self incomingUnlinkedOptionName  
		ifPresent: [ :links | links isNotEmpty ] 
		ifAbsent: [ false ]
]

{ #category : #'api - testing' }
LePage >> hasTitle [
	^ self title isNotNil and: [ self title isNotEmpty ]
]

{ #category : #'api - testing' }
LePage >> includesSnippetUid: aLeUID [
	"Answer a boolean indicating whether the supplied uid is present"

	^ self children includesSnippetUid: aLeUID
]

{ #category : #'api - unlinked' }
LePage >> incomingUnlinked [
	"Answer the collection of links that reference the receiver in plain text.
	Most pages won't have incoming unlinked references, so answer an array.
	An OrderedCollection will be added by LeUnlinkedReferenceMaintenace if necessary."

	^ self optionAt: self incomingUnlinkedOptionName ifAbsent: [ #() ]
]

{ #category : #'private - accessing' }
LePage >> incomingUnlinkedOptionName [
	^ #incomingUnlinkedReferences
]

{ #category : #initialization }
LePage >> initialize [ 

	super initialize.
	type := LeNamedPageType title: '' page: self.
	self assignNewUID.
]

{ #category : #initialization }
LePage >> initializeDailyNote: aDate [

	type := LeDailyNotePageType date: aDate page: self
]

{ #category : #initialization }
LePage >> initializePharoClassName: aSymbol [

	type := LePharoClassPageType pageClassName: aSymbol page: self
]

{ #category : #initialization }
LePage >> initializePharoCommentClassName: aSymbol [

	type := LePharoClassCommentPageType pharoClassName: aSymbol page: self
]

{ #category : #initialization }
LePage >> initializeTitle: aTitleString [

	type := LeNamedPageType title: aTitleString page: self
]

{ #category : #initialization }
LePage >> initializeUnnamedPage [

	type := LeUnnamedPageType page: self
]

{ #category : #'api - testing' }
LePage >> isDailyNote [
	^ self type isDailyNote
]

{ #category : #'api - testing' }
LePage >> isPage [
	^ true
]

{ #category : #'api - testing' }
LePage >> isTableOfContents [
	^ self database tableOfContents == self
]

{ #category : #'api - testing' }
LePage >> isTodayDailyNote [
	^ self type isTodayDailyNote
]

{ #category : #'api - testing' }
LePage >> isUnnamedPage [
	^ self type isUnnamedPageType
]

{ #category : #'api - accessing' }
LePage >> latestEditTime [
	"Answer the most recent time the page or one of its blocks was changed in some way"

	^ latestEditTime ifNil: [ latestEditTime := self getLatestEditTime ]
]

{ #category : #'private - exporting' }
LePage >> markdownOn: stream [
	"Write the receiver as an HTML string on the supplied stream"

	self hasTitle ifTrue:
		[ stream 
			<< '#';
			<< self title;
			cr; cr ].

	self childrenDo: [ :child |
		child markdownOn: stream level: 0.
		stream cr ].

]

{ #category : #'api - editing' }
LePage >> moveDownSnippet: aLeSnippet [
	"Try to move the supplied snippet down one item in the receiver's children.
	If that isn't possible, do nothing"

	(self children moveDownSnippet: aLeSnippet) ifTrue:
		[ self announceContentMoved: aLeSnippet ].
]

{ #category : #'api - editing' }
LePage >> moveToDatabase: aNewDatabase [
	self assert: [ aNewDatabase notNil ].
	self database = aNewDatabase ifTrue: [ 
		Error signal: 'Can only be moved to a different database.' ].
	self allChildrenBreadthFirstDo: [ :aSnippet |
		self assert: (aNewDatabase hasBlockUID: aSnippet uid) not ].

	
	self database movePage: self toDatabase: aNewDatabase.
]

{ #category : #'api - editing' }
LePage >> moveUpSnippet: aLeSnippet [
	"Try to move the supplied snippet up one item in the receiver's children.
	If that isn't possible, do nothing"

	(self children moveUpSnippet: aLeSnippet) ifTrue:
		[ self announceContentMoved: aLeSnippet ].
]

{ #category : #'api - notifications' }
LePage >> notifier [
	^ LeNotifier new
		content: self
]

{ #category : #'private - hooks' }
LePage >> onAddedToDatabase [
	super onAddedToDatabase.
	self database updateUnresolvedReferencesForPage: self.
]

{ #category : #'private - hooks' }
LePage >> onRemovedFromDatabase: aDatabase [
	super onRemovedFromDatabase: aDatabase.
	
	aDatabase removeExplicitOutgoingLinksForContent: self.
	aDatabase removeIncomingExplicitLinksForContent: self.
]

{ #category : #'api - accessing' }
LePage >> page [
	^ self
]

{ #category : #accessing }
LePage >> pageTypeClass [
	"Answer the class used to store the pages in ${class:name=LeDatabase}$."

	^ type pageTypeClass
]

{ #category : #printing }
LePage >> printOn: aStream [

	type ifNil: [ ^ super printOn: aStream ].
	type printOn: aStream.
]

{ #category : #'private - updating' }
LePage >> reloadFromPage: aLePage [
	"Update the receiver to match the supplied page"
	| changed |

	changed := self reloadFromContent: aLePage.
	latestEditTime := nil.

	type = aLePage type ifFalse:
		[ type := aLePage type.
		changed := true ].

	changed ifTrue: [ self announceTreeChanged: self ]
]

{ #category : #'api - unlinked' }
LePage >> removeAllIncomingUnlinkedSuchThat: aBlock [
	"Remove all the incoming unlinked references that match aBlock"

	self hasIncomingUnlinked ifFalse: [ ^ self ].
	self incomingUnlinked removeAllSuchThat: aBlock.
]

{ #category : #'api - editing' }
LePage >> removeSelf [
	"Remove the page from a database"
	
	self database removePage: self
]

{ #category : #'api - editing' }
LePage >> removeSelfIfEmpty [
	"Remove the receiver if it is empty"

	self isEmpty ifTrue: [ self removeSelf ]
]

{ #category : #'api - editing' }
LePage >> renameTo: aString [
	self updateTitle: aString
]

{ #category : #'api - accessing' }
LePage >> title [
	"Answer the page's title"
	<return: #String>

	^ type title
]

{ #category : #'api - accessing' }
LePage >> title: aString [
	"Set the receiver's title.
	As the title can currently change the page type, also update the type.
	To update title, use ${method:LePage>>#updateTitle:}$."

	type := type title: aString.

]

{ #category : #'private - accessing' }
LePage >> type [
	<return: #LePageType>
	^ type
]

{ #category : #'private - accessing' }
LePage >> type: aType [
	type := aType
]

{ #category : #'api - accessing' }
LePage >> uid [
	<return: #UUID>

	^ uid
]

{ #category : #'api - accessing' }
LePage >> uidString [
	<return: #String>

	^ uid asString36
]

{ #category : #'api - editing' }
LePage >> unindentSnippet: aLeSnippet [
	"Pages can't unindent a snippet, there's no where to go.  Do nothing."

]

{ #category : #'api - updating' }
LePage >> unlinkedBy: aLink [
	"Remove the incoming link aLink.
	If the receiver is empty and there are no incoming links, remove the receiver."

	super unlinkedBy: aLink.
	(self incomingLinks isEmpty and: [ self isEmpty ]) ifTrue: 
		[ self database removePage: self ].
]

{ #category : #installing }
LePage >> unload [ 

	self allChildrenDepthFirstDo: [ :child | child unload ].
	self notifier
		bubble; database;
		announce: (LePageUnloadAnnouncement new content: self).
]

{ #category : #'api - editing' }
LePage >> updateTitle: aTitle [
	"Update a page title if allowed.
	Notice that it is allowed only if a page of the same title does not exist in a database."
	| aString anOldTitle anOldType oldDatabaseKey |
	aString := aTitle asString.
	self title = aString ifTrue: [ ^ self ].
	anOldTitle := self title.
	anOldType := self type.
	oldDatabaseKey := anOldType databaseKey.
	self updater 
		title: aString; 
		callback: [
			self notifier local; database; announce: (LePageTitleChanged new
				page: self;
				oldTitle: anOldTitle;
				newTitle: self title;
				oldType: anOldType;
				newType: self type;
				oldDatabaseKey: oldDatabaseKey;
				newDatabaseKey: self type databaseKey 
			) ];
		update.
]

{ #category : #'private - updating' }
LePage >> updateType [
	| aDate |
	aDate := LeDailyNoteTitleParser parse: self title.
	aDate 
		ifNotNil: [ self type: (LePageType date: aDate)  ]
		ifNil: [ self type: LePageType default ].
]

{ #category : #'api - editing' }
LePage >> updater [
	^ LeDatabasePageUpdater new
		page: self;
		database: self database.
]