service instance-server
handleRequestFrom: task
  "forked by caller"

  self
    gemServer: [ 
      | retryCount |
      retryCount := 0.
      [ retryCount < 11 ]
        whileTrue: [ 
          self
            processTask: task
            onSuccess: [ :response | ^ self writeResponse: response to: task ]
            onError: [ :ex | ^ self writeServerError: ex to: task ].
          retryCount := retryCount + 1 ] ]
    exceptionSet: Error
    beforeUnwind: [ :ex | ^ self writeServerError: ex to: task ]