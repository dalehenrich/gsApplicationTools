task scheduling
waitForTasks: taskList gemServer: gemServer
  | tasks loopCount completed target valid trace expectedDelay |
  trace := gemServer tracing.
  trace
    ifTrue: [ 
      self
        doTransaction: [ 
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
  expectedDelay := 0.
  tasks do: [ :each | expectedDelay := expectedDelay + each expectedDelay ].
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
                        , completed size printString , ' valid: '
                        , valid size printString , ' queue: '
                        , self queue size printString , ' inProcess: '
                        , self inProcess size printString.
              crashLog
                do: [ :assoc | 
                  Transcript
                    cr;
                    tab;
                    show: assoc value label ].
              trace
                ifTrue: [ 
                  self
                    doTransaction: [ (ObjectLogEntry trace: '---CRASHED' object: gemServer crashLog) addToLog ] ].
              ^ {false.
              tasks.
              completed.
              valid.
              #'crashed'.
              (self inProcess).
              (self queue)} ].
          (task hasError or: [ task hasValue ])
            ifTrue: [ 
              trace
                ifTrue: [ 
                  self
                    doTransaction: [ (ObjectLogEntry trace: task label , ' completed' object: task) addToLog ] ].
              completed add: task.
              tasks remove: task ] ].
      (Delay forSeconds: 1) wait.
      loopCount := loopCount + 1.
      loopCount > (expectedDelay * 2)
        ifTrue: [ 
          Transcript
            cr;
            show:
                'Server timed out: (' , (expectedDelay * 2) printString , ' tasks: '
                    , tasks size printString , ' completed: '
                    , completed size printString , ' valid: '
                    , valid size printString , ' queue: '
                    , self queue size printString , ' inProcess: '
                    , self inProcess size printString.
          trace
            ifTrue: [ 
              self
                doTransaction: [ 
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
          #'timedOut'.
          (self inProcess).
          (self queue)} ] ].
  valid := completed select: [ :each | each isValid ].
  Transcript
    cr;
    show:
        'Server completed: ' , tasks size printString , ' completed: '
            , completed size printString , ' valid: ' , valid size printString
            , ' queue: ' , self queue size printString , ' inProcess: '
            , self inProcess size printString.
  trace
    ifTrue: [ 
      self
        doTransaction: [ 
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
  #'success'.
  (valid collect: [ :each | each value ]).
  (self inProcess).
  (self queue)}