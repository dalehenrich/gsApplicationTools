private
runTest: gemServer
  [ 
  self startGems: gemServer.
  self waitAndValidateResponse: gemServer ]
    ensure: [ self stopGems: gemServer ]