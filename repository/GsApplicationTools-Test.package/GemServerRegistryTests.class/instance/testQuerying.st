tests
testQuerying
  | expected actual |
  expected := #('Mock_Server' 'Mock_Server_Default').
  actual := GemServerRegistry gemServerNames.
  self assertExpectedNames: actual equals: expected.
  actual := GemServerRegistry serversOnPort: 9001.
  self assertExpectedNames: {(actual name)} equals: #('Mock_Server')