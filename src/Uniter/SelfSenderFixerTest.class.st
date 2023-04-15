Class {
	#name : #SelfSenderFixerTest,
	#superclass : #TestCase,
	#category : #Uniter
}

{ #category : #tests }
SelfSenderFixerTest >> testFixNoSender [

	| ast |
	ast := SelfSenderFixer new
		mappingSelector: { #small  -> #testSmall } asDictionary;
		convert: PragmaUserForTest >> #notUsingSmall;
		ast.
	self assert: ast formattedCode equals: 'notUsingSmall

	self small2'
]

{ #category : #tests }
SelfSenderFixerTest >> testFixNoSenderAST [

	| ast |
	ast := SelfSenderFixer new
		mappingSelector: { #small  -> #testSmall } asDictionary;
		convertAst: (PragmaUserForTest >> #notUsingSmall) ast;
		ast.
	self assert: ast formattedCode equals: 'notUsingSmall

	self small2'
]

{ #category : #tests }
SelfSenderFixerTest >> testFixSender [

	| ast |
	ast := SelfSenderFixer new
		mappingSelector: { #small  -> #testSmall } asDictionary;
		convert: PragmaUserForTest >> #usingSmall;
		ast.
	self assert: ast formattedCode equals: 'usingSmall

	self testSmall'
]

{ #category : #tests }
SelfSenderFixerTest >> testFixSenderAST [

	| ast |
	ast := SelfSenderFixer new
		mappingSelector: { #small  -> #testSmall } asDictionary;
		convertAst: (PragmaUserForTest >> #usingSmall) ast;
		ast.
	self assert: ast formattedCode equals: 'usingSmall

	self testSmall'
]

{ #category : #tests }
SelfSenderFixerTest >> testFixSenderNotSelf [

	| ast |
	ast := SelfSenderFixer new
		mappingSelector: { #small  -> #testSmall } asDictionary;
		convert: PragmaUserForTest >> #usingSmallOnNotSelf;
		ast.
	self assert: ast formattedCode equals:'usingSmallOnNotSelf

	| tmp |
	tmp small'
]
