tests
runTest: gemServer client: client task: task
  | completed |
  [ 
  self startGems: gemServer.
  completed := self waitForTasks: {task} for: client trace: gemServer tracing ]
    ensure: [ 
      gemServer tracing
        ifTrue: [ 
          gemServer
            doSimpleTransaction: [ (ObjectLogEntry trace: task label printString , ' ensure : stopGems') addToLog ] ].
      self stopGems: gemServer ].
  ^ completed