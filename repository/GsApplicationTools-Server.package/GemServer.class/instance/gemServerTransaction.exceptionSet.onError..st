gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet onError: errorBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    onError: errorBlock
    onConflict: [ :conflicts | self doTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ] ]