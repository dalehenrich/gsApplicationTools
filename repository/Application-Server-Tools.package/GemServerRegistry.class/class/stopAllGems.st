other
stopAllGems
	self singleton servers do: [:each | self stopGems: each].
