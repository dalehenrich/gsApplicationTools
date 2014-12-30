transactions-support
doTransaction: aBlock
  "Perform a transaction. If the transaction fails, signal an Error."

  self
    doTransaction: aBlock
    onConflict: [ :ignored | self error: 'commit conflicts' ]