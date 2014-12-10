gem server stop
stopAllGems
  self singleton servers do: [ :each | each stopGems ]