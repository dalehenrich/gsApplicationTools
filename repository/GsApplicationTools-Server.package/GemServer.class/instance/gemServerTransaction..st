transactions
gemServerTransaction: aBlock
  ^ self
    gemServerTransaction: aBlock
    onError: [ :ex | 
      self
        doSimpleTransaction: [ self logError: ex titled: 'application error - non resumable' ].
      ^ #'error' ]