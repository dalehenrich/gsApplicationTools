tasks
scheduleExampleHttpTask
  ^ (GemServerRemoteTaskExample
    value: [ 
      true
        ifTrue: [ (HTTPSocket httpGet: 'http://example.com') contents ] ])
    addToQueue: self