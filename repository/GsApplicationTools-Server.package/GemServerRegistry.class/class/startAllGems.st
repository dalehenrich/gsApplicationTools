gem server start
startAllGems
	self singleton servers do: [:each | self startGems: each].
