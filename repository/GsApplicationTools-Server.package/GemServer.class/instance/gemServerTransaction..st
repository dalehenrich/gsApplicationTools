gem server api
gemServerTransaction: aBlock
  self
    gemServerTransaction: aBlock
    onError: [ :ex | 
      "server error is already logged"
       ]