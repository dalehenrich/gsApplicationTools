server compat
restart
  self scriptLogEvent: '-->>Interactive restart ' , self name object: self.
  self
    stop;
    start