*PhratchList
isListEmpty: listName
	"Verify if the list contains the given object."
	<phratchItem: 'Is $List$ empty?' kind: #BooleanBlockMorph category: 'list' defaultValues: #('list') subCategory: #a5 special: #()>
	| list |
	list := self listNamed: listName ifNone: [^ false].
	^ list isEmpty
