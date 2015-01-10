tests
testReentrantTransactionError
  | gemServer |
  gemServer := self createGemServer.
  gemServer
    scriptLogEvent: '---->testReentrantTransactionError'
    object: gemServer.
  [ 
  self startGems: gemServer.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'reentrantTransactionError'.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == self errorLoggedSymbol.
  self assert: (gemServer actionException isKindOf: Error).
  gemServer performMessage: #'add' with: 41.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == 42 ]
    ensure: [ self stopGems: gemServer ]