gem server api
gemServer: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock ensure: ensureBlock
  [ 
  ^ aBlock
    on: exceptionSet
    do: [ :ex | 
      | exception |
      [ 
      exception := ex.
      self handleGemServerException: ex.
      beforeUnwindBlock value: exception ]
        on: Error
        do: [ :unexpectedError | 
          "error while handling the exception"
          self
            serverError: unexpectedError
            titled: self name , ' Internal Server error handling exception: '.
          beforeUnwindBlock value: unexpectedError.
          self doInteractiveModePass: unexpectedError.
          exception return: nil	"unwind stack" ].
      self doInteractiveModePass: exception.
      exception return: nil	"unwind stack" ] ]
    ensure: ensureBlock