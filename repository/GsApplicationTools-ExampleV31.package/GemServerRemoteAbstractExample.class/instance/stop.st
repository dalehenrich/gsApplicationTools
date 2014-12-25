server compat
stop
  self scriptLogEvent: '-->>Interactive stop ' , self name object: self.
  self serverProcess
    ifNotNil: [ :proc | 
      self serverProcess: nil.
      proc terminate ]