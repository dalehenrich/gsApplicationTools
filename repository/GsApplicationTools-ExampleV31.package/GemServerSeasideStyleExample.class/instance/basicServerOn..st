service instance-server
basicServerOn: ignored
  "forked by called"

  self
    gemServer: [ 
      | requests |
      requests := self requests.
      [ requests notEmpty ]
        whileTrue: [ 
          | request |
          request := requests first.
          requests remove: request.
          [ self handleRequestFrom: request ] fork ] ]