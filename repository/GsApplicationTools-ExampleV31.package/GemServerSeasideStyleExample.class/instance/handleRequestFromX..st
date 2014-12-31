service instance-server
handleRequestFromX: requestSocket
  "forked by caller"

  [ 
  (self
    gemServer: [ self readRequestFrom: requestSocket ]
    exceptionSet: Error
    beforeUnwind: [ :ex | 
      self writeServerErrorTo: requestSocket.
      nil ])
    ifNotNil: [ :httpRequest | 
      (self
        gemServerTransaction: [ self processHttpRequest: httpRequest ]
        beforeUnwind: [ :ex | 
          self writeServerErrorTo: requestSocket.
          nil ]
        onConflict: [ :conflictDictionary |  ])
        ifNotNil: [ :httpResponse | 
          self
            gemServer: [ self writeResponse: httpResponse to: requestSocket ]
            exceptionSet: Error ] ] ]
    ensure: [ requestSocket close ]