task scheduling
waitForTasks: taskList gemServer: gemServer
  | tasks loopCount completed target valid trace |
  trace := gemServer tracing.
  trace
    ifTrue: [ 
      self
        doSimpleTransaction: [ 
          (ObjectLogEntry
            trace: '---SCHEDULING tasks (' , taskList size printString , ')'
            object:
              {taskList.
              (self inProcess).
              (self queue)})
            addToLog ] ].
  loopCount := 0.
  completed := {}.
  valid := #().
  tasks := taskList copy.
  [ tasks isEmpty ]
    whileFalse: [ 
      tasks copy
        do: [ :task | 
          self doAbortTransaction.
          gemServer crashLog isEmpty
            ifFalse: [ 
              Transcript
                cr;
                show:
                    'Server crashed: ' , tasks size printString , ' completed: '
                        , completed size printString.
              crashLog
                do: [ :assoc | 
                  Transcript
                    cr;
                    tab;
                    show: assoc value label ].
              trace
                ifTrue: [ 
                  self
                    doSimpleTransaction: [ (ObjectLogEntry trace: '---CRASHED' object: gemServer crashLog) addToLog ] ].
              ^ {false.
              tasks.
              completed.
              valid.
              (self inProcess).
              (self queue)} ].
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
      loopCount > (taskList size * 6)
        ifTrue: [ 
          trace
            ifTrue: [ 
              self
                doSimpleTransaction: [ 
                  (ObjectLogEntry
                    trace: '---EXPIRED'
                    object:
                      {taskList.
                      false.
                      tasks.
                      completed.
                      valid.
                      (self inProcess).
                      (self queue)})
                    addToLog ] ].
          ^ {false.
          tasks.
          completed.
          valid.
          (self inProcess).
          (self queue)} ] ].
  valid := completed select: [ :each | each isValid ].
  trace
    ifTrue: [ 
      self
        doSimpleTransaction: [ 
          (ObjectLogEntry
            trace: '---COMPLETED'
            object:
              {taskList.
              false.
              tasks.
              completed.
              valid.
              #().
              (self inProcess).
              (self queue)})
            addToLog ] ].
  ^ {true.
  tasks.
  completed.
  valid.
  (valid collect: [ :each | each value ]).
  (self inProcess).
  (self queue)}