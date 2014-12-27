tasks
scheduleExampleHttpTask
  ^ (self taskClass
    value: [ (HTTPSocket httpGet: 'http://example.com') contents ])
    expectedDelay: 30;
    addToQueue: self