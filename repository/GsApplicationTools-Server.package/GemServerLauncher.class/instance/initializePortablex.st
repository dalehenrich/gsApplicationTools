initialization
initializePortablex
  "create a native launcher process"

  | proc |
  proc := [ 
  Transcript
    cr;
    show: 'initialize portable block [0]'.
  self convertToPortable.
  Transcript
    cr;
    show:
        'initialize portable block [1] using native? '
            , GsProcess usingNativeCode printString.
  [ 
  Transcript
    cr;
    show:
        'initialize portable block [2] (preforkblock) using native? '
            , GsProcess usingNativeCode printString.
  [ 
  Transcript
    cr;
    show:
        'initialize portable block [3] (preblock) using native? '
            , GsProcess usingNativeCode printString.
  self block value.
  Transcript
    cr;
    show:
        'initialize portable block [3.5] (postblock) using native? '
            , GsProcess usingNativeCode printString ]
    fork.
  Transcript
    cr;
    show:
        'initialize portable block [4] (postforkblock)using native? '
            , GsProcess usingNativeCode printString.
  self portableSemaphore wait.
  Transcript
    cr;
    show:
        'initialize portable block [4] (postportablewait)using native? '
            , GsProcess usingNativeCode printString ]
    repeat.
  Transcript
    cr;
    show: 'initialize portable block [5]' ]
    fork.
  Transcript
    cr;
    show:
        'initialize portable block [6] using native? ' , proc _nativeStack printString.
  Processor yield.
  self portableProcess: proc