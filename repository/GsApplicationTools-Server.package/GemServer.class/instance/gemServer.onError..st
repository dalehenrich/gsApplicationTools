gem server api
gemServer: aBlock onError: errorBlock
  self
    gemServer: aBlock
    exceptionSet: self gemServerExceptionSet
    onError: errorBlock