tests
testStartServer
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer scriptLogEvent: '---->testStartServer' object: gemServer.
  [ 
  gemServer startGems.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started' ]
    ensure: [ 
      gemServer stopGems.
      (Delay forSeconds: 3) wait ]