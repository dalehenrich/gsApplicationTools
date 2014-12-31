gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock ensure: ensureBlock
  ^ self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: beforeUnwindBlock
    ensure: ensureBlock
    onConflict: [ :conflicts | 
      self
        doTransaction: [ ObjectLogEntry error: 'Commit failure ' object: conflicts ] ]