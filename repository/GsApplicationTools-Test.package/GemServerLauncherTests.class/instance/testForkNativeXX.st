tests
testForkNativeXX
  "basic functionality test that runs in 2.4.x (no native) and 3.x (native)"

  | launchBlock processRan sem |
  true
    ifTrue: [ ^ self ].
  sem := Semaphore new.
  processRan := false.
  launchBlock := [ 
  processRan := true.
  sem signal ] fork.
  sem wait.
  self assert: processRan