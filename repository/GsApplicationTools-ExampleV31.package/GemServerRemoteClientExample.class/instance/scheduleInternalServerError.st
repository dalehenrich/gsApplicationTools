tasks
scheduleInternalServerError
  ^ (self taskClass
    value: [ GemServerRemoteInternalServerErrorTriggerExample signal ])
    expectedException: ImproperOperation;
    addToQueue: self