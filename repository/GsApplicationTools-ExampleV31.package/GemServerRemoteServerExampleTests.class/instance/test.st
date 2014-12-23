tests
test
  | gemServer client |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer scriptLogEvent: '---->test' object: gemServer.
  client := GemServerRemoteClientExample new.
  [ 
  | task loopCount |
  self startGems: gemServer.
  task := client scheduleSimpleTask.
  loopCount := 0.
  [ task hasError or: [ task hasValue ] ]
    whileFalse: [ 
      (Delay forSeconds: 1) wait.
      client doAbortTransaction.
      loopCount := loopCount + 1.
      loopCount > 6
        ifTrue: [ self assert: false description: 'no response from server' ] ].
  self assert: task hasValue.
  self deny: task hasError ]
    ensure: [ self stopGems: gemServer ]