exception dispatching
gemServerHandleResumableException: exception
  self interactiveMode
    ifTrue: [ exception pass ].
  self
    serverError: exception
    titled: self name , ' ' , exception class name asString , ' exception'.
  exception resume