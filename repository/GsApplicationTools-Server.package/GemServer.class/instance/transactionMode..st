accessing
transactionMode: aSymbol
  "#autoBegin or #manualBegin"

  self doTransaction: [ transactionMode := aSymbol ].
  System transactionMode == aSymbol
    ifFalse: [ System transactionMode: aSymbol ]