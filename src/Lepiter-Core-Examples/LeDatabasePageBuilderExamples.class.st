Class {
	#name : #LeDatabasePageBuilderExamples,
	#superclass : #LePageBuilderExamples,
	#category : #'Lepiter-Core-Examples-Builder'
}

{ #category : #'examples - pages' }
LeDatabasePageBuilderExamples >> addAutoGeneratedTitlePage [
	<gtExample>
	| aDatabase aPage |
	aDatabase := self basicDatabase.
	aPage := aDatabase pageBuilder uniqueTitle; add.
	self assert: aDatabase size equals: 1.
	self assert: aDatabase anyOne equals: aPage.
	self assert: aPage database equals: aDatabase.
	self assert: aPage hasTitle.
	self assert: aPage createTime isNotNil.
	self assert: aPage createEmail isNotNil.
	self assert: aPage editTime equals: aPage createTime.
	self assert: aPage editEmail equals: aPage createEmail.
	self assert: aPage wasEdited not.
	^ aDatabase
]

{ #category : #'examples - pages' }
LeDatabasePageBuilderExamples >> addAutoGeneratedTitlePage_Two [
	<gtExample>
	| aDatabase aPage |
	aDatabase := self addAutoGeneratedTitlePage.
	aPage := aDatabase pageBuilder uniqueTitle; add.
	self assert: aDatabase size equals: 2.
	self assert: (aDatabase pageNamed: aPage title) equals: aPage.
	self assert: aPage database equals: aDatabase.
	self assert: aPage hasTitle.
	self assert: aPage createTime isNotNil.
	self assert: aPage createEmail isNotNil.
	self assert: aPage editTime equals: aPage createTime.
	self assert: aPage editEmail equals: aPage createEmail.
	self assert: aPage wasEdited not.
	^ aDatabase
]

{ #category : #'examples - pages' }
LeDatabasePageBuilderExamples >> addEmptyPage [
	<gtExample>
	| aDatabase aPage |
	aDatabase := self basicDatabase.
	aPage := aDatabase pageBuilder add.
	self assert: aDatabase size equals: 1.
	self assert: aDatabase anyOne equals: aPage.
	self assert: aPage database equals: aDatabase.
	self assert: aPage hasTitle not.
	self assert: aPage createTime isNotNil.
	self assert: aPage createEmail isNotNil.
	self assert: aPage editTime equals: aPage createTime.
	self assert: aPage editEmail equals: aPage createEmail.
	self assert: aPage wasEdited not.
	^ aDatabase
]

{ #category : #'examples - pages' }
LeDatabasePageBuilderExamples >> addLaterEmptyPage [
	"Demonstrate creating a page, but only adding to the database after the title has been set."
	<gtExample>
	| aDatabase aPage |
	aDatabase := self basicDatabase.
	aPage := aDatabase pageBuilder addOnlyAfterSettingTitle.
	self assert: aDatabase size equals: 0.
	self assert: aPage hasTitle not.
	self assert: aPage createTime isNotNil.
	self assert: aPage createEmail isNotNil.
	
	aPage updateTitle: 'Hi'.
	
	self assert: aDatabase size equals: 1.
	self assert: aDatabase anyOne equals: aPage.
	self assert: aPage database equals: aDatabase.
	self assert: aPage title equals: 'Hi'.
	self assert: aPage createTime isNotNil.
	self assert: aPage createEmail isNotNil.
	^ aDatabase
]

{ #category : #adding }
LeDatabasePageBuilderExamples >> addLaterEmptyPage_GarbageNotAddedPage [
	"Demonstrate creating a page, since it is not added, it should be garbage collected."
	<gtExample>
	| aDatabase aWeakPage |
	aDatabase := self basicDatabase.
	aWeakPage := aDatabase pageBuilder addOnlyAfterSettingTitle asWeakReference.
	self assert: aDatabase size equals: 0.

	1 timesRepeat: [ Smalltalk garbageCollect ].
	
	self assert: (aWeakPage at: 1) isNil description: 'Not added page must be garbage collected'.

	^ aWeakPage
]