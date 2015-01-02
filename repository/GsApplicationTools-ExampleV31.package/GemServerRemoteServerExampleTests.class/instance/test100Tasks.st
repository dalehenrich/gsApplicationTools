tests
test100Tasks
  | gemServer taskList client |
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
  true
    ifTrue: [ 
      self taskList100
        do: [ :sel | 
          task := client perform: sel.
          gemServer doTransaction: [ task label: sel asString ].
          Transcript
            cr;
            show: task label.
          taskList add: task ] ]
    ifFalse: [ 
      100
        timesRepeat: [ 
          | sel |
          sel := taskSelectors atRandom.
          task := client perform: sel.
          gemServer doTransaction: [ task label: sel asString ].
          Transcript
            cr;
            show: task label.
          taskList add: task ] ].
  Transcript
    cr;
    show:
        '============================TASK SCHEDULING COMPLETE============================'.
  System commitTransaction.
  self waitForTasks: taskList gemServer: gemServer client: client ]
    ensure: [ 
      gemServer
        doTransaction: [ (ObjectLogEntry trace: 'test100Tasks ensure : stopGems') addToLog ].
      self stopGems: gemServer ]