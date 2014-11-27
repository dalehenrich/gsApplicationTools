gem server stop
stopGemOnPort: aPortNumber
	(self serversOnPort: aPortNumber) do: [:each | self stopGems: each]
