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
              (qcv := self queueCounterValue) > self currentQueueCounter
                ifTrue: [ 
                  "handle exceptions that occur while managing the queues"
                  [ self queue size > 0 ]
                    whileTrue: [ 
                      | tasks |
                      self
                        doSimpleTransaction: [ self inProcess addAll: (tasks := self queue removeAll) ].
                      tasks
                        do: [ :task | 
                          [ 
                          self
                            gemServer: [ 
                              "handle exceptions (including breakpoints and Halt) that occur while processing individual task"
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