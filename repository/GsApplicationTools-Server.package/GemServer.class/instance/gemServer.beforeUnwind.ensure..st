gem server api
gemServer: aBlock beforeUnwind: beforeUnwindBlock ensure: ensureBlock
  ^ self
    gemServer: aBlock
    exceptionSet: self gemServerExceptionSet
    beforeUnwind: beforeUnwindBlock
    ensure: ensureBlock