exception dispatching
gemServerHandleErrorException: exception
  "unwind stack"

  self
    serverError: exception
    titled: self name , ' ' , exception class name asString , ' exception'