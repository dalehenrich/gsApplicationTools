tests
waitAndValidateResponse: gemServer
  | loopCount done |
  loopCount := 0.
  done := false.
  [ done ]
    whileFalse: [ 
      gemServer doAbortTransaction.
      gemServer crashLog isEmpty
        ifFalse: [ 
          Transcript
            cr;
            show: 'Gem server crashed: '.
          gemServer crashLog
            do: [ :assoc | 
              Transcript
                cr;
                tab;
                show: assoc value label ].
          self assert: false description: 'gem server crashed' ].
      gemServer requests
        detect: [ :request | request status == #'unprocessed' ]
        ifNone: [ done := true ].
      loopCount > gemServer expectedLoopCount
        ifTrue: [ 
          Transcript
            cr;
            show: 'server timed out'.
          self assert: false description: 'server timed out' ].
      loopCount := loopCount + 1.
      (Delay forSeconds: 1) wait ].
  gemServer requests
    detect: [ :request | request isValid not ]
    ifNone: [ ^ self ].
  self assert: false description: 'invalid responses'