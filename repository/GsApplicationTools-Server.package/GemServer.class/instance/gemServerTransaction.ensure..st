gem server api
gemServerTransaction: aBlock ensure: ensureBlock
  ^ self
    gemServerTransaction: aBlock
    beforeUnwind: [ :ex | 
      "server error is already logged"
       ]
    ensure: ensureBlock