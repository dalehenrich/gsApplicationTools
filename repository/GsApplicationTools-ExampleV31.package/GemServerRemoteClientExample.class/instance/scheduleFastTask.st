tasks
scheduleFastTask
  ^ (GemServerRemoteTaskExample value: [ DateAndTime now ]) addToQueue: self