tests
testTimeInLondon
  | gemServer taskList client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer tracing: false.
  gemServer scriptLogEvent: '---->testTimeInLondon' object: gemServer.
  client := GemServerRemoteClientExample new.
  [ 
  | task |
  self startGems: gemServer.
  taskList := {}.
  4
    timesRepeat: [ 
      task := client scheduleTimeInLondonTask.
      taskList add: task ].
  completed := self waitForTasks: taskList for: client trace: gemServer tracing.
  completed
    do: [ :each | 
      Transcript
        cr;
        show: each elapsedTime printString ] ]
    ensure: [ 
      gemServer
        doSimpleTransaction: [ (ObjectLogEntry trace: 'testTimeInLondon ensure : stopGems') addToLog ].
      self stopGems: gemServer ]