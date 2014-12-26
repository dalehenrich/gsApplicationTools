tasks
scheduleOutOfMemoryPersistent
  ^ (GemServerRemoteTaskExample value: [ self outOfMemoryPersistentMethod ])
    expectedDelay: 4;
    addToQueue: self