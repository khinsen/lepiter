Extension { #name : #LeModelExamples }

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> databaseWithPageHavingLargePictureSnippets [
	"Pages with picture snippets."

	<gtExample>
	| temporaryDatabase database page form pngFile possibleColors |
	temporaryDatabase := LeTemporaryDatabase new.
	database := temporaryDatabase database.

	page := database pageBuilder
			title: self pageOneTitle;
			add.

	form := Form extent: 1600@1000 depth: 16.
	possibleColors := Color gtRegisteredColors.
	1 to: form extent x do: [ :x | 
		1 to: form extent y do: [ :y |
			form colorAt: x@y put: possibleColors atRandom color
	] ].
	pngFile := FileReference 
		newTempFilePrefix: 'lepiter-model-examples' 
		suffix: '-large-image.png'.
	PNGReadWriter putForm: form onFileNamed: pngFile .
	
	5 timesRepeat: [ 
		| pictureAttachment snippet |
		pictureAttachment := database addAttachmentByCopy: pngFile.
		snippet := LePictureSnippet new
				urlString: pictureAttachment;
				caption: 'Blank form'.
		page addSnippet: snippet.
	].

	^ temporaryDatabase
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> databaseWithPageHavingManyPictureSnippets [
	"Pages with picture snippets."

	<gtExample>
	| temporaryDatabase database pageOne pictureFileOne pictureFileTwo |
	temporaryDatabase := LeTemporaryDatabase new.
	database := temporaryDatabase database.

	pageOne := database pageBuilder
			title: self pageOneTitle;
			add.

	pictureFileOne := FileLocator gtResource / 'feenkcom/gtoolkit/doc/feenk.png'.
	pictureFileTwo := FileLocator gtResource / 'feenkcom/gtoolkit/doc/gtoolkit.png'.
	
	15 timesRepeat: [ 
		| pictureAttachmentOne pictureAttachmentTwo snippetOne snippetTwo |
		pictureAttachmentOne := database addAttachmentByCopy: pictureFileOne.
		snippetOne := LePictureSnippet new
				urlString: pictureAttachmentOne;
				caption: 'Feenk'.
		pageOne addSnippet: snippetOne.

		pictureAttachmentTwo := database addAttachmentByCopy: pictureFileTwo.
		snippetTwo := LePictureSnippet new
				urlString: pictureAttachmentTwo;
				caption: 'Glamorous Toolkit'.
		snippetOne addSnippet: snippetTwo.
	].

	^ temporaryDatabase
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> databaseWithTwoPagesHavingPictureSnippets [
	"Pages with picture snippets. Some picture files repeats by purpose."

	<gtExample>
	| temporaryDatabase database pageOne pictureFileOne pictureAttachmentOne snippetOne pictureFileTwo pictureAttachmentTwo snippetTwo snippetThree pageTwo snippetFour |
	temporaryDatabase := LeTemporaryDatabase new.
	database := temporaryDatabase database.

	pageOne := database pageBuilder
			title: self pageOneTitle;
			add.

	pictureFileOne := FileLocator gtResource / 'feenkcom/gtoolkit/doc/feenk.png'.
	pictureAttachmentOne := database addAttachmentByCopy: pictureFileOne.

	snippetOne := LePictureSnippet new
			urlString: pictureAttachmentOne;
			caption: 'Feenk'.
	pageOne addSnippet: snippetOne.

	pictureFileTwo := FileLocator gtResource / 'feenkcom/gtoolkit/doc/gtoolkit.png'.
	pictureAttachmentTwo := database addAttachmentByCopy: pictureFileTwo.

	snippetTwo := LePictureSnippet new
			urlString: pictureAttachmentTwo;
			caption: 'Glamorous Toolkit'.
	snippetOne addSnippet: snippetTwo.

	snippetThree := LePictureSnippet new
			urlString: pictureAttachmentOne;
			caption: 'Feenk 2'.
	snippetTwo addSnippet: snippetThree.

	pageTwo := database pageBuilder
			title: self pageTwoTitle;
			add.

	snippetFour := LePictureSnippet new
			urlString: pictureAttachmentTwo;
			caption: 'Glamorous Toolkit 2'.
	pageTwo addSnippet: snippetFour.

	^ temporaryDatabase
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> pageOneTitle [
	^ 'Page one with pictures'
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> pageOneWithTwoAttachmentPictures [
	"Page with picture snippets. Some picture files repeats by purpose."

	<gtExample>
	| temporaryDatabase database page |
	temporaryDatabase := self databaseWithTwoPagesHavingPictureSnippets.
	database := temporaryDatabase database.

	page := database pageNamed: self pageOneTitle.

	^ LePageExampleHolder new
		page: page;
		temporaryDatabase: temporaryDatabase
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> pageThreeTitle [
	^ 'Page three with words'
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> pageThreeWithOneWordAttachment [
	"Page with picture snippets. Some picture files repeats by purpose."

	<gtExample>
	| temporaryDatabase database page |
	temporaryDatabase := self databaseWithWordSnippet.
	database := temporaryDatabase database.

	page := database pageNamed: self pageThreeTitle.

	^ LePageExampleHolder new
		page: page;
		temporaryDatabase: temporaryDatabase
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> pageTwoTitle [
	^ 'Page two with pictures'
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> pageTwoWithOneAttachmentPictures [
	"Page with a picture snippet."

	<gtExample>
	| temporaryDatabase database page |
	temporaryDatabase := self databaseWithTwoPagesHavingPictureSnippets.
	database := temporaryDatabase database.

	page := database pageNamed: self pageTwoTitle.

	^ LePageExampleHolder new
		page: page;
		temporaryDatabase: temporaryDatabase
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> pageWithLargePictureSnippets [
	"Page with a picture snippet."

	<gtExample>
	| temporaryDatabase database page |
	temporaryDatabase := self databaseWithPageHavingLargePictureSnippets.
	database := temporaryDatabase database.

	page := database pageNamed: self pageOneTitle.

	^ LePageExampleHolder new
		page: page;
		temporaryDatabase: temporaryDatabase
]

{ #category : #'*Lepiter-Snippet-Picture' }
LeModelExamples >> pageWithManyPictureSnippets [
	"Page with a picture snippet."

	<gtExample>
	| temporaryDatabase database page |
	temporaryDatabase := self databaseWithPageHavingManyPictureSnippets.
	database := temporaryDatabase database.

	page := database pageNamed: self pageOneTitle.

	^ LePageExampleHolder new
		page: page;
		temporaryDatabase: temporaryDatabase
]
