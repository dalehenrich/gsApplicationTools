tests
testTimeInLondon
  | gemServer taskList client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
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
  completed := self waitForTasks: taskList gemServer: gemServer client: client.
  completed
    do: [ :each | 
      Transcript
        cr;
        show: each elapsedTime printString ] ]
    ensure: [ 
      gemServer
        doTransaction: [ (ObjectLogEntry trace: 'testTimeInLondon ensure : stopGems') addToLog ].
      self stopGems: gemServer ]