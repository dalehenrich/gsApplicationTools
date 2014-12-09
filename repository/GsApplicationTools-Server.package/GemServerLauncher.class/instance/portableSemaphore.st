accessing
portableSemaphore
  portableSemaphore ifNil: [ portableSemaphore := TransientSemaphore new ].
  ^ portableSemaphore