gem server api
gemServer: aBlock
  self
    gemServer: aBlock
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]