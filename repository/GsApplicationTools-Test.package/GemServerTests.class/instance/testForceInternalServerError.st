tests
testForceInternalServerError
  | gemServer |
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer
    scriptLogEvent: '---->testForceInternalServerError'
    object: gemServer.
  [ 
  self startGems: gemServer.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'forceInternalServerError'.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == self internalServerErrorSymbol.
  self assert: (gemServer actionException isKindOf: Error).
  gemServer performMessage: #'add' with: 41.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == 42 ]
    ensure: [ self stopGems: gemServer ]