gem server stop
stopAllGems
	self singleton servers do: [:each | self stopGems: each].
