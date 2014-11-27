tests
testRegistration
  | gemName gemServer |
  gemName := 'Another_Mock_Server'.
  self assert: (GemServerRegistry gemServerNamed: gemName) isNil.
  gemServer := GemServerRegistry
    addGemServerOfClass: GemServerMockServer
    withName: gemName
    on: #(9001 9002 9003).
  self assert: (GemServerRegistry gemServerNamed: gemName) notNil.
  GemServerRegistry removeGemServer: gemServer.
  self assert: (GemServerRegistry gemServerNamed: gemName) isNil