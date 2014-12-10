tests
testForkPortable
  "basic functionality test that runs in 2.4.x (no native) and 3.x (native)"

  | launchBlock processRan sem |
  sem := Semaphore new.
  processRan := {false}.
  launchBlock := [ 
  processRan at: 1 put: true.
  sem signal ].
  GemServerLauncher forkPortable: launchBlock.
  sem wait.
  self assert: (processRan at: 1)