*gsapplicationtools-serverv30
gemServerHandleAlmostOutOfStackException: exception
  "log the stack trace and unwind stack unless in interactive mode"

  self doInteractiveModePass: exception.
  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered:'