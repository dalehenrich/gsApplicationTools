exception handling
gemServerExceptionSet
  self interactiveMode
    ifTrue: [ ^ Error , self class gemServerExceptionSet ].
  ^ Error , self class gemServerDebuggingExceptionSet