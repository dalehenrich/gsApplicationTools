tasks
scheduleSimpleTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      false
        ifTrue: [ (Delay forSeconds: 1) wait ].
      DateAndTime now ])
    addToQueue: self