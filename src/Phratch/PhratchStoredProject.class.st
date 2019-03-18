Class {
	#name : #PhratchStoredProject,
	#superclass : #Object,
	#instVars : [
		'version',
		'info',
		'morph'
	],
	#category : #'Phratch-Object IO'
}

{ #category : #'instance creation' }
PhratchStoredProject class >> fromByteArray: aByteArray [
	^ self fromStream: (ReadStream on: aByteArray)
]

{ #category : #'instance creation' }
PhratchStoredProject class >> fromFile: aFile [
	^ FLPlatform current
		fileNamed: aFile asFileReference fullName
		readStreamDo: [ :aFileStream | self fromStream: aFileStream ]
]

{ #category : #'instance creation' }
PhratchStoredProject class >> fromStream: aStream [
	"Creates an instances and extract project info and data from stream"
	| instance |
	instance := self new.
	instance extractProjectFromStream: aStream.
	^ instance
]

{ #category : #'instance creation' }
PhratchStoredProject class >> infoFromByteArray: aByteArray [
	^ self infoFromStream: (ReadStream on: aByteArray)
]

{ #category : #'instance creation' }
PhratchStoredProject class >> infoFromFile: aFile [
	^ FLPlatform current
		fileNamed: aFile asFileReference fullName
		readStreamDo: [ :aFileStream | self infoFromStream: aFileStream ]
]

{ #category : #'instance creation' }
PhratchStoredProject class >> infoFromStream: aStream [
	"Returns an instance and extracts only the info part of the project"
	| instance |
	instance := self new.
	instance extractProjectInfoFromStream: aStream.
	^ instance
]

{ #category : #'file read/write' }
PhratchStoredProject >> extractProjectFromStream: aStream [
	"Answer a Phratch project (i.e. a PhratchStageMorph possibly containing sprites) from the given stream. Answer nil if the project cannot be unpacked."

	| data objStream |
	version := FuelObjStream
		phratchFileVersionFrom: (aStream next: 10) asString.
	aStream next: 4.
	objStream := FuelObjStream new.
	version = 0
		ifTrue: [ aStream position: 0 ]
		ifFalse: [ objStream readFileHeader: aStream ].
	info := objStream readObjFrom: aStream showProgress: false.
	data := objStream readObjFrom: aStream showProgress: false.
	data class = PhratchStageMorph
		ifTrue: [ morph := data ]
]

{ #category : #'file read/write' }
PhratchStoredProject >> extractProjectInfoFromStream: aStream [
	"Answer a Phratch project (i.e. a PhratchStageMorph possibly containing sprites) from the given stream. Answer nil if the project cannot be unpacked."

	| objStream |
	version := FuelObjStream
		phratchFileVersionFrom: (aStream next: 10) asString.
	aStream next: 4.
	objStream := FuelObjStream new.
	version = 0
		ifTrue: [ aStream position: 0 ]
		ifFalse: [ objStream readFileHeader: aStream ].
	info := objStream readObjFrom: aStream showProgress: false
]

{ #category : #accessing }
PhratchStoredProject >> info [
	^ info
]

{ #category : #accessing }
PhratchStoredProject >> info: anObject [
	info := anObject
]

{ #category : #initialization }
PhratchStoredProject >> initialize [
	super initialize.
	version := 1.
	info := Dictionary new
]

{ #category : #accessing }
PhratchStoredProject >> morph [
	^ morph
]

{ #category : #accessing }
PhratchStoredProject >> morph: anObject [
	morph := anObject
]

{ #category : #accessing }
PhratchStoredProject >> version [
	^ version
]

{ #category : #accessing }
PhratchStoredProject >> version: anObject [
	version := anObject
]

{ #category : #writing }
PhratchStoredProject >> versionStringForStoring [
	^ 'PhratchV{1}' format: {(version asString padLeftTo: 2 with: $0)}
]

{ #category : #writing }
PhratchStoredProject >> writeToFile: aFile [
	aFile asFileReference
		binaryWriteStreamDo: [ :str | self writeToStream: str ]
]

{ #category : #writing }
PhratchStoredProject >> writeToStream: aStream [
	| objStream infoStream |
	version > 0
		ifTrue: [ aStream nextPutAll: self versionStringForStoring asByteArray ].

	infoStream := WriteStream on: (ByteArray new: 100000).
	FuelObjStream new
		writeFileHeaderOn: infoStream;
		storeObj: info on: infoStream.
	aStream uint32: infoStream size.
	aStream nextPutAll: infoStream contents.

	objStream := FuelObjStream new.
	objStream storeObj: morph on: aStream
]
