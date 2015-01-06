tasks
scheduleOutOfMemoryPersistent
  ^ (self taskClass value: [ self outOfMemoryPersistentMethod ])
    expectedDelay: 4;
    addToQueue: self