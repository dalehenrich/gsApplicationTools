tasks
scheduleOutOfMemoryPersistent
  ^ (GemServerRemoteTaskExample value: [ self outOfMemoryPersistentMethod ])
    addToQueue: self