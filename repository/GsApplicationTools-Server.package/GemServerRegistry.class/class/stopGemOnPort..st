gem server stop
stopGemOnPort: aPortNumber
  (self serversOnPort: aPortNumber) do: [ :each | each stopGems ]