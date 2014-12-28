*gsapplicationtools-serverv30
gemServerHandleAlmostOutOfMemoryException: exception
  "re-enable OOM, log the stack trace and unwind stack unless EVEN in interactive mode"

  AlmostOutOfMemory enable.
  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered: '