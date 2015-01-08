tests
testExampleHttp
  | gemServer taskList client completed |
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testExampleHttp' object: gemServer.
  client := self gemClientClass new.
  [ 
  | task |
  self startGems: gemServer.
  taskList := {}.
  4
    timesRepeat: [ 
      task := client scheduleExampleHttpTask.
      taskList add: task ].
  self waitForTasks: taskList gemServer: gemServer client: client ]
    ensure: [ 
      gemServer
        doTransaction: [ (ObjectLogEntry trace: 'testExampleHttp ensure : stopGems') addToLog ].
      self stopGems: gemServer ]