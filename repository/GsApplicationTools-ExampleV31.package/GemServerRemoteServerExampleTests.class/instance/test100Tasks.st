tests
test100Tasks
  | gemServer taskList client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    enableCreateContinuations: true;
    tracing: true.
  gemServer scriptLogEvent: '---->test100Tasks' object: gemServer.
  client := self gemClientClass new.
  [ 
  | task taskSelectors |
  self startGems: gemServer.
  taskSelectors := self scheduledTaskList.
  taskList := {}.
  100
    timesRepeat: [ 
      | sel |
      sel := taskSelectors atRandom.
      task := client perform: sel.
      gemServer doSimpleTransaction: [ task label: sel asString ].
      Transcript
        cr;
        show: task label.
      taskList add: task ].
  Transcript
    cr;
    show:
        '============================TASK SCHEDULING COMPLETE============================'.
  System commitTransaction.
  completed := self waitForTasks: taskList gemServer: gemServer client: client.
  completed
    do: [ :each | 
      Transcript
        cr;
        show: each label , ': ' , each elapsedTime printString ] ]
    ensure: [ 
      gemServer
        doSimpleTransaction: [ (ObjectLogEntry trace: 'test100Tasks ensure : stopGems') addToLog ].
      self stopGems: gemServer ]