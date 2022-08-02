Class {
	#name : #LeRestoreContentCommand,
	#superclass : #LeContentCommand,
	#instVars : [
		'traceEvent',
		'targetCommand'
	],
	#category : #'Lepiter-History-Commands'
}

{ #category : #'instance creation' }
LeRestoreContentCommand class >> forTraceEvent: anEvent inPage: aPage [
	^ self new 
		initializeForTraceEvent: anEvent 
		inPage: aPage
]

{ #category : #executing }
LeRestoreContentCommand >> basicExecute [
	^ self withUndoExecute: [  self targetCommand execute ]
]

{ #category : #'execution - utils' }
LeRestoreContentCommand >> createCommandResult [
	^ LeRestoreContentCommandExecutionResult forCommand: self
]

{ #category : #converting }
LeRestoreContentCommand >> createCommandSpecification [
	^ LeGenericCommandSpecification new
		commandUid: self uid;
		contentUid: self targetPage uid;
		commandTypeName: self className;
		attributeAt: #traceEvent put: self traceEvent
]

{ #category : #'execution - utils' }
LeRestoreContentCommand >> createUndoCommand [
	self subclassResponsibility
]

{ #category : #'execution - utils' }
LeRestoreContentCommand >> createUndoCommandSpecification [
	^ self createUndoCommand createCommandSpecification
]

{ #category : #initialization }
LeRestoreContentCommand >> initializeForTraceEvent: anEvent inPage: aPage [
	self traceEvent: anEvent.
	self targetContent: aPage.
]

{ #category : #accessing }
LeRestoreContentCommand >> targetCommand [
	^ targetCommand
]

{ #category : #accessing }
LeRestoreContentCommand >> targetPage [ 
	^ self targetContent 
]

{ #category : #accessing }
LeRestoreContentCommand >> traceEvent [

	^ traceEvent
]

{ #category : #accessing }
LeRestoreContentCommand >> traceEvent: anEvent [
	
	traceEvent := anEvent
]

{ #category : #accessing }
LeRestoreContentCommand >> traceEventTypeForRecording [
	self subclassResponsibility
]