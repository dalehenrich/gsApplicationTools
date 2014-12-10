initialization
initializeNative
  "create a native launcher process"

  | proc |
  proc := [ 
  [ 
  self nativeSemaphore wait.
  [ self block value ] fork ] repeat ] fork.
  Processor yield.
  self nativeProcess: proc