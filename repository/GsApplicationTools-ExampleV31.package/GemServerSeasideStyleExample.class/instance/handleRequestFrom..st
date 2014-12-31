service instance-server
handleRequestFrom: requestSocket
  "forked by caller"

  self
    gemServer: [ 
      | httpRequest retryCount |
      httpRequest := self readRequestFrom: requestSocket.
      retryCount := 0.
      [ retryCount < 11 ]
        whileTrue: [ 
          self
            processHttpRequest: httpRequest
            onSuccess: [ :httpResponse | ^ self writeResponse: httpResponse to: requestSocket ]
            onError: [ :ex | ^ self writeServerError: ex to: requestSocket ]
            from: requestSocket.
          retryCount := retryCount + 1 ] ]
    exceptionSet: Error
    beforeUnwind: [ :ex | ^ self writeServerError: ex to: requestSocket ]
    ensure: [ requestSocket close ]