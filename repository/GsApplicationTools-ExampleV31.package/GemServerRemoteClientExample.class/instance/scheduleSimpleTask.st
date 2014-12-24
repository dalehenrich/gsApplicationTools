tasks
scheduleSimpleTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      (Delay forSeconds: 1) wait.
      DateAndTime now ])
    addToQueue: self