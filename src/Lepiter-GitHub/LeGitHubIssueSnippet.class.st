Class {
	#name : #LeGitHubIssueSnippet,
	#superclass : #LeGitHubSnippet,
	#category : #'Lepiter-GitHub-Snippets'
}

{ #category : #'api - accessing menu' }
LeGitHubIssueSnippet class >> contextMenuItemSpefication [
	<leSnippetSpecification>
	^ LeContextMenuItemSpecification new
		snippetClass: self;
		title: 'GitHub issue'
]

{ #category : #jsonV3 }
LeGitHubIssueSnippet class >> leJsonV3AttributeMapping [

	^ super leJsonV3AttributeMapping
		add: (#issueNumber -> #issueNumber);
		yourself
]

{ #category : #'lepiter-store' }
LeGitHubIssueSnippet class >> leJsonV3Name [

	^ 'githubIssueSnippet'
]

{ #category : #jsonV3 }
LeGitHubIssueSnippet class >> leJsonV4AttributeMapping [

	^ super leJsonV4AttributeMapping
		add: (#issueNumber -> #issueNumber);
		yourself
]

{ #category : #'lepiter-store' }
LeGitHubIssueSnippet class >> leJsonV4Name [

	^ 'githubIssueSnippet'
]

{ #category : #visiting }
LeGitHubIssueSnippet >> acceptVisitor: aVisitor [

	^ aVisitor visitGitHubIssueSnippet: self
]

{ #category : #converting }
LeGitHubIssueSnippet >> asSnippetViewModel [
	<return: #LeSnippetViewModel>
	^ LeGithubIssueViewModel new snippetModel: self
]

{ #category : #'api - accessing' }
LeGitHubIssueSnippet >> contentAsString [		
	^ String streamContents: [ :aStream |
			aStream
				nextPutAll: (self ownerName ifEmpty: [ '<username>' ]);
				nextPut: $/;
				nextPutAll: (self projectName ifEmpty: [ '<project>' ]);
				nextPutAll: '/issues/';
				nextPutAll: (self issueNumber asString ifEmpty: [ '<issue>' ]) ]
]

{ #category : #initialization }
LeGitHubIssueSnippet >> defaultModel [
	<return: #LeGitHubModel>
	^ LeGitHubIssueModel new
]

{ #category : #'api - accessing' }
LeGitHubIssueSnippet >> issueNumber [
	^ self model issueNumber
]

{ #category : #'api - accessing' }
LeGitHubIssueSnippet >> issueNumber: aNumber [
	self model issueNumber: aNumber
]

{ #category : #'api - accessing' }
LeGitHubIssueSnippet >> url: anUrl [
	| aValidator |
	aValidator := LeGitHubIssueUrlValidator new
		url: anUrl;
		validate.
		
	aValidator isValid ifFalse: [ ^ self ].
	
	self ownerName: aValidator ownerName.
	self projectName: aValidator projectName.
	self issueNumber: aValidator issueNumber.
]