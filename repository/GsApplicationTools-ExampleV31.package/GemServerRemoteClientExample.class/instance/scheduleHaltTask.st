tasks
scheduleHaltTask
  ^ (self taskClass value: [ self haltMethod ]) addToQueue: self