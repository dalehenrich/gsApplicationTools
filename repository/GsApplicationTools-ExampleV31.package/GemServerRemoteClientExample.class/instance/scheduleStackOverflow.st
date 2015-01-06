tasks
scheduleStackOverflow
  ^ (self taskClass
    value: [ 
      Transcript
        cr;
        show: 'scheduleStackOverflow'.
      self stackOverflowMethod ])
    expectedException: AlmostOutOfStack;
    addToQueue: self