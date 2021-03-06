tests
testStartStopRestartAll
  | mockServer mockServerDefault |
  mockServer := GemServerRegistry gemServerNamed: 'Mock_Server'.
  mockServerDefault := GemServerRegistry gemServerNamed: 'Mock_Server_Default'.
  mockServerDefault eventLog: mockServer eventLog.
  self assert: mockServer eventLog isEmpty.
  GemServerRegistry startAllGems.
  self
    assertEventLog: mockServer eventLog
    total: 4
    start: 4
    stop: 0
    restart: 0.
  GemServerRegistry stopAllGems.
  self
    assertEventLog: mockServer eventLog
    total: 8
    start: 4
    stop: 4
    restart: 0.
  GemServerRegistry restartAllGems.
  self
    assertEventLog: mockServer eventLog
    total: 16
    start: 8
    stop: 8
    restart: 0