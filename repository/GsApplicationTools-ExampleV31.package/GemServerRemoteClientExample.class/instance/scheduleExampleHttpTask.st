tasks
scheduleExampleHttpTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      false
        ifTrue: [ (HTTPSocket httpGet: 'http://example.com') contents ] ])
    addToQueue: self