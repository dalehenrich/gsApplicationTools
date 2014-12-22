service instance-server
startBasicServerOn: ignored
  "start server in current vm. expected to return."

  self
    serverProcess:
      [ 
      | loopCount |
      loopCount := 0.
      [ true ]
        whileTrue: [ 
          [ 
          loopCount := loopCount + 1.
          self forceBeginTransaction
            ifTrue: [ 
              "Enter transaction before calling GemServer>>gemServerTransaction:onError:, which is illegal."
              self doBeginTransaction.
              forceBeginTransaction := false ].
          self forceInternalServerError
            ifTrue: [ self error: 'internal server error' ].
          self
            gemServerTransaction: [ self handleAction ]
            onError: [ :ex | self handleActionError: ex ].
          (Delay forMilliseconds: 500) wait.
          self
            doSimpleTransaction: [ self logEvent: 'LOOPCOUNT: ' , loopCount printString object: self ] ]
            on: Error
            do: [ :ex | 
              self internalServerError: ex titled: 'top-level service loop'.
              self
                doSimpleTransaction: [ 
                  self logEvent: 'LOOPCOUNT: ' , loopCount printString object: self.
                  forceBeginTransaction := forceInternalServerError := false.
                  actionCount := actionCount + 1	"acknowledge event handled" ] ] ] ]
        fork.
  self serverInstance: self	"the serverProcess is session-specific"