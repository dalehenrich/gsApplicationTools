tasks
scheduleHaltTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      (Delay forSeconds: 2) wait.
      self haltMethod ])
    addToQueue: self