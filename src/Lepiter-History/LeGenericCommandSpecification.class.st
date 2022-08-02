Class {
	#name : #LeGenericCommandSpecification,
	#superclass : #LeCommandSpecification,
	#instVars : [
		'attributesByName'
	],
	#category : #'Lepiter-History-Commands'
}

{ #category : #accessing }
LeGenericCommandSpecification >> attributeAt: anAttributeName [
	^ attributesByName at: anAttributeName
]

{ #category : #accessing }
LeGenericCommandSpecification >> attributeAt: anAttributeName put: anAttributeValue [
	attributesByName at: anAttributeName put: anAttributeValue
]

{ #category : #accessing }
LeGenericCommandSpecification >> attributes [
	^ attributesByName values
]

{ #category : #initialization }
LeGenericCommandSpecification >> initialize [ 
	super initialize.
	attributesByName := OrderedDictionary new.
]

{ #category : #printing }
LeGenericCommandSpecification >> printOn: aStream [ 
	super printOn: aStream.
	aStream parenthesize: [ 
		aStream << self commandTypeName ]
]