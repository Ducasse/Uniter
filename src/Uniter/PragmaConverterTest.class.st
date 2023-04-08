Class {
	#name : #PragmaConverterTest,
	#superclass : #TestCase,
	#category : #Uniter
}

{ #category : #tests }
PragmaConverterTest >> testConvertTintin [

	| ast |
	ast := PragmaConverter new
		convert: 'tintin' into: 'toto';
		convert: PragmaUserForTest >> #usingPragmaTintin;
		ast.
	self assert: ast formattedCode equals: 'usingPragmaTintin

	<toto>
	^ 999'
]
