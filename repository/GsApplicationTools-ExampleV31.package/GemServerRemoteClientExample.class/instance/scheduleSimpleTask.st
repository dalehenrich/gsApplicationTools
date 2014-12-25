tasks
scheduleSimpleTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      | delay |
      delay := TransientStackValue value: (Delay forSeconds: 1).
      delay value wait.
      DateAndTime now ])
    addToQueue: self