tasks
scheduleStackOverflow
  ^ (GemServerRemoteTaskExample value: [ self stackOverflowMethod ])
    expectedException: AlmostOutOfStack;
    addToQueue: self