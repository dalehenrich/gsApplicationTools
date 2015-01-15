tests
testError
  | gemServer |
  gemServer := self createGemServer.
  gemServer scriptLogEvent: '---->testERROR' object: gemServer.
  [ 
  self startGems: gemServer.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'error'.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == self errorLoggedSymbol.
  self assert: (gemServer actionException isKindOf: MessageNotUnderstood).
  gemServer performMessage: #'add' with: 41.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == 42 ]
    ensure: [ self stopGems: gemServer ]