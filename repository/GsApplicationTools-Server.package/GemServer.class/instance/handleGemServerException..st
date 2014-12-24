exception handling
handleGemServerException: exception
  "if control is returned to receiver, then exception is treated like an error, i.e., 
   the errorBlock is evaluated and stack is unwound."

  ^ exception exceptionHandlingForGemServer: self