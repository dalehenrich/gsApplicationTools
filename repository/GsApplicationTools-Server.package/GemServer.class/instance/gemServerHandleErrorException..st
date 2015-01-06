exception dispatching
gemServerHandleErrorException: exception
  "log the stack trace and unwind stack. Exception is passed (in interactiveMode) AFTER
   errorBlock has had a chance to run."

  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered: '