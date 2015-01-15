tests
testTransaction
  | gemServer |
  gemServer := self createGemServer.
  gemServer class resetPersistentRoot.
  System commitTransaction.
  gemServer scriptLogEvent: '---->testTransaction' object: gemServer.
  [ 
  self startGems: gemServer.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'transaction' with: 41.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == 42.
  self assert: (gemServer class persistentRoot at: #'performTransaction') = 42.
  gemServer performMessage: #'transaction' with: 45.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == 46.
  self assert: (gemServer class persistentRoot at: #'performTransaction') = 46 ]
    ensure: [ self stopGems: gemServer ]