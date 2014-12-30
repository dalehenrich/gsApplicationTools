gem server api
gemServerTransaction: aBlock exceptionSet: exceptionSet beforeUnwind: beforeUnwindBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: exceptionSet
    beforeUnwind: beforeUnwindBlock
    onConflict: [ :conflicts | self doTransaction: [ ObjectLogEntry warn: 'Commit failure ' object: conflicts ] ]