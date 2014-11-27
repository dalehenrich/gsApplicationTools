tests
testQuerying
  | expected actual |
  expected := #('Mock Server' 'Mock Server Default').
  actual := GemServerRegistry gemServerNames.
  self assertExpectedNames: actual equals: expected.
  actual := GemServerRegistry serversOnPort: 9001.
  self assertExpectedNames: {(actual name)} equals: #('Mock Server')