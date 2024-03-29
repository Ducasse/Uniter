"
I'm an helper to convert in a nice way (not destroying GT meta data) example classes into test case.
Here is a typical example.

```
UniterForP11 new forClass: BlVector2DExamples; generate
```

```
UniterForP11 new forClass: BlGeometryVisualAndLayoutBoundsTest; fixPragma
```

To do
- only convert method with gtExample tag 
- manage superclass 
- use local and not methods else trait methods are duplicated.

"
Class {
	#name : #UniterForP11,
	#superclass : #Uniter,
	#category : #Uniter
}

{ #category : #accessing }
UniterForP11 >> generateTestCaseClass [
	"Pay attention if there is a super class"
	"self new forClass: BlAttributeRopeExamples; generateTestCaseClass"
	| newName |
	newName := forClass name allButLast: 'Examples' size.
	newName := newName, 'Test'.
	forClass traits 
		ifNotEmpty: [ :t | 
	TestCase subclass: newName asSymbol
		uses: t
		instanceVariableNames: forClass instanceVariablesString
		classVariableNames: ''
		package: (RPackageOrganizer default packageOf: forClass) packageName. ]
		ifEmpty: [ 
			TestCase subclass: newName asSymbol
		instanceVariableNames: forClass instanceVariablesString
		classVariableNames: ''
		package: (RPackageOrganizer default packageOf: forClass) packageName. 
			 ].
		
	newClass := self class environment at: newName asSymbol.
	self addComment.
]
