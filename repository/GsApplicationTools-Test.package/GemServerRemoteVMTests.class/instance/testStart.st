tests
testStart
  | eventLog count statusReport |
  GemServerRegistry gemServerNamed: 'Mock_Server'.
  GemServerRegistry startGemsNamed: 'Mock_Server'.
  count := 0.
  [ 
  System abortTransaction.
  GemServerMockServer isEventLogInitialized ]
    whileFalse: [ 
      "If running remote server, wait for event log to get initialized"
      (Delay forSeconds: 5) wait.
      count := count + 1.
      count > 6
        ifTrue: [ 
          "fail if it takes longer than 30 seconds for remote server to get started"
          self assert: false ] ].
  eventLog := GemServerMockServer eventLog.
  self
    assertEventLog: eventLog
    total: 1
    start: 1
    stop: 0
    restart: 0.
  statusReport := (GemServerRegistry gemServerNamed: 'Mock_Server') statusGems.
  Transcript
    cr;
    show: statusReport.
  self assert: statusReport lines size = (self ports size + 1).
  GemServerRegistry stopGemsNamed: 'Mock_Server'