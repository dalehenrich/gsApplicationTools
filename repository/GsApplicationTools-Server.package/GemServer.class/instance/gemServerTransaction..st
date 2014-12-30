gem server api
gemServerTransaction: aBlock
  self
    gemServerTransaction: aBlock
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]