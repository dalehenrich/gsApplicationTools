*gsapplicationtools-serverv30
enableAlmostOutOfMemoryHandling
  self
    scriptLogEvent: 'startAlmostOutOfMemoryHandling: ' , self name
    object: self almostOutOfMemoryThreshold.
  AlmostOutOfMemory enableAtThreshold: self almostOutOfMemoryThreshold