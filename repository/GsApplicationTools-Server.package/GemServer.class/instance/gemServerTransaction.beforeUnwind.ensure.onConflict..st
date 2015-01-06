gem server api
gemServerTransaction: aBlock beforeUnwind: beforeUnwindBlock ensure: ensureBlock onConflict: conflictBlock
  ^ self
    gemServerTransaction: aBlock
    exceptionSet: self gemServerExceptionSet
    beforeUnwind: beforeUnwindBlock
    ensure: ensureBlock
    onConflict: conflictBlock