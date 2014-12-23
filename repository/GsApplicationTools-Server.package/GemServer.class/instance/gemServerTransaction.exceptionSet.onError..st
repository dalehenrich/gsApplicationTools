gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet onError: errorBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    onError: errorBlock
    onConflict: [ :conflicts | 
      self doAbortTransaction.
      self
        doSimpleTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ] ]