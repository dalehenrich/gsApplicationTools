gem server api
gemServerTransaction: aBlock onError: errorBlock
  self
    gemServerTransaction: aBlock
    exceptionSet: self gemServerExceptionSet
    onError: errorBlock