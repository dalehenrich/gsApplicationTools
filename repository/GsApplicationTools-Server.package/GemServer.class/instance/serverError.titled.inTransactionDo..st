error handling
serverError: exception titled: title inTransactionDo: inTransactionBlock
  | stream stack exDescription |
  stack := GsProcess stackReportToLevel: 300.
  exDescription := exception description.
  System inTransaction
    ifTrue: [ 
      self createContinuation: exDescription.
      inTransactionBlock value ]
    ifFalse: [ 
      self
        doSimpleTransaction: [ 
          self createContinuation: exDescription.
          inTransactionBlock value ] ].
  stream := WriteStream on: String new.
  stream
    nextPutAll:
      '----------- ' , title , ' Server ERROR Encountered: '
        , DateAndTime now printString.
  stream lf.
  stream nextPutAll: exDescription.
  stream lf.
  stream nextPutAll: stack.
  stream nextPutAll: '-----------'.
  stream lf.
  GsFile gciLogServer: stream contents.
  self interactiveMode
    ifTrue: [ exception pass ]