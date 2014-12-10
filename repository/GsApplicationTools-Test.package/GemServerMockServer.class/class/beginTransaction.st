transactions
beginTransaction
  "In GemServer, in manual transaction mode"

  Transcript
    cr;
    show: 'begin: ' , self eventLog size printString.
  System transactionMode == #'manualBegin'
    ifTrue: [ 
      Transcript
        cr;
        show: 'beginTransaction'.
      System beginTransaction ]