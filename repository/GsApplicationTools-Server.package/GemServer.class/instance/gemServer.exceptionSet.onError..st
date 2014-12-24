gem server api
gemServer: aBlock exceptionSet: exceptionSet onError: errorBlock
  aBlock
    on: exceptionSet
    do: [ :ex | 
      | exception |
      [ 
      "only returns if an error was logged"
      exception := ex.
      self handleGemServerException: ex ]
        on: Error
        do: [ :unexpectedError | 
          "error while handling the exception"
          self
            serverError: unexpectedError
            titled:
              self name , ' Internal Server error during handleGemServerException:'.
          exception := unexpectedError ].
      errorBlock value: exception.
      self interactiveMode
        ifTrue: [ exception pass ].
      ^ self	"unwind stack" ]