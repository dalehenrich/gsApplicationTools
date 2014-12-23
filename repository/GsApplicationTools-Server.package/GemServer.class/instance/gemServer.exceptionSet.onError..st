gem server api
gemServer: aBlock exceptionSet: exceptionSet onError: errorBlock
  aBlock
    on: exceptionSet
    do: [ :ex | 
      self handleGemServerException: ex.	"only returns if an error was logged"
      errorBlock value: ex.
      self interactiveMode
        ifTrue: [ ex pass ] ]