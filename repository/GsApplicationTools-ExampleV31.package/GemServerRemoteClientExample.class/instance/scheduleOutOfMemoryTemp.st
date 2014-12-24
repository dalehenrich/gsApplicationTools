tasks
scheduleOutOfMemoryTemp
  ^ (GemServerRemoteTaskExample value: [ self outOfMemoryTempMethod ])
    expectedException: AlmostOutOfMemory;
    addToQueue: self