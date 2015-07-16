*gsapplicationtools-serverv30
convertToPortable
  "convert activeProcess to portable"

  | sema activeProcess |
  sema := TransientSemaphore new.
  activeProcess := ProcessorScheduler scheduler activeProcess.
  [ 
  activeProcess localStackDepth.
  activeProcess convertToPortableStack.
  sema signal ]
    fork.
  sema wait