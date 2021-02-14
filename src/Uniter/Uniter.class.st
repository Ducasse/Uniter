"
I'm an helper to convert in a nice way (not destroying GT meta data) example classes into test case.
Here is a typical example.

```
Uniter new forClass: BlCollectionRopeIteratorExamples; generate
```
"
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
	newClass comment: 'I have been automatically converted and probably manually tweaked from ', forClass name, '. Pay attention there is an important design decision in such tests. First to let GT people execute them, the tests and helpers are tagged with <gtExample> do not remove them, let also the <label:...>.
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
	self generateClassOriginString
	
]

{ #category : #accessing }
Uniter >> generateClassOriginString [
	
	newClass 
			compile: ('originClassName
	"This test was generated from..."
	^ ''', forClass name, '''') 
		 	classified: 'metadata'
]

{ #category : #accessing }
Uniter >> generateMethods [
	"self new forClass: BlAttributeRopeExamples ; generateMethods"
	| ast methods |
	methods := forClass localMethods groupedBy: [:each | each hasPragmaNamed: 'gtExample'].
	(methods at: true)
		do: [ :each | 
			| sel |
			sel := self treatSelectorForTest: each selector.
		   ast := each ast.
			newClass 
				compile: (ast selector: ('test', sel) asSymbol) formattedCode
			 	classified: 'tests'
		 ].
	
	(methods at: false)
		do: [ :each | 
			| sel |
			sel := self treatSelector: each selector.
		   ast := each ast.
			newClass 
				compile: (ast selector: sel asSymbol) formattedCode
			 	classified: 'fixture'
		 ].
]

{ #category : #accessing }
Uniter >> generateTestCaseClass [
	"Pay attention if there is a super class"
	"self new forClass: BlAttributeRopeExamples; generateTestCaseClass"
	| newName builder |
	newName := forClass name allButLast: 'Examples' size.
	newName := newName, 'Test'.
	builder := (Smalltalk globals at: #FluidClassBuilder) new.
	builder
		  superclassToBuild: TestCase;
		  classNameToBuild: newName;
		  package: (RPackageOrganizer default packageOf: forClass) packageName.
	forClass traits ifNotEmpty: [ :t | builder traitComposition: t  ].
	builder install.
	newClass := self class environment at: newName asSymbol.
	self addComment.
]

{ #category : #accessing }
Uniter >> treatSelector: aSymbol [
	(aSymbol includes: $_) 	
		ifTrue: [ ^ self treatUnderscoredSelector: aSymbol ].
	^ aSymbol 
]

{ #category : #accessing }
Uniter >> treatSelectorForTest: aSymbol [
	(aSymbol includes: $_) 	
		ifTrue: [ ^ self treatUnderscoredSelector: aSymbol ].
	^ aSymbol capitalized 
]

{ #category : #accessing }
Uniter >> treatUnderscoredSelector: aSymbolWithUnderscores [
	"replace _ ne_maman -> neManan"
	
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
