service instance-server
handleRequestFrom: request
  "forked by caller"

  self
    gemServer: [ 
      | retryCount |
      retryCount := 0.
      [ retryCount < 11 ]
        whileTrue: [ 
          self
            processRequest: request
            onSuccess: [ :response | ^ self writeResponse: response to: request ]
            onError: [ :ex | ^ self writeApplicationError: ex to: request ].
          retryCount := retryCount + 1 ] ]
    exceptionSet: Error
    beforeUnwind: [ :ex | ^ self writeServerError: ex to: request ]