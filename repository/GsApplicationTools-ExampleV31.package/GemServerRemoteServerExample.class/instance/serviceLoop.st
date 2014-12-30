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
        object: self ].
  qcv > self currentQueueCounter
    ifTrue: [ 
      "handle exceptions that occur while managing the queues"
      [ 
      self trace: [ 'queue size [1] ' , self queue size printString ] object: [  ].
      self queue size > 0 ]
        whileTrue: [ self processTasksOnQueue ].
      self doTransaction: [ currentQueueCounter := qcv ] ]