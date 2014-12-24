tasks
scheduleErrorTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      (Delay forSeconds: 3) wait.
      1 foo ])
    expectedException: Error;
    addToQueue: self