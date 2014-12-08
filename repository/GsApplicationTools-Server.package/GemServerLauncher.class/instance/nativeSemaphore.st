accessing
nativeSemaphore
  nativeSemaphore ifNil: [ nativeSemaphore := Semaphore new ].
  ^ nativeSemaphore