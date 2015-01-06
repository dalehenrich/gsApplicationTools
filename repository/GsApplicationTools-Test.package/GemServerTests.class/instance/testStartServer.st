tests
testStartServer
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer scriptLogEvent: '---->testStartServer' object: gemServer.
  [ 
  self startGems: gemServer.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started' ]
    ensure: [ self stopGems: gemServer ]