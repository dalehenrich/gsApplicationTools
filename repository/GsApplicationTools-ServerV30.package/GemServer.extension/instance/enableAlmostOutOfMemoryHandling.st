*gsapplicationtools-serverv30
enableAlmostOutOfMemoryHandling
  self
    scriptLogEvent: 'startAlmostOutOfMemoryHandling: ' , self name
    object: self almostOutOfMemoryThreshold.
  System signalAlmostOutOfMemoryThreshold: self almostOutOfMemoryThreshold