tasks
scheduleHaltTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      false
        ifTrue: [ (Delay forSeconds: 2) wait ].
      self haltMethod ])
    addToQueue: self