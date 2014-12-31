service instance-server
processHttpRequest: httpRequest beforeUnwind: beforeUnwindBlock from: requestSocket
  "need to commit BEFORE either response is sent"

  | httpResponse |
  httpResponse := self
    gemServerTransaction: [ httpResponse := self processHttpRequest: httpRequest ]
    exceptionSet: Error
    beforeUnwind: beforeUnwindBlock
    onConflict: [ :conflicts | 
      "log conflict and retry"
      self
        doTransaction: [ ObjectLogEntry error: 'Commit failure ' object: conflicts ].
      ^ #'retry' ].
  self
    gemServer: [ ^ self writeResponse: httpResponse to: requestSocket ]
    exceptionSet: Error
    beforeUnwind: beforeUnwindBlock