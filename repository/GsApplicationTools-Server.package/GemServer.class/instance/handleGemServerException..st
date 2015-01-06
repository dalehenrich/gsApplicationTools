exception handling
handleGemServerException: exception
  "if control is returned to receiver, then exception is treated like an error, i.e., 
   the beforeUnwindBlock is invoked and stack is unwound."

  ^ exception exceptionHandlingForGemServer: self