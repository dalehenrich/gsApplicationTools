gem server restart
restartAllGems
  self singleton servers do: [ :each | self restartGems: each ]