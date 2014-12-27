tasks
scheduleFastTask
  ^ (self taskClass value: [ DateAndTime now ]) addToQueue: self