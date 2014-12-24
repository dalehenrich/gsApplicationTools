task scheduling
waitForTasks: taskList trace: trace
  | tasks loopCount completed target valid |
  trace
    ifTrue: [ 
      self
        doSimpleTransaction: [ 
          (ObjectLogEntry
            trace: '---SCHEDULING tasks (' , taskList size printString , ')'
            object: taskList) addToLog ] ].
  loopCount := 0.
  completed := {}.
  valid := #().
  tasks := taskList copy.
  [ tasks isEmpty ]
    whileFalse: [ 
      tasks copy
        do: [ :task | 
          self doAbortTransaction.
          (task hasError or: [ task hasValue ])
            ifTrue: [ 
              trace
                ifTrue: [ 
                  self
                    doSimpleTransaction: [ (ObjectLogEntry trace: task label , ' completed' object: task) addToLog ] ].
              completed add: task.
              tasks remove: task ] ].
      (Delay forSeconds: 1) wait.
      loopCount := loopCount + 1.
      loopCount > (taskList size * 12)
        ifTrue: [ 
          ^ {false.
          tasks.
          completed.
          valid.
          (self inProcess).
          (self queue)} ] ].
  valid := completed select: [ :each | each isValid ].
  ^ {true.
  tasks.
  completed.
  valid.
  (self inProcess).
  (self queue)}