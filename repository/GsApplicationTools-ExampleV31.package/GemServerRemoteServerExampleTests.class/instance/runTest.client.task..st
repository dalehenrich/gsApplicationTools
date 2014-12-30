tests
runTest: gemServer client: client task: task
  | completed |
  [ 
  self startGems: gemServer.
  completed := self waitForTasks: {task} gemServer: gemServer client: client ]
    ensure: [ 
      gemServer tracing
        ifTrue: [ 
          gemServer
            doTransaction: [ (ObjectLogEntry trace: task label printString , ' ensure : stopGems') addToLog ] ].
      self stopGems: gemServer ].
  ^ completed