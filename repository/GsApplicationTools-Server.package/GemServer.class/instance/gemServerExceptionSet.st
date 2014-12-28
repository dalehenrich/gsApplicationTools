accessing
gemServerExceptionSet
  gemServerExceptionSet
    ifNil: [ 
      self interactiveMode
        ifTrue: [ ^ Error , self class gemServerExceptionSet ].
      ^ Error , self class gemServerExceptionSet
        , self class gemServerDebuggingExceptionSet ].
  ^ gemServerExceptionSet