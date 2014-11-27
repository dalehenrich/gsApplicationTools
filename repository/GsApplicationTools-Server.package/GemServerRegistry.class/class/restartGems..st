gem server restart
restartGems: server
	"self restartGems"

	self executeGemCommand: 'restart' for: server
