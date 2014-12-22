tests
testHalt
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer scriptLogEvent: '---->testHalt' object: gemServer.
  [ 
  gemServer startGems.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'halt'.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'halt' ]
    ensure: [ 
      gemServer stopGems.
      (Delay forSeconds: 3) wait ]