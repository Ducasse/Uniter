Class {
	#name : #Uniter,
	#superclass : #Object,
	#instVars : [
		'forClass',
		'newClass'
	],
	#category : #Uniter
}

{ #category : #accessing }
Uniter >> addComment [
	newClass comment: 'I have automatically converted and probably manually tweaked from ', forClass name, '. Pay attention there is an important design decision in such tests. First to let GT people execute them, the tests and helpers are tagged with <gtExample> do not remove them, let also the <label:...>.
	Finally and more important such tests should not use setup because every method should be in capacity of returning a fully working object called an example :)'
	
]

{ #category : #accessing }
Uniter >> forClass: aClass [

	forClass := aClass
]

{ #category : #accessing }
Uniter >> generate [
	"self new forClass: BlAttributeRopeExamples; generate"
	self generateTestCaseClass.
	self generateMethods.
	
]

{ #category : #accessing }
Uniter >> generateMethods [
	"self new forClass: BlAttributeRopeExamples ; generateMethods"
	| ast |
	forClass methods do: [ :each | 
		| sel |
		sel := self treatSelector: each selector.
	   ast := each ast.
		newClass 
			compile: (ast selector: ('test', sel) asSymbol) formattedCode
		 	classified: 'tests'
		 ]
]

{ #category : #accessing }
Uniter >> generateTestCaseClass [
	"Pay attention if there is a super class"
	"self new forClass: BlAttributeRopeExamples; generateTestCaseClass"
	| newName builder |
	newName := forClass name allButLast: 'Examples' size.
	newName := newName, 'Test'.
	builder := FluidClassBuilder new.
	builder 
		  superclassToBuild: TestCase;
		  classNameToBuild: newName;
		  package: (RPackageOrganizer default packageOf: forClass) packageName.
	builder install.
	newClass := self class environment at: newName asSymbol.
	self addComment.
]

{ #category : #accessing }
Uniter >> treatSelector: aSymbol [
	(aSymbol includes: $_) 	
		ifTrue: [ ^ self treatUnderscoredSelector: aSymbol ].
	^ aSymbol capitalized 
]

{ #category : #accessing }
Uniter >> treatUnderscoredSelector: aSymbolWithUnderscores [
	
	
	^ String streamContents: [ :s |
		| under |
		under := true.
		aSymbolWithUnderscores do: [ :each | 
			each = $_ 
				ifTrue: [ under := true  ] 
				ifFalse: [ 
						under 
							ifTrue: [ s nextPut: each asUppercase ]
							ifFalse: [ s nextPut: each ].	 
						under := false ] ] ]
	
]
