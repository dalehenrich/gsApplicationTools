tests
testRegistration
  | gemName |
  gemName := 'Another Mock Server'.
  self assert: (GemServerRegistry gemServerNamed: gemName) isNil.
  GemServerRegistry
    addGemServerOfClass: GemServerMockServer
    withName: gemName
    on: #(9001 9002 9003).
  self assert: (GemServerRegistry gemServerNamed: gemName) notNil.
  GemServerRegistry removeGemServerNamed: gemName.
  self assert: (GemServerRegistry gemServerNamed: gemName) isNil