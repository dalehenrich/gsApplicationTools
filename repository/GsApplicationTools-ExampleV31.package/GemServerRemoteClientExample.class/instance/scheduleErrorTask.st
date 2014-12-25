tasks
scheduleErrorTask
  ^ (GemServerRemoteTaskExample value: [ 1 foo ])
    expectedException: Error;
    addToQueue: self