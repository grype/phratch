block API
checkEmpty: anObject
	"Verify if the given value is empty"
	<phratchItem: 'is $String$ empty?' kind: #BooleanBlockMorph category: 'operators' defaultValues: #() subCategory: #a9 special: #()>
	^ anObject isEmpty