tasks
scheduleWarning
  ^ (self taskClass value: [ Warning signal: 'this is a warning' ])
    addToQueue: self