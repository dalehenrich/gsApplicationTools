initialization
initialize
  super initialize.
  currentQueueCounter := 0.
  tracing := false.
  activeProcesses := TransientValue value: nil.
  activeProcessesMutex := TransientSemaphore forMutualExclusion