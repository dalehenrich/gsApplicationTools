error handling
logError: exception titled: title
  "caller is responsible for transaction"

  | stream stack description |
  stack := GsProcess stackReportToLevel: 300.
  description := exception description.
  self createContinuation: description.
  stream := WriteStream on: String new.
  stream
    nextPutAll:
      '----------- ' , title , ' ERROR Encountered: ' , DateAndTime now printString.
  stream lf.
  stream nextPutAll: description.
  stream lf.
  stream nextPutAll: stack.
  stream nextPutAll: '-----------'.
  stream lf.
  GsFile gciLogServer: stream contents