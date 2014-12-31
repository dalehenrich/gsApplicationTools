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
          "somehow need to be able to exit if there was success"
          (self
            processHttpRequest: httpRequest
            beforeUnwind: [ :ex | ^ self writeServerError: ex to: requestSocket ]
            from: requestSocket) ~~ #'retry'
            ifTrue: [ ^ self ].
          retryCount := retryCount + 1 ] ]
    exceptionSet: Error
    beforeUnwind: [ :ex | ^ self writeServerError: ex to: requestSocket ]
    ensure: [ requestSocket close ]