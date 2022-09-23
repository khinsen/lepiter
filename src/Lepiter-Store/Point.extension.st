Extension { #name : #Point }

{ #category : #'*Lepiter-Store' }
Point class >> leFromJsonV4Dictionary: aDictionary [
	"Create a new instance of the receiver from the supplied dictionary."
	| pointString splitString |

	pointString := aDictionary at: #pointString.
	splitString := $@ split: pointString.
	^ self
		x: splitString first
		y: splitString second.
]

{ #category : #'*Lepiter-Store' }
Point class >> leJsonV4MappingFor: aNeoJSONMapper [
	"Points are encoded as their type and a single string in x@y format"

	aNeoJSONMapper for: self do: [ :mapping | 
		mapping
			mapProperty: #'__type' 
			getter: [ :object | object class leJsonV4Name ] 
			setter: [ :um | self error: 'Objects should not be read here' ].
		mapping 
			mapProperty: #pointString
			getter: [ :object | object x asString, '@', object y asString ]
			setter: [ :pointString | | splitString |
				splitString := $@ split: pointString.
				self
					x: splitString first
					y: splitString second ] ].

]

{ #category : #'*Lepiter-Store' }
Point class >> leJsonV4Name [

	^ #point
]