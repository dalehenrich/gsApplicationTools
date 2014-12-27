tasks
scheduleSimpleTask
  ^ (self taskClass value: [ DateAndTime now ]) addToQueue: self