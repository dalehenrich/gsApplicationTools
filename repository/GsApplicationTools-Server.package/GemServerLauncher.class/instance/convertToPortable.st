private
convertToPortable
  "convert activeProcess to portable"

  | sema activeProcess |
  sema := Semaphore new.
  activeProcess := ProcessorScheduler scheduler activeProcess.
  [ 
  activeProcess localStackDepth.
  activeProcess _convertToPortableStack.
  sema signal ]
    fork.
  sema wait