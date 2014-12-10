initialization
initializePortable
  "create a native launcher process"

  | proc |
  proc := [ 
  self convertToPortable.
  [ 
  self portableSemaphore wait.
  [ self block value ] fork ] repeat ]
    fork.
  Processor yield.
  self portableProcess: proc