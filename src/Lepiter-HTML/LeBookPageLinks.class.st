Class {
	#name : #LeBookPageLinks,
	#superclass : #Object,
	#instVars : [
		'links',
		'sortedLinks'
	],
	#category : #'Lepiter-HTML-Model'
}

{ #category : #'instance creation' }
LeBookPageLinks class >> withAll: aCollection [
	^ self new initializeLinks: aCollection asArray
]

{ #category : #enumerating }
LeBookPageLinks >> do: aBlock [
	self links do: aBlock
]

{ #category : #accessing }
LeBookPageLinks >> gtLinksFor: aView [
	<gtView>
	self links ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Sorted Links';
		priority: 10;
		items: [ self sortedLinks ];
		column: 'Index' text: [ :_ :anIndex | anIndex ] width: 40;
		column: 'Page Title' text: #pageTitle;
		column: 'File Name' text: #fileName
]

{ #category : #initialization }
LeBookPageLinks >> initializeLinks: anArray [
	links := anArray asArray.
	sortedLinks := nil.
]

{ #category : #enumerating }
LeBookPageLinks >> linkTitled: aPageTitle ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self links
		detect: [ :eachLink | eachLink pageTitle = aPageTitle ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #accessing }
LeBookPageLinks >> links [
	^ links
]

{ #category : #accessing }
LeBookPageLinks >> sortedLinks [
	^ sortedLinks ifNil: [ sortedLinks := self links 
			sorted: [ :a :b | 
				a isToC asBit > b isToC asBit
					or: [ a isToC = b isToC and: [ a pageTitle < b pageTitle ] ] ] ]
]