accessing
portableSemaphore
  portableSemaphore ifNil: [ portableSemaphore := Semaphore new ].
  ^ portableSemaphore