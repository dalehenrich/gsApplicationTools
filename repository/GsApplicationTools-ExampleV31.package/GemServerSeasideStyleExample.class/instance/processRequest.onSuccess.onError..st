service instance-server
processRequest: request onSuccess: successBlock onError: errorBlock
  "Both <successBlock> and errorBlock are expected to do a non-local return.
   If this method returns normally, the request should be retried. "

  | requestResult |
  requestResult := self
    gemServerTransaction: [ self processRequest: request ]
    exceptionSet: Error
    beforeUnwind: errorBlock
    onConflict: [ :conflicts | 
      "log conflict and retry"
      self
        doTransaction: [ ObjectLogEntry error: 'Commit failure ' object: conflicts ].
      ^ self	"retry" ].
  successBlock value: requestResult