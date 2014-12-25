tasks
scheduleHaltTask
  ^ (GemServerRemoteTaskExample value: [ self haltMethod ]) addToQueue: self