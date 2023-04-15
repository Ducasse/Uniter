"
I'm an helper to convert in a nice way (not destroying GT meta data) example classes into test case.
Here is a typical example.

```
Uniter new forClass: BlCollectionRopeIteratorExamples; generate
```

```
Uniter new forClass: PragmaUserForTest ; fixPragma
```
"
Class {
	#name : #Uniter,
	#superclass : #Object,
	#instVars : [
		'forClass',
		'newClass',
		'selectorMapping'
	],
	#category : #Uniter
}

{ #category : #accessing }
Uniter >> addComment [
	newClass comment: 'I have been automatically converted and probably manually tweaked from ', forClass name, '. Pay attention there is an important design decision in such tests. First to let GT people execute them, the tests and helpers are tagged with <gtExample> do not remove them, let also the <label:...>.
	Finally and more important such tests should not use setup because every method should be in capacity of returning a fully working object called an example :)'
	
]

{ #category : #API }
Uniter >> fixPragma [

	| converter |
	converter := PragmaConverter new.
	converter convert: 'gtExample' into: 'sampleInstance'.
	
	forClass methods do: [ :cm | 
		
		cm origin compile: (converter convert: cm) ast formattedCode classified: cm protocol
	]
	
]

{ #category : #API }
Uniter >> forClass: aClass [

	forClass := aClass
]

{ #category : #API }
Uniter >> generate [
	"self new forClass: BlAttributeRopeExamples; generate"
	self generateTestCaseClass.
	self generateMethods.
	self generateClassOriginString
	
]

{ #category : #internals }
Uniter >> generateClassMethods [
	"self new forClass: BlAttributeRopeExamples ; generateMethods"
	| methods |
	methods := forClass class localMethods groupedBy: [:each | each hasPragmaNamed: 'gtExample'].
	self handleMethodFromSplitDictionary: methods.
]

{ #category : #internals }
Uniter >> generateClassOriginString [
	
	newClass 
			compile: ('originClassName
	"This test was generated from..."
	^ ''', forClass name, '''') 
		 	classified: 'metadata'
]

{ #category : #internals }
Uniter >> generateMethods [
	"self new forClass: BlAttributeRopeExamples ; generateMethods"

	| methods |
	methods := forClass localMethods groupedBy: [:each | each hasPragmaNamed: 'gtExample'].
	self handleMethodFromSplitDictionary: methods.
]

{ #category : #internals }
Uniter >> generateTestCaseClass [
	"Pay attention if there is a super class"
	"self new forClass: BlAttributeRopeExamples; generateTestCaseClass"
	| newName builder |
	newName := forClass name allButLast: 'Examples' size.
	newName := newName, 'Test'.
	self class environment at: newName asSymbol ifPresent: [ newName := newName, 'Zork248' ].
	builder := (self class environment at: #FluidClassBuilder) new.
	builder
		  superclassToBuild: TestCase;
		  nameToBuild: newName;
		  package: (RPackageOrganizer default packageOf: forClass) packageName.
	forClass traits ifNotEmpty: [ :t | builder traitComposition: t  ].
	builder install.
	newClass := self class environment at: newName asSymbol.
	self addComment.
]

{ #category : #internals }
Uniter >> handleMethodFromSplitDictionary2: aDict [
	
	(aDict at: true)
		do: [ :each | 
			| sel |
			sel := self treatSelectorForTest: each selector.
			selectorMapping at: each selector put: ('test', sel) asSymbol.
		 ].
	
	aDict 
		at: false 
		ifPresent: [ :ms |
			ms do: [ :each | 
				| sel |
				sel := self treatSelector: each selector.
				selectorMapping at: each selector put: sel ]].
		
		
	(aDict at: true)
		do: [ :each | 
			| sel ast |
		   ast := SelfSenderFixer new 
						mappingSelector: selectorMapping ; 
						convertAst: each ast;
						ast.
			sel := selectorMapping at: each selector.
			newClass 
				compile: (ast selector: ('test', sel) asSymbol) formattedCode
			 	classified: 'tests'
		 ].
	
	aDict 
		at: false 
		ifPresent: [ :ms |
			ms do: [ :each | 
				| sel ast |
		   		ast := SelfSenderFixer new 
						mappingSelector: selectorMapping ; 
						convertAst: each ast;
						ast.
				sel := selectorMapping at: each selector.
				newClass
					compile: (ast selector: sel asSymbol) formattedCode
			 		classified: 'fixture' ]]
]

{ #category : #internals }
Uniter >> handleMethodFromSplitDictionary: aDict [
	
	(aDict at: true)
		do: [ :each | 
			| sel ast |
			sel := self treatSelectorForTest: each selector.
			selectorMapping at: each selector put: ('test', sel) asSymbol.
		   ast := each ast.
			newClass 
				compile: (ast selector: ('test', sel) asSymbol) formattedCode
			 	classified: 'tests'
		 ].
	
	aDict 
		at: false 
		ifPresent: [ :ms |
			ms do: [ :each | 
				| sel ast |
				sel := self treatSelector: each selector.
				selectorMapping at: each selector put: sel.
		 	  ast := each ast.
				newClass 
					compile: (ast selector: sel asSymbol) formattedCode
			 		classified: 'fixture' ]]
		 
]

{ #category : #initialization }
Uniter >> initialize [

	super initialize.
	selectorMapping := Dictionary new. 
]

{ #category : #internals }
Uniter >> treatSelector: aSymbol [
	(aSymbol includes: $_) 	
		ifTrue: [ ^ self treatUnderscoredSelector: aSymbol ].
	^ aSymbol 
]

{ #category : #internals }
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
