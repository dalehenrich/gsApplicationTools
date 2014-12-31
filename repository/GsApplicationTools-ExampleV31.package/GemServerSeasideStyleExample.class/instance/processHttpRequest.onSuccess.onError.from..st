service instance-server
processHttpRequest: httpRequest onSuccess: successBlock onError: errorBlock from: requestSocket
  "Both <successBlock> and errorBlock are expected to do a non-local return.
   If this method returns normally, the request should be retried. "

  | httpResponse |
  httpResponse := self
    gemServerTransaction: [ self processHttpRequest: httpRequest ]
    exceptionSet: Error
    beforeUnwind: errorBlock
    onConflict: [ :conflicts | 
      "log conflict and retry"
      self
        doTransaction: [ ObjectLogEntry error: 'Commit failure ' object: conflicts ].
      ^ self	"retry" ].
  successBlock value: httpResponse