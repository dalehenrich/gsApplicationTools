accessing
nativeSemaphore
  nativeSemaphore ifNil: [ nativeSemaphore := TransientSemaphore new ].
  ^ nativeSemaphore