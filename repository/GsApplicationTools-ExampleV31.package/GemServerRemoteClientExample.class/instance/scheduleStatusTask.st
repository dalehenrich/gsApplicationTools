tasks
scheduleStatusTask
  ^ (self taskClass value: [ :gemServer | gemServer status ]) addToQueue: self