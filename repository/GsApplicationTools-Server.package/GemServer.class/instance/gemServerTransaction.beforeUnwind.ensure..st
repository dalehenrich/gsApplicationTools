gem server api
gemServerTransaction: aBlock beforeUnwind: beforeUnwindBlock ensure: ensureBlock
  ^ self
    gemServerTransaction: aBlock
    exceptionSet: self gemServerExceptionSet
    beforeUnwind: beforeUnwindBlock
    ensure: ensureBlock