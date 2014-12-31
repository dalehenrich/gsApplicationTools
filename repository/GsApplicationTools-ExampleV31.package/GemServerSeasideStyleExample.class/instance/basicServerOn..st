service instance-server
basicServerOn: port
  "forked by called"

  | listeningSocket |
  self
    gemserver: [ 
      | requestSocket |
      listeningSocket := self acceptOn: port.
      [ true ]
        whileTrue: [ 
          requestSocket := self listenOn: listeningSocket.
          [ self handleRequestFrom: requestSocket ] fork ] ]
    exceptionSet: Error
    ensure: [ listeningSocket ifNotNil: [ listeningSocket close ] ]