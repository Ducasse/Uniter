Class {
	#name : #PragmaUserForTest,
	#superclass : #Object,
	#category : #Uniter
}

{ #category : #tests }
PragmaUserForTest >> notUsingSmall [

	self small2
]

{ #category : #'as yet unclassified' }
PragmaUserForTest >> usingPragmaGT [

	<gtExample>
	^ 999
]

{ #category : #'as yet unclassified' }
PragmaUserForTest >> usingPragmaTintin [

	<tintin>
	^ 999
]

{ #category : #tests }
PragmaUserForTest >> usingSmall [

	self small
]

{ #category : #tests }
PragmaUserForTest >> usingSmallOnNotSelf [

	| tmp |
	tmp small.
]
