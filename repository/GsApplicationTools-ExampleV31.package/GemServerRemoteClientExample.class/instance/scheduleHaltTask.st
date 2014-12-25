tasks
scheduleHaltTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      | delay |
      delay := TransientStackValue value: (Delay forSeconds: 2).
      delay value wait.
      self haltMethod ])
    addToQueue: self