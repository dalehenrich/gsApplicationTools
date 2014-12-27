tasks
scheduleStackOverflow
  ^ (self taskClass value: [ self stackOverflowMethod ])
    expectedException: AlmostOutOfStack;
    addToQueue: self