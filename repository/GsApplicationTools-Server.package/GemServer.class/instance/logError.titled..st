exception handling
logError: exception titled: title
  "snap off a continuation and dump the stack to the gem log"

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