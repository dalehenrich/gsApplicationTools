tasks
scheduleStatusTask
  ^ (self taskClass value: [ :gemServer | gemServer status ])
    expectedDelay: 2;
    addToQueue: self