gem server stop
stopGems: server
	"self stopGems"

	self executeGemCommand: 'stop' for: server
