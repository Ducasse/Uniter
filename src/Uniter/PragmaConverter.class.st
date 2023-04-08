Class {
	#name : #PragmaConverter,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'oldString',
		'newString',
		'ast'
	],
	#category : #Uniter
}

{ #category : #accessing }
PragmaConverter >> ast [
	^ ast
]

{ #category : #converting }
PragmaConverter >> convert: aCompiledMethod [ 
	
	ast := RBParser parseMethod: aCompiledMethod sourceCode.
	"I do not want to fall into the cache or other"
	ast acceptVisitor: self
]

{ #category : #'set up' }
PragmaConverter >> convert: aString into: aString2 [ 
	oldString := aString.
	newString := aString2
]

{ #category : #visiting }
PragmaConverter >> visitPragmaNode: aPragma [
 	
	(aPragma selector asString = oldString)
		ifTrue: [ aPragma selector: newString asSymbol ] 
]
