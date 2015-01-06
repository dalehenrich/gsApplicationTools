tests
runTest: gemServer client: client task: task
  [ 
  self startGems: gemServer.
  self waitForTasks: {task} gemServer: gemServer client: client ]
    ensure: [ 
      gemServer tracing
        ifTrue: [ 
          gemServer
            doTransaction: [ (ObjectLogEntry trace: task label printString , ' ensure : stopGems') addToLog ] ].
      self stopGems: gemServer ]