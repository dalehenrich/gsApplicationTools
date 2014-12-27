service instance-server
serviceLoop
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
              self trace: [ 'fork task [2] ' , task label ] object: [ task ].
              proc := TransientStackValue
                value: (self taskServiceThreadBlock: task) fork.
              activeProcessesMutex
                critical: [ self activeProcesses add: proc value ].
              self
                trace: [ 
                  'task [5] inProcess: ' , self inProcess size printString , ' activeProcesses: '
                    , self activeProcesses size printString ]
                object: [ self status ].
              Processor yield ] ].
      self doSimpleTransaction: [ currentQueueCounter := qcv ] ]