tests
testPerformMessage
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer scriptLogEvent: '---->testPerformMessage' object: gemServer.
  [ 
  gemServer startGems.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'add' with: 41.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == 42 ]
    ensure: [ 
      gemServer stopGems.
      (Delay forSeconds: 3) wait ]