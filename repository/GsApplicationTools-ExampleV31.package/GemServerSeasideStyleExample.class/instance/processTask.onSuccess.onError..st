service instance-server
processTask: task onSuccess: successBlock onError: errorBlock
  "Both <successBlock> and errorBlock are expected to do a non-local return.
   If this method returns normally, the request should be retried. "

  | taskResult |
  taskResult := self
    gemServerTransaction: [ self processTask: task ]
    exceptionSet: Error
    beforeUnwind: errorBlock
    onConflict: [ :conflicts | 
      "log conflict and retry"
      self
        doTransaction: [ ObjectLogEntry error: 'Commit failure ' object: conflicts ].
      ^ self	"retry" ].
  successBlock value: taskResult