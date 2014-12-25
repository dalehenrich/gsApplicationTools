tasks
scheduleErrorTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      false
        ifTrue: [ (Delay forSeconds: 3) wait ].
      1 foo ])
    expectedException: Error;
    addToQueue: self