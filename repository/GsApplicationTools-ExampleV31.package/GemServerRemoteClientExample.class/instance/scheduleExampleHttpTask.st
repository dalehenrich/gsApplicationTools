tasks
scheduleExampleHttpTask
  ^ (GemServerRemoteTaskExample
    value: [ (HTTPSocket httpGet: 'http://example.com') contents ])
    addToQueue: self