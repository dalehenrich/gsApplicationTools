exception handling
createContinuation: label
  "disable continuation creation until I find the reference to delay from continuation .... an abort is causing the process to forget the waiters ... bug will be finxed in 23.2.4?"

  false
    ifTrue: [ self class createContinuation: label ]