server compat
stop
  self serverProcess
    ifNotNil: [ :proc | 
      self serverProcess: nil.
      proc terminate ]