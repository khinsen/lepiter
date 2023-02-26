"
I am a {{gtClass:LeHTMLPageDecorator}}. 
I am responsible for {{gtMethod: LeHTMLPageLocalAssetsDecorator >> #initializeHTMLPageExporter: | label=configuring}}  and {{gtMethod: LeHTMLPageLocalAssetsDecorator >> #writeAssetFilesUsing: | label=adding}} additional  asset files used for {{gtClass:LePage}} HTML exports.
I add a remote CSS and JavaScript links to a {{gtClass:LePage}} HTML output.
I download [](https://lepiter.io) CSS and JavaScript files and store them next to a {{gtClass:LePage}} HTML output.
"
Class {
	#name : #LeHTMLPageLocalAssetsDecorator,
	#superclass : #LeHTMLPageDecorator,
	#category : #'Lepiter-HTML-Helpers'
}

{ #category : #private }
LeHTMLPageLocalAssetsDecorator >> convertRemoteUrl: aRemoteUrl [
	"Convert an absolute (remote) URL into a relative URL"

	(aRemoteUrl beginsWith: self lepiterUrl caseSensitive: false)
		ifFalse: [ ^ aRemoteUrl ].


	^ aRemoteUrl copyFrom: self lepiterUrl size + 1 to: aRemoteUrl size
]

{ #category : #accessing }
LeHTMLPageLocalAssetsDecorator >> defineTypeFor: anUrl [
	| anIndex aSegment aName |
	aSegment := anUrl asZnUrl lastPathSegment.
	anIndex := aSegment indexOf: $..

	aName := (anIndex < 1 or: [ anIndex + 1 >= aSegment size ])
			ifTrue: [ aSegment ]
			ifFalse: [ aSegment copyFrom: anIndex + 1 to: aSegment size ].

	^ XdType typeFromString: aName
]

{ #category : #'api - initialization' }
LeHTMLPageLocalAssetsDecorator >> initializeHTMLPageExporter: anExporter [
	"Configure a {{gtClass:LeHtmlPageExporterVisitor}} instance before a page export.
	I add a local CSS and JavaScript links to a {{gtClass:LePage}} HTML output."

	anExporter shouldGenerateHeader: true.

	self localLinks
		do: [ :eachUrl | 
			anExporter
				addLink: {'rel' -> 'stylesheet'.
						'href' -> eachUrl} ].

	self remoteScripts
		do: [ :eachUrl | 
			anExporter
				addScript: (LeHtmlScriptDefinition
						attributes: {'type' -> 'text/javascript'.
								'src' -> eachUrl}) ]
]

{ #category : #accessing }
LeHTMLPageLocalAssetsDecorator >> lepiterUrl [
	^ 'https://lepiter.io/'
]

{ #category : #accessing }
LeHTMLPageLocalAssetsDecorator >> localLinks [
	^ self remoteLinks collect: [ :eachUrl | self convertRemoteUrl: eachUrl ]
]

{ #category : #accessing }
LeHTMLPageLocalAssetsDecorator >> localScripts [
	^ self remoteScripts collect: [ :eachUrl | self convertRemoteUrl: eachUrl ]
]

{ #category : #accessing }
LeHTMLPageLocalAssetsDecorator >> remoteExtraLinks [
	^ {'https://lepiter.io/assets/v1/src/css/bootstrap.css.map'}
]

{ #category : #private }
LeHTMLPageLocalAssetsDecorator >> writeAssetFileFromUrl: aRemoteUrl type: anXdType using: aXdWriter [
	"I download a file available at a remote URL and 
	store its content next to a {{gtClass:LePage}} HTML output."

	| aResponse aLocalName aContents |
	aLocalName := self convertRemoteUrl: aRemoteUrl.
	aLocalName = aRemoteUrl ifTrue: [ ^ self ].

	aResponse := ZnEasy get: aRemoteUrl.
	aResponse isSuccess ifFalse: [ ^ self ].
	aContents := aResponse contents.

	aContents isString
		ifTrue: [ aXdWriter
				documentType: anXdType;
				attachment: aLocalName text: aContents.
			^ self ].

	(aContents isKindOf: ByteArray)
		ifTrue: [ aXdWriter
				documentType: anXdType;
				attachment: aLocalName
					stream: aContents readStream
					size: aContents size.
			^ self ]
]

{ #category : #'api - writing' }
LeHTMLPageLocalAssetsDecorator >> writeAssetFilesUsing: aXdWriter [
	"Write extra (asset) files to a page HTML export.
	I download https://lepiter.io CSS and JavaScript files and 
	store them next to a {{gtClass:LePage}} HTML output."

	self remoteLinks
		do: [ :eachUrl | 
			self
				writeAssetFileFromUrl: eachUrl
				type: XdType css
				using: aXdWriter ].


	self remoteExtraLinks
		do: [ :eachUrl | 
			| aType |
			aType := self defineTypeFor: eachUrl.

			self
				writeAssetFileFromUrl: eachUrl
				type: aType
				using: aXdWriter ]
]