local server compat
stop
  self scriptLogEvent: '-->>Interactive stop ' , self name object: self.
  self basicServerProcess
    ifNotNil: [ :proc | 
      self basicServerProcess: nil.
      proc terminate ]