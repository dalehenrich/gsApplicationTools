tasks
scheduleErrorTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      (Delay forSeconds: 3) wait.
      1 foo ])
    shouldError: true;
    addToQueue: self