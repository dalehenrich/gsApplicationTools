error handling
logError: exception titled: title
  "caller is responsible for transaction"

  | stream stack exDescription |
  stack := GsProcess stackReportToLevel: 300.
  exDescription := exception description.
  self createContinuation: exDescription.
  stream := WriteStream on: String new.
  stream
    nextPutAll:
      '----------- ' , title , ' ERROR Encountered: ' , DateAndTime now printString.
  stream lf.
  stream nextPutAll: exDescription.
  stream lf.
  stream nextPutAll: stack.
  stream nextPutAll: '-----------'.
  stream lf.
  GsFile gciLogServer: stream contents