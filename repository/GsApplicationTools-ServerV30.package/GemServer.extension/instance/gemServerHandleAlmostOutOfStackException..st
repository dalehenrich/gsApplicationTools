*gsapplicationtools-serverv30
gemServerHandleAlmostOutOfStackException: exception
  "log the stack trace and unwind stack unless in interactive mode"

  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered: '.
  self interactiveMode
    ifTrue: [ exception pass ]