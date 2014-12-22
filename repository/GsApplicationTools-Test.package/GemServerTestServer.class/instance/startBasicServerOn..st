service instance-server
startBasicServerOn: ignored
  "start server in current vm. expected to return."

  self
    maintenanceProcess:
      [ 
      | loopCount |
      loopCount := 0.
      [ true ]
        whileTrue: [ 
          loopCount := loopCount + 1.
          self
            gemServerTransaction: [ self handleAction ]
            onError: [ :ex | self handleActionError: ex ].
          (Delay forMilliseconds: 500) wait.
          self
            doSimpleTransaction: [ self logEvent: 'LOOPCOUNT: ' , loopCount printString object: self ] ] ]
        fork.
  self serverInstance: self	"the maintenanceProcess is session-specific"