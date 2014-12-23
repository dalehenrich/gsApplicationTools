gem server api
gemServer: aBlock
  self
    gemServer: aBlock
    onError: [ :ex | 
      "server error is already logged"
       ]