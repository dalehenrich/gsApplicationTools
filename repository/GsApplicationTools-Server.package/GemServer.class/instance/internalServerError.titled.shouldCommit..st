error handling
internalServerError: exception titled: title shouldCommit: shouldCommit
  "snap off a continuation (if possible) and dump the stack to the gem log"

  | stream stack exDescription |
  stack := GsProcess stackReportToLevel: 300.
  exDescription := exception description.
  shouldCommit
    ifTrue: [ self doSimpleTransaction: [ self createContinuation: exDescription ] ]
    ifFalse: [ self createContinuation: exDescription ].
  stream := WriteStream on: String new.
  stream
    nextPutAll:
      '----------- ' , title , ' Internal Server ERROR Encountered: '
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