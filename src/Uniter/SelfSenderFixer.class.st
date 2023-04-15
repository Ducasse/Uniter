Class {
	#name : #SelfSenderFixer,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'ast',
		'mappingSelector'
	],
	#category : #Uniter
}

{ #category : #accessing }
SelfSenderFixer >> ast [
	^ ast
]

{ #category : #accessing }
SelfSenderFixer >> ast: anAST [
	ast := anAST
]

{ #category : #converting }
SelfSenderFixer >> convert: aCompiledMethod [ 
	
	ast := RBParser parseMethod: aCompiledMethod sourceCode.
	"I do not want to fall into the cache or other"
	ast acceptVisitor: self
]

{ #category : #converting }
SelfSenderFixer >> convertAst: anAST [ 
	
	ast := anAST.
	anAST acceptVisitor: self
]

{ #category : #accessing }
SelfSenderFixer >> mappingSelector: aDictionary [ 
	mappingSelector := aDictionary
]

{ #category : #visiting }
SelfSenderFixer >> visitMessageNode: aMessage [
 
	aMessage isSelfSend 
		ifTrue: [ 
				mappingSelector at: aMessage selector asString
					ifPresent: [ :new | aMessage selector: new ]
					ifAbsent: [  ] ]
]
