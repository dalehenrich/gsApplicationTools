transactions
gemServer: aBlock onError: errorBlock
  ^ aBlock
    on: self gemServerExceptionSet
    do: [ :ex | 
      self handleGemServerException: ex.	"only returns if an error was logged"
      errorBlock value: ex.
      self interactiveMode
        ifTrue: [ ex pass ] ]