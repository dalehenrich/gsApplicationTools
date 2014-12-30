gem server api
gemServerTransaction: aBlock beforeUnwind: beforeUnwindBlock onConflict: conflictBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: self gemServerExceptionSet
    beforeUnwind: beforeUnwindBlock
    onConflict: conflictBlock