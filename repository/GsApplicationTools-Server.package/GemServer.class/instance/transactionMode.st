accessing
transactionMode
  transactionMode ifNil: [ transactionMode := #'autoBegin' ].
  ^ transactionMode