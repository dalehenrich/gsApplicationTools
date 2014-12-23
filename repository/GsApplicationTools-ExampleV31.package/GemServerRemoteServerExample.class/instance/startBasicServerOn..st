service instance-server
startBasicServerOn: ignored
  "start server in current vm. expected to return."

  self
    serverProcess:
      [ 
      [ true ]
        whileTrue: [ 
          | qcv |
          self queueCounterValue <= self currentQueueCounter
            ifTrue: [ (Delay forMilliseconds: 100) wait ].
          (qcv := self queueCounterValue) > self currentQueueCounter
            ifTrue: [ 
              self
                gemServerTransaction: [ 
                  self
                    halt:
                      'this guy acquires transaction mutex ... might not be cool when forking off servers ... see Issue #12'.
                  [ self queue size > 0 ]
                    whileTrue: [ 
                      self doSimpleTransaction: [ self inProcess addAll: self queue removeAll ].
                      [ self inProcess size > 0 ]
                        whileTrue: [ 
                          self inProcess anyOne
                            ifNotNil: [ :task | 
                              task processTask: self.
                              self
                                doSimpleTransaction: [ self inProcess remove: task ] ] ] ].
                  self doSimpleTransaction: [ currentQueueCounter := qcv ] ]
                onError: [ :ex |  ] ] ] ]
        fork.
  self serverInstance: self	"the serverProcess is session-specific"