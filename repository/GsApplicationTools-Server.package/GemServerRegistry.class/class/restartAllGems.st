gem server restart
restartAllGems
  self singleton servers do: [ :each | each restartGems ]