tests
testRegistration
  | gemName gemServer |
  gemName := 'Another_Mock_Server'.
  self assert: (GemServer gemServerNamed: gemName) isNil.
  gemServer := MockGemServer register: gemName on: #(9001 9002 9003).
  self assert: (GemServer gemServerNamed: gemName) notNil.
  GemServer removeGemServer: gemServer.
  self assert: (GemServer gemServerNamed: gemName) isNil