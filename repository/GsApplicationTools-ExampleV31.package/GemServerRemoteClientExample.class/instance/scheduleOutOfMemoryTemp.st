tasks
scheduleOutOfMemoryTemp
  ^ (GemServerRemoteTaskExample value: [ self outOfMemoryTempMethod ])
    expectedException: AlmostOutOfMemory;
    expectedDelay: 4;
    addToQueue: self