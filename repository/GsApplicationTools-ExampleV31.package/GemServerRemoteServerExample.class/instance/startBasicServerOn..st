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
              self
                trace: [ 'counters [0]' ]
                object: [ 
                  {qcv.
                  currentQueueCounter} ].
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
                          self trace: [ 'fork task [2]' ] object: [ task ].
                          [ 
                          self
                            gemServer: [ 
                              "handle exceptions (including breakpoints and Halt) that occur while processing individual task"
                              self
                                trace: [ 'process task [3]' ]
                                object: [ task ].
                              task processTask: self.
                              self
                                doSimpleTransaction: [ self inProcess remove: task ] ]
                            onError: [ :ex | 
                              self
                                doSimpleTransaction: [ 
                                  task exception: ex.
                                  (ObjectLogEntry
                                    error:
                                      'Server example task exception: ' , ex description printString
                                    object: task) addToLog ] ] ]
                            fork ] ].
                  self doSimpleTransaction: [ currentQueueCounter := qcv ] ] ]
            exceptionSet: Error , Halt ] ]
        fork.
  self serverInstance: self	"the serverProcess is session-specific"