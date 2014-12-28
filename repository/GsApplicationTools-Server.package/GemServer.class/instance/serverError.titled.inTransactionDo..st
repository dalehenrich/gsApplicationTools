exception handling
serverError: exception titled: title inTransactionDo: inTransactionBlock
  self
    logStack: exception
    titled: title , ' Server error encountered: '
    inTransactionDo: inTransactionBlock.
  self interactiveMode
    ifTrue: [ exception pass ]