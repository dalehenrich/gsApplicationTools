tasks
scheduleErrorTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      | delay |
      delay := TransientStackValue value: (Delay forSeconds: 3).
      delay value wait.
      1 foo ])
    expectedException: Error;
    addToQueue: self