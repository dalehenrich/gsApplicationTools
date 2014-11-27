gem server stop
stopGemsNamed: aName
	
	self stopGems:(self gemServerNamed: aName).
