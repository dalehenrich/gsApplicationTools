gem server api
gemServer: aBlock ensure: ensureBlock
  ^ self
    gemServer: aBlock
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]
    ensure: ensureBlock