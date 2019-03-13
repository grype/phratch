error handling
errorWithTitle: aTitle message: aMessage
	
	DialogBoxMorph inform: aMessage title: aTitle.
	ScriptablePhratchMorph noviceMode ifFalse:[
		^super error: aMessage
	]
