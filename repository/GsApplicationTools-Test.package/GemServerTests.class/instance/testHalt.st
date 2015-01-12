tests
testHalt
  | gemServer |
  gemServer := self createGemServer.
  gemServer scriptLogEvent: '---->testHalt' object: gemServer.
  [ 
  self startGems: gemServer.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == #'started'.
  gemServer performMessage: #'halt'.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == self haltSymbol.
  gemServer actionException ifNotNil: [ :ex | self assert: (ex isKindOf: Halt) ].
  gemServer performMessage: #'add' with: 41.
  self waitForActionResult: gemServer.
  self assert: gemServer actionResult == 42 ]
    ensure: [ self stopGems: gemServer ]