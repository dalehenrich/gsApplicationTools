gem server restart
restartGemsNamed: aName
	
	self restartGems: (self gemServerNamed: aName)
