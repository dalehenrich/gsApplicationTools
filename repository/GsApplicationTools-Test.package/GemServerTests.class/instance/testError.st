tests
testError
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer scriptLogEvent: '---->testERROR' object: gemServer.
  [ 
  self startGems: gemServer.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'error'.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult key == #'ERROR_LOGGED'.
  self assert: (gemServer actionResult value isKindOf: MessageNotUnderstood) ]
    ensure: [ self stopGems: gemServer ]