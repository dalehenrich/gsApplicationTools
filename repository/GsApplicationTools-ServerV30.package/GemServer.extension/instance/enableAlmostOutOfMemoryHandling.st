*gsapplicationtools-serverv30
enableAlmostOutOfMemoryHandling
  self
    scriptLogEvent: 'enable AlmostOutOfMemoryHandling: ' , self name
    object: self almostOutOfMemoryThreshold.
  System signalAlmostOutOfMemoryThreshold: self almostOutOfMemoryThreshold