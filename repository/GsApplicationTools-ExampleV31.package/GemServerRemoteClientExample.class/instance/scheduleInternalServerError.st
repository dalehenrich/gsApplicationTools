tasks
scheduleInternalServerError
  ^ (GemServerRemoteTaskExample
    value: [ GemServerRemoteInternalServerErrorTriggerExample signal ])
    expectedException: ImproperOperation;
    addToQueue: self