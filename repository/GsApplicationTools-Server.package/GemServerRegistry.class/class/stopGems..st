gem server stop
stopGems: server
  "self stopGems"

  server executeGemCommand: 'stop'