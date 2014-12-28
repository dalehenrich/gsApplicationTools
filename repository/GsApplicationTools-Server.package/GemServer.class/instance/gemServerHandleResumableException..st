exception dispatching
gemServerHandleResumableException: exception
  "in interactive mode pass exception without logging.
   Otherwise, log the stack trace and then resume the exception."

  self interactiveMode
    ifTrue: [ exception pass ].
  self
    logStack: exception
    titled:
      self name , ' ' , exception class name asString , ' exception encountered: '.
  exception resume