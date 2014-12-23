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
            doSimpleTransaction: [ 
              self
                logEvent:
                  'LOOPCOUNT: ' , loopCount printString , ' : ' , actionCount printString
                object: self copy ] ]
            on: Error
            do: [ :ex | 
              self serverError: ex titled: 'top-level service loop'.
              self
                doSimpleTransaction: [ 
                  (forceBeginTransaction or: [ forceInternalServerError ])
                    ifTrue: [ 
                      "acknowledge event handled"
                      actionCount := actionCount + 1 ].
                  forceBeginTransaction := forceInternalServerError := false.
                  self
                    logEvent:
                      'LOOPCOUNT (internal error): ' , loopCount printString , ' : '
                        , actionCount printString
                    object: self copy ] ] ]
            on: self gemServerExceptionSet
            do: [ :ex | 
              "Handler for interactive Errors ... record for testing purposes"
              self
                doSimpleTransaction: [ 
                  (forceBeginTransaction or: [ forceInternalServerError ])
                    ifTrue: [ 
                      "acknowledge event handled"
                      actionCount := actionCount + 1 ].
                  forceBeginTransaction := forceInternalServerError := false.
                  actionResult := #'interactiveError'.
                  actionException := ex.
                  self logAction: #'startBasicServerOn:...interativeError'.
                  self
                    logEvent:
                      'LOOPCOUNT (interactive exception): ' , loopCount printString , ' : '
                        , actionCount printString
                    object: self copy ] ] ] ]
        fork.
  self serverInstance: self	"the serverProcess is session-specific"