tests
testPerformMessage
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer scriptLogEvent: '---->testPerformMessage' object: gemServer.
  [ 
  self startGems: gemServer.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'add' with: 41.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == 42 ]
    ensure: [ self stopGems: gemServer ]