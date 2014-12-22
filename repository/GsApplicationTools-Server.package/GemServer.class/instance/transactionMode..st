accessing
transactionMode: aSymbol
  "#autoBegin or #manualBegin"

  self doSimpleTransaction: [ transactionMode := aSymbol ].
  System transactionMode == aSymbol
    ifFalse: [ System transactionMode: aSymbol ]