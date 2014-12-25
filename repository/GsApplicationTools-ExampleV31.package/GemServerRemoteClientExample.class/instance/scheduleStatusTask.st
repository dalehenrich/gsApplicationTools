tasks
scheduleStatusTask
  ^ (GemServerRemoteTaskExample value: [ :gemServer | gemServer status ])
    addToQueue: self