gem server start
startAllGems
  self singleton servers do: [ :each | each startGems ]