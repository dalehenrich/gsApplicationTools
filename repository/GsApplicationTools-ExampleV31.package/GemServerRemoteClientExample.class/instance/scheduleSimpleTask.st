tasks
scheduleSimpleTask
  ^ (GemServerRemoteTaskExample value: [ DateAndTime now ]) addToQueue: self