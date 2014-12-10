transactions
commit
  "In GemServer, in manual transaction mode"

  Transcript
    cr;
    show: 'commit: ' , self eventLog size printString.
  Transcript
    cr;
    show: 'commitTransaction: ' , System transactionMode printString.
  System commitTransaction
    ifFalse: [ self error: 'failed to commit for ' , self name asString , ' reset' ].
  self beginTransaction