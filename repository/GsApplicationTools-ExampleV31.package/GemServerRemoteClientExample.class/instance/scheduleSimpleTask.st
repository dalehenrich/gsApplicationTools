tasks
scheduleSimpleTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      (Delay forSeconds: 3) wait.
      DateAndTime now ])
    addToQueue: self