service instance-server
startBasicServerOn: ignored
  "start server in current vm. expected to return."

  self
    serverProcess:
      [ 
      [ true ]
        whileTrue: [ 
          self
            gemServer: [ 
              | qcv |
              self queueCounterValue <= self currentQueueCounter
                ifTrue: [ (Delay forMilliseconds: 100) wait ].
              qcv := self queueCounterValue.
              self inProcess size > 0
                ifTrue: [ 
                  self
                    trace: [ 'counters [0] inProcess: ' , self inProcess size printString ]
                    object: [ 
                      {(self status).
                      qcv.
                      currentQueueCounter.
                      (self inProcess).
                      (self queue).
                      self} ] ].
              qcv > self currentQueueCounter
                ifTrue: [ 
                  "handle exceptions that occur while managing the queues"
                  [ 
                  self trace: [ 'queue size [1] ' , self queue size printString ] object: [  ].
                  self queue size > 0 ]
                    whileTrue: [ 
                      | tasks |
                      self
                        doSimpleTransaction: [ 
                          tasks := self queue removeAll.
                          self inProcess addAll: tasks ].
                      self
                        trace: [ 'tasks [1] ' , tasks size printString ]
                        object: [ tasks copy ].
                      tasks
                        do: [ :task | 
                          | proc |
                          self
                            trace: [ 'fork task [2] ' , task label ]
                            object: [ task ].
                          proc := [ 
                          [ 
                          self
                            gemServer: [ 
                              "handle exceptions (including breakpoints and Halt) that occur while processing individual task"
                              self
                                trace: [ 'start process task [3] ' , task label ]
                                object: [ task ].
                              [ task processTask: self ]
                                ensure: [ 
                                  self doSimpleTransaction: [ self inProcess remove: task ].
                                  self
                                    trace: [ 'end process task [4] ' , task label ]
                                    object: [ task ] ] ]
                            exceptionSet:
                              GemServerRemoteInternalServerErrorTriggerExample , self gemServerExceptionSet
                            onError: [ :ex | 
                              self
                                doSimpleTransaction: [ 
                                  task exception: ex.
                                  (ObjectLogEntry
                                    error:
                                      'Server example task exception: ' , ex description printString
                                    object: task) addToLog ] ] ]
                            ensure: [ 
                              activeProcessesMutex
                                critical: [ self activeProcesses value remove: Processor activeProcess ifAbsent: [  ] ] ] ]
                            fork.
                          activeProcessesMutex
                            critical: [ self activeProcesses add: proc ].
                          self
                            trace: [ 
                              'task [5] inProcess: ' , self inProcess size printString , ' activeProcesses: '
                                , self activeProcesses size printString ]
                            object: [ self status ].
                          Processor yield ] ].
                  self doSimpleTransaction: [ currentQueueCounter := qcv ] ] ] ] ]
        fork.
  self serverInstance: self	"the serverProcess is session-specific"