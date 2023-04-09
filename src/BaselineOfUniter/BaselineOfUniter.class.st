Class {
	#name : #BaselineOfUniter,
	#superclass : #BaselineOf,
	#category : #BaselineOfUniter
}

{ #category : #baselines }
BaselineOfUniter >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec package: #'Uniter' ]
]
