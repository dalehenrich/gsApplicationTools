tests
testTimeInLondon
  | gemServer taskList client |
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->testTimeInLondon' object: gemServer.
  client := self gemClientClass new.
  [ 
  | task |
  self startGems: gemServer.
  taskList := {}.
  4
    timesRepeat: [ 
      task := client scheduleTimeInLondonTask.
      taskList add: task ].
  self waitForTasks: taskList gemServer: gemServer client: client ]
    ensure: [ 
      gemServer
        doTransaction: [ (ObjectLogEntry trace: 'testTimeInLondon ensure : stopGems') addToLog ].
      self stopGems: gemServer ]