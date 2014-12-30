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
          self
            gemServer: [ 
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
                doTransaction: [ 
                  self
                    logEvent:
                      'LOOPCOUNT: ' , loopCount printString , ' : ' , actionCount printString
                    object: self copy ] ]
            exceptionSet: Error
            onError: [ :ex | 
              self
                serverError: ex
                titled: 'top-level service loop'
                inTransactionDo: [ 
                  (forceBeginTransaction or: [ forceInternalServerError ])
                    ifTrue: [ 
                      "acknowledge event handled"
                      actionCount := actionCount + 1 ].
                  forceBeginTransaction := forceInternalServerError := false.
                  self
                    logEvent:
                      'LOOPCOUNT (internal error): ' , loopCount printString , ' : '
                        , actionCount printString
                    object: self copy ].
              System inTransaction
                ifTrue: [ 
                  "ensure that error logging info is committed ... when forceBeginTransaction was in effect"
                  self doCommitTransaction ] ] ]
            on: self gemServerExceptionSet
            do: [ :ex | 
              "Handler for interactive Errors ... record for testing purposes"
              self
                doTransaction: [ 
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