tasks
scheduleHaltTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      (Delay forSeconds: 3) wait.
      self haltMethod ])
    addToQueue: self