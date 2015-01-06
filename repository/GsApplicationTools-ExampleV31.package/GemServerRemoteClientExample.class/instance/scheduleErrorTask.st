tasks
scheduleErrorTask
  ^ (self taskClass value: [ 1 foo ])
    expectedException: Error;
    addToQueue: self