transactions
handleGemServerException: exception
  "only returns if an error was logged"

  ((exception isKindOf: Error) or: [ exception isResumable not ])
    ifTrue: [ self serverError: exception titled: self name , ' error/non-resumable exception' ]
    ifFalse: [ 
      self interactiveMode
        ifTrue: [ exception pass ].
      self serverError: exception titled: self name , ' resumable exception'.
      exception resume ]