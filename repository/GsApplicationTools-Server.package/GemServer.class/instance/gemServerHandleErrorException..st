exception dispatching
gemServerHandleErrorException: exception
  "log the stack trace and unwind stack.
   interactiveMode is handled by caller of handleGemServerException: before stack is unwound."

  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered:'