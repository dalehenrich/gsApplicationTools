tests
testStartStopRestart
  | mockServer |
  mockServer := GemServerRegistry gemServerNamed: 'Mock_Server'.
  self assert: mockServer eventLog isEmpty.
  GemServerRegistry startGemsNamed: 'Mock_Server'.
  self
    assertEventLog: mockServer eventLog
    total: 3
    start: 3
    stop: 0
    restart: 0.
  GemServerRegistry stopGemsNamed: 'Mock_Server'.
  self
    assertEventLog: mockServer eventLog
    total: 6
    start: 3
    stop: 3
    restart: 0.
  GemServerRegistry restartGemsNamed: 'Mock_Server'.
  self
    assertEventLog: mockServer eventLog
    total: 9
    start: 3
    stop: 3
    restart: 3