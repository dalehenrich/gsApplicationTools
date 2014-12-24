tasks
scheduleWarning
  ^ (GemServerRemoteTaskExample value: [ Warning signal: 'this is a warning' ])
    addToQueue: self