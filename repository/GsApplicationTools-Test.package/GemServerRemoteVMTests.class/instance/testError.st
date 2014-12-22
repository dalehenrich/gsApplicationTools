tests
testError
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer scriptLogEvent: '---->testERROR' object: gemServer.
  [ 
  gemServer startGems.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'error'.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult key == #'ERROR_LOGGED'.
  self assert: (gemServer actionResult value isKindOf: MessageNotUnderstood) ]
    ensure: [ 
      gemServer stopGems.
      (Delay forSeconds: 3) wait ]