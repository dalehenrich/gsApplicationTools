gem server restart
restartGemOnPort: aPortNumber
  (self serversOnPort: aPortNumber) do: [ :each | each restartGems ]