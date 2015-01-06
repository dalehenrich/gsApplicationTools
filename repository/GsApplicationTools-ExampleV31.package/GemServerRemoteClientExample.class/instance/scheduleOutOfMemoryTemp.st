tasks
scheduleOutOfMemoryTemp
  ^ (self taskClass value: [ self outOfMemoryTempMethod ])
    expectedException: AlmostOutOfMemory;
    expectedDelay: 4;
    addToQueue: self