Class {
	#name : #UniterTest,
	#superclass : #TestCase,
	#category : #Uniter
}

{ #category : #tests }
UniterTest >> testTreatUnderscoredSelector [
	| u |
	u := Uniter new. 
	self 
		assert: (u treatUnderscoredSelector: 'attributes_small_0_to_0') 
		equals: 'AttributesSmall0To0'
		
]
